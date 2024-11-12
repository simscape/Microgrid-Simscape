function solarOptVariable = solar(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for solar plant
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.ReserveEnable {mustBeNonempty} = 0;
end
solar = NameValueArgs.Param;
%% Create optimization variables
if solar.available
    name = 'solarRating';
    type = 'continuous';
    varLength = 1;
    lowerBound = solar.minimumRating;
    upperBound = solar.maximumRating;
    solarRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
    
    if NameValueArgs.ReserveEnable
        name = 'solarReserve';
        type = 'continuous';
        varLength = 1;
        lowerBound = 0;
        upperBound = solar.maximumRating;
        solarReserve = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
    else
        solarReserve = 0;
    end
else
    solarRating = 0;
    solarReserve = 0;
end
solarOptVariable.rating = solarRating;
solarOptVariable.reserve = solarReserve;