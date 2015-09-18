function [Ships, Stack_Cont,Arrival_Ships] = Generate_stacking_containers(mu,lambda,Ships,n_cont_per_ship,numDays)

% Last Modification: 9/16
% Virgile

% This function generates the containers that are going to arrive during
% the simulation
% n_ships: number of ships we want to see arrive in the process. That is
% what should be fixed.
% n_cont_per_ship: numer of container arriving per ships.
% mu: arrival rate of ships
% lambda : arrival rate of trucks

% We first set the time of arrival of the ships corresponding to a Poisson
% porcess with mean arrival mu.

% let us assume that the containers will leave over a period of 3 days = 3*1440
% lambda = n_cont_per_ship/(3*1440);

n_total_ships = length(Ships.ID);
n_ships_per_day = n_total_ships/numDays;
Arrival_Ships = zeros(1,n_total_ships);
for n=0:numDays-1
    Arrival_Ships(1+(n*n_ships_per_day)) = (n*1440) + exprnd(1/mu);
    Ships.arrival_time(1+(n*n_ships_per_day))=Arrival_Ships(1+(n*n_ships_per_day));
end

if n_ships_per_day>1
    for n=0:numDays-1
        for i=2:n_ships_per_day
            inter_arrival_time = exprnd(1/mu);
            Arrival_Ships(i+(n*n_ships_per_day)) = Arrival_Ships(i-1+(n*n_ships_per_day)) + inter_arrival_time;
            Ships.arrival_time(i+(n*n_ships_per_day))=Arrival_Ships(i+(n*n_ships_per_day));
        end
    end
end

% Then we create the matrix. Each row corresponds to a ship and has length
% n_cont_per_ship columns corresponding to each container in this ship. The
% value given is the retrieval time (truck arrival).
% The truck arrivals are taken as a Poisson process with mean lambda and
% each container is randomly retrieved from the ship to the yard 
% (uniform permutation)

Stack_Cont = zeros(n_total_ships,n_cont_per_ship);

for i=1:n_total_ships
    Departure_times = zeros(1,n_cont_per_ship);
    Departure_times(1) = ceil(Ships.arrival_time(i)/1440)*1440 + exprnd(1/lambda);
    for j=2:n_cont_per_ship
        inter_arrival_time = exprnd(1/lambda);
        Departure_times(j) = Departure_times(j-1) + inter_arrival_time;
    end
    sigma = randperm(n_cont_per_ship);
    Stack_Cont(i,:) = Departure_times(sigma);
end


