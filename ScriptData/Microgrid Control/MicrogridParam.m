% Copyright 2026 The MathWorks, Inc.

% Solar Plant parameters
SolarPlantParam;

% Wind Farm parameters
WindFarmParam;

% BESS parameters;
BESSGFLParam;
BESSGFMParam;

% Generator parameters
GeneratorParam;

% Planned Islanding parameters
PlannedIslandParam;

% Planned Islanding parameters
ResynchronizationParam;

% Planned Islanding parameters
BlackStartParam;

% Generic parameters
systemFrequency = 50;
lineResistance = 1e-3;
lineInductance = 1e-5;
gridVoltage = 33000;
powerLimit.upper = 1.2;
powerLimit.lower = -1.2;
powerQuality.maxVoltage = 1.1;
powerQuality.minVoltage = 0.9;
powerQuality.maxFrequency = 50.5;
powerQuality.minFrequency = 49.5;