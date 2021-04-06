function [utm_x,utm_y] = rp_gga2utm(lat,long)
% function [utm_x,utm_y] = rp_gga2utm(lat,long)
%
% this function takes the position from a nmea GPGGA string in degrees
% decimal minutes and outputs the utm coordinates.  It requires the deg2utm
% package, available from the matlab file exchange.
%
% Rob
%
% August, 2017
%

degrees_lat = floor(lat/100);
degrees_long = floor(long/100);

minutes_lat = lat - (degrees_lat*100);
minutes_long = long - (degrees_long*100);

ddd_lat = degrees_lat + (minutes_lat/60);
ddd_long = degrees_long + (minutes_long/60);

[utm_x,utm_y,~] = deg2utm(ddd_lat,-ddd_long);



