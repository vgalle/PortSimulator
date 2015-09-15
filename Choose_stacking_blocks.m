function [chosen_blocks,Numb_of_blocks] = Choose_stacking_blocks(Blocks,Numb_of_blocks,Numb_of_cont_to_stack)

% Last Modification: 2/8
% Virgile

% This function chooses the blocks that could potentially be selected for
% the stacking of incoming containers.

% Numb_of_blocks is the max number of blocks that we want to consider
% to stack our containers.

B = length(Blocks.ID);
Bl = zeros(2,B);
Bl(1,:) = Blocks.ID;
Bl(2,:) = min(Blocks.Free_spots,Blocks.unassigned_slots_to_ships);
% We first create a matric with:
%     Bl = [   id1         id2     ...   first row is id of the blocks
%          free_spot1  free_spot2  ...]  second row is free spot 


% We sort the free_pot array to consider the emptier blocks first
[order, index_sorted] = sort(Bl(2,:),'descend');
% We take the Numb_of_blocks first ones.
chosen_blocks = Blocks.ID(index_sorted(1:Numb_of_blocks));

% If there is enough spot to stack all the incoming containers, we do not
% need to consider other blocks. Otherwise we add them one by one until we
% have enough free spot
i = Numb_of_blocks + 1;
while sum(order(1:i-1)) < Numb_of_cont_to_stack
    chosen_blocks(i) = Blocks.ID(index_sorted(i));
    i = i + 1;
end
% We output the selected block and the number of blocks needed to stack
% the incoming containers.
chosen_blocks = chosen_blocks(chosen_blocks~=0);
Numb_of_blocks = i - 1;
