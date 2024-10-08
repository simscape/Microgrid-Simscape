function remoteMicrogridPlotLoadVI(logsout,tEvent,tStart,tStop)
% Function to plot simulation results from remote_microgrid
% Plot Description:
%
% This plot shows the load voltage and load current.

% Copyright 2022 - 2023 The MathWorks, Inc.

% Create new figure
h2_remote_microgrid = figure('Name', 'h2_remote_microgrid');
figure(h2_remote_microgrid)

clf(h2_remote_microgrid)

% Plot remote microgrid
% Get simulation results
logsout_LoadV = logsout.get('LVoltage');
logsout_LoadC = logsout.get('LCurrent');

% Plot results
simlog_handles(1) = subplot(2, 2, 1);
plot(logsout_LoadV.Values.Time, logsout_LoadV.Values.Data, 'LineWidth', 1)

grid on
axis([tEvent-1 tEvent+1 -1.3 1.3])
title('Three-Phase MV Load Voltage ')
ylabel('Voltage (p.u.)')
xlabel('Time (s)')

simlog_handles(1) = subplot(2, 2, 2);
plot(logsout_LoadV.Values.Time, logsout_LoadV.Values.Data, 'LineWidth', 1)

grid on
axis([tStart tStop  -1.3 1.3])
title('Three-Phase MV Load Voltage ')
ylabel('Voltage (p.u.)')
xlabel('Time (s)')

simlog_handles(1) = subplot(2, 2, 3);
plot(logsout_LoadC.Values.Time, logsout_LoadC.Values.Data, 'LineWidth', 1)

grid on
axis([tEvent-1 tEvent+1 -1.3 1.3])
title('Three-Phase MV Load Current ')
ylabel('Current (p.u.)')
xlabel('Time (s)')

simlog_handles(1) = subplot(2, 2, 4);
plot(logsout_LoadC.Values.Time, logsout_LoadC.Values.Data, 'LineWidth', 1)

grid on
axis([tStart tStop  -1.3 1.3])
title('Three-Phase MV Load Current  ')
ylabel('Current (p.u.)')
xlabel('Time (s)')

linkaxes(simlog_handles, 'x')
end
