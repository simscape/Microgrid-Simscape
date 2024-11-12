function capacityFactor = capacityFactor(Solution,NormalizedPower,NPV)
% Copyright 2024 The MathWorks, Inc.

% This function calculates the capacity factors for different assets
arguments
    Solution {mustBeNonempty}
    NormalizedPower {mustBeNonempty}
    NPV {mustBeNonempty}
end
if Solution.solarRating > 0
    capacityFactor.solar = 100*sum(NormalizedPower.solar.*Solution.solarRating)/(Solution.solarRating*NPV.years*365*24);
else
    capacityFactor.solar = 0;
end
if Solution.windRating > 0
    capacityFactor.wind = 100*sum(NormalizedPower.wind.*Solution.windRating)/(Solution.windRating*NPV.years*365*24);
else
    capacityFactor.wind = 0;
end
if Solution.generatorRating > 0
    capacityFactor.generator = 100*sum(Solution.generatorLoading)/(Solution.generatorRating*NPV.years*365*24);
else
    capacityFactor.generator = 0;
end
monthlyNormSolarPower = reshape(getMonthlyData(NormalizedPower.solar),[],NPV.years*12);
monthlyNormWindPower = reshape(getMonthlyData(NormalizedPower.wind),[],NPV.years*12);
monthlyGenLoading = reshape(getMonthlyData(Solution.generatorLoading),[],NPV.years*12);

for monthIdx = 1:NPV.years*12
    capacityFactor.solarMonthly{monthIdx} = 100*sum(monthlyNormSolarPower{monthIdx}.*Solution.solarRating)./(Solution.solarRating*length(monthlyNormSolarPower{monthIdx}));
    capacityFactor.windMonthly{monthIdx} = 100*sum(monthlyNormWindPower{monthIdx}.*Solution.windRating)./(Solution.windRating*length(monthlyNormWindPower{monthIdx}));
    capacityFactor.generatorMonthly{monthIdx} = 100*sum(monthlyGenLoading{monthIdx})./(Solution.generatorRating*length(monthlyGenLoading{monthIdx}));
end
end
