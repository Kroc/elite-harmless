; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; gecko
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_GECKO              = hull_index                                    ;=$15

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_GECKO_KILL         = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_gecko                                              ;$D028/9

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D056

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_GECKO_KILL                                       ;$D077

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_GECKO_KILL                                       ;$D098

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_gecko                                                      ;$E2D1
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$E2D1
        
        .byte             $49, $26, $5c, $a0, $45, $00                  ;$E2D2
        .byte   $1a, $48, $11, $37, $00, $24, $12, $46
        .byte   $1e, $00, $00, $03, $10, $0a, $04, $2f                  ;$E2E0
        .byte   $df, $03, $45, $0a, $04, $2f, $5f, $01
        .byte   $23, $10, $08, $17, $bf, $05, $67, $10                  ;$E2F0
        .byte   $08, $17, $3f, $01, $78, $42, $00, $03
        .byte   $bf, $45, $66, $42, $00, $03, $3f, $12                  ;$E300
        .byte   $88, $14, $0e, $17, $ff, $34, $67, $14
        .byte   $0e, $17, $7f, $23, $78, $08, $06, $21                  ;$E310
        .byte   $d0, $33, $33, $08, $06, $21, $51, $33
        .byte   $33, $08, $0d, $10, $f0, $33, $33, $08                  ;$E320
        .byte   $0d, $10, $71, $33, $33, $1f, $03, $00
        .byte   $04, $1f, $12, $04, $14, $1f, $18, $14                  ;$E330
        .byte   $0c, $1f, $07, $0c, $08, $1f, $56, $08
        .byte   $10, $1f, $45, $10, $00, $1f, $28, $14                  ;$E340
        .byte   $1c, $1f, $37, $1c, $18, $1f, $46, $18
        .byte   $10, $1d, $05, $00, $08, $1e, $01, $04                  ;$E350
        .byte   $0c, $1d, $34, $00, $18, $1e, $23, $04
        .byte   $1c, $14, $67, $08, $18, $14, $78, $0c                  ;$E360
        .byte   $1c, $10, $33, $20, $28, $11, $33, $24
        .byte   $2c, $1f, $00, $1f, $05, $1f, $04, $2d                  ;$E370
        .byte   $08, $5f, $19, $6c, $13, $5f, $00, $54
        .byte   $0c, $df, $19, $6c, $13, $9f, $04, $2d                  ;$E380
        .byte   $08, $bf, $58, $10, $d6, $3f, $00, $00
        .byte   $bb, $3f, $58, $10, $d6                                 ;$E390

.endproc