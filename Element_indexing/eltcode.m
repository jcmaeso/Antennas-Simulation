function [Elt]=eltcode(eltype)
% Returns element code assignment for use in the array_config variable.
%
% Usage: [Elt]=eltcode(eltype)
%
% eltype....Element type (string)
%
% Returned value:
%
% Elt.......Element code (integer)
%


switch eltype                % Assign numeric code for element type
 case 'iso',    Elt=0;
 case 'patchr', Elt=1;
 case 'patchc', Elt=2; 
 case 'dipole', Elt=3;
 case 'dipoleg',Elt=4;
 case 'helix',  Elt=5;
 case 'aprect', Elt=6;
 case 'apcirc', Elt=7;
 case 'wgr',    Elt=8; 
 case 'wgc',    Elt=9;
 case 'dish',   Elt=10;
 case 'interp', Elt=11;
 case 'user1',  Elt=12; 
 otherwise, disp('Unknown Element Type, set to iso');Elt=0;
end

