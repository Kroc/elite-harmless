; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; unused / unreferenced?
;$3a48
        ldx ZP_ROLL_MAGNITUDE
        stx ZP_VAR_P
_3a4c:                                                                  ;$3A4C
        ldx ZP_VAR_XX_HI
        stx ZP_VAR_S
_3a50:                                                                  ;$3A50
        ldx ZP_VAR_XX_LO
        stx ZP_VAR_R

multiply_signed:                                                        ;$3A54
;===============================================================================
; calculates:
;
;       A.P = Q * A
;
; i.e. multiplies two 8-bit (signed) numbers
; and returns a 16-bit (signed) number: A = HI, P = LO
;
; this was adapted (badly) from:
; http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
;
.ifdef  OPTION_MATHTABLES
        ;///////////////////////////////////////////////////////////////////////

        ZP_F8   = $f8
        ;
        ;       Q = multiplicand
        ;       A = multiplier
        ;
.ifdef  USE_ILLEGAL_OPS
        ;///////////////////////////////////////////////////////////////////////
        ldx # %01111111
        axs # 0                 ; X = $7F & A (-0)
.else   ;///////////////////////////////////////////////////////////////////////
        tax
.endif  ;///////////////////////////////////////////////////////////////////////

        ; compare signs for working out what the final sign will be. XOR'ing
        ; the two operands will work out the +ve/-ve combination for us!
        ;
        ; +ve * +ve = +ve
        ; +ve * -ve = -ve
        ; -ve * +ve = -ve
        ; -ve * -ve = +ve
        ;
        eor ZP_VAR_Q            ; load multiplicand, combining the signs
        and # %10000000         ; extract resulting sign
        sta ZP_VAR_T            ; keep resulting sign for the end

        ; now the sign is separate, extract the "magnitude"
        ; -- the value, without sign, which will be 0 to 127
        ;
        lda ZP_VAR_Q            ; again, multiplicand
        and # %01111111         ; extract the magnitude
        sta sm1+1               ; these effectively add A and X
        sta sm3+1               ; ->  `lda table+A, X`
        eor # $ff
        sta sm2+1
        sta sm4+1

.ifndef USE_ILLEGAL_OPS
        ;///////////////////////////////////////////////////////////////////////
        txa
        and # %01111111
        tax
.endif  ;///////////////////////////////////////////////////////////////////////

        sec 
sm1:    lda square1_lo, x
sm2:    sbc square2_lo, x
        sta ZP_VAR_P
sm3:    lda square1_hi, x
sm4:    sbc square2_hi, x

        ora ZP_VAR_T            ; restore the sign
        rts 

