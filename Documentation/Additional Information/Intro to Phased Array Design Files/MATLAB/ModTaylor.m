function [Lin_Volts,dB_POWER] = modtaylor(N,R);
% Calculation of modified Taylor distribution for monotonically decreasing
% sidelobe levels. Ref JASIK 20-9
%
% Usage : [Lin_Volts,dB_POWER]=modtaylor(N,B)
%
% N....Number of elements in array
% R....Sidelobe ratio of 1st sidelobe w.r.t. main beam (dB) 
%
% Valid range for R is : 15 < R < 60

% Calculation of modified Taylor distribution for monotonically decreasing
% sidelobe levels. Ref JASIK 20-9
%
% N  = number of elements in whole array
%
% x  = Distance measured from centre of aperture
% L  = Total length of aperture
% Jo = Zero-order Bessel function of first kind
% B  = Parameter that fixes ratio of R of main beam amplitude to amplitude
%      of first side lobe by R = 4.60333 sinh(pi.B)/pi.B  For B=0 the value
%      of R is simply 4.60333 (lin V) or 13.2dB (dB pwr) characteristic of
%      a uniform distribution.
%
%      1st Sidelobe ratio dB    Value of B
%             15                  0.355769
%             20                  0.738600
%             25                  1.022920
%             30                  1.276160
%             35                  1.513630
%             40                  1.741480
%
%  Note :- For an N source array of length 2 the spacing is 2/N not!
%          2/(N-1) i.e the end element is (2/N)/2 in from the end.
%

L=2; % Total aperture length in units (dimensionless)

% 6th order polynomial fit to give B as a function of sidlobe
% level R in dB

Cp6=-8.6865e-10;
Cp5=+2.3255183e-7;
Cp4=-2.519124552e-5;
Cp3=+1.41192273253e-3;
Cp2=-4.329667260471e-2;
Cp1=+7.3879146026700e-1;
Cp0=-4.66189278748759e-0;

B=Cp6*(R.^6)+Cp5*(R.^5)+Cp4*(R.^4)+Cp3*(R.^3)+Cp2*(R.^2)+Cp1*R+Cp0;

deltax=2/(N);
x1=(deltax/2-1:deltax:1-deltax/2);
[R,C]=size(x1);
J=1;
for I=1:C,
 if x1(1,I)>=0,
   x(1,J)=x1(1,I);
   J=J+1;
 end
end
x;
AxLINAMP=(1./(2.*pi)).*besselj(0,(j.*pi.*B.*sqrt(1-(2.*x./L).^2)));
AxLINAMPnorm=AxLINAMP./max(AxLINAMP);
Lin_Volts=[AxLINAMPnorm(N./2:-1:1) AxLINAMPnorm]';
dB_POWER=20.*log10(Lin_Volts);
