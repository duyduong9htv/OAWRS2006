% scratch 
clear all; close all; 

cd /Users/dtran/Research/TL_vs_Range/200m_IW/950_PS
figure(10); 
set(gcf, 'position', [2112 214 938 709])

for bb = [0 50]
    cd /Users/dtran/Research/TL_vs_Range/200m_IW/950_PS
    eval(['load PSmean_std_rect_' num2str(bb) '.mat'])
    
%     averaging over the range
    for ii = 1:1999
       std_run(ii) = mean(mean(standard_deviation(1:200, max(ii-40, 1):min(ii+40, 1999))));  
    end
    range_run  = 25*[1:1:1999];

    
  hold on 
  switch bb
      case 0 
      plot(range_run, std_run, 'color', 'black', 'linewidth', 2); hold on; 
        plot(range_run, std_run, '--', 'color', 'black', 'linewidth', 2);         
        plot(range_run, std_run, 'color', [0.7 0.7 0.7], 'linewidth', 2); 
        plot(range_run, std_run, '--', 'color', [0.7 0.7 0.7 ], 'linewidth', 2); 
        plot(range_run, std_run, 'color', 'black', 'linewidth', 2); 
        
        cd ../../2km_IW/950_PS/

        eval(['load PSmean_std_rect_' num2str(bb) '.mat'])
        
         for ii = 1:1999
           std_run(ii) = mean(mean(standard_deviation(1:200, max(ii-40, 1):min(ii+40, 1999))));  
         end
        range_run  = 25*[1:1:1999];
         hold on 
        plot(range_run, std_run, 'k--', 'linewidth', 2);
      case 50 
        plot(range_run, std_run, 'color', [0.7 0.7 0.7], 'linewidth', 2); 
    % legend('10', '20', '30', '40', '50')

        cd ../../2km_IW/950_PS/

        eval(['load PSmean_std_rect_' num2str(bb) '.mat'])
        for ii = 1:1999
           std_run(ii) = mean(mean(standard_deviation(1:200, max(ii-40, 1):min(ii+40, 1999))));  
         end
        range_run  = 25*[1:1:1999];
         hold on 
        plot(range_run, std_run, '--', 'color', [0.7 0.7 0.7], 'linewidth', 2);
         hold on 
        plot(range_run, std_run, '--', 'linewidth', 2, 'color', [0.7 0.7 0.7]);
  end
          
end


legend('200m CF', '2km CF', '200m 50Hz', '2km 50Hz', 'location', 'southwest'); 
xtl = get(gca, 'xtick'); 
set(gca, 'xticklabel', xtl*2./1000);

set(gca, 'fontsize', 18); 
xlabel('Range (km)'); ylabel('Standard deviation \sigma (dB)' ); 

box on; 
print -f10 -depsc std_vs_range_IW_model.eps
!scp std_vs_range_IW_model.eps /Users/dtran/Research/SI/