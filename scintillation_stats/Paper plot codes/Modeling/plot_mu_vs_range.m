%% plot mu vs. range
% for a transect of 50 km length, 50 m increment 
% 415 :
%  cd /Volumes/scratch2/TL_vs_range/Transect14/415_PS %path has been changed 
%1125 : 
% cd /Users/dtran/Research/TL_vs_Range/1125_PS



close all; clear all; 
 cd /Volumes/scratch2/TL_vs_range/Transect14/415_PS %path has been changed 
%1125 : 
% cd /Users/dtran/Research/TL_vs_Range/1125_PS

% cd /Volumes/scratch2/TL_vs_range/Results/1125_PS
% f_c = 1125; 

% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%%plot std vs. range
% 
% load ~/Research/TL_MC_10/P'aper plot codes'/pos.mat 
% figure('Position', pos)


fullscreen = get(0,'ScreenSize');
figure('Position',[0 0 fullscreen(3)-250 fullscreen(4)/2]);
set(gcf, 'position', [1966 466 1400 600])
% 415 


band1 = input('6 frequencies you want for std plot: ');
% 
% fullscreen = get(0,'ScreenSize');
% figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%%plot std vs. range
s(1) = subplot(1, 2, 1)

for bb = 1:length(band1)
    eval(['load PSmean_std_rect_', num2str(band1(bb)), '.mat']);
   
    range = 50*[1:1:max(size(PS))]
    for kk = 1:size(standard_deviation, 2)
        standard_deviation_range_averaged(kk) = mean(mean(standard_deviation(60:120,max(1, kk-20):min(max(size(PS)),kk+20))));
        mu(kk) = get_tbprod(standard_deviation_range_averaged(kk)); 
    end
%     figure(1); 
    
    if bb == 1 
        plot(range(60:15:end), mu(60:15:end), '--k', 'linewidth', 2); hold on;     
    end
    
    if bb ==2 
        plot(range(60:15:end), mu(60:15:end), 'k-', 'linewidth', 2); hold on;     
    end
    
    if bb ==3
        plot(range(60:15:end), mu(60:15:end), 'k-.', 'linewidth', 2); hold on;             
    end
    if bb ==4
        plot(range(60:15:end), mu(60:15:end), '-.', 'linewidth', 2, 'color', [0.9 0.9 0.9]); hold on;     
    end
    
    if bb ==5 
        plot(range(60:15:end), mu(60:15:end), 'k-', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
    
    if bb ==6 
        plot(range(60:15:end), mu(60:15:end), '--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
%     ylim([0 250]);colorbar; 
%     ylim([0 6])
    set(gca, 'fontsize', 20);
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    xlabel('Range (km)'); ylabel('Number of coherence cells  \mu'); %set(aa, 'intepreter', 'latex'); 
%     title(['Standard deviation of PS intensity for different bandwidths, function of range']);
end
h = legend('CW', '20 Hz', '50 Hz', '150 Hz', '250 Hz', '350 Hz', 'fontsize', 18, 'location', 'southeast')
set(h, 'interpreter', 'latex')
% legend(num2str(band2(1)), num2str(band2(2)), num2str(band2(3)), num2str(band2(4)), num2str(band2(5)), num2str(band2(6)));
% eval([' saveas(gcf, ''std_vs_range_',  num2str(f_c), '.tif'')']);
% eval(['print -f1 -depsc std_vs_range_', num2str(f_c), '.eps']);




cd /Volumes/scratch2/TL_vs_range/Results/1125_PS
s(2) = subplot(1, 2, 2); box on; 

for bb = 1:length(band1)
    eval(['load PSmean_std_rect_', num2str(band1(bb)), '.mat']);
   
    range = 50*[1:1:max(size(PS))]
    for kk = 1:size(standard_deviation, 2)
        standard_deviation_range_averaged(kk) = mean(mean(standard_deviation(60:120,max(1, kk-20):min(max(size(PS)),kk+20))));
        mu(kk) = get_tbprod(standard_deviation_range_averaged(kk)); 
    end
%     figure(1); 
    
    if bb == 1 
        plot(range(60:15:end), mu(60:15:end), '--k', 'linewidth', 2); hold on;     
    end
    
    if bb ==2 
        plot(range(60:15:end), mu(60:15:end), 'k-', 'linewidth', 2); hold on;     
    end
    
    if bb ==3
        plot(range(60:15:end), mu(60:15:end), 'k-.', 'linewidth', 2); hold on;             
    end
    if bb ==4
        plot(range(60:15:end), mu(60:15:end), '-.', 'linewidth', 2, 'color', [0.9 0.9 0.9]); hold on;     
    end
    
    if bb ==5 
        plot(range(60:15:end), mu(60:15:end), 'k-', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
    
    if bb ==6 
        plot(range(60:15:end), mu(60:15:end), '--', 'linewidth', 2, 'color', [0.8 0.8 0.8]); hold on;     
    end
    
%     ylim([0 250]);colorbar; 
%     ylim([0 6])
    set(gca, 'fontsize', 20);
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    ylim([0 25])
    xlabel('Range (km)'); 
%     ylabel('Number of coherence cells $\mu$', 'interpreter', 'latex'); %set(aa, 'intepreter', 'latex'); 
%     title(['Standard deviation of PS intensity for different bandwidths, function of range']);
end
h = legend('CW', '20 Hz', '50 Hz', '150 Hz', '250 Hz', '350 Hz', 'fontsize', 18, 'location', 'northeast')
% set(h, 'interpreter', 'latex')
% 
% pos1 = get(s(1), 'position'); 
% set(s(2), 'yticklabel', '')
% set(s(2), 'position', [pos1(1)+0.35 0.11 0.3347 0.8150])

set(s(1), 'position', [0.05 0.1 0.4 0.8]);
set(s(2), 'position', [0.48 0.1 0.4 0.8])
set(s(2), 'yticklabel', '')

% set(gcf, 'paperPositionMode', 'auto');
% print -dtiff /Users/dtran/2006_stats/Figures/mu_vs_range_1125.tif
% print -depsc /Users/dtran/2006_stats/Figures/mu_vs_range_1125.eps



a = annotation(gcf,'textbox',...
    [0.06 0.65 0.113046044864227 0.0814132104454685],...
    'Interpreter','latex',...
    'String',{'$f_c$=415 Hz'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');
set(a, 'interpreter', 'latex')


annotation(gcf,'textbox',...
    [0.01+0.48 0.65 0.113046044864227 0.0814132104454685],...
    'Interpreter','latex',...
    'String',{'$f_c$=1125 Hz'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');
set(a, 'interpreter', 'latex')

a = annotation(gcf,'textbox',...
    [0.06 0.75 0.113046044864227 0.0814132104454685],...
    'Interpreter','latex',...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');
set(a, 'interpreter', 'latex')


annotation(gcf,'textbox',...
    [0.01+0.48 0.75 0.113046044864227 0.0814132104454685],...
    'Interpreter','latex',...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',24,...
    'FitBoxToText','off',...
    'LineStyle','none');
set(a, 'interpreter', 'latex')

setFigureAuto; 



% print -dtiff /Users/dtran/2006_stats/Figures/mu_vs_range_415.tif
% print -depsc /Users/dtran/2006_stats/Figures/mu_vs_range_415.eps


print -depsc /Users/dtran/2006_stats/Figures/mu_vs_range_both.eps