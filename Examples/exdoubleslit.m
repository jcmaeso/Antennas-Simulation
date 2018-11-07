% DOUBLE SLIT FRINGE PATTERN (exdoubleslit)
% 
% Example using the plot_field_slice1.m function to show the classic fringe pattern produced 
% by a pair of narrow slits.
% 
% In this case two narrow 2.4GHz rectangular aperture sources are placed, vertically orientated
% and 4*lambda apart on the x-axis. 
%
% Try changing the slit width and separation (sx variable), see inside file.

close all
clc
help exdoubleslit

init;                              % Initialise global variables
nfmin_config=0.25;
freq_config=2.4e9;                 % Set frequency (Hz)
lambda=3e8/(freq_config);          % Calculate wavelength (m)


% Rectangular aperture (slit) parameters
length=1.0*lambda;                   % Aperture dimension in x-axis (m) Before rotating the array
width=0.05*lambda;                   % Aperture dimension in y-axis (m) Before rotating the array
aprect_config=[length,width];
                                         
%**********************************
%    Define the 2 slit array 
%**********************************
nx=2;  % Number of slits in x-direction
ny=1;  % Number of slits in y-direction
sx=lambda*4;     % Slit spacing in x-direction (m)
sy=0;            % Slit spacing in y-direction (m)
eltype='aprect'; % Element type (string)
Erot=0;          % Element rotation about z-axis (deg)

rect_array(nx,ny,sx,sy,eltype,Erot);   % Setup array

xrot_array(90,1,99); % Orientate the array boresight along y-axis
norm_array;          % Normalise array excitations to unity

% *************  Plot patterns *************


plot_geom3d(1,0);      % Plot 3D geometry with axis (uses standard figure1)
view([140,40]);        % Select view
plot_geom3d1(1,1,20);  % Plot 3D geometry with axis and element excitations in figure 20
view([180,0]);         % Select view
axis auto;             % Autoscale axes
list_array(0);         % List the array x,y,z locations and excitations only
calc_directivity(10,5);

% ******** Field slice plot #1 *********

dBrange_config=80;  % Set dynamic range for field slice plots (dB)
xrng=8*lambda; % Dimension of slice in local x-direction 
yrng=8*lambda; % Dimension of slice in local y-direction
xsteps=40;   % Number of steps in x direction
ysteps=40;   % Number of steps in y direction
xrot=0;        % Rotation about x-axis 
yrot=0;        % Rotation about y-axis
zrot=0;        % Rotation about z-axis
xoff=0;                   % Offset in x 
yoff=yrng/2;              % Offset in y
zoff=0;                   % Offset in z
polarisation='tot';     % Plot parameter
normalise='no';         % Normalisation option
units='dblossd';        % Display units
fignum1=1;              % Figure number for plot in global coordinates (numeric)
fignum2=21;             % Figure number for plot in local/global coords as appropriate (numeric)

% Generate field-slice plots in global and local coordinates, fignum1 / fignum2   
plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);    


% ********* Field slice plot #2 **********
% Leave other field_slice input values the same as for plot #1 except for...
xrot=-90;
yoff=yrng;
xrng=8*lambda; % Dimension of slice in local x-direction 
yrng=2*lambda; % Dimension of slice in local y-direction
xsteps=40;     % Number of steps in x direction
ysteps=10;     % Number of steps in y direction
fignum2=22;    % Select another figure for the field-slice plot in local coords

plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);

figure(fignum1);  % Select the figure for the slice plot in global coordinates.
                  % In this case figure1 which already has the 3D array geometry on it.

colorbar;
axis('tight');
axis('equal');

% Modify the title for the 3D geometry plot
if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase');  % Plot data for ar,tau or phase options
  Tunit='Deg';
else
  Tunit='dB';
end 
Ttext=sprintf('3D Geometry \n%s Field Slice (%s)',upper(polarisation),Tunit);
title(Ttext);


% Other 2D and 3D plots
dBrange_config=40;                              % Set dynamic range for pattern plots (dB)
plot_theta(0,2,180,[90],'tot','none');          % Plot tot theta pattern -180 to +180 deg in 2deg steps phi=90
plot_phi(0,2,180,[90],'tot','none');            % Plot tot phi pattern -180 to +180 deg in 2deg steps theta=90
plot_pattern3d1(5,2,'tot','no',23);             % Plot tot 3D pattern
view([140,40]);                                 % Select view
