%% RawDataSpectrogram
% RawDataSpectrogram(pingID, freqStr) plots the spectrogram of given
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
%   Created: 05Oct2011
%   Modified: 23Feb2012
%
% See also PingObjectQuery, WhaleQuery
function RawDataSpectrogram(pingID)

cla

pingObject = PingObjectQuery('id',pingID);

rawMatDir = '/Volumes/Alpha/AveragedPings';

temp = load(fullfile(rawMatDir,sprintf('%04g.mat',pingID)));
spectData = temp.S1;

%keyboard

imagesc([0 1]*4000,[0 pingObject(1).getDuration],10*log10(spectData'))
colormap(color128map1)
caxis([45 70])
xlabel('Frequency (Hz)')
ylabel('Time (s)')
titleString = {...
    sprintf('PingID: %g, Track: %s', pingID, char(pingObject(1).getTracks().getName)),...
    sprintf('Date: %s (GMT)', char(pingObject(1).getStartTime)),...
    };

title(titleString,'Interpreter','none')
colorbar
axis xy;

set(gca,'NextPlot','Add')

ping2SrcObjects = pingObject(1).getPingsToSourceses().toArray();

for ii = 1:length(ping2SrcObjects)
    
    startTime = double(ping2SrcObjects(ii).getTimeStart()) - 0.5;
    stopTime = startTime + double(ping2SrcObjects(ii).getSources().getPulseLength());
    
    startFreq = double(ping2SrcObjects(ii).getSources().getStartFreq);
    stopFreq = double(ping2SrcObjects(ii).getSources().getStopFreq);
%     xLimits = pingInfo.sources(ii).sourceFrequency;
%     yLimits = pingInfo.sources(ii).sourceTime - 0.5;
    
    
    xData = [startFreq startFreq stopFreq stopFreq startFreq];
    yData = [startTime stopTime stopTime startTime startTime];
    
    plot(xData, yData, 'y','Linewidth',1);
    text(xData(2), yData(1), char(ping2SrcObjects(ii).getSources().getWaveformName), 'Color', 'y', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
end

whales = WhaleQuery('ping', pingID);

set(gca,'NextPlot','Add')

for ii = 1:length(whales)
    
    xData = [whales(ii).freqBounds(1) whales(ii).freqBounds(2) whales(ii).freqBounds(2) whales(ii).freqBounds(1) whales(ii).freqBounds(1)];
    yData = [whales(ii).timeBounds(1) whales(ii).timeBounds(1) whales(ii).timeBounds(2) whales(ii).timeBounds(2) whales(ii).timeBounds(1)];
    
    plot(xData, yData, 'w','Linewidth',1)
    text(xData(2), yData(1), num2str(whales(ii).whaleID), 'Color', 'w', 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom');
    
end

xlim([0 4000])
ylim([0 pingObject(1).getDuration])

% FigureSize(gcf,'Custom',[600 1000])