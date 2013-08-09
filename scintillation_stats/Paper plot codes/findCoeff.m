function [k1, A1] = findCoeff(x1, y1)

sse = 1e90; 
for A = 1.5:0.1:4
    for k = 10:0.1:80
        sse1 = sum((A - (A-1)*exp(-k.*x1)-y1).^2);
        if sse1 < sse
            sse = sse1
            k1 = k; A1 = A;
        end
    end
end

end
