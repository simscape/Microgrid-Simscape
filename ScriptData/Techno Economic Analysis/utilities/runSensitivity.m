function [batteryEnergyRating,solarRating,windRating,generatorRating,cost] = runSensitivity(variable,value)   %#ok<*STOUT>
% Copyright 2024 The MathWorks, Inc.
    
% This function performs the sensitivity analysis
MicrogridTechnoEconomic;
switch variable
    case 'Grid Price'
        grid.importPrice = value; %#ok<*STRNU>
    case 'Discount Rate'
        discountRate = value; %#ok<*NASGU>
    case 'PV Capex'
        solar.capex = value;
    case 'Wind Capex'
        wind.capex = value;
    case 'Battery Capex'
        battery.capex = value;
end
    OptimizeMicrogrid;
    batteryEnergyRating = solution.batteryEnergyRating;
    solarRating = solution.solarRating;
    windRating = solution.windRating;
    generatorRating = solution.generatorRating;
    cost = fVal;
end