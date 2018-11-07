
#include "hrtimer.bas"


DIM AS INTEGER Cycles, Count, ArgErr, Channel 
DIM AS DOUBLE PLen, pulseLength, updatePeriod, S1
DIM AS INTEGER argc
DIM AS STRING argv 


PLen=-99 
Cycles=0   
Channel=0   'Parallel port line to use (0-7)

SCREEN 12

LOCATE 1,1
PRINT "exe name= "; COMMAND( 0 )
 	
 
 	 	
argc = 1
DO
    argv = COMMAND( argc )
 		
    IF( LEN( argv ) = 0 ) THEN
        EXIT DO
    END IF
 		
    PRINT "arg"; argc; " = """; argv; """"
 		
    argc += 1
LOOP
 
ArgErr=0 
IF( argc < 3 ) THEN
    ArgErr=1
    PRINT "Insufficient arguments found, use : servodrive.exe pulseLength cycles"
    PRINT ""
    PRINT "Where : pulseLength....In millseconds and in the range 1-2"
    PRINT "        cycles.........Number of pulses to send typically 20"
  ELSE
    PLen=VAL(COMMAND(1))
    Cycles=VAL(COMMAND(2))

 	

  '****** Drive Servo to 'Angle' using 'Cycles' number of pulses ******

  IF (PLen>=1 AND PLen <=2) THEN
    
    pulseLength=PLen*1e-3
    updatePeriod = 0.02      ' Pulse repetition rate (Seconds)
 
    LOCATE 5, 1: PRINT "Pulse Length = "
    LOCATE 5, 15: PRINT USING "###.### (ms)"; Plen
    LOCATE 6, 1: PRINT "Cycles = "
    LOCATE 6, 15: PRINT USING "###.###"; Cycles
    OUT 888, 0

    Count = 0
    WHILE Count < Cycles
  
        asm cli
            OUT 888, 1
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
    LOCATE 5, 1: PRINT "Pulse Length (ms) = Out of Range (use 1 to 2)"
  END IF
END IF

IF ArgErr THEN
    SLEEP
END IF
