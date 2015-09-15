function  [selected_block, selected_row, selected_col, selected_tier,Row_counter,Col_counter] = ...
    Closest_stack (chosen_blocks, Blocks, Rows,Row_counter,Col_counter)

% Last Modification: 2/2
% Setareh

% the ATIB heuristic tries to place an incoming (or reshuffling)
% container in a column with the latest average departure time.

global H

R = ceil(size(Rows.ID)/size(Blocks.ID));
C = size(Rows.Config_value,2);

temp_Block_counter = chosen_blocks(1);
temp_Row_counter = Row_counter;
temp_Col_counter = Col_counter;

while Rows.Number_cont((temp_Block_counter-1)*R+temp_Row_counter) >= H*C - (H-1)
    if temp_Row_counter >= R;
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
selected_tier = Rows.Height(selected_col,selected_row)+1;

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
