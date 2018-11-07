% ExAp1
% 
% 1 x 4 lambda aperture approximated by very short dipole (lambda/100) sources
% spaced 0.1 lambda. Array dimensions are 40x10 
%
% Note: When 'filling' an aperture the end sources lie inside the aperture limits
%       by (element spacing)/2. Hence there are 40 rather than 41 sources.


close all
clc

help exap1;

Freq=1e9;              % Frequency
Lambda=3e8/Freq;       % Wavelength
theta=-pi:(pi/90):pi;  % Define theta cut vector
thetaDeg=theta*180/pi;
a=4*Lambda;            % Aperture dimension (Y-axis)
b=1*Lambda;            % Aperture dimension (X-axis)

% PHI=90 Degrees Pattern Calculation
% Fourier derived pattern equation
% Ref Balanis 2nd Edition Page 596
phi=90;
phi=phi*pi/180;               
ko=2*pi/Lambda;

X=(ko*a/2).*sin(theta).*sin(phi)+1e-9;
Y=(ko*b/2).*sin(theta).*cos(phi)+1e-9;

Etheta=sin(phi).*(sin(X)./X).*(sin(Y)./Y);
Ephi=cos(theta).*cos(phi).*(sin(X)./X).*(sin(Y)./Y);

Etot=sqrt(abs(Etheta).^2+abs(Ephi).^2)+1e-9;

PwrdB0=20*log10(Etot);
PwrdBnorm0=PwrdB0-max(PwrdB0);

% PHI=90 Degrees Pattern Calculation
% Fourier derived pattern equation
% Ref Balanis 2nd Edition Page 596
phi=90;
phi=phi*pi/180;               
k=2*pi/Lambda;
X=(k*a/2).*sin(theta).*cos(phi)+1e-9;
Y=(k*b/2).*sin(theta).*sin(phi)+1e-9;

Etheta=sin(phi).*(sin(X)./X).*(sin(Y)./Y);
Ephi=cos(phi).*cos(theta).*(sin(X)./X).*(sin(Y)./Y);

Etheta=(sin(X)./X).*(sin(Y)./Y);
Ephi=(sin(X)./X).*(sin(Y)./Y);


Etot=sqrt(abs(Etheta).^2+abs(Ephi).^2)+1e-9;

PwrdB90=20*log10(Etot);
PwrdBnorm90=PwrdB90-max(PwrdB90);


fprintf('\n\n1x4-lambda aperture, approximated by N,M short dipole (Lambda/100) sources,\n');
fprintf('Plotting patterns\n');


init;                      % Initialise global variables
freq_config=1e9;
lambda=3e8/freq_config;    % Calculate wavelength
N=10;
M=40;
fprintf('\n\nCalculating pattern for N=%i, M=%i\n\n',N,M);
dipole_config=[Lambda/100];
rect_array(N,M,1*lambda/N,4*lambda/M,'iso',0); 
plot_geom3d(1,0);
[theta0,pat0]=calc_theta(-90,2,90,0,'tot','yes');
[theta90,pat90]=calc_theta(-90,2,90,90,'tot','yes');


figure(5);

plot(theta0,pat0,'r-',thetaDeg,PwrdBnorm0,'rx',...
     theta90,pat90,'g-',thetaDeg,PwrdBnorm90,'gx');

legend('Array Pattern (Phi=0)','Fourier Pattern (Phi=0)',...
       'Array Pattern (Phi=90)','Fourier Pattern (Phi=90)',4);

axis([-90,90,-40,0]);
title('4 x 1 lambda aperture approximated by very short dipoles (0.1 lambda spacing)')