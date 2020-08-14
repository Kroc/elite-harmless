; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; escape capsule
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ESCAPE             := hull_index                                   ;=$03

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ESCAPE_KILL        = 16    ;= 0.06

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_escape                                             ;$D004/5

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $01                                                     ;$D044

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_ESCAPE_KILL                                      ;$D065

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_ESCAPE_KILL                                      ;$D086

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_escape                                                     ;$D2BF
        ;-----------------------------------------------------------------------
        .byte                                      $20                  ;$D2BF
        .byte   $00, $01, $2c, $44, $1d, $00, $16, $18                  ;$D2C0
        .byte   $06, $00, $00, $10, $08, $11, $08, $00
        .byte   $00, $04, $00, $07, $00, $24, $9f, $12                  ;$D2D0
        .byte   $33, $07, $0e, $0c, $ff, $02, $33, $07
        .byte   $0e, $0c, $bf, $01, $33, $15, $00, $00                  ;$D2E0
        .byte   $1f, $01, $22, $1f, $23, $00, $04, $1f
        .byte   $03, $04, $08, $1f, $01, $08, $0c, $1f                  ;$D2F0
        .byte   $12, $0c, $00, $1f, $13, $00, $08, $1f
        .byte   $02, $0c, $04, $3f, $34, $00, $7a, $1f                  ;$D300
        .byte   $27, $67, $1e, $5f, $27, $67, $1e, $9f
        .byte   $70, $00, $00                                           ;$D310

.endproc