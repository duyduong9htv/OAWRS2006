function input_series = read_input_series(raw_file_name, aperture)
% function input_series = read_input_series(raw_file_name, aperture) 
% reads the raw .dat file for data recorded by all 64 channels. 
% Output inputseries is in uPa, with all conversion gain and hydrophone
% sensitivity already accounted for in this code. 
% INPUT raw_file_name : fora.....dat 
%       aperture      : 'lf', 'mf', 'hf', or 'uf'


%% Read parameters and extract input signals from .dat file

[fid, message] = fopen(raw_file_name,'rb');
if fid == -1
    disp(' *** Error opening input file... Please check filename! ***');
    return;
end
read_block_size = 80;
count = 0; 
while ~feof(fid)
%     count = count+1; 
%     disp(count); 
    temp = fread(fid,read_block_size,'*char')';
    temp1 = sscanf(temp, '%s', 1); 
    tata = deblank(temp1); 
    if strcmp(tata,'END')
        break;
    elseif strcmp(sscanf(temp,'%s',1),'NRHE')
        nrhe = sscanf(temp,'%*s%d',1);
    elseif strcmp(sscanf(temp,'%s',1),'RECL')
        recl = sscanf(temp,'%*s%d',1);   
    elseif strcmp(sscanf(temp,'%s',1),'NCHA')
        nchannels = sscanf(temp,'%*s%d',1);
    elseif strcmp(sscanf(temp,'%s',1),'DSIZE')
        nsamples_per_read = sscanf(temp,'%*s%d',1);    
    elseif strcmp(sscanf(temp,'%s',1),'GAIN')
        vga = sscanf(temp,'%*s%d',1);
    end
    clear temp;
end

fseek(fid, nrhe*recl, -1);
ftell(fid);
nsensors = 64;
tic
inp = fread(fid,'long');
fclose(fid);
inp = reshape(inp,nsamples_per_read,nchannels,[]);
if (strcmp(aperture,'hf') == 1)
    input_series = inp(:,35:98,:);
elseif (strcmp(aperture,'mf') == 1)
    input_series = [ ...
        inp(:,19:34,:) ...
        mean(inp(:,35:36,:),2) ...
        mean(inp(:,37:38,:),2) ...
        mean(inp(:,39:40,:),2) ...
        mean(inp(:,41:42,:),2) ...
        mean(inp(:,43:44,:),2) ...
        mean(inp(:,45:46,:),2) ...
        mean(inp(:,47:48,:),2) ...
        mean(inp(:,49:50,:),2) ...
        mean(inp(:,51:52,:),2) ...
        mean(inp(:,53:54,:),2) ...
        mean(inp(:,55:56,:),2) ...
        mean(inp(:,57:58,:),2) ...
        mean(inp(:,59:60,:),2) ...
        mean(inp(:,61:62,:),2) ...
        mean(inp(:,63:64,:),2) ...
        mean(inp(:,65:66,:),2) ...
        mean(inp(:,67:68,:),2) ...
        mean(inp(:,69:70,:),2) ...
        mean(inp(:,71:72,:),2) ...
        mean(inp(:,73:74,:),2) ...
        mean(inp(:,75:76,:),2) ...
        mean(inp(:,77:78,:),2) ...
        mean(inp(:,79:80,:),2) ...
        mean(inp(:,81:82,:),2) ...
        mean(inp(:,83:84,:),2) ...
        mean(inp(:,85:86,:),2) ...
        mean(inp(:,87:88,:),2) ...
        mean(inp(:,89:90,:),2) ...
        mean(inp(:,91:92,:),2) ...
        mean(inp(:,93:94,:),2) ...
        mean(inp(:,95:96,:),2) ...
        mean(inp(:,97:98,:),2) ...
        inp(:,99:114,:)];
