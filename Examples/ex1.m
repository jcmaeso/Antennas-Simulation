% SINGLE MICROSTRIP PATCH (ex1)
% 
% Single rectangular patch
% Freq = 2.45GHz
% Er   = 3.48 (Rogers 4350)
% h    = 1.6mm
%
% Shows directivity calculation, 
% multiple theta cuts and 3D pattern.

close all
clc

help ex1


init;                                                   % Initialise global variables
freq_config=2.45e9;                                     % Specify frequency

patchr_config=design_patchr(3.48,1.6e-3,freq_config);   % Use design_patchr to assign the patchr_config
                                                        % parameters.
                                                        
single_element(0,0,0,'patchr',0,0);                     % Place a single element at the origin excited : 0dB 0deg

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(-90,2,90,[0,45,90],'tot','none');            % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0,45,90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                                                        % Normalisation option is 'no' so total power is plotted in dBi
