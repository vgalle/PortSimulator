% number of containers that should be relocated to retrieve the earliest
function col_with_min_RI = compute_min_RI(bay,maxKnown,to_be_relocated,col_to_be_relocated,Tstar,time)
CC = size(bay,2);
HH = size(bay,1);
maxN = (HH-1)*CC;
RI_all_cols = zeros(3,CC);
RI_all_cols(1,:) = 1:CC;

if time<Tstar
     bay(bay>maxKnown) = maxN+1;
     to_be_relocated = to_be_relocated*(to_be_relocated<=maxKnown) + ...
         ( (maxN+1) * (to_be_relocated>maxKnown)) ;
end

for c=1:CC
    this_temp_col = bay(:,c);
    height_this_temp_col = sum(this_temp_col>0);
    RI_all_cols(3,c) = height_this_temp_col;
    if height_this_temp_col==HH || c == col_to_be_relocated
            RI_all_cols(2,c) = inf;
        else
        this_temp_col(HH - height_this_temp_col) = to_be_relocated;
        this_temp_col(this_temp_col==0) = inf;
        [~ , loc_earliest] = min(this_temp_col);
        RI_all_cols(2,c) = loc_earliest - HH + height_this_temp_col;
        % if all unknwon, then compute expected RI
        if sum(this_temp_col==maxN) == length(this_temp_col)
            RI_all_cols(2,c) = ((length(this_temp_col)==1)*0)+...
                               ((length(this_temp_col)==2)*1/2) +... 
                               ((length(this_temp_col)==3)*1) + ...
                               ((length(this_temp_col)==4)*3/2);
        end
    end
end
% RI_all_cols(2,:)
min_RI = min(RI_all_cols(2,:));
loc_min = find(RI_all_cols(2,:) == min_RI);
col_with_min_RI = zeros(3,length(loc_min));
col_with_min_RI(1,:) = RI_all_cols(1,loc_min);
col_with_min_RI(2,:) = RI_all_cols(2,loc_min);
col_with_min_RI(3,:) = RI_all_cols(3,loc_min);  %height

% picke the highest
col_with_min_RI = col_with_min_RI(:,col_with_min_RI(3,:)>=max(col_with_min_RI(3,:)));
%     break further tie by moving to closest
min_col_index = min(col_with_min_RI(1,:));
col_with_min_RI = col_with_min_RI(:,col_with_min_RI(1,:)==min_col_index);
end