
% Code to plot system performance from Industrial Microgrid
%% Plot Description: 
%
% This plot shows the diesel cost for various size of BESS and diesel generator.

% Copyright 2023 The MathWorks, Inc.

IndustrialMicrogridInputData;

% Scenario 1

BESSKVAs1= Microgrid.BESSMVAs1*1000 ; % The KVA rating of the BESS in KVA
DieselKVAs1 = Microgrid.DieselMVAs1*1000 ; % The KVA rating of the diesel in KVA
PVKVAs1 = Microgrid.PVMVAs1*1000 ; % The KVA rating of the PV in KVA
% Scenario 2

BESSKVAs2 = Microgrid.BESSMVAs2*1000 ; % The KVA rating of the BESS in KVA
DieselKVAs2 = Microgrid.DieselMVAs2*1000 ; % The KVA rating of the diesel in KVA
PVKVAs2 = Microgrid.PVMVAs2*1000 ; % The KVA rating of the PV in KVA

% Scenario 3

BESSKVAs3= Microgrid.BESSMVAs3*1000 ; % The KVA rating of the BESS in KVA
DieselKVAs3 = Microgrid.DieselMVAs3*1000 ; % The KVA rating of the diesel in KVA
PVKVAs3 = Microgrid.PVMVAs3*1000 ; % The KVA rating of the PV in KVA

% Scenario 4

BESSKVAs4 = Microgrid.BESSMVAs4*1000 ; % The KVA rating of the BESS in KVA
DieselKVAs4 = Microgrid.DieselMVAs4*1000 ; % The KVA rating of the diesel in KVA
PVKVAs4 = Microgrid.PVMVAs4*1000 ; % The KVA rating of the PV in KVA

% Diesel loading 
Diesel_loading_25percent = Microgrid.Diesel_loading_25percent; % diesel loading for 25% in hours
Diesel_loading_50percent = Microgrid.Diesel_loading_50percent; % diesel loading for 50% in hours
Diesel_loading_75percent = Microgrid.Diesel_loading_75percent; % diesel loading for 75% in hours
Diesel_loading_100percent =Microgrid.Diesel_loading_100percent; % diesel loading for 100% in hours

% Diesel consumtion in liters per hour for a 2MW generator
dieselConsumption_25PercentLoading_2000KW = 162.6;
dieselConsumption_50PercentLoading_2000KW = 276.3;
dieselConsumption_75PercentLoading_2000KW  = 393.3;
dieselConsumption_100PercentLoading_2000KW = 539.2;

% Diesel consumtion in liters per hour for a 1.5MW generator
dieselConsumption_25PercentLoading_1500KW = 122.4;
dieselConsumption_50PercentLoading_1500KW = 206.3;
dieselConsumption_75PercentLoading_1500KW = 295.6;
dieselConsumption_100PercentLoading_1500KW = 404.7;

% Diesel consumtion in liters per hour for a 0.5MW generator
dieselConsumption_25PercentLoading_500KW = 41.8;
dieselConsumption_50PercentLoading_500KW = 70.3;
dieselConsumption_75PercentLoading_500KW = 100.3;
dieselConsumption_100PercentLoading_500KW = 135.7;

Diesel_s1 = (dieselConsumption_25PercentLoading_2000KW*Diesel_loading_25percent)+...
    (dieselConsumption_50PercentLoading_2000KW*Diesel_loading_50percent)+...
    (dieselConsumption_75PercentLoading_2000KW*Diesel_loading_75percent)+...
    (dieselConsumption_100PercentLoading_2000KW*Diesel_loading_100percent);  % Diesel rating 2 MW

Diesel_s2 = (dieselConsumption_25PercentLoading_1500KW*Diesel_loading_25percent)+...
    (dieselConsumption_50PercentLoading_1500KW*Diesel_loading_50percent)+...
    (dieselConsumption_75PercentLoading_1500KW*Diesel_loading_75percent)+...
    (dieselConsumption_100PercentLoading_1500KW*Diesel_loading_100percent);  % Diesel rating 1.5 MW

