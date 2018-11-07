function [Lin_Volts,Phase_Rad,Theta,FnValdB] = fourier1(N,Dx,Profile);
% Calculation of Fourier coefficients for specified pattern profile
%
% Usage : [Lin_Volts,Phase_Rad,Theta,FnValdB]=fourier1(N,Dx,Profile)
%
% N.........Number of elements in array (odd or even)
% Dx........Array element spacing (m), ideally Dx=0.5*lambda 
% Profile...Ideal pattern profile (Min angle=-90, Max angle=+90)
%
%
% Returned Values :
%
% Lin_Volts...Amplitude of coefficients in (linear volts)
% Phase_Rad...Phase of coefficients (radians)
% Theta.......Theta vector for plotting [-90:1:90] (Deg)
% FnValdB.....The pattern profile defined over theta vector (dB)
%
%
% To define a pattern that is -50dB between -90 and -45 deg,
%                               0dB between -45 and +45 deg,
%                             -50dB between +45 and +90 deg 
% 
% use: Angle=[-90 -45 -45 +45 +45  90];  % Angle data points (Deg)
%      PwrdB=[-50 -50  0   0  -50 -50];  % Power data points (dB)
%
%      Profile=[Angle;PwrdB];            % Assemble the profile matrix
%      Dx=lambda*0.5;                    % Define array spacing (m)
%      N=16;                             % Number of array elements
%
%      [Lin_Volts,Phase_Rad,Theta,FnValdB]=fourier1(N,Dx,Profile);
%      array_config(1,5,:)=Lin_Volts;
%      array_config(2,5,:)=Phase_Rad;
%
% Notes : The pattern profile is interpreted as a series of linked
%         lines drawn between the Angle,PwrdB coordinates supplied.
% 
%         This type of synthesis is generally used for flat-top sector
%         coverage patterns. Although more complicated pattern profiles are 
%         possible, the resulting element excitations can result in very
%         inefficient use of the array aperture. Basically many of the 
%         elements end up at very low power levels. It also requires fairly
%         precise control of both amplitude and phase.
%
%         For the method to work, array elements must be regularly spaced
%         and ideally 0.5*lambda apart. Less then 0.5*lambda causes the 
%         transform to map to non-visible space (complex values for theta).
%         Larger than 0.5*lambda and grating lobes start to appear.
%
% See C.A. Balanis 2nd Edition page 349 for more details 


global velocity_config;
global freq_config;


[Row,Col]=size(Profile);
for n=1:Col
 if Profile(1,n)<-90
  fprintf('Warning : Min profile angle of -90 Deg exceeded, set to -90 Deg\n');
  Profile(1,n)=-90;
 end
 if Profile(1,n)>90
  fprintf('Warning : Max profile angle of 90 Deg exceeded, set to 90 Deg\n');
  Profile(1,n)=90;
 end
end


fprintf('Calculating Fourier coefficients\n');

lambda=velocity_config/freq_config;
k=2*pi/lambda;

AngDeg=Profile(1,:);
PwrdB=Profile(2,:);

AngRad=AngDeg*pi/180;
LinVolt=10.^(PwrdB./20);

ThetaMin=-90;
ThetaStep=1;
ThetaMax=90;

Theta=ThetaMin:ThetaStep:ThetaMax;
FnVal=zeros(size(Theta))+1e-9;
FnValdB=zeros(size(Theta))-99;

% Use the profile data points to generate a target farfield
% pattern function, defined over Theta=-90:1:90

for n=1:1:(Col-1)
 x1=AngDeg(1,n);
 x2=AngDeg(1,n+1);
 y1=PwrdB(1,n);
 y2=PwrdB(1,n+1);
 Grad=(y2-y1)/((x2-x1)+1e-9);
 for x=x1:1:x2
  index=round(x+91);  
   FnValdB(1,index)=(x-x1)*Grad+y1;
 end
end


FnVal=10.^(FnValdB./20);
Lin_Volts=zeros(1,N);
An=zeros(1,N);


% Perform the fourier transform

n=-(N-1)/2;                      % Set up n so that element position (n*Dx)  
for ele=1:N                      % will be symmetric about the boresight.
 index=1;
 for th=ThetaMin:ThetaStep:ThetaMax
  du=cos(th*pi/180)*ThetaStep;
  AnVal=FnVal(1,index)*exp(-j*k*n*Dx*sin(th*pi/180))*du; 
  An(1,ele)=An(1,ele)+AnVal;     % Summation
  index=index+1; 
 end
 n=n+1;
 An(1,ele)=An(1,ele)*(1/(2*pi)); % Scale the coefficients
end



AnMag=abs(An);                   % Amplitude of coefficients
AnPha=angle(An);                 % Phase of coefficients
AnLINAMPnorm=AnMag./max(AnMag);

Lin_Volts=[AnLINAMPnorm]';
Phase_Rad=[AnPha]';
FnValdB=20*log10(FnVal);                

