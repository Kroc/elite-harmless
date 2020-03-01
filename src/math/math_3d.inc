; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; hello and welcome to disassembly hell!
;
; I didn't know a thing about 3D math when I started disassembling this game,
; so the commentary below represents eveything I've learned along the way.
; the best complete-beginner guide to 3D math I've found online is:
; <http://programmedlessons.org/VectorLessons/>
; 
; it's strongly recommended that you read that tutorial to familiarise yourself
; with the specific terminology (points, lines, vectors & matricies) as I'll be
; describing everything using those terms. it also doesn't crank out the formal
; math notation on page.1 like every other math tutorial does :|
;

.macro  .move_polyobj_x
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.move_polyobj_x_small:                                                  ;$A44A
        ;-----------------------------------------------------------------------
        ; move the current poly-object's X position a small amount (9-bits) 
        ;
        ;       A = sign
        ;       R = X-amount to move object
        ;
        and # %10000000         ; only use the sign in A

move_polyobj_x:                                                         ;$A44C
        ;-----------------------------------------------------------------------
        ; move the current poly-object's X position (16-bits)
        ;
        ;       R = lo-byte of X-amount to move object
        ;       A = hi-byte of X-amount to move object
        ;
        asl                     ; shift the sign into carry
        sta ZP_VAR_S            ; set aside the magnitude (shifted left once,
                                ; must be shifted right to restore again)
        
        lda # $00
        ror                     ; restore sign
        sta ZP_VAR_T            ; put aside sign
        
        lsr ZP_VAR_S            ; restore the magnitude

        ; compare signs for working out what the final sign will be. XOR'ing
        ; the two operands will work out the +ve/-ve combination for us!
        ;
        ; +ve(0) + +ve(0) = +ve(0)
        ; +ve(0) + -ve(1) = -ve(1)
        ; -ve(1) + +ve(0) = -ve(1)
        ; -ve(1) + -ve(1) = +ve(0)
        ;
        eor ZP_POLYOBJ_XPOS_HI, x
        ; if the result will be negative, skip ahead
        bmi :+
           
        ; add `RS` to object's X-position 
        lda ZP_VAR_R
        adc ZP_POLYOBJ_XPOS_LO, x       ; if low-byte overflows, carry is set
        sta ZP_POLYOBJ_XPOS_LO, x
        lda ZP_VAR_S
        adc ZP_POLYOBJ_XPOS_MI, x       ; if middle-byte overflows, carry set
        sta ZP_POLYOBJ_XPOS_MI, x
        lda ZP_POLYOBJ_XPOS_HI, x
        adc # $00                       ; add carry to high-byte if it's set
            
        ; restore the sign taken at the beginning
        ora ZP_VAR_T
        sta ZP_POLYOBJ_XPOS_HI, x

        rts 

        ; handle negative result outcome;
        ; subtract `RS` from object's X-position
:       lda ZP_POLYOBJ_XPOS_LO, x                                      ;$A46F
        sec 
        sbc ZP_VAR_R                    ; subtract lo-byte `R`
        sta ZP_POLYOBJ_XPOS_LO, x
        lda ZP_POLYOBJ_XPOS_MI, x
        sbc ZP_VAR_S                    ; subtract hi-byte `S`
        sta ZP_POLYOBJ_XPOS_MI, x
        lda ZP_POLYOBJ_XPOS_HI, x
        and # %01111111                 ; mask sign before applying carry
        sbc # $00                       ; subtract carry if set
        ora # %10000000                 ; un-mask sign

        ; restore sign from beginning
        eor ZP_VAR_T
        sta ZP_POLYOBJ_XPOS_HI, x

        ; has the subtraction caused the X-position to go from positive
        ; to negative? e.g. 100 + -150 = -50
        bcs :+                          ; if no, skip over

        ; do a two's-compliment of the whole number --
        ; flipping the bits and adding one; done as '1 - number'
        ;
        lda # $01                       ; start with 1
        sbc ZP_POLYOBJ_XPOS_LO, x       ; subtract the low-byte
        sta ZP_POLYOBJ_XPOS_LO, x
        lda # $00                       ; zero in the middle byte,
        sbc ZP_POLYOBJ_XPOS_MI, x       ; and subtract the middle-byte
        sta ZP_POLYOBJ_XPOS_MI, x
        lda # $00                       ; zero in the high-byte,
        sbc ZP_POLYOBJ_XPOS_HI, x       ; and subract the high-byte
        and # %01111111                 ; remove old sign
        ora ZP_VAR_T                    ; set the sign
        sta ZP_POLYOBJ_XPOS_HI, x

