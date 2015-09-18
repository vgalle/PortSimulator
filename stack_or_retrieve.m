function stack_retrieve_decision = stack_or_retrieve(Containers, target_ID, ready_to_stack_IDs,...
    max_stack_wait_time, max_retrieve_wait_time, Time,duration_disch)

% Last Modification: 9/16
% Virgile

% OUTPUT:
% Stack = 1
% Retrieve = 2

stack_retrieve_decision = 1;

stacking_containerID = Containers.ID(Containers.discharge_time == min(Containers.discharge_time(ready_to_stack_IDs)));
[~ ,temp] = min(Containers.discharging_crane(stacking_containerID));

stacking_containerID  = stacking_containerID(temp);

wait_time_target_container = Time - Containers.Departure_time(target_ID);
wait_time_stacking_containerID = Time - Containers.discharge_time(stacking_containerID) - duration_disch;

if wait_time_target_container>=max_retrieve_wait_time && wait_time_stacking_containerID<max_stack_wait_time
    stack_retrieve_decision = 2;
end