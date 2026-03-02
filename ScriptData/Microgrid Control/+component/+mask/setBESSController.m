function setBESSController(blockPath)

% Copyright 2026 The MathWorks, Inc.

arguments
    blockPath = [gcb,'/','Detailed','/','BESS Controller'];
end

choice = get_param(gcb,'bessController');

switch choice
    case 'Grid Following'
        set_param(blockPath, 'LabelModeActiveChoice', 'Grid Following');
    case 'Grid Forming'
         set_param(blockPath, 'LabelModeActiveChoice', 'Grid Forming');
    otherwise
        disp('Choose proper variant');
end
end