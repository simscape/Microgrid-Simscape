%% Script to run unit tests
% This script runs the unit test and generates the code coverage report

% Copyright 2023 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

topFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromFile(...
fullfile(topFolder, "Test_Scripts", "RemoteMicrogridUnitTest.m"));

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
  MainFile = "Remote Microgrid Coverage" + relStr + ".html" );
list = dir(fullfile(topFolder, 'ScriptData','Remote Microgrid'));
fileList = arrayfun(@(x)[x.folder, filesep, x.name], list, 'UniformOutput', false);
plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile(fileList(3:end),Producing = coverageReport);

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
