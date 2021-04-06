function [tr_out] = rp_gaussian_smoother_mod(tr_in,t,sig)
% function [tr_out] = rp_gaussian_smoother(tr_in,sig)
%
% This function smooths a time-series using a Gaussian kernel
%
% Input:
%   tr_in - input signal
%   t - time vector associated with the signal
%   sig - this sigma is used to calculate the kernel
%
% Output:
%   tr_out - smoothed signal
% 
% Made In Canada

t_range = max(t) - min(t);

t_int = linspace(min(t) - (0.2*t_range),max(t) + (0.2*t_range),10*(length(t)));
tr_int = interp1(t,tr_in,t_int,'linear','extrap');

temp = exp(-1/(2*sig^2) * ([1:1:50].^2));

temp(temp<0.00001) = [];

gau_filt = [fliplr(temp) 1 temp];
% 
% pad1 = repmat(tr_in(1),50,1);
% pad2 = repmat(tr_in(end),50,1);

tr_out_int = conv(tr_int,gau_filt','same')./sum(gau_filt(:));

tr_out = interp1(t_int,tr_out_int,t,'linear');
