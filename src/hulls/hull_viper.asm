; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; viper
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_VIPER              = hull_index                                    ;=$10

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_VIPER_KILL         = 26    ;= 0.10

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_viper                                              ;$D01E/F

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $c2                                                     ;$D051

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_VIPER_KILL                                       ;$D072

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_VIPER_KILL                                       ;$D093

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_viper                                                      ;$DE0B
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$DE0B
        
        .byte                       $f9, $15, $6e, $be                  ;$DE0C
        .byte   $51, $00, $2a, $5a, $14, $00, $00, $1c                  ;$DE10
        .byte   $17, $8c, $20, $00, $00, $01, $11, $00
        .byte   $00, $48, $1f, $21, $43, $00, $10, $18                  ;$DE20
        .byte   $1e, $10, $22, $00, $10, $18, $5e, $43
        .byte   $55, $30, $00, $18, $3f, $42, $66, $30                  ;$DE30
        .byte   $00, $18, $bf, $31, $66, $18, $10, $18
        .byte   $7e, $54, $66, $18, $10, $18, $fe, $35                  ;$DE40
        .byte   $66, $18, $10, $18, $3f, $20, $66, $18
        .byte   $10, $18, $bf, $10, $66, $20, $00, $18                  ;$DE50
        .byte   $b3, $66, $66, $20, $00, $18, $33, $66
        .byte   $66, $08, $08, $18, $33, $66, $66, $08                  ;$DE60
        .byte   $08, $18, $b3, $66, $66, $08, $08, $18
        .byte   $f2, $66, $66, $08, $08, $18, $72, $66                  ;$DE70
        .byte   $66, $1f, $42, $00, $0c, $1e, $21, $00
        .byte   $04, $1e, $43, $00, $08, $1f, $31, $00                  ;$DE80
        .byte   $10, $1e, $20, $04, $1c, $1e, $10, $04
        .byte   $20, $1e, $54, $08, $14, $1e, $53, $08                  ;$DE90
        .byte   $18, $1f, $60, $1c, $20, $1e, $65, $14
        .byte   $18, $1f, $61, $10, $20, $1e, $63, $10                  ;$DEA0
        .byte   $18, $1f, $62, $0c, $1c, $1e, $46, $0c
        .byte   $14, $13, $66, $24, $30, $12, $66, $24                  ;$DEB0
        .byte   $34, $13, $66, $28, $2c, $12, $66, $28
        .byte   $38, $10, $66, $2c, $38, $10, $66, $30                  ;$DEC0
        .byte   $34, $1f, $00, $20, $00, $9f, $16, $21
        .byte   $0b, $1f, $16, $21, $0b, $df, $16, $21                  ;$DED0
        .byte   $0b, $5f, $16, $21, $0b, $5f, $00, $20
        .byte   $00, $3f, $00, $00, $30                                 ;$DEE0

.endproc