; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; thargoid
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_THARGOID           = hull_index                                    ;=$1D

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_THARGOID_KILL      = 682   ;= 2.66

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_thargoid                                           ;$D038/9

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D05E

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_THARGOID_KILL                                    ;$D07F

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_THARGOID_KILL                                    ;$D0A0

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_thargoid                                                   ;$EAA1
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$EAA1
        
        .byte             $49, $26, $8c, $f4, $69, $3c                  ;$EAA2
        .byte   $26, $78, $1a, $f4, $01, $28, $37, $f0
        .byte   $27, $00, $00, $02, $16, $20, $30, $30                  ;$EAB0
        .byte   $5f, $40, $88, $20, $44, $00, $5f, $10
        .byte   $44, $20, $30, $30, $7f, $21, $44, $20                  ;$EAC0
        .byte   $00, $44, $3f, $32, $44, $20, $30, $30
        .byte   $3f, $43, $55, $20, $44, $00, $1f, $54                  ;$EAD0
        .byte   $66, $20, $30, $30, $1f, $64, $77, $20
        .byte   $00, $44, $1f, $74, $88, $18, $74, $74                  ;$EAE0
        .byte   $df, $80, $99, $18, $a4, $00, $df, $10
        .byte   $99, $18, $74, $74, $ff, $21, $99, $18                  ;$EAF0
        .byte   $00, $a4, $bf, $32, $99, $18, $74, $74
        .byte   $bf, $53, $99, $18, $a4, $00, $9f, $65                  ;$EB00
        .byte   $99, $18, $74, $74, $9f, $76, $99, $18
        .byte   $00, $a4, $9f, $87, $99, $18, $40, $50                  ;$EB10
        .byte   $9e, $99, $99, $18, $40, $50, $be, $99
        .byte   $99, $18, $40, $50, $fe, $99, $99, $18                  ;$EB20
        .byte   $40, $50, $de, $99, $99, $1f, $84, $00
        .byte   $1c, $1f, $40, $00, $04, $1f, $41, $04                  ;$EB30
        .byte   $08, $1f, $42, $08, $0c, $1f, $43, $0c
        .byte   $10, $1f, $54, $10, $14, $1f, $64, $14                  ;$EB40
        .byte   $18, $1f, $74, $18, $1c, $1f, $80, $00
        .byte   $20, $1f, $10, $04, $24, $1f, $21, $08                  ;$EB50
        .byte   $28, $1f, $32, $0c, $2c, $1f, $53, $10
        .byte   $30, $1f, $65, $14, $34, $1f, $76, $18                  ;$EB60
        .byte   $38, $1f, $87, $1c, $3c, $1f, $98, $20
        .byte   $3c, $1f, $90, $20, $24, $1f, $91, $24                  ;$EB70
        .byte   $28, $1f, $92, $28, $2c, $1f, $93, $2c
        .byte   $30, $1f, $95, $30, $34, $1f, $96, $34                  ;$EB80
        .byte   $38, $1f, $97, $38, $3c, $1e, $99, $40
        .byte   $44, $1e, $99, $48, $4c, $5f, $67, $3c                  ;$EB90
        .byte   $19, $7f, $67, $3c, $19, $7f, $67, $19
        .byte   $3c, $3f, $67, $19, $3c, $1f, $40, $00                  ;$EBA0
        .byte   $00, $3f, $67, $3c, $19, $1f, $67, $3c
        .byte   $19, $1f, $67, $19, $3c, $5f, $67, $19                  ;$EBB0
        .byte   $3c, $9f, $30, $00, $00

.endproc