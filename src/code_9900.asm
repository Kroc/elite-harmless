; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; NOTE: the segment that this code belongs to will be set by the including
;       file, e.g. "elite-original.asm" / "elite-harmless.asm"

; referenced in the `chrout` routine, these are a pair of hi/lo-byte lookup
; tables that index a row number (0-24) to the place in the menu screen memory
; where that row starts -- note that Elite uses a 32-char (256 px) wide
; 'screen' so this equates the the 4th character in each 40-char row
;
.define menuscr_pos \
        ELITE_MENUSCR_ADDR + .scrpos(  0, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  1, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  2, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  3, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  4, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  5, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  6, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  7, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  8, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  9, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 10, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 11, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 12, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 13, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 14, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 15, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 16, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 17, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 18, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 19, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 20, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 21, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 22, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 23, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 24, 3 )

menuscr_lo:                                                             ;$9900
        .lobytes menuscr_pos
menuscr_hi:                                                             ;$9919
        .hibytes menuscr_pos

;===============================================================================

_9932:                                                                  ;$9932
        jsr _9ad8
        jsr _7d1f
        ora ZP_POLYOBJ01_XPOS_pt2
        bne _995d

        lda ZP_43
        cmp # $8e
        bcs _995d

        ldy # $02
        jsr _9964
        ldy # $06

        lda ZP_43
        adc # $01
        jsr _9964

        lda # visibility::redraw
        ora ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY

        lda # $08
        jmp _a174

_995b:                                                                  ;$995B
        pla
        pla
_995d:                                                                  ;$995D
        lda # visibility::redraw ^$FF   ;=%11110111
        and ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY
        rts

;===============================================================================

_9964:                                                                  ;$9964
        sta [ZP_TEMP_ADDR2], y
        iny
        iny
        sta [ZP_TEMP_ADDR2], y
        lda ZP_POLYOBJ01_XPOS_pt1
        dey
        sta [ZP_TEMP_ADDR2], y
        adc # $03
        bcs _995b
        dey
        dey
        sta [ZP_TEMP_ADDR2], y
        rts

;===============================================================================
;   this calculates a very good approximation of the square root of R.Q
;   Q = sqrt(R.Q)
;
square_root:                                                            ;$9978

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
        bne @increase
        cpy # $40
        bcc @next       ; if (X.Y >= Q.$40) increase else next
@increase:                                                              ;$9990
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

;===============================================================================
; calculates A=R = A/Q*256 using log-tables. Uses A,X,B6
_99af:                                                                  ;$99AF
        cmp ZP_VAR_Q
        bcs _9a07           ; if (A>=Q) return $FF
        sta ZP_B6
        tax
        beq _99d3           ; if (A==0) return 0
        lda table_logdiv, x
        ldx ZP_VAR_Q
        sec
        sbc table_logdiv, x
        bmi _99d6
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _9a07           ; if (log(A)>=log(Q)) return $FF
        tax
        lda _9500, x
_99d3:                                                                  ;$99D3
        sta ZP_VAR_R
        rts

_99d6:                                                                  ;$99D6
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _9a07           ; if (log(A)>=log(Q)) return $FF
        tax
        lda _9600, x
        sta ZP_VAR_R
        rts

;===============================================================================
; unused / unreferenced?
; divides A=R = A/Q*256, possibly abandoned in favor of log-table division?
; this is of course slower, but does not use X
; the first statement, cmp ZP_VAR_Q seems to be missing
;$99e9:
        bcs _9a07           ; -> return $FF, presumably when A > Q
        ldx # $fe           ; 1-bit is not set and serves as the ending flag
        stx ZP_VAR_R
_99ef:                                                                  ;$99EF
        asl
        bcs _99fd           ; A overflows? continue at _99fd
        cmp ZP_VAR_Q
        bcc _99f8
        sbc ZP_VAR_Q
_99f8:                                                                  ;$99F8
        rol ZP_VAR_R
        bcs _99ef           ; test for the ending flag, else continue division
        rts

_99fd:  ; the first bit is shiftet out of A into the carry              ;$99FD
        sbc ZP_VAR_Q        ; no test needed, A+carry is > Q
        sec
        rol ZP_VAR_R
        bcs _99ef           ; test for the ending flag, else continue division
        lda ZP_VAR_R
        rts

_9a07:                                                                  ;$9A07
        lda # $ff
        sta ZP_VAR_R
        rts

;===============================================================================
; returns A=Q+R, sign-bit S. regards two sign-bits in A,S.
; only uses A (and stack). this is another example of the curious
; "unsigned value+sign bit" math used at many places in Elite.
; TODO: name proposal? add_bytes_external_sign?
; we probably need a consistent naming for both the
; unsigned_with_sign_bit and the unsigned_with_external_sign-variables
_9a0c:                                                                  ;$9A0C
        eor ZP_VAR_S
        bmi _9a16           ; if (sign1 == sign2) return Q+R, keep sign
        lda ZP_VAR_Q
        clc
        adc ZP_VAR_R
        rts

_9a16:                                                                  ;$9A16
        lda ZP_VAR_R
        sec
        sbc ZP_VAR_Q
        bcc _9a1f           ; if (R>=Q) return R-Q
        clc
        rts

_9a1f:                                                                  ;$9A1F
        pha
        lda ZP_VAR_S        ; if (R<Q) sign=-sign; return Q-R
        eor # %10000000
        sta ZP_VAR_S
        pla
        eor # %11111111
        adc # $01
        rts

;===============================================================================

_9a2c:                                                                  ;$9A2C
        ldx # $00
        ldy # $00
_9a30:                                                                  ;$9A30
        lda ZP_VAR_X
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_MATRIX, x
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_T
        lda ZP_VAR_Y
        eor ZP_TEMPOBJ_M2x0_HI, x
        sta ZP_VAR_S
        lda ZP_VAR_X2
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_M2x1_LO, x
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_VAR_Y2
        eor ZP_TEMPOBJ_M2x1_HI, x
        jsr _9a0c
        sta ZP_VAR_T
        lda ZP_6F
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_M2x2_LO, x
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_70
        eor ZP_TEMPOBJ_M2x2_HI, x
        jsr _9a0c
        sta ZP_71, y
        lda ZP_VAR_S
        sta ZP_72, y
        iny
        iny
        txa
        clc
        adc # $06
        tax
        cmp # $11
        bcc _9a30
        rts

;===============================================================================

_9a83:                                                                  ;$9A83
        jmp _7d62

_9a86:                                                                  ;$9A86
        lda ZP_A5
        bmi _9a83
        lda # $1f
        sta ZP_AD

        lda ZP_POLYOBJ_BEHAVIOUR
        bmi _9ad8

        lda # visibility::display
        bit ZP_POLYOBJ_VISIBILITY
        bne _9ac5
        bpl _9ac5

        ora ZP_POLYOBJ_VISIBILITY
        and # (visibility::exploding | visibility::firing)^$FF  ;=%00111111
        sta ZP_POLYOBJ_VISIBILITY
        lda # $00
        ldy # $1c
        sta [ZP_POLYOBJ_ADDR], y
        ldy # $1e
        sta [ZP_POLYOBJ_ADDR], y
        jsr _9ad8
        ldy # $01
        lda # $12
        sta [ZP_TEMP_ADDR2], y

        ldy # Hull::_07                  ;=$07: "explosion count"?
        lda [ZP_HULL_ADDR], y

        ldy # $02                       ;?
        sta [ZP_TEMP_ADDR2], y
_9abb:                                                                  ;$9ABB
        iny
        jsr get_random_number
        sta [ZP_TEMP_ADDR2], y
        cpy # $06
        bne _9abb
_9ac5:                                                                  ;$9AC5
        lda ZP_POLYOBJ_ZPOS_HI
        bpl _9ae6
_9ac9:                                                                  ;$9AC9
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9ad8

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::redraw ^$FF   ;=%11110111
        sta ZP_POLYOBJ_VISIBILITY
        jmp _7866

_9ad8:                                                                  ;$9AD8
        lda # visibility::redraw
        bit ZP_POLYOBJ_VISIBILITY
        beq _9ae5
        eor ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY
        jmp _a178

_9ae5:                                                                  ;$9AE5
        rts

_9ae6:                                                                  ;$9AE6
        lda ZP_POLYOBJ_ZPOS_MI
        cmp # $c0
        bcs _9ac9
        lda ZP_POLYOBJ_XPOS_LO
        cmp ZP_POLYOBJ_ZPOS_LO
        lda ZP_POLYOBJ_XPOS_MI
        sbc ZP_POLYOBJ_ZPOS_MI
        bcs _9ac9
        lda ZP_POLYOBJ_YPOS_LO
        cmp ZP_POLYOBJ_ZPOS_LO
        lda ZP_POLYOBJ_YPOS_MI
        sbc ZP_POLYOBJ_ZPOS_MI
        bcs _9ac9

        ldy # Hull::_06                 ;=$06: "gun vertex"?
        lda [ZP_HULL_ADDR], y
        tax

        lda # $ff
        sta $0100, x
        sta $0101, x
        lda ZP_POLYOBJ_ZPOS_LO
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        lsr
        ror ZP_VAR_T
        lsr
        ror ZP_VAR_T
        lsr
        ror ZP_VAR_T
        lsr
        bne _9b29
        lda ZP_VAR_T
        ror
        lsr
        lsr
        lsr
        sta ZP_AD
        bpl _9b3a
_9b29:                                                                  ;$9B29
        ldy # Hull::_0d                 ;=$0D: level-of-detail distance
        lda [ZP_HULL_ADDR], y
        cmp ZP_POLYOBJ_ZPOS_MI
        bcs _9b3a

        lda # visibility::display
        and ZP_POLYOBJ_VISIBILITY
        bne _9b3a
        jmp _9932

_9b3a:                                                                  ;$9B3A
        ldx # $05                       ; 6-byte counter

        ; take a copy of matrix 2x0, 2x1 & 2x2
:       lda ZP_POLYOBJ_M2x0, x                                          ;$9B3C
        sta ZP_TEMPOBJ_M2x0, x
        ; take a copy of matrix 1x0, 1x1 & 1x2
        lda ZP_POLYOBJ_M1x0, x
        sta ZP_TEMPOBJ_M1x0, x
        ; take a copy of matrix 0x0, 0x1 & 0x2
        lda ZP_POLYOBJ_M0x0, x
        sta ZP_TEMPOBJ_M0x0, x
        dex
        bpl :-

        lda # $c5
        sta ZP_VAR_Q
        ldy # $10
_9b51:                                                                  ;$9B51
        lda ZP_TEMPOBJ_M2x0_LO, y
        asl
        lda ZP_TEMPOBJ_M2x0_HI, y
        rol
        jsr _99af
        ldx ZP_VAR_R
        stx ZP_TEMPOBJ_MATRIX, y
        dey
        dey
        bpl _9b51
        ldx # $08
_9b66:                                                                  ;$9B66
        lda ZP_POLYOBJ_XPOS_LO, x
        sta ZP_85, x
        dex
        bpl _9b66

        lda # $ff
        sta ZP_44

        ldy # Hull::face_count          ;=$0C: face count
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9b8b
        lda [ZP_HULL_ADDR], y
        lsr
        lsr
        tax
        lda # $ff
_9b80:                                                                  ;$9B80
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex
        bpl _9b80
        inx
        stx ZP_AD
_9b88:                                                                  ;$9B88
        jmp _9cfe

_9b8b:                                                                  ;$9B8B
        lda [ZP_HULL_ADDR], y
        beq _9b88
        sta ZP_AE

        ldy # Hull::_12                 ;=$12: "scaling of normals"?
        lda [ZP_HULL_ADDR], y
        tax
        lda ZP_8C
        tay
        beq _9baa
_9b9b:                                                                  ;$9B9B
        inx
        lsr ZP_89
        ror ZP_88
        lsr ZP_86
        ror ZP_85
        lsr
        ror ZP_8B
        tay
        bne _9b9b
