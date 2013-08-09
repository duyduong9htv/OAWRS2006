%% Find Ambiguous True Bearings from Relative Bearing 
%
% trueBearings = GetTrueBearingsFromRelative(heading, relativeBearing)
% returns a 1x2 vector containing the true and ambiguous bearings given the
% relative bearing and array heading.  heading should be represented by
% degress in interval from 0 - 360. relative bearing should be reprented in
% degrees with 90 degrees representing array heading and -90 degrees
% representing angle directly opposite array heading.
%
% References:
%
% Remarks: 
%
%   Written by: David C. Reed
%   Created: 22Nov2011
%   Modified: 20Jan2012
%
% See also 
function trueBearings = GetTrueBearingsFromRelative(heading, relativeBearing)

trueBearings(1,1) = mod(heading + (relativeBearing - 90),360);
trueBearings(1,2) = mod(heading - (relativeBearing - 90),360);