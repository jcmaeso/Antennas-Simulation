function [Etot,CPflag]=patchr(theta_in,phi_in)
% Calculates total E-field pattern for patch as a function
% of theta and phi (in radians)
%
% Patch is assumed to be resonating in the (TMx 010) mode.
%
% Usage: [Etot,CPflag]=patchr(theta,phi)
%
% Patch parameters Er,W,L and h are defined in global vector patch_config
% initialised in init.m and is of format :
%
% patchr_config=[Er,W,L,h]
%
% Er.....Dielectric constant of substrate
% W......Width of patch (m)
% L......Length of patch (m)
% h......Substrate thickness (m)
%
% E-field is parallel to x-axis
%
% Refrence C.A. Balanis 2nd Edition Page 745

global array_config;
global freq_config;
global patchr_config;
global velocity_config;


% Rotate coords 90 deg about x-axis to match array_utils coord system
% with coord system used in the model.


[xff,yff,zff]=sph2cart1(999,theta_in,phi_in);
xffd=zff;
yffd=xff;
zffd=yff;
[r,thp,php]=cart2sph1(xffd,yffd,zffd);
phi=php;
theta=thp;

% Trap potential division by zero warning
if theta==0;theta=1e-9;end
if phi==0;phi=1e-9;end

Er=patchr_config(1,1);
W=patchr_config(1,2);
L=patchr_config(1,3);
h=patchr_config(1,4);


vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;



% Calculate effictive dielectric constant for microstrip
% line of width W on dielectric material of constant Er

Ereff=((Er+1)/2)+((Er-1)/2)*(1+12*(h/W)).^-0.5;

% Calculate increase length dL of patch length L due to fringing
% fields at each end, giving total effective length Leff = L + 2*dL

F1=(Ereff+0.3)*(W/h+0.264);
F2=(Ereff-0.258)*(W/h+0.8);
dL=h*0.412*(F1/F2);

Leff=L+2*dL;

% Calculate effective width Weff for patch, uses standard Er
% value.

Weff=W;
heff=h*sqrt(Er);

% Patch pattern function of theta and phi, note the theta and
% phi for the function are defined differently to theta_in and phi_in

Numtr2=sin(ko*heff.*cos(phi)/2);
Demtr2=(ko*heff.*cos(phi))/2;
Fphi=(Numtr2./Demtr2).*cos((ko*Leff/2).*sin(phi));

Numtr1=sin((ko*heff/2).*sin(theta));
Demtr1=((ko*heff/2).*sin(theta));
Numtr1a=sin((ko*Weff/2).*cos(theta));
Demtr1a=((ko*Weff/2).*cos(theta));
Ftheta=((Numtr1.*Numtr1a)./(Demtr1.*Demtr1a)).*sin(theta);

% Due to groundplane function is only valid for 
% theta values :   0 < theta < 90   for all phi

% Modify pattern for theta values close to 90 to give
% smooth roll-off, standard model truncates H-plane
% at theta=90. PatEdgeSF has value=1 except at theta close
% to 90 where it drops (proportional to 1/x^2) to 0

rolloff_factor=0.5;                                    % 1=sharp, 0=softer
theta_in_deg=theta_in*180/pi;                          % theta_in in Deg
F1=1./(((rolloff_factor*(abs(theta_in_deg)-90)).^2)+0.001); % intermediate calc
PatEdgeSF=1./(F1+1);                                   % Pattern scaling factor

UNF=1.0006;   % Unity normalisation factor for element pattern

if theta_in <= pi/2
   Etot=Ftheta*Fphi*PatEdgeSF*UNF;  % Total pattern by pattern multiplication
   else Etot=0;
end
CPflag=0;

