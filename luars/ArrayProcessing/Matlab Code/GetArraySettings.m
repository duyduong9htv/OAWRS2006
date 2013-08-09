%% Get FORA Aperture settings.
%
% [sensorSpacing, readFreq] = GetArraySettings(frequency) Gets the
% appropriate sensor spacing in meters and frequency string used in
% ReadDAT_v2.
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 12Feb2012
%   Modified: 12Feb2012
%
% See also ReadDAT_v2
function [sensorSpacing, readFreq] = GetArraySettings(frequency)

if frequency < 500
    readFreq = 'lf';
    sensorSpacing = 1.5;
elseif frequency >= 500 && frequency < 1000
    readFreq = 'mf';
    sensorSpacing = 0.75;
elseif frequency >= 1000 && frequency <= 2000
    readFreq = 'hf';
    sensorSpacing = 0.375;
elseif frequency > 2000
    disp('Above Nyquist')
    sensorSpacing = [];
    readFreq = [];
end