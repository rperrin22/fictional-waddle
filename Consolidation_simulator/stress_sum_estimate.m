function [sigma_est] = stress_sum_estimate(dP,alpha,V)
% from the equations for poroelasticity, estimate the change of the 
% sum of the principle stresses from the change in pore pressure

[~,~,Gxy2] = second_derivative_op(dP,1,1);

RHS = ((2*(1-2*V)) / (1 - V)) * alpha * (Gxy2*dP(:));

sigma_est = Gxy2\RHS;


end