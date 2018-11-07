% EXAMPLE ExParabPol
%
% Parabolic reflector approximation using lambda/100 dipoles spaced lambda/4 above a groundplane.
% The reflector surface function is a separate m-file ReflectorFn.m
%
% The approximation is used to explore the effects of reflector geometry on cross polarisation 
% and sidelobe levels. The 3D geometry plot shows the orientation of the individual array element
% polarisation vectors. This gives good insight as to how cross-polar radiation components are
% generated in the far field.
%
% Experiment : Try changing the offset value (PaYcen in the file) to zero, notice that the 
%              cross-polar (horizontal) components become symmetrical about the reflector's
%              primary axes. As a result the cross-polar radiation components cancel out in 
%              the far field.
%
% The sources are placed such that they lie on the parabolic surface.
% The phase of each source is then determined by calculating the distance 
% between it and the feed point. A cos(theta)^n function is used to represent
% the feed illumination of the dish. The value of 'n' is calculated according
% the user specified edge taper.
%
% Dish configuration :
%
%   Frequency 2.45GHz
%   Diameter 400mm
%   Offset 200mm
%   Focal Length 320mm
%   F/D 0.80
%   Feed (Linear Vertical Pol)
%   Feed Taper (-12dB at dish edge)
%
%
%
% The 3D geometry plot key :
%
%   The plot shows the orientation of the currents induced on
%   the reflector surface (red arrows).
%
%   Theta and Phi pattern plots relate to the standard global coord denoted gx,gy and gz.
%
%   Coordinates for defining the reflector are denoted rx,ry and rz.
%
%   The reflector has been rotated 90deg about the gy axis so that the direction of propagation
%   is along gx (-rz in reflector coords). By doing this, VP and HP plots represent Co and Cross-polar
%   pattern components respectively, assuming the feed E-vector is orientated vertically (in line
%   with gz). 
%
%   The feed point location is normally located at the reflector coordinate system origin. 
%   It can be displaced in x,y,or z and denoted by a blue 'F'. 
%
% The refector is 'sampled' at lambda/4 intervals (XYstep variable in file). This can be extended
% to lambda/2 for larger reflectors, to reduce calculation time. However, grating lobes will
% limit the angular range over which the approximation is valid.
%
% The reflector is normally parabolic but modifications could be made to use another
% surface function or introduce distortion errors. Script lines commented with '###' reference
% the z=(x^2+y^2)/(4*F) parabolic form via a separate function (reflectorfn.m). 
%
% Note the orientation of the reflector axes, +zr is towards the reflector, not in the direction
% of propagation. Therefore the actual form of the equation is z=-(x^2+y^2)/(4*F)+F  
%
% Reference : Antenna Theory Analysis and Design, C.A.Balanis 2nd Edition
%             Chapter 15 page 803 Parabolic reflector
%
% For more rapid and detailed reflector/horn analysis consider using ICARA
% from the University of Vigo in Spain. 
% (Internet search for 'ICARA Refector Design')
%
% Or SABOR from the Technical University of Madrid. 
% (Internet search for 'SABOR Refector Design')


close all
clc

init;                                  % Initialise global variables


freq_config=2.45e9;                    % Define frequency (Hz)
lambda=3e8/freq_config;                % Calculate wavelength (m)
dBrange_config=60;                     % Dynamic range for plots (min value plotted is -dBrange_config)

% Parabolic dish parameters
% *************************
F=320e-3;                              % Parabola focal length (m)

% Array element dimensions
% Lambda/100 dipole spaced lambda/4 above groundplane used to represent currents induced on dish surface
dipoleg_config=[lambda/100,lambda/4];

PaXcen=00e-3;                % Projected aperture centre X-coordinate (m)
PaYcen=200e-3;               % Projected aperture centre Y-coordinate (m)

Xap=400e-3;                  % Projected aperture X-dimension (m)
Yap=400e-3;                  % Projected aperture Y-dimension (m)

EtaperdB=-12;                % Edge taper in dB, used to calculate n in (cos(theta))^n feed model

XYstep=lambda/4;             % Stepping distance to sample aperture (m)

% Feed translations in reflector coordinates
dFx=00e-3;                   % Feed displacement x-direction (m)
dFy=00e-3;                   % Feed displacement y-direction (m)
dFz=00e-3;                   % Feed displacement z-direction (m)