_9baa:                                                                  ;$9BAA
        stx ZP_9F
        lda ZP_8D
        sta ZP_70
        lda ZP_85
        sta ZP_VAR_X
        lda ZP_87
        sta ZP_VAR_Y
        lda ZP_88
        sta ZP_VAR_X2
        lda ZP_8A
        sta ZP_VAR_Y2
        lda ZP_8B
        sta ZP_6F
        jsr _9a2c
        lda ZP_71
        sta ZP_85
        lda ZP_72
        sta ZP_87
        lda ZP_73
        sta ZP_88
        lda ZP_74
        sta ZP_8A
        lda ZP_75
        sta ZP_8B
        lda ZP_76
        sta ZP_8D

        ldy # Hull::face_data_lo
        lda [ZP_HULL_ADDR], y
        clc
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR3_LO

        ldy # Hull::face_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR3_HI

        ldy # Hull::_00         ;=$00: "scoop / debris"?
_9bf2:                                                                  ;$9BF2
        lda [ZP_TEMP_ADDR3], y
        sta ZP_72
        and # %00011111
        cmp ZP_AD
        bcs _9c0b
        tya
        lsr
        lsr
        tax
        lda # $ff
        sta ZP_POLYOBJ01_XPOS_pt1, x
        tya
        adc # $04
        tay
        jmp _9cf7

_9c0b:                                                                  ;$9C0B
        lda ZP_72
        asl
        sta ZP_74
        asl
        sta ZP_76
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_71
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_73
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_75
        ldx ZP_9F
        cpx # $04
        bcc _9c4b
        lda ZP_85
        sta ZP_VAR_X
        lda ZP_87
        sta ZP_VAR_Y
        lda ZP_88
        sta ZP_VAR_X2
        lda ZP_8A
        sta ZP_VAR_Y2
        lda ZP_8B
        sta ZP_6F
        lda ZP_8D
        sta ZP_70
        jmp _9ca9

;===============================================================================

_9c43:                                                                  ;$9C43
        lsr ZP_85
        lsr ZP_8B
        lsr ZP_88
        ldx # $01
_9c4b:                                                                  ;$9C4B
        lda ZP_71
        sta ZP_VAR_X
        lda ZP_73
        sta ZP_VAR_X2
        lda ZP_75
        dex
        bmi _9c60
_9c58:                                                                  ;$9C58
        lsr ZP_VAR_X
        lsr ZP_VAR_X2
        lsr
        dex
        bpl _9c58
_9c60:                                                                  ;$9C60
        sta ZP_VAR_R
        lda ZP_76
        sta ZP_VAR_S
        lda ZP_8B
        sta ZP_VAR_Q
        lda ZP_8D
        jsr _9a0c
        bcs _9c43
        sta ZP_6F
        lda ZP_VAR_S
        sta ZP_70
        lda ZP_VAR_X
        sta ZP_VAR_R
        lda ZP_72
        sta ZP_VAR_S
        lda ZP_85
        sta ZP_VAR_Q
        lda ZP_87
        jsr _9a0c
        bcs _9c43
        sta ZP_VAR_X
        lda ZP_VAR_S
        sta ZP_VAR_Y
        lda ZP_VAR_X2
        sta ZP_VAR_R
        lda ZP_74
        sta ZP_VAR_S
        lda ZP_88
        sta ZP_VAR_Q
        lda ZP_8A
        jsr _9a0c
        bcs _9c43
        sta ZP_VAR_X2
        lda ZP_VAR_S
        sta ZP_VAR_Y2
_9ca9:                                                                  ;$9CA9
        lda ZP_71
        sta ZP_VAR_Q
        lda ZP_VAR_X
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_T
        lda ZP_72
        eor ZP_VAR_Y
        sta ZP_VAR_S
        lda ZP_73
        sta ZP_VAR_Q
        lda ZP_VAR_X2
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_74
        eor ZP_VAR_Y2
        jsr _9a0c
        sta ZP_VAR_T
        lda ZP_75
        sta ZP_VAR_Q
        lda ZP_6F
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_70
        eor ZP_76
        jsr _9a0c
        pha
        tya
        lsr
        lsr
        tax
        pla
        bit ZP_VAR_S
        bmi _9cf4
        lda # $00
_9cf4:                                                                  ;$9CF4
        sta ZP_POLYOBJ01_XPOS_pt1, x
        iny
_9cf7:                                                                  ;$9CF7
        cpy ZP_AE
        bcs _9cfe
        jmp _9bf2

        ;-----------------------------------------------------------------------

_9cfe:                                                                  ;$9CFE
        ldy ZP_TEMPOBJ_M2x1_LO
        ldx ZP_TEMPOBJ_M2x1_HI
        lda ZP_TEMPOBJ_M1x0_LO
        sta ZP_TEMPOBJ_M2x1_LO
        lda ZP_TEMPOBJ_M1x0_HI
        sta ZP_TEMPOBJ_M2x1_HI
        sty ZP_TEMPOBJ_M1x0_LO
        stx ZP_TEMPOBJ_M1x0_HI
        ldy ZP_TEMPOBJ_M2x2_LO
        ldx ZP_TEMPOBJ_M2x2_HI
        lda ZP_TEMPOBJ_M0x0_LO
        sta ZP_TEMPOBJ_M2x2_LO
        lda ZP_TEMPOBJ_M0x0_HI
        sta ZP_TEMPOBJ_M2x2_HI
        sty ZP_TEMPOBJ_M0x0_LO
        stx ZP_TEMPOBJ_M0x0_HI
        ldy ZP_TEMPOBJ_M1x2_LO
        ldx ZP_TEMPOBJ_M1x2_HI
        lda ZP_TEMPOBJ_M0x1_LO
        sta ZP_TEMPOBJ_M1x2_LO
        lda ZP_TEMPOBJ_M0x1_HI
        sta ZP_TEMPOBJ_M1x2_HI
        sty ZP_TEMPOBJ_M0x1_LO
        stx ZP_TEMPOBJ_M0x1_HI

        ldy # Hull::_08         ;=$08: verticies byte length
        lda [ZP_HULL_ADDR], y
        sta ZP_AE

        lda ZP_HULL_ADDR_LO
        clc
        adc # $14
        sta ZP_TEMP_ADDR3_LO
        lda ZP_HULL_ADDR_HI
        adc # $00
        sta ZP_TEMP_ADDR3_HI
        ldy # $00
        sty ZP_AA
_9d45:                                                                  ;$9D45
        sty ZP_9F
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_X
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_X2
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_6F
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_T
        and # %00011111
        cmp ZP_AD
        bcc _9d8e
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_P1
        and # %00001111
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        lda ZP_VAR_P1
        lsr
        lsr
        lsr
        lsr
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_P1
        and # %00001111
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        lda ZP_VAR_P1
        lsr
        lsr
        lsr
        lsr
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
_9d8e:                                                                  ;$9D8E
        jmp _9f06

        ;-----------------------------------------------------------------------

_9d91:                                                                  ;$9D91
        lda ZP_VAR_T
        sta ZP_VAR_Y
        asl
        sta ZP_VAR_Y2
        asl
        sta ZP_70
        jsr _9a2c
        lda ZP_POLYOBJ_XPOS_HI
        sta ZP_VAR_X2
        eor ZP_72
        bmi _9db6
        clc
        lda ZP_71
        adc ZP_POLYOBJ_XPOS_LO
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_MI
        adc # $00
        sta ZP_VAR_Y
_9db3:                                                                  ;$9DB3
        jmp _9dd9

_9db6:                                                                  ;$9DB6
        lda ZP_POLYOBJ_XPOS_LO
        sec
        sbc ZP_71
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_MI
        sbc # $00
        sta ZP_VAR_Y
        bcs _9dd9
        eor # %11111111
        sta ZP_VAR_Y
        lda # $01
        sbc ZP_VAR_X
        sta ZP_VAR_X
        bcc _9dd3
        inc ZP_VAR_Y
_9dd3:                                                                  ;$9DD3
        lda ZP_VAR_X2
        eor # %10000000
        sta ZP_VAR_X2
_9dd9:                                                                  ;$9DD9
        lda ZP_POLYOBJ_YPOS_HI
        sta ZP_70
        eor ZP_74
        bmi _9df1
        clc
        lda ZP_73
        adc ZP_POLYOBJ_YPOS_LO
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_MI
        adc # $00
        sta ZP_6F
_9dee:                                                                  ;$9DEE
        jmp _9e16

        ;-----------------------------------------------------------------------

_9df1:                                                                  ;$9DF1
        lda ZP_POLYOBJ_YPOS_LO
        sec
        sbc ZP_73
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_MI
        sbc # $00
        sta ZP_6F
        bcs _9e16
        eor # %11111111
        sta ZP_6F
        lda ZP_VAR_Y2
        eor # %11111111
        adc # $01
        sta ZP_VAR_Y2
        lda ZP_70
        eor # %10000000
        sta ZP_70
        bcc _9e16
        inc ZP_6F
_9e16:                                                                  ;$9E16
        lda ZP_76
        bmi _9e64
        lda ZP_75
        clc
        adc ZP_POLYOBJ_ZPOS_LO
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        adc # $00
        sta ZP_VAR_U
_9e27:                                                                  ;$9E27
        jmp _9e83

;===============================================================================

_9e2a:                                                                  ;$9E2A
        ldx ZP_VAR_Q
        beq _9e4a
        ldx # $00
_9e30:                                                                  ;$9E30
        lsr
        inx
        cmp ZP_VAR_Q
        bcs _9e30
        stx ZP_VAR_S
        jsr _99af
        ldx ZP_VAR_S
        lda ZP_VAR_R
_9e3f:                                                                  ;$9E3F
        asl
        rol ZP_VAR_U
        bmi _9e4a
        dex
        bne _9e3f
        sta ZP_VAR_R
        rts

_9e4a:                                                                  ;$9E4A
        lda # $32
        sta ZP_VAR_R
        sta ZP_VAR_U
        rts

;===============================================================================

_9e51:                                                                  ;$9E51
        lda # $80
        sec
        sbc ZP_VAR_R
        sta $0100, x
        inx
        lda # $00
        sbc ZP_VAR_U
        sta $0100, x
        jmp _9ec3

;===============================================================================

_9e64:                                                                  ;$9E64
        lda ZP_POLYOBJ_ZPOS_LO
        sec
        sbc ZP_75
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        sbc # $00
        sta ZP_VAR_U
        bcc _9e7b
        bne _9e83
        lda ZP_VAR_T
        cmp # $04
        bcs _9e83
_9e7b:                                                                  ;$9E7B
        lda # $00
        sta ZP_VAR_U
        lda # $04
        sta ZP_VAR_T
_9e83:                                                                  ;$9E83
        lda ZP_VAR_U
        ora ZP_VAR_Y
        ora ZP_6F
        beq _9e9a
        lsr ZP_VAR_Y
        ror ZP_VAR_X
        lsr ZP_6F
        ror ZP_VAR_Y2
        lsr ZP_VAR_U
        ror ZP_VAR_T
        jmp _9e83

_9e9a:                                                                  ;$9E9A
        lda ZP_VAR_T
        sta ZP_VAR_Q
        lda ZP_VAR_X
        cmp ZP_VAR_Q
        bcc _9eaa
        jsr _9e2a
        jmp _9ead

_9eaa:                                                                  ;$9EAA
        jsr _99af
_9ead:                                                                  ;$9EAD
        ldx ZP_AA
        lda ZP_VAR_X2
        bmi _9e51
        lda ZP_VAR_R
        clc
        adc # $80
        sta $0100, x
        inx
        lda ZP_VAR_U
        adc # $00
        sta $0100, x
_9ec3:                                                                  ;$9EC3
       .phx                     ; push X to stack (via A)
        lda # $00
        sta ZP_VAR_U
        lda ZP_VAR_T
        sta ZP_VAR_Q
        lda ZP_VAR_Y2
        cmp ZP_VAR_Q
        bcc _9eec
        jsr _9e2a
        jmp _9eef

_9ed9:                                                                  ;$9ED9
        lda # $48
        clc
        adc ZP_VAR_R
        sta $0100, x
        inx
        lda # $00
        adc ZP_VAR_U
        sta $0100, x
        jmp _9f06

_9eec:                                                                  ;$9EEC
        jsr _99af
