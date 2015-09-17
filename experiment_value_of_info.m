Full_info = 0;

% approx. 3 ships in the first 6 hours 
n_ships = 3; %3;
mu = n_ships/(60*6);  

n_cont_per_ship = 350; %350

numDays = 3;

total_ships = numDays*n_ships;

%500 trucks in 12 hours
% lambda = 1000/(60*24); %1000/(60*24); 
% lambda = 1500/(60*24); %1000/(60*24); 
% lambda = 2000/(60*24); %1000/(60*24); 
% lambda = 2500/(60*24); %1000/(60*24); 
% lambda = 3000/(60*24); %1000/(60*24); 
lambda = 3500/(60*24); %1000/(60*24); 

B = 30;%30;
R = 50;%50;
C = 7;
numTiers = 4;
gamma = 0.9;
horizon_known_length = 30;
n_BC = 12; %12;
n_RTG = B;
n_trucks = 58; %58;

within_same_row= 1;

heu_relocation = {'Myopic', 'Lowest_Height','RI','Closest'};
Look_ahead = 5;
heu_stack = {'Myopic', 'Lowest_Height','RI','Closest'}; 

num_heuristics = size(heu_stack,2);

different_horizons_known = [15 60 120 180 1000000];


overall_stats2 = cell(0,length(different_horizons_known));
% 
% 
[Blocks,Rows,Containers, Ships, berthcranes, RTGs, trucks, max_zone, defined_horizon] = Initialization(Full_info,lambda,mu,total_ships,n_cont_per_ship,B,R,C,numTiers,...
                                                                            gamma,horizon_known_length,n_BC,n_RTG,n_trucks);
% % 
[overall_stats2{2,1},overall_stats2{3,1},overall_stats2{4,1} ,overall_stats2{5,1},overall_stats2{6,1},overall_stats2{7,1},overall_stats2{8,1},overall_stats2{9,1},...
 overall_stats2{10,1},overall_stats2{11,1},overall_stats2{12,1},overall_stats2{13,1},overall_stats2{14,1},overall_stats2{15,1},overall_stats2{16,1}...
 overall_stats2{17,1},overall_stats2{18,1},overall_stats2{19,1},overall_stats2{20,1},overall_stats2{21,1},overall_stats2{22,1}] = ...
deal('horizon','retrieved','unretrieved','discharged/Not Stacked','undischarged','stacked','numDays','total_rel','ave_rel','max_rel','total_ret_del','ave_ret_del','max_ret_del',...
    'total_stack_del','ave_stack_del','max_stack_del','min_dwell_time','max_dwell_time','n_ships','rate_trucks','rate_ships');

for m = 1:1 %length(heu_relocation)
    m
    which_heuristic = m;
    Heuristic_reloc = heu_relocation{which_heuristic};
    Heuristic_stack = heu_stack{which_heuristic};
    shift_index = (m-1)*length(different_horizons_known);

    if m==2 || m==4
      horizon_options = 1;
    else
       horizon_options = 5;
    end
        
    for h=1:horizon_options
        h
        overall_stats2{1,h+1+shift_index} = heu_relocation{which_heuristic};
        newHorizon_known = different_horizons_known(h);

        [Blocks,Rows,Containers] = update_horizon_for_experiment(Blocks,Rows,Containers,newHorizon_known);

        u=2;
        [cs,cr,N_reloc,N_retrieval,N_stacked,Time,sign_RTGs_status,FinalBlocks,FinalRows,FinalContainers,FinalRTGs, FinalBerthCranes,FinalTrucks, FinalShips] = ...
        Simulator(Blocks,Rows,Containers, berthcranes, RTGs,Ships, trucks,Heuristic_reloc,Heuristic_stack,within_same_row,Look_ahead);

        overall_stats2(u,h+1+shift_index) = num2cell(different_horizons_known(h));
        u=u+1;
        
        overall_stats2(u,h+1+shift_index) = num2cell(N_retrieval);
        u=u+1;
        
        overall_stats2(u,h+1+shift_index) = num2cell(sum(FinalContainers.Status==0 & FinalContainers.Departure_time<Time));
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(sum(FinalContainers.Arrival_time<Time & FinalContainers.Status==-2));
        u=u+1;
        
        overall_stats2(u,h+1+shift_index) = num2cell(sum(FinalContainers.Status==-1 & FinalContainers.Arrival_time<Time));
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(N_stacked);
        u=u+1;
        