Forient='V';                 % Feed orientation 'V'=vertical, 'H'=horizontal
 
% Plotting parameters
% Phi Cuts (Deg)
phimin=-90;                  % Minimum value for phi
phistep=1;                   % Phi step value
phimax=90;                   % Maximum value for phi
theta=90;                    % Theta value for phi cut

% Theta Cuts (Deg)
thmin=-90+90;                % Minimum value for theta
thstep=1;                    % Theta step value
thmax=90+90;                 % Maximum value for theta
phi=0;                       % Phi value for theta cut

% Vertical plot range (dB)
pmin=-dBrange_config;             
pmax=0;

% ***************************************************************
% ************ End of User Params & Start Calculations **********

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



% Calc Array Geom To Represent Specified Reflector And Feed Position 
% ******************************************************************

%PaZcen=-(PaXcen.^2+PaYcen.^2)/(4*F)+F;    % Z-coord of projected aperture centre ###
PaZcen=reflectorfn(PaXcen,PaYcen,F);       % Z-coord of projected aperture centre ###

% Feed Position 'F'

Fx=0+dFx;                % Feed X-coordinate (m)
Fy=0+dFy;                % Feed Y-coordinate (m)
Fz=0+dFz;                % Feed Z-coordinate (m)

% Array element parameters
Pwr=0;                   % Initialise power level variable for elements
Pha=0;                   % Initialise phase level variable for elements

Dsf=1e-6;                % Delta value used for numerical calculation of gradient, defines dx, dy and dz

dx=Dsf;
dy=Dsf;
dz=Dsf;

EtaperLin=10^(EtaperdB/20);                       % Linear value for edge taper


% Find the maximum angles subtended by the reflector edges at the feed point
% These angles are used to define the cos-q parameters for the feed illumination
% ******************************************************************************
 
% ************************ X-limits **********************************

h1x=sqrt((PaXcen-Fx)^2+(PaYcen-Fy)^2+(PaZcen-Fz)^2);  % Distance from feed to centre of dish
o1x=(PaXcen-Fx);
AngleX1=asin(o1x/h1x);

% Left-hand edge
ExL=-Xap/2+XYstep/2+PaXcen;
EyL=PaYcen;
EzL=reflectorfn(ExL,EyL,F);                           % Z-value at dish left hand edge of reflector ###
h2x=sqrt((ExL-Fx)^2+(EyL-Fy)^2+(EzL-Fz)^2);           % Distance from feed to left-hand edge of dish
o2x=(ExL-Fx);
AngleX2=asin(o2x/h2x);
%AngleX2*180/pi

% Right-hand edge
ExR=Xap/2-XYstep/2+PaXcen;
EyR=PaYcen;
EzR=reflectorfn(ExR,EyR,F);                           % Z-value at dish right hand edge of reflector ###
h3x=sqrt((ExR-Fx)^2+(EyR-Fy)^2+(EzR-Fz)^2);           % Distance from feed to right-hand edge of dish
o3x=(ExR-Fx);
AngleX3=asin(o3x/h3x);
%AngleX3*180/pi
XangleMin=min([abs(AngleX2-AngleX1),abs(AngleX3-AngleX1)]);

% *************************** Y-limits *******************************

h1y=sqrt((PaXcen-Fx)^2+(PaYcen-Fy)^2+(PaZcen-Fz)^2);  % Distance from feed to centre of dish
o1y=(PaYcen-Fy);
AngleY1=asin(o1y/h1y);

% Downward edge
ExD=PaXcen;
EyD=-Yap/2+XYstep/2+PaYcen;
EzD=reflectorfn(ExD,EyD,F);                           % Z value at bottom edge of reflector ###
h2y=sqrt((ExD-Fx)^2+(EyD-Fy)^2+(EzD-Fz)^2);           % Distance from feed to downward edge of reflector
o2y=(EyD-Fy);
AngleY2=asin(o2y/h2y);
%AngleY2*180/pi

% Upper edge
ExU=PaXcen;
EyU=Yap/2-XYstep/2+PaYcen;            
EzU=reflectorfn(ExU,EyU,F);                           % Z value at to edge of reflector ###
h3y=sqrt((ExU-Fx)^2+(EyU-Fy)^2+(EzU-Fz)^2);           % Distance from feed to upper edge of reflector
o3y=(EyU-Fy);
AngleY3=asin(o3y/h3y);
%AngleY3*180/pi
YangleMin=min([abs(AngleY2-AngleY1),abs(AngleY3-AngleY1)]);

