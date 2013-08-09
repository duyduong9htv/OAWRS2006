%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% last modified Jun 07 2010 12:10pm
%
% This file plots the average standard deviation vs. the relative bandwidth
% for all 4 waveforms, using different symbols in order to get the paper in
% all black and white

% modifed may 21: make 2 subplots for sigma and mu. Do curve fitting on mu.
% Then use riemann zeta function to plot curve fit on signam 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all; 
% close all; 

%save std_dev_rel_bw_all_waveforms.mat rel_bw415 rel_bw735 rel_bw950 rel_bw1125 std_dev415 std_dev735 std_dev950 std_dev1125;

cd ~/2006_data_from_geoclutter1/
mksize = 12; %markersize
%% plot the curve fitting for mu first, then use riemann zeta equation to
%% get that of sigma
%clear
load std_dev_rel_bw_all_waveforms
cd /Volumes/scratch2/Source_calibrations/PScal
fullscreen = get(0,'ScreenSize');
figure('Position',[0 0 fullscreen(3)-250 fullscreen(4)/2]);

%% error bar values 
err_bar = [0.82 0.68 0.63 0.62 0.62; 
            0.89 0.82 0.80 0.82 0.84; 
            0.91 0.88 0.86 0.84 0.84;
            0.93 0.86 0.84 0.85 0.86]; %standard deviation
        
NoTrans = 200

err_bar = err_bar/sqrt(NoTrans); 

%% 415 
x1 = [0 0.5/415 rel_bw415(1:4)];
y1 = ones(1,6);
load std_415_all
std_dev415 = [std_ave(1) std_dev415]; 

for ii = 1:6
    mu(ii) = get_tbprod(std_dev415(ii))
end 

for ii = 1:5
    y1(ii+1) = mu(ii)
end

[k1, A1] = findCoeff(x1, y1); 
figure(1); s(2) = subplot(1,2,2); hold on;  plot([0.5/415 rel_bw415], mu, 'k*', 'linewidth', 2, 'markersize', mksize); 


%% 735 
x1 = [0 0.5/735  rel_bw735(1:4)];
y1 = ones(1,6);
load std_735_all
std_dev735 = [std_ave(1) std_dev735]; 

for ii = 1:6
    mu(ii) = get_tbprod(std_dev735(ii));
end
for ii = 1:5
    y1(ii+1) = mu(ii)
end

[k2, A2] = findCoeff(x1, y1); 
plot([0.5/735 rel_bw735], mu, 'k^', 'linewidth', 2, 'markersize', mksize);


%% 950
x1 = [0 0.5/950 rel_bw950(1:4)];
y1 = ones(1,6);
load std_950_all
std_dev950 = [std_ave(1) std_dev950]; 

for ii = 1:6
    mu(ii) = get_tbprod(std_dev950(ii));
end
for ii = 1:5
    y1(ii+1) = mu(ii)
end

[k3, A3] = findCoeff(x1, y1); 
plot([0.5/950 rel_bw950], mu, 'kd', 'linewidth', 2, 'markersize', mksize);


%% 1125 

x1 = [0 0.5/1125 rel_bw1125(1:4)];
y1 = ones(1,6);
load std_1125_all
std_dev1125 = [std_ave(1) std_dev1125]; 

for ii = 1:6
    mu(ii) = get_tbprod(std_dev1125(ii));
end
for ii = 1:5
    y1(ii+1) = mu(ii)
end

[k4, A4] = findCoeff(x1, y1); 
plot([0.5/1125 rel_bw1125], mu, 'ko', 'linewidth', 2, 'markersize', mksize);

h = errorbar(rel_bw415(3),get_tbprod(std_dev415(4)), 0.11, 'linestyle', 'none', 'color', 'k'); 
errorbar_tick(h, 20); 

%% curve fitting plot

x4 = [0:0.001:max(rel_bw1125)]; y4 = A4 -(A4-1)*exp(-k4.*x4); plot(x4, y4, 'k--');hold on; 
x3 = [0:0.001:max(rel_bw950)]; y3 = A3 -(A3-1)*exp(-k3.*x3);plot(x3, y3, 'k--');
x1 = [0:0.001:max(rel_bw415)]; y1 = A1 -(A1-1)*exp(-k1.*x1); plot(x1,y1 , 'k--');
x2 = [0:0.001:max(rel_bw735)]; y2 = A2 -(A2-1)*exp(-k2.*x2);plot(x2, y2, 'k--');
xlim([0 0.12])

