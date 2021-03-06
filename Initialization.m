function [Blocks,Rows,Containers, Ships, BerthCranes, RTGs, trucks, max_zone] = ...
    Initialization(Full_info,lambda,mu,n_ships,n_cont_per_ship,B,R,C,numTiers,gamma,horizon_length_known_containers,...
                    n_BC,n_RTG, n_trucks,numDays)

% Last Modification: 9/16
% Virgile


% Full_info: 1 if all containers are known
% B: #blocks
% R: #rows (bays) in each block
% C: #columns
% H: #tiers
% gamma: utilization factor of each row
% horizon: the length of one time zone (measured in time steps)

% ************************************************************************
% ************************************************************************
% ************************************************************************

global H horizon Maxzone Tlimit;

minutes_in_day = 1440;
Tlimit = numDays * minutes_in_day;
H = numTiers;
horizon = horizon_length_known_containers;

Nrow = ceil(gamma*(C*(H-1)+1));
Nblo = R*Nrow;
Ntot = B*Nblo;

% Blocks give the relationship between the blocks and the rows: meaning
% Rows_in_block are giving the rows ID of the rows in a given block.
% Rows has 6 keys:
% 1- ID
% 2- Rows_in_block lists the rows that forms the block
% 3- Number_cont counts the number of containers in the block
% 4- Free_spots counts the number of free spots in the block
% 5- unassigned_slots_to_ships gives the nuber of slots remained that are not assigned for stacking in this block
% 6- num_containers_to_be_stacked_here gives the number of blocks waiting to be stacked here.
Blocks = struct('ID',1:B,'Rows_in_block',zeros(R,B),'Number_cont',zeros(1,B),...
                'Free_spots',(R*C*H-(H-1))*ones(1,B), ...
                'unassigned_slots_to_ships',(R*C*H-(H-1))*ones(1,B),...
                'num_containers_to_be_stacked_here', zeros(1,B));
for b=1:B
    Blocks.Rows_in_block(:,b) = 1+(b-1)*R:b*R;
end

% Rows has 8 keys:
% 1- ID
% 2- Number_cont
% 3- Cont_in_row the ID of the containers in this row
% 4- Height of each column
% 5- Minimum of each column
% 6- Config_value is the representation of the bay with the values
% 7- Config_id is the representation of the bay with the ID
% 8- isColumnLocked is 1 if the column has a planned stack
Rows = struct('ID',1:B*R,'Block',zeros(1,B*R),'Number_cont',zeros(1,B*R),'Height',zeros(C,B*R),...
              'Minimum',zeros(C,B*R),'Config_value',zeros(H,C,B*R),'Config_id',zeros(H,C,B*R),...
               'isColumnLocked',zeros(C,B*R));
for r=1:B*R
    Rows.Block(r) = floor((r-1)/R)+1;
end

% Containers has 19 keys:
% 1- ID
% 2- Status = -1 in vessel, 0 in yard, 1 retrieved
% 3- Arrival_time: Time of the ship
% 4- Departure_zone: Time zone of the pick-up truck
% 5- Departure_time: Exact time of pick-up
% 6- Ship: ID of the ship the container is currently in
% 7- Block: ID of the block the container is currently in
% 8- Row: ID of the row the container is currently in
% 9- Column: column number the container is currently in
% 10- Tier: tier number of the ship the container is currently in counting from bottom to top
% 11- config_stacking_column: Configuration of the stacking column
% 12- Block_value is the value that this container takes in a given row
% 13- Number_reloc is the number of time that this container has been relocated.
% 14- discharge_time: time it is discharged from the ship
% 15- discharging_crane: The crane currenlty discharging the container
% 16- Actual_departure_time: The time it was actually picked-up
% 17- Actual_stacking_time: The time it was stacked in the yard
% 18- Delay: Actual_departure_time - Arrival_time
% 19- internal_truck: The ID of the internal truck moving the container to be stacked.