%XangleMin*180/pi
%YangleMin*180/pi

nXap=log10(EtaperLin)/log10(cos(XangleMin));    % Value of n for the cos(theta)^n feed model
nYap=log10(EtaperLin)/log10(cos(YangleMin));    % Value of n for the cos(theta)^n feed model

%pause

% ******************* End of limit Calcs ******************************

% Fig24 used for diagnostic testing
figure(24);
hold on;

% Setup some initial parameters
Usf=2e-2;                                    % Scaling factor for plotting
EleN=0;                                      % Initialise number of array elements counter
x=minXap:XYstep:maxXap+XYstep;               % X-vector for meshgrid      
y=minYap:XYstep:maxYap+XYstep;               % Y-vector for meshgrid
[X,Y]=meshgrid(x,y);                         % Grid for plotting power and phase distributions (figure24)
Z=zeros(size(X));
xc=0;                                        % Initialise x-index for power / phase plotting 

% Start the main calculation loop
% The loop steps through a rectangular grid in x and y. At each point
% a decision is made as to whether the x,y point lies within the 
% projected aperture (r1 and r2 comparison). If the point is valid
% the rest of the loop executes.
for x=minXap:XYstep:maxXap+XYstep            % Step through x-coordinates
 xc=xc+1;
 yc=0;                                       % Initialise y-index for power phase plotting
 for y=minYap:XYstep:maxYap+XYstep           % Step through y-coordinates
  yc=yc+1;
  Z(yc,xc)=EtaperdB-10;                      % Default Z-values for plotting the power dist (values outside reflector)
  Z1(yc,xc)=0;                               % Default Z-values for plotting the phase dist (values outside reflector) 
  if x==0;x=1e-9;end;                        % Avoid divide by zero errors
  if y==0;y=1e-9;end;                        % Avoid divide by zero errors
  xr1=(x-PaXcen);                            % x-coord relative to projected aperture centre
  yr1=(y-PaYcen);                            % y-coord relative to projected aperture centre
  r1=sqrt(xr1.^2+yr1.^2);                    % Radial distance from centre of projected aperture to point x,y
  ang1=atan2(yr1,xr1);                       % Angle from centre of aperture to point x,y

  xr2=(Xap/2).*cos(ang1);
  yr2=(Yap/2).*sin(ang1);                    % Point on aperture periphery in direction ang1
  r2=sqrt(xr2.^2+yr2.^2);                    % Radial distance from centre of projected aperture to periphery point
  
  if r1<r2                                   % Decide whether point lies within the specified aperture

   EleN=EleN+1;                              % Increment the element count
   
   %z=-(x.^2+y.^2)/(4*F)+F;                  % Calculate z-coordinate for parabola ###
   z=reflectorfn(x,y,F);                     % Calculate z-coordinate for parabola ###
   f2p=sqrt((Fx-x).^2+(Fy-y).^2+(Fz-z).^2);  % Calculate distance from focal point to parabolic surface, f2p
   Pha=(f2p./(lambda))*360;                  % Calculate the appropriate phase excitation, based on f2p distance
   Pha=mod(Pha,360);
    
   % Calculate numerical gradient of surface at point P 
   % **************************************************
   
   Px=x;                                     % X-coord of Point P on reflector surface
   Py=y;                                     % Y-coord of Point P on reflector surface
   Pz=z;                                     % Z-coord of Point P on reflector surface

   Px1=Px+dx;                                % Delta-x to calculate gradient in x-direction
   %Pz1=-(Px1.^2+Py.^2)/(4*F)+F;             % Calculate change in z on parabolic surface ###
   Pz1=reflectorfn(Px1,Py,F);                % Calculate change in z on parabolic surface ###
   ddx=(Pz1-Pz)/(Px1-Px);                    % Gradient in x-direction
   
   Py1=Py+dy;                                % Delta-y to calculate gradient in y-direction
   %Pz1=-(Px.^2+Py1.^2)/(4*F)+F;             % Calculate change in z on parabolic surface ###
   Pz1=reflectorfn(Px,Py1,F);                % Calculate change in z on parabolic surface ###
   ddy=(Pz1-Pz)/(Py1-Py);                    % Gradient in y-direction
   

   % Calculate unit normal to reflector surface : UNx,UNy,UNz
   % ********************************************************  

   Ux=ddx;   % X-component of normal vector
   Uy=ddy;   % Y-component of normal vector
   Uz=-1;    % Z-component of normal vector

   % Normalise to create unit vector
   Umag=sqrt(Ux.^2+Uy.^2+Uz.^2);
   UNx=Ux/Umag;
   UNy=Uy/Umag;
   UNz=Uz/Umag;

   UN=[UNx,UNy,UNz];  % Define unit vector (normal to surface at P)

   % Used for diagnostic tests
   Vx=[Px;(Px+UNx*Usf)];
   Vy=[Py;(Py+UNy*Usf)];
   Vz=[Pz;(Pz+UNz*Usf)];
   plot3(Vx,Vy,Vz,'b');    % Add unit normal to plot (fig 24)



   % Calculate vector from feed point 'F' to point 'P' on surface : Sx,Sy,Sz
   % ***********************************************************************

   Sx=Px-Fx;  % Distance in x-direction from F to P
   Sy=Py-Fy;  % Distance in y-direction from F to P
   Sz=Pz-Fz;  % Distance in z-direction from F to P

   
   Smag=sqrt(Sx.^2+Sy.^2+Sz.^2);  % Magnitude of distance from feed point to P
   SNx=Sx/Smag;                   % X-component of unit vector
   SNy=Sy/Smag;                   % Y-component of unit vector
   SNz=Sz/Smag;                   % Z-component of unit vector

   SN=[SNx,SNy,SNz];  % Define unit vector

   % Calculate feed orientation vector at feed point : Efx,Efy,Efz
   % *************************************************************

   % Define ENf, a unit vector representing the feed E-vector
   % Default is aligned with the reflector y-axis (vertical)
   ENfx=0;
   ENfy=1;
   ENfz=0;
   ENf=[ENfx,ENfy,ENfz]; % Normalised feed E-vector
   
   % Magnitude of distance from feed point to centre of projected
   % aperture of reflector. The 'aiming point' for the feed.
   SmagCen=sqrt((PaXcen-Fx).^2+(PaYcen-Fy).^2+(PaZcen-Fz).^2);
    
   
   % Orientate the the feed E-vector according to whether Vertical
   % or Horizontal polarisation has been selected for the feed.
   % Once rotated, the vector represensts the orientation of 
   % the incident E-field (EiNf)
   
   % Rotations returned by the rotx,roty and rotz functions
   % are defined as +ve looking from the origin out along the
   % axis. (Opposite sense to ArrayCalcs xrot_array, yrot_array etc)
   
   if Forient=='V'
      XR=rotx(-atan2(Sy,SmagCen));
      YR=roty(atan2(Sx,SmagCen));
      ZR=rotz(0*pi/180);
      EiNf=ENf*ZR*XR*YR;
   else   
      XR=rotx(-atan2(Sy,SmagCen));
      YR=roty(atan2(Sx,SmagCen));
      ZR=rotz(90*pi/180);
      EiNf=ENf*ZR*YR*XR;
   end 
   
   % Used for diagnostic tests
   EiNx=EiNf(1,1);
   EiNy=EiNf(1,2);
   EiNz=EiNf(1,3);
      
   Vx=[dFx;(dFx+EiNx*Usf*5)];
   Vy=[dFy;(dFy+EiNy*Usf*5)];
   Vz=[dFz;(dFz+EiNz*Usf*5)];
   plot3(Vx,Vy,Vz,'m');  %Plot orientation of incident E-field at feed point (fig 24) 
   
   
   % Calculate induced current vector on reflector surface
   % *****************************************************

   A=cross(SN,EiNf);  % Cross product of the (Feed 'F' to point 'P' unit vector)
                      % and the (Incident E-field unit vector)
                      
   J=cross(UN,A);     % Cross product of (unit normal to surface)
                      % and intermediate product A, giving the surface current vector J

   % Extract individual vector components
   Jx=J(1,1);
   Jy=J(1,2);
   Jz=J(1,3);

   % Normalise vector
   Jmag=sqrt(Jx.^2+Jy.^2+Jz.^2);
   JNx=Jx/Jmag;
   JNy=Jy/Jmag;
   JNz=Jz/Jmag;

   % Used for diagnostic tests
   Vx=[Px;Px+JNx*Usf];
   Vy=[Py;Py+JNy*Usf];
   Vz=[Pz;Pz+JNz*Usf];
   plot3(Vx,Vy,Vz,'r');
   
   % Cross product of induced current unit vector and unit normal to surface.
   % This is to give a unit vector orthogonal to JN and UN, so a local
   % unit axis set can be created. See xyz2 variable below
   B=[JNx,JNy,JNz];
   A=[UNx,UNy,UNz];
   CP=cross(A,B);            
   
   % Extract x,y,z components of the cross product
   CPx=CP(1,1);
   CPy=CP(1,2);
   CPz=CP(1,3);
   
   % Visualise the CP vector, used for diagnostic tests
   Vx=[Px;Px+CPx*Usf];
   Vy=[Py;Py+CPy*Usf];
   Vz=[Pz;Pz+CPz*Usf];
   plot3(Vx,Vy,Vz,'g');
   
   
   % Calculate the rotation matrix and offsets
   % *****************************************
   
   % By defining a set of 4-points, known in two coordinate systems, a
   % set of rotations and offsets can be calculated to link them. These
   % rotations and offsets are then used to place the array elements.
   %
   % The 1st set xyz1 is simply a unit axis set in the global coordinate
   % system. The 2nd set represents the orientation and 3D location of
   % the induced current vector JN, unit normal to surface UN and their
   % cross product CP at point P.
   %
   % The rotations and offsets are used by ArrayCalc to define the
   % position and orientation of each element in the array.
   
   % Define unit axis coordinate points origin,x,y and z. (1st set of 4 points)
   xyz1=[0,1,0,0
         0,0,1,0
         0,0,0,1];

   % Define unit axis coordinate points based on the surface current unit vector, normal to parabolic
   % surface and cross product of the two. (2nd set of 4 points)
   xyz2=[Px,JNx+Px,CPx+Px,UNx+Px
         Py,JNy+Py,CPy+Py,UNy+Py
         Pz,JNz+Pz,CPz+Pz,UNz+Pz];

   
   [rotoff]=coord2troff(xyz1,xyz2);   % Calc rotation matrix and offsets for xyz1 and xyz2 coord sets
   rot=rotoff(1:3,1:3);
   
   % Define rotation matrices for 180deg rotations about x,y and z axes 
   XR=rotx(pi);                       % Rotation matrix 180 deg rotation about local x-axis
   YR=roty(pi);                       % Rotation matrix 180 deg rotation about local y-axis
   ZR=rotz(pi);                       % Rotation matrix 180 deg rotation about local z-axis



   single_element(Px,Py,Pz,'dipoleg',Pwr,Pha);      % Place the element 

   array_config(1:3,1:3,EleN)=[rot];                % Overwrite the orientation information

   % Calculate cross product of the surface unit normal UN and
   % the incident E-field unit vector EiNf. This gives a scaling
   % factor for the induced surface current JN, which is currently
   % in orientation only.
   % Think of it in the same way that the sun's ray strike a surface. At normal
   % incidence there is maximum flux (heat transfer), at a glancing incidence the flux
   % level is reduced.
   
   SF=cross(UN,EiNf);                  % Scale factor to account for incidence angle of E-field
   SFx=SF(1,1);
   SFy=SF(1,2);
   SFz=SF(1,3);
   SFmag=sqrt(SFx.^2+SFy.^2+SFz.^2);   % Magnitude of scaling factor
   
   % Calculate the square law attenuation, 1/r rather than 1/r^2 in this case
   % because we are working in linear volts rather than power. 
   
   SQlawAtten=1/(Smag)^1;              % Attenuation factor from 'F' to 'P' on the reflector
   SQlawAttenCen=(1/SmagCen^1);        % Attenuation factor from 'F' to projected aperture centre
   SQlawSF=SQlawAtten/SQlawAttenCen;   % Normalise to the centre value

   
   % Calculate angles subtended at the feed point by point 'P'
   % on the reflector surface, thereby allowing the power distribution
   % profile to be calculated.
   % ************************ X-Angle ********************************

   h1x=sqrt((PaXcen-Fx)^2+(PaYcen-Fy)^2+(PaZcen-Fz)^2);
   o1x=(PaXcen-Fx);
   AngleX1=asin(o1x/h1x);

   h2x=sqrt((Px-Fx)^2+(Py-Fy)^2+(Pz-Fz)^2);
   o2x=(Px-Fx);
   AngleX2=asin(o2x/h2x);
   %AngleX2*180/pi
   Xangle=abs(AngleX2-AngleX1);

   % *********************** Y-Angle *********************************

   h1y=sqrt((PaXcen-Fx)^2+(PaYcen-Fy)^2+(PaZcen-Fz)^2);
   o1y=(PaYcen-Fy);
   AngleY1=asin(o1y/h1y);

   h2y=sqrt((Px-Fx)^2+(Py-Fy)^2+(Pz-Fz)^2);
   o2y=(Py-Fy);
   AngleY2=asin(o2y/h2y);
   %AngleY2*180/pi
   Yangle=abs(AngleY2-AngleY1);
   
   LinVoltX=(cos(Xangle).^nXap);       % Calc the cos-q taper in x at point P
   LinVoltY=(cos(Yangle).^nYap);       % Calc the cos-q taper in y at point P
   LinVolt=LinVoltX*LinVoltY;          % Calc the combined taper in x and y at point P
   if LinVolt<0.0316                   % Limit evaluated edge taper to -30dB (0.0316=10^-30dB/20)
      LinVolt=0.0316;
   end
   LinVolt=LinVolt*SFmag*SQlawSF;      % Apply the incidence angle and square-law attenuation factors
   array_config(1,5,EleN)=LinVolt;     % Fill the array_config matriz
   Z(yc,xc)=20*log10(LinVolt);         % Power distribution data (dB power)
   Z1(yc,xc)=Pha;                      % Phase distribution data (deg)
   
   % Used for diagnostic testing
   % text(x,y,z,[num2str(sign(af)),num2str(sign(bf)),num2str(sign(ap)),num2str(sign(bp))]);

  end
 end
