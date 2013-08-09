%% 415 Hz

load('Mean_and_standard_dev_across_bandwidth_415.mat')
Labels = {'Frequency (Hz)','Normalized ESD (dB)', ''}; 
Range = [395 435; -10 10; 2.6 8.6]; 
Legends = {'Energy spectral density', 'Standard deviation'}
load Pos.mat 
figure(3); clf; 
s(1)= subplot(1, 2, 1);   


gainCorrection = 21.6; 
SL = 217; 
mean_spectrum = mean_spectrum - SL; 
layerplot2([398:432],mean_spectrum(9:43),[398:432], std_dB(9:43), Labels, Range, Legends);


%% 1125 Hz 


load Calculating_mean_std_1125_7to9km.mat
figure(3);
hold on; 
s(2)= subplot(1, 2, 2); 
Range = [1100 1150; -10 10; 2.6 8.6];
Labels = {'Frequency (Hz)','', 'Standard deviation (dB)'}; 
Legends = {'Energy spectral density', 'Standard deviation'}
mean_spectrum = mean_spectrum - mean(mean_spectrum(9:43)); 
layerplot2([1108:1142],mean_spectrum(9:43),[1108:1142], std_dB(9:43), Labels, Range, Legends);


%% annotation 
set(gcf, 'position', [1971         318        1332         557])
set(s(2), 'position', [0.52 0.11 0.3347 0.8150])


annotation(gcf,'textbox',...
    [0.146396396396396 0.781764811490126 0.163288288288288 0.0987432675044883],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');

annotation(gcf,'textbox',...
    [0.146396396396396+0.395 0.781764811490126 0.163288288288288 0.0987432675044883],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');

setFigureAuto; 

%% save 

print -depsc /Users/dtran/2006_stats/Figures/Mean_std_dev_spectrum.eps

%% replot, showing erorbars every 5 Hz 

clear; 
cd /Users/dtran/Research/TL_MC_10/plotMeanStdDevSpectrum



load('Mean_and_standard_dev_across_bandwidth_415.mat')
figure(10); clf; hold on; 

s(1) = subplot(1, 2, 1); hold on; 

normFactor = 210 - 20*log10(50);
mean_spectrum = mean_spectrum - normFactor; 

%source waveform correction 
[st1, Sf1, rst1, rSf1] = getLFM(8000, 0, 1, 2, 390, 440);
SL_correct_fact = abs(Sf1(2*(390:1:440)));
mean_spectrum = mean_spectrum - 20*log10(abs(SL_correct_fact)) - 17.92 ;



plot([398:432],mean_spectrum(9:43), '-k', 'linewidth', 2); hold on; 
% plot([390:440],mean_spectrum, '-k', 'linewidth', 2); hold on;
ylim([-85 -55]); 
xlim([395 435]); 
errorX = [400:5:430]; 
errorB = std_dB(11:5:41); 
h = errorbar(errorX, mean_spectrum(11:5:41), errorB,  'linestyle', 'none','color', 'k'); hold on; 

% 
% % errorX = [390:5:440]; 
% errorB = std_dB(1:5:51); 
% h = errorbar(errorX, mean_spectrum(1:5:51), errorB,  'linestyle', 'none','color', 'k'); hold on; 


errorbar_tick(h, 20); 

setFont(20); 
% ylim([-85 -55])
box on; 
ylabel('Transmission loss (dB re 1 m)'); 
xlabel('Frequency (Hz)'); 



%% 1125 Hz 
s(2) = subplot(1, 2, 2) 
hold on; box on; 
set(gcf, 'position', [1971         318        1332         557])
set(s(2), 'position', [0.52 0.11 0.3347 0.8150])

load Calculating_mean_std_1125_7to9km.mat
setFigureAuto
setFont(20); 
normFactor = 210 - 20*log10(50);
mean_spectrum = mean_spectrum - normFactor; 

[st1, Sf1, rst1, rSf1] = getLFM(8000, 0, 1, 2, 1100, 1150);
SL_correct_fact = abs(Sf1(2*(1100:1:1150)));
mean_spectrum = mean_spectrum - 20*log10(abs(SL_correct_fact)) - 17.92 ;


% plot([1108:1142],mean_spectrum(9:43), '-k', 'linewidth', 2); 


plot([1100:1150], mean_spectrum, '-k', 'linewidth', 2); 

errorX = [1110:5:1140]; 
errorB = std_dB(11:5:41); 
h = errorbar(errorX, mean_spectrum(11:5:41), errorB,  'linestyle', 'none','color', 'k'); hold on;
errorbar_tick(h, 20); 

set(gcf, 'position', [1971         318        1332         557])
set(s(2), 'position', [0.52 0.11 0.3347 0.8150])


annotation(gcf,'textbox',...
    [0.146396396396396 0.781764811490126 0.163288288288288 0.0987432675044883],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');

annotation(gcf,'textbox',...
    [0.146396396396396+0.395 0.781764811490126 0.163288288288288 0.0987432675044883],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',26,...
    'LineStyle','none');

setFigureAuto; 


ylim([-85 -55])
set(gca, 'yticklabel', ''); 
xlim([1105 1145])
xlabel('Frequency (Hz)'); 



% print -depsc /Users/dtran/2006_stats/Figures/Mean_std_dev_spectrum.eps


%% plot mean of the linear estimate 

figure; plot([1100:1150], mean_linear/sqrt(sum(abs(mean_linear).^2)), '-k', 'linewidth', 2); 







