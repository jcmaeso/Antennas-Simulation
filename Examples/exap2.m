% APERTURE APPROXIMATION (exap2)
% 
% 4-lambda aperture approximated by varying numbers of short dipole sources.
% 
% Number of sources   Spacing (lambda)
%      N=40                0.1 
%      N=20                0.2
%      N=10                0.4
%      N=5                 0.8
%
% Notice how the approximation begins to depart at 0.4 lambda spacing and 
% significant grationg lobes have appeared by 0.8 lambda spacing. In practice
% a value of around 0.6-0.7 is a good compromise, depending on the application.


close all
clc

help exap2;

Freq=1e9;              % Frequency
Lambda=3e8/Freq;       % Wavelength
theta=-pi:(pi/90):pi;  % Define theta cut vector
thetaDeg=theta*180/pi;


a=4*Lambda;            % Aperture dimension (Y-axis)
b=0.1*Lambda;          % Aperture dimension (X-axis)

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


PwrdB90=20*log10(Etot);
PwrdBnorm90=PwrdB90-max(PwrdB90);

%figure(6);
%plot(thetaDeg,PwrdBnorm0,'r-',thetaDeg,PwrdBnorm90,'g-');
%axis([-90,90,-40,0]);
%pause;


fprintf('\n\n1x4-lambda aperture, approximated by N,M short dipole (Lambda/100) sources,\n');
fprintf('Plotting patterns\n');

% *************** N=40 ******************
init;                      % Initialise global variables
freq_config=1e9;
lambda=3e8/freq_config;    % Calculate wavelength
N=1;
M=40;
fprintf('\n\nCalculating pattern for N=%i, M=%i\n\n',N,M);
dipole_config=[Lambda/100];
rect_array(N,M,1*lambda/N,4*lambda/M,'dipole',0); 
[thetaM40,patM40]=calc_theta(-90,2,90,90,'tot','yes');



% *************** N=20 ******************
init;                      % Initialise global variables
freq_config=1e9;
lambda=3e8/freq_config;    % Calculate wavelength
N=1;
M=20;
fprintf('\n\nCalculating pattern for N=%i, M=%i\n\n',N,M);
dipole_config=[Lambda/100];
rect_array(N,M,1*lambda/N,4*lambda/M,'dipole',0); 
[thetaM20,patM20]=calc_theta(-90,2,90,90,'tot','yes');

% *************** N=10 ******************
init;                      % Initialise global variables
freq_config=1e9;
lambda=3e8/freq_config;    % Calculate wavelength
N=1;
M=10;
fprintf('\n\nCalculating pattern for N=%i, M=%i\n\n',N,M);
dipole_config=[Lambda/100];
rect_array(N,M,1*lambda/N,4*lambda/M,'dipole',0); 
[thetaM10,patM10]=calc_theta(-90,2,90,90,'tot','yes');

% *************** N=5 ******************
init;                      % Initialise global variables
freq_config=1e9;
lambda=3e8/freq_config;    % Calculate wavelength
N=1;
M=5;
fprintf('\n\nCalculating pattern for N=%i, M=%i\n\n',N,M);
dipole_config=[Lambda/100];
rect_array(N,M,1*lambda/N,4*lambda/M,'dipole',0); 
[thetaM5,patM5]=calc_theta(-90,2,90,90,'tot','yes');


figure(5);

plot(thetaDeg,PwrdBnorm90,'kx',thetaM40,patM40,'r-',thetaM20,patM20,'g-',...
     thetaM10,patM10,'b-', thetaM5,patM5,'m-');

legend('Fourier Pattern','Array (N=40, 0.1 lambda spacing)','Array (N=20, 0.2 lambda spacing)',...
       'Array (N=10, 0.4 lambda spacing)','Array (N=5, 0.8 lambda spacing)',4);

axis([-90,90,-40,0]);
title('4-lambda aperture approximated by N short dipoles')