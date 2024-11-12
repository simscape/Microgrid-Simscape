function plotCostContribution(cost,solution)
% Copyright 2024 The MathWorks, Inc.

% This function plots cost contribution of different assets
arguments
    cost {mustBeNonempty}
    solution {mustBeNonempty}
end
hold off;
finalCost.grid = evaluate(cost.grid,solution);
finalCost.generator = round(evaluate(cost.generator,solution));
finalCost.wind = evaluate(cost.wind,solution);
finalCost.solar = evaluate(cost.solar,solution);
finalCost.battery = evaluate(cost.battery,solution);
data = abs([sum(finalCost.grid),sum(finalCost.generator),sum(finalCost.wind),sum(finalCost.solar),sum(finalCost.battery)]);
names = ["Grid","Generator","Wind","Solar","Battery"];
piechart(data,names);
title('Overall Cost Contribution in Microgrid')
end