Containers = struct('ID',1:Ntot,'Status',zeros(1,Ntot),'Arrival_time',zeros(1,Ntot),'Departure_zone',zeros(1,Ntot),...
    'Departure_time',zeros(1,Ntot),'Ship',zeros(1,Ntot),'Block',zeros(1,Ntot),'Row',zeros(1,Ntot),'Column',zeros(1,Ntot),...
    'Tier',zeros(1,Ntot),'config_stacking_column',zeros(H,Ntot),'Block_value',zeros(1,Ntot),...
    'Number_reloc',zeros(1,Ntot),'discharge_time',inf(1,Ntot),'discharging_crane',zeros(1,Ntot),...
    'Actual_departure_time',zeros(1,Ntot),'Actual_stacking_time',zeros(1,Ntot),'Delay',zeros(1,Ntot), 'internal_truck', zeros(1,Ntot));

zone = zeros(1,Ntot);
retrieve_times = external_truck_arrivals(lambda,Ntot);


%*****************************
% Trucks coming only during the first half of the day
num_days = ceil(max(retrieve_times)/minutes_in_day);
for d=0:2*num_days
    temp = retrieve_times > (d*minutes_in_day)+(minutes_in_day/2);
    retrieve_times(temp)=retrieve_times(temp) + minutes_in_day/2 ;
end
%*****************************

if Full_info
    horizon = ceil(max(retrieve_times));
    Maxzone = 0;
else
    Maxzone = 3;
    zone(1,:) = (horizon<retrieve_times(1,:) & retrieve_times(1,:)<=minutes_in_day) + 2*(retrieve_times(1,:)>minutes_in_day);
end

max_zone = Maxzone;

% BerthCranes has 3 keys:
% 1- ID
% 2- Status: 0 if idle or ID of the container it is discharging from a ship.
% 3- ssigned_to_which_ship: ID of the ship it is assigned to
BerthCranes = struct('ID',1:n_BC,'Status',zeros(n_BC,Tlimit), 'assigned_to_which_ship', zeros(n_BC,Tlimit));

% Ships has 6 keys:
% 1- ID
% 2- arrival_time
% 3- Number_cont: number of containers in the ship
% 4- discharge_started = 1 if so, 0 if not
% 5- num_discharged is the number of containers already discharged
% 6- which_BC_assigned_to_ship is the list of berthcranes assigned to thi ship.
Ships = struct('ID',1:n_ships,'arrival_time',zeros(1,n_ships),'Number_cont',...
    n_cont_per_ship*ones(1,n_ships),'discharge_started',zeros(1,n_ships),...
    'num_discharged',zeros(1,n_ships),'which_BC_assigned_to_ship',zeros(n_ships,n_BC));

% RTGs has 3 keys:
% 1- ID
% 2- Status: 0 if idle or ID of the container that it is moving.
% 3- relocate_to_other_rows counts the number of relocation performed by the RTG from one row to another
RTGs = struct('ID',1:n_RTG,'Status',zeros(n_RTG,Tlimit), 'relocate_to_other_rows', zeros(1,n_RTG));

% RTGs has 3 keys:
% 1- ID
% 2- Status: 0 if idle or ID of the container that it is moving.
% 3- assigned_to_which_BC is the berthcranes to which the truck is assigned to
trucks = struct('ID', 1:n_trucks, 'status' , zeros(n_trucks,Tlimit), 'assigned_to_which_BC' , zeros(n_trucks,Tlimit));

n = 0;
for b=1:B
    for r=1:R
% We pre-set the positions of possible containers in the row j of block i
% by assigning random position which gives an uneven bay to start with.
        pos = randperm(H*C);
        pos = pos(1:Nrow);
        pos = pos - 1;
        finalpos = zeros(Nrow,2);
        for c=1:Nrow;
            finalpos(c,1) = floor(pos(c)/H)+1;
            locpos = sort(pos(floor(pos/H)==floor(pos(c)/H)));
            finalpos(c,2) = find(locpos==pos(c));
        end
