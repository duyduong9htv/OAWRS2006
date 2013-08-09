function pdf = GammaDist(mu, Imean, L)
%function pdf = GammaDist(mu, Imean) 
%gets the Gamma distribution probability density function, parametrized by
%the number of coherence cells mu and the mean intensity Imean
%input:     mu     : number of coherence cells. = 1 for exponential
%           Imean  : mean intensity 
%           L      : log-intensity, eg: [-90:1:50]; 
%output:    pdf    : Gamma distribution PDF for L 
% written by DD Tran, 2012. 

    firstterm = (mu/Imean)^mu; 
    secondterm = (10.^(L./10)).^(mu-1)/(gamma(mu));
    power = -mu.*(10.^(L./10))/Imean + log(10).*L/10; 
    thirdterm = exp(power); 
    lastterm = 1/(10*log10(exp(1)));
    pdf = firstterm.*secondterm.*thirdterm.*lastterm; 
end
