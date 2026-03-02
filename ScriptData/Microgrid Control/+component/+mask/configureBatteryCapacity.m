function configureBatteryCapacity(blockPath)
%This function enables or disables the battery capacity parameter

% Copyright 2026 The MathWorks, Inc.
arguments
    blockPath = gcb;
end
capacityType = get_param(blockPath,"capacityType");

maskObj = Simulink.Mask.get(blockPath);
allNames = {maskObj.Parameters.Name};
capIdx = find(strcmp(allNames, 'capacity'));
if strcmp(capacityType,'Fixed')
    maskObj.Parameters(capIdx).Visible = 'on';
else
    maskObj.Parameters(capIdx).Visible = 'off';
end
end