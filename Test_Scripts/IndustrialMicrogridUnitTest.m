classdef IndustrialMicrogridUnitTest < matlab.unittest.TestCase
    %% Class implementation of unit test

    % Copyright 2023 The MathWorks, Inc.

    methods (Test)
        function IndustrialMicrogrid_Test(~)
            close all
            bdclose all
            IndustrialMicrogridDesign
            close all
            bdclose all
        end

    end % methods (Test)
end % classdef