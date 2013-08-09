%% RawSpectrogramSteered
% GetSteeredData(inputs) returns a ...
%
% Inputs:
%
% * signalTD- the signal in the time domain.  This a 64xN matrix.
% * sensorSpacingMeters- spacing between array elements.
% * doaEstimate- direction of arrival estimate in units sin(theta) (-1 to 1)
% * window- filter window.
%
% Outputs:
%
% * output1- a ...
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Date: 19Sep2011
%%
function RawSpectrogramSteered(pingID, steeringAngleDegrees)

numPlots = length(steeringAngleDegrees);

ah = zeros(1,numPlots+1);

pingObject = PingObjectQuery('id',pingID);
pingInfo = PingQuery('id',pingID);

pingObject1 = PingObject(pingInfo);

% rawMatDir = '/Volumes/Alpha/AveragedPings';
% 
% temp = load(fullfile(rawMatDir,sprintf('%04g.mat',pingID)));
% spectData = temp.S1/64;

pingObject1.LoadData('lf')
pingObject1.Spectrogram;


%keyboard
ah(1) = subplot(numPlots + 1,1,1);
set(ah(1),'NextPlot','Add')
imagesc([0 pingObject(1).getDuration],[0 1]*1000,10*log10(pingObject1.spectrogramData))
colormap(color128map1)
colorbar
caxis([100 110])
ylabel('Frequency (Hz)')
xlabel('Time (s)')

axis xy

ylim([0 800])
    xlim([0 pingObject(1).getDuration()])
set(ah(1),'Box','On','Linewidth',2)







rawData = pingObject1.rawDataLF;

% %Decimate
% index = 1:4:size(rawData,1);
% rawData = rawData(index,:);


for ii = 2:numPlots+1
    beamData = GetSteeredData(rawData,1.5,sind(steeringAngleDegrees(ii-1)),2000);
    
    wavwrite(real(beamData/max(real(beamData))),2000,num2str(ii))
    
    S = spectrogram(beamData,128,64,8192,2000);
    
    ah(ii) = subplot(numPlots+1,1,ii);
    set(ah(ii),'NextPlot','Add')
    imagesc([0 length(beamData)/2000],[0 2000],20*log10(abs(S/2)))
    colormap(color128map1)
    
    
    axis xy
    colorbar
    caxis([70 110])
    ylim([0 800])
    xlim([0 pingObject(1).getDuration()])
    
    set(ah(ii),'Box','On','Linewidth',2)
end

FigureSize(gcf,'custom',[1840 430])

pause(0.5)
ping2SrcObjects = pingObject(1).getPingsToSourceses().toArray();

sbh = zeros(1,length(ping2SrcObjects));
sth = zeros(1,length(ping2SrcObjects));
for ii = 1:length(ping2SrcObjects)
    
    startTime = double(ping2SrcObjects(ii).getTimeStart()) - 0.5;
    stopTime = startTime + double(ping2SrcObjects(ii).getSources().getPulseLength());
    
    startFreq = double(ping2SrcObjects(ii).getSources().getStartFreq);
    stopFreq = double(ping2SrcObjects(ii).getSources().getStopFreq);
    %     xLimits = pingInfo.sources(ii).sourceFrequency;
    %     yLimits = pingInfo.sources(ii).sourceTime - 0.5;
    
    
    yData = [startFreq startFreq stopFreq stopFreq startFreq];
    xData = [startTime stopTime stopTime startTime startTime];
    
    sbh(ii) = plot(ah(1),xData, yData, 'y','Linewidth',1);
    sth(ii) = text(xData(2), yData(1), char(ping2SrcObjects(ii).getSources().getWaveformName),...
        'Color', 'y',...
        'HorizontalAlignment', 'Right',...
        'VerticalAlignment', 'Bottom',...
        'FontSize',8,...
        'Parent',ah(1));
end

whales = WhaleQuery('ping', pingID);



wbh = zeros(1,length(whales));
wth = zeros(1,length(whales));
for ii = 1:length(whales)
    
    yData = [whales(ii).freqBounds(1) whales(ii).freqBounds(2) whales(ii).freqBounds(2) whales(ii).freqBounds(1) whales(ii).freqBounds(1)];
    xData = [whales(ii).timeBounds(1) whales(ii).timeBounds(1) whales(ii).timeBounds(2) whales(ii).timeBounds(2) whales(ii).timeBounds(1)];
    
    wbh(ii) = plot(ah(1),xData, yData, 'w','Linewidth',1);
    wth(ii) = text(xData(3), yData(1), num2str(whales(ii).whaleID),...
        'Color', 'w',...
        'HorizontalAlignment', 'Right',...
        'VerticalAlignment', 'Bottom',...
        'FontSize',8,...
        'Parent',ah(1));
    
end

% for ii = 2:numPlots+1
% copyobj([sbh sth wbh wth],ah(ii))
% end

PrepFiguresForPPT(gcf,18)