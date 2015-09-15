function  [is_optimal max_gap opt_rel_so_far best_solution_upto_this_stage total_nodes end_nodes ] = heu_in_tree_new_rule_laptop(config)
% clear ~config

global num_tier num_col counter_depth counter_total_nodes_output num_end_nodes_output 
start = tic;
num_tier = size(config,1);
num_col = size(config,2);
% num_containers = sum(sum(config>0));
counter_total_nodes_output = 0;

num_candidate_end_nodes = 1;
exact_rel=10000;
configs_for_next_stage = config;
opt_rel_so_far = 10000;
num_relocation_upto_this_node_temp = 0;
counter_depth = 0;

best_solution_upto_this_stage(1,1) = 10000;

num_end_nodes_output =zeros(1,0);

% *************************************************************************
% first check if LB = Heuristic for the initial configuration:
blockings = [];
for c=1:max(max(config))
    [col_c temp_c is_blocked] = locate_target (config, c);
    if is_blocked==1
        height_c = sum(config(:,col_c)>0);
        blockings_temp = config(num_tier - height_c+1:temp_c -1 , col_c);
        blockings_temp = blockings_temp (blockings_temp>c);
        blockings = [blockings ; blockings_temp];
    end
end 
blockings = unique(blockings);

if Casserta(config) == size(blockings,1)
    opt_rel_so_far = size(blockings,1);
    total_nodes = 1;
    end_nodes(1,1) = 1;
    is_optimal = 1;
    best_solution_upto_this_stage(1,1) = opt_rel_so_far;   
    max_gap = 0;
    return
end
% *************************************************************************
% Run the loop for 60 seconds or until the optimal is found!
% while ( exact_rel==10000 && toc(start)<=60)
while ( exact_rel==10000 )
    counter_depth = counter_depth+1; 
%     toc(start);
    configs_for_next_stage_temp = [];
    LB_UB_all_nodes = [];
    num_relocation_upto_this_node = [];
    
    for counter_nodes_to_be_explored = 1:num_candidate_end_nodes % branch on each of the end nodes

        [~, nodes, relocations] = branch (configs_for_next_stage (:,:,counter_nodes_to_be_explored) , 1);

        info_candidate_nodes_of_this_node_temp =  relocations;
        configs_for_next_stage_temp = cat(3,configs_for_next_stage_temp,nodes(:,:, info_candidate_nodes_of_this_node_temp(:,1)));
        num_relocation_upto_this_node_this_config = info_candidate_nodes_of_this_node_temp(:,2)+num_relocation_upto_this_node_temp(counter_nodes_to_be_explored,1);
     
        % add the previous relocations to the LB and UB along each path
        info_candidate_nodes_of_this_node_temp(:,3) = info_candidate_nodes_of_this_node_temp(:,3) + num_relocation_upto_this_node_temp(counter_nodes_to_be_explored,1);
        info_candidate_nodes_of_this_node_temp(:,4) = info_candidate_nodes_of_this_node_temp(:,4) + num_relocation_upto_this_node_temp(counter_nodes_to_be_explored,1);
    
        % put to gether thw LB, UB, and relocations for all end nodes of
        LB_UB_all_nodes = [LB_UB_all_nodes;info_candidate_nodes_of_this_node_temp];
        num_relocation_upto_this_node = [num_relocation_upto_this_node;num_relocation_upto_this_node_this_config];
        
        if toc(start)>120
            break
        end
    end
     
    temp = num_relocation_upto_this_node(LB_UB_all_nodes(:,3)==LB_UB_all_nodes(:,4)); % num_relocations of those with equal UB and LB
    temp2 = LB_UB_all_nodes(LB_UB_all_nodes(:,3)==LB_UB_all_nodes(:,4),3);  % nodes with UB=LB

    if ~isempty(temp)
      opt_rel_so_far = min(opt_rel_so_far , min(temp2));
    end

    clearvars temp temp2 temp3
        
    num_relocation_upto_this_node_temp = num_relocation_upto_this_node;
    
    min_UB = min(LB_UB_all_nodes(:,3));
    
    best_solution_upto_this_stage(1,counter_depth) = min(min_UB,min(best_solution_upto_this_stage));

    % choose those whose LB<min(all UB)
    configs_for_next_stage_temp = configs_for_next_stage_temp(:,:,LB_UB_all_nodes(:,4)<min_UB);
    num_relocation_upto_this_node = num_relocation_upto_this_node(LB_UB_all_nodes(:,4)<min_UB,1);
    num_relocation_upto_this_node_temp = num_relocation_upto_this_node_temp(LB_UB_all_nodes(:,4)<min_UB,1);

   
    if isempty(configs_for_next_stage_temp)
        total_nodes = counter_total_nodes_output; 
        end_nodes = num_end_nodes_output;
        is_optimal = 1;
        max_gap = 0;
        opt_rel_so_far = best_solution_upto_this_stage(1,end);
        return
    end
   
   LB_UB_all_nodes = LB_UB_all_nodes(LB_UB_all_nodes(:,4)<min_UB,:);

    configs_for_next_stage = [];
    configs_for_next_stage = configs_for_next_stage_temp;
    num_candidate_end_nodes = size(configs_for_next_stage,3);    
    
    % re-label the configs to start from one
    for i=1:num_candidate_end_nodes
        num_remaining_containers = sum(sum(configs_for_next_stage(:,:,i)>0));
        temp = configs_for_next_stage(:,:,i);
        temp(temp>0) = temp(temp>0)- (max(max(configs_for_next_stage(:,:,i))) - num_remaining_containers) ;
        configs_for_next_stage(:,:,i) = temp;
    end
