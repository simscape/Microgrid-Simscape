% Run this script to generate a MAT file containing the information about
% MPPT voltage for different irradiance values

% Copyright 2023 The MathWorks, Inc.
irradianceVec = 0:50:1000 ;  
for index = 1:length(irradianceVec)  
       model = 'SolarMPPTTestHarness';
       load_system(model);
       modelWS = get_param(model,'ModelWorkspace');
       assignin(modelWS,'irradiance',irradianceVec(index));
       assignin(modelWS,'Voc',37.6);
       sim(model);
        
       % Extract results from simlog
       vPanel = simlogMPPTTestHarness.Controlled_Voltage_Source.v.series.values;
       iPanel = simlogMPPTTestHarness.Controlled_Voltage_Source.i.series.values;
       vPanel = vPanel(iPanel>=0);
       iPanel = iPanel(iPanel>=0);
       power = vPanel.*iPanel;
       vMPP(index) = vPanel(power==max(power)); %#ok<*SAGROW>
end
solarMPPT.vMPP = vMPP;
solarMPPT.irradiance = irradianceVec;
topFolder = currentProject().RootFolder;
folderPath = strcat(topFolder,filesep,'Data',filesep,'Techno Economic Analysis');
fileName = 'solarMPPT.mat';
fullFilePath = fullfile(folderPath, fileName);
save(fullFilePath, 'solarMPPT');