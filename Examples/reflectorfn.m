% Surface function used by ArrayCalc example exparabpol
% The +ve z-axis is looking from the focus towards the reflector.
% The +ve y axis is vertical
% The +ve x-axis to the left
% Axis origin is at the the focal point F

function z = reflectorfn(x,y,F)

% Surface function z(x,y,F)
z=(x^2+y^2)/(4*F);

% Account for reflector axis orientation and origin

z=-z+F;


