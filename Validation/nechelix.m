function []=necplot(file,Nturns)
%
% Post processing for '.nou' Nec output files 
% and is designed to be used on any specified .nou file.
%
% Usage   : necplot('filename',Nturns)
%
% Note    : filename does not require path or extension as these are defined
%           in variables 'filepath' and 'extension' in this function 
%           (they can of course be changed)
% 
% Example : To process file 'C:\4nec2\out\antenna1.nou' 
%           Set filepath to 'C:\4nec2\out\' (See first 3 variables in this function)
%           Set extension to '.nou'         (See first 3 variables in this function)
%
%           At the command prompt type : necplot('antenna1')

SegsPerTurn=18
Nsegs=Nturns*SegsPerTurn;




% Initialise global variables

global F                   % ASCII array variable for incomming DXF file
global count               % Pointer to location in ASCII array (incremented as array is searched using dxf2nec_strings)
global file_size           % Size of ASCII array F
global nlines              % Total number of wires 
global xyz                 % Matrix of output data in form : [TagNo Nseg X1 Y1 Z1 X2 Y2 Z2 Wrad], one row for each wire.  


%*******************************
Zo=50;
filepath='c:\4nec2\out\';
extension='.out';

%filepath='c:\NEC-PRO\examples\';
%extension='.nou';
%*******************************




postproc_filename=[filepath,file,extension];


% Initialise and read files

fid_in=fopen(postproc_filename,'r');

if fid_in==-1
   fprintf('\n File Not Found :   %s   \n',postproc_filename);
   break
end

F=fread(fid_in);                                     % Load the file as an ASCII array F
fclose(fid_in);                                      % Close input file channel
F=F';
[Rows,Cols]=size(F);                                 % Cols is the number of chrs in the file
file_size=Cols;   



count=0;                                                     % Init counter to read thru ASCII file
Nfreqs=0;                                                    % Init counter for number of Frequencies
Nsource=0;                                                   % Number of sources



% ****************************************************
% ********* Find out how many sources there are ******
% ****************************************************

 S_FRQ='***** DATA';                                 % Define search string '***** DATA'
 P_FRQ=findstr(F,S_FRQ);                             % Find occurances of '***** DATA' in ASCII array F. 
                                                     % P_FRQ is an array of pointers to the letter 'D' in '***** DATA'
 [Row,Col]=size(P_FRQ);
 Nfreqs=Col;                                         % Cols is the number of frequencies
 for x=1:Nfreqs                                      % Loop through the array of pointers to the letter 'D'
    st_ptr=P_FRQ(1,x)+21;                            % Define a start pointer, offset to the beginning of the numeric value
    end_ptr=st_ptr+107;                              % Define an end pointer offset to the end of the numeric value
    %Freq(1,x)=str2num(char(F(1,st_ptr:end_ptr)));   % Extract the numeric value and pop it in an array called Freq
    A=sscanf(setstr(F(1,st_ptr:end_ptr)),'%f %s %i %i %i %i %f %f %f %f %f %f');
    A=A';
    if char(A(1,2:3))=='EX'                          % Look for occurances of the 'EX' excitation card
       Nsource=Nsource+1;
    end   
 end
Nsource;
fprintf('\n %g Source(s) Found\n',Nsource);


% ****************************************************
% ***** Find out which Frequencies were analysed *****
% ****************************************************


S_FRQ='FREQUENCY=';                                          % Define search string 'FREQUENCY='
P_FRQ=findstr(F,S_FRQ);                                      % Find occurances of 'FREQUENCY=' in ASCII array F. 
                                                             % P_FRQ is an array of pointers to the letter 'F' in 'FREQUENCY='
[Row,Col]=size(P_FRQ);
Nfreqs=Col;                                                  % Cols is the number of frequencies
for x=1:Nfreqs                                               % Loop through the array of pointers to the letter 'F'
   st_ptr=P_FRQ(1,x)+10;                                     % Define a start pointer, offset to the beginning of the numeric value
   end_ptr=st_ptr+11;                                        % Define an end pointer offset to the end of the numeric value
   Freq(1,x)=sscanf(setstr(F(1,st_ptr:end_ptr)),'%f');       % Extract the numeric value and pop it in an array called Freq

end

