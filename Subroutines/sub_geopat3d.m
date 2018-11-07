function sub_geopat3D(gpratio)
% Add array geometry to 3D pattern plot created with plot_geopat3D.
%
%
% Usage: sub_geopat3D(gpratio)
%
% gpratio......Geometry to pattern ratio  (Size of geometry relative to pattern)
%
% Notes for gpratio are :
%
%                The larger the value for gpratio the larger the geometry
%                plot relative to the pattern plot will be. 
%                Values are typically (1 to 5) 
%                For a small array (2 x 2) choose a large value (4)
%                For a large array (8 x 8) choose a small value (2)
%
% e.g. sub_geopat3D(4)

global array_config;    % Array of element data : position, excitation, and type
global freq_config;     % Analysis frequency (Hz)
global velocity_config; % Wave propagation velocity (m/s)
global range_config;    % Radius at which to sum element field contributions (m)

global direct_config;
global normd_config;
global dBrange_config;


gaxisflag=0;
anotflag=0;


fprintf('\nAdding 3D geometry\n');
[Trow,Tcol,N]=size(array_config); % Number of elements in array N
fsum=0;                           % Field total init                
lambda=velocity_config/freq_config;
axlen=lambda./5;                  % Axis length for plotting local/global axis sets


% **********************************************************************************

% define limits for 3D plotting using global array coords
border=lambda;

xlimsp=max(array_config(1,4,:))+border;
ylimsp=max(array_config(2,4,:))+border;
zlimsp=max(array_config(3,4,:))+border;

xlimsn=min(array_config(1,4,:))-border;
ylimsn=min(array_config(2,4,:))-border;
zlimsn=min(array_config(3,4,:))-border;

side_len=max([(xlimsp-xlimsn),(ylimsp-ylimsn),(zlimsp-zlimsn)]); % Side length for 3D-plotting cube

acenx=(xlimsp+xlimsn)/2; % X coord of structure centre
aceny=(ylimsp+ylimsn)/2; % Y coord of structure centre
acenz=(zlimsp+zlimsn)/2; % Z coord of structure centre

% Plot limit
xplimp=acenx+side_len/2;  % X +ve
xplimn=acenx-side_len/2;  % X -ve

yplimp=aceny+side_len/2;  % Y +ve
yplimn=aceny-side_len/2;  % Y -ve

zplimp=acenz+side_len/2;  % Z +ve
zplimn=acenz-side_len/2;  % Z +ve

% Use the supplied 'gpratio' and the plot limits to calculate a suitable scaling factor
    
SFgeom1=max([(xplimp-xplimn),(yplimp-yplimn),(zplimp-zplimn)]);
SFgeom2=(dBrange_config+direct_config)*gpratio/SFgeom1;  % SFgeom2 is used to scale 
                                                         % the geom plot, below

% ************************************************************************************


hold on;


for n=1:N
 Trot=array_config(1:3,1:3,n);
 Toff=array_config(1:3,4,n);  
 Eamp=array_config(1,5,n);
 Epha=array_config(2,5,n);
 Elt=array_config(3,5,n);
 gpflag=0;
  
 
 [element,gpflag]=geocode(Elt);  % Get the element geometry coordinates returned to (element)
 				 % and the draw ground plane flag, returned to (gpflag) 


  
  elementp=local2global(element,[Trot,Toff]);    % Calculate plotting coords
  xcrds=elementp(1,:).*SFgeom2;                  % X-coords of element, scaled
  ycrds=elementp(2,:).*SFgeom2;                  % Y-coords of element, scaled
  zcrds=elementp(3,:).*SFgeom2;                  % Z-coords of element, scaled
  if Elt==0
    plot3(xcrds,ycrds,zcrds,'k+','LineWidth',1);  % Draw the 'iso' element  
  else
    plot3(xcrds,ycrds,zcrds,'k-','LineWidth',2);  % Draw the non-'iso' elements  
  end
 
  

end
rotate3d on;

% Scale axis so that geometry and pattern are visible
%AX=axis;
%AXSF=((dBrange_config+direct_config)*gpratio)/(max(axis)*2);
%BorderSF=1.1;
%axis(AX*AXSF*BorderSF);

axis tight;
hold off;