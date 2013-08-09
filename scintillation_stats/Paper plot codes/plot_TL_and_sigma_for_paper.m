% plot range_averaged TL and standard deviation for
%paper

%Oct 14 2011: added to the end: range-average in log land to show
%dependence of std over range. 


cd /Users/dtran/Research/SI/
close all; clear all; 

fullscreen = get(0,'ScreenSize');
figure('Position',[2080 461 1629 651]);

hold on; 
freq_vector = [415 735 950 1125];
window = 1500; %averaging window is 1000 m
for f_ind = 1:4
    s(1)  = subplot(1,2,1); hold on; box on; 
    eval(['load range_PS_' num2str(freq_vector(f_ind)) '.mat']);
    
    range_run = [];
    range = range_PS(:,1);
    PS_run = [];
    
    ind = find(range_PS(:, 1)<20e3); 
    range_PS = range_PS(ind, :); 
    
    for ii = 1:max(size(range_PS))
        inds = find(abs(range_PS(:,1)-range_PS(ii,1))<window);
        if length(inds)>1
            range_run(ii) = mean(range_PS(inds, 1)); 
            PS_run = [PS_run; mean(range_PS(inds, 2:6))];
        end
    end
    
    switch f_ind
        case 1
             plot(range_run, PS_run(:, 5), 'k--', 'color', [0.8 0.8 0.8],'linewidth', 2); 
        case 2
            plot(range_run, PS_run(:, 5), 'k--', 'linewidth', 2); 
        case 3
            plot(range_run, PS_run(:, 5), 'color', [0.8 0.8 0.8], 'linewidth', 2); 
        case 4
             plot(range_run, PS_run(:, 5), 'k-', 'linewidth', 2); 
    end
end



legend('415 Hz', '735 Hz', '950 Hz', '1125 Hz' )
xlim([0 15e3])    
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl./1000); 

set(s(1), 'fontsize', 20); 
xlabel('Range (km)')
ylabel('Normalized received pressure level (dB)')
set(gcf, 'paperpositionMode', 'auto');

window = 200; 
for f_ind = 1:4
    s(2)  = subplot(1,2,2); hold on; box on; 
    eval(['load range_std_' num2str(freq_vector(f_ind)) '.mat']);
    
    ind = find(range_std(:, 1)< 30e3); 
    range_std = range_std(ind, :); 
    
    range_run = [];
    range = range_std(:,1);
    std_run = []; 
    
    for ii = 1:max(size(range_std))
        inds = find(abs(range_std(:,1)-range_std(ii,1))<window);
        if ~isempty(inds)
            if length(inds)>1
                range_run(ii) = mean(range_std(inds, 1)); 
                std_run = [std_run; mean(range_std(inds, 6:6))];%%??? Why did I average across the whole bandwidth before???
                
            else
                range_run(ii) = range_std(inds,1);
                std_run = [std_run; range_std(inds, 6:6)];
            end
        end
            
    end
    
    
    figure(10); hold on; 
    plot(log(range_run), std_run(:, end), 'color', rand(1, 3)); 
    figure(1); 
    switch f_ind
        case 1
            plot(range_run, std_run(:, end), 'k--', 'color', [0.8 0.8 0.8],'linewidth', 2); 
        case 2
            plot(range_run, std_run(:, end), 'k--', 'linewidth', 2); 
        case 3
            plot(range_run, std_run(:, end), 'color', [0.8 0.8 0.8], 'linewidth', 2); 
        case 4
            plot(range_run, std_run(:, end), 'k-', 'linewidth', 2); 
    end
end

figure(10); 

legend('415 Hz', '735 Hz', '950 Hz', '1125 Hz' )
xlim([0 15e3])    
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl./1000); 

% set(s(2), 'position', 
set(s(1), 'position', [0.0800 0.1100 0.3347 0.8150]);
set(s(2), 'position', [0.50 0.1100 0.3347 0.8150]);

set(s(2), 'fontsize', 20); 
xlabel('Range (km)')
ylabel('Standard deviation (dB)')
set(gcf, 'paperpositionMode', 'auto');

text(-18394.970414201183, 5.28,17.32, '(A)', 'fontsize', 20, 'fontweight', 'bold')
text(628.4916201117303, 5.28, 17.32, '(B)', 'fontsize', 20, 'fontweight', 'bold'); 
print -f1 -depsc mean_standard_deviation_vs_range_GOM.eps




%% this section to do range averaging in log domain 
figure(10); clf; 
window = 0.075;
for f_ind = 1:4
    eval(['load range_std_' num2str(freq_vector(f_ind)) '.mat']);
    ind = find(range_std(:, 1)< 30e3); 
    range_std = range_std(ind, :); 
    figure(10); hold on; 
    range_log = log10(range_std(:, 1)); 
    std_run = []; 
    range_log_run = []; 
    
    for ii = 1:max(size(range_std))
        inds = find(abs(range_log(:,1)-range_log(ii,1))<window);
        if ~isempty(inds)
            if length(inds)>1
                range_log_run(ii) = mean(range_log(inds, 1)); 
                std_run = [std_run; mean(range_std(inds, 2:6))];
            else
                range_log_run(ii) = range_log(inds,1);
                std_run = [std_run; range_std(inds, 2:6)];
            end
        end
%         range_log_run(ii) = mean(range_log(ii:ii+window));
%         std_

    
    end
    
    
    switch f_ind
        case 1
             plot(10.^(range_log_run), std_run(:, end),'k--', 'color', [0.8 0.8 0.8],'linewidth', 2); 
        case 2
             plot(10.^(range_log_run), std_run(:, end), 'k--', 'linewidth', 2); 
        case 3
             plot(10.^(range_log_run), std_run(:, end), 'color', [0.8 0.8 0.8], 'linewidth', 2); 
        case 4
            plot(10.^(range_log_run), std_run(:, end), 'k-', 'linewidth', 2); 
    end
    
    

end 

legend('415 Hz', '735 Hz', '950 Hz', '1125 Hz' )

polish_figure; 

xlabel('Range (km)')
ylabel('Standard deviation (dB)')
set(gcf, 'paperpositionMode', 'auto');
set(gca, 'xtick', [0 5000 10000 15000 20000])
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', round(xtl/1000)); 

print -depsc /Users/dtran/2006_stats/Figures/std_vs_range_data_log_averaged.eps 

%% Just Oct days

%plot std vs. range (data, Oct days) 

cd ~/Research/SI/

f_vec = [415 735 950 1125]; 

for ii = 1:length(f_vec)
    f_c = f_vec(ii); 
    eval(['load range_std_' num2str(f_c) '_oct']); 
    range_std = [range_all std_run_all]; 
    range_std = sortrows(range_std); 
    range_std1 = range_std; 
    window = 2e3; %2km range averaged
    for jj = 1:length(range_std)
        ind = find(abs(range_std(:, 1)-range_std(jj, 1))<window/2); 
        range_std1(jj, 2:end) = mean(range_std(ind, 2:end)); 
    end
    
    
    figure(10); hold on; 
    plot(range_std1(:, 1), range_std1(:, end), 'color', rand(1, 3)); 
end

xlim([0 20e3])


