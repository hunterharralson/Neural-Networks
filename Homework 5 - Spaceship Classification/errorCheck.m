function [error_index] = errorCheck(planet_vec)
% checks the correctness of classification with the correct planet origins
%
% INPUTS:
%   planet_vec - 1x20 vector storing each ship's planet classification
%       (1) Klingon, (2) Romulan, (3) Antarean, (4) Federation
% 
% OUTPUT:
%   error_index - vector containing indices of incorrect classification


correct_planet_vec = [2 4 4 4 1 2 1 2 1 3 1 1 3 3 2 2 3 3 4 4]; % correct planet classifications given noisy data
%correct_planet_vec = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4]; % un-comment to test the training set
error_index = [];

for i = 1:20
    if correct_planet_vec(i) ~= planet_vec(i)
        error_index = [error_index, i];
    end
end

end