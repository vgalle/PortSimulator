function [Blocks,Rows,Containers,RTGs, BerthCranes] = update_horizon(Blocks,Rows,Containers,RTGs, BerthCranes,Time)

% Last Modification: 9/16
% Setareh

global H horizon horizon_estimated

R = length(Blocks.Rows_in_block(:,1));

day_of_this_Time = ceil(Time/1440);

Containers.Departure_zone( Containers.Departure_zone==2 & (day_of_this_Time-1)*1440 <= Containers.Departure_time & Containers.Departure_time < day_of_this_Time*1440) = 1;

Containers.Departure_zone(Containers.Departure_time >= Time & Containers.Departure_time<Time+horizon) =0;

for i=1:length(Blocks.ID)
% We sort the departure times of containers that are in the bay and from
% which we know the departure time (Departure zone = 0)
    locorder = sort(Containers.Departure_time(Containers.Status==0 & Containers.Block==i & Containers.Departure_zone == 0));
% Their block value is their place in the sorted list.
    for j=1:length(locorder)
        locid = Containers.ID(Containers.Departure_time==locorder(j));
        Containers.Block_value(Containers.ID==locid) = j;
        Rows.Config_value(H-Containers.Tier(Containers.ID==locid)+1,Containers.Column(Containers.ID==locid),Containers.Row(Containers.ID==locid)) = j;
    end
    for j=1:R
        Rows.Minimum(:,j+(i-1)*R) = mins_of_row(Rows.Config_value(:,:,j+(i-1)*R),Blocks.Number_cont(i));
    end    
end
