%% Script to run unit tests
% This script runs the unit test and generates the code coverage report

% Copyright 2024 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

topFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromFile(...
fullfile(topFolder, "Test_Scripts", "TechnoEconomicAnalysisUnitTest.m"));

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

%% MATLAB Code Coverage Report

coverageReportFolder = fullfile(topFolder, "coverage" + relStr);
if not(isfolder(coverageReportFolder))
  mkdir(coverageReportFolder)
end

HTMLFile = "Techno Economic Analysis of Microgrids Coverage" + relStr + ".html";

%% Folders to cover
folders = {topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'plottingFunctions',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'+getValues',...
    topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'+constraints',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'+optimizationVariable',...
    topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'utilities',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'+forecast'};
folders = cellfun(@(x) char(x), folders, 'UniformOutput', false);

%% Files to cover
files = {topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'MicrogridTechnoEconomic.mlx',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'SensitivityAnalysis.mlx',...
    topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'TechnoEconomicAnalysisInput.mlx',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'TechnoEconomicAnalysis.mlx',...
    topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'MicrogridOptimization.mlx',topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'OptimizeMicrogrid.m',...
    topFolder+filesep+'ScriptData'+filesep+'Techno Economic Analysis'+filesep+'MicrogridOptimization.mlx'};
files = cellfun(@(x) char(x), files, 'UniformOutput', false);

%% Create plugin
folderFormat = matlab.unittest.plugins.codecoverage.CoverageResult;
fileFormat = matlab.unittest.plugins.codecoverage.CoverageResult;
pluginFolder = matlab.unittest.plugins.CodeCoveragePlugin.forFolder( ...
  folders,'IncludingSubfolders',true,...
  Producing =  folderFormat );
pluginFile = matlab.unittest.plugins.CodeCoveragePlugin.forFile(files,...
  Producing = fileFormat );

addPlugin(runner, pluginFolder);
addPlugin(runner, pluginFile);

%% Run tests
results = run(runner, suite);
resultFolder = folderFormat.Result;
resultFile = fileFormat.Result;
generateHTMLReport(resultFolder + resultFile,coverageReportFolder,MainFile=HTMLFile)

