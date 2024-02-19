classdef RemoteMicrogridUnitTest < matlab.unittest.TestCase
    %% Class implementation of unit test

    % Copyright 2023 The MathWorks, Inc.

    properties
        openfigureListBefore;
        openModelsBefore;
    end

    methods(TestMethodSetup)
        % This function will be executed before each test point runs
        function listOpenFigures(test)
            % List all open figures
            test.openfigureListBefore = findall(0,'Type','Figure');
        end

        function listOpenModels(test)
            % List all open simulink models
            test.openModelsBefore = get_param(Simulink.allBlockDiagrams('model'),'Name');
        end
    end

    methods(TestMethodTeardown)
        % This function will be executed after each test point runs
        function closeOpenedFigures(test)
            % Close all figure opened during test
            figureListAfter = findall(0,'Type','Figure');
            figuresOpenedByTest = setdiff(figureListAfter, test.openfigureListBefore);
            arrayfun(@close, figuresOpenedByTest);
        end

        function closeOpenedModels(test)
            % Close all models opened during test
            openModelsAfter = get_param(Simulink.allBlockDiagrams('model'),'Name');
            modelsOpenedByTest = setdiff(openModelsAfter, test.openModelsBefore);
            close_system(modelsOpenedByTest, 0);
        end
    end

    methods (Test)
        function IndustrialMicrogrid_Test(~)
            RemoteMicrogridDesign
        end
    end % methods (Test)
end % classdef