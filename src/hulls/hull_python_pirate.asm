; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; python (pirate)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_PYTHON_PIRATE      = hull_index                                    ;=$1A

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_PYTHON_PIRATE_KILL = 298   ;= 1.16

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_py_pirate                                          ;$D032/3

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D05B

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_PYTHON_PIRATE_KILL                               ;$D07C

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_PYTHON_PIRATE_KILL                               ;$D09D

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_py_pirate                                                  ;$E7BD
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 2 debris:
        .scoop_debris   0, 2                                            ;$E7BD
        
        .byte                                 $00, $19                  ;$E7BE
        .byte   $56, $be, $59, $00, $2a, $42, $1a, $c8                  ;$E7C0
        .byte   $00, $34, $28, $fa, $14, $00, $00, $00
        .byte   $1b, $00, $00, $e0, $1f, $10, $32, $00                  ;$E7D0
        .byte   $30, $30, $1f, $10, $54, $60, $00, $10
        .byte   $3f, $ff, $ff, $60, $00, $10, $bf, $ff                  ;$E7E0
        .byte   $ff, $00, $30, $20, $3f, $54, $98, $00
        .byte   $18, $70, $3f, $89, $cc, $30, $00, $70                  ;$E7F0
        .byte   $bf, $b8, $cc, $30, $00, $70, $3f, $a9
        .byte   $cc, $00, $30, $30, $5f, $32, $76, $00                  ;$E800
        .byte   $30, $20, $7f, $76, $ba, $00, $18, $70
        .byte   $7f, $ba, $cc, $1f, $32, $00, $20, $1f                  ;$E810
        .byte   $20, $00, $0c, $1f, $31, $00, $08, $1f
        .byte   $10, $00, $04, $1f, $59, $08, $10, $1f                  ;$E820
        .byte   $51, $04, $08, $1f, $37, $08, $20, $1f
        .byte   $40, $04, $0c, $1f, $62, $0c, $20, $1f                  ;$E830
        .byte   $a7, $08, $24, $1f, $84, $0c, $10, $1f
        .byte   $b6, $0c, $24, $07, $88, $0c, $14, $07                  ;$E840
        .byte   $bb, $0c, $28, $07, $99, $08, $14, $07
        .byte   $aa, $08, $28, $1f, $a9, $08, $1c, $1f                  ;$E850
        .byte   $b8, $0c, $18, $1f, $c8, $14, $18, $1f
        .byte   $c9, $14, $1c, $1f, $ac, $1c, $28, $1f                  ;$E860
        .byte   $cb, $18, $28, $1f, $98, $10, $14, $1f
        .byte   $ba, $24, $28, $1f, $54, $04, $10, $1f                  ;$E870
        .byte   $76, $20, $24, $9f, $1b, $28, $0b, $1f
        .byte   $1b, $28, $0b, $df, $1b, $28, $0b, $5f                  ;$E880
        .byte   $1b, $28, $0b, $9f, $13, $26, $00, $1f
        .byte   $13, $26, $00, $df, $13, $26, $00, $5f                  ;$E890
        .byte   $13, $26, $00, $bf, $19, $25, $0b, $3f
        .byte   $19, $25, $0b, $7f, $19, $25, $0b, $ff                  ;$E8A0
        .byte   $19, $25, $0b, $3f, $00, $00, $70

.endproc