function plot_pattern3d(deltheta,delphi,polarisation,normalise)
% Plot 3D pattern 
% Default figure (10)
%
% Usage: plot_pattern3d(deltheta,delphi,polarisation,normalise)
%
% deltheta.....Step value of theta (Deg)  Such that 180/deltheta is an integer
% delphi.......Step value for phi (Deg)   Such that 360/delphi is an integer
% polarisation.Polarisation (string)
% normalise....Normalisation (string)
% 
% Options for polarisation are :
%  
%               'tot'   - Total E-field
%               'vp'    - Vertical polarisation
%               'hp'    - Horizontal polarisation
%               'lhcp'  - Left Hand circular polarisation
%               'rhcp'  - Right Hand circular polarisation
%               'ar'    - Axial Ratio
%               'tau'   - Tilt of polarisation ellipse
%               'phase' - Phase of total E-field
%   
% Options for normalise are : 
%
%               'yes'  - Normalise pattern suface to its maximum value
%               'no'   - Directivity (dBi), no normalisation
%                        Note : calc_directivity must be run first !
%
% e.g. plot_pattern3D(10,15,'tot','no')
%
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    

global direct_config;
global normd_config;
global dBrange_config;
global range_config;
global freq_config;
global arrayeff_config;

dBrange=dBrange_config;   % dB range for plots

switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 case 'lhcp',pol=4;
 case 'rhcp',pol=5;
 case 'ar',pol=1;normalise='yes';
 case 'tau',pol=1;normalise='yes';
 case 'phase',pol=1;normalise='yes';   
 otherwise, fprintf('\n\nUnknown polarisation, options are : "tot","vp","hp","lhcp","rhcp","ar","tau" or "phase"\n');...
            fprintf('Polarisation set to "tot"\n');pol=1;polarisation='tot'; 
end

switch normalise
  case 'yes',% OK
  case 'no', % OK
  otherwise,fprintf('\n\nUnknown normalisation, options are : "yes" or "no"\n');...
            fprintf('Normalisation set to "yes"\n');normalise='yes';
end


if direct_config==0 & strcmp(normalise,'no')
 fprintf('\nWarning, directivity = 0 dBi has calc_directivity been run?\n');
 fprintf('Plot may not be scaled correctly.\n');
end


dth=deltheta*pi/180;          % Delta theta step
dph=delphi*pi/180;            % Delta phi step

Nps=floor(2*pi/dph)+1;        % Number of phi steps         
Nts=floor(pi/dth)+1;          % Number of theta steps


% Initialise arrays for surface x,y,z data and colour data Rc as radius. 
% Rc = sqrt(x^2+y^2+z^2)
x=zeros(Nts,Nps);              % Cartesian x }
y=zeros(Nts,Nps);              % Cartesian y }- coordinates for MATLAB surface plotting 
z=zeros(Nts,Nps);              % Cartesian z }
pat=zeros(Nts,Nps);            % Pattern (patch corners) i.e. the squares of the mesh
patc=zeros(Nts,Nps);           % Pattern (patch centres) i.e. the values at the centres of the mesh squares
Rc=zeros(Nts,Nps);             % Pattern as a radius from origin (Plot Data for MATLAB surface command)
AR=zeros(Nts,Nps);             % Axial Ratio

% Storage for the corresponding theta and phi values
thval=zeros(Nts,Nps);          % Theta (patch corners)
phival=zeros(Nts,Nps);         % Phi (patch corners)
thcval=zeros(Nts,Nps);         % Theta (patch centres)
phicval=zeros(Nts,Nps);        % Phi (patch centres)


fprintf('\nCalculating 3D Pattern Data : d(Th)=%3.2f   d(Phi)=%3.2f\n',deltheta,delphi);

BarLen=40;               % Progress bar length (space characters)
BarStep=(pi)/(BarLen);   % Bar step length as a proportion of theta(max)=pi
BarProg=0;
fprintf('|');
for n=1:1:(BarLen)
 fprintf(' ');
end
fprintf('|\n..');

Psum=0;
Pmax=0;
Thmax=0;
Phmax=0;
m=0;                                          
for theta=0:dth:(pi)                           % Theta loop 
 m=m+1;
 while (theta>BarProg) & ((BarProg+BarStep)<=pi)
  fprintf('.');                                % Progress bar
  BarProg=BarProg+BarStep;
 end 
 n=0;
 for phi=(-pi):dph:(pi)                        % Phi loop        
  n=n+1;

  if theta==pi              % thetac is the value of theta for the
   thetac=theta;            % the centre of the surface patch and
  else                      % is used for the colour scale
   thetac=theta+(dth/2);
  end

  if phi==pi                % phic is the value of phi for the centre
   phic=phi;                % of the surface patch and is used to for
  else                      % the colour scale
   phic=phi+(dph/2);
  end

  Ecorner=fieldsum(range_config,theta,phi);       % E(theta,Phi) surface patch corners
  Ecentre=fieldsum(range_config,thetac,phic);     % E(theta,Phi) surface patch centres

  Ethph=Ecorner(1,pol);    % E(theta,Phi) polarisation component selection for surface patch corners
  Ethphc=Ecentre(1,pol);   % E(theta,Phi) polarisation component selection for surface patch centres
  
  AxialRatio=Ecentre(1,6); % Axial ratio value at (thetac,phic)
  Tau=Ecentre(1,7);        % Tau value at (thetac,phic)
  Phase=Ecentre(1,8);      % Phase value at (thetac,phic)
  
  pat(m,n)=Ethph;
  thval(m,n)=theta;
  phival(m,n)=phi;

  patc(m,n)=Ethphc;
  thcval(m,n)=thetac;
  phicval(m,n)=phic;
  
  if strcmp(polarisation,'ar')
     ArTauPhase(m,n)=AxialRatio;
  end
  if strcmp(polarisation,'tau')
     ArTauPhase(m,n)=Tau;
  end
  if strcmp(polarisation,'phase')
     ArTauPhase(m,n)=Phase;
  end
    
  
 end
