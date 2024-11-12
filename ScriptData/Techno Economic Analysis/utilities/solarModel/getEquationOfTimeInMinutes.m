% Function to calculate the equation of time in minutes.

% Copyright 2024 The MathWorks, Inc.

function EOTminutes = getEquationOfTimeInMinutes(fromYear,nDayOfYear)
    nDayOfLeapYear = mod(fromYear,4)*365+nDayOfYear;
    k = 0:5;
    Ak = [2.0870e-4, 9.2869e-3, -5.2258e-2, -1.3077e-3, -2.1867e-3, -1.5100e-4];
    Bk = [0, -1.2229e-1, -1.5698e-1, -5.1602e-3, -2.9823e-3, -2.3463e-4];
    EOTminutes = 60*sum(Ak.*cos(deg2rad(k*nDayOfLeapYear*360/365.25)) + ...
                        Bk.*sin(deg2rad(k*nDayOfLeapYear*360/365.25)) ...
                       );
end