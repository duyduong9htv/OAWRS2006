%% combine %% plot std vs. range 
% for a transect of 50 km length, 50 m increment 
% 415 :


close all; clear all; 
 cd /Volumes/scratch2/TL_vs_range/Transect14/415_PS %path has been changed 
%1125 : 
% cd /Users/dtran/Research/TL_vs_Range/1125_PS

% cd /Volumes/scratch2/TL_vs_range/Results/1125_PS
% f_c = 1125; 
% band2 = input('6 frequencies you want for std plot: ');

band2 = [0 20 50 110 150 210];
% 
% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%%plot std vs. range

load ~/Research/TL_MC_10/P'aper plot codes'/pos.mat 
figure('Position', pos)
hold on; 
s(1) = subplot(1, 2,1); 
errorBarTable = []; 

for bb = 1:length(band2)
    eval(['load PSmean_std_rect_', num2str(band2(bb)), '.mat']);
   
    range = 50*[1:1:max(size(PS))]
    for kk = 1:size(standard_deviation, 2)
        standard_deviation_range_averaged(kk) = mean(mean(standard_deviation(60:120,max(1, kk-20):min(max(size(PS)),kk+20))));
    end
    error_band = mean(std(standard_deviation(60:120, :)))/sqrt(60); 
    figure(1); 
    
    errorbar1 = std(standard_deviation(60:120, :)); 
    errorBarTable = [errorBarTable; bb errorbar1]; 
    
    line_step = 15; 
    symbol_step = 50; 
    
    if bb == 1 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;     
        h1 = plot(range(10:50:end), standard_deviation_range_averaged(10:50:end), 'k^',  'markersize', 8); hold on;
        h = errorbar(range(460), standard_deviation_range_averaged(460), 0.25, 'linestyle', 'none', 'color', 'k')
        errorbar_tick(h, 30); 
    end
    
    if bb ==2 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;     
        h2 = plot(range(30:50:end), standard_deviation_range_averaged(30:50:end), 'ko', 'markersize', 8); hold on; 
%         h =errorbar(range(480), standard_deviation_range_averaged(480), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==3
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;             
        h3 = plot(range(50:50:end), standard_deviation_range_averaged(50:50:end), 'k<', 'markersize', 8); hold on; 
%         h = errorbar(range(500), standard_deviation_range_averaged(500), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==4
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.9 0.9 0.9]); hold on;     
        h4 = plot(range(20:50:end), standard_deviation_range_averaged(20:50:end), 'k*', 'markersize', 8); hold on; 
