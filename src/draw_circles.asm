; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_2977"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

draw_circle_line:                                       ; BBC: BLINE    ;$2977
;===============================================================================
; draws a segment of a circle, connecting the previous
; point around the circumfrence to the new one:
;
; the points in the circle are stored in two lists, `circle_lines_x`
; for X-positions and `circle_lines_y` for Y-positions, with some
; special values to support disjointed lines;
;
; the first byte in `circle_lines_x` has a special meaning:
; $FF indicates an empty buffer and $00 indicates data present
;
; if a circle goes partially off screen, such that entire segments of the
; circle are outside of the viewport, $FF is inserted into the Y-positions
; to indicate a break in line and the next entry will begin a new, visible,
; line (all hidden lines are skipped)
;
; TOOD: why is flag (ZP_CIRCLE_FLAG) needed if ZP_TEMP_COUNTER = 0;
;       would indicate the same? is this because of keeping the heap
;       for later erasing? for drawing two circles? (i.e. "crater")
;
; in:   ZP_TEMP_COUNTER         the current point number (0-64)
;       ZP_CIRCLE_STEP          number of steps around the circle (0-64)
;                               to increment to get to the next point (1+)
;       K6                      the X-position of the new point (16-bits)
;       T.X                     the Y-position of the new point (16-bits)
;       ZP_CIRCLE_FLAG          set to $FF to indicate first point
;       ZP_CIRCLE_RADIUS        circle's radius
;       ZP_CIRCLE_YPOS          circle's centre Y-position (16-bits),
;                               signed, 0 is the top of the viewport
;-------------------------------------------------------------------------------
        txa                     ; point Y-position lo-byte
        adc ZP_CIRCLE_YPOS_LO
        sta ZP_VAR_K6_2         ; BBC: K6+2 (previous Y-pos, lo)

        lda ZP_CIRCLE_YPOS_HI   ; circle's Y-position, hi-byte
        adc T                   ; add point Y-position hi-byte
        sta ZP_VAR_K6_3         ; BBC: K6+3 (previous Y-pos, hi)

        ; break?
        ;-----------------------------------------------------------------------
        ; if this is the first point in the circle, there is no previous
        ; point to connect a line to, so we force a line-break to write
        ; the starting co-ords and wait for the next call to join the line
        ;
        lda ZP_CIRCLE_FLAG      ; get the flag parameter
        beq @clip               ; not the first point?

        inc ZP_CIRCLE_FLAG      ; roll flag over from $ff to 0

        ; check if previous y-position is $FF,
        ; indicating a line break:
        ;
@break: ldy ZP_CIRCLE_INDEX     ; current circle-buffer index           ;$2988
        lda # $ff               ; $FF is a line break
        cmp circle_lines_y-1, y ; check the circle-buffer Y-coords
        beq @next
        sta circle_lines_y, y   ; update circle-buffer Y-coords
        inc ZP_CIRCLE_INDEX     ; move to the next index in the circle buffer
        bne @next               ; (always branches)

        ; configure line:
        ;-----------------------------------------------------------------------
        ; set the start and end points for drawing the line:
        ;
@clip:  lda ZP_VAR_K5           ; previous point, X-position, lo-byte   ;$2998
        sta ZP_LINE_XX1_LO
        lda ZP_VAR_K5_1         ; previous point, X-position, hi-byte
        sta ZP_LINE_XX1_HI
        lda ZP_VAR_K5_2         ; previous point, Y-position, lo-byte
        sta ZP_LINE_YY1_LO
        lda ZP_VAR_K5_3         ; previous point, Y-position, hi-byte
        sta ZP_LINE_YY1_HI

        lda ZP_VAR_K6           ; new point, X-position, lo-byte
        sta ZP_LINE_XX2_LO
        lda ZP_VAR_K6_1         ; new point, X-position, hi-byte
        sta ZP_LINE_XX2_HI
        lda ZP_VAR_K6_2         ; new point, Y-position, lo-byte
        sta ZP_LINE_YY2_LO
        lda ZP_VAR_K6_3         ; new point, Y-position, hi-byte
        sta ZP_LINE_YY2_HI

        jsr clip_line           ; clip the line to the viewport
        bcs @break              ; is offscreen? add a line break to the buffer

        ; if the line ends were flipped by the clipping routine, then we must
        ; flip them back to avoid storing them in the circle buffer the wrong
        ; way around
        ;
        ; TODO: can we avoid this? we should validate line direction
        ;       everywhere before clipping / drawing lines, since sometimes
        ;       lines are constructed in a way guaranteed the right direction
        ;
        lda LINE_SWAP           ; were the line co-ords swapped?
        beq :+                  ; no, skip ahead

        ; flip the ends back:
        ; (note that these are 8-bit line-coords now)
        ;
        lda ZP_LINE_X1
        ldy ZP_LINE_X2
        sta ZP_LINE_X2
        sty ZP_LINE_X1
        lda ZP_LINE_Y1
        ldy ZP_LINE_Y2
        sta ZP_LINE_Y2
        sty ZP_LINE_Y1

:       ldy ZP_CIRCLE_INDEX     ; current circle-buffer index           ;$29D2
        lda circle_lines_y-1, y ; check current Y-coord
        cmp # $ff               ; is it the terminator?
        bne @draw               ; no

        ; add X1/Y1 to line-buffer:
        ; (Y is the current buffer index)
        lda ZP_LINE_X1
        sta circle_lines_x, y   ; line-buffer X-coords
        lda ZP_LINE_Y1
        sta circle_lines_y, y   ; line-buffer Y-coords
        iny                     ; move to the next point in the buffer

        ; add X2/Y2 to the line-buffer:
        ; (Y is the current buffer index)
@draw:  lda ZP_LINE_X2                                                  ;$2936
        sta circle_lines_x, y   ; line-buffer X-coords
        lda ZP_LINE_Y2
        sta circle_lines_y, y   ; line-buffer Y-coords
        iny                     ; move to the next point in the buffer
        sty ZP_CIRCLE_INDEX     ; update circle-buffer index

        jsr draw_line           ; draw the current line in X1/Y1/X2/Y2

        lda ZP_VAR_XX13
        bne @break

        ; prepare for next point:
        ;-----------------------------------------------------------------------
