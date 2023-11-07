function industrialMicrogridPlotBESSIV(logsout,caseNum,voltageLimit,microgrid)
% Function to plot simulation results from IndustrialMicrogrid
%% Plot Description:
%
% This plot shows the voltage, current, and power output of BESS.

% Copyright 2023 The MathWorks, Inc.

% Create new figure
h1_IndustrialMicrogrid = figure('Name', 'h1_IndustrialMicrogrid');

figure(h1_IndustrialMicrogrid)
clf(h1_IndustrialMicrogrid)

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

% Get simulation results
if strcmp(microgrid,'Microgrid1')
    logsout_vabcBESS = logsout.get('VabcBESS1');
    logsout_iBESS = logsout.get('CurrentBESS1');
    logsout_iGrid = logsout.get('iGRID1');
    plotTitle = 'Microgrid1 Voltage and Current';
else
    logsout_vabcBESS = logsout.get('VabcBESS2');
    logsout_iBESS = logsout.get('CurrentBESS2');
    logsout_iGrid = logsout.get('iGRID2');
    plotTitle = 'Microgrid2 Voltage and Current';
end

% Plot results
flag=sum(logsout_vabcBESS.Values.Data>1+voltageLimit)+sum(logsout_vabcBESS.Values.Data<-1-voltageLimit);

simlog_handles(1) = subplot(3, 2, 1);
plot(logsout_vabcBESS.Values.Time, logsout_vabcBESS.Values.Data, 'LineWidth', 1)
hold on 
if flag>0
plot([2.9 3.1],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
plot([2.9 3.1],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
title('BESS Three-Phase Voltage', 'Outside Acceptable Limit ', 'Color','red')

else
plot([2, 8],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot([2, 8],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
title('BESS Three-Phase Voltage', 'Within Acceptable Limit ', 'Color','green')

end
grid on
ylabel('Voltage (pu)')
xlabel('Time (s)')
axis([2.9 3.1 -1.2 1.2])

simlog_handles(2) = subplot(3, 2, 3);
plot(logsout_iBESS.Values.Time, logsout_iBESS.Values.Data, 'LineWidth', 1)
grid on
title('BESS Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([2.9 3.1 -1.1 1.1 ])

simlog_handles(3) = subplot(3, 2, 5);
plot(logsout_iGrid.Values.Time, logsout_iGrid.Values.Data, 'LineWidth', 1)
grid on
title('Grid Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([2.9 3.1 -1.2 1.2])

simlog_handles(1) = subplot(3, 2, 2);
plot(logsout_vabcBESS.Values.Time, logsout_vabcBESS.Values.Data,'LineWidth',1)
grid on
hold on
if flag>0
plot([tStart tStop],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
plot([tStart tStop],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
title('BESS Three-Phase Voltage','Outside Acceptable Limit ', 'Color','red')

else
plot([tStart tStop],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot([tStart tStop],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
title('BESS Three-Phase Voltage', 'Within Acceptable Limit ', 'Color','green')

end
ylabel('Voltage (pu)')
xlabel('Time (s)')
axis([tStart tStop -1.2 1.2 ])

simlog_handles(2) = subplot(3, 2, 4);
plot(logsout_iBESS.Values.Time, logsout_iBESS.Values.Data, 'LineWidth', 1)
grid on
title('BESS Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tStart tStop -1.1 1.1  ])

simlog_handles(3) = subplot(3, 2, 6);
plot(logsout_iGrid.Values.Time, logsout_iGrid.Values.Data, 'LineWidth', 1)
grid on
title('Grid Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tStart tStop -1 1   ])

linkaxes(simlog_handles, 'x')
sgtitle(plotTitle,'Fontsize',15);
end
