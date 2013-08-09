%% Get Ping information through various queries.
%
% pings = PingObjectQuery(...)  Retrieves raw ping objects based upon given
% criteria.  The array of pings returned is sorted by time.
%
% Criteria Field - Parameter Pairs:
%   'heading', [h1 h2]          - ship heading range. (e.g. [50 60])
%   'source', waveformName      - source waveform name. (e.g. 'XA1M' or 'NOSRC', use NOSRC for pings with no source, and 'SRC' for pings with source)
%   'source', sourceID          - source id. (e.g. 42)
%   'track', trackName          - track name. (e.g. '570_1')
%   'track', trackID            - track id. (e.g. 51)
%   'datetime' [date1 date2]    - date range. (e.g. {'2006-10-01 06:00:00', '2006-10-02 06:00:00'})
%   'time' [time1 time2]        - time range. (e.g. {'00:00:00', '00:15:00'})
%   'id' pingID                 - ping id. (e.g. 2023)
%   'id' [pingIDs]              - set of ping id's. (e.g. [3002, 3003, 3006])
%
% Multiple criteria fields may be included to give necessary restriction.
% For example:
%
%   pings = PingObjectQuery('track', '570_1', 'heading', [50 60]);
%
% will return information about all pings from track 570_1 in which the
% ship was heading between 50 and 60 degrees from true north.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 21Feb2012
%   Modified: 21Feb2012
%
% See also WhaleQuery, TrackQuery
function pingsObjects = PingObjectQuery(varargin)

pingQuery = Queries.PingQuery();

hasError = true;
for ii = 1:length(varargin)
    
    if ischar(varargin{ii})
        switch lower(varargin{ii})
            case 'all'
                hasError = false;
                break;
            case 'heading'
                value = varargin{ii + 1};
                if isnumeric(value) && (length(value) == 2)
                    pingQuery.byHeading(value(1), value(2));
                    hasError = false;
                end
            case 'source'
                value = varargin{ii + 1};
                if isnumeric(value) || ischar(value)
                    pingQuery.bySource(value);
                    hasError = false;
                end
            case 'track'
                value = varargin{ii + 1};
                if isnumeric(value) || ischar(value)
                    pingQuery.byTrack(value);
                    hasError = false;
                end
            case 'time'
                value = varargin{ii + 1};
                if iscellstr(value) && (length(value)==2)
                    pingQuery.byTime(value{1}, value{2});
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
                    pingQuery.byDate(dateObj1, dateObj2);
                    hasError = false;
                elseif ischar(value)
                    date = datenum(value);
                    dateStr = datestr(date, 'yyyy-mm-dd HH:MM:SS');
                    dateObj = formatter.parse(dateStr);
                    pingQuery.byDate(dateObj);
                    hasError = false;
                end
            case 'id'
                value = varargin{ii + 1};
                if isnumeric(value)
                    pingQuery.byID(value);
                    hasError = false;
                end
        end
    end
    
    
end

if hasError
    error('There was an error, please check if your field-parameter pairs are correct');
else
    
    pingsObjects = pingQuery.getPings();
    pingsObjects = pingsObjects.toArray();      
end

pingQuery.closeSession();



