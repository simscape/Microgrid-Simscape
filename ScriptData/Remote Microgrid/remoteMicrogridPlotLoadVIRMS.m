function remoteMicrogridPlotLoadVIRMS(logsout,caseNum)
% Function to plot simulation results from remote_microgrid
% Plot Description:
%
% This plot shows the load voltage and load current.

% Copyright 2022 - 2023 The MathWorks, Inc.

% Create a new figure
h2a_remote_microgrid = figure('Name', 'h2a_remote_microgrid');
figure(h2a_remote_microgrid)
clf(h2a_remote_microgrid)

% selecting time axis for the plot
switch caseNum
    case 1
        tStart = 5.9;
        tStop = 6.1;
    case 2
        tStart = 5.9;
        tStop = 6.1;
    case 3
        tStart = 7.2;
        tStop = 7.4;
    case 4
        tStart = 7.4;
        tStop = 7.6;
end

% Plot remote microgrid
% Get simulation results
logsout_LoadVRMS = logsout.get('LVoltageRMS');
logsout_LoadCRMS = logsout.get('LCurrentRMS');
logsout_LoadF2VRMS = logsout.get('LoadVoltageF2RMS');
logsout_LoadF2CRMS = logsout.get('LoadCurrentF2RMS');

% Plot results
simlog_handles(1) = subplot(2, 2, 1);
Voltage=squeeze(logsout_LoadVRMS.Values.Data);
plot(logsout_LoadVRMS.Values.Time, Voltage(1,:), 'LineWidth', 1) % ploting single phase RMS
hold on
VoltageLV=squeeze(logsout_LoadF2VRMS.Values.Data);
plot(logsout_LoadF2VRMS.Values.Time, VoltageLV(1,:), 'LineWidth', 1) % ploting single phase RMS

grid on
axis([2.9 3.1 0 1.3])
title('Load RMS Voltage ')
ylabel('Voltage (p.u.)')
xlabel('Time (s)')
legend({'MV Load', 'LV Load' });

simlog_handles(1) = subplot(2, 2, 2);
Voltage=squeeze(logsout_LoadVRMS.Values.Data);
plot(logsout_LoadVRMS.Values.Time, Voltage(1,:), 'LineWidth', 1) % ploting single phase RMS

hold on
VoltageLV=squeeze(logsout_LoadF2VRMS.Values.Data);
plot(logsout_LoadF2VRMS.Values.Time, VoltageLV(1,:), 'LineWidth', 1) % ploting single phase RMS

grid on
axis([tStart tStop 0 1.3])
title('Load RMS Voltage ')
ylabel('Voltage (p.u.)')
xlabel('Time (s)')
legend({'MV Load', 'LV Load' });

simlog_handles(1) = subplot(2, 2, 3);
Current= squeeze(logsout_LoadCRMS.Values.Data);
plot(logsout_LoadCRMS.Values.Time, Current(1,:), 'LineWidth', 1) % ploting single phase RMS
hold on
CurrentLV=squeeze(logsout_LoadF2CRMS.Values.Data);
plot(logsout_LoadF2CRMS.Values.Time, CurrentLV(1,:), 'LineWidth', 1) % ploting single phase RMS

grid on
axis([2.9 3.1 0 1.1])
title('Load RMS Current  ')
ylabel('Current (p.u.)')
xlabel('Time (s)')
legend({'MV Load', 'LV Load' });

simlog_handles(1) = subplot(2, 2, 4);
Current= squeeze(logsout_LoadCRMS.Values.Data);
plot(logsout_LoadCRMS.Values.Time, Current(1,:), 'LineWidth', 1) % ploting single phase RMS
hold on
CurrentLV=squeeze(logsout_LoadF2CRMS.Values.Data);
plot(logsout_LoadF2CRMS.Values.Time, CurrentLV(1,:), 'LineWidth', 1) % ploting single phase RMS

grid on
axis([5.9 6.1  0 1.1])
title('Load RMS Current  ')
ylabel('Current (p.u.)')
xlabel('Time (s)')
legend({'MV Load', 'LV Load' });
linkaxes(simlog_handles, 'x')
end
