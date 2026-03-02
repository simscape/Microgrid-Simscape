function converterFidelityPlant
%This function displays the appropriate mask options depending on the
%fidelity chosen

% Copyright 2026 The MathWorks, Inc.
choice = get_param(gcb,'converterFidelity');
maskObj = Simulink.Mask.get(gcb);
allNames = {maskObj.Parameters.Name};
fSwIdx = find(strcmp(allNames, 'fSw'));

switch choice
    case 'Average'
         maskObj.Parameters(fSwIdx).Visible = 'off';
    case 'Switching'
         maskObj.Parameters(fSwIdx).Visible = 'on';
    otherwise
        disp('Choose proper variant');
end
end