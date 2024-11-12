logsout = out.logsout;
steps = 24*365;
tStep = 1;
simulation = 1;
simTime = logsout.get('pWind').Values.Time;
simWind = logsout.get('pWind').Values.Data;
simSolar = logsout.get('pSolar').Values.Data;
simBattery = logsout.get('pBattery').Values.Data;
simGenerator = logsout.get('pGenerator').Values.Data;
simGrid = logsout.get('pGrid').Values.Data;
simLoad = logsout.get('pLoad').Values.Data;
%
simSolar = simSolar(3:end);
simWind = simWind(3:end);
simBattery = simBattery(3:end);
simGenerator = simGenerator(3:end);
simGrid = simGrid(3:end);
simLoad = simLoad(3:end);
simTime = simTime(3:end);

% simSolar = simSolar(3:steps);
% simWind = simWind(3:steps);
% simBattery = simBattery(3:steps);
% simGenerator = simGenerator(3:steps);
% simGrid = simGrid(3:steps);
% simLoad = simLoad(3:steps);
% simTime = simTime(2:steps-1);

optTime = tStep:tStep:steps-2;
optWind = solution.windRating*normalizedWindPower(1:steps-2);
optSolar = solution.solarRating*normalizedSolarPower(1:steps-2);
optGenerator = solution.generatorLoading(1:steps-2);
optBattery = solution.batteryPower(1:steps-2);
optGrid = solution.gridPower(1:steps-2);
optLoad = loadPower.load8760(1:steps-2);

optWind = repelem(optWind,1/tStep);
optSolar = repelem(optSolar,1/tStep);
optGenerator = repelem(optGenerator,1/tStep);
optBattery = repelem(optBattery,1/tStep);
optGrid = repelem(optGrid,1/tStep);
optLoad = repelem(optLoad,1/tStep);

simTime = optTime;
plot_compareSimOpt_wind = figure('Name','plot_compareSimOpt_wind');
figure(plot_compareSimOpt_wind)
subplot(3,1,1)
plot(simTime,simWind,'LineWidth',1);
hold on;
plot(optTime,optWind,"LineWidth",1);
legend('Simulation','Optimization');
title('Wind Power Comparison','FontSize',10);

subplot(3,1,2)
windDifference = abs(simWind-optWind);
plot(optTime,windDifference,"LineWidth",1);
legend("Absolute Difference");

subplot(3,1,3)
windRelative = abs((optWind-simWind)./optWind);
plot(optTime,windRelative,"LineWidth",1);
legend("Relative Difference");


plot_compareSimOpt_solar = figure('Name','plot_compareSimOpt_solar');
figure(plot_compareSimOpt_solar)
subplot(3,1,1)
plot(simTime,simSolar,'LineWidth',1);
hold on;
plot(optTime,optSolar,"LineWidth",1);
legend('Simulation','Optimization');
title('Solar Power Comparison ','FontSize',10);

subplot(3,1,2)
solarDifference = simSolar-optSolar;
plot(optTime,solarDifference,"LineWidth",1);
legend("Absolute Difference");

subplot(3,1,3)
solarRelative = abs((optSolar-simSolar)./optSolar);
plot(optTime,solarRelative,"LineWidth",1);
legend("Relative Difference");

plot_compareSimOpt_battery = figure('Name','plot_compareSimOpt_battery');
figure(plot_compareSimOpt_battery)
subplot(3,1,1)
plot(simTime,simBattery,'LineWidth',1);
hold on;
plot(optTime,optBattery,"LineWidth",1);
legend('Simulation','Optimization');
title('Battery Power Comparison ','FontSize',10);

subplot(3,1,2)
batteryDifference = abs(simBattery-optBattery);
plot(optTime,batteryDifference,"LineWidth",1);
legend("Absolute Difference");

subplot(3,1,3)
batteryRelative = abs((optBattery-simBattery)./optBattery);
plot(optTime,batteryRelative,"LineWidth",1);
legend("Relative Difference");

plot_compareSimOpt_generator = figure('Name','plot_compareSimOpt_generator');
figure(plot_compareSimOpt_generator)
subplot(3,1,1)
plot(simTime,simGenerator,'LineWidth',1);
hold on;
plot(optTime,optGenerator,"LineWidth",1);
legend('Simulation','Optimization');
title('Generator Power Comparison ','FontSize',10);

subplot(3,1,2)
generatorDifference = simGenerator-optGenerator;
plot(optTime,generatorDifference,"LineWidth",1);
legend("Absolute Difference");

subplot(3,1,3)
generatorRelative = abs((optGenerator-simGenerator)./optGenerator);
plot(optTime,generatorRelative,"LineWidth",1);
legend("Relative Difference");

plot_compareSimOpt_grid = figure('Name','plot_compareSimOpt_grid');
figure(plot_compareSimOpt_grid)
subplot(3,1,1)
plot(simTime,simGrid,'LineWidth',1);
hold on;
plot(optTime,optGrid,"LineWidth",1);
legend('Simulation','Optimization');
title('Grid Power Comparison ','FontSize',10);

subplot(3,1,2)
gridDifference = simGrid-optGrid;
plot(optTime,gridDifference,"LineWidth",1);
legend("Absolute Difference");

subplot(3,1,3)
gridRelative = abs((optGrid-simLoad)./optGrid);
plot(optTime,gridRelative,"LineWidth",1);
legend("Relative Difference");

plot_compareSimOpt_load = figure('Name','plot_compareSimOpt_load');
figure(plot_compareSimOpt_load)
subplot(3,1,1)
plot(simTime,simLoad,'LineWidth',1);
hold on;
plot(optTime,optLoad,"LineWidth",1);
legend('Simulation','Optimization');
title('Load Power Comparison ','FontSize',10);

subplot(3,1,2)
loadDifference = simLoad-optLoad;
plot(optTime,loadDifference,"LineWidth",1);
legend("Absolute Difference");


subplot(3,1,3)
loadRelative = abs((optLoad-simLoad)./optLoad);
plot(optTime,loadRelative,"LineWidth",1);
legend("Relative Difference");