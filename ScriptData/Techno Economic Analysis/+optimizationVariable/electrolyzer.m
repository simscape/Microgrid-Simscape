function electrolyzerOptVar = electrolyzer(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for electrolyzer
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty} = 0;
end
electrolyzer = NameValueArgs.Param;
%% Create optimization variables
if electrolyzer.available
    % Optimization variable for electrolyzer rating
    name = 'electrolyzerRating';
    type = 'continuous';
    varLength = 1;
    lowerBound = electrolyzer.minRating;
    upperBound = electrolyzer.maxRating;
    electrolyzerRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % Optimization variable for electrolyzer capacity
    name = 'electrolyzerCapacity';
    type = 'continuous';
    varLength = 1;
    lowerBound = electrolyzer.minCapacity;
    upperBound = electrolyzer.maxCapacity;
    electrolyzerCapacity = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % Optimization variable for electrolyzer power
    name = 'electrolyzerPower';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = electrolyzer.minPower;
    upperBound = electrolyzer.maxPower;
    electrolyzerPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % Optimization variable for electrolyzer power
    name = 'electrolyzerEnergy';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = electrolyzer.minEnergy;
    upperBound = electrolyzer.maxEnergy;
    electrolyzerEnergy = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
else
    electrolyzerRating = 0;
    electrolyzerCapacity = 0;
    electrolyzerPower = 0;
    electrolyzerEnergy = 0;
end
electrolyzerOptVar.rating = electrolyzerRating;
electrolyzerOptVar.capacity = electrolyzerCapacity;
electrolyzerOptVar.power = electrolyzerPower;
electrolyzerOptVar.energy = electrolyzerEnergy;