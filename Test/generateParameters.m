function [] = generateParameters(name)
%Common Parameters
freq_config=7.804e9;        % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

patchr_config=design_patchr(3.43,1.6e-3,freq_config);

% Array Parameters

M=18;       % Number of elements in X-direction
N=22;       % Number of elements in Y-direction
T=M*N;     % Total number of circ-pol elements
xspc=0.5;  % Array spacing in the X-direction
yspc=0.5;  % Array spacing in the Y-direction

sll = 25;
%Calculate Row Taper
rwind = chebwin1(M, sll)';
rwind = repmat(rwind,N,1);
%Calculate Column Taper
sll = 25;
cwind = chebwin(N, sll)';
cwind = repmat(cwind.',1,M);
%Calculate taper
wind = 20*log10(rwind.*cwind);
save(name,'xspc','yspc','lambda','wind','M','N');
end

