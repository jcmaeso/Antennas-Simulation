function single_element(x,y,z,eltype,Amp,Pha)
% Place a single element in specific location, appended to
% the current array configuration. Default E-plane for the
% element is the X-axis.
%
% Usage: single_element(x,y,z,eltype,Pwr,Pha)
%
% x.......X-coordinate (meters)
% y.......Y-coordinate (meters)
% z.......Z-coordinate (meters)
% eltype..Element type (string)
% Pwr.....Power (volts^2 in dB)
% Pha.....Phase (Deg)
%
% Valid strings for eltype are listed below. 
%              STRING    VALUE IN array_config
%              'iso'             0
%              'patchr'          1
%              'patchc'          2
%              'dipole'          3
%              'dipoleg'         4
%              'helix'           5
%              'aprect'          6
%              'apcirc'          7
%              'wgr'             8
%              'wgc'             9
%              'dish'            10
%              'interp'          11
%              'user1'           12
%
%
% Use place_element to set orientation and element number.
%
% e.g. single_element(0,0,0,'patchr',-10,90)

% This function generates a global matrix variable :
% array_config(3,5,n)
%
% For each of n=1:N elements there is a 3x5 element
% matrix which defines the element's location, orientation
% excitation and type.
%
%                     /---------- 3x3 rotation matrix
%                    /    /------ 3x1 offset matrix
%                   /    /   /--- Amplitude,Phase,ElementType (1,2,3..)
%                  /    /   /
%               ----- ---- ---
%               L M N Xoff Amp
%   3x5 matrix  O P Q Yoff Pha
%               R S T Zoff Elt
%
% See Also : place_element  % Includes element orientation

global array_config;

n=0;
xr=0;
yr=0;
zr=0;

place_element(n,xr,yr,zr,x,y,z,eltype,Amp,Pha);
