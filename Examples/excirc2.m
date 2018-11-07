% CIRCULAR POLARISATION METHOD 2 (excirc2)
% 
% Crossed dipoles
% Overlaid, in-phase and spaced lambda/4 apart give LHCP in the Z-axis direction
%
% Try the 'rhcp' plotting option for X-polar response (3D and 2D Plots).
% And the 'ar' option to see the axial ratio overlaid on the
% 'tot' pattern (3D only).


close all
clc

help excirc2

init;                                 % Initialise global variables

freq_config=300e6;                    % Specify frequency
lambda=3e8/freq_config;               % Calculate wavelength
dipole_config=lambda/2;
single_element(0,0,0,'dipole',0,0);         % 1st dipole
single_element(0,0,lambda/4,'dipole',0,0);  % 2nd dipole (Z height=lambda/4)
zrot_array(-90,2,2);                        % Rotate the 2nd dipole 90 deg

plot_geom3d(1,0);
list_array(0);

calc_directivity(5,15);
plot_theta(-180,5,180,[0,45],'lhcp','each'); 
plot_pattern3d(5,15,'lhcp','no');         