@next:  lda ZP_VAR_K6                                                   ;$29FA
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
;===============================================================================
; RAM used for X-coords for circle line-drawing
;
.ifdef  BUILD_ORIGINAL
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
;===============================================================================
; RAM used for Y-coords for circle line-drawing
;
.ifdef  BUILD_ORIGINAL
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


.segment        "CODE_7D57"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_PL2:                                                   ; BBC: PL2      ;$7D57
;===============================================================================
        lda ZP_SHIP_TYPE
        lsr 
        bcs :+
        jmp _WPLS2
:       jmp wipe_sun                                                    ;$7D5F


_PLANET:                                                ; BBC: PLANET   ;$7D62
;===============================================================================
        lda ZP_SHIP_ZPOS_SIGN
        cmp # $30
        bcs _PL2
        ora ZP_SHIP_ZPOS_HI
        beq _PL2
        jsr project_ship
        bcs _PL2
        lda #> ELITE_MENUSCR_ADDR
        sta ZP_VAR_P2
        lda #< ELITE_MENUSCR_ADDR
        sta ZP_VAR_P1
        jsr _3bc1
        lda ZP_VALUE_pt2
        beq :+
        lda # $f8
        sta ZP_VALUE_pt1
:       lda ZP_SHIP_TYPE                                                ;$7D84
        lsr 
        bcc _PL9 

        jmp draw_sun


_PL9:                                                   ; BBC: PL9      ;$7D8C
;===============================================================================
        jsr _WPLS2
        jsr draw_planet_outline
        bcs _PL20
        lda ZP_VALUE_pt2
        beq _PL25
_PL20:                                                  ; BBC: PL20     ;$7D98
        rts 

_PL25:                                                  ; BBC: PL25     ;$7D99
        lda _1d0f
        beq _PL20
        lda ZP_SHIP_TYPE
        cmp # $80
        bne _PL26

        lda ZP_VALUE_pt1
        cmp # $06
        bcc _PL20

        lda ZP_SHIP_M0x2_HI
        eor # %10000000
        sta ZP_VAR_P1

        lda ZP_SHIP_M1x2_HI
        jsr _PLS4

        ldx # $09
        jsr _PLS1
        sta ZP_B2
        sty $45
        jsr _PLS1
        sta ZP_B3
        sty ZP_ROTATE_M2x0_HI
        ldx # $0f
        jsr _PLS5
        jsr _PLS2
        lda ZP_SHIP_M0x2_HI
        eor # %10000000
        sta ZP_VAR_P1
        lda ZP_SHIP_M2x2_HI
        jsr _PLS4
        ldx # $15
        jsr _PLS5
        jmp _PLS2


_PL26:                                                  ; BBC: PL26     ;$7DE0
;===============================================================================
        lda ZP_SHIP_M1x2_HI
        bmi _PL20

        ldx # $0f
        jsr _PLS3
        clc 
        adc ZP_SHIP01_XPOS_pt1
        sta ZP_SHIP01_XPOS_pt1
        tya 
        adc ZP_SHIP01_XPOS_pt2
        sta ZP_SHIP01_XPOS_pt2
        jsr _PLS3
        sta ZP_VAR_P1

        lda ZP_CIRCLE_YPOS_LO
        sec 
        sbc ZP_VAR_P1
        sta ZP_CIRCLE_YPOS_LO

        sty ZP_VAR_P1

        lda ZP_CIRCLE_YPOS_HI
        sbc ZP_VAR_P1
        sta ZP_CIRCLE_YPOS_HI

        ldx # $09
        jsr _PLS1
        lsr 
        sta ZP_B2
        sty $45
        jsr _PLS1
        lsr 
        sta ZP_B3
        sty ZP_ROTATE_M2x0_HI
        ldx # $15
        jsr _PLS1
        lsr 
        sta ZP_B4
        sty ZP_ROTATE_M2x1_LO
        jsr _PLS1
        lsr 
        sta ZP_B5
        sty ZP_ROTATE_M2x1_HI
        lda # $40
        sta ZP_A8
        lda # $00
        sta ZP_AB
        jmp _PLS22


_PLS1:                                                  ; BBC: PLS1     ;$7E36
;===============================================================================
        lda ZP_SHIP_XPOS_LO, x
        sta ZP_VAR_P1
        lda ZP_SHIP_XPOS_HI, x
        and # %01111111
        sta ZP_VAR_P2
        lda ZP_SHIP_XPOS_HI, x
        and # %10000000
        jsr _3bc1
        lda ZP_VALUE_pt1
        ldy ZP_VALUE_pt2
        beq _7e4f
        lda # $fe
_7e4f:                                                                  ;$7E4F
        ldy ZP_VALUE_pt4
        inx 
        inx 
        rts 


_PLS2:                                                  ; BBC: PLS2     ;$7E54
;===============================================================================
        lda # $1f
        sta ZP_A8

        ; fallthrough
        ; ...

_PLS22:                                                 ; BBC: PLS22    ;$7E58
;===============================================================================
        ldx # $00
        stx ZP_TEMP_COUNTER
        dex 
        stx ZP_CIRCLE_FLAG
_7e5f:                                                  ; BBC: PLL4     ;$7E5F
        lda ZP_AB
        and # %00011111
        tax 
        lda table_sin, x        
        sta Q                   ; Q = abs(sin(AB))*256
        lda ZP_B4
        jsr _39ea               ; A=(A*Q)/256
        sta R                   ; R = B4 * abs(sin(AB))
        lda ZP_B5
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VALUE_pt1        ; VALUE_pt1 = B5 * abs(sin(AB))
        ldx ZP_AB
        cpx # $21               ; AB > pi : invert matrix sign
        lda # $00               ;   (because sin turns negative at $21)
        ror 
        sta ZP_ROTATE_M2x2_HI   ; store the sign
        lda ZP_AB
        clc 
        adc # $10               ; offset in sine-table: sin(x+pi/2) = cos(x)
        and # %00011111
        tax 
        lda table_sin, x
        sta Q                   ; Q = abs(cos(AB))*256
        lda ZP_B3
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VALUE_pt3        ; VALUE_pt3 = B3 * abs(cos(AB))
        lda ZP_B2
        jsr _39ea               ; A=(A*Q)/256
        sta ZP_VAR_P1           ; P1 = B2 * abs(cos(AB))
        lda ZP_AB
        adc # $0f
        and # %00111111
        cmp # $21
        lda # $00
        ror 
        sta ZP_ROTATE_M2x2_LO
        lda ZP_ROTATE_M2x2_HI
        eor ZP_ROTATE_M2x1_LO
        sta S
        lda ZP_ROTATE_M2x2_LO
        eor $45
        jsr multiplied_now_add
        sta T
        bpl _7ec8
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda T
        eor # %01111111
        adc # $00
        sta T
