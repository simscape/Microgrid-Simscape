function [problem,powerBalance] = grid(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with grid NameValueArgs.PowerVal
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.OptVar {mustBeNonempty}
    NameValueArgs.PowerVal {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
grid = NameValueArgs.Param;
problem = NameValueArgs.Problem;

% Constraints to make the grid NameValueArgs.PowerVal zero during the down time
if grid.downTime
    downTimeIndices = [];
    for downTimeIdx = 1:length(grid.startDownTime)
        downTimeIndices = [downTimeIndices,grid.startDownTime(downTimeIdx):grid.endDownTime(downTimeIdx)]; %#ok<*AGROW>
    end
    NameValueArgs.PowerVal.LowerBound(downTimeIndices) = 0;
    NameValueArgs.PowerVal.UpperBound(downTimeIndices) = 0;
end

if grid.bidirection
    problem.Constraints.buyingGridPower = NameValueArgs.OptVar.gridPowerBuy <= grid.maxImportPower*NameValueArgs.OptVar.zBuy;
    problem.Constraints.sellingGridPower = NameValueArgs.OptVar.gridPowerSell <= grid.maxExportPower*NameValueArgs.OptVar.zSell;
    problem.Constraints.buyOrSell = NameValueArgs.OptVar.zBuy + NameValueArgs.OptVar.zSell <= 1;
end

powerBalance = NameValueArgs.PowerVal.load+NameValueArgs.PowerVal.electrolyzer == NameValueArgs.PowerVal.grid+NameValueArgs.PowerVal.battery+NameValueArgs.PowerVal.solar+NameValueArgs.PowerVal.wind+NameValueArgs.PowerVal.generator;

if grid.peakDemand
    problem.Constraints.maxPeakPower = NameValueArgs.PowerVal.gridPeak >= NameValueArgs.PowerVal.grid;
end
end
