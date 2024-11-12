function gridOptVar = grid(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for grid power 
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBePositive} 
end
grid = NameValueArgs.Param;
%% Create optimization variables
if grid.available

    if ~grid.bidirection
        % Optimization variable for grid power
        name = 'gridPower';
        type = 'continuous';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = -grid.maxExportPower;
        upperBound = grid.maxImportPower;
        gridPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        gridPowerBuy = 0;
        gridPowerSell = 0;
        zBuy = 0;
        zSell = 0;
    else
        % Optimization variable for grid power
        name = 'gridPowerBuy';
        type = 'continuous';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = grid.maxImportPower;
        gridPowerBuy = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        % Optimization variable for grid power
        name = 'gridPowerSell';
        type = 'continuous';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = grid.maxExportPower;
        gridPowerSell = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        % Optimization variable for grid power
        name = 'zBuy';
        type = 'integer';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = 1;
        zBuy = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

        name = 'zSell';
        type = 'integer';
        varLength = NameValueArgs.OptimizationSteps;
        lowerBound = 0;
        upperBound = 1;
        zSell = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
        
        gridPower = 0;
    end
    
    % Optimization variable for including peak demand cost
    if grid.peakDemand   
        name = 'peakPower';
        type = 'continuous';
        varLength = 1;
        lowerBound = 0;
        upperBound = grid.maxImportPower;
        peakPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
    else
        peakPower = 0;
    end

    % Optimization variables for bi-directional power flow

else
    gridPower = 0;
    peakPower = 0;
    gridPowerBuy = 0;
    gridPowerSell = 0;
    zBuy = 0;
    zSell = 0;
end
gridOptVar.power = gridPower;
gridOptVar.peakPower = peakPower;
gridOptVar.gridPowerBuy = gridPowerBuy;
gridOptVar.gridPowerSell = gridPowerSell;
gridOptVar.zBuy = zBuy;
gridOptVar.zSell = zSell;