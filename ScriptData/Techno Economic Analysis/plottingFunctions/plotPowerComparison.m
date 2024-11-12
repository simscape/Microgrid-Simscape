function plotPowerComparison(component,steps,tStep,titleName,logsout,figureName)
% Copyright 2024 The MathWorks, Inc.

% This function plots power output from different assets and compare with
% the power output of the optmization

simTime = logsout.get(component.name).Values.Time;
simAsset = logsout.get(component.name).Values.Data;
simTime = simTime(2:end-1);
simAsset = simAsset(3:end);

% Wind power from optimization
optTime = tStep:tStep:steps-2;
optAssetPower = component.power;

figure('Name',figureName)
plot(simTime,simAsset,'LineWidth',1);
hold on;
plot(optTime,optAssetPower,"LineWidth",1);
legend('Simulation','Optimization');
title(titleName,'FontSize',10);
grid on;
end