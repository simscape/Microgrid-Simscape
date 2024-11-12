function generatorOptVar= generator(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for generator
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
    NameValueArgs.ReserveEnable {mustBeNonempty} = 0;
end
generator = NameValueArgs.Param;
%% Create optimization variables
if generator.available
    % Rated generator power
    name = 'generatorRating';
    type = 'continuous';
    varLength = 1;

    lowerBound = generator.minPowerRating;
    upperBound = generator.maxPowerRating;
    generatorRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % generator loading
    name = 'generatorLoading';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = generator.minLoading;
    upperBound = generator.maxLoading;
    generatorLoading = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);


    % generator Auxillary variables for natural gas generator
    name = 'generatorApproximate';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = generator.minLoading*generator.minPowerRating;
    upperBound = generator.maxLoading*generator.maxPowerRating;
    generatorApproximate = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    name = 'generatorLoadingNaturalGas';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = generator.minLoading/generator.maxPowerRating;
    upperBound = generator.maxLoading/generator.maxPowerRating;
    generatorLoadingNaturalGas = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    if NameValueArgs.ReserveEnable
        % Operating reserve
        name = 'generatorReserve';
        type = 'continuous';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = generator.maxLoading;
        generatorReserve = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        name = 'generatorReserveApproximate';
        type = 'continuous';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = generator.maxPowerRating;
        generatorReserveApproximate = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        name = 'generatorReserveRating';
        type = 'continuous';
        varLength = 1;
        lowerBound = 0;
        upperBound = generator.maxPowerRating*10;
        generatorReserveRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
    else
        generatorReserve = 0;
        generatorReserveApproximate = 0;
        generatorReserveRating = 0;
    end
else
    generatorRating = 0;
    generatorLoading = 0;
    generatorReserve = 0;
    generatorApproximate = 0;
    generatorReserveRating = 0;
    generatorReserveApproximate = 0;
    generatorLoadingNaturalGas = 0;
end
generatorOptVar.rating = generatorRating;
generatorOptVar.loading = generatorLoading;
generatorOptVar.reserve = generatorReserve;
generatorOptVar.approximate = generatorApproximate;
generatorOptVar.reserveRating  = generatorReserveRating;
generatorOptVar.reserveApproximate = generatorReserveApproximate;
generatorOptVar.loadingNaturalGas = generatorLoadingNaturalGas;
