function Emulti=fieldsum(R,th,phi)
% Summation of field contributions at location (R,th,phi) 
% from each element in array_config, at frequency freq_config. 
%
% Usage: Emulti=fieldsum(R,th,phi)
%
% R....Radius of farfield point
% th...Theta (radians)
% phi..Phi (radians)
%
% 
% Returned values :
%
% Emulti..[Etot,Evp,Ehp,Elhcp,Erhcp,AR,Tau,Phase,Phavp,Phahp] where :
%         
% 1        Etot  =  Total E-field
% 2        Evp   =  Vertical E-field component (Z-axis in global coords)
% 3        Ehp   =  Horizontal E-field component (X-Y plane in global coords)
% 4        Elhcp =  Left Hand Circular Polarisation
% 5        Erhcp =  Right Hand Circular Polarisation
% 6        AR    =  Axial ratio (Linear)
% 7        Tau   =  Tilt angle of polarisation ellipse (deg)
% 8        Phase =  Phase of total E-field (deg)
% 9        Phavp =  Phase of vertical component of E-field (deg)
% 10       Phahp =  Phase of horizontal component of E-field (deg)
%
%
% This version of fieldsum includes 1/r path loss factor for psuedo-near field
% calculations. i.e. It accounts for the relative distances (relative path losses)
% to the various array elements, as viewed by the observer. It should be noted 
% that distances where this is significant are likely to be close to the Fraunhofer
% distance of 2D^2/lambda (D is the maximum aperture dimension).
%
% See examples : exdoubleslit.m and exdipoles.m 
%
% 
% As well as calculating the total E-field at a given farfield point.
% Two polarisation scaling factors are calculated :
% HP (Horizontal Polarisation)   0<= HP <=1
% VP (Vertical Polarisation)     0<= VP <=1
%
% To calculate the scaling factors a unit vector along the (n)th element
% X-axis is defined. This represents the E-field orientation in all linearly
% polarised element models. When viewed from the farfield point the 
% Z-component of the unit vector represents the VP component and the
% Y-component of the unit vector represents the HP component.
% 
% These scaling factors are then applied to the total E-field to give
% Vertical and Horizontally polarised patterns.
%
% Note: The Theta reference angle for VP and HP is 90 Deg (Horizon)
%

global array_config;
global freq_config;
global velocity_config;

[Trow,Tcol,N]=size(array_config);    % Number of elements in array N
Etot=0;                              % Total field init                
Evp=0;                               % Vertical field init
Ehp=0;                               % Horizontal field init

lambda=velocity_config/freq_config;  % Wavelength
k=2*pi/lambda;                       % Propagation constant

[xff,yff,zff]=sph2cart1(R,th,phi);   % Far-field point for summation
xyzff=[xff;yff;zff;];

CPflag=0;                            % Flag for circular polarisation
                                     % if set, causes VP=HP -3dB down
                                     % from Etotal
                                     
rlocmin=lambda/(4*pi);               % Minimum radius distance from element at which nearfield is calculated                     
                                              
EvpSum=0;
EhpSum=0;

