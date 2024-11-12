function energyVal = energy(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.
arguments
    NameValueArgs.Solution {mustBeNonempty}
    NameValueArgs.NormalizedPower {mustBeNonempty}
end
solution = NameValueArgs.Solution;
normalizedPower = NameValueArgs.NormalizedPower;
% This function calculates energy flow with in the microgrid
energyVal.grid = sum(solution.gridPower);
energyVal.solar = solution.solarRating*sum(normalizedPower.solar);
energyVal.wind = solution.windRating*sum(normalizedPower.wind);
energyVal.load = sum(solution.actualLoad);
if solution.generatorRating > 0
    energyVal.generator = sum(solution.generatorLoading);
else
    energyVal.generator = 0;
end
energyVal.batteryDisharging = sum(solution.batteryPower(solution.batteryPower>0));
energyVal.batteryCharging = -sum(solution.batteryPower(solution.batteryPower<0));
energyVal.balance = energyVal.grid+energyVal.solar+energyVal.wind+energyVal.generator+energyVal.batteryDisharging-energyVal.batteryCharging-energyVal.load;
end