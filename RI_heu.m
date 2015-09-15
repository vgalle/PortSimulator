function rel = RI_heu(bay , maxKnown , Tstar)


T=1;

N = sum(sum(bay>0));

numRow = size(bay,1);
height = sum(bay>0);
for n=1:N
    [ tier(n) col(n)] = find(bay==n);
    tier(n) = numRow-tier(n)+1;
end
n=1;
rel=0;
retrieved = zeros(1,N);

while n <= N
    if tier(n)==height(col(n)) 
        
        %retrieve
        bay(bay==n)=0;
        retrieved(n) = 1;
        height(col(n))=height(col(n))-1;
    end
    if ~retrieved(n)
        blocking = bay(numRow-height(col(n))+1,col(n));
        % find a slot for relocation
        dest_col  = compute_min_RI(bay,maxKnown,blocking,col(n),Tstar,T);
        dest_col = dest_col(1);
        bay(bay==blocking)=0;
        bay(numRow-height(dest_col),dest_col) = blocking;
        
        tier(blocking) = height(dest_col)+1;
        col(blocking) = dest_col;
        height(dest_col)=height(dest_col)+1;
        height(col(n))=height(col(n))-1;
        rel=rel+1;
    end
    if retrieved(n)==1
        n=n+1;
    end
    T = T + 1;
end

end

