function loadOptVar = load(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for the shitable load for
% demand side management of the microgrid
arguments
    NameValueArgs.Load {mustBeNonempty}
    NameValueArgs.MaxLoadShift {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
end
load = NameValueArgs.Load;
%% Create optimization variables
    % Actual load after load shifting
    name = 'actualLoad';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = min(load);
    upperBound = max(load);
    actualLoad = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % Load that can be shifted during peak demand
    name = 'shiftableLoad';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = 0;
    upperBound = NameValueArgs.MaxLoadShift;
    shiftableLoad = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % Load that should be compensated for the shifted load during the non
    % peak loading 
    name = 'optimalShiftedLoad';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = 0;
    upperBound = max(load);
    optimalShiftedLoad = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    loadOptVar.actualLoad = actualLoad;
    loadOptVar.shiftableLoad = shiftableLoad;
    loadOptVar.optimalShiftedLoad = optimalShiftedLoad;