%% RawDataSpectrogram_v02
% RawDataSpectrogram_v02(pingID, freqStr) plots the spectrogram of given
% pingID.
%
% Inputs:
%
% * pingID- the pingID in which you wnat to plot the spectrogram
% * freqStr- string representing the frequency to read in raw data
%       'lf': low-frequency
%       'mf': mid-frequency
%       'hf': high-frequency
%
% Outputs:
%
% * none
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Date: 05Oct2011
%%
function RawDataSpectrogram_v02(pingID)

cla

pingInfo = GetPingInfo_v2('id',pingID);

rawMatDir = '/Volumes/Alpha/AveragedPings';

temp = load(fullfile(rawMatDir,sprintf('%04g.mat',pingID)));
spectData = temp.S1;

%keyboard

imagesc([0 1]*4000,[0 pingInfo.duration],10*log10(spectData'))
colormap(color128map1)
caxis([45 70])
xlabel('Frequency (Hz)')
ylabel('Time (s)')
title({sprintf('PingID: %g, Track: %s',pingInfo.pingID, pingInfo.trackName), sprintf('Date: %s (GMT)', pingInfo.startTime)},'Interpreter','none')
colorbar
axis xy;

set(gca,'NextPlot','Add')
for ii = 1:length(pingInfo.sources)
    
    xLimits = pingInfo.sources(ii).sourceFrequency;
    yLimits = pingInfo.sources(ii).sourceTime - 0.5;
    
    
    xData = [xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)];
    yData = [yLimits(1) yLimits(2) yLimits(2) yLimits(1) yLimits(1)];
    
    plot(xData, yData, 'y','Linewidth',1);
    text(xData(2), yData(1), pingInfo.sources(ii).waveform, 'Color', 'y', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
end

whales = GetWhaleInfo_v3('ping', pingID);

set(gca,'NextPlot','Add')

for ii = 1:length(whales)
    
    xData = [whales(ii).frequencyBounds(1) whales(ii).frequencyBounds(2) whales(ii).frequencyBounds(2) whales(ii).frequencyBounds(1) whales(ii).frequencyBounds(1)];
    yData = [whales(ii).timeBounds(1) whales(ii).timeBounds(1) whales(ii).timeBounds(2) whales(ii).timeBounds(2) whales(ii).timeBounds(1)];
    
    plot(xData, yData, 'w','Linewidth',1)
    text(xData(2), yData(1), num2str(whales(ii).whaleID), 'Color', 'w', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
    
end

xlim([0 4000])
ylim([0 pingInfo.duration])