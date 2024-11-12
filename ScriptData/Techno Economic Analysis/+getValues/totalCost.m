function cost = totalCost(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function calculates different costs associated with the microgrid
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.TimeInterval {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
    NameValueArgs.PowerVal {mustBeNonempty}
end

power = NameValueArgs.PowerVal;
optimalVal.gridPower = power.grid;
optimalVal.gridPeakPower = NameValueArgs.OptVar.grid.peakPower;
optimalVal.gridPowerBuy = NameValueArgs.OptVar.grid.gridPowerBuy;
optimalVal.gridPowerSell = NameValueArgs.OptVar.grid.gridPowerSell;
optimalVal.zBuy = NameValueArgs.OptVar.grid.zBuy;
optimalVal.zSell = NameValueArgs.OptVar.grid.zSell;
optimalVal.batteryEnergyRating = NameValueArgs.OptVar.battery.energyRating;
optimalVal.solarRating = NameValueArgs.OptVar.solar.rating+NameValueArgs.OptVar.solar.reserve;
optimalVal.windRating = NameValueArgs.OptVar.wind.rating+NameValueArgs.OptVar.wind.reserve;
optimalVal.generatorRating = NameValueArgs.OptVar.generator.rating+NameValueArgs.OptVar.generator.reserveRating;
optimalVal.generatorLoading = NameValueArgs.OptVar.generator.loading;
optimalVal.generatorApproximate = NameValueArgs.OptVar.generator.approximate;
optimalVal.electrolyzerEnergy = NameValueArgs.OptVar.electrolyzer.energy;
optimalVal.electrolyzerRating = NameValueArgs.OptVar.electrolyzer.rating;

grid = NameValueArgs.Param.grid;
solar = NameValueArgs.Param.solar;
wind = NameValueArgs.Param.wind;
generator = NameValueArgs.Param.generator;
electrolyzer = NameValueArgs.Param.electrolyzer;
battery = NameValueArgs.Param.battery;
carbonTax = NameValueArgs.Param.carbonTax;

% Calculate the fuel consumption
if generator.available
    if strcmp(generator.type,'Diesel')
        a = 0.08415;
        b = 0.246;
        dieselConsumption = a*optimalVal.generatorRating+b*optimalVal.generatorLoading;
        generatorFuelCost = sum(dieselConsumption)*generator.fuelCost;
        generatorCarbonEmission = sum(optimalVal.generatorLoading.*NameValueArgs.TimeInterval)*carbonTax.generatorConversionFactor;
    else
        generatorFuelCost = sum(optimalVal.generatorApproximate*7.43/1000);
        generatorCarbonEmission = sum(optimalVal.generatorApproximate.*NameValueArgs.TimeInterval)*carbonTax.generatorConversionFactor;
    end
else
    generatorFuelCost = 0;
    generatorCarbonEmission = 0;
end

% Calculate the grid power cost
if  ~grid.bidirection
    if strcmp(grid.price,'Dynamic')
        gridPowerCost = sum(grid.importPrice.*power.grid);
    else
        gridPowerCost = grid.importPrice*sum(power.grid);
    end
else
    gridPowerCost = sum(optimalVal.gridPowerBuy)*grid.importPrice - sum(optimalVal.gridPowerSell)*grid.exportPrice + sum(optimalVal.zBuy + optimalVal.zSell);
end

peakDemandCharge = grid.peakDemand*optimalVal.gridPeakPower;
gridCarbonEmission = sum(power.grid.*NameValueArgs.TimeInterval)*carbonTax.gridConversionFactor;
totalHydrogen = optimalVal.electrolyzerEnergy(end)*electrolyzer.conversionFactor;

% Compute costs
cost.grid = gridPowerCost+peakDemandCharge;

cost.battery = optimalVal.batteryEnergyRating*battery.capex + optimalVal.batteryEnergyRating*battery.opex;

cost.solar = optimalVal.solarRating*solar.capex + optimalVal.solarRating*solar.opex*NameValueArgs.OptimizationSteps/8760;

cost.wind = optimalVal.windRating*wind.capex+optimalVal.windRating*wind.opex*NameValueArgs.OptimizationSteps/8760;

cost.electrolyzer = optimalVal.electrolyzerRating*electrolyzer.capex+optimalVal.electrolyzerRating*electrolyzer.opex*NameValueArgs.OptimizationSteps/8760-totalHydrogen*electrolyzer.hydrogenCost;

cost.generator = generator.capex*optimalVal.generatorRating+generatorFuelCost+generator.opex*optimalVal.generatorRating*NameValueArgs.OptimizationSteps/8760;

cost.carbonTax = (gridCarbonEmission+generatorCarbonEmission)*carbonTax.enable*carbonTax.penality;
end