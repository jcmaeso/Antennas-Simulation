function polaxis(rmin,rmax,rstep,astep);
%
% Draw set of polar axis. 
%
% Usage : polaxis(rmin,rmax,rstep,astep);
%
%         rmin  - Polar axis centre threshold
%         rmax  - Maximum polar radius value
%         rstep - Radius increment
%         astep - Radial increment (degrees)
%
% Example : polaxis(-40,0,5,15)
%           
%      Any value less than or equal to -40 should be plotted at the centre.
%      Concentric circles for -40 -30 -20 -10 0 10  and 20.          
%      Radial lines at 36 degree increments.
%
% The file circ.m is required to run this module.

% N. Tucker 7/1/98

mrad=(rmax-rmin);
ncircs=round(mrad./rstep);
nradial=round(360./astep);
astep=360./nradial;

hold off;
clf;
axis([-mrad mrad -mrad mrad]);  % Set cartesian axis
axis('square');
axis off;
hold on;

for rangle=0:5:360               % Plot minor radials (every 5 Deg)
 mrad1=mrad-((ncircs-2).*rstep);
 
 rx1=mrad1.*sin(rangle.*pi./180);
 ry1=mrad1.*cos(rangle.*pi./180);

 rx2=mrad.*sin(rangle.*pi./180);
 ry2=mrad.*cos(rangle.*pi./180);
 
 plot([rx1,rx2],[ry1,ry2],'color',[0.7,0.7,0.7]);
end

for i=1:ncircs,                  % Plot circles and label them
 circ(mrad-((i-1).*rstep),'k-');                   
 S=sprintf('%g',(rmax-((i-1).*rstep)));
 rx=0;
 ry=mrad-(i-1).*rstep;
 xoff=mrad.*0.005;
 yoff=-mrad.*0.035;
 text(rx+xoff,ry+yoff,S);
end;

for i=1:nradial,                 % Plot main radials and label them
 rangle=i.*astep;
 mrad1=mrad-((ncircs-1).*rstep);
 
 rx1=mrad1.*sin(rangle.*pi./180);
 ry1=mrad1.*cos(rangle.*pi./180);

 rx2=mrad.*sin(rangle.*pi./180);
 ry2=mrad.*cos(rangle.*pi./180);
 if mod(rangle,90)>0
  plot([rx1,rx2],[ry1,ry2],'k-');
 else
  plot([0,rx2],[0,ry2],'k-');
 end

 if rangle>=180
  S=sprintf('%g',-(360-rangle));
 else
  S=sprintf('%g',rangle);
 end
 xoff=rx2.*0.085-(0.07.*mrad);
 yoff=ry2.*0.06;
 text(rx2+xoff,ry2+yoff,S);
end

set(gcf,'color',[1,1,1]);