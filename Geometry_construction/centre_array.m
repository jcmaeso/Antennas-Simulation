function centre_array()
% Moves entire array such that the average distance of all the elements
% from the centre of the array is zero.
%
% Usage: centre_array

global array_config;

[Trow,Tcol,N]=size(array_config); % Number of elements in array N

xcen=0;
ycen=0;
zcen=0;

xcen=mean(array_config(1,4,1:N));
ycen=mean(array_config(2,4,1:N));
zcen=mean(array_config(3,4,1:N));

move_array(-xcen,-ycen,-zcen,1,N);