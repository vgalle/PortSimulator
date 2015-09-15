function stack_retrieve_decision = stack_or_retrieve(Containers, target_ID, ready_to_stack_IDs,...
    max_stack_wait_time, max_retrieve_wait_time, Time)

% OUTPUT:
% Stack = 1
% Retrieve = 2

% ID_ready_to_be_retrieved_containers = Containers.ID(Containers.Departure_time<=Time);
% num_ready_to_be_retrieved_containers = length(ID_ready_to_be_retrieved_containers);

duration_disch = 2;
% duration_stack = 1;
% duration_retrieval = 1;
% duration_relocate = 1;

stack_retrieve_decision = 1;

stacking_containerID = Containers.ID(Containers.discharge_time == min(Containers.discharge_time(ready_to_stack_IDs)));
[~ ,temp] = min(Containers.discharging_crane(stacking_containerID));

stacking_containerID  = stacking_containerID(temp);

wait_time_target_container = Time - Containers.Departure_time(target_ID);
wait_time_stacking_containerID = Time - Containers.discharge_time(stacking_containerID) - duration_disch;

% if wait_time_stacking_containerID>=max_stack_wait_time
%     stack_retrieve_decision = 1;
% end

if wait_time_target_container>=max_retrieve_wait_time && wait_time_stacking_containerID<max_stack_wait_time
    stack_retrieve_decision = 2;
end

% if wait_time_target_container<max_retrieve_wait_time && wait_time_stacking_containerID<max_stack_wait_time
%     stack_retrieve_decision = 2;
% end