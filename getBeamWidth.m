function beamwidth = getBeamWidth(steering_angle, fc)
% function beamwidth = getBeamWidth(steering_angle) 
% gets the beamwidth when the array is steered at the steering_angle value
% of choice. To be used when simulating localization of whales/sources and
% see how errors in bearing estimates affect the localization results. 
% 
% By default, it is assumed that the large aperture (L = 94.5m) is used for
% frequency fc = 415 Hz. 
% 
% input: steering angle is the angle made with the forward endfire
% direction of the array. Eg: 90 degree steering_angle means that the array
% is steered to broadside. 
% fc: center frequency being used
% Written by DD Tran, 2012. 

if fc < 800 
	Larray = 94.5; 
else 
	Larray = 47.5; 
end 

cw=1500;
rcv_heading=0;
alpha=rcv_heading*pi/180; 
phi=[0:1*pi/180:2*pi];
p0=alpha+steering_angle*pi/180;
 
%calculate beampattern
kw=2*pi*fc/cw;

for pp=1:length(phi)
    ss=sin(phi(pp)+(pi/2)-alpha)-sin(p0+(pi/2)-alpha);
    BPrect=sinc(Larray*kw*ss/(2*pi));
    BPhanning=(sinc(Larray*kw*ss/(2*pi)-1)+sinc(Larray*kw*ss/(2*pi)+1))/4 + BPrect/2;
    BP1(pp)=abs(BPhanning)^2;
end
BP=BP1/max(BP1);
%  
% g=figure
% hold
% axis([0 360 0 1]);
% a=plot(phi*180/pi,BP);
% set(a,'color',[.5 .5 .5],'linestyle',':');

if ((steering_angle<=12.608) || (steering_angle>=(180-12.608)))
	beamwidth=sum(BP);
	beamwidth_rad=beamwidth*pi/180;
else
	beamwidth=sum(BP(1:181));
	beamwidth_rad=beamwidth*pi/180;
end

end 