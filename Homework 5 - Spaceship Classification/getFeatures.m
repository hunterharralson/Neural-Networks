function [input_data] = getFeatures(original_data)
% extracts feautures from original dataset into probabilites of being from
%   a planet
%
% INPUT:
%   original_data - the initial cell matrix we read in from the excel file
% 
% OUTPUT:
%   input_data - matrix stories probability values of a planet 


num_ships = size(original_data,1);
input_data = []; % initialize input data matrix

% Extract feautures for each ship
for ship = 1:num_ships
    f = []; % initialize feature vector
    
    name = original_data{ship,1};
    murds = original_data{ship,3};
    hailing_freq = original_data{ship,4};
    color = original_data{ship,5};
    ratio = original_data{ship,6};
    
    consonants = '[BbCcDdFfGgHhJjKkLlMmNnPpQqRrSsTtVvWwXxZz]';
    
    % Test for NAMES:
    ints = ['1' '2' '3' '4' '5' '6' '7' '8' '9'];
    
    %   deal with noisy data
    if isnan(name)
        f = [f; 0; 0; 0; 0]; % no name listed
    elseif ~isnan(name)
        f = [f; 0; 0; 0.9; 0;]; % most likely Antarean
    
    %   Antarean
    elseif strfind(name,'A') == 1 | strfind(name,'E') == 1 % if name starts with A or E
        num_str = extractBetween(name,2,strlength(name));
        if ~isnan(str2double(num_str)) % and ends with digits only
            f = [f; 0; 0; 1; 0]; % definitely an Antarean
        else
            f = [f; 0; 0; 0.9; 0];
        end
    
    %   Klingon
    elseif regexp(name(1),consonants) == 1
        if regexp(name(2),consonants) == 1 % definitely a Klingon
            f = [f; 1; 0; 0; 0];
        else
            f = [f; 0; 0.5; 0; 0.5];
        end
        
    %   name tells us nothing; possibly Romulan or Federation
    else
        f = [f; 0; 0.5; 0; 0.5];
    end
    
    
    % Test for MURDS:
    %   deal with noisy data
    if isnan(murds)
        f = [f; 0; 0; 0; 0];
    
    %   Romulan
    elseif murds >= 7.3
        f = [f; 0.1; 0.9; 0; 0]; % slight chance it is a Klingon
    
    %   Klingon
    elseif murds <= 7.1 && murds >= 6.9
        f = [f; 1; 0; 0; 0]; % definitely Klingon
    
    %   Klingon or Romulan
    elseif murds > 7.1 && murds < 7.3
        f = [f; 0.5; 0.5; 0; 0];
    
    %   Antarean (maybe Fed)
    elseif murds >= 6.7 && murds <= 6.8
        f = [f; 0; 0; 0.67; 0.33]; % most likely Antarean; could be Fed
    
    %   Federation (maybe Ant)
    elseif murds >= 6.5 && murds < 6.7
        f = [f; 0; 0; 0.25; 0.75]; % most likely Fed; could be Ant
    
    % Federation
    elseif murds < 6.5
        f = [f; 0; 0; 0; 1]; % definitely Fed
        
    else
            f = [f; 0; 0; 0; 0]; % tells us nothing
    end
    
   
    % Test for HAILING TRANSPONDER FREQUENCY:
    %   deal with noisy data
    if isnan(hailing_freq)
        f = [f; 0; 0; 0; 0;]; % empty cell
    
    %   Federation
    elseif hailing_freq > 1035
        if mod(hailing_freq,5) == 0 % most Fed end in 5
            f = [f; 0; 0; 0; 1]; % def Fed
        else
            f = [f; 0; 0; 0.5; 0.5]; % most likely not fed, but still could be Fed or Ant
        end
        
    %   Antarean
    elseif hailing_freq <= 1035 & hailing_freq >= 1010
        f = [f; 0; 0; 1; 0];
    
    %   Klingon
    elseif hailing_freq < 1010 & hailing_freq >= 990
        f = [f; 1; 0; 0; 0];
        
    %   Romulan (maybe Klingon)
    elseif hailing_freq < 990 & hailing_freq >= 970
        f = [f; 0.2; 0.8; 0; 0];
    elseif hailing_freq < 970
        f = [f; 0; 1; 0; 0];
    else
        f = [f; 0; 0; 0; 0];
    end
    
    
    % Test for COLOR
    if isnan(color)
        color = "";
    end
    if regexp(color,' or ') > 0
        color = extractBefore(color," "); % take the first color listed
    end 
    %   Klingon
    if regexp(color,'Black') > 0
        f = [f; 1; 0; 0; 0]; 
    
    %   Romulan 
    elseif regexp(color,'Green') > 0
        f = [f; 0; 1; 0; 0];
        
    %   Antarean
    elseif regexp(color,'Pink') > 0 | regexp(color,'Orange') > 0 | regexp(color,'Yellow') > 0
        f = [f; 0; 0; 1; 0];
        
    %   Federation
    elseif regexp(color,'White') > 0
        f = [f; 0; 0; 0; 1];
        
    %   Ambiguous Cases:
    %   Gray
    elseif regexp(color,'Gray') > 0
        if regexp(color,'Dark') > 0
            f = [f; 1; 0; 0; 0]; % Klingon
        elseif regexp(color,'Light') > 0
            f = [f; 0.167; 0.333; 0; 0.5];
        else
            f = [f; 0.375; 0.25; 0; 0.375];
        end
        
    %   Blue
    elseif regexp(color,'Blue') > 0
        if regexp(color,'Dark') > 0
            f = [f; 0; 1; 0; 0]; % Romulan
        elseif regexp(color,'Light') > 0
            f = [f; 0; 0.333; 0.667; 0];
        else
            f = [f; 0; 0.5; 0.5; 0];
        end
        
    %   Light
    elseif regexp(color,'Light') > 0
        f = [f; 0.0714; 0.214; 0.357; 0.357];
        
    %   Dark
    elseif regexp(color,'Dark') > 0
        f = [f; 0.667; 0.333; 0; 0];
        
    else f = [f; 0; 0; 0; 0]; % tells us nothing
    end
    
    
    % Test for RATIO:
    %   deal with noisy data
    if isnan(ratio)
        f = [f; 0; 0; 0; 0];
    
    %   Antarean
    elseif ratio <= 1.3 && ratio >= 1
        f = [f; 0.05; 0; 0.95; 0];
    
    %   Klingon
    elseif ratio >= 2.6
        f = [f; 1; 0; 0; 0];
        
    %   Federation or Romulan 
    elseif ratio >= 1.6 && ratio <= 2.3
        f = [f; 0; 0.5; 0; 0.5]; 
        
    else
        f = [f; 0; 0; 0; 0];
    end
    
    f = f/norm(f); % normalize f
    input_data = [input_data, f];
end

end