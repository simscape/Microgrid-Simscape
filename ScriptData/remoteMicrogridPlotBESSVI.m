% Code to plot simulation results from remote_microgrid
%% Plot Description:
%
% This plot shows the voltage, current, and power output of BESS.

% Copyright 2022 - 2023 The MathWorks, Inc.

remoteMicrogridInputData;

% Initializing case number for parameters if it does not exist



% Generate new simulation results if they don't exist or if they need to be
% updated
if  ~exist('simlog_remote_microgrid', 'var') || ...
        pm_simlogNeedsUpdate(simlog_remote_microgrid)
        sim('remoteMicrogrid',8)
end
% Reuse figure if it exists, else create new figure
if ~exist('h1_remote_microgrid', 'var') || ...
        ~isgraphics(h1_remote_microgrid, 'figure')
    h1_remote_microgrid = figure('Name', 'remote_microgrid');
end
figure(h1_remote_microgrid)
clf(h1_remote_microgrid)
if ~exist('caseNum','var')
    caseNum = 1;
end

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
voltageLimit=Microgrid.VoltageLimit;
plotRemoteMicrogridBESS(logsout_remote_microgrid, tStart, tStop,voltageLimit)

% Plot microgrid planned island

function plotRemoteMicrogridBESS(logsout,tStart, tStop,voltageLimit)

% Get simulation results

logsout_vabcBESS = logsout.get('VabcBESS');
logsout_iBESS = logsout.get('CurrentBESS');
logsout_iGrid = logsout.get('iGRID');


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
ylabel('Voltage (p.u.)')
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
title('Diesel Three-Phase Currents')
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
ylabel('Voltage (p.u.)')
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
title('Diesel Three-Phase Currents')
ylabel('Current (p.u)')
xlabel('Time (s)')
axis([tStart tStop -1 1   ])

linkaxes(simlog_handles, 'x')

end