elseif (strcmp(aperture,'lf') == 1)
    input_series = [ ...
        inp(:,3:18,:) ...
        mean(inp(:,19:20,:),2) ...
        mean(inp(:,21:22,:),2) ...
        mean(inp(:,23:24,:),2) ...
        mean(inp(:,25:26,:),2) ...
        mean(inp(:,27:28,:),2) ...
        mean(inp(:,29:30,:),2) ...
        mean(inp(:,31:32,:),2) ...
        mean(inp(:,33:34,:),2) ...
        mean(inp(:,35:38,:),2) ...
        mean(inp(:,39:42,:),2) ...
        mean(inp(:,43:46,:),2) ...
        mean(inp(:,47:50,:),2) ...
        mean(inp(:,51:54,:),2) ...
        mean(inp(:,55:58,:),2) ...
        mean(inp(:,59:62,:),2) ...
        mean(inp(:,63:66,:),2) ...
        mean(inp(:,67:70,:),2) ...
        mean(inp(:,71:74,:),2) ...
        mean(inp(:,75:78,:),2) ...
        mean(inp(:,79:82,:),2) ...
        mean(inp(:,83:86,:),2) ...
        mean(inp(:,87:90,:),2) ...
        mean(inp(:,91:94,:),2) ...
        mean(inp(:,95:98,:),2) ...
        mean(inp(:,99:100,:),2) ...
        mean(inp(:,101:102,:),2) ...
        mean(inp(:,103:104,:),2) ...
        mean(inp(:,105:106,:),2) ...
        mean(inp(:,107:108,:),2) ...
        mean(inp(:,109:110,:),2) ...
        mean(inp(:,111:112,:),2) ...
        mean(inp(:,113:114,:),2) ...
        inp(:,115:130,:)];
elseif (strcmp(aperture,'uf') == 1)
    input_series = [ ...
        mean(inp(:,3:4,:),2) ...
        mean(inp(:,5:6,:),2) ...
        mean(inp(:,7:8,:),2) ...
        mean(inp(:,9:10,:),2) ...
        mean(inp(:,11:12,:),2) ...
        mean(inp(:,13:14,:),2) ...
        mean(inp(:,15:16,:),2) ...
        mean(inp(:,17:18,:),2) ...
        mean(inp(:,19:22,:),2) ...
        mean(inp(:,23:26,:),2) ...
        mean(inp(:,27:30,:),2) ...
        mean(inp(:,31:34,:),2) ...
        mean(inp(:,35:42,:),2) ...
        mean(inp(:,43:50,:),2) ...
        mean(inp(:,51:58,:),2) ...
        mean(inp(:,59:66,:),2) ...
        mean(inp(:,67:74,:),2) ...
        mean(inp(:,75:82,:),2) ...
        mean(inp(:,83:90,:),2) ...
        mean(inp(:,91:98,:),2) ...
        mean(inp(:,99:102,:),2) ...
        mean(inp(:,103:106,:),2) ...
        mean(inp(:,107:110,:),2) ...
        mean(inp(:,111:114,:),2) ...
        mean(inp(:,115:116,:),2) ...
        mean(inp(:,117:118,:),2) ...
        mean(inp(:,119:120,:),2) ...
        mean(inp(:,121:122,:),2) ...
        mean(inp(:,123:124,:),2) ...
        mean(inp(:,125:126,:),2) ...
        mean(inp(:,127:128,:),2) ...
        mean(inp(:,129:130,:),2) ...
        inp(:,131:162,:)];
else 
    disp('*** ERROR: Invalid Subarray Selection... Choose UF, LF, MF, or HF... Exiting...***');
    return;
end

input_series = permute(input_series,[2,1,3]);
input_series = reshape(input_series,nsensors,[])';
hsens = -187.0;
conv_gain = 132.45;
fixed_gain = 12.2;
vga = 18;
Sens = hsens + conv_gain + fixed_gain + vga;
uPa_volt = 10^(-Sens/20);

input_series = input_series*uPa_volt; %return hydrophone data in uPa after correcting for sensitivity. 

toc
end 
