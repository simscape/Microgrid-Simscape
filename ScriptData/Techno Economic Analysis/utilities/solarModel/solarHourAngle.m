% Function to find solar hour angle.

% Copyright 2024 The MathWorks, Inc.

function hourAngle = solarHourAngle(ASThrs)
    hourAngle = (ASThrs - 12)*15;
end