%         overall_stats2(u,h+1+shift_index) = num2cell(sum(FinalContainers.Status==-2));
        overall_stats2(u,h+1+shift_index) = num2cell(numDays);
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(N_reloc);
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(N_reloc/N_retrieval);
        u=u+1;
        
        overall_stats2(u,h+1+shift_index) = num2cell(max(FinalContainers.Number_reloc));     
        u=u+1;
        
        retrieved_containers_dep_time = FinalContainers.Departure_time(FinalContainers.Status==1);        
        retrieved_containers_actual_dep_time = FinalContainers.Actual_departure_time(FinalContainers.Status==1);
        
        overall_stats2(u,h+1+shift_index) = num2cell(sum(retrieved_containers_actual_dep_time-retrieved_containers_dep_time));
        u=u+1;
        
        overall_stats2(u,h+1+shift_index) = num2cell(sum((retrieved_containers_actual_dep_time-retrieved_containers_dep_time))/N_retrieval);    
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(max(retrieved_containers_actual_dep_time-retrieved_containers_dep_time));    
        u=u+1;

        statusTemp = (FinalContainers.Status==0 | FinalContainers.Status==1) & FinalContainers.discharge_time~=inf;
        stacked_containers_discharge_time = FinalContainers.discharge_time(statusTemp);
        stacked_containers_actual_stack_time = FinalContainers.Actual_stacking_time(statusTemp);
        overall_stats2(u,h+1+shift_index) = num2cell(sum(stacked_containers_actual_stack_time-stacked_containers_discharge_time));
        u=u+1;

        overall_stats2(u,h+1+shift_index) = num2cell(sum((stacked_containers_actual_stack_time-stacked_containers_discharge_time))/N_stacked);    
        u=u+1;

        if isempty(stacked_containers_actual_stack_time-stacked_containers_discharge_time)
           overall_stats2{u,h+1+shift_index} = 'NA';
           u=u+1;
        else
            overall_stats2(u,h+1+shift_index) = num2cell(max(stacked_containers_actual_stack_time-stacked_containers_discharge_time));
            u=u+1;
        end
        
        statusTemp2 = (FinalContainers.Status==1) & FinalContainers.discharge_time~=inf;
        stack_time = FinalContainers.Actual_stacking_time(statusTemp2);
        departure_time = FinalContainers.Actual_departure_time(statusTemp2);
        
        if isempty(departure_time)
            overall_stats2{u,h+1+shift_index} = 'NA';
            u=u+1;
            overall_stats2{u,h+1+shift_index} = 'NA';
            u=u+1;
        else
            overall_stats2(u,h+1+shift_index) =  num2cell(min(departure_time- stack_time));
            u=u+1;
            overall_stats2(u,h+1+shift_index) = num2cell(max(departure_time- stack_time));
            u=u+1;
        end
        
        
%         temp = size(overall_stats2,1)+3;
                
        for n=1:total_ships
            containers_in_this_ship = FinalContainers.ID(FinalContainers.Ship==n);
            if sum(FinalContainers.Status(containers_in_this_ship)==-1)>0
                duration_of_discharge_process = inf;
            else
                last_containers_in_this_ship = containers_in_this_ship(end);
                first_container_in_this_ship = containers_in_this_ship(1);
                duration_of_discharge_process = FinalContainers.discharge_time(last_containers_in_this_ship) - FinalContainers.discharge_time(first_container_in_this_ship);
            end
            overall_stats2(22+n,h+1+shift_index) = num2cell(duration_of_discharge_process);
        end
        
        temp = 25;
        for r =1:length(RTGs.ID)
            overall_stats2{temp+r,1}=sprintf('RTG%d: utilization',r);
        end

        for r =1:length(RTGs.ID)
            overall_stats2{temp+length(RTGs.ID)+r,1}=sprintf('RTG%d:to_other_rows',r);
        end

    
    
        for r =1:length(FinalRTGs.ID)
            overall_stats2(temp+r,h+1+shift_index) = num2cell(sum(FinalRTGs.Status(r,:)~=0)/(Time-1));
        end
        for r =1:length(FinalRTGs.ID)
            overall_stats2(temp+length(FinalRTGs.ID)+r,h+1+shift_index) = num2cell(FinalRTGs.relocate_to_other_rows(1,r));
        end
        
    cs1=cs;
    cr1=cr;
    end


%     for n=1:length(Containers.ID)
%         if FinalContainers.Departure_time(n) <= FinalContainers.Arrival_time(n)
%             n
%             error('!!!');
%         end
%     end



end

overall_stats2(20,2:end) = num2cell(n_ships);
overall_stats2(21,2:end) =  num2cell(lambda);
overall_stats2(22,2:end) =  num2cell(mu);


