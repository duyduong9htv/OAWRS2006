%this code creates a 2x2 panel graph that shows the distribution for two
%center frequencies within one range window. Shows the histogram (measured)
%and PDF (modeled) for : center single frequency and 50 Hz broadband. 


clear all; close all; 
cd ~/Research/SI
freq = [415 735 950 1125];
    
window =2000; 
range = 7000; 
count = 0; 
figure(5); clf; hold on; 
TestTable = []; 
rangeStart = 7000; 
rangeEnd = 9000; 

for freq_ind = 1:3:4
        eval(['load  range_TL_' num2str(freq(freq_ind)) '.mat'])    
        count = count + 1;         
        
        [rangeWithin, window_inds] = findWithin(rangeStart, rangeEnd, range_TL(:, 1));           
       
        [N,X] = hist(range_TL(window_inds, 2), [-85:1:-55]); %data histogram 
%         L_mean = sum(X.*N)./(sum(N)); %mean intensity value from measured data 
        L_mean = mean(range_TL(window_inds, 2)); 
        std_deviation = std(range_TL(window_inds, 2)); %measured standard deviation
        mu = get_tbprod(std_deviation); %number of coherence cells, calculated from measured standard deviation
        
        L = [-90:1:-50]; %L values for superposing theoretical distribution 
        I_0 = 10^((L_mean-10*log10(exp(1))*(psi(mu)-log(mu)))/10);        
        
        %exponential distribution
        pExponential = GammaDist(1, I_0, L);        
      
        %Gamma distribution  
        p = GammaDist(mu, I_0, L); 

        % plotting the histogram and the PDF of L 
        s(count)=subplot(2,2, count); hold on;   set(gca, 'fontsize', 22); 
            plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
            plot(L, pExponential, '--k', 'linewidth', 2); 
            
        if (count~=1)&&(count~=4)
            set(gca, 'yticklabel', '');
        else
            ylabel('Normalized number of occurences')
        end
%         title([num2str(range/1000) '-' num2str(range/1000 + window/1000) ' km']);hold on; 
        title(['f_m = ' num2str(freq(freq_ind)) ' Hz']); 

        bar(X, N./sum(N), 'facecolor', [0.6 0.6 0.6]);hold on; 
        plot(L, pExponential, '--k', 'linewidth', 2); 
        plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
        xlim([-88 -55])
        set(gca, 'xtick', [-90:10:-50])
        ylim([0 0.16])   
         set(gca, 'ytick', 0:0.05:0.16)
        legend(['\mu = ' num2str(mu) ', Gamma'], '\mu = 1, exponential', 'location', 'northwest')
%         title(['Bandwidth B = ' num2str(ii*10) 'Hz'])    
        set(gcf,'paperpositionmode', 'auto');
        
        %goodness of fit test 
        L = [-85:1:-55]; %set L to be the same range as observed data
        pExponential = GammaDist(1, I_0, L); 
        pGamma = GammaDist(mu, I_0, L); 
        MeasuredData = N; 
        TheoreticalDist = pGamma*sum(N); 
        TheoreticalDistExp = pExponential*sum(N)
        [ChiSquared, degFreedom] = TestGoodnessOfFit(MeasuredData, TheoreticalDist); 
        [ChiSquaredExp, degFreedomExp] = TestGoodnessOfFit(MeasuredData, TheoreticalDistExp); 
        TestTable = [TestTable; freq(freq_ind) mu degFreedom ChiSquared degFreedomExp ChiSquaredExp]    
        
% 
%         
end

count = 2; 
for freq_ind = 1:3:4
        eval(['load range_PS_' num2str(freq(freq_ind)) '.mat'])
        count = count + 1; 
        [rangeWithin, window_inds] = findWithin(rangeStart, rangeEnd, range_PS(:, 1)); 
        
        [N,X] = hist(range_PS(window_inds, 6), [-85:1:-55]); 
        L_mean = sum(X.*N)./(sum(N)); 
        L_mean = mean(range_PS(window_inds, 6)); 
    
        std_deviation = std(range_PS(window_inds, 6));
        mu = get_tbprod(std_deviation); 
        L = [-90:1:-50];
        I_0 = 10^((L_mean-10*log10(exp(1))*(psi(mu)-log(mu)))/10);    

        %exponential distribution
        pExponential = GammaDist(1, I_0, L);
        %Gamma distribution  
        p = GammaDist(mu, I_0, L);    

        % plotting the histogram and the PDF of L 
        s(count) = subplot(2, 2, count); hold on;   set(gca, 'fontsize', 22); 
        if (count~=1)&&(count~=3)
            set(gca, 'yticklabel', '');
        else
            ylabel('Normalized number of occurences')
        end
        plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
        plot(L, pExponential, '--k', 'linewidth', 2); 

        bar(X, N./sum(N), 'facecolor', [0.6 0.6 0.6]);hold on; 
        plot(L, p, 'color', [0 0 0], 'linewidth', 2); box on; 
        plot(L, pExponential, '--k', 'linewidth', 2); 
        xlim([-88 -55])
        set(gca, 'xtick', [-90:10:-50])
        ylim([0 0.16])   
        set(gca, 'ytick', 0:0.05:0.16)
        xlabel('Normalized received pressure level (dB)')
        legend(['\mu = ' num2str(mu) ', Gamma'], '\mu = 1, exponential', 'location', 'northwest')

        %goodness of fit test 
        L = [-85:1:-55]; %set L to be the same range as observed data
        pExponential = GammaDist(1, I_0, L); 
        pGamma = GammaDist(mu, I_0, L); 
        MeasuredData = N; 
        TheoreticalDist = pGamma*sum(N); 
        TheoreticalDistExp = pExponential*sum(N)
        [ChiSquared, degFreedom] = TestGoodnessOfFit(MeasuredData, TheoreticalDist); 
        [ChiSquaredExp, degFreedomExp] = TestGoodnessOfFit(MeasuredData, TheoreticalDistExp); 
        TestTable = [TestTable; freq(freq_ind) mu degFreedom ChiSquared degFreedomExp ChiSquaredExp ]; 