_7ec8:                                                                  ;$7EC8
        txa 
        adc ZP_SHIP01_XPOS_pt1
        sta ZP_VAR_K6
        lda T
        adc ZP_SHIP01_XPOS_pt2
        sta ZP_VAR_K6_1
        lda ZP_VALUE_pt1
        sta R
        lda ZP_ROTATE_M2x2_HI
        eor ZP_ROTATE_M2x1_HI
        sta S
        lda ZP_VALUE_pt3
        sta ZP_VAR_P1
        lda ZP_ROTATE_M2x2_LO
        eor ZP_ROTATE_M2x0_HI
        jsr multiplied_now_add
        eor # %10000000
        sta T
        bpl _7efd
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda T
        eor # %01111111
        adc # $00
        sta T
_7efd:                                                                  ;$7EFD
        jsr draw_circle_line
        cmp ZP_A8
        beq _7f06
        bcs _7f12
_7f06:                                                                  ;$7F06
        lda ZP_AB
        clc 
        adc ZP_CIRCLE_STEP
        and # %00111111
        sta ZP_AB
        jmp _7e5f

_7f12:                                                                  ;$7F12
        rts 


_7f13:  jmp wipe_sun                                                    ;$7F13

_7f16:                                                  ; BBC: PLF3     ;$7F16
;===============================================================================
; invert X value:
;-------------------------------------------------------------------------------
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 

_PLF17: lda # $ff                                       ; BBC: PLF17    ;$7F1D
        jmp _PLF5


draw_sun:                                               ; BBC: SUN      ;$7F22
;===============================================================================
; calculate the scan-lines of a sun and draw it:
;
; because the sun has to be drawn solid, Elite breaks the sun down into
; scanlines, computing each slice of the circle as a distance from the
; horizontal midpoint. this distance is then mirrored right-to-left, and
; the whole line mirrored from the bottom half of the circle to the top half
;
; TODO: check this is the case, not there yet in the disassembly commenting
;
; this approach achieves more than just minimising the number of calculations
; needed; a clever algorithm is used to approximate the curve without using
; sine / cosine or pi. I'm certain this routine would have been written by
; Ian Bell; it's wicked-smart but coded in a text-book fashion, unlike
; Braben's more pragmatic, hacker approach to code
;
; the sun, being solid, is too large to draw and erase each frame so instead
; one scanline is erased and redrawn at a time. this means that the sun-
; buffer (used to store circle-width per scanline) is used to erase the
; previous frame, before being updated with new values
;
; in:   ZP_CIRCLE_XPOS          sun X-position (16-bits)
;       ZP_CIRCLE_YPOS          sun Y-position (16-bits)
;       ZP_CIRCLE_RADIUS        radius
;-------------------------------------------------------------------------------
        ; TODO: enable the sun buffer?
        ; (value is $FF when buffer is clear)
        lda # $01
        sta SUN_BUFFER

        ; check the sun is visible in the viewport:
        ;-----------------------------------------------------------------------
        ; carry will be clear if the sun is out of sight; for drawing the stars
        ; on the short-range chart this will always be the case, but if the sun
        ; in the cockpit-view goes out of sight it will be erased
        ;
        ; note that this routine sets some
        ; variables required for drawing:
        ;
        ;       P3.P2           bottom-edge (Y-position + radius)
        ;                       of the sun (signed, 16-bits)
        ;
        jsr check_circle        ; is the sun visible?
        bcs _7f13               ; if the sun is out of sight, erase it

        ; calculate extent of fringes:
        ; (i.e. firery edge of the sun)
        ;-----------------------------------------------------------------------
        ; the sun's radius is checked against three different scales
        ; and for each, a true/false bit is shifted into the bottom of
        ; register A. this should give the results:
        ;
        ;       r >= 96         %111
        ;       r >= 40         %011
        ;       r >= 16         %001
        ;       r < 16          %000
        ;
        lda # %00000000
        ldx ZP_CIRCLE_RADIUS
        cpx # 96                ; sun radius >= 192?
        rol                     ; (shift the carry bit in)
        cpx # 40                ; sun radius >= 80?
        rol                     ; (shift the carry bit in)
        cpx # 16                ; sun radius >= 32?
        rol                     ; (shift the carry bit in)
        sta ZP_TEMP_COUNTER     ; "fringe size"

        ; clip bottom of sun to viewport:
        ;-----------------------------------------------------------------------
        ; we have determined that the sun is visible, even partially,
        ; within the viewport, but it may be overlapping the edges
        ;
        lda ZP_VIEWH            ; viewport height (-1)
                                ; (143 for cockpit, 199 for menu pages)

        ; the sun's bottom-edge value is 16-bit, so anything > 256
        ; automatically implies the sun extends below the viewport.
        ; since A is currently the viewport height, a branch here
        ; clips the sun's bottom-edge to the viewport's
        ;
        ldx ZP_VAR_P3           ; bottom of sun, hi byte
       .bnz :+                  ; any bit there indicates >256 value

        ; the sun's bottom edge is somewhere 0-256;
        ; now compare against the viewport height:
        ;
        cmp ZP_VAR_P2           ; sun's bottom edge, lo-byte
       .blt :+                  ; if over, clip to the viewport

        ; sun's bottom-edge is within the viewport
        ; -- it must be a non-zero value however
        ;
        lda ZP_VAR_P2           ; sun's bottom-edge, lo-byte
       .bnz :+                  ; non-zero is okay, skip over

        lda # $01               ; set to 1 (TODO: why?)
