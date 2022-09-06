; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CIRCLE_LINES"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; a buffer of line-points is built up so cricles can be drawn continuously.
; in the original game, these two buffers (one for X-coords, one for Y-coords)
; are filled with junk data (stuff left over in the C64 RAM when the game was
; assembled) and occupy space in the disk-file. for elite-harmless we make
; these buffers blocks of reserved RAM that do not exist in the disk-file
;
; TODO: BBC code says these are supposed to be max. 78 bytes each:
;       <https://www.bbcelite.com/deep_dives/the_ball_line_heap.html>
;       also, why 78 bytes? why not 64? (max. number of points in circle)
;
line_points_x:                                          ; BBC: LSX2     ;$26A4
;-------------------------------------------------------------------------------
; RAM used for X-coords for circle line-drawing
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is junk code/data left in memory
        ; in this unitialised table
        ;
        .byte   $76, $85, $9c, $a5, $8b, $85, $9a, $a5
        .byte   $8d, $20, $0c, $9a, $b0, $d2, $85, $6f
        .byte   $a5, $9c, $85, $70, $a5, $6b, $85, $9b
        .byte   $a5, $72, $85, $9c, $a5, $85, $85, $9a
        .byte   $a5, $87, $20, $0c, $9a, $b0, $b9, $85
        .byte   $6b, $a5, $9c, $85, $6c, $a5, $6d, $85
        .byte   $9b, $a5, $74, $85, $9c, $a5, $88, $85
        .byte   $9a, $a5, $8a, $20, $0c, $9a, $b0, $a0
        .byte   $85, $6d, $a5, $9c, $85, $6e, $a5, $71
        .byte   $85, $9a, $a5, $6b, $20, $ea, $39, $85
        .byte   $bb, $a5, $72, $45, $6c, $85, $9c, $a5
        .byte   $73, $85, $9a, $a5, $6d, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $74
        .byte   $45, $6e, $20, $0c, $9a, $85, $bb, $a5
        .byte   $75, $85, $9a, $a5, $6f, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $70
        .byte   $45, $76, $20, $0c, $9a, $48, $98, $4a
        .byte   $4a, $aa, $68, $24, $9c, $30, $02, $a9
        .byte   $00, $95, $35, $c8, $c4, $ae, $b0, $fe
        .byte   $4c, $f2, $9b, $a4, $47, $a6, $48, $a5
        .byte   $4b, $85, $47, $a5, $4c, $85, $48, $84
        .byte   $4b, $86, $4c, $a4, $49, $a6, $4a, $a5
        .byte   $51, $85, $49, $a5, $52, $85, $4a, $84
        .byte   $51, $86, $52, $a4, $4f, $a6, $50, $a5
        .byte   $53, $85, $4f, $a5, $54, $85, $50, $84
        .byte   $53, $86, $54, $a0, $08, $b1, $57, $85
        .byte   $ae, $a5, $57, $18, $69, $14, $85, $5b
        .byte   $a5, $58, $69, $00, $85, $5c, $a0, $00
        .byte   $84, $aa, $84, $9f, $b1, $5b, $85, $6b
        .byte   $c8, $b1, $5b, $85, $6d, $c8, $b1, $5b
        .byte   $85, $6f, $c8, $b1, $5b, $85, $bb, $29
        .byte   $1f, $c5, $ad, $90, $fb, $c8, $b1, $5b
.else   ;///////////////////////////////////////////////////////////////////////
        .res    78
.endif  ;///////////////////////////////////////////////////////////////////////

line_points_y:                                          ; BBC: LSY2     ;$27A4
;-------------------------------------------------------------------------------
; RAM used for Y-coords for circle line-drawing
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is junk code/data left in memory
        ; in this unitialised table
        ;
        .byte   $85, $2e, $29, $0f, $aa, $b5, $35, $d0
        .byte   $fe, $a5, $2e, $4a, $4a, $4a, $4a, $aa
        .byte   $b5, $35, $d0, $fe, $c8, $b1, $5b, $85
        .byte   $2e, $29, $0f, $aa, $b5, $35, $d0, $fe
        .byte   $a5, $2e, $4a, $4a, $4a, $4a, $aa, $b5
        .byte   $35, $d0, $fe, $4c, $8e, $9d, $a5, $bb
        .byte   $85, $6c, $0a, $85, $6e, $0a, $85, $70
        .byte   $20, $2c, $9a, $a5, $0b, $85, $6d, $45
        .byte   $72, $30, $fe, $18, $a5, $71, $65, $09
        .byte   $85, $6b, $a5, $0a, $69, $00, $85, $6c
        .byte   $4c, $b3, $9d, $a5, $09, $38, $e5, $71
        .byte   $85, $6b, $a5, $0a, $e9, $00, $85, $6c
        .byte   $b0, $fe, $49, $ff, $85, $6c, $a9, $01
        .byte   $e5, $6b, $85, $6b, $90, $02, $e6, $6c
        .byte   $a5, $6d, $49, $80, $85, $6d, $a5, $0e
        .byte   $85, $70, $45, $74, $30, $fe, $18, $a5
        .byte   $73, $65, $0c, $85, $6e, $a5, $0d, $69
        .byte   $00, $85, $6f, $4c, $ee, $9d, $a5, $0c
        .byte   $38, $e5, $73, $85, $6e, $a5, $0d, $e9
        .byte   $00, $85, $6f, $b0, $fe, $49, $ff, $85
        .byte   $6f, $a5, $6e, $49, $ff, $69, $01, $85
        .byte   $6e, $a5, $70, $49, $80, $85, $70, $90
        .byte   $fe, $e6, $6f, $a5, $76, $30, $fe, $a5
        .byte   $75, $18, $65, $0f, $85, $bb, $a5, $10
        .byte   $69, $00, $85, $99, $4c, $27, $9e, $a6
        .byte   $9a, $f0, $fe, $a2, $00, $4a, $e8, $c5
        .byte   $9a, $b0, $fa, $86, $9c, $20, $af, $99
        .byte   $a6, $9c, $a5, $9b, $0a, $26, $99, $30
        .byte   $fe, $ca, $d0, $f8, $85, $9b, $60, $a9
        .byte   $32, $85, $9b, $85, $99, $60, $a9, $80
        .byte   $38, $e5, $9b, $9d, $00, $01, $e8, $a9
        .byte   $00, $e5, $99, $9d, $00, $01, $4c, $61
.else   ;///////////////////////////////////////////////////////////////////////
        .res    78
.endif  ;///////////////////////////////////////////////////////////////////////
