function commentBlocks(blocks)
% Copyright 2024 The MathWorks, Inc.
    
% This function disables the blocks which are not part of the analysis
    for blockIdx = 1:length(blocks)
        set_param(['TechnoEconomicMicrogrid','/',blocks{blockIdx}],'commented','on');
    end
end