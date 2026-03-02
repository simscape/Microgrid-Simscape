function setPanelNumber

% Copyright 2026 The MathWorks, Inc.
[nPanelSeries,nPanelParallel] = scaleSolarPlant;
set_param(gcb,'nSeries',num2str(nPanelSeries));
set_param(gcb,'nParallel',num2str(nPanelParallel));
end