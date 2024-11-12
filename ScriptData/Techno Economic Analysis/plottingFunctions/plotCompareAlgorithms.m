function plotCompareAlgorithms(simOutOpt,simOutRule,elements,plotTime,titleName,generatorSet,mainGrid,plotLength)

% Copyright 2024 The MathWorks, Inc.

% This function plots power output of different assets
plot_powerFlow = figure('Name','plot_PowerFlow');
figure(plot_powerFlow);
plot_powerFlow.Position =  [100, 50, 700, plotLength];
title('Power flow in Microgrid');
grid on;
numSubplots = length(elements);
colors = lines(numSubplots);
for elementIdx = 1:length(elements)
    subplot(length(elements),1,elementIdx)
    powerVal = char(strcat('p',elements(elementIdx)));

    % Optimization based
    simTime = simOutOpt.logsout.get(powerVal).Values.Time;
    activePowerOpt = simOutOpt.logsout.get(powerVal).Values.Data;
    timeRange = simTime(simTime >= plotTime(1) & simTime <= plotTime(end));
    logicalArray = find(ismember(simTime,timeRange));
    timeIdx = logicalArray;

    % Rule based
    activePowerRule = simOutRule.logsout.get(powerVal).Values.Data;
    time = hours(timeRange);

    plot(time,activePowerOpt(timeIdx),'Color',colors(elementIdx, :),'LineWidth',1.5,'LineStyle','--');
    hold on;
    plot(time,activePowerRule(timeIdx),'Color',(colors(elementIdx, :)),'LineWidth',1.5);
    hold on;
    if contains(elements{elementIdx},'Load')
        actualLoad = simOutOpt.logsout.getElement('criticalLoad').Values.Data*1.25/1000;
        plot(time,actualLoad(timeIdx),'Color','g','LineWidth',1.5);
        legend('Optimization','RuleBased','ActualLoad','Orientation','horizontal');
    else
        legend('Optimization','RuleBased','Orientation', 'horizontal');
    end

    xlabel('Time in hrs');
    ylabel('Power');
    ax = gca;
    if elementIdx < length(elements)
        ax.XTick = [];
    else
        ax.XTick = time(1:10:end);
        ax.XTickLabel = string(time(1:10:end));
    end
    title(char(strcat(elements(elementIdx),' ','Power in kW')));
    sgtitle(titleName);

end

%% Plot cost variation over the day
plot_costComparison = figure('Name','plot_costComparison');
figure(plot_costComparison);
title('Cost Comparison');
grid on;
gridPowerRuleBased = simOutRule.logsout.get('pGrid').Values.Data(timeIdx);
gridPowerOptBased = simOutOpt.logsout.get('pGrid').Values.Data(timeIdx);
if any(contains(elements,'Generator'))
    genPowerRuleBased = simOutRule.logsout.get('pGenerator').Values.Data(timeIdx);
    genPowerOptBased = simOutOpt.logsout.get('pGenerator').Values.Data(timeIdx);

    a = 0.08415;
    b = 0.246;
    for idx = 1:length(genPowerRuleBased)
        if genPowerRuleBased(idx)>0
            fuelConsumptionRule(idx) = a*generatorSet.rating+b*genPowerRuleBased(idx);
            fuelConsumptionOpt(idx) = a*generatorSet.rating+b*genPowerOptBased(idx);
        else
            fuelConsumptionRule(idx) = 0;
            fuelConsumptionOpt(idx) = 0;
        end
    end
else
    fuelConsumptionRule = zeros(length(gridPowerRuleBased),1);
    fuelConsumptionOpt = zeros(length(gridPowerRuleBased),1);
end
for idx = 1:length(gridPowerRuleBased)
    costRuleBased(idx) = gridPowerRuleBased(idx)*mainGrid.cost+fuelConsumptionRule(idx)*generatorSet.fuelCost;
    costOptBased(idx) = gridPowerOptBased(idx)*mainGrid.cost+fuelConsumptionOpt(idx)*generatorSet.fuelCost; %#ok<*AGROW>
end

plot(time,costOptBased,'LineWidth',1.5,'LineStyle','--');
hold on;
plot(time,costRuleBased,'LineWidth',1.5);
hold on;
grid on;
xlabel('Time in hrs');
ylabel('Cost in $');
legend('Optimization','RuleBased');
ax = gca;
ax.XTick = time(1:10:end);
ax.XTickLabel = string(time(1:10:end));

%% Plot Cummulative cost
plot_totalCost = figure('Name','plot_totalCost');
figure(plot_totalCost);
data = [floor(sum(costOptBased)) floor(sum(costRuleBased))];
barHandle = bar(data);
colors = [
    0.2, 0.6, 0.8;   % Color for Grid (light blue)
    0.8, 0.4, 0.2;];   % Color for Solar (orange)

% Customize the plot
% Apply colors to each bar
barHandle.FaceColor = 'flat';
for idx = 1:length(data)
    barHandle.CData(idx,:) = colors(idx, :);
end
set(gca, 'XTickLabel', {'Optimization','RuleBased'}); % Set the x-axis labels
xlabel('Algorithm');
ylabel('Cummulative Cost ($)');
title('Cummulative Cost of Energy');

% Hold the current plot
hold on;
% Add data labels on top of each bar
for idx = 1:length(data)
    % Get the X and Y coordinates for the text
    xData = barHandle.XData(idx);
    yData = data(idx);

    % Display the value on top of the bar
    text(xData, yData, num2str(yData), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off;
end
