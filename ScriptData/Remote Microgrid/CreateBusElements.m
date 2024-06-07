% Copyright 2024 The MathWorks, Inc.

% Create a simulink bus elements for Resync
ResyncElements = {'enable', 'status', 'delay'};
Resync = Simulink.Bus;
booleanIdx = [1,2];
for elementIdx = 1 : length(ResyncElements)
    Resync.Elements(elementIdx) = Simulink.BusElement;
    Resync.Elements(elementIdx).Name = ResyncElements{elementIdx};
    Resync.Elements(elementIdx).Complexity = 'real';
    Resync.Elements(elementIdx).Dimensions = 1;
    if any(elementIdx == booleanIdx)
        Resync.Elements(elementIdx).DataType = 'boolean';
    else
        Resync.Elements(elementIdx).DataType = 'double';
    end
    Resync.Elements(elementIdx).Min = [];
    Resync.Elements(elementIdx).Max = [];
    Resync.Elements(elementIdx).DimensionsMode = 'Fixed';
    Resync.Elements(elementIdx).SamplingMode = 'Sample based';
    Resync.Elements(elementIdx).SampleTime = -1;
    Resync.Elements(elementIdx).DocUnits = '';
    Resync.Elements(elementIdx).Description = '';
end


% Create a simulink bus elements for PlannedIslanding
PlannedIslandingElements = {'enable', 'status', 'delay'};
PlannedIslanding = Simulink.Bus;
booleanIdx = [1,2];
for elementIdx = 1 : length(PlannedIslandingElements)
    PlannedIslanding.Elements(elementIdx) = Simulink.BusElement;
    PlannedIslanding.Elements(elementIdx).Name = PlannedIslandingElements{elementIdx};
    PlannedIslanding.Elements(elementIdx).Complexity = 'real';
    PlannedIslanding.Elements(elementIdx).Dimensions = 1;
    if any(elementIdx == booleanIdx)
        PlannedIslanding.Elements(elementIdx).DataType = 'boolean';
    else
        PlannedIslanding.Elements(elementIdx).DataType = 'double';
    end
    PlannedIslanding.Elements(elementIdx).Min = [];
    PlannedIslanding.Elements(elementIdx).Max = [];
    PlannedIslanding.Elements(elementIdx).DimensionsMode = 'Fixed';
    PlannedIslanding.Elements(elementIdx).SamplingMode = 'Sample based';
    PlannedIslanding.Elements(elementIdx).SampleTime = -1;
    PlannedIslanding.Elements(elementIdx).DocUnits = '';
    PlannedIslanding.Elements(elementIdx).Description = '';
end

% Create a simulink bus elements for Island
IslandElements = {'voltage', 'frequency'};
Island = Simulink.Bus;
for elementIdx = 1 : length(IslandElements)
    Island.Elements(elementIdx) = Simulink.BusElement;
    Island.Elements(elementIdx).Name = IslandElements{elementIdx};
    Island.Elements(elementIdx).Complexity = 'real';
    Island.Elements(elementIdx).Dimensions = 1;
    Island.Elements(elementIdx).DataType = 'double';
    Island.Elements(elementIdx).Min = [];
    Island.Elements(elementIdx).Max = [];
    Island.Elements(elementIdx).DimensionsMode = 'Fixed';
    Island.Elements(elementIdx).SamplingMode = 'Sample based';
    Island.Elements(elementIdx).SampleTime = -1;
    Island.Elements(elementIdx).DocUnits = '';
    Island.Elements(elementIdx).Description = '';
end

% Create a simulink bus elements for Status
StatusElements = {'mode','resync','plannedIslanding','blackStart','resyncEnable','plannedIslandingEnable','loadReference','loadDispatch'};
Status = Simulink.Bus;
booleanIdx = [2,3,4,5,6,8];
enumIdx = 1;
for elementIdx = 1 : length(StatusElements)
    Status.Elements(elementIdx) = Simulink.BusElement;
    Status.Elements(elementIdx).Name = StatusElements{elementIdx};
    Status.Elements(elementIdx).Complexity = 'real';
    Status.Elements(elementIdx).Dimensions = 1;
    if any(elementIdx == booleanIdx)
        Status.Elements(elementIdx).DataType = 'boolean';
    elseif any(elementIdx == enumIdx)
        Status.Elements(elementIdx).DataType = 'Enum: MicrogridStatus';
    else
        Status.Elements(elementIdx).DataType = 'double';
    end
    Status.Elements(elementIdx).Min = [];
    Status.Elements(elementIdx).Max = [];
    Status.Elements(elementIdx).DimensionsMode = 'Fixed';
    Status.Elements(elementIdx).SamplingMode = 'Sample based';
    Status.Elements(elementIdx).SampleTime = -1;
    Status.Elements(elementIdx).DocUnits = '';
    Status.Elements(elementIdx).Description = '';
end

% Create a simulink bus elements for BrKControl
BrKControlElements = {'PCC', 'LoadF2A','LoadF2B'};
BrKControl = Simulink.Bus;
for elementIdx = 1 : length(BrKControlElements)
    BrKControl.Elements(elementIdx) = Simulink.BusElement;
    BrKControl.Elements(elementIdx).Name = BrKControlElements{elementIdx};
    BrKControl.Elements(elementIdx).Complexity = 'real';
    BrKControl.Elements(elementIdx).Dimensions = 1;
    BrKControl.Elements(elementIdx).DataType = 'double';
    BrKControl.Elements(elementIdx).Min = [];
    BrKControl.Elements(elementIdx).Max = [];
    BrKControl.Elements(elementIdx).DimensionsMode = 'Fixed';
    BrKControl.Elements(elementIdx).SamplingMode = 'Sample based';
    BrKControl.Elements(elementIdx).SampleTime = -1;
    BrKControl.Elements(elementIdx).DocUnits = '';
    BrKControl.Elements(elementIdx).Description = '';
end