function planet_vec = testData(A, input_data)
% classifies a ship's origin based on its classification
%
% INPUTS:
%   A - the linear associator matrix storing weights of connections
%   input_data - matrix storing f vectors (each ship) and its probabilities
% 
% OUTPUT:
%   planet_vec - 1x20 vector storing each ship's planet classification
%       (1) Klingon, (2) Romulan, (3) Antarean, (4) Federation


planet_vec = zeros(1,size(input_data,1));

for i = 1:20
    g_prime = A * input_data(:,i);
    [max_value, planet_num] = max(g_prime(:)); % find max value and its index - this is the planet number classification
    planet_vec(1,i) = planet_num;
    
    if planet_num == 1
        disp('Ship Origin: KLINGON. Hostile - **** Stay alert ****');
    end
    if planet_num == 2
        disp('Ship Origin: ROMULAN. Could be Hostile - Stay alert, but do not engage in active preparations for hostility');
    end
    if planet_num == 3
        disp('Ship Origin: ANTAREAN. Friendly - No necessary action needs to be taken');
    end
    if planet_num == 4
        disp('Ship Origin: FEDERATION. Friendly - No necessary action except welcoming them back!');
    end
end

end