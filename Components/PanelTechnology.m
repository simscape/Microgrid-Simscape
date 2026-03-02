classdef PanelTechnology < int32

 % Copyright 2025 The MathWorks, Inc.
   enumeration
     polycrystallinePanel (1)
     monocrystallinePanel (2)
     cadmium_telluridePanel (3)
     others (4)
   end
   methods(Static)
       function map = displayText()
         map = containers.Map;
         map('polycrystallinePanel') = 'Poly-Crystalline';
         map('monocrystallinePanel') = 'Mono-Crystalline';
         map('cadmium_telluridePanel') = 'Cadmium-Telluride';
         map('others') = 'Others';
       end
   end
end