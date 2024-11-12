function problem = electrolyzer(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.PowerVal {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
    NameValueArgs.TimeInterval {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
electrolyzer = NameValueArgs.Param;
electrolyzerOptVar = NameValueArgs.OptVar;
problem = NameValueArgs.Problem;
power = NameValueArgs.PowerVal;

% This function formulates constraints associated with elctrolyzer
% Create constraints for energy balance
problem.Constraints.electrolyzerEnergyBalance               =  optimconstr(NameValueArgs.OptimizationSteps);
problem.Constraints.electrolyzerEnergyBalance(1)            =  electrolyzerOptVar.energy(1) == electrolyzerOptVar.power(1);
problem.Constraints.electrolyzerEnergyBalance(2:NameValueArgs.OptimizationSteps)   =  electrolyzerOptVar.energy(2:NameValueArgs.OptimizationSteps) == electrolyzerOptVar.energy(1:NameValueArgs.OptimizationSteps-1) + electrolyzerOptVar.power(2:NameValueArgs.OptimizationSteps)*NameValueArgs.TimeInterval;

% Create constraints for electrolyzer capacity
problem.Constraints.electrolyzerChargeUpper                 =  optimconstr(NameValueArgs.OptimizationSteps-1);
problem.Constraints.electrolyzerChargeUpper                 =  electrolyzerOptVar.energy(1:NameValueArgs.OptimizationSteps-1) <= electrolyzerOptVar.capacity*electrolyzer.conversionFactor;
problem.Constraints.electrolyzerChargeFinal                 =  electrolyzerOptVar.energy(NameValueArgs.OptimizationSteps) == electrolyzerOptVar.capacity*electrolyzer.conversionFactor;

% Create constraints for electrolyzer power
problem.Constraints.electrolyzerPowerUpper                 =  electrolyzerOptVar.power(1:NameValueArgs.OptimizationSteps)  <=  electrolyzerOptVar.rating;

% Create a constraint if the green hydrogen production is enabled
if electrolyzer.greenProduction
    problem.Constraints.electrolyzerPowerUpper2                 =  electrolyzerOptVar.power  <=  power.solar + power.wind + power.battery;
end