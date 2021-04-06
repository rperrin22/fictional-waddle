function [tr_out] = rp_tik_smoother(tr_in,t,reg_param,deriv_flag)
% function [tr_out] = rp_tik_smoother(tr_in,t,reg_param,deriv_flag)
%
% Smooth a signal using tikhonov regularization
%
% Inputs:
%       - tr_in - input signal
%       - t - input time vector
%       - reg_param - regularization paramter
%       - deriv_flag - 1st or 2nd derivative operator choice (default is 2)
%
% Outputs:
%       - tr_out - smoothed signal
%
% Made in Germany, while tired, so check it for errors
%

assert(length(tr_in)==length(t),'signal and time vector should be the same length');
assert(reg_param>0,'please set the regularization parameter to a positive number')

if nargin==3
    fprintf('no flag chosen, deriv_flag set to 2\n');
    deriv_flag=2;
end

if deriv_flag~=1 && deriv_flag~=2
    fprintf('your choice of deriv_flag makes no sense, setting to 2\n')
    deriv_flag=2;
end

M1 = spalloc((length(t)-1),(length(t)-1),2*(length(t)-1));
M2 = spalloc(length(t) - 2,length(t) - 2,2*(length(t) - 2));

% set up 1st derivative operator
for count = 1:(length(t)-1)
   M1(count,count) = -1;
   M1(count,count+1) = 1;
end

% set up 2nd derivative operator
for count = 1:length(t) - 2
   M2(count,count) = 1;
   M2(count,count+1) = -2;
   M2(count,count+2) = 1;
    
end

switch deriv_flag
    case 1
        M = M1;
    case 2
        M = M2;
end



tr_out =( speye(length(t)) +( reg_param*(M'*M)))\tr_in;