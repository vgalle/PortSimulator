function  [selected_block, Blocks] = ...
    KimHong_block_allocation (ID_this_container, chosen_blocks, Blocks, Rows, Containers,EN)

global H

value = Containers.Block_value(ID_this_container);

%     We start with all possible col_this_container as candidate
%     col_this_containers in the block
%     target_cols=[r1    r2  ...   first row row is row ID
%                  c1    c2  ...   second row is column number 
%                  h1    h2  ...   third row is the height
%                  m1    m2  ...   forth row is the minimum
%                  R1    R2  ...]  fifth row is the R score of ENAR

target_cols = zeros(5,0);
counter = 1;
for b=1:length(chosen_blocks)
    rowsID_in_this_blocks = Blocks.Rows_in_block(:,chosen_blocks(b)); 
    T = round(mean(mean(Rows.Height(:,chosen_blocks(b)))));
    N = Blocks.Number_cont(chosen_blocks(b));
    for r=1:size(rowsID_in_this_blocks,1)
        containersID_in_this_row = Rows.Config_id(:,:,rowsID_in_this_blocks(r));
        for c=1:size(containersID_in_this_row,2)
            target_cols(1,counter) = rowsID_in_this_blocks(r);
            target_cols(2,counter) = c;
            target_cols(3,counter) = Rows.Height(c,rowsID_in_this_blocks(r));
            target_cols(4,counter) = Rows.Minimum(c,rowsID_in_this_blocks(r));
            if target_cols(3,counter) < H-1
                target_cols(5,counter) = EN_access((target_cols(3,counter) < H-1)*max(1,T-(target_cols(3,counter)+1)),min(target_cols(4,counter),value),N,max(T,target_cols(3,counter)+2),EN) ...
                - EN_access(max(1,T-target_cols(3,counter)),target_cols(4,counter),N,max(T,target_cols(3,counter)+1),EN) + 1 + (value>target_cols(4,counter));
            elseif target_cols(3,counter) == H-1
                target_cols(5,counter) = EN_access((target_cols(3,counter) < H-1)*max(1,T-(target_cols(3,counter)+1)),min(target_cols(4,counter),value),N,max(T,target_cols(3,counter)+1),EN) ...
                + 1 + (value>target_cols(4,counter));
            end
            counter = counter+1;
        end
    end
end

%     eliminate full columns
target_cols = target_cols(:,target_cols(3,:) < H);

%     find minimum R (according to the KimHong heuristic)
min_R = min(target_cols(5,:));

%     find which column(s) have minimum weight
loc_min = find(target_cols(5,:) == min_R);

cols_with_min_R = zeros(5,length(loc_min));
cols_with_min_R(1,:) = target_cols(1,loc_min); %row
cols_with_min_R(2,:) = target_cols(2,loc_min); %column
cols_with_min_R(3,:) = target_cols(3,loc_min); %height
cols_with_min_R(4,:) = target_cols(4,loc_min); %minimum
cols_with_min_R(5,:) = repmat(min_R, [1 , length(loc_min)]); %R

%     break further tie by moving to closest to the ship meaning the one
%     with the smallest row index and column index
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(1,:)==min(cols_with_min_R(1,:)));
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(2,:)==min(cols_with_min_R(2,:)));


selected_row = cols_with_min_R(1);
selected_block = Rows.Block(selected_row);

Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
Blocks.unassigned_slots_to_ships(selected_block) =Blocks.unassigned_slots_to_ships(selected_block)+1;
    