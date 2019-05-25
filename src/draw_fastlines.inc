; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "draw_fastlines_h.inc"
.include        "draw_fastlines_v.inc"

; line drawing optimization results:
; drawloop measured with VICE tickcount between $B820 and $B83C
;
; SIMPLE SHIP (no engines visible)
;
; OLD:
; 100577375 - 100552083 = 25292
; 100611261 - 100586775 = 24486
; 100680798 - 100656741 = 24057
; 100702224 - 100687369 = 14855
;
; NEW:
; 100656644 - 100633465 = 23179
; 100689606 - 100666088 = 23518
; 100759112 - 100735968 = 23144
; 100779769 - 100765642 = 14127
;
;
; COMPLEX SHIP (Pointing up, engines visible:)
;
; OLD:
; 102412378 - 102376109 = 36269
; 102459956 - 102423424 = 36532
; 102565798 - 102529230 = 36568
; 102615180 - 102576718 = 38462
; 102722982 - 102684075 = 38907
;
; 104485635 - 104442873 = 42762
; 104538453 - 104496124 = 42329
; 104649668 - 104607563 = 42105
; 104703684 - 104660629 = 43055
;
;
; NEW:
; 102416238 - 102384206 = 32032
; 102461048 - 102426943 = 34105
; 102563756 - 102530002 = 33754
; 102609132 - 102574503 = 34629
; 102713648 - 102679239 = 34409
;
; 104530801 - 104492551 = 38250
; 104580127 - 104541675 = 38452
; 104694440 - 104655991 = 38449
; 104744599 - 104705517 = 39082
;

.macro  .draw_lines
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ZP_LINE_HEIGHT = ZP_BD
ZP_LINE_WIDTH = ZP_BC
ZP_LINE_RESTORE_Y = ZP_9E
ZP_LINE_BLOCKS = ZP_BC          ; repurpose line width

;=== HLINE
ZP_HLINE_SLOPE = ZP_BD
ZP_HLINE_COUNTER = ZP_BF
ZP_HLINE_ENDMASK = ZP_BE        ; used for vert_line, I guess it's safe

;=== SLINE
ZP_SLINE_XOFF1 = ZP_BE
ZP_SLINE_XOFF2 = ZP_BF

;=== VLINE
ZP_VLINE_BIT = ZP_BE
ZP_VLINE_YEND = ZP_BD
ZP_VLINE_YSTART = ZP_BF

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
; draw a line:
;
;       ZP_VAR_X1 = horizontal "beginning" of line in viewport, in pixels
;       ZP_VAR_X2 = horizontal "end" of line in viewport, in pixels
;       ZP_VAR_Y1 = vertical "beginning" of line in viewport, in pixels
;       ZP_VAR_Y2 = vertical "end" of line in viewport, in pixels
;       Y is preserved
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
; Bresenham's algorithm works on the principal that a solid line will only
; ever step 1 pixel at a time in one of the directions but potentially multiple
; pixles in the other. therefore, there are two distinct types of lines --
; "horizontal" lines are wider than they are tall, thus step multiple pixels
; across X, but only one at a time in Y. "vertical" lines are taller than they
; are wide and step multiple pixels across Y, but only one at a time in X
;
; this routine determines what type of line the coordinates describe
; and uses either a horizontal or vertical algorithm accordingly
;
.export draw_line
        ; TODO: since every line is drawn twice (drawn once, then erased next
        ;       frame), the line-flipping checks here should really be done
        ;       when building the list of lines to draw, rather than every
        ;       time a line is drawn
        ;
        sty ZP_LINE_RESTORE_Y   ; preserve Y

        sec 
        ; get abs height of line:
        lda ZP_VAR_Y2           ; take line-ending Y pos
        sbc ZP_VAR_Y1           ; subtract the line-starting Y pos
;;        beq @flat
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

        ; is the line "horizontal" or "vertical"?
        ; note: A = line-width
        ;
        cmp ZP_LINE_HEIGHT      ; compare line-height with width
        bcc @vert

        jmp draw_line_horz

;;        bne draw_line_horz      ; a "horiztonal" line?

;;@flat:  ; a perfectly flat line
;;        jmp draw_straight_line

@vert:  ; handle "vertical" line
        jmp draw_line_vert

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro