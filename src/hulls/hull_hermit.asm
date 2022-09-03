; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; rock hermit
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_HERMIT             = hull_index                                    ;=$0F

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_HERMIT_KILL        = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_hermit                                             ;$D01C/D

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a1                                                     ;$D050

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_HERMIT_KILL                                      ;$D071

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_HERMIT_KILL                                      ;$D092

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_hermit                                                     ;$DD35
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 7 debris!
        .scoop_debris   0, 7                                            ;$DD35
        
        .byte                                 $00, $19                  ;$DD36
        .byte   $4a, $9e, $45, $00, $32, $36, $15, $00
        .byte   $00, $38, $32, $b4, $1e, $00, $00, $01                  ;$DD40
        .byte   $02, $00, $50, $00, $1f, $ff, $ff, $50
        .byte   $0a, $00, $df, $ff, $ff, $00, $50, $00                  ;$DD50
        .byte   $5f, $ff, $ff, $46, $28, $00, $5f, $ff
        .byte   $ff, $3c, $32, $00, $1f, $65, $dc, $32                  ;$DD60
        .byte   $00, $3c, $1f, $ff, $ff, $28, $00, $46
        .byte   $9f, $10, $32, $00, $1e, $4b, $3f, $ff                  ;$DD70
        .byte   $ff, $00, $32, $3c, $7f, $98, $ba, $1f
        .byte   $72, $00, $04, $1f, $d6, $00, $10, $1f                  ;$DD80
        .byte   $c5, $0c, $10, $1f, $b4, $08, $0c, $1f
        .byte   $a3, $04, $08, $1f, $32, $04, $18, $1f                  ;$DD90
        .byte   $31, $08, $18, $1f, $41, $08, $14, $1f
        .byte   $10, $14, $18, $1f, $60, $00, $14, $1f                  ;$DDA0
        .byte   $54, $0c, $14, $1f, $20, $00, $18, $1f
        .byte   $65, $10, $14, $1f, $a8, $04, $20, $1f                  ;$DDB0
        .byte   $87, $04, $1c, $1f, $d7, $00, $1c, $1f
        .byte   $dc, $10, $1c, $1f, $c9, $0c, $1c, $1f                  ;$DDC0
        .byte   $b9, $0c, $20, $1f, $ba, $08, $20, $1f
        .byte   $98, $1c, $20, $1f, $09, $42, $51, $5f                  ;$DDD0
        .byte   $09, $42, $51, $9f, $48, $40, $1f, $df
        .byte   $40, $49, $2f, $5f, $2d, $4f, $41, $1f                  ;$DDE0
        .byte   $87, $0f, $23, $1f, $26, $4c, $46, $bf
        .byte   $42, $3b, $27, $ff, $43, $0f, $50, $7f                  ;$DDF0
        .byte   $42, $0e, $4b, $ff, $46, $50, $28, $7f
        .byte   $3a, $66, $33, $3f, $51, $09, $43, $3f                  ;$DE00
        .byte   $2f, $5e, $3f

.endproc