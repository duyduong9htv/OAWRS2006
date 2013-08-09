%% <Function Title>
%
% <OUTPUTS> = GetSteeringAngle(<INPUTS>) <Function Description>
%
% References:
%
% Remarks:
%
%   Written by: David C. Reed
%   Created: 03Apr2012
%   Modified: 03Apr2012
%
% See also
function steeringAngle = GetSteeringAngle(heading, trueBearing)

steeringAngle = zeros(size(trueBearing));
for ii = 1:length(trueBearing)
    relAngle = trueBearing(ii) - heading;
    if abs(relAngle) < 180
        steeringAngle(ii) = -abs(relAngle) + 90;
    else
        steeringAngle(ii) = abs(relAngle) - 270;
        
    end
end