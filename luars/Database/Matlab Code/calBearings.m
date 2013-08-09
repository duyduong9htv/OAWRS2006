function bearings = calBearings(targetLocs, rcv)
%function bearings = calBearings(targetLocs, rcv) 
%gives the bearings (theoretical) when the trajectory of the targets is given
%by a Nx2 vector targetLocs. 
% INPUTS: targetLocs (Nx2) x and y coordinates of the trajectory.
%         rcv: Nx2: x and y coordinates of the receiver. 
% OUTPUTS: bearings: Nx1, calculated bearings. 
% Last updated by DD Tran, Aug 9, 2013. 

xx = targetLocs(:, 1); 
yy = targetLocs(:, 2); 

epsilon = (1e-12); 
iota = (1 - (sign(xx - rcv(:, 1)).^2))*epsilon; %to avoid division by zero 

angle1 = atand((yy - rcv(:, 2))./(xx - rcv(:, 1) + iota)); 
angle1 = angle1 - 90*(1 - sign(xx - rcv(:, 1) + iota));
bearings = 90 - angle1; 

end 
