% Train the network using the given data:
[~,~,training_data] = xlsread('spaceships-train.xlsx'); % read in data
input_data = getFeatures(training_data); % extract the features from the data and store in a matrix
A = linearAssociator(input_data); % build the linear associator
A = errorCorrection(A, input_data, training_data); % apply the delta learning rule

% Read in noisy data:
[~,~,noisy_data] = xlsread('noisy-data.xlsx');
noisy_data_matrix = getFeatures(noisy_data);

% Test the training set and display the results:
%disp('Testing the training data:');
%test_planets = testData(A, input_data);
%[error_indices] = errorCheck(test_planets)
%num_errors = size(error_indices,2)

    
% Test the noisy dataset and display the results:
disp('Testing the noisy data:');
noisy_planets = testData(A, noisy_data_matrix); % displays ships and predicted origin
error_indices = errorCheck(noisy_planets) % displays the ship numbers that are incorrect
num_errors = size(error_indices,2) 