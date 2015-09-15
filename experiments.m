Full_info = 1;
n_ships = 3;
n_cont_per_ship = 350;

%500 trucks in 12 hours
lambda = 1000/(60*24); 

% mu = lambda/n_cont_per_ship;
mu = n_ships/(60*12);  % n ships in 12 hours
B = 30;
R = 50;
C = 7;
numTiers = 4;
gamma = 0.8;
horizon_known_length = 30;
horizon_estimated_length = 20;
n_BC = 12;
n_RTG = B;
n_trucks = 58;
within_same_row= 1;
% heu_relocation = {'Myopic','ATIB-new-RI','ATIB-original-RI', 'Lowest_Height','RI','Closest','Petering'};
% Look_ahead = 5;
% heu_stack = {'Myopic','ATIB-new-RI','ATIB-original-RI', 'Lowest_Height','RI','Myopic','Myopic'}; 

heu_relocation = {'Myopic', 'Lowest_Height','RI','Closest','Petering'};
Look_ahead = 5;
heu_stack = {'Myopic', 'Lowest_Height','RI','Closest','Myopic'}; 


num_heuristics = size(heu_stack,2);
overall_stats = cell(0,num_heuristics);
[Blocks,Rows,Containers, Ships, berthcranes, RTGs, trucks, max_zone, defined_horizon] = Initialization2(Full_info,lambda,mu,n_ships,n_cont_per_ship,B,R,C,numTiers,...
                                                                            gamma,horizon_known_length,n_BC,n_RTG,n_trucks);


[overall_stats{2,1},overall_stats{3,1},overall_stats{4,1} ,overall_stats{5,1},overall_stats{6,1},overall_stats{7,1},overall_stats{8,1},overall_stats{9,1},...
 overall_stats{10,1},overall_stats{11,1},overall_stats{12,1},overall_stats{13,1},overall_stats{14,1},overall_stats{15,1},overall_stats{16,1},overall_stats{17,1}...
 overall_stats{18,1},overall_stats{19,1},overall_stats{20,1}] = ...
deal('max_zone','horizon','retrieved','unretrieved','discharged','undischarged','stacked','unstacked','total_rel','ave_rel','max_rel','total_ret_del','ave_ret_del','max_ret_del',...
    'total_stack_del','ave_stack_del','max_stack_del','min_dwell_time','max_dwell_time');

tempCounter = size(overall_stats,1);
for r =1:length(RTGs.ID)
    overall_stats{tempCounter+r,1}=sprintf('RTG%d: utilization',r);
end
for r =1:length(RTGs.ID)
    overall_stats{tempCounter+length(RTGs.ID)+r,1}=sprintf('RTG%d:to_other_rows',r);
end

for h=1:6 %num_heuristics
    h
    u=1;
 
    Heuristic_reloc = heu_relocation{h};
    Heuristic_stack = heu_stack{h};
    overall_stats{u,h+1} = heu_relocation{h};
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(max_zone);
    u=u+1;
    overall_stats(u,h+1) = num2cell(defined_horizon);
    u=u+1;
    
    [N_reloc,N_retrieval,N_stacked,Time,sign_RTGs_status,FinalBlocks,FinalRows,FinalContainers,FinalRTGs, FinalBerthCranes,FinalTrucks] = ...
    Simulator(Blocks,Rows,Containers, berthcranes, RTGs,Ships, trucks,Heuristic_reloc,Heuristic_stack,within_same_row,Look_ahead);

    overall_stats(u,h+1) = num2cell(N_retrieval);
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(sum(FinalContainers.Status==0 & FinalContainers.Departure_time<Time));
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(sum(FinalContainers.Arrival_time<Time & FinalContainers.Status==-2));
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(sum(FinalContainers.Status==-1 & FinalContainers.Arrival_time<Time));
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(N_stacked);
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(sum(FinalContainers.Status==-2));
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(N_reloc);
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(N_reloc/N_retrieval);
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(max(FinalContainers.Number_reloc));  
    u=u+1;

    retrieved_containers_dep_time = FinalContainers.Departure_time(FinalContainers.Status==1);
    retrieved_containers_actual_dep_time = FinalContainers.Actual_departure_time(FinalContainers.Status==1);
    
    overall_stats(u,h+1) = num2cell(sum(retrieved_containers_actual_dep_time-retrieved_containers_dep_time));
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(sum((retrieved_containers_actual_dep_time-retrieved_containers_dep_time))/N_retrieval);    
    u=u+1;
    
    overall_stats(u,h+1) = num2cell(max(retrieved_containers_actual_dep_time-retrieved_containers_dep_time));    
    u=u+1;
   
    statusTemp = (FinalContainers.Status==0 | FinalContainers.Status==1) & FinalContainers.discharge_time~=inf;
    stacked_containers_discharge_time = FinalContainers.discharge_time(statusTemp);
    stacked_containers_actual_stack_time = FinalContainers.Actual_stacking_time(statusTemp);
    overall_stats(u,h+1) = num2cell(sum(stacked_containers_actual_stack_time-stacked_containers_discharge_time));
    u=u+1;

    overall_stats(u,h+1) = num2cell(sum((stacked_containers_actual_stack_time-stacked_containers_discharge_time))/N_stacked);    
    u=u+1;

    if isempty(stacked_containers_actual_stack_time-stacked_containers_discharge_time)
       overall_stats{u,h+1} = 'NA';
       u=u+1;
    else
        overall_stats(u,h+1) = num2cell(max(stacked_containers_actual_stack_time-stacked_containers_discharge_time));
        u=u+1;
    end
    
    statusTemp2 = (FinalContainers.Status==1) & FinalContainers.discharge_time~=inf;
    stack_time = FinalContainers.Actual_stacking_time(statusTemp2);
    departure_time = FinalContainers.Actual_departure_time(statusTemp2);
    
    if isempty(departure_time)
       overall_stats{u,h+1} = 'NA';
       u=u+1;
       overall_stats{u,h+1} = 'NA';
       u=u+1;
    else
        overall_stats(u,h+1) =  num2cell(min(departure_time- stack_time));
        u=u+1;
        overall_stats(u,h+1) = num2cell(max(departure_time- stack_time));
        u=u+1;
    end
    
    
    for r =1:length(FinalRTGs.ID)
        overall_stats(tempCounter+r,h+1) = num2cell(min((sum(FinalRTGs.Status(r,:)~=0)/(Time-1)),1));
    end

    for r =1:length(FinalRTGs.ID)
        overall_stats(tempCounter+length(FinalRTGs.ID)+r,h+1) = num2cell(FinalRTGs.relocate_to_other_rows(1,r));
    end

end

for n=1:length(Containers.ID)
    if FinalContainers.Departure_time(n) <= FinalContainers.Arrival_time(n)
        n
        error('!!!');
    end
end
