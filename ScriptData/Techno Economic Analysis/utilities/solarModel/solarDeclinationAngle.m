% Function to find solar declination angle.

% Copyright 2024 The MathWorks, Inc.

function declinationAngle = solarDeclinationAngle(daysOfTheYear)
    declinationAngle = 23.45*sin(deg2rad((360/365)*(284+daysOfTheYear)));
end