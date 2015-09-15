function [E]=ENAR(k,n,N,T)
if n>N || k==0
    E=0;
else
    if k==1;
        E=(N-T-n+2)/(N-T+1);
    else
        s=0;
        for i=1:(n-1)
            s=s+ENAR(k-1,i,N,T);
        end
        E=s/(N-T+k)+(N-n-T+k+1)*(1+ ENAR(k-1,n,N,T))/(N-T+k);
    end
end