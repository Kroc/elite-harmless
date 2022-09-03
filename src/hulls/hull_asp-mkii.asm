; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; asp mk-II
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ASPMK2             = hull_index                                    ;=$19

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ASPMK2_KILL        = 277   ;= 1.08

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_aspmk2                                             ;$D030/1

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D05A

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ASPMK2_KILL                                      ;$D07B

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ASPMK2_KILL                                      ;$D09C

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_aspmk2                                                     ;$E693
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$E693
        
        .byte                       $10, $0e, $86, $f6                  ;$E694
        .byte   $69, $20, $1a, $72, $1c, $c8, $00, $30
        .byte   $28, $96, $28, $00, $00, $01, $29, $00                  ;$E6A0
        .byte   $12, $00, $56, $01, $22, $00, $09, $2d
        .byte   $7f, $12, $bb, $2b, $00, $2d, $3f, $16                  ;$E6B0
        .byte   $bb, $45, $03, $00, $5f, $16, $79, $2b
        .byte   $0e, $1c, $5f, $01, $77, $2b, $00, $2d                  ;$E6C0
        .byte   $bf, $25, $bb, $45, $03, $00, $df, $25
        .byte   $8a, $2b, $0e, $1c, $df, $02, $88, $1a                  ;$E6D0
        .byte   $07, $49, $5f, $04, $79, $1a, $07, $49
        .byte   $df, $04, $8a, $2b, $0e, $1c, $1f, $34                  ;$E6E0
        .byte   $69, $2b, $0e, $1c, $9f, $34, $5a, $00
        .byte   $09, $2d, $3f, $35, $6b, $11, $00, $2d                  ;$E6F0
        .byte   $aa, $bb, $bb, $11, $00, $2d, $29, $bb
        .byte   $bb, $00, $04, $2d, $6a, $bb, $bb, $00                  ;$E700
        .byte   $04, $2d, $28, $bb, $bb, $00, $07, $49
        .byte   $4a, $04, $04, $00, $07, $53, $4a, $04                  ;$E710
        .byte   $04, $16, $12, $00, $04, $16, $01, $00
        .byte   $10, $16, $02, $00, $1c, $1f, $1b, $04                  ;$E720
        .byte   $08, $1f, $16, $08, $0c, $10, $79, $0c
        .byte   $20, $1f, $04, $20, $24, $10, $8a, $18                  ;$E730
        .byte   $24, $1f, $25, $14, $18, $1f, $2b, $04
        .byte   $14, $1f, $17, $0c, $10, $1f, $07, $10                  ;$E740
        .byte   $20, $1f, $28, $18, $1c, $1f, $08, $1c
        .byte   $24, $1f, $6b, $08, $30, $1f, $5b, $14                  ;$E750
        .byte   $30, $16, $36, $28, $30, $16, $35, $2c
        .byte   $30, $16, $34, $28, $2c, $1f, $5a, $18                  ;$E760
        .byte   $2c, $1f, $4a, $24, $2c, $1f, $69, $0c
        .byte   $28, $1f, $49, $20, $28, $0a, $bb, $34                  ;$E770
        .byte   $3c, $09, $bb, $3c, $38, $08, $bb, $38
        .byte   $40, $08, $bb, $40, $34, $0a, $04, $48                  ;$E780
        .byte   $44, $5f, $00, $23, $05, $7f, $08, $26
        .byte   $07, $ff, $08, $26, $07, $36, $00, $18                  ;$E790
        .byte   $01, $1f, $00, $2b, $13, $bf, $06, $1c
        .byte   $02, $3f, $06, $1c, $02, $5f, $3b, $40                  ;$E7A0
        .byte   $1f, $df, $3b, $40, $1f, $1f, $50, $2e
        .byte   $32, $9f, $50, $2e, $32, $3f, $00, $00                  ;$E7B0
        .byte   $5a, $59, $3a, $43, $4d

.endproc