function batteryOptVar= battery(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function creates optimization variables for the battery
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty} = 0;
end
battery = NameValueArgs.Param;

%% Create optimization variables
if battery.available
    % battery energy rating
    name = 'batteryEnergyRating';
    type = 'continuous';
    varLength = 1;
    lowerBound = battery.minEnergyRating;
    upperBound = battery.maxEnergyRating;
    batteryEnergyRating = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % battery power
    name = 'batteryPower';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = battery.minPower;
    upperBound = battery.maxPower;
    batteryPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

    % battery energy
    name = 'batteryEnergy';
    type = 'continuous';
    varLength = NameValueArgs.OptimizationSteps;
    lowerBound = battery.minEnergyRating;
    upperBound = battery.maxEnergyRating;
    batteryEnergy = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);
else
    batteryEnergyRating = 0;
    batteryPower = 0;
    batteryEnergy = 0;
end
batteryOptVar.energyRating = batteryEnergyRating;
batteryOptVar.power = batteryPower;
batteryOptVar.energy = batteryEnergy;