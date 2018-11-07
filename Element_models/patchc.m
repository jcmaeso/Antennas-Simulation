function [Etot,CPflag]=patchc(theta_in,phi_in)
% Calculates total E-field pattern for circular patch as a function
% of theta and phi (in radians). 
%
% Patch is assumed to be resonating in the (TM 110) mode.
%
% Usage: [Etot,CPflag]=patchc(theta,phi)
%
% Patch parameters Er,a and h are defined in global vector patchc_config
% initialised in init.m and is of format :
%
% patchc_config=[Er,a,h]
%
% Er.....Dielectric constant of substrate
% a......Patch radius (m)
% h......Substrate thickness (m)
%
% E-field is parallel to x-axis
%
% Refrence C.A. Balanis 2nd Edition Page 752 / Bahl & Bhartia 1980 Page 90

global array_config;
global freq_config;
global patchc_config;
global velocity_config;

% Rotate coords 90 deg about x-axis to match array_utils coord system
% with coord system used in the model.


%[xff,yff,zff]=sph2cart1(999,theta_in,phi_in);
%xffd=zff;
%yffd=xff;
%zffd=yff;
%[r,thp,php]=cart2sph1(xffd,yffd,zffd);

vo=velocity_config;

phi=phi_in;
theta=theta_in;      

Er=patchc_config(1,1);     % Dielectric constant
a=patchc_config(1,2)*100;  % Patch radius in (cm)
h=patchc_config(1,3)*100;  % Substrate height (cm)

lambda=vo/freq_config;
ko=2*pi/lambda;

% Calculate effective radius of patch

F1=(2*h)/(pi*a*Er);
F2=log((pi*a)/(2*h))+1.7726;
aeff=a*sqrt(1+F1*F2)/100;     % Effective patch radius (m)

F3=sin(ko*(h/100)*cos(theta))/(ko*(h/100)*cos(theta));

Ja02=besselj(0,(ko*aeff*sin(theta)))-besselj(2,(ko*aeff*sin(theta)));
Jb02=besselj(0,(ko*aeff*sin(theta)))+besselj(2,(ko*aeff*sin(theta)));

Ftheta=-j*cos(phi)*Ja02*F3;
Fphi=j*cos(theta)*sin(phi)*Jb02*F3;

% Due to groundplane function is only valid for 
% theta values :   0 < theta < 90   for all phi

% Modify pattern for theta values close to 90 to give
% smooth roll-off, standard model truncates H-plane
% at theta=90. PatEdgeSF has value=1 except at theta close
% to 90 where it drops (proportional to 1/x^2) to 0

rolloff_factor=0.5;                                    % 1=sharp, 1<=softer
theta_in_deg=theta_in*180/pi;                          % theta_in in Deg
F1=1./(((rolloff_factor*(abs(theta_in_deg)-90)).^2)+0.001); % intermediate calc
PatEdgeSF=1./(F1+1);                                   % Pattern scaling factor

UNF=1.0005;   % Unity normalisation factor for element pattern

if theta_in <= pi/2
    Etot=abs(sqrt(Ftheta^2+Fphi^2))*PatEdgeSF*UNF;  %Power sum of Etheta and Ephi
  else Etot=0;
end
CPflag=0;

