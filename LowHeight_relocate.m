function  [selected_row, selected_col, selected_tier, same_row]  = ...
    LowHeight_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers)

% Last Modification: 9/17
% Virgile

column = Containers.Column(ID_this_container);
R = length(Blocks.Rows_in_block(:,1));
C = size(Rows.Config_value,2);
H = size(Rows.Config_value,1);

blockID_this_container = Containers.Block(ID_this_container);
rowID_this_container = Containers.Row(ID_this_container);


% If we only consider moves in the same row
if within_same_row
    height = Rows.Height(:,Containers.Row(ID_this_container));
% We start with all possible column as candidate columns in the row
    target_col = 1:length(height);
% We withdraw the column of the container to be moved
    target_col(column) = [];
% Then we suppress the ones that are full
    target_col = target_col(height(target_col)<H);
% We take the lowest column(s)
    target_col = target_col(height(target_col) == min(height(target_col)));
% Then we take the one(s) that is(are) the closest to the column
    target_col = target_col(abs(target_col-column) == min(abs(target_col-column)));
end

if ~isempty (target_col)
    % Finally we break the tie by piking the one on the left.
    selected_col = target_col(1);
    selected_row = Containers.Row(ID_this_container);
    selected_tier = height(selected_col) + 1;
else
    within_same_row = 0;
end

% If we allow for relocations in different rows
if ~within_same_row
    height_1 = Rows.Height(:,Blocks.Rows_in_block(:,Containers.Block(ID_this_container)));
    h1 = inf;
    target1_row = inf;
    target1_col = inf;
    row_index = find(Blocks.Rows_in_block(:,blockID_this_container)==rowID_this_container);
    for r=1:R
        for c=1:C
            if height_1(c,r) <= h1 && height_1(c,r) < H
                if (r==row_index && c~=column) || r~=row_index
                    if height_1(c,r) == h1 && abs(r-row_index) < abs(target1_row-row_index)
                        h1 = height_1(c,r);
                        target1_row = r;
                        target1_col = c;
                    elseif height_1(c,r) < h1
                        h1 = height_1(c,r);
                        target1_row = r;
                        target1_col = c;
                    end
                end
            end
        end
    end
    temp = Blocks.Rows_in_block(:,blockID_this_container);
    selected_row = temp(target1_row);
    selected_col = target1_col;
    selected_tier = height_1(selected_col,target1_row) + 1;                       
end
    
same_row = within_same_row;
                
    
    