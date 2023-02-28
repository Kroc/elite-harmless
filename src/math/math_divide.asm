; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_3B30"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

get_dust_speed:                                                         ;$3B30
;===============================================================================
; calculate dust speed:
;
; in:   Y                       dust particle index
;-------------------------------------------------------------------------------
        lda DUST_Z_HI, y

        ; fallthrough
        ; ...

divide_by_player_speed:                                                 ;$3B33
;===============================================================================
; divide the number, given in A, by the player's speed:
;-------------------------------------------------------------------------------
        sta Q
        lda ZP_PLAYER_SPEED

        ; fallthrough
        ; ...

divide_unsigned:                                                        ;$3B37
;===============================================================================
; unsigned integer division:
;
; in:   A                       ?
;       Q                       ?
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
        cmp Q
        bcc :+        
        sbc Q

:       rol ZP_VAR_P            ; 1                                     ;$3B43
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 2                                     ;$3B4C
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 4                                     ;$3B55
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 8                                     ;$3B5E
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 16                                    ;$3B67
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 32                                    ;$3B70
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 64                                    ;$3B79
        rol 
        cmp Q
        bcc :+
        sbc Q

:       rol ZP_VAR_P            ; 128                                   ;$3B82
        
        ; end of P = A/Q
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ldx # $00               ; unneccessary, cancelled out by the tax below
.endif  ;///////////////////////////////////////////////////////////////////////
        sta ZP_B6               ; A and ZP_B6 are now both the remainder of A/Q
        tax 
        beq @3ba6               ; no remainder: finish

        ; calculate (remainder/Q)*256 via the log-tables
        lda table_loglo, x
        ldx Q
        sec 
        sbc table_loglo, x
        bmi @3bae
        ldx ZP_B6
        lda table_log, x
        ldx Q
        sbc table_log, x
        bcs @3ba9               ; carry is set: log(remainder) < log(Q)
        tax 
        lda table_antilog, x
@3ba6:  sta R                                                           ;$3BA6

        rts 
        
        ;-----------------------------------------------------------------------
@3ba9:  lda # $ff                                                       ;$3BA9
        sta R
        rts 

        ;-----------------------------------------------------------------------
@3bae:  ldx ZP_B6                                                       ;$3ABE
        lda table_log, x
        ldx Q
        sbc table_log, x
        bcs @3ba9
        tax 
        lda table_antilog_odd, x
        sta R

        rts 


.segment        "CODE_99AF"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

math_divide_AQ:                                         ; BBC: LL28     ;$99AF
;===============================================================================
; divide A by Q:
;
; the result is multiplied by 256 to return a fractional value as a whole byte.
; the exact mathematics involved in log-based multiplication and division are
; extremely complex; an overview can be seen in Mark Moxon's BBC disassembly:
; <bbcelite.com/deep_dives/multiplication_and_division_using_logarithms.html>
;
; in:   A                       dividend -- number to divide
;       Q                       divisor  -- number dividing by
; out:  R                       quotient -- result, * 256
;-------------------------------------------------------------------------------
        cmp Q                   ; if A >= Q, the result won't fit,
        bcs @rtsff              ;  in which case just return $FF

        sta ZP_B6               ; preserve input dividend for reuse
        tax                     ; copy to X for a lookup in a moment

        beq :+                  ; 0*256 = 0, and anything divided by zero
                                ; ends the universe, but we will return zero
                                ; for convenience

        ; use the log tables: logs are the opposite of exponention (e.g.
        ; powers of 2). if multiplication can be represented by adding
        ; powers, then division can be represented by subtracting logs
        ;
        ; the log-lo table is used first to guage which
        ; method should be used for best accuracy
        ;
        lda table_loglo, x      ; look up log(2) lo-byte for the dividend
        ldx Q                   ; switch to the divisor
        sec                     ;  and subtract its log(2) lo-byte
        sbc table_loglo, x      ;  from the dividend's
        bmi @odd                ; if there's no underflow, use the odd method

        ;-----------------------------------------------------------------------
@even:  ldx ZP_B6               ; retrieve our input dividend value
        lda table_log, x        ; look that up in the log table
        ldx Q                   ; repeat this for the divisor
        sbc table_log, x        ;  and subtract the two
        bcs @rtsff              ; if log2(A) >= log2(Q) return $FF

        tax                     ; use the delta to look up the
        lda table_antilog, x    ;  result in the antilog (even) table

:       sta R                   ; return result in R                    ;$99D3
        rts

        ;-----------------------------------------------------------------------
@odd:   ldx ZP_B6               ; retrieve our input dividend value     ;$99D6
        lda table_log, x        ; look this up in the log table
        ldx Q                   ; repeat this for the divisor
        sbc table_log, x        ;  and subtract the two
        bcs @rtsff              ; if log2(A) >= log2(Q) return $FF

        tax                     ; use the delta to look up the
        lda table_antilog_odd, x;  result in the antilog (odd) table

        sta R                   ; return result in R
        rts 

        ; here follows the remnants of the older BBC
        ; code to do the division by rotation
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        bcs @rtsff              ; return $FF, presumably when A > Q     ; $99E9

        ldx # %11111110         ; this is a  7-bit train counter
        stx R                   ; the result will be rotated into R

@shift: asl                     ; pop a bit off dividend                ;$99EF
        bcs @sub                ; if carry, apply subtraction

        cmp Q
        bcc :+
        sbc Q
:       rol R                                                           ;$99F8
        bcs @shift              ; test for the ending flag,
        rts                     ;  else continue division

@sub:   sbc Q                   ; no test needed, A+carry is > Q        ;$99FD
        sec 
        rol R
        bcs @shift              ; test for the ending flag,

        lda R                   ; return A & R = result
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

@rtsff: lda # $ff                                                       ;$9A07
        sta R
        rts 