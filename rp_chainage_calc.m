function [chainage] = rp_chainage_calc(xvec,yvec,startdist)
%
% [chainage] = rp_chainage_calc(xvec,yvec,startdist)
%
% This function calculates a chainage vector from the x and y vectors
%
% Twas made
%

assert(length(xvec)==length(yvec),'rp_chainage_calc: x-vector and y-vector lengths must be the same'); 

distances(1) = startdist;

for count = 2:length(xvec)
    
    distances(count) = norm([xvec(count)-xvec(count-1) yvec(count)-yvec(count-1)]);
    
end

chainage = cumsum(distances);