function plot_wave_slice(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation)
% Plot E-field parameters visualised as a 3D wave surface added to the 3D geometry plot,
% if present (default figure1). Note that this function is for visualisation only.
% There is a minimum distance from the radiating elements at which the 'nearfield' 
% is evaluated, given in wavelengths by nfmin_config, see init.m. This is to limit 
% scaling issues for the 1/r E-field dependence. 
%
% The plotted wave is based on the relation : WaveAmp=Amp*cos(Phase)
%
% Where : Amp   is 20*log10(E(x,y,z)) normalised and then scaled to lambda (m)
%         Phase is Phase(E(x,y,z))
%
% This gives a 3D repesentation of the wave that is well proportioned for plotting
% and decays with increasing distance from the source.
%
% The propagation of waves can be dynamically illustrated using another function
% plot_wave_anim. This function calls plot_wave_slice to produce a series of plots
% with incremental element phases, these are then animated using Matlab's 'movie' 
% function. See the exanim1/2/3 examples.
%
%
% Usage: plot_wave_slice(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation)
%
% xrng......Slice dimensions in x-direction before rotations and offsets are applied (m)
% xsteps....Number of steps in x-direction (m)
% yrng......Slice dimensions in x-direction before rotations and offsets are applied (m)
% ysteps....Number of steps in y-direction (m)
%
% xrot......Rotation about x-axis (Deg)
% yrot......Rotation about y-axis (Deg)
% zrot......Rotation about z-axis (Deg)
% 
% xoff......Offset in x direction (m)
% yoff......Offset in y direction (m)
% zoff......Offset in z direction (m)
%
%
% Options for polarisation are :
%  
%               'tot'   - Total E-field
%               'vp'    - Vertical polarisation (Z-axis in global coords)
%               'hp'    - Horizontal polarisation (X-Y plane in global coords)
%
% Notes on using the plot_wave_slice function :-
%
%  The wave slice is defined as a grid in a 'local' coordinate system according
%  to the definition : X=-xrng/2:xstep:xrng/2, Y=-yrng/2:ystep:yrng/2), Z=0.
%  This grid is then subject to 3 rotations and 3 offsets to place it in the 'global'
%  system of coordinates used for the antenna.
%
%  IMPORTANT ! The rotations are applied to the fixed X,Y,Z axes in the order : 
%              X-rotation,Y-rotation,Z-rotation followed by the X,Y,Z offsets.
%
%              Positive rotation is defined as :  
%              Clockwise about axis looking towards the origin
%
%                +Z
%                 |
%                 | Field slice, local coordinate system : origin os
%                 |                                        x-axis xs
%                 |                                        y-axis ys
%            os---|----ys   <----- -xrng/2
%            /    |___ /_______ +Y    
%           /    /    /             
%         xs ---/----    <----- +xrng/2
%              /
%        /    /    /
%   -yrng/2  /  +yrng/2
%           /
%         +X
%


global array_config;
global freq_config;
global range_config;
global dBrange_config;
global direct_config;
global velocity_config;

vo=velocity_config;
lambda=vo/freq_config;
normalise='yes';        % Normalisation is required for the wave plot calculations
ATPflag=0;              % The 'ar','tau' and 'phase' options are not valid so set flag to False

% Convert the parameter selection into a single number
switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 otherwise,fprintf('\n\nUnknown polarisation, options are : "tot","vp" or "hp"\n');...
           fprintf('Polarisation set to "tot"\n');pol=1;param='tot'; 
end


% Calculate a rotation and offset matrix to relate the local coordinates of the
% the field slice X=-xrng/2:xstep:xrng/2, Y=-yrng/2:ystep:yrng/2), Z=0 to their
% rotated and offset position in the global system the of the antenna array. 

% Define rotation matrices for each axis
XR=rotx(xrot*pi/180);
YR=roty(yrot*pi/180);
ZR=rotz(zrot*pi/180);

% Define offset matrix for offset in each axis direction
Toff=[xoff;yoff;zoff];

