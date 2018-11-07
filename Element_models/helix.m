function [Etot,CPflag]=helix(theta,phi)
% Calculates total E-field pattern for N-turn helix as a function
% of theta and phi (in radians).
%
% Usage: [Etot,CPflag]=helix(theta,phi)
%
% Helix parameters N and S are defined in global vector helix_config
% initialised in init.m and is of format :
%
% helix_config=[N,S]
%
% N.....Number of turns (integer)
% S.....Turn Spacing (m)
%
% The circumference C(m) is not supplied because this is
% implied by critera for axial mode operation of the helix.
%
% Model gives a good approximation assuming the following conditions 
% for an actual helix design :
%
% Number of turns, N > 3
% Ratio of S/C  = 0.2217  (helix pitch angle of 12.5 Deg)
% C is set = (1.2)*Lambda
%
% For example at a frequency of 300MHz, good values would be :
% N=6
% S=0.264 (m)
%
% Reference C.A. Balanis 2nd Edition page 510


global freq_config;
global helix_config;
global velocity_config;

vo=velocity_config;
lambda=vo/freq_config;
ko=2*pi/lambda;

% Helix parameters
N=helix_config(1,1);  % Number of turns
S=helix_config(1,2);  % Turn spacing (m)
C=1.2*lambda;         % Turn circumference (m)
Lo=sqrt(C^2+S^2);     % Turn length (m)

% Ordinary endfire condition, value of p
% **************************************
%p=(Lo/lambda)/(S/lambda+1);
%
%psi=ko*(S*cos(theta)-(Lo/p));
%
%F1=sin(pi/(2*N))*cos(theta);
%F2=sin((N/2)*psi)/sin(psi/2);
%
%Eord=F1*F2;


% Hansen-Woodyard increased directivity condition, value of p
% ***********************************************************
p=(Lo/lambda)/(S/lambda+((2*N+1)/(2*N)));

psi=ko*(S*cos(theta)-(Lo/p));

F1=sin(pi/(2*N))*cos(theta);
F2=sin((N/2)*psi)/sin(psi/2);

Ehan=abs(F1*F2);

% Due to groundplane function is only valid for 
% theta values :   0 < theta < 90   for all phi
%
% SSF is a sidelobe scaling factor, raising the 
% sidelobe levels as the square of theta to a 
% maximum of SSF(dB) above the standard value at theta = +/-(pi)
% Typical values of SSF are around 15dB give good agreement with
% NEC models and measured results. 

SSF=15;                    % Sidlobe scaling factor dB

F3=(10^(SSF/20)-1)/(pi^2); % Intermediate calc 
SF=(F3*theta.^2)+1;        % Factor by which to multiply standard pattern

UNF=1;                     % Unity normalisation factor for element pattern

if theta <= pi/2
 Etot=Ehan*SF*UNF;         % Etot=Ehan or Etot=Eord here
else Etot=0;
end
CPflag=1;                  % RHCP, use CPflag=-1 for LHCP