_9eef:                                                                  ;$9EEF
        pla
        tax
        inx
        lda ZP_70
        bmi _9ed9
        lda # $48
        sec
        sbc ZP_VAR_R
        sta $0100, x
        inx
        lda # $00
        sbc ZP_VAR_U
        sta $0100, x
_9f06:                                                                  ;$9F06
        clc
        lda ZP_AA
        adc # $04
        sta ZP_AA
        lda ZP_9F
        adc # $06
        tay
        bcs _9f1b
        cmp ZP_AE
        bcs _9f1b
        jmp _9d45

_9f1b:                                                                  ;$9F1B
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9f2a

        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::redraw
        sta ZP_POLYOBJ_VISIBILITY
        jmp _7866

_9f2a:                                                                  ;$9F2A
        lda # visibility::redraw
        bit ZP_POLYOBJ_VISIBILITY
        beq _9f35
        jsr _a178
        lda # visibility::redraw
_9f35:                                                                  ;$9F35
        ora ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY

        ldy # Hull::edge_count  ;=$09: edge count
        lda [ZP_HULL_ADDR], y
        sta ZP_AE

        ldy # $00
        sty ZP_VAR_U
        sty ZP_9F
        inc ZP_VAR_U
        bit ZP_POLYOBJ_VISIBILITY
        bvc _9f9f
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::firing ^$FF
        sta ZP_POLYOBJ_VISIBILITY

        ldy # Hull::_06         ;=$06: gun vertex
        lda [ZP_HULL_ADDR], y
        tay
        ldx $0100, y
        stx ZP_VAR_X
        inx
        beq _9f9f
        ldx $0101, y
        stx ZP_VAR_Y
        inx
        beq _9f9f
        ldx $0102, y
        stx ZP_VAR_X2
        ldx $0103, y
        stx ZP_VAR_Y2
        lda # $00
        sta ZP_6F
        sta ZP_70
        sta ZP_72
        lda ZP_POLYOBJ_ZPOS_LO
        sta ZP_71
        lda ZP_POLYOBJ_XPOS_HI
        bpl _9f82
        dec ZP_6F
_9f82:                                                                  ;$9F82
        jsr _a013
        bcs _9f9f
        ldy ZP_VAR_U
        lda ZP_VAR_X
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_Y
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_X2
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_Y2
        sta [ZP_TEMP_ADDR2], y
        iny
        sty ZP_VAR_U
_9f9f:                                                                  ;$9F9F
        ldy # Hull::edge_data_lo
        clc
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR3_LO

        ldy # Hull::edge_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR3_HI

        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_VAR

        ldy ZP_9F
_9fb8:                                                                  ;$9FB8
        lda [ZP_TEMP_ADDR3], y
        cmp ZP_AD
        bcc _9fd6
        iny
        lda [ZP_TEMP_ADDR3], y
        iny
        sta ZP_VAR_P1
        and # %00001111
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9fd9
        lda ZP_VAR_P1
        lsr
        lsr
        lsr
        lsr
        tax
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9fd9
_9fd6:                                                                  ;$9FD6
        jmp _a15b

_9fd9:                                                                  ;$9FD9
        lda [ZP_TEMP_ADDR3], y
        tax
        iny
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_Q
        lda $0101, x
        sta ZP_VAR_Y
        lda $0100, x
        sta ZP_VAR_X
        lda $0102, x
        sta ZP_VAR_X2
        lda $0103, x
        sta ZP_VAR_Y2
        ldx ZP_VAR_Q
        lda $0100, x
        sta ZP_6F
        lda $0103, x
        sta ZP_72
        lda $0102, x
        sta ZP_71
        lda $0101, x
        sta ZP_70
        jsr _a01a
        bcs _9fd6
        jmp _a13f

;===============================================================================

_a013:                                                                  ;$A013
        lda # $00
        sta VAR_06F4
        lda ZP_70
_a01a:                                                                  ;$A01A
        bit ZP_B7
        bmi _a03c
        ldx # $8f
        ora ZP_72
        bne _a02a
        cpx ZP_71
        bcc _a02a
        ldx # $00
_a02a:                                                                  ;$A02A
        stx ZP_A2
        lda ZP_VAR_Y
        ora ZP_VAR_Y2
        bne _a04e
        lda # $8f
        cmp ZP_VAR_X2
        bcc _a04e
        lda ZP_A2
        bne _a04c
_a03c:                                                                  ;$A03C
        lda ZP_VAR_X2
        sta ZP_VAR_Y
        lda ZP_6F
        sta ZP_VAR_X2
        lda ZP_71
        sta ZP_VAR_Y2
        clc
        rts

;===============================================================================

_a04a:                                                                  ;$A04A
        sec
        rts

_a04c:                                                                  ;$A04C
        lsr ZP_A2
_a04e:                                                                  ;$A04E
        lda ZP_A2
        bpl _a081
        lda ZP_VAR_Y
        and ZP_70
        bmi _a04a
        lda ZP_VAR_Y2
        and ZP_72
        bmi _a04a
        ldx ZP_VAR_Y
        dex
        txa
        ldx ZP_70
        dex
        stx ZP_73
        ora ZP_73
        bpl _a04a
        lda ZP_VAR_X2
        cmp # $90
        lda ZP_VAR_Y2
        sbc # $00
        sta ZP_73
        lda ZP_71
        cmp # $90
        lda ZP_72
        sbc # $00
        ora ZP_73
        bpl _a04a
_a081:                                                                  ;$A081
       .phy                     ; push Y to stack (via A)
        lda ZP_6F
        sec
        sbc ZP_VAR_X
        sta ZP_73
        lda ZP_70
        sbc ZP_VAR_Y
        sta ZP_74
        lda ZP_71
        sec
        sbc ZP_VAR_X2
        sta ZP_75
        lda ZP_72
        sbc ZP_VAR_Y2
        sta ZP_76
        eor ZP_74
        sta ZP_VAR_S
        lda ZP_76
        bpl _a0b2
        lda # $00
        sec
        sbc ZP_75
        sta ZP_75
        lda # $00
        sbc ZP_76
        sta ZP_76
_a0b2:                                                                  ;$A0B2
        lda ZP_74
        bpl _a0c1
        sec
        lda # $00
        sbc ZP_73
        sta ZP_73
        lda # $00
        sbc ZP_74
_a0c1:                                                                  ;$A0C1
        tax
        bne _a0c8
        ldx ZP_76
        beq _a0d2
_a0c8:                                                                  ;$A0C8
        lsr
        ror ZP_73
        lsr ZP_76
        ror ZP_75
        jmp _a0c1

        ;-----------------------------------------------------------------------

_a0d2:                                                                  ;$A0D2
        stx ZP_VAR_T
        lda ZP_73
        cmp ZP_75
        bcc _a0e4
        sta ZP_VAR_Q
        lda ZP_75
        jsr _99af
        jmp _a0ef

_a0e4:                                                                  ;$A0E4
        lda ZP_75
        sta ZP_VAR_Q
        lda ZP_73
        jsr _99af
        dec ZP_VAR_T
_a0ef:                                                                  ;$A0EF
        lda ZP_VAR_R
        sta ZP_73
        lda ZP_VAR_S
        sta ZP_74
        lda ZP_A2
        beq _a0fd
        bpl _a110
_a0fd:                                                                  ;$A0FD
        jsr _a19f
        lda ZP_A2
        bpl _a136
        lda ZP_VAR_Y
        ora ZP_VAR_Y2
        bne _a13b
        lda ZP_VAR_X2
        cmp # $90
        bcs _a13b
_a110:                                                                  ;$A110
        ldx ZP_VAR_X
        lda ZP_6F
        sta ZP_VAR_X
        stx ZP_6F
        lda ZP_70
        ldx ZP_VAR_Y
        stx ZP_70
        sta ZP_VAR_Y
        ldx ZP_VAR_X2
        lda ZP_71
        sta ZP_VAR_X2
        stx ZP_71
        lda ZP_72
        ldx ZP_VAR_Y2
        stx ZP_72
        sta ZP_VAR_Y2
        jsr _a19f
        dec VAR_06F4
_a136:                                                                  ;$A136
        pla
        tay
        jmp _a03c

        ;-----------------------------------------------------------------------

_a13b:                                                                  ;$A13B
        pla
        tay
        sec
        rts

;===============================================================================

_a13f:                                                                  ;$A13F
        ldy ZP_VAR_U
        lda ZP_VAR_X
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_Y
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_X2
        sta [ZP_TEMP_ADDR2], y
        iny
        lda ZP_VAR_Y2
        sta [ZP_TEMP_ADDR2], y
        iny
        sty ZP_VAR_U
        cpy ZP_TEMP_VAR
        bcs _a172
_a15b:                                                                  ;$A15B
        inc ZP_9F
        ldy ZP_9F
        cpy ZP_AE
        bcs _a172
        ldy # $00
        lda ZP_TEMP_ADDR3_LO
        adc # $04
        sta ZP_TEMP_ADDR3_LO
        bcc _a16f
        inc ZP_TEMP_ADDR3_HI
_a16f:                                                                  ;$A16F
        jmp _9fb8

        ;-----------------------------------------------------------------------

_a172:                                                                  ;$A172
        lda ZP_VAR_U
_a174:                                                                  ;$A174
        ldy # $00
        sta [ZP_TEMP_ADDR2], y
_a178:                                                                  ;$A178
        ldy # $00
        lda [ZP_TEMP_ADDR2], y
        sta ZP_AE
        cmp # $04
        bcc _a19e
        iny
_a183:                                                                  ;$A183
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_X
        iny
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Y
        iny
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_X2
        iny
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Y2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line
        iny
        cpy ZP_AE
        bcc _a183
_a19e:                                                                  ;$A19E
        rts

;===============================================================================

_a19f:                                                                  ;$A19F
        lda ZP_VAR_Y
        bpl _a1ba
        sta ZP_VAR_S
        jsr _a219
        txa
        clc
        adc ZP_VAR_X2
        sta ZP_VAR_X2
        tya
        adc ZP_VAR_Y2
        sta ZP_VAR_Y2
        lda # $00
        sta ZP_VAR_X
        sta ZP_VAR_Y
        tax
_a1ba:                                                                  ;$A1BA
        beq _a1d5
        sta ZP_VAR_S
        dec ZP_VAR_S
        jsr _a219
        txa
        clc
        adc ZP_VAR_X2
        sta ZP_VAR_X2
        tya
        adc ZP_VAR_Y2
        sta ZP_VAR_Y2
        ldx # $ff
        stx ZP_VAR_X
        inx
        stx ZP_VAR_Y
_a1d5:                                                                  ;$A1D5
        lda ZP_VAR_Y2
        bpl _a1f3
        sta ZP_VAR_S
        lda ZP_VAR_X2
        sta ZP_VAR_R
        jsr _a248
        txa
        clc
        adc ZP_VAR_X
        sta ZP_VAR_X
        tya
        adc ZP_VAR_Y
        sta ZP_VAR_Y
        lda # $00
        sta ZP_VAR_X2
        sta ZP_VAR_Y2
_a1f3:                                                                  ;$A1F3
        lda ZP_VAR_X2
        sec
        sbc # $90
        sta ZP_VAR_R
        lda ZP_VAR_Y2
        sbc # $00
        sta ZP_VAR_S
        bcc _a218
        jsr _a248
        txa
        clc
        adc ZP_VAR_X
        sta ZP_VAR_X
        tya
        adc ZP_VAR_Y
        sta ZP_VAR_Y
        lda # $8f
        sta ZP_VAR_X2
        lda # $00
        sta ZP_VAR_Y2
_a218:                                                                  ;$A218
        rts

;===============================================================================

_a219:                                                                  ;$A219
        lda ZP_VAR_X
        sta ZP_VAR_R
        jsr _a284
        pha
        ldx ZP_VAR_T
        bne _a250
_a225:                                                                  ;$A225
        lda # $00
        tax
        tay
        lsr ZP_VAR_S
        ror ZP_VAR_R
        asl ZP_VAR_Q
        bcc _a23a
_a231:                                                                  ;$A231
        txa
        clc
        adc ZP_VAR_R
        tax
        tya
        adc ZP_VAR_S
        tay
