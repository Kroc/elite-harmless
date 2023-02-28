; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; Complex Inteface Adapters
;===============================================================================
; CIA1 - keyboard, joysticks, lightpen & paddles I/O
;-------------------------------------------------------------------------------
CIA1_PORTA                      = $dc00
CIA1_PORTB                      = $dc01

CIA1_PORTA_DDR                  = $dc02
CIA1_PORTB_DDR                  = $dc03

CIA1_INTERRUPT                  = $dc0d
CIA2_INTERRUPT                  = $dd0d

.enum   CIA
        TIMER_A                 = %001
        TIMER_B                 = %010
        TIMER_TOD               = %100
.endenum

; CIA2 - VIC memory bank, IEC serial & userport RS232 I/O
;-------------------------------------------------------------------------------
CIA2_PORTA                      = $dd00
CIA2_PORTB                      = $dd01

CIA2_PORTA_DDR                  = $dd02
CIA2_PORTB_DDR                  = $dd03

CIA2_TIMERA                     = $dd04
CIA2_TIMERA_LO                  = $dd04
CIA2_TIMERA_HI                  = $dd05
CIA2_TIMERB                     = $dd06
CIA2_TIMERB_LO                  = $dd06
CIA2_TIMERB_HI                  = $dd07