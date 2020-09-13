; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; shuttle
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_SHUTTLE            := hull_index                                   ;=$09

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_SHUTTLE_KILL       = 16    ;= 0.062

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_shuttle                                            ;$D010/1

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $21                                                     ;$D04A

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_SHUTTLE_KILL                                     ;$D06B

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_SHUTTLE_KILL                                     ;$D08C

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_shuttle                                                    ;$D5AF
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 15 debris!!
        .scoop_debris   0, 15                                           ;$D5AF

        .byte   $c4, $09, $86, $fe, $71, $00, $26, $72                  ;$D5B0
        .byte   $1e, $00, $00, $34, $16, $20, $08, $00
        .byte   $00, $02, $00, $00, $11, $17, $5f, $ff                  ;$D5C0
        .byte   $ff, $11, $00, $17, $9f, $ff, $ff, $00
        .byte   $12, $17, $1f, $ff, $ff, $12, $00, $17                  ;$D5D0
        .byte   $1f, $ff, $ff, $14, $14, $1b, $ff, $12
        .byte   $39, $14, $14, $1b, $bf, $34, $59, $14                  ;$D5E0
        .byte   $14, $1b, $3f, $56, $79, $14, $14, $1b
        .byte   $7f, $17, $89, $05, $00, $1b, $30, $99                  ;$D5F0
        .byte   $99, $00, $02, $1b, $70, $99, $99, $05
        .byte   $00, $1b, $a9, $99, $99, $00, $03, $1b                  ;$D600
        .byte   $29, $99, $99, $00, $09, $23, $50, $0a
        .byte   $bc, $03, $01, $1f, $47, $ff, $02, $04                  ;$D610
        .byte   $0b, $19, $08, $01, $f4, $0b, $04, $19
        .byte   $08, $a1, $3f, $03, $01, $1f, $c7, $6b                  ;$D620
        .byte   $23, $03, $0b, $19, $88, $f8, $c0, $0a
        .byte   $04, $19, $88, $4f, $18, $1f, $02, $00                  ;$D630
        .byte   $04, $1f, $4a, $04, $08, $1f, $6b, $08
        .byte   $0c, $1f, $8c, $00, $0c, $1f, $18, $00                  ;$D640
        .byte   $1c, $18, $12, $00, $10, $1f, $23, $04
        .byte   $10, $18, $34, $04, $14, $1f, $45, $08                  ;$D650
        .byte   $14, $0c, $56, $08, $18, $1f, $67, $0c
        .byte   $18, $18, $78, $0c, $1c, $1f, $39, $10                  ;$D660
        .byte   $14, $1f, $59, $14, $18, $1f, $79, $18
        .byte   $1c, $1f, $19, $10, $1c, $10, $0c, $00                  ;$D670
        .byte   $30, $10, $0a, $04, $30, $10, $ab, $08
        .byte   $30, $10, $bc, $0c, $30, $10, $99, $20                  ;$D680
        .byte   $24, $07, $99, $24, $28, $09, $99, $28
        .byte   $2c, $07, $99, $20, $2c, $05, $bb, $34                  ;$D690
        .byte   $38, $08, $bb, $38, $3c, $07, $bb, $34
        .byte   $3c, $05, $aa, $40, $44, $08, $aa, $44                  ;$D6A0
        .byte   $48, $07, $aa, $40, $48, $df, $37, $37
        .byte   $28, $5f, $00, $4a, $04, $df, $33, $33                  ;$D6B0
        .byte   $17, $9f, $4a, $00, $04, $9f, $33, $33
        .byte   $17, $1f, $00, $4a, $04, $1f, $33, $33                  ;$D6C0
        .byte   $17, $1f, $4a, $00, $04, $5f, $33, $33
        .byte   $17, $3f, $00, $00, $6b, $9f, $29, $29                  ;$D6D0
        .byte   $5a, $1f, $29, $29, $5a, $5f, $37, $37
        .byte   $28                                                     ;$D6E0

.endproc