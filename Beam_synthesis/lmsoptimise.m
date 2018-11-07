function lmsoptimise(SAngle,IAngle,mu)
% Signal to noise optimisation for array defined in array_config. 
%
% The desired signal direction is supplied in Sangle, the directions
% of the interferers are supplied in Iangle
%
% The initial phase/amp weightings are assumed to be those already
% defined in the array_config matrix. After running array_config
% contains the optimised phase/amp values.
%
% Usage : lmsoptimise(SAngle,IAngle,mu)
%
% Sangle....Direction of desired signal of form : Sangle=[theta,phi] 
% Iangle....Direction of interferers of form : Iangle=[theta1,phi1; theta2,phi2; etc]
% mu........Step size for optimisation.  0.01 is a good value for planar arrays
%
% Example : For a desired signal direction of theta=60, phi=0 and
%           interferers at theta=30, phi=0 and theta=-10, phi=0 use.
%
%           lmsoptimise([60,0], [30,0; -10,0], 0.01);
%        

global array_config;
global freq_config;
global velocity_config;

lambda=velocity_config/freq_config;
k=2*pi/lambda;


[SNumber,unused] = size(SAngle);
[INumber,unused] = size(IAngle);

[Trow,Tcol,N]=size(array_config);    % Number of elements in array N


wInit = ones(N,1);                   %Initial weights (ones)


% Vector 'Signal'
global vS;	vS = [];
for i = 1 : SNumber
    vS = [vS, lmsav(SAngle(i,1),SAngle(i,2))];
end


% Vector 'Interferer'
global vI; vI = [];
for i = 1 : INumber
    vI = [vI, lmsav(IAngle(i,1),IAngle(i,2))];
end


% Desired Signal & Interferers definition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = 1E-3;                                 % T = 1ms
t = (1:100)*T/100;
S = cos(2*pi*t/T);                        % Desired signal
for i = 1 : INumber                       % Generate an interferer signal for each interference angle
    I(i,:) = randn(1,100);                % Interferers signal
end 




it = 1:200;                   % Iterations

% Solve for Weights using LMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = zeros(N,1);               % Initialize weights (with zeros)
snr = 10;                     % Signal to noise ratio
X = (vS*S+vI*I);              % Array input without noise
Rx = X*X';                    % Array correlation matrix


wi = zeros(N,max(it));
for n = 1:length(S)
    x = S(n)*vS + (I(:,n).'*vI')';    % To include several interferers
    y = w'*x;
    
    e = conj(S(n)) - y;               % Mean square error
    esave(n) = abs(e)^2;              % To plot mean square error history
    w = w+mu*conj(e)*x;
    wi(:,n) = w;
    yy(n) = y;
    
end
w = (w./w(1));                        % Normalize results to first weight

for n=1:N
 array_config(1,5,n)=abs(w(n,1));
 array_config(2,5,n)=angle(w(n,1));
end

figure(20);
plot(esave);
title('Mean square error history');
chartname=sprintf('Error history');
set(20,'name',chartname);