end

set(gcf, 'position', [1 1 1230 769]); 
set(s(1), 'xticklabel', ''); 
set(s(2), 'xticklabel', ''); 

pos1 = get(s(1), 'position'); 

set(s(2), 'position', [0.48 0.5838 0.3347 0.3412])
set(s(3), 'position', [pos1(1) 0.23 0.3347 0.3412])
set(s(4), 'position', [0.48 0.23 0.3347 0.3412])
set(s(1), 'position', [0.1393 0.5838 0.3347 0.3412])

pos1 = get(s(1), 'position'); 

set(s(2), 'position', [0.48 0.5838 0.3347 0.3412])
set(s(3), 'position', [pos1(1) 0.23 0.3347 0.3412])
set(s(4), 'position', [0.48 0.23 0.3347 0.3412])
set(s(1), 'position', [0.1393 0.5838 0.3347 0.3412])
set(gcf,'paperpositionmode', 'auto'); 
setFigureAuto; 
% 
%  print -f5 -depsc /Users/dtran/2006_stats/Figures/PS_histogram5.eps

for annotationWork = 1

annotation(figure(5),'textbox',...
    [0.147967479674797 0.783135240572172 0.195121951219512 0.0546163849154746],...
    'Interpreter','latex',...
    'String',{'$f_m$=415 Hz, $B$=0.5 Hz'},...
    'FontSize',22,...
    'LineStyle','none');

annotation(figure(5),'textbox',...
    [0.492682926829268 0.787036410923277 0.195121951219512 0.0546163849154746],...
    'Interpreter','latex',...
    'String',{'$f_m$=1125 Hz, $B$=0.5 Hz'},...
    'FontSize',22,...
    'LineStyle','none');

annotation(figure(5),'textbox',...
    [0.142276422764228 0.445033810143043 0.195121951219512 0.0546163849154746],...
    'Interpreter','latex',...
    'String',{'$f_m$=415 Hz, $B$=42 Hz'},...
    'FontSize',22,...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(5),'textbox',...
    [0.492682926829268 0.445033810143043 0.195121951219512 0.0546163849154746],...
    'Interpreter','latex',...
    'String',{'$f_m$=1125 Hz, $B$=42 Hz'},...
    'FontSize',22,...
    'FitBoxToText','off',...
    'LineStyle','none');


annotation(figure(5),'textbox',...
    [0.434146341463415 0.858557867360208 0.0516260162601626 0.046814044213264],...
    'String',{'(A)'},...
    'FontWeight','bold',...
    'FontSize',22,...
    'LineStyle','none');

annotation(figure(5),'textbox',...
    [0.434146341463415 0.858557867360208-pos1(4) 0.0516260162601626 0.046814044213264],...
    'String',{'(C)'},...
    'FontWeight','bold',...
    'FontSize',22,...
    'LineStyle','none');


annotation(figure(5),'textbox',...
    [0.434146341463415+pos1(3) 0.858557867360208 0.0516260162601626 0.046814044213264],...
    'String',{'(B)'},...
    'FontWeight','bold',...
    'FontSize',22,...
    'LineStyle','none');


annotation(figure(5),'textbox',...
    [0.434146341463415+pos1(3) 0.858557867360208-pos1(4) 0.0516260162601626 0.046814044213264],...
    'String',{'(D)'},...
    'FontWeight','bold',...
    'FontSize',22,...
    'LineStyle','none');
end 





% %% goodness of fit 
% MeasuredData =N; 
% TheoreticalDist = p*sum(N); 
% 
% inds = find ((MeasuredData(:)>5) &(TheoreticalDist(:)>5)); 
% MeasuredData = MeasuredData(inds); 
% TheoreticalDist = TheoreticalDist(inds); 
% 
% ChiSquared = sum(((MeasuredData - TheoreticalDist).^2)./TheoreticalDist)
% 
% size(TheoreticalDist)
% 
