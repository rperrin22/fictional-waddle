function [K] = rp_om_geomfactor_calc_galv(dipole_length,dipole_sep)


% b = 2*(dipole_sep/dipole_length);
% bs = b^2;
% 
% K = (dipole_sep*pi)/log((bs / (bs - 1))^(2*b) * ((bs + (2*b))/(b+1)^2)^(b+2) * ((bs - (2*b))/(b-1)^2)^(b-2));

K = ((4*dipole_length^2)/dipole_sep) - dipole_sep;