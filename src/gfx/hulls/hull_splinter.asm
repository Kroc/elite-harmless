; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; $08: splinter / rock
;-------------------------------------------------------------------------------
hull_index           .set hull_index + 1
hull_splinter_index    := hull_index

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
hull_splinter_kill      = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_splinter                                           ;$D00E/F

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D049

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < hull_splinter_kill                                    ;$D06A

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > hull_splinter_kill                                    ;$D08B

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_splinter                                                   ;$D573
        ;-----------------------------------------------------------------------
        .byte                  $b0, $00, $01, $78, $44                  ;$D573
        .byte   $1d, $00, $16, $18, $06, $00, $00, $10
        .byte   $08, $14, $0a, $fd, $00, $05, $00, $18                  ;$D580
        .byte   $19, $10, $df, $12, $33, $00, $0c, $0a
        .byte   $3f, $02, $33, $0b, $06, $02, $5f, $01                  ;$D590
        .byte   $33, $0c, $2a, $07, $1f, $01, $22, $1f
        .byte   $23, $00, $04, $1f, $03, $04, $08, $1f                  ;$D5A0
        .byte   $01, $08, $0c, $1f, $12, $0c, $00

.endproc