% Code to plot system performance from remote_microgrid
%% Plot Description:
%
% This plot shows the THD of load voltage and PCC voltage. It also shows
% the laod voltage deviations.

% Copyright 2022 - 2023 The MathWorks, Inc.

RemoteMicrogridInputData;

load('powerLoss1_RemoteMicrogrid.mat');
load('powerLoss2_RemoteMicrogrid.mat');
load('powerLoss3_RemoteMicrogrid.mat');
load('powerLoss4_RemoteMicrogrid.mat');
% 
logsout_PCCTHD1 = mean(logsout1.get('THDPCCVoltage').Values.Data);
logsout_LoadTHD1 =mean(logsout1.get('THDLoadVoltage').Values.Data);
logsout_MinLoadVoltage1 =sqrt(2)* min(min(logsout1.get('MinLoadVoltage').Values.Data));
logsout_MaxLoadVoltage1 =sqrt(2)*max(max(logsout1.get('MaxLoadVoltage').Values.Data));
% 
logsout_PCCTHD2 = mean(logsout2.get('THDPCCVoltage').Values.Data);
logsout_LoadTHD2 =mean(logsout2.get('THDLoadVoltage').Values.Data);
logsout_MinLoadVoltage2 = sqrt(2)*min(min(logsout2.get('MinLoadVoltage').Values.Data));
logsout_MaxLoadVoltage2 =sqrt(2)*max(max(logsout2.get('MaxLoadVoltage').Values.Data));


logsout_PCCTHD3 = mean(logsout3.get('THDPCCVoltage').Values.Data);
logsout_LoadTHD3 =mean(logsout3.get('THDLoadVoltage').Values.Data);
logsout_MinLoadVoltage3 = sqrt(2)*min(min(logsout3.get('MinLoadVoltage').Values.Data));
logsout_MaxLoadVoltage3 =sqrt(2)*max(max(logsout3.get('MaxLoadVoltage').Values.Data));

logsout_PCCTHD4 = mean(logsout4.get('THDPCCVoltage').Values.Data);
logsout_LoadTHD4 =mean(logsout4.get('THDLoadVoltage').Values.Data);
logsout_MinLoadVoltage4 = sqrt(2)*min(min(logsout4.get('MinLoadVoltage').Values.Data));
logsout_MaxLoadVoltage4 =sqrt(2)*max(max(logsout4.get('MaxLoadVoltage').Values.Data));

figure ;
subplot (2,1,1)

bar([logsout_PCCTHD1(1),logsout_PCCTHD2(1),logsout_PCCTHD3(1),logsout_PCCTHD4(1); ...
    logsout_LoadTHD1(1),logsout_LoadTHD2(1),logsout_LoadTHD3(1),logsout_LoadTHD4(1)]);
% hold on
xlim=get(gca,'xlim');
hold on
plot(xlim,[Microgrid.THDLimit Microgrid.THDLimit],'LineWidth',1,'Color','g','LineStyle','-')
% plot([1,2],[5,5],'LineWidth',1,'Color','g','LineStyle','-')
ylabel('%');
title('THD of PCC Voltage and Load Voltage')
legend({'Case1','Case2','Case3','Case4','THD Limit'},'NumColumns',5);
ylim([0 4])
xticks={'PCC Voltage','Load Voltage'};
xticklabels(xticks);


subplot (2,1,2)

bar([logsout_MaxLoadVoltage1-1,logsout_MaxLoadVoltage2-1,logsout_MaxLoadVoltage3-1,logsout_MaxLoadVoltage4-1;...
    logsout_MinLoadVoltage1(1,1,1)-1,logsout_MinLoadVoltage2-1,logsout_MinLoadVoltage2-1,logsout_MinLoadVoltage4-1;])
xlim=get(gca,'xlim');
hold on
plot(xlim,[Microgrid.LoadVoltageDeviationLimit Microgrid.LoadVoltageDeviationLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot(xlim,[-Microgrid.LoadVoltageDeviationLimit -Microgrid.LoadVoltageDeviationLimit],'LineWidth',1,'Color','g','LineStyle','-')

title('Load Voltage Deviation Below and Above 1 p.u.')
legend({'Case1','Case2','Case3','Case4','Deviation limit'},'NumColumns',2);
xticks={'Load Voltage Above 1 p.u.','Load Voltage Below 1 p.u.'};
xticklabels(xticks);
ylabel('p.u.')
ylim([-.11 .11])



