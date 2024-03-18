% This script is used for initializing the model for different cases

% Copyright 2023 - 2024 The MathWorks, Inc.
simTime = 10;
model = 'IndustrialMicrogrid';
for caseNum = 1:5
    load_system(model);
    set_param(model,'LoadInitialState','off');
    set_param(model,'LoadExternalInput','off');    
    switch(caseNum)
        case 1
            IndustrialMicrogridInputData;
            microgrid.controller2PlannedIsland = 20;
            opCase1 = findop('IndustrialMicrogrid',simTime);
        case 2
            IndustrialMicrogridInputData;
            microgrid.controller1Resynch = 20; % Time when resynch command is activated in controller 1 [s]
            microgrid.controller1PlannedIsland = 20; % Time when planned island command is activated controller 1  [s]
            opCase2 = findop('IndustrialMicrogrid',simTime);
        case 3
            IndustrialMicrogridInputData;
            microgrid.controller1BlackStart = 20;
            opCase3 = findop('IndustrialMicrogrid',simTime);
        case 4
            IndustrialMicrogridInputData;
            microgrid.controller2BlackStart = 20;
            opCase4 = findop('IndustrialMicrogrid',simTime);
        case 5
            IndustrialMicrogridInputData;
            microgrid.controller2PCCBrk = 20; % Time when PCC breaker command is activated controller 2  [s]
            microgrid.controller2PVBrk = 20; % Time when pv breaker command is activated controller 2  [s]
            microgrid.controller2PowerCenterFault = 20;
            microgrid.controller2PowerCenterBrk1 = microgrid.controller2PowerCenterFault+0.1;
            microgrid.controller2PowerCenterBrk3 = microgrid.controller2PowerCenterFault+0.1;
            microgrid.controller2SubstationBrk = microgrid.controller2PowerCenterFault+0.1;
            opCase5 = findop('IndustrialMicrogrid',simTime);
    end
end
