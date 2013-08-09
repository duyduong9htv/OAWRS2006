%% plot std vs. range 
% for a transect of 50 km length, 50 m increment 
% 415 :


close all; clear all; 
 cd /Volumes/scratch2/TL_vs_range/Transect14/415_PS %path has been changed 
%1125 : 
% cd /Users/dtran/Research/TL_vs_Range/1125_PS

cd /Volumes/scratch2/TL_vs_range/Results/1125_PS
f_c = input('f_c = '); 

band2 = input('6 frequencies you want for std plot: ');
% 
% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%%plot std vs. range
figure('position', [2119, 258, 1066, 825]);

for bb = 1:length(band2)
    eval(['load PSmean_std_rect_', num2str(band2(bb)), '.mat']);
   
    range = 50*[1:1:max(size(PS))]
    for kk = 1:size(standard_deviation, 2)
        standard_deviation_range_averaged(kk) = mean(mean(standard_deviation(60:120,max(1, kk-20):min(max(size(PS)),kk+20))));
    end
    figure(1); 
    
    standard_deviation_range_averaged(1) = 0;
    
    if bb == 1 
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), '--k', 'linewidth', 2); hold on;     
    end
    
    if bb ==2 
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), 'k-', 'linewidth', 2); hold on;     
    end
    
    if bb ==3
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), 'k-.', 'linewidth', 2); hold on;             
    end
    if bb ==4
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), '-.', 'linewidth', 2, 'color', [0.9 0.9 0.9]); hold on;     
    end
    
    if bb ==5 
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), 'k-', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
    
    if bb ==6 
        plot(range(1:15:end), standard_deviation_range_averaged(1:15:end), '--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
    
%     ylim([0 250]);colorbar; 
    ylim([0 6])
    set(gca, 'fontsize', 20);
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    xlabel('Range (km)', 'interpreter', 'latex'); ylabel('$\sigma$ (dB)', 'interpreter', 'latex'); 
%     title(['Standard deviation of PS intensity for different bandwidths, function of range']);
end
h = legend('CS', '20 Hz', '50 Hz', '150 Hz', '250 Hz', '350 Hz', 'fontsize', 18, 'location', 'southeast')
set(h,  'interpreter', 'latex')

% legend(num2str(band2(1)), num2str(band2(2)), num2str(band2(3)), num2str(band2(4)), num2str(band2(5)), num2str(band2(6)));
% eval([' saveas(gcf, ''std_vs_range_',  num2str(f_c), '.tif'')']);
% eval(['print -f1 -depsc /Users/dtran/2006_stats/Figures/std_vs_range_', num2str(f_c), '.eps']);
set(gcf, 'paperPositionMode', 'auto');

% eval(['print -f1 -depsc /Users/dtran/2006_stats/Figures/std_vs_range_', num2str(f_c), '.eps']);
