classdef PingObject < handle
    %PINGOBJECT Summary of this class goes here
    %   Detailed explanation goes here   
    
    
    properties
        
        pingID;
        headingAvg;
        startTime;
        receiverLatLng; 
        sourceLatLng;
        rcvUTM; 
        srcUTM; 
        duration;
        foraName;
        trackName;
        rawFs = 8000;
        decimateFs = 2000;
        srcRange; 
        relBearing; 
        trueBearing; 
        % Data        
        beamData;
        spectrogramData;
        rawDataLF;
        rawDataMF;
        
        % Filenames
        rawDataLFName;
        rawDataMFName;
        spectrogramName;
        
        rawDir;
    end
    
    methods
        
        function po = PingObject(javaObject)
            
            %% Load Data from Java Object
            po.headingAvg = javaObject(1).getPingId;            
            
            po.pingID = double(javaObject.getPingId());
            po.headingAvg = double(javaObject.getHeadingAvg());
            po.duration = double(javaObject.getDuration());
            po.startTime = char(javaObject.getStartTime());
            po.receiverLatLng = [...
                double(javaObject.getReceiverLat()),...
                double(javaObject.getReceiverLng())...
                ];
            po.sourceLatLng = [...
                double(javaObject.getSourceLat()),...
                double(javaObject.getSourceLng())...
                ];
            
            thisTimeVec = datevec(po.startTime);
            
            jd = datenum(po.startTime) - datenum(2006,0,0,thisTimeVec(4), thisTimeVec(5), thisTimeVec(6));
            po.foraName = sprintf('fora2006jd%dt%s', jd, datestr(thisTimeVec,'HHMMSS'));
            
            trackObj = javaObject.getTracks();
            
            po.trackName = char(trackObj.getName());
            
            config = LUARS_CONFIG;
            po.rawDir = config.pingData;  
            po.updateRange; 
            po.updateUTMcoordinates; 
            po.updateRelativeBearings; 
            po.updateTrueBearings;
            
            %% Set Filenames
            po.rawDataLFName = fullfile('RawData', sprintf('RawPingData.P%05i.LF.mat', po.pingID));
            po.rawDataMFName = fullfile('RawData', sprintf('RawPingData.P%05i.MF.mat', po.pingID));
            po.spectrogramName = fullfile('AvgSpectrumData', sprintf('SpectrogramPingData.P%05i.mat', po.pingID));
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % the following functions are added by DD Tran to update :
        % source-receiver range, rcv
        % and source UTM coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % last changes made: Feb 4th 2013. 
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function po = srcRcvRange(po)
            [xr, yr, zone] = deg2utm(po.receiverLatLng(1), po.receiverLatLng(2)); 
            [xs, ys, zone] = deg2utm(po.sourceLatLng(1), po.sourceLatLng(2)); 
            po.srcRange = ddist([xr yr], [xs ys]); 
        end
        
        function po = updateRange(po)
            for k = 1:length(po)
                po(k).srcRcvRange; 
            end
            
        end
        
        function po = updateUTMcoordinates(po)
            for k = 1:length(po)
                [xr, yr, zone] = deg2utm(po(k).receiverLatLng(1), po(k).receiverLatLng(2)); 
                po(k).rcvUTM = [xr yr]; 
                [xs, ys, zone] = deg2utm(po(k).sourceLatLng(1), po(k).sourceLatLng(2)); 
                po(k).srcUTM = [xs ys]; 
            end
            
        end
        
        
        function po = updateTrueBearings(po)
            for k = 1:length(po)
                 po(k).trueBearing = calBearings(po(k).srcUTM, po(k).rcvUTM);
            end
            
        end
        
        function po = updateRelativeBearings(po)
            for k = 1:length(po)
                trueBearing = calBearings(po(k).srcUTM, po(k).rcvUTM); 
                po(k).relBearing = po(k).headingAvg + sign(180 - po(k).headingAvg)*90 - trueBearing; 
                po(k).relBearing = asind(sind(po(k).relBearing)); %restrict to between -90 and 90 degrees
            end
            
        end
        
        
        
        % end of addition%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        % end of addition by DD Tran %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function ClearData(po)
            po.rawDataLF = [];
            po.rawDataMF = [];
            po.spectrogramData = [];
            po.beamData = [];
        end
        
        function po = LoadData(po, readFreq)
            
            if isempty(dir(fullfile(po.rawDir, po.trackName, 'RawData')))
                mkdir(fullfile(po.rawDir, po.trackName, 'RawData'));
            end
            
            switch(readFreq)
                case 'lf'
                    thisName = fullfile(po.rawDir, po.trackName, po.rawDataLFName);
                    if isempty(dir(thisName))
                        temp = ReadDAT_v2(po.pingID, 'lf');
                        temp = po.FilterData(temp);
                        index = 1:(po.rawFs/po.decimateFs):size(temp,1);
                        temp = temp(index,:)';
                        save(thisName,'temp');
                    else
                        load(thisName)
                    end
                    
                    po.rawDataLF = temp;
                    
                case 'mf'
                    thisName = fullfile(po.rawDir, po.trackName, po.rawDataMFName);
                    if isempty(dir(thisName))
                        temp = ReadDAT_v2(po.pingID, 'mf');
                        temp = po.FilterData(temp);
                        index = 1:(po.rawFs/po.decimateFs):size(temp,1);
                        temp = temp(index,:)';
                        save(thisName,'temp');
                    else
                        load(thisName)
                    end
                    
                    po.rawDataMF = temp;
            end
        end
        
        function po = DisplaySteeredSpectrogram(po, varargin)
            
            p = inputParser;
            
            p.addParamValue('truebearing',nan,@isnumeric);
            p.addParamValue('relbearing',nan,@isnumeric);
            p.addParamValue('parent',nan,@ishandle);
            
            p.parse(varargin{:});
            
            input = p.Results();
            if isnan(input.parent)
                % Create figure
                thisFig = figure('Position', [150 700 1650 300]);
                
                ah = axes('Parent',thisFig,'NextPlot','Add');
            else
                ah = input.parent;
                set(ah,'NextPlot','Add');
            end
            
            if ~isnan(input.truebearing)
                steeringAngle = sind(GetSteeringAngle(po.headingAvg, input.truebearing));            
            end
            
            if ~isnan(input.relbearing)
                steeringAngle = input.relbearing;          
            end
            
            
            S = 0;
            for ss = 1:length(steeringAngle)
                
                beamData = GetSteeredData(po.rawDataLF, 1.5, steeringAngle(ss), 2000);
                
                S = spectrogram(...
                    beamData,...
                    128,...
                    64,...
                    8192,...
                    po.decimateFs);
                
                S = S + abs(S*0.5).^2;
            end
            
            po.beamData = beamData;
            S = S/length(steeringAngle);
            
            imagesc([0 po.duration], [0 2000], 10*log10(abs(S)), 'Parent', ah)
            
            set(ah, 'YDir', 'Normal')
            colorbar('peer', ah)
            caxis(ah, [80 120])
            
            
            
            
            
            
            whaleObjects = WhaleObjectQuery('ping',po.pingID);
            
            for ii = 1:length(whaleObjects)
                tStart = double(whaleObjects(ii).getTimeStart());
                tStop = double(whaleObjects(ii).getTimeStop());
                fStart = double(whaleObjects(ii).getFreqStart());
                fStop = double(whaleObjects(ii).getFreqStop());
                
                xData = [tStart tStart tStop tStop tStart];
                yData = [fStart fStop fStop fStart fStart];
                
                plot(ah,xData, yData, 'w','Linewidth',1);
                text(xData(3), yData(1), num2str(double(whaleObjects(ii).getWhaleId)),...
                    'Color', 'w',...
                    'HorizontalAlignment', 'Right',...
                    'VerticalAlignment', 'Bottom',...
                    'FontSize',8,...
                    'Parent',ah(1));
            end
            
            xlim(ah,[0 po.duration])
            ylim(ah,[0 po.decimateFs/2])
            titleString = {...
                sprintf('Ping ID: %g', po.pingID)
                };
            title(ah, titleString);
            
        end
        
        function po = DisplaySpectrogram(po, ah)
            
            if nargin < 2
                % Create figure
                thisFig = figure('Position', [150 700 1650 300]);
                
                ah = axes('Parent',thisFig,'NextPlot','Add');
            end
            
            imagesc([0 po.duration], [0 1000], 10*log10(abs(po.spectrogramData)),...
                'Parent',ah)
            
            %             xlim(po.freqBounds)
            
            colorbar
            caxis([90 110])
            
            
            
            axis xy
            
            
            whaleObjects = WhaleObjectQuery('ping',po.pingID);
            
            for ii = 1:length(whaleObjects)
                tStart = double(whaleObjects(ii).getTimeStart());
                tStop = double(whaleObjects(ii).getTimeStop());
                fStart = double(whaleObjects(ii).getFreqStart());
                fStop = double(whaleObjects(ii).getFreqStop());
                
                xData = [tStart tStart tStop tStop tStart];
                yData = [fStart fStop fStop fStart fStart];
                
                plot(ah,xData, yData, 'w','Linewidth',1);
                text(xData(3), yData(1), num2str(double(whaleObjects(ii).getWhaleId)),...
                    'Color', 'w',...
                    'HorizontalAlignment', 'Right',...
                    'VerticalAlignment', 'Bottom',...
                    'FontSize',8,...
                    'Parent',ah(1));
            end
            
            xlim([0 po.duration])
            ylim([0 po.decimateFs/2])
        end
        
        function BeamformWhales(po)
            
            whaleTrackDir = fullfile('/Volumes/Alpha/WhaleData', po.trackName);
            
            if isempty(dir(whaleTrackDir))
                mkdir(fullfile(whaleTrackDir));
            end
            
            whales = WhaleObjectQuery(...
                'ping', po.pingID,...
                'frequency',[0 900]);
            
            
            
            for ii = 1:length(whales)
                ii
                thisFilename = fullfile(...
                    whaleTrackDir,...
                    sprintf('%05g_WhaleData.mat', double(whales(ii).getWhaleId)));
                
                if isempty(dir(thisFilename))
                    
                    %% Isolate Whale Call in time with some additional buffer
                    bufferSeconds = 0.5;
                    whaleData.timeBounds = [...
                        max([double(whales(ii).getTimeStart)-bufferSeconds, 0]),...
                        min([double(whales(ii).getTimeStop)+bufferSeconds, po.duration])...
                        ];
                    
                    iWhaleSamples = round(...
                        whaleData.timeBounds(1) * po.decimateFs)+1 : round(whaleData.timeBounds(2) * po.decimateFs);
                    
                    %                     %% Create Filter
                    %                     numCoeff = GenBPFilt(...
                    %                         double(whales(ii).getFreqStart),...
                    %                         double(whales(ii).getFreqStop),...
                    %                         po.decimateFs);
                    
                    if double(whales(ii).getFreqStop) < 500
                        temp = po.rawDataLF(:,iWhaleSamples);
                        %                         temp = filter(numCoeff,1,temp,[],2);
                        sensorSpacing = 1.5;
                    else
                        temp = po.rawDataMF(:,iWhaleSamples);
                        %                         temp = filter(numCoeff,1,temp,[],2);
                        sensorSpacing = 0.75;
                    end
                    
                    whaleData.beamTimeImage = DelaySumBeamformer_v02(...
                        temp,...
                        double(whales(ii).getFreqCenter),...
                        double(whales(ii).getFreqStop) - double(whales(ii).getFreqStart),...
                        sensorSpacing,...
                        po.decimateFs);
                    
                    %                     whaleData.beamTimeImage = DelaySumBeamformer(...
                    %                         temp,...
                    %                         sensorSpacing,...
                    %                         po.decimateFs);
                    
                    save(thisFilename,'whaleData')
                    
                end
                
                %                 keyboard
            end
        end
        
        function Spectrogram(po)
            if isempty(dir(fullfile(po.rawDir, po.trackName, 'AvgSpectrumData')))
                mkdir(fullfile(po.rawDir, po.trackName, 'AvgSpectrumData'));
            end
            
            thisFilename = fullfile(...
                po.rawDir,....
                po.trackName,...
                po.spectrogramName);
            
            if isempty(dir(thisFilename))
                overlap = 0.5;
                windowSize = 128;
                overlapSize = overlap * windowSize;
                
                temp = 0;
                for ii = 1:64
                    ii
                    S = spectrogram(...
                        po.rawDataLF(ii,:),...
                        windowSize,...
                        overlapSize,...
                        8192,...
                        po.decimateFs);
                    
                    temp = temp + abs(S*(1-overlap)).^2;
                    
                end
                
                temp = temp/64;
                
                save(thisFilename, 'temp')
            else
                load(thisFilename)
            end
            po.spectrogramData = temp;
        end
        
        function data = FilterData(po, data)
            % All frequency values are in Hz.
            
            Fpass = po.decimateFs/2 - 20;             % Passband Frequency
            Fstop = po.decimateFs/2;            % Stopband Frequency
            Dpass = 0.057501127785;  % Passband Ripple
            Dstop = 0.0001;          % Stopband Attenuation
            dens  = 20;              % Density Factor
            
            % Calculate the order from the parameters using FIRPMORD.
            [N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(po.rawFs/2), [1 0], [Dpass, Dstop]);
            
            % Calculate the coefficients using the FIRPM function.
            b  = firpm(N, Fo, Ao, W, {dens});
            
            
            data = filter(b,1,data,[],1);
        end
    end
end

