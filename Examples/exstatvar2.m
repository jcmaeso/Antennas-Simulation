% STATISTICAL VARIATION EXAMPLE (exstatvar2)
%
% Shows the effect of normally distributed random variations
% in phase and amplitude on array performance.
%
% In this example a 6-element patch array, with amplitude taper,
% is steered 20 Deg from bore-sight.
%
% Random variations are applied by the function plot_phi_statvar.m 
% as follows :
%
% Normally distributed phase variations of +/- 20 Deg
% Normally distrubuted amplitude variations of +/- 2 dB 
%
% The function makes multiple pattern cuts, each with a different set
% of randomised phases and amplitudes, building up a pattern envelope
% of maximum and minimum values.
%
% See inside this file to change the array configuration under test.


close all
clc

help exstatvar2

init;

% ****** Some input parameters to experiment with *******

Nx=1;         % Number of elements in X-axis direction
Ny=6;         % Number of elements in Y-axis direction
Prng=20;      % Phase range (Deg) 99.7pcnt of the phase errors will be within +/- Prng
Arng=2;       % Amplitude range (dB) 99.7pcnt of the amplitude errors will be within +/- Arng
Nruns=50;     % Number of plots to make

phimin=-90;   % Min phi for plots
phistep=1;    % Phi step for plots
phimax=90;    % Max phi for plots
theta=90;     % Theta cut
phisqnt=20;   % Steer main beam in phi (Deg)
thetasqnt=90; % Steer main beam in theta (Deg)
SLL=20;       % Sidlobe reduction (dB) w.r.t main beam


% ***************  Array definition *********************

freq_config=2.45e9;                                     % Specify frequency
lambda=3e8/freq_config;                                 % Calculate wavelength
patchr_config=design_patchr(3.43,1.6e-3,freq_config);   % Calculate patch parameters

rect_array(Nx,Ny,0.6*lambda,0.6*lambda,'patchr',0);     % Define the array array
taywin_array(SLL,'x');                                  % Amplitude taper
yrot_array(-90,1,(Nx*Ny));                              % Rotate whole array to point in +ve x
squint_array(thetasqnt,phisqnt,1);                      % Steer main beam


% ***************   Plot results ************************

list_array(0);
plot_geom3d(1,0);
calc_directivity(5,15);
[tha,minp,maxp]=plot_phi_statvar(phimin,phistep,phimax,theta,'tot','no',Prng,Arng,Nruns); 

