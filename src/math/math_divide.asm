; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "math_divide.asm":
;

divide_unsigned:                                                        ;$3B37
;===============================================================================
; unsigned integer division:
;
; in:   A               ?
;       ZP_VAR_Q        ?
;
; returns:
;       A/Q*256 as 16-bit value in P.R  (A is the same as R on exit)
;
; TODO: use lookup table (ROM only?)
; TODO: A = R, so do away with R?
;-------------------------------------------------------------------------------
        ; This calculates A / Q by repeatedly shifting A (16bit) left
        ; and subtracting from the hi-byte whenever possible.
        asl 
        sta ZP_VAR_P
        
        lda # $00
        rol 
        cmp ZP_VAR_Q
        bcc :+        
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 1                                     ;$3B43
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 2                                     ;$3B4C
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 4                                     ;$3B55
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 8                                     ;$3B5E
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 16                                    ;$3B67
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 32                                    ;$3B70
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 64                                    ;$3B79
        rol 
        cmp ZP_VAR_Q
        bcc :+
        sbc ZP_VAR_Q

:       rol ZP_VAR_P            ; 128                                   ;$3B82
        
        ; end of P = A/Q
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ldx # $00               ; unneccessary, cancelled out by the tax below
.endif  ;///////////////////////////////////////////////////////////////////////
        sta ZP_B6               ; A and ZP_B6 are now both the remainder of A/Q
        tax 
        beq @3ba6               ; no remainder: finish

        ; calculate (remainder/Q)*256 via the log-tables
        lda table_logdiv, x
        ldx ZP_VAR_Q
        sec 
        sbc table_logdiv, x
        bmi @3bae
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs @3ba9               ; carry is set: log(remainder) < log(Q)
        tax 
        lda _9500, x
@3ba6:  sta ZP_VAR_R                                                    ;$3BA6

        rts 
        
        ;-----------------------------------------------------------------------
@3ba9:  lda # $ff                                                       ;$3BA9
        sta ZP_VAR_R
        rts 

        ;-----------------------------------------------------------------------                                                          
@3bae:  ldx ZP_B6                                                       ;$3ABE
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs @3ba9
        tax 
        lda _9600, x
        sta ZP_VAR_R

        rts 