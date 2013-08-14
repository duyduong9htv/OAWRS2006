% shape_colorbar.m  loads a brown axis (for background) and a color axis
% (for fish) and shapes them as desired.  Specify the total color axis
% desired, then the threshold for where it should transition from the
% browns to the colors.  This program interpolates each part of the
% colorbar to the appropriate color range and concatenates the two into a
% new colormap.  It also sets the colormap and caxis as specified for the 
% current figure.  Usage:
% shape_colorbar(coloraxis, threshold)

function science_cb = shape_science_colorbar(coloraxis, threshold)
% clear all;
% coloraxis = [10*log10(0.01)-40.8 10*log10(10)-40.8];
% threshold = 10*log10(0.3)-40.8

% coloraxis = [-5.5266 10];
% threshold = -5.2288;

load science_oawrs_colorbar.mat

map_size=10000;

caxis_range=coloraxis(2)-coloraxis(1);
brown_inds=(1:round(map_size*(threshold-coloraxis(1))/caxis_range));
color_inds=(1:round(map_size*(coloraxis(2)-threshold)/caxis_range));
% browns = browns(1:45,:);

dbrown=brown_inds(end-1)/(size(browns,1)-1);
old_brown_vec=(1:dbrown:brown_inds(end));
[x y]=meshgrid((1:3), old_brown_vec);% (1:size(browns,1))*caxis_range/(threshold-coloraxis(1)));
[xi yi]=meshgrid((1:3), brown_inds);
new_browns=interp2(x, y, browns, xi, yi);

dcolor=color_inds(end-1)/(size(colors,1));
old_colorvec=(1:dcolor:length(color_inds));
for cc=1:color_inds(end)
    [this_c c_ind]=max(find(old_colorvec<=cc));
    if c_ind>size(colors,1)
        c_ind=c_ind-1;
    end
    new_colors(cc,:)=colors(c_ind,:);
end

science_cb=[new_browns; new_colors];