end
if toc(start)>120
%     toc(start)
    opt_rel_so_far = best_solution_upto_this_stage(1,end);
    is_optimal = 0;
    total_nodes = counter_total_nodes_output; 
    end_nodes = num_end_nodes_output;
    max_gap = opt_rel_so_far - min(LB_UB_all_nodes(:,4));
    return;
end
total_nodes = counter_total_nodes_output; 
end_nodes = num_end_nodes_output;
is_optimal = 1;
max_gap =0;
end

%%
% function [pred, path, nodes, relocations, exact_rel] = branch (config, initial_retrievals)
function [path, nodes, relocations] = branch (config, initial_retrievals)

% clear ~config
global num_tier num_col counter_total_nodes_output num_end_nodes_output counter_depth
% 
% num_tier = size(config,1);
% num_col = size(config,2);
% num_containers = sum(sum(config>0));
nodes = zeros(num_tier, num_col, 0);
num_retrieved = zeros(0);
next_target = zeros(0);
flag_rel = zeros(0);

num_retrieved(1) = 0;

next_target(1) = 1;

num_nodes_last_stage = 1;
counter_total_nodes = 1;
copy_of_counter_total_nodes = 1;
counter_stage = 1;

nodes_stage = zeros(0,0);
nodes_stage (1,1) = 1;

pred = zeros(1,0);
pred(1) = 0;
nodes(:,:,1) = config;

path = zeros(0,0);
relocations = zeros(0,4);
exact_rel_so_far = 10000;


% run until "initial_retrievals" containers are retrieved
% while sum(num_retrieved(copy_of_counter_total_nodes - num_nodes_last_stage+1:end) >= initial_retrievals)<num_nodes_last_stage

    counter_nodes_this_stage = 0;
    counter_stage=counter_stage+1;

    % run for all end nodes of the last stage
    for i = 1:num_nodes_last_stage

