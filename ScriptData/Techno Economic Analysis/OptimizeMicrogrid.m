% Copyright 2024 The MathWorks, Inc.

% This script creates different optimization variables and formulates the
% microgrid optimization problem

% Create optimization problem
problem = optimproblem("ObjectiveSense","min");

% Number of optimization steps
optStepsTotal = 24*365*years;

%% Create optimization variables
% Grid
gridOptVar = optimizationVariable.grid(Param = grid,OptimizationSteps = optStepsTotal);

% Solar
solarOptVar = optimizationVariable.solar(Param = solar,ReserveEnable = microgrid.operatingReserveEnable);

% Wind
windOptVar = optimizationVariable.wind(Param = wind,ReserveEnable = microgrid.operatingReserveEnable);

% Generator
generatorOptVar = optimizationVariable.generator(Param = generator,OptimizationSteps = optStepsTotal,...
    ReserveEnable = microgrid.operatingReserveEnable);

% Electrolyzer
electrolyzerOptVar = optimizationVariable.electrolyzer(Param = electrolyzer,OptimizationSteps = optStepsTotal);

% Battery
batteryOptVar = optimizationVariable.battery(Param = battery,OptimizationSteps = optStepsTotal);

% Loads
if microgrid.DSM
    loadOptVar= optimizationVariable.load(Load = loadPower,MaxLoadShift = microgrid.maxLoadShift,...
        OptimizationSteps = optStepsTotal);   
% else
%     loadOptVar.power = loadPower;
end

%% Formualate constraints

% Formulate structure for the avilable powers in the microgrid
if ~grid.bidirection  
    power.grid = gridOptVar.power;   
else
    power.grid = gridOptVar.gridPowerBuy-gridOptVar.gridPowerSell;
end

power.gridPeak = gridOptVar.peakPower;
power.solar = normalizedSolarPower*(solarOptVar.rating-solarOptVar.reserve);
power.wind = normalizedWindPower*(windOptVar.rating-windOptVar.reserve);
if strcmp(generator.type,'Diesel')
    power.generator = generatorOptVar.loading;
else
    power.generator = generatorOptVar.approximate;
end
power.battery = batteryOptVar.power;
power.load = loadPower;%loadOptVar.power;
power.electrolyzer = electrolyzerOptVar.power;

% Grid
if grid.available
  [problem,powerBalance] = constraints.grid(Param = grid,OptVar = gridOptVar,PowerVal = power,Problem = problem);   
else
    powerBalance = power.load+power.electrolyzer == power.grid+power.battery+power.solar+power.wind+power.generator; 
end

% Solar
if solar.available
  [normalizedSolarPower,problem] = constraints.solar(Param = solar,NormalizedPower = normalizedSolarPower,Problem = problem);   
end

% Wind
if wind.available
  [normalizedWindPower,problem] = constraints.wind(Param = wind,NormalizedPower = normalizedWindPower,Problem = problem);   
end

% Generator
if generator.available
    problem = constraints.generator(Param = generator,OptVar = generatorOptVar,Microgrid = microgrid...
        ,Problem = problem);
end

% Battery
if battery.available
    problem = constraints.battery(Param = battery,OptVar = batteryOptVar,OptimizationSteps = optStepsTotal,...
        TimeInterval = timeStep,Problem = problem);
end

% Electrolyzer
if electrolyzer.available
    problem = constraints.electrolyzer(Param = electrolyzer,OptVar = electrolyzerOptVar,PowerVal = power...
        ,OptimizationSteps = optStepsTotal,TimeInterval = timeStep,Problem = problem);
end

% Load 
if microgrid.DSM
    [problem,powerBalance] = constraints.load(OptVar = loadOptVar,GridParam = grid,PowerVal = power,...
        Microgrid = microgrid,OptimizationSteps = optStepsTotal,Problem = problem);
end

% Minimum renewable penetration
if microgrid.enableMinRenewables
    problem.Constraints.renewablePenetration = solarOptVar.rating*sum(normalizedSolarPower)+windOptVar.rating*sum(normalizedWindPower) >= microgrid.renewablePenetration*sum(power.load)/100; 
end

% Operating reserve and power balance
if microgrid.operatingReserveEnable
    reserveBalance = microgrid.operatingReserve == ...
        solarOptVar.reserve*normalizedSolarPower+windOptVar.reserve*normalizedWindPower+...
        generatorOptVar.reserve;
    problem.Constraints.reserveBalance = reserveBalance;
end

problem.Constraints.powerBalance = powerBalance;


%% Cost computation
componentParam.grid = grid;
componentParam.solar = solar;
componentParam.wind = wind;
componentParam.battery = battery;
componentParam.generator = generator;
componentParam.electrolyzer = electrolyzer;
componentParam.carbonTax = carbonTax;

componentOptVar.grid = gridOptVar;
componentOptVar.solar = solarOptVar;
componentOptVar.wind = windOptVar;
componentOptVar.battery = batteryOptVar;
componentOptVar.generator = generatorOptVar;
componentOptVar.electrolyzer = electrolyzerOptVar;

cost = getValues.totalCost(Param = componentParam,OptVar = componentOptVar,OptimizationSteps = optStepsTotal...
    ,TimeInterval = timeStep,PowerVal = power);

% Formulate the objective function
NPVCorrection = 1./((1+discountRate).^(0:years-1));

if microgrid.NPV
    totalCost = sum((cost.grid+cost.generator+cost.electrolyzer+cost.carbonTax).*NPVCorrection)+cost.battery+cost.solar+cost.wind;
else
    totalCost = cost.grid+cost.battery+cost.solar+cost.wind+cost.generator+cost.electrolyzer+cost.carbonTax;
end
problem.Objective = totalCost;

% Solve the optimzation problem

if ~grid.bidirection
    options = optimoptions('linprog','Display','none','OptimalityTolerance',1e-2,'ConstraintTolerance',1e-3);
    [solution,fVal,exitFlag,output] = solve(problem,"Solver","linprog","Options",options);
else
    options = optimoptions('intlinprog','Algorithm','legacy','Display','none','LPOptimalityTolerance',1e-2,'RelativeGapTolerance',1e-2,'ObjectiveImprovementThreshold',1e-4,'IntegerTolerance',0.001,'IntegerPreprocess','advanced');
    [solution,fVal,exitFlag,output] = solve(problem,"Solver","intlinprog","Options",options);
end

if ~microgrid.DSM
    solution.actualLoad = loadPower;
end

if isfield(solution,'generatorLoadingNaturalGas')
    solution.generatorLoading = solution.generatorApproximate;
end

if grid.available
    if grid.bidirection
        solution.finalGridPower = (solution.gridPowerBuy - solution.gridPowerSell);
    else
        solution.finalGridPower = solution.gridPower;
    end
else
    solution.finalGridPower = 0;
end

if electrolyzer.available
    solution.electrolyzerConsumption = solution.electrolyzerPower;
else
    solution.electrolyzerConsumption = 0;
end

if exitFlag == -2
    exitText = 'Please re-visit optimization variable bounds and constraints';
    warning(exitText)
end








