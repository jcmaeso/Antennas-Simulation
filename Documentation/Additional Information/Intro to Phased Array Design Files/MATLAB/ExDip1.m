close all
clc

init;                      % Initialise global variables

freq_config=1e9;           % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

dipoleg_config=[lambda*0.5,0.25*lambda];

Spc=0.65;
rect_array(6,1,Spc*lambda,0,'dipoleg',90);
taywin_array(20.5,'x');
squint_array(15,0,1);
plot_geom3D(1,0);
ax=axis;
axis(ax/2);
view(45,45);
list_array(0);
%calc_directivity(3,10);
plot_theta(-90,1,90,[0,90],'tot','first');
%plot_pattern3d(3,10,'tot','no')








