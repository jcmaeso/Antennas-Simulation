% The files and what they do :
%
% HrTimer......High resolution timer, 
%              returns elapsed time in seconds (microsecond resolution).
%              Must be Win98/Dos/Linux and Pentium class processor.
%
% ServoTest1...Uses HrTimer and outputs Pulse Width Modulated signal on selected
%              parallel port data line (0-7). User may vary pulse width from 1-2ms.
%              Pulse repetition rate is 20ms, can be changed in the basic program.
%              Run ServoTest1.exe with no arguments for details.
%
% ServoDrive1..Uses HrTimer and drives servo to obtain specified phase-delay angle. 
%              User supplies, via command line call:  
%              (angle) (number of pulses) (channel) (C1,C2,C3)
%              Run ServoDrive1.exe with no arguments for details.
%
% ServoPulse1..Uses HrTimer and outputs a series of pulses, number and width specified
%              by the user in the command line.
%              Run ServoPulse1.exe with no arguments for details.