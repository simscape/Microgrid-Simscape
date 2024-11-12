function loadProfile = loadPower(years)
% Copyright 2024 The MathWorks, Inc.

% This function calculates the load power

% Load data
load('loadData8760.mat')
loadProfile = loadPower;
loadProfile = repmat(loadProfile,years,1)/1000; % Conversion to kW
end