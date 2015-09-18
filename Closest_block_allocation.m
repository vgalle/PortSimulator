function  [selected_block, tempRows, Blocks,Block_counter,Row_counter,Col_counter] = ...
    Closest_block_allocation (ID_this_container, chosen_blocks, Blocks, Rows,Block_counter,Row_counter,Col_counter)

% Last Modification: 9/16
% Setareh

% the ATIB heuristic tries to place an incoming (or reshuffling)
% container in a column with the latest average departure time.

global H

B = size(Blocks.ID,2);
R = ceil(size(Rows.ID,2)/size(Blocks.ID,2));
C = size(Rows.Config_value,2);

temp_Block_counter = Block_counter;
temp_Row_counter = Row_counter;
temp_Col_counter = Col_counter;

while sum(chosen_blocks==temp_Block_counter)==0
    if temp_Block_counter >= B
        temp_Block_counter = 1;
    else
        temp_Block_counter = temp_Block_counter + 1;
    end
end

while Rows.Number_cont((temp_Block_counter-1)*R+temp_Row_counter) >= H*C - (H-1)
    if temp_Row_counter == R;
        temp_Block_counter = temp_Block_counter + 1;
        while sum(chosen_blocks==temp_Block_counter)==0
            if temp_Block_counter >= B
                temp_Block_counter = 1;
            else
                temp_Block_counter = temp_Block_counter + 1;
            end
        end
        temp_Row_counter = 1;
    else
        temp_Row_counter = temp_Row_counter + 1;
    end
end

while Rows.Height(temp_Col_counter,(temp_Block_counter-1)*R+temp_Row_counter) >= H
    if temp_Col_counter == C
        temp_Col_counter = 1;
    else
        temp_Col_counter = temp_Col_counter + 1;
    end
end

selected_block = temp_Block_counter;
selected_row = (temp_Block_counter-1)*R+temp_Row_counter;
selected_col = temp_Col_counter;
tempHeight = Rows.Height(selected_col,selected_row);

Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
Blocks.unassigned_slots_to_ships(selected_block) =Blocks.unassigned_slots_to_ships(selected_block)+1;
tempRows = Rows;
tempRows.Height (selected_col,selected_row) = tempRows.Height (selected_col,selected_row) +1;
tempRows.Config_id(H - tempHeight, selected_col, selected_row) = ID_this_container;

if temp_Block_counter == B
    Block_counter = 1;
else
    Block_counter = temp_Block_counter + 1;
end
if temp_Row_counter == R
    Row_counter = 1;
else
    Row_counter = temp_Row_counter + 1;
end
if temp_Col_counter == C
    Col_counter = 1;
else
    Col_counter = temp_Col_counter + 1;
end
