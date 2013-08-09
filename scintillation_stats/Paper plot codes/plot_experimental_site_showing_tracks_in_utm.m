% 
% %% this one good. Others no good. 
% 
% 
% % to plot this: 
% % large map of the GOM area
% % rectangle showing experimental sites
% % annotation
% 
% 
% load ./GOM1017-9992_data/GOM1017-9992/GOM1017-9992.xyz
% bathy = GOM1017_9992; 
% 
% x = bathy(1:421, 1); 
% y = bathy(1:361:end, 2); 
% depth = zeros(length(x), length(y)); 
% for ii = 1:length(x)
%     ind1 = find(bathy(:, 1) == x(ii));
%     x1 = bathy(ind1, 1);
%     y1 = bathy(ind1, 2); 
%     depth1 = bathy(ind1, 3); 
%     for jj = 1:length(y)
%         ind2 = find(y1(:) == y(jj));        
%         depth(ii, jj) = depth1(ind2); 
%     end
% end
% 
% 
% depth2 = depth; 
% 
% depth3 = interp2(depth, 5);
% 
% x2 = linspace(x(1), x(end), size(depth3, 1)); 
% y2 = linspace(y(1), y(end), size(depth3, 2)); 
% 
% % [x1, y1] = meshgrid(x, y);
% % y_interp = interp(y, 2); 
% % x_interp = interp(x, 2); 
% % [x_interp, y_interp] = meshgrid(x_interp, y_interp);
% % depth2 = interp2(x1, y1, depth, x_interp, y_interp); 
% 
% 
% ind1 = depth3(:) > -2; 
% depth3(ind1) = 5000; 

cd /Users/dtran/Research/MC_TL_2006/tracks_onbath/
load /Users/dtran/Research/MC_TL_2006/tracks_onbath/plot_experimental_site_workspace

figure(10);clf;  

s(1) = subplot(1, 2, 1); 

x2degree= x2; 
y2degree = y2; 
[x2degree, inds] = findWithin(-68.5, -67.2, x2degree); 
depth3 = depth3(inds,:); 
% y2degree = y2degree(inds); 
[y2degree, inds] = findWithin(41, 42, y2degree); 
% x2degree = x2degree(inds);
depth3 = depth3(:, inds); 


for ii = 1:size(x2degree, 2)
    [x2(ii), ~, utmzone] = deg2utm(y2degree(1), x2degree(ii)); 
end

for jj = 1:size(y2degree, 2)
    [~, y2(jj), utmzone] = deg2utm(y2degree(jj), x2degree(ii)); 
end

