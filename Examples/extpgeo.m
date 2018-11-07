% ADDING 2D PATTERNS TO 3D GEOMETRY (extpgeo)
% 
% An example showing the use of the plot_theta_geo1 and plot_phi_geo1 
% commands to display 2D theta pattern cuts on the specified 
% 3D geometry plot. See plot_geom3d1 for plotting geometry on figures
% other than figure1 
%
% The plot_theta_geo1 and  plot_phi_geo1 commands allow the plot colour
% and figure number to be specified.
% 
% The example uses a 4 x 1 array of circular patches (0.7 lambda spacing),
% orientated vertically to show Azimuth and Elevation patterns.


close all
clc

help extpgeo


init;                                                   % Initialise global variables
freq_config=2.45e9;                                     % Specify frequency
lambda=3e8/freq_config;
patchc_config=design_patchc(3.43,1.6e-3,freq_config);   % Use design_patchc to assign the patchc_config
                                                        % parameters.

rect_array(4,1,(0.7*lambda),(0.7*lambda),'patchc',0);   % Define a 4 x 1 array of circular patches
yrot_array(-90,1,4);                                    % Rotate array -90deg around y-axis

figure(20);
clf;
plot_geom3d1(1,0,20);                                   % Plot 3D geometry with axis on figure 20
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
   

plot_theta_geo1(0,2,180,[0],'tot','no','r-',20);        % Display the 'total' theta (for phi=0 i.e. Elevation) pattern 
                                                        % in red on the 3D geom plot in figure20

plot_phi_geo1(0,2,360,[90],'tot','no','b-',20);         % Display the 'total' phi (for theta=90 i.e. Azimuth) pattern
                                                        % in blue on the 3D geom plot in figure20

axis tight;
view([60,30]);

