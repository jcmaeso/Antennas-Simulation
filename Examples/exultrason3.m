% MULTI-FOCUS ULTRASOUND TRANSDUCER (exultrason3)
% 
% Example showing the use of ArrayCalc for ultrasound modelling of a focused ultrasound
% transducer, such as used in medical imaging.
% 
% One of the advantages of using sound waves over electromagnetic waves for medical
% imaging is the relatively low velocity (1522m/s) of sound waves passing through the body.
% This results in very short wavelengths (0.4mm) for quite modest operating frequencies
% (3.5Mhz). In turn a physically small array (14mm Diameter) still has a large effective 
% aperture (35 lambda).
%
% Large apertures (in wavelengths) are good because they give more gain for a given physical
% size. The problem is that the far-field distance (2*D^2)/lambda, where D is the largest 
% aperture dimension, is quite large (980mm). This means that the beam from the transducer
% may not be well formed within the region of interest. To compensate for this, ultrasound
% arrays are geometrically focused by mounting the elements such that they follow a parabolic 
% profile. This allows the beam to be 'focused' at a range of a few centimeters, within the 
% region of interest in the body. In order to maintain a low profile, the parabolic form can 
% be stepped a bit like a Fresnel lens. To improve the useful depth-range, different sections
% of the array can have different focal lengths, at the expense of some beam intensity.
%
% This example is written to model circular and elliptical apertures however the parameters
% are set to produce a single line of sources in this example, to keep the run-time short. 
%
% See inside file for details, try un-focusing the array by setting the focal lengths 
% to F1=F2=F3 = 2500e-3.


close all
clc

help exultrason3

% Define some general parameters
% ******************************
init;                                 % Initialise global variables
dBrange_config=50;                    % Dynamic range for plots
freq_config=3.5e6;                    % Specify frequency (Hz)
velocity_config=1522;                 % Approx speed of sound in sea water at 20degC (m/s)
lambda=velocity_config/freq_config;   % Calculate wavelength (m)
element='user1';                      % Default 'user1' element has a half-hemispherical pattern

% Transducer element parameters
% *****************************
F1=20e-3;R1=2e-3;          % Transducer focal length and radius #1,  F=F1 for radius<R1    (m)
F2=25e-3;R2=5e-3;          % Transducer focal length and radius #2,  F=F2 for R1<radius<R2 (m)
F3=30e-3;R3=7e-3;          % Transducer focal length and radius #3,  F=F3 for R2<radius<R3 (m)

diameter=14.0e-3; % Transducer diameter (m)

PaXcen=0e-3;      % Projected aperture centre X-coordinate (m)
PaYcen=0e-3;      % Projected aperture centre Y-coordinate (m)

Xap=lambda/10;       % Projected aperture X-dimension (m)
Yap=diameter;        % Projected aperture Y-dimension (m)

XYstep=lambda/2;     % Stepping distance to sample aperture (element separation) (m)

%                         End of basic input parameters           
% **********************************************************************************


% Calculate element locations (array geometry)
% ********************************************
minXap=PaXcen-Xap/2;  % Minimum X-coord of projected aperture (m)
maxXap=PaXcen+Xap/2;  % Maximum X-coord of projected aperture (m)

minYap=PaYcen-Yap/2;  % Minimum Y-coord of projected aperture (m)
maxYap=PaYcen+Yap/2;  % Maximum Y-coord of projected aperture (m)

% Modify the limits slightly so that the sample points form a 
% symmetrical grid on the reflector surface

minXap=round(minXap/XYstep)*XYstep;
maxXap=round(maxXap/XYstep)*XYstep;

minYap=round(minYap/XYstep)*XYstep;
maxYap=round(maxYap/XYstep)*XYstep;

Pwr=0;                   % Initialise power level variable for elements
Pha=0;                   % Initialise phase level variable for elements

