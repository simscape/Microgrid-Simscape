function remoteMicrogridPlot(caseNum,simoutData)
% Function to plot simulation results from RemoteMicrogrid

% Copyright 2023 The MathWorks, Inc.
voltageLimit = 0.1;
frequencyLimit = 0.02;

% Plot BESS and Grid voltage and current
remoteMicrogridPlotBESSVI(simoutData.logsout_RemoteMicrogrid,caseNum,voltageLimit);

% Plot Active and Reactive power
remoteMicrogridPlotPQ(simoutData.logsout_RemoteMicrogrid);

% Plot Load voltage and current
remoteMicrogridPlotLoadVI(simoutData.logsout_RemoteMicrogrid,caseNum);

% Plot Load RMS voltage and current
remoteMicrogridPlotLoadVIRMS(simoutData.logsout_RemoteMicrogrid,caseNum);

if caseNum == 3 || caseNum == 4
    % Plot Frequency and Angle
    remoteMicrogridPlotFreAngle(simoutData.logsout_RemoteMicrogrid,caseNum,voltageLimit,frequencyLimit);
end
end
