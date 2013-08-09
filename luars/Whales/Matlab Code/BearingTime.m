classdef BearingTime < handle
    % Handles many operations involved with whale vocalizations in the
    % bearing-time domain.
    % 1.) Break Ambiguity
    % 2.) Group Vocalizations
    
    properties
        isAmbiguityVisible = false;
        timeRange;
        whales;
        
        whaleTimes;
        headings;
        bearings;
        
        timeOffset;  % Used for plotting.  Matlab (in mac) of plotting the high numbers found in datenum.
        
        areAmbiguitiesVisible;
        areRegionsVisible;
        areHeadingsVisible;
        areTrackMarkersVisible;
        isSelected;
        isTrue;
        
        % Plotting
        fh;
        ah;
        plotTimes;
        bearingHandles;
        headingHandles;
    end
    
    methods
        % Constructor
        function bth = BearingTime(month, day)
            % Inputs:
            %   month- integer of month
            %   day- integer of day
            
            %% Determine Range
            % Recording stopped at the latest at 2am EDT, which is 6am GMT.  So add 6
            % hours to get contiguous recording regions.
            bth.timeRange = [datenum(2006,month,day) datenum(2006,month,day+1)] + datenum(0,0,0,6,0,0);
            
            % Before Plotting, subtract this from times to fix plotting bug.  Since the
            % year 0000 was a leap year and 2006 is not and we are after Febuary 29, we
            % add 1 more day on to get days and months the same in 0000.
            minTime = datenum(2006,00,00) - 1;
            
            % Subtract before plotting for GMT to EDT conversion.
            edtConv = datenum(00,00,00,04,00,00);
            
            bth.timeOffset = edtConv + minTime;
            
        end
        
        function getWhales(bth)
            
            if isempty(bth.whales)
                startDateStr = datestr(bth.timeRange(1), 'yyyy-mm-dd HH:MM:SS');
                stopDateStr = datestr(bth.timeRange(2), 'yyyy-mm-dd HH:MM:SS');
                
                bth.whales = WhaleObjectQuery(...
                    'datetime',{startDateStr stopDateStr},...
                    'frequency',[300 700],...
                    'relativebearing',[-1 1]);
                
                bth.whaleTimes = zeros(1,length(bth.whales));
                bth.bearings = zeros(2,length(bth.whales));
                bth.headings = zeros(1,length(bth.whales));
                bth.isTrue = zeros(1, length(bth.whales));
                
                for ii = 1:length(bth.whales)
                    thisPing = bth.whales(ii).getPings;
                    % Start of whale call is ping start + whale start
                    bth.whaleTimes(ii) = datenum(char(bth.whales(ii).getDatetime));
                    
                    % Array Heading
                    bth.headings(ii) = mod(thisPing.getHeadingAvg(), 360);
                    %                     bth.headings(ii) = mod(double(bth.whales(ii).getArrayHeading()), 360);
                    
                    % Find two ambiguous bearings from relative bearing.
                    whaleBearing = asind(double(bth.whales(ii).getRelativeBeamCdsb()));
                    bth.bearings(:,ii) = GetTrueBearingsFromRelative(bth.headings(ii), whaleBearing);
                    
                    thisTrue = double(bth.whales(ii).getTrueBearing);
                    if ~isempty(thisTrue)
                        trueIndex = find(abs(bth.bearings(:,ii) - thisTrue) < 1e-6, 1);
                        
                        if double(bth.whales(ii).getWhaleId) == 7602
