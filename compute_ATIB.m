function col_with_min_ave_dep_time = compute_ATIB(bay,maxKnown,to_be_relocated,col_to_be_relocated,Tstar,time)
CC = size(bay,2);
HH = size(bay,1);
% maxN = max(max(bay));
maxN = (HH-1)*CC;

ave_dep_time_all_cols = zeros(3,CC);
ave_dep_time_all_cols(1,:) = 1:CC;
if time<Tstar
    bay(bay>maxKnown) = maxN+1;
end
for c=1:CC
    this_temp_col = bay(:,c);
    height_this_temp_col = sum(this_temp_col>0);
    ave_dep_time_all_cols(3,c) = height_this_temp_col;
%     if height_this_temp_col==HH || c == col_to_be_relocated
%             ave_dep_time_all_cols(2,c) = inf;
%     else
        tempDepTime = this_temp_col(this_temp_col>0);
        mean_tempDepTime = mean(tempDepTime);
        ave_dep_time_all_cols(2,c) = mean_tempDepTime;
        if isempty(tempDepTime)
            ave_dep_time_all_cols(2,c) = inf;
        end
 
%     end
end

relocating = to_be_relocated;
if time<Tstar
     bay(bay>maxKnown) = maxN+1;
     relocating = to_be_relocated*(to_be_relocated<=maxKnown) + ...
         ( (maxN+1) * (to_be_relocated>maxKnown)) ;
end

ave_dep_time_all_cols(4,:) = double(ave_dep_time_all_cols(1,:) < relocating);  %weights

% eliminate full columns and column of the relocating container
ave_dep_time_all_cols(:,ave_dep_time_all_cols(3,:)==HH)=[];
ave_dep_time_all_cols(:,ave_dep_time_all_cols(1,:)==col_to_be_relocated)=[];


% find minimum weight (either 0 or 1)
min_weight = min(ave_dep_time_all_cols(4,:));

% find which column(s) have minimum weight
loc_min = find(ave_dep_time_all_cols(4,:) == min_weight);

% build a new matrix for columns with minimum weight
cols_with_min_weight = zeros(4,length(loc_min));
cols_with_min_weight(1,:) = ave_dep_time_all_cols(1,loc_min); %column
cols_with_min_weight(2,:) = ave_dep_time_all_cols(2,loc_min); %average departure time
cols_with_min_weight(3,:) = ave_dep_time_all_cols(3,loc_min); %height
cols_with_min_weight(4,:) = repmat(min_weight, [1 , length(loc_min)]); %weight

if size(cols_with_min_weight,2)==1
    col_with_min_ave_dep_time = cols_with_min_weight(1);
else
    
    % break tie using RI and then height and then arbitrarily
        tempBay_to_compute_RI = bay(:,cols_with_min_weight(1,:));
        CC2 = size(tempBay_to_compute_RI,2);
        for c=1:CC2
            RI_all_cols(1,c) = cols_with_min_weight(1,c);
            this_temp_col = tempBay_to_compute_RI(:,c);
            height_this_temp_col = sum(this_temp_col>0);
            RI_all_cols(3,c) = height_this_temp_col;
            this_temp_col(HH - height_this_temp_col) = relocating;
            this_temp_col(this_temp_col==0) = inf;
            tier_relocating_from_top = HH-height_this_temp_col;
            RI_all_cols(2,c) = sum(this_temp_col(tier_relocating_from_top+1:HH)< this_temp_col(tier_relocating_from_top));
            num_unknown_below_relocating = sum(this_temp_col(tier_relocating_from_top+1:HH)==this_temp_col(tier_relocating_from_top));

            RI_all_cols(2,c) = RI_all_cols(2,c) + ((num_unknown_below_relocating==0)*0)+...
                               ((num_unknown_below_relocating==1)*1/2) +... 
                               ((num_unknown_below_relocating==2)*1) + ...
                               ((num_unknown_below_relocating==3)*3/2);

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

        col_with_min_ave_dep_time = col_with_min_RI;
end
end
    


    