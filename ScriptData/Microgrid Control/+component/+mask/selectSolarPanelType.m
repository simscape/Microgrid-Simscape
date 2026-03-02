function selectSolarPanelType()


% Copyright 2026 The MathWorks, Inc.
blockPath = [gcb,'/','Simplified','/','solar_plant'];
blockHandle = get_param(blockPath, 'Handle');
panelType = get_param(gcb,'panelType');
switch panelType
    case 'Poly-crystalline'
        set_param(blockHandle,'PVTech','PanelTechnology.polycrystallinePanel');
    case 'Mono-crystalline'
        set_param(blockHandle,'PVTech','PanelTechnology.monocrystallinePanel');
    case 'Cadmium-Telluride'
        set_param(blockHandle,'PVTech','PanelTechnology.cadmium-telluridePanel');
    otherwise
        set_param(blockHandle,'PVTech','PanelTechnology.others');

end