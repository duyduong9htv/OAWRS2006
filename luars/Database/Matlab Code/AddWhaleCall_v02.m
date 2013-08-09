%% AddWhaleCall_v02
% AddWhaleCall_v01(inputs) returns a ...
%
% Inputs:
%
% * input1- a ...
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
function AddWhaleCall_v02(pingID)


numCalls = input('How many calls would you like to add? ');

ph = zeros(1,numCalls);

tLimits = zeros(numCalls,2);
fLimits = zeros(numCalls,2);
for ii = 1:numCalls
    bounds = getrect;
    
    tLimits(ii,:) = [bounds(2) bounds(2) + bounds(4)];
    fLimits(ii,:) = [bounds(1) bounds(1) + bounds(3)];
    
    xLimits = fLimits(ii,:);
    yLimits = tLimits(ii,:);
    
    xData = [xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)];
    yData = [yLimits(1) yLimits(2) yLimits(2) yLimits(1) yLimits(1)];
    
    ph(ii) = plot(xData, yData, 'w','Linewidth',1);
end


proceed = input('Add all these calls? (y/N)','s');

if strcmpi(proceed, 'y')
    
    
    
    a = sqlConnection.mysqlConnector;
    
    for ii = 1:numCalls
        update = sprintf('INSERT INTO whales (ping_id, tStart, tStop, fStart, fStop) VALUES (%g,%d,%d,%d,%d)',...
            pingID, tLimits(ii,1), tLimits(ii,2), fLimits(ii,1), fLimits(ii,2));
        
        a.executeUpdate(update);
        
    end
    
    a.close();
    
    fprintf('%d Calls Added to Ping %d. \n',numCalls, pingID);
    
else
    
    fprintf('Adding Calls ABORTED! \n');
    delete(ph)
    
end






