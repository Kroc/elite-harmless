; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; constrictor
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_CONSTRICTOR        = hull_index                                    ;=$1F

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_CONSTRICTOR_KILL   = 1365  ;= 5.33!

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_constrictor                                        ;$D03C/D

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $04                                                     ;$D060

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_CONSTRICTOR_KILL                                 ;$D081

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_CONSTRICTOR_KILL                                 ;$D0A2

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_constrictor                                                ;$EC29
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, drops up to 3 debris:
        .scoop_debris   0, 3                                            ;$EC29
        
        .byte             $81, $10, $7a, $da, $51, $00                  ;$EC2A
        .byte   $2e, $66, $18, $00, $00, $28, $2d, $fc                  ;$EC30
        .byte   $24, $00, $00, $02, $34, $14, $07, $50
        .byte   $5f, $02, $99, $14, $07, $50, $df, $01                  ;$EC40
        .byte   $99, $36, $07, $28, $df, $14, $99, $36
        .byte   $07, $28, $ff, $45, $89, $14, $0d, $28                  ;$EC50
        .byte   $bf, $56, $88, $14, $0d, $28, $3f, $67
        .byte   $88, $36, $07, $28, $7f, $37, $89, $36                  ;$EC60
        .byte   $07, $28, $5f, $23, $99, $14, $0d, $05
        .byte   $1f, $ff, $ff, $14, $0d, $05, $9f, $ff                  ;$EC70
        .byte   $ff, $14, $07, $3e, $52, $99, $99, $14
        .byte   $07, $3e, $d2, $99, $99, $19, $07, $19                  ;$EC80
        .byte   $72, $99, $99, $19, $07, $19, $f2, $99
        .byte   $99, $0f, $07, $0f, $6a, $99, $99, $0f                  ;$EC90
        .byte   $07, $0f, $ea, $99, $99, $00, $07, $00
        .byte   $40, $9f, $01, $1f, $09, $00, $04, $1f                  ;$ECA0
        .byte   $19, $04, $08, $1f, $01, $04, $24, $1f
        .byte   $02, $00, $20, $1f, $29, $00, $1c, $1f                  ;$ECB0
        .byte   $23, $1c, $20, $1f, $14, $08, $24, $1f
        .byte   $49, $08, $0c, $1f, $39, $18, $1c, $1f                  ;$ECC0
        .byte   $37, $18, $20, $1f, $67, $14, $20, $1f
        .byte   $56, $10, $24, $1f, $45, $0c, $24, $1f                  ;$ECD0
        .byte   $58, $0c, $10, $1f, $68, $10, $14, $1f
        .byte   $78, $14, $18, $1f, $89, $0c, $18, $1f                  ;$ECE0
        .byte   $06, $20, $24, $12, $99, $28, $30, $05
        .byte   $99, $30, $38, $0a, $99, $38, $28, $0a                  ;$ECF0
        .byte   $99, $2c, $3c, $05, $99, $34, $3c, $12
        .byte   $99, $2c, $34, $1f, $00, $37, $0f, $9f                  ;$ED00
        .byte   $18, $4b, $14, $1f, $18, $4b, $14, $1f
        .byte   $2c, $4b, $00, $9f, $2c, $4b, $00, $9f                  ;$ED10
        .byte   $2c, $4b, $00, $1f, $00, $35, $00, $1f
        .byte   $2c, $4b, $00, $3f, $00, $00, $a0, $5f                  ;$ED20
        .byte   $00, $1b, $00

.endproc