function circ(r,linetype)
% Draw circle radius r centred on (0,0)
% Usage : circ(r)
%
% e.g. circ(53.4);

% N. Tucker 21/1/98

theta=0:0.1:(2.*pi+0.1);
x=r.*cos(theta);
y=r.*sin(theta);
plot(x,y,linetype);
