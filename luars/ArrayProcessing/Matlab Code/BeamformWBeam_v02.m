%% BeamformWBeam_v02
% BeamformWBeam_v02(inputs) returns a ...
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
function beamDataTD = BeamformWBeam_v02(...
    signalDataTD,...
    freqCenterHz,...
    freqBandHz,...
    sensorSpacingMeters,...
    doaEstimate,...
    window)

if nargin < 6
    window = 'hanning';
end

%% Some Constants
freqSamplingHz = 8000;
nSensors = size(signalDataTD,1);
cVelocity = 1500;
nSignalDataSamples = size(signalDataTD,2);

%% Filter to Specific Band
nSignalDataFrequencies = nSignalDataSamples;
dSignalDataFrequencies = freqSamplingHz/nSignalDataFrequencies;

signalDataFD = fft(signalDataTD,[],2);

frequencyBounds = [freqCenterHz-freqBandHz/2 freqCenterHz+freqBandHz/2];
signalFrequencyBounds = round(frequencyBounds/dSignalDataFrequencies);

% Find frequency samples to remove
iBandStopSignalFrequencies = [1:signalFrequencyBounds(1)-1 , signalFrequencyBounds(2)+1:nSignalDataFrequencies];

% Set frequencies to zero
signalDataFD(:,iBandStopSignalFrequencies) = 0;

% Sensor Index
iSensors = -((0:(nSensors-1)) - (nSensors-1)/2)';
iSignalDataFrequencies = 0:nSignalDataFrequencies-1;

if strncmpi(window, 'hann',4)
    window1 = hann(nSensors);
    window1 = window1/sum(window1);
else
    window1 = ones(nSensors, 1);
    window1 = window1/sum(window1);
end

% Create new delay matrix from new steering angle
delay = 2*pi*iSensors*iSignalDataFrequencies*(freqSamplingHz * sensorSpacingMeters/(nSignalDataFrequencies*cVelocity))*doaEstimate;
delay_matrix = exp(-1j*delay);

shiftDataFD = signalDataFD.*delay_matrix;

shiftDataTD = ifft(shiftDataFD,[],2);

beamDataTD = window1' * shiftDataTD;