end

patdB=20*log10(abs(pat)+1e-15);             % Convert pattern (patch corner) data to power (dB)
patcdB=20*log10(abs(patc)+1e-15);           % Convert pattern (patch centre) data to power (dB)

if strcmp(normalise,'yes')                 % If 'normalise'=yes then set normalisation factor 
 norm1=max(max(patdB));                    % to max pattern values.
 normc1=max(max(patcdB));
end

if strcmp(normalise,'no')                  % If 'normalise'=no then set normalisation factor 
 norm1=normd_config-direct_config;         % to peak directivity (dBi)
 normc1=normd_config-direct_config;
end

patdBn=patdB-norm1+dBrange_config;         % Normalise pattern (patch-corners)
patcdBn=patcdB-normc1+dBrange_config;      % Normalise pattern (patch centres)


patdBn1=patdBn.*ceil(sign(patdBn)*0.5);    % Truncate -ve pattern values to 0dB
patcdBn1=patcdBn.*ceil(sign(patcdBn)*0.5); % Truncate -ve pattern values to 0dB

x=patdBn1.*cos(phival).*sin(thval);        % Convert pattern (patch corner) data to (x,y,z) form
y=patdBn1.*sin(phival).*sin(thval);
z=patdBn1.*cos(thval);

xc=patcdBn1.*cos(phicval).*sin(thcval);    % Convert pattern (patch centre) data to (x,y,z) form
yc=patcdBn1.*sin(phicval).*sin(thcval);
zc=patcdBn1.*cos(thcval);

Rc=(xc.^2+yc.^2+zc.^2).^0.5;               % Pattern (patch centre) data in radius dB form
MaxVal=max(max(Rc));



if strcmp(normalise,'yes')
  if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase')  % Plot data for ar,tau or phase options
  PlotData=ArTauPhase;
   Tmax=' ';
   Tdirec=' ';
  else
   PlotData=Rc;                            % Plot data for gain plot
   Tmax=' ';
   Tdirec='(Normalised to 0dB)';
 end
else
 PlotData=Rc;                              % Plot data for gain plot
 MaxPlotValue=max(max(PlotData))-dBrange_config;
  if arrayeff_config<100
     Tmax=sprintf(' (Max Plot Value = %3.2f dB)',MaxPlotValue);
     Tdirec=sprintf('(Peak Gain = %3.2f dB)',direct_config);
   else
     Tmax=sprintf(' (Max Plot Value = %3.2f dBi)',MaxPlotValue);
     Tdirec=sprintf('(Peak Directivity = %3.2f dBi)',direct_config); 
   end 
end


figure(10);
clf;
chartname=sprintf('3D %s Plot',upper(polarisation));
set(10,'name',chartname);
hold on;
surface(x,y,z,'cdata',PlotData); 
view([60,20]);
colormap('jet');

xlabel('Global X-axis');
ylabel('Global Y-axis');
zlabel('Global Z-axis');
Tfreq=sprintf('\nFreq %g MHz',freq_config/1e6);
T1=['3D ',upper(polarisation),' Pattern Plot ',Tdirec,Tmax,Tfreq];
title(T1);
axis equal;
axis off;
rotate3d;
set(gcf,'color',[0.9,0.9,0.9]);
colorbar;


if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase')  % Plot scaling for ar,tau and phase options
 h=get(colorbar,'yticklabel');
 set(colorbar,'yticklabel',str2num(h));
else
 h=get(colorbar,'yticklabel');
 set(colorbar,'yticklabel',str2num(h)-dBrange_config);
end


hold on;

% Add global axis lines to plot

% Scale axis lengths according to 
% dimensions of pattern surface
axlenx=max(max(x))*1.2; 
axleny=max(max(y))*1.2;
axlenz=max(max(z))*1.2;

% X-axis
elaxis(1:3,1)=[ 0   ; 0   ;0  ].*axlenx;
elaxis(1:3,2)=[ 1   ; 0   ;0  ].*axlenx;

% Y-axis
elaxis(1:3,3)=[ 0   ; 0   ;0  ].*axleny;
elaxis(1:3,4)=[ 0   ; 1   ;0  ].*axleny;
% Z-axis
elaxis(1:3,5)=[ 0   ; 0   ;0  ].*axlenz;
elaxis(1:3,6)=[ 0   ; 0   ;1  ].*axlenz;


 % Plot global X-axis
 plot3(elaxis(1,1:2),elaxis(2,1:2),elaxis(3,1:2),'k-','linewidth',2);
 text(elaxis(1,2),elaxis(2,2),elaxis(3,2),'gx','fontsize',8,'fontweight','bold');
 
 % Plot global Y-axis
 plot3(elaxis(1,3:4),elaxis(2,3:4),elaxis(3,3:4),'k-','linewidth',2);
 text(elaxis(1,4),elaxis(2,4),elaxis(3,4),'gy','fontsize',8,'fontweight','bold');

 % Plot global Z-axis
 plot3(elaxis(1,5:6),elaxis(2,5:6),elaxis(3,5:6),'k-','linewidth',2);
 text(elaxis(1,6),elaxis(2,6),elaxis(3,6),'gz','fontsize',8,'fontweight','bold');

fprintf('\n');