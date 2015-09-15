function [EN]=ENAR_matrix(H,C,R)


EN = zeros(H+1,H*C,H*C+1,H+1);
for N=0:R*H*C
    for T=0:H
        for k=0:T
            for n=1:N
                EN(k+1,n,N+1,T+1) = ENAR(k,n,N,T);
            end
        end
    end
end