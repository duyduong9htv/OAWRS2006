%FUNCTION get_PS_recursive_v6(f_i, f_f, window, band, MC_sample, path) 
%last modified Mar 31 '10 by DD
%This function gets the PS sum based on the available data files in the form g_grid_[frequency]_[MC sample].mat 
%   f_i, f_f       : initial,, and final frequency
%   window         : rectangular window    : 'rect'
%                    Tukey window       : 'Tukey'
%   band           : the band of frequencies that needs to be processed, eg. [0:10:50]
%   MC_sample      : number of Monte Carlo samples available 
%   path           : path to where the g_grid files are stored,
%   eg.'Users/dtran/blahblah/'. Do note the final slash needs to be included 

function get_PS_recursive_v6(f_i, f_f, window, band, MC_sample, path)
%% windowing 
%the data files are stored as single frequency transmission, if Tukey
%window was used then it should be applied to the available data now. If
%rectangular window was used then no pre-gain needs to be applied.
if strcmp(window, 'Tukey') || strcmp(window, 'tukey')
    f_samp = 8000; 
    t_0 = 0; 
    t_p = 2; 
    T = 2; 
    [st1, Sf1, rst1, rSf1] = getLFM(f_samp, t_0, t_p, T, f_i, f_f);
else 
    Sf1 = sqrt(1/(f_f - f_i))*ones(1, 16000);
end

%% initialize 
f_h = max(f_i, f_f);
f_l = min(f_i, f_f); 
f_cent=(f_f+f_i)/2;
PS = 0; 
f_range_stored = [f_cent]; 

%% sweeping through the MC samples 
for line_idx = 1:MC_sample
	PS_stored = 0;
    for bb=0:1:band(end)
     f_start_PS = f_cent - floor(bb/2);
     f_end_PS = f_start_PS + bb;    
        if bb == 0                     
            eval(['load ', path, 'g_grid_' num2str(f_cent) '_'  num2str(line_idx) '.mat']); %initialize for 0Hz (single frequency)              
            else

        if f_start_PS - f_start_stored < 0 
        %compare the starting frequency of the band with the previously stored value, if smaller, it means the bandwidth window has extended to the left, otherwise window has been extended to the right side 
                f_ind = f_start_PS;
            else 
                f_ind = f_end_PS;
        end
            eval(['load ' path, 'g_grid_' num2str(f_ind) '_'  num2str(line_idx) '.mat']);
            %load the extra data files that was not summed in the PS in
            %previous step 
        end

        PS_stored = PS_stored + (abs(g_grid).^2); %add the new frequency component to the PS 
	
         f_start_stored = f_start_PS;     %update the starting frequency
         PS = PS_stored;    
         PS = PS/(bb+1);        %normalize the PS sum to a single frequency
         PS = 10*log10(PS);     %convert to dB 
            
         %save Parseval sum grid if the bandwidth just processed is equal
         %to a bandwidth value that the user specified
         tt = find(band ==bb,1);
         if ~isempty(tt)
             eval(['save PS_grid_', window, num2str(bb), 'Hz_MC_', num2str(line_idx), '.mat PS']);  
         end
         clear g_grid;
    end
end
