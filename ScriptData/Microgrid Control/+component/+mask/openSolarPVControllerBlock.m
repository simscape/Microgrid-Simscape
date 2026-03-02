function openSolarPVControllerBlock(blockPath)
%This function opens the solar PV controller block 

% Copyright 2026 The MathWorks, Inc.
blockHandle = get_param(blockPath, 'Handle');
open_system(blockHandle,'mask');
end