set(s(2), 'position', [0.55 0.13 0.42 0.85]); box on; 
set(gca, 'fontsize', 26)
ylim([1 3])
set(gca, 'ytick', [1:0.5:3])
set(gca, 'yticklabel', [1:0.5:3])
xl = xlabel('Relative bandwidth B/f_m');
yl = ylabel('Number of correlation cells \mu_F')
le = legend('$f_m$ = 415 Hz', '$f_m$ = 735 Hz', '$f_m$ = 950 Hz', '$f_m$ = 1125 Hz', 'location', 'southeast')

set(le, 'interpreter', 'latex', 'fontsize', 26); 


%% sigma part 


s(1) = subplot(1,2,1); 
plot([0.5/415 rel_bw415], std_dev415, 'k*', 'linewidth', 2 , 'markersize', mksize);hold on;
plot([0.5/735 rel_bw735], std_dev735, 'k^', 'linewidth', 2, 'markersize', mksize);
plot([0.5/950 rel_bw950], std_dev950, 'kd', 'linewidth', 2, 'markersize', mksize)
plot([0.5/1125 rel_bw1125], std_dev1125, 'ko', 'linewidth', 2, 'markersize', mksize)
le = legend('$f_m$ = 415 Hz', '$f_m$ = 735 Hz', '$f_m$ = 950 Hz', '$f_m$ = 1125 Hz');
xlim([0 0.14])

load ~/Research/SI/range_std_415.mat

h = errorbar(rel_bw415(3), std_dev415(4), 0.07, 'linestyle', 'none', 'color', 'k'); 
errorbar_tick(h, 20); 

load ~/Research/SI/range_std_735.mat 
% h = errorbar(rel_bw735(3), std_dev735(3), 0.07, 'linestyle', 'none', 'color', 'k'); 
% errorbar_tick(h, 20);

load ~/Research/SI/range_std_950.mat
% e = std(range_std(:, 2:end)); 
% h = errorbar(rel_bw950(3), std_dev950(3), 0.07, 'linestyle', 'none', 'color', 'k'); 
% errorbar_tick(h, 20);


load ~/Research/SI/range_std_1125.mat
% e = std(range_std(:, 2:end)); 
% h = errorbar(rel_bw1125(3), std_dev1125(3), 0.07, 'linestyle', 'none', 'color', 'k'); 
errorbar_tick(h, 20);


x1 = [0:0.001:max(rel_bw415)];
for ii = 1:length(x1)
    sigma1(ii) = 10*log10(exp(1))*sqrt(riemann_zeta_dd(2,y1(ii)));
end

plot(x1, sigma1, '--k');

x1 = [0:0.001:max(rel_bw735)];
for ii = 1:length(x1)
    sigma2(ii) = 10*log10(exp(1))*sqrt(riemann_zeta_dd(2,y2(ii)));
end

plot(x1, sigma2, '--k');

x1 = [0:0.001:max(rel_bw950)];
for ii = 1:length(x1)
    sigma3(ii) = 10*log10(exp(1))*sqrt(riemann_zeta_dd(2,y3(ii)));
end

plot(x1, sigma3, '--k');

x1 = [0:0.001:max(rel_bw1125)];
for ii = 1:length(x1)
    sigma4(ii) = 10*log10(exp(1))*sqrt(riemann_zeta_dd(2,y4(ii)));
end

plot(x1, sigma4, '--k');


%% annotation 
xlim([0 0.12])
set(s(1), 'position', [0.07 0.13 0.42 0.85]);
set(gca, 'fontsize', 26); 
xl = xlabel('Relative bandwidth B/f_m'); 
yl = ylabel('Standard deviation  \sigma')
set(le, 'interpreter', 'latex', 'fontsize', 26); 
set(gcf, 'paperPositionMode', 'auto');

annotation(figure(1),'textbox',...
    [0.0601060695344726+0.02 0.828787234042553+0.03 0.0433117265763111 0.0470324748040314],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');
annotation(figure(1),'textbox',...
    [0.568615203299941+0.02 0.828787234042553+0.03 0.0433117265763111 0.0470324748040314],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');
set(gcf, 'position', [2244 362 1497 701]); 


%% error barr showing bias of estimates










%% save 

% print -f1 -depsc /Users/dtran/2006_stats/Figures/2006_mu_and_sigma_vs_relative_bandwidth_curve_fit.eps


