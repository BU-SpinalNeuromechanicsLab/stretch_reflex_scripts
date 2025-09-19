;This code is to be paried with Cope Lab motor control code via sequence (.PLS) files.  12-05-05 JFP, edited 7-18-2025 PN
;This code was used with the aurora scientific brand of lever systems, specifically the 305C-LR, and 300C-LR.
;Available choices for stimulus are Quick Stretches, Ramp-hold-release, three successive triangles, and small
;amplitude vibrations at a range of frequencies from 10Hz to 250Hz.
;For each motor stimulus, a trigger is sent out of Digital Output 1 on the power1401. 
;In our configuration, we have chosen to record this trigger on Event Input 1.  This allows the analysis code
;to detect when a stimulus has occurred and analyze it.  




            SET      1.000 1 0     ;SET    msPerStep, DACscale, DACoffset 
            JUMP   ZA

            HALT                   ;HALT instruction stops the output sequence and removes all overhead associated with it

ZA:     'Z  DAC1   0.0             ;'Z = stop all, stopping all motor instructions
            DAC0   0.0             ;DAC instruction can write a value to any of the 8 possible DAC outputs, this sets DAC1 to 0
IDLE:       HALT                   
  

NA:     'N  LDCNT1 V1              ;'N = Three Triangles 
            LDCNT2 V1              ;LDCNTn loads a counters
            DAC0   0
	    REPORT 
	    DIGOUT [......10]      ;open state of Digital Output 1
            DAC    0,0
            DAC    1,0
            DELAY  s(0.15)-1       ;DELAY instruction occupies one clock tick plus the number of extra ticks set by the argument
            DIGOUT [......00]      ;closed state of Digital Output 1  
            DELAY  s(0.01)-1       
                                   ;First of three triangles
NC:         ADDAC0 V2              ;V2 = VOLTAGE INCREMENT
            DBNZ1  NC              ;DBNZ (Decrement and Branch if Not Zero) subtracts 1 from a variable and branches to a label unless the counter is zero
ND:         ADDAC0 V3              ;V3 = VOLTAGE DECREMENT
            DBNZ2  ND
	    LDCNT1 V1              ;second TRIANGLE
            LDCNT2 V1
            DAC0   0
NE:         ADDAC0 V2              
            DBNZ1  NE
NF:         ADDAC0 V3              
            DBNZ2  NF
	    LDCNT1 V1              ;third TRIANGLE
            LDCNT2 V1
            DAC0   0
NG:         ADDAC0 V2              
            DBNZ1  NG
NH:         ADDAC0 V3              
            DBNZ2  NH

            DELAY  V4              ;V4 = delay between sets of triangles
            JUMP   NA              ;JUMP instruction transfers control unconditionally to the instruction at the label
		



EA:     'E  LDCNT1 V1              ;Quick stretches
            LDCNT2 V1
	    DAC0   0.0
	    DAC1   0.0
            REPORT 
	    DIGOUT [......10]
            DAC    0,0
            DAC    1,0
            DELAY  s(0.01)-1
            DIGOUT [......00]
            DELAY  s(0.01)-1
            REPORT 
EC:         ADDAC0 V2              ;V2 = VOLTAGE INCREMENT
            DBNZ1  EC
FD:         ADDAC0 V3              ;V3 = VOLTAGE DECREMENT
            DBNZ2  FD
            DELAY  V4              ;V4 = delay between quick stretches
            JUMP   EA              



RA:     'R  LDCNT1 V1              ;ramp-hold-release
            LDCNT2 V4
            DAC0   0.0
            REPORT 
	    DIGOUT [......10]
            DAC    0,0
            DAC    1,0
            DELAY  s(0.01)-1
            DIGOUT [......00]
            DELAY  s(0.01)-1
RC:         ADDAC0 V2              ;V2 = VOLTAGE INCREMENT
            DBNZ1  RC
            DELAY  V3              ;V3 = delay for hold phase 
RD:         ADDAC0 V5              ;V5 = VOLTAGE DECREMENT
            DBNZ2  RD
            DELAY  V6              ;V6 = delay between ramp-hold-release
            JUMP   RA              


EH:     'H  DIGOUT [......10]      ;  10Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(10)        ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ;  Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   EH


ED:     'D  DIGOUT [......10]      ;  50Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(20)        ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ; Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   ED


EV:     'V  DIGOUT [......10]      ;  1670Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(167)       ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ; Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   EV




EX:     'X  DIGOUT [......10]      ;  250Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(250)       ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ; Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   EX


EY:     'Y  DIGOUT [......10]      ;  100Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(100)       ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ; Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   EY
            


EB:     'B  DIGOUT [......10]      ;  50Hz vibration
	    DIGOUT [......00]
	    DAC    0,0
            SZ     0,V2            ;  This instruction sets the waveform amplitude
            OFFSET 0,0             ;  cosine centre
            ANGLE  0,90            ;  cosine phase
            RATE   0,Hz(50)        ;  set rate and start cosine off
            DAC    1,0
            DELAY  V1
            RATE   0,0             ; Stop cosine output
            DAC    0,0             
	    DELAY  V4
	    JUMP   EB








 











