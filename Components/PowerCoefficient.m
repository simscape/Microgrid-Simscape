classdef PowerCoefficient < int32
   enumeration
     tableLookUp (1)
     estimate (2)
   end
   methods(Static)
       function map = displayText()
         map = containers.Map;
         map('tableLookUp') = 'Look Table';
         map('estimate') = 'Estimate';
       end
   end
end