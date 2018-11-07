function [XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                xoff,yoff,zoff,polarisation,normalise,units)
% Plot E-field parameters as a slice through 3D space.
%          
% Two field-slice plots are generated in default figures :
%
%        1) The first plot (figure 1) is in global coordinates and is useful for verifying that 
%           the field-slice is where it should be relative to the array. To this end it is
%           best if a 3D geometry plot has already been added to figure1 using plot_geom3d.
%
%        2) The second plot (figure 15) is in local coordinates unless the required slice is 
%           parallel to one of the primary axis planes, in which case global coordinates are 
%           used. This separate, dedicated plot, is more convenient for reading off specific 
%           values.
%
%
% There is a minimum distance from the radiating elements at which the 'nearfield' is evaluated,
% set to lambda/(4*pi) in the field summing function, fieldsum. This is to limit scaling issues 
% for the 1/r E-field dependence. 
%
% Usage: [XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
%               xoff,yoff,zoff,polarisation,normalise,units)
%
% xrng......Slice dimensions in x-direction before rotations and offsets are applied (m)
% xsteps....Number of steps in x-direction (m)
% yrng......Slice dimensions in y-direction before rotations and offsets are applied (m)
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
%               'lhcp'  - Left Hand circular polarisation
%               'rhcp'  - Right Hand circular polarisation
%               'ar'    - Axial Ratio (Linear)
%               'tau'   - Tilt of polariasation ellipse (Degrees)
%               'phase' - Phase of total E-field (Degrees)
%               'phavp' - Phase of vertical component of E-field (Degrees)
%               'phahp' - Phase of horizontal component of E-field (Degrees)
%
%
% Options for normalise are : 
%
%               'yes'  - Normalise pattern surface to its maximum value (relative path loss)
%               'no'   - Absolute field values (path loss + peak directivity) 
%                        calc_directivity and norm_array should be run before using this option.
%
% Options for units are :
% 
%              'dblossd' - Path loss including directivity of the array (dB power)     
%              'dbloss'  - Path loss only (dB power)
%              'dbwm2'   - Power density (dBW/m^2)
%              'wm2'     - Power density (W/m^2)
%              'dbvm'    - RMS E-field (dBV/m)
%              'vm'      - RMS E-field (V/m)
%
% Note :- For polarisation options 'tau','phase','phasevp' and 'phasehp' the units will be degrees.
%         For option 'ar' the scale is linear 0 to 1.
%
% IMPORTANT ! If you want to use any of the options apart from dbloss, you will need to run calc_directivity 
%             first. If you want to use any of the absolute unit options dbwm2,wm2,dbvm or vm, you will also
%             need to set the array input power using the arraypwr_config variable, see init.m. The default 
%             setting is 100W, this can of course be reset as required. Finally you will also need to run 
%             norm_array to make sure the input power is distributed correctly across the elements. 
%             See norm_array help for details.        
%
% Returned Data :
%
% [XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData] are the full mesh coordinate sets of the centres
% of the patch elements in the surface plots. The coordinates XGC,YGC,ZGC and XLC,YLC,ZLC
% are in the global and local coordinate systems respectively (see below). PlotData contains the 
% E-field parameter according to the polarisation parameter supplied. It should be noted that ZLC
% will be all zeros in the local system, but is provided for completeness. Also the x,y coordinates
% are offset by 1/2 step from the supplied range for the surface mesh. This is so the patch colours
% represent the centres of the patches. It means that the x,y data is in the ranges :
%
%                         X-data    -xrng/2+xstep/2 : xstep : +xrng/2-xstep/2
%                         Y-data    -yrng/2+ystep/2 : ystep : +yrng/2-ystep/2
%
% Which also means that PlotData returned as W/m^2 can be numerically integrated to get the total power
% intercepted by the supplied aperture area : xrng x yrng (m^2) 
%
% Notes on using the plot_field_slice function :-
%
%  The field slice is defined as a grid in a 'local' coordinate system according
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
%  The plot_field_slice function can be called multiple times and each call will
%  add the slice to the 3D geometry plot, if present. However, each figure only
%  supports one colorbar scale. This means that a colour scale applied to the 3D
%  geometry plot will only be meaningful if all slices are of the same parameter 
%  e.g. 'phase', and no normalisation is applied.
%
%  Also bear in mind that the individual plot figures will have their own 
%  unique colorbar, so take care when making comparisons, look carefully at the 
%  actual values at the side of the colorbar.
%
%  See : expointsrce1.m, exdipoles.m, exdoubleslit.m, exrtpslice, extotpower.m and
%        exoam1/2/3.m examples.
%

global array_config;
global arraypwr_config;
global arrayeff_config;
global freq_config;
global velocity_config;
global impedance_config;
global range_config;
global dBrange_config;
global direct_config;

