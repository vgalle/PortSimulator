function [Blocks,Rows,Containers] = ...
    Relocate(relocate_ID,selected_row,selected_col,selected_tier,Blocks,Rows,Containers,Maxzone,same_row)

% Last Modification: 2/2
% Virgile

% This function updates the configuration when the relocation of the
% target container with relocate_ID to the coordinates selected_row, 
% selected_col, selected_tier is performed.

H = length(Rows.Config_value(:,1));

% We update both configurations value and id by settting the previous slot
% to 0 and the new one to the block value of the container and its ID.
Rows.Config_value(H-Containers.Tier(relocate_ID)+1,Containers.Column(relocate_ID),Containers.Row(relocate_ID)) = 0;
Rows.Config_value(H-selected_tier+1,selected_col,selected_row) = Containers.Block_value(relocate_ID);
Rows.Config_id(H-Containers.Tier(relocate_ID)+1,Containers.Column(relocate_ID),Containers.Row(relocate_ID)) = 0;
Rows.Config_id(H-selected_tier+1,selected_col,selected_row) = relocate_ID;
% We compute the heights of columns in the original row of relocated_ID and 
% its new row.
Rows.Height(:,Containers.Row(relocate_ID)) = heights_of_row(Rows.Config_value(:,:,Containers.Row(relocate_ID)));
Rows.Height(:,selected_row) = heights_of_row(Rows.Config_value(:,:,selected_row));
% Same for minimum
Rows.Minimum(:,Containers.Row(relocate_ID)) = mins_of_row(Rows.Config_value(:,:,Containers.Row(relocate_ID)),Blocks.Number_cont(Containers.Block(relocate_ID)));
Rows.Minimum(:,selected_row) = mins_of_row(Rows.Config_value(:,:,selected_row),Blocks.Number_cont(Containers.Block(relocate_ID)));
if same_row == 0
    Rows.Number_cont(Containers.Row(relocate_ID)) = Rows.Number_cont(Containers.Row(relocate_ID)) - 1;
    Rows.Number_cont(selected_row) = Rows.Number_cont(selected_row) + 1;
end
% Finally I update its coordinates with the new ones and add one to the
% number of relocations.
Containers.Row(relocate_ID) = selected_row;
Containers.Column(relocate_ID) = selected_col;
Containers.Tier(relocate_ID) = selected_tier;
Containers.Number_reloc(relocate_ID) = Containers.Number_reloc(relocate_ID) + 1;

