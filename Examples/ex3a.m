% PATTERN INTERPOLATION (ex3a)
% 
% Interpolated half-wave Dipole pattern rotated 35Deg 
% about the Yaxis. Freq = 300 MHz
%
% Source files are :  dipole.nec   The NEC2 model used to generate data
%                     dipole.out   Data for interpolation 
%
% Nec data has been calculated in 10deg steps in theta and phi.
% Demonstrates the use of the 'interp' element type

close all
clear all;
clc

help ex3a

init;                                           % Initialise global variables

loadnecpat1('dipole');                          % Loads raw NEC output data, processes it and saves file called 
                                                % 'pattern1.mat' that contains variable pattern_config

load pattern1;                                  % Load the .mat file, pattern_config is now available 
                                                % in the MATLAB environment (see help for loadnecpat1 and interpl)
                      
place_element(1,0,0,0,0,0,0,'interp',0,0);      % Place element 1 at origin 0dB 0deg Phase
yrot_array(35,1,1);                             % Rotate elements 1 to 1 35deg about the y-axis                      
calc_directivity(10,10);                        % Calc directivity using 10deg theta and phi steps
list_array(0);                                  % List array details
plot_geom3d(1,0);                               % Plot 3D geometry with global axes
plot_theta(-180,5,180,[0,45,90],'tot','none');  % Plot full circle theta patterns for phi=0,45 and 90 deg
plot_pattern3d(10,10,'tot','no');               % Plot 3D total field pattern in dBi (normalisation = 'no')