y2 = fliplr(y2); 
imagesc(x2, y2, depth3'); 

axis xy
caxis([-20 15000])
colormap(flipud(gray))
% 
% xlim([-72 -65.5])
% axis equal
hold on; 
% plot([-69.1 -66.7], [41.3 41.3], '--k')
% plot([-69.2 -69.2], [41.3 42.7], '--k')
% plot([-66.7 -66.7], [41.3 42.7], '--k')
% plot([-69.2 -66.7], [42.7 42.7], '--k')

% contour(x2-x2(1), fliplr(y2-y2(1)), depth3', [4000 5000], 'color', 'k', 'linewidth',1)

 x = linspace(x2(1), x2(end), 421); 
y = linspace(y2(1), y2(end), 421); 

contour_lines=[100 150 180 200 250];
% [cs, h]=contour(x2, y2, -depth3, contour_lines, 'color',[0.8 0.8 0.8]);
% clabel(cs,h)
% 
% % plot(src_utm(:,1),src_utm(:,2),

contour(x, y, depth', [-2000 -1000 -300 -200 -150 -100 -50], 'color', [0.8 0.8 0.8])

load TracksCoordinates
track_utm = track_utm*1e6; 

for ii = 1:size(track_utm, 1)
%     [LatStart,LonStart] = utm2deg(track_utm(ii, 1), track_utm(ii,3), '19
%     T'); %plotting in degrees
%     [LatEnd,LonEnd] = utm2deg(track_utm(ii, 2), track_utm(ii,4), '19 T');
%     plot([LonStart LonEnd], [LatStart LatEnd], '-k', 'linewidth', 2); 
    
    yTrack = [track_utm(ii, 3) track_utm(ii, 4)]; 
    xTrack = [track_utm(ii, 1) track_utm(ii, 2)]; 
    plot(xTrack, yTrack, '-k', 'linewidth', 2); 
end



load SourceLocations; 

SourceLocations = 1e6*SourceLocations; 
for ii = 1:30:size(SourceLocations, 1)
    [Lat, Lon] = utm2deg(SourceLocations(ii, 1), SourceLocations(ii, 2),  '19 T'); 
    plot(Lon, Lat, 'ko'); 
end


% axis([-71.2 -67 41.2  43])
axis([-68.5686  -67.3214   41.8252   42.3942]); 
set(gca, 'xtick', [-72:1:-65])
set(gca, 'ytick', [41:0.5:44])

set(gca, 'fontsize', 16); 
set(gca, 'ytick', [41:0.5:44])

% 
% set(gcf, 'position', map_position); 
set(gca, 'xticklabel', '');

set(gca, 'yticklabel', ''); 


for commented_out = 1
% 
% for annotation_work = 1
% annotation(gcf,'textbox',...
%     [0.0572082379862 0.225229508196721 0.12070938215103 0.0672131147540984],...
%     'Interpreter','latex',...
%     'String',{'$41^o$N'},...
%     'FontSize',16,...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% annotation(gcf,'textbox',...
%     [0.0554691075514174 0.411786885245901 0.12070938215103 0.0672131147540984],...
%     'Interpreter','latex',...
%     'String',{'$42^o$N'},...
%     'FontSize',16,...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% 
% annotation(gcf,'textbox',...
%     [0.0577574370708682 0.58883606557377 0.12070938215103 0.0672131147540984],...
%     'Interpreter','latex',...
%     'String',{'$43^o$N'},...
%     'FontSize',16,...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% 
% 
% annotation(gcf,'textbox',...
%     [0.0589016018305936 0.77572131147541 0.12070938215103 0.0672131147540984],...
%     'Interpreter','latex',...
%     'String',{'$44^o$N'},...
%     'FontSize',16,...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% 
% 
% a = annotation(gcf,'textbox',...
%     [0.148224110229319 0.113286519069348 0.730718085106383 0.0446735395189003],...
%     'Interpreter','latex',...
%     'String',{'$71^o$W \ \ \ \ \ \ \ \ \ $70^o$W\ \ \ \ \ \ \ \ \ $69^o$W\ \ \ \ \ \ \ \ \ \ $68^o$W\ \ \ \ \ \ \ \ \ \ $67^o$W\ \ \ \ \ \ \ \ \ \ $66^o$W'},...
%     'FontSize',16,...
%     'LineStyle','none');
% 
% 
% 
% annotation(gcf,'textbox',...
%     [0.239130434782609 0.367852459016394 0.109839816933638 0.0442622950819672],...
%     'String',{'Cape Cod'},...
%     'FontWeight','bold',...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% 
% 
% annotation(gcf,'textbox',...
%     [0.125263157894737 0.487196721311475 0.109839816933638 0.0442622950819672],...
%     'String',{'Boston'},...
%     'FontSize',12,...
%     'FitBoxToText','off',...
%     'LineStyle','none');
% 
% 
% end 

end 

% set(gcf, 'paperpositionMode', 'auto'); 

s(2) = subplot(1, 2, 2); 
cd /Users/dtran/Research/SI
% % clear; 
% % close all; 
load range_PS_415
range = range_PS(:,1);
[hist_r x] = hist(range, 30)
figure(1); 
% set(gcf, 'position', [1 1 695 513]);
bar(x, hist_r/1845, 'barwidth', 1.0, 'facecolor', 'white'); box on; 

ylabel('Normalized abundance ', 'fontsize', 16); 
% xlabel('Range (km)', 'fontsize', 20)
xtl = get(gca, 'xtick'); 
set(s(2), 'xtick', [0:5e3:20e3])
set(gca, 'xticklabel', ''); 
xlim([0 20e3])
set(gca, 'fontsize', 16)


set(s(1), 'position', [0.1 0.17 0.48 0.565])
set(s(2), 'position', [0.64 0.17 0.20 0.565])
set(gcf, 'paperpositionMode', 'auto');
cd /Users/dtran/Research/MC_TL_2006/tracks_onbath


% position_all = get(gcf, 'position')
set(gcf, 'position', position_all); 
% s1_pos = get(s(1), 'position')
% s2_pos = get(s(2), 'position')
set(s(1), 'position', s1_pos); 
set(s(2), 'position', s2_pos); 



% 
% print -f1 -depsc /Users/dtran/2006_stats/Figures/histogram.eps






% 
% 
% print -dtiff test.tif
% 
% 
% print -depsc test.eps
