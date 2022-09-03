; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "draw_fastlines.asm":
;
; a new line-drawing routine by Dyme! formatted and lightly
; modified by Kroc. requires illegal opcodes
;
.linecont+
.ifndef USE_ILLEGAL_OPS
        .fatal .concat( \
                "please enable the extended 6510 instruction set for the ", \
                "fastlines option (option: --cpu 6502X)" \
        )
.endif

.segment        "CODE_LINE"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ZP_LINE_HEIGHT          := ZP_REG_H
ZP_LINE_WIDTH           := ZP_REG_W
ZP_LINE_RESTORE_Y       := ZP_9E
ZP_LINE_BLOCKS          := ZP_REG_W     ; repurpose line width

;=== HLINE
ZP_HLINE_SLOPE          := ZP_REG_H
ZP_HLINE_COUNTER        := ZP_BF
ZP_HLINE_ENDMASK        := ZP_BE        ; used for vert_line, I guess it's safe

;=== SLINE
ZP_SLINE_XOFF1          := ZP_BE
ZP_SLINE_XOFF2          := ZP_BF

;=== VLINE
ZP_VLINE_BIT            := ZP_BE
ZP_VLINE_YEND           := ZP_REG_H
ZP_VLINE_YSTART         := ZP_BF

_ab47:
        .byte   %11000000
        .byte   %11000000
_ab49:
        .byte   %00110000
        .byte   %00110000
        .byte   %00001100
        .byte   %00001100
        .byte   %00000011
        .byte   %00000011
        .byte   %11000000
        .byte   %11000000

draw_line:
;===============================================================================
;
; in:   ZP_VAR_X1       horizontal "beginning" of line in viewport, in pixels
;       ZP_VAR_X2       horizontal "end" of line in viewport, in pixels
;       ZP_VAR_Y1       vertical "beginning" of line in viewport, in pixels
;       ZP_VAR_Y2       vertical "end" of line in viewport, in pixels
;       Y               (preserved)
;
;       note that the "beginning" and "end" of the line is not necessarily
;       left-to-right, top-to-bottom; the routine flips these as necessary
;
;       also, the X/Y values are viewport-coordinates (0..255),
;       not screen-coordinates (0..320); the routine does the
;       centring of the viewport automatically
;
; lines are drawn using a form of Bresenham's Line Algorithm;
; <https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm>
;
; Bresenham's algorithm works on the principal that a solid line will only ever
; step 1 pixel at a time in one of the directions but potentially multiple
; pixels in the other. therefore, there are two distinct types of lines --
; "horizontal" lines are wider than they are tall, thus step multiple pixels
; across X, but only one at a time in Y. "vertical" lines are taller than they
; are wide and step multiple pixels across Y, but only one at a time in X
;
; this routine determines what type of line the coordinates describe
; and uses either a horizontal or vertical algorithm accordingly
;
; TODO: since every line is drawn twice (drawn once, then erased next frame),
;       the line-flipping checks here should really be done when building
;       the list of lines to draw, rather than every time a line is drawn
;
;-------------------------------------------------------------------------------
        ; get abs height of the line:
        ;
        sec 
        lda ZP_VAR_Y2           ; take line-ending Y pos
        sbc ZP_VAR_Y1           ; subtract the line-starting Y pos
        beq @flat               ; completely flat line? use specific routine
        bcs :+                  ; if line is top-to-bottom, skip ahead
        eor # %11111111         ; flip all bits,
        adc # $01               ; and add 1 (two's compliment)
        sec 
:       sta ZP_LINE_HEIGHT      ; store line-height

        ; get abs width of the line:
        ;
        lda ZP_VAR_X2           ; take line-starting X pos
        sbc ZP_VAR_X1           ; and subtract line-ending X pos
        bcs :+                  ; if line is left-to-right, skip ahead
        eor # %11111111         ; flip all bits,
        adc # $01               ; and add 1 (two's compliment)
:       sta ZP_LINE_WIDTH       ; store line-width

        sty ZP_LINE_RESTORE_Y   ; preserve Y
        
        ; is the line "horizontal" or "vertical"?
        ; note: A = line-width
        ;
        cmp ZP_LINE_HEIGHT      ; compare line-height with width
        bcs draw_line_horz      ; a "horizontal" line?

@vert:  ; handle "vertical" line
        jmp draw_line_vert
        
@flat:  ; a perfectly flat line
        jmp draw_straight_line


.include        "draw_fastlines_h.asm"
.include        "draw_fastlines_v.asm"