%                             keyboard
                        end
                        
                        if ~isempty(trueIndex)
                            bth.isTrue(ii) = trueIndex;
                        end
                    end
                end
            end
        end
        
        function createPlotVectors(bth)
            % Using the whale objects, create vectors used for plotting.
            if ~isempty(bth.whales)
                % Create empty arrays to store values
                
                bth.plotTimes = zeros(1,length(bth.whales));
                bth.isSelected = zeros(1, length(bth.whales));
                bth.bearingHandles = zeros(2, length(bth.whales));
                bth.plotTimes = bth.whaleTimes - bth.timeOffset;
                
                for ii = 1:length(bth.whales)
                    userData.index = ii;
                    userData.selected = false;
                    
                    bth.bearingHandles(1, ii) = line(...
                        'XData', bth.plotTimes(ii),...
                        'YData', bth.bearings(1, ii),...
                        'MarkerFaceColor',[136 255 0]/255,...
                        'MarkerEdgeColor', 'none',...
                        'Marker','o',...
                        'Linestyle', 'none',...
                        'MarkerSize', 4,...
                        'Parent', bth.ah,...
                        'DisplayName', 'Side1',...
                        'UserData', userData,...
                        'ButtonDownFcn', @ptSelected,...
                        'Visible', 'Off');
                    
                    bth.bearingHandles(2, ii) = line(...
                        'XData', bth.plotTimes(ii),...
                        'YData', bth.bearings(2, ii),...
                        'MarkerFaceColor',[255 136 0]/255,...
                        'MarkerEdgeColor', 'none',...
                        'Marker','o',...
                        'Linestyle', 'none',...
                        'MarkerSize', 4,...
                        'Parent', bth.ah,...
                        'DisplayName', 'Side2',...
                        'UserData', userData,...
                        'ButtonDownFcn', @ptSelected,...
                        'Visible', 'Off');
                end
                
                bth.headingHandles = line(...
                    'XData', bth.plotTimes,...
                    'YData', bth.headings,...
                    'Marker','^',...
                    'Linestyle', 'none',...
                    'MarkerSize', 5,...
                    'MarkerEdgeColor',[60 192 239]/255,...
                    'DisplayName', 'Headings',...
                    'Visible','Off');
            end
            function ptSelected(src,evnt)
                % src - the object that is the source of the event
                % evnt - empty for this property
                
                bData = get(src,'UserData');
                bData.selected = not(bData.selected);
                
                if bData.selected
                    set(bth.bearingHandles(:, bData.index), 'MarkerSize', 10);
                    bth.whales(bData.index).getWhaleId
                else
                    set(bth.bearingHandles(:, bData.index), 'MarkerSize', 4);
                end
                
                set(bth.bearingHandles(:, bData.index), 'UserData', bData);
            end
        end
        
        function plotRegions(bth)
            % Find Angles to regions from receiver position in this date range
            angles = GetGOMAngles(bth.timeRange);
            
            % Subtract plotting time conversion
            xLimits = dateRange - totalConv;
            
            ph(1) = patch(...
                'XData',[xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)],...
                'YData',[angles.swbAng(1) angles.swbAng(2) angles.swbAng(2) angles.swbAng(1) angles.swbAng(1)],...
                'FaceColor',[1 0.5 0.5]*.8,...
                'LineStyle','none',...
                'FaceAlpha',0.3,...
                'DisplayName','Stellwagen Bank');
            ph(2) = patch(...
                'XData',[xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)],...
                'YData',[angles.gscAng(1) angles.gscAng(2) angles.gscAng(2) angles.gscAng(1) angles.gscAng(1)],...
                'FaceColor',[1 0.5 0.5]*.5,...
                'LineStyle','none',...
                'FaceAlpha',0.3,...
                'DisplayName','Great South Channel');
            ph(3) = patch(...
                'XData',[xLimits(1) xLimits(1) xLimits(2) xLimits(2) xLimits(1)],...
                'YData',[angles.nefAng(1) angles.nefAng(2) angles.nefAng(2) angles.nefAng(1) angles.nefAng(1)],...
                'FaceColor',[1 0.5 0.5]*.2,...
                'LineStyle','none',...
                'FaceAlpha',0.3,...
                'DisplayName','Northeast Flank');
            
        end
        
        function plotHeadings(bth)
            set(bth.headingHandles,...
                'Visible', 'On')
        end
        
        function plotBearings(bth)
            set(bth.bearingHandles,...
                'Visible','On');
        end
        
        function PlotTrue(bth)
            % Plot both true and ambiguos arrival estimates
            bth.getWhales();
            
            bth.SetupFigure(datestr(bth.timeRange(1), 'mmm dd, yyyy'));
            bth.createPlotVectors();
            set(bth.fh,...
                'KeyPressFcn', @ReturnWhales);
            
            
            
            set(bth.bearingHandles(1,bth.isTrue == 1),...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', [1 1 1]*0.5,...
            'Visible','On');
        
            set(bth.bearingHandles(2,bth.isTrue == 2),...
            'MarkerEdgeColor', 'k',...
            'MarkerFaceColor', [1 1 1]*0.5,...
            'Visible','On');
        
            datetick('x','HH:MM','keeplimits','keepticks')
            
            xlabel('Time (EDT)')
            ylabel('True Bearing')
        end
        
        function markTrueBearings(bth)
            set(bth.bearingHandles(1,bth.isTrue == 1), 'MarkerEdgeColor', 'k');
            set(bth.bearingHandles(2,bth.isTrue == 2), 'MarkerEdgeColor', 'k');
        end
        
        function GetWhales(bth)
            % Plot both true and ambiguos arrival estimates
            bth.getWhales();
            
            bth.SetupFigure('Get Whales');
            bth.createPlotVectors();
            set(bth.fh,...
                'KeyPressFcn', @ReturnWhales);
            
            bth.plotHeadings();
            bth.plotBearings();
            
            function ReturnWhales(src,evnt)
                % src - the object that is the source of the event
                % evnt - empty for this property
                
                if strcmp(evnt.Modifier{1}, '') && strcmp(evnt.Character, 'b')
                    disp('Select Points.  Double-click to stop')
                    [xVertices, yVertices] = getline(bth.fh, 'closed');
                    
                    xPts = bth.plotTimes;
                    yPts1 = bth.bearings(1,:);
                    yPts2 = bth.bearings(2,:);
                    
                    
                    inIndex1 = find(inpolygon(xPts, yPts1, xVertices, yVertices) == 1);
                    inIndex2 = find(inpolygon(xPts, yPts2, xVertices, yVertices) == 1);
                    
                    set(bth.bearingHandles(1, inIndex1),'MarkerFaceColor','r')
                    set(bth.bearingHandles(2, inIndex2),'MarkerFaceColor','r')
                    
                    outWhales = [bth.whales(inIndex1) bth.whales(inIndex2)];
                    
                    save('outWhales','outWhales')
                end
            end
            
        end
        
        function BreakAmbiguity(bth)
            % Plot both true and ambiguos arrival estimates
            bth.getWhales();
            
            bth.SetupFigure('Breaking Ambiguity');
            bth.createPlotVectors();
            set(bth.fh,...
                'KeyPressFcn', @BreakAmb);
            
            bth.plotHeadings();
            bth.plotBearings();
            
            function BreakAmb(src,evnt)
                % src - the object that is the source of the event
                % evnt - empty for this property
                
                session = luars.util.HibernateUtil.getSessionFactory().openSession();
                session.beginTransaction();
                
                if strcmp(evnt.Modifier{1}, 'control') && strcmp(evnt.Key, 'b')
                    disp('Select Points.  Double-click to stop')
                    [xVertices, yVertices] = getline(bth.fh, 'closed');
                    
                    xPts = bth.plotTimes;
                    yPts1 = bth.bearings(1,:);
                    yPts2 = bth.bearings(2,:);
                    
                    
                    inIndex1 = find(inpolygon(xPts, yPts1, xVertices, yVertices) == 1);
                    inIndex2 = find(inpolygon(xPts, yPts2, xVertices, yVertices) == 1);
                    
                    set(bth.bearingHandles(1, inIndex1),'MarkerFaceColor','r')
                    set(bth.bearingHandles(2, inIndex2),'MarkerFaceColor','r')
                    
                    for ii = 1:length(inIndex1)
                        bth.whales(inIndex1(ii)).setTrueBearing(java.lang.Double(bth.bearings(1, inIndex1(ii))));
                        session.update(bth.whales(inIndex1(ii)));
                        fprintf('Update WhaleID: %g\n', double(bth.whales(inIndex1(ii)).getWhaleId));
                    end
                    
                    for jj = 1:length(inIndex2)
                        bth.whales(inIndex2(jj)).setTrueBearing(java.lang.Double(bth.bearings(2, inIndex2(jj))));
                        session.update(bth.whales(inIndex2(jj)));
                        fprintf('Update WhaleID: %g\n', double(bth.whales(inIndex2(jj)).getWhaleId));
                    end
                    
                    session.getTransaction().commit();
                    session.close();
                end
            end
        end
        
        function SetupFigure(bth, titleString)
            % Setup Figure and Axes
            bth.fh = figure('Visible','Off');
            bth.ah = axes(...
                'Parent', bth.fh,...
                'YDir', 'reverse',...
                'YLim', [0 360]);
            
            title(...
                titleString,...
                'Interpreter', 'None',...
                'Parent', bth.ah...
                );
            
            set(bth.fh, 'Visible', 'On');
            
            %             datetick('x','ddmmm HH:MM', 'keepticks', 'keeplimits');
            FigureSize(bth.fh, 'custom',[1230 670])
            PrepFiguresForPPT(bth.fh, 18)
        end
    end
end


