%% Convert unwiedly Pingnumber to a Matlab serial number
%
% dateNum = ConvertPingNumberToDatenum(pingNum) Converts a ping number
% which is an integer in the form of jdHHMMSS (eg. 274163000) to a Matlab
% serial datenumber which is more easily manipulated.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 21Dec2011
%   Modified: 21Dec2011
%
% See also
function dateNum = ConvertPingNumberToDatenum(year, pingNum)

thisJulianDay = floor(pingNum/(10^6));
pingNum = pingNum - thisJulianDay*10^6;

thisHour = floor(pingNum/(10^4));
pingNum = pingNum - thisHour*10^4;

thisMinute = floor(pingNum/(10^2));
pingNum = pingNum - thisMinute*10^2;

thisSecond = floor(pingNum);

dateNum = datenum(year, 0, thisJulianDay, thisHour, thisMinute, thisSecond);