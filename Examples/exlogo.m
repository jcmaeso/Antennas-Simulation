% ARRAYCALC LOGO (exlogo)
% 
% Shows the 3D pattern and array geometry for a 64-element
% rectangular array array of patches.
%
% The array is squinted to theta=25, phi=45deg.
%
% The array element pitch is 0.6 lambda
%
% The array element is :
%
% Single rectangular patch
% Freq = 2.45GHz
% Er   = 3.43 (Rogers 4350)
% h    = 1.6mm

close all
clc

help exlogo


init;                                                   % Initialise global variables
freq_config=2.45e9;                                     % Specify frequency
lambda=3e8/freq_config;                                 % Calculate wavelength
patchr_config=design_patchr(3.43,1.6e-3,freq_config);   % Use design_patchr to assign the patchr_config
                                                        % parameters.
rect_array(8,8,(0.6*lambda),(0.6*lambda),'patchr',0)
squint_array(25,45,1);                                  % Steering the array to theta=25, phi=45 deg. 
                                                        

plot_geom3d(1,0);                                       % Plot 3D geometry with axis

list_array(0);                                          % List the array x,y,z locations and excitations only

plot_theta(-90,2,90,[0,45,90],'tot','each');            % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0,45,90. Normalise to the max of the 
                                                        % 'first' cut (phi=0).

plot_geopat3d(2,5,'tot','yes','surf',1.8);              % Plot a 3D directivity pattern using 5/10 deg theta/phi steps
                                                        % and overlay array geometry.