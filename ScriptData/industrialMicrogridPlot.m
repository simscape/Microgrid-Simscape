function industrialMicrogridPlot(caseNum,simoutData,microgrid)
% Function to plot simulation results from IndustrialMicrogrid

% Copyright 2023 The MathWorks, Inc.

voltageLimit = 0.1;
% Plot BESS and Grid voltage and current
industrialMicrogridPlotBESSIV(simoutData.logsout_IndustrialMicrogrid,caseNum,voltageLimit,microgrid);

% Plot Active and Reactive power
industrialMicrogridPlotPQ(simoutData.logsout_IndustrialMicrogrid,caseNum,microgrid);

if caseNum == 1 || caseNum == 2
    limit.voltage = 0.1;
    limit.frequency = 0.02;
    % Plot Frequency and Angle
    industrialMicrogridPlotFreAngle(simoutData.logsout_IndustrialMicrogrid,caseNum,limit);
end

% Plot Load voltage and current
loadVoltageLimit.max = 0.1;
loadVoltageLimit.min = -0.05;
industrialMicrogridPlotLoadVI(simoutData.logsout_IndustrialMicrogrid,caseNum,loadVoltageLimit,microgrid);

% Plot Load RMS voltage and current
loadVoltageLimit.max = 0.1;
loadVoltageLimit.min = -0.05;
industrialMicrogridPlotLoadVIRMS(simoutData.logsout_IndustrialMicrogrid,caseNum,loadVoltageLimit,microgrid);
end
