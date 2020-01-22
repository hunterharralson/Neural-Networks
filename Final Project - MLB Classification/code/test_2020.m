% --- Trains the network with all players and tests classification of 2020
% HOF nominees ---


[~,~,training_data] = xlsread('training_data.xlsx');
training_data(1,:) = [];
desired_output = cell2mat(training_data(:,38))';
data = training_data(:,5:37); % cut out names,ids,and year, and HOFornah
data = cell2mat(data);
nans = isnan(data);
data(nans) = 0;
data(:,1:24) = data(:,1:24)/10;
data = data/norm(data);
input = data;

num_inputs = 33; 
num_patterns = 672;
num_hidden_units = 10;
num_output_units = 1;
num_epochs = 500;


input = data;
desired_output = cell2mat(training_data(:,38))';

input = input';

% create matrix for the weights between input and hidden layer
w_fg = rand(num_hidden_units, num_inputs); % 3x8
w_fg(:) = w_fg(:) - 0.5;

% create matrix for the weights between hidden layer and output
w_gh = rand(num_output_units, num_hidden_units); % 1x3
w_gh(:) = w_gh(:) - 0.5;

output_error = zeros(1,num_patterns); % vector to store errors of each pattern
sse_values = zeros(1,num_epochs);

% iterate through the model 
for i = 1:num_epochs
    
   % one pattern at a time
   for curr_pattern = 1:num_patterns
       input_to_hidden = w_fg * input(:,curr_pattern);
       hidden_activation = activation_fn(input_to_hidden);
       input_to_output = w_gh * hidden_activation;
       output_activation = activation_fn(input_to_output);
       output_error = desired_output(curr_pattern) - output_activation;
       
       % determine weight changes
       dw_fg = diag(hidden_activation .* (1-hidden_activation)) * w_gh' * output_error * (output_activation .* (1-output_activation)) * input(:,curr_pattern)';
       dw_gh = (output_activation .* (1-output_activation)) * output_error * hidden_activation';
       
       % apply weight changes
       w_fg = w_fg + dw_fg;
       w_gh = w_gh + dw_gh;
   end
   
   % compute sum of squared errors for all input patterns
   input_to_hidden = w_fg * input; % pass activation from input units to hidden units
   hidden_activation = activation_fn(input_to_hidden); % determine hidden unit activation
   input_to_output = w_gh * hidden_activation; % pass activation from hidden to output units
   output_activation = activation_fn(input_to_output); % determine output activity 
   output_errors = desired_output - output_activation;
   sse = trace(output_errors' * output_errors); % calculate sse
   sse_values(i) = sse;
      
   if sse < 0.01
       break;
   end
end

% upload current player data 
[~,~,data_2020] = xlsread('testing_data.xls');
class_2020 = data_2020(:,5:37);
class_2020 = cell2mat(class_2020);
nans = isnan(class_2020);
class_2020(nans) = 0;
class_2020(:,1:24) = class_2020(:,1:24)/10;
class_2020 = class_2020/norm(class_2020);
class_2020 = class_2020';
test_data = class_2020;
test_data(:,:)=test_data(:,:)/5;

% testing 
total = 1;
for i = 1:size(test_data,2)
    input_to_hidden = w_fg * test_data(:,i);
    hidden_activation = activation_fn(input_to_hidden);
    input_to_output = w_gh * hidden_activation;
    output_activation = activation_fn(input_to_output);
    classification = round(output_activation);
    
    if classification == 1
        HOF_players{total,1} = data_2020{i,2};
        HOF_players{total,2} = data_2020{i,3};
        HOF_players{total,3} = output_activation;
        total = total +1;
        
    end
end


total = total -1;
for i = 1:total
    y(i) = HOF_players{i,3};
end

% plot the players with activation values above 0.5
names = {'Barry Bonds';'Manny Ramirez';'Todd Helton';'Gary Sheffield';'Sammy Sosa';'Bobby Abreu';'Derek Jeter'};
bar(y);
set(gca,'Xticklabel',names);
ylabel('Activation');
title('Classified as HOF');
    