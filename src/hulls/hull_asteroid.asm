; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; asteroid
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ASTEROID           := hull_index                                   ;=$07

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ASTEROID_KILL      = 8     ;= 0.03

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_asteroid                                           ;$D00C/D

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D048

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_ASTEROID_KILL                                    ;$D069

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_ASTEROID_KILL                                    ;$D08A

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_asteroid                                                   ;$D49D
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$D49D
        
        .byte                                 $00, $19                  ;$D49E
        .byte   $4a, $9e, $45, $00, $22, $36, $15, $05                  ;$D4A0
        .byte   $00, $38, $32, $3c, $1e, $00, $00, $01
        .byte   $00, $00, $50, $00, $1f, $ff, $ff, $50                  ;$D4B0
        .byte   $0a, $00, $df, $ff, $ff, $00, $50, $00
        .byte   $5f, $ff, $ff, $46, $28, $00, $5f, $ff                  ;$D4C0
        .byte   $ff, $3c, $32, $00, $1f, $65, $dc, $32
        .byte   $00, $3c, $1f, $ff, $ff, $28, $00, $46                  ;$D4D0
        .byte   $9f, $10, $32, $00, $1e, $4b, $3f, $ff
        .byte   $ff, $00, $32, $3c, $7f, $98, $ba, $1f                  ;$D4E0
        .byte   $72, $00, $04, $1f, $d6, $00, $10, $1f
        .byte   $c5, $0c, $10, $1f, $b4, $08, $0c, $1f                  ;$D4F0
        .byte   $a3, $04, $08, $1f, $32, $04, $18, $1f
        .byte   $31, $08, $18, $1f, $41, $08, $14, $1f                  ;$D500
        .byte   $10, $14, $18, $1f, $60, $00, $14, $1f
        .byte   $54, $0c, $14, $1f, $20, $00, $18, $1f                  ;$D510
        .byte   $65, $10, $14, $1f, $a8, $04, $20, $1f
        .byte   $87, $04, $1c, $1f, $d7, $00, $1c, $1f                  ;$D520
        .byte   $dc, $10, $1c, $1f, $c9, $0c, $1c, $1f
        .byte   $b9, $0c, $20, $1f, $ba, $08, $20, $1f                  ;$D530
        .byte   $98, $1c, $20, $1f, $09, $42, $51, $5f
        .byte   $09, $42, $51, $9f, $48, $40, $1f, $df                  ;$D540
        .byte   $40, $49, $2f, $5f, $2d, $4f, $41, $1f
        .byte   $87, $0f, $23, $1f, $26, $4c, $46, $bf                  ;$D550
        .byte   $42, $3b, $27, $ff, $43, $0f, $50, $7f
        .byte   $42, $0e, $4b, $ff, $46, $50, $28, $7f                  ;$D560
        .byte   $3a, $66, $33, $3f, $51, $09, $43, $3f
        .byte   $2f, $5e, $3f                                           ;$D570

.endproc