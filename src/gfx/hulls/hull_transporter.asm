; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; transporter
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_TRANSPORTER        := hull_index                                   ;=$0A

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_TRANSPORTER_KILL   = 17    ;= 0.066

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_transporter                                        ;$D012/3

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $61                                                     ;$D04B

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_TRANSPORTER_KILL                                 ;$D06C

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_TRANSPORTER_KILL                                 ;$D08D

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_transporter                                                ;$D6E1
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$D6E1
        
        .byte             $c4, $09, $f2, $aa, $95, $30                  ;$D6E2
        .byte   $1a, $de, $2e, $00, $00, $38, $10, $20
        .byte   $0a, $00, $01, $02, $00, $00, $0a, $1a                  ;$D6F0
        .byte   $3f, $06, $77, $19, $04, $1a, $bf, $01
        .byte   $77, $1c, $03, $1a, $ff, $01, $22, $19                  ;$D700
        .byte   $08, $1a, $ff, $02, $33, $1a, $08, $1a
        .byte   $7f, $03, $44, $1d, $03, $1a, $7f, $04                  ;$D710
        .byte   $55, $1a, $04, $1a, $3f, $05, $66, $00
        .byte   $06, $0c, $13, $ff, $ff, $1e, $01, $0c                  ;$D720
        .byte   $df, $17, $89, $21, $08, $0c, $df, $12
        .byte   $39, $21, $08, $0c, $5f, $34, $5a, $1e                  ;$D730
        .byte   $01, $0c, $5f, $56, $ab, $0b, $02, $1e
        .byte   $df, $89, $cd, $0d, $08, $1e, $df, $39                  ;$D740
        .byte   $dd, $0e, $08, $1e, $5f, $3a, $dd, $0b
        .byte   $02, $1e, $5f, $ab, $cd, $05, $06, $02                  ;$D750
        .byte   $87, $77, $77, $12, $03, $02, $87, $77
        .byte   $77, $05, $07, $07, $a7, $77, $77, $12                  ;$D760
        .byte   $04, $07, $a7, $77, $77, $0b, $06, $0e
        .byte   $a7, $77, $77, $0b, $05, $07, $a7, $77                  ;$D770
        .byte   $77, $05, $07, $0e, $27, $66, $66, $12
        .byte   $04, $0e, $27, $66, $66, $0b, $05, $07                  ;$D780
        .byte   $27, $66, $66, $05, $06, $03, $27, $66
        .byte   $66, $12, $03, $03, $27, $66, $66, $0b                  ;$D790
        .byte   $04, $08, $07, $66, $66, $0b, $05, $03
        .byte   $27, $66, $66, $10, $08, $0d, $e6, $33                  ;$D7A0
        .byte   $33, $10, $08, $10, $c6, $33, $33, $11
        .byte   $08, $0d, $66, $33, $33, $11, $08, $10                  ;$D7B0
        .byte   $46, $33, $33, $0d, $03, $1a, $e8, $00
        .byte   $00, $0d, $03, $1a, $68, $00, $00, $09                  ;$D7C0
        .byte   $03, $1a, $25, $00, $00, $08, $03, $1a
        .byte   $a5, $00, $00, $1f, $07, $00, $04, $1f                  ;$D7D0
        .byte   $01, $04, $08, $1f, $02, $08, $0c, $1f
        .byte   $03, $0c, $10, $1f, $04, $10, $14, $1f                  ;$D7E0
        .byte   $05, $14, $18, $1f, $06, $00, $18, $10
        .byte   $67, $00, $1c, $1f, $17, $04, $20, $0b                  ;$D7F0
        .byte   $12, $08, $24, $1f, $23, $0c, $24, $1f
        .byte   $34, $10, $28, $0b, $45, $14, $28, $1f                  ;$D800
        .byte   $56, $18, $2c, $11, $78, $1c, $20, $11
        .byte   $19, $20, $24, $11, $5a, $28, $2c, $11                  ;$D810
        .byte   $6b, $1c, $2c, $13, $bc, $1c, $3c, $13
        .byte   $8c, $1c, $30, $10, $89, $20, $30, $1f                  ;$D820
        .byte   $39, $24, $34, $1f, $3a, $28, $38, $10
        .byte   $ab, $2c, $3c, $1f, $9d, $30, $34, $1f                  ;$D830
        .byte   $3d, $34, $38, $1f, $ad, $38, $3c, $1f
        .byte   $cd, $30, $3c, $07, $77, $40, $44, $07                  ;$D840
        .byte   $77, $48, $4c, $07, $77, $4c, $50, $07
        .byte   $77, $48, $50, $07, $77, $50, $54, $07                  ;$D850
        .byte   $66, $58, $5c, $07, $66, $5c, $60, $07
        .byte   $66, $60, $58, $07, $66, $64, $68, $07                  ;$D860
        .byte   $66, $68, $6c, $07, $66, $64, $6c, $07
        .byte   $66, $6c, $70, $06, $33, $74, $78, $06                  ;$D870
        .byte   $33, $7c, $80, $08, $00, $84, $88, $05
        .byte   $00, $88, $8c, $05, $00, $8c, $90, $05                  ;$D880
        .byte   $00, $90, $84, $3f, $00, $00, $67, $bf
        .byte   $6f, $30, $07, $ff, $69, $3f, $15, $5f                  ;$D890
        .byte   $00, $22, $00, $7f, $69, $3f, $15, $3f
        .byte   $6f, $30, $07, $1f, $08, $20, $03, $9f                  ;$D8A0
        .byte   $08, $20, $03, $93, $08, $22, $0b, $9f
        .byte   $4b, $20, $4f, $1f, $4b, $20, $4f, $13                  ;$D8B0
        .byte   $08, $22, $0b, $1f, $00, $26, $11, $1f
        .byte   $00, $00, $79                                           ;$D8C0

.endproc