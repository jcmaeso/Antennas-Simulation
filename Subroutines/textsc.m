function textsc(x,y,txt);
% Places text at screen coords
% Lower Left (0,0)
% Upper Right (1,1);
%
% Usage : textsc(x,y,'text');
%
%  e.g.   plot(x,y);
%         textsc(0.8,0.5,'text');

% N. Tucker 23/12/97

ax=axis;
xpos=(1.18).*x.*(ax(2)-ax(1))+ax(1);
ypos=y.*(ax(4)-ax(3))+ax(3);
text(xpos,ypos,txt);
