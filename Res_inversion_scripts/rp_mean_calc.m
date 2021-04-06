function [rho_mean] = rp_mean_calc(alpha,r1,r2,rho_sw,rho_fw,rho_i)
% [rho_mean] = rp_mean_calc(alpha,r1,r2,rho_sw,rho_fw,rho_i)
%
% function to calculate the mean formation resistivity based on the freeze
% wall model with azimuthal slices of invasion on the fresh water side
%
% outputs:
%       rho_mean - the calculated mean formation resistivity
%
% inputs:
%       alpha - the azimuthal width of the invasion (in radians)
%       r1 - the thickness of the freeze wall
%       r2 - the maximum depth of investigation of the survey
%       rho_sw - the resistivity of the saline water (in ohm-m)
%       rho_fw - the resistivity of the fresh water (in ohm-m)
%       rho_i - the resistivity of the freeze wall (in ohm-m)

term1 = alpha*((1/rho_sw) - (1/rho_fw));

term2 = (4*asin(r1/r2))/rho_i;

term3 = (pi + (2*asin(r1/r2)))/rho_sw;

term4 = (pi + (2*asin(r1/r2)))/rho_fw;

rho_mean = (2*pi)/(term1 + term2 + term3 + term4);