end
zrot_array(90,1,EleN);                      % Rotate whole reflector 90deg around z-axis
yrot_array(90,1,EleN);                      % Rotate whole reflector 90deg around y-axis

% Used for diagnostic testing
figure(24);
axis square;
xlabel('Global X-axis');
ylabel('Global Y-axis');
zlabel('Global Z-axis');
rotate3d on;
AX=max(axis);
axis([-AX AX -AX AX -AX AX]);
chartname=sprintf('Diagnostics');
set(24,'name',chartname);



% Plot 3d geometry
plot_geom3d(1,0);
view([60,20]);


% Plot Power Distribution 
figure(22);
surf(X,Y,Z);
colormap('jet');
axis equal;
xlabel('Reflector X-axis');
ylabel('Reflector Y-axis');
zlabel('Power Level dB');
rotate3d off;
view(0,90);
colorbar;
title('Power Distribution dB')

chartname=sprintf('Power Distribution');
set(22,'name',chartname);


% Plot Phase Distribution
figure(23);
surf(X,Y,Z1);
colormap('jet');
axis equal;
xlabel('Reflector X-axis');
ylabel('Reflector Y-axis');
zlabel('Phase Deg');
rotate3d off;
view(0,90);
colorbar;
title('Phase Distribution Deg')

chartname=sprintf('Phase Distribution');
set(23,'name',chartname);

