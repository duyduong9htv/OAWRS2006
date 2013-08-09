function tracks = CreateTrackStruct(trackObj)

tracks.trackID = double(trackObj.getTrackId());
tracks.name = char(trackObj.getName());

trackStart = 0;
trackStop = 0;
pingObjects = trackObj.getPingses.toArray;
for ii = 1:length(pingObjects)
    thisStart = datenum(char(pingObjects(ii).getStartTime));
    thisStop = datenum(char(pingObjects(ii).getStartTime)) + double(pingObjects(1).getDuration)/(60*60*24);
    if ii == 1
        trackStart = thisStart;
        trackStop = thisStop;        
    else
        if thisStart < trackStart
            trackStart = thisStart;
        end
        
        if thisStop > trackStop
            trackStop = thisStop;
        end
    end
end

tracks.bounds = [trackStart trackStop];


