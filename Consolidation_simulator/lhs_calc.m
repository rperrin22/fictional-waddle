function [LHS] = lhs_calc(k,rho_f,g,mu_f,P,Z)

[GPx,GPz] = gradient(P);
[GZx,GZz] = gradient(Z);

Lx = (k*rho_f*g/mu_f).*(GPx + rho_f*g*GZx);
Lz = (k*rho_f*g/mu_f).*(GPz + rho_f*g*GZz);

LHS = divergence(Lx,Lz);

end