%         h = errorbar(range(520), standard_deviation_range_averaged(520), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==5 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
        h5 = plot(range(40:50:end), standard_deviation_range_averaged(40:50:end), 'k>', 'markersize', 8); hold on; 
%         h = errorbar(range(540), standard_deviation_range_averaged(540), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==6 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
        h6 = plot(range(10:50:end), standard_deviation_range_averaged(10:50:end), 'kd', 'markersize', 8); hold on;
%         h = errorbar(range(560), standard_deviation_range_averaged(560), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
        
%     ylim([0 250]);colorbar; 
    ylim([0 6])
    set(gca, 'fontsize', 23);
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    xlabel('Range (km)'); 
    ylabel('Standard deviation \sigma (dB)'); 
%     title(['Standard deviation of PS intensity for different bandwidths, function of range']);
end
set(s(1), 'position', [0.05 0.1 0.4 0.8]); box on; 

h = legend([h1, h2, h3, h4, h5, h6], 'CW', '20 Hz', '50 Hz', '100 Hz', '150 Hz', '200 Hz', 'fontsize', 18, 'location', 'southwest')
% set(h,  'interpreter', 'latex')

% legend(num2str(band2(1)), num2str(band2(2)), num2str(band2(3)), num2str(band2(4)), num2str(band2(5)), num2str(band2(6)));
% eval([' saveas(gcf, ''std_vs_range_',  num2str(f_c), '.tif'')']);
% eval(['print -f1 -depsc /Users/dtran/2006_stats/Figures/std_vs_range_', num2str(f_c), '.eps']);
set(gcf, 'paperPositionMode', 'auto');


%  cd /Volumes/scratch2/TL_vs_range/Transect14/415_PS %path has been changed 
%1125 : 
% cd /Users/dtran/Research/TL_vs_Range/1125_PS

cd /Volumes/scratch2/TL_vs_range/Results/1125_PS
% f_c = 1125; 
% band2 = input('6 frequencies you want for std plot: ');
% 
% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%%plot std vs. range
s(2) = subplot(1, 2, 2); 

band2 = [0 20 50 150 250 350];

for bb = 1:length(band2)
    eval(['load PSmean_std_rect_', num2str(band2(bb)), '.mat']);
   
    range = 50*[1:1:max(size(PS))]
    for kk = 1:size(standard_deviation, 2)
        standard_deviation_range_averaged(kk) = mean(mean(standard_deviation(60:120,max(1, kk-20):min(max(size(PS)),kk+20))));
    end
    figure(1); 
    
    error_band = mean(std(standard_deviation(60:120, :))); 
    standard_deviation_range_averaged(1) = 0;
    error_band = mean(std(standard_deviation(60:120, :)))/sqrt(60)
    errorbar1 = std(standard_deviation(60:120, :)); 
    errorBarTable = [errorBarTable; bb errorbar1]; 
    
     if bb == 1 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;     
        h1 = plot(range(10:50:end), standard_deviation_range_averaged(10:50:end), 'k^',  'markersize', 8); hold on;
         h = errorbar(range(460), standard_deviation_range_averaged(460), 0.25, 'linestyle', 'none', 'color', 'k')
        errorbar_tick(h, 30); 
     end
    
    if bb ==2 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;     
        h2 = plot(range(30:50:end), standard_deviation_range_averaged(30:50:end), 'ko', 'markersize', 8); hold on; 
%         h = errorbar(range(480), standard_deviation_range_averaged(480), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==3
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2); hold on;             
        h3 = plot(range(50:50:end), standard_deviation_range_averaged(50:50:end), 'k<', 'markersize', 8); hold on; 
%         h = errorbar(range(500), standard_deviation_range_averaged(500), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==4
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.9 0.9 0.9]); hold on;     
        h4 = plot(range(20:50:end), standard_deviation_range_averaged(20:50:end), 'k>', 'markersize', 8); hold on; 
%         h = errorbar(range(520), standard_deviation_range_averaged(520), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==5 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
        h5 = plot(range(40:50:end), standard_deviation_range_averaged(40:50:end), 'k+', 'markersize', 8); hold on; 
%         h = errorbar(range(540), standard_deviation_range_averaged(540), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    if bb ==6 
        plot(range(1:line_step:end), standard_deviation_range_averaged(1:line_step:end), 'k--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
        h6 = plot(range(10:50:end), standard_deviation_range_averaged(10:50:end), 'ks', 'markersize', 8); hold on;
%         h = errorbar(range(560), standard_deviation_range_averaged(560), 0.25, 'linestyle', 'none', 'color', 'k')
%         errorbar_tick(h, 30); 
    end
    
    
%     ylim([0 250]);colorbar; 
    ylim([0 6])
    set(gca, 'fontsize', 23);
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    xlabel('Range (km)'); 
    set(gca, 'yticklabel', '')
%     ylabel('$\sigma$ (dB)', 'interpreter', 'latex'); 
%     title(['Standard deviation of PS intensity for different bandwidths, function of range']);
end
h = legend([h1, h2, h3, h4, h5, h6], 'CW', '20 Hz', '50 Hz', '150 Hz', '250 Hz', '350 Hz', 'fontsize', 18, 'location', 'southwest')
% set(h,  'interpreter', 'latex', 'fontsize', 23)



set(gcf, 'position', [2244 362 1497 701]); 

% set(s(2), 'position', [0.48 0.1 0.4 0.8]); box on; 
set(s(1), 'position', [0.07 0.13 0.42 0.85]); box on; 
set(s(2), 'position', [0.53 0.13 0.42 0.85]); box on; 

% Create textbox
annotation(gcf,'textbox',...
    [0.442796793902642 0.882131580735004 0.113046044864227 0.0814132104454685],...
    'Interpreter','none',...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'FitBoxToText','off',...
    'LineStyle','none');

annotation(gcf,'textbox',...
    [0.442796793902642+0.53-0.07 0.882131580735004 0.113046044864227 0.0814132104454685],...
    'Interpreter','none',...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'FitBoxToText','off',...
    'LineStyle','none');


annotation(gcf,'textbox',...
    [0.385510099301318 0.659422242966489 0.162920094419457 0.181413210445468],...
    'Interpreter','latex',...
    'String',{'$f_c$ = 415 Hz'},...
    'FontWeight','bold',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');

annotation(gcf,'textbox',...
    [0.385510099301318+0.53-0.07 0.659422242966489 0.162920094419457 0.181413210445468],...
    'Interpreter','latex',...
    'String',{'$f_c$ = 1125 Hz'},...
    'FontWeight','bold',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');






% legend(num2str(band2(1)), num2str(band2(2)), num2str(band2(3)), num2str(band2(4)), num2str(band2(5)), num2str(band2(6)));
% eval([' saveas(gcf, ''std_vs_range_',  num2str(f_c), '.tif'')']);
% eval(['print -f1 -depsc /Users/dtran/2006_stats/Figures/std_vs_range_', num2str(f_c), '.eps']);
set(gcf, 'paperPositionMode', 'auto');

% print -depsc /Users/dtran/2006_stats/Figures/std_vs_range_modeled.eps 

%% 1125 
