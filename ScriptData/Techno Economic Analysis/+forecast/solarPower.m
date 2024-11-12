function normalizedSolarPower = solarPower(geoLocation,year,years)
% Copyright 2024 The MathWorks, Inc.

% This function calculates the normalized solar power for a particular
% location
location = {'City'};
geoLocationTable = table({geoLocation.lattitude},{geoLocation.longitude},{geoLocation.Mereidian},...
                              'VariableNames',{'Latitude','Longitude','Meredian (Time Zone)'},...
                              'RowNames',location);
dayLightHrs = 0;
idx = 1;
phi = 12.97;

for days = 1:365
    delta = 23.45 * sind(360/365 * (days+284));
    for time = 1:24
        omega = 15 * (time - 12);
        solarAltDeg = max(0,rad2deg(asin(...
            sin(deg2rad(phi))*sin(deg2rad(delta)) + ...
            cos(deg2rad(phi))*cos(deg2rad(delta))*cos(deg2rad(omega))...
            )));
        gamma = rad2deg(asin(...
            cos(deg2rad(delta))*sin(deg2rad(omega))/cos(deg2rad(solarAltDeg))...
            ));
        beta = 30;
        cosineAngleOfIncidence = sin(phi)*sin(delta)*cos(beta) - ...
            cos(phi)*sin(delta)*sin(beta)*cos(gamma) + ...
            cos(phi)*cos(delta)*cos(omega)*cos(beta) + ...
            sin(phi)*cos(delta)*cos(omega)*sin(beta)*cos(gamma) + ...
            cos(delta)*sin(omega)*sin(beta)*sin(gamma);
        cosineAngleOfIncidence = max(0,cosineAngleOfIncidence);
        cosineAngleOfIncidence = cosineAngleOfIncidence*(phi>0);

        solarIntesity(idx) = getSunRadiationOnTheDay(geoLocationTable,year,days,time,dayLightHrs); %#ok<*AGROW>
        normalizedSolarPower(idx) = solarIntesity(idx)*cosineAngleOfIncidence/1000;
        idx = idx+1;
    end
end
normalizedSolarPower = repmat(normalizedSolarPower',years,1);
normalizedSolarPower = min(normalizedSolarPower,1);
end