_a23a:                                                                  ;$A23A
        lsr ZP_VAR_S
        ror ZP_VAR_R
        asl ZP_VAR_Q
        bcs _a231
        bne _a23a
        pla
        bpl _a277
        rts

;===============================================================================

_a248:                                                                  ;$A248
        jsr _a284
        pha
        ldx ZP_VAR_T
        bne _a225
_a250:                                                                  ;$A250
        lda # $ff
        tay
        asl
        tax
_a255:                                                                  ;$A255
        asl ZP_VAR_R
        rol ZP_VAR_S
        lda ZP_VAR_S
        bcs _a261
        cmp ZP_VAR_Q
        bcc _a26c
_a261:                                                                  ;$A261
        sbc ZP_VAR_Q
        sta ZP_VAR_S
        lda ZP_VAR_R
        sbc # $00
        sta ZP_VAR_R
        sec
_a26c:                                                                  ;$A26C
        txa
        rol
        tax
        tya
        rol
        tay
        bcs _a255
        pla
        bmi _a283
_a277:                                                                  ;$A277
        txa
        eor # %11111111
        adc # $01
        tax
        tya
        eor # %11111111
        adc # $00
        tay
_a283:                                                                  ;$A283
        rts

;===============================================================================

_a284:                                                                  ;$A284
        ldx ZP_73
        stx ZP_VAR_Q
        lda ZP_VAR_S
        bpl _a29d
        lda # $00
        sec
        sbc ZP_VAR_R
        sta ZP_VAR_R
        lda ZP_VAR_S
        pha
        eor # %11111111
        adc # $00
        sta ZP_VAR_S
        pla
_a29d:                                                                  ;$A29D
        eor ZP_74
        rts

;===============================================================================
; process object? checks if A.I. needs running and appears to rotate and move
; the objcet
;
;       X = ship type (i.e. a `hull_pointers` index)
;
_a2a0:                                                                  ;$A2A0
        ; is the ship exploding? must be 'near'
        ; (i.e. not a distant dot), and in exploding state
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::exploding | visibility::display
       .bnz _a2cb

        ; handle explosion?

        lda ZP_A3               ; move counter?
        eor ZP_9D
        and # %00001111
        bne _a2b1
        jsr _9105
_a2b1:                                                                  ;$A2B1
        ldx ZP_A5
        bpl _a2b8
        jmp _a53d

        ;-----------------------------------------------------------------------
        ; is the A.I. active?
        ;
_a2b8:  lda ZP_POLYOBJ_ATTACK   ; check current A.I. state              ;$A2B8
        bpl _a2cb               ; is bit 7 ("active") set?

        ;is this a missile?
        cpx # hull_missile_index
        ; missiles always run A.I. every frame
        beq :+

        ; should we run an A.I. check? when the A.I. is not "active",
        ; it runs at a much lower rate. these instructions here gear-down
        ; the ratio
        ;
        lda ZP_A3               ; move counter?
        eor ZP_9D
        and # %00000111         ; modulo 8
        bne _a2cb

        ; handle A.I.
:       jsr _32ad                                                       ;$A2C8

_a2cb:                                                                  ;$A2CB
        jsr _b410

        lda ZP_POLYOBJ_VERTX_LO
        asl                     ; x2
        asl                     ; x4 (i.e. each vertex is 4 bytes)
        sta ZP_VAR_Q

        lda ZP_POLYOBJ_M0x0_HI
        and # %01111111         ; remove sign
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_R

        lda ZP_POLYOBJ_M0x0_HI
        ldx # $00
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_M0x1_HI
        and # %01111111
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_R

        lda ZP_POLYOBJ_M0x1_HI
        ldx # $03
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_M0x2_HI
        and # %01111111
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_R

        lda ZP_POLYOBJ_M0x2_HI
        ldx # $06
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_VERTX_LO
        clc
        adc ZP_POLYOBJ_VERTX_HI
        bpl :+
        lda # $00
:       ldy # Hull::speed       ;=$0F                                   ;$A30D
        cmp [ZP_HULL_ADDR], y
        bcc :+
        lda [ZP_HULL_ADDR], y
:       sta ZP_POLYOBJ_VERTX_LO                                         ;$A315

        lda # $00
        sta ZP_POLYOBJ_VERTX_HI

        ldx ZP_ROLL_MAGNITUDE

        lda ZP_POLYOBJ_XPOS_LO
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_POLYOBJ_XPOS_MI
        jsr _3a25
        sta ZP_VAR_P3

        lda ZP_6A               ; move count?
        eor ZP_POLYOBJ_XPOS_HI
        ldx # $03
        jsr _a508
        sta ZP_B5

        lda ZP_VAR_P2
        sta ZP_B3
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_VAR_P3
        sta ZP_B4
        ldx ZP_PITCH_MAGNITUDE
        jsr _3a25
        sta ZP_VAR_P3

        lda ZP_B5
        eor ZP_PITCH_SIGN
        ldx # $06
        jsr _a508
        sta ZP_POLYOBJ_ZPOS_HI

        lda ZP_VAR_P2
        sta ZP_POLYOBJ_ZPOS_LO
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_VAR_P3
        sta ZP_POLYOBJ_ZPOS_MI

        jsr _3a27
        sta ZP_VAR_P3

        lda ZP_B5
        sta ZP_POLYOBJ_YPOS_HI
        eor ZP_PITCH_SIGN
        eor ZP_POLYOBJ_ZPOS_HI
        bpl :+

        lda ZP_VAR_P2
        adc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO

        lda ZP_VAR_P3
        adc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI

        jmp _a39d

:       lda ZP_B3                                                       ;$A37D
        sbc ZP_VAR_P2
        sta ZP_POLYOBJ_YPOS_LO
        lda ZP_B4
        sbc ZP_VAR_P3
        sta ZP_POLYOBJ_YPOS_MI
        bcs _a39d
        lda # $01
        sbc ZP_POLYOBJ_YPOS_LO
        sta ZP_POLYOBJ_YPOS_LO
        lda # $00
        sbc ZP_POLYOBJ_YPOS_MI
        sta ZP_POLYOBJ_YPOS_MI
        lda ZP_POLYOBJ_YPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_YPOS_HI
_a39d:                                                                  ;$A39D
        ldx ZP_ROLL_MAGNITUDE
        lda ZP_POLYOBJ_YPOS_LO
        eor # %11111111
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_YPOS_MI
        jsr _3a25
        sta ZP_VAR_P3
        lda ZP_ROLL_SIGN        ; roll sign?
        eor ZP_POLYOBJ_YPOS_HI
        ldx # $00
        jsr _a508
        sta ZP_POLYOBJ_XPOS_HI
        lda ZP_VAR_P3
        sta ZP_POLYOBJ_XPOS_MI
        lda ZP_VAR_P2
        sta ZP_POLYOBJ_XPOS_LO
_a3bf:                                                                  ;$A3BF
        lda PLAYER_SPEED
        sta ZP_VAR_R

        lda # $80
        ldx # $06
        jsr move_polyobj_x

        lda ZP_A5
        and # %10000001
        cmp # $81
        bne :+

        rts

        ;-----------------------------------------------------------------------
        ; apply the roll & pitch rotation to the poly-object's compound matrix.
        ; this creates a single matrix that can apply both roll & pitch to the
        ; verticies in one operation, i.e. we do not have to calculate roll &
        ; pitch separately for each vertex point in the shape
        ;
:       ldy # MATRIX_ROW_0                                              ;$A3D3
        jsr rotate_polyobj_axis
        ldy # MATRIX_ROW_1
        jsr rotate_polyobj_axis
        ldy # MATRIX_ROW_2
        jsr rotate_polyobj_axis

        ; slowly dampen pitch rate toward zero:
        ;-----------------------------------------------------------------------
        ; separate out the pitch sign
        ; (positive / negative)
        ;
        lda ZP_POLYOBJ_PITCH    ; current pitch rate
        and # %10000000         ; isolate pitch sign
        sta ZP_B1               ; put aside sign

        ; TODO: we could use a register transfer instead of doing LDA again
        ; i.e. use `tay` to keep `ZP_POLYOBJ_PITCH` for next use

        ; get the pitch rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_POLYOBJ_PITCH
        and # %01111111         ; isolate pitch magnitude
        beq :+                  ; skip if pitch is level (= %x0000000)

        ; on the 6502 `cmp` effectively subtracts the given value from A
        ; but doesn't write the result back, setting the flags as the result;
        ; if A is less than *or equal to* the value, carry will be set.
        ;
        ; this means that if we compare the magnitude, without sign (%x0000001
        ; to %x1111111), with `%x1111111` then no matter what the magnitude,
        ; the carry *will* be set. when we call 'SuBtract with Carry' only 1
        ; will be subtracted, not the actual difference between the two!
        ;
        cmp # %01111111         ; carry will be set if pitch <= %x1111111,
        sbc # $00               ; and 1 will be subtracted instead of 0
        ora ZP_B1               ; add the sign back in
        sta ZP_POLYOBJ_PITCH    ; save back the pitch rate

        ldx # $0f
        ldy # $09
        jsr _2dc5               ; move ship?
        ldx # $11
        ldy # $0b
        jsr _2dc5               ; move ship?
        ldx # $13
        ldy # $0d
        jsr _2dc5               ; move ship?

        ; slowly dampen roll rate toward zero:
        ;-----------------------------------------------------------------------
        ; separate out the roll sign
        ; (positive / negative)
        ;
:       lda ZP_POLYOBJ_ROLL     ; current roll rate                     ;$A40B
        and # %10000000         ; isolate roll sign
        sta ZP_B1               ; put aside sign

        ; get the roll rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_POLYOBJ_ROLL
        and # %01111111         ; isolate roll magnitude
        beq :+                  ; skip if roll is level (= %x0000000)

        cmp # %01111111         ; carry will be set if roll <= %x1111111,
        sbc # $00               ; and 1 will be subtracted instead of 0
        ora ZP_B1               ; add the sign back in
        sta ZP_POLYOBJ_ROLL     ; save back the roll rate

        ldx # $0f
        ldy # $15
        jsr _2dc5               ; move ship?
        ldx # $11
        ldy # $17
        jsr _2dc5               ; move ship?
        ldx # $13
        ldy # $19
        jsr _2dc5

:       lda ZP_POLYOBJ_VISIBILITY                                       ;$A434
        and # visibility::exploding | visibility::display
        bne :+
        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::scanner
        sta ZP_POLYOBJ_VISIBILITY
        jmp _b410

        ;-----------------------------------------------------------------------

:       lda ZP_POLYOBJ_VISIBILITY                                       ;$A443
        and # visibility::scanner ^$FF
        sta ZP_POLYOBJ_VISIBILITY
        rts

;===============================================================================
; insert these routines from "math_3d.inc"
;
.move_polyobj_x                                                         ;$A44A
.rotate_polyobj_axis                                                    ;$A4A1

;===============================================================================

_a508:                                                                  ;$A508
        tay
        eor ZP_POLYOBJ_XPOS_HI, x
        bmi _a51c
        lda ZP_VAR_P2
        clc
        adc ZP_POLYOBJ_XPOS_LO, x
        sta ZP_VAR_P2
        lda ZP_VAR_P3
        adc ZP_POLYOBJ_XPOS_MI, x
        sta ZP_VAR_P3
        tya
        rts

        ;-----------------------------------------------------------------------

_a51c:                                                                  ;$A51C
        lda ZP_POLYOBJ_XPOS_LO, x
        sec
        sbc ZP_VAR_P2
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_XPOS_MI, x
        sbc ZP_VAR_P3
        sta ZP_VAR_P3
        bcc _a52f
        tya
        eor # %10000000
        rts

        ;-----------------------------------------------------------------------

_a52f:                                                                  ;$A52F
        lda # $01
        sbc ZP_VAR_P2
        sta ZP_VAR_P2
        lda # $00
        sbc ZP_VAR_P3
        sta ZP_VAR_P3
        tya
        rts

;===============================================================================

