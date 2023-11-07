% Code to plot system performance from remote_microgrid
%% Plot Description:
%
% This plot shows the loss, frequency deviation and voltage deviation.

% Copyright 2022 - 2023 The MathWorks, Inc.

load('powerLoss1_RemoteMicrogrid.mat');
load('powerLoss2_RemoteMicrogrid.mat');
load('powerLoss3_RemoteMicrogrid.mat');
load('powerLoss4_RemoteMicrogrid.mat');
% 
logsout_activeloss1 = mean(logsout1.get('ActivePowerLoss').Values.Data);
logsout_reactiveloss1 =mean(logsout1.get('ReactivePowerLoss').Values.Data);
logsout_freqmax1 = max(logsout1.get('MicrogridFrequencyMax').Values.Data);
logsout_freqmin1 =min(logsout1.get('MicrogridFrequencyMin').Values.Data);
logsout_volmax1 = max(logsout1.get('MicrogridVoltageMax').Values.Data);
logsout_volmin1 =min(logsout1.get('MicrogridVoltageMin').Values.Data);
% 
logsout_activeloss2 = mean(logsout2.get('ActivePowerLoss').Values.Data);
logsout_reactiveloss2 = mean(logsout2.get('ReactivePowerLoss').Values.Data);
logsout_freqmax2 = max(logsout2.get('MicrogridFrequencyMax').Values.Data);
logsout_freqmin2 =min(logsout2.get('MicrogridFrequencyMin').Values.Data);
logsout_volmax2 = max(logsout2.get('MicrogridVoltageMax').Values.Data);
logsout_volmin2 =min(logsout2.get('MicrogridVoltageMin').Values.Data);


logsout_activeloss3 = mean(logsout3.get('ActivePowerLoss').Values.Data);
logsout_reactiveloss3 = mean(logsout3.get('ReactivePowerLoss').Values.Data);
logsout_freqmax3 = max(logsout3.get('MicrogridFrequencyMax').Values.Data);
logsout_freqmin3 =min(logsout3.get('MicrogridFrequencyMin').Values.Data);
logsout_volmax3 = max(logsout3.get('MicrogridVoltageMax').Values.Data);
logsout_volmin3 =min(logsout3.get('MicrogridVoltageMin').Values.Data);

logsout_activeloss4 = mean(logsout4.get('ActivePowerLoss').Values.Data);
logsout_reactiveloss4 = mean(logsout4.get('ReactivePowerLoss').Values.Data);
logsout_freqmax4 = max(logsout4.get('MicrogridFrequencyMax').Values.Data);
logsout_freqmin4 =min(logsout4.get('MicrogridFrequencyMin').Values.Data);
logsout_volmax4 = max(logsout4.get('MicrogridVoltageMax').Values.Data);
logsout_volmin4 =min(logsout4.get('MicrogridVoltageMin').Values.Data);

figure ;
subplot (3,1,1)
bar([logsout_activeloss1,logsout_activeloss2,logsout_activeloss3,logsout_activeloss4; ...
    logsout_reactiveloss1,logsout_reactiveloss2,logsout_reactiveloss3,logsout_reactiveloss4]);
legend({'Case1','Case2','Case3','Case4'},'NumColumns',2,'Location','northwest');
ylabel('kW/KVAr')
title('Average Active and Reactive Power Loss')
xticks={'Active Power','Reactive Power'};
xticklabels(xticks);

subplot (3,1,2)
bar([logsout_freqmax1-60,logsout_freqmax2-60,logsout_freqmax3-60,logsout_freqmax4-60; ...
    logsout_freqmin1-60,logsout_freqmin2-60,logsout_freqmin3-60,logsout_freqmin4-60]);
ylabel('Hz')
title('Maximum Frequency Deviation Above and Below 60 Hz ')
legend({'Case1','Case2','Case3','Case4'},'NumColumns',2);
xticks={'Frequency Above 60 Hz','Frequency Below 60 Hz '};
xticklabels(xticks);

subplot (3,1,3)
bar([logsout_volmax1-1,logsout_volmax2-1,logsout_volmax3-1,logsout_volmax4-1; ...
    logsout_volmin1-1,logsout_volmin2-1,logsout_volmin3-1,logsout_volmin4-1]);
ylabel('p.u.')
title(' Maximum Voltage Deviation above and below 1 p.u.')
legend({'Case1','Case2','Case3','Case4'},'NumColumns',2);
xticks={'Voltage Above 1 p.u.','Voltage Below 1 p.u.'};
xticklabels(xticks);

