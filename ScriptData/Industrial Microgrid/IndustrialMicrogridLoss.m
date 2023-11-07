% Code to plot system performance from  industrial microgrid
%% Plot Description:
%
% This plot shows the loss, frequency deviation and voltage deviation.

% Copyright 2023 The MathWorks, Inc.
IndustrialMicrogridInputData;
load('powerLoss1.mat');
load('powerLoss2.mat');
load('powerLoss3.mat');
load('powerLoss4.mat');
load('powerLoss5.mat');
% 
logsout_activeloss1 = mean(logsout1.get('ActivePowerLossMG2').Values.Data);
logsout_reactiveloss1 =mean(logsout1.get('ReactivePowerLossMG2').Values.Data);
logsout_freqmax1 = max(logsout1.get('MicrogridFrequencyMG2').Values.Data);
logsout_freqmin1 =min(logsout1.get('MicrogridFrequencyMG2').Values.Data);
logsout_volmax1 = max(logsout1.get('MicrogridVoltageMG2').Values.Data);
logsout_volmin1 =min(logsout1.get('MicrogridVoltageMG2').Values.Data(floor(0.4*end):end));
% 
logsout_activeloss2 = mean(logsout2.get('ActivePowerLossMG1').Values.Data);
logsout_reactiveloss2 =mean(logsout2.get('ReactivePowerLossMG1').Values.Data);
logsout_freqmax2 = max(logsout2.get('MicrogridFrequencyMG1').Values.Data);
logsout_freqmin2 =min(logsout2.get('MicrogridFrequencyMG1').Values.Data);
logsout_volmax2 = max(logsout2.get('MicrogridVoltageMG1').Values.Data);
logsout_volmin2 =min(logsout2.get('MicrogridVoltageMG1').Values.Data(floor(0.4*end):end));


logsout_activeloss3 = mean(logsout3.get('ActivePowerLossMG1').Values.Data);
logsout_reactiveloss3 =mean(logsout3.get('ReactivePowerLossMG1').Values.Data);
logsout_freqmax3 = max(logsout3.get('MicrogridFrequencyMG1').Values.Data);
logsout_freqmin3 =min(logsout3.get('MicrogridFrequencyMG1').Values.Data);
logsout_volmax3 = max(logsout3.get('MicrogridVoltageMG1').Values.Data);
logsout_volmin3 =min(logsout3.get('MicrogridVoltageMG1').Values.Data(floor(0.9*end):end));


logsout_activeloss4 = mean(logsout4.get('ActivePowerLossMG2').Values.Data);
logsout_reactiveloss4 =mean(logsout4.get('ReactivePowerLossMG2').Values.Data);
logsout_freqmax4 = max(logsout4.get('MicrogridFrequencyMG2').Values.Data);
logsout_freqmin4 =min(logsout4.get('MicrogridFrequencyMG2').Values.Data);
logsout_volmax4 = max(logsout4.get('MicrogridVoltageMG2').Values.Data);
logsout_volmin4 =min(logsout4.get('MicrogridVoltageMG2').Values.Data(floor(0.9*end):end));

logsout_activeloss5 = mean(mean(logsout5.get('ActivePowerLossMG1').Values.Data(floor(0.7*end):end))+ mean(logsout5.get('ActivePowerLossMG2').Values.Data(floor(0.7*end):end)));
logsout_reactiveloss5 =mean(mean(logsout5.get('ReactivePowerLossMG1').Values.Data(floor(0.7*end):end))+mean(logsout5.get('ReactivePowerLossMG2').Values.Data(floor(0.7*end):end)));
logsout_freqmax5 = max(max(logsout5.get('MicrogridFrequencyMG1').Values.Data),max(logsout5.get('MicrogridFrequencyMG2').Values.Data));
logsout_freqmin5 =min(min(logsout5.get('MicrogridFrequencyMG1').Values.Data),min(logsout5.get('MicrogridFrequencyMG2').Values.Data));
logsout_volmax5 = max(max(logsout5.get('MicrogridVoltageMG1').Values.Data(floor(0.7*end):end)));max(logsout5.get('MicrogridVoltageMG2').Values.Data(floor(0.7*end):end));
logsout_volmin5 = min(min(logsout5.get('MicrogridVoltageMG1').Values.Data(floor(0.7*end):end)),min(logsout5.get('MicrogridVoltageMG2').Values.Data(floor(0.7*end):end)));

figure 
subplot (3,1,1)
bar([logsout_activeloss1,logsout_activeloss2,logsout_activeloss3,logsout_activeloss4,logsout_activeloss4; ...
    logsout_reactiveloss1,logsout_reactiveloss2,logsout_reactiveloss3,logsout_reactiveloss4,logsout_reactiveloss5]);
legend({'Case1','Case2','Case3','Case4','Case5'},'NumColumns',3,'Location','northwest');
ylabel('MW/MVAr')
title('Average Active and Reactive Power Loss')
xticks={'Active Power','Reactive Power'};
xticklabels(xticks);

subplot (3,1,2)
bar([logsout_freqmax1-60,logsout_freqmax2-60,logsout_freqmax3-60,logsout_freqmax4-60,logsout_freqmax4-60; ...
    logsout_freqmin1-60,logsout_freqmin2-60,logsout_freqmin3-60,logsout_freqmin4-60,logsout_freqmin4-60]);
ylabel('Hz')
title('Maximum Frequency Deviation Above and Below 60 Hz ')
xticks={'Frequency Above 60 Hz','Frequency Below 60 Hz '};
xlim=get(gca,'xlim');
hold on
plot(xlim,[microgrid.FrequencyLimit1*microgrid.frequency microgrid.FrequencyLimit1*microgrid.frequency],'LineWidth',1,'Color','g','LineStyle','-')
plot(xlim,[-microgrid.FrequencyLimit1*microgrid.frequency -microgrid.FrequencyLimit1*microgrid.frequency],'LineWidth',1,'Color','g','LineStyle','-')
xticklabels(xticks);
ylim([-1.1 1.1]*microgrid.FrequencyLimit1*microgrid.frequency);
legend({'Case1','Case2','Case3','Case4','Case5','Deviation Limit'},'NumColumns',5,'Location','northeast');

subplot (3,1,3)
bar([logsout_volmax1-1,logsout_volmax2-1,logsout_volmax3-1,logsout_volmax4-1,logsout_volmax5-1; ...
    logsout_volmin1-1,logsout_volmin2-1,logsout_volmin3-1,logsout_volmin4-1,logsout_volmin5-1]);
ylabel('p.u.')
title(' Maximum Voltage Deviation above and below 1 p.u.')
xticks={'Voltage Above 1 p.u.','Voltage Below 1 p.u.'};
xticklabels(xticks);
xlim=get(gca,'xlim');
hold on;
plot(xlim,[microgrid.VoltageLimit1 microgrid.VoltageLimit1],'LineWidth',1,'Color','g','LineStyle','-');
plot(xlim,[-microgrid.VoltageLimit1 -microgrid.VoltageLimit1],'LineWidth',1,'Color','g','LineStyle','-');
ylim([-1.11 1.11]*microgrid.VoltageLimit1);
legend({'Case1','Case2','Case3','Case4','Case5','Deviation Limit'},'NumColumns',5,'Location','northeast');
