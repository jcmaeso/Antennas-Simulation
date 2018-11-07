% OFFSET REFLECTOR NEAR FIELD (exoffreflector)
% 
% Example showing the standing wave patterns produced in the near-field
% zone of an offset parabolic reflector. 
%
% The reflector is modelled as 2D slice in the X-Y plane using half-isotropic sources 
% (hemispherical pattern). The far-field pattern will be reasonably accurate because it
% is dependent on the aperture in the same plane. The near-field is for visualisation 
% only, since actual field values would require the whole reflector surface to be modelled.
%
% This model differs from the other reflector model examples in that the feed is represented
% by a circular aperture source and ArrayCalc itself is used to calculate how the feed 
% illuminates the reflector.
%
% The model runs in two stages :
%
% The first section calculates the position and orientation of the half-isotrope sources
% used to represent the reflector surface. At the same time feed aperture's power flux 
% density is evaluated at each of the source locations. This is multiplied by the area 
% represented by the source to get its power level, which is stored for use in the next
% second section.
%
% In the second section completes the array description by adding all the half-isotrope
% elements with excitations. The array (feed and reflector) is then
% analysed as 2D slice through the X-Y plane.
%
% There are 3 options, set by the variable OPT at the beginning of the file :
%
% OPT=1  Field from feed only (reflector sources set to -999dB)
% OPT=2  Field from reflector only (feed source set to -999dB)
% OPT=3  Field from feed and reflector (default)
%
% Try changing the option value inside the file.
%
% Also try experimenting with the other parameters of Offset(O), Diameter(D) 
% and Focal Length(F).
%


close all
clc

help exoffreflector

% Define some general parameters
% ******************************
init;                                 % Initialise global variables
OPT=3;                                % Option for display output, see end of help file
dBrange_config=40;                    % Dynamic range for plots
freq_config=12e9;                     % Specify frequency (Hz)
lambda=velocity_config/freq_config;   % Calculate wavelength (m)
element='user1';                      % Default 'user1' element has a half-hemispherical pattern
AZ=30;                                % AZ value for 3D views
EL=40;                                % EL value for 3D views

% Parabolic Reflector Parameters
% ******************************
F=160e-3;           % Focal length (m)
D=200e-3;           % Reflector diameter (m)
O=100e-3;           % Offset distance from origin (m)
Fap=40e-3;          % Feed aperture diameter (m)

%                        End of basic input parameters           
% **********************************************************************************

PaYcen=O;           % Projected aperture centre Y-coordinate (m)
Yap=D;              % Projected aperture Y-dimension (m)
Ystep=lambda/2;     % Stepping distance to sample aperture (element separation) (m)

apcirc_config=[Fap];                                        % Set diameter for circular aperture, used to model feed
FeedOffAngle=180*atan(PaYcen/F)/pi+0;                       % Feed rotation angle, to point it towards centre of reflector 
place_element(0,0,-90,180+FeedOffAngle,F,0,0,'apcirc',0,0); % Feed element
calc_directivity(5,5);

% Calculate element locations (array geometry)
% ********************************************
minYap=PaYcen-Yap/2;  % Minimum Y-coord of projected aperture (m)
maxYap=PaYcen+Yap/2;  % Maximum Y-coord of projected aperture (m)

% Modify the limits slightly so that the sample points form a 
% symmetrical grid on the reflector surface

minYap=round(minYap/Ystep)*Ystep;
maxYap=round(maxYap/Ystep)*Ystep;


% Some preliminary calculations to establish reference levels
r=1/(4*pi);                         % Reference radius (m) for power density calculation (ref fieldsum rloc)
PdenRef=arraypwr_config/(4*pi*r^2); % Reference power density (W/m^2)
PdenRefdB=10*log10(PdenRef);        % Reference power density (dBW/m^2)

% Calculate the x,y,z positions of array elements used to model parabolic reflector.
% Use field sum to calculate the Amplitude and Phase of the feed element at the x,y,z
% locations. The array element parameters are stored so as not to change the array
% geometry (just the feed at this point) during the calculations.

