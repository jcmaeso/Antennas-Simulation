function plot_geom2d(gaxisflag,anotflag)
% Draw local axis sets for elements and show array geometry in 2D.
% Default figure(11)
%
% Usage: plot_geom2d(gaxisflag,anotflag)
%
% gaxisflag..Flag=1 to plot global axis set, labeled gx and gy 
%            Flag=0 no axis set
%
% anotflag...Flag=1 specifies that element details are added to plot
%            Flag=0 no details
%
% Details if requested are :
% 
% Element number    - As stored in array_config
% Element amplitude - dB power (20*log10(Volts))
% Element phase     - Degrees
%
% e.g. plot_geom2d(0,0) % No axis, Geometry only
%      plot_geom2d(1,1) % Global axis and element details

global array_config;    % Array of element data : position, excitation, and type
global freq_config;     % Analysis frequency (Hz)
global velocity_config; % Wave propagation velocity (m/s)
global range_config;    % Radius at which to sum element field contributions (m)

global patchr_config;   % Rectangular patch element parameters
global patchc_config;   % Circular patch element parameters
global dipole_config;   % Dipole parameters
global dipoleg_config;  % Dipole over ground parameters
global helix_config;    % Helix parameters


fprintf('\nPlotting 2D geometry\n');
[Trow,Tcol,N]=size(array_config); % Number of elements in array N
fsum=0;                           % Field total init                
lambda=velocity_config/freq_config;
axlen=lambda./5;

% X-axis
elaxis(1:3,1)=[ 0   ; 0   ;0  ].*axlen;
elaxis(1:3,2)=[ 1   ; 0   ;0  ].*axlen;
elaxis(1:3,3)=[ 0.8 ; 0.2 ;0  ].*axlen; % Arrow head +y side
elaxis(1:3,4)=[ 1   ; 0   ;0  ].*axlen; % Back to axis endpoint
elaxis(1:3,5)=[ 0.8 ;-0.2 ;0  ].*axlen; % Arrow head -y side

% Y-axis
elaxis(1:3,6)=[ 0   ; 0   ;0  ].*axlen;
elaxis(1:3,7)=[ 0   ; 1   ;0  ].*axlen;

figure(11);
clf;
hold on;
chartname=sprintf('2D Geom');
set(11,'name',chartname);


% Ground patch for elements with ground plane
gplane(1:3,1)=[0   ;0   ;-0.05  ].*axlen;
gplane(1:3,2)=[1   ;0   ;-0.05  ].*axlen;
gplane(1:3,3)=[1   ;1   ;-0.05  ].*axlen;
gplane(1:3,4)=[0   ;1   ;-0.05  ].*axlen;

% Get parameters for the (n)th source from the array_config matrix
for n=1:N
 Trot=array_config(1:3,1:3,n);
 Toff=array_config(1:3,4,n);  
 Eamp=array_config(1,5,n);
 Epha=array_config(2,5,n);
 Elt=array_config(3,5,n);
 gpflag=0;

 [element,gpflag]=geocode(Elt);  % Get the element geometry coordinates returned to (element)
 				 % and the draw-ground-plane flag, returned to (gpflag)

 % Plot a small xy axis set for each element showing it's
 % orientation in the global array coordinate system

 % X-axis
 elaxisp=local2global(elaxis,[Trot,Toff]);
 plot(elaxisp(1,1:5),elaxisp(2,1:5),'r-');
 %text(elaxisp(1,2),elaxisp(2,2),'x');
 
 % Y-axis
 plot(elaxisp(1,6:7),elaxisp(2,6:7),'g-');
 %text(elaxisp(1,7),elaxisp(2,7),'y');


 if gpflag==1
  gplanep=local2global(gplane,[Trot,Toff]);
  patch(gplanep(1,1:4),gplanep(2,1:4),[0.9,0.9,0.9]);
 end

 % If the element is anything other than isotropic draw it.
 if Elt>0
  elementp=local2global(element,[Trot,Toff]);                           % Calculate plotting coords
  plot(elementp(1,:),elementp(2,:),'k-','LineWidth',2); % Draw the element  
 end
 
 % Annotate element number amplitude and phase if required 
 if anotflag==1
  T1=sprintf('%i\n',n);
  T2=sprintf('%3.2f dB\n',20*log10(Eamp));
  T3=sprintf('%3.2f Deg',Epha*180/pi);
  text(elaxisp(1,2),elaxisp(2,2),[T1,T2,T3],'fontsize',8);
 end

end

% define limits for 2D plotting using global array coords
border=lambda;

xlimsp=max(array_config(1,4,:))+border;
ylimsp=max(array_config(2,4,:))+border;

xlimsn=min(array_config(1,4,:))-border;
ylimsn=min(array_config(2,4,:))-border;


side_len=max([(xlimsp-xlimsn),(ylimsp-ylimsn)]); % Side length for 2D-plotting cube

acenx=(xlimsp+xlimsn)/2; % X coord of structure centre
aceny=(ylimsp+ylimsn)/2; % Y coord of structure centre

% Plot limits
xplimp=acenx+side_len/2;  % X +ve
xplimn=acenx-side_len/2;  % X -ve

yplimp=aceny+side_len/2;  % Y +ve
yplimn=aceny-side_len/2;  % Y -ve


axis([xplimn xplimp yplimn yplimp]);


% Define global axis lines
gaxlen=side_len/4;   % Axis length for plotting global axis set
                     % Set to fraction of plotting cube side length
% X-axis
gaxis(1:3,1)=[ 0   ; 0   ;0  ].*gaxlen;
gaxis(1:3,2)=[ 1   ; 0   ;0  ].*gaxlen;

% Y-axis
gaxis(1:3,3)=[ 0   ; 0   ;0  ].*gaxlen;
gaxis(1:3,4)=[ 0   ; 1   ;0  ].*gaxlen;


% Plot global axis set if required
if gaxisflag==1
 % Plot global X-axis
 plot3(gaxis(1,1:2),gaxis(2,1:2),gaxis(3,1:2),'k-','linewidth',1);
 text(gaxis(1,2),gaxis(2,2),gaxis(3,2),'gx','fontsize',8,'fontweight','bold');
 
 % Plot global Y-axis
 plot3(gaxis(1,3:4),gaxis(2,3:4),gaxis(3,3:4),'k-','linewidth',1);
 text(gaxis(1,4),gaxis(2,4),gaxis(3,4),'gy','fontsize',8,'fontweight','bold');
end 

axis square
xlabel('Global X-axis');
ylabel('Global Y-axis');
title('2D Array Geometry Plot');

zoom on;
hold off;