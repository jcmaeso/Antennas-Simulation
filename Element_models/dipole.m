function [Etot,CPflag]=dipole(theta_in,phi_in)
% Calculates total E-field pattern for dipole as a function
% of theta and phi (in radians).
%
% Usage: [Etot,CPflag]=dipole(theta,phi)
%
% Dipole length is defined in global variable dipole_config
% initialised in init.m and is of the format :
%
% dipole_config=[L]
%
% L.....Length of dipole (m)
%
% E-field is parallel to x-axis
%
% Reference C.A. Balanis 2nd edition page 153

global freq_config;
global dipole_config;
global velocity_config;

vo=velocity_config;
dlen=dipole_config;

lambda=vo/freq_config;
k=2*pi/lambda;


% Convert array local element coords into dipole model coords.
% Conversion is ccw rotation about the y-axis.

[xff,yff,zff]=sph2cart1(999,theta_in,phi_in);
xffd=-zff;
yffd=yff;
zffd=xff;
[r,th,ph]=cart2sph1(xffd,yffd,zffd);
if th==0; th=1e-9;end;

% Dipole pattern function ref C.Balanis
F1=cos((k*dlen/2)*cos(th));
F2=cos(k*dlen/2);
Ftheta=(F1-F2)./sin(th);

UNF=1;   % Unity normalisation factor for element pattern

Etot=Ftheta*UNF;
CPflag=0;