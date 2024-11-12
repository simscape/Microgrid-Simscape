function normalizedWindPower = windPower(years)
% Copyright 2024 The MathWorks, Inc.

% This function calculates the normalized wind power

% Load wind speed data
load('windProfile.mat'); %#ok<*LOAD>

% Load MPPT data for wind
load('windData.mat');

normalizedWindPower = windProfile;
for windIdx = 1:length(windProfile)
    normalizedWindPower(windIdx,1) = interp1(MPPT.windSpeed,MPPT.power,min(windProfile(windIdx),12),'spline');
    if normalizedWindPower(windIdx,1) < 1e-4
        normalizedWindPower(windIdx,1) = 1e-4;
    end
end
normalizedWindPower = repmat(normalizedWindPower,years,1);
end