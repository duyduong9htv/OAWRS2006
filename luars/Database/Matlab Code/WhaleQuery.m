%% Get Whale vocalizations through under various criteria.
%
% whales = WhaleQuery() Returns all whale vocalizations.  Not recommended 
% since there are a lot of whale calls, and structure creation takes awhile.
%
% whales = WhaleQuery(...)  Retrieves whale vocalizations based upon given
% criteria.  The array of whales returned is sorted by time; whaleID is not
% indicative of temporal order, only order in which that vocalization was
% added to the database.
%
% Criteria Field - Parameter Pairs:
%   'frequency', [f1 f2]        - vocalizations between f1 and f2.
%   'source', waveformName      - source waveform name. (e.g. 'XA1M' or 'NOSRC')
%   'source', sourceID          - source id. (e.g. 42)
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
%   whales = WhaleQuery('track', '570_1', 'frequency', [400 700]);
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
%   Modified: 01May2012
%
% See also PingQuery, TrackQuery
function whales = WhaleQuery(varargin)

%% Parse Arguments
p = inputParser;
p.addParamValue('frequency',[], @(x)validateattributes(x, {'numeric'}, {'>=',0,'<=',2000}));
p.addParamValue('source',[],@(x)isnumeric(x) | ischar(x));
p.addParamValue('ping',[],@isnumeric);
p.addParamValue('truebearing', [], @(x)validateTrueBearing(x));
p.addParamValue('relativebearing', [], @(x)validateRelBearing(x));
p.addParamValue('track',[],@(x)isnumeric(x) | ischar(x) | iscellstr(x));
p.addParamValue('time',[],@(x)iscellstr(x) & length(x) == 2);
p.addParamValue('datetime',[],@(x)iscellstr(x) | ischar(x));
p.addParamValue('id',[],@isnumeric);
p.addParamValue('group',[],@isnumeric);

p.parse(varargin{:});

input = p.Results();

%% Set Criteria
whaleQuery = Queries.WhaleQuery();
% DATETIME
if ~isempty(input.datetime)
    formatter = java.text.SimpleDateFormat('yyyy-MM-dd hh:mm:ss');    
    if iscellstr(input.datetime)
        date1 = datenum(input.datetime{1});
        date2 = datenum(input.datetime{2});
        dateStr1 = datestr(date1, 'yyyy-mm-dd HH:MM:SS');
        dateStr2 = datestr(date2, 'yyyy-mm-dd HH:MM:SS');
        dateObj1 = formatter.parse(dateStr1);
        dateObj2 = formatter.parse(dateStr2);
        whaleQuery.byDate(dateObj1, dateObj2);        
    elseif ischar(input.datetime)
        date1 = datenum(input.datetime);        
        date2 = datenum(input.datetime)+datenum(0,0,1);
        dateStr1 = datestr(date1, 'yyyy-mm-dd HH:MM:SS');
        dateStr2 = datestr(date2, 'yyyy-mm-dd HH:MM:SS'); 
        dateObj1 = formatter.parse(dateStr1);
        dateObj2 = formatter.parse(dateStr2);
        whaleQuery.byDate(dateObj1, dateObj2);
    end
end
% PING
if ~isempty(input.ping)
    whaleQuery.byPing(input.ping);
end
% FREQUENCY
if ~isempty(input.frequency)
    whaleQuery.byFrequency(input.frequency(1), input.frequency(2));
end
% SOURCE
if ~isempty(input.source)
    whaleQuery.bySource(input.source);
end
% TRUE BEARING
if ~isempty(input.truebearing)
    if strcmpi(input.truebearing, 'null')
        whaleQuery.byTrueBearing();
    elseif isnumeric(input.truebearing)
        whaleQuery.byTrueBearing(input.truebearing(1), input.truebearing(2));
    end 
end
% RELATIVE BEARING
if ~isempty(input.relativebearing)
    if strcmpi(input.relativebearing, 'null')
        whaleQuery.byRelativeBearing();
    elseif isnumeric(input.relativebearing)
        whaleQuery.byRelativeBearing(input.relativebearing(1), input.relativebearing(2));
    end 
end
% TRACK
if ~isempty(input.track)
    if isnumeric(input.track) || ischar(input.track)                    
        whaleQuery.byTrack(input.track);                    
    elseif iscellstr(input.track)
        temp = javaArray('java.lang.String', length(input.track));                        
        for jj = 1:length(input.track)
            temp(jj) = java.lang.String(input.track{jj});
        end                         
        whaleQuery.byTrack(temp);        
    end
end
% TIME
if ~isempty(input.time)
    whaleQuery.byTime(input.time{1}, input.time{2});
end
% ID
if ~isempty(input.id)
    whaleQuery.byID(input.id);
end
% GROUP
if ~isempty(input.group)
    whaleQuery.byGroup(input.group);
end

%% Get Whale Structures based on Criteria    
whaleObjects = whaleQuery.getWhales();
whaleObjects = whaleObjects.toArray();

if isempty(whaleObjects)
    whales = [];
else
    for ii = 1:length(whaleObjects)
%             whales(ii) = CreateWhaleStruct(whaleObjects(ii));
        whales(ii) = WhaleObject(whaleObjects(ii));
    end
end    

whaleQuery.closeSession();
end

% Custom Validation Functions for True and Relative Bearings
function val = validateTrueBearing(x)    
    val = false;
    if isnumeric(x) & x >= 0 & x <= 360
        val = true;
    elseif ischar(x) & strcmpi(x, 'null')
        val = true;
    end            
end

function val = validateRelBearing(x)    
    val = false;
    if isnumeric(x) & x >= -1 & x <= 1
        val = true;
    elseif ischar(x) & strcmpi(x, 'null')
        val = true;
    end            
end
