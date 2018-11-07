function [Etot,CPflag]=wgc(theta,phi)
% Calculates total E-field pattern for a circular waveguide aperture with
% TE11 field distribution, as a function of theta and phi. 
%
% Usage: [Etot,CPflag]=wgc(theta,phi)
%
% Waveguide diameter d is defined in global vector wgc_config
% initialised in init.m and is of format :
%
% wgc_config=[d]
%
% d.....Waveguide diameter (m) 
%
% E-field is parallel to x-axis
%
% Ref C.A. Balanis 2nd edition Page 608

global array_config;
global freq_config;
global wgc_config;
global velocity_config;


diameter=wgc_config(1,1);
a=diameter/2;

vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;
if theta==0; theta=1e-9;end;
if theta==pi/2; theta=pi/2-1e-9;end;
if theta==-pi/2; theta=-pi/2+1e-9;end;

Z=(ko*a).*sin(theta);
xi=1.841;

Etheta=cos(phi).*besselj(1,Z)./Z;
F1=besselj(0,Z);
F2=besselj(1,Z)./Z;
Ephi=cos(theta).*sin(phi).*(F1-F2)./(1-(Z./xi).^2);

UNF=2;   % Unity normalisation factor for element pattern

if theta <= pi/2
  Etot=abs(sqrt(Etheta.^2+Ephi.^2))*UNF+1e-9;
else Etot=1e-9;
end;

CPflag=0;