% **************** Generate Theta and Phi pattern cut data ********************** 
% With the exception of the legends, variable labeling assumes feed is orientated
% vertically, transposse VP and HP ifyou have selected Forient='H' option. There
% is no need to edit or change anything. 


fprintf('\nCalculating pattern cut in Phi\n');
[phicut,Emulti]=phi_cut(phimin,phistep,phimax,theta);
EphicutVP=Emulti(:,2);
EphicutHP=Emulti(:,3);

phicut=phicut';
EphicutVP=EphicutVP';
EphicutHP=EphicutHP';
PWRphicutVP=20*log10(abs(EphicutVP));
PWRphicutHP=20*log10(abs(EphicutHP));

if Forient=='V'
 NormPhi=max(PWRphicutVP);
else
 NormPhi=max(PWRphicutHP);
end

fprintf('\nCalculating pattern cut in Theta\n');
[thetacut,Emulti]=theta_cut(thmin,thstep,thmax,phi);
EthetacutVP=Emulti(:,2);
EthetacutHP=Emulti(:,3);

thetacut=thetacut';
EthetacutVP=EthetacutVP';
EthetacutHP=EthetacutHP';
PWRthetacutVP=20*log10(abs(EthetacutVP));
PWRthetacutHP=20*log10(abs(EthetacutHP));