%         nodes
        % if for this particular end node, "initial_retrievals" containers has not been retrieved
        if num_retrieved(copy_of_counter_total_nodes - num_nodes_last_stage + i ) < initial_retrievals       

            config_this_node = nodes(:,:,copy_of_counter_total_nodes - num_nodes_last_stage + i);
   
            [col_target temp_target is_blocked] = locate_target (config_this_node, next_target(copy_of_counter_total_nodes-num_nodes_last_stage+i));

            % if next target is not blcoked, retrieve it; update the config and the next target
            if is_blocked == 0
                counter_total_nodes = counter_total_nodes +1;
                nodes(:,:,counter_total_nodes) = config_this_node;
                nodes(temp_target,col_target,counter_total_nodes)=0;
                pred(counter_total_nodes) = copy_of_counter_total_nodes - num_nodes_last_stage + i;
                counter_nodes_this_stage = counter_nodes_this_stage+1;
                nodes_stage (counter_nodes_this_stage,counter_stage+1) = counter_total_nodes;
                num_retrieved(counter_total_nodes)=num_retrieved(pred(counter_total_nodes))+1;
                next_target(counter_total_nodes)=next_target(pred(counter_total_nodes))+1;
                flag_ret (counter_total_nodes)=1;
            end
            
            % if next target is blcoked, do the relocation; update the config
            if is_blocked == 1
                [destination_candidates , blocking,temp_blocking ,col_blocking]=find_destination(config_this_node,next_target(copy_of_counter_total_nodes-num_nodes_last_stage+i));
                for j = 1: size(destination_candidates,1)   % destination_candidates [col_index, min, height]
                    counter_total_nodes = counter_total_nodes +1;
                    pred(counter_total_nodes) = copy_of_counter_total_nodes - num_nodes_last_stage + i;
                    nodes(:,:,counter_total_nodes) = config_this_node;
                    nodes(num_tier - destination_candidates(j,3) , destination_candidates(j,1) , counter_total_nodes) = blocking;
                    nodes(temp_blocking,col_blocking,counter_total_nodes)=0;
                    counter_nodes_this_stage = counter_nodes_this_stage+1;
                    nodes_stage (counter_nodes_this_stage,counter_stage+1) = counter_total_nodes;
                    num_retrieved(counter_total_nodes)=num_retrieved(pred(counter_total_nodes));
                    next_target(counter_total_nodes)=next_target(pred(counter_total_nodes));
                    flag_rel(counter_total_nodes)=1;
                    flag_ret(counter_total_nodes)=0;
                end
            end        
            
%       If for this particular end node, "initial_retrievals" containers have been retrieved, just duplicate the end node
        else
            counter_total_nodes = counter_total_nodes +1;
            counter_nodes_this_stage = counter_nodes_this_stage+1;
            nodes(:,:,counter_total_nodes) = nodes(:,:,copy_of_counter_total_nodes - num_nodes_last_stage + i);

            pred(counter_total_nodes) = copy_of_counter_total_nodes - num_nodes_last_stage + i;
            num_retrieved(counter_total_nodes)=num_retrieved(copy_of_counter_total_nodes - num_nodes_last_stage + i);

        end            
    end
    
    num_nodes_last_stage = counter_nodes_this_stage;
    copy_of_counter_total_nodes = counter_total_nodes;
   
% end

num_end_nodes_output(1,counter_depth) = num_nodes_last_stage;
counter_total_nodes_output = counter_total_nodes_output+counter_total_nodes;

for n = 1:num_nodes_last_stage
    path(n,counter_stage) = counter_total_nodes-num_nodes_last_stage+n;
    for s=counter_stage-1:-1:1
        path(n,s) = pred(path(n,s+1));
    end
end

flag_rel(end+1:counter_total_nodes)=0;

% Relocations--> each row for one path; col1: end node of the path;
% col2: num_relocations of that path; col3: UB for rhe end node
% col4: LB for rhe end node
for p = 1:size(path,1)
    blockings=[];
    relocations(p,1)= path(p,end);
    relocations(p,2) = sum(flag_rel(path(p,1:end)));
    node_temp = nodes(:,:,path(p,end));
    if flag_ret(path(p,end))
        node_temp = node_temp - (initial_retrievals*(node_temp>0)); % re-label the containers starting from one
    end
    relocations(p,3) = Casserta(node_temp)+relocations(p,2);   %upper bound: rel by heuristic for the rest of the tree
    % compute the LB for the end node
    for c=1:max(max(node_temp))
        [col_c temp_c is_blocked] = locate_target (node_temp, c);
        if is_blocked==1
            height_c = sum(node_temp(:,col_c)>0);
            blockings_temp = node_temp(num_tier - height_c+1:temp_c -1 , col_c);
            blockings_temp = blockings_temp (blockings_temp>c);
            blockings = [blockings ; blockings_temp];
        end
    end 
    blockings = unique(blockings);
    relocations(p,4) = size(blockings,1)+relocations(p,2);   %lower bound: number of blocking containers
end

% min_UB = min(relocations(:,3));
% 
% relocations = relocations(relocations(:,4)<=min_UB,:); % choose those whose LB<min(all UB)
% 
% 
% temp = relocations(relocations(:,3)==relocations(:,4),:); %those with LB=UB
% exact_rel_temp = min(temp(:,3)); %LB_min of all with UB=LB
% exact_rel_temp2 = min(relocations(:,4));  % LB_min of all
% if isempty(exact_rel_temp)
%     exact_rel = 10000;
% else
%     exact_rel = (exact_rel_temp==exact_rel_temp2)*exact_rel_temp + (exact_rel_temp2<exact_rel_temp)*10000 ; %if LB_min is such that LB=UB then exact_rel = LB_min
%     exact_rel_so_far = min(exact_rel_so_far,exact_rel_temp);
% end
% 
% keyboard
end