Diesel_s3 = (dieselConsumption_25PercentLoading_500KW*Diesel_loading_25percent)+...
    (dieselConsumption_50PercentLoading_500KW*Diesel_loading_50percent)+...
    (dieselConsumption_75PercentLoading_500KW*Diesel_loading_75percent)+...
    (dieselConsumption_100PercentLoading_500KW*Diesel_loading_100percent);  % Diesel rating 0.5 MW

Diesel_s4 = 0;                                                                                                                                 % Diesel rating 0 MW


% Cost of diesel
diesel_litre_USD = Microgrid.diesel_litre_USD; % cost of diesel/litre 

Diesel_cost_s1 = diesel_litre_USD*Diesel_s1;
Diesel_cost_s2 = diesel_litre_USD*Diesel_s2;
Diesel_cost_s3 = diesel_litre_USD*Diesel_s3;
Diesel_cost_s4 = diesel_litre_USD*Diesel_s4;

figure ;
subplot (2,1,1)

bar([Diesel_loading_25percent,Diesel_loading_50percent,Diesel_loading_75percent,Diesel_loading_100percent;...
    ])

ylabel('Hours')
title('Diesel Loading in Hours')
xticks={'25% Loading','50% Loading','75% Loading',' 100% Loading'};
xticklabels(xticks);
subplot (2,1,2)

bar([BESSKVAs1,BESSKVAs2,BESSKVAs3,BESSKVAs4;...
    DieselKVAs1,DieselKVAs2,DieselKVAs3,DieselKVAs4;...
    Diesel_s1,Diesel_s2,Diesel_s3,Diesel_s4;...
    Diesel_cost_s1,Diesel_cost_s2,Diesel_cost_s3,Diesel_cost_s4])

legend({'Scenario1 : Only Diesel', 'Scenario2 : Diesel+PV','Scenario3 : BESS+Diesel+PV','Scenario4 : Only BESS'},'NumColumns',1, Location='northwest');
xticks={'BESS Rating KVA','Diesel Rating KVA','Diesel Consumption Litre ','Diesel Cost USD'};
xticklabels(xticks);
ylabel('MVA/MVA/Litre/USD')
title('Cost of Diesel')

BESSCost1 = Microgrid.BESSCapitalCost*BESSKVAs1*1000 + Microgrid.BESSOperationalCost*BESSKVAs1;
BESSCost2 = Microgrid.BESSCapitalCost*BESSKVAs2*1000 + Microgrid.BESSOperationalCost*BESSKVAs2;
BESSCost3 = Microgrid.BESSCapitalCost*BESSKVAs3*1000 + Microgrid.BESSOperationalCost*BESSKVAs3;
BESSCost4 = Microgrid.BESSCapitalCost*BESSKVAs4*1000 + Microgrid.BESSOperationalCost*BESSKVAs4;


PVCost1 = Microgrid.PVCapitalCost*PVKVAs1*1000 + Microgrid.PVOperationalCost*PVKVAs1;
PVCost2 = Microgrid.PVCapitalCost*PVKVAs2*1000 + Microgrid.PVOperationalCost*PVKVAs2;
PVCost3 = Microgrid.PVCapitalCost*PVKVAs3*1000 + Microgrid.PVOperationalCost*PVKVAs3;
PVCost4 = Microgrid.PVCapitalCost*PVKVAs4*1000 + Microgrid.PVOperationalCost*PVKVAs4;

DieselCost1 = Microgrid.DieselCapitalCost*DieselKVAs1*1000 + Microgrid.DieselOperationalCost*DieselKVAs1;
DieselCost2 = Microgrid.DieselCapitalCost*DieselKVAs2*1000 + Microgrid.DieselOperationalCost*DieselKVAs2;
DieselCost3 = Microgrid.DieselCapitalCost*DieselKVAs3*1000 + Microgrid.DieselOperationalCost*DieselKVAs3;
DieselCost4 = Microgrid.DieselCapitalCost*DieselKVAs4*1000 + Microgrid.DieselOperationalCost*DieselKVAs4;

Diesel_cost_s1_yr = Diesel_cost_s1*365 +DieselCost1;
Diesel_cost_s2_yr = Diesel_cost_s2*365 +DieselCost2;
Diesel_cost_s3_yr = Diesel_cost_s3*365 +DieselCost3;
Diesel_cost_s4_yr = Diesel_cost_s4*365 +DieselCost4;

