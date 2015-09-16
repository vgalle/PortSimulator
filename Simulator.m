function [cs,cr,N_reloc,N_retrieval,N_stacked,Time,sign_RTGs_status, FinalBlocks,FinalRows,FinalContainers,FinalRTGs, FinalBerthCranes,FinalTrucks,FinalShips] = ...
    Simulator(Blocks,Rows,Containers, BerthCranes, RTGs,Ships, trucks,Heuristic_reloc,Heuristic_stack,within_same_row,Look_ahead)

% Last Modification: 2/6
% Setareh

% change RI in ATIB
% change horizon and estimation horizon
% assign fixed number of berthcranes to ships


global Maxzone Tlimit H

% horizon 
% Maxzone 
% Tlimit 

max_stack_wait_time = 2;
max_retrieve_wait_time = 2;

Time = 1;
length_time_step = 1;
N_reloc = 0;
N_stacked = 0;
N_retrieval = 0;

% duration_disch_and_transfer = 4 * length_time_step;
duration_transfer = 2 * length_time_step;
duration_disch = 2 * length_time_step;
duration_stack = 2 * length_time_step;
duration_retrieval = 2 * length_time_step;
% duration_relocate = 2;

if strcmp(Heuristic_stack,'Closest')
    Block_counter = 1;
    Row_counter = 1;
    Col_counter = 1;
end

B = length(Blocks.ID);

% tempBlocks = Blocks;
tempRows = Rows;

% BC = length(BerthCranes.ID);

% We keep going until we reached the time limit of the experiment or that
% the bay is empty.

% if strcmp(Heuristic_reloc,'Kim_Hong') || strcmp(Heuristic_stack,'Kim_Hong');
%     EN = ENAR_matrix(size(Rows.Config_id(:,:,1),1),size(Rows.Config_id(:,:,1),2));
% end
% Tlimit

cs = zeros(2,0);
cr = zeros(2,0);

while Time <= Tlimit 

    Time
    
%     if  Containers.Block(20)<0
% 
%         keyboard
%     end
% %     
%     if Time==274
%         keyboard
%     end
%     
%     for r=11:11
%         tempp = Rows.Config_value(:,:,r);
%         for c=1:7
%             tempp2 = tempp(:,c);
%             tempp2 = tempp2(end:-1:1);
%             for t=1:3
%                 if tempp2(t)==0 && tempp2(t+1)>0
%                     r
%                     c
%                     t
%                     display('!!!!')
%                     keyboard
%                 end
%             end
%         end
%     end
    

    
    % We can take one action per crane i.e per block
%     if Time == (Time_zone+1)*horizon
%         Time_zone = Time_zone + 1;
%         [Rows,Containers] = Change_of_zone(Blocks,Rows,Containers);
%     end
    
    for i=1:B

        % We find the ID of the target container that can be retrieved and its row and its row
        target_ID = Containers.ID(Containers.Block_value == 1 & Containers.Block == i & Containers.Departure_time<=Time);
        % We also find the ID of the container that can be stacked (i.e., has been discharged at previous time step or earlier)
        ready_to_stack_IDs = Containers.ID(Containers.Status==-2 & Containers.Block == i & Containers.discharge_time+duration_disch + duration_transfer<=Time);
        
        if isempty(target_ID) && ~isempty(ready_to_stack_IDs)
            stack_retrieve_decision = 1;
        elseif isempty(ready_to_stack_IDs) && ~isempty(target_ID) 
            stack_retrieve_decision = 2;
        elseif ~isempty(target_ID) && ~isempty(ready_to_stack_IDs)           
            stack_retrieve_decision = stack_or_retrieve(Containers, target_ID, ready_to_stack_IDs,max_stack_wait_time, max_retrieve_wait_time, Time);
        else
            RTGs.Status(i,Time) = 0;
            stack_retrieve_decision=inf;
        end
        
        if stack_retrieve_decision==2 && RTGs.Status(i,Time)== 0 % if we decide to retrieve:
            if Containers.Departure_zone(target_ID)==0
                % relocate_ID is the ID of the container that has to be moved. It can be either
                % a blocking container or the target container.
                relocate_ID = Containers.ID(Containers.Row == Containers.Row(target_ID) & ...
                                            Containers.Column == Containers.Column(target_ID) & ...
                                            Containers.Tier == Rows.Height(Containers.Column(target_ID),Containers.Row(target_ID)) & ...
                                            Containers.Status==0);
                % If the target container is on the top, it is retrieved.
                if target_ID == relocate_ID && Containers.Departure_time(target_ID) <= Time
                    [Blocks,Rows,Containers] = Retieval(target_ID,Blocks,Rows,Containers,Maxzone,Time);
                    N_retrieval = N_retrieval + 1;             
                    RTGs.Status(i,Time:Time+duration_retrieval-1) = target_ID;
                    
                % Otherwise it is moved
                elseif target_ID ~= relocate_ID
                    switch Heuristic_reloc
                        case 'Myopic'
                            [selected_row, selected_col, selected_tier, same_row] = Myopic_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers);
