function  [selected_row, selected_col, selected_tier, same_row]  = ...
    Closest_relocate (ID_this_container, Blocks, Rows, Containers)

% Last Modification: 2/2
% Setareh

global H
% the Closest heuristic tries to place an incoming (or reshuffling)
% container in a column that is the closest to its original slot.

% within_same_row = 1 (true) or 0(false) is not used here since we always
% select the same row if that is possible

blockID_this_container = Containers.Block(ID_this_container);
rowID_this_container = Containers.Row(ID_this_container);
col_this_container = Containers.Column(ID_this_container);

%     target_cols=[r1    r2  ...   first row is row ID
%                  c1    c2  ...   second row is column number 
%                  h1    h2  ...]  third row is the height
counter = 1;
rowsID_in_this_block = Blocks.Rows_in_block(:,blockID_this_container);
target_cols = zeros(3,0);
for r=1:size(rowsID_in_this_block,1)
    containersID_in_this_row = Rows.Config_id(:,:,rowsID_in_this_block(r));
    for c=1:size(containersID_in_this_row,2)
        target_cols(1,counter) = rowsID_in_this_block(r);
        target_cols(2,counter) = c;
        target_cols(3,counter) = Rows.Height(c,rowsID_in_this_block(r));
        counter = counter + 1;
    end
end

% eliminate the column of this container 
target_cols(:,target_cols(1,:)==rowID_this_container & target_cols(2,:)==col_this_container)=[];

% eliminate full columns
target_cols = target_cols(:,target_cols(3,:)<H);

% Find the closests columns
min_distance_row = min(abs(target_cols(1,:) - rowID_this_container));
target_cols = target_cols(:,abs(target_cols(1,:) - rowID_this_container)<= min_distance_row);
min_distance = min(abs(target_cols(2,:) - col_this_container));
target_cols = target_cols(:,abs(target_cols(2,:) - col_this_container)<= min_distance);
% break any further tie by moving to the column with smallest index 
target_cols = target_cols(:,target_cols(2,:)==min(target_cols(2,:)));

selected_row = target_cols(1);
selected_col = target_cols(2);
selected_tier = Rows.Height(selected_col,selected_row)+1;
same_row = selected_row==rowID_this_container;