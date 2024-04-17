function remoteMicrogridPlotFreAngle(logsout,caseNum,voltageLimit,frequencyLimit)
% Function to plot simulation results from remote_microgrid
%% Plot Description:
%
% This plot shows the differences (Diesel and microgrid side) in voltage magnitude, frequency, and phase angle.

% Copyright 2022 - 2024 The MathWorks, Inc.
% Create new figure
h4_remote_microgrid = figure('Name', 'h4_remote_microgrid');
figure(h4_remote_microgrid)
clf(h4_remote_microgrid)

% Plot microgrid planned island
% Get simulation results
logsout_islandcommand = logsout.get('IslandCommand');
logsout_islanding = logsout.get('Islanding');
logsout_resynchcommand = logsout.get('ResynchCommand');
logsout_resynchronization = logsout.get('Resynchronization');
logsout_brkstatus = logsout.get('BRKStatus');
logsout_fault = logsout.get('Fault');
logsout_gridfre = logsout.get('GridFre');
logsout_islandfre = logsout.get('IslandFre');
logsout_gridangle = logsout.get('Gridangle');
logsout_islandangle = logsout.get('Islandangle');
logsout_gridvoltage = logsout.get('GridVoltage');
logsout_islandvoltage = logsout.get('IslandVoltage');

simlog_handles(1) = subplot(4, 1, 1);
% Neglect the initial data to avoid transients
tPlot = 2;
tIndex = find(logsout_islandcommand.Values.Time > tPlot,1);
tIndexPLL = find(logsout_gridfre.Values.Time > tPlot,1);
% selecting the plot
switch caseNum
    case 3
 % Plot results
plot(logsout_islandcommand.Values.Time(tIndex:end), logsout_islandcommand.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_islanding.Values.Time(tIndex:end), logsout_islanding.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_brkstatus.Values.Time(tIndex:end), logsout_brkstatus.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
axis([2 8 -0.1 2.5])
title('Planned Island Command and BRK Status')
legend({'Island Command', 'Islanding', 'BRK Status'},'NumColumns',3);

 case 4

plot(logsout_resynchcommand.Values.Time(tIndex:end), logsout_resynchcommand.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_resynchronization.Values.Time(tIndex:end), logsout_resynchronization.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_brkstatus.Values.Time(tIndex:end), logsout_brkstatus.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
axis([2 8 -0.1 2.5])
title(' Resynch Command and BRK Status')
legend({'Resynch Command', 'Resynchronization', 'BRK Status'},'NumColumns',3);

 case 5

plot(logsout_fault.Values.Time(tIndex:end), logsout_fault.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_brkstatus.Values.Time(tIndex:end), logsout_brkstatus.Values.Data(tIndex:end), 'LineWidth', 1)
grid on
axis([2 8 -0.1 2.5])
title(' Fault and BRK Status')
legend({'Fault', 'BRK Status'},'NumColumns',2);
end

flag=sum(logsout_gridfre.Values.Data(tIndexPLL:end)>60+frequencyLimit*60)+sum(logsout_gridfre.Values.Data(tIndexPLL:end)<60-frequencyLimit*60)+...
    sum(logsout_islandfre.Values.Data(tIndex:end)>60+frequencyLimit*60)+sum(logsout_islandfre.Values.Data(tIndex:end)<60-frequencyLimit*60);
simlog_handles(1) = subplot(4, 1, 2);
plot(logsout_gridfre.Values.Time(tIndexPLL:end), logsout_gridfre.Values.Data(tIndexPLL:end), 'LineWidth', 1)
grid on
hold on
plot(logsout_islandfre.Values.Time(tIndexPLL:end), logsout_islandfre.Values.Data(tIndexPLL:end), 'LineWidth', 1)


grid on
if flag>0
plot([2, 8],[60-frequencyLimit*60,60-frequencyLimit*60],'LineWidth',1,'Color','r','LineStyle','-')
plot([2, 8],[60+frequencyLimit*60,60+frequencyLimit*60],'LineWidth',1,'Color','r','LineStyle','-')
title('Diesel and Island  Frequency Outside Acceptable Limit', 'Color','red')

else
  plot([2, 8],[60-frequencyLimit*60,60-frequencyLimit*60],'LineWidth',1,'Color','g','LineStyle','-')
plot([2, 8],[60+frequencyLimit*60,60+frequencyLimit*60],'LineWidth',1,'Color','g','LineStyle','-')
title('Diesel and Island  Frequency Within Acceptable Limit','Color','green')

end
  

axis([2 8 58 67])
ylabel('Frequency (Hz)')
legend({'Diesel Frequency', 'Island Frequency','Frequency Limits'},'NumColumns',3);


simlog_handles(1) = subplot(4, 1, 3);
plot(logsout_gridangle.Values.Time(tIndexPLL:end), logsout_gridangle.Values.Data(tIndexPLL:end), 'LineWidth', 1)
grid on
hold on 
plot(logsout_islandangle.Values.Time(tIndexPLL:end), logsout_islandangle.Values.Data(tIndexPLL:end), 'LineWidth', 1)
grid on
title('Diesel and Island Voltage Angle')
ylabel('Angle (deg)')
axis([2 8 -190 190])
legend({'Diesel voltage angle', 'Island voltage angle'},'NumColumns',2);

flag1=sum(logsout_gridvoltage.Values.Data(tIndexPLL:end)>1+voltageLimit)+sum(logsout_gridvoltage.Values.Data(tIndexPLL:end)<1-voltageLimit)+...
    sum(logsout_islandvoltage.Values.Data(tIndexPLL:end)>1+voltageLimit)+sum(logsout_islandvoltage.Values.Data(tIndexPLL:end)<1-voltageLimit);
simlog_handles(1) = subplot(4, 1, 4); %#ok<*NASGU>
plot(logsout_gridvoltage.Values.Time(tIndexPLL:end), logsout_gridvoltage.Values.Data(tIndexPLL:end), 'LineWidth', 1)

hold on
plot(logsout_islandvoltage.Values.Time(tIndexPLL:end), logsout_islandvoltage.Values.Data(tIndexPLL:end), 'LineWidth', 1,'Color','black')
if flag1>0
plot([2, 8],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
plot([2, 8],[1-voltageLimit,1-voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
title('Diesel and Island Peak Voltage Outside Acceptable Limit ', 'Color','red')

else
plot([2, 8],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
plot([2, 8],[1-voltageLimit,1-voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
title('Diesel and Island  Peak Voltage Within Acceptable Limit ', 'Color','green')

end

grid on
ylabel('Voltage (p.u.)')
xlabel('Time (s)')
axis([2 8 0.85 1.4])
legend({'Diesel voltage ', 'Island voltage ','Voltage limit'},'NumColumns',3);
end

