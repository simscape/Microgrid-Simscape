function plotSensitivityAnalysis(analysis)
% Copyright 2024 The MathWorks, Inc.

% Plot the optimal values
data = [];
formatComponent = @(str) regexprep(regexprep(str, '([a-z])([A-Z])', '$1 $2'), '(^|\s)(\w)', '${upper($0)}');
analysis.componentTitle = cellfun(formatComponent, analysis.components, 'UniformOutput', false);

for componentIdx = 1:length(analysis.components)
    componentVal = analysis.result.(char(analysis.components(componentIdx))); %#ok<*AGROW>
    figure('Name',char(analysis.components(componentIdx)))
    plot(analysis.val,componentVal,'LineWidth',2,'Marker',"^");
    title(sprintf('Variation of %s with %s',analysis.componentTitle{componentIdx},analysis.var));
    xlabel(analysis.var);
    if contains(analysis.components{componentIdx},'battery')
        ylabel(strcat(analysis.componentTitle{componentIdx},' (kWh)'));
    else
        ylabel(strcat(analysis.componentTitle{componentIdx},' (kW)'));
    end
    grid on;
    data =[data,componentVal];
end
figure('Name','plot_Bar_SensitivityAnalysis')

bar(data');

% Customize the plot
set(gca, 'XTickLabel', analysis.components); % Set the x-axis labels
xlabel(analysis.var);
ylabel('Rating  (kWh)');
title(sprintf('Bar Plot for Multiple Components with Change in %s',analysis.var));
legend(num2str(analysis.val), 'Location', 'northeast');

figure('Name','plot_TotalCost_SensitivityAnalysis')
plot(analysis.val,analysis.result.cost,'LineWidth',2,'Marker',"^");
title(sprintf('Variation of Total Cost with %s',analysis.var));
xlabel(analysis.var);
ylabel('Cost ($)');
grid on;
