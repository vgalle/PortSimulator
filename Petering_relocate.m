function  [selected_row, selected_col, selected_tier, same_row, ID_container_to_relocate,New]  = ...
    Petering_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers,Look_ahead)

% Last Modification: 2/2
% Virgile
global H



% H = length(Rows.Config_value(:,1));

blockID_this_container = Containers.Block(ID_this_container);
rowID_this_container = Containers.Row(ID_this_container);
col_this_container = Containers.Column(ID_this_container);

if within_same_row
    
    containers_ID_in_this_bay = Rows.Config_id(:,:,rowID_this_container);
    containers_value_in_this_bay = Rows.Config_value(:,:,rowID_this_container);

    height = Rows.Height(:,rowID_this_container);
    minimum = Rows.Minimum(:,rowID_this_container);
    %     We start with all possible col_this_container as candidate col_this_containers in the row
    %     target_cols=[r1    r2  ...   first row row is row ID
    %                  c1    c2  ...   second row is column number 
    %                  h1    h2  ...   third row is the height
    %                  m1    m2  ...   forth row is the minimum
    %                  t1    t2  ...]  fifth row is the top container
    target_cols = zeros(4,size(containers_ID_in_this_bay,2));
    target_cols(1,:) = rowID_this_container*ones(1,size(target_cols,2));
    target_cols(2,:) = 1:size(target_cols,2);
    target_cols(3,:) = height;
    target_cols(4,:) = minimum;
    for i=1:size(target_cols,2)
        if target_cols(3,i) == 0
            target_cols(5,i) = target_cols(4,i);
        else
            target_cols(5,i) = containers_value_in_this_bay(H-target_cols(3,i)+1,i);
        end
    end
    % We withdraw the col_this_container of the container to be moved
    loc_target_cols = target_cols;
    loc_target_cols(:,loc_target_cols(1,:)==rowID_this_container & loc_target_cols(2,:)==col_this_container)=[];
    
    % Then we suppress the ones that are full
    loc_target_cols = loc_target_cols(:,loc_target_cols(3,:) < H);

    % if still there is no column, look in other rows
    if isempty(loc_target_cols)
        within_same_row = 0;
    end
end

if within_same_row
    new_Look_ahead = min(Look_ahead,Rows.Number_cont(rowID_this_container));
    value_Look_ahead = sort(containers_value_in_this_bay(containers_value_in_this_bay~=0));
    ID_Look_ahead = zeros(1,new_Look_ahead);
    if numel(value_Look_ahead)==3 && new_Look_ahead >=4
        keyboard
    end
    for i=1:new_Look_ahead
        loc_ID_Look_ahead = Containers.ID(Containers.Block == blockID_this_container &...
            Containers.Row == rowID_this_container & Containers.Block_value == value_Look_ahead(i));
        ID_Look_ahead(i) = loc_ID_Look_ahead(1);
    end
    columns_to_consider = Give_columns(ID_Look_ahead,containers_ID_in_this_bay);
    other_columns = 1:size(containers_ID_in_this_bay,2);
    other_columns(columns_to_consider) = [];
    while length(columns_to_consider) == size(containers_ID_in_this_bay,2) || ...
            sum(target_cols(3,other_columns) == H * ones(1,length(other_columns))) == length(other_columns)
        new_Look_ahead = new_Look_ahead - 1;
        ID_Look_ahead = ID_Look_ahead(1:new_Look_ahead);
        columns_to_consider = Give_columns (ID_Look_ahead,containers_ID_in_this_bay);
        other_columns = 1:size(containers_ID_in_this_bay,2);
        other_columns(columns_to_consider) = [];
    end

    r = 1;
    found_good_cleaning_move = 0;
    while columns_to_consider(length(columns_to_consider)-r+1) ~= col_this_container && found_good_cleaning_move == 0;
        loc_top_container = target_cols(5,columns_to_consider(length(columns_to_consider)-r+1));
        loc_target_cols2 = target_cols;
        loc_target_cols2(:,columns_to_consider(length(columns_to_consider)-r+1))=[];
        if loc_top_container < max(loc_target_cols2(4,:)) && loc_top_container > target_cols(4,columns_to_consider(length(columns_to_consider)-r+1))
            found_good_cleaning_move = 1;
            ID_container_to_relocate = containers_ID_in_this_bay(H+1-target_cols(3,columns_to_consider(length(columns_to_consider)-r+1)),...
                columns_to_consider(length(columns_to_consider)-r+1));
        else
            r = r + 1;
        end    
    end
    if columns_to_consider(length(columns_to_consider)-r+1) == col_this_container
        [selected_row, selected_col, selected_tier, same_row] = Myopic_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers);
        ID_container_to_relocate = ID_this_container;
    else
        [selected_row, selected_col, selected_tier, same_row] = Myopic_relocate (ID_container_to_relocate, within_same_row, Blocks, Rows, Containers);
    end
else
    [selected_row, selected_col, selected_tier, same_row] = Myopic_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers);
    ID_container_to_relocate = ID_this_container;
end



    

                
    
    