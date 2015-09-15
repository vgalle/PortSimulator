% number of containers with earlier dep time than the relocating one

function col_with_min_RI = compute_min_RI2(bay,maxKnown,to_be_relocated,col_to_be_relocated,Tstar,time)
CC = size(bay,2);
HH = size(bay,1);
maxN = (HH-1)*CC;
RI_all_cols = zeros(3,CC);
RI_all_cols(1,:) = 1:CC;

relocating = to_be_relocated;
if time<Tstar
     bay(bay>maxKnown) = maxN+1;
     relocating = to_be_relocated*(to_be_relocated<=maxKnown) + ...
         ( (maxN+1) * (to_be_relocated>maxKnown)) ;
end
for c=1:CC
    this_temp_col = bay(:,c);
    height_this_temp_col = sum(this_temp_col>0);
    RI_all_cols(3,c) = height_this_temp_col;
    if height_this_temp_col==HH || c == col_to_be_relocated
            RI_all_cols(2,c) = inf;
        else
        this_temp_col(HH - height_this_temp_col) = relocating;

%         this_temp_col(this_temp_col==0) = inf;
%         [~ , loc_earliest] = min(this_temp_col);
%         RI_all_cols(2,c) = loc_earliest - HH + height_this_temp_col;
        tier_relocating_from_top = HH-height_this_temp_col;
        RI_all_cols(2,c) = sum(this_temp_col(tier_relocating_from_top+1:HH)< this_temp_col(tier_relocating_from_top));
        num_unknown_below_relocating = sum(this_temp_col(tier_relocating_from_top+1:HH)==this_temp_col(tier_relocating_from_top));
%         if num_unknown_below_relocating>0
%             keyboard
%         end
        % if all unknwon, then compute expected RI
%         if sum(this_temp_col==maxN) == length(this_temp_col)
            RI_all_cols(2,c) = RI_all_cols(2,c) + ((num_unknown_below_relocating==0)*0)+...
                               ((num_unknown_below_relocating==1)*1/2) +... 
                               ((num_unknown_below_relocating==2)*1) + ...
                               ((num_unknown_below_relocating==3)*3/2);
%         end
    end
end
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