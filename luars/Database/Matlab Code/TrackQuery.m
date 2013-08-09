%% Get Track Information through under various criteria.
%
% tracks = TrackQuery(...)  Retrieves track information based upon given
% criteria.  
%
% Criteria Field - Parameter Pairs:
%   'all'                       - all whale vocalizations.
%   'datetime', {date1 date2}   - date range. (e.g. {'2006-10-01 06:00:00', '2006-10-02 06:00:00'})
%   'id', whaleID               - whale id. (e.g. 8023)
%   'id', [whaleIDs]            - set of whale id's. (e.g. [3002, 3003, 3006])
%   'name', trackName           - track string name. (e.g. '570_1')
%
% Multiple criteria fields may be included to give necessary restriction.
% For example:
%
%   tracks = TrackQuery('track', '570_1', 'frequency', [400 700]);
%
% will return all whale vocalizations from track 570_1 in the frequency
% band from 400 to 700 Hz.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 12Feb2012
%   Modified: 20Feb2012
%
% See also PingQuery, WhaleQuery
function tracks = TrackQuery(varargin)

trackQuery = Queries.TrackQuery();

hasError = true;
for ii = 1:length(varargin)
    if ischar(varargin{ii})
        switch lower(varargin{ii})
            case 'all'
                hasError = false;
                break;            
            case 'name'
                value = varargin{ii + 1};
                if ischar(value)
                    trackQuery.byName(value);
                    hasError = false;
                end
            case 'datetime'
                formatter = java.text.SimpleDateFormat('yyyy-MM-dd hh:mm:ss');
                value = varargin{ii + 1};
                if iscellstr(value) && (length(value)==2)
                    date1 = datenum(value{1});
                    date2 = datenum(value{2});
                    dateStr1 = datestr(date1, 'yyyy-mm-dd HH:MM:SS');
                    dateStr2 = datestr(date2, 'yyyy-mm-dd HH:MM:SS');
                    dateObj1 = formatter.parse(dateStr1);
                    dateObj2 = formatter.parse(dateStr2);
                    trackQuery.byDate(dateObj1, dateObj2);
                    hasError = false;                
                end
            case 'id'
                value = varargin{ii + 1};
                if isnumeric(value)
                    trackQuery.byID(value);
                    hasError = false;
                end
        end
    end
end

if hasError
    error('There was an error, please check if your field-parameter pairs are correct');
else
    
    trackObjects = trackQuery.getTracks();
    trackObjects = trackObjects.toArray();
    
    if isempty(trackObjects)
        tracks = [];
    else
        for ii = 1:length(trackObjects)
            tracks(ii) = CreateTrackStruct(trackObjects(ii));
        end
    end
    
end

trackQuery.closeSession();
