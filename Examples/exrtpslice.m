% POWER RECEIVED BY APERTURE (exrtpslice)
% 
% This example shows how to position an aperture in spherical (R,theta,phi)
% coordinates and calculate the total power collected by it.
%
%
%     The radiating antenna parameters :
%              Type = Single rectangular patch element.
%              Freq = 2.45GHz
%              Er   = 3.48 (Rogers 4350)
%              h    = 1.6mm
%       Input power = 10W
%        Efficiency = Calculated, see text output.
%
%     Aperture parameters :
%       x-dimension = lambda/2 (m)
%       y-dimension = lambda/2 (m)
%    Location :   R = 0.2 (m) 
%             Theta = 50 (Deg)
%               Phi = 70 (Deg)
%
% IMPORTANT (for small values of R) 
% When summing the plot_field_slice data to get total power, each sample point must
% be multipled by the cosine of the incident angle. This can easily be calculated 
% using a combination of data supplied to and returned from the function. In this 
% case the cosine of the incident angle is just : 
%
%   cos(incident angle) = adjacent/hypotenuse 
%
%   cos(incident angle) = The radial distance from the antenna centre to the aperture centre : (R) 
%                    ___________________________________________________________________________________
%
%                  The  radial dist from antenna centre to sample point in aperture : sqrt(XG.^2+YG.^2+ZG.^2)
%
%
%   Where : XG,YG,ZG are arrays of the global coordinates of the aperture sample points (centres of
%           the squares in the field_slice plot). So each sample point has a different incident angle.
%
%   For large values of R i.e. R>>(largest dimension of array)
%   There is no need to multiply by the cosine of the incident angle. 
%   


close all
clc

help exrtpslice

init;                                                   % Initialise global variables
freq_config=2.45e9;                                     % Specify frequency
arraypwr_config=10;                                     % Seta antenna input power to 10W
lambda=velocity_config/freq_config;                     % Calculate wavelength

% Location of aperture
R=0.2;         % Radial distance of aperture from centre of radiating antenna element (m)
theta=50;      % Theta direction (deg)
phi=70;        % Phi direction (deg)
% Aperture dimensions
Xdim=lambda/2; % X-Aperture dimension
Ydim=lambda/2; % Y-aperture dimension

% Patch element parameters

h=0.76e-3;         % Patch height (m) 
Er=3.48;           % Substrate dielectric constant
Freq=freq_config;  % Frequency (Hz)  
sigma=5.8e7;       % Metal conductivity (cooper)
tand=0.004;        % Dielectric loss tangent
VSWR=2.0;          % VSWR value for bandwidth estimate

patchr_config=design_patchr(Er,h,Freq);                 % Design patch,  patchr_config format is [Er,W,L,h].
W=patchr_config(1,2);                                   % Retrieve patch width W from patchr_config
L=patchr_config(1,3);                                   % Retrieve patch length L from patchr_config 
eff=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR);     % Estimate patch efficiency
arrayeff_config=eff;                                    % Set the antenna efficiency to the patch efficiency (percent)

single_element(0,0,0,'patchr',0,0);                     % Place a single element at the origin excited : 0dB 0deg

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
norm_array;                                             % Normalise array excitations, in case more elments are added.

plot_theta(-90,2,90,[-45,0,45,90],'tot','none');        % Plot total power theta patterns theta= +/-90 deg in 2deg steps
                                                        % for phi angles of -45,0,45,90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                                                        % Normalisation option is 'no' so total power is plotted in dBi
                                                        
% ******** Field slice plot #1 *********

% Intermediate calculations
[xo,yo,zo]=sph2cart1(R,(theta)*pi/180,phi*pi/180);  % Calculate offset distances for slice
Theta=-theta;                                       % Theta value for use in plot_field_slice
Phi=-phi;                                           % Phi value for use in plot_field_slice

% Plot_field_slice parameters
xrng=Xdim; % Dimension of slice in local x-direction (m) 
yrng=Ydim; % Dimension of slice in local y-direction (m)
xsteps=20; % Number of steps in x (m)
ysteps=20; % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=Theta;    % Rotation about y-axis (deg)
zrot=Phi;      % Rotation about z-axis (deg)
xoff=xo;     % Offset in x (m)
yoff=yo;     % Offset in y (m)
zoff=zo;     % Offset in z (m)
polarisation='tot';     % Plot parameter (string)
normalise='no';         % Normalisation option (string)
units='wm2';            % Display units
fignum1=1;           % Figure for 3D display
fignum2=15;          % Figure for dedicated plot

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,1,15); 

Area=(xrng/(xsteps))*(yrng/(xsteps));         % Area of each sample square
AreaEf=Area*(R./sqrt(XGC.^2+YGC.^2+ZGC.^2));  % Effective area of each square.  (cos(incident angle)=opp/adjacent)

LinDataMag=PlotData.*AreaEf;                 % Multiply piecewise (.*) the W/m^2 data by the Effective area of each sample  
TotPwr1=sum(sum(LinDataMag));                % Sum all the cosine corrected samples
TotRad1=arraypwr_config*arrayeff_config/100; % Total radiated power (W)

fprintf('\n\n                   Frequency = %3.3f MHz\n',freq_config/1e6);
fprintf('                      Lambda = %3.3f cm\n\n',lambda*100);
fprintf('         Antenna input power = %3.3f W\n',arraypwr_config);
fprintf('   Antenna efficiency factor = %3.3f\n', arrayeff_config/100);
fprintf('        Total radiated power = %3.3f W\n',TotRad1);

fprintf('\n     Rx aperture X-dimension = %3.3f m  (%3.3f lambda)\n',Xdim,Xdim/lambda);
fprintf('     Rx aperture Y-dimension = %3.3f m  (%3.3f lambda)\n',Ydim,Ydim/lambda);
fprintf(' Spherical coords (R,th,phi) = (%3.2f m,%3.2f Deg,%3.2f Deg)\n',R,theta,phi);
fprintf('     Total Rx Aperture Power = %3.3f W  (%3.2f percent of total radiated)\n\n',TotPwr1,TotPwr1/TotRad1*100);

figure(1);
axis('auto'); 
axis('equal');
view([160,40]); % Set 3D geom view to be normal to slice (160=90+phi) (40=90-theta)
ax=axis;
axis(ax/1.5);   % Zoom in by 1.5x
title('3D Geometry field slice W/m^2');
figure(15);      
view([90,90]);  % Set slice view to be same orientation as 3D view
