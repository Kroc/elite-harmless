; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; "draw_lines.asm" -- code & data for drawing lines
;
; this is a macro because it is located in the
; middle of other code in the original game
;
.macro  .draw_lines
;///////////////////////////////////////////////////////////////////////////////
;
; line-drawing data:
;-------------------------------------------------------------------------------
; for drawing vertical lines, this is a pixel mask
; for each particular column in a character cell
;
_ab31:                                                                  ;$AB31
        .byte   %10000000
        .byte   %01000000
        .byte   %00100000
        .byte   %00010000
        .byte   %00001000
        .byte   %00000100
        .byte   %00000010
        .byte   %00000001

        ; bytes beyond this point appear not to be used
        ;
        .byte   %10000000
        .byte   %01000000

        .byte   %11000000
        .byte   %00110000
        .byte   %00001100
        .byte   %00000011
        .byte   %11000000

        .byte   %11000000
        .byte   %01100000
        .byte   %00110000
        .byte   %00011000
        .byte   %00001100
        .byte   %00000110
        .byte   %00000011

; multi-color pixels are made from pairs of pixels. this lookup table
; translates a pixel from 0-7 to the nearest multi-color pixel pair
; e.g.
;
;       %10------ & %01------ = %11000000
;       %--10---- & %--01---- = %00110000
;       %----10-- & %----01-- = %00001100
;       %------10 & %------01 = %00000011
;
_ab47:                                                                  ;$AB47
        .byte   %11000000
        .byte   %11000000
_ab49:                                                                  ;$AB49
        .byte   %00110000
        .byte   %00110000
        .byte   %00001100
        .byte   %00001100
        .byte   %00000011
        .byte   %00000011
        .byte   %11000000
        .byte   %11000000

;-------------------------------------------------------------------------------
; lookup-table of routines to draw a line-segment beginning from each column
; 0...7 of a char-cell row and stepping vertically upwards
; 
.define _ab51_addrs \
        _horzup_col0, \
        _horzup_col1, \
        _horzup_col2, \
        _horzup_col3, \
        _horzup_col4, \
        _horzup_col5, \
        _horzup_col6, \
        _horzup_col7

_ab51:  .lobytes _ab51_addrs            ; just the lo-bytes             ;$AB51
_ab59:  .hibytes _ab51_addrs            ; just the hi-bytes             ;$AB59

.define _ab61_addrs \
        _horzup_col0_next, \
        _horzup_col1_next, \
        _horzup_col2_next, \
        _horzup_col3_next, \
        _horzup_col4_next, \
        _horzup_col5_next, \
        _horzup_col6_next, \
        _horzup_col7_next

_ab61:  .lobytes _ab61_addrs                                            ;$AB61
_ab69:  .hibytes _ab61_addrs                                            ;$AB69

;-------------------------------------------------------------------------------
; lookup-table of routines to draw a line-segment beginning from each column
; 0...7 of a char-cell row and stepping vertically downwards
; 
.define _ab71_addrs \
        _horzdn_col0, \
        _horzdn_col1, \
        _horzdn_col2, \
        _horzdn_col3, \
        _horzdn_col4, \
        _horzdn_col5, \
        _horzdn_col6, \
        _horzdn_col7

_ab71:  .lobytes _ab71_addrs                                            ;$AB71
_ab79:  .hibytes _ab71_addrs                                            ;$AB79

.define _ab81_addrs \
        _horzdn_col0_next, \
        _horzdn_col1_next, \
        _horzdn_col2_next, \
        _horzdn_col3_next, \
        _horzdn_col4_next, \
        _horzdn_col5_next, \
        _horzdn_col6_next, \
        _horzdn_col7_next

_ab81:  .lobytes _ab81_addrs                                            ;$AB81
_ab89:  .hibytes _ab81_addrs                                            ;$AB89

draw_line:                                                              ;$AB91
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
        sty ZP_9E                       ; preserve Y

        ; how do we know when to take a step vertically? an 'error' counter
        ; increments a set amount (here named "step fraction") based on the
        ; 'slope' of the line, whenever it overflows a vertical step is taken
        ;
        ; we begin with a step fraction of 1/2,
        ; i.e. the centre of a pixel
        ;
        lda # $80                       ; = 128/256 (1/2, or "0.5")                        
        sta ZP_BF                       ; this will be the incremental counter
        asl                             ; this just sets A to 0
        sta VAR_06F4                    ;?

        ; get width of the line:
        lda ZP_VAR_X2                   ; take line-starting X pos
        sbc ZP_VAR_X1                   ; and subtract line-ending X pos
       .bge :+                          ; if line is left-to-right, skip ahead

        ; line coords are right-to-left, so the result underflowed
        ; invert the result to get the positive length
        ; 
        eor # %11111111                 ; flip all bits,
        adc # $01                       ; and add 1 (two's compliment)

:       sta ZP_BC                       ; store line-width              ;$ABA5

        ; get height of line:
        sec 
        lda ZP_VAR_Y2                   ; take line-ending Y pos
        sbc ZP_VAR_Y1                   ; subtract the line-starting Y pos
       .bge :+                          ; if line is top-to-bottom, skip ahead

        ; line co-ords are bottom-to-top, so the result underflowed
        ; invert the result to get the positive height
        ;
        eor # %11111111                 ; flip all bits,
        adc # $01                       ; and add 1 (two's compliment)

