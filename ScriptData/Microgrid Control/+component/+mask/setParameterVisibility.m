function setParameterVisibility

% Copyright 2026 The MathWorks, Inc.
choice = get_param(gcb,'bessController');
fidelity = get_param(gcb,'fidelity');
maskObj = Simulink.Mask.get(gcb);
paramNames = {'maxSOC','minSOC','activeDroop','reactiveDroop'};
for idx = 1:length(paramNames) 
    paramIdx(idx) = find(strcmp({maskObj.Parameters.Name}, paramNames{idx})); %#ok<*AGROW>
end

switch fidelity
    case 'Detailed'
        for idx = 1:length(paramIdx)         
            maskObj.Parameters(paramIdx(idx)).Visible = 'off';
        end
    case 'Simplified'
        if strcmp(choice,'Grid Following')
            for idx = 1:length(paramNames)/2
                maskObj.Parameters(paramIdx(idx)).Visible = 'on';
                maskObj.Parameters(paramIdx(idx+2)).Visible = 'off';
            end
        else
            for idx = (length(paramNames)/2)+1:length(paramNames)
                maskObj.Parameters(paramIdx(idx)).Visible = 'on';
                maskObj.Parameters(paramIdx(idx-2)).Visible = 'off';
            end
        end
    otherwise
        disp('Choose proper variant');
end
end