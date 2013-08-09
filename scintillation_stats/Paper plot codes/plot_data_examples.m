% % plots the examples of data which includes
% - transmitted signal
% - received signal
% - frequency spectra of both

 cd /Volumes/scratch/duong/whale_localization_data/Tracks_data/track570_7/DAT/
f_samp = 8000; 
t_0 = 0; 
t_p = 1; 
T = 2; 
f_i = 390; f_f = 440; 

[st1, Sf1, rst1, rSf1] = getLFM(f_samp, t_0, t_p, T, f_i, f_f);

figure(14);
setFigureAuto; 
s1 = subplot(2, 2, 1); 
plot(1/8000*[1:1:size(st1, 2)], sqrt(2)*real(st1), '-k')
setFont(18);
title('Transmitted signal'); 
ylabel('Normalized pressure (\muPa)'); 
xlabel('Time (seconds)'); 


filename = 'fora2006jd277t000500.dat'; 
input_series = read_input_series(filename, 'lf'); 

figure(14); s2 =subplot(2, 2, 2); 
ReceivedTimeSeries = BandPassFilter(input_series, 0, 600, 8000); 
plot(1/8000*[1:1:size(input_series, 1)], real(ReceivedTimeSeries/(10^(220/20))), 'k');
xlim([5.5 8.5])
setFont(18); 
title('Received signal at 9 km range'); 
xlabel('Time (seconds)'); 

s3 = subplot(2, 2, 3); 
plot(linspace(0, 8000, size(Sf1,2)), abs(Sf1)/sqrt(2), 'k');
setFont(18);
set(gca, 'ytick', [0 0.1 0.2])
ylim([0 0.15])
xlim([350 500])

xlabel('Frequency (Hz)'); 
ylabel('Normalized spectrum');

s4 = subplot(2, 2, 4); 
T = size(input_series, 1)/f_samp; 
ReceivedSpectrum = ifft(input_series(:, 1)/(10^(220/20)))*T; 
plot(linspace(0, 8000, size(ReceivedSpectrum, 1)), abs(ReceivedSpectrum), 'k'); 
setFont(18); 
xlim([350 500])
xlabel('Frequency (Hz)'); 

%% adjusting positions 

s1Pos = get(s1, 'position') 
s2Pos = get(s2, 'position') 
s3Pos = get(s3, 'position')
s4Pos = get(s4, 'position')

GraphWidth = s1Pos(3); 
GraphHeight = s1Pos(4); 

DeltaX = 0.05; 
DeltaY = 0.1; 

set(s3, 'position', [s1Pos(1) s1Pos(2)-GraphHeight-DeltaY GraphWidth GraphHeight]);  
set(s2, 'position', [s1Pos(1)+GraphWidth+DeltaX s1Pos(2) GraphWidth GraphHeight]);  
set(s4, 'position', [s1Pos(1)+GraphWidth+DeltaX s2Pos(2)-GraphHeight-DeltaY GraphWidth GraphHeight]);  


% print -depsc /Users/dtran/2006_stats/Figures/data_example.eps