fignum1=1;   % Set default figure for plotting in global coordinates
fignum2=15;  % Set default figure for dedicated plot

% Convert the parameter selection into a single number
switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 case 'lhcp',pol=4;
 case 'rhcp',pol=5;
 case 'ar',pol=6;
 case 'tau',pol=7;
 case 'phase',pol=8; 
 case 'phavp',pol=9;
 case 'phahp',pol=10;   
    
 otherwise,fprintf('\n\nUnknown polarisation, options are : "tot","vp","hp","lhcp","rhcp","ar","tau","phase","phavp" or "phahp"\n');...
     fprintf('Polarisation set to "tot"\n');pol=1;param='tot'; 
end



% Set flag for parameters (ar,tau,phase) that return values in degress or are unitless
if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase') |...
   strcmp(polarisation,'phavp') | strcmp(polarisation,'phahp' );  % Plot data for ar,tau or phase options
  ATPflag=1;
else
  ATPflag=0;
end 

if direct_config==0 & strcmp(normalise,'no')  
  fprintf('\nWarning, directivity = 0 dBi has calc_directivity been run?\n');
  fprintf('Plot may not be scaled correctly.\n');
end

if sum(array_config(1,5,:))>1.001 & strcmp(normalise,'no')
  fprintf('\nWarning, array excitations not normalised, has norm_array been run?\n');
  fprintf('Plot may not be scaled correctly.\n');
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

  
% Initialise the appropriate figure
figure(fignum2);
clf;
hold on;

% Calculates step size
xstep=xrng/xsteps;
ystep=yrng/ysteps;

%       Initialise matrices for all the mesh data
% ************************************************************
rows=xsteps+1;
cols=ysteps+1;

% Fieldsum data which is then processed to give required units
Z=zeros(rows,cols);

% Global coords, mesh and surface_colour_patch centres
XG=zeros(rows,cols);XGC=zeros(rows,cols);
YG=zeros(rows,cols);YGC=zeros(rows,cols);
ZG=zeros(rows,cols);ZGC=zeros(rows,cols);

% Local coords, mesh and surface_colour_patch centres
XL=zeros(rows,cols);XLC=zeros(rows,cols);
YL=zeros(rows,cols);YLC=zeros(rows,cols);
ZL=zeros(rows,cols);ZLC=zeros(rows,cols);

% *************************************************************

% Progress Bar
fprintf('\nCalculating Field Slice Data : xrng=%3.4f xstep=%3.4f   yrng=%3.4f ystep=%3.4f (m)\n',xrng,xstep,yrng,ystep);

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
BarCount=1;
for xl=-xrng/2:xstep:xrng/2
 xi=xi+1;
 yi=0;
 
 % Progress bar
 for yl=-yrng/2:ystep:yrng/2
  yi=yi+1;
  while (xl>BarProg) & (BarCount<=BarLen) 
   fprintf('.');BarCount=BarCount+1;                              
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
  xlCen=xl+xstep/2;
  ylCen=yl+ystep/2;
  zlCen=zl;
  localxyzCen=[xlCen;ylCen;zlCen]; % Assemble coords into single vector
  
  
  [globalxyzCen]=local2global(localxyzCen,rotoff); % Convert to global coords
  
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
   
   % Fill XG,YG,ZG coordinate matrices (global coord system)
   XG(xi,yi)=xg; XGC(xi,yi)=xgCen;
   YG(xi,yi)=yg; YGC(xi,yi)=ygCen;
   ZG(xi,yi)=zg; ZGC(xi,yi)=zgCen;
   
   % Fill XL,YL,ZL coordinate matrices (local system)
   XL(xi,yi)=xl; XLC(xi,yi)=xlCen;
   YL(xi,yi)=yl; YLC(xi,yi)=ylCen;
   ZL(xi,yi)=0;  ZLC(xi,yi)=zlCen;
 end
end

[row,col]=size(Z);
row=row-1;
col=col-1;
MaxData=max(max(Z(1:1:row,1:1:col))); % Max data value for annotation
MinData=min(min(Z(1:1:row,1:1:col))); % Min data value for annotation

% IF parameters are linear or measured in degrees (ar,tau or phase) => Process data accordingly 
if ATPflag 
  if strcmp(polarisation,'ar') 
     PlotData=Z;
     Ttxt=sprintf('  Max %3.2f  Min %3.2f Lin Ratio',MaxData,MinData);
  else 
    if strcmp(normalise,'yes')            
       PlotData=mod((Z-MaxData),-360);          % Normalise data measured in degrees and assign to PlotData
       Ttxt=sprintf('Normalised to 0 Deg  Min Value %3.2f Deg',(MinData-MaxData));
    else   
       PlotData=Z;                              % Assign PlotData for data in degrees
       Ttxt=sprintf('  Max %3.2f  Min %3.2f Deg',MaxData,MinData);
    end   
  end
 
