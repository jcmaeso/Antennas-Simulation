function [thetacut,Emulti]=theta_cut(thmin,thstep,thmax,phi)
% Cut in theta for single value of phi 
%
% Usage: [thetacut,Emulti]=theta_cut(thmin,thstep,thmax,phi)
%
% thmin......Minimum theta value (Deg)
% thstep.....Step size (Deg)
% thmax......Maximum theta value (Deg)
% phi........Phi value for pattern cut (Deg)
%
% Returned values :
%
% thetacut...theta values (Deg)
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
% Theta and components of Emulti (Etot,Evp...etc) are of the 
% form variable[npoints,1] 
%
%       
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    
%

global array_config;
global freq_config;
global range_config;

thmin_rad=thmin*pi/180;
thmax_rad=thmax*pi/180;
thstep_rad=thstep*pi/180;

phi_rad=phi*pi/180;

index=0;
for th_rad=thmin_rad:thstep_rad:thmax_rad,
 index=index+1;
 Emultiple=fieldsum(range_config,th_rad,phi_rad);
 
 for param=1:7
   if Emultiple(1,param)==0
    Emultiple(1,param)=1e-15;         % Stops plotting of nulls, log 0 error
   end
 end

 Etot(index,1)=Emultiple(1,1);   % Add values to Etot to make a vector
 Evp(index,1)=Emultiple(1,2);    % Add values to Evp to make a vector
 Ehp(index,1)=Emultiple(1,3);    % Add values to Ehp to make a vector
 Elhcp(index,1)=Emultiple(1,4);  % Add values to Elhcp to make a vector
 Erhcp(index,1)=Emultiple(1,5);  % Add values to Erhcp to make a vector
 AR(index,1)=Emultiple(1,6);     % Add values to AR to make a vector
 TauDeg(index,1)=Emultiple(1,7); % Add values to TauDeg to make a vector
 Phase(index,1)=Emultiple(1,8);  % Add values to Phase to make a vector
 Phavp(index,1)=Emultiple(1,9);  % Add values to Phavp to make a vector
 Phahp(index,1)=Emultiple(1,10); % Add values to Phahp to make vector

end

thetacut=(thmin:thstep:thmax)';                                       % Output as a vector
Emulti=[Etot,Evp,Ehp,Elhcp,Erhcp,AR,TauDeg,Phase,Phavp,Phahp];        % Output as 10 vectors