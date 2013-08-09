%% Convert unwiedly Foraname to a Matlab serial number
%
% dateNum = ConvertForanameToDatenum(pingNum) Converts a foraname which is
% a string in the form 'fora2006jd272t121730' to a Matlab
% serial datenumber which is more easily manipulated.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 27Dec2011
%   Modified: 21Dec2011
%
% See also
function dateNum = ConvertForanameToDatenum(foraname)

thisYear = str2double(foraname(5:8));
thisJulianDay = str2double(foraname(11:13));
thisHour = str2double(foraname(15:16));
thisMinute = str2double(foraname(17:18));
thisSecond = str2double(foraname(19:20));

dateNum = datenum(thisYear, 0, thisJulianDay, thisHour, thisMinute, thisSecond);