
#include "hrtimer.bas"

Screen 12

Dim As Double pulseLength, pulseIncrement, updatePeriod, S1
Dim As Integer Cycles, Count, Channel, DataHigh
Dim as String ch

pulseLength = 0.001      ' Initial pulse length (Seconds)
pulseIncrement = 0.000005' Change in pulse length (Seconds)
updatePeriod = 0.02      ' Pulse repetition rate (Seconds)

Channel=-99
WHILE ((Channel<0) or (Channel>7)) 
 LOCATE 1,1
 PRINT "                              "
 LOCATE 1,1
 INPUT "Enter channel (0-7) : ",Channel
WEND 
DataHigh=2^Channel

PRINT "Use - and + keys to vary pulse width, ESC to exit"
PRINT "Range 1ms to 2ms"
PRINT
LOCATE 5, 1: PRINT "Pulse Width = "
LOCATE 5, 15: PRINT USING "###.### ms"; pulseLength / .001


Cycles = 1
Count = 0

OUT 888, 0           'Send data to parallel port to make all lines go low

DO
 Count = 0

 WHILE Count < Cycles
  
  'Send pulse of duration pulseLength (seconds)
  asm cli
  OUT 888, DataHigh 'Send data to parallel port to make appropriate line go high
  S1=HrTimer
  DO
  LOOP UNTIL (HrTimer-S1) > pulseLength
  OUT 888, 0        'Send data to parallel port to make all lines go low
  asm sti
  
  'Leave outputs low for updatePeriod (seconds)
  S1=HrTimer
  DO
  LOOP UNTIL (HrTimer-S1) > updatePeriod

  Count = Count + 1
 WEND



ch = INKEY$
IF (ch = "-") AND (pulseLength > .001) THEN
    pulseLength = pulseLength - pulseIncrement
END IF
  
IF (ch = "=") AND (pulseLength < .002) THEN
    pulseLength = pulseLength + pulseIncrement
END IF 

   
   LOCATE 5, 1: PRINT "Pulse Width = "
   LOCATE 5, 15: PRINT USING "###.###"; (pulseLength-0) / .001


LOOP WHILE (ch <> " ") AND (ch <> CHR$(27))'Press SPACE or ESC to end

