function industrialMicrogridPlotLoadVI(logsout,caseNum,voltageLimit,microgrid)
% Function to plot simulation results from Industrial Microgrid
% Plot Description:
%
% This plot shows the load voltage and load current.

% Copyright 2023 The MathWorks, Inc.
% Create new figure
h3_IndustrialMicrogrid = figure('Name', 'h3_IndustrialMicrogrid');
figure(h3_IndustrialMicrogrid)
clf(h3_IndustrialMicrogrid)

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
    logsout_LoadV = logsout.get('LoadVoltageMG1');
    logsout_LoadC = logsout.get('LoadCurrentMG1');
else
    logsout_LoadV = logsout.get('LoadVoltageMG2');
    logsout_LoadC = logsout.get('LoadCurrentMG2');
end
% Plot results
flag=sum(logsout_LoadV.Values.Data>1+voltageLimitMax)+sum(logsout_LoadV.Values.Data<-1-voltageLimitMax)...
    +sum(max(logsout_LoadV.Values.Data)<1+voltageLimitMin);

simlog_handles(1) = subplot(2, 2, 1);
plot(logsout_LoadV.Values.Time, logsout_LoadV.Values.Data, 'LineWidth', 1)
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
axis([2.9 3.1 -1.2 1.7])
title('Three-Phase Load Voltage ')
ylabel('Voltage (pu)')
xlabel('Time (s)')
legend('','','','Max','','Min','NumColumns',2)

simlog_handles(1) = subplot(2, 2, 2);
plot(logsout_LoadV.Values.Time, logsout_LoadV.Values.Data, 'LineWidth', 1)
hold on 

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
axis([tStart tStop  -1.2 1.7])
title('Three-Phase Load Voltage ')
ylabel('Voltage (pu)')
xlabel('Time (s)')
legend('','','','Max','','Min','NumColumns',2)

simlog_handles(1) = subplot(2, 2, 3);
plot(logsout_LoadC.Values.Time, logsout_LoadC.Values.Data, 'LineWidth', 1)

grid on

if caseNum == 5 && strcmp(microgrid,'microgrid2')
    yScale = [-3 3];
else
    yScale = [-1.3 1.3];
end

axis([2.9 3.1 yScale])
title('Three-Phase Load Current ')
ylabel('Current (pu)')
xlabel('Time (s)')

simlog_handles(1) = subplot(2, 2, 4);
plot(logsout_LoadC.Values.Time, logsout_LoadC.Values.Data, 'LineWidth', 1)

grid on

axis([tStart tStop  yScale])
title('Three-Phase Load Current  ')
ylabel('Current (pu)')
xlabel('Time (s)')
sgtitle(strcat(microgrid,' Load Voltage and Current'),'Fontsize',15);
linkaxes(simlog_handles, 'x')
end