:       sta ZP_A8               ; sun's bottom-edge (clipped)           ;$7F4B

        ; determine portion of sun to draw(?)
        ;-----------------------------------------------------------------------
        ; since we draw the sun as a series of horizontal scanlines, we need
        ; to determine the visible portion of the sun in terms of a first and
        ; last scanline because we may have a complex situation such as a sun
        ; whose centre-point is *above* the viewport, but the radius is so
        ; large that the bottom-edge of the sun is *below* the viewport,
        ; meaning that only a sub-portion of the radius (both top and
        ; bottom) is visible!
        ; 
        ; the first task is check where the sun's
        ; centre point is in relation to the viewport
        ;
        lda ZP_VIEWH            ; height of the viewport (-1)
        sec                     ; (e.g. 143 for cockpit, 199 for menu pages)
        sbc ZP_CIRCLE_YPOS_LO   ; subtract sun Y-position, lo-byte
        tax                     ; put aside the calculated lo-byte

        ; validate the hi-byte:
        ;
        ; if the sun's Y position is off-screen, the hi-byte will be
        ; a non-zero value. we want to work out if the sun's centre
        ; is ABOVE, WITHIN, or BELOW the screen
        ;
        ; subtracting the hi-byte from zero will give us:
        ;
        ; 0     the sun's centre is within the screen Y=0...255,
        ;       as the hi-bytes are both zero
        ;
        ; 128+  the sun's hi-byte is positive (0-127),
        ;       ergo, the sun's centre is below the screen.
        ;       in this instance we invert the result to get
        ;       back to an absolute positive value
        ;
        ; >0    the sun's hi-byte is negative (bit 7 set),
        ;       ergo, the sun's centre is above the screen
        ;
        lda # $00               ; subtract from zero:
        sbc ZP_CIRCLE_YPOS_HI   ; sun Y-position, hi-byte
        bmi _7f16               ; if result negative, invert the value
       .bnz :+                  ; if result positive, skip ahead

        ; result hi-byte is zero; if the result lo-byte is zero, the
        ; sun's centre is directly on the viewport's bottom edge!
        ; ergo, there is no bottom-half to the sun!
        ;
        inx                     ; (a rather clumsy way to check
        dex                     ;  if X is currently zero)
        beq _PLF17              ; if zero, draw top-half only(?)

        ; although we've determined that the sun's Y-centre point is within
        ; the viewport, we still need to know how much of the sun's radius is
        ; within that viewport, as this will be the actual number of scan-
        ; lines we need to draw for the bottom half of the sun
        ;
        ; where the X-register is currently the number of scanlines between
        ; the sun's Y-centre and the bottom of the viewport, check if the
        ; sun's radius fits within that space:
        ;
        cpx ZP_CIRCLE_RADIUS    ; when the radius doesn't fit,
       .blt _PLF5               ; clip it using the value we calculated (X)

        ; the sun's south radius fits within the viewport:
        ; that's how many scanlines to draw for the bottom half of the sun
        ;
:       ldx ZP_CIRCLE_RADIUS                                            ;$7F63
        lda # $00

_PLF5:                                                  ; BBC: PLF5     ;$7F67
        ;-----------------------------------------------------------------------
        ; X = number of scanlines to draw for the bottom-half of the sun?
        stx ZP_TEMP_ADDR2_LO
        sta ZP_TEMP_ADDR2_HI    ; can be $FF?

        ; the specifics of the algorithm used to generate the sun are
        ; explained in the section below, but for now just know that we
        ; need to square (multiply by itself) the radius and put it aside
        ;
        lda ZP_CIRCLE_RADIUS
        jsr math_square         ; square the radius
        sta ZP_B3               ; squared 16-bit radius hi
        lda ZP_VAR_P            ; (P = result, lo-byte)
        sta ZP_B2               ; squared 16-bit radius lo

        ; IMPORTANT: because we erase and redraw each scanline of the sun,
        ; and the sun from the previous frame is likely to be in a different
        ; position, we must walk all scanlines of the viewport to ensure that
        ; every line of the previous frame is erased, not just the ones that
        ; lie within the new sun. for speed/simplicity of code, the walk
        ; is done from the bottom of the viewport, upwards
        ;
        ldy ZP_VIEWH            ; height of viewport

        ; copy sun centre-point to YY-LO/HI for the
        ; line-clipping and drawing routines used later
        ; TODO: where does short-range chart set SUNX??
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI

@_7f80:                                                                 ;$7F80
        ;-----------------------------------------------------------------------
        ; is the last scanline of the sun on the viewport border(?)
        ; this will never be the case with the short-range chart, so it skips
        ; TODO: where does this come into play?
        ;
        cpy ZP_A8
        beq @calc               ; if yes, move ahead with next step

        lda SUN_BUFFER, y
       .bze :+                  ; if half-width is 0, no line
        jsr _28f3               ; calculate the line-width/pos & draw
:       dey                     ; next scanline                         ;$7F8C
       .bnz @_7f80              ; continue scanning. reaching zero
                                ; (top of screen) also exits

