function  [selected_block, Blocks] = ...
    Myopic_block_allocation (ID_this_container, chosen_blocks, Blocks, Rows, Containers)

% Last Modification: 9/16
% Seatreh

% We first compute the value of the target to be stacked as well as the
% dimension of our problem R and C.

global H

if length(chosen_blocks)==1 && Blocks.Free_spots(chosen_blocks)>0
    selected_block = chosen_blocks;
    Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
    return
end

% if there is no lot for stacking, give error
is_there_a_slot = double(sum(Blocks.Free_spots(chosen_blocks))>0);

full_blocks = Blocks.Free_spots(chosen_blocks)==0;
chosen_blocks (full_blocks) =[];
if ~is_there_a_slot
    selected_block = 0;
    display('no block was allocated!');
    return
end

R = length(Blocks.Rows_in_block(:,1));
C = size(Rows.Config_value,2);

% The Min_good variable is the best minimum found so far in a good column.
% R_good and C_good are the coordinates in the matrix minimum where
% Min_good is located. All are infinite if there are no good column in the
% columns of the rows of the chosen blocks.
% It is symetric for the bad case. Except that we set Min_bad to 0 because
% the want to maximize the min when we only have bad columns.
Min_good = Inf;

Min_bad = 0;

% We sort chosen_blocks because we prefer blocks in order to break ties
% between blocks. We chose the block with smallest index which is supposed
% to be closer to the ship.
chosen_blocks = sort(chosen_blocks);

queue_length_selected_block = inf;

for b=1:length(chosen_blocks)
    rows_this_block = Blocks.Rows_in_block(:,chosen_blocks(b));
    minimum = Rows.Minimum(:,rows_this_block);
    height = Rows.Height(:,rows_this_block);
    ID_containers_this_block = Containers.ID(:,Containers.Block==b  & Containers.Status==0);   % exclude those that were planned to be stacked in this block but have not yet been stacked (status=-2)
    
    dep_time_temp = [];
    dep_time_temp(1,:) = Containers.Departure_time([ID_containers_this_block ID_this_container]);
    dep_time_temp(2,:) = [ID_containers_this_block ID_this_container];
    
    [~,index_dep_time_temp_sorted] = sort(dep_time_temp(1,:));
    dep_time_temp_sorted = dep_time_temp( :,index_dep_time_temp_sorted);
    
    value = find(dep_time_temp_sorted(2,:)==ID_this_container);
    
    queue_length_this_block = Blocks.num_containers_to_be_stacked_here(chosen_blocks(b));
    
    for r=1:R
        for c=1:C
            if height(c,r)~=H 
% In that case, we found a good column and we only take a new column if its
% minimum is smaller that the previous one.
                if minimum(c,r) > value && minimum(c,r) < Min_good 
                    Min_good = minimum(c,r);
                    B_good = b;
                    queue_length_selected_block = queue_length_this_block;

% In the other case, we have a bad column: we only consider it if we did
% not find a good column yet. In that case, we consider it if its minimum
% is larger that our previous bad column.
                elseif minimum(c,r) <= value && minimum(c,r) > Min_bad && Min_good == Inf
                    Min_bad = minimum(c,r);
                    B_bad = b;
                    queue_length_selected_block = queue_length_this_block;
                    
                elseif  minimum(c,r) > value && minimum(c,r) == Min_good  && queue_length_this_block<queue_length_selected_block
                    Min_good = minimum(c,r);
                    B_good = b;
                    queue_length_selected_block = queue_length_this_block;
                    
                elseif  minimum(c,r) <= value && minimum(c,r) == Min_bad  && Min_good == Inf && queue_length_this_block<queue_length_selected_block
                    Min_bad = minimum(c,r);
                    B_bad = b;
                    queue_length_selected_block = queue_length_this_block;

                end
            end
        end
    end
end

% Finally we output the coordinate of the slot where to stack the
% container.
if Min_good ~= Inf
    selected_block = chosen_blocks(B_good);
else
    selected_block = chosen_blocks(B_bad);
end
Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
Blocks.unassigned_slots_to_ships(selected_block) =Blocks.unassigned_slots_to_ships(selected_block)+1;



