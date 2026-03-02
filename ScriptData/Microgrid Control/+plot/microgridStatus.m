function microgridStatus(logsout,caseNum)
% Function to plot simulation results of load current and load voltage

% Copyright 2026 The MathWorks, Inc.

arguments
    logsout
    caseNum (1,1) double = 1;
end


% Create new figure
PlotMicrogridStatus = figure('Name', 'PlotMicrogridStatus');
figure(PlotMicrogridStatus)
%clf(PlotLoadVI)

% selecting time axis for the plot
switch caseNum
    case 2
      eventData = logsout.get("plannedIslandingCommand").Values.Data;
      eventType = 'PlannedIslanding';
      numPlots = 3;
    case 3
      eventData = logsout.get("resynchCommand").Values.Data;
      eventType = 'Resynchronization';
      numPlots = 3;
    otherwise
      eventData = [];
      numPlots = 2;
end
microgridMode = logsout.get("microgridMode").Values.Data;
breakerPCC = logsout.get("breakerPCC").Values.Data;
% Get simulation results
timeData = logsout.get('loadVoltage').Values.Time;


% Plot results
plotWidth = 2;
subplot(numPlots, 1, 1);
plot(timeData, microgridMode, 'LineWidth', plotWidth);
yticks(1:6);     % Set which tick marks to show
yticklabels({"Steady State Islanded", "Resynchronization", "Steady State Grid Connected", "Planned Islanding", "Black Start","Unplanned Islanding"});

grid on;

title('Microgrid Operating Mode')
ylabel('Mode')
xlabel('Time (s)')

%%
subplot(numPlots, 1, 2);
plot(timeData, breakerPCC, 'LineWidth', plotWidth);
yticks(0:1);
yticklabels({'Close','Open'});
title('PCC breaker status')
ylabel('Breaker Status')
xlabel('Time (s)')
grid on;
if caseNum == 2 || caseNum == 3
    subplot(numPlots, 1, 3);
    hold on
    plot(timeData, eventData, 'LineWidth', plotWidth);
    title(eventType)
    ylabel('Command')
    xlabel('Time (s)')
    grid on
end

sgtitle('Microgrid Status','Fontsize',15);

end