%                         case 'ATIB-new-RI'
%                             [selected_row, selected_col, selected_tier, same_row] = ATIB_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers);
%                         case 'ATIB-original-RI'
%                             [selected_row, selected_col, selected_tier, same_row] = ATIB_relocate_original_RI (relocate_ID, within_same_row, Blocks, Rows, Containers, Time);
                        case 'Lowest_Height'
                            [selected_row, selected_col, selected_tier, same_row] = LowHeight_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers);
                        case 'Closest'
                            [selected_row, selected_col, selected_tier, same_row] = Closest_relocate (relocate_ID, Blocks, Rows, Containers);
                        case 'RI'
                            [selected_row, selected_col, selected_tier, same_row] = RI_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers);
                            cr(1,size(cr,2)+1)=relocate_ID; 
                            cr(2,size(cr,2)) = ((Containers.Block(relocate_ID)-1)*B) + ((selected_row-1)*length(Rows.ID)) + selected_col;
                        case 'Petering'
                            [selected_row, selected_col, selected_tier, same_row, relocate_ID] = Petering_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers,Look_ahead);
%                       case 'Kim_Hong'
%                           [selected_row, selected_col, selected_tier, same_row] = KimHong_relocate (relocate_ID, within_same_row, Blocks, Rows, Containers,EN);
                    end
                    
                    RTGs.relocate_to_other_rows(1,Containers.Block(relocate_ID))=RTGs.relocate_to_other_rows(1,Containers.Block(relocate_ID))+(~same_row);
                    
                    [Blocks,Rows,Containers] = Relocate(relocate_ID,selected_row,selected_col,selected_tier,Blocks,Rows,Containers,Maxzone,same_row);
                    N_reloc = N_reloc + 1;

                    duration_relocate = compute_relocation_time (Containers.Row(relocate_ID), selected_row);                    
                    RTGs.Status(i,Time: Time + duration_relocate - 1 ) = relocate_ID+0.5;
                end
            end        
        end
        
        if stack_retrieve_decision==1 && RTGs.Status(i,Time)== 0 % if we decide to stack:
            earliest_discharged = min(Containers.discharge_time(Containers.Status==-2 & Containers.Block==i ));
            containerID_to_be_stacked = Containers.ID(Containers.Block==i & Containers.discharge_time==earliest_discharged & Containers.Status==-2);
            [~ ,temp] = min(Containers.discharging_crane(containerID_to_be_stacked));
            containerID_to_be_stacked  = containerID_to_be_stacked(temp);
    
%             containerID_to_be_stacked = containerID_to_be_stacked(1);
            stacking_block = Containers.Block(containerID_to_be_stacked);
            switch Heuristic_stack
                case 'Myopic'
                   [~, stacking_row, stacking_col, stacking_tier] = Myopic_stack (containerID_to_be_stacked, stacking_block, Blocks, Rows, Containers); 
