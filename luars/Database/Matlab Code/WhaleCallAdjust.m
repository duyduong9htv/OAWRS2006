%% WhaleCallAdjust
% WhaleCallAdjust(pingID, whaleID) adjusts the time and frequency of the
% given whaleID.  The pingID is needed to minimize errors if a wrong
% whaleID is given.
%
% Inputs:
%
% * pingID- a ...
% * whaleID- a ...
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
%   Date: 19Oct2011
%%
function [outputs] = WhaleCallAdjust(pingID, whaleID)
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
numCalls = input('Select the correct bounding box. \n');

ph = zeros(1,numCalls);


%% 2.) Get Bounding boxes for each whale using the getrect function.

bounds = getrect;

tLimits(ii) = [bounds(2) bounds(2) + bounds(4)];
fLimits(ii) = [bounds(1) bounds(1) + bounds(3)];

xLimits = fLimits(ii);
yLimits = tLimits(ii);

xData = [xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)];
yData = [yLimits(1) yLimits(2) yLimits(2) yLimits(1) yLimits(1)];

ph = plot(xData, yData, 'r','Linewidth',1);


%% 3.) Ask user if they are sure they want to continue and add these calls.
proceed = input('Adjust this Call? (y/N)','s');

if strcmpi(proceed, 'y')
    
    %% 4.) Get Pings entity from Hibernate (Java Database API) using given ID.
    whaleQuery = Queries.WhaleQuery();
    whaleQuery.byID(whaleID);
    
    whaleObj = whaleQuery.getWhales();
    whaleObj = whaleObj.get(0);
    
    thisPingObj = whaleObj.getPings();
    thisPingID = thisPingObj.getPingId;
    
    if thisPingID == pingID
        newWhale.setTimeStart(java.lang.Double(tLimits(1)));
        newWhale.setTimeStop(java.lang.Double(tLimits(2)));
        newWhale.setFreqStart(java.lang.Double(fLimits(1)));
        newWhale.setFreqStop(java.lang.Double(fLimits(2)));
    else
        error('This whale does not correspond with this Ping')
    end
else
    
    fprintf('Adding Calls ABORTED! \n');
    delete(ph)
end





