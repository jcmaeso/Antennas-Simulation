% APERTURE APPROXIMATION (exap1)
% 
% 1 x 4 lambda aperture approximated by very short dipole (lambda/100) sources
% spaced 0.2 lambda, array dimensions are 5x20.
%
% Short dipoles are used, as opposed to isotropic sources, because these vectorise
% the field in the E-plane of the aperture that is being approximated. 
%
% This example demonstrates the relation between arrays and apertures. Try changing
% Nx and Ny in the 'Array' section of the code to see how few sources are required
% to approximate the continuous aperture distribution modelled using 'aprect.m' in 
% the first section.
%
% Note: When 'filling' an aperture the end sources lie inside the aperture limits
%       by (element spacing)/2. Hence there are (5 x 20) rather than (6 x 21) sources
%       for a 0.2 lambda spacing.


close all
clc

help exap1;

init;
freq_config=1e9;              % Frequency
Lambda=3e8/freq_config;       % Wavelength



% Fourier based aperture model (aprect.m)
a=4*Lambda;            % Aperture dimension (Y-axis)
b=1*Lambda;            % Aperture dimension (X-axis)
aprect_config=[a,b];

single_element(0,0,0,'aprect',0,0);                        % 4x1 lambda rectangular aperture

fprintf('\n\nCalculating pattern for continuous aperture distribution\n');
[APRtheta0,APRpat0]=calc_theta(-90,2,90,0,'tot','yes');    % Theta cut for Phi=0 Deg
[APRtheta90,APRpat90]=calc_theta(-90,2,90,90,'tot','yes'); % Theta cut for Phi=90 Deg

% Array approximation to aperture
init;
freq_config=1e9;          % Frequency
Lambda=3e8/freq_config;   % Wavelength
a=4*Lambda;               % Aperture dimension (Y-axis)
b=1*Lambda;               % Aperture dimension (X-axis)

Ny=20;                    % Number of sources in y-axis direction
Nx=5;                     % Number of sources in x-axis direction

fprintf('\n\nCalculating pattern for Nx=%i, Ny=%i array\n',Nx,Ny);
dipole_config=[Lambda/100];
rect_array(Nx,Ny,b/Nx,a/Ny,'dipole',0);                     % Define array of sources
plot_geom3d(1,0);
[DIPtheta0,DIPpat0]=plot_theta(-90,2,90,0,'tot','each');     % Theta cut for phi=0 Deg
[DIPtheta90,DIPpat90]=plot_theta(-90,2,90,90,'tot','each');  % Theta cut for phi=90 Deg


figure(5);
hold on;
p1=plot(APRtheta0,APRpat0,'rx');
p2=plot(DIPtheta0,DIPpat0,'r-');
p3=plot(APRtheta90,APRpat90,'gx');
p4=plot(DIPtheta90,DIPpat90,'g-');

legend([p1,p2,p3,p4],'Fourier Pattern (Phi=0)','Array Pattern (Phi=0)',...
       'Fourier Pattern (Phi=90)','Array Pattern (Phi=90)',4);

axis([-90,90,-40,0]);
T1=sprintf('1 x 4 lambda aperture approximated by %i x %i short dipoles',Nx,Ny);
title(T1)