function movec_array(x,y,z,elstart,elfinish)
% Translate and copy array geometry in x,y,z, new elements
% are added onto the end of array_config.
%
% Usage: movec_array(x,y,z,elstart,elfinish)
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
% e.g. movec_array(0.5,0,0,2,4) % Copy elements 2 to 4 and move them
%                               % 0.5m along the X-axis

global array_config;

New_Toff=[x;y;z];

[Trow,Tcol,N]=size(array_config); % Number of elements in array N

if elfinish>N
 elfinish=N;
end

if elstart<1
 elstart=1;
end

fprintf('Translate-copy elements %i to %i by dX=%3.2f, dX=%3.2f, dZ=%3.2f (m)\n',...
         elstart,elfinish,x,y,z);

newn=N+1;

for n=elstart:1:elfinish
 array_config(1:3,1:3,newn)=array_config(1:3,1:3,n);       % Duplicate rotation matrix for new elements
 array_config(1:3,4,newn)=array_config(1:3,4,n)+New_Toff;  % Add x,y,z movement for new elements
 array_config(1:3,5,newn)=array_config(1:3,5,n);           % Duplicate excitations and element name
 newn=newn+1;
end


