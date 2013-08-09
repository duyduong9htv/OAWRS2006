
function get_stds_from_PS_grids(band, window, MC_realizations)
%FUNCTION get_stds_from_PS_grids(band, window, MC_realizations)
%band                 : set the bandwidth, for eg. [0:10:50]
%window               : the window used, for eg 'rect' or 'Tukey'
%MC_realizations      : Number of MC realizations
%last modified by DD Jun 29 2011


for bb = 1:max(size(band))
    PS_mean = 0;
    standard_deviation = 0;
    N = 0;
    for MC = 1:MC_realizations
        eval(['load PS_grid_', window, num2str(band(bb)) ,'Hz_MC_', num2str(MC) '.mat']); 
        PS_mean_new = (PS_mean*N + PS)/(N+1);
        var_new = (1/(N+1))*(N*standard_deviation.^2 + N/(N+1)*(PS-PS_mean).^2);
        PS_mean = PS_mean_new;
        standard_deviation = sqrt(var_new);
        N = N + 1;
    end
    PS = PS_mean;
    eval(['save PSmean_std_' window, '_', num2str(band(bb)), '.mat PS standard_deviation']) ;
end