if Forient=='V'
 NormTheta=max(PWRthetacutVP);
else
 NormTheta=max(PWRthetacutHP);
end

% ********************** Plot Phi Cuts on Cartesian Axes *******************
figure(20);
plot(phicut,PWRphicutVP-NormPhi,'r','linewidth',2);
hold on;
plot(phicut,PWRphicutHP-NormPhi,'b','linewidth',2);
axis([phimin phimax pmin pmax]);
xlabel('Phi (Degrees)');
ylabel('dB');
T1=sprintf('Phi cut for Theta = %g Deg',theta);
title(T1);
grid on;

if Forient=='V'
 plegend(0.6,0.80,'r','VP (Co Polar)');          % VP Label at screen coords               
 plegend(0.6,0.77,'b','HP (Cross Pol)');         % HP Label at screen coords
else
 plegend(0.6,0.80,'b','HP (Co Polar)');          % HP Label at screen coords               
 plegend(0.6,0.77,'r','VP (Cross Pol)');         % VP Label at screen coords
end

chartname=sprintf('Phi Patterns');
set(20,'name',chartname);


% ********************** Plot Theta Cuts on Cartesian Axes *****************
figure(21);
plot(thetacut,PWRthetacutVP-NormTheta,'m','linewidth',2);
hold on;
plot(thetacut,PWRthetacutHP-NormTheta,'c','linewidth',2);
axis([thmin thmax pmin pmax]);
xlabel('Theta (Degrees)');
ylabel('dB');
T1=sprintf('Theta cut for Phi = %g Deg',phi);
title(T1);
grid on;