for n=1:N                          % Sum over N sources
  Amp=array_config(1,5,n);         % Amplitude of (n)th source (lin volts)
  Pha=-array_config(2,5,n);         % Phase of (n)th source (radians)

  Trot=array_config(1:3,1:3,n);    % Element orientataion (rotation matrix)
  Toff=array_config(1:3,4,n);      % Element position (offset matrix)
    
  xyzffloc=inv(Trot)*(xyzff-Toff); % Far-field point in local coords  
  
  xloc=xyzffloc(1,1);              % x-coord
  yloc=xyzffloc(2,1);              % y-coord
  zloc=xyzffloc(3,1);              % z-coord

  [rloc,thloc,philoc]=cart2sph1(xloc,yloc,zloc);  % Convert to (r,theta,phi) coords
  
                                             
  if rloc<=rlocmin              % If within min distance from source field 1/r^2 relation tends to unity
     rloc=rlocmin;              % This avoids scaling and divide by zero problems when r is very small.
  else
     rloc=abs(rloc);
  end    
  
  eltype=array_config(3,5,n);                     % Select appropriate element model
  
  [EleAmp,CPflag]=sumcode(eltype,thloc,philoc);   % Sumcode calls the relevant element model 'eltype'

  % Polarisation unit vector manipulation
  if CPflag==0             % If linear pol
   uo=[0;0;0];             % Unit origin
   ux=[1;0;0];             % Unit x-axis (E-field vector for elements)
   ux=ux.*1e-9;            % Scale unit by 1e-9 so as not to be problematic when
                           % the farfield point is chosen to have a small radius

   uor=Trot*uo+Toff;       % Transform origin point to global coords
   uxr=Trot*ux+Toff;       % Transform unit x-axis (E-field vector)
  
   PZr=rotz(-phi);         % Phi rotation
   PYr=roty(-th-pi/2);     % Theta rotation (add 90 Deg so theta is referenced from horizon)

   Prot=PZr*PYr;           % Construct polarisation rotation matrix
   Poff=xyzff;             % Offsets are just the farfield point location (x,y,z)

   uorf=inv(Prot)*(uor-Poff);      % Origin point as viewed from farfield point
   uxrf=inv(Prot)*(uxr-Poff);      % Unit x-axis (E-field vector) as viewed from farfield point
   
   VPc=(uxrf(3,1)-uorf(3,1))*1e9;  % Vertical (Z-component) of E-field vector as viewed from
                                   % the farfield point, and rescale back to unity

   HPc=(uxrf(2,1)-uorf(2,1))*1e9;  % Horizontal (Y-component) of E-field vector as viewed from
                                   % the farfield point, and rescale back to unity
  else                  % For Circularly polarised elements CPflag=1 (RHCP), CPflag=-1 (LHCP)
   VPc=0.7079;          % For circular polarisation VP=HP -3dB down from Etot (lin volts)
   HPc=0.7079;          % For circular polarisation VP=HP -3dB down from Etot (lin volts)
  end 
 
  VectSum=sqrt(VPc.^2+HPc.^2); % Vector sum of Vertical and Horizontal components 
  if VectSum>0
   VP=VPc./VectSum;            % Vertical as a proportion on the total
   HP=HPc./VectSum;            % Horizontal as a proportion of the total
  else
   VP=1e-9;                     % If there are no vector component Vert or Horiz 
   HP=1e-9;                     % e.g. end-on on a dipole, set to 1e-9 to avoid
  end                           % a divide by zero warning.

 if CPflag==0                  % If linearly polarised
   AmpVP=abs(VP);                      % Amplitude for the Vertical vector component
   PhaVP=(pi/2)*sign(VP)+(pi/2);       % Phase for the Vertical vector component

   AmpHP=abs(HP);                      % Amplitude for the Horizontal vector component
   PhaHP=(pi/2)*sign(HP)+(pi/2);       % Phase for the Horizontal vector component
  else                        % If circularly polarised
   AmpVP=abs(VP);
   PhaVP=(pi/4)*CPflag*(-1);  % No geometric phase change used, phase is defined by CPflag
   AmpHP=abs(HP);  
   PhaHP=(pi/4)*CPflag*(+1);  % No geometric phase change used, phase is defined by CPflag
  end   


  PhaVPt=mod((k.*rloc+Pha+PhaVP),(2*pi)); % Total phase for VP (propagation, element-excitation
                                          % and VP-vector-phase-sign) modulo 360

  PhaHPt=mod((k.*rloc+Pha+PhaHP),(2*pi)); % Total phase for HP (propagation, element-excitation
                                          % and HP-vector-phase-sign) modulo 360
  

  Evpn=(1/(rloc*4*pi)).*Amp.*EleAmp.*AmpVP.*exp(-j.*PhaVPt); % Vertical E-field component propagated to near-field point
  Ehpn=(1/(rloc*4*pi)).*Amp.*EleAmp.*AmpHP.*exp(-j.*PhaHPt); % Horiz E-field component propagated to near-field point
    
  
  EvpSum=EvpSum+Evpn;  % Summation of VP E-field comps for the N elements     
  EhpSum=EhpSum+Ehpn;  % Summation of HP E-field comps for the N elements 
 
end

EvpCplx=EvpSum;       % Sum of complex vertical components
EhpCplx=EhpSum;       % Sum of complex horizontal components

Evp=abs(EvpCplx);
Ehp=abs(EhpCplx);

dg=abs(angle(EvpCplx)-angle(EhpCplx));              % Calculate Delta gamma

F1=Ehp^2+Evp^2;					                      % Intermediate calculation
F2=(Ehp^4+Evp^4+2*(Ehp^2)*(Evp^2)*cos(2*dg))^0.5;   % Intermediate calculation
Emajor=sqrt(0.5*(F1+F2))+1e-15;                     % Emajor, Major axis of polarisation ellipse
Eminor=sqrt(0.5*(F1-F2))+1e-15;                     % Eminor, Minor axis of polarisation ellipse

F3=2*Ehp*Evp;
F4=(Ehp^2-Evp^2)+1e-9;
Tau=pi/2-0.5*atan((F3/F4)*cos(dg));                 % Tilt angle of polarisation ellipse

angdiff=(angle(EvpCplx)-angle(EhpCplx));            % Angle difference between complex Ehp and Evp
if angdiff>pi | angdiff<-pi                         % If difference is greater than 180 Deg (pi rad)
 angdiff=pi-angdiff;                                % difference=180-difference i.e. Phase-Lag becomes Phase-Lead
end
LR=sign(angdiff);                                   % Predominantly Left Handed, LR is -1
 					                                     % Predominantly Right Handed, LR is +1
						                                  % If LR is 0 then polarisation is linear, however
                                                    % to avoid plot discontinuities will default to LH pol
                                                    % for now.

if LR==-1 | LR==0              % Left Handed and Linear
 El=(Emajor+Eminor)/sqrt(2);
 Er=((Emajor-Eminor)/sqrt(2))*exp(j*2*Tau);
end

if LR==1                      % Right Handed
 El=(Emajor-Eminor)/sqrt(2);
 Er=((Emajor+Eminor)/sqrt(2))*exp(j*2*Tau);
end


 
AR=1./(abs(Emajor)/abs(Eminor));                   % Axial Ratio 1=perfect circular, 0=linear

Elh=abs(El);                                       % LHCP component
Erh=abs(Er);                                       % RHCP component

Etot=sqrt(abs(Evp)^2+abs(Ehp)^2);        % Calc total E-field
TauDeg=Tau*180/pi;                       % Tau (Deg)
Phase=angle(EhpCplx+EvpCplx)*180/pi;     % Phase of total E-field (deg) 
Phavp=angle(EvpCplx)*180/pi;             % Phase of vertical component E-field (deg)
Phahp=angle(EhpCplx)*180/pi;             % Phase of horizontal component E-field (deg)


Emulti=[Etot,Evp,Ehp,Elh,Erh,AR,TauDeg,Phase,Phavp,Phahp];  % Function output 
