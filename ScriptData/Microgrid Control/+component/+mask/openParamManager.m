function openParamManager()
%This function opens the block parameterization manager for the solar cell
%block

% Copyright 2026 The MathWorks, Inc.

blockPath = [gcb,'/','Detailed','/','PV Plant & Controller','/','PV Plant','/','PV Array'];
blockHandle = get_param(blockPath, 'Handle');
set_param(blockHandle,'LinkStatus','none');
simscape.parts.internal.app.App.showInstance(blockHandle)
end

