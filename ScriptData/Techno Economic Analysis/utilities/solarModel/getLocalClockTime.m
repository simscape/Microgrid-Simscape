% Function to find local clock time.

% Copyright 2024 The MathWorks, Inc.

function clockTime = getLocalClockTime(long,longStdTimeZoneMeredian,year,nDayOfYear,watchTime,dayLightSavingHrs)
    EOTminutes = getEquationOfTimeInMinutes(year,nDayOfYear);
    clockTime = watchTime - EOTminutes/60 + (long-longStdTimeZoneMeredian)/15 + dayLightSavingHrs;
end