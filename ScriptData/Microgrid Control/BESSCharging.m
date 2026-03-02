% Copyright 2026 The MathWorks, Inc.

% BESS charging in grid connected mode

% BESS operating mode
bessMode = 1;
bessModeInitial = 1;

% BESS set points
ref.PBESS1MW = -0.1;
ref.QBESS1MW = 0;
ref.PBESS3MW = -0.1;
ref.QBESS3MW = 0;

% Breaker status
breakerStatus.motorInitial = 1;
breakerStatus.generator = 1;
breakerStatus.load = 100;
breakerStatus.PCCInitial = 0;

% Solar Irradiance change
solarInsolationChange = 100;

% Event triggers
event.plannedIslanding = 100;
event.resynchronization = 100;

