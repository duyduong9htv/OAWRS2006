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
% See also 
function unixTime = ConvertDatenumToUnixTime(dateNum)

% Unix Timestamp Epoch is Thursday January 1st, 1970 at midnight.
unixEpoch = datenum(1970,1,1,0,0,-.0001);

% Get number of days since Unix Epoch
dateNumTemp = dateNum - unixEpoch;

% Matlab serial date is in days so convert to seconds.
unixTime = dateNumTemp * 24 * 60 * 60;

