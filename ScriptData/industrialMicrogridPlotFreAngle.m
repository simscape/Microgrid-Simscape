function industrialMicrogridPlotFreAngle(logsout,caseNum,limit)
% Function to plot simulation results from industrial microgrid
%% Plot Description:
%
% This plot shows the differences (Grid and microgrid side) in voltage magnitude, frequency, and phase angle.

% Copyright 2023 The MathWorks, Inc.

% Create new figure

h5_IndustrialMicrogrid = figure('Name', 'h5_IndustrialMicrogrid');
figure(h5_IndustrialMicrogrid)
clf(h5_IndustrialMicrogrid)

frequencyLimit = limit.frequency;
voltageLimit = limit.voltage;

% Plot microgrid planned island
simlog_handles(1) = subplot(4, 1, 1);

% selecting the plot
switch caseNum
    case 1
        % Get simulation results
        logsout_gridfre = logsout.get('GridFreMG2');
        logsout_islandfre = logsout.get('IslandFreMG2');
        logsout_gridangle = logsout.get('GridAngleMG2');
        logsout_islandangle = logsout.get('IslandAngleMG2');
        logsout_gridvoltage = logsout.get('GridVoltageMG2');
        logsout_islandvoltage = logsout.get('IslandVoltageMG2');
        logsout_islandcommand = logsout.get('IslandCommandMG2');
        logsout_islanding = logsout.get('IslandingMG2');
        logsout_brkstatus = logsout.get('BRKStatusMG2');

        % Plot results
        plot(logsout_islandcommand.Values.Time, logsout_islandcommand.Values.Data, 'LineWidth', 1)
        grid on
        hold on
        plot(logsout_islanding.Values.Time, logsout_islanding.Values.Data, 'LineWidth', 1)
        grid on
        hold on
        plot(logsout_brkstatus.Values.Time, logsout_brkstatus.Values.Data, 'LineWidth', 1)
        grid on
        axis([2 8 -0.1 2.5])
        title('Planned Island Command and BRK Status')
        legend({'Island Command', 'Islanding', 'BRK Status'},'NumColumns',3);
    case 2
        % Get simulation results
        logsout_gridfre = logsout.get('GridFreMG1');
        logsout_islandfre = logsout.get('IslandFreMG1');
        logsout_gridangle = logsout.get('GridAngleMG1');
        logsout_islandangle = logsout.get('IslandAngleMG1');
        logsout_gridvoltage = logsout.get('GridVoltageMG1');
        logsout_islandvoltage = logsout.get('IslandVoltageMG1');
        logsout_resynchcommand = logsout.get('ResynchCommandMG1');
        logsout_resynchronization = logsout.get('ResynchronizationMG1');
        logsout_brkstatus = logsout.get('BRKStatusMG1');

        % change plot to blackstart of MG2
        plot(logsout_resynchcommand.Values.Time, logsout_resynchcommand.Values.Data, 'LineWidth', 1)
        grid on
        hold on
        plot(logsout_resynchronization.Values.Time, logsout_resynchronization.Values.Data, 'LineWidth', 1)
        grid on
        hold on
        plot(logsout_brkstatus.Values.Time, logsout_brkstatus.Values.Data, 'LineWidth', 1)
        grid on
        axis([2 8 -0.1 2.5])
        title(' Resynch Command and BRK Status')
        legend({'Resynch Command', 'Resynchronization', 'BRK Status'},'NumColumns',3);
end

flag=sum(logsout_gridfre.Values.Data>60+frequencyLimit*60)+sum(logsout_gridfre.Values.Data<60-frequencyLimit*60)+...
    sum(logsout_islandfre.Values.Data>60+frequencyLimit*60)+sum(logsout_islandfre.Values.Data<60-frequencyLimit*60);
simlog_handles(1) = subplot(4, 1, 2);
plot(logsout_gridfre.Values.Time, logsout_gridfre.Values.Data, 'LineWidth', 1)
grid on
hold on
plot(logsout_islandfre.Values.Time, logsout_islandfre.Values.Data, 'LineWidth', 1)


grid on
if flag>0
    plot([2, 8],[60-frequencyLimit*60,60-frequencyLimit*60],'LineWidth',1,'Color','r','LineStyle','-')
    plot([2, 8],[60+frequencyLimit*60,60+frequencyLimit*60],'LineWidth',1,'Color','r','LineStyle','-')
    title('Grid and Island  Frequency Outside Acceptable Limit', 'Color','red')

else
    plot([2, 8],[60-frequencyLimit*60,60-frequencyLimit*60],'LineWidth',1,'Color','g','LineStyle','-')
    plot([2, 8],[60+frequencyLimit*60,60+frequencyLimit*60],'LineWidth',1,'Color','g','LineStyle','-')
    title('Grid and Island  Frequency Within Acceptable Limit','Color','green')

end

axis([2 8 58 67])
ylabel('Frequency (Hz)')
legend({'Grid Frequency', 'Island Frequency','Frequency Limits'},'NumColumns',3);

simlog_handles(1) = subplot(4, 1, 3);
plot(logsout_gridangle.Values.Time, logsout_gridangle.Values.Data, 'LineWidth', 1)
grid on
hold on
plot(logsout_islandangle.Values.Time, logsout_islandangle.Values.Data, 'LineWidth', 1)
grid on
title('Grid and Island Voltage Angle')
ylabel('Angle (deg)')
axis([2 8 -190 190])
legend({'Grid voltage angle', 'Island voltage angle'},'NumColumns',2);

flag1=sum(logsout_gridvoltage.Values.Data>1+voltageLimit)+sum(logsout_gridvoltage.Values.Data(1100:end)<1-voltageLimit)+...
    sum(logsout_islandvoltage.Values.Data>1+voltageLimit)+sum(logsout_islandvoltage.Values.Data(1100:end)<1-voltageLimit);
simlog_handles(1) = subplot(4, 1, 4); %#ok<*NASGU>
plot(logsout_gridvoltage.Values.Time, logsout_gridvoltage.Values.Data, 'LineWidth', 1)

hold on
plot(logsout_islandvoltage.Values.Time, logsout_islandvoltage.Values.Data, 'LineWidth', 1,'Color','black')
if flag1>0
    plot([2, 8],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
    plot([2, 8],[1-voltageLimit,1-voltageLimit],'LineWidth',1,'Color','r','LineStyle','-')
    title('Grid and Island Peak Voltage Outside Acceptable Limit ', 'Color','red')
else
    plot([2, 8],[1+voltageLimit,1+voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
    plot([2, 8],[1-voltageLimit,1-voltageLimit],'LineWidth',1,'Color','g','LineStyle','-')
    title('Grid and Island  Peak Voltage Within Acceptable Limit ', 'Color','green')
end

grid on
ylabel('Voltage (pu)')
xlabel('Time (s)')
axis([2 8 0.85 1.2])
legend({'Grid voltage ', 'Island voltage ','Voltage limit'},'NumColumns',3);
end

