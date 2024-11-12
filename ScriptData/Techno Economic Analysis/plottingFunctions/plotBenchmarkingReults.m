function plotBenchmarkingReults(simOut,element,solution,normalizedPower,steps,tStep)
% Copyright 2024 The MathWorks, Inc.

% This function plots power output from different assets and compare with
% the power output of the optmization

if any(contains(element,'Wind'))
    % Wind power from simulation
    component.name = 'pWind';
    component.power = solution.windRating*normalizedPower.wind(1:steps-2);
    component.rating = solution.windRating;
    titleName = 'Wind Power Comparison';
    figureName = titleName;
    plotPowerComparison(component,steps,tStep,titleName,simOut.logsout,figureName);
end

if any(contains(element,'Solar'))
    % Wind power from simulation
    component.name = 'pSolar';
    component.power = solution.solarRating*normalizedPower.solar(1:steps-2);
    titleName = 'Wind Power Comparison';
    figureName = titleName;
    plotPowerComparison(component,steps,tStep,titleName,simOut.logsout,figureName);
end

if any(contains(element,'Battery'))
    % Wind power from simulation
    component.name = 'pBattery';
    component.rating = solution.batteryPower;
    titleName = 'Battery Power Comparison';
    figureName = titleName;
    plotPowerComparison(component,steps,tStep,titleName,simOut.logsout,figureName);
end

if any(contains(element,'Generator'))
    % Wind power from simulation
    component.name = 'pGenerator';
    component.rating = solution.generatorApproximate;
    titleName = 'Generator Power Comparison';
end

if any(contains(element,'Grid'))
    % Wind power from simulation
    component.name = 'pGrid';
    component.rating = solution.gridPower;
    titleName = 'Grid Power Comparison';
    figureName = titleName;
    plotPowerComparison(component,steps,tStep,titleName,simOut.logsout,figureName);
end

if any(contains(element,'Load'))
    % Wind power from simulation
    component.name = 'pLoad';
    component.rating = normalizedPower.load;
    titleName = 'Load Power Comparison';
    figureName = titleName;
    plotPowerComparison(component,steps,tStep,titleName,simOut.logsout,figureName);
end

end