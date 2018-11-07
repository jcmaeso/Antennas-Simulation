function [Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,normalise,units,fignum1,fignum2)
% Plot E-field parameters along a line through 3D space.
%          
% Two line-slice plots are generated:
%
%        1) The first plot (fignum1) is the line in global coordinates and is useful for verifying that 
%           the line is where it should be relative to the array. To this end it is best if a 
%           3D geometry plot has already been added to this figure using plot_geom3d.
%
%        2) The second plot (fignum2) is the requested data against distance along the line.
%           If the requested line is invariant in two axes then the data is plotted w.r.t the 
%           remaining one, in global coordinates.
%
% There is a minimum distance from the radiating elements at which the 'nearfield' is evaluated,
% set to lambda/(16*pi) in the field summing function, fieldsum. This is to limit scaling issues 
% for the 1/r E-field dependence. 
%
% Usage : [Xline,Yline]=plot_line_slice(xg1,yg1,zg1,xg2,yg2,zg2,steps,polarisation,normalise,units,fignum1,fignum2)
%
%
% xg1,yg1,zg1....Coordinates of beginning of line in global coordinates, P1 (m)
% xg2,yg2,zg2....Coordinates of end of line in global coordinates, P2 (m)
% steps..........Number of steps along line
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
% fignum1....Figure number for line orientation, plotted in the global coordinate system
% fignum2....Figure number for data plotted against distance along line
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
% [Xline,Yline] Where Xline is the distance along the line and Yline is the requested data.

global array_config;
global arraypwr_config;
global arrayeff_config;
global freq_config;
global velocity_config;
global impedance_config;
global range_config;
global dBrange_config;
global direct_config;


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
    
 otherwise,disp('\n\nUnknown polarisation, options are : "tot","vp","hp","lhcp","rhcp","ar","tau","phase","phavp" or "phahp"');...
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
  

  
% Initialise the appropriate figure
figure(fignum2);
clf;
hold on;

% *************************************************************

fprintf('\nCalculating Line Slice Data...\n');

linelen=sqrt((xg2-xg1)^2+(yg2-yg1)^2+(zg2-zg1)^2);
dline=linelen/steps;
dx=(xg2-xg1)/steps;
dy=(yg2-yg1)/steps;
dz=(zg2-zg1)/steps;

xg=xg1-dx;
yg=yg1-dy;
zg=zg1-dz;
Pline=0-dline;


for n=1:1:steps+1
  xg=xg+dx; 
  yg=yg+dy; 
  zg=zg+dz; 
  Pline=Pline+dline;
  
  % Convert global cartesian coords to r,theta,phi form 
  [r,th,phi]=cart2sph1(xg,yg,zg);
  
  Emultiple=fieldsum(r,th,phi); % Evaluate the field parameters
  
    for param=1:7
      if Emultiple(1,param)==0
       Emultiple(1,param)=1e-15;         % Stops plotting of nulls, log 0 error
      end
   end
   
   % Select the required parameter (pol) for the raw plot data Z(xg,yg,zg).
   Z(n)=Emultiple(1,pol);         

   % Fill Xline,Yline plotting vectors (local system)
   Xline(n)=Pline;         % Distance along the line (default)
   TxtX='Distance alone line (m)';
   
   if xg1==xg2 & yg1==yg2   % Line invariant in x and y so plot w.r.t z-axis 
      Xline(n)=zg;
      TxtX='Z-axis (m)';
   end
   
   if xg1==xg2 & zg1==zg2   % Line invariant in x and z so plot w.r.t y-axis 
      Xline(n)=yg;  
      TxtX='Y-axis (m)';
   end
   
   if yg1==yg2 & zg1==zg2   % Line invariant in y and z so plot w.r.t x-axis 
      Xline(n)=xg;
      TxtX='X-axis (m)';
   end
   
   % Add text labels to identify origin,x-axis and y-axis of the line slice plots
   
  % Beginning Point on Line
  if n==1
     figure(fignum1);
     hold on;
     text(xg,yg,zg,'P1','fontsize',8,'fontweight','bold'); % Text on 3D geom plot
  end
  
  % End Point on Line
  if n==steps
     figure(fignum1);
     hold on;
     text(xg,yg,zg,'P2','fontsize',8,'fontweight','bold');
  end