_a53d:                                                                  ;$A53D
        lda ZP_ALPHA
        eor # %10000000
        sta ZP_VAR_Q

        lda ZP_POLYOBJ_XPOS_LO
        sta ZP_VAR_P1

        lda ZP_POLYOBJ_XPOS_MI
        sta ZP_VAR_P2

        lda ZP_POLYOBJ_XPOS_HI
        jsr _38f8

        ldx # $03
        jsr _2d69

        lda ZP_VALUE_pt2
        sta ZP_B3
        sta ZP_VAR_P1

        lda ZP_VALUE_pt3
        sta ZP_B4
        sta ZP_VAR_P2

        lda $63
        sta ZP_VAR_Q

        lda ZP_VALUE_pt4
        sta ZP_B5

        jsr _38f8

        ldx # $06
        jsr _2d69

        lda ZP_VALUE_pt2
        sta ZP_VAR_P1
        sta ZP_POLYOBJ_ZPOS_LO

        lda ZP_VALUE_pt3
        sta ZP_VAR_P2
        sta ZP_POLYOBJ_ZPOS_MI

        lda ZP_VALUE_pt4
        sta ZP_POLYOBJ_ZPOS_HI
        eor # %10000000
        jsr _38f8

        lda ZP_VALUE_pt4
        and # %10000000
        sta ZP_VAR_T
        eor ZP_B5
        bmi _a5a8

        lda ZP_VALUE_pt1
        clc
        adc ZP_B2

        lda ZP_VALUE_pt2
        adc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO

        lda ZP_VALUE_pt3
        adc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI

        lda ZP_VALUE_pt4
        adc ZP_B5

        jmp _a5db

_a5a8:                                                                  ;$A5A8
        lda ZP_VALUE_pt1
        sec
        sbc ZP_B2
        lda ZP_VALUE_pt2
        sbc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO
        lda ZP_VALUE_pt3
        sbc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI
        lda ZP_B5
        and # %01111111
        sta ZP_VAR_P1
        lda ZP_VALUE_pt4
        and # %01111111
        sbc ZP_VAR_P1
        sta ZP_VAR_P1
        bcs _a5db
        lda # $01
        sbc ZP_POLYOBJ_YPOS_LO
        sta ZP_POLYOBJ_YPOS_LO
        lda # $00
        sbc ZP_POLYOBJ_YPOS_MI
        sta ZP_POLYOBJ_YPOS_MI
        lda # $00
        sbc ZP_VAR_P1
        ora # %10000000
_a5db:                                                                  ;$A5DB
        eor ZP_VAR_T
        sta ZP_POLYOBJ_YPOS_HI
        lda ZP_ALPHA
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_YPOS_LO
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_YPOS_MI
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_YPOS_HI
        jsr _38f8
        ldx # $00
        jsr _2d69
        lda ZP_VALUE_pt2
        sta ZP_POLYOBJ_XPOS_LO
        lda ZP_VALUE_pt3
        sta ZP_POLYOBJ_XPOS_MI
        lda ZP_VALUE_pt4
        sta ZP_POLYOBJ_XPOS_HI
        jmp _a3bf

;===============================================================================

; what calls in to this, where?

_a604:                                                                  ;$A604
        sec
        ldy # $00
        sty ZP_TEMP_ADDR3_LO
        ldx # $10
        lda [ZP_TEMP_ADDR1], y
        txa
_a60e:                                                                  ;$A60E
        stx ZP_TEMP_ADDR3_HI
        sty ZP_VAR_T
        adc [ZP_TEMP_ADDR3], y
        eor ZP_VAR_T
        sbc ZP_TEMP_ADDR3_HI
        dey
        bne _a60e
        inx
        cpx # $a0
        bcc _a60e
        cmp _1d21
        bne _a604

        rts

;===============================================================================

_a626:                                                                  ;$A626

        ldx COCKPIT_VIEW
        beq _a65e
        dex
        bne _a65f
        ; adjust for rear view: invert sign of X,Z. Up stays up, so Y is ok.
        lda ZP_POLYOBJ_XPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_XPOS_HI
        lda ZP_POLYOBJ_ZPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_ZPOS_HI
        lda ZP_POLYOBJ_M0x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M0x0_HI
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M0x2_HI
        lda ZP_POLYOBJ_M1x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M1x0_HI
        lda ZP_POLYOBJ_M1x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M1x2_HI
        lda ZP_POLYOBJ_M2x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        lda ZP_POLYOBJ_M2x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M2x2_HI
_a65e:                                                                  ;$A65E
        ; adjust for front view: this is the default view, all is ok.
        rts

        ;-----------------------------------------------------------------------

_a65f:                                                                  ;$A65F
        ; adjust for side view: swap Z and X, invert according to B0
        ; B0 is set when view is RIGHT (see)
        lda # $00
        cpx # $02               ; X is COCKPIT_VIEW-1, so this checks for RIGHT
        ror
        sta ZP_B1               
        eor # %10000000
        sta ZP_B0
        lda ZP_POLYOBJ_XPOS_LO
        ldx ZP_POLYOBJ_ZPOS_LO
        sta ZP_POLYOBJ_ZPOS_LO
        stx ZP_POLYOBJ_XPOS_LO
        lda ZP_POLYOBJ_XPOS_MI
        ldx ZP_POLYOBJ_ZPOS_MI
        sta ZP_POLYOBJ_ZPOS_MI
        stx ZP_POLYOBJ_XPOS_MI
        lda ZP_POLYOBJ_XPOS_HI  
        eor ZP_B0                   ; invert X-sign when looking LEFT
        tax
        lda ZP_POLYOBJ_ZPOS_HI
        eor ZP_B1                   ; invert X-sign when looking RIGHT
        sta ZP_POLYOBJ_XPOS_HI
        stx ZP_POLYOBJ_ZPOS_HI
        ldy # $09
        jsr _a693
        ldy # $0f
        jsr _a693
        ldy # $15
_a693:                                                                  ;$A693
        lda ZP_POLYOBJ_XPOS_LO, y
        ldx ZP_POLYOBJ_YPOS_MI, y
        sta ZP_POLYOBJ_YPOS_MI, y
        stx ZP_POLYOBJ_XPOS_LO, y
        lda ZP_POLYOBJ_XPOS_MI, y
        eor ZP_B0
        tax
        lda ZP_POLYOBJ_YPOS_HI, y
        eor ZP_B1
        sta ZP_POLYOBJ_XPOS_MI, y
        stx ZP_POLYOBJ_YPOS_HI, y
_a6ad:                                                                  ;$A6AD
        rts

;===============================================================================

_a6ae:                                                                  ;$A6AE
        stx COCKPIT_VIEW
        jsr set_page
        jsr _a6d4
        jmp _7af3

;===============================================================================
; set cockpit view (front / rear / left / right)
;
;       X = $00 = front
;           $01 = rear
;           $02 = left
;           $03 = right
;
_a6ba:                                                                  ;$A6BA
        lda # $00

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ldy ZP_SCREEN
        bne _a6ae

        cpx COCKPIT_VIEW
        beq _a6ad               ; view did not change, rts
        stx COCKPIT_VIEW

        jsr set_page
        jsr dust_swap_xy        ; is this an opt: avoid rand
        jsr _7b1a
_a6d4:                                                                  ;$A6D4

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn the I/O area on to manage the sprites
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; TODO: is this instruction unecessary?
        ldy COCKPIT_VIEW        ; current viewpoint (front, rear, left, right)

        lda PLAYER_LASERS, y    ; get type of laser for current viewpoint
        beq _a700               ; no laser? skip ahead

        ; the index of the first sprite is entirely dependent on where
        ; sprites are located in the selected VIC bank; see "elite.inc"
        ; for where this value is defined
        ldy # ELITE_SPRITES_INDEX
        cmp # $0f               ; a type of laser?
        beq :+
        iny                     ; select next sprite index
        cmp # $8f               ; a type of laser?
        beq :+
        iny                     ; select next sprite index
        cmp # $97               ; a type of laser?
        beq :+
        iny                     ; select next sprite index

        ; the indices for the 8 hardware sprites are stored just after
        ; the 1'000 bytes used for the screen RAM. since Elite has two
        ; screens (flight or docked+menus), the sprite index needs to
        ; be set for both screens
        ;
:       sty ELITE_MENUSCR_ADDR + VIC_SPRITE0_PTR                        ;$A6F2
        sty ELITE_MAINSCR_ADDR + VIC_SPRITE0_PTR

        ; set colour of cross-hairs
        ; according to type of laser
        ;
        lda _3ea8 - ELITE_SPRITES_INDEX, y
        sta VIC_SPRITE0_COLOR

        ; mark the cross-hairs sprite as enabled
        lda # %00000001

_a700:                                                                  ;$A700

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_T

        lda PLAYER_TRUMBLES_HI
        and # %01111111
        lsr
        lsr
        lsr
        lsr
        tax
        lda trumbles_sprite_count, x
        sta TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
        lda trumbles_sprite_mask, x
        ora ZP_VAR_T            ; other sprites mask?
        sta VIC_SPRITE_ENABLE
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jmp set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
        rts
.endif  ;///////////////////////////////////////////////////////////////////////

.ifndef OPTION_NOTRUMBLES
;///////////////////////////////////////////////////////////////////////////////

trumbles_sprite_count:                                                  ;$A71F
        ;-----------------------------------------------------------------------
        .byte   $00, $01, $02, $03, $04, $05, $06, $06

trumbles_sprite_mask:                                                   ;$A727
        ;-----------------------------------------------------------------------
        ; table of bit-masks for which sprites to enable for Trumbles™.
        ; up to six Trumbles™ can appear on-screen, two sprites are always
        ; reserved for other uses (cross-hair and explosion-sprite)
        ;
        .byte   %00000000
        .byte   %00000100
        .byte   %00001100
        .byte   %00011100
        .byte   %00111100
        .byte   %01111100
        .byte   %11111100
        .byte   %11111100

;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================
; switch screen page?
;
;       A = page to switch to; e.g. cockpit-view, galactic chart &c.
;
set_page:                                                               ;$A72F
        sta ZP_SCREEN
_a731:                                                                  ;$A731
        jsr txt_docked_token02

        lda # $00
        sta ZP_7E               ; "arc counter"?

        lda # %10000000
        sta ZP_34
        sta txt_lcase_flag

        jsr _7b4f

        lda # $00
        sta VAR_0484
        sta VAR_048B
        sta VAR_048C

        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        jsr clear_screen

        ; display hyperspace countdown in the menu screens?

        ldx ZP_66               ; hyperspace countdown (outer)?
        beq _a75d

        jsr _7224

_a75d:                                                                  ;$A75D
        lda # 1
        jsr set_cursor_row

        ; are we in the cockpit-view?
        lda ZP_SCREEN
        bne :+

        lda # 11
        jsr set_cursor_col

        lda COCKPIT_VIEW
        ora # %01100000
        jsr print_flight_token
        jsr print_space

.import TXT_VIEW:direct

        lda # TXT_VIEW
        jsr print_flight_token

:       ldx # 1                                                         ;$A77B
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW

        dex
        stx ZP_34

.ifdef  OPTION_ORIGINAL
        rts
.endif

;===============================================================================

_a785:                                                                  ;$A785
        rts

_a786:                                                                  ;$A786
        lda # $00
        sta ZP_67
        sta VAR_0481

        jsr _b0fd
        ldy # $09
        jmp _a822

;===============================================================================

_a795:                                                                  ;$A795
        ldx # $01
        jsr _3708
        bcc _a785
        lda # $78
        jsr _900d
        ldy # $04
        jmp _a858

_a7a6:                                                                  ;$A7A6
;===============================================================================
; kill a PolyObject?
;
        lda VAR_04CB
        clc
        adc hull_d062, x
        sta VAR_04CB

        ; add fractional kill value?
        lda VAR_04E0
        adc hull_d083, x
        sta VAR_04E0

        bcc _a7c3               ; < 1.0

        inc PLAYER_KILLS        ; +1

        lda # $65
        jsr _900d
_a7c3:                                                                  ;$A7C3
        lda ZP_POLYOBJ_ZPOS_MI
        ldx # $0b
        cmp # $10
        bcs _a7db
        inx
        cmp # $08
        bcs _a7db
        inx
        cmp # $06
        bcs _a7db
        inx
        cmp # $03
        bcs _a7db
        inx
