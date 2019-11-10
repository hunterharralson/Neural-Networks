function A = linearAssociator(input_data)
% train the network - create a linear associator matrix, A
%
% created a desired output vector, gi, for each fi, storing a 1 where the
%   ship's origin should be from 
%
% INPUT:
%   input_data - the matrix storing probabilities for each ship's origin 
% 
% OUTPUT:
%   A - the linear associator

A = zeros(4,size(input_data,1));

correct_planet = 1; % value to assign to lin. associator

for i = 1:5:20
    for j = i:i+4
        gi = zeros(4,1);
        gi(correct_planet) = 1; 
        
        fi = input_data(:,j);
        Ai = gi*fi';
        A = A + Ai;
    end
    correct_planet = correct_planet + 1;
end

end