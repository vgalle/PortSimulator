function  [selected_block, selected_row, selected_col, selected_tier] = ...
    Myopic_stack (ID_this_container, chosen_blocks, Blocks, Rows, Containers)

% Last Modification: 9/16
% Setareh

% We first compute the value of the target to be stacked as well as the
% dimension of our problem R and C.

global H

R = length(Blocks.Rows_in_block(:,1));
C = size(Rows.Config_value,2);

% The Min_good variable is the best minimum found so far in a good column.
% R_good and C_good are the coordinates in the matrix minimum where
% Min_good is located. All are infinite if there are no good column in the
% columns of the rows of the chosen blocks.
% It is symetric for the bad case. Except that we set Min_bad to 0 because
% the want to maximize the min when we only have bad columns.
Min_good = Inf;
R_good = Inf;
C_good = Inf;
Min_bad = 0;
R_bad = Inf;
C_bad = Inf;
% We sort chosen_blocks because we prefer blocks in order to break ties
% between blocks. We chose the block with smallest index which is suppose
% to be closer to the ship.
chosen_blocks = sort(chosen_blocks);


for b=1:length(chosen_blocks)
    rows_this_block = Blocks.Rows_in_block(:,chosen_blocks(b));
    minimum = Rows.Minimum(:,rows_this_block);
    height = Rows.Height(:,rows_this_block);
    ID_containers_this_block = Containers.ID(:,Containers.Block==b  & Containers.Status==0);   % exclude those that were planned to be stacked in this block but have not yet been stacked (status=-2)
    
    dep_time_temp(1,:) = Containers.Departure_time([ID_containers_this_block ID_this_container]);
    dep_time_temp(2,:) = [ID_containers_this_block ID_this_container];
    
    [~,index_dep_time_temp_sorted] = sort(dep_time_temp(1,:));
    dep_time_temp_sorted = dep_time_temp( :,index_dep_time_temp_sorted);
    
    value = find(dep_time_temp_sorted(2,:)==ID_this_container);
    
    for r=1:R
        for c=1:C
            if height(c,r)~=H 
% In that case, we found a good column and we only take a new column if its
% minimum is smaller that the previous one.
                if minimum(c,r) > value && minimum(c,r) < Min_good
                    Min_good = minimum(c,r);
                    B_good = b;
                    R_good = r;
                    C_good = c;
% In the other case, we have a bad column: we only consider it if we did
% not find a good column yet. In that case, we consider it if its minimum
% is larger that our previous bad column.
                elseif minimum(c,r) <= value && minimum(c,r) > Min_bad && Min_good == Inf
                    Min_bad = minimum(c,r);
                    B_bad = b;
                    R_bad = r;
                    C_bad = c;
                end
            end
        end
    end
end

% Finally we output the coordinate of the slot where to stack the
% container.
if Min_good ~= Inf
    selected_block = chosen_blocks(B_good);
    selected_row = Blocks.Rows_in_block(R_good,selected_block);
    selected_col = C_good;
    selected_tier = Rows.Height(C_good,selected_row)+1;
else
    selected_block = chosen_blocks(B_bad);
    selected_row = Blocks.Rows_in_block(R_bad,selected_block);
    selected_col = C_bad;
    selected_tier = Rows.Height(C_bad,selected_row)+1;
end




