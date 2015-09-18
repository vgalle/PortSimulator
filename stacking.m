function [Blocks,Rows,Containers] = stacking(containerID,stacking_block, stacking_row, ...
                             stacking_col, stacking_tier, Blocks,Rows,Containers,Time)

% Last Modification: 9/16
% Setareh

% This function updates the configuration when a container is stacked.

global H
    
% add 1 to number of containers in the stacking row
Rows.Number_cont(stacking_row) = Rows.Number_cont(stacking_row) + 1;

% update Block_value of the stacking container and Rows.Config_value
rows_in_stacking_block = Blocks.Rows_in_block(:,stacking_block);
temp = Rows.Config_value(:,:,rows_in_stacking_block); 

stacking_row_index = find(rows_in_stacking_block==stacking_row);


ID_containers_in_stacking_block = Rows.Config_id(:,:,rows_in_stacking_block);
is_zone_greater_than_zero = Rows.Config_value(:,:,rows_in_stacking_block)>0;
ID_zone_0_containers_in_stacking_block = ID_containers_in_stacking_block(is_zone_greater_than_zero);

if Containers.Departure_zone(containerID)>0
        
% * we add 1 to rows.config_value of other containers whose zone is greater than zero, because we now have 1 more container
    temp(temp > Blocks.Number_cont(stacking_block)) = temp(temp > Blocks.Number_cont(stacking_block)) + 1;
       
% * updated config_value of the stacking row and column
    temp(H-stacking_tier+1,stacking_col,stacking_row_index) = Blocks.Number_cont(stacking_block)+Containers.Departure_zone(containerID);
    
% ** we set block value of stacking container to zone + number of containers
    Containers.Block_value(containerID) = Blocks.Number_cont(stacking_block) + 1 + Containers.Departure_zone(containerID);
            
% ** we add 1 to block value of other containers whose zone is greater than zero, because we now have 1 more container
    Containers.Block_value(ID_zone_0_containers_in_stacking_block) = Containers.Block_value(ID_zone_0_containers_in_stacking_block)+1;

else
 
    departure_time_of_zone_0_containers = Containers.Departure_time(ID_zone_0_containers_in_stacking_block);
    departure_time_of_zone_0_containers = [departure_time_of_zone_0_containers  Containers.Departure_time(containerID)];
    departure_time_of_zone_0_containers = [departure_time_of_zone_0_containers ; [ID_zone_0_containers_in_stacking_block' containerID]];
% departure_time_of_zone_0_containers =[depTime1  depTime2 ... depTimen
%                                       ID1         ID2    ...  IDn ];
    
    [~, index_sorted_dep_times] = sort(departure_time_of_zone_0_containers(1,:));
    sorted_dep_times = departure_time_of_zone_0_containers( :,index_sorted_dep_times);
    
    rank_stacking_container = find(sorted_dep_times(2,:)==containerID);

    is_value_greater_than_rank_stacking_container = Rows.Config_value(:,:,rows_in_stacking_block)>=rank_stacking_container;
    ID_value_greater_than_rank_stacking_container = ID_containers_in_stacking_block(is_value_greater_than_rank_stacking_container);
    
% ** Add 1 to block value of containers whose value is greater than or equal to stacking rank
    if ~isempty(ID_value_greater_than_rank_stacking_container)
        Containers.Block_value(ID_value_greater_than_rank_stacking_container) = Containers.Block_value(ID_value_greater_than_rank_stacking_container)+1;
    end

% ** Assign the Block_value of stacking container
    Containers.Block_value(containerID) = rank_stacking_container;
    
% * we add 1 to rows.config_value of other containers whose value is greater than or equal to stacking rank
    temp(temp >= rank_stacking_container) = temp(temp >= rank_stacking_container) + 1;  

% * updated config_value of the stacking row and column
    temp(H-stacking_tier+1,stacking_col,stacking_row_index) = rank_stacking_container;
    
end

% replace Rows.Config_value(:,:,rows_in_stacking_block) with temp
Rows.Config_value(:,:,rows_in_stacking_block) = temp;
 
% add 1 to number of containers in the stacking block
Blocks.Number_cont(stacking_block) = Blocks.Number_cont(stacking_block) + 1;

% updated config_id of the stacking row and column
Rows.Config_id(H-stacking_tier+1,stacking_col,stacking_row) = containerID;

% update height of the stacking row and column
Rows.Height(:,stacking_row) = heights_of_row(Rows.Config_value(:,:,stacking_row));

% update minimums of the stacking row and column
Rows.Minimum(:,stacking_row) = mins_of_row(Rows.Config_value(:,:,stacking_row),Blocks.Number_cont(stacking_block));

Containers.Status(containerID) = 0;
Containers.Block(containerID) = stacking_block;
Containers.Row(containerID) = stacking_row;
Containers.Column(containerID) = stacking_col;
Containers.Tier(containerID) = stacking_tier;
Containers.Actual_stacking_time(containerID) = Time;

