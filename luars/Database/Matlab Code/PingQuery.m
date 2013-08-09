%% Get Ping information through various queries.
%
% pings = PingQuery() Returns all ping objects.  Not recommended 
% since there are over 4000 pings, and structure creation takes awhile.
%
% pings = PingQuery(...)  Retrieves ping information based upon given
% criteria.  The array of pings returned is sorted by time; pingID is not
% indicative of temporal order, only order in which that ping was added to
% the database.
%
% Criteria Field - Parameter Pairs:
%   'heading', [h1 h2]          - ship heading range. (e.g. [50 60])
%   'source', waveformName      - source waveform name. (e.g. 'XA1M' or 'NOSRC', use NOSRC for 
%                                 pings with no source, and 'SRC' for pings with sources)
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
%   pings = PingQuery('track', '570_1', 'heading', [50 60]);
%
% will return information about all pings from track 570_1 in which the
% ship was heading between 50 and 60 degrees from true north.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 12Feb2012
%   Modified: 20Feb2012
%
% See also WhaleQuery, TrackQuery
function pings = PingQuery(varargin)

%% Parse Arguments
p = inputParser;
p.addParamValue('heading', [], @(x)validateattributes(x, {'numeric'}, {'>=',0,'<=',360}));
p.addParamValue('source', [], @(x)isnumeric(x) | ischar(x));
p.addParamValue('track', [], @(x)isnumeric(x) | ischar(x) | iscellstr(x));
p.addParamValue('time', [], @(x)iscellstr(x) & length(x) == 2);
p.addParamValue('datetime', [], @(x)iscellstr(x) | ischar(x));
p.addParamValue('id', [], @isnumeric);

p.parse(varargin{:});

input = p.Results();

%% Set Criteria
pingQuery = Queries.PingQuery();
% HEADING
if ~isempty(input.heading)
    pingQuery.byHeading(input.heading(1), input.heading(2));
end
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
        pingQuery.byDate(dateObj1, dateObj2);        
    elseif ischar(input.datetime)
        date1 = datenum(input.datetime);        
        date2 = datenum(input.datetime)+datenum(0,0,1);
        dateStr1 = datestr(date1, 'yyyy-mm-dd HH:MM:SS');
        dateStr2 = datestr(date2, 'yyyy-mm-dd HH:MM:SS'); 
        dateObj1 = formatter.parse(dateStr1);
        dateObj2 = formatter.parse(dateStr2);
        pingQuery.byDate(dateObj1, dateObj2);
    end
end
% SOURCE
if ~isempty(input.source)
    pingQuery.bySource(input.source);
end
% TRACK
if ~isempty(input.track)
    if isnumeric(input.track) || ischar(input.track)                    
        pingQuery.byTrack(input.track);                    
    elseif iscellstr(input.track)
        temp = javaArray('java.lang.String', length(input.track));                        
        for jj = 1:length(input.track)
            temp(jj) = java.lang.String(input.track{jj});
        end                         
        pingQuery.byTrack(temp);        
    end
end
% TIME
if ~isempty(input.time)
    pingQuery.byTime(input.time{1}, input.time{2});
end
% ID
if ~isempty(input.id)
    pingQuery.byID(input.id);
end

%% Get Ping Objects based on Criteria
pingsObjects = pingQuery.getPings();
pingsObjects = pingsObjects.toArray();

if isempty(pingsObjects)
    pings = [];
else
    for ii = 1:length(pingsObjects)
        pings(ii) = PingObject(pingsObjects(ii));
    end
end    


% pingQuery.closeSession();


