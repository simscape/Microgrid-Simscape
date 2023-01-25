% Code to plot system performance from remote_microgrid
%% Plot Description: 
%
% This plot shows the diesel cost for various size of BESS and diesel generator.

% Copyright 2022 - 2023 The MathWorks, Inc.

remoteMicrogridInputData;

% Scenario 1

BESSKVAs1= Microgrid.BESSKVAs1 ; % The KVA rating of the BESS in KVA
DieselKVAs1 = Microgrid.DieselKVAs1 ; % The KVA rating of the diesel in KVA

% Scenario 2

BESSKVAs2 = Microgrid.BESSKVAs2 ; % The KVA rating of the BESS in KVA
DieselKVAs2 = Microgrid.DieselKVAs2 ; % The KVA rating of the diesel in KVA

% Scenario 3

BESSKVAs3= Microgrid.BESSKVAs3 ; % The KVA rating of the BESS in KVA
DieselKVAs3 = Microgrid.DieselKVAs3 ; % The KVA rating of the diesel in KVA

% Scenario 4

BESSKVAs4 = Microgrid.BESSKVAs4 ; % The KVA rating of the BESS in KVA
DieselKVAs4 = Microgrid.DieselKVAs4 ; % The KVA rating of the diesel in KVA

% Scenario 5

BESSKVAs5 = Microgrid.BESSKVAs5 ; % The KVA rating of the BESS in KVA
DieselKVAs5 = Microgrid.DieselKVAs5 ; % The KVA rating of the diesel in KVA


% Diesel loading 

Diesel_loading_25percent = Microgrid.Diesel_loading_25percent; % diesel loading for 25% in hours
Diesel_loading_50percent = Microgrid.Diesel_loading_50percent; % diesel loading for 50% in hours
Diesel_loading_75percent = Microgrid.Diesel_loading_75percent; % diesel loading for 75% in hours
Diesel_loading_100percent =Microgrid.Diesel_loading_100percent; % diesel loading for 100% in hours

% Diesel consumtion in liters

Diesel_s1 = 2*Diesel_loading_25percent+3*Diesel_loading_50percent+5*Diesel_loading_75percent+6*Diesel_loading_100percent;
Diesel_s2 = 3*Diesel_loading_25percent+6*Diesel_loading_50percent+9*Diesel_loading_75percent+12*Diesel_loading_100percent;
Diesel_s3 = 7*Diesel_loading_25percent+12*Diesel_loading_50percent+18*Diesel_loading_75percent+25*Diesel_loading_100percent;
Diesel_s4 = 8*Diesel_loading_25percent+16*Diesel_loading_50percent+24*Diesel_loading_75percent+32*Diesel_loading_100percent;
Diesel_s5 = 13*Diesel_loading_25percent+25*Diesel_loading_50percent+38*Diesel_loading_75percent+50*Diesel_loading_100percent;


% Cost of diesel

diesel_litre_USD = 	Microgrid.diesel_litre_USD; % cost of diesel/litre 

Diesel_cost_s1 = diesel_litre_USD*Diesel_s1;
Diesel_cost_s2 = diesel_litre_USD*Diesel_s2;
Diesel_cost_s3 = diesel_litre_USD*Diesel_s3;
Diesel_cost_s4 = diesel_litre_USD*Diesel_s4;
Diesel_cost_s5 = diesel_litre_USD*Diesel_s5;

figure ;
subplot (2,1,1)

bar([Diesel_loading_25percent,Diesel_loading_50percent,Diesel_loading_75percent,Diesel_loading_100percent;...
    ])
% legend({'Diesel Lading 25%','Diesel Lading 50%','Diesel Lading 75%','Diesel Lading 100%'});

ylabel('Hours')
title('Diesel Loading in Hours')
xticks={'25% Loading','50% Loading','75% Loading',' 100% Loading'};
xticklabels(xticks);
subplot (2,1,2)