MaxPlotData=max(max(PlotData(1:1:row,1:1:col)));
MinPlotData=min(min(PlotData(1:1:row,1:1:col)));  
 
% ELSE parameters measured in dB => Process data accordingly
else 
     lambda=velocity_config/freq_config;         % Wavelength (m)
     DatadB=20*log10(abs(Z)+1e-15);              % Convert data to power (dB power)
     norm1=max(max(DatadB));                     % Max value in (dB power)
     DatadBn=DatadB-norm1+dBrange_config;        % Normalise data and add dBrange_config
     DatadBn1=DatadBn.*ceil(sign(DatadBn)*0.5);  % Truncate -ve pattern values to 0dB
     DatadB1=DatadBn1-dBrange_config+norm1;      % Data adjusted to required dynamic range given by dBrange_config


     % Some preliminary calculations to establish reference levels
     r=1/(4*pi);                         % Reference radius (m) for power density calculation, (ref fieldsum rloc)
     PdenRef=arraypwr_config/(4*pi*r^2); % Reference power density (W/m^2)
     PdenRefdB=10*log10(PdenRef);        % Reference power density (dBW/m^2)
     DatadB1d=DatadB1+direct_config;     % Path loss including directivity of the array (dB power)
 
     % Convert data into the various units
     dbwm2=PdenRefdB+DatadB1d;                 % Power density (dBW/m^2)
     wm2=10.^((dbwm2)/10);                     % Power density (W/m^2)
     vm=sqrt((wm2)*impedance_config);          % RMS E-field (V/m)
     dbvm=10*log10(vm);                        % RMS E-field (dBv/m)
     
     DatadB=20*log10(abs(Z*lambda)+1e-15);       % Path loss (dB) raw data
     norm1=max(max(DatadB));                     % Max value in (dB power)
     DatadBn=DatadB-norm1+dBrange_config;        % Normalise data and add dBrange_config
     DatadBn1=DatadBn.*ceil(sign(DatadBn)*0.5);  % Truncate -ve pattern values to 0dB
     DatadB1=DatadBn1-dBrange_config+norm1;      % Data adjusted to required dynamic range given by dBrange_config
     
     dbloss=DatadB1;                             % Path loss (dB) 
     dblossd=dbloss+direct_config;               % Path loss + directivity (dB)

     % Assign plot data and string for units as appropriate (un-normalised).
     switch units
      case 'dblossd',PlotData=dblossd;Tunit='dB';
      case 'dbloss',PlotData=dbloss;Tunit='dB';
      case 'dbwm2',PlotData=dbwm2;Tunit='dBW/m2';
      case 'wm2',PlotData=wm2;Tunit='W/m^2';
      case 'dbvm',PlotData=dbvm;Tunit='dBV/m';
      case 'vm',PlotData=vm;Tunit='V/m';
      otherwise,fprintf('\n\nUnknown unit, options are : "dblossd","dbloss","dbwm2","wm2","dbvm", or "vm"\n');...
               fprintf('Units set to "dblossd"\n');PlotData=dblossd;Tunit='dB'; 
     end

     if strcmp(normalise,'yes')
       switch units
        case 'dblossd',PlotData=PlotData-max(max(PlotData));
        case 'dbloss',PlotData=PlotData-max(max(PlotData));
        case 'dbwm2',PlotData=PlotData-max(max(PlotData));
        case 'wm2',PlotData=PlotData/max(max(PlotData));
        case 'dbvm',PlotData=PlotData-max(max(PlotData));
        case 'vm',PlotData=PlotData/max(max(PlotData));
        otherwise,fprintf('\n\nUnknown unit, no normalisation applied!\n'); 
      end
     end
   
    [row,col]=size(PlotData);
    row=row-1;
    col=col-1;
    MaxPlotData=max(max(PlotData(1:1:row,1:1:col)));
    MinPlotData=min(min(PlotData(1:1:row,1:1:col)));
     
   if strcmp(normalise,'yes')
      Ttxt=sprintf('Normalised to %g %s  Min %g %s',MaxPlotData,Tunit,MinPlotData,Tunit);
   else
      Ttxt=sprintf('   Max %g %s  Min %g %s',MaxPlotData,Tunit,MinPlotData,Tunit);  
   end
   
end % END Parameters
  
 fprintf('\n');
 
% Define X-Y plotting axes labels according to which, if any, of XG,YG,ZG are invarient

if (max(max(XG))-min(min(XG)))<1e-9;
   InvarX=1;
else
   InvarX=0;
end

if (max(max(YG))-min(min(YG)))<1e-9;
   InvarY=1;
else
   InvarY=0;
end

if (max(max(ZG))-min(min(ZG)))<1e-9;
   InvarZ=1;
else
   InvarZ=0;