if Forient=='V'
 plegend(0.6,0.80,'m','VP (Co Polar)');          % VP Label at screen coords               
 plegend(0.6,0.77,'c','HP (Cross Pol)');         % HP Label at screen coords
else
 plegend(0.6,0.80,'c','HP (Co Polar)');          % HP Label at screen coords               
 plegend(0.6,0.77,'m','VP (Cross Pol)');         % VP Label at screen coords
end

chartname=sprintf('Theta Patterns');
set(21,'name',chartname);


% ************************ Reflector Axis Plotting *************************

figure(1);
hold on;

% Define reflector axis lines
ax=axis;
gaxlen=(max(ax)-min(ax))/(2);     % Axis length for plotting reflectoraxis set
                                  % Set to fraction of plotting cube side length
% Reflector X-axis
gaxis(1:3,1)=[ 0   ; 0   ;0  ].*gaxlen;
gaxis(1:3,2)=[ 0   ; -1  ;0  ].*gaxlen;

% Reflector Y-axis
gaxis(1:3,3)=[ 0   ; 0   ;0  ].*gaxlen;
gaxis(1:3,4)=[ 0   ; 0   ;1  ].*gaxlen;

% Reflector Z-axis
gaxis(1:3,5)=[ 0   ; 0   ;0  ].*gaxlen;
gaxis(1:3,6)=[ -1  ; 0   ;0  ].*gaxlen;

% Plot reflector axis set

