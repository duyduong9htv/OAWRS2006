classdef WhaleObject < handle
    %WhaleObject Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        whaleID;
        arrayHeading;
        relativeBearing;
        trueBearing;
        dateTime;
        timeBounds;
        freqBounds;
        duration;
        lastUpdate;
        pingID;
        trackName;
        groupID;
        pingHeading;
        f0;
        f1;
        tStart_2;
        duration_2;
        
        % Data
        beamData;        
        rawData;
        beamTimeImage;        
                
        dataTimeBounds;
        
        dataFilename;
        beamImageFilename;
        
               
        rawDir;
        
        beamTimeAxes;
        spectrogramAxes;
    end
    
    methods
        
        function wo = WhaleObject(javaObject)
            wo.whaleID = double(javaObject.getWhaleId());
            wo.arrayHeading = double(javaObject.getArrayHeading());
            wo.relativeBearing = double(javaObject.getRelativeBeamCdsb());
            wo.trueBearing = double(javaObject.getTrueBearing());
            wo.dateTime = char(javaObject.getDatetime());
            wo.timeBounds = [double(javaObject.getTimeStart()) double(javaObject.getTimeStop())];
            wo.freqBounds = [double(javaObject.getFreqStart()) double(javaObject.getFreqStop())];
            wo.duration = double(javaObject.getTimeStop) - double(javaObject.getTimeStart());
            wo.lastUpdate = char(javaObject.getLastUpdated());
            
            wo.f0 = double(javaObject.getF0MLE);
            wo.f1 = double(javaObject.getF1MLE);
            wo.tStart_2 = double(javaObject.getTimeStartMLE);
            wo.duration_2 = double(javaObject.getDurationMLE);
            
            pingObj = javaObject.getPings();
            trackObj = pingObj.getTracks();
            groupObj = javaObject.getWhaleGroups();
            
            wo.pingID = double(pingObj.getPingId);
            wo.trackName = char(trackObj.getName);
            
            wo.pingHeading = double(pingObj.getHeadingAvg);
            
            if isempty(groupObj)
                wo.groupID = [];
            else
                wo.groupID = double(groupObj.getGroupId);
            end
            
            config = LUARS_CONFIG;
            wo.rawDir = config.whaleData;            
            
            wo.dataFilename = sprintf('W%05i.data.mat', wo.whaleID);
            wo.beamImageFilename = sprintf('W%05i.beamImage.mat', wo.whaleID);
        end
        
        function ClearData(wo)
            wo.beamTimeImage = [];
            wo.rawData = [];
        end
        
        function wo = LoadData(wo)
            if isempty(dir(fullfile(wo.rawDir, wo.trackName)))
                mkdir(fullfile(wo.rawDir, wo.trackName));
            end
            
            
            thisFilename = fullfile(...
                wo.rawDir,...
                wo.trackName,...
                wo.dataFilename);
            if isempty(dir(thisFilename))
                po = PingQuery('id', wo.pingID);
                
                %% Isolate Whale Call in time with some additional buffer
                bufferSeconds = 0.5;
                rawSave.timeBounds = [...
                    max([wo.timeBounds(1)-bufferSeconds, 0]),...
                    min([wo.timeBounds(2)+bufferSeconds, po.duration])...
                    ];
                
                iWhaleSamples = round(...
                    rawSave.timeBounds(1) * po.decimateFs)+1 : round(rawSave.timeBounds(2) * po.decimateFs);
                
                if double(wo.freqBounds(2)) < 500
                    po.LoadData('lf');
                    rawSave.rawData = po.rawDataLF(:,iWhaleSamples);
                    %                     temp = filter(numCoeff,1,temp,[],2);
                    sensorSpacing = 1.5;
                    if ~isempty(wo.relativeBearing)
                        rawSave.beamData = GetSteeredData(rawSave.rawData, sensorSpacing, wo.relativeBearing, po.decimateFs);
                    else
                        rawSave.beamData = [];
                    end
                else
                    po.LoadData('mf');
                    rawSave.rawData = po.rawDataMF(:,iWhaleSamples);
                    %                     temp = filter(numCoeff,1,temp,[],2);
                    sensorSpacing = 0.75;
                    if ~isempty(wo.relativeBearing)
                        rawSave.beamData = GetSteeredData(rawSave.rawData, sensorSpacing, wo.relativeBearing, po.decimateFs);
                    else
                        rawSave.beamData = [];
                    end                    
                end              
                
                save(thisFilename,'rawSave')
            else
                load(thisFilename)
            end
            
            wo.dataTimeBounds = rawSave.timeBounds;
            wo.beamData = rawSave.beamData;
            wo.rawData = rawSave.rawData;         
        end
        
        function LoadBeamImage(wo)
            if isempty(dir(fullfile(wo.rawDir, wo.trackName)))
                mkdir(fullfile(wo.rawDir, wo.trackName));
            end
            
            
            thisFilename = fullfile(...
                wo.rawDir,...
                wo.trackName,...
                wo.beamImageFilename);
            
            if isempty(dir(thisFilename))
                
                wo.LoadData();    
                
                beamSave.beamTimeImage = DelaySumBeamformer_v02(...
                    wo.rawData,...
                    sum(wo.freqBounds)/2,...
                    diff(wo.freqBounds),...
                    sensorSpacing,...
                    po.decimateFs);
                
                beamSave.timeBounds = wo.dataTimeBounds;
                
                save(thisFilename,'beamSave')
            else
                load(thisFilename)
            end
            
            wo.dataTimeBounds = beamSave.timeBounds;
            wo.beamTimeImage = beamSave.beamTimeImage;          
        end
        
        function DisplayBeamTime(wo, ah)
            if isempty(wo.beamTimeImage)
                wo.LoadBeamImage;
            end
            
            if nargin < 2
                fh = figure;
                wo.beamTimeAxes = axes(...
                    'Parent', fh,...
                    'NextPlot', 'Add',...
                    'Box', 'On',...
                    'Linewidth', 2);
                
                PrepFiguresForPPT(gcf,15);
                
                xlim([-1 1]);
                ylim(wo.beamTimeBounds);
                
                ah = wo.beamTimeAxes;
            else
                wo.beamTimeAxes = ah;
            end
            
            cla(ah);
            if isempty(wo.spectrogramAxes)
                bdf = [];
            else
                bdf = @test;
            end
            
            imagesc([-1 1],wo.beamTimeBounds,10*log10(abs(wo.beamTimeImage)'),...
                'Parent', ah,...
                'ButtonDownFcn', bdf);
            
            if ~isempty(wo.relativeBearing)
                relBounds(1) = wo.relativeBearing-.1;
                relBounds(2) = wo.relativeBearing+.1;
                
                xData = [relBounds(1) relBounds(2) relBounds(2) relBounds(1) relBounds(1)];
                yData = [wo.timeBounds(1) wo.timeBounds(1) wo.timeBounds(2) wo.timeBounds(2) wo.timeBounds(1)];
                plot(ah, xData, yData,'k','Linewidth',2)
            end
            
            function test(a,b)
                
                if strcmp(get(gcf,'SelectionType'), 'extend')
                    wo.UpdateWhaleBearing;
                else
                    
                    curPt = get(wo.beamTimeAxes, 'CurrentPoint');
                    
                    doaEstimate = curPt(1,1);
                    
                    index = ceil(doaEstimate*(399/2) + 200.5);
                    
                    beamDataTemp = wo.beamTimeImage(index,:);
                    
                    S = spectrogram(beamDataTemp,128,64,8192,2000);
                    
                    cla(wo.spectrogramAxes);
                    
                    imagesc([0 2000], wo.beamTimeBounds, 10*log10(abs(S)'),...
                        'Parent', wo.spectrogramAxes);
                end
            end
            
            %             caxis([25 40])
        end
        
        function DisplaySpectrogram(wo, ah)
            
            if isempty(wo.beamTimeImage)
                wo.LoadData;
            end
            
            if nargin < 2
                fh = figure;
                wo.spectrogramAxes = axes(...
                    'Parent', fh,...
                    'NextPlot', 'Add',...
                    'Box', 'On',...
                    'Linewidth', 2);
                
                PrepFiguresForPPT(gcf,15);
                
                xlim(wo.freqBounds);
                ylim(wo.beamTimeBounds);
                
                ah = wo.spectrogramAxes;
            else
                wo.spectrogramAxes = ah;
            end
            
            cla(ah);
            
            if ~isempty(wo.relativeBearing)
                
                index = ceil(wo.relativeBearing*(399/2) + 200.5);
                
                beamDataTemp = wo.beamTimeImage(index,:);
                
                S = spectrogram(beamDataTemp,128,64,8192,2000);
                
            else
                S = 0;
            end
            
            imagesc([0 2000], wo.beamTimeBounds, 10*log10(abs(S)'),...
                'Parent', ah);
            
            %             colorbar
            caxis([40 65])           
        end
        
        function UpdateWhaleBearing(wo)
            
            yLimits = ylim(wo.beamTimeAxes);
            xLimits = xlim(wo.beamTimeAxes);
            
            A = getrect(wo.beamTimeAxes);
            
            xIndex = ceil([A(1) A(1)+A(3)]*(399/2) + 200.5);
            xIndex = [max([1 xIndex(1)]) min([size(wo.beamTimeImage,1) xIndex(2)])];
            
            yIndex = ceil([A(2) A(2)+A(4)]*2000 + 1 - yLimits(1)*2000);
            yIndex = [max([1 yIndex(1)]) min([size(wo.beamTimeImage,2) yIndex(2)])];
            
            % BeamTimeImage is 400xN
            temp1 = abs(wo.beamTimeImage(xIndex(1):xIndex(2),yIndex(1):yIndex(2)));
            temp1 = mean(temp1,2);
            index = find(temp1 == max(temp1));
            
            index = index + xIndex(1) -1;
            
            doaEstimate = 2/399 * (index - 200.5);
            
            %% Start Hibernate Session
            session = luars.util.HibernateUtil.getSessionFactory().openSession();
            session.beginTransaction();
            
            %% Get Whale Object by ID
            whaleQuery = Queries.WhaleQuery();
            whaleQuery.byID(wo.whaleID);
            whaleObj = whaleQuery.getWhales();
            whaleObj = whaleObj.get(0);
            
            %% Set Whale Object Whale Bearing
            whaleObj.setRelativeBeamCdsb(java.lang.Double(doaEstimate));
            
            session.update(whaleObj);

            session.getTransaction().commit();
            session.close();      
            
            fprintf('Updated Whale %d with beam of %d\n', wo.whaleID, doaEstimate)
            
            %% Plot Line to Show Sent Beam
            line(...
                'XData',[doaEstimate doaEstimate],...
                'YData',ylim(wo.beamTimeAxes),...
                'Color','m',...
                'Parent',wo.beamTimeAxes,...
                'HitTest','Off');
            
            %             keyboard
        end
        
    end
end

