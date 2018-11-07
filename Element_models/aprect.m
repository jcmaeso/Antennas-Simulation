function [Etot,CPflag]=aprect(theta,phi)
% Calculates total E-field pattern for rectangular aperture with
% uniform field distribution, as a function of theta and phi (in radians). 
%
% Usage: [Etot,CPflag]=aprect(theta,phi)
%
% Aperture parameters a and b are defined in global vector aprect_config
% initialised in init.m and of format :
%
% aprect_config=[a,b]
%
% a.....Aperture dimension in y-axis (m) 
%       Nominally the long dimension (e.g. lambda/2)
%
% b.....Aperture dimension in x-axis (m) 
%       Nominally the narrow dimension (e.g. lambda/10)
%
% E-field is parallel to x-axis
%
% Ref C.A. Balanis 2nd edition Page 596


global array_config;
global freq_config;
global aprect_config;
global velocity_config;
 
a=aprect_config(1,1);  % Y-axis dimension input as (a)
b=aprect_config(1,2);  % X-axis dimension input as (b)

vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;

X=(ko*a/2).*sin(theta).*sin(phi)+1e-9;
Y=(ko*b/2).*sin(theta).*cos(phi)+1e-9;

Etheta=sin(phi).*(sin(X)./X).*(sin(Y)./Y);
Ephi=cos(theta).*cos(phi).*(sin(X)./X).*(sin(Y)./Y);

UNF=1;   % Unity normalisation factor for element pattern

if theta <= pi/2
  Etot=sqrt((abs(Etheta))^2+(abs(Ephi))^2)*UNF+1e-9;
else Etot=1e-9;
end;

CPflag=0;