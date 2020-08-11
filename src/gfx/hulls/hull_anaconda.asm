; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; $0E: anaconda
;-------------------------------------------------------------------------------
hull_index           .set hull_index + 1
hull_anaconda_index    := hull_index                                    ;=$0E

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
hull_anaconda_kill      = 256   ;= 1.00

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_anaconda                                           ;$D01A/B

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $a1                                                     ;$D04F

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < hull_anaconda_kill                                    ;$D070

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > hull_anaconda_kill                                    ;$D091

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_anaconda                                                   ;$DC33
        ;-----------------------------------------------------------------------
        .byte                  $07, $10, $27, $6e, $d2                  ;$DC33
        .byte   $5d, $30, $2e, $5a, $19, $00, $00, $30
        .byte   $24, $fc, $0e, $00, $00, $01, $3f, $00                  ;$DC40
        .byte   $07, $3a, $3e, $01, $55, $2b, $0d, $25
        .byte   $fe, $01, $22, $1a, $2f, $03, $fe, $02                  ;$DC50
        .byte   $33, $1a, $2f, $03, $7e, $03, $44, $2b
        .byte   $0d, $25, $7e, $04, $55, $00, $30, $31                  ;$DC60
        .byte   $3e, $15, $66, $45, $0f, $0f, $be, $12
        .byte   $77, $2b, $27, $28, $df, $23, $88, $2b                  ;$DC70
        .byte   $27, $28, $5f, $34, $99, $45, $0f, $0f
        .byte   $3e, $45, $aa, $2b, $35, $17, $bf, $ff                  ;$DC80
        .byte   $ff, $45, $01, $20, $df, $27, $88, $00
        .byte   $00, $fe, $1f, $ff, $ff, $45, $01, $20                  ;$DC90
        .byte   $5f, $49, $aa, $2b, $35, $17, $3f, $ff
        .byte   $ff, $1e, $01, $00, $04, $1e, $02, $04                  ;$DCA0
        .byte   $08, $1e, $03, $08, $0c, $1e, $04, $0c
        .byte   $10, $1e, $05, $00, $10, $1d, $15, $00                  ;$DCB0
        .byte   $14, $1d, $12, $04, $18, $1d, $23, $08
        .byte   $1c, $1d, $34, $0c, $20, $1d, $45, $10                  ;$DCC0
        .byte   $24, $1e, $16, $14, $28, $1e, $17, $18
        .byte   $28, $1e, $27, $18, $2c, $1e, $28, $1c                  ;$DCD0
        .byte   $2c, $1f, $38, $1c, $30, $1f, $39, $20
        .byte   $30, $1e, $49, $20, $34, $1e, $4a, $24                  ;$DCE0
        .byte   $34, $1e, $5a, $24, $38, $1e, $56, $14
        .byte   $38, $1e, $6b, $28, $38, $1f, $7b, $28                  ;$DCF0
        .byte   $30, $1f, $78, $2c, $30, $1f, $9a, $30
        .byte   $34, $1f, $ab, $30, $38, $7e, $00, $33                  ;$DD00
        .byte   $31, $be, $33, $12, $57, $fe, $4d, $39
        .byte   $13, $5f, $00, $5a, $10, $7e, $4d, $39                  ;$DD10
        .byte   $13, $3e, $33, $12, $57, $3e, $00, $6f
        .byte   $14, $9f, $61, $48, $18, $df, $6c, $44                  ;$DD20
        .byte   $22, $5f, $6c, $44, $22, $1f, $61, $48
        .byte   $18, $1f, $00, $5e, $12                                 ;$DD30

.endproc