TotalCost1 = BESSCost1 + Diesel_cost_s1_yr+PVCost1;
TotalCost2 = BESSCost2 + Diesel_cost_s2_yr+PVCost2;
TotalCost3 = BESSCost3 + Diesel_cost_s3_yr+PVCost3;
TotalCost4 = BESSCost4 + Diesel_cost_s4_yr+PVCost4;

figure ;

bar([BESSCost1/1000,BESSCost2/1000,BESSCost3/1000,BESSCost4/1000;...
    Diesel_cost_s1_yr/1000,Diesel_cost_s2_yr/1000,Diesel_cost_s3_yr/1000,Diesel_cost_s4_yr/1000,;...
    TotalCost1/1000,TotalCost2/1000,TotalCost3/1000,TotalCost4/1000])

legend({'Scenario1: Only Diesel', 'Scenario2: Diesel + PV','Scenario3: Diesel + PV + BESS','Scenario4: Only BESS'},'NumColumns',2, Location='northwest');
xticks={'BESS Cost','Diesel Cost','Total Cost(Diesel+BESS+PV) '};
xticklabels(xticks);
ylabel('kUSD')
title('Yearly Cost of BESS, Diesel, and Combined Diesel+BESS+PV Cost')
ylim([0 7000])

% Loss of power delivery in grid loss

BESSMVA1 = Microgrid.BESSMVA1;                       % Size of BESS 1  [MVA]
BESSMVA2 = Microgrid.BESSMVA2;                       % Size of BESS 2  [MVA]

DieselMVA = Microgrid.DieselMVA;                     % Size of diesel [MVA]
PVMVA = Microgrid.PVMVA;                             % Size of PV  [MVA]

Grid1MVA = Grid.Grid1MVA;                            % MVA rating of grid 1 [MVA]
Grid2MVA = Grid.Grid2MVA;                            % MVA rating of grid 2 [MVA]
Grid1Limited = Grid.Grid1Limited;                    % MVA rating with grid limit [MVA]
Grid2Limited = Grid.Grid2Limited;

% MG1 loads	
DrillingLoad1 = Microgrid.DrillingLoad1;             % MVA rating of drilling load 1 [MVA]
DrillingLoad2a = Microgrid.DrillingLoad2a;		     % MVA rating of drilling load 2a [MVA]
DrillingLoad2b = Microgrid.DrillingLoad2b;           % MVA rating of drilling load 2b [MVA]
Conveyor = Microgrid.Conveyor;                       % MVA rating of conveyor [MVA]
TotalMG1Load = DrillingLoad1+DrillingLoad2a+DrillingLoad2b+Conveyor;

% MG2 loads	
LightingLoad = Microgrid.LightingLoad;               % MVA rating of lighting load  [MVA]
AuxiliaryLoad = Microgrid.AuxiliaryLoad;	         % MVA rating of auxiliary load [MVA]
ProcessingMotorLoad = Microgrid.ProcessingMotorLoad; % MVA rating of Processing motor load [MVA]
TotalMG2Load = LightingLoad+AuxiliaryLoad+ProcessingMotorLoad;
TotalMG2Generation = BESSMVA2+DieselMVA+PVMVA; 
figure;
title('Power Generations and Loads in Two Microgrids')

subplot(1,3,1)
bar(1,[BESSMVA1;BESSMVA2;DieselMVA;PVMVA]);
legend({'BESS1','BESS2','Diesel','PV'});
title('Power Generations')
ylabel('MVA')
ylim([0,1.3]);
subplot(1,3,2)
bar(2, [DrillingLoad1;DrillingLoad2a;DrillingLoad2b;Conveyor;TotalMG1Load]);
title('Microgrid 1 Loads')
legend({'DrillingLoad1','DrillingLoad2a','DrillingLoad2b','Conveyor','TotalMG1Load'});
ylim([0,1.3]);
subplot(1,3,3)
bar(3, [LightingLoad;AuxiliaryLoad;ProcessingMotorLoad;TotalMG2Load]);
legend({'LightingLoad','AuxiliaryLoad','ProcessingLoad','TotalMG2Load'});
title('Microgrid 2 Loads')
ylim([0,1.3]);
ylabel('MVA');



