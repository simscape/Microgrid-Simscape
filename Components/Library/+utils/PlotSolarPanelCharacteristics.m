% This script plots the solar panel characteristics for different
% irradiance and temperature values

% Copyright 2025 The MathWorks, Inc.
close all
irradianceVec = 200:100:1000;
temperatureVec = (25:5:50)+273;

% Get the parameters from the mask
maskVariables = get_param(gcb,'MaskWSVariables');
IscRef = getMaskVariable('IscRef',maskVariables);
VocRef = getMaskVariable('VocRef',maskVariables);

IrRef = getMaskVariable('IrRef',maskVariables);
Ns = getMaskVariable('NsCell',maskVariables);
alpha = getMaskVariable('alpha',maskVariables)/100;
beta = getMaskVariable('beta',maskVariables)/100;
panelType = getMaskVariable('PVTech',maskVariables);
if strcmp(string(panelType),'polycrystallinePanel')
    delta = 0.111;
    n = 1.49;
elseif strcmp(string(panelType),'monocrystallinePanel')
    delta = 0.063;
    n = 1.49;
else
    delta = 0.04;
    n = 2.4;
end
q = 1.602176634e-19; % Charge of an electron (C)
k = 1.380649e-23;    % Boltzmann constant (J/K)

T = 298;
Ir = 1000;
for tIndex = 1:length(temperatureVec)
    Vt = n*k*temperatureVec(tIndex)/q;
    temperature = temperatureVec(tIndex);

    % Simulate I-V characteristics
    % Voltage range from 0 to V_oc
    % Adjust short-circuit current for irradiance
    Isc = IscRef * (Ir / IrRef)* (1 + alpha * (temperature-T));
    Voc = (VocRef+ beta * VocRef*(temperature - T))/(1 + delta * log(IrRef / Ir));
    V = linspace(0, Voc, 200);
    I = Isc * (1 - exp((V - Voc) / ( Vt * Ns)));
    P = V.*I;
    [~,idx] = max(P);
    if tIndex == 1
        plot_VITemperature = figure('Name', 'plot_VITemperature');
        axes_plotVITemperature = axes; 
        plot_PVTemperature = figure('Name', 'plot_PVTemperature');
        axes_plotPVTemperature = axes;        
    end

    figure(plot_VITemperature);
    plot(axes_plotVITemperature,V,I,'LineWidth',1);
    grid on;
    legendEntriesT{tIndex} = strcat(num2str(temperatureVec(tIndex)),char(176),'K'); %#ok<*SAGROW>
    hold on;
    drawnow limitrate;

    figure(plot_PVTemperature);
    plot(axes_plotPVTemperature,V,P,'LineWidth',1);
    grid on;
    hold on;
    drawnow limitrate;

    if tIndex == length(temperatureVec)
        legend(axes_plotVITemperature,legendEntriesT,'Location','best');    
        title(axes_plotVITemperature,'V-I chavateristics at 1000 W/m^2 with different temperature values')
        xlabel(axes_plotVITemperature,'Voltage (V)');
        ylabel(axes_plotVITemperature,'Current (A)');
        legend(axes_plotPVTemperature,legendEntriesT,'Location','best');
        title(axes_plotPVTemperature,'P-V chavateristics at 1000 W/m^2 with different temperature values')
        xlabel(axes_plotPVTemperature,'Voltage (V)');
        ylabel(axes_plotPVTemperature,'Power (W)');
    end
end

temperature = 298;
Vt = n*k*temperature/q;
for irIndex = 1:length(irradianceVec)
    Ir = irradianceVec(irIndex);

    % Simulate I-V characteristics
    % Voltage range from 0 to V_oc
    % Adjust short-circuit current for irradiance
    Isc = IscRef * (Ir / IrRef)* (1 + alpha * (temperature-T));
    Voc = (VocRef+ beta * VocRef*(temperature - T))/(1 + delta * log(IrRef / Ir));
    V = linspace(0, Voc, 50);
    I = Isc * (1 - exp((V - Voc) / ( Vt * Ns)));
    P = V.*I;
    [~,idx] = max(P);
    if irIndex == 1
        plot_VIIrradiance = figure('Name', 'plot_VIIrradiance');        
        axes_plotVIIrradiance = axes;
        plot_PVIrradiance = figure('Name', 'plot_PVIrradiance');     
        axes_plotPVIrradiance = axes;
    end
    legendEntriesIr{irIndex} = strcat(num2str(irradianceVec(irIndex)),'W/m^2');
    figure(plot_VIIrradiance);    
    hold on;
    plot(axes_plotVIIrradiance,V,I,'LineWidth',1);
    grid on;
    figure(plot_PVIrradiance);
    hold on;
    drawnow;
    plot(axes_plotPVIrradiance,V,P,'LineWidth',1);
    grid on;
    if irIndex == length(irradianceVec)
        legend(axes_plotVIIrradiance,legendEntriesIr,'Location','best');
        title(axes_plotVIIrradiance,strcat('V-I chavateristics at 25',char(176),'C with different irradiance values'))
        xlabel(axes_plotVIIrradiance,'Voltage (V)');
        ylabel(axes_plotVIIrradiance,'Current (A)');
        legend(axes_plotPVIrradiance,legendEntriesIr,'Location','best');
        title(axes_plotPVIrradiance,strcat('P-V chavateristics at 25',char(176),'C with different irradiance values'))
        xlabel(axes_plotPVIrradiance,'Voltage (V)');
        ylabel(axes_plotPVIrradiance,'Power (W)');
    end
end


function value = getMaskVariable(varName,maskVariables)
arguments
    varName {mustBeNonempty}
    maskVariables {mustBeNonempty}
end
index = strcmp({maskVariables.Name}, varName);
value = maskVariables(index).Value;
end
