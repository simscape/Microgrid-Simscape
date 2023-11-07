function remoteMicrogridPlotPQ(logsout)
% Function to plot simulation results from remote_microgrid
% Plot Description:
%
% This plot shows the active and reactive power of BESS, PV, Diesel, and load.

% Copyright 2022 - 2023 The MathWorks, Inc.
% Create new figure
h3_remote_microgrid = figure('Name', 'h3_remote_microgrid');
figure(h3_remote_microgrid)
clf(h3_remote_microgrid)

% Get simulation results
logsout_PBESSKW = logsout.get('PBESSKW');
logsout_QBESSKVAR = logsout.get('QBESSKVAR');
logsout_PGRIDKW = logsout.get('PGRIDKW');
logsout_QGRIDKVAR = logsout.get('QGRIDKVAR');
logsout_PPVKW = logsout.get('PPVKWT');
logsout_PLoadKW = logsout.get('PLoadKW');
logsout_QLoadKVAR = logsout.get('QLoadKVAR');
logsout_PLoadF2KW = logsout.get('PLoadF2KW');
logsout_QLoadF2KVAR = logsout.get('QLoadF2KVAR');

% Plot results

simlog_handles(1) = subplot(2, 1, 1);
plot(logsout_PBESSKW.Values.Time, logsout_PBESSKW.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_PGRIDKW.Values.Time, logsout_PGRIDKW.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_PPVKW.Values.Time, logsout_PPVKW.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_PLoadKW.Values.Time, logsout_PLoadKW.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_PLoadF2KW.Values.Time, logsout_PLoadF2KW.Values.Data, 'LineWidth', 1)

grid on
axis([2.5 8 -70 300])
title('Active Power ')
ylabel('Active Power (kW)')
xlabel('Time (s)')
legend({'BESS', 'Diesel','PV','MV Load', 'LV Load'},'NumColumns',3);


simlog_handles(1) = subplot(2, 1, 2);
plot(logsout_QBESSKVAR.Values.Time, logsout_QBESSKVAR.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_QGRIDKVAR.Values.Time, logsout_QGRIDKVAR.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_QLoadKVAR.Values.Time, logsout_QLoadKVAR.Values.Data, 'LineWidth', 1)
hold on
plot(logsout_QLoadF2KVAR.Values.Time, logsout_QLoadF2KVAR.Values.Data, 'LineWidth', 1)
grid on
axis([2.5 8 -50 100])
title('Reactive Power ')
ylabel('Reactive Power (KVAr)')
xlabel('Time (s)')
legend({'BESS', 'Diesel','MV Load', 'LV Load'},'NumColumns',2);

linkaxes(simlog_handles, 'x')
end

