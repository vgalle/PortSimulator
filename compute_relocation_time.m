function t = compute_relocation_time (origin_row, destination_row)

% Last Modification: 2/2
% Setareh


distance = destination_row - origin_row;

if 0<=distance && distance<5
    t = 4;
end


if 5<=distance && distance<10
    t = 5;
end


if 10<=distance && distance<15
    t = 6;
end

if 15<=distance 
    t = 7;
end