z=0;     % Set x-coord to 0
n=0;     % Index                              
for y=minYap:Ystep:maxYap                       % Step through x-coordinates
   if y==0;y=1e-4;end
   n=n+1;                                       % Increment index
   x=(y.^2)/(4*F);                              % Calculate z-coordinate for parabola
   xc(n)=x;                                     % Store x-value
   yc(n)=y;                                     % Store y-value
   zc(n)=z;                                     % Store z-value
   [R,th,phi]=cart2sph1(x,y,z);                 % Convert (x,y,z) relative to feed centre, to (R,theta,phi) 
   Etot=fieldsum(R,th,phi);                     % Calculate the field at point x,y,z on the reflector surface 
   RelPwrdB=20*log10(Etot(1,1));                % Convert returned E-field Magnitude to Relative Pwr(dB)
   
   % Convert data into the various units
   dblossd=RelPwrdB+direct_config;           % Path loss including directivity of the feed (dB power)
   dbwm2=PdenRefdB+dblossd;                  % Power density (dBW/m^2)
   wm2=10.^((dbwm2)/10);                     % Power density (W/m^2)
   Pwr(n)=10*log10(wm2*(Ystep^2));                   % Power density x Area of array element, converted to dB
   Phase=Etot(1,8);                                  % Phase 'tot' parameter returned from fieldsum.m
   Pha(n)=mod(Phase,360);                            % Divide modulo 360
   EleRotAng(n)=-0.5*(atan2((F-x),y)*180/pi-90);     % Calculate rotation angle for reflector element so its local
end                                                  % groundplane is parallel to parabolic surface
N=n;

clear_array; % Clear the feed element

% Use the stored array element parameters to define the reflector

% Select whether reflector is to be energised
if OPT==1
   Pwr(1:N)=-999;
end

for n=1:1:N
  place_element(n,0,-90,EleRotAng(n),xc(n),yc(n),zc(n),element,Pwr(n),Pha(n)); % Place the reflector elements
end

% Select whether feed is to be energised
if OPT==2
   FeedPwrdB=-999;
else   
   FeedPwrdB=0;
end

place_element(0,0,-90,180+FeedOffAngle,F,0,0,'apcirc',FeedPwrdB,0); % Put back the feed element
   
                                     
plot_geom3d(1,0);                            % Plot the array geometry in 3D
list_array(0);                               % List the array elements 

% Display parameters used
fprintf('\n                 Frequency %3.2f GHz',freq_config/1e9);
fprintf('\n                    Lambda %3.2f mm',lambda*1000);
fprintf('\n        Reflector Diameter %3.2f mm',D*1000);
fprintf('\n    Aperture centre offset %3.2f mm',O*1000);
fprintf('\n              Focal length %3.2f mm',F*1000);
fprintf('\n    Feed aperture diameter %3.2f mm\n\n',Fap*1000);


% ******** Field slice plot *********
% ***********************************

xrng=0.600;   % Dimension of slice in local x-direction (m) 
yrng=D*1.25;    % Dimension of slice in local y-direction (m)
xsteps=100;     % Number of steps in x (m)
ysteps=50;    % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=xrng/2;          % Offset in x (m)
yoff=PaYcen;          % Offset in y (m)
zoff=0;               % Offset in z (m)
polarisation='tot';     % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='dbloss';         % Display units
fignum1=20;             % Figure number for plot in global coordinates (numeric)
fignum2=21;             % Figure number for plot in local coordinates (numeric)


plot_geom3d1(1,0,fignum1);                            % Plot the array geometry in 3D
view([AZ,EL]);


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


%       Plot field along a lines through 3D space
% *******************************************************

% Cross section through beam 
% ==========================

if OPT==1 % Feed only
 % First end of line P1
 xg1=xc(1);
 yg1=yc(1);  
 zg1=zc(1);

 % Second end of line P2
 xg2=xc(N);
 yg2=yc(N);
 zg2=zc(N);
else     % Feed + reflector or reflector only
 % First end of line P1
 xg1=F+300e-3;
 yg1=-yrng/2+PaYcen;
 zg1=0e-3;

 % Second end of line P2
 xg2=F+300e-3;
 yg2=+yrng/2+PaYcen;
 zg2=0e-3;
end

% Define parameters to be plotted
steps=200;              % Number of steps for line-slice plots
polarisation='tot';     % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='dbloss';         % Display units
fignum1=20;             % Figure number for displaying line orientation in global coords (numeric)
fignum2=25;             % Figure number for 2D plot (numeric)

[Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,...
              normalise,units,fignum1,fignum2);
           
set(fignum2,'name','Beam Cross Section');
           

% Intensity along beam axis yg=0e-3
% =================================

if OPT==1   % Feed Only
 % First end of line P1
 xg1=F;
 yg1=0e-3;
 zg1=0e-3;

 % Second end of line P2
 xg2=0e-3;
 yg2=PaYcen;
 zg2=0e-3;
else       % Feed + reflector or reflector only
 % First end of line P1
 xg1=0e-3;
 yg1=PaYcen;
 zg1=0e-3;

 % Second end of line P2
 xg2=xrng;
 yg2=PaYcen;
 zg2=0e-3;
end 
 
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
if OPT==1
   plot_phi(-180,0.5,180,[90],'tot','first');
else   
   plot_phi(-90,0.5,90,[90],'tot','first'); 
end   
figure(1);
view([AZ,EL]);
axis('tight');
axis('equal');

figure(20);

