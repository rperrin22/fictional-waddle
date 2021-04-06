function [ hmean ] = rp_harmmean( input_vec )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

inv_input_vec = 1./input_vec;

hmean_temp = (1/length(input_vec)) * sum(inv_input_vec);

hmean = 1/hmean_temp;

end

