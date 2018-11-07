function squint_array(theta_in,phi_in,Elref)
% Adjusts phase excitations for each element in the array,
% (as stored in array_config) such that they are equiphased 
% in the direction defined by spherical coords (theta,phi)
%
% The calculated phases are quantised into steps of : 360/(2^n) Deg
% The value of the number of bits (n) is stored in phaseq_config  
% and initialised in init.m 
% (For n=16 the step size is 0.0055 Deg)
% 
% Usage: squint_array(theta,phi,Elref)
%
% theta....Theta (Deg)
% phi......Phi (Deg)
% Elref....Element number to normalise phase to
%
% e.g. squint_array(12,0,1) % Squint array by 12 Deg towards X-axis
%                             in the X-Z plane
%  
%      squint_array(5,90,1) % Squint array by 5 Deg towards Y-axis
%                             in the Y-Z plane
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
global velocity_config;
global phaseq_config;
global range_config;

nbits=phaseq_config; % Number of bits for phase shifters

theta=theta_in/180*pi;
phi=phi_in/180*pi;

fprintf('Array squinted to Theta = %3.2f , Phi = %3.2f   Using %i bit phase shifters\n',...
         theta_in,phi_in,nbits);

lambda=velocity_config/freq_config;
ko=2*pi/lambda;


[xs,ys,zs]=sph2cart1(range_config,theta,phi); % Point in the far-field where
                                              % the elements must be equiphased 
[Trow,Tcol,N]=size(array_config);             % Number of elements in array N

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


% Quantise data in (2*pi)/(2^n) steps
for n=1:N
 step=(2*pi)./(2.^nbits);
 array_config(2,5,n)=round(array_config(2,5,n)./step);
 array_config(2,5,n)=array_config(2,5,n).*step;
end