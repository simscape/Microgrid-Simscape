function lcoe = LCOE(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function plots the levelized costs of different assets in microgrid
arguments
    NameValueArgs.Solution {mustBeNonempty}
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.Cost {mustBeNonempty}
    NameValueArgs.NPV {mustBeNonempty}
    NameValueArgs.NormalizedPower {mustBeNonempty}
    NameValueArgs.Components {mustBeNonempty}
end
solution = NameValueArgs.Solution;
solar = NameValueArgs.Param.solar;
wind = NameValueArgs.Param.wind;
generator = NameValueArgs.Param.generator;
npv = NameValueArgs.NPV;
lcoe.components = {};
lcoe.data = [];
capitalRecoveryFactor = (npv.discountRate*(1+npv.discountRate)^npv.years)/((1+npv.discountRate)^npv.years-1);
%capitalRecoveryFactor = 1;
if any(contains(NameValueArgs.Components,'Grid'))
    levalizedCost.grid = sum(reshape(solution.gridPower,[],npv.years),1).*(NameValueArgs.Param.grid.importPrice).*npv.correctionFactor;
    energy.grid = sum(reshape(solution.gridPower,[],npv.years),1);
    lcoe.grid = sum(levalizedCost.grid)/sum(energy.grid);
    lcoe.components = {'Grid'};
    lcoe.data =[lcoe.data,lcoe.grid];
end

if any(contains(NameValueArgs.Components,'Solar'))
    levalizedCost.solar = solar.capex*solution.solarRating*capitalRecoveryFactor+sum(solar.opex*solution.solarRating*npv.correctionFactor);
    energy.solar = sum(solution.solarRating*reshape(NameValueArgs.NormalizedPower.solar,[],npv.years),1);
    lcoe.solar = sum(levalizedCost.solar)/sum(energy.solar);
    lcoe.components = [lcoe.components,'Solar'];
    lcoe.data =[lcoe.data,lcoe.solar];
end

if any(contains(NameValueArgs.Components,'Wind'))
    levalizedCost.wind = wind.capex*solution.windRating*capitalRecoveryFactor+sum(wind.opex*solution.windRating*npv.correctionFactor);
    energy.wind = sum(solution.windRating*reshape(NameValueArgs.NormalizedPower.wind,[],npv.years),1);
    lcoe.wind = sum(levalizedCost.wind)/sum(energy.wind);
    lcoe.components = [lcoe.components,'Wind'];
    lcoe.data =[lcoe.data,lcoe.wind];
end
   
if any(contains(NameValueArgs.Components,'Generator'))
    a = 0.08415;
    b = 0.246;
    for idx = 1:length(solution.generatorLoading)
        if solution.generatorLoading(idx) < 0.1
            fuelConsumption(idx) = 0; %#ok<*AGROW>
        else
            fuelConsumption(idx) = a*solution.generatorRating+b*solution.generatorLoading(idx);
        end
    end
    fuelCost = sum(reshape(fuelConsumption,[],npv.years),1);
    if solution.generatorRating == 0
        levalizedCost.generator = 0;
    else
        levalizedCost.generator = generator.capex*solution.generatorRating*capitalRecoveryFactor+sum(generator.opex*npv.correctionFactor)+sum(fuelCost);
    end
    energy.generator = sum(reshape(solution.generatorLoading,[],npv.years),1);
    if sum(energy.generator) > 0.1
        lcoe.generator = sum(levalizedCost.generator)/sum(energy.generator);
    else
        lcoe.generator = 0;
    end
    lcoe.components = [lcoe.components,'Generator'];
    lcoe.data =[lcoe.data,lcoe.generator];
end
end