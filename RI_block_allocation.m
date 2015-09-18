function  [selected_block, tempRows, Blocks] = ...
    RI_block_allocation (ID_this_container, chosen_blocks, Blocks, Rows, Containers)

% The RI heuristic computes a “reshuffling index” which is defined as
% The RI of the column withrespect to an incoming or reshuffled 
% container is the number of containers in the column that should 
% be retrieved earlier than the incoming container.
% Then, an incoming or reshuffling container is
% placed on the column with the lowest RI. 

% Last Modification: 9/16
% Virgile

global H 

value = Containers.Departure_time(ID_this_container);
zone_incoming = Containers.Departure_zone(ID_this_container);

%     We start with all possible col_this_container as candidate
%     col_this_containers in the block
%     target_cols=[r1    r2  ...   first row row is row ID
%                  c1    c2  ...   second row is column number 
%                  h1    h2  ...   third row is the height
%                  m1    m2  ...   forth row is the minimum
%                  R1    R2  ...]  fifth row is the RI
%                  B1    B2  ...]  sixth row is the block ID

target_cols = zeros(5,0);
counter = 1;
for b=1:length(chosen_blocks)
    rowsID_in_this_blocks = Blocks.Rows_in_block(:,chosen_blocks(b)); 
    for r=1:size(rowsID_in_this_blocks,1)
        containersID_in_this_row = Rows.Config_id(:,:,rowsID_in_this_blocks(r));
        for c=1:size(containersID_in_this_row,2)
            target_cols(1,counter) = rowsID_in_this_blocks(r);
            target_cols(2,counter) = c;
            target_cols(3,counter) = Rows.Height(c,rowsID_in_this_blocks(r));
            target_cols(4,counter) = Rows.Minimum(c,rowsID_in_this_blocks(r));

            config_id_this_column = containersID_in_this_row(:,c);
            dep_time_this_column = Containers.Departure_time(config_id_this_column(config_id_this_column~=0)); 

            tempZone =  Containers.Departure_zone(config_id_this_column(config_id_this_column>0));

            % in the sace of incomplete info
            if sum(Containers.Departure_zone)>0
                num_smaller_zone_below_new_container = sum(tempZone<zone_incoming);
                num_same_zone_below_new_container = sum(tempZone==zone_incoming);
                target_cols(5,counter) = num_smaller_zone_below_new_container + ((num_same_zone_below_new_container==0)*0)+...
                                   ((num_same_zone_below_new_container==1)*1/2) +... 
                                   ((num_same_zone_below_new_container==2)*1) + ...
                                   ((num_same_zone_below_new_container==3)*3/2);

            % in the case of complete info
            else
                target_cols(5,counter) = sum(dep_time_this_column<value);        
            end
            
            target_cols(6,counter) = chosen_blocks(b);
            counter = counter + 1;
        end
    end
end

%     eliminate full columns
target_cols = target_cols(:,target_cols(3,:) < H);

%     find minimum R (according to the KimHong heuristic)
min_R = min(target_cols(5,:));

%     find which column(s) have minimum weight
loc_min = find(target_cols(5,:) == min_R);

cols_with_min_R = zeros(6,length(loc_min));
cols_with_min_R(1,:) = target_cols(1,loc_min); %row
cols_with_min_R(2,:) = target_cols(2,loc_min); %column
cols_with_min_R(3,:) = target_cols(3,loc_min); %height
cols_with_min_R(4,:) = target_cols(4,loc_min); %minimum
cols_with_min_R(5,:) = repmat(min_R, [1 , length(loc_min)]); %R
cols_with_min_R(6,:) =  target_cols(6,loc_min); % Block

%     then choose the highest column(s)
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(3,:)>=max(cols_with_min_R(3,:)));


    % then choose the block with shortest queue of internal trucks
candidate_blocks = unique(cols_with_min_R(6,:));
queue_candidate_blocks = Blocks.num_containers_to_be_stacked_here(candidate_blocks);
min_queue = min(queue_candidate_blocks);
block_with_min_queue =  candidate_blocks(queue_candidate_blocks==min_queue);
block_not_with_min_queue = setdiff(candidate_blocks, block_with_min_queue);
for i = 1: length(block_not_with_min_queue)
    cols_with_min_R(: , cols_with_min_R(6,:) == block_not_with_min_queue(i) ) = [];
end

% break any further tie by moving to the block with smallest index 
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(6,:)==min(cols_with_min_R(6,:))); 

% break any further tie by moving to the row with smallest index 
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(1,:)==min(cols_with_min_R(1,:))); 

% then choose the column with smallest index
cols_with_min_R = cols_with_min_R(:,cols_with_min_R(2,:)==min(cols_with_min_R(2,:))); 

selected_block = cols_with_min_R(6);
selected_row = cols_with_min_R(1);
selected_col = cols_with_min_R(2);

tempHeight = Rows.Height(selected_col,selected_row);

selected_tier = H - tempHeight;

Blocks.Free_spots(selected_block) = Blocks.Free_spots(selected_block)-1;
Blocks.unassigned_slots_to_ships(selected_block) =Blocks.unassigned_slots_to_ships(selected_block)+1;
tempRows = Rows;
tempRows.Height (selected_col,selected_row) = tempRows.Height (selected_col,selected_row) +1;
tempRows.Config_id(selected_tier , selected_col, selected_row) = ID_this_container;

end

   