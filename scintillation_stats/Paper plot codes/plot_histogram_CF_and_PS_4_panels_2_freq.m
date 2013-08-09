%this code creates a 2x2 panel graph that shows the distribution for two
%center frequencies within one range window. Shows the histogram (measured)
%and PDF (modeled) for : center single frequency and 50 Hz broadband. 


clear all; close all; 
cd ~/Research/SI
freq = [415 735 950 1125];

    
window =2000; 
range = 7000; 

count = 0; 
figure(1); clf; hold on; 
for freq_ind = 1:3:4
        eval(['load  range_TL_' num2str(freq(freq_ind)) '.mat'])
    
        count = count + 1; 
        window_inds = find( (range_TL(:,1)>range) & ((range_TL(:,1)-range)<window));
        
       
        [N,X] = hist(range_TL(window_inds, 2), [-85:1:-55]); 
        L_mean = sum(X.*N)./(sum(N)); 
        std_deviation = std(range_TL(window_inds, 2));
        mu = get_tbprod(std_deviation); 
        L = [-90:1:-50];
        I_0 = 10^((L_mean-10*log10(exp(1))*(psi(mu)-log(mu)))/10);


        %calculating the PDF of L 
        firstterm = (mu/I_0)^mu; 
        secondterm = (10.^(L./10)).^(mu-1)/(gamma(mu));
        power = -mu.*(10.^(L./10))/I_0 + log(10).*L/10; 
        thirdterm = exp(power); 

        lastterm = 1/(10*log10(exp(1)));

        p = firstterm.*secondterm.*thirdterm.*lastterm; 

        % plotting the histogram and the PDF of L 
        s(count)=subplot(2,2, count); hold on;   set(gca, 'fontsize', 16); 
            plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
        if (count~=1)&&(count~=4)
            set(gca, 'yticklabel', '');
        else
            ylabel('Normalized number of occurences')
        end
%         title([num2str(range/1000) '-' num2str(range/1000 + window/1000) ' km']);hold on; 
        title(['f_c = ' num2str(freq(freq_ind)) ' Hz']); 

        bar(X, N./sum(N), 'facecolor', [0.6 0.6 0.6]);hold on; 
        plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
        xlim([-88 -55])
        set(gca, 'xtick', [-90:10:-50])
        ylim([0 0.16])   
         set(gca, 'ytick', 0:0.05:0.16)
        legend(['\mu = ' num2str(mu)], 'location', 'northwest')
%         title(['Bandwidth B = ' num2str(ii*10) 'Hz'])    
        set(gcf,'paperpositionmode', 'auto');  

        
end

count = 2; 
for freq_ind = 1:3:4
    eval(['load range_PS_' num2str(freq(freq_ind)) '.mat'])
    count = count + 1; 
    window_inds = find( (range_PS(:,1)>range) & ((range_PS(:,1)-range)<window));
        
    [N,X] = hist(range_PS(window_inds, 6), [-85:1:-55]); 
    L_mean = sum(X.*N)./(sum(N)); 
    std_deviation = std(range_PS(window_inds, 6));
    mu = get_tbprod(std_deviation); 
    L = [-90:1:-50];
    I_0 = 10^((L_mean-10*log10(exp(1))*(psi(mu)-log(mu)))/10);
    
    
    %calculating the PDF of L 
    firstterm = (mu/I_0)^mu; 
    secondterm = (10.^(L./10)).^(mu-1)/(gamma(mu));
    power = -mu.*(10.^(L./10))/I_0 + log(10).*L/10; 
    thirdterm = exp(power); 

    lastterm = 1/(10*log10(exp(1)));

    p = firstterm.*secondterm.*thirdterm.*lastterm; 
    
    % plotting the histogram and the PDF of L 
    s(count) = subplot(2, 2, count); hold on;   set(gca, 'fontsize', 16); 
    if (count~=1)&&(count~=3)
        set(gca, 'yticklabel', '');
    else
        ylabel('Normalized number of occurences')
    end
    plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
   
    bar(X, N./sum(N), 'facecolor', [0.6 0.6 0.6]);hold on; 
    plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
    xlim([-88 -55])
    set(gca, 'xtick', [-90:10:-50])
    ylim([0 0.16])   
    set(gca, 'ytick', 0:0.05:0.16)
    xlabel('Normalized received pressure level (dB)')
    legend(['\mu = ' num2str(mu)], 'location', 'northwest')
%     title(['Bandwidth B = ' num2str(ii*10) 'Hz'])  
end

set(gcf, 'position', [1 1 1230 769]); 
set(s(1), 'xticklabel', ''); 
set(s(2), 'xticklabel', ''); 

pos1 = get(s(1), 'position'); 

set(s(2), 'position', [0.48 0.5838 0.3347 0.3412])
set(s(3), 'position', [pos1(1) 0.23 0.3347 0.3412])
set(s(4), 'position', [0.48 0.23 0.3347 0.3412])
set(s(1), 'position', [0.1393 0.5838 0.3347 0.3412])
set(gcf,'paperpositionmode', 'auto'); 


 print -f1 -depsc /Users/dtran/2006_stats/Figures/PS_histogram.eps
