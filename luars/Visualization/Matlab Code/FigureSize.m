%% Change Size of Figure
%
% FigureSize(figureHandle, size) saves the figure with size
% specified by:
%       'default'   - saves figure at default size of 560 x 420
%       'medium'    - saves figure at 616 x 462
%       'large'     - saves figure at 728 x 546
%       'xlarge'    - saves figure at 840 x 630
%
% FigureSize(figureHandle, 'custom', param) saves the figure with size
% specified by the 2 element param vector.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Date: 19Jan2012
%   Modified: 20Jan2012
%
% See also SaveFigToJPG, SaveFigToPNG
function FigureSize(fh,size,param)

% This is the default size for a figure
figSize = [560 420];

switch lower(size)
    case 'default'
        figSize = figSize;
    case 'medium'
        figSize = 1.1*figSize;
    case 'large'
        figSize = 1.3*figSize;
    case 'xlarge'
        figSize = 1.5*figSize;
    case 'custom'
        figSize = param;
end

% Get current figure position, which includes size
figPosition = get(fh,'Position');
set(gcf,'Position',[figPosition(1:2) figSize]);





