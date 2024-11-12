function components = setComponents(solution,components)
% Copyright 2024 The MathWorks, Inc.
    
% This function create the list of components which are part of the analysis

% Uncomment all the blocks
allBlocks = {'IC Generator','Generator','IC Solar','Solar','IC Wind','Wind','IC BESS','BESS'};
for blockIdx = 1:length(allBlocks)
    set_param(['TechnoEconomicMicrogrid','/',allBlocks{blockIdx}],'commented','off');
end

if solution.generatorRating < 0.1
    genBlock = {'IC Generator','Generator'};
    commentBlocks(genBlock);
    components(5) = [];
end

if solution.solarRating < 0.1
    solarBlock = {'IC Solar','Solar'};
    commentBlocks(solarBlock);
    components(2) = [];
end

if solution.windRating < 0.1
    windBlock = {'IC Wind','Wind'};
    commentBlocks(windBlock);
    components(3) = [];
end

if solution.batteryEnergyRating < 0.1
    batteryBlock = {'IC BESS','BESS'};
    commentBlocks(batteryBlock);
    components(4) = [];
end