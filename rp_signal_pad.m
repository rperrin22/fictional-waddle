function [tr_out] = rp_signal_pad(tr_in,flag,padsize)
% [tr_out] = rp_signal_pad(tr_in,flag)
% 
% This function pads a signal, or removes the pad
%
% Inputs:
%   tr_in - input signale
%   flag - pad (1) or remove pad (2)
%
% Outputs:
%   tr_out - padded signal, or unpadded signal
%
% Made in the ocean between Canada and China

assert( flag==1 || flag==2,...
    'rp_signal_pad: flag must be 1 or 2');

switch flag
    case 1
%         tvecin = [1:length(tr_in)]';
%         tvec = tvecin;
%         tvec = [tvec(1)-[1:padsize]'; tvec; [(tvec(end)+1):(tvec(end)+padsize)]'];
%         tr_out = interp1(tvecin,tr_in,tvec,'linear','extrap');
        tr_out = [repmat(tr_in(1),padsize,1); tr_in; repmat(tr_in(end),padsize,1)];
    case 2
        tr_out = tr_in;
        tr_out(1:padsize)=[];
        tr_out(end-(padsize-1):end)=[];
end
