; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; sidewinder
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_SIDEWINDER         := hull_index                                   ;=$11

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_SIDEWINDER_KILL    = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_sidewinder                                         ;$D020/1

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $0c                                                     ;$D052

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_SIDEWINDER_KILL                                  ;$D073

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_SIDEWINDER_KILL                                  ;$D094

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_sidewinder                                                 ;$DEE5
        ;-----------------------------------------------------------------------
        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0                                            ;$DEE5
        
        .byte                                 $81, $10                  ;$DEE6
        .byte   $50, $8c, $41, $00, $1e, $3c, $0f, $32
        .byte   $00, $1c, $14, $46, $25, $00, $00, $02                  ;$DEF0
        .byte   $10, $20, $00, $24, $9f, $10, $54, $20
        .byte   $00, $24, $1f, $20, $65, $40, $00, $1c                  ;$DF00
        .byte   $3f, $32, $66, $40, $00, $1c, $bf, $31
        .byte   $44, $00, $10, $1c, $3f, $10, $32, $00                  ;$DF10
        .byte   $10, $1c, $7f, $43, $65, $0c, $06, $1c
        .byte   $af, $33, $33, $0c, $06, $1c, $2f, $33                  ;$DF20
        .byte   $33, $0c, $06, $1c, $6c, $33, $33, $0c
        .byte   $06, $1c, $ec, $33, $33, $1f, $50, $00                  ;$DF30
        .byte   $04, $1f, $62, $04, $08, $1f, $20, $04
        .byte   $10, $1f, $10, $00, $10, $1f, $41, $00                  ;$DF40
        .byte   $0c, $1f, $31, $0c, $10, $1f, $32, $08
        .byte   $10, $1f, $43, $0c, $14, $1f, $63, $08                  ;$DF50
        .byte   $14, $1f, $65, $04, $14, $1f, $54, $00
        .byte   $14, $0f, $33, $18, $1c, $0c, $33, $1c                  ;$DF60
        .byte   $20, $0c, $33, $18, $24, $0c, $33, $20
        .byte   $24, $1f, $00, $20, $08, $9f, $0c, $2f                  ;$DF70
        .byte   $06, $1f, $0c, $2f, $06, $3f, $00, $00
        .byte   $70, $df, $0c, $2f, $06, $5f, $00, $20                  ;$DF80
        .byte   $08, $5f, $0c, $2f, $06

.endproc