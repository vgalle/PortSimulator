function  [selected_row, selected_col, selected_tier, same_row]  = ...
    RI_relocate (ID_this_container, within_same_row, Blocks, Rows, Containers)

% The RI heuristic computes a “reshuffling index” which is defined as
% The RI of the column withrespect to an incoming or reshuffled 
% container is the number of containers in the column that should 
% be retrieved earlier than the incoming container.
% Then, an incoming or reshuffling container is
% placed on the column with the lowest RI. 

% Last Modification: 9/16
% Virgile
global H 


blockID_this_container = Containers.Block(ID_this_container);

value = Containers.Departure_time(ID_this_container);
zone_incoming = Containers.Departure_zone(ID_this_container);


rowID_this_container = Containers.Row(ID_this_container);
col_this_container = Containers.Column(ID_this_container);


% If we only consider moves in the same row
if within_same_row
    
    containers_ID_in_this_bay = Rows.Config_id(:,:,rowID_this_container);
    height = Rows.Height(:,rowID_this_container);
    minimum = Rows.Minimum(:,rowID_this_container);
%     We start with all possible col_this_container as candidate col_this_containers in the row
%     target_cols=[r1    r2  ...   first row row is row ID
%                  c1    c2  ...   second row is column number 
%                  h1    h2  ...   third row is the height
%                  m1    m2  ...   forth row is the minimum
%                  R1    R2  ...]  fifth row is the RI score
    target_cols = zeros(5,size(containers_ID_in_this_bay,2));
    target_cols(1,:) = rowID_this_container*ones(1,size(target_cols,2));
    target_cols(2,:) = 1:size(target_cols,2);
    target_cols(3,:) = height;
    target_cols(4,:) = minimum;
    for i=1:size(target_cols,2)
        config_id_this_column = containers_ID_in_this_bay(:,i);
        dep_time_this_column = Containers.Departure_time(config_id_this_column(config_id_this_column~=0)); 

     % in the case of incomplete info
        tempZone =  Containers.Departure_zone(config_id_this_column(config_id_this_column>0));
        if sum(Containers.Departure_zone)>0
            num_smaller_zone_below_new_container = sum(tempZone<zone_incoming);
            num_same_zone_below_new_container = sum(tempZone==zone_incoming);
            target_cols(5,i) = num_smaller_zone_below_new_container + ((num_same_zone_below_new_container==0)*0)+...
                               ((num_same_zone_below_new_container==1)*1/2) +... 
                               ((num_same_zone_below_new_container==2)*1) + ...
                               ((num_same_zone_below_new_container==3)*3/2);

        % in the case of complete info
        else
            target_cols(5,i) = sum(dep_time_this_column<value);        
        end
    end
    
%     eliminate full columns
    target_cols = target_cols(:,target_cols(3,:) < H);

%     eliminate the column of this container 
    target_cols(:,target_cols(1,:)==rowID_this_container & target_cols(2,:)==col_this_container)=[];

%     if still there is no column, look in other rows
    if isempty(target_cols)
        within_same_row = 0;
    end
end

if within_same_row
%     find minimum R (according to the KimHong heuristic)
    min_R = min(target_cols(5,:));

%     find which column(s) have minimum weight
    loc_min = find(target_cols(5,:) == min_R);
    
    cols_with_min_R = zeros(5,length(loc_min));
    cols_with_min_R(1,:) = target_cols(1,loc_min); %row
    cols_with_min_R(2,:) = target_cols(2,loc_min); %column
    cols_with_min_R(3,:) = target_cols(3,loc_min); %height
    cols_with_min_R(4,:) = target_cols(4,loc_min); %minimum
    cols_with_min_R(5,:) = repmat(min_R, [1 , length(loc_min)]); %R
    
%     then choose the highest column(s)
    cols_with_min_R = cols_with_min_R(:,cols_with_min_R(3,:)>=max(cols_with_min_R(3,:)));
    
%     break further tie by moving to closest
    min_distance = min(abs(cols_with_min_R(2,:) - col_this_container));
    cols_with_min_R = cols_with_min_R(:,abs(cols_with_min_R(2,:) - col_this_container)<= min_distance);
    
%     break any further tie by moving to the column with smallest index 
    cols_with_min_R = cols_with_min_R(:,cols_with_min_R(2,:)==min(cols_with_min_R(2,:)));
    
    selected_row = cols_with_min_R(1);
    selected_col = cols_with_min_R(2);
    selected_tier = Rows.Height(selected_col,selected_row)+1;

