% Normalise array excitations to unity.
%
% Rescale the linear amplitudes of the element excitations such
% that they sum to unity, the relative power levels remain un-changed.
%
% This should be run before plot_field_slice is used if you require
% absolute field levels to be calculated. It is a normal procedure
% when using full-wave solvers such as NEC2, HFSS etc
%
% For example : If you had an array of two dipoles each excited (0dB,0deg) => (1volt,0deg) in linear form. 
%               After running norm_array each excitation would be (-6.02dB,0deg) => (0.5volt,0deg) in linear form.
%               So the total linear voltage excitation for the array is 1volt.
%
% This is so that the total power into the array is distributed among the array elements, as it would be
% in a passive feed network. 
%
% An exception to this is if each element has its own Tx/Rx module. In this case The total power into
% the array is the sum of all the excitation levels. Of course the linear values have to represent the 
% actual Tx power levels if the field results are to be accurate.
%
% See section7 of the 'Introduction to Phased Array Design' in the additional documentation.
 

global array_config

[Trow,Tcol,N]=size(array_config);         % Number of elements in array N

TotLin=0;                                 % Total of linear voltage excitation voltages

for ele=1:N
   TotLin=TotLin+array_config(1,5,ele);   % Add up the linear voltage excitation voltages
end   

if TotLin>0
  for ele=1:N
    array_config(1,5,ele)=array_config(1,5,ele)/TotLin; % Normalise
  end 
fprintf('\nArray excitations normalised to 1 (linear form)\n');
else
fprintf('\nArray un-modified no element excitations found!\n');
end   