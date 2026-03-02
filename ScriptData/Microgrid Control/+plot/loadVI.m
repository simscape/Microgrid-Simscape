function loadVI(logsout,plotType,caseNum,voltageLimit)
% Function to plot simulation results of load current and load voltage

% Copyright 2026 The MathWorks, Inc.

arguments
    logsout
    plotType string = "instantaneous";
    caseNum (1,1) double = 1;
    voltageLimit.max double = 1.1;
    voltageLimit.min double = 0.9;
end

if strcmp(plotType,"instantaneous")
    figureName = 'loadVI';
else
    figureName = 'loadVIRMS';
end
% Create new figure
PlotLoadVI = figure('Name', figureName);
figure(PlotLoadVI)
%clf(PlotLoadVI)

% selecting time axis for the plot
switch caseNum
    case 1
        tStartPlot1 = 3;
        tStopPlot1 = 8;
        tStartPlot2 = 4;
        tStopPlot2 = 4.2;
    case 2
        tStartPlot1 = 3.9;
        tStopPlot1 = 4.1;
        tStartPlot2 = 7;
        tStopPlot2 = 7.5;
    case 3
        tStartPlot1 = 3.9;
        tStopPlot1 = 4.1;
        tStartPlot2 = 7.5;
        tStopPlot2 = 7.7;
    case 4
        tStartPlot1 = 3.9;
        tStopPlot1 = 4.1;
        tStartPlot2 = 7.5;
        tStopPlot2 = 8;
    case 5
        tStartPlot1 = 3;
        tStopPlot1 = 8;
        tStartPlot2 = 4;
        tStopPlot2 = 4.2;
end
voltageLimitMax = voltageLimit.max;
voltageLimitMin = voltageLimit.min;

% Get simulation results
loadVoltage = squeeze(logsout.get('loadVoltage').Values.Data);
loadCurrent = squeeze(logsout.get('loadCurrent').Values.Data);
if strcmp(plotType,"instantaneous")
    voltageData = loadVoltage;
    currentData = loadCurrent;
    plotWidth = 1;
    plotTitle = 'Load Voltage and Current';
else
    voltageData = rms(loadVoltage)*sqrt(2);
    currentData = rms(loadCurrent)*sqrt(2);
    plotWidth = 2;
    plotTitle = 'Load Voltage and Current (RMS)';
end

timeData = logsout.get('loadVoltage').Values.Time;
timeIdxPlot1 = find(timeData > tStartPlot1 & timeData < tStopPlot1);
timeIdxPlot2 = find(timeData > tStartPlot2 & timeData < tStopPlot2);

% Plot results
flag = any(voltageData(:)>voltageLimitMax)+any(voltageData(:) < -voltageLimitMax)+...
    any(max(voltageData(:))<voltageLimitMin);

subplot(2, 2, 1);
plot(timeData(timeIdxPlot1), voltageData(:,timeIdxPlot1), 'LineWidth', plotWidth)
hold on

if flag > 0
    plotColor = 'r';
    title('Three-Phase Load Voltage', 'Outside Acceptable Limit ', 'Color','red')
else
    plotColor = 'g';
    title('Three-Phase Load Voltage', 'Within Acceptable Limit ', 'Color','green')
end

plot([tStartPlot1,tStopPlot1],[voltageLimitMax,voltageLimitMax],'LineWidth',1,'Color',plotColor,'LineStyle','-');
plot([tStartPlot1,tStopPlot1],[voltageLimitMin,voltageLimitMin],'LineWidth',1,'Color',plotColor,'LineStyle',':');

if strcmp(plotType,"instantaneous")
    plot([tStartPlot1,tStopPlot1],[-voltageLimitMax,-voltageLimitMax],'LineWidth',1,'Color',plotColor,'LineStyle','-');
    plot([tStartPlot1,tStopPlot1],[-voltageLimitMin,-voltageLimitMin],'LineWidth',1,'Color',plotColor,'LineStyle',':');
    legend('','','','Max','','Min','NumColumns',2)
else
    legend('','Max','Min','Location','best');
end
grid on;
axis([tStartPlot1 tStopPlot1 -1.3 1.3]);
title('Three-Phase Load Voltage ')
ylabel('Voltage (pu)')
xlabel('Time (s)')

%%
subplot(2, 2, 2);
plot(timeData(timeIdxPlot2), voltageData(:,timeIdxPlot2), 'LineWidth', plotWidth)
hold on
if flag > 0
    title(' Three-Phase Load Voltage', 'Outside Acceptable Limit ', 'Color','red')
else
    title('Three-Phase Load Voltage', 'Within Acceptable Limit ', 'Color','green')
end
plot([tStartPlot2,tStopPlot2],[voltageLimitMax,voltageLimitMax],'LineWidth',1,'Color',plotColor,'LineStyle','-');
plot([tStartPlot2,tStopPlot2],[voltageLimitMin,voltageLimitMin],'LineWidth',1,'Color',plotColor,'LineStyle',':');
if strcmp(plotType,"instantaneous")
    plot([tStartPlot2,tStopPlot2],[-voltageLimitMax,-voltageLimitMax],'LineWidth',1,'Color',plotColor,'LineStyle','-');
    plot([tStartPlot2,tStopPlot2],[-voltageLimitMin,-voltageLimitMin],'LineWidth',1,'Color',plotColor,'LineStyle',':');
    legend('','','','Max','','Min','NumColumns',2);
else
    legend('','Max','Min','Location','best');
end
grid on

axis([tStartPlot2 tStopPlot2 -1.3 1.3]);
title('Three-Phase Load Voltage')
ylabel('Voltage (pu)')
xlabel('Time (s)')
%legend('','','','Max','','Min','NumColumns',2)

subplot(2, 2, 3);
plot(timeData(timeIdxPlot1), currentData(:,timeIdxPlot1), 'LineWidth', plotWidth)
grid on

axis([tStartPlot1 tStopPlot1 -1.3 1.3]);
title('Three-Phase Load Current')
ylabel('Current (pu)')
xlabel('Time (s)')

subplot(2, 2, 4);
plot(timeData(timeIdxPlot2), currentData(:,timeIdxPlot2), 'LineWidth', plotWidth)

grid on

axis([tStartPlot2 tStopPlot2 -1.3 1.3]);
title('Three-Phase Load Current');
ylabel('Current (pu)');
xlabel('Time (s)');
sgtitle(plotTitle,'Fontsize',15);
% if strcmp(plotType,"instantaneous")
%     sgtitle(' Load Voltage and Current','Fontsize',15);
% else
%     sgtitle(' Load Voltage and Current (RMS)','Fontsize',15);
% end
end