% We set the time and position information of each container of the row. We
% also set the number of containers, their IDs and the configuration with
% the ID.
        for c=1+n:Nrow+n
            Containers.Departure_zone(c) = zone(c);
            Containers.Departure_time(c) = retrieve_times(c);
            Containers.Block(c) = b;
            Containers.Row(c) = r+(b-1)*R;
            Containers.Column(c) = finalpos(c-n,1);
            Containers.Tier(c) = finalpos(c-n,2);
            Rows.Number_cont(r+(b-1)*R) = Rows.Number_cont(r+(b-1)*R) + 1;
            %Rows.Cont_in_row(Rows.Number_cont(j+(i-1)*R),j+(i-1)*R) = Containers.ID(k);
            Rows.Config_id(H-Containers.Tier(c)+1,Containers.Column(c),r+(b-1)*R) = Containers.ID(c);
            Blocks.Number_cont(b) = Blocks.Number_cont(b) + 1;
            Blocks.Free_spots(b) = Blocks.Free_spots(b) - 1;
        end
% We then allocate each container to its number in its row. It has
% a number less than Nrow if the departure time is known i.e. the
% time zone is 0. Otherwise we set the containers of other time
% zones to Nrow + Departure_zone.
% We also complete the configuration value of the row
        order = retrieve_times(1+(b-1)*R*Nrow:b*R*Nrow);
        locorder = sort(order(order <= horizon));
        for c=1+n:Nrow+n
            if Containers.Departure_zone(c) == 0
                Containers.Block_value(c) = find(locorder==retrieve_times(c));
            else
                Containers.Block_value(c) = Nblo + Containers.Departure_zone(c);
            end
            Rows.Config_value(H-Containers.Tier(c)+1,Containers.Column(c),r+(b-1)*R) = Containers.Block_value(c);
        end
% Finally, we compute the Height and the Minimum for each column of the row
        Rows.Height(:,r+(b-1)*R) = heights_of_row(Rows.Config_value(:,:,r+(b-1)*R));
        Rows.Minimum(:,r+(b-1)*R) = mins_of_row(Rows.Config_value(:,:,r+(b-1)*R),Nrow*R);
        n = n + Nrow;
    end
end

% We introduce the containers that are going to be stacked. Those
% containers have arrival_time of their ships. They are ranked by ID so the
% one with the smallest ID is available first for the berth cranes.
[Ships,Stack_Cont,Arrival_Ships] = Generate_stacking_containers(mu,lambda,Ships,n_cont_per_ship,numDays);
for i=1:n_ships
    for j=1:n_cont_per_ship
        Containers.ID(Ntot+1) = Ntot+1;
        Containers.Status(Ntot+1)= -1;
        Containers.Arrival_time(Ntot+1)= Arrival_Ships(i); 
        
        %*****************************
        % Trucks coming only during the first half od the day
        temp = ceil(Stack_Cont(i,j)/minutes_in_day);
        if Stack_Cont(i,j)> ((temp-1)*minutes_in_day) + 720
            Stack_Cont(i,j) = Stack_Cont(i,j)+720;
        end
        %*****************************
        
        if Full_info
            horizon = ceil(max(retrieve_times));
            Containers.Departure_zone(Ntot+1)= 0;
        else
            Containers.Departure_zone(Ntot+1) = (horizon<Stack_Cont(i,j)&Stack_Cont(i,j)<=minutes_in_day) + 2*(Stack_Cont(i,j)>minutes_in_day);
        end

        Containers.Departure_time(Ntot+1) = Stack_Cont(i,j);
        Containers.Block(Ntot+1) = 0;
        Containers.Row(Ntot+1) = 0;
        Containers.Column(Ntot+1) = 0;
        Containers.Tier(Ntot+1) = 0;
        Containers.Block_value(Ntot+1) = 0;
        Containers.Number_reloc(Ntot+1) = 0;
        Containers.Actual_departure_time(Ntot+1) = 0;
        Containers.Actual_stacking_time(Ntot+1) = 0;
        Containers.Delay(Ntot+1) = 0;
        Containers.config_stacking_column(:,Ntot+1) = zeros(H,1);
        Containers.discharge_time(Ntot+1) = inf;
        Containers.discharging_crane(Ntot+1) = 0;
        Containers.Ship(Ntot+1) = i;
        Containers.internal_truck(Ntot+1) = 0;
        Ntot = Ntot + 1;
    end
end

        
        
