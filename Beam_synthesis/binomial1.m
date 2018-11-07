function [Lin_Volts,dB_POWER] = binomial1(N);
% Calculation of Binomial distribution for zero power
% sidelobes. 
%
% Usage : [Lin_Volts,dB_POWER]=binomial1(N)
%
% N....Number of elements in array

pas=fliplr(abs(pascal(N,1)));
An=pas(N,:);

AnLINAMPnorm=An./max(An);
Lin_Volts=[AnLINAMPnorm]';
dB_POWER=20.*log10(Lin_Volts);