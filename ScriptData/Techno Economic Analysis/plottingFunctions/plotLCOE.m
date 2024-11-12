function lcoe = plotLCOE(lcoe)
% This function plots the levelized costs of different assets in microgrid
%data = [lcoe.grid;lcoe.solar;lcoe.wind;lcoe.generator];
barPlot = bar(lcoe.data);

% Define colors for each bar
colors = [
    0.2, 0.6, 0.8;   % Color for Grid (light blue)
    0.8, 0.4, 0.2;   % Color for Solar (orange)
    0.4, 0.8, 0.4;   % Color for Wind (green)
    0.8, 0, 0.1      % Color for Generator (red)
];

% Apply colors to each bar
barPlot.FaceColor = 'flat';
for idx = 1:length(lcoe.components)
    barPlot.CData(idx,:) = colors(idx, :);
end
% Customize the plot
set(gca, 'XTickLabel', lcoe.components); % Set the x-axis labels
xlabel('Components');
ylabel('LCOE ($/kWh)');
title('Levelized Cost of Energy');
end
