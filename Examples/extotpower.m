% TOTAL RADIATED POWER (extotpower)
% 
% This example was set up to verify the plot_field_slice function's ability to
% calculate absolute power densities.
%
% The test antenna, in this case a 1Ghz isotropic source, is surrounded by a 
% bounding cube. The cube is formed by 6 calls to the plot_field_slice function 
% with with the normalisation option set to 'no' and units set to 'wm2' (W/m^2). 
% The total power incident on each of the cube sides is calculated by summing 
% the requested sample points (50 x 50), multiplied piecewise by the cosine of 
% the incident angle. 
% 
% IMPORTANT ! 
% When summing the plot_field_slice data to get total power, each sample point must
% be multipled by the cosine of the incident angle. This can easily be calculated for
% slices in the primary axes using a combination of data supplied to and returned from
% the function . For a slice in the Y-Z plane offset in the X-direction, the code would
% be : 
%
%   [XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
%                                       xoff,yoff,zoff,polarisation,normalise,units,1,15); 
%                                
%   Area=(xrng/(xsteps))*(yrng/(xsteps));               % Area of each sample square
%   AreaEf=Area*((xoff)./sqrt(XGC.^2+YGC.^2+ZGC.^2));   % Effective area of each square = Area*cos(incident angle)  
%                                                       %                               = Area*(adj/hyp)
%
%   LinDataMag=PlotData.*AreaEf;                        % Multiply the PlotData (W/m2) by the Effective Area (m^2)
%   TotPwr1=sum(sum(LinDataMag));                       % Sum all the sample squares
%
%
% The summed power should always equal the power radiated from the antenna irrespective of pattern.
% There maybe small differences due to the numerical integration. 
% 
% Try running the example with a rectangular patch element instead, see line 54 in the file.
%
%



close all
clc

help extotpower


init;                                                   % Initialise global variables
freq_config=1e9;                                        % Specify frequency
lambda=velocity_config/freq_config;                     % Calculate wavelength
arraypwr_config=100;                                    % Set array input power to 100W 
arrayeff_config=100;                                    % Set array efficiency to 100%
patchr_config=design_patchr(3.48,1.6e-3,freq_config);   % Use design_patchr to assign the patchr_config
                                                        % parameters.
                                                        
% Change 'iso' to 'patchr' in line below to see calculation for non-isotropic source                                                       
single_element(0,0,0,'iso',0,0);                        % Place a single isotropic element at the origin excited : 0dB 0deg
plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,5);                                  % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(0,2,360,[0,90],'tot','none');                % Plot total power theta patterns -90 to +90 deg in 2deg steps
plot_phi(0,2,360,[90],'tot','none');


% ******** Field slice plot #1 *********
box=lambda*0.8;     % Set bounding box side length (m)
dBrange_config=40;  % Set dynamic range for field slice plots (dB)

xrng=box; % Dimension of slice in local x-direction (m) 
yrng=box; % Dimension of slice in local y-direction (m)
xsteps=50; % Number of steps in x (m)
ysteps=50; % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;                 % Offset in x (m)
yoff=0;                 % Offset in y (m)
zoff=-box/2;            % Offset in z (m)
polarisation='tot';   % Plot parameter (string)
normalise='no';       % Normalisation option (string)
units='wm2';          % Display units

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
                                
Area=(xrng/(xsteps))*(yrng/(xsteps));               % Area of each sample square
AreaEf=Area*((box/2)./sqrt(XGC.^2+YGC.^2+ZGC.^2));  % Effective area of each square.  
                                                    % cos(incident angle)=adjacent/hypotenuse

LinDataMag=PlotData.*AreaEf;            % Multiply piecewise (.*) the W/m^2 data by the Effective area of each sample  
TotPwr1=sum(sum(LinDataMag));           % Sum all the cosine corrected samples
fprintf('\nTotal Power1 = %3.2f W\n',TotPwr1);



% ******** Field slice plot #2 *********

% Use the same parameters as #1 except for :

xrot=0;        % Rotation about x-axis (deg) 
yrot=90;       % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=box/2;    % Offset in x (m)
yoff=0;        % Offset in y (m)
zoff=0;        % Offset in z (m)

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
LinDataMag=PlotData.*AreaEf; 
TotPwr2=sum(sum(LinDataMag));
fprintf('\nTotal Power2 = %3.2f W\n',TotPwr2);



% ******** Field slice plot #3 *********

xrot=0;        % Rotation about x-axis (deg) 
yrot=-90;       % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=-box/2;            % Offset in x (m)
yoff=0;                % Offset in y (m)
zoff=0;            % Offset in z (m)

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
LinDataMag=PlotData.*AreaEf; 
TotPwr3=sum(sum(LinDataMag));
fprintf('\nTotal Power3 = %3.2f W\n',TotPwr3);



% ******** Field slice plot #4 *********

xrot=90;       % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;        % Offset in x (m)
yoff=box/2;    % Offset in y (m)
zoff=0;        % Offset in z (m)

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
LinDataMag=PlotData.*AreaEf; 
TotPwr4=sum(sum(LinDataMag));
fprintf('\nTotal Power4 = %3.2f W\n',TotPwr4);



% ******** Field slice plot #5 *********

xrot=-90;      % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;            % Offset in x (m)
yoff=-box/2;       % Offset in y (m)
zoff=0;        % Offset in z (m)

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
LinDataMag=PlotData.*AreaEf; 
TotPwr5=sum(sum(LinDataMag));
fprintf('\nTotal Power5 = %3.2f W\n',TotPwr5);



% ******** Field slice plot #6 *********

xrot=0;        % Rotation about x-axis (deg) 
yrot=0;        % Rotation about y-axis (deg)
zrot=0;        % Rotation about z-axis (deg)
xoff=0;        % Offset in x (m)
yoff=0;        % Offset in y (m)
zoff=+box/2;   % Offset in z (m)

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                                   xoff,yoff,zoff,polarisation,normalise,units,1,15); 
                             
LinDataMag=PlotData.*AreaEf;
TotPwr6=sum(sum(LinDataMag));
fprintf('\nTotal Power6 = %3.2f W\n',TotPwr6);


% Sum contribution for all 6 sides of cube 

fprintf('\n\n         Antenna input power = %3.2f W\n',arraypwr_config);
fprintf('   Antenna efficiency factor = %3.2f\n', arrayeff_config/100);
fprintf('        Total radiated power = %3.2f W\n',arraypwr_config*arrayeff_config/100);

fprintf('\nTotal power for all surfaces = %3.2f W\n\n',TotPwr1+TotPwr2+TotPwr3+TotPwr4+TotPwr5+TotPwr6);
figure(1);
warning off;
shading flat;
view([40,40]);
Txt1=sprintf('Power density incident on box surrounding antenna element (W/m^2)\n');
Txt2=sprintf('Freq = %3.2f Ghz   Antenna radiated power = %3.2f W',freq_config/1e9,arraypwr_config*arrayeff_config/100);
title([Txt1,Txt2]);
colorbar;