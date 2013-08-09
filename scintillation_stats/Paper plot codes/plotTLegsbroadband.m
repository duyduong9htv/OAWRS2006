
%% 415

cd /Users/dtran/Research/plotTLtransScin/RAM_Dave
load track_example1

load meanPS415.mat 
 
s(1)= subplot(1, 2, 1); 
imagesc(1:1:20000,0.2*[1:1:1999], 10*log10(G)); 
hold on; 
plot(bathy_data(:, 1), bathy_data(:, 2),'-w', 'linewidth', 1); 
caxis([-85 -55])
colormap(gray); 

setFont(18); setFigureAuto; 
ylim([0 250])
set(gca, 'xtick', 0:5000:20e3); 
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl/1000); 
xlabel('Range (km)'); 

%% 1125

cd /Users/dtran/Research/plotTLtransScin/RAM2/

load meanPS1125.mat; 
s(2)= subplot(1, 2, 2); 
imagesc(1:1:20000,0.2*[1:1:1999], 10*log10(G)); 
hold on; 
plot(bathy_data(:, 1), bathy_data(:, 2),'-w', 'linewidth', 1); 
caxis([-85 -55])
colormap(gray); 

setFont(18); setFigureAuto; 
ylim([0 250])
set(gca, 'xtick', 0:5000:20e3); 
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl/1000); 
set(gca, 'yticklabel', ''); 
xlabel('Range (km)'); 
c = colorbar('location', 'east')


set(c, 'ycolor', 'white')
set(c, 'xcolor', 'white')
get(c, 'location')

set(s(2), 'position', [0.5 0.1492 0.3347 0.7758])
set(s(1), 'position', [0.1300    0.1492    0.3347    0.7758])
set(c, 'position', [0.87 0.20 0.025 0.4])

annotation(gcf,'textbox',...
    [0.252651880424301 0.7 0.265670202507232 0.102439024390244],...
    'String',{'$f_m$=415 Hz, $B$=42 Hz'},...
    'FontWeight','bold',...
    'FontSize',18,...
    'interpreter', 'latex',...
    'LineStyle','none',...
    'Color',[1 1 1]);

annotation(gcf,'textbox',...
    [0.4 0.81 0.0564127290260366 0.0829268292682927],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',23,...
    'LineStyle','none',...
    'Color',[1 1 1]);

annotation(gcf,'textbox',...
    [0.252651880424301+0.38 0.7 0.265670202507232 0.102439024390244],...
    'String',{'$f_m$=1125 Hz, $B$=42 Hz'},...
    'FontWeight','bold',...
    'FontSize',18,...
    'interpreter', 'latex',...
    'LineStyle','none',...
    'Color',[1 1 1]);

annotation(gcf,'textbox',...
    [0.4+0.38 0.81 0.0564127290260366 0.0829268292682927],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',23,...
    'LineStyle','none',...
    'Color',[1 1 1]);
ti = get(c, 'title')
set(ti, 'string', 'dB');
set(ti, 'color', 'white', 'fontsize', 20)
set(c, 'position', [0.8 0.3 0.025 0.35])





