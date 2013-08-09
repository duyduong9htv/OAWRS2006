% plot histogram with less black color (waste of ink and irritates the
% eyes, remove title); 

cd /Users/dtran/Research/SI
clear; 
close all; 
load range_PS_415
range = range_PS(:,1);
[hist_r x] = hist(range, 30)
figure(1); set(gcf, 'position', [1 1 695 513]);
bar(x, hist_r, 'barwidth', 1.0, 'facecolor', 'white'); box on; 

ylabel('Number of transmissions ', 'fontsize', 20); 
xlabel('Range (km)', 'fontsize', 20)
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl/1000); 
xlim([0 20e3])
set(gca, 'fontsize', 20)
set(gcf, 'paperpositionMode', 'auto');
% print -f1 -depsc /Users/dtran/2006_stats/Figures/histogram.eps


cdf = zeros(length(x)+1);
for ii = 1:length(x)
    cdf(ii+1) = sum(hist_r(1:ii));
end

figure; plot([0 x], cdf./sum(hist_r), 'k-', 'linewidth', 2); 
addpath ~/Research/Tools/
polish_figure; 
a= ylabel('CDF of transmissions ', 'fontsize', 18); 
set(a, 'interpreter', 'latex'); 
a = xlabel('Range (km)', 'fontsize', 18); 
set(a, 'interpreter', 'latex'); 
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl/1000); 
xlim([0 20e3])
set(gca, 'fontsize', 16)
set(gcf, 'paperpositionMode', 'auto');

 print -f2 -depsc /Users/dtran/2006_stats/Figures/cdf_transmission.eps