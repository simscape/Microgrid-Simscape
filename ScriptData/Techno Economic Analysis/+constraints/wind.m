function [normalizedWindPower,problem] = wind(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with wind plant
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.NormalizedPower {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
wind = NameValueArgs.Param;
normalizedWindPower = NameValueArgs.NormalizedPower;
problem = NameValueArgs.Problem;

% Constraints to make the wind power zero during the down time
if wind.downTime
    downTimeIndices = [];
    for downTimeIdx = 1:length(wind.startDownTime)
            downTimeIndices = [downTimeIndices,wind.startDownTime(downTimeIdx):wind.endDownTime(downTimeIdx)]; %#ok<*AGROW>
    end 
    normalizedWindPower(downTimeIndices) = 0;
end
