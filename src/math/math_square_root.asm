; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "math_square_root.asm":
;
.segment        "CODE_9978"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

square_root:                                                            ;$9978
;===============================================================================
; this calculates a very good approximation of the square root of R.Q
; Q = sqrt(R.Q)
;
; TODO: create a lookup table for this, for cart ROM
;-------------------------------------------------------------------------------
        ldy ZP_VAR_R
        lda ZP_VAR_Q
        sta ZP_VAR_S
        ldx # $00
        stx ZP_VAR_Q    ; X.Y.S = 0.R.Q ; Q = 0
        lda # $08
        sta ZP_VAR_T    ; REPEAT 8
@loop:                                                                  ;$9986
        cpx ZP_VAR_Q
        bcc @next       ; blt
        bne @inc
        cpy # $40
        bcc @next       ; if (X.Y >= Q.$40) increase else next
@inc:                                                                   ;$9990
        tya
        sbc # $40       ; carry is set
        tay
        txa
        sbc ZP_VAR_Q
        tax             ; X.Y -= Q.$40; Q++ (via carry used in rol below)
@next:                                                                  ;$9998
        rol ZP_VAR_Q    ; Q*=2 (+1 if carry set, see above)
        asl ZP_VAR_S
        tya
        rol
        tay
        txa
        rol
        tax
        asl ZP_VAR_S
        tya
        rol
        tay
        txa
        rol
        tax             ; X.Y.S *= 4
        dec ZP_VAR_T    
        bne @loop       ; ENDREP
        rts