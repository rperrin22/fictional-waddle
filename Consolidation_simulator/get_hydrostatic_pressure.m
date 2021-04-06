function [P_hydrostatic] = get_hydrostatic_pressure(ZZ,waterbottomdepth)
% function [P_hydrostatic] = get_hydrostatic_pressure(ZZ,waterbottomdepth)
%
% This function will calculate the hydrostatic pressure for the mesh
% provided by ZZ.  The water column pressure is added to all values

P_hydrostatic = ((ZZ - 1) + waterbottomdepth) * 9.81 * 1000;


end