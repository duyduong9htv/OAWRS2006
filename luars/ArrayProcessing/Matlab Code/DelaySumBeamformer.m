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
function beamDataTD = DelaySumBeamformer(...
    signalDataTD,...    
    sensorSpacingMeters,...
    freqSamplingHz,...
    window)

if nargin < 4
    window = 'hanning';
end

%% Some Constants
nSteeringAngles = 800;
nSensors = size(signalDataTD,1);
cVelocity = 1500;
nSignalDataSamples = size(signalDataTD,2);
nSignalDataFrequencies = round(1.2*nSignalDataSamples);

% FFT along second dimension
signalDataFD = fft(signalDataTD,nSignalDataFrequencies,2);

% Index of Steering angles(i.e. range of sin(theta))
iSteeringAngles = linspace(-1, 1, nSteeringAngles);

% Sensor Index
iSensors = -((0:(nSensors-1)) - (nSensors-1)/2)';
iSignalDataFrequencies = 0:nSignalDataFrequencies-1;

if strncmpi(window, 'han2',4)
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
    
%     delay_matrix2 = exp(1j*delay);
    
    shiftDataFD = signalDataFD.*delay_matrix;
    
%     shiftDataFD = shiftDataFD + signalDataFD.*delay_matrix2;
    
    
    shiftDataTD = ifft(shiftDataFD,nSignalDataSamples,2);
    
    
    beamDataTD(ii,:) = window1' * shiftDataTD;    
    
end

