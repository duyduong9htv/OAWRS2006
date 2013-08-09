%% DelaySumBeamformer_v02 
% DelaySumBeamformer_v02(inputs) returns a ...
%
% Inputs:
%
% * input1- a ... 
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
%   Date: 20Sep2011
%%
function beamDataTD = DelaySumBeamformer_v02(...
    signalDataTD,...
    freqCenterHz,...
    freqBandHz,...
    sensorSpacingMeters,...
    freqSamplingHz,...
    window)

if nargin < 6
    window = 'hanning';
end

%% Some Constants
nSteeringAngles = 400;
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

% Index of Steering angles(i.e. range of sin(theta))
iSteeringAngles = linspace(-1, 1, nSteeringAngles);

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

beamDataTD = zeros(nSteeringAngles,nSignalDataSamples);

% Create Status Icon in window
ps = ProcessStatus('Beamforming');
for ii = 1:nSteeringAngles
    
    % Update Status
    ps.update(ii/nSteeringAngles);
    
    % Create new delay matrix from new steering angle
    delay = 2*pi*iSensors*iSignalDataFrequencies*(freqSamplingHz * sensorSpacingMeters/(nSignalDataFrequencies*cVelocity))*iSteeringAngles(ii);   
    delay_matrix = exp(-1j*delay);  
    
    
    shiftDataFD = signalDataFD.*delay_matrix;
    
    
    shiftDataTD = ifft(shiftDataFD,[],2);
    
    
    beamDataTD(ii,:) = window1' * shiftDataTD;
    
end

% ps.close;

% % matlabpool
% parfor ii = 1:nSteeringAngles
% %     disp(ii);
%     %     % Create new delay matrix from new steering angle
%     delay = 2*pi*iSensors*iSignalDataFrequencies*(freqSamplingHz * sensorSpacingMeters/(nSignalDataFrequencies*cVelocity))*iSteeringAngles(ii);   
%     delay_matrix = exp(-1j*delay);  
%     
%     
%     shiftDataFD = signalDataFD.*delay_matrix;
%     
%     
%     shiftDataTD = ifft(shiftDataFD,[],2);
%     
%     
%     beamDataTD(ii,:) = window1' * shiftDataTD;
% end