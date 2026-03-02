function openConverterParameters()
%This function opens the solar cell block 

% Copyright 2026 The MathWorks, Inc.
converterFidelity = get_param(gcb,'converterFidelity');
blockPath = [gcb,'/','Detailed','/','PV Plant & Controller','/','PV Plant','/','Converter','/',converterFidelity,'/','Converter'];
blockHandle = get_param(blockPath, 'Handle');

open_system(blockHandle,'mask');
end