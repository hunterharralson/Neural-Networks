function newA = errorCorrection(A, input_data, training_data)
% apply the delta rule to the linear associator
%
% INPUTS:
%   A - the linear associator matrix storing weights of connections
%   input_data - matrix storing f vectors (each ship) and its probabilities
%   training_data - initial data from the excel file
% 
% OUTPUT:
%   newA - corrected linear associator

num_learning_trials = 10000; % num times we correct the network
num_ships = size(training_data,1);
k = 1; % learning constant

% desired output matrix (stores each g vector)
g_values = zeros(20,4);
j = 1;
for i=1:5:20
    g_values([i:i+4],j) = 1; % assign a 1 for desired planet
    j = j+1;
end

for i = 1:num_learning_trials 
    rand_vec = randperm(num_ships);
    for ship = 1:num_ships
        fi = input_data(:,rand_vec(ship));
        gi = (g_values(rand_vec(ship),:))';
        g_prime = A*fi;
        delta_A = k*(gi - g_prime)*fi'; % apply delta learning rule
        A = A + delta_A; % update the overall linear associator
    end
    k = 1/i; % slowly decrease the learning constant
end

newA = A;
end