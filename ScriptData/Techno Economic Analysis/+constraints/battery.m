function problem = battery(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with battery
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
    NameValueArgs.TimeInterval {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
battery = NameValueArgs.Param;
batteryOptVar = NameValueArgs.OptVar;
problem = NameValueArgs.Problem;

% Constraints to make the battery power zero during the down time
if battery.downTime
    downTimeIndices = [];
    for downTimeIdx = 1:length(battery.startDownTime)
            downTimeIndices = [downTimeIndices,battery.startDownTime(downTimeIdx):battery.endDownTime(downTimeIdx)]; %#ok<*AGROW>
    end
    batteryOptVar.power.LowerBound(downTimeIndices) = 0;
    batteryOptVar.power.UpperBound(downTimeIndices) = 0;
end

% Create a constraint for battery energy balance whose length is equal to
% the optimization time steps
problem.Constraints.energyBalance               =  optimconstr(NameValueArgs.OptimizationSteps);

% Create a constraint to ensure the initial energy of the battery is equal
% to the corresponding set initial SOC
problem.Constraints.energyBalance(1)            =  batteryOptVar.energy(1) == batteryOptVar.energyRating*battery.initialSOC;

% Create a constraint to ensure that at every instant, battery energy is
% equal to the difference of previous battery energy value and the product 
% of battery power and the optimization time step. This can be formulated 
% using the equation E(t) = E(t-1) - P(t)*t where E(t) is the energy at time
% interval 't' and P(t) is the corresponding power.
problem.Constraints.energyBalance(2:NameValueArgs.OptimizationSteps)      =  batteryOptVar.energy(2:NameValueArgs.OptimizationSteps) == batteryOptVar.energy(1:NameValueArgs.OptimizationSteps-1)*battery.roundTripEff - batteryOptVar.power(2:NameValueArgs.OptimizationSteps)*NameValueArgs.TimeInterval;

% Create a constraint to ensure battery never operates below the set
% minimum SOC
problem.Constraints.minimumSOC                  =  batteryOptVar.energy <= batteryOptVar.energyRating*battery.maxOperatingSOC;%*linspace(1,1-battery.degradation,NameValueArgs.OptimizationSteps)';

% Create a constraint to ensure battery never operates beyond the set
% maximum SOC
problem.Constraints.maximumSOC                     =  batteryOptVar.energy >= batteryOptVar.energyRating*battery.minOperatingSOC;%*linspace(1,1-degradationEnergy,NameValueArgs.OptimizationSteps)'
