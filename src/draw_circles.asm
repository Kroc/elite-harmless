; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_2977"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

draw_circle_line:                                       ; BBC: BLINE    ;$2977
;===============================================================================
; draws a segment of a circle, connecting one point
; around the circumfrence to another:
;
; the points in the circle are stored in two lists, `circle_lines_x`
; for x-positions and `circle_lines_y` for y-positions, with some
; special values to support disjointed lines;
;
; the first byte in `circle_lines_x` has a special meaning:
; $FF indicates an empty buffer and $00 indicates data present
;
; if a circle goes partially off screen, such that entire segments
; of the circle are outside of the viewport, $FF is inserted into
; the Y-positions to indicate a break in line and the next entry
; will begin a new, visible, line (all hidden lines are skipped)
;
; in:   ZP_TEMP_COUNTER         the current point number (0-64)
;       K6                      the x-position of the new point (16-bit)
;       T.X                     the y-position of the new point (16-bit)
;       ZP_A9                   set to $FF to indicate first point
;       ZP_CIRCLE_RADIUS        circle's radius
;       ZP_CIRCLE_YPOS          circle's centre Y-position (16-bit)
;                               signed, 0 is the top of the viewport
;
; TOOD: why is flag (ZP_A9) needed if ZP_TEMP_COUNTER = 0 would indicate
;       the same? is this because of keeping the heap for later erasing?
;-------------------------------------------------------------------------------
        txa                     ; point Y-position lo-byte
        adc ZP_CIRCLE_YPOS_LO
        sta ZP_VAR_K6_2         ; BBC: K6+2 (previous Y-pos, lo)

        lda ZP_CIRCLE_YPOS_HI   ; circle's y-position, hi-byte
        adc ZP_VAR_T            ; add point Y-position hi-byte
        sta ZP_VAR_K6_3         ; BBC: K6+3 (previous Y-pos, hi)

        ; break?
        ;-----------------------------------------------------------------------
        ; if this is the first point in the circle, there is no previous
        ; point to connect a line to, so we force a line-break to write
        ; the starting co-ords and wait for the next call to join the line
        ;
        lda ZP_A9               ; get the flag parameter
        beq .clip               ; is this the first point?

        inc ZP_A9               ; roll flag over from $ff to 0

        ; check if previous y-position is $FF,
        ; indicating a line break:
        ;
.break: ldy ZP_CIRCLE_INDEX     ; current circle-buffer index           ;$2988
        lda # $ff               ; $FF is a line break
        cmp circle_lines_y-1, y ; check the circle-buffer Y-coords
        beq ._29fa
        sta circle_lines_y, y   ; update circle-buffer Y-coords
        inc ZP_CIRCLE_INDEX     ; move to the next index in the circle buffer
        bne ._29fa              ; (always branches)

        ; configure line:
        ;-----------------------------------------------------------------------
        ; set the start and end points for drawing the line:
        ;
.clip:  lda ZP_VAR_K5           ; previous point, X-position, lo-byte   ;$2998
        sta ZP_VAR_XX15_0
        lda ZP_VAR_K5_1         ; previous point, X-position, hi-byte
        sta ZP_VAR_XX15_1
        lda ZP_VAR_K5_2         ; previous point, Y-position, lo-byte
        sta ZP_VAR_XX15_2
        lda ZP_VAR_K5_3         ; previous point, Y-position, hi-byte
        sta ZP_VAR_XX15_3

        lda ZP_VAR_K6           ; new point, X-position, lo-byte
        sta ZP_VAR_XX15_4
        lda ZP_VAR_K6_1         ; new point, X-position, hi-byte
        sta ZP_VAR_XX15_5
        lda ZP_VAR_K6_2         ; new point, Y-position, lo-byte
        sta ZP_71
        lda ZP_VAR_K6_3         ; new point, Y-position, hi-byte
        sta ZP_72

        jsr _a013               ; clip the line
        bcs .break              ; offscreen? add a line break to the buffer

        lda LINE_FLIP           ; was the line co-ords flipped?
        beq :+                  ; no, skip ahead

        lda ZP_VAR_XX15_0
        ldy ZP_VAR_XX15_2
        sta ZP_VAR_XX15_2
        sty ZP_VAR_XX15_0
        lda ZP_VAR_XX15_1
        ldy ZP_VAR_XX15_3
        sta ZP_VAR_XX15_3
        sty ZP_VAR_XX15_1

:       ldy ZP_CIRCLE_INDEX     ; current circle-buffer index           ;$29D2
        lda circle_lines_y-1, y ; check current Y-coord
        cmp # $ff               ; is it the terminator?
        bne ._29e6

        ; add X1/Y1 to line-buffer
        ; (Y is the current cursor position)
        lda ZP_VAR_XX15_0
        sta circle_lines_x, y   ; line-buffer X-coords
        lda ZP_VAR_XX15_1
        sta circle_lines_y, y   ; line-buffer Y-coords
        iny                     ; move to the next point in the buffer

        ; add X2/Y2 to the line-buffer?
._29e6: lda ZP_VAR_XX15_2                                               ;$2936
        sta circle_lines_x, y   ; line-buffer X-coords
        lda ZP_VAR_XX15_3
        sta circle_lines_y, y   ; line-buffer Y-coords
        iny                     ; move to the next point in the buffer
        sty ZP_CIRCLE_INDEX     ; update circle-buffer index

        ; draw the current line in X1/Y1/X2/Y2
        jsr draw_line

        lda ZP_A2
        bne .break

        ;-----------------------------------------------------------------------
._29fa: lda ZP_VAR_K6                                                   ;$29FA
        sta ZP_VAR_K5
        lda ZP_VAR_K6_1
        sta ZP_VAR_K5_1
        lda ZP_VAR_K6_2
        sta ZP_VAR_K5_2
        lda ZP_VAR_K6_3
        sta ZP_VAR_K5_3
        lda ZP_TEMP_COUNTER
        clc 
        adc ZP_CIRCLE_STEP
        sta ZP_TEMP_COUNTER

        rts 


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
circle_lines_x:                                         ; BBC: LSX2     ;$26A4
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

circle_lines_y:                                         ; BBC: LSY2     ;$27A4
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
