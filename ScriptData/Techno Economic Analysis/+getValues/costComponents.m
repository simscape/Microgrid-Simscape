function [capex,opex,fuelCost,costTable] = costComponents(Param,Solution,NPV,FuelType)
% Copyright 2024 The MathWorks, Inc.

% This function computes different costs associated with grid and different assets
arguments
    Param {mustBeNonempty}
    Solution {mustBeNonempty}
    NPV {mustBeNonempty}
    FuelType {mustBeNonempty}
end
% Capital costs
capex.grid = 0;
capex.solar = Param.solar.capex*Solution.solarRating;
capex.wind = Param.wind.capex*Solution.windRating;
capex.generator = Param.generator.capex*Solution.generatorRating;
capex.battery = Param.battery.capex*Solution.batteryEnergyRating;

% Operational costs
opex.grid = sum(reshape(Solution.gridPower,[],NPV.years),1).*Param.grid.importPrice.*NPV.correctionFactor;
opex.solar = Param.solar.opex*Solution.solarRating*NPV.correctionFactor;
opex.wind = Param.wind.opex*Solution.windRating*NPV.correctionFactor;
opex.battery = Param.battery.opex*Solution.batteryEnergyRating*NPV.correctionFactor;
opex.generator = Param.generator.opex*Solution.generatorRating*NPV.correctionFactor;

% Fuel cost
a = 0.08415;
b = 0.246;
for idx = 1:length(Solution.generatorLoading)
    if Solution.generatorLoading == 0
        fuelConsumption(idx) = 0; %#ok<*AGROW>
    elseif strcmp(FuelType,'diesel')
        fuelConsumption(idx) = a*Solution.generatorRating+b*Solution.generatorLoading(idx);
    else
        fuelConsumption(idx) = Solution.generatorLoading(idx)*7.43/1000;
    end
end

  
fuelCost.grid = zeros(1,NPV.years);
fuelCost.solar = zeros(1,NPV.years);
fuelCost.wind = zeros(1,NPV.years);
fuelCost.battery = zeros(1,NPV.years);
fuelCost.generator = round(sum(reshape(fuelConsumption,[],NPV.years),1)).*Param.generator.fuelCost.*NPV.correctionFactor;

% Create a table
capitalCost = [capex.grid;capex.battery;capex.solar;capex.wind;capex.generator];
operatingCost = [opex.grid;opex.battery;opex.solar;opex.wind;opex.generator];
fuelCostFinal = [fuelCost.grid;fuelCost.battery;fuelCost.solar;fuelCost.wind;fuelCost.generator];

totalCapex = sum(capitalCost);
totalOpex = sum(operatingCost,1);
totalFuelCost = sum(fuelCostFinal,1);

capitalCost = [capitalCost;totalCapex];
operatingCost = [operatingCost;totalOpex];
fuelCostFinal = [fuelCostFinal;totalFuelCost];

allVarNames = [{'CAPEX (USD)'}, {'OPEX (USD)'}, {'FuelCost (USD)'}];
costTable = table(capitalCost, ...
                           operatingCost, ...
                           fuelCostFinal, ...
    'VariableNames', allVarNames, ...
    'RowNames', {'Grid', 'Solar', 'Wind', 'Battery', 'Generator','Total'});
end