_a7db:                                                                  ;$A7DB
        txa
        asl
        asl
        asl
        asl
        ora # %00000011
        ldy # $03
        ldx # $51
        jmp _a850

;===============================================================================

_a7e9:                                                                  ;$A7E9
        lda ZP_POLYOBJ_ZPOS_MI
        ldx # $0b
        cmp # $08
        bcs _a801
        inx
        cmp # $04
        bcs _a801
        inx
        cmp # $03
        bcs _a801
        inx
        cmp # $02
        bcs _a801
        inx
_a801:                                                                  ;$A801
        txa
        asl
        asl
        asl
        asl
        ora # %00000011
        ldy # $02
        ldx # $d0
        jmp _a850


_a80f:                                                                  ;$A80F
;===============================================================================
        ldy # $05
        bne _a858               ; always branches

_a813:                                                                  ;$A813
;===============================================================================
        ldy # $03
        bne _a858               ; always branches

_a817:                                                                  ;$A817
;===============================================================================
        ldy # $03
        lda # $01

:       sta _aa15, y                                                    ;$A81B
        dey
        bne :-
_a821:                                                                  ;$A821
        rts

;===============================================================================

_a822:                                                                  ;$A822
        ldx # $03
        iny
        sty ZP_VAR_X2
_a827:                                                                  ;$A827
        dex
        bmi _a821
        lda _aa13, x
        and # %00111111
        cmp ZP_VAR_X2
        bne _a827
        lda # $01
        sta _aa16, x
        rts


_a839:                                                                  ;$A839
;===============================================================================
; called only by `_3795`
;
        ldy # $07
        lda # $f5
        ldx # $f0
        jsr _a850

        ldy # $04
        jsr _a858

        ; wait until the next frame:
        ; SPEED: could just call `wait_for_frame` instead
        ldy # 1
        jsr wait_frames

        ldy # $87
        bne _a858               ; awlays branches

;===============================================================================
;       A = X1
;       X = Y1
;       Y = ?
;
_a850:                                                                  ;$A850
        bit _a821               ; an unused skip?

        sta ZP_VAR_X1
        stx ZP_VAR_Y1
        ; this causes the `clv` below to become a `branch on overflow clear`
        ; to $A811 -- the address is defined by the opcode of `clv` ($B8)
.ifdef  OPTION_ORIGINAL
        .byte   $50
.else
        .byte   $a5             ; lda ZP
.endif

_a858:                                                                  ;$A858
;       Y = $00-$0F?

        clv

        ; do nothing if an option is set?
        lda _1d05
        bne _a821               ; `rts`

        ldx # $02
        iny                     ; use Y 1-based
        sty ZP_VAR_X2
        dey                     ; return to 0-based for the lookup
        lda _aa32, y
        lsr                     ; check bit 1 by pushing it off
        bcs @_a876              ; did the bit fall into the carry?

:       lda _aa13, x                                                    ;$A86A
        and # %00111111
        cmp ZP_VAR_X2
        beq @_a88b
        dex
        bpl :-

@_a876:                                                                 ;$A876
        ldx # $00
        lda _aa19
        cmp _aa1a
        bcc :+
        inx
        lda _aa1a

:       cmp _aa1b                                                       ;$A884
        bcc @_a88b
        ldx # $02

@_a88b:                                                                  ;$A88B
        tya
        and # %01111111
        tay
        lda _aa32, y
        cmp _aa19, x
        bcc _a821

        sei                     ; disable interrupts
        sta _aa19, x
        bvs _a8a0+1
        lda _aa82, y
_a8a0:                                                                  ;$A8A0
       .cmp
        lda ZP_VAR_X
        sta _aa29, x
        lda _aa42, y
        sta _aa16, x
        lda _aa92, y
        sta _aa1d, x
        lda _aa62, y
        sta _aa23, x
        bvs _a8bd+1
        lda _aa52, y
_a8bd:                                                                  ;$A8BD
       .cmp
        lda ZP_VAR_Y
        sta _aa20, x
        lda _aa72, y
        sta _aa26, x
        lda _aaa2, y
        sta _aa2c, x
        iny
        tya
        ora # %10000000
        sta _aa13, x

        cli                     ; enable interrupts
        sec                     ; exit with carry set
        rts

;===============================================================================

_a8d9:                                                                  ;$A8D9
        .byte   $00

; these are VIC_LAYOUT states
_a8da:                                                                  ;$A8DA
        .byte   ELITE_VIC_LAYOUT_MENUSCR
_a8db:                                                                  ;$A8DB
        .byte   ELITE_VIC_LAYOUT_MENUSCR

; this is a toggle for `_a8d9`
_a8dc:                                                                  ;$A8DC
        .byte   $01, $00

; these are VIC_RASTER values
_a8de:                                                                  ;$A8DE
        ; top of screen, plus height of viewport
        .byte   51 + ELITE_VIEWPORT_HEIGHT-1
        ; scanline 51, 2nd pixel row in screen
        ; i.e. changes after the yellow border at the top
        .byte   51

; these are VIC_SCREEN_CTL2 states
_a8e0:                                                                  ;$A8E0
        .byte   %11000000
_a8e1:                                                                  ;$A8E1
        .byte   %11000000

; these are VIC_SPRITE_MULTICOLOR states
_a8e2:                                                                  ;$A8E2
        .byte   %11111110, %11111100

; these are VIC_SPRITE1_COLOR states
_a8e4:                                                                  ;$A8E4
        .byte   RED, BLACK
_a8e6:                                                                  ;$A8E6
        .byte   $00, $00

; e-bomb explosion?
;
_a8e8:                                                                  ;$A8E8
        ;-----------------------------------------------------------------------
        dey
        bpl _a958
        pla
        tay

interrupt_end_XA:                                                       ;$A8ED
        ;=======================================================================
        ; interrupt finished! restores X & A.
        ;
       .plx                     ; restore X

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================
; this is Elite's main interrupt routine
;
interrupt:                                                              ;$A8FA

        pha                     ; preserve A

        ; the current memory map (BASIC, KERNAL, and/or I/O) could be anything
        ; when this interrupt occurs; for the purposes of the interrupt routine
        ; we want to have the ROMs off and I/O on
        ;
        ; in the original Elite code, changing the memory map is handled by
        ; a central routine `set_memory_layout` which keeps a record of the
        ; "current" state. assuming that this routine is *always* used when
        ; changing the memory map, the interrupt routine can restore the
        ; previous state
        ;
        lda CPU_CONTROL         ; read current memory map

.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless, we use an optimisation technique described by
        ; Gregory Naçu in his article "The 6510 Processor Port":
        ; <http://www.c64os.com/post?p=83>
        ;
        ; this method removes the need to store extra state, doesn't require
        ; an expensive subroutine and doesn't even use any registers(!) but
        ; it does mean we have to be very, very careful that before we change
        ; it, the memory map is guaranteed to be an expected value every time
        ; (otherwise the machine usually crashes hard)
        ;
        ; the interrupt routine complicates this as we cannot guarantee that
        ; the memory map will be a certain value any time the interrupt occurs.
        ; nested interrupts (when an interrupt interrupts an interrupt) need to
        ; be handled too, so whilst the original code 'knows' what memory map
        ; to return to, elite-harmless pushes the current value to the stack
        ; during the interrupt. whilst this adds 3 cycles to the initialisation
        ; it does greatly reduce the cleanup at the end -- a simple pull and
        ; set (7 cycles) does everything, without needing to `lda, and, ora`
        ; first and then set (12 cycles)
        ;
        pha                     ; push current memory-map value on stack
.endif  ;///////////////////////////////////////////////////////////////////////
        and # %11111000         ; mask out current value in the memory map bits
        ora # C64_MEM::IO_ONLY  ; set I/O on, ROMs off
        sta CPU_CONTROL         ; make it so!

        ; acknowledge the interrupt?
        lda VIC_INTERRUPT_STATUS
        ora # %10000000
        sta VIC_INTERRUPT_STATUS

       .phx                     ; push X to stack (via A)

        ldx _a8d9

        ; flicker the VIC memory map!?
        ; the two values are the same, so this does nothing in practice
        ;
        lda _a8da, x
        sta VIC_LAYOUT

        lda _a8e0, x
        sta VIC_SCREEN_CTL2

        lda _a8de, x
        sta VIC_RASTER

        lda _a8e2, x
        sta VIC_SPRITE_MULTICOLOR

        lda _a8e4, x
        sta VIC_SPRITE1_COLOR

        ; flash screen with e-bomb explosion?
        bit PLAYER_EBOMB
        bpl :+
        inc _a8e6           ; only the viewport-bgcolor is changed
:       lda _a8e6, x                                                    ;$A936
        sta VIC_BACKGROUND

        ; fetch the next interrupt index (currently 0->1->0...)
        ; this toggles the interrupt index in the same frame.
        lda _a8dc, x
        sta _a8d9

        ; exit when this is not the last interrupt of this frame
        ; (the interrupt directly before the HUD, so the next index is zero)
        ; everything that follows shall only be don 1x per frame
       .bnz interrupt_end_XA

        ; push Y to stack (via A).
        ; from this point we must restore Y before ending the interrupt,
        ; so a different exit point is used than the one above
       .phy

        bit _1d03               ; if this option,
        bpl _a956               ; is off, skip ahead

.ifndef OPTION_NOSOUND
        ;///////////////////////////////////////////////////////////////////////
        jsr _b4d2               ; handle music?
.endif  ;///////////////////////////////////////////////////////////////////////

        bit _1d12               ; sound effects enabled?
        bmi _a956               ; yes, do SFX

        jmp interrupt_end_YXA

_a956:                                                                  ;$A956
        ldy # $02
_a958:                                                                  ;$A958
        lda _aa13, y
        beq _a8e8
        bmi _a969

        ldx _aa2f, y
        lda _aa1d, y
        beq _a9ae
        bne _a990
_a969:                                                                  ;$A969
        lda _aa2f, y
        sta _a973+1             ;low-byte, i.e. $d4xx
        lda # $00
        ldx # $06
_a973:                                                                  ;$A973
        sta SID_VOICE1, x
        dex
        bpl _a973
        ldx _aa2f, y
        lda _aa23, y
        sta SID_VOICE1_CTRL, x
        lda _aa26, y
        sta SID_VOICE1_ATKDCY, x
        lda _aa29, y
        sta SID_VOICE1_SUSREL, x
        lda # $00
_a990:                                                                  ;$A990
        clc
        cld
        adc _aa20, y
        sta _aa20, y
        pha
        lsr
        lsr
        sta SID_VOICE1_FREQ_HI, x
        pla
        asl
        asl
        asl
        asl
        asl
        asl
        sta SID_VOICE1_FREQ_LO, x
        lda _aa1c
        sta SID_VOICE1_PULSE_HI, x
_a9ae:                                                                  ;$A9AE
        lda _aa13, y
        bmi _a9f1
        tya
        tax
        dec _aa19, x
        bne _a9bd
        inc _aa19, x
_a9bd:                                                                  ;$A9BD
        dec _aa16, x
        beq _a9dc
        lda _aa16, x
        and _aa2c, y
        bne _a9f6
        lda _aa29, y
        sec
        sbc # $10
        sta _aa29, y
        ldx _aa2f, y
        sta SID_VOICE1_SUSREL, x
        jmp _a9f6

_a9dc:                                                                  ;$A9DC
        ldx _aa2f, y
        lda _aa23, y
        and # %11111110
        sta SID_VOICE1_CTRL, x
        lda # $00
        sta _aa13, y
        sta _aa19, y
        beq _a9f6
_a9f1:                                                                  ;$A9F1
        and # %01111111
        sta _aa13, y
_a9f6:                                                                  ;$A9F6
        dey
        bmi _a9fc
        jmp _a958

_a9fc:                                                                  ;$A9FC
        lda _aa1c
        eor # %00000100
        sta _aa1c

interrupt_end_YXA:                                                      ;$AA04
        ;-----------------------------------------------------------------------
       .ply                     ; restore Y
       .plx                     ; restore X

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================

_aa13:                                                                  ;$AA13
        .byte   $00, $00
_aa15:                                                                  ;$AA15
        .byte   $00
_aa16:                                                                  ;$AA16
        .byte   $00, $00, $00
