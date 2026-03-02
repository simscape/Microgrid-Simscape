function openBlock(blockPath)
%This function opens the block mask

% Copyright 2026 The MathWorks, Inc.
arguments
    blockPath = gcb;
end

open_system(blockPath,'mask');
end