end

 TxtInvar=' ';
 
 if not(InvarX | InvarY | InvarZ)
    Txt1='Field Slice Local X-axis (m)';
    Txt2='Field Slice Local Y-axis (m)';
    Txt3='Field Slice Local Z-axis (m)';
    XP=XL;YP=YL;ZP=ZL;
    AZ=0;EL=90;
 else  
    Txt1='Global X-axis (m)';
    Txt2='Global Y-axis (m)';
    Txt3='Global Z-axis (m)';
    XP=XG;YP=YG;ZP=ZG;
    
    if InvarX   % Slice invariant in X so plot slice using Y & Z axes 
       TxtInvar=sprintf('  Xg=%g (m)',max(max(XG)));
       AZ=90;EL=0;
       fprintf('Xg invariant, plotting using global Y & Z axes\n');
    end
   
    if InvarY   % Slice invariant in Y so plot slice using X & Z axes 
       AZ=0;EL=0;
       TxtInvar=sprintf('  Yg=%g (m)',max(max(YG)));
       fprintf('Yg invariant, plotting using global X & Z axes\n');
    end
   
    if InvarZ   % Slice invariant in Z so plot slice using X & Y axes 
       AZ=0;EL=90;
       TxtInvar=sprintf('  Zg=%g (m)',max(max(ZG)));
       fprintf('Zg invariant, plotting using global X & Y axes\n');
    end
  end
  
figure(fignum1);
hold on;
text(XG(1,1),YG(1,1),ZG(1,1),'os','fontsize',8,'fontweight','bold');     % Text on 3D plot
text(XG(xi,1),YG(xi,1),ZG(xi,1),'xs','fontsize',8,'fontweight','bold');  % Text on 3D plot
text(XG(1,yi),YG(1,yi),ZG(1,yi),'ys','fontsize',8,'fontweight','bold');  % Text on 3D plot
    
figure(fignum2);
hold on;
text(XP(1,1),YP(1,1),ZP(1,1),'os','fontsize',8,'fontweight','bold');     % Text on dedicated plot
text(XP(xi,1),YP(xi,1),ZP(xi,1),'xs','fontsize',8,'fontweight','bold');  % Text on dedicated plot
text(XP(1,yi),YP(1,yi),ZP(1,yi),'ys','fontsize',8,'fontweight','bold');  % Text on dedicated plot

fprintf('\n');

% Trap problem with caxis command in plotting section below
if MaxPlotData<=MinPlotData
   MaxPlotData=MinPlotData+1e-15;
   fprintf('\nAttention, plot range zero, set to 1e-15\n(Might be groundplane side of antenna?)\n');
end   

% Plot field distribution as a colour-map slice in 3D space
figure(fignum2);
warning off;     % Seems to be an issue in Matlab 5.2 regading axis scaling in 3D plots
                 % for small axis dimensions e.g. single slice in z-y plane for single value of x,
                 % plot seems fine though!
chartname=sprintf('%s Slice',upper(polarisation));
set(fignum2,'name',chartname);
surf(XP,YP,ZP,PlotData);     % Plot data using local coordinates
colormap('jet');
rotate3d;
axis equal;
axis tight;
view([AZ,EL]);
Tfreq=sprintf('\nFreq %g MHz',freq_config/1e6);
T1=[upper(polarisation),' Slice ',Ttxt,Tfreq,TxtInvar];
title(T1);
caxis([MinPlotData,MaxPlotData]);
colorbar;
xlabel(Txt1);
ylabel(Txt2);
zlabel(Txt3);
warning on;     % Turn warnings back on
hold on;

% Add the colourmap slice to the 3D geometry plot
figure(fignum1);
hold on;
surf(XG,YG,ZG,PlotData);  % Plot data in global coordinates, adding to 3D geometry if plotted
colormap('jet');
caxis([MinPlotData,MaxPlotData]);
colorbar;

% The x,y coordinates used to calculate the plotdata are offset by 1/2 step from the supplied range.
% This is so the patch colours represent the centres of the patchs. It means that the x,y data is
% in the ranges :
%
%                         X-data    -xrng/2+xstep/2 : xstep : +xrng/2-xstep/2
%                         Y-data    -yrng/2+ystep/2 : ystep : +yrng/2-ystep/2
% 
%
% The data used to generate the mesh has an extra data point to form the outside edge of the mesh.
% These are trimmed off the returned data. See below

[row,col]=size(XGC);
row=row-1;
col=col-1;

% Trim off the end row/column of the returned matrices
XGC=XGC(1:1:row,1:1:col);
YGC=YGC(1:1:row,1:1:col);
ZGC=ZGC(1:1:row,1:1:col);

XLC=XLC(1:1:row,1:1:col);
YLC=YLC(1:1:row,1:1:col);
ZLC=ZLC(1:1:row,1:1:col);

PlotData=PlotData(1:1:row,1:1:col);