@calc:  ; slice & draw sun:                                             ;$7F8F
        ;=======================================================================
        ; this is the main loop that walks along the scanlines of the sun,
        ; calculating the width of each to form the curvature of the sun,
        ; i.e, as we approach the bottom of the sun, the width becomes less
        ;
        ; this curvature is produced via a form of Pythagoras' theorem (the
        ; thing about right-angled triangles and their sides) which does not
        ; require the use of sine / cosine tables or pi, making it relatively
        ; easy to implement on an 8-bit micro
        ;
        ; the equation used is:
        ; 
        ;       q = SQR( r^2 - n^2 )
        ;
        ; where r is the sun's radius, and n is the position within the
        ; radius to 'slice' the circle. the result, q, is the distance from
        ; the horizontal mid-point of the sun to the edge (for the given
        ; scanline, n) -- the result is doubled to mirror horizontally
        ;
        ; why exactly this is able to produce a curve is beyond me,
        ; but it is easier to digest visualised as a graph:
        ;
        ; https://www.wolframalpha.com/input/?i=sqrt%28x%5E2+-+y%5E2%29
        ; 
        ; (with thanks to Roel Nieskens, @PixelAmbacht
        ;  on Twitter, for pointing this out to me)
        ;
        ; "r^2" has already been calculated previously and
        ; is stored in ZP_VAR_B2+B3 ("B3.B2" -- hi, lo)
        ;
        ; begin by squaring the current sun scanline:
        ;
        lda ZP_TEMP_ADDR2_LO    ; current scanline "n"
        jsr math_square         ; square, the hi-byte will be in P
        sta T                   ; (P.T = n^2)

        ; calculate the difference between the squares of
        ; the sun's radius and the current scanline:
        ; (i.e. "r^2 - n^2")
        ;
        lda ZP_B2               ; r^2, lo byte
        sec                     ; subtract:
        sbc ZP_VAR_P            ; n^2, lo-byte
        sta Q                   ; result, lo-byte

        lda ZP_B3               ; r^2, hi-byte
        sbc T                   ; subtract n^2, hi byte
        sta R                   ; result, hi-byte

        ; do the square root:
        ; i.e. "SQR( r^2 - n^2 )"
        ;
        sty ZP_VAR_XX15_1       ; backup Y; the square-root routine clobbers it
        jsr square_root         ; calculate the square-root, result in Q
        ldy ZP_VAR_XX15_1       ; restore Y-register

        ; add the "fringe"
        ;-----------------------------------------------------------------------
        ; TODO: we should be able to pluck a faster random number from somewhere
        jsr get_random_number   ; randomise the fringe each frame
        and ZP_TEMP_COUNTER     ; limit to the fringe-size chosen earlier
        clc                     ; add the fringe to...
        adc Q                   ; ...the scanline's half-width
        bcc :+                  ; if adding the fringe takes it over 256,
        lda # $ff               ; clip it to 256

        ;-----------------------------------------------------------------------
        ; check the sun buffer for a scanline from the previous frame:
        ;
:       ldx SUN_BUFFER, y       ; read old value from sun buffer        ;$7FB6
        sta SUN_BUFFER, y       ; replace with the just-calculated value
       .bze @clip               ; if there was no scanline (=0) from the
                                ; previous frame, skip to drawing the new one

        ; erase the previous frame's scanline:
        ;-----------------------------------------------------------------------
        ; set up the line-drawing routine with the sun's
        ; centre-point in the previous frame 
        ;
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI
        txa                     ; previous scanline width
        jsr clip_sun_line       ; clip the old line against the viewport

        ; put aside the result (X1, X2)
        lda ZP_VAR_XX15_0
        sta ZP_VAR_XX_LO
        lda ZP_VAR_XX15_2
        sta ZP_VAR_XX_HI

        ; now clip the new line
        lda ZP_CIRCLE_XPOS_LO
        sta ZP_VAR_YY_LO
        lda ZP_CIRCLE_XPOS_HI
        sta ZP_VAR_YY_HI
        lda SUN_BUFFER, y
        jsr clip_sun_line
        bcs :+
        
        lda ZP_VAR_XX15_2
        ldx ZP_VAR_XX_LO
        stx ZP_VAR_XX15_2
        sta ZP_VAR_XX_LO
        jsr draw_straight_line

:       lda ZP_VAR_XX_LO                                                ;$7FED
        sta ZP_VAR_XX15_0
        lda ZP_VAR_XX_HI
        sta ZP_VAR_XX15_2

        ;-----------------------------------------------------------------------
@draw:  jsr draw_straight_line                                          ;$7FF5

@next:  dey                                                             ;$7FF8
        beq @done               ; exit once we hit the top of the viewport

        lda ZP_TEMP_ADDR2_HI
        bne @_801c
        dec ZP_TEMP_ADDR2_LO
        bne @calc
        dec ZP_TEMP_ADDR2_HI

@_calc: jmp @calc                                                       ;$8005

        ; clip sun scanline to viewport:
        ;-----------------------------------------------------------------------
        ; working from the horizontal centre-point of the sun (16-bits),
        ; and given the width of the sun's scanline, calculate the actual
        ; bounds of the line to be drawn in the viewport (0-255); e.g. the
        ; sun might be outside the viewport, but a portion of its radius
        ; within the viewport, this needs to be reduced to just the line of
        ; pixels to actually be drawn between 0 & 255 in the viewport
        ;
        ; note that at this point the A-register contains
        ; the half-width (radius) of the sun's scanline
        ;
@clip:  ldx ZP_CIRCLE_XPOS_LO   ; get sun Y-position, lo                ;$8008
        stx ZP_VAR_YY_LO        ; set line mid-point, lo
        ldx ZP_CIRCLE_XPOS_HI   ; get sun Y-position, hi
        stx ZP_VAR_YY_HI        ; set line mid-point, hi
        jsr clip_sun_line       ; do the line clipping
        bcc @draw               ; if line is visible, go draw it

        ; NOTE: `clip_sun_line` already removes the line
        ;       from the sun-buffer, so this is redundant
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # $00               ; clear the line from the sun-buffer,
        sta SUN_BUFFER, y       ;  and move to the next
        beq @next               ; (always branches)
.else   ;///////////////////////////////////////////////////////////////////////
        bcs @next               ; (always branches)
.endif  ;///////////////////////////////////////////////////////////////////////

@_801c:                                                                 ;$801C
        ;-----------------------------------------------------------------------
        ldx ZP_TEMP_ADDR2_LO
        inx 
        stx ZP_TEMP_ADDR2_LO
        cpx ZP_CIRCLE_RADIUS
        bcc @_calc
        beq @_calc

        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI
@_802f:                                                                 ;$802F
        lda SUN_BUFFER, y
        beq @_8037
        jsr _28f3               ;...draw_straight_line
@_8037:                                                                 ;$8037
        dey 
        bne @_802f

        ; copy sun X-position into SUNX
        ; (TODO: for overdrawing?)
@done:  clc                                                             ;$803A 
        lda ZP_CIRCLE_XPOS_LO
        sta ZP_SUNX_LO
        lda ZP_CIRCLE_XPOS_HI
        sta ZP_SUNX_HI

:       rts                                                             ;$8043


