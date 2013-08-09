%% AddWhaleCalls adds multiple whale vocalizations.
% AddWhaleCall_v01(pingID) adds multiple whale vocalizations to the
% appropriate ping.  This function assumes you are looking at the
% time-frequency domain of the ping with the correct x-axis and y-axis
% setup.
%
% Inputs:
%
% * pingID- The pingID of the current spectrogram you are looking at.
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
%   Created: 31Jan2012
%   Modified: 18Feb2012
%%
function AddWhaleCalls(orientation, pingID)
%% Outline
% 1.) Ask How many calls the user wants to add.
% 2.) Get Bounding boxes for each whale using the getrect function.
% 3.) Ask user if they are sure they want to continue and add these calls.
% 4.) Get Pings entity from Hibernate (Java Database API) using given ID.
% 5.) Create a new Whales entity.
% 6.) Add Values to Whales entity.
% 7.) Save session and commit.
% 8.) Close session.

%% 1.) Ask How many calls the user wants to add.
numCalls = input('How many calls would you like to add? ');

ph = zeros(1,numCalls);


%% 2.) Get Bounding boxes for each whale using the getrect function.
tLimits = zeros(numCalls,2);
fLimits = zeros(numCalls,2);
for ii = 1:numCalls
    bounds = getrect;
    
    if strcmpi(orientation, 'h')
        fLimits(ii,:) = [bounds(2) bounds(2) + bounds(4)];
        tLimits(ii,:) = [bounds(1) bounds(1) + bounds(3)];
    elseif strcmpi(orientation, 'v')        
        tLimits(ii,:) = [bounds(2) bounds(2) + bounds(4)];
        fLimits(ii,:) = [bounds(1) bounds(1) + bounds(3)];
    else
        error
    end
    xLimits = [bounds(1) bounds(1) + bounds(3)];
    yLimits = [bounds(2) bounds(2) + bounds(4)];
    
    xData = [xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)];
    yData = [yLimits(1) yLimits(2) yLimits(2) yLimits(1) yLimits(1)];
    
    ph(ii) = plot(xData, yData, 'w','Linewidth',1);
end

%% 3.) Ask user if they are sure they want to continue and add these calls.
proceed = input('Add all these calls? (y/N)','s');

if strcmpi(proceed, 'y')
    
    %% 4.) Get Pings entity from Hibernate (Java Database API) using given ID.
    pingQuery = Queries.PingQuery();
    pingQuery.byID(pingID)
    ping = pingQuery.getPings;
    ping = ping.get(0);
    
    session = luars.util.HibernateUtil.getSessionFactory().openSession();
    session.beginTransaction();
    
    for ii = 1:numCalls
        %% 5.) Create a new Whales entity.
        newWhale = luars.entity.Whales();
        
        %% 6.) Add Values to Whales entity.
        newWhale.setPings(ping);
        newWhale.setTimeStart(java.lang.Double(tLimits(ii,1)));
        newWhale.setTimeStop(java.lang.Double(tLimits(ii,2)));
        newWhale.setFreqStart(java.lang.Double(fLimits(ii,1)));
        newWhale.setFreqCenter(java.lang.Double((fLimits(ii,1) + fLimits(ii,2))/2));
        newWhale.setFreqStop(java.lang.Double(fLimits(ii,2)));
        
        %% 7.) Save session and commit.
        session.save(newWhale);
        
    end
    
    %% 8.) Close session.
    session.getTransaction().commit;
    session.close;
    
    fprintf('%d Calls Added to Ping %d. \n',numCalls, pingID);
    
else
    
    fprintf('Adding Calls ABORTED! \n');
    delete(ph)
end






