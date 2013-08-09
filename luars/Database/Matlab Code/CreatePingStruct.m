function pings = CreatePingStruct(pingObj)

pings.pingID = double(pingObj.getPingId());
pings.headingAvg = double(pingObj.getHeadingAvg());
pings.duration = double(pingObj.getDuration());
pings.startTime = char(pingObj.getStartTime());
pings.receiverLatLng = [double(pingObj.getReceiverLat()) double(pingObj.getReceiverLng())];
pings.sourceLatLng = [double(pingObj.getSourceLat()) double(pingObj.getSourceLng())];

thisTimeVec = datevec(pings.startTime);

jd = datenum(pings.startTime) - datenum(2006,0,0,thisTimeVec(4), thisTimeVec(5), thisTimeVec(6));
pings.foraName = sprintf('fora2006jd%dt%s', jd, datestr(thisTimeVec,'HHMMSS')); 

trackObj = pingObj.getTracks();

pings.trackName = char(trackObj.getName);