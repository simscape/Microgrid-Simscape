function windOptVar = wind(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for wind plant
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.ReserveEnable {mustBeNonempty} = 0;
end
wind = NameValueArgs.Param;
%% Create optimization variables
if wind.available
    name = 'windRating';
    type = 'continuous';
    varLength = 1;
    lowerBound = wind.minimumRating;
    upperBound = wind.maximumRating;
    windRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    if NameValueArgs.ReserveEnable
        name = 'windReserve';
        type = 'continuous';
        varLength = 1;
        lowerBound = 0;
        upperBound = wind.maximumRating;
        windReserve = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
    else
        windReserve = 0;
    end
else
    windRating = 0;
    windReserve = 0;
end
windOptVar.rating = windRating;
windOptVar.reserve = windReserve;