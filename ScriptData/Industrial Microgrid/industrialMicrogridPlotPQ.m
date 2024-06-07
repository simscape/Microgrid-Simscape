function industrialMicrogridPlotPQ(logsout,caseNum,microgrid)
% Function to plot simulation results from Industrial Microgrid
% Plot Description:
%
% This plot shows the active and reactive power of BESS, PV, Diesel, and load.

% Copyright 2023 The MathWorks, Inc.

% Create new figure
h2_IndustrialMicrogrid = figure('Name', 'h2_IndustrialMicrogrid');
figure(h2_IndustrialMicrogrid)
clf(h2_IndustrialMicrogrid)

% Get simulation results
if strcmp(microgrid,'Microgrid1')
    logsout_PBESS = logsout.get('PBESSMW1');
    logsout_QBESS = logsout.get('QBESSMVAR1');
    logsout_PGRID = logsout.get('PGRIDMW1');
    logsout_QGRID = logsout.get('QGRIDMVAR1');
    logsout_PLoad = logsout.get('PLoadMW1');
    logsout_QLoad = logsout.get('QLoadMVAR1');
else
    logsout_PBESS = logsout.get('PBESSMW2');
    logsout_QBESS = logsout.get('QBESSMVAR2');
    logsout_PGRID = logsout.get('PGRIDMW2');
    logsout_QGRID = logsout.get('QGRIDMVAR2');
    logsout_PPV = logsout.get('PPVMW');
    logsout_QPV = logsout.get('QPVMVAR');
    logsout_PLoad = logsout.get('PLoadMW2');
    logsout_QLoad = logsout.get('QLoadMVAR2');
end

% Plot results

simlog_handles(1) = subplot(2, 1, 1);
plot(logsout_PBESS.Values.Time, logsout_PBESS.Values.Data, 'LineWidth', 1);
hold on;
plot(logsout_PGRID.Values.Time, logsout_PGRID.Values.Data, 'LineWidth', 1)
hold on;
plot(logsout_PLoad.Values.Time, logsout_PLoad.Values.Data, 'LineWidth', 1);

grid on

if caseNum == 5
    yActiveScale = [-0.5 2.5];
else
    yActiveScale = [-0.5 1];
end

axis([2.5 8 yActiveScale])
title('Active Power ')
ylabel('Active Power (MW)')
xlabel('Time (s)')
if strcmp(microgrid,'microgrid2')
    hold on;
    plot(logsout_PPV.Values.Time, logsout_PPV.Values.Data, 'LineWidth', 1);
    legend({'BESS', 'Grid','Load','PV'},'NumColumns',2);
end
legend({'BESS', 'Grid','Load'},'NumColumns',2);

simlog_handles(1) = subplot(2, 1, 2);
plot(logsout_QBESS.Values.Time, logsout_QBESS.Values.Data, 'LineWidth', 1);
hold on;
plot(logsout_QGRID.Values.Time, logsout_QGRID.Values.Data, 'LineWidth', 1);
hold on;
plot(logsout_QLoad.Values.Time, logsout_QLoad.Values.Data, 'LineWidth', 1);
grid on;

if caseNum == 5
    yReactiveScale = [-0.2 0.2];
else
    yReactiveScale = [-0.2 1.5];
end
axis([2.5 8 yReactiveScale])
title('Reactive Power ')
ylabel('Reactive Power (MVAr)')
xlabel('Time (s)')
if strcmp(microgrid,'Microgrid2')
    hold on;
    plot(logsout_QPV.Values.Time, logsout_QPV.Values.Data, 'LineWidth', 1)
    legend({'BESS', 'Grid','PV', 'Load'},'NumColumns',2);
    plotTitle = 'Microgrid2 Active and Reactive powers';
else
    legend({'BESS', 'Grid','Load'},'NumColumns',2);
    plotTitle = 'Microgrid1 Active and Reactive powers';
end
sgtitle(plotTitle,'Fontsize',14);
linkaxes(simlog_handles, 'x')
end
