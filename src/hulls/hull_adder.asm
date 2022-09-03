; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; adder
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ADDER              = hull_index                                    ;=$14

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ADDER_KILL         = 90    ;= 0.35

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_adder                                              ;$D026/7

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D055

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ADDER_KILL                                       ;$D076

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ADDER_KILL                                       ;$D097

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_adder                                                      ;$E1A1
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$E1A1

        .byte             $c4, $09, $80, $f4, $65, $00                  ;$E1A2
        .byte   $16, $6c, $1d, $28, $00, $3c, $14, $55
        .byte   $18, $00, $00, $02, $10, $12, $00, $28                  ;$E1B0
        .byte   $9f, $01, $bc, $12, $00, $28, $1f, $01
        .byte   $23, $1e, $00, $18, $3f, $23, $45, $1e                  ;$E1C0
        .byte   $00, $28, $3f, $45, $66, $12, $07, $28
        .byte   $7f, $56, $7e, $12, $07, $28, $ff, $78                  ;$E1D0
        .byte   $ae, $1e, $00, $28, $bf, $89, $aa, $1e
        .byte   $00, $18, $bf, $9a, $bc, $12, $07, $28                  ;$E1E0
        .byte   $bf, $78, $9d, $12, $07, $28, $3f, $46
        .byte   $7d, $12, $07, $0d, $9f, $09, $bd, $12                  ;$E1F0
        .byte   $07, $0d, $1f, $02, $4d, $12, $07, $0d
        .byte   $df, $1a, $ce, $12, $07, $0d, $5f, $13                  ;$E200
        .byte   $5e, $0b, $03, $1d, $85, $00, $00, $0b
        .byte   $03, $1d, $05, $00, $00, $0b, $04, $18                  ;$E210
        .byte   $04, $00, $00, $0b, $04, $18, $84, $00
        .byte   $00, $1f, $01, $00, $04, $07, $23, $04                  ;$E220
        .byte   $08, $1f, $45, $08, $0c, $1f, $56, $0c
        .byte   $10, $1f, $7e, $10, $14, $1f, $8a, $14                  ;$E230
        .byte   $18, $1f, $9a, $18, $1c, $07, $bc, $1c
        .byte   $00, $1f, $46, $0c, $24, $1f, $7d, $24                  ;$E240
        .byte   $20, $1f, $89, $20, $18, $1f, $0b, $00
        .byte   $28, $1f, $9b, $1c, $28, $1f, $02, $04                  ;$E250
        .byte   $2c, $1f, $24, $08, $2c, $1f, $1c, $00
        .byte   $30, $1f, $ac, $1c, $30, $1f, $13, $04                  ;$E260
        .byte   $34, $1f, $35, $08, $34, $1f, $0d, $28
        .byte   $2c, $1f, $1e, $30, $34, $1f, $9d, $20                  ;$E270
        .byte   $28, $1f, $4d, $24, $2c, $1f, $ae, $14
        .byte   $30, $1f, $5e, $10, $34, $05, $00, $38                  ;$E280
        .byte   $3c, $03, $00, $3c, $40, $04, $00, $40
        .byte   $44, $03, $00, $44, $38, $1f, $00, $27                  ;$E290
        .byte   $0a, $5f, $00, $27, $0a, $1f, $45, $32
        .byte   $0d, $5f, $45, $32, $0d, $1f, $1e, $34                  ;$E2A0
        .byte   $00, $5f, $1e, $34, $00, $3f, $00, $00
        .byte   $a0, $3f, $00, $00, $a0, $3f, $00, $00                  ;$E2B0
        .byte   $a0, $9f, $1e, $34, $00, $df, $1e, $34
        .byte   $00, $9f, $45, $32, $0d, $df, $45, $32                  ;$E2C0
        .byte   $0d, $1f, $00, $1c, $00, $5f, $00, $1c
        .byte   $00                                                     ;$E2D0

.endproc