_aa19:                                                                  ;$AA19
        .byte   $00
_aa1a:                                                                  ;$AA1A
        .byte   $00
_aa1b:                                                                  ;$AA1B
        .byte   $00
_aa1c:                                                                  ;$AA1C
        .byte   $02
_aa1d:                                                                  ;$AA1D
        .byte   $00, $00, $00
_aa20:                                                                  ;$AA20
        .byte   $00, $00, $00
_aa23:                                                                  ;$AA23
        .byte   $00, $00, $00
_aa26:                                                                  ;$AA26
        .byte   $00, $00, $00
_aa29:                                                                  ;$AA29
        .byte   $00, $00, $00
_aa2c:                                                                  ;$AA2C
        .byte   $00, $00, $00
_aa2f:                                                                  ;$AA2F
        .byte   $00, $07, $0e
_aa32:                                                                  ;$AA32
        .byte   $72, $70, $74, $77, $73, $68, $60, $f0
        .byte   $30, $fe, $72, $72, $92, $e1, $51, $02
_aa42:                                                                  ;$AA42
        .byte   $14, $0e, $0c, $50, $3f, $05, $18, $80
        .byte   $30, $ff, $10, $10, $70, $40, $0f, $0e
_aa52:                                                                  ;$AA52
        .byte   $45, $48, $d0, $51, $40, $f0, $40, $80
        .byte   $10, $50, $34, $33, $60, $55, $80, $40
_aa62:                                                                  ;$AA62
        .byte   $41, $11, $81, $81, $81, $11, $11, $41
        .byte   $21, $41, $21, $21, $11, $81, $11, $21
_aa72:                                                                  ;$AA72
        .byte   $01, $09, $20, $08, $0c, $00, $63, $18
        .byte   $44, $11, $00, $00, $44, $11, $18, $09
_aa82:                                                                  ;$AA82
        .byte   $d1, $f1, $e5, $fb, $dc, $f0, $f3, $d8
        .byte   $00, $e1, $e1, $f1, $f4, $e3, $b0, $a1
_aa92:                                                                  ;$AA92
        .byte   $fe, $fe, $f3, $ff, $00, $00, $00, $44
        .byte   $00, $55, $fe, $ff, $ef, $77, $7b, $fe
_aaa2:                                                                  ;$AAA2
        .byte   $03, $03, $03, $0f, $0f, $ff, $ff, $1f
        .byte   $ff, $ff, $03, $03, $0f, $ff, $ff, $03


; CALL FROM LOADER; this is the first thing called after initialisation

.export init_mem
.proc   init_mem                                                        ;$AAB2
        ;=======================================================================
        ; clear the main variable space
        ;
.import __VARS_MAIN_RUN__       ; runtime location
.import __VARS_MAIN_SIZE__      ; and length

        lda #> __VARS_MAIN_RUN__
        sta ZP_TEMP_ADDR1_HI

        ; number of whole pages to copy
        ldx #< .page_count( __VARS_MAIN_SIZE__ )

        lda #< __VARS_MAIN_RUN__
        sta ZP_TEMP_ADDR1_LO
        tay                     ; =0

:       sta [ZP_TEMP_ADDR1], y                                          ;$AABD
        iny
        bne :-

        inc ZP_TEMP_ADDR1_HI     ; move to the next page
        dex
        bne :-

        ;-----------------------------------------------------------------------
        ; set non-maskable interrupt location when the KERNAL is on.
        ; pressing the RESTORE key will fire this routine
        ;
        ; note that when the KERNAL is switched off, the RAM underneath will
        ; define the NMI interrupt address -- this gets rectified further down
        ;
        lda #< nmi_null
        sta KERNAL_VECTOR_NMI+0
        lda #> nmi_null
        sta KERNAL_VECTOR_NMI+1

        ; set new KERNAL_CHROUT (print character) routine
        ; -- re-route printing to the bitmap screen
        ;
        lda #< chrout
        sta KERNAL_VECTOR_CHROUT+0
        lda #> chrout
        sta KERNAL_VECTOR_CHROUT+1

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; change the C64's memory layout, turn off the BASIC & KERNAL ROMs
        ; leaving just the I/O registers ($D000...)
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the KERNAL is currently on, so stepping down
        ; once will switch from KERNAL+I/O to I/O only
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        sei                     ; disable interrupts

        ; configure interrupts (regular and non-interruptable)
        ; for system timers A & B -- do not use the TimeOfDay timer
        ;
        lda # CIA::TIMER_A | CIA::TIMER_B
        sta CIA1_INTERRUPT
        sta CIA2_INTERRUPT

        ; configure SID chip
        ;
        lda # 15                ; max volume, filters off
        sta SID_VOLUME_CTRL

        ; frame indicator?
        ldx # $00
        stx _a8d9

        ; set the flag for raster interrupts, but note that with CIA1 & 2
        ; interrupts currently enabled, the raster interrupt won't fire
        inx
        stx VIC_INTERRUPT_CONTROL

        ; the 9th bit (for scanlines 256-312) of the raster line register
        ; is held in the MSB of $D011. in Elite's case our raster-splits
        ; all occur before 256 so this bit just needs to be zero
        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1

        ; set the interrupt to occur at line 40.
        ; this is above the top screen border (~50)
        lda # 40
        sta VIC_RASTER

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; switch off the ROMs, leaving 64K of RAM
        lda CPU_CONTROL
        and # %11111000
        ora # C64_MEM::ALL
        sta CPU_CONTROL

        ; record this as the game's
        ; current memory-layout state
        lda # C64_MEM::ALL
        sta current_memory_layout

.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the I/O shield is currently on so stepping down
        ; once will turn I/O off leaving 64K of RAM
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set up the routines for the interrupts:
        ;
        ; NOTE: with the KERNAL ROM off, the hardware vectors at $FFFA...$FFFF
        ;       are now being defined by empty RAM -- we need to set something
        ;       there to prevent crashes when KERNAL ROM is off

        ; non-maskable interrupt:
        lda #< nmi_null
        sta HW_VECTOR_NMI+0
        lda #> nmi_null
        sta HW_VECTOR_NMI+1

        ; regular interrupt:
        lda #> interrupt
        sta HW_VECTOR_IRQ+1
        lda #< interrupt
        sta HW_VECTOR_IRQ+0

        cli                     ; enable interrupts
        rts
.endproc

.proc   nmi_null                                                        ;$AB27
        ;=======================================================================
        ; a Non-Maskable-Interrupt that does nothing; used to disable the
        ; RESTORE key and to prevent crashes when the KERNAL ROM is off
        ;
        cli                     ; re-enable interrupts
        rti                     ; "ReTurn from Interrupt"
.endproc

;===============================================================================

; unused / unreferenced?
; $ab29:
        lda # $ff
        sta ZP_32
        rts

;===============================================================================

; unused / unreferenced?
; $ab2e:
        sta ZP_32
        rts

;===============================================================================
; from "draw_lines.inc" insert the line-drawing code
;
.draw_lines                                                             ;$AB31

.ifdef  OPTION_DYME_FASTLINE
;///////////////////////////////////////////////////////////////////////////////
.hline_draw
.vline_draw
;///////////////////////////////////////////////////////////////////////////////
.endif


_b09d:                                                                  ;$B09DB
;===============================================================================
; plot a multi-color pixel
;
;       VAR_04EB        = Y position, in view-port pixels (0-255). adjusted
;                         automatically to nearest multi-color pixel (0-127)
;       VAR_04EA        = X position, in view-port pixels
;       _1d01           = colour-mask
;
        lda VAR_04EB
        sta ZP_VAR_Y

        lda VAR_04EA
        sta ZP_VAR_X

        lda _1d01
        sta ZP_32
        cmp # %10101010
        bne _b0b5

_b0b0:                                                                  ;$B0B0
        ;-----------------------------------------------------------------------
        ; draws two multi-color pixels, one atop the other
        ;
        jsr _b0b5                       ; draw first multi-color pixel
        dec ZP_VAR_Y                    ; move up one pixel and draw again

_b0b5:                                                                  ;$B0B5
        ;-----------------------------------------------------------------------
        ; get bitmap address from X & Y co-ords
        ;
        ldy ZP_VAR_Y
        lda ZP_VAR_X                    ; X-position, in pixels
        and # %11111000                 ; clip X to a char-cell
        clc
        adc row_to_bitmap_lo, y         ; add X to the bitmap address by row
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # $00
        sta ZP_TEMP_ADDR1_HI

        ; let Y be the row within the char-cell (0-7)
        tya
        and # %00000111
        tay

        ; let X be the column within the char-cell (0-7)
        lda ZP_VAR_X
        and # %00000111
        tax

        ; multi-colour pixels are made from pairs of pixels. this lookup
        ; translates a pixel from 0-7 to the nearest multi-colour pixel
        ; e.g.
        ;
        ;       %10------ & %01------ = %11000000
        ;       %--10---- & %--01---- = %00110000
        ;       %----10-- & %----01-- = %00001100
        ;       %------10 & %------01 = %00000011
        ;
        lda _ab47, x
        ;
        ; this only gives us the pixel mask, the actual colour to be drawn
        ; depends upon the two bits of the multi-colour pixel:
        ;
        ;       %00     = background color, i.e. $D021
        ;       %01     = for screen RAM upper-nybble
        ;       %10     = for screen RAM lower-nybble
        ;       %11     = for colour RAM ($D800+)
        ;
        ; a 'colour mask' is used to convert the multi-colour pixel
        ; (regardless of position) into the desired pair. e.g.
        ;
        ;       pixel:     colour-mask:   result:
        ;
        ;       %11000000 AND %00000000 = %00------ (background)
        ;       %00110000 AND %01010101 = %--01---- (screen RAM upper-nybble)
        ;       %00001100 AND %10101010 = %----10-- (screen RAM lower-nybble)
        ;       %00000011 AND %11111111 = %------11 (colour RAM)
        ;
        and ZP_32                       ; set colour, i.e. %11, %10, %01, %00
        eor [ZP_TEMP_ADDR1], y          ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y          ; update the screen

        lda _ab49, x                    ; look ahead to the next pixel
        bpl @_b0ed

        lda ZP_TEMP_ADDR1_LO
        clc
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcc :+
        inc ZP_TEMP_ADDR1_HI
:       lda _ab49, x                                                    ;$B0EA

@_b0ed:                                                                 ;$B0ED
        and ZP_32                       ; apply the colour-mask to the pixel
        eor [ZP_TEMP_ADDR1], y          ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y          ; update the screen
        rts

;===============================================================================

_b0f4:                                                                  ;$B0F4
        lda # $20
        sta ZP_67
        ldy # $09
        jsr _a858
_b0fd:                                                                  ;$B0FD
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3

        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB

        rts

;===============================================================================

_b10e:                                                                  ;$B10E
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4

        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC

        rts

;===============================================================================
; "draw missile block"
;
_b11f:                                                                  ;$B11F

        dex
        txa
        inx
        eor # %00000011
        sty ZP_TEMP_ADDR1_LO
        tay
        lda ZP_TEMP_ADDR1_LO
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 6 ), y    ;=$67C6
        ldy # $00

        rts

;===============================================================================

; unused / unreferenced?
;$b12f:
        ; probably data rather than code?
        jsr $ffff               ;irq
        cmp # $80
        bcc _b13a

_b136:                                                                  ;$B136
        lda # $07
        clc
        rts

        ;-----------------------------------------------------------------------

_b13a:                                                                  ;$B13A
        cmp # $20
        bcs _b146
        cmp # $0d
        beq _b146
        cmp # $15
        bne _b136
_b146:                                                                  ;$B146
        clc
        rts

wait_for_frame:                                                         ;$B148
        ;=======================================================================
        ; I think this function waits for a frame to complete
        ;
        pha                     ; preserve A

        ; wait for non-zero in the frame status?
:       lda _a8d9                                                       ;$B149
        beq :-
        ; and then wait for it to return to zero?
:       lda _a8d9                                                       ;$B14E
        bne :-

        pla                     ; restore A
        rts


