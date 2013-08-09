function whales = CreateWhaleStruct(whaleObj)

whales.whaleID = double(whaleObj.getWhaleId());
whales.arrayHeading = double(whaleObj.getArrayHeading());
whales.relativeBearing = double(whaleObj.getRelativeBeamCdsb());
whales.trueBearing = double(whaleObj.getTrueBearing());
whales.dateTime = char(whaleObj.getDatetime());
whales.timeBounds = [double(whaleObj.getTimeStart()) double(whaleObj.getTimeStop())];
whales.freqBounds = [double(whaleObj.getFreqStart()) double(whaleObj.getFreqStop())];
whales.duration = double(whaleObj.getTimeStop) - double(whaleObj.getTimeStart());
whales.lastUpdate = char(whaleObj.getLastUpdated());

pingObj = whaleObj.getPings();
trackObj = pingObj.getTracks();
groupObj = whaleObj.getWhaleGroups();

whales.pingID = double(pingObj.getPingId);
whales.trackName = char(trackObj.getName);

whales.pingHeading = double(pingObj.getHeadingAvg);

if isempty(groupObj)
    whales.groupID = [];
else
    whales.groupID = double(groupObj.getGroupId);
end