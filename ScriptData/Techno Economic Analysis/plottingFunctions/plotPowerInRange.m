function plotPowerInRange(simOut,elements,plotTime)

% Copyright 2024 The MathWorks, Inc.

% This function plots power output of different assets
plot_powerInRange = figure('Name','plot_powerInRange');
figure(plot_powerInRange);
plot_powerInRange.Position =  [100, 100, 800, 525];
title('Power flow in Microgrid');
grid on;
numSubplots = length(elements);
colors = lines(numSubplots);
for elementIdx = 1:length(elements)
    subplot(length(elements),1,elementIdx)
    powerVal = char(strcat('p',elements(elementIdx)));
    simTime = simOut.logsout.get(powerVal).Values.Time;
    activePower = simOut.logsout.get(powerVal).Values.Data;
    timeRange = simTime(simTime >= plotTime(1) & simTime <= plotTime(end));
    logicalArray = find(ismember(simTime,timeRange));
    timeIdx = logicalArray;
    time = hours(timeRange);
    plot(time,activePower(timeIdx),'Color',colors(elementIdx, :),'LineWidth',2);
    xlabel('Time in hrs');
    ylabel('Power in kW');
    % ax = gca;
    % ax.XTick = time(1:10:end);
    % ax.XTickLabel = string(time(1:10:end));
    title(char(strcat(elements(elementIdx),' ','Power')));
    grid on;
end
end
