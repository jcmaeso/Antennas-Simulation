function focus_array(R,theta_in,phi_in,Elref)
% Adjusts phase excitations for each element in the array,
% (as stored in array_config) such that they are equiphased 
% at the distance and in the direction defined by spherical 
% coords (r,theta,phi)
%
% Usage: focus_array(R,theta,phi,Elref)
%
% R........Focal distance (m)
% theta....Theta (Deg)
% phi......Phi (Deg)
% Elref....Element number to normalise phase to
%
% e.g. focus_array(50,12,0,1) % Squint array by 12 Deg towards X-axis
%                               in the X-Z plane and set focal length to 50m
%  
%      focus_array(200,5,90,1) % Squint array by 5 Deg towards Y-axis
%                                in the Y-Z plane and set focal length to 200m
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    
%
% SEE ALSO  squint_array

global array_config;
global freq_config;
global velocity_config;
fprintf('Array focused to : Theta = %3.2f , Phi = %3.2f , Flen = %3.2f (m)\n',theta_in,phi_in,R);

lambda=velocity_config/freq_config;
ko=2*pi/lambda;

theta=theta_in/180*pi;
phi=phi_in/180*pi;

[xs,ys,zs]=sph2cart1(R,theta,phi);   % Point in the far-field where
                                     % the elements must be equiphased 
[Trow,Tcol,N]=size(array_config);    % Number of elements in array N

phaseCorr=zeros(1,N);                % Dimension phase correction array

for n=1:N
 Toff=array_config(1:3,4,n);
 x=xs-Toff(1,1);
 y=ys-Toff(2,1);
 z=zs-Toff(3,1);
 [r,thloc,phloc]=cart2sph1(x,y,z);
 PhaseDist=ko*r;
 PhaseCorr(1,n)=mod(PhaseDist,2*pi);
end

% Normalise to element Elref
PhaseCorr(1,:)=PhaseCorr(1,:)-PhaseCorr(1,Elref); 

% Assign phase corrections to elements, ensuring all phases
% are positive in the range 0 to 2*pi
for n=1:N
 if sign(PhaseCorr(1,n))==-1
  array_config(2,5,n)=(2*pi+PhaseCorr(1,n));
 else
  array_config(2,5,n)=PhaseCorr(1,n);
 end
end