function remoteMicrogridPlot(caseNum,simoutData)
% Function to plot simulation results from RemoteMicrogrid

% Copyright 2023 The MathWorks, Inc.
voltageLimit = 0.1;
frequencyLimit = 0.02;

% Assign the start and stop time for plotting
switch caseNum
    case 1
        tStart = 5.9;
        tStop = 6.1;
    case 2
        tStart = 5.9;
        tStop = 6.1;
    case 3
        tStart = 7.2;
        tStop = 7.4;
    case 4
        tStart = 7.4;
        tStop = 7.6;
    case 5
        tStart = 5.9;
        tStop = 6.1;
end 
tEvent = 3;
powerPlotStart = 2.5;
powerPlotStop =8;

% Plot BESS and Grid voltage and current
remoteMicrogridPlotBESSVI(simoutData.logsout_RemoteMicrogrid,voltageLimit,tEvent,tStart,tStop);

% Plot Active and Reactive power
remoteMicrogridPlotPQ(simoutData.logsout_RemoteMicrogrid,powerPlotStart,powerPlotStop);

% Plot Load voltage and current
remoteMicrogridPlotLoadVI(simoutData.logsout_RemoteMicrogrid,tEvent,tStart,tStop);

% Plot Load RMS voltage and current
remoteMicrogridPlotLoadVIRMS(simoutData.logsout_RemoteMicrogrid,tEvent,tStart,tStop);

if caseNum == 3 || caseNum == 4
    % Plot Frequency and Angle
    remoteMicrogridPlotFreAngle(simoutData.logsout_RemoteMicrogrid,caseNum,voltageLimit,frequencyLimit);
end
end
