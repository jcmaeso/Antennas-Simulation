
#include "hrtimer.bas"


DIM AS SINGLE Angle
DIM AS INTEGER Cycles, Count, Channel, Datahigh 
DIM AS INTEGER ArgErr, AngleErr, ChannelErr, PulseLenErr
DIM AS DOUBLE pulseLength, pulseLength1, updatePeriod, S1, C1, C2, C3
DIM AS INTEGER argc
DIM AS STRING argv 


Angle=0    'Required phase angle
Cycles=20  'Number of pulses to send
Channel=1  'Parallel output line (0-7)
C1=0       'Cal coeff for x^2 term
C2=0.0017  'Cal coeff for x^1 term
C3=1       'cal coeff for x^0 term

SCREEN 12

LOCATE 1,1
PRINT "exe name= "; COMMAND( 0 )
 	
 
 	 	
argc = 1
DO
    argv = COMMAND( argc )
 		
    IF( LEN( argv ) = 0 ) THEN
        EXIT DO
    END IF
 		
    'PRINT "arg"; argc; " = """; argv; """"
 		
    argc += 1
LOOP

ArgErr=0
IF( argc < 7 ) THEN
    ArgErr=1
    PRINT ""
    PRINT "Insufficient arguments found, use : "
    PRINT "servodrive1.exe angle cycles channel C1 C2 C3"
    PRINT ""
    PRINT "angle.....Required phase-delay angle 0<=angle<=360  (deg)         (float)"
    PRINT "cycles....Number of pulses to send 0<cycles typ 20              (integer)"
    PRINT "channel...Parallel port data line  0<=channel<=7                (integer)"
    PRINT "C1,C2,C3..Cal  pulselen(ms)=C1*X^2+C2*X+C3  where X=angle(deg)    (float)"
    PRINT ""
    PRINT "C1=0      typ"
    PRINT "C2=0.0017 typ"
    PRINT "C3=1.05   typ"
ELSE
    Angle=VAL(COMMAND(1))
    Cycles=VAL(COMMAND(2))
    Channel=VAL(COMMAND(3))
    C1=VAL(COMMAND(4))
    C2=VAL(COMMAND(5))
    C3=VAL(COMMAND(6))
END IF
 	

'****** Drive Servo to 'Angle' using 'Cycles' number of pulses ******

AngleErr=0
ChannelErr=0
PulseLenErr=0

PRINT ""
IF Angle<0 OR Angle>360 THEN 
 AngleErr=1
 PRINT "Angle out of range, use 0-360"
END IF

IF Channel<0 OR Channel>7 THEN
 ChannelErr=1
 PRINT "Channel out of range, use 0-7"
END IF

pulseLength=(C1*Angle^2+C2*Angle+C3)*1e-3 'Pulse length for desired angle(sec)
pulseLength1=pulseLength-0.05*1e-3 'Pulse len for (desired ang)-5deg(physical)


IF ((pulseLength<1e-3) OR (pulselength>2e-3))=1 THEN
 PulseLenErr=1
 PRINT "Calculated pulse length out of range, check cal"
END IF

IF not(AngleErr or ChannelErr or PulseLenErr or ArgErr)=1 THEN
    
    updatePeriod = 0.02                 ' Pulse repetition rate (Seconds)
    Datahigh=2^(Channel)                ' Data to output to parallel port
                                        ' Channel #0, data=1,
                                        ' Channel #1, data=2,
                                        ' Channel #2, data=4..etc
    LOCATE 5, 1: PRINT "Angle = "
    LOCATE 5, 15: PRINT USING "###.## Deg"; Angle
    LOCATE 6, 1: PRINT "PulseLen = "
    LOCATE 6, 15: PRINT USING "###.## ms"; pulseLength*1000
    LOCATE 7, 1: PRINT "Cycles = "
    LOCATE 7, 15: PRINT USING "###"; Cycles
    LOCATE 8, 1: PRINT "Channel = "
    LOCATE 8, 15: PRINT USING "###"; Channel

    
    
    OUT 888, 0
     
    'Drive to desired angle-5deg(physical), to avoid backlash errors
    Count = 0
    WHILE Count < Cycles
  
        asm cli
            OUT 888, Datahigh
            S1=HrTimer
            DO
            LOOP UNTIL (HrTimer-S1) > pulseLength1
            OUT 888, 0
        asm sti
  
        S1=HrTimer
        DO
        LOOP UNTIL (HrTimer-S1) > updatePeriod
        Count = Count + 1
    WEND
    
    'Drive to the desired angle in positive direction
    Count = 0
    WHILE Count < 10
  
        asm cli
            OUT 888, Datahigh
            S1=HrTimer
            DO
            LOOP UNTIL (HrTimer-S1) > pulseLength
            OUT 888, 0
        asm sti
  
        S1=HrTimer
        DO
        LOOP UNTIL (HrTimer-S1) > updatePeriod
        Count = Count + 1
    WEND
    
ELSE
 PRINT ""
 PRINT "Press any key"   
 sleep    

END IF

