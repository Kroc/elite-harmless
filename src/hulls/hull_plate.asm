; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; plate / alloys
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_PLATE              = hull_index                                    ;=$04

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_PLATE_KILL         = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_plate                                              ;$D006/7

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D045

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_PLATE_KILL                                       ;$D066

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_PLATE_KILL                                       ;$D087

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_plate                                                      ;$D313
        ;-----------------------------------------------------------------------
        ; scooping a plate will get you some alloys
        .scoop_debris   Cargo::alloys, 0                                ;$D313
        
        .byte                       $64, $00, $2c, $3c                  ;$D314
        .byte   $15, $00, $0a, $18, $04, $00, $00, $04
        .byte   $05, $10, $10, $00, $00, $03, $00, $0f                  ;$D320
        .byte   $16, $09, $ff, $ff, $ff, $0f, $26, $09
        .byte   $bf, $ff, $ff, $13, $20, $0b, $14, $ff                  ;$D330
        .byte   $ff, $0a, $2e, $06, $54, $ff, $ff, $1f
        .byte   $ff, $00, $04, $10, $ff, $04, $08, $14                  ;$D340
        .byte   $ff, $08, $0c, $10, $ff, $0c, $00, $00
        .byte   $00, $00, $00                                           ;$D350

.endproc