bar([BESSKVAs1,BESSKVAs2,BESSKVAs3,BESSKVAs4,BESSKVAs5;...
    DieselKVAs1,DieselKVAs2,DieselKVAs3,DieselKVAs4,DieselKVAs5;...
    Diesel_s1,Diesel_s2,Diesel_s3,Diesel_s4,Diesel_s5;...
    Diesel_cost_s1,Diesel_cost_s2,Diesel_cost_s3,Diesel_cost_s4,Diesel_cost_s5])

% legend({'Diesel Lading 25%','Diesel Lading 50%','Diesel Lading 75%','Diesel Lading 100%'});
legend({'Scenario1', 'Scenario2','Scenario3','Scenario4','Scenario5'},'NumColumns',2, Location='northwest');
xticks={'BESS Rating KVA','Diesel Rating KVA','Diesel Consumption Litre ','Diesel Cost USD'};
xticklabels(xticks);
ylabel('KVA/KVA/Litre/USD')
title('Cost of Diesel')

BESSCost1 = Microgrid.BESSCapitalCost*Microgrid.BESSKVAs1 + Micorgrid.BESSOperationalCost*Microgrid.BESSKVAs1;
BESSCost2 = Microgrid.BESSCapitalCost*Microgrid.BESSKVAs2 + Micorgrid.BESSOperationalCost*Microgrid.BESSKVAs2;
BESSCost3 = Microgrid.BESSCapitalCost*Microgrid.BESSKVAs3 + Micorgrid.BESSOperationalCost*Microgrid.BESSKVAs3;
BESSCost4 = Microgrid.BESSCapitalCost*Microgrid.BESSKVAs4 + Micorgrid.BESSOperationalCost*Microgrid.BESSKVAs4;
BESSCost5 = Microgrid.BESSCapitalCost*Microgrid.BESSKVAs5 + Micorgrid.BESSOperationalCost*Microgrid.BESSKVAs5;

Diesel_Unit_Cost = Microgrid.dieselcost;

Diesel_cost_s1_yr = Diesel_cost_s1*365 +Diesel_Unit_Cost;
Diesel_cost_s2_yr = Diesel_cost_s2*365 +Diesel_Unit_Cost;
Diesel_cost_s3_yr = Diesel_cost_s3*365 +Diesel_Unit_Cost;
Diesel_cost_s4_yr = Diesel_cost_s4*365 +Diesel_Unit_Cost;
Diesel_cost_s5_yr = Diesel_cost_s5*365 +Diesel_Unit_Cost;

TotalCost1 = BESSCost1 + Diesel_cost_s1_yr;
TotalCost2 = BESSCost2 + Diesel_cost_s2_yr;
TotalCost3 = BESSCost3 + Diesel_cost_s3_yr;
TotalCost4 = BESSCost4 + Diesel_cost_s4_yr;
TotalCost5 = BESSCost5 + Diesel_cost_s5_yr;

figure ;

bar([BESSCost1/1000,BESSCost2/1000,BESSCost3/1000,BESSCost4/1000,BESSCost5/1000;...
    Diesel_cost_s1_yr/1000,Diesel_cost_s2_yr/1000,Diesel_cost_s3_yr/1000,Diesel_cost_s4_yr/1000,Diesel_cost_s5_yr/1000;...
    TotalCost1/1000,TotalCost2/1000,TotalCost3/1000,TotalCost4/1000,TotalCost5/1000])

% legend({'Diesel Lading 25%','Diesel Lading 50%','Diesel Lading 75%','Diesel Lading 100%'});
legend({'Scenario1', 'Scenario2','Scenario3','Scenario4','Scenario5'},'NumColumns',2, Location='northwest');
xticks={'BESS Cost','Diesel Cost','Combined BESS and Diesel Cost '};
xticklabels(xticks);
ylabel('kUSD')
title('Yearly Cost of BESS, Diesel, and Combined BESS Plus Diesel Cost')

