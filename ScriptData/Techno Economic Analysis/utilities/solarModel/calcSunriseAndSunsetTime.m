% Function to calculate sunrise and sunset time at a given time, at a given
% location.

% Copyright 2024 The MathWorks, Inc.

function [sunriseTime, sunsetTime] = calcSunriseAndSunsetTime(year,nDayOfYear,lat,long,longStdTimeZoneMeredian,dayLightSavingHrs)
    declinationAngleOnThatDay = solarDeclinationAngle(nDayOfYear);
    solarHrAngleCalc = rad2deg(acos(-tan(deg2rad(lat))*tan(deg2rad(declinationAngleOnThatDay))));
    ASThrs = solarHrAngleCalc/15+12;
    EOTminutes = getEquationOfTimeInMinutes(year,nDayOfYear);
    sunsetTime = max(0,min(24,ASThrs + EOTminutes/60 - (long-longStdTimeZoneMeredian)/15 - dayLightSavingHrs));
    sunriseTime = max(0,min(24,12 - (sunsetTime-12)));
end