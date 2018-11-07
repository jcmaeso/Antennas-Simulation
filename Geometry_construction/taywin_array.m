function taywin_array(R,xyr);
% Adjusts amplitude excitations for each element in the array,
% (as stored in array_config) to give monotonically decreasing 
% sidelobe levels. Uses modified Taylor distribution.
%
% Usage : taywin_array(R,xyr)
%
% R....Sidlobe level for 1st sidlobe (dB)
% xyr..Windowing direction (string)
%   
%      xyr = 'x'  to apply window along X-axis 
%      xyr = 'y'  to apply window along Y-axis
%      xyr = 'xy' to apply window along x and y-axis
%
%      xyr = 'r'  to apply window as a function of distance from
%                 the centre of the array. Use for circular arrays
%                 or to window in x & y for rectangular arrays
%
% Note :- For a uniform distribution the 1st sidlobe is already 
%         13.2dB down, R should specify a value greater than this.
%
%         Also the distribution assumes isotropic sources, element
%         directivity can further reduce sidelobe levels.
%
% e.g.    taywin_array(20,'x')  % For -20dB 1st sidelobe taper in x-direction       
                                    


% Calculation of modified Taylor distribution for monotonically decreasing
% sidelobe levels. Ref JASIK 20-9  / 2-27 (1st edition 1961)
%
% N  = Number of elements in whole array
%
% R  = Sidelobe ratio dB
%
% d  = Distance measured from centre of aperture
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

% N.Tucker www.activefrance.com 2008

global array_config;


L=2; % Total aperture length in units (dimensionless)

[Trow,Tcol,N]=size(array_config); % Number of elements in array N

xcen=mean(array_config(1,4,1:N));
ycen=mean(array_config(2,4,1:N));
zcen=mean(array_config(3,4,1:N));

Xc=array_config(1,4,1:N)-xcen;
Yc=array_config(2,4,1:N)-ycen;
Zc=array_config(3,4,1:N)-zcen;

xmin=min(Xc);
ymin=min(Yc);
zmin=min(Zc);

xmax=max(Xc);
ymax=max(Yc);
zmax=max(Zc);

Radius=sqrt(Xc.^2+Yc.^2+Zc.^2);
rmax=max(Radius);


xdiff=max(diff(Xc));
ydiff=max(diff(Yc));
zdiff=max(diff(Zc));
rdiff=sqrt(xdiff^2+ydiff^2);

if xdiff>0
 SFx=L/((xmax-xmin)+xdiff);
else
 SFx=1;
end

if ydiff>0 
 SFy=L/((ymax-ymin)+ydiff);
else
 SFy=1;
end

SFr=L/((2*rmax)+rdiff);

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

for n=1:N
  dx=abs(Xc(1,n).*SFx);
  dy=abs(Yc(1,n).*SFy);
  dr=abs(Radius(1,n).*SFr);

  LinAmpx(1,n)=(1./(2.*pi)).*besselj(0,(j.*pi.*B.*sqrt(1-dx.^2)));
  LinAmpy(1,n)=(1./(2.*pi)).*besselj(0,(j.*pi.*B.*sqrt(1-dy.^2)));
  LinAmpr(1,n)=(1./(2.*pi)).*besselj(0,(j.*pi.*B.*sqrt(1-dr.^2)));

end

LinAmpNormx=LinAmpx./max(LinAmpx);
LinAmpNormy=LinAmpy./max(LinAmpy);
LinAmpNormr=LinAmpr./max(LinAmpr);

xyr_found=0;
for n=1:N  
  if strcmp(xyr,'x')
   array_config(1,5,n)=LinAmpNormx(1,n);
   xyr_found=1;
  end
  
  if strcmp(xyr,'y')
   array_config(1,5,n)=LinAmpNormy(1,n);
   xyr_found=1;
  end

  if strcmp(xyr,'xy')
   array_config(1,5,n)=(LinAmpNormx(1,n).*LinAmpNormy(1,n));
   xyr_found=1;
  end

  if strcmp(xyr,'r')
   array_config(1,5,n)=LinAmpNormr(1,n);
   xyr_found=1;
  end
end

if xyr_found==0
 fprintf('Warning, no valid windowing direction found use "x", "y" , "xy"  or "r"\n');
 fprintf('No apmlitude distribution applied.\n');
else
 fprintf('\nTaylor window applied for %3.1fdB SL as function of %s\n',R,xyr);
end

