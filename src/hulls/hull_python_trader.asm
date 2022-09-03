; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; python (trader)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_PYTHON_TRADER      = hull_index                                    ;=$0C

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_PYTHON_TRADER_KILL = 170   ;= 0.66

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_python_trader                                      ;$D016/7

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a0                                                     ;$D04D

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_PYTHON_TRADER_KILL                               ;$D06E

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_PYTHON_TRADER_KILL                               ;$D08F

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_python_trader                                              ;$DA4B
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 5 debris!
        .scoop_debris   0, 5                                            ;$DA4B
        
        .byte                       $00, $19, $56, $be                  ;$DA4C
        .byte   $59, $00, $2a, $42, $1a, $00, $00, $34                  ;$DA50
        .byte   $28, $fa, $14, $00, $00, $00, $1b, $00
        .byte   $00, $e0, $1f, $10, $32, $00, $30, $30                  ;$DA60
        .byte   $1f, $10, $54, $60, $00, $10, $3f, $ff
        .byte   $ff, $60, $00, $10, $bf, $ff, $ff, $00                  ;$DA70
        .byte   $30, $20, $3f, $54, $98, $00, $18, $70
        .byte   $3f, $89, $cc, $30, $00, $70, $bf, $b8                  ;$DA80
        .byte   $cc, $30, $00, $70, $3f, $a9, $cc, $00
        .byte   $30, $30, $5f, $32, $76, $00, $30, $20                  ;$DA90
        .byte   $7f, $76, $ba, $00, $18, $70, $7f, $ba
        .byte   $cc, $1f, $32, $00, $20, $1f, $20, $00                  ;$DAA0
        .byte   $0c, $1f, $31, $00, $08, $1f, $10, $00
        .byte   $04, $1f, $59, $08, $10, $1f, $51, $04                  ;$DAB0
        .byte   $08, $1f, $37, $08, $20, $1f, $40, $04
        .byte   $0c, $1f, $62, $0c, $20, $1f, $a7, $08                  ;$DAC0
        .byte   $24, $1f, $84, $0c, $10, $1f, $b6, $0c
        .byte   $24, $07, $88, $0c, $14, $07, $bb, $0c                  ;$DAD0
        .byte   $28, $07, $99, $08, $14, $07, $aa, $08
        .byte   $28, $1f, $a9, $08, $1c, $1f, $b8, $0c                  ;$DAE0
        .byte   $18, $1f, $c8, $14, $18, $1f, $c9, $14
        .byte   $1c, $1f, $ac, $1c, $28, $1f, $cb, $18                  ;$DAF0
        .byte   $28, $1f, $98, $10, $14, $1f, $ba, $24
        .byte   $28, $1f, $54, $04, $10, $1f, $76, $20                  ;$DB00
        .byte   $24, $9f, $1b, $28, $0b, $1f, $1b, $28
        .byte   $0b, $df, $1b, $28, $0b, $5f, $1b, $28                  ;$DB10
        .byte   $0b, $9f, $13, $26, $00, $1f, $13, $26
        .byte   $00, $df, $13, $26, $00, $5f, $13, $26                  ;$DB20
        .byte   $00, $bf, $19, $25, $0b, $3f, $19, $25
        .byte   $0b, $7f, $19, $25, $0b, $ff, $19, $25                  ;$DB30
        .byte   $0b, $3f, $00, $00, $70                                 ;$DB38

.endproc