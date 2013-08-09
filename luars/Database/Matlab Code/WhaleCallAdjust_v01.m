%% WhaleCallAdjust_v01 
% WhaleCallAdjust_v01(inputs) returns a ...
%
% Inputs:
%
% * input1- a ... 
%
% Outputs:
%
% * output1- a ... 
%
% References: 
%
% Remarks: 
%
%   Written by: David C. Reed
%   Date: 19Oct2011
%%
function [outputs] = WhaleCallAdjust_v01(pingID, whaleID)

fLimits = xlim;
tLimits = ylim;

whaleInfo = GetWhaleInfo_v3('id',whaleID);

if whaleInfo.pingID ~= pingID
    error('This whale does not correspond with this Ping')
end

a = sqlConnection.mysqlConnector;

update = sprintf('UPDATE whales SET tStart = %g, tStop = %g, fStart = %g, fStop = %g WHERE whale_id = %d',...
    tLimits(1), tLimits(2), fLimits(1), fLimits(2), whaleID);

a.executeUpdate(update);

a.close();

line(...
    'XData',[fLimits(1) fLimits(2) fLimits(2) fLimits(1) fLimits(1)],...
    'YData',[tLimits(1) tLimits(1) tLimits(2) tLimits(2) tLimits(1)],...
    'Color','r');