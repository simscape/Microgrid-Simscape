function [VocCell, IscCell] = getVocIsc(blockPath)

% Copyright 2026 The MathWorks, Inc.

pattern = '[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?';
modelOption = get_param(blockPath,'prm');
if contains(modelOption,'eightParameter') || contains(modelOption,'fiveParameter') ...
        || strcmp(modelOption,'3') || strcmp(modelOption,'2')
    N = str2double(regexp(get_param(blockPath,"ec"), pattern, 'match'));
    Vt = 0.0257; % kT/q, k-Boltzmann constant, q- electron charge, T- temperature

    IphValue = str2double(regexp(get_param(blockPath,"Iph"), pattern, 'match'));
    IphUnit = get_param(blockPath,"Iph_unit");
    Iph = convert(simscape.Value(IphValue,IphUnit),"A"); % Convert to ampere

    IsValue = str2double(regexp(get_param(blockPath,"Is"), pattern, 'match'));
    IsUnit = get_param(blockPath,"Is_unit");
    Is = convert(simscape.Value(IsValue,IsUnit),"A"); % Convert to ampere

    VocCell = N*Vt*log((Iph.value/Is.value)+1);
    IscCell = Iph;
else
    VocValue = str2double(regexp(get_param(blockPath,"Voc"), pattern, 'match'));
    VocUnit = get_param(blockPath,"Voc_unit");
    VocWithUnit = convert(simscape.Value(VocValue,VocUnit),"V"); % Convert to volts
    VocCell = VocWithUnit.value;
    IscValue = str2double(regexp(get_param(blockPath,"isc"), pattern, 'match'));
    IscUnit = get_param(blockPath,"Isc_unit");
    IscWithUnit = convert(simscape.Value(IscValue,IscUnit),"A"); % Convert to volts
    IscCell = IscWithUnit.value;
end