% Plot reflector X-axis (-ve global X-axis)
 plot3(gaxis(1,1:2),gaxis(2,1:2),gaxis(3,1:2),'m:','linewidth',1);
 text(gaxis(1,2),gaxis(2,2),gaxis(3,2),'rx','fontsize',8,'fontweight','bold');
  
 % Plot reflector Y-axis (-ve global Y-axis)
 plot3(gaxis(1,3:4),gaxis(2,3:4),gaxis(3,3:4),'m:','linewidth',1);
 text(gaxis(1,4),gaxis(2,4),gaxis(3,4),'ry','fontsize',8,'fontweight','bold');

 % Plot reflector Z-axis (global Z-axis)
 plot3(gaxis(1,5:6),gaxis(2,5:6),gaxis(3,5:6),'m:','linewidth',1);
 text(gaxis(1,6),gaxis(2,6),gaxis(3,6),'rz','fontsize',8,'fontweight','bold');
 

 % Identify focal point (note plotting is in global coords gx,gy,gz)
 text(-Fz,-Fx,Fy,'F','fontsize',8,'fontweight','bold','color',[0,0,1]);





 % ******************************* Add plots to 3D geom *********************************

 figure(1);                                    
 hold on;
 AX=max(axis);
 axis([-AX AX -AX AX -AX AX]);
 SF=AX;

 % ********************************* Add Theta Cut Plots ********************************

 pwrdBplotVP=(PWRthetacutVP-NormTheta+dBrange_config).*SF./dBrange_config; 
 pwrdBplotHP=(PWRthetacutHP-NormTheta+dBrange_config).*SF./dBrange_config; 
 
 thetaplot=thetacut.*pi./180;                  % Convert theta values to radians
 phiplot=ones(size(thetacut)).*phi.*pi./180;   % Set up plot vector of phi values

 Rvp=pwrdBplotVP;                              % Radius is equal to pattern power in dB
 Rvp=(Rvp+Rvp.*sign(Rvp))/2;                   % Limit negative values to 0
 Rhp=pwrdBplotHP;                              % Radius is equal to pattern power in dB
 Rhp=(Rhp+Rhp.*sign(Rhp))/2;                   % Limit negative values to 0
 
 [x1,y1,z1]=sph2cart1(Rvp,thetaplot,phiplot);     % Calculate x,y,z coord for plotting
 [x2,y2,z2]=sph2cart1(Rhp,thetaplot,phiplot);     % Calculate x,y,z coord for plotting
 plot3(x1,y1,z1,'m','linewidth',2);               % Plot VP
 plot3(x2,y2,z2,'c','linewidth',2);               % Plot VP


 % ********************************* Add Phi Cut Plots **********************************

 pwrdBplotVP=(PWRphicutVP-NormPhi+dBrange_config).*SF./dBrange_config; 
 pwrdBplotHP=(PWRphicutHP-NormPhi+dBrange_config).*SF./dBrange_config; 
 
 phiplot=phicut.*pi./180;                      % Convert phi values to radians
 thetaplot=ones(size(phicut)).*theta.*pi./180; % Set up plot vector of theta values

 Rvp=pwrdBplotVP;                              % Radius is equal to pattern power in dB
 Rvp=(Rvp+Rvp.*sign(Rvp))/2;                   % Limit negative values to 0
 Rhp=pwrdBplotHP;                              % Radius is equal to pattern power in dB
 Rhp=(Rhp+Rhp.*sign(Rhp))/2;                   % Limit negative values to 0
 
 [x1,y1,z1]=sph2cart1(Rvp,thetaplot,phiplot);     % Calculate x,y,z coord for plotting
 [x2,y2,z2]=sph2cart1(Rhp,thetaplot,phiplot);     % Calculate x,y,z coord for plotting
 plot3(x1,y1,z1,'r','linewidth',2);               % Plot VP
 plot3(x2,y2,z2,'b','linewidth',2);               % Plot VP

 axis auto;
 axis equal;
 
 %calc_directivity(5,5);  % Calculate directivity, takes about 3min on 1GHz machine
                          % and does not include spill-over loss.
                          
                          
 help exparabpol
                          
 fprintf('\n\nReflector parameters\n');
 fprintf('====================\n\n');
 fprintf('Frequency : %g GHz\n',freq_config/1e9);
 fprintf('X-aperture : %g m\n',Xap);
 fprintf('Y-aperture : %g m\n',Yap);
 fprintf('Focal Length : %g m\n',F);
 fprintf('F/D Ratio : %g \n\n',F/max([Xap,Yap]));
 
 fprintf('Aperture Centre X : %g m\n',PaXcen);
 fprintf('Aperture Centre Y : %g m\n',PaYcen);
 fprintf('Edge Taper : %g dB\n',EtaperdB);
 fprintf('Cos-q param in x : %g\n',nXap);
 fprintf('Cos-q param in y : %g\n\n',nYap);
 
 fprintf('Feed Displacement X : %g m\n',dFx);
 fprintf('Feed Displacement Y : %g m\n',dFy);
 fprintf('Feed Displacement Z : %g m\n\n',dFz);
 
 fprintf('Feed Orientation : %s\n',Forient);