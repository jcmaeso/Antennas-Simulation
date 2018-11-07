function [x,y,z]=sph2cart1(r,th,phi)
% Spherical to Cartesian coordinate conversion
%
% Usage: [x,y,z]=sph2cart1(r,th,phi)
%
% r....Radius (units)
% th...Theta measured from z-axis (radians)
% phi..Phi measured from x-axis (radians) 

x=r.*cos(phi).*sin(th);
y=r.*sin(phi).*sin(th);
z=r.*cos(th);
