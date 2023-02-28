; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_3AB2"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_3ab2:                                                                  ;$3AB2
;===============================================================================
        ldx ZP_SHIP_XPOS_LO, y
        stx Q
        lda ZP_VAR_XX15_0
        jsr multiply_signed_into_RS
        ldx ZP_SHIP_XPOS_SIGN, y
        stx Q
        lda ZP_VAR_XX15_1
        jsr multiply_and_add
        sta S
        stx R
        ldx ZP_SHIP_YPOS_HI, y
        stx Q
        lda ZP_VAR_XX15_2

        ; fallthrough
        ; ...

multiply_and_add:                                                       ;$3ACE
;===============================================================================
; return a 16-bit number (in X & A), by multiplying "Q" (`Q`) with `A`
; and adding the 16-bit number in R & S
;
;       A.X = Q * A + S.R
;
; this is used as a lot as part of 3D math
;-------------------------------------------------------------------------------
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


_3b0d:                                                                  ;$3B0D
;===============================================================================
        stx Q
        eor # %10000000
        jsr multiply_and_add
        tax 
        and # %10000000
        sta T
        txa 
        and # %01111111
        ldx # $fe
        stx ZP_TEMP_VAR
_3b20:                                                                  ;$3B20
        asl 
        cmp # $60
        bcc _3b27
        sbc # $60
_3b27:                                                                  ;$3B27
        rol ZP_TEMP_VAR
        bcs _3b20
        lda ZP_TEMP_VAR
        ora T
        rts