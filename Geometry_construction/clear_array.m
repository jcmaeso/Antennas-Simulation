function clear_array()
% Re-initialises the array_config matrix, clearing all existing elements.
% All other variables remain un-changed.
%
% Usage: clear_array

global array_config;

array_config=-ones(3,5,1);

fprintf('Array configuration cleared\n');