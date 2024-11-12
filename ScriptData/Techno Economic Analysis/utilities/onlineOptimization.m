function [pRefBattery,pRefGenerator,loadShedding] = onlineOptimization(grid,battery,loadForecast,renewableForecast,generator,optimizationSteps,timeInterval)
name = 'gridPower';
type = 'continuous';
varLength = optimizationSteps;
lowerBound = grid.minPower;
upperBound = grid.maxPower;
gridPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

name = 'batteryPower';
type = 'continuous';
varLength = optimizationSteps;
lowerBound = battery.minPower;
upperBound = battery.maxPower;
batteryPower = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

name = 'batteryEnergy';
type = 'continuous';
varLength = optimizationSteps;
lowerBound = 0;
upperBound = battery.energyRating;
batteryEnergy = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

% Generator loading
name = 'generatorLoading';
type = 'continuous';
varLength = optimizationSteps;
lowerBound = 0;
upperBound = 1;
generatorLoading = createOptimizationVariable(name,varLength,type,lowerBound,upperBound);

% Create optimization problem
problem = optimproblem("ObjectiveSense","min");

%% Constraints for battery
% Energy balance constraint
% Create a constraint for battery energy balance whose length is equal to
% the optimization time steps
problem.Constraints.energyBalance               =  optimconstr(optimizationSteps);

% Create a constraint to ensure the initial energy of the battery is equal
% to the corresponding set initial SOC
problem.Constraints.energyBalance(1)            =  batteryEnergy(1) == battery.energyRating*battery.initialSOC;

% Create a constraint to ensure that at every instant, battery energy is
% equal to the difference of previous battery energy value and the product
% of battery power and the optimization time step. This can be formulated
% using the equation E(t) = E(t-1) - P(t)*t where E(t) is the energy at time
% interval 't' and P(t) is the corresponding power.
problem.Constraints.energyBalance(2:optimizationSteps)      =  batteryEnergy(2:optimizationSteps) == batteryEnergy(1:optimizationSteps-1) - batteryPower(2:optimizationSteps)*timeInterval;

% Create a constraint to ensure battery never operates below the set
% minimum SOC
%problem.Constraints.minimumSOC                  =  batteryEnergy <= battery.energyRating*battery.maxSOC;%*linspace(1,1-battery.degradation,optimizationSteps)';

% Create a constraint to ensure battery never operates beyond the set
% maximum SOC
%problem.Constraints.maximumSOC                     =  batteryEnergy >= battery.energyRating*battery.minSOC;%*linspace(1,1-degradationEnergy,optimizationSteps)'

%% Power balance constraints
problem.Constraints.powerBalance = loadForecast == gridPower + batteryPower + renewableForecast + generatorLoading*generator.rating;

%% Cost function
% Fuel cost
a = 0.08415;
b = 0.246;
if generator.fuel == 1
    fuelConsumption = a*generator.rating+b*generatorLoading*generator.rating;
else
    fuelConsumption = generator.rating*generatorLoading*7.43/1000;
end
cost = sum(gridPower)/1000*grid.cost+sum(fuelConsumption)*generator.fuelCost;%+sum(batteryPower)*battery.opex;

problem.Objective = cost;
options = optimoptions('linprog','Algorithm','interior-point','Display', 'none','OptimalityTolerance',1e-2);
[solution,~,exitFlag,~,~] = solve(problem,"Solver","linprog","Options",options);
if exitFlag > 0
    pRefBattery = solution.batteryPower;
    pRefGenerator = solution.generatorLoading;
    loadShedding = 0;

elseif any(loadForecast > grid.maxPower)
    loadShedding = 1;
    pRefBattery = battery.forecast;
    pRefGenerator = generator.forecast;
else
    pRefBattery = battery.forecast;
    pRefGenerator = generator.forecast;
    loadShedding = 0;
end