function  [selected_block, tempRows, Blocks] = LowHeight_block_allocation (ID_this_container,chosen_blocks, Blocks, Rows)

% Last Modification: 2/8
% Virgile


    
R = size(Blocks.Rows_in_block,1);
C = size(Rows.Config_value,2);
H = size(Rows.Config_value,1);

if length(chosen_blocks)==1 && Blocks.Free_spots(chosen_blocks)>0
    selected_block = chosen_blocks;
    Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
    tempRows = Rows;
    return
end

chosen_blocks = sort(chosen_blocks);
h = inf;
selected_block = inf;
queue_length_selected_block = inf;
% selected_row = inf;
% selected_col = inf;


for b=1:length(chosen_blocks)
    queue_length_this_block = Blocks.num_containers_to_be_stacked_here(chosen_blocks(b));
    height = Rows.Height(:,Blocks.Rows_in_block(:,chosen_blocks(b)));
    for r=1:R
        for c=1:C
            if height(c,r) < h && height(c,r) < H && queue_length_this_block <= queue_length_selected_block
                h = height(c,r);
                selected_block = chosen_blocks(b);
                queue_length_selected_block = queue_length_this_block;
                selected_row = Blocks.Rows_in_block(r,selected_block);
                selected_col = c;
            end
        end
    end
end
% selected_tier = height(selected_col,selected_row) + 1;
tempHeight = Rows.Height(selected_col,selected_row);

selected_tier = H - tempHeight;
    
Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
Blocks.unassigned_slots_to_ships(selected_block) =Blocks.unassigned_slots_to_ships(selected_block)+1;
  
tempRows = Rows;
tempRows.Height (selected_col,selected_row) = tempRows.Height (selected_col,selected_row) +1;
tempRows.Config_id(selected_tier , selected_col, selected_row) = ID_this_container;

                
    
    