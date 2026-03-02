classdef ModellingOption < int32

% Copyright 2025 The MathWorks, Inc.
    
   enumeration
     maximumPower (1)
     powerReference (2)
   end
   methods(Static)
       function map = displayText()
         map = containers.Map;
         map('maximumPower') = 'Maximum Power-Point Tracking';
         map('powerReference') = 'Power Reference';
       end
   end
end