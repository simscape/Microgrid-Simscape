% Copyright 2026 The MathWorks, Inc.

% Normal operation with all the sources connected

% BESS operating mode
bessMode = 0;
bessModeInitial = 0;

% BESS set points
ref.PBESS1MW = 0.8;
ref.QBESS1MW = 0;
ref.PBESS3MW = 0.4;
ref.QBESS3MW = 0.2;

% Breaker status
breakerStatus.motorInitial = 1;
breakerStatus.generator = 1;
breakerStatus.load = 100;
breakerStatus.PCCInitial = 1;

% Solar Irradiance change
solarInsolationChange = 100;

% Event triggers
event.plannedIslanding = 100;
event.resynchronization = 4;

