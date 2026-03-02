function powerFlow(logsout,caseNum)
% Function to plot simulation results of power flow

% Copyright 2026 The MathWorks, Inc.

arguments
    logsout
    caseNum (1,1) double = 1;
end


% Create new figure
PlotPower = figure('Name', 'Power flow in microgrid');
figure(PlotPower)


tStart = 3.5;
tStop = 8;
powerMeasurement = {'grid','wind','solar','bess','generator','load'};
timeData = logsout.get('gridActivePower').Values.Time;
timeIdx = find(timeData > tStart & timeData < tStop);

%% 
% Plot Active Power
subplot(2,1,1)
for plotIdx = 1:length(powerMeasurement)
    powerVar = strcat(powerMeasurement{plotIdx},'ActivePower');
    activePower = logsout.get(powerVar).Values.Data;
    plot(timeData(timeIdx),activePower(timeIdx),'LineWidth',1);
    hold on;
end
title('Active Power')
ylabel('Power (MW)')
xlabel('Time (s)')
legend('Grid','Wind','Solar','BESS','Generator','Load','NumColumns',2);
xlim([tStart,tStop]);
grid on;
%% 
% Plot Reactive Power
subplot(2,1,2)
for plotIdx = 1:length(powerMeasurement)
    powerVar = strcat(powerMeasurement{plotIdx},'ReactivePower');
    reactivePower = logsout.get(powerVar).Values.Data;
    plot(timeData(timeIdx),reactivePower(timeIdx),'LineWidth',1);
    hold on;
end
title('Reactive Power')
ylabel('Power (MVar)')
xlabel('Time (s)')
xlim([tStart,tStop]);
grid on;
legend('Grid','Wind','Solar','BESS','Generator','Load','NumColumns',1);

sgtitle('Power flow in Microgrid','Fontsize',15);
end