else
%     We start with all possible col_this_container as candidate
%     col_this_containers in the block
%     target_cols=[r1    r2  ...   first row row is row ID
%                  c1    c2  ...   second row is column number 
%                  h1    h2  ...   third row is the height
%                  m1    m2  ...   forth row is the minimum
%                  R1    R2  ...]  fifth row is the R score of ENAR

    counter = 1;
    rowsID_in_this_block = Blocks.Rows_in_block(:,blockID_this_container);
    target_cols = zeros(5,0);
    for r=1:size(rowsID_in_this_block,1)
        containersID_in_this_row = Rows.Config_id(:,:,rowsID_in_this_block(r));
        for c=1:size(containersID_in_this_row,2)
            target_cols(1,counter) = rowsID_in_this_block(r);
            target_cols(2,counter) = c;
            target_cols(3,counter) = Rows.Height(c,rowsID_in_this_block(r));
            target_cols(4,counter) = Rows.Minimum(c,rowsID_in_this_block(r));

            config_id_this_column = containersID_in_this_row(:,c);
            dep_time_this_column = Containers.Departure_time(containersID_in_this_row(containersID_in_this_row~=0)); 

         
            % in the sace of incomplete info
            tempZone =  Containers.Departure_zone(config_id_this_column(config_id_this_column>0));
            if sum(Containers.Departure_zone)>0
                num_smaller_zone_below_new_container = sum(tempZone<zone_incoming);
                num_same_zone_below_new_container = sum(tempZone==zone_incoming);
                target_cols(5,counter) = num_smaller_zone_below_new_container + ((num_same_zone_below_new_container==0)*0)+...
                                   ((num_same_zone_below_new_container==1)*1/2) +... 
                                   ((num_same_zone_below_new_container==2)*1) + ...
                                   ((num_same_zone_below_new_container==3)*3/2);

            % in the case of complete info
            else
                target_cols(5,counter) = sum(dep_time_this_column<value);        
            end

            counter = counter + 1;
        end
    end  
    
    
    
%     eliminate full columns
    target_cols = target_cols(:,target_cols(3,:) < H);

%     eliminate the column of this container 
    target_cols(:,target_cols(1,:)==rowID_this_container & target_cols(2,:)==col_this_container)=[];

%     find minimum R (according to the KimHong heuristic)
    min_R = min(target_cols(5,:));

%     find which column(s) have minimum weight
    loc_min = find(target_cols(5,:) == min_R);
    
    cols_with_min_R = zeros(5,length(loc_min));
    cols_with_min_R(1,:) = target_cols(1,loc_min); %row
    cols_with_min_R(2,:) = target_cols(2,loc_min); %column
    cols_with_min_R(3,:) = target_cols(3,loc_min); %height
    cols_with_min_R(4,:) = target_cols(4,loc_min); %minimum
    cols_with_min_R(5,:) = repmat(min_R, [1 , length(loc_min)]); %R
    
%     first pick the columns in the same row
    temp = cols_with_min_R(:,cols_with_min_R(1,:)==rowID_this_container);
    if ~isempty(temp)
        cols_with_min_R = temp;
    end

%     then choose the highest column(s)
    cols_with_min_R = cols_with_min_R(:,cols_with_min_R(3,:)>=max(cols_with_min_R(3,:)));
    
%     break further tie by moving to closest
    min_distance_row = min(abs(cols_with_min_R(1,:) - rowID_this_container));
    cols_with_min_R = cols_with_min_R(:,abs(cols_with_min_R(1,:) - rowID_this_container)<= min_distance_row);
    min_distance_col = min(abs(cols_with_min_R(2,:) - col_this_container));
    cols_with_min_R = cols_with_min_R(:,abs(cols_with_min_R(2,:) - col_this_container)<= min_distance_col);
    
%     break any further tie by moving to the column with smallest index 
    cols_with_min_R = cols_with_min_R(:,cols_with_min_R(2,:)==min(cols_with_min_R(2,:)));
    
    selected_row = cols_with_min_R(1);
    selected_col = cols_with_min_R(2);
    selected_tier = Rows.Height(selected_col,selected_row)+1;

end
    
same_row = within_same_row;
    

                
    
    