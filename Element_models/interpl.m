function [Etot,CPflag]=interpl(theta_in,phi_in)
% Calculates total E-field pattern interpolated from measured
% or calculated data stored in the file pattern.mat
% Theta and phi are in radians.
%
% Usage: [Etot,CPflag]=interpl(theta,phi)
%
% File data should be in pattern_config and in column format as 
% shown below, except with no column titles :
%
% Theta(Deg)   Phi(Deg)  Pwr_tot(dB)
%  0           0         -2.1
%  5           0         -2.4
%  10          0         -2.6
%  .           .           .
%  .           .           .
%  180         0         -3.1
%  0           5         -3.3
%  5           5         -3.4
%  10          5         -3.6
%  .           .           .
%  .           .           .
%  180         5         -4.2
%  0           360      -20.2
%  .           .           .
%  .           .           .
%  170         360      -30.7
%  180         360      -35.8  
%
% Example usage :
%
%  loadnecpat1('dipole');       % Loads raw NEC output data, processes it and saves file called 
%                               % 'pattern1.mat' that contains variable pattern_config
%
%  load pattern1;               % Load the .mat file, pattern_config is now available 
%                               % in the MATLAB environment
%
%  place_element(1,0,0,0,0,0,0,'interp',0,0);  % The element 'interp' uses the data in pattern_config
%
%  See examples 3a, 3b and 3c

global freq_config;
global pattern_config;

theta_p=pattern_config(:,1); % Theta angle (degrees)
phi_p=pattern_config(:,2);   % Phi angle (degrees)
pwr_p=pattern_config(:,3);   % Pattern data (dB power)


dthaS=sort(diff(theta_p));   % Find step value in the theta data
I=find(dthaS>0);             % i.e. the smallest non-zero step value in the data
theta_step=dthaS(I(1,1),1);  %


dphiS=sort(diff(phi_p));     % Find step value in the phi data
I=find(dphiS>0);             % i.e. the smallest non-zero step value in the data
phi_step=dphiS(I(1,1),1);    %


theta_in_deg=theta_in*180/pi;
phi_in_deg=phi_in*180/pi;

if phi_in_deg<0                 % Take care of -ve phi values that
 phi_in_deg=360+phi_in_deg;     % can result from cart2sph conversions
end


% Find the theta and phi data values either side of the
% requested values theta_in & phi_in

[Y,I]=min(abs(theta_p-theta_in_deg)); % Y=abs diff, I=index
dI=sign(theta_in_deg-theta_p(I,1));   % Index offset
if dI==0;dI=1;end
theta_nrst1=theta_p(I);                           % 1st Nearest theta value
theta_nrst2=mod((theta_nrst1+dI*theta_step),180); % 2nd Nearest theta value

[Y,I]=min(abs(phi_p-phi_in_deg));     % Y=abs diff, I=index
dI=sign(phi_in_deg-phi_p(I,1));       % Index offset
if dI==0;dI=1;end
phi_nrst1=phi_p(I);                               % 1st Nearest phi value
phi_nrst2=mod((phi_nrst1+dI*phi_step),360);       % 2nd Nearest phi value

% Find the Pwr pattern values corresponding to the coordinates :
% [theta_nrst1,phi_nrst1]
% [theta_nrst1,phi_nrst2]
% [theta_nrst2,phi_nrst1]
% [theta_nrst2,phi_nrst2]


% First find the indicies

[Y,I1]=min(abs(theta_nrst1-theta_p)+abs(phi_nrst1-phi_p));
[Y,I2]=min(abs(theta_nrst1-theta_p)+abs(phi_nrst2-phi_p));
[Y,I3]=min(abs(theta_nrst2-theta_p)+abs(phi_nrst1-phi_p));
[Y,I4]=min(abs(theta_nrst2-theta_p)+abs(phi_nrst2-phi_p));

% Second find the pattern values

Pwr1=pwr_p(I1,1);
Pwr2=pwr_p(I2,1);
Pwr3=pwr_p(I3,1);
Pwr4=pwr_p(I4,1);


% Define the 4 (x,y,z) coords
x=zeros(4,1);
y=zeros(4,1);
z=zeros(4,1);
dr=zeros(4,1);

xyz(1,1)=theta_nrst1; % X1
xyz(1,2)=phi_nrst1;   % Y1
xyz(1,3)=Pwr1;        % Z1
dr(1,1)=sqrt((xyz(1,1)-theta_in_deg)^2+(xyz(1,2)-phi_in_deg)^2); % Dist between point 1 and required point

xyz(2,1)=theta_nrst1; % X2
xyz(2,2)=phi_nrst2;   % Y2
xyz(2,3)=Pwr2;        % Z2
dr(2,1)=sqrt((xyz(2,1)-theta_in_deg)^2+(xyz(2,2)-phi_in_deg)^2); % Dist between point 2 and required point

xyz(3,1)=theta_nrst2; % X3
xyz(3,2)=phi_nrst1;   % Y3
xyz(3,3)=Pwr3;        % Z3
dr(3,1)=sqrt((xyz(3,1)-theta_in_deg)^2+(xyz(3,2)-phi_in_deg)^2); % Dist between point 3 and required point

xyz(4,1)=theta_nrst2; % X4
xyz(4,2)=phi_nrst2;   % Y4
xyz(4,3)=Pwr4;        % Z4
dr(4,1)=sqrt((xyz(4,1)-theta_in_deg)^2+(xyz(4,2)-phi_in_deg)^2); % Dist between point 4 and required point

points4of=[xyz,dr];           % Assemble matrix of points and distances (dr) from the required point
[Y,I]=sortrows(points4of,4);  % Sort them by rows according to the distance (dr)
points3of=Y(1:3,1:3);         % Select the closest 3 points
p=points3of;                  % Shorter variable name

% Solve for coefficients a,b,c for a plane :  Pwr=a(theta)+b(phi)+c

% Format of matrix B is :
% B=[x1 y1 1
%    x2 y2 1
%    x3 y3 1];

B=[p(1,1) p(1,2) 1
   p(2,1) p(2,2) 1
   p(3,1) p(3,2) 1];

% A=[z1;z2;z3];
 
A=[p(1,3);p(2,3);p(3,3)];

X=B\A;

a=X(1,1);
b=X(2,1);
c=X(3,1);
  
% Insert required theta,phi coords into equation

PwrdB=a*theta_in_deg+b*phi_in_deg+c;

Etot=10^(PwrdB/20);
CPflag=0;

