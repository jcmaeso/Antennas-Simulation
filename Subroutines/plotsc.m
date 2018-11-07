function plotsc(x1,y1,x2,y2,c);
% Draws line in colour c from (x1,y1) to (x2,y2)
% Lower Left (0,0)
% Upper Right (1,1);
%
% Usage : plotsc(x1,y1,x2,y2,'colour');
%
%    E.g. plotsc(0.3,0.4,0.6,0.8,'g')
%         

% N. Tucker 23/12/97

ax=axis;
xpos1=(1.18).*x1.*(ax(2)-ax(1))+ax(1);
ypos1=y1.*(ax(4)-ax(3))+ax(3);

xpos2=(1.18).*x2.*(ax(2)-ax(1))+ax(1);
ypos2=y2.*(ax(4)-ax(3))+ax(3);

hold on;
plot([xpos1,xpos2],[ypos1,ypos2],c,'linewidth',2);
hold off;
