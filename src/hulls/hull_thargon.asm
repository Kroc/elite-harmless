; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; thargon
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_THARGON            = hull_index                                    ;=$1E

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_THARGON_KILL       = 33    ;= 0.128

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_thargon                                            ;$D03A/B

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $04                                                     ;$D05F

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_THARGON_KILL                                     ;$D080

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_THARGON_KILL                                     ;$D0A1

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_thargon                                                    ;$EBBD
        ;-----------------------------------------------------------------------
        ; scooping a thargon gets you valuable "alien items"
        .scoop_debris   Cargo::aliens, 0                                ;$EBBD
        
        .byte                                 $40, $06                  ;$EBBE
        .byte   $e6, $50, $45, $00, $12, $3c, $0f, $32                  ;$EBC0
        .byte   $00, $1c, $14, $14, $1e, $e7, $00, $02
        .byte   $10, $09, $00, $28, $9f, $01, $55, $09                  ;$EBD0
        .byte   $26, $0c, $df, $01, $22, $09, $18, $20
        .byte   $ff, $02, $33, $09, $18, $20, $bf, $03                  ;$EBE0
        .byte   $44, $09, $26, $0c, $9f, $04, $55, $09
        .byte   $00, $08, $3f, $15, $66, $09, $0a, $0f                  ;$EBF0
        .byte   $7f, $12, $66, $09, $06, $1a, $7f, $23
        .byte   $66, $09, $06, $1a, $3f, $34, $66, $09                  ;$EC00
        .byte   $0a, $0f, $3f, $45, $66, $9f, $24, $00
        .byte   $00, $5f, $14, $05, $07, $7f, $2e, $2a                  ;$EC10
        .byte   $0e, $3f, $24, $00, $68, $3f, $2e, $2a
        .byte   $0e, $1f, $14, $05, $07, $1f, $24, $00                  ;$EC20
        .byte   $00

.endproc