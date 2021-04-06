function [y_out,num_values_corrected] = rp_despike_func(y_in,zone_width,variance)
% [y_out] = rp_despike_func(y_in,zone_width,variance)
%
% This function despikes a dataset
%  
% Inputs:
%   y_in - dependant variable for noisy data
%   zone_width - zone width for calculation in samples
%   variance - how far outta wack does the point have to be to qualify for
%              correction (in std deviations)?
%
% Outputs:
%   y_out - despiked dependant variable
%
% Created 29 May, 2017
% RP
%

%% check the input data

% check to make sure the window is smaller than the input data
assert( zone_width<length(y_in),...
    'rp_despike_func: zone width must be smaller than input vector length');

% check to make sure the window is larger than zero
assert( zone_width > 0,...
    'rp_despike_func: zone with must be greater than zero');

% check to make sure the window is an odd length
assert( mod(zone_width,2)==1,...
    'rp_despike_func: zone with must be an odd number');

% check to make sure that the window is a whole number
assert( round(zone_width) == zone_width,...
    'rp_despike_func: zone width must be a whole number of samples');

%% run the function
y_out = y_in;

% set sliding window limits
window_slide_begin = ceil(zone_width/2);
window_slide_end = length(y_in) - window_slide_begin;
num_values_corrected = 0;

for count = 1:length(y_in)
    
    if count < window_slide_begin
        temp_vec = [y_in(1:count-1); y_in(count+1:zone_width)];
        window_std = std(temp_vec);
        window_mean = mean(temp_vec);
    elseif count > window_slide_begin && count < window_slide_end
        temp_vec = [y_in(count-floor(zone_width/2):(count-1)); y_in((count+1):(count+floor(zone_width/2)))];
        window_std = std(temp_vec);
        window_mean = mean(temp_vec);
    elseif count > window_slide_end
        temp_vec = [y_in(end-zone_width:count-1); y_in(count+1:end)];
        window_std = std(temp_vec);
        window_mean = mean(temp_vec);
    end
    
    temp_ow = abs(window_mean - y_in(count));
    
    if temp_ow > (variance*window_std)
       y_out(count) = window_mean; 
       num_values_corrected = num_values_corrected + 1;
    end
    
    
end

fprintf('rp_despike_func: operation complete, %d values corrected\n',num_values_corrected);
