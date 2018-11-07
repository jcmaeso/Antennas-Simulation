% DIPOLE ARRAY (ex2b)
%
% 5x5 array of half-wave dipoles 0.25 lambda over a groundplane
% X-Y spacing 0.7 lambda. Frequency 1GHz
%
% Phi Squints of 0,10,20,30 Degrees are applied in 
% the theta=90 plane.

close all
clc

help ex2b

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
yrot_array(-90,1,(Nx*Ny));             % Rotate whole array 90deg around y-axis, to point in +ve x
list_array(0);                         % List the array x,y,z locations and excitations only 
plot_geom3d(1,0);                      % Plot the array geometry in 3D, with global axes

%                    /Min phi
%                   /  /Step                    /Polarisation (Total field)
%                  /  /  /Max phi              /      /Normalise to max of 0deg theta squint
%                 /  /  /                     /      /
plot_squint_phi(-90,2,90,90,90,[0,10,20,30],'tot','first');   
%                         \  \  \       
%                          \  \  \Phi squint list (squint array to each angle and plot pattern)
%                           \  \Theta squint (Theta angle in which to apply the phi squints)
%                            \Theta angle for the phi patterns)
%