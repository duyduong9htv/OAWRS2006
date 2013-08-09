% this thing plots selected standard deviation curve exteded up to 0.2
% relative bandwidth for all 4 waveforms, and compare the rectangular as
% well as the Tukey window 

%last modified May 14 2:10pm 

%plot the extended standard deviation vs. relative bandwidth 
clear all; close all 
cd /Volumes/scratch2/TL_vs_range/Transect10
%415
bandwidth_basic = [0 10 20 30 40 50];

%% 415

%cd /media/disk/duong/TL_vs_range/Transect10/

cd 415_PS/

bandwidth_extended = [50:20:410];
bandwidth = [0 2 6 12 20 30 40 50 bandwidth_extended];
std_dev = [];
for ii = 1:length(bandwidth)
	eval(['load PSmean_std_rect_' num2str(bandwidth(ii)) '.mat']);
	std_dev = [std_dev ; mean(mean(standard_deviation(1:180, 80:199)))];
end

figure(2); 
fullscreen = get(0,'ScreenSize');

set(gcf, 'Position',[0 0 fullscreen(3)/2 fullscreen(4)-250]);

s(1) = subplot(1, 2, 1); 
xlim([0 0.2])
h1 = plot(bandwidth/415, std_dev, '-', 'linewidth', 1.5, 'color', [0.7 0.7 0.7]); hold on;
xlim([0 0.25])
% plot(bandwidth(10)/415, std_dev(10), 'k*', 'linewidth', 2)
h = errorbar(bandwidth(10)/415, std_dev(10), 0.26, 'linestyle', 'none', 'color', 'k');  
errorbar_tick(h, 30)

x1 = bandwidth./415;
y1 = std_dev; 


%% 735
cd  /Volumes/scratch2/TL_vs_range/Transect10/735_PS/ %trnasect 
bandwidth_extended = [50:20:730];
bandwidth = [0 4 10 20 30 40 50 bandwidth_extended];
std_dev = [];
for ii = 1:length(bandwidth)
	eval(['load PSmean_std_rect_' num2str(bandwidth(ii)) '.mat']);
	std_dev = [std_dev ; mean(mean(standard_deviation(1:180, 1:199)))];
end

figure(2); 

h2 = plot(bandwidth/735, std_dev, '--', 'linewidth', 2, 'color', [0.7 0.7 0.7]); hold on; 
% plot(bandwidth(8)/735, std_dev(8), 'k*', 'linewidth', 2)
% h =errorbar(bandwidth(8)/735, std_dev(8), 0.27, 'linestyle', 'none', 'color', 'k'); 
% errorbar_tick(h, 30)

x2 = bandwidth./735; y2 = std_dev; 


%% 950 

cd /Volumes/scratch2/TL_vs_range/Transect9/950_PS/

bandwidth_extended = [70:20:950];
bandwidth = [bandwidth_basic  bandwidth_extended];
std_dev = [];
for ii = 1:length(bandwidth)
	eval(['load PSmean_std_rect_' num2str(bandwidth(ii)) '.mat']);
	std_dev = [std_dev ; mean(mean(standard_deviation(1:180, 1:199)))];
end

figure(2); 

h3 = plot(bandwidth/950, std_dev, 'k--', 'linewidth', 1.5); hold on; 
% plot(bandwidth(8)/950, std_dev(8), 'k*', 'linewidth', 2)
% h=errorbar(bandwidth(8)/950, std_dev(8), 0.26, 'linestyle', 'none', 'color', 'k'); 
% errorbar_tick(h, 30)

x3 = bandwidth./950; y3 = std_dev; 



%% 1125

cd  /Volumes/scratch2/TL_vs_range/Transect7/1125_PS/ %trnasect 
bandwidth_extended = [80:20:400]
bandwidth = [0:10:50 bandwidth_extended];
std_dev = [];
for ii = 1:length(bandwidth)
	eval(['load PSmean_std_rect_' num2str(bandwidth(ii)) '.mat']);
	std_dev = [std_dev ; mean(mean(standard_deviation(1:180, 1:199)))];
end

figure(2); 

h4 = plot(bandwidth/1125, std_dev, 'k-', 'linewidth', 2); hold on; 
% plot(bandwidth(10)/1125, std_dev(10), 'k*', 'linewidth', 2)
% h=errorbar(bandwidth(10)/1125, std_dev(10), 0.26, 'linestyle', 'none', 'color', 'k'); 
% errorbar_tick(h, 30)
x4 = bandwidth./1125; y4 = std_dev; 



