
function mu=get_tbprod(sigma)
%FUNCTION mu = get_tbprod(sigma) gets the time bandwidth product for a given standard deviation 
% from the equation found in 
% "The effect of saturated transmission scintillations.." by Makris, eq. 23

mu_exp=(0:.005:2);
mu_vec=10.^mu_exp;

for mm=1:length(mu_vec)
	 k_vec=(0:round(mu_vec(mm))+100);
stdl(mm)=10*log10(exp(1))*sqrt(sum(1./((mu_vec(mm)+k_vec).^2)));
end

[~, std_ind]=min(abs(stdl-sigma));
mu = mu_vec(std_ind);

% figure(1)
% plot(mu_vec, stdl)
% hold on
% plot(mu, stdl(std_ind), 'kd')
% 
% figure(2)
% plot(mu_exp, stdl)
% hold on
% plot(mu_exp(std_ind), stdl(std_ind), 'kd')