:       sta ZP_BD                       ; store line-height             ;$ABB2
        
        ; is the line "horizontal" or "vertical"?
        ; note: A = line-height
        ;
        cmp ZP_BC                       ; compare line-height with width                       
       .blt draw_line_horz              ; a "horiztonal" line?

        ; handle "vertical" line
        jmp draw_line_vert

draw_line_horz:                                                         ;$ABBB
        ;=======================================================================
        ; a "horizontal" line is one which is wider than it is tall, having the
        ; property that the line only ever steps one pixel vertically at a time
        ; (for any given number of steps horizontally, depending on width)
        ;
        ; for drawing and speed purposes, there are two kinds of horizontal
        ; lines: top-down, i.e. "\", and bottom-up, i.e. "/"
        ;
        ldx ZP_VAR_X1
        cpx ZP_VAR_X2
       .blt :+                          ; line is left-to-right, skip ahead.
                                        ; note that the use of `ldx` means that
                                        ; X = horizontal start point (pixels)
        
        ; line is the wrong way around,
        ; flip the line's direction
        dec VAR_06F4                    ;? 

        lda ZP_VAR_X2                   ; flip beginning and end points;
        sta ZP_VAR_X1                   ; line-drawing will proceed
        stx ZP_VAR_X2                   ; left-to-right
        tax                             ; X = horizontal start point (pixels)
        lda ZP_VAR_Y2                   ; also flip vertically, so that the
        ldy ZP_VAR_Y1                   ; line proceeds from the higher to
        sta ZP_VAR_Y1                   ; the lower Y-coordinate
        sty ZP_VAR_Y2                   ; Y = vertical start point (pixels)

        ; given a horizontal line that can only adjust one pixel vertically
        ; at a time, we must get the 'step' value that tells us how often
        ; the horizontal line takes a step vertically
        ;
:       ldx ZP_BD                       ; get line height (dy)          ;$ABD3
       .bze @flat                       ; if zero, line is straight!

        lda _9400, x                    ;?

        ldx ZP_BC                       ; get line width (dx)
        sec 
        sbc _9400, x                    ;
        bmi @_abfd

        ldx ZP_BD                       ; get line height (dy)
        lda _9300, x                    ;?
        ldx ZP_BC                       ; get line width (dx)
        sbc _9300, x                    ;?
        bcs @deg45                      ; is the line 45-degrees?
        
        tax 
        lda _9500, x                    ;?
        jmp @_ac0d

@deg45: ; 45-degree line...                                             ;$ABF5
        ;-----------------------------------------------------------------------
        lda # $ff                       ; 1:1 step increment, i.e. 45-degrees
       .bnz @_ac0d                      ; (always branches)

@flat:  ; straight line...                                              ;$ABF9
        ;-----------------------------------------------------------------------
        lda # $00                       ; no step increment!
       .bze @_ac0d                      ; (always branches)

@_abfd:                                                                 ;$ABFD
        ;-----------------------------------------------------------------------
        ldx ZP_BD                       ; get line-height
        lda _9300, x                    ;?
        ldx ZP_BC                       ; get line-width
        sbc _9300, x                    ;?
        bcs @deg45                      ; is the line 45-degrees?

        tax 
        lda _9600, x

@_ac0d:                                                                 ;$AC0D
        ; set the step-fraction. for every pixel horizontal, this fractional
        ; amount will be added to the incremental counter. every time it
        ; overflows a step vertically will be taken
        sta ZP_BD

        clc 
        ldy ZP_VAR_Y1
        cpy ZP_VAR_Y2
       .bge draw_line_horzup

        jmp draw_line_horzdn

draw_line_horzup:                                                       ;$AC19
        ;=======================================================================
        ; draws a horizontally sloped line from the bottom up (Y2 > Y1)
        
        ; get the address within the bitmap where we will be drawing,
        ; stored into `ZP_TEMP_ADDR1`
        ;
        lda ZP_VAR_X1                   ; horizontal pixel column
        and # %11111000                 ; round to 8-bits, i.e. per char cell
        clc 
        adc row_to_bitmap_lo, y         ; get bitmap address low-byte
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y         ; get bitmap address high-byte
        adc # $00
        sta ZP_TEMP_ADDR1_HI

        tya                             ; get the pixel row again
        and # %00000111                 ; mod 8 (0...7), i.e. row within cell
        tay                             ; Y = char cell row index

        lda ZP_VAR_X1                   ; again, the horizontal pixel column
        and # %00000111                 ; mod 8 (0...7)
        tax                             ; X = char cell pixel column no.

        bit VAR_06F4
        bmi @_ac49

        ; each pixel column has its own routine for drawing for speed purposes,
        ; get the address to jump to based on the column number 0...7 
        lda _ab51, x
        sta @_ac46+1
        lda _ab59, x
        sta @_ac46+2
        ldx ZP_BC
@_ac46:                                                                 ;$AC46
        jmp $8888

@_ac49:                                                                 ;$AC49
        lda _ab61, x
        sta @_ac5a+1
        lda _ab69, x
        sta @_ac5a+2
        ldx ZP_BC
        inx 
        beq line_done1