%% now plot the Tukey windowed statistics up to 50 Hz
% 
% %415 : transect 10 
% freq = 415;
% cd /Volumes/scratch2/TL_vs_range/Transect10
% cd 415_PS
% std_dev_Tukey = [];rel_bw = [];
% for bandwidth = 0:2:50
%     eval(['load PSmean_std_Tukey_' num2str(bandwidth) '.mat']);
%     std_dev_Tukey = [std_dev_Tukey  mean(mean(standard_deviation(1:180,1:199)))];
%     rel_bw= [rel_bw bandwidth/freq];
% end
% 
% figure(2); plot(rel_bw, std_dev_Tukey, '-k', 'Linewidth', 2.5); 
% 
% plot(x1, y1, 'linewidth', 1, 'color', [0.7 0.7 0.7]);
% 
% plot(x2, y2, 'k-.', 'linewidth', 1);
% 
% 
% plot(x3, y3, 'k--', 'linewidth', 1);
% 
% 
% plot(x4, y4, 'k--*', 'linewidth', 0.5, 'markersize', 2);
% 
% 
% 
% 
% % 735 transect 10 
% 
% freq = 735;
% cd /Volumes/scratch2/TL_vs_range/Transect10
% cd 735_PS
% std_dev_Tukey = [];rel_bw = [];
% for bandwidth = 0:2:50
%     eval(['load PSmean_std_Tukey_' num2str(bandwidth) '.mat']);
%     std_dev_Tukey = [std_dev_Tukey  mean(mean(standard_deviation(1:180,1:199)))];
%     rel_bw= [rel_bw bandwidth/freq];
% end
% 
% figure(2); plot(rel_bw, std_dev_Tukey, '-k', 'Linewidth', 2.5); 
% 
% % 950 Transect 9 
% 
% freq = 950;
% cd /Volumes/scratch2/TL_vs_range/Transect9
% cd 950_PS
% std_dev_Tukey = [];rel_bw = [];
% for bandwidth = 0:2:50
%     eval(['load PSmean_std_Tukey_' num2str(bandwidth) '.mat']);
%     std_dev_Tukey = [std_dev_Tukey  mean(mean(standard_deviation(1:180,1:199)))];
%     rel_bw= [rel_bw bandwidth/freq];
% end
% 
% figure(2); plot(rel_bw, std_dev_Tukey, '-k', 'Linewidth', 2.5); 
% 
% % 1125 transect 7
% 
% freq = 1125;
% cd /Volumes/scratch2/TL_vs_range/Transect7
% cd 1125_PS
% std_dev_Tukey = [];rel_bw = [];
% bandwidth_bank = [0:2:50] ;
% 
% for bb = 1:length(bandwidth_bank)
%     bandwidth = bandwidth_bank(bb); 
%     eval(['load PSmean_std_Tukey_' num2str(bandwidth) '.mat']);
%     std_dev_Tukey = [std_dev_Tukey  mean(mean(standard_deviation(1:180,1:199)))];
%     rel_bw= [rel_bw bandwidth/freq];
% end
% 
% figure(2); plot(rel_bw, std_dev_Tukey, '-k', 'Linewidth', 2.5); 



%% set graph properties

xlim([0 0.25]);
ylim([2.5 6]);



set(gca, 'fontsize',23); 
xl = xlabel('Relative bandwidth B/f_c'); 
yl = ylabel('Standard deviation \sigma');
le = legend([h1, h2, h3, h4], '$f_c$=415 Hz', '$f_c$=735 Hz', '$f_c$=950 Hz', '$f_c$=1125 Hz');
% set(xl, 'interpreter', 'latex'); 
% set(yl, 'interpreter', 'latex'); 
set(le, 'interpreter', 'latex', 'fontsize', 23); 





%% get mu

s(2) = subplot(1,2,2); 
for ii = 1:length(y1)
    mu415(ii) = get_tbprod(y1(ii));
end

for ii = 1:length(y2)
    mu735(ii) = get_tbprod(y2(ii));
end

for ii = 1:length(y3)
    mu950(ii) = get_tbprod(y3(ii));
end

for ii = 1:length(y4)
    mu1125(ii) = get_tbprod(y4(ii));
end



% plot(x1, mu415, 'k*', 'linewidth', 1); hold on; 
% plot(x2, mu735, 'k^', 'linewidth', 1); 
% plot(x3, mu950, 'kd', 'linewidth', 1); 
% plot(x4, mu1125, 'ko', 'linewidth', 1); 
hold on; box on; 

plot(x1, mu415,  'color', [0.7 0.7 0.7], 'linewidth', 1.5)
plot(x2, mu735, '--', 'color', [0.7 0.7 0.7], 'linewidth', 1.5)
plot(x3, mu950, 'k--', 'linewidth', 1.5)
plot(x4, mu1125, 'k-', 'linewidth', 1.5)
ylim([1 3])


set(gca, 'fontsize', 23); 
xl = xlabel('Relative bandwidth B/f_c'); 
yl = ylabel('Number of coherence cells  \mu');
le = legend('$f_c$=415 Hz', '$f_c$=735 Hz', '$f_c$=950 Hz', '$f_c$=1125 Hz', 'location', 'southeast');
% set(xl, 'interpreter', 'latex'); 
% set(yl, 'interpreter', 'latex'); 
set(le, 'interpreter', 'latex', 'fontsize', 23); 
xlim([0 0.25])

h = errorbar(x1(10), mu415(10), 0.36, 'linestyle', 'none', 'color', 'k'); 
errorbar_tick(h, 30)


set(gcf, 'position', [2244 362 1497 701]); 


% set(gca, 'position',  [0.53 0.11 0.3347 0.8150])
set(gca, 'ytick', [1 1.5 2 2.5 3])


set(s(1), 'position', [0.07 0.13 0.42 0.85]); box on; 

% set(s(1), 'position', [0.05 0.1 0.42 0.85]);

% set(s(1), 'position', [0.05 0.1 0.42 0.85]);
set(s(2), 'position', [0.55 0.13 0.42 0.85]); box on; 



annotation(figure(2),'textbox',...
    [0.070365358592693+0.02 0.815393442622951+0.05 0.0497293640054127 0.0688524590163934],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'FitBoxToText','off',...
    'LineStyle','none');



annotation(figure(2),'textbox',...
    [0.561271989174571+0.02 0.811786885245901+0.05 0.0497293640054127 0.0688524590163934],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'FitBoxToText','off',...
    'LineStyle','none');

setFigureAuto; 

% set(gcf, 'paperPositionMode', 'auto');
% print -f2 -depsc /Users/dtran/2006_stats/Figures/model_sigmal_and_mu.eps

print -depsc /Users/dtran/2006_stats/Figures/model_sigmal_and_mu.eps