% Set up 4 reference points in 3D space
P1=[0;0;0];
P2=[1;0;0];
P3=[0;1;0];
P4=[0;0;1];

% Apply the rotation about the x-axis
P1a=XR*P1;
P2a=XR*P2;
P3a=XR*P3;
P4a=XR*P4;

% Apply the rotation about the y-axis
P1b=YR*P1a;
P2b=YR*P2a;
P3b=YR*P3a;
P4b=YR*P4a;

% Apply the rotation about the z-axis and add the offsets
G1=ZR*P1b+Toff;
G2=ZR*P2b+Toff;
G3=ZR*P3b+Toff;
G4=ZR*P4b+Toff;

% Assemble 2 matricies of 4 points.
xyz1=[P1,P2,P3,P4]; % Referecnce points
xyz2=[G1,G2,G3,G4]; % Rotated and offset reference points

% Use the 2 sets of points to define a single rotation and offset matrix
[rotoff]=coord2troff(xyz1,xyz2);

% Calculate step sizes
xstep=xrng/xsteps;
ystep=yrng/ysteps;

%        Initialise matrices for all the mesh data
% ************************************************************
rows=xsteps+1;
cols=ysteps+1;

% Fieldsum data which is then processed to give required units
Z=zeros(rows,cols);

% Global coords for mesh
XG=zeros(rows,cols);
YG=zeros(rows,cols);
ZG=zeros(rows,cols);

% Local coords for mesh
XL=zeros(rows,cols);
YL=zeros(rows,cols);
ZL=zeros(rows,cols);

% *************************************************************

% Progress Bar
fprintf('\nCalculating Wave Slice Data : xrng=%3.4f xstep=%3.4f   yrng=%3.4f ystep=%3.4f (m)\n',xrng,xstep,yrng,ystep);

BarLen=40;                 % Progress bar length (space characters)
BarStep=(xrng)/(BarLen);   % Bar step length as a proportion of xrng
BarProg=-xrng/2;
fprintf('|');
for n=1:1:(BarLen)
 fprintf(' ');
end
fprintf('|\n..');


zl=0;
xi=0;
for xl=-xrng/2:xstep:xrng/2
 xi=xi+1;
 yi=0;
 
 % Progress bar
 for yl=-yrng/2:ystep:yrng/2
  yi=yi+1;
  while (xl>BarProg) & ((BarProg+BarStep)<=(xrng/2+xstep/2))
  fprintf('.');                               
  BarProg=BarProg+BarStep;
 end 
  
  localxyz=[xl;yl;zl];                          % Array of local x,y,z coords for the field-slice
  [globalxyz]=local2global(localxyz,rotoff);    % Convert to global coods
  
  % Assign variables for each global coordinate
  xg=globalxyz(1,1);
  yg=globalxyz(2,1);
  zg=globalxyz(3,1);
  
  % Create another set of coordinates offset from the first,
  % used to ensure the field value is for the centre of each plotted grid square. 
  localxyzCen=[xl+xstep/2;yl+ystep/2;zl];
  [globalxyzCen]=local2global(localxyzCen,rotoff);
  
  % Assign variables for each global coordinate
  xgCen=globalxyzCen(1,1);
  ygCen=globalxyzCen(2,1);
  zgCen=globalxyzCen(3,1);
  
  % Convert global cartesian coords to r,theta,phi form 
  [r,th,phi]=cart2sph1(xgCen,ygCen,zgCen);
  
  Emultiple=fieldsum(r,th,phi); % Evaluate the field parameters
 
    for param=1:7
      if Emultiple(1,param)==0
       Emultiple(1,param)=1e-9;         % Stops plotting of nulls, log 0 error
      end
   end
   
   % Select the required parameter (pol) for the raw plot data Z(xi,yi).
   
   Z(xi,yi)=Emultiple(1,pol); 
   
   Amp(xi,yi)=Emultiple(1,1);
   Phase(xi,yi)=Emultiple(1,7+pol); % Select appropriate phase component from Emultiple
      
   % Fill XG,YG,ZG coordinate matrices (global coord system)
   XG(xi,yi)=xg;
   YG(xi,yi)=yg;
   ZG(xi,yi)=zg;
   
   % Fill XL,YL,ZL coordinate matrices (local system)
   XL(xi,yi)=xl;
   YL(xi,yi)=yl;
   ZL(xi,yi)=0;
   
   % Add text lables to identify origin,x-axis and y-axis of the field slice plots
   
  % ORIGIN
  if xl==-xrng/2 & yl==-yrng/2
     figure(1);
     hold on;
     text(xg,yg,zg,'os','fontsize',8,'fontweight','bold'); % Text on 3D geom plot
  end
  
  % X-AXIS
  if xl==+xrng/2 & yl==-yrng/2
     figure(1);
     hold on;
     text(xg,yg,zg,'xs','fontsize',8,'fontweight','bold');
  end
  
  % Y-AXIS
  if xl==-xrng/2 & yl==+yrng/2
     figure(1);
     hold on;
     text(xg,yg,zg,'ys','fontsize',8,'fontweight','bold');
  end

  
 end
