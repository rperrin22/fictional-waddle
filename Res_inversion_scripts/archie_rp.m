function [Rt]=archie_rp(a,por,m,Sw,n,Rw)
% [Rt]=archie_rp(a,por,m,Sw,n,Rw)
% function to plot resistivities according to Archie's equation
%
% Rt = a*por^-m*Sw^-n*Rw
% where
%     Rt = resistivity of saturated rock
%     a  = tortuosity factor   ( range between 0.5 and 1.5 (Ellis and
%                                 Singer, 2008) )
%     por= porosity
%     m  = cementation factor  ( 1.3 to 1.7 ish )
%     Sw = brine saturation    ( for our purposes, assume 100% saturated )
%     n  = saturation exponent ( commonly 2 (Ellis and Singer, 2008) )
%     Rw = brine resistivity

Rt = (a).*(por.^-m).*(Sw.^-n).*(Rw);

end