:       rts                                                             ;$A4A0

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .rotate_polyobj_axis
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
; rotate a poly-object around a single axis:
;
;        Y = matrix row (0, 1 or 2), i.e. axis to rotate
; ZP_ALPHA = roll  (signed byte) -- rotation around the Z axis (in/out)
;  ZP_BETA = pitch (signed byte) -- rotation around the X axis (left/right)
;
; the BBC disassembly describes the matrix transformation here as:
; (I do not understand this at all)
;
; roll alpha=a pitch beta=b, z in direction of travel, y is vertical.
; [     ca    sa   0 ]    [  1 a  0]      [x]    [x + ay       ]
; [ -sa.cb ca.cb -sb ] -> [- a 1 -b]   so [y] -> [y - ax  -bz  ]
; [ -sa.sb ca.sb  cb ]    [-ab b  1]      [z]    [z + b(y - ax)]
;
; to the best I am able understand it, I believe
; this routine calculates the following:
;
;       Y' = ( ROLL_Z * -X ) + Y
;       X' = ( ROLL_Z *  Y') + X
;
;       Y' = (PITCH_X * -Z ) + Y
;       Z' = (PITCH_X *  Y') + Z
;
; this routine gets called three times in a row,
; once for each of the matrix rows
;
; TODO: do the full 3x3 rotation as one routine so as to be able to share
;       intermediate calculations and reduce the amount of math needed.
;       see: <http://realtimecollisiondetection.net/blog/?p=21>  
;
mYx0    = $00           ; column 0 of the matrix row given in Y (0, 1 or 2)
mYx0_LO = $00
mYx0_HI = $01
mYx1    = $02           ; column 1 of the matrix row given in Y (0, 1 or 2)
mYx1_LO = $02
mYx1_HI = $03
mYx2    = $04           ; column 2 of the matrix row given in Y (0, 1 or 2)
mYx2_LO = $04
mYx2_HI = $05

rotate_polyobj_axis:                                                    ;$A4A1
;===============================================================================
        ; compute the following:
        ;
        ;       mYx1 = (ALPHA * -mYx0) + mYx1
        ;       mYx0 = (ALPHA *  mYx1) + mYx0
        ;
        ; the `multiply_and_add` function is used,
        ; which requires the following variable setup:
        ;
        ;       X.A = Q * A + R.S 
        ;
        lda ZP_ALPHA                    ; our roll amount
        sta ZP_VAR_Q                    ; Q = ALPHA

        ; R.S = mYx1
        ;
        ldx ZP_POLYOBJ + mYx1_LO, y
        stx ZP_VAR_R
        ldx ZP_POLYOBJ + mYx1_HI, y
        stx ZP_VAR_S

        ldx ZP_POLYOBJ + mYx0_LO, y

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this instruction appears entirely unecessary as `multiply_and_add`
        ; will blindly overwrite `ZP_VAR_P` anyway. if compiling elite-harmless
        ; without the multiplication lookup-tables, this instruction is skipped
        stx ZP_VAR_P
.endif  ;///////////////////////////////////////////////////////////////////////
        lda ZP_POLYOBJ + mYx0_HI, y
        eor # %10000000                 ; flip the sign-bit
        
        jsr multiply_and_add            ; calculate! (Q, R & S are setup)
        sta ZP_POLYOBJ + mYx1_HI, y     ; write back the hi-byte
        stx ZP_POLYOBJ + mYx1_LO, y     ; write back the lo-byte

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; as before, this instruction is unecessary
        stx ZP_VAR_P
.endif  ;///////////////////////////////////////////////////////////////////////

        ; R.S = mYx0
        ;
        ldx ZP_POLYOBJ + mYx0_LO, y
        stx ZP_VAR_R
        ldx ZP_POLYOBJ + mYx0_HI, y
        stx ZP_VAR_S

        lda ZP_POLYOBJ + mYx1_HI, y
        jsr multiply_and_add
        sta ZP_POLYOBJ + mYx0_HI, y     ; write back the hi-byte
        stx ZP_POLYOBJ + mYx0_LO, y     ; write back the lo-byte

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; as before, this instruction is unecessary
        stx ZP_VAR_P
.endif  ;///////////////////////////////////////////////////////////////////////

        ; compute the following:
        ;
        ;       mYx1 = BETA * -mYx2 + mYx1
        ;       mYx2 = BETA *  mYx1 + mYx2
        ;
        lda ZP_BETA                     ; our pitch amount
        sta ZP_VAR_Q                    ; Q = BETA
        
        ; R.S = mYx1 
        ;
        ldx ZP_POLYOBJ + mYx1_LO, y
        stx ZP_VAR_R
        ldx ZP_POLYOBJ + mYx1_HI, y
        stx ZP_VAR_S
        
        ldx ZP_POLYOBJ + mYx2_LO, y

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; as before, this instruction is unecessary
        stx ZP_VAR_P
.endif  ;///////////////////////////////////////////////////////////////////////

        lda ZP_POLYOBJ + mYx2_HI, y
        eor # %10000000                 ; flip the sign-bit

        jsr multiply_and_add            ; calculate! (Q, R & S are setup)
        sta ZP_POLYOBJ + mYx1_HI, y     ; write back the hi-byte
        stx ZP_POLYOBJ + mYx1_LO, y     ; write back the lo-byte

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; as before, this instruction is unecessary
        stx ZP_VAR_P
.endif  ;///////////////////////////////////////////////////////////////////////
        ;
        ; R.S = mYx2
        ;
        ldx ZP_POLYOBJ + mYx2_LO, y
        stx ZP_VAR_R
        ldx ZP_POLYOBJ + mYx2_HI, y
        stx ZP_VAR_S
        
        lda ZP_POLYOBJ + mYx1_HI, y
        jsr multiply_and_add
        sta ZP_POLYOBJ + mYx2_HI, y     ; write back the hi-byte
        stx ZP_POLYOBJ + mYx2_LO, y     ; write back the lo-byte
        
        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