%                 case 'ATIB-new-RI'
%                    [~, stacking_row, stacking_col, stacking_tier] = ATIB_stack (containerID_to_be_stacked, stacking_block, Blocks, Rows, Containers);
%                 case 'ATIB-original-RI'
%                    [~, stacking_row, stacking_col, stacking_tier] = ATIB_stack_original_RI (containerID_to_be_stacked, stacking_block, Blocks, Rows, Containers,Time);
                case 'Lowest_Height'
                   [~, stacking_row, stacking_col, stacking_tier] = LowHeight_stack (stacking_block, Blocks, Rows);
                case 'RI'
                   [~, stacking_row, stacking_col, stacking_tier] = RI_stack (containerID_to_be_stacked, stacking_block, Blocks, Rows, Containers);
                   
                   cs(1,size(cs,2)+1)=containerID_to_be_stacked; 
                   cs(2,size(cs,2)) = ((Containers.Block(containerID_to_be_stacked)-1)*B) + ((stacking_row-1)*length(Rows.ID)) + stacking_col;
                case 'Closest'
                   [~, stacking_row, stacking_col, stacking_tier,Row_counter,Col_counter] = Closest_stack (stacking_block, Blocks, Rows,Row_counter,Col_counter);
%               case 'Kim_Hong'
%                  [~, stacking_row, stacking_col, stacking_tier] = KimHong_stack (containerID_to_be_stacked, stacking_block, Blocks, Rows, Containers,EN);

            end
            Blocks.num_containers_to_be_stacked_here(stacking_block) = Blocks.num_containers_to_be_stacked_here(stacking_block) -1;
%             selected_row = Containers.Row(containerID_to_be_stacked);
%             selected_col = Containers.Column(containerID_to_be_stacked);
%             selected_tier = Containers.Tier(containerID_to_be_stacked);
            if H-stacking_tier+1 == 0
                keyboard
            end
            [Blocks,Rows,Containers] = stacking(containerID_to_be_stacked,stacking_block, stacking_row, stacking_col, stacking_tier, Blocks,Rows,Containers,Time);
            N_stacked = N_stacked+1;
            RTGs.Status(i,Time:Time+duration_stack-1) = -containerID_to_be_stacked;
            internal_truck_containerID_to_be_stacked = Containers.internal_truck(containerID_to_be_stacked);
            trucks.status(internal_truck_containerID_to_be_stacked, Time+duration_stack+duration_transfer:end)=0;
            
        end   
    end
    
    ships_done_with_discharging = Ships.ID(Ships.num_discharged==Ships.Number_cont);
    for i=1:length(ships_done_with_discharging)
        involved_BCs = find(Ships.which_BC_assigned_to_ship(ships_done_with_discharging(i),:));
        BerthCranes.assigned_to_which_ship(involved_BCs,Time+duration_disch-1:end) = 0;
        for j=1:length(involved_BCs)
            involved_trucks = find(trucks.assigned_to_which_BC(:,Time)==involved_BCs(j));
            trucks.assigned_to_which_BC(involved_trucks,Time:end)=0;
            trucks.status(involved_trucks,Time:end)=0;
        end
        Ships.num_discharged(ships_done_with_discharging(i)) = inf;
    end
        
    
    remaining_ships = Ships.ID(Ships.discharge_started==0 & ceil(Ships.arrival_time)<= Time);
    num_remaining_ships = length(remaining_ships);
    
    if ~isempty(remaining_ships)
        free_BCs = find(BerthCranes.assigned_to_which_ship(:,Time)==0);
        num_free_BCs = length(free_BCs);
        free_trucks = find(trucks.assigned_to_which_BC(:,Time)==0 & trucks.status(:,Time)==0);
        num_free_trucks = length(free_trucks);
        counter_BC_assigned = 1;
        counter_truck_assigned = 1;
        
        total_assigned_BC = 0;
        total_assigned_trucks = 0;
        

        % assign BC to ships
        for i=1:num_remaining_ships
            num_assigned_BC_to_this_ship = min(ceil(num_free_BCs/num_remaining_ships),ceil(Ships.Number_cont(remaining_ships(i))/60));
            if i==num_remaining_ships
                num_assigned_BC_to_this_ship = min(num_free_BCs-total_assigned_BC,ceil(Ships.Number_cont(remaining_ships(i))/60));
            end
            if num_assigned_BC_to_this_ship>0
                Ships.which_BC_assigned_to_ship(remaining_ships(i),free_BCs(counter_BC_assigned:counter_BC_assigned+num_assigned_BC_to_this_ship-1))=1;
                Ships.discharge_started(remaining_ships(i))=1;
                BerthCranes.assigned_to_which_ship( free_BCs(counter_BC_assigned:counter_BC_assigned+num_assigned_BC_to_this_ship-1), Time:end)=remaining_ships(i);
                assigned_BCs(counter_BC_assigned:counter_BC_assigned + num_assigned_BC_to_this_ship-1) = free_BCs(counter_BC_assigned:counter_BC_assigned+num_assigned_BC_to_this_ship-1);
                counter_BC_assigned = counter_BC_assigned + num_assigned_BC_to_this_ship;
                total_assigned_BC = total_assigned_BC + num_assigned_BC_to_this_ship;
            end
        end
        
        % assign truck to BC
        for bc = 1:total_assigned_BC
            num_assigned_trucks_to_this_BC = min(ceil(num_free_trucks/total_assigned_BC),6);
            if bc==total_assigned_BC
                num_assigned_trucks_to_this_BC=min(num_free_trucks-total_assigned_trucks,6);
            end
            if num_assigned_trucks_to_this_BC>0
                trucks.assigned_to_which_BC(free_trucks(counter_truck_assigned:counter_truck_assigned+num_assigned_trucks_to_this_BC-1), Time:end)=assigned_BCs(bc);
                counter_truck_assigned = counter_truck_assigned + num_assigned_trucks_to_this_BC;
                total_assigned_trucks = total_assigned_trucks + num_assigned_trucks_to_this_BC;
        
            end
        end


