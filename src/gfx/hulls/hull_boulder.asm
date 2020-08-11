; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; $06: boulder
;-------------------------------------------------------------------------------
hull_index           .set hull_index + 1
hull_boulder_index     := hull_index                                    ;=$06

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
hull_boulder_kill       = 6     ;= 0.02

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_boulder                                            ;$D00A/B

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D047

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < hull_boulder_kill                                     ;$D068

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > hull_boulder_kill                                     ;$D089

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_boulder                                                    ;$D3FB
        ;-----------------------------------------------------------------------
        .byte                  $00, $84, $03, $3e, $7a                  ;$D3FB
        .byte   $31, $00, $0e, $2a, $0f, $01, $00, $28                  ;$D400
        .byte   $14, $14, $1e, $00, $00, $02, $00, $12
        .byte   $25, $0b, $bf, $01, $59, $1e, $07, $0c                  ;$D410
        .byte   $1f, $12, $56, $1c, $07, $0c, $7f, $23
        .byte   $67, $02, $00, $27, $3f, $34, $78, $1c                  ;$D420
        .byte   $22, $1e, $bf, $04, $89, $05, $0a, $0d
        .byte   $5f, $ff, $ff, $14, $11, $1e, $3f, $ff                  ;$D430
        .byte   $ff, $1f, $15, $00, $04, $1f, $26, $04
        .byte   $08, $1f, $37, $08, $0c, $1f, $48, $0c                  ;$D440
        .byte   $10, $1f, $09, $10, $00, $1f, $01, $00
        .byte   $14, $1f, $12, $04, $14, $1f, $23, $08                  ;$D450
        .byte   $14, $1f, $34, $0c, $14, $1f, $04, $10
        .byte   $14, $1f, $59, $00, $18, $1f, $56, $04                  ;$D460
        .byte   $18, $1f, $67, $08, $18, $1f, $78, $0c
        .byte   $18, $1f, $89, $10, $18, $df, $0f, $03                  ;$D470
        .byte   $08, $9f, $07, $0c, $1e, $5f, $20, $2f
        .byte   $18, $ff, $03, $27, $07, $ff, $05, $04                  ;$D480
        .byte   $01, $1f, $31, $54, $08, $3f, $70, $15
        .byte   $15, $7f, $4c, $23, $52, $3f, $16, $38                  ;$D490
        .byte   $89, $3f, $28, $6e, $26

.endproc