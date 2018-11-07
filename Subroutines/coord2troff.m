function [rotoff]=coord2troff(xyz1,xyz2)
% Calculate rotation and offset matricies using a set of 4 points
% known in both coordinate systems
% 
% Usage: [rotoff]=coord2troff(xyz1,xyz2)
%
% xyz1.......Matrix [3,4] giving 4 points in 1st coord system
% xyz2.......Matrix [3,4] giving 4 points in 2nd coord system
% rotoff.....Rotation and offset matrix
% 
%                                     
% [xyz1] and [xyz2] are of dimensions (3,4) : x1 x2 x3 x4
%                                             y1 y2 y3 y4
%                                             z1 z2 z3 z4 
%
% rotoff is of dimensions (3,4) as below :
%
%                    /------- 3x3 rotation matrix
%                   /    /--- 3x1 offset matrix
%                  /    /  
%               ----- ---- 
%               L M N Xoff 
%   3x4 matrix  O P Q Yoff 
%               R S T Zoff 
%
%

xyz1=xyz1';
xyz2=xyz2';

Q=[xyz1,ones(4,1)];

X1=zeros(4,1);
X2=zeros(4,1);
X3=zeros(4,1);
X4=zeros(4,1);

% Solve for L,M,N and Xoff
P1=xyz2(1:4,1);
X1=Q\P1;

% Solve for O,P,Q and Yoff
P2=xyz2(1:4,2);
X2=Q\P2;

% Solve for R,S,T and Zoff
P3=xyz2(1:4,3);
X3=Q\P3;

Result=[X1';X2';X3'];

Trot=Result(1:3,1:3);
Toff=Result(1:3,4);

rotoff=[Trot,Toff];