%%
function [destination_candidates topmost_blockings temp_blocking col_blocking] = find_destination (config, target_container)

global num_tier num_col 
    
    [temp_target col_target] = find(config==target_container);   
    
    height_col_target = sum(config(:,col_target)>0);
    
    all_blocking = config(num_tier-height_col_target+1:temp_target-1 , col_target);
    topmost_blockings = all_blocking (1);
    
    [temp_blocking col_blocking] = find(config==topmost_blockings);
    
    
    candidates = (1:num_col)';  % potential candidates = all columns
    candidates(col_blocking,1) = 0;  % exclude the origin column from potential candidates 
    candidates(sum(config>0)==num_tier) = 0; % exclude full columns from potential candidates 
    eligible_candidates = candidates(candidates>0); 
    temp = config(:,eligible_candidates(:));
    temp(temp==0)=inf;
    
    eligible_candidates(:,2) = min(temp,[],1); % find the minimum of each column
%         eligible_candidates_j(eligible_candidates_j==n_container+1)=0;
    good_candidates = eligible_candidates(eligible_candidates(:,2)>topmost_blockings ,:);

    bad_candidates = eligible_candidates(eligible_candidates(:,2)<=topmost_blockings ,:);
%     num_good_candidates = size(good_candidates,1);
    
%     col1: column number; col2: minimum of column; col3:height of column
    good_candidates(:,3) = sum(config(:,good_candidates(:,1))>0)';
    bad_candidates(:,3) = sum(config(:,bad_candidates(:,1))>0)';

    [min_good_cand pos_min_good_cand]= min(good_candidates(:,2));
%     good_candidates = good_candidates(pos_min_good_cand,:);
    
% % %     if (isempty(bad_candidates))
% % %         destination_candidates = good_candidates;   % if there is no bad column, choose all the good ones!
% % %     end
% % %         
% % %     if (isempty(good_candidates))
% % %         destination_candidates = bad_candidates; % if there is no good column, choose all the bad ones!
% % %     end
    
    larger_than_relocating_container = [];
  
    destination_candidates = [good_candidates ;bad_candidates];
    % New rule:
% % %     if (~isempty(good_candidates) && ~isempty(bad_candidates))
% % %         for j = target_container:topmost_blockings-1 
% % %             [col_this temp_this is_blocked_this] = locate_target (config, j);
% % %             if is_blocked_this
% % %                 height_this_col = sum(config(:,col_this)>0);
% % %                 containers_on_top_of_this = config(num_tier-height_this_col+1 : temp_this-1 , col_this);
% % % %                 keyboard
% % %                 larger_than_relocating_container = [larger_than_relocating_container ; containers_on_top_of_this(containers_on_top_of_this>topmost_blockings)];
% % %             end
% % %         end
% % %         if ~isempty(larger_than_relocating_container)
% % %             destination_candidates = [good_candidates; bad_candidates];
% % %         else
% % %             destination_candidates = good_candidates;
% % %         end
% % %     end        

%     if (isempty(good_candidates)~=1)
%         destination_candidates = good_candidates;
% 
%     else
%        num_bad_candidates_j = size(bad_candidates,1);

end
%%
function [col_target temp_target is_blocked] = locate_target (config, target_container)


    global num_tier 

    [temp_target col_target] = find(config==target_container);
    tier_target = num_tier - temp_target +1;
   
    height_col_target = sum(config(:,col_target)>0);
%     if tier_target<height_col_target ==> is_blocked =1
    is_blocked = tier_target<height_col_target; 
   
%     num_on_top = sum(config(1:temp_target-1,col_target)>0);
end

%%
function [N]=Casserta(B)

% Casserta is a function which solve the CRP problem with full information.
% Its only entry is a bay B and it returns N the number of relocations
% needed and D the delays of each container.

