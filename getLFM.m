%getLFM gets an LFM waveform with Tukey window both in time domain and frequency domain
%Outputs are normalized so that the Parseval sum is 1 for both time and frequency domain.
%function is used by:
%
%function [st1, Sf1, rst1, rSf1] = getLFM(f_samp, t_0, t_p, T, f_i, f_f)
%input parameters:  f_samp - sampling frequency of signal
%                   t_0 - starting time of LFM signal
%                   t_p - duration of LFM ping
%                   T - duration of time signal (zero padding used)
%                   f_i - initial frequency
%                   f_f - final frequency
%output parameters: st1 - normalized complex time signal
%                   Sf1 - ifft of complex time signal
%                   rst1 - normalized real time signal
%                   rSf1 - ifft of real time signal

function [st1, Sf1, rst1, rSf1] = getLFM(f_samp, t_0, t_p, T, f_i, f_f)

dt=1/f_samp;
t=(0:dt:T-dt);
% Waveform Parameters for WX1:
% indices in t for t_0 <= t <= (t_0+t_p)
I_t=find( (t_0 <= t) & (t <=(t_0+t_p)) );
st0=zeros(1,length(t));                 % initialize the waveform
st0(I_t) = 1/sqrt(t_p)*exp(-i*2*pi*( f_i*(t(I_t)-t_0) ...
    + (f_f-f_i)./(2*t_p)*(t(I_t)-t_0).^2 )  );
clear I_t;

% Tukey window
p=0.1;                %0.1; 
T_w=.125*t_p;
wt=zeros(1,length(t));                                  % initialize Tukey window
I_wt1=find( (t_0 <= t) & (t <=(t_0+T_w)) );             % indices for Tukey window sloping up
I_wt2=find( ( (t_0+T_w) < t) & (t <(t_0+t_p-T_w)) );    % indices for flat part of window
I_wt3=find( ((t_0+t_p-T_w) <= t) & (t <=(t_0+t_p)) );   % indices for Tukey window sloping down
wt(I_wt1)=p+(1-p)*(sin(pi*(I_wt1-I_wt1(1))/(2*length(I_wt1)))).^2;
wt(I_wt2)=1;
wt(I_wt3)=p+(1-p)*(cos(pi*(I_wt3-I_wt3(1))/(2*length(I_wt3)))).^2;
st1=wt.*st0;     % time domain waveform

st1=st1./sqrt(sum(abs(st1).^2)*dt);    %normalizes st1
Sf1=T*ifft(st1); % frequency domain waveform normalized

%normalization check:
%df=1/T;
%PSt = sum(abs(st1).^2)*dt
%PSf = sum(abs(Sf1).^2)*df

%real quantities in time:
rst1=real(st1)./sqrt(sum(real(st1).^2)*dt);  %normalizes st1 
rSf1=T*ifft(rst1);  %normalizes Sf1 so that Parsevals sum is 1

%PSrt = sum(abs(rst1).^2)*dt
%PSrf = sum(abs(rSf1).^2)*df
