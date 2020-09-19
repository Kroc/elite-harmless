; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "math_multiply+add.asm":
;
; return a 16-bit number (in X & A), by multiplying "Q" (`ZP_VAR_Q`) with `A`
; and adding the 16-bit number in `R` (`ZP_VAR_R`) & `S` (`ZP_VAR_S`):
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
        sta ZP_VAR_T
        eor ZP_VAR_S
        bmi :+

        lda ZP_VAR_R
        clc 
        adc ZP_VAR_P
        tax 
        lda ZP_VAR_S
        adc ZP_TEMP_VAR
        ora ZP_VAR_T
        
        rts 

        ;-----------------------------------------------------------------------

:       lda ZP_VAR_S                                                    ;$3AE8
        and # %01111111
        sta ZP_VAR_U
        lda ZP_VAR_P
        sec 
        sbc ZP_VAR_R
        tax 
        lda ZP_TEMP_VAR
        and # %01111111
        sbc ZP_VAR_U
        bcs :+
        sta ZP_VAR_U
        txa 
        eor # %11111111
        adc # $01
        tax 
        lda # $00
        sbc ZP_VAR_U
        ora # %10000000

:       eor ZP_VAR_T                                                    ;$3B0A
        rts 
