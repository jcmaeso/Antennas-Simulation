function [Etot,CPflag]=apcirc(theta,phi)
% Calculates total E-field pattern for a circular aperture with
% uniform field distribution, as a function of theta and phi (in radians). 
%
% Usage: [Etot,CPflag]=apcirc(theta,phi)
%
% Aperture parameter d is defined in global vector apcirc_config
% initialised in init.m and of format :
%
% apcirc_config=[d]
%
% d.....Aperture diameter (m) 
%
% E-field is parallel to x-axis
%
% Ref C.A. Balanis 2nd edition Page 608

global array_config;
global freq_config;
global apcirc_config;
global velocity_config;

diameter=apcirc_config(1,1);
a=diameter/2;

vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;

if theta==0; theta=1e-9;end;
Z=(ko*a).*sin(theta);

Etheta=cos(phi).*besselj(1,Z)./Z;
Ephi=cos(theta).*sin(phi).*besselj(1,Z)./Z;

UNF=2;   % Unity normalisation factor for element pattern

if theta <= pi/2
  Etot=abs(sqrt(Etheta.^2+Ephi.^2))*UNF+1e-9;
else Etot=1e-9;
end;

CPflag=0;