function [Blocks,Rows,Containers] = Retieval(target_ID,Blocks,Rows,Containers,Maxzone,Time)

% Last Modification: 9/16
% Virgile

% This function updates the configuration when the retrieval from the
% target container with target_ID is performed.

global H

% We decrease by one the number of containers in the block of the container
% and also in its row.
Blocks.Number_cont(Containers.Block(target_ID)) = Blocks.Number_cont(Containers.Block(target_ID)) - 1;
Rows.Number_cont(Containers.Row(target_ID)) = Rows.Number_cont(Containers.Row(target_ID)) - 1;
% We update the Config_value of the row. We start by setting a 0 where the
% container was. Then we retrieve 1 to each of the values that are
% currently in the same block
Rows.Config_value(H-Containers.Tier(target_ID)+1,Containers.Column(target_ID),Containers.Row(target_ID)) = 0;
Rows.Config_value(:,:,Rows.Block == Containers.Block(target_ID)) = Rows.Config_value(:,:,Rows.Block == Containers.Block(target_ID)) - 1;
Rows.Config_value(Rows.Config_value == -1) = Rows.Config_value(Rows.Config_value == -1) + 1;
% We update the Config_value by emptying the slot of the container to 0
Rows.Config_id(H-Containers.Tier(target_ID)+1,Containers.Column(target_ID),Containers.Row(target_ID)) = 0;
% We decrease the height of this column by one and compute the new minimum
Rows.Height(:,Containers.Row(target_ID)) = heights_of_row(Rows.Config_value(:,:,Containers.Row(target_ID)));
Rows.Minimum(:,Containers.Row(target_ID)) = mins_of_row(Rows.Config_value(:,:,Containers.Row(target_ID)),Blocks.Number_cont(Containers.Block(target_ID)));
% Each container in the block has its value decreased by one.
Containers.Block_value(Containers.Block_value~=0 & Containers.Block == Containers.Block(target_ID)) = Containers.Block_value(Containers.Block_value~=0 & Containers.Block == Containers.Block(target_ID)) - 1;
% The target container has now status 1 as it has been retrieved
Containers.Status(target_ID) = 1;
% All its coordinates and value are zeros since it is not in the bay anymore.
Blocks.Free_spots(Containers.Block(target_ID)) = Blocks.Free_spots(Containers.Block(target_ID))+1;
Containers.Block(target_ID) = -Containers.Block(target_ID) ; 
Containers.Row(target_ID) = -Containers.Row(target_ID);
Containers.Column(target_ID) = -Containers.Column(target_ID);
Containers.Tier(target_ID) = -Containers.Tier(target_ID);
Containers.Block_value(target_ID) = 0;
% Finally we set its departure time to Time and compute the delay.
Containers.Actual_departure_time(target_ID) = Time;
Containers.Delay(target_ID) = Time - Containers.Departure_time(target_ID);


