% ANTENNA COVERAGE PATTERN (excoverage)
%
% Shows the use of geometry construction commands to construct
% a vertical array of horizontal dipoles. The specifications
% of the array are :
%
%          Number of elements = 6
%             Element spacing = 0.7 lambda
%         Electrical downtilt = 8 Deg
%                   Sidelobes < 20dB w.r.t main lobe
%                   Frequency = 1 Ghz
%                 Input power = 10W 
%                  Efficiency = 80%
%
%      Calculated directivity = 15.8 dBi
%             Calculated Gain = 14.8 dB
%
% To get an idea of what a coverage pattern might look like on the
% ground a field-slice plot is added, measuring 100m x 100m and 10m
% below the centre of the antenna. The plot shows the power 
% distribution on the ground in W/m^2.
%
% Two line_slice plots are generated :
%   
%    1) A plot of power flux density moving along the ground away from
%       the base of the antenna mast. Because the line is invariant in 
%       two of the primary axes it is plotted w.r.t the global axis set.
%
%    2) A plot of power flux density moving away from the antenna in
%       the direction of maximum radiation. Because the line varies in
%       two axes it is plotted w.r.t. distance along the line. 
%
% The efficiency figure is just an estimated value, based on experience,
% to include feed network, element and radome losses. For patch antennas
% there are the calc_patchr_eff and calc_patchc_eff functions to estimate
% the efficiency of rectangular and circular patch antennas respectively.
%
%

close all
clc

help excoverage

init;                    % Initialise global variables
arraypwr_config=10;      % Set array input power to 10W
arrayeff_config=80;      % Set array efficiency to 80%
freq_config=1e9;         % Set frequency to 1GHz
lambda=3e8/freq_config;  % Calculate wavelength

% ****************** Array Definition *******************
% *******************************************************

% Dipole over ground parameters
len=0.5*lambda;          % Length (m)
h=0.25*lambda;           % Height above ground (m)
dipoleg_config=[len,h];  % Define vector of parameters

% Construct the array
N=6;       % Number of array elements
tilt=8;    % Tilt angle of main beam (deg) 
height=10; % Height of antenna (m)

rect_array(1,N,0,0.7*lambda,'dipoleg',0);  % 6-element array of dipoles along the y-axis
taywin_array(20,'y');                      % Apply amplitude taper to give -20dB sidelobe levels
squint_array(tilt,90,1);                   % Squint array to theta=tilt(deg), phi=0(deg), ref elmnt 1
xrot_array(90,1,99);                       % Rotate the whole array 90deg around the x-axis

list_array(0);
norm_array;                                % Normalise linear array element excitations so they sum to unity
list_array(0);

% ************** End of Array Definition ****************
% *******************************************************


% **************  Preliminary Plots *********************

plot_geom3d(1,0);      % Plot array geometry (default figure 1)
figure(1);
view(140,40);          % Select view angle AZ,EL
ax=axis; 
axis(ax/1.5);          % Zoom in by 1.5x

[ThetaMaxDeg,PhiMaxDeg]=calc_directivity(4,4);   % Calculate directivity : theta_step=2deg, phi_step=5deg
plot_pattern3d(2,10,'tot','no');                 % Plot 3D gain pattern : theta_step=2deg, phi_step=10deg

plot_theta(-180,2,180,[90],'tot','none');        % Plot rect and polar patterns in theta for phi=90
plot_phi(-180,2,180,[90+tilt],'tot','none');     % Plot rect and polar patterns in phi for theta=90+tilt


% ***************** Field slice plot ********************

dBrange_config=40;  % Set dynamic range for field slice plots (dB)

xrng=100; % Dimension of slice in local x-direction 
yrng=100; % Dimension of slice in local y-direction
xsteps=100; % Number of steps in x direction (m)
ysteps=100; % Number of steps in y direction (m)
xrot=0;        % Rotation about x-axis (deg)
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;                   % Offset in x (m)
yoff=50;                  % Offset in y (m)
zoff=-height;             % Offset in z (m)   Leave antenna at 0,0,0 and plot field at z=-(antenna height)
polarisation='tot';     % Plot parameter (string)
normalise='no';         % Normalisation option (string)
units='wm2';            % Display units (string)
fignum1=20;             % Figure number for plot in global coords (numeric)
fignum2=21;             % Figure number for plot in local coords (numeric)


% Plot the field slice
[XG,YG,ZG,XL,YL,ZL,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
          xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);
       

% Fine tune the display for local (fignum2) plot
% *********************************************** 
figure(fignum2);   
set(gcf,'name','Coverage');
view([0,90]);     % View from antenna origin 
shading interp;


% Plot flux density profile along ground, moving away from antenna
% ****************************************************************
plot_line_slice(0,0,zoff,0,yrng,zoff,200,polarisation,normalise,units,fignum1,fignum2);
figure(fignum2);
title('Power flux density along ground (W/m^2)');

% Plot flux density profile moving away from antenna in direction of maximum radiation
% ************************************************************************************
fignum1=20;
fignum2=22;
units='wm2';

R1=10;                             % Distance from antenna for first end of line, not zero to avoid very high flux values
[x1,y1,z1]=sph2cart1(R1,ThetaMaxDeg*pi/180,PhiMaxDeg*pi/180); % Polar to rect coords in direction of max radiation,
                                                              % could use earlier directivity calculation.

R2=height/sin(tilt*pi/180);      % Distance from antenna, calculated so end of line will be at ground level.                           
[x2,y2,z2]=sph2cart1(R2,ThetaMaxDeg*pi/180,PhiMaxDeg*pi/180); % Polar to rect coords in direction of max radiation,
                                                              % reference earlier directivity calculation.

plot_line_slice(x1,y1,z1,x2,y2,z2,200,polarisation,normalise,units,fignum1,fignum2);
figure(fignum2);
title('Power flux density in direction of maximum radiation (W/m^2)');
xlabel('Radial distance from antenna (m)');
axis([0,100,0,0.25]);

% Fine tune the display for global figure 20 plot after all surfaces and lines have been added to it
% **************************************************************************************************       
figure(fignum1);  % Select the figure with global axis plot
axis auto;        % Set up the axes for a nice view
axis equal;
axis tight;
view([140,40]);   % Select view
warning off;      % Lots of grumbling from Matlab about color data and shading, but seems to work OK
shading interp
colorbar;
Ttext=sprintf('Field coverage (%s) W/m^2',upper(polarisation));
title(Ttext);
set(gcf,'name','Coverage 3D');
hold on;
Xp=[0,0];Yp=[0,0];Zp=[-height,0];plot3(Xp,Yp,Zp,'k','linewidth',3); % Put a short line in to represent antenna mast
text(0,0,0,'Array','fontsize',8,'fontweight','bold');
xlabel('Global X-axis (m)');
ylabel('Global Y-axis (m)');
zlabel('Global Z-axis (m)');
rotate3d;


% Add a contour plot (fignum2+1) using returned data from plot_field_slice1
% *************************************************************************
figure(23);   
[c,h]=contour(XG,YG,PlotData);
clabel(c,h);
colorbar;
Ttext=sprintf('Field coverage (%s) W/m^2',upper(polarisation));
title(Ttext);
xlabel('Global X-axis (m)');
ylabel('Global Y-axis (m)');
set(gcf,'name','Coverage Contour');
view([0,90]);     % View from antenna origin 
shading interp;
grid on;
%warning on;