@_ac5a:                                                                 ;$AC5A
        jmp $8888

line_done1:                                                             ;$AC5D
        ;-----------------------------------------------------------------------
        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!

; this series of routines represent an unrolled loop to draw pixels of the
; line beginning at a particular column numbers, and proceeding to the next
;
_horzup_col0:                                                           ;$AC60
        ;=======================================================================
        ; draw a pixel in column 0 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %10000000                 ; we will set the first pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col0_next:                                                      ;$AC66

        dex                             ; one less pixel to draw
       .bze line_done1                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col1                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$AC82

_horzup_col1:                                                           ;$AC83
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 1 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %01000000                 ; we will set the second pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col1_next:                                                      ;$AC89

        dex                             ; one less pixel to draw
        beq line_done1                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col2                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?

        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07
     
:       clc                                                             ;$ACA5

_horzup_col2:                                                           ;$ACA6
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 2 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00100000                 ; we will set the third pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col2_next:                                                      ;$ACAC

        dex                             ; one less pixel to draw
        beq line_done1                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col3                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$ACC8

_horzup_col3:                                                           ;$ACC9
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 3 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00010000                 ; we will set the fourth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col3_next:                                                      ;$ACCF

        dex                             ; one less pixel to draw
        beq line_done1                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col4                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$ACEB

_horzup_col4:                                                           ;$ACEC
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 4 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00001000                 ; we will set the fifth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col4_next:                                                      ;$ACF2
        dex                             ; one less pixel to draw
        beq _horzup_col6_done           ; no more pixels to draw?
                                        ; note that the relative branch will
                                        ; not reach `line_done_rel1` above,
                                        ; so trampolines downward

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col5                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI
        
        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$AD0E

_horzup_col5:                                                           ;$AD0F
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 5 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000100                 ; we will set the sixth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col5_next:                                                      ;$AD15

        dex                             ; one less pixel to draw
        beq line_done2                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col6                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI
        
        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$AD31

_horzup_col6:                                                           ;$AD32
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 6 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000010                 ; we will set the seventh pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col6_next:                                                      ;$AD38
        dex                             ; one less pixel to draw
_horzup_col6_done:                                                      ;$AD39
        beq line_done2                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_col7                ; draw next pixel if step continues

        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI
        
        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$AD54

_horzup_col7:                                                           ;$AD55
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 7 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000001                 ; we will set the eighth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzup_col7_next:                                                      ;$AD5B

        dex                             ; one less pixel to draw
        beq line_done2                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzup_next_char           ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move up one row in the character cell (8 rows).
        ; if we're at the top of the cell, move to the next cell above
        ;
        dey                             ; move to the previous row
        bpl :+                          ; still within the char-cell?
        
        ; subtract 320 from the current bitmap address
        ; i.e. move up one char-cell on the screen
        lda ZP_TEMP_ADDR1_LO
        sbc # < 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 320
        sta ZP_TEMP_ADDR1_HI
        
        ; begin at bottom of char-cell, row 7
        ldy # $07

:       clc                                                             ;$AD77

_horzup_next_char:                                                      ;$AD78
        ;-----------------------------------------------------------------------
        ; move one char-cell to the right
        ; (add 8-bytes to the bitmap address)
        lda ZP_TEMP_ADDR1_LO
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcs :+                          ; moved to the next page?

        jmp _horzup_col0                ; begin drawing at column 0

:       inc ZP_TEMP_ADDR1_HI            ; increase bitmap hi-byte       ;$AD83
        jmp _horzup_col0                ; begin drawing at column 0

line_done2:                                                             ;$AD88
        ;-----------------------------------------------------------------------
        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!


draw_line_horzdn:                                                       ;$AD8B
        ;=======================================================================
        ; get the char-cell bitmap address
        ; for the given X & Y pixel coords:
        ;
        lda row_to_bitmap_hi, y
        sta ZP_TEMP_ADDR1_HI

        lda ZP_VAR_X1                   ; horizontal pixel column
        and # %11111000                 ; round to 8-bits, i.e. per char cell
        adc row_to_bitmap_lo, y
        sta ZP_TEMP_ADDR1_LO
        bcc :+

        inc ZP_TEMP_ADDR1_HI
        clc 

:       sbc # $f7                       ; 255 - 8??                     ;$AD9E
        sta ZP_TEMP_ADDR1_LO
        bcs :+

        dec ZP_TEMP_ADDR1_HI

:       tya                                                             ;$ADA6
        and # %00000111
        eor # %11111000
        tay 
        lda ZP_VAR_X
        and # %00000111
        tax 
        bit VAR_06F4
        bmi _adc9

        lda _ab71, x
        sta _adc6+1
        lda _ab79, x
        sta _adc6+2
        ldx ZP_BC
        beq line_done2
_adc6:                                                                  ;$ADC6
        jmp $8888

        ;-----------------------------------------------------------------------

_adc9:                                                                  ;$ADC9
        lda _ab81, x
        sta _adda+1
        lda _ab89, x
        sta _adda+2
        ldx ZP_BC
        inx 
        beq line_done2
_adda:                                                                  ;$ADDA
        jmp $8888

line_done3:                                                             ;$ADDD
        ;-----------------------------------------------------------------------
        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!

