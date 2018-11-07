function [Lin_Volts,dB_POWER] = chebwin1(M,R);
% Calculation of Chebyshev distribution for uniform
% sidelobe levels. 
%
% Usage : [Lin_Volts,dB_POWER]=chebwin1(M,R)
%
% M....Number of elements in array
% R....Sidelobe ratio of 1st sidelobe w.r.t. main beam (dB) 
%
% Valid range for R is : 15 < R < 60
%
% Reference RICK LYONS article on DSPrelated.com
% Gives the same results as the MATLAB signal
% processing function chebwin.m

Ro=10.^(R/20);
N=M-1;
a=cosh((1./N).*acosh(Ro));

m=0:1:(N-1);

Am=(a.*cos(pi.*m./N));

for i=1:N
 if abs(Am(1,i)) > 1
  Wm(1,i)=(-1).^(i-1).*cosh(N.*acosh(Am(1,i)));
 else
  Wm(1,i)=(-1).^(i-1).*cos(N.*acos(Am(1,i)));
 end
end

IWm=real(ifft(Wm,N));
IWo=IWm(1)/2;
IWm(1,M)=IWo;
IWm(1,1)=IWo;

AnLINAMPnorm=IWm./max(IWm);
Lin_Volts=[AnLINAMPnorm]';
dB_POWER=20.*log10(Lin_Volts);