draw_planet_outline:                                    ; BBC: CIRCLE   ;$8044
;===============================================================================
; draw a planet's circle:
;
; this routine prepares the circle parameters for drawing a planet,
; before falling through to the routine that actually draws circles 
;
; in:   ZP_CIRCLE_XPOS          X-position (signed, 16-bit), 0 is viewport top
;       ZP_CIRCLE_YPOS          Y-position (signed, 16-bit), 0 is viewport left
;       ZP_CIRCLE_RADIUS        radius (16-bit)
;-------------------------------------------------------------------------------
        jsr check_circle        ; check the circle bounds for visibility
        bcs :-                  ; circle not visible? exit (RTS above us)

        lda # $00
        sta circle_lines_x

        ; change the number of lines used to draw the circle depending upon
        ; visible size:
        ;
        ldx ZP_CIRCLE_RADIUS    ; circle radius
        lda # 8                 ; set circle-step to 8
        cpx # 8                 ; circle radius < 8px?
        bcc :+                  ; for radius < 8px, use circle-step of 8
        lsr                     ; set circle-step to 4 (divide A by 2)
        cpx # 60                ; circle radius < 60px?
        bcc :+                  ; for radius < 60px, use circle-step of 4
        lsr                     ; set circle-step to 2 (divide A by 2)

        ; fallthrough implies radius >= 60px,
        ; use a circle-step of 2

:       sta ZP_CIRCLE_STEP                                              ;$805C

        ; fallthrough
        ; ...

draw_circle:                                            ; BBC: CIRCLE2  ;$805E
;===============================================================================
; draw a circle:
;
; circles are drawn as a series of progressive lines starting at 6'clock
; (the bottom) and going anti-clockwise (rightwards) around the circumfrence
;
; all circles drawn this way have up to 64 points but points can be skipped
; along the way (with `ZP_CIRCLE_STEP`), reducing the circle's 'resolution'
;
; because all circles have 64 points, the different quarters / halves of the
; circle always fall within certain point numbers, and because these quadrants
; are mirrors of each other (either by horizontal or vertical reflection,
; or both) the math can be done for one axis and flipped according to need
;
;        0-16   bottom-right quarter    +x, +y
;       16-32   top-right quarter       +x, -y
;       32-48   top-left quarter        -x, -y
;       48-64   bottom-left quarter     -x, +y
;
; thanks goes to Mark Moxon's BBC disassembly and
; deep-dive that describes the circle drawing process:
; <https://www.bbcelite.com/deep_dives/drawing_circles.html>
;
; TODO: Instead of drawing all (up to) 64 points, I wonder if it would be
;       faster to draw one quarter (0-15) and automatically mirror the line
;       to the other quarters?
;
; in:   ZP_CIRCLE_XPOS          16-bit X-position of the circle's centre;
;                               note that 0 is the left-most edge of the
;                               viewport, not the centre of the screen!
;
;       ZP_CIRCLE_STEP          the "resolution" of the circle is set by the
;                               step rate; values above 1 skip points along
;                               the circumfrence, e.g. a step rate of 2 would
;                               connect points 0, 2, 4 etc.
;-------------------------------------------------------------------------------
        ldx # $ff               ; set flag to reset ball-line heap
        stx ZP_CIRCLE_FLAG
        inx                     ; reset counter for ball-lines,
        stx ZP_TEMP_COUNTER     ; draw the circle from the bottom

        ; calculate x-position of point:
        ;-----------------------------------------------------------------------
.loop:  lda ZP_TEMP_COUNTER     ; current point in the circle           ;$8065
        jsr multiply_by_sin     ; calculate: A = radius * sin(counter)

        ldx # $00               ; T will be our hi-byte
        stx T                   ;  so set that to zero

        ldx ZP_TEMP_COUNTER     ; left or right half of circle?
        cpx # 33                ; points 0-32 = right half
        bcc :+                  ; skip ahead for right-side

        ; swap sides:
        ;
        ; negate the number by two's compliment: flip bits and add one.
        ; due to the `bcc` branch above, carry is guaranteed to be set
        ; so `adc # $00` will add 1 (the carry)
        ;
        eor # %11111111         ; flip all bits
        adc # $00               ; add 1 (the carry!)
        tax                     ; put result (lo-byte) aside

        lda # $ff               ; flip the high byte in T ($00)
        adc # $00               ; ripple the carry!
        sta T                   ; update the result hi-byte
        txa                     ; retrieve our lo-byte again
        clc                     ;  before continuing

        ; centre the circle by adding the X-position to the value
        ; we just calculated and storing the result in K6
        ;
:       adc ZP_CIRCLE_XPOS_LO   ; add the X-position lo-byte            ;$8081
        sta ZP_VAR_K6           ;  to the current lo-byte in A
        lda ZP_CIRCLE_XPOS_HI   ; now do the hi-bytes
        adc T
        sta ZP_VAR_K6_1

        ; calculate Y-position of point:
        ;-----------------------------------------------------------------------
        ; the sine table contains 32 entries, and if you imagine the upward
        ; curve of the sine wave occupying the first half and the downward
        ; curve occupying the second half, then adding 16 to the current
        ; index would reverse the direction of the curve -- a cosine
        ; (note: `multiply_by_sin` automatically wraps the input)
        ;
        lda ZP_TEMP_COUNTER     ; take our current point index and
        clc                     ;  add 16 to it to offset
        adc # 16                ;  the sine into its cosine
        jsr multiply_by_sin     ;  i.e. A = radius * cosine(counter)
        tax                     ; put aside the result lo-byte

        lda # $00               ; as before, set the result
        sta T                   ;  hi-byte to zero

        ; top half or bottom half?
        ;
        ; if we add one-quarter to the current position and ask if we are left
        ; or right, we are efectively checking for top or bottom as adding one
        ; quarter rotates the problem 90deg
        ;
        lda ZP_TEMP_COUNTER     ; take our current point index
        adc # 15                ;  add 15
        and # %00111111         ;  wrap at 64 (0...63)
        cmp # 33                ; points 0-32 = "bottom" half
        bcc :+                  ; skip ahead for "bottom" half

        ; swap sides:
        ;
        ; negate the number by two's compliment: flip bits and add one.
        ; due to the `bcc` branch above, carry is guaranteed to be set
        ; so `adc # $00` will add 1 (the carry)
        ;
        txa                     ; retrieve delta lo-byte
        eor # %11111111         ; flip all bits
        adc # $00               ; add 1 (the carry!)
        tax                     ; put result (lo-byte) aside

        lda # $ff               ; flip the high byte in T ($00)
        adc # $00               ; ripple the carry!
        sta T                   ; update the result hi-byte
        clc                     ;  before continuing

        ; draw the line-segment! this routine will keep track of the previous
        ; points and automatically connect this new point to the previous;
        ; the circle-line heap will also be used to erase the circle
        ;