.else   ;///////////////////////////////////////////////////////////////////////
        ; if not using the extra math tables, fall-back to an algorithm;
        ;
        ; the algorithm used here is a common type, best described in context
        ; of the 6502 here: <http://nparker.llx.com/a2/mult.html> under the
        ; heading "Multplying Arbitrary Numbers"
        ;
        ; a multiply is nothing more than repeatedly adding the given value,
        ; e.g. multiply 2 by 5 is just 2 + 2 + 2 + 2 + 2 but in the case of
        ; 101 * 99, looping 99 times adding 101 each time would be incredibly
        ; slow! there are shortcuts to do this efficiently in 8-bit assembly
        ; -- multiplying and dividing by 2 is very fast in assembly as these
        ; can be done with left & right shifts only
        ;
        ; therefore we want to reduce the overall multiplication to some
        ; combination of shifts, that is combining any of x1, x2, x4, x8, x16,
        ; x32 & x64. for example, multiplying 'n' by 10 would be a combination
        ; of 'n' * 2 and then adding 'n' * 8
        ;
        ; how do we work out which combination to use? to steal a perfect
        ; example from the 6502 tutorial above, the binary representation
        ; of a number already describes the powers of 2:
        ;
        ;       3 (decimal) = 11 (binary)
        ;                     |+--  1
        ;                     +--- +2
        ;                          --
        ;                           3, i.e. 1x + 2x = 3x
        ;       
        ;       10 (decimal) = 1010 (binary)
        ;                      | +--  2
        ;                      +---- +8
        ;                            --
        ;                            10, i.e. 2x + 8x = 10x
        ;       
        ;       25 (decimal) = 11001 (binary)
        ;                      ||  +--   1
        ;                      |+-----   8
        ;                      +------ +16
        ;                              ---
        ;                               25, i.e. x + 8x + 16x = 25x
        ;
        ; therefore we can reduce the multiplication of any two 8-bit numbers
        ; to just 8 steps (or 7 in our case for signed numbers) by adding
        ; powers of 2 of the multiplcand (the number being multiplied) for each
        ; bit found in the multiplier (the number we are multiplying _by_)
        ;
        ; an optimisation used here is that the running total (result) begins
        ; in its hi-byte and is shifted down into its lo-byte as digits are
        ; pushed off the right of the multiplier. the importance of this is
        ; that the multiplicand never has to be shifted! if you are multiplying
        ; 30 then "30" remains the same and it's the result that shifts along
        ; the powers of two
        ;
        ; since the bits of the result are shifting in from the left, and the
        ; multipler is shifting bits out the right, they actually share the
        ; same byte! once all 8 bits of the multiplier have been removed,
        ; the same byte has now become the lo-byte of the result! e.g.
        ;                       
        ;      multiplicand --> result hi   --> result lo /
        ;                                       multiplier  --> carry
        ;                                       
        ;       Q:%????????     A:%????????     P:%????????
        ;
        ; we begin by removing the first digit from the multiplier `A`.
        ; if it's a 1, this means that we need to add the multiplicand once.
        ; the `lsr` instruction shifts the bits right and if bit 0 of `A` was
        ; set then the carry flag will be set -- *THIS CARRY FLAG WILL BE
        ; KEPT FOR QUITE SOME TIME BEFORE BEING USED!*
        ;
        tax                     ; keep copy of original A value
        and # %01111111         ; strip off the sign
        lsr                     ; push 1st digit off the multiplier into carry
        sta ZP_VAR_P            ; more digits to be pushed off later

        ; compare signs for working out what the final sign will be. XOR'ing
        ; the two operands will work out the +ve/-ve combination for us!
        ;
        ; +ve * +ve = +ve
        ; +ve * -ve = -ve
        ; -ve * +ve = -ve
        ; -ve * -ve = +ve
        ;
        txa                     ; load multiplier
        eor ZP_VAR_Q            ; load multiplicand, combining the signs
        and # %10000000         ; extract resulting sign
        sta ZP_VAR_T            ; keep resulting sign for the end

        ; now the sign is separate, extract the "magnitude" -- the value,
        ; without sign, which will be 0 to 127. we'll check here to see if
        ; we're multiplying with zero, which will always yield a result of zero
        ;
        lda ZP_VAR_Q            ; again, multiplicand
        and # %01111111         ; extract the magnitude
       .bze @zero               ; multiplying with 0? skip everything!
        
        ; since the 6502 does not have a way to add/subtract without the use
        ; of carry, and that the carry will flow from one add to another,
        ; we preempt this behaviour by subtracting one from our multiplicand
        ;
        ; note that the use of `dex` *DOES NOT MODIFY CARRY*, so we retain the
        ; carry flag we've been carrying all this time (pun very much intended)
        ;
        tax                     ; multiplicand
        dex                     ; subtract 1 (carry will compensate for this)
        stx ZP_TEMP_VAR         ; store this as our starting multiplicand

        ; this is an unrolled version of the loop in
        ; the BBC code which set X to 7 and counted down
        lda # $00
        tax                     ; unnecessary?

        ; x1:   if the first multiplier digit popped off at the start of
        ;       this routine was 1 (currently in the carry) then we need to
        ;       add "multiplicand * 1" to the running total
        ; 
        bcc :+
        adc ZP_TEMP_VAR         ; add multiplicand -- and carry -- to total
:       ror                     ; shift result down to the next power   ;$3A72

        ; x2
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 2x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A79

        ; x4:
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 4x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A80

        ; x8:
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 8x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A87

        ; x16:
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 16x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A8E

        ; x32:
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 32x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A95

        ; x64:
        ror ZP_VAR_P            ; pop the next digit off the multiplier
        bcc :+                  ; nothing to add if multiplier digit was 0
        adc ZP_TEMP_VAR         ; add 64x the multiplicand to the total
:       ror                     ; shift result down to the next power   ;$3A9C

        ror ZP_VAR_P            ; push off unused sign-bit on the multiplier
        lsr                     ; shift the result without adding to it

        ; bring the result lo-byte `P` into focus; all multiplier bits will
        ; be gone and the result will have been shifted down fully 8 times,
        ; producing a 16-bit result value
        ror ZP_VAR_P
        ora ZP_VAR_T            ; restore the sign

        rts 

        ; multiplying by zero will return zero. note that this is why that
        ; carry was not added to the result lo-byte right away --
        ; `A` will be 0 so we can now zero out `P` and return a 16-bit zero
        ;-----------------------------------------------------------------------
@zero:  sta ZP_VAR_P            ; `A` = 0 so also return `P` = 0        ;$3AA5
        rts                     ; `A.P` will be $0000

.endif  ;///////////////////////////////////////////////////////////////////////

multiply_signed_into_RS:                                                ;$3AA8
        ;-----------------------------------------------------------------------
        ; does a multiply as above (`multiply_signed`) and stores the result
        ; in "`R.S`" (`ZP_VAR_R` & `ZP_VAR_S`)
        ;
        jsr multiply_signed
        sta ZP_VAR_S
        lda ZP_VAR_P
        sta ZP_VAR_R
        rts 
