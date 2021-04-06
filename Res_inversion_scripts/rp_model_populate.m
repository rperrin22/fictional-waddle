function [ C ] = rp_model_populate( r1_real,rho1_real,rho2_real,xe_vec,xc_vec,zc_vec,dr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

C = zeros(length(zc_vec),length(xc_vec));

for count=1:length(r1_real)
    
    %s(count,1:dsearchn(xvec,r1_real(count))) = rho1_real(count);
    
    [k] = dsearchn(xc_vec,r1_real(count));
    if k >= length(xc_vec)
        k=length(xc_vec)-1;
    end
    invcells = k - 1;
    
    if k > 1
        invremain = (r1_real(count)-xe_vec(k))/(dr(k));
    else
        invremain = (r1_real(count))/(dr(k));
    end
    
    buffercell = invremain*rho1_real(count) + ((1-invremain)*rho2_real(count));
    
    C(count,:)=1/rho2_real(count);
    C(count,1:invcells)=1/rho1_real(count);
    if invremain > 0
        C(count,invcells+1) = 1/buffercell;
    end
    
end

end

