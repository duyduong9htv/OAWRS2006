function nas = CreateNasStruct(nasObjects)


for ii = 1:length(nasObjects)
    
    nas.time(ii) = ConvertUnixTimeToDatenum(double(nasObjects(ii).getTimestamp()));
    nas.heading(ii) = double(nasObjects(ii).getArrayHeading());
    nas.arrayCenterLat(ii) = double(nasObjects(ii).getArrayCenterLat); 
    nas.arrayCenterLng(ii) = double(nasObjects(ii).getArrayCenterLng);    
    
end