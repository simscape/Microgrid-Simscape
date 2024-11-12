% Function to find solar radiation on a particular day.

% Copyright 2024 The MathWorks, Inc.

function solarRadiation = getSunRadiationOnTheDay(geoLocation,year,day,clockHrs,dayLightHrs)
    arguments
        geoLocation (1,3) table {mustBeNonempty}
        year (1,1) {mustBeNonnegative}
        day (1,1) {mustBeNonnegative,mustBeInRange(day,0,366)}
        clockHrs (1,1) {mustBeNonnegative,mustBeInRange(clockHrs,0,24)}
        dayLightHrs (1,1) {mustBeNonnegative}
    end
    sunAngles = getSolarRadiationAngle(year,day,clockHrs,geoLocation,dayLightHrs);
    omega = deg2rad(sunAngles.solarHrAngle);
    delta = deg2rad(sunAngles.declinationAngleOnThatDay);
    lat   = deg2rad(str2num(geoLocation.Latitude{1,1}(1:end-1)));
    if clockHrs >= sunAngles.sunrise && clockHrs <= sunAngles.sunset
        Gsc = 1367; % W/m^2
        solarRadiation = max(0,Gsc*(1+0.033*cos(deg2rad(360*day/365)))*(cos(lat)*cos(delta)*cos(omega)+sin(lat)*sin(delta))); % W/m^2
    else
        solarRadiation = 0;
    end
end