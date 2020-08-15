; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cargo cannister
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_CANNISTER          := hull_index                                   ;=$05

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_CANNISTER_KILL     = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_cannister                                          ;$D008/9

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D046

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_CANNISTER_KILL                                   ;$D067

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_CANNISTER_KILL                                   ;$D088

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_cannister                                                  ;$D353
        ;-----------------------------------------------------------------------
        .byte                  $00, $90, $01, $50, $8c
        .byte   $35, $00, $12, $3c, $0f, $00, $00, $1c
        .byte   $0c, $11, $0f, $00, $00, $02, $00, $18                  ;$D360
        .byte   $10, $00, $1f, $10, $55, $18, $05, $0f
        .byte   $1f, $10, $22, $18, $0d, $09, $5f, $20                  ;$D370
        .byte   $33, $18, $0d, $09, $7f, $30, $44, $18
        .byte   $05, $0f, $3f, $40, $55, $18, $10, $00                  ;$D380
        .byte   $9f, $51, $66, $18, $05, $0f, $9f, $21
        .byte   $66, $18, $0d, $09, $df, $32, $66, $18                  ;$D390
        .byte   $0d, $09, $ff, $43, $66, $18, $05, $0f
        .byte   $bf, $54, $66, $1f, $10, $00, $04, $1f                  ;$D3A0
        .byte   $20, $04, $08, $1f, $30, $08, $0c, $1f
        .byte   $40, $0c, $10, $1f, $50, $00, $10, $1f                  ;$D3B0
        .byte   $51, $00, $14, $1f, $21, $04, $18, $1f
        .byte   $32, $08, $1c, $1f, $43, $0c, $20, $1f                  ;$D3C0
        .byte   $54, $10, $24, $1f, $61, $14, $18, $1f
        .byte   $62, $18, $1c, $1f, $63, $1c, $20, $1f                  ;$D3D0
        .byte   $64, $20, $24, $1f, $65, $24, $14, $1f
        .byte   $60, $00, $00, $1f, $00, $29, $1e, $5f                  ;$D3E0
        .byte   $00, $12, $30, $5f, $00, $33, $00, $7f
        .byte   $00, $12, $30, $3f, $00, $29, $1e, $9f                  ;$D3F0
        .byte   $60, $00, $00

.endproc