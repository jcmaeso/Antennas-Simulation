function [r,th,phi]=cart2sph1(x,y,z)
% Cartesian to Spherical coordinate conversion
%
% Usage: [r,th,phi]=cart2sph1(x,y,z)
%
% r....Radius (units)
% th...Theta measured from z-axis (radians)
% phi..Phi measured from x-axis (radians) 

r=sqrt(x.^2+y.^2+z.^2)+1e-15;
th=acos(z./r);
phi=atan2(y,x);