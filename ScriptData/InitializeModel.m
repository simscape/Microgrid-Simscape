% This script is used for initializing the model for different cases

% Copyright 2023 The MathWorks, Inc.

set_param(bdroot,'LoadInitialState','off');
set_param(bdroot,'LoadExternalInput','off');
IndustrialMicrogridInputData;
switch(caseNum)
    case 1
        microgrid.controller2PlannedIsland = 20;
    case 2
        microgrid.controller1Resynch = 20; % Time when resynch command is activated in controller 1 [s]
        microgrid.controller1PlannedIsland = 20; % Time when planned island command is activated controller 1  [s]
    case 3
        microgrid.controller1BlackStart = 20;
    case 4
        microgrid.controller2BlackStart = 20;
    case 5
        microgrid.controller2PCCBrk = 20; % Time when PCC breaker command is activated controller 2  [s]
        microgrid.controller2PVBrk = 20; % Time when pv breaker command is activated controller 2  [s]
        microgrid.controller2PowerCenterFault = 20;
        microgrid.controller2PowerCenterBrk1 = microgrid.controller2PowerCenterFault+0.1;
        microgrid.controller2PowerCenterBrk3 = microgrid.controller2PowerCenterFault+0.1;
        microgrid.controller2SubstationBrk = microgrid.controller2PowerCenterFault+0.1;
end
simTime = 10;
op = findop('IndustrialMicrogrid',simTime);