% TAYWIN ARRAY EXAMPLE1 (extaywin1)
% 
% Example showing the use of the circ_array and taywin_array functions.
%
% A circular array of 48 patches in 4 rings is defined. Then an
% amplitude taper based on the Taylor distribution is applied as
% a function of radius. The target 1st sidelobe level is -25dB relative
% to the main lobe peak.
%
% Note that the Taylor distribution assumes isotropic sources, the 
% slight reduction in the 1st sidelobe level (compared to -25 requested)
% is due to the patch element pattern.

close all
clc

help extaywin1


init;                                                        % Initialise global variables
freq_config=2.45e9;                                          % Specify frequency
lambda=3e8/freq_config;  
patchr_config=design_patchr(3.43,1.6e-3,freq_config);        % Use design_patchr to assign the patchr_config
                                                        
circ_array(3,4,(0.6*lambda),(0.6*lambda),'patchr',0,'yes');  % Circ array 4 rings, starting with 3 elements
taywin_array(25,'r');                                        % Apply Taylor distribution as a function of radius

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
plot_geom2d(1,1);
list_array(0);                                          % List the array x,y,z locations and excitations only

plot_theta(-90,1,90,[0,45,90],'tot','first');           % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0,45,90. Normalise to the max of the 
                                                        % 'first' cut (phi=0).

%plot_pattern3d(2,5,'tot','yes');                       % Plot a 3D directivity pattern using 2/5 deg theta/phi steps
                                                        % Plot is normalised to peak power.
