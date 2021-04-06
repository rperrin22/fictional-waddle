function [dT] = temp_flow_calc(P,Z,T,g,dx,dy,k,rho_w,c_w,rho_r,c_r,mu_w,n,k_m,BCtop,BCbot,Gx1,Gy1,Dx1,Dy1)

[kx,ky] = permeability_mean_calc(k);
[rho_wx,rho_wy] = matrix_mean_calc(rho_w);
[mu_wx,mu_wy] = matrix_mean_calc(mu_w);
%[k_mx,k_my] = permeability_mean_calc(k_m);
[c_wx,c_wy] = matrix_mean_calc(c_w);
[Tx,Ty] = matrix_mean_calc(T);

BCls = P(:,1);
BCrs = P(:,end);
[GPx,GPz] = gradient_calc(P,BCls,BCrs,BCbot,BCtop,dx,dy,Gx1,Gy1);

ZBCtop = Z(1,:) + dy;
ZBCbot = Z(end,:) - dy;
ZBCls = Z(:,1);
ZBCrs = Z(:,end);
[GZx,GZz] = gradient_calc(Z,ZBCls,ZBCrs,ZBCbot,ZBCtop,dx,dy,Gx1,Gy1);

Lx1 = (kx.*rho_wx.*c_wx.*Tx./mu_wx).*(GPx + rho_wx.*g.*GZx);
Lz1 = (ky.*rho_wy.*c_wy.*Ty./mu_wy).*(GPz + rho_wy.*g.*GZz);
LHS1 = divergence_calc(Lx1,Lz1,Dx1,Dy1);

%TBCtop = T(1,:) + dy;
TBCtop = T(1,:) * 0;
%TBCbot = T(end,:) - dy;
TBCbot = (T(end,:) * 0) + 550;
TBCls = T(:,1);
TBCrs = T(:,end);
[GTx,GTz] = gradient_calc(T,TBCls,TBCrs,TBCbot,TBCtop,dx,dy,Gx1,Gy1);

Lx2 = k_m*GTx;
Ly2 = k_m*GTz;
LHS2 = divergence_calc(Lx2,Ly2,Dx1,Dy1);

dT = (LHS1 + LHS2) ./ (n.*rho_w.*c_w + ((1-n) * rho_r * c_r));

end