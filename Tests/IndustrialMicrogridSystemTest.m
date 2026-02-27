classdef IndustrialMicrogridSystemTest < matlab.unittest.TestCase
    % Copyright 2023 The MathWorks, Inc.
    
    % System level test for IndustrialMicrogrid.slx 
    % Test strategy: Test point 1 : testBlackStart This test point checks
    % the black start in microgrid2. Reference voltages with different
    % levels are given as input and the output voltage is compared with the
    % reference voltage.
    % Test point 2: testPlannedIsland This test point checks the planned
    % islanding in microgrid2. Power thresholds for planned islanding are
    % set to higher values for a quick islanding operation and load power
    % is compared to check whether the active power and reactive power are the same
    % before and after islanding for a smooth planned islanding.
    % Test point 3: testResync This test point checks the resynchronization
    % in microgrid1. Voltage, frequency, and angle thresholds are set to
    % higher values for a quick resynchronization operation and the load power
    % is compared to check whether the active power and reactive power are the same
    % before and after islanding for a smooth resynchronization.
    
    properties
        model = 'IndustrialMicrogrid';
        microgrid1Subsystems = {'MG1 Primary Substation','MG1 Main Grid','MG1 Solver Configuration','MG1 Unit Substation','MG1 Drilling Loads','MG1 Portable Substation'...
            ,'MG1 Conveyor Belt','Selected Results/MG1','Operator Room/MG1','MG1 Bus1','MG1 Bus2','MG1 Bus3','MG1 Bus4'...
            };
        microgrid2Subsystems = {'MG2 Primary Substation','MG2 Main Grid','MG2 Solver Configuration','MG2 PV Plant','MG2 Power Center',...
            'MG2 Processing, Lighting  and Auxiliary Loads','Selected Results/MG2','Operator Room/MG2','MG2 Bus1','MG2 Bus2','MG2 Bus3'};
        simIn
    end

    methods(TestMethodSetup)
        function loadAndTearDown(testCase)
            % This function executes before each test method runs. This
            % function loads the model and adds a teardown which is
            % executed after the test method runs
            % Load the model
            load_system(testCase.model);

            % Create a Simulink.SimulationInput object for the model
            testCase.simIn = Simulink.SimulationInput(testCase.model);

            % Load the input data for the model
            IndustrialMicrogridInputData;

            % Set the microgrid structure in the global workspace
            testCase.simIn = testCase.simIn.setVariable('microgrid',microgrid);

            % Set the default status for different circuit breakers
            testCase.setDefaultStatusForCircuitBreakers;

            % Close the model after each test point runs
            testCase.addTeardown(@()bdclose(testCase.model));
        end
    end

    methods(Test)
        function testBlackStart(testCase)
            % Test the black start functionality of the industrial
            % microgrid
            % Voltage and delay inputs for black start of microgrid
            voltageLevel = [0.4 0.4 0.2];
            expectedVoltageLevel = [0.4 0.8 1];
            delayTime = [1 1 1];
            blackStartTime = 3;

            % Comment the microgrid1 subsystems
            
            for idx = 1:length(testCase.microgrid1Subsystems)
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid1Subsystems{idx}),'Commented','on');
            end

            % Uncomment the microgrid2 subsystems
            for idx = 1:length(testCase.microgrid2Subsystems)      
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid2Subsystems{idx}),'Commented','off');
            end

            % Set black start controller parameters and necessary breaker
            % parameters
            setBlackStartParametersForMicrogrid(testCase,blackStartTime,voltageLevel,delayTime);
            setBreakerParametersForMicrogridBlackStart(testCase);

            % Simulate the model
            out = sim(testCase.simIn);

            % BESS voltage
            bessVoltage = out.logsout_IndustrialMicrogrid.get('VabcBESS2').Values.Data;
            timeVal = out.logsout_IndustrialMicrogrid.get('VabcBESS2').Values.Time;

            % Time window for comparing the actual and expected voltages
            timeWindow = [5 6 7];

            % Verify if all the three phase voltages follow setpoints
            for phaseIdx = 1:3
                voltage = bessVoltage(1:end,phaseIdx);
                peakIdx = find(voltage(2:end-1) > voltage(1:end-2) & voltage(2:end-1) > voltage(3:end)) + 1;
                peakVoltage{phaseIdx} = timetable(seconds(timeVal(peakIdx)),voltage(peakIdx)); %#ok<*AGROW>
                for timeIdx = 1:length(timeWindow)
                    range = timerange(seconds(timeWindow(timeIdx)-0.2),seconds(timeWindow(timeIdx))) ;
                    actualVoltage = peakVoltage{phaseIdx}(range,:).Var1;
                    expectedVoltage = ones(length(actualVoltage),1)*expectedVoltageLevel(timeIdx);
                    diagnostic = sprintf('Actual and expected voltage are not equal for phase %d at %d seconds window',phaseIdx,timeWindow(timeIdx));
                    testCase.verifyEqual(actualVoltage,expectedVoltage,'AbsTol',5e-2,'RelTol',5e-2,diagnostic);
                end
            end
        end

        function testPlannedIsland(testCase)
            % Test point to check the planned island functionality of the
            % microgrid. Check if the load consumes same amount of power before and
            % after islanding

            % Time at which islanding starts
            islandingTime = 4;

            % Set the simulation stop time
            simulationTime = 8;
            testCase.simIn = testCase.simIn.setModelParameter('StopTime',mat2str(simulationTime));

            % Active and Reactive power thresholds for planned islanding
            % are set to 1 to have an instantaneous islanding
            powerThreshold.active = 1;
            powerThreshold.reactive = 1;

            % Comment the microgrid1 subsystems
            for idx = 1:length(testCase.microgrid1Subsystems)
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid1Subsystems{idx}),'Commented','on');
            end

            % Uncomment the microgrid2 subsystems
            for idx = 1:length(testCase.microgrid2Subsystems)
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid2Subsystems{idx}),'Commented','off');
            end

            % Set active and reactive power thresholds for planned islanding
            setPlannedIslandingParametersForMicrogrid(testCase,powerThreshold);

            % Set the status of different circuit breakers for planned
            % islanding
            setBreakerParametersForPlannedIslanding(testCase,islandingTime);

            % Simulate the model
            out = sim(testCase.simIn);

            % Verify if the load power before and after the islanding is
            % the same and the grid circuit breaker is open
            event = 'islanding';
            element.loadActivePower = 'PLoadMW2';
            element.loadReactivePower = 'QLoadMVAR2';
            element.breaker = 'BRKStatusMG2';
            testCase.verifyLoadPowerAndBreakerStatus(out,element,islandingTime,event);
        end

        function testResynchronization(testCase)
            % Test point to check the resynchronization functionality of
            % microgrid

            % Time at which resynchronization starts
            resyncTime = 3;

            % Set the simulation stop time
            simulationTime = 8;
            testCase.simIn = testCase.simIn.setModelParameter('StopTime',mat2str(simulationTime));

            % Thresholds for resynchronization are set to 1 to have an
            % instantaneous resynchronization
            threshold.voltage = 1;
            threshold.frequency = 3;
            threshold.angle = 1;

            % Uncomment the microgrid1 subsystems
            for idx = 1:length(testCase.microgrid1Subsystems)
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid1Subsystems{idx}),'Commented','off');
            end

            % Comment the microgrid2 subsystems
            for idx = 1:length(testCase.microgrid2Subsystems)
                testCase.simIn = setBlockParameter(testCase.simIn,strcat(testCase.model,'/',testCase.microgrid2Subsystems{idx}),'Commented','on');
            end

            % Set thresholds for resynchronization
            setResynchronizationParametersForMicrogrid(testCase,threshold);

            % Set the status of different circuit breakers for
            % resynchronization
            setBreakerParametersForResynchronization(testCase,resyncTime);

            % Simulate the model
            out = sim(testCase.simIn);

            % Verify if the load power is the same before and after the resynchronization 
            % and the grid circuit breaker is open
            event = 'resync';
            element.loadActivePower = 'PLoadMW1';
            element.loadReactivePower = 'QLoadMVAR1';
            element.breaker = 'BRKStatusMG1';
            testCase.verifyLoadPowerAndBreakerStatus(out,element,resyncTime,event);
        end
    end

    methods
        function verifyLoadPowerAndBreakerStatus(testCase,out,element,eventTime,event)
            % Function to verify if the load power is the same before and after the
            % islanding or the resynchronization. The function also checks whether the
            % circuit breaker is opened for planned islanding or closed for resynchronization
            % Import necessary constraints for the test
            import Simulink.sdi.constraints.MatchesSignal
            import Simulink.sdi.constraints.MatchesSignalOptions

            % Create time table arrays for load active and reactive power
            loadActivePower = extractTimetable(out.logsout_IndustrialMicrogrid.get(element.loadActivePower));
            loadReactivePower = extractTimetable(out.logsout_IndustrialMicrogrid.get(element.loadReactivePower));
            breakerStatus = extractTimetable(out.logsout_IndustrialMicrogrid.get(element.breaker));

            % Check if the active and reactive power from the grid is zero
            % after the
            % settling time when the microgrid is islanded
            settlingTime = 1;
            comparisonTime = 2;

            % Create pre-event and post-event time ranges
            preEventTimeRange = timerange(seconds(eventTime-comparisonTime),seconds(eventTime));
            postEventTimeRange = timerange(seconds(eventTime+settlingTime),seconds(eventTime+settlingTime+comparisonTime));
           
            % Verify the circuit breaker status
            if strcmp(event,'islanding')
                testCase.verifyFalse(all(breakerStatus(postEventTimeRange,:).(element.breaker)),'Grid circuit breaker is still closed and islanding has not happened. Please examine the model');
            else
                testCase.verifyFalse(all(breakerStatus(postEventTimeRange,:).(element.breaker)),'Grid circuit breaker is still opened and resynchronization has not happened. Please examine the model')
            end

            % Verify if the load power is the same before and after
            % islanding
            preEventActivePower = loadActivePower(preEventTimeRange,:);
            postEventActivePower = loadActivePower(postEventTimeRange,:);

            preEventReactivePower = loadReactivePower(preEventTimeRange,:);
            postEventReactivePower = loadReactivePower(postEventTimeRange,:);

            % Verification
            options = MatchesSignalOptions('IgnoringExtraData',true);
            testCase.verifyThat(preEventActivePower,MatchesSignal(postEventActivePower,...
                'AbsTol',5e-2,'RelTol',5e-2,'WithOptions',options),...
                sprintf('The active power taken by the load after %s has been changed. Please examing the model',event));
            testCase.verifyThat(preEventReactivePower,MatchesSignal(postEventReactivePower,...
                'AbsTol',5e-2,'RelTol',5e-2,'WithOptions',options),...
                'The reactive power taken by the load after islanding has been changed. Please examing the model');
        end

        function setBlackStartParametersForMicrogrid(testCase,blackStartTime,voltageLevels,delayTime)
            % Function to all the parameters required for the black start
            % of microgrid2
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2UnplannedIslanding',100);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2VFMode',1);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStart',blackStartTime);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartDelayLevel1',delayTime(1));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartDelayLevel2',delayTime(2));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartDelayLevel3',delayTime(3));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartVoltageLevel1',voltageLevels(1));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartVoltageLevel2',voltageLevels(2));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartVoltageLevel3',voltageLevels(3));
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartBloackLoad1PickUp1',1.5);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartBloackLoad1PickUp2',1.5);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2BlackStartBloackLoad1PickUp3',1.5);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2Blackout',0);
        end

        function setBreakerParametersForMicrogridBlackStart(testCase)
            % Function to the circuit breaker parameters for black start
            testCase.simIn = setVariable(testCase.simIn,'microgrid.PCC2BrkInitStatus',1); 
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2DieselBrk',0); 
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2PVBrk',20);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2Load3Control',20);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2Load4Control',20);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2Load5Control',20);
            testCase.simIn = testCase.simIn.setVariable('microgrid.controller2SwitchableLoad',0);
        end

        function setPlannedIslandingParametersForMicrogrid(testCase,powerThreshold)
            % Function to set the planned island parameters for microgrid2
            testCase.simIn = setVariable(testCase.simIn,'microgrid.zeroActivePowerThreshold2',powerThreshold.active);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.zeroReactivePowerThreshold2',powerThreshold.reactive);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.plannedIslandDelay',0.05);
        end     

        function setBreakerParametersForPlannedIslanding(testCase,islandingTime)
            % Function to set the circuit breaker status for planned
            % islanding of microgrid2
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2PlannedIsland',islandingTime);
        end
        
        function setResynchronizationParametersForMicrogrid(testCase,threshold)
            % Function to set the resynchronization parameters for
            % microgrid1
            testCase.simIn = setVariable(testCase.simIn,'microgrid.frequencyThreshold',threshold.frequency);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.voltageThreshold',threshold.voltage);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.angleThreshold',threshold.angle);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.resynchDelay',0.0038);
        end

        function setBreakerParametersForResynchronization(testCase,resyncTime)
            % Function to set the circuit breaker status for resunchronization
            % Breaker settings for Microgrid1
            testCase.simIn = setVariable(testCase.simIn,'microgrid.PCC1BrkInitStatus',1); 
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller1PCCBrk',100); 
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller1Resynch',resyncTime);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller1Load1Control',0);
            testCase.simIn = setVariable(testCase.simIn,'microgrid.controller2Load1Control',0);
        end

        function setDefaultStatusForCircuitBreakers(testCase)
            % Function to set the default status of the ciruit breakers for
            % microgrid1 and microgrid2
            microgrid1Breakers = [{'controller1Resynch',20},{'controller1PlannedIsland',20},{'controller1PCCBrk',0},{'controller1PortableSubstationBrk',20}...
                {'controller1Load1Control',20},{'controller1Load2Control',20},{'controller1UnitSubstationBrk1',20},{'controller1UnitSubstationBrk2',20}];

            % Breaker settings for Microgrid2
            microgrid2Breakers = [{'controller2Resynch',20},{'controller2PlannedIsland',20},{'controller2PCCBrk',0},{'controller2DieselBrk',20}...
                {'controller2PVBrk',0},{'controller2Load3Control',0},{'controller2Load4Control',0},{'controller2Load5Control',0}...
                {'controller2PowerCenterBrk2',20},{'controller2PowerCenterFault',20},{'controller2PowerCenterBrk1',20},...
                {'controller2PowerCenterBrk3',20},{'controller2SubstationBrk',20}];

            testCase.setBreakerStatus(microgrid2Breakers);
            testCase.setBreakerStatus(microgrid1Breakers);
        end

        function setBreakerStatus(testCase,breakerStatus)
            % Function to set the breaker status
            for breakerIdx = 1:2:length(breakerStatus)
                testCase.simIn = setVariable(testCase.simIn,strcat('microgrid.',breakerStatus{breakerIdx}),breakerStatus{breakerIdx+1});
            end
        end
    end
end


