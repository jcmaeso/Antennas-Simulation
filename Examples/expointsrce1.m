% POINT SOURCE NEAR FIELD (expointsrce1)
% 
% Example using the plot_field_slice1.m function
%
% In this case a single 1GHz isotropic source is placed at the origin.
% It has excitation 0dB 0deg and shows the phase of the wave, as it
% propagates out from the source. 

close all
clc
help expointsrce1

init;                                   % initialise global variables
freq_config=1e9;                        % Set frequency (Hz)
lambda=velocity_config/(freq_config);   % Calculate wavelength (m)

% *********  Array definition **********

single_element(0,0,0,'iso',0,0);


% *************  Plot patterns *************

plot_geom3d(1,0);         % Plot 3D geometry with axis (uses standard figure1)
view([30,40]);            % Select view
plot_geom3d1(1,1,20);     % Plot 3D geometry with axis and element excitations in figure 20
view([30,40]);            % Select view
axis equal;
list_array(0);            % List the array x,y,z locations and excitations only
calc_directivity(5,5);    % Calculate directivity d(theta)=5, d(phi)=5

plot_phi(0,1,360,[90],'tot','each'); 

% ******** Field slice plot *********

dBrange_config=40;  % Set dynamic range for field slice plots (dB)

xrng=1; % Dimension of slice in local x-direction (m) 
yrng=1; % Dimension of slice in local y-direction (m)
xsteps=100; % Number of steps in x (m)
ysteps=100; % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;                   % Offset in x (m)
yoff=0;                   % Offset in y (m)
zoff=0;                   % Offset in z (m)
polarisation='phase';     % Plot parameter (string)
normalise='no';          % Normalisation option (string)
units='dbloss';          % Display units

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units); 

% Fine tune the plots generated by plot_field_slice1

figure(1);         % Select the figure for the slice-plot in global coordinates.
                   % In this case figure1 which already has the 3D array geometry on it.
warning off;       % Lots of grumbling from Matlab about color data and shading, but seems to work OK
shading flat;
axis('auto');

% Modify the title for the default 3D geometry plot
if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase');  % Plot data for ar,tau or phase options
   if strcmp(polarisation,'ar')
      Tunit='Lin Ratio';
   else   
      Tunit='Deg';
   end   
else
  Tunit='dB';
end 
Ttext=sprintf('3D Geometry \n%s Field Slice (%s)',upper(polarisation),Tunit);
title(Ttext);

figure(15);        % Select the figure for the dedicated slice plot.
shading flat;
colorbar;

steps=200;
xg1=0;yg1=0;zg1=0;
xg2=0.5;yg2=0;zg2=0;
[Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,normalise,units,1,16);
