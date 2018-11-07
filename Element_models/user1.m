function [Etot,CPflag]=user1(theta_in,phi_in)
% Calculates total E-field pattern for user element as a function
% of theta and phi.
%
% Usage: [Etot,CPflag]=user1(theta,phi)


global freq_config;
global user1_config;
global velocity_config;

% parameter1=user1_config(1,1);
% parameter2=user1_config(1,2);

% Etot= your function of theta_in and phi_in


if theta_in <= pi/2
  Etot=1;      % Default is half hemispherical
else Etot=1e-9;
end;

CPflag=1; % Set CPflag so that VP and HP field-components are -3dB w.r.t Total field
