function rel = lowheightV2(numRow , numCol , bay)

% bay = createbay2(numRow , numCol , numConfig)
% initialBay = bay;

N = sum(sum(bay>0));

height = sum(bay>0);
for n=1:N
    [ tier(n) col(n)] = find(bay==n);
    tier(n) = numRow-tier(n)+1;
end
n=1;
rel=0;
retrieved = zeros(1,N);
% tier_temp=tier;
% col_temp = col;
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
        height_temp = height;
        height_temp(2,:) = 1:numCol;
%         f = find(height_temp(1,:)==numRow);
% %         
%         if ~isempty(f)
%             height_temp(:,f)=[];
%         end


        height_temp = height_temp(:,height_temp(1,:)<numRow);
        height_temp(:,height_temp(2,:)==col(n))=[];
        [~,b] = min(height_temp(1,:));
        dest_col = height_temp(2,b);

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
end
