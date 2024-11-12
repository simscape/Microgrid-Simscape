% Run this script to generate a MAT file containing the information about
% MPPT speed for different wind speed values
% Copyright 2024 The MathWorks, Inc.

windSpeed = 0:1:12;
windSpeed(1) = 0.01;
for windIdx = 1:length(windSpeed) 
       model = 'WindMPPTTestHarness';
       load_system(model);
       modelWS = get_param(model,'ModelWorkspace');
       assignin(modelWS,'windSpeed',windSpeed(windIdx));
       out = sim(model);
        
       % Extract results from simlog
       power = out.logsout.getElement('turbineOutput').Values.Data;
       rotorSpeed = out.logsout.getElement('rotorSpeed').Values.Data;
       [maxPower,maxIdx] = max(power);
       MPPTOmega(windIdx) = rotorSpeed(maxIdx); %#ok<*SAGROW>
end
windMPPT.windSpeed = windSpeed;
windMPPT.rotorSpeed = MPPTOmega;
topFolder = currentProject().RootFolder;
folderPath = strcat(topFolder,filesep,'Data',filesep,'Techno Economic Analysis');
fileName = 'windMPPT.mat';
fullFilePath = fullfile(folderPath, fileName);
save(fullFilePath, 'windMPPT');