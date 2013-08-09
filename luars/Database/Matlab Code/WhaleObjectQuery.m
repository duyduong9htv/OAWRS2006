%% Get Whale vocalizations through under various criteria.
%
% whaleObjects = WhaleObjectQuery(...)  Retrieves raw whale objects based
% upon given criteria.
%
% Criteria Field - Parameter Pairs:
%   'all'                       - all whale vocalizations.
%   'frequency', [f1 f2]        - vocalizations between f1 and f2.
%   'source', waveformName      - source waveform name. (e.g. 'XA1M' or 'NOSRC')
%   'source', sourceID          - source id. (e.g. 42)
%   'ping', foraFilename        - fora filename. (e.g. 'fora2006jd272t121730')
%   'ping', pingID              - ping id. (e.g. 3002).
%   'truebearing', [tb1 tb2]    - true bearing range in degrees. (e.g. [90 180])
%   'truebearing', 'NULL'       - true bearing is NULL.
%   'relativebearing', [rb1 rb2]- relative bearing range, in sin(theta). 1 is towards ship.
%   'relativebearing', 'NULL'   - relative bearing is NULL.
%   'track', trackName          - track name. (e.g. '570_1')
%   'track', trackID            - track id. (e.g. 51)
%   'datetime', {date1 date2}   - date range. (e.g. {'2006-10-01 06:00:00', '2006-10-02 06:00:00'})
%   'time', {time1 time2}       - time range. (e.g. {'00:00:00', '00:15:00'})
%   'id', whaleID               - whale id. (e.g. 8023)
%   'id', [whaleIDs]            - set of whale id's. (e.g. [3002, 3003, 3006])
%
% Multiple criteria fields may be included to give necessary restriction.
% For example:
%
%   whaleObjects = WhaleObjectQuery('track', '570_1', 'frequency', [400 700]);
%
% will return all whale vocalizations from track 570_1 in the frequency
% band from 400 to 700 Hz.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 21Feb2012
%   Modified: 21Feb2012
%
% See also PingObjectQuery, WhaleQuery
function whaleObjects = WhaleObjectQuery(varargin)

whaleQuery = Queries.WhaleQuery();

hasError = true;
for ii = 1:length(varargin)
    if ischar(varargin{ii})
        switch lower(varargin{ii})
            case 'all'
                hasError = false;
                break;
            case 'frequency'
                value = varargin{ii + 1};
                if isnumeric(value) && (length(value) == 2)
                    whaleQuery.byFrequency(value(1), value(2));
                    hasError = false;
                end
            case 'source'
                value = varargin{ii + 1};
                if isnumeric(value) || ischar(value)
                    whaleQuery.bySource(value);
                    hasError = false;
                end
            case 'ping'
                value = varargin{ii + 1};
                if isnumeric(value)
                    whaleQuery.byPing(value);
                    hasError = false;
                end
            case 'truebearing'
                value = varargin{ii + 1};
                if isnumeric(value) && (length(value) == 2)
                    whaleQuery.byTrueBearing(value(1), value(2));
                    hasError = false;
                elseif strcmpi(value,'null')
                    whaleQuery.byTrueBearing();
                    hasError = false;
                end
            case 'relativebearing'
                value = varargin{ii + 1};
                if isnumeric(value) && (length(value) == 2)
                    whaleQuery.byRelativeBearing(value(1), value(2));
                    hasError = false;
                elseif strcmpi(value,'null')
                    whaleQuery.byRelativeBearing();
                    hasError = false;
                end
            case 'track'
                value = varargin{ii + 1};
                if isnumeric(value) || ischar(value)
                    whaleQuery.byTrack(value);
                    hasError = false;
                end
            case 'time'
                value = varargin{ii + 1};
                if iscellstr(value) && (length(value)==2)
                    whaleQuery.byTime(value{1}, value{2});
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
                    whaleQuery.byDate(dateObj1, dateObj2);
                    hasError = false;
                elseif ischar(value)
                    date = datenum(value);
                    dateStr = datestr(date, 'yyyy-mm-dd HH:MM:SS');
                    dateObj = formatter.parse(dateStr);
                    whaleQuery.byDate(dateObj);
                    hasError = false;
                end
            case 'id'
                value = varargin{ii + 1};
                if isnumeric(value)
                    whaleQuery.byID(value);
                    hasError = false;
                end
        end
    end
end

if hasError
    error('There was an error, please check if your field-parameter pairs are correct');
else
    
    whaleObjects = whaleQuery.getWhales();
    whaleObjects = whaleObjects.toArray();     
end

whaleQuery.closeSession();
