; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_3986"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

math_square_7bit:                                                       ;$3986
;===============================================================================
; square a 7-bit number:
;
; removes the sign-bit and then does A * A. see the next procedure for details.
; the caller should save and restore the sign if desired
;
;-------------------------------------------------------------------------------
        and # %01111111         ; remove sign

        ; fallthrough...
        ;

; if the math lookup tables are being included,
; we can use these to go faster
; 
.ifdef  FEATURE_MATHTABLES
;///////////////////////////////////////////////////////////////////////////////

math_square:                                            ; BBC: MLU2     ;$3988
;===============================================================================
; square a number:
; (i.e. A * A)
;
; in:   A       number to multiply with itself
; out:  A.P     16-bit result in A = hi, P = lo
;-------------------------------------------------------------------------------
        tax                     ; use A as index into tables (i.e. A * A)
        bne multiply_unsigned_PX; non-zero value?

        ; zero-squared is zero!
        ;
        sta ZP_VAR_P            ; make it 16-bits
        rts 
        ;-----------------------------------------------------------------------

_3992:  ;?
        tax 
        lda DUST_Y_HI, y
        sta ZP_VAR_XX15_1
_3997:  ;?
        and # %01111111
        sta ZP_VAR_P

        ; fallthrough...
        ;

multiply_unsigned_PQ:                                   ; BBC: MULTU    ;$399B
;===============================================================================
; unsigned multiplication of two 8-bit numbers:
;
; in:   ZP_VAR_P                multiplier, i.e. left-hand-side of 'P * Q'
;       Q                       multiplicand, i.e. right-hand-side of 'P * Q'
;
; out:  A.P                     16-bit result returned in A.P, where P
;                               is the lo-byte and A is the hi-byte
;-------------------------------------------------------------------------------
.export multiply_unsigned_PQ

        ldx Q

multiply_unsigned_PX:
        ;-----------------------------------------------------------------------
        ; NOTE: must preserve Y
        txa 
        sta @sm1+1
        sta @sm3+1
        eor # %11111111
        sta @sm2+1
        sta @sm4+1

        sec 
@sm1:   lda square1_lo, x
@sm2:   sbc square2_lo, x
        sta ZP_VAR_P
@sm3:   lda square1_hi, x
@sm4:   sbc square2_hi, x

        rts 

.else   ; (no fast-tables)
;///////////////////////////////////////////////////////////////////////////////

math_square:                                            ; BBC: MLU2     ;$3988
;===============================================================================
; square a number:
; (i.e. A * A)
;
; in:   A                       number to multiply with itself
; out:  A.P                     16-bit result in A = hi, P = lo
;-------------------------------------------------------------------------------
        ; original elite square routine, or elite-harmless
        ; without the math lookup tables:
        ; 
        sta ZP_VAR_P            ; put aside initial value
        tax                     ; and again
       .bnz multiply_unsigned_PX; if not zero, begin multiplication

        ; multiplying with zero?
        ; result is zero!
        ;
_398d:  clc                                                             ;$398D
        stx ZP_VAR_P
        txa 
        rts 

        ;-----------------------------------------------------------------------

_3992:                                                                  ;$3992
        lda DUST_Y_HI, y        ; get Y-position of dust particle index Y
        sta ZP_VAR_XX15_1       ; keep original value before multiplication

_3997:                                                                  ;$3997
        and # %01111111         ; strip the sign
        sta ZP_VAR_P            ; store this as the working multiplier

        ; fallthrough...
        ;

multiply_unsigned_PQ:                                   ; BBC: MULTU    ;$399B
;===============================================================================
; unsigned multiplication of two 8-bit numbers:
;
; in:   ZP_VAR_P                multiplier, i.e. left-hand-side of 'P * Q'
;       Q                       multiplicand, i.e. right-hand-side of 'P * Q'
;
; out:  A.P                     16-bit result returned in A.P, where
;                               P is the lo-byte and A is the hi-byte
;-------------------------------------------------------------------------------
.export multiply_unsigned_PQ

        ldx Q                   ; load our multiplicand
        beq _398d               ; are we multiplying by zero!?

multiply_unsigned_PX:                                                   ;$399F
        ;-----------------------------------------------------------------------
        ; NOTE: this routine must preserve Y
        ;
        dex                     ; subtract 1 because carry will add one already 
        stx T                   ; this is the amount to add for each carry

        lda # $00
        tax 

        lsr ZP_VAR_P            ; pop a bit off
        bcc :+                  ; if zero, nothing to add
        adc T                   ; add x1 quantity to the result

:       ror                     ; shift to the next power of 2          ;$39AB
        ror ZP_VAR_P            ; move the result down and pop next bit
        bcc :+                  ; if zero, nothing to add
        adc T                   ; add x2 quantity to result

:       ror                                                             ;$39B2
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39B9
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39C0
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39C7
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39CE
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39D5
        ror ZP_VAR_P
        bcc :+
        adc T

:       ror                                                             ;$39DC
        ror ZP_VAR_P

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endif


.segment        "CODE_9978"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

square_root:                                                            ;$9978
;===============================================================================
; this calculates a very good approximation of the square root of R.Q
; Q = sqrt(R.Q)
;
; TODO: create a lookup table for this, for cart ROM
;-------------------------------------------------------------------------------
        ldy R
        lda Q
        sta S
        ldx # $00
        stx Q                   ; X.Y.S = 0.R.Q ; Q = 0
        lda # $08
        sta T                   ; REPEAT 8
@loop:                                                                  ;$9986
        cpx Q
        bcc @next               ; blt
        bne @inc
        cpy # $40
        bcc @next               ; if (X.Y >= Q.$40) increase else next
@inc:                                                                   ;$9990
        tya
        sbc # $40               ; carry is set
        tay
        txa
        sbc Q
        tax                     ; X.Y -= Q.$40; Q++ (via carry from rol below)
@next:                                                                  ;$9998
        rol Q                   ; Q*=2 (+1 if carry set, see above)
        asl S
        tya
        rol
        tay
        txa
        rol
        tax
        asl S
        tya
        rol
        tay
        txa
        rol
        tax                     ; X.Y.S *= 4
        dec T    
        bne @loop               ; ENDREP
        rts