%             [chosen_blocks,~] = Choose_stacking_blocks(Blocks,Numb_of_blocks,Numb_of_cont_to_stack);
%             Blocks.unassigned_slots_to_ships(chosen_blocks) = Blocks.unassigned_slots_to_ships(chosen_blocks)-Numb_of_cont_to_stack;
    end
            
%     if ~isempty(remaining_ships)
%         if remaining_ships(1)>1
%             temp = Ships.num_discharged(remaining_ships(1)-1);
%             temp2 = Ships.Number_cont(remaining_ships(1)-1);
%             choose_block_for_next_ship = temp==temp2;
%         else
%             choose_block_for_next_ship=1;
%         end
%         if Time >= ceil(Ships.arrival_time(remaining_ships(1))) && choose_block_for_next_ship
%             Numb_of_cont_to_stack = Ships.Number_cont(remaining_ships(1));
%             Ships.discharge_started(remaining_ships(1))=1;
%             [chosen_blocks,~] = Choose_stacking_blocks(Blocks,Numb_of_blocks,Numb_of_cont_to_stack);
%             Blocks.unassigned_slots_to_ships(chosen_blocks) = Blocks.unassigned_slots_to_ships(chosen_blocks)-Numb_of_cont_to_stack;
%         end
%     end


    ships_still_being_discharged = Ships.ID(Ships.num_discharged<Ships.Number_cont & Ships.discharge_started==1);
    
    for s =1:length(ships_still_being_discharged)
        this_ship = ships_still_being_discharged(s);
        BCs_this_ship = find(Ships.which_BC_assigned_to_ship(this_ship,:));
        for j=1:length(BCs_this_ship)     
            assigned_trucks_to_this_BC = find(trucks.assigned_to_which_BC(:,Time)==BCs_this_ship(j));
            available_to_discharge_ID = Containers.ID(Containers.Status==-1 & Containers.Ship==this_ship);
            free_assigned_trucks_to_this_BC = assigned_trucks_to_this_BC(trucks.status(assigned_trucks_to_this_BC,Time)==0);
            if BerthCranes.Status(BCs_this_ship(j),Time)==0 && ~isempty(available_to_discharge_ID) && sum(Blocks.Free_spots)>0 && ~isempty(free_assigned_trucks_to_this_BC)
                containerID_to_be_discharged = Containers.ID(available_to_discharge_ID(1));
                BerthCranes.Status(BCs_this_ship(j),Time:Time+duration_disch-1) = containerID_to_be_discharged;            
                free_assigned_trucks_to_this_BC = free_assigned_trucks_to_this_BC(1);
                trucks.status(free_assigned_trucks_to_this_BC,Time:end)=containerID_to_be_discharged;
                Containers.internal_truck(containerID_to_be_discharged)=free_assigned_trucks_to_this_BC;
                chosen_blocks = Blocks.ID(Blocks.Free_spots>0);
                
                switch Heuristic_stack
                    case 'Myopic'
                       [stacking_block, Blocks] = Myopic_block_allocation (containerID_to_be_discharged, chosen_blocks, Blocks, Rows, Containers);
