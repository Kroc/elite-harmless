; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "math_multiply+add.asm":
;
; return a 16-bit number (in X & A), by multiplying "Q" (`Q`) with `A`
; and adding the 16-bit number in R & S
;
;       A.X = Q * A + S.R
;
; this is used as a lot as part of 3D math
;
multiply_and_add:                                                       ;$3ACE
        ;=======================================================================
        ; calculate `Q * A`, returning `A.P`
        jsr multiply_signed

multiplied_now_add:                                                     ;$3AD1
        ;=======================================================================
        ; skips the `Q * A` multiplication: A.X = S.R + A.P
        ;
        sta ZP_TEMP_VAR
        and # %10000000
        sta T
        eor S
        bmi :+

        lda R
        clc 
        adc ZP_VAR_P
        tax 
        lda S
        adc ZP_TEMP_VAR
        ora T
        
        rts 

        ;-----------------------------------------------------------------------

:       lda S                                                           ;$3AE8
        and # %01111111
        sta U
        lda ZP_VAR_P
        sec 
        sbc R
        tax 
        lda ZP_TEMP_VAR
        and # %01111111
        sbc U
        bcs :+
        sta U
        txa 
        eor # %11111111
        adc # $01
        tax 
        lda # $00
        sbc U
        ora # %10000000

:       eor T                                                           ;$3B0A
        rts 
