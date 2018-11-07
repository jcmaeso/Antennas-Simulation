function [gcoords,gp_flag]=geocode(Elt)
% Returns element geometry coords and flag showing whether or not 
% it has a groundplane (for indication on geometry plots).
%
% Usage: [gcoords,gpflg]=geocode(Elt)
%
% Elt....Element type (numeric code)
%
% Returned value:
%
% gcoords.......Element geometry coordinates
% gpflag........Groundplane flag, just for indication 
%               on the geometry plot.
%


switch Elt                % Assign numeric code for element type
 case 0,[gcoords,gp_flag]=iso_geom;
 case 1,[gcoords,gp_flag]=patchr_geom;
 case 2,[gcoords,gp_flag]=patchc_geom;
 case 3,[gcoords,gp_flag]=dipole_geom; 
 case 4,[gcoords,gp_flag]=dipoleg_geom;
 case 5,[gcoords,gp_flag]=helix_geom;
 case 6,[gcoords,gp_flag]=aprect_geom;
 case 7,[gcoords,gp_flag]=apcirc_geom;
 case 8,[gcoords,gp_flag]=wgr_geom;
 case 9,[gcoords,gp_flag]=wgc_geom;
 case 10,[gcoords,gp_flag]=dish_geom;
 case 11,[gcoords,gp_flag]=interp_geom;
 case 12,[gcoords,gp_flag]=user1_geom;
 otherwise, disp('Unknown Element Geometry');gcoords=iso_geom;
end