function plegend(xsc,ysc,linetype,label)

% Put a single legend line on a plot at specified screen co-ordinates
%
% Usage: plegend(xsc,ysc,linetype,label)
%
% xsc........X screen coordinate
% ysc........Y screen coordinate
% linetype...Standard MATLAB definition (string)
% label......Text label (string)
%  
% Screen coords : (0,1)     (1,1)
% 
%
%                 (0,0)     (1,0)
%
% Vertical spacing for successive lines is typically 0.03
%
% e.g. plegend(0.8,0.2,'b-','Phi=0 Cut')   % (0.85,0.25) is a good position for
%      plegend(0.8,0.2,'r-','Phi=90 Cut')  % polar plot legend.

hold on;
plotsc((xsc),(ysc),(xsc+0.05),(ysc),linetype); % Plot short section of line
textsc((xsc+0.06),ysc,label);                  % Print text

