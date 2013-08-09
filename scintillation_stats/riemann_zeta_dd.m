% calculates the Riemann zeta function Z(s,q) = sum of 1/[(k+q)^s] with k
% running from 0 to infinity.
function dataout = riemann_zeta_dd(s,q)
    dataout = 0; 
    if q == 0 
        k=1;
    else
        k=0;
    end
        
    addition_term = 1/((k+q)^s);    
    while addition_term>0.00000001
        dataout = dataout+addition_term;
        k = k+1;
        addition_term = 1/((k+q)^s);
    end
    
end     
    
