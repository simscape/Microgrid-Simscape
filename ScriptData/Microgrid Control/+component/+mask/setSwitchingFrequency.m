function setSwitchingFrequency(blockPath)
% Copyright 2026 The MathWorks, Inc.
arguments
    blockPath = gcb;
end

converterFidelity = get_param(blockPath,'converterFidelity');
maskObj = Simulink.Mask.get(blockPath);
allNames = {maskObj.Parameters.Name};
fSwIdx = find(strcmp(allNames, 'fSw'));
if strcmp(converterFidelity,'Average')
    maskObj.Parameters(fSwIdx).Visible = 'off';
else
    maskObj.Parameters(fSwIdx).Visible = 'on';
end
end