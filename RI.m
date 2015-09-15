function  [rows_cols_loc_with_min_RI]  = RI (Rows , Containers, ID_this_container, row_cols_for_computing_RI,H)

% Last Modification: 2/2
% Setareh
% The RI heuristic computes a “reshuffling index” which is defined as
% The RI of the column withrespect to an incoming or reshuffled 
% container is the number of containers in the column that should 
% be retrieved earlier than the incoming container.
% Then, an incoming or reshuffling container is
% placed on the column with the lowest RI. 

% row_cols_for_computing_RI says compute RI for which columns in which rows
% row_cols_for_computing_RI = [r1  r2  r3  ...    
%                              c1  c2  c3  ...]
% ?? the value is zero?! ??
% !!FIX THIS!!

reshuffling_index = zeros(1,size(row_cols_for_computing_RI,2));
value = Containers.Departure_time(ID_this_container);
zone_incoming = Containers.zone(ID_this_container);

for i=1:size(row_cols_for_computing_RI,2)  
   
     config_id_this_column = Rows.Config_id(:,row_cols_for_computing_RI(2,i),row_cols_for_computing_RI(1,i));
     dep_time_this_column = Containers.Departure_time(config_id_this_column(config_id_this_column~=0)); 

     % in the sace of incomplete info
    tempZone =  Containers.Departure_zone(config_id_this_column(config_id_this_column>0));
    if sum(Containers.Departure_zone)>0
        num_smaller_zone_below_new_container = sum(tempZone<zone_incoming);
        
        num_same_zone_below_new_container = sum(tempZone==zone_incoming);
        
        reshuffling_index(1,i) = num_smaller_zone_below_new_container + ((num_same_zone_below_new_container==0)*0)+...
                           ((num_same_zone_below_new_container==1)*1/2) +... 
                           ((num_same_zone_below_new_container==2)*1) + ...
                           ((num_same_zone_below_new_container==3)*3/2);
        
    % in the case of complete info
    else
        reshuffling_index(1,i) = sum(dep_time_this_column<value);        
    end
                           
end

min_RI = min(reshuffling_index);
loc_min_RI = reshuffling_index(1,:) == min_RI;

% rows_cols_loc_with_min_RI = [r1    r2    r3 ...
%                          c1    c2    c3 ...
%                          loc1 loc2 loc3 ...];

rows_cols_loc_with_min_RI = row_cols_for_computing_RI(:,loc_min_RI);
rows_cols_loc_with_min_RI(3,:) = find(reshuffling_index == min_RI);

