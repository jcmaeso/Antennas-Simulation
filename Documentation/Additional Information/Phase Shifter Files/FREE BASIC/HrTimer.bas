
'====================================================================
'' This function returns the elapsed seconds since the system was
'' started, or zero if the processor does not support the CPUID
'' or RDTSC instructions. The elapsed seconds are determined by
'' dividing the current Time Stamp Counter (TSC) value by the CPU
'' clock frequency, as determined in the first call by counting
'' the processor clock cycles over a (65536/1193182) second
'' interval timed with system timer 2.
'====================================================================

Function HrTimer() As Double

    Static As Double clkhz
    Dim As Ulongint tsc
    Dim As Integer i

    If clkhz = 0 Then

      '------------------------------------------------------------
      '' CPUID supported if can set/clear ID flag (EFLAGS bit 21).
      '------------------------------------------------------------

      asm
        pushfd
        pop edx
        pushfd
        pop eax
        Xor eax, &h200000  '' flip ID flag
        push eax
        popfd
        pushfd
        pop eax
        Xor eax, edx
        mov [i], eax
      End asm
      If i = 0 Then Return 0

      '---------------------------------------------------------------
      '' TSC supported if CPUID func 1 returns with bit 4 of EDX set.
      '---------------------------------------------------------------

      asm
        mov eax, 1
        cpuid
        And edx, &h10
        mov [i], edx
      End asm
      If i = 0 Then Return 0

      '-----------------------------------------------------------
      '' Set the gate for timer 2 (bit 0 at I/O port 61h) to OFF.
      '-----------------------------------------------------------

      Out &h61, Inp(&h61) And Not 1

      '----------------------------------------------------
      '' Program timer 2 for LSB then MSB, mode 0, binary.
      ''   bit 7-6:   10     = timer 2
      ''   bit 5-4:   11     = R/W LSB then MSB
      ''   bit 3-1:   000    = single timeout
      ''   bit 0:     0      = binary
      '----------------------------------------------------

      Out &h43, &hb0

      '---------------------------------------------------------
      '' Load the starting value, LSB then MSB. This value will
      '' cause the timer to time out after 65536 cycles of its
      '' 1193182 Hz clock.
      '---------------------------------------------------------

      Out &h42, 0
      Out &h42, 0

      '-------------------------------------------
      '' Serialize and get the current TSC value.
      '-------------------------------------------

      asm
        Xor eax, eax
        cpuid
        rdtsc
        mov [tsc], eax
        mov [tsc+4], edx
      End asm

      '----------------------------------------------------------
      '' Set the gate for timer 2 (bit 0 at I/O port 61h) to ON.
      '----------------------------------------------------------

      Out &h61, Inp(&h61) Or 1

      '------------------------------------------------------------
      '' Wait until the output bit (bit 5 at I/O port 61h) is set.
      '------------------------------------------------------------

      Wait &h61, &h20

      '--------------------------------------------------
      '' Serialize and calculate the elapsed TSC counts.
      '--------------------------------------------------

      asm
        Xor eax, eax
        cpuid
        rdtsc
        Sub eax, [tsc]
        sbb edx, [tsc+4]
        mov [tsc], eax
        mov [tsc+4], edx
      End asm

      '-------------------------------------------------------------
      '' Set the gate for timer 2 (bit 0 at I/O port 61h) to OFF.
      '-------------------------------------------------------------

      Out &h61, Inp(&h61) And Not 1

      '-------------------------------------------
      '' Calc and save the processor clock speed.
      '-------------------------------------------

      clkhz = tsc / (65536 / 1193182)

    End If

    '-------------------------------------------
    '' Serialize and get the current TSC value.
    '-------------------------------------------

    asm
      Xor eax, eax
      cpuid
      rdtsc
      mov [tsc], eax
      mov [tsc+4], edx
    End asm

    '---------------------------------------
    '' Calc and return the elapsed seconds.
    '---------------------------------------

    Return tsc / clkhz

End Function

'====================================================================
 