function [Blocks,Rows,Containers] = update_rows_config_value(added_container_ID,stacking_block, stacking_row, stacking_col,stacking_tier, Blocks,Rows,Containers)

rows_in_stacking_block = Blocks.Rows_in_block(:,stacking_block);
temp = Rows.Config_value(:,:,rows_in_stacking_block); 

ID_containers_in_stacking_block = Rows.Config_id(:,:,rows_in_stacking_block);
is_zone_greater_than_zero = Rows.Config_value(:,:,rows_in_stacking_block)>0;
ID_zone_0_containers_in_stacking_block = ID_containers_in_stacking_block(is_zone_greater_than_zero);


if Containers.Departure_zone(containerID)>0

    % * we add 1 to rows.config_value of other containers whose zone is greater than zero, because we now have 1 more container
    temp(temp > Blocks.Number_cont(stacking_block)) = temp(temp >= Blocks.Number_cont(stacking_block)) + 1;

    % * updated config_value of the stacking row and column
    temp(H-stacking_tier+1,stacking_col,stacking_row) = Blocks.Number_cont(stacking_block)+Containers.Departure_zone(added_container_ID);
    
else
    
    departure_time_of_zone_0_containers = Containers.Departure_time(ID_zone_0_containers_in_stacking_block);
    departure_time_of_zone_0_containers = [departure_time_of_zone_0_containers  Containers.Departure_time(containerID)];
    departure_time_of_zone_0_containers = [departure_time_of_zone_0_containers ; [ID_zone_0_containers_in_stacking_block' containerID]];
    % departure_time_of_zone_0_containers =[depTime1  depTime2 ... depTimen
    %                                       ID1         ID2    ...  IDn ];
    
    [~, index_sorted_dep_times] = sort(departure_time_of_zone_0_containers(1,:));
    sorted_dep_times = departure_time_of_zone_0_containers( :,index_sorted_dep_times);
    
    rank_stacking_container = find(sorted_dep_times(2,:)==containerID);
  
    
    % * we add 1 to rows.config_value of other containers whose value is greater than or equal to stacking rank
    temp(temp >= rank_stacking_container) = temp(temp >= rank_stacking_container) + 1;  

    % * updated config_value of the stacking row and column
    temp(H-stacking_tier+1,stacking_col,stacking_row) = rank_stacking_container;
end

Rows.Config_value(:,:,rows_in_stacking_block) = temp; 
    