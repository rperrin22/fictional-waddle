function [LHS,Zc] = lhs_calc_1D_variablez(k,rho_f,g,mu_f,P,zvec,BCtop,BCbot)

% pad zvec for boundary conditions
if size(zvec,2)>size(zvec,1)
    zvec = zvec';
end
zvec_pad = [zvec(1); zvec; zvec(end)];

% locate the cell centres based on the cell sizes (zvec)
Zc = zeros(length(zvec_pad),1);
Zc(1) = zvec_pad(1)/2;
for count = 2:length(zvec_pad)
   Zc(count) = Zc(count-1) + (0.5*zvec_pad(count-1) + 0.5*zvec_pad(count)); 
end

% pad pressure vector for boundary conditions - be sure pressure goes from 
% top to bottom.
if size(P,2)>size(P,1)
    P = P';
end
P_pad = [BCtop; P; BCbot];

% make derivative operator
[Gz] = first_derivative_ops_1D_variablez(zvec_pad);

% figure out k on the edges
for count = 1:length(k)-1
   k_e(count,1) = mean(k(count:count+1)); 
end
k_e = [k(1); k_e; k(end)];

% calculate inner
inner = (k_e.*rho_f.*g./mu_f) .* (Gz*P_pad + rho_f.*g.*Gz*Zc);

zvec_pad_edges = diff(Zc);

% make divergence operator
[Dz] = first_derivative_ops_1D_variablez(zvec_pad_edges);

LHS = Dz*inner;


end