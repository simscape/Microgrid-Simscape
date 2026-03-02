function setModelFidelity(model,Settings)

% Copyright 2026 The MathWorks, Inc.

    arguments(Input)
        model 
        Settings.Fidelity (1,1) string
        Settings.SampleTime (1,1) string
        Settings.SimulationTime (1,1) string
    end
    subsystems = find_system(model, 'BlockType', 'SubSystem');
    % Initialize cell array to store matching subsystems
    matchingSubsystems = {};

for i = 1:length(subsystems)
    block = subsystems{i};
    % Check if subsystem is masked
    if strcmp(get_param(block, 'Mask'), 'on')
        % Get mask parameter names
        maskNames = get_param(block, 'MaskNames');
        if ismember('fidelity', maskNames)
            matchingSubsystems{end+1} = block; %#ok<*AGROW>
        end
    end
end
for index = 1:length(matchingSubsystems)
    set_param(matchingSubsystems{index},'fidelity',Settings.Fidelity)
end
solverBlock = [model,'/','Solver Configuration'];
if strcmp(Settings.Fidelity,"Simplified")
    simType = "NE_FREQUENCY_TIME_EF";
else   
    simType = 'NE_TIME_EF';
end
set_param(solverBlock,'EquationFormulation',simType);
set_param(solverBlock,'LocalSolverSampleTime',Settings.SampleTime);
set_param(model,'StopTime',Settings.SimulationTime);
end