for x=minXap:XYstep:maxXap                          % Step through x-coordinates
 for y=minYap:XYstep:maxYap                         % Step through y-coordinates
  xr1=(x-PaXcen);                            % x-coord relative to projected aperture centre
  yr1=(y-PaYcen);                            % y-coord relative to projected aperture centre
  r1=sqrt(xr1.^2+yr1.^2);                    % Radial distance from centre of projected aperture to point x,y
  ang1=atan2(xr1,yr1);                       % Angle from centre of aperture to point x,y

  xr2=(Xap/2).*sin(ang1);
  yr2=(Yap/2).*cos(ang1);                    % Point on aperture periphery in direction ang1
  r2=sqrt(xr2.^2+yr2.^2);                    % Radial distance from centre of projected aperture to periphery point
  
  if r1<r2                                   % Decide whether point lies within the specified aperture
     
   if r1<=R3;F=F3;end % Outer section focal length F3
   if r1<=R2;F=F2;end % Intermediate section focal length F2
   if r1<=R1;F=F1;end % Centre section focal length F1
     
   z=(x.^2+y.^2)/(2*F);                      % Calculate z-coordinate for focusing
   single_element(x,y,z,'user1',Pwr,Pha);    % Place the element 
  end
 end
end

plot_geom3d(1,0);                            % Plot the array geometry in 3D
view([35,10]);
axis('tight');

% Display parameters used
fprintf('\n                 Frequency %3.2f KHz',freq_config/1000);
fprintf('\n             Wave Velocity %3.2f m/s',velocity_config);
fprintf('\n                    Lambda %3.2f mm',lambda*1000);
fprintf('\n       Transducer diameter %3.2f mm',diameter*1000);
fprintf('\n      Centre section f-len %3.2f mm',F1*1000);
fprintf('\nIntermediate section f-len %3.2f mm',F2*1000);
fprintf('\n       Outer section f-len %3.2f mm\n\n',F3*1000);



% ******** Field slice plot *********
% ***********************************

xrng=0.05;    % Dimension of slice in local x-direction (m) 
yrng=0.025;   % Dimension of slice in local y-direction (m)
xsteps=100;   % Number of steps in x (m)
ysteps=50;    % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=90;       % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;                % Offset in x (m)
yoff=0;                   % Offset in y (m)
zoff=xrng/2;              % Offset in z (m)
polarisation='tot';     % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='dbloss';         % Display units
fignum1=20;             % Figure number for plot in global coordinates (numeric)
fignum2=21;             % Figure number for plot in local coordinates (numeric)


plot_geom3d1(1,0,fignum1);                            % Plot the array geometry in 3D
view([35,10]);

% Generate field-slice plots in global and local coordinates, fignum1 / fignum2   
[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);    


% Fine tune the plots generated by plot_field_slice1

figure(fignum2);   % Select the figure for the slice-plot in local coordinates
colorbar;
warning off;       % Lots of grumbling from Matlab about color data and shading, but seems to work OK
shading interp;
warning on;

figure(fignum1);  % Select the figure for the slice plot in global coordinates.
                  % In this case figure1 which already has the 3D array geometry on it.
axis equal;
warning off;      % Lots of grumbling from Matlab about color data and shading, but seems to work OK
shading interp;
%warning on;
colorbar;



% Plot field along a lines through 3D space
% *****************************************

% Cross-section through beam at zg=30e-3

% First end of line P1
xg1=0e-3;
yg1=-10e-3;
zg1=30e-3;

% Second end of line P2
xg2=0e-3;
yg2=+10e-3;
zg2=30e-3;

% Define parameters to be plotted
steps=200;
polarisation='tot';     % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='dbloss';         % Display units
fignum1=20;             % Figure number for displaying line orientation in global coords (numeric)
fignum2=25;             % Figure number for 2D plot (numeric)

[Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,...
              normalise,units,fignum1,fignum2);
           
set(fignum2,'name','Beam Cross Section');
           

% Intensity along beam axis yg=0e-3

% First end of line P1
xg1=0e-3;
yg1=0e-3;
zg1=0e-3;

% Second end of line P2
xg2=0e-3;
yg2=0e-3;
zg2=50e-3;

% Define parameters to be plotted
steps=200;
polarisation='tot';     % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='dbloss';         % Display units
fignum1=20;             % Figure number for displaying line orientation in global coords (numeric)
fignum2=26;             % Figure number for 2D plot (numeric)

[Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,...
              normalise,units,fignum1,fignum2);
set(fignum2,'name','Beam Axis Profile');