% First we compute the numbers of containers, the position of every container
% the height and the minimum of every column of the bay.
% By convienience, is the column is empty, we set the minimum at m+1, where
% m is the number of containers.
m=0;
P=zeros(size(B,1)*size(B,2),2);
H=zeros(1,size(B,2));
for j=1:size(B,2);
    for i=1:size(B,1);
        if B(i,j)~=0;
            m=m+1;
            P(B(i,j),1)=i;
            P(B(i,j),2)=j;
            if H(j)==0;
                H(j)=i;
            end;
        end;
    end;
end;

Pos=P(1:m,1:2);

minimum=(m+1)*ones(1,size(B,2));
for j=1:size(B,2);
    if H(j)~=0;
        for i=H(j):size(B,1);
            if minimum(j)>B(i,j);
                minimum(j)=B(i,j);
            end;
        end;
    end;
end;
N=0;
counter_ret=1;
counter_rel=1;
counter_vnt=1;
% N is the number of "improductive" relocations
D=zeros(1,m);
% D is the list of the delays of all containers. We suppose that each
% truck i arrive at time i
T=1;
% T is the time step we are in

position(:,:,T)=Pos;
for n=1:m;
% We iterate for each container n
% First we compute its position in the bay, I and J are its coordinates
    I=Pos(n,1);
    J=Pos(n,2);
    
    while B(I,J)~=0;
% We loop until container n is retrieved
        if I==H(J);
% If it is available, we retrieve it and we update the bay and its feature 
% such as height, position of n and minimum.
            D(n)=T-n;
            B(I,J)=0;
            if H(J)==size(B,1);
                H(J)=0;
            else
                H(J)=H(J)+1;
            end;
            Pos(n,1)=0;
            Pos(n,2)=0;
            minimum(J)=m+1;
            if I<size(B,1);
                for i=I+1:size(B,1);
                    if minimum(J)>B(i,J);
                        minimum(J)=B(i,J);
                    end;
                end;
            end;
            
%            fprintf('retrieve container %d at time %d from column %d and tier %d \n',n , T, J, size(B,1)-I+1); 
           
           retrieval(counter_ret,1) = n; retrieval(counter_ret,2) = T; 
           retrieval(counter_ret,3) = J; retrieval(counter_ret,4) = size(B,1)-I+1;
           counter_ret=counter_ret+1;
           position(:,:,T+1) = Pos;
%            keyboard
           
        else
% We are goign to apply the heuristic of Casserta to choose on which column
% to move the top of column J denoted by r. We note this column C.
            r=B(H(J),J);
            q=0;
            Q=m+2;
            for j=1:size(B,2);
                if j~=J;
                    if H(j)~=1;
                        if q<minimum(j) && minimum(j)<r;
                            C=j;
                            q=minimum(j);
                        end
                        if r<minimum(j) && minimum(j)<Q;
                            C=j;
                            Q=minimum(j);
                            q=r;
                        end
                    end
                end
            end
             
            destination_tier = find(B(:,C)~=0,1) - 1;
            if (isempty(find(B(:,C)~=0,1))) 
                destination_tier=size(B,1); 
            end
%             fprintf('relocate container %d at time %d from column %d and tier %d to column %d and tier %d \n ',r , T, J, size(B,1)-H(J)+1, C, size(B,1) - destination_tier + 1);
           relocation(counter_rel,1) = r; relocation(counter_rel,2) = T; 
           relocation(counter_rel,3) = J; relocation(counter_rel,4) = size(B,1)-H(J)+1;
           relocation(counter_rel,5) = C; relocation(counter_rel,6) = size(B,1) - destination_tier + 1;
           counter_rel=counter_rel+1;
           pos_temp = Pos;
           pos_temp(r,1)=destination_tier;
           pos_temp(r,2)=C;
           position(:,:,T+1) = pos_temp;
% And we move the top of column J on the top of column C and we update all
% the features of the bay (position, minimum and height)
            if minimum(C)==m+1;
                minimum(C)=r;
            else
                if minimum(C)>r;
                    minimum(C)=r;
                end
            end
            if H(C)==0;
                H(C)=size(B,1);
            else
                H(C)=H(C)-1;
            end
            B(H(C),C)=r;
            Pos(r,1)=H(C);
            Pos(r,2)=C;
            B(H(J),J)=0;
            H(J)=H(J)+1;
% Finally we count this as a relocation
            N=N+1;
        end
% We update the time
    T=T+1;
    end
end
end

