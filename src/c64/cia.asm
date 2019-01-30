; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; CIA
;===============================================================================
; CIA1 - keyboard, joysticks, lightpen & paddles I/O
;-------------------------------------------------------------------------------
.define CIA1_PORTA              $dc00
.define CIA1_PORTB              $dc01

.define CIA1_PORTA_DDR          $dc02
.define CIA1_PORTB_DDR          $dc03

.define CIA1_INTERRUPT          $dc0d
.define CIA2_INTERRUPT          $dd0d

.enum   CIA
        TIMER_A                 = %001
        TIMER_B                 = %010
        TIMER_TOD               = %100
.endenum

; CIA2 - VIC memory bank, IEC serial & userport RS232 I/O
;-------------------------------------------------------------------------------
.define CIA2_PORTA              $dd00
.define CIA2_PORTB              $dd01

.define CIA2_PORTA_DDR          $dd02
.define CIA2_PORTB_DDR          $dd03

.define CIA2_TIMERA             $dd04
.define CIA2_TIMERA_LO          $dd04
.define CIA2_TIMERA_HI          $dd05
.define CIA2_TIMERB             $dd06
.define CIA2_TIMERB_LO          $dd06
.define CIA2_TIMERB_HI          $dd07