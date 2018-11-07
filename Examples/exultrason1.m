% SIMPLE SONAR ARRAY (exultrason1)
% 
% Example showing the use of ArrayCalc for ultrasound modelling of a simple sidescan
% sonar array.
%
% In this case a generic circular aperture is used to model the ultrasound transducer.
% The power distribution pattern for a single transducer is displayed, together with
% the pattern for a 4x1 array of transducers. The transducers are 44mm diameter with
% 16mm gaps between them (=>60mm between centres) and are operating at 50kHz in sea water.
%
% Since ArrayCalc does all its calculations using fundamental units 
% of distance, frequency and velocity in the propagating medium, it
% can be used calculations in other homogeneous mediums e.g. air, water.
%
% Approx speed of sound in : Dry Air (20degC)       = 344 m/s
%  (Compression waves)       Fresh Water (20degC)   = 1482 m/s
%                            Sea Water (20degC)     = 1522 m/s
%                            Stainless Steel        = 5800 m/s
%
% Although the element models in ArrayCalc are primarily for Electromagnetic (EM)
% radiators such as dipoles and patches, there are also generic aperture elements
% such as 'apcirc', 'aprect' and 'dish' that can be used to model ultrasound 
% transducers : 
%  
%                APERTURE            OPTION       PARAMETERS
%
%                Circular           'apcirc'      Diameter   
%                Rectangular        'aprect'      Width,height
%                Parabolic Dish     'dish'        Dia,Taper_Factor,Edge_Value
%
%
% By plotting the patterns for a single aperture it should be possible to 'tune'
% the parameters to give a pattern close to that of the actual transducer.
% To use this example, simply set the array dimensions Nx,Ny to be 1,1 respectively.
%
% If this is not possible, the pattern could be interpolated from measured data
% using the 'interp' element. Or, the 'user1' element could be defined, using a
% suitable element model. Look at the other models such as apcirc to see how to
% define the model and geometry for display. See interpl and user1 in the 
% element_models directory end examples 3a/b.
%
% In EM modelling the waves are transverse and therefore polarised. In general,
% for ultrasound applications the waves are compression (longitudinal). It
% is therefore recommended that the 'tot' polarisation option is used for
% analysis/plotting.
%
% For a specific Ultrasound modelling toolbox search for 'Ultrasim' on the web.
% This array configuration has been run on Ultrasim and gives very similar results.

close all
clc

help exultrason1

% Define some parameters
init;                                 % Initialise global variables
dBrange_config=30;                    % Dynamic range for plots
freq_config=50e3;                     % Specify frequency (Hz)
velocity_config=1522;                 % Approx speed of sound in sea water at 20degC (m/s)
lambda=velocity_config/freq_config;   % Calculate wavelength (m)
diameter=44e-3;                       % Transducer diameter (m)
apcirc_config=diameter;               % Circular aperture diameter (m)

% Steer array main beam to direction (theta,phi) if required
theta=0;   % Theta (deg)                            
phi=0;     % Phi (deg)
Elref=1;   % Reference element for phase excitations

eltype='apcirc';            % Element model

% Array parameters
Nx=4;                       % Number of elements in x-axis direction       
Ny=1;                       % Number of elements in y-axis direction

gapx=16e-3;                 % Gap between edges of transducers in x-direction
gapy=16e-3;                 % Gap between edges of transducers in y-direction

Sx=gapx+diameter;           % Spacing in x-axis direction
Sy=gapy+diameter;           % Spacing in y-axis direction
Ang=0;                      % Angle of elements - % (+ve rotation about z-axis, measured from x-axis in Deg) EM use!

% Define single element and plot patterns
Pwr=0;  % Element power (dB)
Pha=0;  % Element phase (deg)
single_element(0,0,0,'apcirc',Pwr,Pha);    % Place a single element at the origin
plot_pattern3d1(5,10,'tot','yes',20);      % Plot a 3D directivity pattern using 5/10 deg theta/phi steps, fig20
T1=sprintf('Power distribution for single transducer\n');
T2=sprintf('Normalised to 0dB,  Freq %g kHz',freq_config/1000);   
title([T1,T2]);

clear_array;                          % Clear the arr_config matrix, ready for a new definition

% Define array
rect_array(Nx,Ny,Sx,Sy,eltype,Ang);   % Define array of transducers
squint_array(theta,phi,Elref);        % Steer array main beam to (theta,phi)

% Output results
fprintf('\n            Frequency %3.3f KHz',freq_config/1000);
fprintf('\n        Wave Velocity %3.3f m/s',velocity_config);
fprintf('\n               Lambda %3.3f mm',lambda*1000);
fprintf('\n  Transducer diameter %3.3f mm',diameter*1000);
fprintf('\n Cen-cen array length %3.2f mm\n\n',((Nx-1)*(diameter+gapx)*1000));

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only

plot_theta(-90,0.5,90,[0,90],'tot','first');              % Plot total power theta patterns -90 to +90 deg in 0.5deg steps
                                                        % for phi angles of 0,90. Normalise to the max of the 
                                                        % 'first' cut (phi=0).

%plot_pattern3d(2,5,'tot','yes');                        % Plot a 3D directivity pattern using 2/5 deg theta/phi steps
                                                        % Plot is normalised to peak power.
