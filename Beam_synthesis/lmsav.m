function [ArrayVector]=lmsav(theta,phi)

% Calculate the array vector for the array using the squint_array function 
%
% Usage : [ArrayVector]=lmsav(theta,phi)
%
%       theta...radians (single value)
%       phi.....radians (single value)
%
%
% Returned Value :
%
%       ArrayVector...Complex (N,1) array weighting steering 
%                     the beam to direction (theta,phi)



global array_config;

[Trow,Tcol,N]=size(array_config);    % Number of elements in array N
ArrayVector=ones(N,1);
array_config_temp=array_config;      % Store a copy of the array_config matrix

squint_array(theta,phi,1);           % Calculate the array vector for (theta,pgi) direction
                                     % The result will be stored in the Amp/Phase part of array_config

% Retrieve the Amp/Pha data from array_config and store as Re/Im in ArrayVector
for n=1:N
 Emag=array_config(1,5,n);
 Epha=array_config(2,5,n);
 ArrayVector(n,1)=(Emag*cos(Epha)+Emag*sin(Epha)*i);
end

array_config=array_config_temp;      % Restore array_config to its original value