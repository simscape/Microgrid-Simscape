function [normalizedSolarPower,problem] = solar(NameValueArgs)
% Copyright 2024 The MathWorks, Inc.

% This function formulates constraints associated with solar plant
arguments
    NameValueArgs.Param {mustBeNonempty}
    NameValueArgs.NormalizedPower {mustBeNonempty}
    NameValueArgs.Problem {mustBeNonempty}
end
solar = NameValueArgs.Param;
normalizedSolarPower = NameValueArgs.NormalizedPower;
problem = NameValueArgs.Problem;

% Constraints to make the solar power zero during the down time
if solar.downTime
    downTimeIndices = [];
    for downTimeIdx = 1:length(wind.startDownTime)
            downTimeIndices = [downTimeIndices,solar.startDownTime(downTimeIdx):solar.endDownTime(downTimeIdx)]; %#ok<*AGROW>
    end 
    normalizedSolarPower(solar.startDownTime:solar.endDownTime) = 0;    
end
