function problem = generator(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with generator
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.Microgrid {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
generator = NameValueArgs.Param;
generatorOptVar = NameValueArgs.OptVar;
microgrid = NameValueArgs.Microgrid;
problem = NameValueArgs.Problem;

% Constraints to make the generator power and generator reserve power zero during the down time
if generator.downTime
    downTimeIndices = [];
    for downTimeIdx = 1:length(generator.startDownTime)
            downTimeIndices = [downTimeIndices,generator.startDownTime(downTimeIdx):generator.endDownTime(downTimeIdx)]; %#ok<*AGROW>
    end 
    generatorOptVar.loading.LowerBound(downTimeIndices) = 0;
    generatorOptVar.loading.UpperBound(downTimeIndices) = 0;

    generatorOptVar.reserve.LowerBound(downTimeIndices) = 0;
    generatorOptVar.reserve.UpperBound(downTimeIndices) = 0;

    generatorOptVar.approximate.LowerBound(downTimeIndices) = 0;
    generatorOptVar.approximate.UpperBound(downTimeIndices) = 0;
end

% Constraint to ensure generator loading is always less than it's rating
problem.Constraints.generatorLoadingCondition1 = generatorOptVar.loading <= generatorOptVar.rating;

if strcmp(generator.type,'Natural Gas')
    % Refer reference "McCormick Envelopes.", Cornell University, https://optimization.cbe.cornell.edu/index.php?title=McCormick_envelopes#References.
    % to forumalate these constraints
    % Constraint to ensure generator loading is always less than it's rating
    problem.Constraints.generatorLoadingCondition2 = generatorOptVar.approximate >= generatorOptVar.loadingNaturalGas;

    % Constraints for under estimator
    problem.Constraints.generatorLoadingUnderEstimator1 = generatorOptVar.approximate >= (generator.minPowerRating*generatorOptVar.loadingNaturalGas+generatorOptVar.rating*(generator.minLoading/generator.maxPowerRating)-(generator.minLoading/generator.maxPowerRating)*generator.minPowerRating);
    problem.Constraints.generatorLoadingUnderEstimator2 = generatorOptVar.approximate >= (generator.maxPowerRating*generatorOptVar.loadingNaturalGas+generatorOptVar.rating*(generator.maxLoading/generator.maxPowerRating)-(generator.maxLoading/generator.maxPowerRating)*generator.maxPowerRating);

    % Constraints for under estimator
    problem.Constraints.generatorLoadingOverEstimator1 = generatorOptVar.approximate <= (generator.maxPowerRating*generatorOptVar.loadingNaturalGas+generatorOptVar.rating*(generator.minLoading/generator.maxPowerRating)-(generator.minLoading/generator.maxPowerRating)*generator.maxPowerRating);
    problem.Constraints.generatorLoadingOverEstimator2 = generatorOptVar.approximate <= ((generator.maxLoading/generator.maxPowerRating)*generatorOptVar.rating+generatorOptVar.loadingNaturalGas*generator.minPowerRating-(generator.maxLoading/generator.maxPowerRating)*generator.minPowerRating);
end

if microgrid.operatingReserveEnable
    problem.Constraints.generatorReserveLoading = generatorOptVar.reserve <= generatorOptVar.reserveRating;
end
end