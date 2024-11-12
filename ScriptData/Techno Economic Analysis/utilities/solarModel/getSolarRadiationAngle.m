% Function to get solar radiation angle.

% Copyright 2024 The MathWorks, Inc.

function solarData = getSolarRadiationAngle(yr,nDay,clockHrs,geoLocation,dayLghtSav)
    % Process geographic data
    geoLat = str2double(geoLocation.Latitude{1,1}(1,1:end-1));
    geoLong = str2double(geoLocation.Longitude{1,1}(1,1:end-1));
    stdTimeZone = str2double(geoLocation.("Meredian (Time Zone)"){1,1}(1,1:end-1));
    % Find hemisphere
    if strcmp("N",geoLocation.Latitude{1,1}(end)) || strcmp("n",geoLocation.Latitude{1,1}(end))
        hemisphereNS = "Northern";
    else
        hemisphereNS = "Southern";
    end
    if strcmp("E",geoLocation.Longitude{1,1}(end)) || strcmp("e",geoLocation.Longitude{1,1}(end))
        hemisphereEW = "Eastern";
    else
        hemisphereEW = "Western";
    end
    % Sunrise and sunset time
    [solarData.sunrise, solarData.sunset] = calcSunriseAndSunsetTime(yr,nDay,geoLat,geoLong,stdTimeZone,dayLghtSav);

    solarData.ASThrs = getLocalClockTime(geoLong,stdTimeZone,yr,nDay,clockHrs,dayLghtSav);
    solarHrAngle = solarHourAngle(solarData.ASThrs);
    declinationAngleOnThatDay = solarDeclinationAngle(nDay);
    solarAltitudeDeg = solarAltitude(geoLat,declinationAngleOnThatDay,solarHrAngle);
    surfaceAzimuthAngle = solarAzimuthAngle(declinationAngleOnThatDay,solarHrAngle,solarAltitudeDeg);

    solarData.solarHrAngle = solarHrAngle;
    solarData.declinationAngleOnThatDay = declinationAngleOnThatDay;
    solarData.solarAltitudeDeg = solarAltitudeDeg;
    solarData.surfaceAzimuthAngle = surfaceAzimuthAngle;
    solarData.hemisphereNS = hemisphereNS;
    solarData.hemisphereEW = hemisphereEW;
end