; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; boa
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_BOA                = hull_index                                    ;=$0D

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_BOA_KILL           = 213   ;= 0.83

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_boa                                                ;$D018/9

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a0                                                     ;$D04E

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_BOA_KILL                                         ;$D06F

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_BOA_KILL                                         ;$D090

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_boa                                                        ;$DB3D
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 5 debris!
        .scoop_debris   0, 5                                            ;$DB3D
        
        .byte                                 $24, $13                  ;$DB3E
        .byte   $62, $c2, $5d, $00, $26, $4e, $18, $00                  ;$DB40
        .byte   $00, $34, $28, $fa, $18, $00, $00, $00
        .byte   $1c, $00, $00, $5d, $1f, $ff, $ff, $00                  ;$DB50
        .byte   $28, $57, $38, $02, $33, $26, $19, $63
        .byte   $78, $01, $44, $26, $19, $63, $f8, $12                  ;$DB60
        .byte   $55, $26, $28, $3b, $bf, $23, $69, $26
        .byte   $28, $3b, $3f, $03, $6b, $3e, $00, $43                  ;$DB70
        .byte   $3f, $04, $8b, $18, $41, $4f, $7f, $14
        .byte   $8a, $18, $41, $4f, $ff, $15, $7a, $3e                  ;$DB80
        .byte   $00, $43, $bf, $25, $79, $00, $07, $6b
        .byte   $36, $02, $aa, $0d, $09, $6b, $76, $01                  ;$DB90
        .byte   $aa, $0d, $09, $6b, $f6, $12, $cc, $1f
        .byte   $6b, $00, $14, $1f, $8a, $00, $1c, $1f                  ;$DBA0
        .byte   $79, $00, $24, $1d, $69, $00, $10, $1d
        .byte   $8b, $00, $18, $1d, $7a, $00, $20, $1f                  ;$DBB0
        .byte   $36, $10, $14, $1f, $0b, $14, $18, $1f
        .byte   $48, $18, $1c, $1f, $1a, $1c, $20, $1f                  ;$DBC0
        .byte   $57, $20, $24, $1f, $29, $10, $24, $18
        .byte   $23, $04, $10, $18, $03, $04, $14, $18                  ;$DBD0
        .byte   $25, $0c, $24, $18, $15, $0c, $20, $18
        .byte   $04, $08, $18, $18, $14, $08, $1c, $16                  ;$DBE0
        .byte   $02, $04, $28, $16, $01, $08, $2c, $16
        .byte   $12, $0c, $30, $0e, $0c, $28, $2c, $0e                  ;$DBF0
        .byte   $1c, $2c, $30, $0e, $2c, $30, $28, $3f
        .byte   $2b, $25, $3c, $7f, $00, $2d, $59, $bf                  ;$DC00
        .byte   $2b, $25, $3c, $1f, $00, $28, $00, $7f
        .byte   $3e, $20, $14, $ff, $3e, $20, $14, $1f                  ;$DC10
        .byte   $00, $17, $06, $df, $17, $0f, $09, $5f
        .byte   $17, $0f, $09, $9f, $1a, $0d, $0a, $5f                  ;$DC20
        .byte   $00, $1f, $0c, $1f, $1a, $0d, $0a, $2e
        .byte   $00, $00, $6b                                           ;$DC30

.endproc