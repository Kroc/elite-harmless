; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; common math routines. for more 3D specific stuff
; (such as matrix math, see "math_3d.asm")

.macro  .math_square
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.export math_square_7bit
.export math_square

; square a 7-bit number:
;-------------------------------------------------------------------------------
; removes the sign-bit and then does A * A. see the next procedure for details.
; the caller should save and restore the sign if desired
;
math_square_7bit:                                                       ;$3986

        and # %01111111         ; remove sign

; square a number:
; (i.e. A * A)
;-------------------------------------------------------------------------------
;       A = number to multiply with itself
;
; returns a 16-bit number in A.P
;
math_square:                                                            ;$3988
;
; if the math lookup tables are being included,
; we can use these to go faster
; 
.ifdef  OPTION_MATHTABLES
        ;///////////////////////////////////////////////////////////////////////
        tax                     ; use A as index into tables (i.e. A * A)
        bne _399f

        sta ZP_VAR_P
        rts 

_3992:  ;?
        tax 
        lda DUST_Y, y
        sta ZP_VAR_Y
_3997:  ;?
        and # %01111111
        sta ZP_VAR_P
_399b:  ;?
.export _399b

        ldx ZP_VAR_Q

_399f:  
        txa 
        sta @sm1+1
        sta @sm3+1
        eor # $ff
        sta @sm2+1
        sta @sm4+1

        sec 
@sm1:   lda square1_lo, x
@sm2:   sbc square2_lo, x
        sta ZP_VAR_P
@sm3:   lda square1_hi, x
@sm4:   sbc square2_hi, x

        rts 

.else   ;///////////////////////////////////////////////////////////////////////
        ; original elite square routine, or elite-harmless
        ; without the math lookup tables
        ; 
        sta ZP_VAR_P            ; put aside initial value
        tax                     ; and again
       .bnz _399f               ; if not zero, begin multiplication

        ; multiplying with zero?
        ; result is zero!
        ;
_398d:  clc                                                             ;$398D
        stx ZP_VAR_P
        txa 
        rts 

        ;-----------------------------------------------------------------------

_3992:                                                                  ;$3992
        lda DUST_Y, y           ; get Y-position of dust particle index Y
        sta ZP_VAR_Y            ; keep original value before multiplication

_3997:                                                                  ;$3997
        and # %01111111         ; strip the sign
        sta ZP_VAR_P            ; store this as the working multiplier
_399b:                                                                  ;$399B
.export _399b

        ldx ZP_VAR_Q            ; load our multiplicand
        beq _398d               ; are we multiplying by zero!?

_399f:                                                                  ;$399F
        ; subtract 1 because carry will add one already
        dex 
        stx ZP_VAR_T

        lda # $00
        tax 

        lsr ZP_VAR_P            ; pop a bit off
        bcc :+                  ; if zero, nothing to add
        adc ZP_VAR_T            ; add x1 quantity to the result

:       ror                     ; shift to the next power of 2          ;$39AB
        ror ZP_VAR_P            ; move the result down and pop next bit
        bcc :+                  ; if zero, nothing to add
        adc ZP_VAR_T            ; add x2 quantity to result

:       ror                                                             ;$39B2
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39B9
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39C0
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39C7
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39CE
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39D5
        ror ZP_VAR_P
        bcc :+
        adc ZP_VAR_T

:       ror                                                             ;$39DC
        ror ZP_VAR_P

        rts 

.endif  ;///////////////////////////////////////////////////////////////////////
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro
