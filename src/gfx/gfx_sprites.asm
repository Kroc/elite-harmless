; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "gfx_sprites.asm":
;
; NOTE: must be aligned to 64 bytes (at destination)

.segment        "GFX_SPRITES"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
_6800:  ; sprites:                                                      ;$6800
;===============================================================================
        ; 1: crosshair 1                                                ;$6800
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $3e, $00, $f8
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00, $3a

        ; 2: crosshair 2                                                ;$6840
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $07, $ff, $c0
        .byte   $04, $00, $40
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $04, $00, $40
        .byte   $07, $ff, $c0
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $10, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00, $31

        ; 3: crosshair 3                                                ;$6880
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $fe, $00
        .byte   $00, $44, $00
        .byte   $00, $28, $00
        .byte   $00, $10, $00
        .byte   $30, $00, $18
        .byte   $28, $00, $28
        .byte   $24, $00, $48
        .byte   $22, $00, $88
        .byte   $24, $00, $48
        .byte   $28, $00, $28
        .byte   $30, $00, $18
        .byte   $00, $10, $00
        .byte   $00, $28, $00
        .byte   $00, $44, $00
        .byte   $00, $fe, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $00, $00, $45

        ; 4: crosshair 4                                                ;$68C0
        ;-----------------------------------------------------------------------
        .byte   $3f, $ff, $f8
        .byte   $20, $10, $08
        .byte   $20, $38, $08
        .byte   $08, $10, $20
        .byte   $c4, $38, $46
        .byte   $82, $10, $82
        .byte   $81, $39, $02
        .byte   $80, $10, $02
        .byte   $80, $7c, $02
        .byte   $a6, $44, $ca
        .byte   $fc, $10, $7e
        .byte   $a6, $44, $ca
        .byte   $80, $7c, $02
        .byte   $80, $10, $02
        .byte   $81, $39, $02
        .byte   $82, $10, $82
        .byte   $c4, $38, $46
        .byte   $08, $10, $20
        .byte   $20, $38, $08
        .byte   $20, $10, $08
        .byte   $3f, $ff, $f8, $a3

        ; 5: explosion                                                  ;$6900
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $00
        .byte   $00, $43, $00
        .byte   $10, $c8, $80
        .byte   $04, $31, $c0
        .byte   $13, $04, $c8
        .byte   $08, $2c, $24
        .byte   $59, $2d, $cc
        .byte   $13, $56, $38
        .byte   $ca, $6e, $16
        .byte   $0e, $6d, $8b
        .byte   $20, $db, $98
        .byte   $06, $cb, $b0
        .byte   $23, $a9, $8a
        .byte   $8e, $6d, $8b
        .byte   $13, $24, $c8
        .byte   $33, $2d, $94
        .byte   $08, $63, $88
        .byte   $18, $04, $20
        .byte   $18, $c2, $0c
        .byte   $00, $c8, $80
        .byte   $00, $06, $00, $44

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////

        ; 6: trumble 1 (multi-colour)                                   ;$6940
        ;-----------------------------------------------------------------------
        .byte   $00, $2a, $00
        .byte   $08, $aa, $80
        .byte   $0a, $99, $a0
        .byte   $2a, $aa, $a8
        .byte   $0a, $aa, $aa
        .byte   $26, $a6, $a8
        .byte   $aa, $6a, $aa
        .byte   $2a, $aa, $98
        .byte   $aa, $aa, $aa
        .byte   $aa, $aa, $aa
        .byte   $2a, $aa, $a8
        .byte   $ab, $ea, $fa
        .byte   $af, $fb, $fe
        .byte   $af, $bb, $ee
        .byte   $ab, $ea, $fa
        .byte   $2a, $aa, $a8
        .byte   $0a, $aa, $a0
        .byte   $02, $aa, $80
        .byte   $00, $96, $00
        .byte   $00, $14, $00
        .byte   $00, $00, $00, $44

        ; 7: trumble 2 (multi-colour)                                   ;$6980
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $00
        .byte   $00, $00, $00
        .byte   $00, $0a, $00
        .byte   $0a, $2a, $80
        .byte   $2a, $a6, $a0
        .byte   $2a, $aa, $a8
        .byte   $aa, $6a, $a8
        .byte   $2a, $aa, $a8
        .byte   $aa, $aa, $aa
        .byte   $aa, $aa, $aa
        .byte   $2a, $aa, $a8
        .byte   $ab, $ea, $fa
        .byte   $af, $fb, $fe
        .byte   $ae, $fb, $be
        .byte   $ab, $ea, $fa
        .byte   $2a, $aa, $a8
        .byte   $0a, $aa, $a0
        .byte   $01, $aa, $40
        .byte   $00, $96, $00
        .byte   $00, $14, $00
        .byte   $00, $00, $00, $54

;$69C0

.endif  ;///////////////////////////////////////////////////////////////////////