fprintf(' START Frequency %g MHz\n',Freq(1,1));
fprintf(' STOP  Frequency %g MHz\n',Freq(1,Nfreqs));
fprintf(' Number Of Frequencies : %g \n',Nfreqs);

% ****************************************************
% ******** Extract the Antenna Input Parameters ******
% ****************************************************


S_FRQ='ANTENNA INPUT PARAMETERS';                            % Define search string 'ANTENNA INPUT PARAMETERS'
P_FRQ=findstr(F,S_FRQ);                                      % Find occurances of 'ANTENNA INPUT PARAMETERS' in ASCII array F. 
                                                             % P_FRQ is an array of pointers to the letter 'A' in 'ANTENNA INPUT PARAMETERS'


source_step_ptr=0;                                                             
for y=1:Nsource                                              % Cycle through for each source
  ReImZ=[]; 
  [Row,Col]=size(P_FRQ);
  Nfreqs=Col;                                                  % Col is the number of frequencies
  for x=1:Nfreqs                                               % Loop through the array of pointers to the letter 'A'
     st_ptr=P_FRQ(1,x)+331+source_step_ptr;                    % Define a start pointer, offset to the beginning of the numeric value
     end_ptr=st_ptr+23;                                        % Define an end pointer offset to the end of the numeric value
     ReImZ(:,x)=sscanf(setstr(F(1,st_ptr:end_ptr)),'%f%f');    % Extract the numeric value and pop it in an array called ReImZ
     %setstr(F(1,st_ptr:end_ptr))
  end

  Zin=ReImZ(1,:)+j.*ReImZ(2,:);
  %Z(y,:)=trl(Zo,Zin,0,Freq,1.0,0);  
  Z(y,:)=Zin;
  source_step_ptr=source_step_ptr+122;                         % Increment pointer to read impedances on next line of 'ANTENNA INPUT PARAMETERS'
end                                                            % End y-loop (Number of 'EX' source cards)


% ****************************************************
% ******** Extract the Output Segment Currents  ******
% ****************************************************


S_FRQ='CURRENTS AND LOCATION';                               % Define search string 'CURRENTS AND LOCATION'
P_FRQ=findstr(F,S_FRQ);                                      % Find occurances of 'CURRENTS AND LOCATION' in ASCII array F. 
                                                             % P_FRQ is an array of pointers to the letter 'C' in 'CURRENTS AND LOCATION'
ISmag=ones(1,Nsegs); 
ISpha=ones(1,Nsegs);
                                                            
if ~isempty(P_FRQ);                                          % Extract currents if any have been found                                                             
   fprintf(' Output Segment Found\n');
   source_step_ptr=0;                                                             
      for x=1:Nsegs                                          % Loop through the array of pointers to the letter 'C'      
      st_ptr=P_FRQ(1,1)+273+source_step_ptr;                 % Define a start pointer, offset to the beginning of the numeric value
      end_ptr=st_ptr+95;
      Tcurrent=setstr(F(st_ptr:end_ptr));                                        % Define an end pointer offset to the end of the numeric value
      C1=sscanf(Tcurrent,'%f%f%f%f%f%f%f%f%f%f');  % Extract the numeric value and pop it in an array called Current
      Current=C1';
      ISmag(1,x)=Current(1,9);
      ISpha(1,x)=Current(1,10);
      source_step_ptr=source_step_ptr+95;
   end
end 

Seg=1:1:Nsegs;

ORDtotPhase=Nturns*0.2495*2*pi;
HWtotPhase=ORDtotPhase+pi;
HWplot=0:(HWtotPhase/(Nsegs-1)):HWtotPhase;
HWplot=-HWplot*180/pi;
HWplot=mod((HWplot+180),360)-180;

MkrX=1:SegsPerTurn:Nsegs;
MkrMag=ISmag(1:SegsPerTurn:Nsegs);
MkrPha=ISpha(1:SegsPerTurn:Nsegs);

figure(1)
subplot(2,1,1),plot(Seg,ISmag,MkrX,MkrMag,'k+');
subplot(2,1,2),plot(Seg,ISpha,MkrX,MkrPha,'k+',Seg,HWplot,'r');
diff(unwrap(MkrPha*pi/180))*180/pi

