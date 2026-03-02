function [seriesPanels,parallelPanels] = scaleSolarPlant
%This function opens the block parameterization manager for the solar cell
%block

% Copyright 2026 The MathWorks, Inc.

blockPath = [gcb,'/','Detailed','/','PV Plant & Controller','/','PV Plant','/','PV Array'];
[Voc,Isc] = getVocIsc(blockPath);

maskParameters = get_param(gcb,'MaskWSVariables');
allNames = {maskParameters.Name};
powerIdx = strcmp(allNames, 'plantRating');
voltageIdx = strcmp(allNames, 'Vac');
ratedPower = maskParameters(powerIdx).Value;
Vac =maskParameters(voltageIdx).Value;
Vdc = ceil(Vac*sqrt(2)*1.2);
pattern = '[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?';
nSeries = str2double(regexp(get_param(blockPath,"N_series"), pattern, 'match'));
panelPower = Voc*Isc*0.9*nSeries*0.85;
%nParallel = get_param(blockPath,"N_parallel");
panelVoltage = nSeries*Voc*0.9;

seriesPanels = ceil(Vdc/panelVoltage);
parallelPanels = ceil(ratedPower*1000/(panelPower.value*seriesPanels));
end

