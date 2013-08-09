%% <Function Title>
%
% <OUTPUTS> = CompareHandleStructs(<INPUTS>) <Function Description>
%
% References: 
%
% Remarks: 
%
%   Written by: David C. Reed
%   Created: 20Mar2012
%   Modified: 20Mar2012
%
% See also 
function CompareHandleStructs(h1, h2)

if strcmp(h1.Type, h2.Type)
    
    
names1 = fieldnames(h1);
names2 = fieldnames(h2);

 

for ii = 1:length(names1)
    temp = h1.(names1{ii});
    
    if isnumeric(temp)
        if h1.(names1{ii}) ~= h2.(names2{ii})
            fprintf('%s: 1.) %d, 2.) %d \n', names1{ii}, h1.(names1{ii}), h2.(names2{ii}));
        end
    elseif ischar(temp)
        if ~strcmp(h1.(names1{ii}), h2.(names2{ii}))
            fprintf('%s: 1.) %s, 2.) %s \n', names1{ii}, h1.(names1{ii}), h2.(names2{ii}));
        end
    end
end

end