%                     case 'ATIB-new-RI'
%                        [stacking_block, tempRows, Blocks] = ATIB_block_allocation (containerID_to_be_discharged, chosen_blocks, Blocks, tempRows, Containers);
%                     case 'ATIB-original-RI'
%                        [stacking_block, tempRows, Blocks] = ATIB_block_allocation_original_RI (containerID_to_be_discharged, chosen_blocks, Blocks, tempRows, Containers,Time);
                    case 'Lowest_Height'
                       [stacking_block, tempRows, Blocks] = LowHeight_block_allocation (containerID_to_be_discharged,chosen_blocks, Blocks, tempRows);
                    case 'RI'
                       [stacking_block, tempRows, Blocks] = RI_block_allocation (containerID_to_be_discharged, chosen_blocks, Blocks, tempRows, Containers);
                    case 'Closest'
                       [stacking_block, tempRows, Blocks,Block_counter,Row_counter,Col_counter] = Closest_block_allocation (containerID_to_be_discharged, chosen_blocks, Blocks, Rows,Block_counter,Row_counter,Col_counter);
    %               case 'Kim_Hong'
    %                  [stacking_block, Blocks] = KimHong_block_allocation (containerID_to_be_discharged, chosen_blocks, Blocks, Rows, Containers,EN);
                end
                
                Blocks.num_containers_to_be_stacked_here(stacking_block) = Blocks.num_containers_to_be_stacked_here(stacking_block)+1;

                Containers.discharging_crane(containerID_to_be_discharged) = BCs_this_ship(j);

                Containers.discharge_time(containerID_to_be_discharged) = Time;
                Containers.Block(containerID_to_be_discharged) = stacking_block;
                Containers.Status(containerID_to_be_discharged) = -2;
                Ships.num_discharged(ships_still_being_discharged(s))=Ships.num_discharged(ships_still_being_discharged(s))+1;

            end
            if BerthCranes.Status(BCs_this_ship(j),Time)==0 && ~isempty(available_to_discharge_ID) && sum(Blocks.Free_spots)==0
                error('There is no free slot to assign to the discharged container!');
            end

        end
    %     Rows.Config_value
    end
   Time = Time+1;
   if sum(Containers.Departure_zone)~=0
        [Blocks,Rows,Containers,RTGs, BerthCranes] = update_horizon2(Blocks,Rows,Containers,RTGs, BerthCranes,Time);
   end
end

FinalBlocks = Blocks;
FinalRows = Rows;
FinalContainers =Containers;
FinalRTGs = RTGs;
FinalShips = Ships;
temp = FinalRTGs.Status;
sign_RTGs_status = (floor(temp) == ceil(temp)) - 2*(temp<0) - 3*(temp==0);
FinalBerthCranes = BerthCranes;
FinalTrucks = trucks;