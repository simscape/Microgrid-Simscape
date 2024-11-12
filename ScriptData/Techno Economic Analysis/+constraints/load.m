function [problem,powerBalance] = load(NameValueArgs)

% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with load shifting
% strategy
arguments
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.GridParam {mustBeNonempty}
    NameValueArgs.PowerVal {mustBeNonempty}
    NameValueArgs.Microgrid {mustBeNonempty}
    NameValueArgs.OptimizationSteps {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
loadOptVar =  NameValueArgs.OptVar;
grid = NameValueArgs.GridParam;
power = NameValueArgs.PowerVal;
microgrid = NameValueArgs.Microgrid;
problem = NameValueArgs.Problem;

% Constraints for load shifting

% Initialize the indices for load shifting strategy
loadShiftingIndices = [];

% Get the indices corresponding to the peak demand and create a
% constraint to ensure the total load during the peak demand is the
% difference of the actual load and the shiftable load
days = NameValueArgs.OptimizationSteps/24;
if strcmp(microgrid.DSMType,'Threshold based')
    loadShiftingIndices = find(power.load > microgrid.peakLoadThreshold);
    loadOptVar.actualLoad.UpperBound = microgrid.peakLoadThreshold;
else
    for dayIdx = 1:days
        dayOffset = (dayIdx - 1) * 24;
        for peakIdx = 1:length(grid.peakStartTime)
            loadShiftingIndices = [loadShiftingIndices,(grid.peakStartTime(peakIdx):grid.peakEndTime(peakIdx))+dayOffset]; %#ok<*AGROW>
        end
    end
end
nonShiftingIndices = setdiff(1:length(loadOptVar.shiftableLoad),loadShiftingIndices);

% Make the optimal shifted load zero during peak hours
loadOptVar.optimalShiftedLoad.LowerBound(loadShiftingIndices) = 0;
loadOptVar.optimalShiftedLoad.UpperBound(loadShiftingIndices) = 0;

loadOptVar.shiftableLoad.LowerBound(nonShiftingIndices) = 0;
loadOptVar.shiftableLoad.UpperBound(nonShiftingIndices) = 0;

% Create a constraint to ensure that load lost during the peak hours is
% accomodated during the off peak hours for very day
problem.Constraints.loadShiftingPeak = optimconstr(days);
problem.Constraints.loadShiftingNonPeak = optimconstr(days);
problem.Constraints.optimalLoadBalance = optimconstr(days);
for dayIdx = 1:days
    startIdx = (dayIdx - 1) * 24 + 1;
    endIdx = dayIdx * 24;
    dailyShiftIdx = loadShiftingIndices(loadShiftingIndices >= startIdx & loadShiftingIndices <= endIdx);
    dailyNonShiftIdx = nonShiftingIndices(nonShiftingIndices >= startIdx & nonShiftingIndices <= endIdx);
    problem.Constraints.loadShiftingPeak(dayIdx) = sum(loadOptVar.actualLoad(dailyShiftIdx)) == sum(power.load(dailyShiftIdx))-sum(loadOptVar.shiftableLoad(dailyShiftIdx));
    problem.Constraints.loadShiftingNonPeak(dayIdx)  = sum(loadOptVar.actualLoad(dailyNonShiftIdx)) == sum(power.load(dailyNonShiftIdx))+sum(loadOptVar.optimalShiftedLoad(dailyNonShiftIdx));
    % Create a constraint to ensure that the load energy lost during the
    % peak hours is equal to the load energy added during the off peak
    % hours
    problem.Constraints.optimalLoadBalance(dayIdx)         =  sum(loadOptVar.optimalShiftedLoad(startIdx:endIdx)) == sum(loadOptVar.shiftableLoad(startIdx:endIdx));
end


% Constraint to ensure the overall energy requirement of the is met
% after the load shifting strategy
problem.Constraints.loadBalance = sum(loadOptVar.actualLoad) == sum(power.load);


% Constraint to ensure that battery always discharges during peak loading
%problem.Constraints.batteryPeakHours = batteryPower <= -0.1;

% Constraints for power balance
powerBalance = loadOptVar.actualLoad+power.electrolyzer == ...
    power.grid+power.battery+power.solar+power.wind+power.generator;