:       jsr draw_circle_line                                            ;$80AF

        cmp # 65                ; finished? (point 65 reached)
        bcs :+                  ; if yes, leave the loop
        jmp .loop               ; if no, draw the next segment

        ;-----------------------------------------------------------------------
:       clc                                                             ;$80B9
        rts 


_WPLS2:                                                 ; BBC: WPLS2    ;$80BB
;===============================================================================
        ; has a circle been drawn before? check first byte of circle-line
        ; buffer; non-zero means empty, so skip ahead
        ldy circle_lines_x      
        bne rest_circle_line_buffer

_80c0:                                                  ; BBC: WPL1     ;$80C0
        cpy ZP_CIRCLE_INDEX
        bcs rest_circle_line_buffer

        lda circle_lines_y, y
        cmp # $ff
        beq _80e6

        sta ZP_VAR_XX15_3

        lda circle_lines_x, y
        sta ZP_VAR_XX15_2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line
        
        iny 
        lda LINE_SWAP
        bne _80c0
        
        lda ZP_VAR_XX15_2
        sta ZP_VAR_XX15_0
        lda ZP_VAR_XX15_3
        sta ZP_VAR_XX15_1
        jmp _80c0

_80e6:                                                                  ;$80E6
        iny 
        lda circle_lines_x, y
        sta ZP_VAR_XX15_0
        lda circle_lines_y, y
        sta ZP_VAR_XX15_1
        iny 
        jmp _80c0


rest_circle_line_buffer:                                ; BBC: WP1      ;$80F5
;===============================================================================
; reset the circle line buffer:
;-------------------------------------------------------------------------------
        lda # $01
        sta ZP_CIRCLE_INDEX     ; reset index
        lda # $ff               ; write $FF to the first X-pos byte
        sta circle_lines_x      ;  to indicate an empty line buffer

:       rts                                                             ;$80FE


wipe_sun:                                               ; BBC: WPLS     ;$80FF
;===============================================================================
        lda SUN_BUFFER
        bmi :-                  ; $FF = nothing to draw, exit

        ; copy sun's horizontal position to YY-LO/HI,
        ; as this is what the drawing operations use
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI

        ; this is the vertical cut-off point. we'll be erasing
        ; from bottom up for the benefit of 6502's zero-flag
        ldy # VIEWPORT_HEIGHT-1
        ; check if a line needs to be drawn at this Y-position
@loop:  lda SUN_BUFFER, y       ; read half-width of line               ;$810E
       .bze:+                   ; if zero, skip
        jsr _28f3               ; work out X1/X2 from middle+width, and draw
:       dey                                                             ;$8116
       .bnz @loop

        dey                     ; Y = $FF?
        sty SUN_BUFFER

        rts 


clip_sun_line:                                          ; BBC: EDGES    ;$811E
;===============================================================================
; clip a centred, horizontal line so that it fits within the viewport. this
; routine is used when drawing the sun as that is stored as a centre-point
; and a series of half-widths (radii) for each scanline to trace the shape
;
; note that YY is a signed 16-bit number because the sun can be so large as to
; be way off the sides of the screen, but still be partially visible on screen
;
; in:   ZP_VAR_YY       *horizontal* middle-point of line (16-bits)
;       A               half-width
;
; out:  carry           c=0 if line is visible, c=1 if outside viewport bounds
;       ZP_VAR_XX15_0   X-position (viewport) of the left end of the line
;       ZP_VAR_XX15_2   X-position (viewport) of the right end of the line
;       Y               (preserved)
;-------------------------------------------------------------------------------
        sta T                   ; put aside half-width

        ; find right-hand point (X2); i.e. middle (YY) + half-width (T)
        ; and clip if it goes beyond the viewport right edge (256)
        ;
        clc 
        adc ZP_VAR_YY_LO        ; "add centre of line X mid-point"?
        sta ZP_VAR_XX15_2       ; this is the right-hand X-coord
        lda ZP_VAR_YY_HI        ; did it overflow?
        adc # 0                 ; apply the carry

        bmi @clear              ; too large, don't draw!
        beq @left               ; fits, now do left-side

        lda # VIEWPORT_WIDTH-1  ; line clips to right of viewport (256)
        sta ZP_VAR_XX15_2

        ;-----------------------------------------------------------------------
        ; find left-hand point (X1); i.e. middle (YY) - half-width (T)
        ; and clip if it goes byeond the viewport left edge (0)
        ;
@left:  lda ZP_VAR_YY_LO        ; begin with middle-point               ;$8131
        sec 
        sbc T                   ; subtract the half-width
        sta ZP_VAR_XX15_0       ; this is the left-hand X-coord
        lda ZP_VAR_YY_HI
        sbc # 0                 ; apply the carry
       .bnz :+                  ; did it overflow?

        clc                     ; it fits, X1 is fine
        rts                     ; return carry clear = OK

        ;-----------------------------------------------------------------------
:       bpl @clear              ; too large, don't draw?                ;$8140

        ; line clips to the left of the viewport (0)
        lda # $00
        sta ZP_VAR_XX15_0

        clc                     ; return carry clear = OK 
        rts 

        ;-----------------------------------------------------------------------
@clear: lda # $00               ; remove the scanline                   ;$8148
        sta SUN_BUFFER, y       ;  from the sun buffer

        sec                     ; return carry set = error 
        rts 


