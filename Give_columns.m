function  [Stacks]  = Give_columns (Set_of_containers,B)

counter = 1;
Stacks = zeros(1,size(B,2));
Stacks_to_check = 1:size(B,2);
for i=1:length(Set_of_containers)
    for j=Stacks_to_check
        if sum(B(:,j)==Set_of_containers(i)) 
            Stacks(counter) = j;
            Stacks_to_check(Stacks_to_check==j) = [];
            counter = counter + 1;
        end
    end
end
Stacks = Stacks(1:counter-1);