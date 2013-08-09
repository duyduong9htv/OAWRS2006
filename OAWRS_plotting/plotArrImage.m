function plotArrImage(fora_name)
% function plotArrImage(fora_name)
% plots an image from the  fora*.arr file. 
% Make sure that both the fora*.arr files and the fora*.m files are added
% to the working path. 
%Eg. plotArrImage('fora2003jd124t222135.arr'); 
tic; 
eval(fora_name(1:(end-4))); %run the corresponding m-file 
disp(['Plotting ' fora_name ' image']); 
ImageData = read_arr(fora_name); 
xdata = grid_xmin:grid_inc:grid_xmax; 
ydata = grid_ymax:-grid_inc:grid_ymin;     

imagesc(xdata, ydata, ImageData); 
% clear ImageData; % save memory
% axis equal; 
axis xy ; 

caxis([50 90])
axis equal

axis([grid_xmin-10e3 grid_xmax+10e3 grid_ymin-10e3 grid_ymax+10e3]); 

colormap(color128map1); 
colorbar; 
hold on; 
contourlines;
plot_bathycontour_dd(overlayfiles, 'w');

% clear overlayfiles; 
toc; 

end 