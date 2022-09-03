; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cobra mk-I
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COBRAMK1           = hull_index                                    ;=$16

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COBRAMK1_KILL      = 170   ;= 0.66

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_cobramk1                                           ;$D02A/B

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D057

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_COBRAMK1_KILL                                    ;$D078

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_COBRAMK1_KILL                                    ;$D099

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_cobramk1                                                   ;$E395
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 3 debris:
        .scoop_debris   0, 3                                            ;$E395
        
        .byte                                 $49, $26                  ;$E396
        .byte   $56, $9e, $49, $28, $1a, $42, $12, $4b
        .byte   $00, $28, $13, $5a, $1a, $00, $00, $02                  ;$E3A0
        .byte   $12, $12, $01, $32, $df, $01, $23, $12
        .byte   $01, $32, $5f, $01, $45, $42, $00, $07                  ;$E3B0
        .byte   $9f, $23, $88, $42, $00, $07, $1f, $45
        .byte   $99, $20, $0c, $26, $bf, $26, $78, $20                  ;$E3C0
        .byte   $0c, $26, $3f, $46, $79, $36, $0c, $26
        .byte   $ff, $13, $78, $36, $0c, $26, $7f, $15                  ;$E3D0
        .byte   $79, $00, $0c, $06, $34, $02, $46, $00
        .byte   $01, $32, $42, $01, $11, $00, $01, $3c                  ;$E3E0
        .byte   $5f, $01, $11, $1f, $01, $04, $00, $1f
        .byte   $23, $00, $08, $1f, $38, $08, $18, $1f                  ;$E3F0
        .byte   $17, $18, $1c, $1f, $59, $1c, $0c, $1f
        .byte   $45, $0c, $04, $1f, $28, $08, $10, $1f                  ;$E400
        .byte   $67, $10, $14, $1f, $49, $14, $0c, $14
        .byte   $02, $00, $20, $14, $04, $20, $04, $10                  ;$E410
        .byte   $26, $10, $20, $10, $46, $20, $14, $1f
        .byte   $78, $10, $18, $1f, $79, $14, $1c, $14                  ;$E420
        .byte   $13, $00, $18, $14, $15, $04, $1c, $02
        .byte   $01, $28, $24, $1f, $00, $29, $0a, $5f                  ;$E430
        .byte   $00, $1b, $03, $9f, $08, $2e, $08, $df
        .byte   $0c, $39, $0c, $1f, $08, $2e, $08, $5f                  ;$E440
        .byte   $0c, $39, $0c, $1f, $00, $31, $00, $3f
        .byte   $00, $00, $9a, $bf, $79, $6f, $3e, $3f                  ;$E450
        .byte   $79, $6f, $3e

.endproc