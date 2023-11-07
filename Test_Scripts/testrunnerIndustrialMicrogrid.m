%% Script to run unit tests
% This script runs the unit test and generates the code coverage report

% Copyright 2021-2023 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

topFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromFile(...
fullfile(topFolder, "Test_Scripts", "IndustrialMicrogridUnitTest.m"));

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

%% MATLAB Code Coverage Report

coverageReportFolder = fullfile(topFolder, "coverage" + relStr);
if not(isfolder(coverageReportFolder))
  mkdir(coverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  coverageReportFolder, ...
  MainFile = "Industrial Microgrid Coverage" + relStr + ".html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [fullfile(topFolder, "ScriptData","Industrial Microgrid", "IndustrialMicrogridDesign.mlx")
  fullfile(topFolder, "ScriptData", "Industrial Microgrid", "IndustrialMicrogridInputData.mlx")
  fullfile(topFolder, "ScriptData", "Industrial Microgrid", "IndustrialMicrogridDieselCost.m")
  fullfile(topFolder, "ScriptData", "Industrial Microgrid", "IndustrialMicrogridTHDLoad.m")
  fullfile(topFolder, "ScriptData", "Industrial Microgrid", "IndustrialMicrogridLoss.m")],...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
