%% Initialize standard parameters

% Copyright 2024 The MathWorks, Inc.

% Vernal equinox, March 21, Day = 80
VernalEquinox = 80;
% Summer solstice, June 21, Day = 172
SummerSolstice = 172;
% Autumnal equinox, September 23, Day = 266
AutumnalEquinox = 266;
% Winter solstice, December 21, Day = 355
WinterSolstice = 355;

solsticeEquinoxDays = [VernalEquinox, SummerSolstice, ...
    AutumnalEquinox, WinterSolstice];
solsticeEquinoxDaysLbl = {'Vernal Equinox', 'Summer Solstice', ...
    'Autumnal Equinox', 'Winter Solstice'};

clear VernalEquinox SummerSolstice AutumnalEquinox WinterSolstice

dayHours = 24;
daysYear = 365;
daysMonth = 30;

