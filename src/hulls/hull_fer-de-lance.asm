; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; fer-de-lance
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_FERDELANCE         = hull_index                                    ;=$1B

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_FERDELANCE_KILL    = 320   ;= 1.25

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_ferdelance                                         ;$D034/5

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $82                                                     ;$D05C

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_FERDELANCE_KILL                                  ;$D07D

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_FERDELANCE_KILL                                  ;$D09E

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_ferdelance                                                 ;$E8AF
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$E8AF
        
        .byte   $40, $06, $86, $f2, $6d, $00, $1a, $72                  ;$E8B0
        .byte   $1b, $00, $00, $28, $28, $a0, $1e, $00
        .byte   $00, $01, $12, $00, $0e, $6c, $5f, $01                  ;$E8C0
        .byte   $59, $28, $0e, $04, $ff, $12, $99, $0c
        .byte   $0e, $34, $ff, $23, $99, $0c, $0e, $34                  ;$E8D0
        .byte   $7f, $34, $99, $28, $0e, $04, $7f, $45
        .byte   $99, $28, $0e, $04, $bc, $01, $26, $0c                  ;$E8E0
        .byte   $02, $34, $bc, $23, $67, $0c, $02, $34
        .byte   $3c, $34, $78, $28, $0e, $04, $3c, $04                  ;$E8F0
        .byte   $58, $00, $12, $14, $2f, $06, $78, $03
        .byte   $0b, $61, $cb, $00, $00, $1a, $08, $12                  ;$E900
        .byte   $89, $00, $00, $10, $0e, $04, $ab, $00
        .byte   $00, $03, $0b, $61, $4b, $00, $00, $1a                  ;$E910
        .byte   $08, $12, $09, $00, $00, $10, $0e, $04
        .byte   $2b, $00, $00, $00, $0e, $14, $6c, $99                  ;$E920
        .byte   $99, $0e, $0e, $2c, $cc, $99, $99, $0e
        .byte   $0e, $2c, $4c, $99, $99, $1f, $19, $00                  ;$E930
        .byte   $04, $1f, $29, $04, $08, $1f, $39, $08
        .byte   $0c, $1f, $49, $0c, $10, $1f, $59, $00                  ;$E940
        .byte   $10, $1c, $01, $00, $14, $1c, $26, $14
        .byte   $18, $1c, $37, $18, $1c, $1c, $48, $1c                  ;$E950
        .byte   $20, $1c, $05, $00, $20, $0f, $06, $14
        .byte   $24, $0b, $67, $18, $24, $0b, $78, $1c                  ;$E960
        .byte   $24, $0f, $08, $20, $24, $0e, $12, $04
        .byte   $14, $0e, $23, $08, $18, $0e, $34, $0c                  ;$E970
        .byte   $1c, $0e, $45, $10, $20, $08, $00, $28
        .byte   $2c, $09, $00, $2c, $30, $0b, $00, $28                  ;$E980
        .byte   $30, $08, $00, $34, $38, $09, $00, $38
        .byte   $3c, $0b, $00, $34, $3c, $0c, $99, $40                  ;$E990
        .byte   $44, $0c, $99, $40, $48, $08, $99, $44
        .byte   $48, $1c, $00, $18, $06, $9f, $44, $00                  ;$E9A0
        .byte   $18, $bf, $3f, $00, $25, $3f, $00, $00
        .byte   $68, $3f, $3f, $00, $25, $1f, $44, $00                  ;$E9B0
        .byte   $18, $bc, $0c, $2e, $13, $3c, $00, $2d
        .byte   $16, $3c, $0c, $2e, $13, $5f, $00, $1c                  ;$E9C0
        .byte   $00

.endproc