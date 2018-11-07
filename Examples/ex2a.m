% DIPOLE ARRAY (ex2a)
%
% 5x5 array of half-wave dipoles 0.25 lambda over a groundplane
% X-Y spacing 0.7 lambda. Frequency 1GHz
%
% Theta Squints of 0,10,20,30 Degrees are applied in 
% the phi=90 plane.

close all
clc

help ex2a

init;                                  % Initialise global variables

freq_config=1e9;                       % Define frequency
lambda=3e8/freq_config;                % Calculate wavelength

% Dipole over ground parameters
len=0.5*lambda;                        % Length (m)
h=0.25*lambda;                         % Height above ground (m)
dipoleg_config=[len,h];                % Define vector of parameters

% Array parameters
Nx=5;                                  % Number of elements in x-axis direction       
Ny=5;                                  % Number of elements in y-axis direction
Sx=0.7*lambda;                         % Spacing in x-axis direction
Sy=0.7*lambda;                         % Spacing in y-axis direction
Ang=0;                                 % Angle of elements - 
                                       % (+ve rotation about z-axis, measured from x-axis in Deg)

rect_array(Nx,Ny,Sx,Sy,'dipoleg',Ang); % Define 5x5 array of dipoles over g-plane
list_array(0);                         % List the array x,y,z locations and excitations only 
plot_geom3d(1,0);                      % Plot the array geometry in 3D, with global axes
plot_geom2d(0,1);                      % Plot array geom in 2D anotating elements with excitations

%                      /Min theta
%                     /  /Step                    /Polarisation (Total field)
%                    /  /  /Max theta            /      /Normalise to max of 0deg theta squint
%                   /  /  /                     /      /
plot_squint_theta(-90,2,90,90,90,[0,10,20,30],'tot','first');   
%                           \  \  \       
%                            \  \  \Theta squint list (squint array to each angle and plot pattern)
%                             \  \Phi squint (Phi angle in which to apply the theta squints)
%                              \Phi angle for the theta patterns
%