;===============================================================================
; print a charcter to the bitmap screen
;
; replaces the KERNAL's `CHROUT` routine for printing text to screen
; (since Elite uses only the bitmap screen)
;
; IMPORTANT NOTE: Elite stores its text in ASCII, not PETSCII!
; this is due to the data being copied over as-is from the BBC
;
;       A = ASCII code of character to print
;
chrout:                                                                 ;$B155

        cmp # $7b               ; is code greater than or equal to $7B?
        bcs :+                  ; if yes, skip it
        cmp # $0d               ; is code less than $0D? (RETURN)
        bcc :+                  ; if yes, skip it
        bne paint_char          ; if it's not RETURN, process it

        ; handle the RETURN code
        lda # TXT_NEWLINE
        jsr paint_char

        lda # $0d
:       clc                     ; clear carry flag before returning     ;$B166
        rts

;define the use of some zero-page variables for this routine
ZP_CHROUT_CHARADDR      := $2f  ; $2F/$30
ZP_CHROUT_DRAWADDR      := $07  ; $07/$08
ZP_CHROUT_DRAWADDR_LO   := $07
ZP_CHROUT_DRAWADDR_HI   := $08

_b168:                                                                  ;$B168
        jsr _a80f               ; BEEP?
        jmp _b210               ; restore state and exit

        ;-----------------------------------------------------------------------

_b16e:                                                                  ;$B16E
        jsr _b384
        lda ZP_POLYOBJ01_XPOS_pt1
        jmp _b189

        ;-----------------------------------------------------------------------

        ; this is a trampoline to account for a branch range limitation below
        ; TODO: this could be combined with the one at `_b168` to save 3 bytes
        ;
_b176:  jmp _b210                                                       ;B176

paint_newline:                                                          ;$B179
        ;-----------------------------------------------------------------------
        ; NOTE: called only ever by `_2c7d`!
        ;
        lda # TXT_NEWLINE

paint_char:                                                             ;$B17B
;===============================================================================
; draws a character on the bitmap screen as if it were the text screen
; (automatically advances the cursor)
;
        ; store current registers
        ; (compatibility with KERNAL_CHROUT?)
        sta ZP_POLYOBJ01_XPOS_pt1
        sty VAR_0490
        stx VAR_048F

        ; cancel if text reaches a certain point?
        ; prevent off-screen writing?
        ldy ZP_34
        cpy # $ff
        beq _b176
_b189:                                                                  ;$B189
        cmp # $07               ; code $07? (unspecified in PETSCII)
        beq _b168
        cmp # $20               ; is it SPC or above? (i.e. printable)
        bcs _b1a1
        cmp # $0a               ; is it $0A? (unspecified in PETSCII)
        beq _b199
_b195:                                                                  ;$B195
        ; start at column 2, i.e. leave a one-char padding from the viewport
        ldx # 1
        stx ZP_CURSOR_COL
_b199:                                                                  ;$B199
        cmp # $0d               ; is it RETURN? although note that `chrout`
                                ; replaces $0D codes with $0C
        beq _b176

        inc ZP_CURSOR_ROW
        bne _b176

_b1a1:                                                                  ;$B1A1
        ;-----------------------------------------------------------------------
        ; convert the PETSCII code to an address in the char gfx (font):
        ; note that the font is ASCII so a few characters appear different
        ; and font graphics are only provided for 96 characters, from space
        ; (32 / $20) onwards
        ;
        tay                     ; put aside the ASCII code

        ; at 8 bytes per character, each page (256 bytes) occupies 32 chars,
        ; so the initial part of this routine is concerned with finding what
        ; the high-address of the character will be
        ;
        ; Elite's font defines 96 characters (3 usable pages),
        ; consisting (roughly) of:
        ;
        ; page 0 = codes 0-31   : invalid, no font gfx here
        ; page 1 = codes 32-63  : most punctuation and numbers
        ; page 2 = codes 64-95  : "@", "A" to "Z", "[", "\", "]", "^", "_"
        ; page 3 = codes 96-127 : "£", "a" to "z", "{", "|", "}", "~"
        ;
        ; default to 0th page since character codes begin from 0,
        ; but in practice we'll only see codes 32-128
        ;
        ldx # (>ELITE_FONT_ADDR) - 1

        ; if you shift any number twice to the left
        ; then numbers 64 or above will carry (> 255)
        asl
        asl
        bcc :+                  ; no carry (char code was < 64),
                                ; char is in the 0th (unlikely) or 1st page

        ; -- char is in the 2rd or 3rd page
        ldx # (>ELITE_FONT_ADDR) + 1

        ; shift left again -- codes 32 or over will carry,
        ; so we can determine which of the two possible pages it's in
:       asl                                                             ;$B1AA
        bcc :+                  ; < 32, lower-page
        inx                     ; >= 32, upper-page

        ; note that shifting left 3 times has multiplied our character code
        ; by 8 -- producing an offset appropriate for the font gfx

:       sta ZP_CHROUT_CHARADDR+0                                        ;$B1AE
        stx ZP_CHROUT_CHARADDR+1

        ;-----------------------------------------------------------------------

        ; line-wrap?
        ; SPEED: this causes the character address to
        ;        have to be recalculated again!
        lda ZP_CURSOR_COL
        cmp # 31                ; max width of line? (32 chars = 256 px)
        bcs _b195               ; reach the end of the line, carriage-return!

        lda # $80
        sta ZP_CHROUT_DRAWADDR_LO

        lda ZP_CURSOR_ROW
        cmp # 24
        bcc :+

        ; SPEED: just copy that code here, or change the branch above to go
        ;        to `_b16e` and favour falling through for the majority case
        jmp _b16e

        ;-----------------------------------------------------------------------

        ; calculate the size of the offset needed for bitmap rows
        ; (320 bytes each). note that A is the current `chrout` row

        ; SPEED: this whole thing could seriously do with a lookup table

        ; divide into 64?
:       lsr                                                             ;$B1C5
        ror ZP_CHROUT_DRAWADDR_LO
        lsr
        ror ZP_CHROUT_DRAWADDR_LO

        ; taking a number and making it the high-byte of a word is just
        ; multiplying it by 256, i.e. shifting left 8 bits

        adc ZP_CURSOR_ROW
        ; re-base to the start of the bitmap screen
        adc #> ELITE_BITMAP_ADDR
        sta ZP_CHROUT_DRAWADDR_HI

        ; calculte the offset of the column
        ; (each character is 8-bytes in the bitmap screen)
        lda ZP_CURSOR_COL
        asl                     ; x2
        asl                     ; x4
        asl                     ; x8
        adc ZP_CHROUT_DRAWADDR_LO
        sta ZP_CHROUT_DRAWADDR_LO
        bcc :+
        inc ZP_CHROUT_DRAWADDR_HI

        ; is this the character code for the solid-block character?
        ; TODO: generate this index in "gfx/font.asm"?
:       cpy # $7f                                                       ;$B1DE
        bne :+

        ; backspace?
        dec ZP_CURSOR_COL
        ; go back 256 pixels??
        dec ZP_CHROUT_DRAWADDR_HI

        ldy # $f8
        jsr erase_page_to_end
        beq _b210

:       inc ZP_CURSOR_COL                                               ;$B1ED
        ; this is `sta ZP_TEMP_ADDR1_HI` if you jump in after the `bit`
        ; instruction, but it doesn't look like this actually occurs
       .bit
        sta ZP_TEMP_ADDR1_HI

        ; paint the character (8-bytes) to the screen
        ; SPEED: this could be unrolled

        ldy # 7
:       lda [ZP_CHROUT_CHARADDR], y                                     ;$B1F4
        eor [ZP_CHROUT_DRAWADDR], y
        sta [ZP_CHROUT_DRAWADDR], y
        dey
        bpl :-

        ; lookup the character colour cell from the row/col index:
        ; -- note that Elite has a 256-px (32-char) centred screen,
        ;    so this table returns column 4 ($03) as the 'first' column
        ldy ZP_CURSOR_ROW
        lda menuscr_lo, y
        sta ZP_CHROUT_DRAWADDR_LO
        lda menuscr_hi, y
        sta ZP_CHROUT_DRAWADDR_HI

        ldy ZP_CURSOR_COL
        lda VAR_050C            ; colour?
        sta [ZP_CHROUT_DRAWADDR], y

        ; exit and clean-up:
        ;-----------------------------------------------------------------------
_b210:  ; restore registers before returning                            ;$B210
        ; (compatibility with KERNAL_CHROUT?)
        ;
        ldy VAR_0490
        ldx VAR_048F
        lda ZP_POLYOBJ01_XPOS_pt1

        clc
        rts

;===============================================================================
; routine(s) for clearing the screen, i.e. when changing screen pages between
; flight screen and menu screens. clears or redraws the HUD accordingly
;
.include        "gfx/clear_screen.asm"                                  ;$B21A

txt_docked_token15:                                                     ;$B3D4
;===============================================================================
.export txt_docked_token15

        lda # $00
        sta VAR_048B
        sta VAR_048C

        lda # %11111111
        sta txt_lcase_flag

        lda # %10000000
        sta ZP_34

        lda # 21
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL

        txt_bmp_addr = ELITE_BITMAP_ADDR + .bmppos( 21, 4 )

        lda #> txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_HI
        lda #< txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_LO
        ldx # $03

@_b3f7:                                                                 ;$B3F7
        lda # $00
        tay

:       sta [ZP_TEMP_ADDR1], y                                          ;$B3FA
        dey
        bne :-
        clc
        lda ZP_TEMP_ADDR1_LO
        adc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
        dex
        bne @_b3f7
_b40f:                                                                  ;$B40F
        rts

;===============================================================================

_b410:                                                                  ;$B410
        lda ZP_SCREEN
        bne _b40f

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::scanner
        beq _b40f

        ldx ZP_A5
        bmi _b40f
        lda _267e, x
        sta ZP_32

        lda ZP_POLYOBJ_XPOS_MI
        ora ZP_POLYOBJ_YPOS_MI
        ora ZP_POLYOBJ_ZPOS_MI
        and # %11000000
        bne _b40f

        lda ZP_POLYOBJ_XPOS_MI
        clc

        ldx ZP_POLYOBJ_XPOS_HI
        bpl :+
        eor # %11111111
        adc # $01
:       adc # $7b                                                       ;$B438
        sta ZP_VAR_X

        lda ZP_POLYOBJ_ZPOS_MI
        lsr
        lsr
        clc
        ldx ZP_POLYOBJ_ZPOS_HI
        bpl :+
        eor # %11111111
        sec
:       adc # $53                                                       ;$B448
        eor # %11111111
        sta ZP_TEMP_ADDR1_LO

        lda ZP_POLYOBJ_YPOS_MI
        lsr
        clc
        ldx ZP_POLYOBJ_YPOS_HI
        bmi :+
        eor # %11111111
        sec
:       adc ZP_TEMP_ADDR1_LO                                            ;$B459
        cmp # $92
        bcs :+
        lda # $92
:       cmp # $c7                                                       ;$B461
        bcc :+
        lda # $c6
:       sta ZP_VAR_Y                                                    ;$B467

        sec
        sbc ZP_TEMP_ADDR1_LO
        php
        pha
        jsr _b0b0                       ; draw two multi-color pixels?
        lda _ab49, x
        and ZP_32
        sta ZP_VAR_X
        pla
        plp
        tax
        beq _b49a
        bcc _b49b
_b47f:                                                                  ;$B47F
        dey
        bpl _b491
        ldy # $07
        lda ZP_TEMP_ADDR1_LO
        sec
        sbc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # $01
        sta ZP_TEMP_ADDR1_HI
_b491:                                                                  ;$B491
        lda ZP_VAR_X
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        dex
        bne _b47f
_b49a:                                                                  ;$B49A
        rts

        ;-----------------------------------------------------------------------

_b49b:                                                                  ;$B49B
        iny
        cpy # $08
        bne _b4ae
        ldy # $00
        lda ZP_TEMP_ADDR1_LO
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
_b4ae:                                                                  ;$B4AE
        iny
        cpy # $08
        bne _b4c1
        ldy # $00
        lda ZP_TEMP_ADDR1_LO
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
_b4c1:                                                                  ;$B4C1
        lda ZP_VAR_X
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        inx
        bne _b4ae

        rts                                                             ;$B4CA
