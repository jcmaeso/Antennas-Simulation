function [Etot,CPflag]=dish(theta,phi)
% Calculates total E-field pattern for a circular parabolic reflector with
% specified amplitude taper, as a function of theta and phi (in radians). 
%
% Usage: [Etot,CPflag]=dish(theta,phi)
%
%
% Dish size and amplitude taper parameters are defined in
% global vector dish_config initialised in init.m and of format :
%
% dish_config=[d,n,t]
%
% d....Aperture diameter d (m)
% n....Amplitude taper factor n (typically 2.5 0=uniform distribution)
% t....Taper value at edge of dish, relative to maximum (dB)
%
% E-field is parallel to x-axis
%
%
% e.g. dish_config=[2,2.5,10]    
%      Defines 2(m) dish, n=2.5 roll off factor, 10dB down at dish edge.
%
% Ref Antennas and Radiowave Propagation 
% R.E. Collin International Edition(1985) Page 211

global array_config;
global freq_config;
global dish_config;
global velocity_config;

diameter=dish_config(1,1);
a=diameter/2;

n=dish_config(1,2);
t=dish_config(1,3);

A=1-10.^(-t./20);

vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;
if theta==0; theta=1e-9;end;

u=ko*a*sin(theta);

F1=2*(1-A);
F2=besselj(1,u)./u;
F3=(A.*(2.^n)).*prod(1:(n+1));
F4=besselj((n+1),u)./(u.^(n+1));

F5=(F1.*F2+F3.*F4);

Etheta=cos(phi).*F5;
Ephi=cos(theta).*sin(phi).*F5;

UNF=1.519494;   % Unity normalisation factor for element pattern

if theta <= pi/2
  Etot=abs(sqrt(Etheta.^2+Ephi.^2))*UNF+1e-9;
else Etot=1e-9;
end;

CPflag=0;