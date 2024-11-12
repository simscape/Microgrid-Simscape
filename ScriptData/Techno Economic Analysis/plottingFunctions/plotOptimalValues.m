function plotOptimalValues(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.
arguments
    NameValueArgs.Solution {mustBeNonempty}
    NameValueArgs.NormalizedPower {mustBeNonempty}
    NameValueArgs.Years {mustBeNonempty}
end

% Results and Plot
optimalGridPower = NameValueArgs.Solution.finalGridPower;
optimalWindPower = NameValueArgs.Solution.windRating*NameValueArgs.NormalizedPower.wind;
optimalSolarPower = NameValueArgs.Solution.solarRating*NameValueArgs.NormalizedPower.solar;
optimalBatteryPower = NameValueArgs.Solution.batteryPower;
optimalGeneratorPower = NameValueArgs.Solution.generatorLoading;
loadPower = NameValueArgs.Solution.actualLoad;
electrolyzerConsumption = NameValueArgs.Solution.electrolyzerConsumption;

totalGeneration = optimalGridPower+optimalWindPower+optimalSolarPower+optimalBatteryPower+optimalGeneratorPower;

startDate = datetime(2025, 1, 1, 12, 0, 0);  % January 1, 2025, at 00:00:00
durationYears = calyears(NameValueArgs.Years);
endDate = startDate + durationYears;

colors = lines(6);

% Create the time scale with one-hour intervals
timeVector= startDate:hours(1):endDate-hours(1);
leapDayIndices = (month(timeVector) == 2) & (day(timeVector) == 29);

% Exclude leap days from the time vector
timeVector = timeVector(~leapDayIndices);
plot_optimalSolution = figure('Name', 'plot_optimalSolution');
%plot_optimalSolution.Position =  [100, 100, 800, 700];

figure(plot_optimalSolution)
subplot(5,1,1)
plot(timeVector,optimalGridPower,'LineWidth',1.5,'Color',colors(1,:));
legend('Grid');
ylabel('Power (kW)');
title('Grid Power (kW)');
set(gca, 'XTick', []);
grid on;

subplot(5,1,2)
plot(timeVector,optimalSolarPower,'LineWidth',1.5,'Color',colors(2,:));
legend('Solar');
ylabel('Power (kW)');
grid on;
title('Solar Power (kW)');
set(gca, 'XTick', []);

subplot(5,1,3)
plot(timeVector,optimalWindPower,'LineWidth',1.5,'Color',colors(3,:));
legend('Wind');
ylabel('Power (kW)');
grid on;
title('Wind Power (kW)');
set(gca, 'XTick', []);

subplot(5,1,4)
plot(timeVector,optimalBatteryPower','LineWidth',1.5,'Color',colors(4,:));
legend('Battery');
ylabel('Power (kW)');
grid on;
title('Battery Power (kW)');
set(gca, 'XTick', []);

subplot(5,1,5)
grid on;
plot(timeVector,optimalGeneratorPower,'LineWidth',1.5,'Color',colors(5,:));
legend('Generator');
ylabel('Power (kW)');
grid on;
title('Generator Power (kW)');
set(gca, 'XTick', []);
newTicks = startDate:calmonths(12):endDate;
xticks(newTicks);
xtickangle(45);
grid on;
xlabel('Time duration');

plot_powerBalance = figure('Name', 'plot_powerBalance');
figure(plot_powerBalance);
plot_powerBalance.Position =  [100, 100, 800, 700];
plot(timeVector,totalGeneration,'Color',colors(1,:));
hold on;
plot(timeVector,loadPower+electrolyzerConsumption,'Color',colors(3,:));
xticks(newTicks);
xtickangle(45);
grid on;
title('Power Balance in Microgrid');
legend('Total Generation','Total Load');
xlabel('Time duration');
ylabel('Power in kW');