; this series of routines represent an unrolled loop to draw pixels of the
; line beginning at a particular column numbers, and proceeding to the next
;
_horzdn_col0:                                                           ;$ADE0
        ;=======================================================================
        ; draw a pixel in column 0 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %10000000                 ; we will set the first pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col0_next:                                                      ;$ADE6

        dex                             ; one less pixel to draw
        beq line_done3                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col1                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI

        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AE02

_horzdn_col1:                                                           ;$AE03
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 1 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %01000000                 ; we will set the second pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col1_next:                                                      ;$AE09

        dex                             ; one less pixel to draw
        beq line_done3                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col2                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI

        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AE25

_horzdn_col2:                                                           ;$AE26
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 2 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00100000                 ; we will set the third pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col2_next:                                                      ;$AE2C

        dex                             ; one less pixel to draw
        beq line_done3                  ; no more pixels to draw?
        
        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col3                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AE48

_horzdn_col3:                                                           ;$AE49
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 3 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00010000                 ; we will set the fourth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col3_next:                                                      ;$AE4F

        dex                             ; one less pixel to draw
        beq _horzdn_col6_done           ; no more pixels to draw?
        
        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col4                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AE6B

_horzdn_col4:                                                           ;$AE6C
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 4 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00001000                 ; we will set the fifth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col4_next:                                                      ;$AE72

        dex                             ; one less pixel to draw
        beq _horzdn_col6_done           ; no more pixels to draw?
        
        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col5                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AE8E

_horzdn_col5:                                                           ;$AE8F
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 5 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000100                 ; we will set the sixth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col5_next:                                                      ;$AE95

        dex                             ; one less pixel to draw
        beq line_done4                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col6                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AEB1

_horzdn_col6:                                                           ;$AEB2
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 6 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000010                 ; we will set the seventh pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col6_next:                                                      ;$AEB8
        dex                             ; one less pixel to draw
_horzdn_col6_done:                                                      ;$AEB9
        beq line_done4                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_col7                ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AED4

_horzdn_col7:                                                           ;$AED5
        ;-----------------------------------------------------------------------
        ; draw a pixel in column 7 of a char-cell and
        ; move to the next pixel, and row if necessary
        ;
        ;       X = remaining no. of pixels of line to draw
        ;       Y = char cell row no. 0...7
        ;
        lda # %00000001                 ; we will set the eighth pixel
        eor [ZP_TEMP_ADDR1], y          ; flip all pixels, masking the new one
        sta [ZP_TEMP_ADDR1], y          ; write combined pixels to screen

