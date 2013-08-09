function CorrectWhalesArraySettings

% load AllPings;

for ii = 3600 %3574:length(pings)
    
    
    fprintf('Index %d\n',ii)
    nas = NasQuery('ping',ii);
    
    
    
    if ~isempty(nas)
        
        whaleQuery = Queries.WhaleQuery();
        whaleQuery.byPing(ii)
        whaleObjects = whaleQuery.getWhales;
        
        
        
        for jj = 1:whaleObjects.size
            
            
            thisWhaleObj = whaleObjects.get(jj-1);
            
            
            thisWhaleTime = datenum(char(thisWhaleObj.getDatetime));
            
            distance = thisWhaleTime - nas.time;
            
            distance(distance < 0) = [];
            
            index = find(distance == min(distance));
            
            if isempty(index)
                arrayCenterLat = nas.arrayCenterLat(1);
                arrayCenterLng = nas.arrayCenterLng(1);
                arrayHeading = nas.heading(1);
            elseif index == length(nas.time)
                arrayCenterLat = nas.arrayCenterLat(index);
                arrayCenterLng = nas.arrayCenterLng(index);
                arrayHeading = nas.heading(index);
            else                
                arrayCenterLat = interp1(nas.time(index:index+1), nas.arrayCenterLat(index:index+1), thisWhaleTime);
                arrayCenterLng = interp1(nas.time(index:index+1), nas.arrayCenterLng(index:index+1), thisWhaleTime);
                arrayHeading = interp1(nas.time(index:index+1), nas.heading(index:index+1), thisWhaleTime);
            end
            
            
            
            thisWhaleObj.setArrayHeading(java.lang.Double(arrayHeading));
            thisWhaleObj.setArrayLat(java.lang.Double(arrayCenterLat));
            thisWhaleObj.setArrayLng(java.lang.Double(arrayCenterLng));
            
            whaleQuery.updateWhales(thisWhaleObj);
            
            fprintf('Update Whale: %d\n', double(thisWhaleObj.getWhaleId));
            
            %             keyboard
            
        end
        whaleQuery.closeSession();       
    else
        fprintf('NAS EMPTY!')
    end
end
