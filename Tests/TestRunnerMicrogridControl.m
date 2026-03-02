%% Script to run unit tests
% This script runs the unit test and generates the code coverage report

% Copyright 2023-2016 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

topFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromFile(...
fullfile(topFolder, "Tests", "MicrogridControlWorkflowTest.m"));

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
  MainFile = "Microgrid Control Coverage" + relStr + ".html" );


% Known file names (no paths)
knownNames = [
    "BESSCharging.m"
    "MicrogridControlDesign.mlx"
    "MicrogridControlParam.m"
    "MicrogridParam.m"
    "NormalOperation.m"
    "PlannedIslandParam.m"
    "PlannedIslandingControl.m"
    "ResynchronizationControl.m"  
];

% List directory contents
list = dir(fullfile(topFolder, 'ScriptData', 'Microgrid Control'));

% Keep only files (drop folders like '.' and '..')
list = list(~[list.isdir]);

% Filter by exact name (case-insensitive)
namesLower = lower({list.name});
mask = ismember(namesLower, lower(cellstr(knownNames)));

% Build full paths for the filtered set
fileList = arrayfun(@(x) fullfile(x.folder, x.name), list(mask), 'UniformOutput', false);
% list = dir(fullfile(topFolder, 'ScriptData','Microgrid Control'));
% fileList = arrayfun(@(x)[x.folder, filesep, x.name], list, 'UniformOutput', false);
plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile(fileList(5:end),Producing = coverageReport);

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
