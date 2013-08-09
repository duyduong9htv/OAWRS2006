%last modified May 12 2008 13:19
%this thing does the following 

% -for a particular centre frequency
%   -get PS grid    (for a few representative frequencies)
%   -get std grid   ( for a few freqs)
%   -plot PS vs. range, superposed on by the mean
%   -plot std vs. range for diff. bandwidth
addpath ~/Research/TL_MC_10/
close all; clear all; 
%input : bandwidths want to process 
%band = input('enter a few bandwidths to process in array form, eg. [0 10 20 30 40 50 200 500] :   ');
% MC_sample = input('number of MC sample = ');
load PSmean_std_rect_0.mat

range = 50*[1:size(PS,2)] -50; 
depth = [1:1:size(PS,1)];
% f_c = input('centre frequency = ');
clear PS; 
%get PS grid





%% plot the 2 standard deviation grids for single tone and broadband and
% save in eps format 

%close all; 
%figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
%% 
fullscreen = get(0,'ScreenSize');
figure('Position',[0 0 fullscreen(3)/2 fullscreen(4)-250])
% set(gcf, 'position', [0 0 fullscreen(3)/2 fullscreen(4)-250])


band = [0 50]
for bb = 1:2
   eval(['load PSmean_std_rect_' num2str(band(bb))]);
%     PS = PS + 10*log10(50);
    s(bb+2) = subplot(2,2, bb+2); 
  
    imagesc(range, depth, standard_deviation); caxis([0 6]);colormap(1-gray); 
    hold on; 
   
    ylim([0 245]);xlim([0 50e3])
    
    set(gca, 'fontsize', 20);
    
    if bb ==1
        ylabel('Depth (m)');
%         text(0.3, 2, 'Standard deviation of log-intensity as a function of range and depth', 'fontsize', 20);
    else
        ytl = get(gca, 'ytick');
        set(gca, 'yticklabel', '');
    end
    
   % title(['Bandwidth B = ' num2str(band(bb)), ' Hz']);
    
   
    plot(range, 200*ones(size(range)), 'linewidth', 2, 'color', 'white');
   
    
    xtl = get(gca, 'xtick'); 
    set(gca, 'xticklabel', xtl./1000);
  
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', xtl/1000);  
    xlabel('Range (km)'); 
    
    if bb == 1
        ylabel('Depth (m)'); 
    end
   
    
    
    
    
end
freezecolors(s(3)); freezecolors(s(4)); 
set(s(3), 'position', [0.13 0.10 0.3347 0.40]);
set(s(4), 'position', [0.5 0.10 0.3347 0.40]);

% t = colorbar('peer',gca);set(t, 'position', [0.86 0.11 0.031 0.347]);

%%%%%%


t = colorbar('peer',s(4));
set(t, 'fontsize', 20)
set(t, 'position', [0.852 0.104 0.032 0.319]);
set(get(t,'ylabel'),'String', 'Standard deviation \sigma (dB)', 'fontsize', 20); hold on;  freezecolors; cbfreeze; 
figure(1); hold on; 

band = [0 50]
for bb = 1:2
   eval(['load PSmean_std_rect_' num2str(band(bb))]);
%     PS = PS + 10*log10(50);
    s(bb) = subplot(2,2, bb); 
    bottom_inds = 201:1:size(PS,1);
%     PS(bottom_inds, :) = 1000;
    imagesc(range, depth, PS); colormap(gray); 
    caxis([-90 -50]); hold on; 
   
    ylim([0 245]);xlim([0 50e3])
    
    set(gca, 'fontsize', 20);
    
    if bb ==1
        ylabel('Depth (m)');
%         text(0.3, 2, 'Mean transmission loss as a function of range and depth', 'fontsize', 20);
    else
        ytl = get(gca, 'ytick');
        set(gca, 'yticklabel', '');
    end
    
    title(['Bandwidth B = ' num2str(band(bb)), ' Hz']);
      
    plot(range, 200*ones(size(range)), 'linewidth', 2, 'color', 'white');
    
    
    xtl = get(gca, 'xtick'); 
    set(gca, 'xticklabel', xtl./1000);
  
    xtl = get(gca, 'xtick');
    set(gca, 'xticklabel', '');  
    
    
    if bb ==1 
        ylabel('Depth (m)'); 
    end
   
       
    
    
end

set(s(1), 'position', [0.13 0.52 0.3347 0.40]);
freezeColors(s(1)); 
set(s(2), 'position', [0.5 0.52 0.3347 0.40]);

t = colorbar('peer',s(2),...
    [0.850427098674521 0.103781094527363+0.43 0.031 0.31910447761194],'FontSize',20);
% t = colorbar('peer',gca);set(t, 'position', [0.86 0.11 0.031 0.347]);
set(get(t,'ylabel'),'String', 'Mean transmission loss (dB)', 'fontsize', 20); hold on; 

set(gca, 'fontsize', 20); freezeColors; %cbfreeze;
set(gcf, 'paperPositionMode', 'auto');


%print -f1 -depsc /Users/dtran/2006_stats/Figures/single_tone_vs_broadband_mean_color.eps
%print -f1 -depsc /Users/dtran/2006_stats/Figures/single_tone_vs_broadband_mean_grayscale1.eps
%saveas(gcf, 'single_tone_vs_broadband_mean1.tif');




text('Parent', s(2),'String','Mean transmission loss (dB)','Rotation',90,...
    'Position',[120319.383259912 240.815217391304 17.3205080756888],...
    'FontSize',20);

annotation(figure(1),'textbox',...
    [0.142857142857143 0.857574610244988 0.0541237113402062 0.0467706013363029],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'LineStyle','none',...
    'Color',[1 1 1]);

annotation(figure(1),'textbox',...
    [0.510890476190476 0.853364083929198 0.0541237113402062 0.0467706013363029],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color',[1 1 1]);

annotation(figure(1),'textbox',...
    [0.146502976190476 0.44073250498183 0.0541237113402062 0.0467706013363029],...
    'String',{'(C)'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color',[1 1 1]);



annotation(figure(1),'textbox',...
    [0.511932142857143 0.439679873402883 0.0541237113402062 0.0467706013363029],...
    'String',{'(D)'},...
    'FontWeight','bold',...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color',[1 1 1]);




%  cbfreeze; 

set(gca, 'fontsize', 20);
set(gcf, 'paperPositionMode', 'auto');


%%%%%  must run these lines after plotting out the above

% set(gca, 'Position',[0.8 0.118947368421053 0.0135416666666667
% 0.189473684210526]);


% print -f1 -depsc mean_standard_deviation_4_panel_1125.eps