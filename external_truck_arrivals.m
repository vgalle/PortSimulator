function arrival_times = external_truck_arrivals(lambda,n_trucks)

% Last Modification: 2/3
% Setareh

% Simulate arrivals of n_trucks as a Poisson process of mean lambda.

% lambda: truck/minute


arrival_times = zeros(1,n_trucks);
arrival_times(1) = exprnd(1/lambda);

for i=2:n_trucks
    inter_arrival_time = exprnd(1/lambda);
    arrival_times(i) = arrival_times(i-1) + inter_arrival_time;
end

sigma = randperm(n_trucks);
arrival_times = arrival_times(sigma);

% hist(inter_arrival_time,50);