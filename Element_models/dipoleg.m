function [Etot,CPflag]=dipoleg(theta_in,phi_in)
% Calculates total E-field pattern for dipole over a groundplane
% as a function of theta and phi (in radians).
%
% Usage: [Etot,CPflag]=dipoleg(theta,phi)
%
% Dipole parameters are L and h are defined in global vector dipoleg_config
% initialised in init.m and is of the format :
%
% dipoleg_config=[L,h]
%
% L....Length of dipole (m) 
% h....Height of dipole above ground plane (m)
%
% The model is the same as that used for the ordinary dipole except
% that it is used twice. The 2nd image dipole is created at height
% -h below the ground plane. The second dipole is phased at 180 Deg
% creating a virtual ground plane between the two.
%
% Refrence C.A. Balanis 2nd Edition page 153

global freq_config;
global dipoleg_config;
global velocity_config;

vo=velocity_config;
dlen=dipoleg_config(1,1);
h=dipoleg_config(1,2);

lambda=vo/freq_config;
k=2*pi/lambda;


% Convert array local element coords into dipole model coords.
% Conversion is ccw rotation about the y-axis.



% ***** Dipole 1 *****
[xff,yff,zff]=sph2cart1(999,theta_in,phi_in);
xffd1=-zff+h;
yffd1=yff;
zffd1=xff;
[r1,th1,ph1]=cart2sph1(xffd1,yffd1,zffd1);
if th1==0; th1=1e-9;end;

% Dipole pattern for primary dipole
F11=cos((k*dlen/2)*cos(th1));
F21=cos(k*dlen/2);
Amp1=((F11-F21)./sin(th1));




% ***** Dipole 2 *****
xffd2=-zff-h;
yffd2=yff;
zffd2=xff;
[r2,th2,ph2]=cart2sph1(xffd2,yffd2,zffd2);
if th2==0; th2=1e-9;end;


% Dipole pattern for image dipole
F12=cos((k*dlen/2)*cos(th2));
F22=cos(k*dlen/2);
Amp2=((F12-F22)./sin(th2));

E1=Amp1*exp(-j*k*r1);
E2=Amp2*exp(-j*(k*r2-pi));

Esum=abs(E1+E2);

UNF=0.5;   % Unity normalisation factor for element pattern

% Due to groundplane function is only valid for 
% theta values :   0 < theta < 90   for all phi

if theta_in <= pi/2
 Etot=Esum*UNF;
else Etot=0;
end
CPflag=0;
