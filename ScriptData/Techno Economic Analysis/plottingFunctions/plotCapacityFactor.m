function plotCapacityFactor(capacityFactor)
% Copyright 2024 The MathWorks, Inc.

% This function plots the capacity factor of different assets for every month in microgrid
timeScale = 1:1:length(capacityFactor.solarMonthly);
plot_capacityFactor = figure('Name','plotCapacityFactor');
figure(plot_capacityFactor);

plot(timeScale,cell2mat(capacityFactor.solarMonthly),'LineWidth',1.5);
hold on;
plot(timeScale,cell2mat(capacityFactor.windMonthly),'LineWidth',1.5);
hold on;
plot(timeScale,cell2mat(capacityFactor.generatorMonthly),'LineWidth',1.5);
grid on;
hold off;

xlabel('Months');
ylabel('Capacity Factor(%)');
title('Capacity Factor of Different Assets');
legend('Solar','Wind','Generator', 'Location', 'northeast');
end