end

MaxData=max(max(Z));                    % Max data values
MinData=min(min(Z));                    % Min data values


% Normalisation for parameters measured in dB   
 
DatadB=20*log10(abs(Z)+1e-9);               % Convert data to power (dB)
norm1=max(max(DatadB));                     % Max value in (dB)
DatadBn=DatadB-norm1+dBrange_config;        % Normalise data and add dBrange_config
DatadBn1=DatadBn.*ceil(sign(DatadBn)*0.5);  % Truncate -ve pattern values to 0dB
PlotData=DatadBn1-dBrange_config;           % Assign PlotData to required dynamic range given by dBrange_config
if strcmp(normalise,'yes')  
   Tunit=sprintf('Normalised to 0dB');
else   
   PlotData=PlotData+norm1;
   Tunit=sprintf('  Max %3.2f  Min %3.2f dB',20*log10(abs(MaxData)+1e-9),20*log10(abs(MinData)+1e-9));
end   
  
fprintf('\n');

WaveSF=lambda/2;                                          % Scale factor for max pk wave amplitude to be lambda/2 (m) 
WaveAmp=WaveSF*(PlotData+dBrange_config)/dBrange_config;  % Apply the scale factor to the normalised plotdata to get WaveAmp matrix

% Diagnostics
%max(max(PlotData))
%min(min(PlotData))

%max(max(WaveAmp))
%min(min(WaveAmp))

% **********************************************
% Add the z component of the wave to the 3D plot
% **********************************************
zl=0;
xi=0;
for xl=-xrng/2:xstep:xrng/2
 xi=xi+1;
 yi=0;
 for yl=-yrng/2:ystep:yrng/2
  yi=yi+1;
  
  zl=WaveAmp(xi,yi)*cos(Phase(xi,yi)*pi/180);   % Set the local z coord to be Amp*cos(Phase)
  localxyz=[xl;yl;zl];                          % Array of local x,y,z coords for the field-slice
  [globalxyz]=local2global(localxyz,rotoff);    % Convert to global coords
  
  % Assign variables for each global coordinate
  xg=globalxyz(1,1);
  yg=globalxyz(2,1);
  zg=globalxyz(3,1);
  
  % Fill XG,YG,ZG coordinate matrices (global coord system)
  XG(xi,yi)=xg;
  YG(xi,yi)=yg;
  ZG(xi,yi)=zg;
   
  % Fill XL,YL,ZL coordinate matrices (local system)
  XL(xi,yi)=xl;
  YL(xi,yi)=yl;
  ZL(xi,yi)=zl;
 end  
end

PlotData=ZL;

% Add the wave slice to the 3D geometry plot
figure(1);
hold on;
caxis([-lambda/2,lambda/2]);
surf(XG,YG,ZG,PlotData);  % Plot data in global coordinates, adding to 3D geometry if plotted
colormap('jet');
