function  [selected_block, selected_row, selected_col, selected_tier]  = ...
    LowHeight_stack (chosen_blocks, Blocks, Rows)

% Last Modification: 2/8
% Virgile

R = length(Blocks.Rows_in_block(:,1));
C = size(Rows.Config_value,2);
H = size(Rows.Config_value,1);

chosen_blocks = sort(chosen_blocks);
h = inf;
selected_block = inf;
selected_row = inf;
selected_col = inf;
for b=1:length(chosen_blocks)
    height = Rows.Height(:,Blocks.Rows_in_block(:,chosen_blocks(b)));
    for r=1:R
        for c=1:C
            if height(c,r) < h && height(c,r) < H
                h = height(c,r);
                selected_block = chosen_blocks(b);
                selected_row = Blocks.Rows_in_block(r,selected_block);
                selected_col = c;   
            end
        end
    end
end
selected_tier = Rows.Height(selected_col,selected_row)+1;
    
    
                
    
    