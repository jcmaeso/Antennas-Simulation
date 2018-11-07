function [name]=namecode(Elt)
% Returns element name assignment for use in the array_config variable.
%
% Usage: [name]=namecode(Elt)
%
% Elt....Element type (numeric)
%
% Returned value:
%
% name.......Element name (string)
%
     

switch Elt                % Assign numeric code for element type
 case 0,name='iso';
 case 1,name='patchr';
 case 2,name='patchc'; 
 case 3,name='dipole';
 case 4,name='dipoleg';
 case 5,name='helix';
 case 6,name='aprect';
 case 7,name='apcirc';
 case 8,name='wgr';
 case 9,name='wgc';
 case 10,name='dish';
 case 11,name='interp';
 case 12,name='user1'; 
 otherwise, disp('Unknown Element Type, set to iso');Elt=0;
end