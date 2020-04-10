; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; $21: space station (dodo)
;-------------------------------------------------------------------------------
hull_index           .set hull_index + 1
hull_dodo_index        := hull_index

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
hull_dodo_kill          = 0     ;= 0.00

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
hull_pointer_dodo:
        ;-----------------------------------------------------------------------
        hull_pointer_dodo_lo := hull_pointer_dodo+0
        hull_pointer_dodo_hi := hull_pointer_dodo+1
        
        .addr   hull_dodo                                               ;$D040

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D062

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < hull_dodo_kill                                        ;$D083

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > hull_dodo_kill                                        ;$D0A4

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_dodo                                                       ;$EE2D
        ;-----------------------------------------------------------------------
        .byte                            $00, $90, $7e                  ;$EE2D
        .byte   $a4, $2c, $65, $00, $36, $90, $22, $00                  ;$EE30
        .byte   $00, $30, $7d, $f0, $00, $00, $01, $00
        .byte   $00, $00, $96, $c4, $1f, $01, $55, $8f                  ;$EE40
        .byte   $2e, $c4, $1f, $01, $22, $58, $79, $c4
        .byte   $5f, $02, $33, $58, $79, $c4, $df, $03                  ;$EE50
        .byte   $44, $8f, $2e, $c4, $9f, $04, $55, $00
        .byte   $f3, $2e, $1f, $15, $66, $e7, $4b, $2e                  ;$EE60
        .byte   $1f, $12, $77, $8f, $c4, $2e, $5f, $23
        .byte   $88, $8f, $c4, $2e, $df, $34, $99, $e7                  ;$EE70
        .byte   $4b, $2e, $9f, $45, $aa, $8f, $c4, $2e
        .byte   $3f, $16, $77, $e7, $4b, $2e, $7f, $27                  ;$EE80
        .byte   $88, $00, $f3, $2e, $7f, $38, $99, $e7
        .byte   $4b, $2e, $ff, $49, $aa, $8f, $c4, $2e                  ;$EE90
        .byte   $bf, $56, $aa, $58, $79, $c4, $3f, $67
        .byte   $bb, $8f, $2e, $c4, $7f, $78, $bb, $00                  ;$EEA0
        .byte   $96, $c4, $7f, $89, $bb, $8f, $2e, $c4
        .byte   $ff, $9a, $bb, $58, $79, $c4, $bf, $6a                  ;$EEB0
        .byte   $bb, $10, $20, $c4, $9e, $00, $00, $10
        .byte   $20, $c4, $de, $00, $00, $10, $20, $c4                  ;$EEC0
        .byte   $17, $00, $00, $10, $20, $c4, $57, $00
        .byte   $00, $1f, $01, $00, $04, $1f, $02, $04                  ;$EED0
        .byte   $08, $1f, $03, $08, $0c, $1f, $04, $0c
        .byte   $10, $1f, $05, $10, $00, $1f, $16, $14                  ;$EEE0
        .byte   $28, $1f, $17, $28, $18, $1f, $27, $18
        .byte   $2c, $1f, $28, $2c, $1c, $1f, $38, $1c                  ;$EEF0
        .byte   $30, $1f, $39, $30, $20, $1f, $49, $20
        .byte   $34, $1f, $4a, $34, $24, $1f, $5a, $24                  ;$EF00
        .byte   $38, $1f, $56, $38, $14, $1f, $7b, $3c
        .byte   $40, $1f, $8b, $40, $44, $1f, $9b, $44                  ;$EF10
        .byte   $48, $1f, $ab, $48, $4c, $1f, $6b, $4c
        .byte   $3c, $1f, $15, $00, $14, $1f, $12, $04                  ;$EF20
        .byte   $18, $1f, $23, $08, $1c, $1f, $34, $0c
        .byte   $20, $1f, $45, $10, $24, $1f, $67, $28                  ;$EF30
        .byte   $3c, $1f, $78, $2c, $40, $1f, $89, $30
        .byte   $44, $1f, $9a, $34, $48, $1f, $6a, $38                  ;$EF40
        .byte   $4c, $1e, $00, $50, $54, $14, $00, $54
        .byte   $5c, $17, $00, $5c, $58, $14, $00, $58                  ;$EF50
        .byte   $50, $1f, $00, $00, $c4, $1f, $67, $8e
        .byte   $58, $5f, $a9, $37, $59, $5f, $00, $b0                  ;$EF60
        .byte   $58, $df, $a9, $37, $59, $9f, $67, $8e
        .byte   $58, $3f, $00, $b0, $58, $3f, $a9, $37                  ;$EF70
        .byte   $59, $7f, $67, $8e, $58, $ff, $67, $8e
        .byte   $58, $bf, $a9, $37, $59, $3f, $00, $00                  ;$EF80
        .byte   $c4, $4c, $44, $41, $52, $1f, $3f, $58

.endproc