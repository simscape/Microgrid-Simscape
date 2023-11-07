function switchSubsystems(microgridSubsystems,microgrid,switchInput)
% This function is used for activating and deactiving the microgrid
% subsystems

% Copyright 2023 The MathWorks, Inc.

subSystems = find(contains(microgridSubsystems,strcat('/',microgrid)));
for index = 1:length(subSystems)
    set_param(char(microgridSubsystems(subSystems(index))),'commented',switchInput);
end
end