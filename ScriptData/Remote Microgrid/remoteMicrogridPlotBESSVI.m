function remoteMicrogridPlotBESSVI(logsout,voltageLimit,tEvent,tStart,tStop)
% Function to plot simulation results from remote_microgrid
%% Plot Description:
%
% This plot shows the voltage, current, and power output of BESS.

% Copyright 2022 - 2023 The MathWorks, Inc.

% Create new figure
h1_remote_microgrid = figure('Name', 'h1_remote_microgrid');
figure(h1_remote_microgrid)
clf(h1_remote_microgrid)

% Plot microgrid planned island
% Get simulation results

logsout_vabcBESS = logsout.get('VabcBESS');
logsout_iBESS = logsout.get('CurrentBESS');
logsout_iGrid = logsout.get('iGRID');

% Plot results
% Neglect the initial data to avoid transients
tPlot = 2;
tIndexStart = find(logsout_vabcBESS.Values.Time > tEvent-0.1,1);
tIndexEnd = find(logsout_vabcBESS.Values.Time > tEvent+0.1,1);
flag=sum(logsout_vabcBESS.Values.Data(tIndexStart:tIndexEnd,1:3)>1+voltageLimit)+sum(logsout_vabcBESS.Values.Data(tIndexStart:tIndexEnd,1:3)<-1-voltageLimit);

simlog_handles(1) = subplot(3, 2, 1);
plot(logsout_vabcBESS.Values.Time, logsout_vabcBESS.Values.Data, 'LineWidth', 1)
hold on 
if flag>0
plot([tEvent-0.1 tEvent+0.1],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
plot([tEvent-0.1 tEvent+0.1],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
title('BESS Three-Phase Voltage', 'Outside Acceptable Limit ', 'Color','red')
else
plot([tEvent-0.1 tEvent+0.1],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot([tEvent-0.1 tEvent+0.1],[-1-voltageLimit,-1-voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
title('BESS Three-Phase Voltage', 'Within Acceptable Limit ', 'Color','green')
end
grid on
ylabel('Voltage (p.u.)')
xlabel('Time (s)')
axis([tEvent-0.1 tEvent+0.1 -1.2 1.2])

simlog_handles(2) = subplot(3, 2, 3);
plot(logsout_iBESS.Values.Time, logsout_iBESS.Values.Data, 'LineWidth', 1)
grid on
title('BESS Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tEvent-0.1 tEvent+0.1 -1.1 1.1 ])

simlog_handles(3) = subplot(3, 2, 5);
plot(logsout_iGrid.Values.Time, logsout_iGrid.Values.Data, 'LineWidth', 1)
grid on
title('Diesel Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tEvent-0.1 tEvent+0.1 -1.2 1.2])

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
ylabel('Voltage (p.u.)')
xlabel('Time (s)')
axis([tStart tStop -1.2 1.2])

simlog_handles(2) = subplot(3, 2, 4);
plot(logsout_iBESS.Values.Time, logsout_iBESS.Values.Data, 'LineWidth', 1)
grid on
title('BESS Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tStart tStop -1.1 1.1])

simlog_handles(3) = subplot(3, 2, 6);
plot(logsout_iGrid.Values.Time, logsout_iGrid.Values.Data, 'LineWidth', 1)
grid on
title('Diesel Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tStart tStop -1 1])

linkaxes(simlog_handles, 'x')
end

