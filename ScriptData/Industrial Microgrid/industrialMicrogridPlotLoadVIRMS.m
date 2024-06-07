function industrialMicrogridPlotLoadVIRMS(logsout,caseNum,voltageLimit,microgrid)
% Function to plot simulation results from  industrial microgrid
% Plot Description:
%
% This plot shows the load voltage and load current.

% Copyright 2023 The MathWorks, Inc.

h4_IndustrialMicrogrid = figure('Name', 'h4_IndustrialMicrogrid');
figure(h4_IndustrialMicrogrid)
clf(h4_IndustrialMicrogrid)
if ~exist('caseNum','var')
    caseNum = 1;
end

% selecting time axis for the plot
switch caseNum
    case 1
        tStart = 5.9;
        tStop = 6.1;
    case 2
        tStart = 7.75;
        tStop = 7.95;
    case 3
        tStart = 3;
        tStop = 8;
    case 4
        tStart = 3;
        tStop = 8;
    case 5
        tStart = 3;
        tStop = 8;
end 

voltageLimitMax = voltageLimit.max;
voltageLimitMin = voltageLimit.min;

% Get simulation results

if strcmp(microgrid,'Microgrid1')
    logsout_LoadVRMS = logsout.get('LoadVoltageRMSMG1');
    logsout_LoadCRMS = logsout.get('LoadCurrentRMSMG1');
else
    logsout_LoadVRMS = logsout.get('LoadVoltageRMSMG2');
    logsout_LoadCRMS = logsout.get('LoadCurrentRMSMG2');
end

% Neglect the initial data to avoid transients
tPlot = 2;
tIndex = find(logsout_LoadVRMS.Values.Time > tPlot,1);

flag = max(logsout_LoadVRMS.Values.Data(tIndex:end,1))>1+voltageLimitMax||min(logsout_LoadVRMS.Values.Data(tIndex:end,1))<1+voltageLimitMin;

% Plot results
simlog_handles(1) = subplot(2, 2, 1);
Voltage=squeeze(logsout_LoadVRMS.Values.Data); 
plot(logsout_LoadVRMS.Values.Time(tIndex:end), Voltage((tIndex:end),1)', 'LineWidth', 1) % ploting single phase RMS

hold on
if flag>0
plot([2.9 3.1],[1+voltageLimitMax,1+voltageLimitMax],'LineWidth',1,'Color','r','LineStyle','-')
plot([2.9 3.1],[-1-voltageLimitMax,-1-voltageLimitMax],'LineWidth',1,'Color','r','LineStyle','-')
plot([2.9 3.1],[1+voltageLimitMin,1+voltageLimitMin],'LineWidth',3,'Color','r','LineStyle',':')
plot([2.9 3.1],[-1-voltageLimitMin,-1-voltageLimitMin],'LineWidth',3,'Color','r','LineStyle',':')

title(' Three-Phase Load Voltage', 'Outside Acceptable Limit ', 'Color','red')

else
plot([2.9 3.1],[1+voltageLimitMax,1+voltageLimitMax],'LineWidth',1,'Color','g','LineStyle','-')
plot([2.9 3.1],[-1-voltageLimitMax,-1-voltageLimitMax],'LineWidth',1,'Color','g','LineStyle','-')
plot([2.9 3.1],[1+voltageLimitMin,1+voltageLimitMin],'LineWidth',3,'Color','g','LineStyle',':')
plot([2.9 3.1],[-1-voltageLimitMin,-1-voltageLimitMin],'LineWidth',3,'Color','g','LineStyle',':')
title('Three-Phase Load Voltage', 'Within Acceptable Limit ', 'Color','green')
end
grid on
axis([2.9 3.1 0 1.1])

title('Load RMS Voltage ')
ylabel('Voltage (pu)')
xlabel('Time (s)')
legend('','Max','','Min','NumColumns',2)


simlog_handles(1) = subplot(2, 2, 2);
Voltage=squeeze(logsout_LoadVRMS.Values.Data);
plot(logsout_LoadVRMS.Values.Time(tIndex:end), Voltage((tIndex:end),1)', 'LineWidth', 1) % ploting single phase RMS
hold on 
 
if flag>0
plot([tStart tStop],[1+voltageLimitMax,1+voltageLimitMax],'LineWidth',1,'Color','r','LineStyle','-')
plot([tStart tStop],[-1-voltageLimitMax,-1-voltageLimitMax],'LineWidth',1,'Color','r','LineStyle','-')
plot([tStart tStop],[1+voltageLimitMin,1+voltageLimitMin],'LineWidth',3,'Color','r','LineStyle',':')
plot([tStart tStop],[-1-voltageLimitMin,-1-voltageLimitMin],'LineWidth',3,'Color','r','LineStyle',':')

title(' Three-Phase Load Voltage', 'Outside Acceptable Limit ', 'Color','red')

else
plot([tStart tStop],[1+voltageLimitMax,1+voltageLimitMax],'LineWidth',1,'Color','g','LineStyle','-')
plot([tStart tStop],[-1-voltageLimitMax,-1-voltageLimitMax],'LineWidth',1,'Color','g','LineStyle','-')
plot([tStart tStop],[1+voltageLimitMin,1+voltageLimitMin],'LineWidth',3,'Color','g','LineStyle',':')
plot([tStart tStop],[-1-voltageLimitMin,-1-voltageLimitMin],'LineWidth',3,'Color','g','LineStyle',':')
title(' Three-Phase Load Voltage', 'Within Acceptable Limit ', 'Color','green')
end

grid on
axis([tStart tStop 0 1.1])
title('Load RMS Voltage ')
ylabel('Voltage (pu)')
xlabel('Time (s)')
legend('','Max','','Min','NumColumns',2)
simlog_handles(1) = subplot(2, 2, 3);
Current= squeeze(logsout_LoadCRMS.Values.Data);
plot(logsout_LoadCRMS.Values.Time(tIndex:end), Current((tIndex:end),1), 'LineWidth', 1) % ploting single phase RMS
grid on

if caseNum == 5 && strcmp(microgrid,'Microgrid2')
    yScale = [0 3];
else
    yScale = [0 1.1];
end
axis([2.9 3.1 yScale])
title('Load RMS Current  ')
ylabel('Current (pu)')
xlabel('Time (s)')

simlog_handles(1) = subplot(2, 2, 4);
Current= squeeze(logsout_LoadCRMS.Values.Data);
plot(logsout_LoadCRMS.Values.Time(tIndex:end), Current((tIndex:end),1), 'LineWidth', 1) % ploting single phase RMS
grid on

axis([tStart tStop yScale])
title('Load RMS Current  ')
ylabel('Current (pu)')
xlabel('Time (s)')
sgtitle(strcat(microgrid,' Load RMS Voltage and Current'),'Fontsize',15);
linkaxes(simlog_handles, 'x')
end
