% Function to find solar azimuth angle.

% Copyright 2024 The MathWorks, Inc.

function azimuthAngle = solarAzimuthAngle(declinationAngle,solarHrAngle,solarAltitudeDeg)
    % Angle between sun rays and south direction on a horizontal
    % plane. Varies between +180 to -180 degrees. Positive on east of
    % south. Some literature calculates this angle in clockwise direction
    % wrt north.
    azimuthAngle = rad2deg(asin(...
                        cos(deg2rad(declinationAngle))*sin(deg2rad(solarHrAngle))/cos(deg2rad(solarAltitudeDeg))...
                        ));
end