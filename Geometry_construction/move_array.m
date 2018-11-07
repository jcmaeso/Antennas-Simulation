function move_array(x,y,z,elstart,elfinish)
% Move array geometry in x,y,z, movement is relative to the 
% current location. 
%
% Usage: move_array(x,y,z,elstart,elfinish)
%
% x....X movement (m)
% y....Y movement (m)
% z....Z movement (m)
%
% elstart...Start element number (1 to N) where N 
%           is the number of elements in the array
%
% elfinish..Finish element number (1 to N) where N
%           is the number of elements in the array.
%           For elfinish>N, elfinish is set equal to N
%
% e.g. move_array(0.1,0,0,1,4)   % Move 4-element array 0.1m along +ve X-axis

global array_config;

Toff=[x;y;z];

[Trow,Tcol,N]=size(array_config); % Number of elements in array N

if elfinish>N
 elfinish=N;
end

if elstart<1
 elstart=1;
end

fprintf('Elements %i to %i moved : dX=%3.4f, dY=%3.4f, dZ=%3.4f (m)\n',...
         elstart,elfinish,x,y,z);


for n=elstart:1:elfinish
 array_config(1:3,4,n)=array_config(1:3,4,n)+Toff;
end
