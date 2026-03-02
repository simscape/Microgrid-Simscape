function fidelitySelection(detailedTabs,simplifiedTabs)
%This function displays the appropriate mask options depending on the
%fidelity chosen

% Copyright 2026 The MathWorks, Inc.

arguments
   detailedTabs = {'cellDetailed','controllerDetailed','converter'};
    simplifiedTabs = {'cellSimplified'};
end

choice = get_param(gcb,'fidelity');
blockPath = gcb;
maskObj = Simulink.Mask.get(gcb);

switch choice
    case 'Detailed'
        set_param(blockPath, 'LabelModeActiveChoice', 'Detailed');
         for tabIdx = 1:length(detailedTabs)
            tab = maskObj.getDialogControl(detailedTabs{tabIdx});
            tab.Visible = 'on';
         end
         for tabIdx = 1:length(simplifiedTabs)
            tab = maskObj.getDialogControl(simplifiedTabs{tabIdx});
            tab.Visible = 'off';
         end
    case 'Simplified'
         set_param(blockPath, 'LabelModeActiveChoice', 'Simplified');
         for tabIdx = 1:length(detailedTabs)
            tab = maskObj.getDialogControl(detailedTabs{tabIdx});
            tab.Visible = 'off';
         end
         for tabIdx = 1:length(simplifiedTabs)
            tab = maskObj.getDialogControl(simplifiedTabs{tabIdx});
            tab.Visible = 'on';
         end
    otherwise
        disp('Choose proper variant');
end
end