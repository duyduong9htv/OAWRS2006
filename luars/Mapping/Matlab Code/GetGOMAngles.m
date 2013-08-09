%% <Function Title>
%
% <OUTPUTS> = GetGOMAngles(<INPUTS>) <Function Description>
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 19Jan2012
%   Modified: 19Jan2012
%
% See also
function angles = GetGOMAngles(dateRange, plotON)

if nargin < 2
    plotON = 0;
end

startDateString = datestr(dateRange(1),'yyyy-mm-dd HH:MM:SS');
stopDateString = datestr(dateRange(2), 'yyyy-mm-dd HH:MM:SS');
query = [...
    'SELECT AVG(rcvLat) as lat, AVG(rcvLon) as lng ',...
    'FROM pings WHERE (rcvLat !=  0 OR rcvLon != 0) ',...
    sprintf('AND start_time > ''%s'' AND start_time < ''%s'' ', startDateString, stopDateString),...
    ];


sqlObject = sqlConnection.mysqlConnector;
results = sqlObject.executeQuery(query);

index = 1;
timeDiff = [];

results.next();
meanLat = results.getDouble('lat');
meanLng = results.getDouble('lng');

experimentMeanLatLng = LatLng(meanLat, meanLng);

stellwagenBankLatLng1 = LatLng(42.1, -70.15);
stellwagenBankLatLng2 = LatLng(42.45, -70.5);

greatSouthChannelLatLng1 = LatLng(41.1, -69.2);
greatSouthChannelLatLng2 = LatLng(41.25, -69.85);

northEastFlankLatLng1 = LatLng(41.9, -67.8);
northEastFlankLatLng2 = LatLng(42.15, -67.0);

if plotON
    B = Bathymetry('/Users/dreed/Projects/GOM2006 General/Bathymetry/GOM2006-OPAREA/GOM2006-2563_data/GOM2006-2563/GOM2006-2563.xyz');
    
    B.addWayPoint(experimentMeanLatLng, 'k' , '.', 'Experiment Mean');
    
    B.addWayPoint(stellwagenBankLatLng1, 'k', '.', 'Stellwagon Bank 1')
    B.addWayPoint(stellwagenBankLatLng2, 'k', '.', 'Stellwagon Bank 2')
    
    B.addWayPoint(greatSouthChannelLatLng1, 'k', '.', 'Great South Channel 1')
    B.addWayPoint(greatSouthChannelLatLng2, 'k', '.', 'Great South Channel 2')
    
    B.addWayPoint(northEastFlankLatLng1, 'k', '.', 'Northeast Flank 1')
    B.addWayPoint(northEastFlankLatLng2, 'k', '.', 'Northeast Flank 2')
    
    B.plotLand
    B.plotWayPoints([1:7])
end

% Convert to UTM
[e1, n1, a, b] = GetUTM(meanLat, meanLng);
expUTM = [e1,n1];

[e1, n1, a, b] = GetUTM(stellwagenBankLatLng1.latitude, stellwagenBankLatLng1.longitude);
swbUTM_1 = [e1,n1];
[e1, n1, a, b] = GetUTM(stellwagenBankLatLng2.latitude, stellwagenBankLatLng2.longitude);
swbUTM_2 = [e1,n1];

[e1, n1, a, b] = GetUTM(greatSouthChannelLatLng1.latitude, greatSouthChannelLatLng1.longitude);
gscUTM_1 = [e1,n1];
[e1, n1, a, b] = GetUTM(greatSouthChannelLatLng2.latitude, greatSouthChannelLatLng2.longitude);
gscUTM_2 = [e1,n1];

[e1, n1, a, b] = GetUTM(northEastFlankLatLng1.latitude, northEastFlankLatLng1.longitude);
nefUTM_1 = [e1,n1];
[e1, n1, a, b] = GetUTM(northEastFlankLatLng2.latitude, northEastFlankLatLng2.longitude);
nefUTM_2 = [e1,n1];


% Get Angles
swbAng(1) = atan2(swbUTM_1(1) - expUTM(1), swbUTM_1(2) - expUTM(2)) *180/pi;
if swbAng(1) < 0
    swbAng(1) = swbAng(1) + 360;
end
swbAng(2) = atan2(swbUTM_2(1) - expUTM(1), swbUTM_2(2) - expUTM(2)) *180/pi;
if swbAng(2) < 0
    swbAng(2) = swbAng(2) + 360;
end

gscAng(1) = atan2(gscUTM_1(1) - expUTM(1), gscUTM_1(2) - expUTM(2)) *180/pi;
if gscAng(1) < 0
    gscAng(1) = gscAng(1) + 360;
end
gscAng(2) = atan2(gscUTM_2(1) - expUTM(1), gscUTM_2(2) - expUTM(2)) *180/pi;
if gscAng(2) < 0
    gscAng(2) = gscAng(2) + 360;
end

nefAng(1) = atan2(nefUTM_1(1) - expUTM(1), nefUTM_1(2) - expUTM(2)) *180/pi;
if nefAng(1) < 0
    nefAng(1) = nefAng(1) + 360;
end
nefAng(2) = atan2(nefUTM_2(1) - expUTM(1), nefUTM_2(2) - expUTM(2)) *180/pi;
if nefAng(2) < 0
    nefAng(2) = nefAng(2) + 360;
end

angles.swbAng = sort(swbAng);
angles.gscAng = sort(gscAng);
angles.nefAng = sort(nefAng);



