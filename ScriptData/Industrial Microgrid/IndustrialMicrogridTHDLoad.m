% Code to plot system performance from Industrial Microgrid
%% Plot Description:
%
% This plot shows the THD of load voltage and PCC voltage. It also shows
% the load voltage deviations.

% Copyright 2023 The MathWorks, Inc.

IndustrialMicrogridInputData;

% Generate the below MAT files by running IndustrialMicrogridDesign.mlx

load('powerLoss1.mat');
load('powerLoss2.mat');
load('powerLoss3.mat');
load('powerLoss4.mat');
load('powerLoss4.mat');
% 
logsout_PCCTHD1 = mean(logsout1.get('THDPCCVoltageMG2').Values.Data);
logsout_LoadTHD1 =mean(logsout1.get('THDLoadVoltageMG2').Values.Data);
logsout_MinLoadVoltage1 = min(min(logsout1.get('MicrogridVoltageMG2').Values.Data(floor(0.7*end:end))));
logsout_MaxLoadVoltage1 =max(max(logsout1.get('MicrogridVoltageMG2').Values.Data(floor(0.7*end:end))));
% 
logsout_PCCTHD2 = mean(logsout2.get('THDPCCVoltageMG1').Values.Data);
logsout_LoadTHD2 =mean(logsout2.get('THDLoadVoltageMG1').Values.Data);
logsout_MinLoadVoltage2 = min(min(logsout2.get('MicrogridVoltageMG1').Values.Data(floor(0.7*end:end))));
logsout_MaxLoadVoltage2 =max(max(logsout2.get('MicrogridVoltageMG1').Values.Data(floor(0.7*end:end))));

% Consider the voltage values only after the black start in case 3 and case
% 4
tBlackStart = 4;
tIndex = find(logsout3.get('THDPCCVoltageMG1').Values.Time(1:end,1) > tBlackStart,1);

logsout_PCCTHD3 = mean([logsout3.get('THDPCCVoltageMG1').Values.Data(tIndex:end,1) logsout3.get('THDPCCVoltageMG1').Values.Data(tIndex:end,2) logsout3.get('THDPCCVoltageMG1').Values.Data(tIndex:end,3)]);
logsout_LoadTHD3 = mean([logsout3.get('THDLoadVoltageMG1').Values.Data(tIndex:end,1) logsout3.get('THDLoadVoltageMG1').Values.Data(tIndex:end,2) logsout3.get('THDLoadVoltageMG1').Values.Data(tIndex:end,3)]);
logsout_MinLoadVoltage3 = min(min(logsout3.get('MicrogridVoltageMG1').Values.Data(floor(0.9*end:end))));
logsout_MaxLoadVoltage3 =max(max(logsout3.get('MicrogridVoltageMG1').Values.Data(floor(0.9*end:end))));

logsout_PCCTHD4 = mean([logsout4.get('THDPCCVoltageMG2').Values.Data(tIndex:end,1) logsout4.get('THDPCCVoltageMG2').Values.Data(tIndex:end,2) logsout4.get('THDPCCVoltageMG2').Values.Data(tIndex:end,3)]);
logsout_LoadTHD4 = mean([logsout4.get('THDLoadVoltageMG2').Values.Data(tIndex:end,1) logsout4.get('THDLoadVoltageMG2').Values.Data(tIndex:end,2) logsout4.get('THDLoadVoltageMG2').Values.Data(tIndex:end,3)]);
logsout_MinLoadVoltage4 =min(min(logsout4.get('MicrogridVoltageMG2').Values.Data(floor(0.9*end:end))));
logsout_MaxLoadVoltage4 =max(max(logsout4.get('MicrogridVoltageMG2').Values.Data(floor(0.9*end:end))));


logsout_PCCTHD5 = mean(mean(logsout5.get('THDPCCVoltageMG1').Values.Data) +mean(logsout5.get('THDPCCVoltageMG2').Values.Data));
logsout_LoadTHD5 =mean(mean(logsout5.get('THDLoadVoltageMG1').Values.Data)+ mean(logsout5.get('THDLoadVoltageMG2').Values.Data));
logsout_MinLoadVoltage5 = min(min(logsout5.get('MicrogridVoltageMG1').Values.Data(floor(0.9*end:end))),min(logsout5.get('MicrogridVoltageMG2').Values.Data(floor(0.9*end:end))));
logsout_MaxLoadVoltage5 =max(max(logsout5.get('MicrogridVoltageMG1').Values.Data(floor(0.9*end:end))),max(logsout5.get('MicrogridVoltageMG2').Values.Data(floor(0.9*end:end))));

figure ;
subplot (2,1,1)

bar([logsout_PCCTHD1(1),logsout_PCCTHD2(1),logsout_PCCTHD3(1),logsout_PCCTHD4(1),logsout_PCCTHD5(1); ...
    logsout_LoadTHD1(1),logsout_LoadTHD2(1),logsout_LoadTHD3(1),logsout_LoadTHD4(1),logsout_LoadTHD5(1)]);
% hold on
xlim=get(gca,'xlim');
hold on
plot(xlim,[Microgrid.THDLimit Microgrid.THDLimit],'LineWidth',1,'Color','g','LineStyle','-')
ylabel('%');
title('THD of PCC Voltage and Load Voltage')
legend({'Case1','Case2','Case3','Case4','Case5','THD Limit'},'NumColumns',3);
ylim([0 5])
xticks={'PCC Voltage','Load Voltage'};
xticklabels(xticks);


subplot (2,1,2)

bar([logsout_MaxLoadVoltage1-1,logsout_MaxLoadVoltage2-1,logsout_MaxLoadVoltage3-1,logsout_MaxLoadVoltage4-1,logsout_MaxLoadVoltage5(1)-1;...
    logsout_MinLoadVoltage1-1,logsout_MinLoadVoltage2-1,logsout_MinLoadVoltage3-1,logsout_MinLoadVoltage4-1,logsout_MinLoadVoltage5(1)-1]);
xlim=get(gca,'xlim');
hold on
plot(xlim,[Microgrid.LoadVoltageDeviationLimit Microgrid.LoadVoltageDeviationLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot(xlim,[-Microgrid.LoadVoltageDeviationLimit -Microgrid.LoadVoltageDeviationLimit],'LineWidth',1,'Color','g','LineStyle','-')

title('Load Voltage Deviation Below and Above 1 p.u.')
legend({'Case1','Case2','Case3','Case4','Case5','Deviation limit'},'NumColumns',3);
xticks={'Load Voltage Above 1 p.u.','Load Voltage Below 1 p.u.'};
xticklabels(xticks);
ylabel('p.u.')
ylim([-.11 .11])



