function polplot(polang,pwrdBn,mindB,linestyle,linewidth1,linewidth2);
% Plots pattern data in polar form onto polar axis set. 
%
% Usage: polplot(polang,pwrdBn,mindB,linestyle,linewidth1,linewidth2);
% 
% polang......Polar angle on polar chart in (degrees) 
% pwrdBn......Normalised pattern data (dB)
% mindB.......Minimum dB value to be displayed (dB)
%
% linestyle...Standard Matlab definition (string)
% linewidth1..Standard linewidth control string (string)
% linewidth2..Standard linewidth (integer)
%
% e.g. polplot(theta,pwrdB1,-40,'r-','linewidth',2);
% e.g. polplot(phi,pwrdB2,-40,'b-','linewidth',2);
%

% Take care of data in column or row vector format
[row,col]=size(polang);
if col>row
   polang=polang';
end

[row,col]=size(pwrdBn);
if col>row
   pwrdBn=pwrdBn';
end

xdata=polang;                    % Angle in degrees 
ydata=pwrdBn;                    % Normalised data in dB
rmin=mindB;                      % Minimum dB value to be displayed

[Ndpts,dummy]=size(xdata);       % Find number of points to be plotted

hold on;

% ****************************** Polar Trace Plotting Routine *******************
  for k=1:(Ndpts-1),  
   x1=xdata(k,1);
   y1=ydata(k,1);
   r1=(y1-rmin);
    if r1<=0,                           % If radius value of data point is less than
     r1=0;                              % min plot radius set value to 0
    end 
   t1=(x1-90).*pi./180;                 % Calc theta in radians and rotate plot by 90Deg
   xp1=r1.*cos(-t1);                    % Xcoord point 1
   yp1=r1.*sin(-t1);                    % Ycoord point 1
   
   x2=xdata((k+1),1);
   y2=ydata((k+1),1);  
   r2=(y2-rmin);                        % If radius value of data point is less than 
    if r2<=0,                           % min plot radius set value to 0
     r2=0;
    end
    t2=(x2-90).*pi./180;                % Calc theta in radian and rotate plot 90Deg
   xp2=r2.*cos(-t2);                    % Xcoord point 2
   yp2=r2.*sin(-t2);                    % Ycoord point 2
                                            
   plot([xp1,xp2],[yp1,yp2],linestyle,linewidth1,linewidth2); 
  end
