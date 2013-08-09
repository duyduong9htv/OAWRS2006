% plot a realization of the IW field 
clear; 

corr_length = 500; 

load ssps_bank; 
load ssps_basin; 

figure; hold on; plot(ssps_basin(:, 1), ssps_basin(:, 2:end), '-k'); 
plot(ssps_bank(:, 1), ssps_bank(:, 2:end), '-b'); 

% range = [0:10:20e3]; 
load ~/Research/TransectBaths/transect4.mat
range = bathy_data(:, 1); 
depth = bathy_data(:, 2); 

% depth = 200*ones(size(range)); 
bathy_data = [range; depth]'; 
rough_range = range; 


% create gradual change in SSP 
shidx = find(bathy_data(:,2)<=80);
if ~isempty(shidx)
    basin = floor(bathy_data(shidx(1),1)/corr_length);
    rand_ssps = ceil((size(ssps_basin,2)-1).*rand(basin,1))+1;
    rand_ssps = [rand_ssps;ceil((size(ssps_bank,2)-1).*rand(length(rough_range)-basin,1))+1];
    for ss = 1:basin
        rough_svp(:,ss) = ssps_basin(:,rand_ssps(ss));
    end
    
    for ss = basin+1:length(rough_range)
        rough_svp(:,ss) = ssps_bank(:,rand_ssps(ss));
    end    
else
    rand_ssps=ceil((size(ssps_basin,2)-1).*rand(length(rough_range),1))+1; 
    for ss=1:length(rough_range)
        rough_svp(:,ss)=ssps_basin(:,rand_ssps(ss));
    end
end


fullSSP = [rough_svp; 1700*ones(251, 1001)]; 

depth = [0:0.2:250]; 
rough_range = [0:50:50e3];



fineRange = [0:5:50e3']; 
fineDepth = linspace(0, 250, length(depth))'; 
fineSSP = ones(length(fineDepth), length(fineRange)); 


for ii = 1:length(fineDepth)
    fineSSP(ii, :) = smooth(interp1(rough_range, fullSSP(ii, :), fineRange), 10); 
end

figure; imagesc(fineSSP); caxis([1470 1510])