_horzdn_col7_next:                                                      ;$AEDB

        dex                             ; one less pixel to draw
        beq line_done4                  ; no more pixels to draw?

        lda ZP_BF                       ; current step counter
        adc ZP_BD                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc _horzdn_next_char           ; draw next pixel if step continues
        
        ; we have stepped vertically:
        ; move down one row in the character cell (8 rows).
        ; if we're at the bottom of the cell, move to the next cell below
        ;
        iny                             ; move to the next row
        bne :+                          ; still within the char-cell?
        
        ; add 320 to the current bitmap address, i.e. move down one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        adc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # > 319
        sta ZP_TEMP_ADDR1_HI
        
        ; set Y to -8 (since we're counting upwards,
        ; it'll hit zero which is fastest to test for)
        ldy # (256 - 8)

:       clc                                                             ;$AEF7

_horzdn_next_char:                                                      ;$AEF8
        ;-----------------------------------------------------------------------
        lda ZP_TEMP_ADDR1_LO
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcc :+
        inc ZP_TEMP_ADDR1_HI

:       jmp _horzdn_col0                                                ;$AF02

line_done4:                                                             ;$AF05
        ;-----------------------------------------------------------------------
        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!


draw_line_vert:                                                         ;$AF08
        ;=======================================================================
        ; a "vertical" line is one which is taller than it is wide, having the
        ; property that the line only ever steps one pixel horizontally at a
        ; time (for any given number of steps vertically, depending on height)
        ;
        ; for speed, all vertical lines are drawn top-to-bottom and a different
        ; routine is used for left-to-right ("/") vs. right-to-left ("\") lines
        ;
        ; the first thing we have to do is determine which way the line goes
        ; and flip top-down lines so we always work bottom-up
        ;
        ldy ZP_VAR_Y1                   ; get "starting" Y-position
        tya 
        ldx ZP_VAR_X1                   ; (get starting X-position, for later)
        cpy ZP_VAR_Y2                   ; is line top-down, or bottom up?
       .bge :+                          ; if line is bottom-up, skip ahead

        ; the line is top-down; we need to flip it
        dec VAR_06F4                    ;?
        
        lda ZP_VAR_X2
        sta ZP_VAR_X1
        stx ZP_VAR_X2
        tax 
        lda ZP_VAR_Y2
        sta ZP_VAR_Y1
        sty ZP_VAR_Y2
        tay 

        ; work out the bitmap address to begin line drawing
        ;
:       txa                             ; retrieve starting X-position  ;$AF22
        and # %11111000                 ; clip to nearest char-cell (8px each)
        clc 
        adc row_to_bitmap_lo, y         ; use the lookup-table to get bitmap
        sta ZP_TEMP_ADDR1_LO            ; address based on the pixel row
        lda row_to_bitmap_hi, y         ; and store in [ZP_TEMP_ADDR1]
        adc # $00                       ; (propogate any overflow from X)
        sta ZP_TEMP_ADDR1_HI
        
        ; get the row number (0-7)
        ; within the character cell
        tya 
        and # %00000111
        tay 

        ; get the column number (0-7)
        ; within the character cell
        txa 
        and # %00000111
        tax 

        ; get a pixel mask for that column
        lda _ab31, x
        sta ZP_BE

        ; is the line straight? (completely vertical)
        ldx ZP_BC                       ; get line-width
       .bze @_af77                      ; if zero, skip ahead
        
        lda _9400, x
        ldx ZP_BD
        sec 
        sbc _9400, x
        bmi @_af65
        
        ldx ZP_BC
        lda _9300, x
        ldx ZP_BD
        sbc _9300, x
        bcs @deg45
        
        tax 
        lda _9500, x
        jmp @_af75

@deg45: ; 45-degree line...                                             ;$AF61
        ;-----------------------------------------------------------------------
        lda # $ff                       ; 1:1 step increment, i.e. 45-degrees
        bne @_af75                      ; (always branches)

@_af65:                                                                 ;$AF65
        ;-----------------------------------------------------------------------
        ldx ZP_BC                       ; get line-width
        lda _9300, x                    ;?
        ldx ZP_BD                       ; get line-height
        sbc _9300, x                    ;?
        bcs @deg45                      ; is the line 45-degrees?
        
        tax 
        lda _9600, x

@_af75:                                                                 ;$AF75
        ; set the step-fraction. for every pixel vertical, this fractional
        ; amount will be added to the incremental counter. every time it
        ; overflows a step horizontally will be taken
        sta ZP_BC
@_af77:                                                                 ;$AF77
        sec 
        ldx ZP_BD
        inx 
        
        lda ZP_VAR_X2
        sbc ZP_VAR_X1
        bcc _vertlt                     ; handle bottom-up, left-to-right line

        clc 
        lda VAR_06F4
        beq _vertrt_pixel_next
        
        dex 

_vertrt_pixel:                                                          ;$AF88
        ;-----------------------------------------------------------------------
        lda ZP_BE                       ; get the current pixel mask
        eor [ZP_TEMP_ADDR1], y          ; mask against the existing pixels
        sta [ZP_TEMP_ADDR1], y          ; write back the new pixels

_vertrt_pixel_next:                                                     ;$AF8E

        dey                             ; move up a row in the char-cell
        bpl :+                          ; if still within char-cell, skip

        ; subtract 320 from the current bitmap address, i.e. move up one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        sbc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 319
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07

:       lda ZP_BF                       ; current step counter          ;$AF9F
        adc ZP_BC                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc :+                          ; draw next pixel if step continues

        lsr ZP_BE                       ; mask the next pixel to the right
        bcc :+                          ; still within char-cell?

        ; we have left the char-cell on the right.
        ; reset the mask to the left-most pixel
        ;
        ror ZP_BE                       ; this just pushes the carry in

        ; now move to the char-cell to the right
        ; (add 8 to the bitmap address)
        lda ZP_TEMP_ADDR1_LO
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcc :+
        inc ZP_TEMP_ADDR1_HI
        clc 
        
:       dex                             ; one less pixel to draw        ;$AFB8
       .bnz _vertrt_pixel               ; any remaining?

        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!

_vertlt:                                                                ;$AFBE
        ;=======================================================================
        lda VAR_06F4
        beq _vertlt_pixel_next
        dex 

_vertlt_pixel:                                                          ;$AFC4
        ;-----------------------------------------------------------------------
        lda ZP_BE                       ; get the current pixel mas
        eor [ZP_TEMP_ADDR1], y          ; mask against the existing
        sta [ZP_TEMP_ADDR1], y          ; write back the new pixels

_vertlt_pixel_next:                                                     ;$AFCA
        
        dey                             ; move up a row in the char-cell
        bpl :+                          ; if still within char-cell, skip

        ; subtract 320 from the current bitmap address, i.e. move up one
        ; char-cell on the screen (note that carry is set, so 319 is used)
        lda ZP_TEMP_ADDR1_LO
        sbc # < 319
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # > 319
        sta ZP_TEMP_ADDR1_HI

        ; begin at bottom of char-cell, row 7
        ldy # $07

:       lda ZP_BF                       ; current step counter          ;$AFDB
        adc ZP_BC                       ; add the step fraction
        sta ZP_BF                       ; update step counter
        bcc @next                       ; draw next pixel if step continues

        asl ZP_BE                       ; mask the next pixel to the left
        bcc @next                       ; still within char-cell?

        ; we have left the char-cell on the left.
        ; reset the mask to the right-most pixel
        ;
        rol ZP_BE                       ; this just pushes the carry in

        ; now move to the char-cell to the left
        ; (add 8 to the bitmap address)
        lda ZP_TEMP_ADDR1_LO
        sbc # $07
        sta ZP_TEMP_ADDR1_LO
        bcs :+
        dec ZP_TEMP_ADDR1_HI

:       clc                                                             ;$AFF3

@next:                                                                  ;$AFF4
        dex                     ; one less pixel to draw
        bne _vertlt_pixel       ; any remaining?

        ldy ZP_9E               ; restore Y
:       rts                     ; line has been drawn!                  ;$AFF9

draw_straight_line:                                                     ;$AFFA
;===============================================================================
; draws a straight, horizontal line:
;
;       ZP_VAR_Y  = Y-position
;       ZP_VAR_X1 = starting X-position, in viewport pixels (0-255)
;       ZP_VAR_X2 = ending X-position, in viewport pixels (0-255)
;       preserves Y
;
; this is reasonably fast as it marches 8-pixels
; at a time in the middle of the line
;
.export draw_straight_line

        sty ZP_9E               ; preserve Y

        ldx ZP_VAR_X1
        cpx ZP_VAR_X2
       .bze :-
        bcc :+

        lda ZP_VAR_X2
        sta ZP_VAR_X1
        stx ZP_VAR_X2
        tax 

:       dec ZP_VAR_X2                                                   ;$B00B
        lda ZP_VAR_Y
        tay 

        ; get bitmap address
        and # %00000111
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        sta ZP_TEMP_ADDR1_HI
        txa 
        and # %11111000
        clc 
        adc row_to_bitmap_lo, y
        tay 
        bcc :+
        inc ZP_TEMP_ADDR1_HI

:       txa                                                             ;$B025 
        and # %11111000
        sta ZP_C0

        lda ZP_VAR_X2
        and # %11111000
        sec 
        sbc ZP_C0
        beq @tiny_line
        lsr 
        lsr 
        lsr 
        sta ZP_BE
        
        lda ZP_VAR_X1
        and # %00000111
        tax 

        ; draw left-hand side
        lda _2907, x
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        ; move to the next char-cell
        ; (add 8 to the bitmap address)
        tya 
        adc # $08
        tay 
        
        bcc :+
        inc ZP_TEMP_ADDR1_HI

:       ldx ZP_BE                                                       ;$B04C
        dex 
       .bze @_b064
        
        clc 

@fill:                                                                  ;$B052
        ;-----------------------------------------------------------------------
        ; set a full char-cell row (8px) in one go
        ; i.e. fast-scan through the body of the sun
        ;
        ;       X = number of char-cells wide to fill
        ;
        lda # %11111111
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        
        ; add 8 to the bitmap address
        ; i.e. move one char-cell to the right
        tya 
        adc # $08
        tay 
        
        ; catch overflow in the address low-byte
        bcc :+
        inc ZP_TEMP_ADDR1_HI
        clc 

:       dex                                                             ;$B061 
       .bnz @fill

@_b064:                                                                 ;$B064
        ; draw right-hand-side
        lda ZP_VAR_X2
        and # %00000111
        tax 
        lda _2900, x
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        
        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!

@tiny_line:                                                             ;$B073
        ;-----------------------------------------------------------------------
        ; line begins and ends within the same char-cell!
        ;
        ; we draw this by combining a left-fill and right-fill pattern to
        ; produce a set of pixels in the middle that corresponds to our line
        ;
        lda ZP_VAR_X1                   ; starting X position
        and # %00000111                 ; where within a char-cell? (0-7)
        tax 
        lda _2907, x                    ; get a pixel mask to fill right
        sta ZP_C0

        lda ZP_VAR_X2                   ; ending X position
        and # %00000111                 ; where within a char-cell? (0-7)
        tax 
        lda _2900, x                    ; get a pixel mask to fill left
        and ZP_C0                       ; merge the two masks

        ; draw the "line" to screen
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y

        ldy ZP_9E                       ; restore Y
        rts                             ; line has been drawn!

; unused / unreferenced?
; duplicate of $2900 / $2907 -- 
; likely intended for `draw_straight_line` above
;
        .byte   %10000000                                               ;$B08E
        .byte   %11000000
        .byte   %11100000
        .byte   %11110000
        .byte   %11111000
        .byte   %11111100
        .byte   %11111110
        .byte   %11111111
        .byte   %01111111
        .byte   %00111111
        .byte   %00011111
        .byte   %00001111
        .byte   %00000111
        .byte   %00000011
        .byte   %00000001

;///////////////////////////////////////////////////////////////////////////////
.endmacro

;===============================================================================
; a series of lookup tables. something to do with line drawing
;
.segment        "DATA_9300"
.align  256

_9300:                                                                  ;$9300
.export _9300
        .byte   $06, $00, $20, $32, $40, $4a, $52, $59                  ;$9300
        .byte   $5f, $65, $6a, $6e, $72, $76, $79, $7d                  ;$9308
        .byte   $80, $82, $85, $87, $8a, $8c, $8e, $90                  ;$9310
        .byte   $92, $94, $96, $98, $99, $9b, $9d, $9e                  ;$9318
        .byte   $a0, $a1, $a2, $a4, $a5, $a6, $a7, $a9                  ;$9320
        .byte   $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1                  ;$9328
        .byte   $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9                  ;$9330
        .byte   $b9, $ba, $bb, $bc, $bd, $bd, $be, $bf                  ;$9338
        .byte   $bf, $c0, $c1, $c2, $c2, $c3, $c4, $c4                  ;$9340
        .byte   $c5, $c6, $c6, $c7, $c7, $c8, $c9, $c9                  ;$9348
        .byte   $ca, $ca, $cb, $cc, $cc, $cd, $cd, $ce                  ;$9350
        .byte   $ce, $cf, $cf, $d0, $d0, $d1, $d1, $d2                  ;$9358
        .byte   $d2, $d3, $d3, $d4, $d4, $d5, $d5, $d5                  ;$9360
        .byte   $d6, $d6, $d7, $d7, $d8, $d8, $d9, $d9                  ;$9368
        .byte   $d9, $da, $da, $db, $db, $db, $dc, $dc                  ;$9370
        .byte   $dd, $dd, $dd, $de, $de, $de, $df, $df                  ;$9378
        .byte   $e0, $e0, $e0, $e1, $e1, $e1, $e2, $e2                  ;$9380
        .byte   $e2, $e3, $e3, $e3, $e4, $e4, $e4, $e5                  ;$9388
        .byte   $e5, $e5, $e6, $e6, $e6, $e7, $e7, $e7                  ;$9390
        .byte   $e7, $e8, $e8, $e8, $e9, $e9, $e9, $ea                  ;$9398
        .byte   $ea, $ea, $ea, $eb, $eb, $eb, $ec, $ec                  ;$93A0
        .byte   $ec, $ec, $ed, $ed, $ed, $ed, $ee, $ee                  ;$93A8
        .byte   $ee, $ee, $ef, $ef, $ef, $ef, $f0, $f0                  ;$93B0
        .byte   $f0, $f1, $f1, $f1, $f1, $f1, $f2, $f2                  ;$93B8
        .byte   $f2, $f2, $f3, $f3, $f3, $f3, $f4, $f4                  ;$93C0
        .byte   $f4, $f4, $f5, $f5, $f5, $f5, $f5, $f6                  ;$93C8
        .byte   $f6, $f6, $f6, $f7, $f7, $f7, $f7, $f7                  ;$93D0
        .byte   $f8, $f8, $f8, $f8, $f9, $f9, $f9, $f9                  ;$93D8
        .byte   $f9, $fa, $fa, $fa, $fa, $fa, $fb, $fb                  ;$93E0
        .byte   $fb, $fb, $fb, $fc, $fc, $fc, $fc, $fc                  ;$93E8
        .byte   $fd, $fd, $fd, $fd, $fd, $fd, $fe, $fe                  ;$93F0
        .byte   $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff                  ;$93F8

;===============================================================================
; a lookup table of line height / width (signed)?

_9400:                                                                  ;$9400
.export _9400
        .byte   $ae, $00, $00, $b8, $00, $4d, $b8, $d5                  ;$9400
        .byte   $ff, $70, $4d, $b3, $b8, $6a, $d5, $05                  ;$9408
        .byte   $00, $cc, $70, $ef, $4d, $8d, $b3, $c1                  ;$9410
        .byte   $b8, $9a, $6a, $28, $d5, $74, $05, $88                  ;$9418
        .byte   $00, $6b, $cc, $23, $70, $b3, $ef, $22                  ;$9420
        .byte   $4d, $71, $8d, $a3, $b3, $bd, $c1, $bf                  ;$9428
        .byte   $b8, $ab, $9a, $84, $6a, $4b, $28, $00                  ;$9430
        .byte   $d5, $a7, $74, $3e, $05, $c8, $88, $45                  ;$9438
        .byte   $ff, $b7, $6b, $1d, $cc, $79, $23, $ca                  ;$9440
        .byte   $70, $13, $b3, $52, $ef, $89, $22, $b8                  ;$9448
        .byte   $4d, $e0, $71, $00, $8d, $19, $a3, $2c                  ;$9450
        .byte   $b3, $39, $bd, $3f, $c1, $40, $bf, $3c                  ;$9458
        .byte   $b8, $32, $ab, $23, $9a, $10, $84, $f7                  ;$9460
        .byte   $6a, $db, $4b, $ba, $28, $94, $00, $6b                  ;$9468
        .byte   $d5, $3e, $a7, $0e, $74, $da, $3e, $a2                  ;$9470
        .byte   $05, $67, $c8, $29, $88, $e7, $45, $a3                  ;$9478
        .byte   $00, $5b, $b7, $11, $6b, $c4, $1d, $75                  ;$9480
        .byte   $cc, $23, $79, $ce, $23, $77, $ca, $1d                  ;$9488
        .byte   $70, $c1, $13, $63, $b3, $03, $52, $a1                  ;$9490
        .byte   $ef, $3c, $89, $d6, $22, $6d, $b8, $03                  ;$9498
        .byte   $4d, $96, $e0, $28, $71, $b8, $00, $47                  ;$94A0
        .byte   $8d, $d4, $19, $5f, $a3, $e8, $2c, $70                  ;$94A8
        .byte   $b3, $f6, $39, $7b, $bd, $fe, $3f, $80                  ;$94B0
        .byte   $c1, $01, $40, $80, $bf, $fd, $3c, $7a                  ;$94B8
        .byte   $b8, $f5, $32, $6f, $ab, $e7, $23, $5f                  ;$94C0
        .byte   $9a, $d5, $10, $4a, $84, $be, $f7, $31                  ;$94C8
        .byte   $6a, $a2, $db, $13, $4b, $82, $ba, $f1                  ;$94D0
        .byte   $28, $5e, $94, $cb, $00, $36, $6b, $a0                  ;$94D8
        .byte   $d5, $0a, $3e, $73, $a7, $da, $0e, $41                  ;$94E0
        .byte   $74, $a7, $da, $0c, $3e, $70, $a2, $d3                  ;$94E8
        .byte   $05, $36, $67, $98, $c8, $f8, $29, $59                  ;$94F0
        .byte   $88, $b8, $e7, $16, $45, $74, $a3, $d1                  ;$94F8

;===============================================================================

_9500:                                                                  ;$9500
.export _9500

        ; this looks like slopes, where the line length increases,
        ; at the same time the angle increases 0 to 45-degrees
        ; (sans 45-degrees itself),
        ;
        ; e.g. $FA = 250/256 = 0.9765625 (almost 1:1)
        ;
        ; imagine a line from (0,0) to (y,255) where y is 1-255
        ; (could be degrees rather than pixels)
        ;
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9500
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9508
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9510
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9518
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9520
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9528
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9530
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9538
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9540
        .byte   $04, $04, $04, $05, $05, $05, $05, $05                  ;$9548
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9550
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9558
        .byte   $08, $08, $08, $08, $08, $08, $09, $09                  ;$9560
        .byte   $09, $09, $09, $0a, $0a, $0a, $0a, $0b                  ;$9568
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0c, $0d                  ;$9570
        .byte   $0d, $0d, $0e, $0e, $0e, $0e, $0f, $0f                  ;$9578
        .byte   $10, $10, $10, $11, $11, $11, $12, $12                  ;$9580
        .byte   $13, $13, $13, $14, $14, $15, $15, $16                  ;$9588
        .byte   $16, $17, $17, $18, $18, $19, $19, $1a                  ;$9590
        .byte   $1a, $1b, $1c, $1c, $1d, $1d, $1e, $1f                  ;$9598
        .byte   $20, $20, $21, $22, $22, $23, $24, $25                  ;$95A0
        .byte   $26, $26, $27, $28, $29, $2a, $2b, $2c                  ;$95A8
        .byte   $2d, $2e, $2f, $30, $31, $32, $33, $34                  ;$95B0
        .byte   $35, $36, $38, $39, $3a, $3b, $3d, $3e                  ;$95B8
        .byte   $40, $41, $42, $44, $45, $47, $48, $4a                  ;$95C0
        .byte   $4c, $4d, $4f, $51, $52, $54, $56, $58                  ;$95C8
        .byte   $5a, $5c, $5e, $60, $62, $64, $67, $69                  ;$95D0
        .byte   $6b, $6d, $70, $72, $75, $77, $7a, $7d                  ;$95D8
        .byte   $80, $82, $85, $88, $8b, $8e, $91, $94                  ;$95E0
        .byte   $98, $9b, $9e, $a2, $a5, $a9, $ad, $b1                  ;$95E8
        .byte   $b5, $b8, $bd, $c1, $c5, $c9, $ce, $d2                  ;$95F0
        .byte   $d7, $db, $e0, $e5, $ea, $ef, $f5, $fa                  ;$95F8

;===============================================================================

_9600:                                                                  ;$9600
.export _9600
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9600
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9608
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9610
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9618
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9620
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9628
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9630
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9638
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9640
        .byte   $04, $04, $05, $05, $05, $05, $05, $05                  ;$9648
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9650
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9658
        .byte   $08, $08, $08, $08, $08, $09, $09, $09                  ;$9660
        .byte   $09, $09, $0a, $0a, $0a, $0a, $0a, $0b                  ;$9668
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0d, $0d                  ;$9670
        .byte   $0d, $0d, $0e, $0e, $0e, $0f, $0f, $0f                  ;$9678
        .byte   $10, $10, $10, $11, $11, $12, $12, $12                  ;$9680
        .byte   $13, $13, $14, $14, $14, $15, $15, $16                  ;$9688
        .byte   $16, $17, $17, $18, $18, $19, $1a, $1a                  ;$9690
        .byte   $1b, $1b, $1c, $1d, $1d, $1e, $1e, $1f                  ;$9698
        .byte   $20, $21, $21, $22, $23, $24, $24, $25                  ;$96A0
        .byte   $26, $27, $28, $29, $29, $2a, $2b, $2c                  ;$96A8
        .byte   $2d, $2e, $2f, $30, $31, $32, $34, $35                  ;$96B0
        .byte   $36, $37, $38, $3a, $3b, $3c, $3d, $3f                  ;$96B8
        .byte   $40, $42, $43, $45, $46, $48, $49, $4b                  ;$96C0
        .byte   $4c, $4e, $50, $52, $53, $55, $57, $59                  ;$96C8
        .byte   $5b, $5d, $5f, $61, $63, $65, $68, $6a                  ;$96D0
        .byte   $6c, $6f, $71, $74, $76, $79, $7b, $7e                  ;$96D8
        .byte   $81, $84, $87, $8a, $8d, $90, $93, $96                  ;$96E0
        .byte   $99, $9d, $a0, $a4, $a7, $ab, $af, $b3                  ;$96E8
        .byte   $b6, $ba, $bf, $c3, $c7, $cb, $d0, $d4                  ;$96F0
        .byte   $d9, $de, $e3, $e8, $ed, $f2, $f7, $fd                  ;$96F8