end

MaxData=max(Z);                    % Max data values
MinData=min(Z);                    % Min data values


% IF parameters are linear or measured in degrees (ar,tau or phase) => Process data accordingly 
if ATPflag==1 
  if strcmp(polarisation,'ar') 
     PlotData=Z;
     Ttxt=sprintf('  Max %3.2f  Min %3.2f Lin Ratio',MaxData,MinData);
     Tunit='AR';
  else 
    Tunit='Deg'; 
    if strcmp(normalise,'yes')            
       PlotData=mod((Z-MaxData),-360);          % Normalise data measured in degrees and assign to PlotData
       Ttxt=sprintf('Normalised to 0Deg  Min Value %3.2f Deg',(MinData-MaxData));
    else   
       PlotData=Z;                              % Assign PlotData for data in degrees
       Ttxt=sprintf('  Max %3.2f  Min %3.2f Deg',MaxData,MinData);
    end   
  end
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
      otherwise,disp('\n\nUnknown unit, options are : "dblossd","dbloss","dbwm2","wm2","dbvm", or "vm"');...
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
        otherwise,disp('\n\nUnknown unit, no normalisation applied!\n'); 
      end
    end

     MaxPlotData=max(max(PlotData));
     MinPlotData=min(min(PlotData));
     
     if strcmp(normalise,'yes')
      Ttxt=sprintf('Normalised to %g %s  Min %g %s',MaxPlotData,Tunit,MinPlotData,Tunit);
     else
      Ttxt=sprintf('   Max %g %s  Min %g %s',MaxPlotData,Tunit,MinPlotData,Tunit);  
     end
   
end % END parameters

  % Label beginning point on line
  figure(fignum2);
  hold on;
  text(Xline(1),PlotData(1),'P1','fontsize',8,'fontweight','bold');  % Text on dedicated plot
 
  
  % Label end point on line
  figure(fignum2);
  hold on;
  text(Xline(n),PlotData(n),'P2','fontsize',8,'fontweight','bold');
  

  % Define X-plotting axis label according to which, if any, of xg,yg,zg are invarient
  TxtX='Distance along line (m)';
  
   TxtInvar=' ';
   
   if xg1==xg2 & yg1==yg2   % Line invariant in x and y so plot w.r.t z-axis 
      TxtX='Global Z-axis (m)';
      TxtInvar=sprintf('  Xg=%g Yg=%g (m)',xg1,yg1);
      fprintf('Xg & Yg invariant, plotting w.r.t global Z-axis\n');
   end
   
   if xg1==xg2 & zg1==zg2   % Line invariant in x and z so plot w.r.t y-axis 
      TxtX='Global Y-axis (m)';
      TxtInvar=sprintf('  Xg=%g Zg=%g (m)',xg1,zg1);
      fprintf('Xg & Zg invariant, plotting w.r.t global Y-axis\n');
   end
   
   if yg1==yg2 & zg1==zg2   % Line invariant in y and z so plot w.r.t x-axis 
      TxtX='Global X-axis (m)';
      TxtInvar=sprintf('  Yg=%g Zg=%g (m)',yg1,zg1);
      fprintf('Yg & Zg invariant, plotting w.r.t global X-axis\n');
   end
  
  
fprintf('\n');

% Plot requested parameter as a function of distance along the line
figure(fignum2);
Yline=PlotData;
chartname=sprintf('%s Line',upper(polarisation));
set(fignum2,'name',chartname);
plot(Xline,Yline,'b','linewidth',2);
Tfreq=sprintf('\nFreq %g MHz',freq_config/1e6);
T1=[upper(polarisation),' Line ',Ttxt,Tfreq,TxtInvar];
title(T1);
xlabel(TxtX);
ylabel(Tunit);
grid on;
hold on;

% Add the line to the 3D geometry plot
figure(fignum1);
hold on;
plot3([xg1,xg2],[yg1,yg2],[zg1,zg2],'k:','linewidth',2);  % Plot line in global coordinates, adding to 3D geometry if plotted



