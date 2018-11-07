function [Etot,CPflag]=wgr(theta,phi)
% Calculates total E-field pattern for rectangular waveguide aperture with
% TE10 field distribution, as a function of theta and phi. 
%
% Usage: [Etot,CPflag]=wgr(theta,phi)
%
% Waveguide parameters a and b are defined in global vector wgr_config
% initialised in init.m and is of format :
%
% wgr_config=[a,b]
%
% a.....Waveguide dimension in y-axis (m) 
%       Nominally the long dimension 
%
% b.....Waveguide dimension in x-axis (m) 
%       Nominally the narrow dimension 
%
% E-field is parallel to x-axis
%
% Ref C.A. Balanis 2nd edition Page 596


global array_config;
global freq_config;
global wgr_config;


a=wgr_config(1,1);  % Y-axis dimension input as (a)
b=wgr_config(1,2);  % X-axis dimension input as (b)

vo=3e8;
lambda=vo/freq_config;
ko=2*pi/lambda;


X=(ko*a/2).*sin(theta).*sin(phi)+1e-9;
Y=(ko*b/2).*sin(theta).*cos(phi)+1e-9;

Etheta=sin(phi).*(cos(X)./((X.^2)-(pi/2).^2)).*(sin(Y)./Y);
Ephi=cos(theta).*cos(phi).*(cos(X)./((X.^2)-(pi/2).^2)).*(sin(Y)./Y);

UNF=2.467401;   % Unity normalisation factor for element pattern

if theta <= pi/2
  Etot=abs(sqrt(Etheta^2+Ephi^2))* UNF+1e-9;
else Etot=1e-9;
   
end;

CPflag=0;