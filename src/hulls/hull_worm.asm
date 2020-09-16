; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; worm
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_WORM               := hull_index                                   ;=$17

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_WORM_KILL          = 50    ;= 0.19

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_worm                                               ;$D02C/D

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $05                                                     ;$D058

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_WORM_KILL                                        ;$D079

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_WORM_KILL                                        ;$D09A

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_worm                                                       ;$E45B
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$E45B
        
        .byte                       $49, $26, $50, $90                  ;$E45C
        .byte   $4d, $00, $12, $3c, $10, $00, $00, $20                  ;$E460
        .byte   $13, $1e, $17, $00, $00, $03, $08, $0a
        .byte   $0a, $23, $5f, $02, $77, $0a, $0a, $23                  ;$E470
        .byte   $df, $03, $77, $05, $06, $0f, $1f, $01
        .byte   $24, $05, $06, $0f, $9f, $01, $35, $0f                  ;$E480
        .byte   $0a, $19, $5f, $24, $77, $0f, $0a, $19
        .byte   $df, $35, $77, $1a, $0a, $19, $7f, $46                  ;$E490
        .byte   $77, $1a, $0a, $19, $ff, $56, $77, $08
        .byte   $0e, $19, $3f, $14, $66, $08, $0e, $19                  ;$E4A0
        .byte   $bf, $15, $66, $1f, $07, $00, $04, $1f
        .byte   $37, $04, $14, $1f, $57, $14, $1c, $1f                  ;$E4B0
        .byte   $67, $1c, $18, $1f, $47, $18, $10, $1f
        .byte   $27, $10, $00, $1f, $02, $00, $08, $1f                  ;$E4C0
        .byte   $03, $04, $0c, $1f, $24, $10, $08, $1f
        .byte   $35, $14, $0c, $1f, $14, $08, $20, $1f                  ;$E4D0
        .byte   $46, $20, $18, $1f, $15, $0c, $24, $1f
        .byte   $56, $24, $1c, $1f, $01, $08, $0c, $1f                  ;$E4E0
        .byte   $16, $20, $24, $1f, $00, $58, $46, $1f
        .byte   $00, $45, $0e, $1f, $46, $42, $23, $9f                  ;$E4F0
        .byte   $46, $42, $23, $1f, $40, $31, $0e, $9f
        .byte   $40, $31, $0e, $3f, $00, $00, $c8, $5f                  ;$E500
        .byte   $00, $50, $00

.endproc