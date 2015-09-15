function [Rows,Containers] = Change_of_zone(Blocks,Rows,Containers)

% Last Modification: 2/2
% Virgile

global H
% This function updates the entire yard when we the time reached the end of
% a time zone.

% We first compute the size of the problem
R = length(Blocks.Rows_in_block(:,1));
% H = length(Rows.Config_value(:,1));

% Each zone decrease by one (e.g. zone 2 is now zone 1 as it is the next 
% one to be reveiled). All the containers that were known before and that
% are still there still stays zone 0.
Containers.Departure_zone(Containers.Departure_zone > 0) = Containers.Departure_zone(Containers.Departure_zone > 0) - 1;
% We need to update 3 things: Block_value, Config_value and Minimum. This
% is done below. Notice that the block value of the containers that are
% just being unveiled are necessarily higher than the ones that were known
% before now.
for i=1:length(Blocks.ID)
% We sort the cdeparture times of containers that are in the bay and from
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
