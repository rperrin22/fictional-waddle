function [LHS] = lhs_calc_bc(k,rho_f,g,mu_f,P,Z,BCls,BCrs,BCtop,BCbot,dx,dy,Gx1,Gy1,Dx1,Dy1)

BCls = P(:,1);
BCrs = P(:,end);
[GPx,GPz] = gradient_calc(P,BCls,BCrs,BCbot,BCtop,dx,dy,Gx1,Gy1);
%[GPx,GPz] = gradient(P);

ZBCtop = Z(1,:) + dy;
ZBCbot = Z(end,:) - dy;
ZBCls = Z(:,1);
ZBCrs = Z(:,end);
% [GZx,GZz] = gradient(Z);
[GZx,GZz] = gradient_calc(Z,ZBCls,ZBCrs,ZBCbot,ZBCtop,dx,dy,Gx1,Gy1);

% kx = zeros(size(GPx));
% ky = zeros(size(GPz));
% 
% for count = 1:size(k,1)+1
%     if count==1
%         kx(:,count) = k(:,1);
%         ky(count,:) = k(1,:);
%     elseif count==size(k,1)+1
%         kx(:,count) = k(:,end);
%         ky(count,:) = k(end,:);
%     else
%         kx(:,count) = harmmean(k(:,count-1:count),2);
%         ky(count,:) = harmmean(k(count-1:count,:),1);
%     end
% end

[kx,ky] = permeability_mean_calc(k);


Lx = (kx*rho_f*g/mu_f).*(GPx + rho_f*g*GZx);
Lz = (ky*rho_f*g/mu_f).*(GPz + rho_f*g*GZz);

% LHS = divergence(Lx,Lz);
LHS = divergence_calc(Lx,Lz,Dx1,Dy1);
end