check_circle:                                           ; BBC: CHKON    ;$814F
;===============================================================================
; check a circle (to be drawn) is visible:
;
; the position of the circle is 16-bits, so as to be able to place a circle
; off-screen, whose radius reaches into the viewport
;
; NOTE: for simplicity in calculations, the signed 16-bit circle X/Y position
;       of 0 matches position 0 in the *viewport*, so the 16-bit range is not
;       exactly centred, and coordinates are relative to the viewport (0-255),
;       not the C64's screen (0-319 px)
;
; in:   ZP_CIRCLE_XPOS          signed 16-bit X-position
;       ZP_CIRCLE_YPOS          signed 16-bit Y-position
;       ZP_VIEWH                viewport height to clip against:
;                               143 = cockpit-view, 199 = menu pages
;
; out:  carry                   returns carry set if the circle is invalid,
;                               otherwise carry is clear
;
;       P3.P2                   last scanline the circle would appear on
;
; TODO: is there a way to optimise this using CMP, to subtract the radius
;       without altering the value?
;-------------------------------------------------------------------------------
        ; the circle will become invisible if the circle's
        ; right-edge goes off the left-edge of the viewport
        ;
        ; when we add the circle's radius to the X-position, the result should
        ; be positive. it'll be negative if the circle's centre position is off
        ; the left-edge of the screen, but the radius does not reach into the
        ; visible portion of the screen
        ;
        lda ZP_CIRCLE_XPOS_LO   ; circle X-position, lo-byte
        clc 
        adc ZP_CIRCLE_RADIUS    ; add the radius (i.e. bottom of circle)
        lda ZP_CIRCLE_XPOS_HI   ; circle X-position, hi-byte
        adc # 0                 ; (ripple the carry)
        bmi _PL21               ; if still negative, circle is not visible!

        ; the circle will become invisible if the left-edge goes off
        ; the right-edge of the screen, indicated by the hi-byte of
        ; the X-position + radius being > 0 (i.e. left-edge is > 255)
        ;
        lda ZP_CIRCLE_XPOS_LO   ; circle X-position, lo-byte
        sec 
        sbc ZP_CIRCLE_RADIUS    ; subtract the radius
        lda ZP_CIRCLE_XPOS_HI   ; circle X-position, hi-byte
        sbc # 0                 ; (ripple the carry)
        bmi :+                  ; the left-edge is allowed to be off-screen
        bne _PL21               ; left-edge is > 255, circle is not visible!

        ; the circle will become invisible if the circle's bottom-edge goes
        ; off the top of the viewport. the 16-bit Y-position of the circle's
        ; bottom- edge is saved to P2/P3 for the circle-drawing routine
        ;
:       lda ZP_CIRCLE_YPOS_LO   ; get circle Y-position, lo-byte        ;$8167
        clc 
        adc ZP_CIRCLE_RADIUS    ; add the radius
        sta ZP_VAR_P2           ; save bottom of circle, lo-byte for drawing
        lda ZP_CIRCLE_YPOS_HI   ; get circle Y-position, hi-byte
        adc # 0                 ; (ripple the carry)
        bmi _PL21               ; if negative, the bottom is above the top!
        sta ZP_VAR_P3           ; save bottom of circle, hi-byte for drawing

        ; the circle will become invisible if the circle's top-edge goes off
        ; the bottom of the viewport. although the height of the viewport is
        ; < 256 -- 144 for cockpit view, 200 for menu pages -- we check first
        ; if the circle's top-edge is < 256 as is this is very easily done
        ; (any value > 1 in the hi-byte)
        ;
        lda ZP_CIRCLE_YPOS_LO   ; get circle Y-position, lo-byte
        sec 
        sbc ZP_CIRCLE_RADIUS    ; subtract the radius
        tax                     ; put this (signed value) aside
        lda ZP_CIRCLE_YPOS_HI   ; get circle Y-position, hi-byte
        sbc # 0                 ; (ripple the carry)
        bmi _PL44               ; the top-egde is allowed to be off-screen
                                ; -- circle is visible (jump to CLC, RTS)
        bne _PL21               ; top-edge is > 255, circle is not visible!
        
        ; lastly, although we have determined the circle's top-edge is within
        ; 0-255, the viewport is shorter than that, so do one final check:
        ;
        cpx ZP_VIEWH            ; return c=1 if circle is outside viewport 
        rts 

        ; circle is invisible (outside bounds)
        ;-----------------------------------------------------------------------
_PL21:  sec                     ; return carry set                      ;$8187
        rts 


_PLS3:                                                  ; BBC: PLS3     ;$8189
;===============================================================================
        jsr _PLS1
        sta ZP_VAR_P1

        lda # $de
        sta Q
        stx U
        jsr multiply_unsigned_PQ
        
        ldx U
        ldy ZP_VALUE_pt4
        bpl :+
        eor # %11111111
        clc 
        adc # $01
        beq :+
        
        ldy # $ff
        rts 

:       ldy # $00                                                       ;$81A7
        rts 


_PLS4:                                                  ; BBC: PLS4     ;$81AA
;===============================================================================
        sta Q
        jsr _3c95
        ldx ZP_SHIP_M0x2_HI
        bmi :+
        eor # %10000000
:       lsr                                                             ;$81B5
        lsr 
        sta ZP_AB
        rts 


_PLS5:                                                  ; BBC: PLS5     ;$81BA
;===============================================================================
        jsr _PLS1
        sta ZP_B4
        sty ZP_ROTATE_M2x1_LO

        jsr _PLS1
        sta ZP_B5
        sty ZP_ROTATE_M2x1_HI

        rts 


_PLS6:                                                  ; BBC: PLS6     ;$81C9
;===============================================================================
        jsr _3bc1

        lda ZP_VALUE_pt4
        and # %01111111
        ora ZP_VALUE_pt3
        bne _PL21

        ldx ZP_VALUE_pt2
        cpx # $04
        bcs _PL6

        lda ZP_VALUE_pt4
        bpl _PL6

        lda ZP_VALUE_pt1        ; radius?
        eor # %11111111
        adc # $01
        sta ZP_VALUE_pt1        ; radius?

        txa 
        eor # %11111111
        adc # $00
        tax 

_PL44:  clc                                                             ;$81EC 
_PL6:   rts                                                             ;$81ED