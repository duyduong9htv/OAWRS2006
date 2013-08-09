%% Convert Matlab Serial Date number to Unix Time
%
% unixTime = ConvertDatenumToUnixTime(dateNum) coverts Matlab datenum to
% Unix Timestamp
%
% References: 
%
% Remarks: 
%
%   Written by: David C. Reed
%   Created: 21Dec2011
%   Modified: 21Dec2011
%
% See also ConvertDatenumToUnixTime
function dateNum = ConvertUnixTimeToDatenum(unixTime)

% Unix Timestamp Epoch is Thursday January 1st, 1970 at midnight.
unixEpoch = datenum(1970,1,1,0,0,-.0001);

dateNumTemp = unixTime / (24 * 60 * 60);

dateNum = dateNumTemp + unixEpoch;




