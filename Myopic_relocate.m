function  [selected_row, selected_col, selected_tier, same_row]  = ...
    Myopic_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers)

% Last Modification: 2/2
% Virgile
global H 

column = Containers.Column(ID_this_container);

value = Containers.Block_value(ID_this_container);

R = length(Blocks.Rows_in_block(:,1));
C = size(Rows.Config_value,2);
% H = length(Rows.Config_value(:,1));

blockID_this_container = Containers.Block(ID_this_container);
rowID_this_container = Containers.Row(ID_this_container);
col_this_container = Containers.Column(ID_this_container);


% If we only consider moves in the same row
if within_same_row
    
    minimum = Rows.Minimum(:,rowID_this_container);
    height = Rows.Height(:,rowID_this_container);
    
    % We start with all possible col_this_container as candidate col_this_containers in the row
    target_col = 1:length(minimum);
    
    % We withdraw the col_this_container of the container to be moved
    target_col(col_this_container) = [];
    
    % Then we suppress the ones that are full
    target_col = target_col(height(target_col)<H);

    % if still there is no column, look in other rows
    if isempty(target_col)
        display('there is no slot for relocation; so looking at other rows');
        within_same_row = 0;
    end
end

if within_same_row
    % Here we check if there is a possible good move
    M = max(minimum(target_col));
    if M <= value
    % if no possible good move exists, we delay the most the next relocation
      target_col = target_col(minimum(target_col) == M);
    % if there is a good move possible
    else
        target_col = target_col(minimum(target_col) > value);
        m = min(minimum(target_col));
        target_col = target_col(minimum(target_col) == m);
    end
    
    % If there is still a draw, we take the highest col_this_container(s)
        target_col = target_col(height(target_col) == max(height(target_col)));
    % Then we take the one(s) that is(are) the closest to the col_this_container

        target_col = target_col(abs(target_col-col_this_container) == min(abs(target_col-col_this_container)));
    % Finally we break the tie by piking the one on the left.
        selected_col = target_col(1);
        selected_row = rowID_this_container;
        selected_tier = height(selected_col) + 1;

else
    
% % %     % Otherwise we consider all col_this_containers in the block.
% % %     minimum = Rows.Minimum(:,rowID_this_container);
% % %     height = Rows.Height(:,rowID_this_container);
% % %     % We start with all possible col_this_container as candidate col_this_containers in the row
% % %     target_col = 1:length(minimum);
% % %     % We withdraw the col_this_container of the container to be moved
% % %     target_col(col_this_container) = [];
% % %     % Then we suppress the ones that are full
% % %     target_col = target_col(height(target_col)<H);
% % %     % Here we check if there is a possible good move
% % %     M = max(minimum(target_col));
    
% % %     if M > value
% % %         % If there is a possible move in the row if ID_this_container
% % %         target_col = target_col(minimum(target_col) > value);
% % %         m = min(minimum(target_col));
% % %         target_col = target_col(minimum(target_col) == m);
% % %         % If there is still a draw, we take the highest col_this_container(s)
% % %         target_col = target_col(height(target_col) == max(height(target_col)));
% % %         % Then we take the one(s) that is(are) the closest to the col_this_container
% % %         target_col = target_col(abs(target_col-col_this_container) == min(abs(target_col-col_this_container)));
% % %         % Finally we break the tie by piking the one on the left.
% % %         selected_col = target_col(1);
% % %         selected_row = rowID_this_container;
% % %         selected_tier = height(selected_col) + 1;
% % %     else
        minimum_1 = Rows.Minimum(:,Blocks.Rows_in_block(:,blockID_this_container));
        height_1 = Rows.Height(:,Blocks.Rows_in_block(:,blockID_this_container));
        M1 = 0;
        target1_row = inf;
        target1_col = inf;
        row_index = find(Blocks.Rows_in_block(:,blockID_this_container)==rowID_this_container);
        for r=1:R
            for c=1:C
%                 if r~=row_index && minimum_1(c,r) >= M1 && height_1(c,r) < H
                if minimum_1(c,r) >= M1 && height_1(c,r) < H
                    if (r==row_index && c~=column) || r~=row_index
                        if minimum_1(c,r) == M1 && abs(r-row_index) < abs(target1_row-row_index)

                            M1 = minimum_1(c,r);
                            target1_row = r;
                            target1_col = c;
                        elseif minimum_1(c,r) > M1
                            M1 = minimum_1(c,r);
                            target1_row = r;
                            target1_col = c;
                        end
                    end
                end
            end
        end
        
% % %         if M1 <= value
% % %             
% % %             % If there is no possible good move in the other rows
% % %             target_col = target_col(minimum(target_col) == M);
% % %             % If there is still a draw, we take the highest col_this_container(s)
% % %             target_col = target_col(height(target_col) == max(height(target_col)));
% % %             % Then we take the one(s) that is(are) the closest to the col_this_container
% % %             target_col = target_col(abs(target_col-col_this_container) == min(abs(target_col-col_this_container)));
% % %             % Finally we break the tie by piking the one on the left.
% % %             selected_row = rowID_this_container;
% % %             selected_col = target_col(1);
% % %             selected_tier = height(selected_col) + 1;
% % %         else
            temp = Blocks.Rows_in_block(:,blockID_this_container);
            selected_row = temp(target1_row);
            selected_col = target1_col;
            selected_tier = height_1(selected_col,target1_row) + 1;
% % %     end    
% % %     end
end
    
same_row = within_same_row;
    

                
    
    