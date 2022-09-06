; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "draw_fastlines_h.asm":

.macro  .hline_next_y_up
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is set when entering and must be clear on exit                  ;cycles
;
        dey                                                             ;2
        bpl :+                                                          ;3/2
        lda ZP_TEMP_ADDR_LO                                             ;3
        sbc #< 320                                                      ;2
        sta ZP_TEMP_ADDR_LO                                             ;3
        lda ZP_TEMP_ADDR_HI                                             ;3
        sbc #> 320                                                      ;2
        sta ZP_TEMP_ADDR_HI                                             ;3
        ldy # 7                                                         ;2
:       clc                     ; __9.125 (7 + 17/8), 18b
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_next_y_down
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is set when entering and must be clear on exit                  ;cycles
;
        iny                                                             ;2
        bne :+                                                          ;3/2
        lda ZP_TEMP_ADDR_LO                                             ;3
        adc #< 319              ;+carry                                 ;2
        sta ZP_TEMP_ADDR_LO                                             ;3
        lda ZP_TEMP_ADDR_HI                                             ;3
        adc #> 319                                                      ;2
        sta ZP_TEMP_ADDR_HI                                             ;3
        ldy # 248                                                       ;2
:       clc                                                             ;2
                                ; __9.125 (5 + 17/8), 17b
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_next_x_right
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is and stays clear                                              ;cycles
;
        lda ZP_TEMP_ADDR_LO                                             ;3
        adc # 8                                                         ;2
        sta ZP_TEMP_ADDR_LO                                             ;3
        bcc :+                                                          ;3/2
        inc ZP_TEMP_ADDR_HI                                             ;5
        clc                                                             ;2
:                               ;__11.1875 (11 + 6/32) 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_up_checkbit      mask
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.local  nextpos                                                         ;cycles

        adc ZP_HLINE_SLOPE                                              ;3
        bcc nextpos                                                     ;2/3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                                                             ;2
        and # mask              ; and #11100000                         ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_up        ;5.75 for CharV, normal:
        lda ZP_HLINE_COUNTER                                            ;3
        ldx # ($ff - mask)      ; set x to #00011111                    ;2
nextpos:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_last_up_checkbit mask, exit
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.local  nextpos                                                         ;cycles

        adc ZP_HLINE_SLOPE                                              ;3
        bcc nextpos                                                     ;2/3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                                                             ;2
        and # mask                                                      ;2
        and ZP_HLINE_ENDMASK                                            ;3
.if (mask = %11000000)
_hline_last_up_trampoline:
.endif
        beq exit                                                        ;2/3
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_up                                                ;5.75
        lda ZP_HLINE_COUNTER                                            ;3
        ldx # ($ff-mask)        ; set new start of segment              ;2
nextpos:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_down_checkbit    mask
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.local  nextpos                                                         ;cycles

        adc ZP_HLINE_SLOPE                                              ;3
        bcc nextpos                                                     ;2/3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                                                             ;2
        and # mask              ; and #11100000                         ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_down                                              ;5.75
        lda ZP_HLINE_COUNTER                                            ;3
        ldx # ($ff - mask)      ; set x to #00011111                    ;2
nextpos:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .hline_last_down_checkbit mask, exit
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.local  nextpos                                                         ;cycles

        adc ZP_HLINE_SLOPE                                              ;3
        bcc nextpos                                                     ;2/3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                     ; mask already processed bits           ;2
        and # mask              ; mask bits behind this pixel           ;2
        and ZP_HLINE_ENDMASK                                            ;3
.if (mask = %11000000)
_hline_last_down_trampoline:
.endif
        beq exit                                                        ;2/3
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_down                                              ;5.75
        lda ZP_HLINE_COUNTER                                            ;3
        ldx # ($ff-mask)        ; mask for already processed bits       ;2
nextpos:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


; 8 byte table for last block mask
;
_hline_endmask = _2900
;    .byte   %10000000
;    .byte   %11000000
;    .byte   %11100000
;    .byte   %11110000
;    .byte   %11111000
;    .byte   %11111100
;    .byte   %11111110
;    .byte   %11111111
_hline_startmask = _2907
;    .byte   %11111111       ;=$FF
;    .byte   %01111111       ;=$7F
;    .byte   %00111111       ;=$3F
;    .byte   %00011111       ;=$1F
;    .byte   %00001111       ;=$0F
;    .byte   %00000111       ;=$07
;    .byte   %00000011       ;=$03
;    .byte   %00000001       ;=$01

; 64 bytes table for initial jump to loop
; Entering loop at the LDX #xx - statement BEFORE the BitCheck
.define _hline_up_enter \
        _hline_up_to0-2, \
        _hline_up_to1-2, \
        _hline_up_to2-2, \
        _hline_up_to3-2, \
        _hline_up_to4-2, \
        _hline_up_to5-2, \
        _hline_up_to6-2, \
        _hline_up_to7-2
        
.define _hline_last_up_enter \
        _hline_last_up_to0-2, \
        _hline_last_up_to1-2, \
        _hline_last_up_to2-2, \
        _hline_last_up_to3-2, \
        _hline_last_up_to4-2, \
        _hline_last_up_to5-2, \
        _hline_last_up_to6-2, \
        _hline_last_up_to7-2

.define _hline_down_addrs \
        _hline_down_to0-2, \
        _hline_down_to1-2, \
        _hline_down_to2-2, \
        _hline_down_to3-2, \
        _hline_down_to4-2, \
        _hline_down_to5-2, \
        _hline_down_to6-2, \
        _hline_down_to7-2
        
.define _hline_last_down_addrs \
        _hline_last_down_to0-2, \
        _hline_last_down_to1-2, \
        _hline_last_down_to2-2, \
        _hline_last_down_to3-2, \
        _hline_last_down_to4-2, \
        _hline_last_down_to5-2, \
        _hline_last_down_to6-2, \
        _hline_last_down_to7-2

        ;=======================================================================
        ; a "horizontal" line is one which is wider than it is tall, having the
        ; property that the line only ever steps one pixel vertically at a time
        ; (for any given number of steps horizontally, depending on width)
        ;
        ; for drawing and speed purposes, there are two kinds of horizontal
        ; lines: top-down, i.e. "\", and bottom-up, i.e. "/"
        ;
draw_line_horz:

        lax ZP_VAR_XX15_0
        cpx ZP_VAR_XX15_2
        bcc :+
        
        ; line is the wrong way around,
        ; flip the line's direction
        dec LINE_FLIP           ;?

        lda ZP_VAR_XX15_2       ; flip beginning and end points;
        sta ZP_VAR_XX15_0       ; line-drawing will proceed
        stx ZP_VAR_XX15_2       ; left-to-right
        ldx ZP_VAR_XX15_3       ; also flip vertically, so that the
        ldy ZP_VAR_XX15_1       ; line proceeds from the higher to
        stx ZP_VAR_XX15_1       ; the lower Y-coordinate
        sty ZP_VAR_XX15_3       ; Y = vertical start point (pixels)
        sec 

        ;-----------------------------------------------------------------------
        ; START A = 256 * height/width
        ;-----------------------------------------------------------------------
:       ldx ZP_LINE_HEIGHT      ; height is never 0, this is checked before
        lda table_log, x
        ldx ZP_LINE_WIDTH
        sbc table_log, x
        bcs @deg45
        tay 
        sec 
        ldx ZP_LINE_HEIGHT
        lda table_logdiv, x
        ldx ZP_LINE_WIDTH
        sbc table_logdiv, x
        bmi @use9600
        
        lda _9500, y
        jmp _hline_draw_set_slope
@deg45:
        lda # $ff
        bne _hline_draw_set_slope
@use9600:
        lda _9600, y
        ; ==== END   A = 256 * height/width
        
_hline_draw_set_slope:
        sta ZP_HLINE_SLOPE

_hline_draw_after_slope:
        ldx # %00000111
        lda ZP_VAR_XX15_0
        sax _hline_begin_bit+1
        and # %11111000         ; start block * 8
        sta ZP_TEMP_ADDR_LO    

        lda ZP_VAR_XX15_2
        sax _hline_end_bit+1
        and # %11111000         ; end block * 8
        sec 
        sbc ZP_TEMP_ADDR_LO     ; sbc begin_block * 8
        lsr 
        lsr 
        lsr 
        sta ZP_LINE_BLOCKS
        
        ;; set mask for last block
_hline_end_bit:
        ldx # 0
        lda _hline_endmask, x
        sta ZP_HLINE_ENDMASK
        
_hline_begin_bit:
        lda # 0
        ldy ZP_LINE_BLOCKS
        bne :+
        adc # 8
:       ldy ZP_VAR_XX15_1
        cpy ZP_VAR_XX15_3
        bcs :+  ; bge
        adc # 16
:       tax 
        ; set jump address to loop start
        lda _hline_jmptable_lo, x
        sta _hline_jump_to_first_segment+1
        lda _hline_jmptable_hi, x
        sta _hline_jump_to_first_segment+2

        ; init screen pointer
        clc 
        lda row_to_bitmap_lo, y
        adc ZP_TEMP_ADDR_LO     ; at the moment, x%8
        sta ZP_TEMP_ADDR_LO
        lda row_to_bitmap_hi, y
        adc # 0
        sta ZP_TEMP_ADDR_HI
        
        tya                     ; get the pixel row again
        and # %00000111         ; mod 8 (0...7), i.e. row within cell
        cpy ZP_VAR_XX15_3
        tay                     ; Y = char cell row index
        bcs _hline_skip_down_adjustments
_hline_down_adjustments:
        lda ZP_TEMP_ADDR_LO
        sbc # (255 - 8)
        sta ZP_TEMP_ADDR_LO
        bcs :+
        dec ZP_TEMP_ADDR_HI
:       tya 
        ora # %11111000
        tay 
_hline_skip_down_adjustments:
        clc 
        lda # $80               ; init ZP_HLINE_COUNTER
_hline_jump_to_first_segment:
        jmp $0000

_hline_jmptable_lo:
        .lobytes _hline_up_enter
        .lobytes _hline_last_up_enter
        .lobytes _hline_down_addrs
        .lobytes _hline_last_down_addrs

_hline_jmptable_hi:
        .hibytes _hline_up_enter
        .hibytes _hline_last_up_enter
        .hibytes _hline_down_addrs
        .hibytes _hline_last_down_addrs
        
_hline_up_startblock:
        ldx # %11111111
_hline_up_to0:
        adc ZP_HLINE_SLOPE                                              ;3
        bcc _hline_up_to1                                               ;2/3
        tax                                                             ;2
        lda # %10000000                                                 ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_up                                                ;5.75
        txa                                                             ;2
        ldx # %01111111         ; set new start of segment              ;2
_hline_up_to1:
        .hline_up_checkbit %11000000
_hline_up_to2:
        .hline_up_checkbit %11100000
_hline_up_to3:
        .hline_up_checkbit %11110000
_hline_up_to4:
        .hline_up_checkbit %11111000
_hline_up_to5:
        .hline_up_checkbit %11111100
_hline_up_to6:
        .hline_up_checkbit %11111110
_hline_up_to7:
        adc ZP_HLINE_SLOPE      ; carry CLEAR: Stay at this y           ;3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                                                             ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        bcc @skipy              ;_20 + 188/256                          ;2
        .hline_next_y_up                                                ;5.75
@skipy: .hline_next_x_right                                             ;8
        lda ZP_HLINE_COUNTER                                            ;3
        dec ZP_LINE_BLOCKS;                                             ;5
        ; -> jump to the last block which adds ora ZP_HLINE_ENDMASK,
        ;    beq exit (+5 cycles/segment)
        beq _hline_up_lastblock     ;2/3
        jmp _hline_up_startblock    ;3
        ; _13  8.448 + 408 + 59,5 + 59,5 = 8975/256 *1 + XX*7 / 8

; ====  4.447.5 / 256
_hline_exit1:
        ldy ZP_LINE_RESTORE_Y   ; restore Y
        rts                     ; line has been drawn!

_hline_up_lastblock:
        ldx # %11111111         ; set new start of segment              ;2
_hline_last_up_to0:
        adc ZP_HLINE_SLOPE                                              ;3
        bcc _hline_last_up_to1                                          ;2/3
        tax                                                             ;2
        lda # %10000000                                                 ;2
        eor [ZP_TEMP_ADDR],y                                            ;5.03125
        sta [ZP_TEMP_ADDR],y                                            ;6
        .hline_next_y_up                                                ;5.75
        txa                                                             ;2
        ldx # %01111111         ; set new start of segment              ;2
_hline_last_up_to1:
        .hline_last_up_checkbit %11000000, _hline_exit1
_hline_last_up_to2:
        .hline_last_up_checkbit %11100000, _hline_exit1
_hline_last_up_to3:
        .hline_last_up_checkbit %11110000, _hline_last_up_trampoline
_hline_last_up_to4:
        .hline_last_up_checkbit %11111000, _hline_exit2
_hline_last_up_to5:
        .hline_last_up_checkbit %11111100, _hline_exit2
_hline_last_up_to6:
        .hline_last_up_checkbit %11111110, _hline_exit2 
_hline_last_up_to7:
        txa                                                             ;2
        and ZP_HLINE_ENDMASK                                            ;3
        beq _hline_exit2                                                ;2/3
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
_hline_exit2:
        ldy ZP_LINE_RESTORE_Y   ; restore Y
        rts                     ; line has been drawn!

_hline_down_startblock:
        ldx # %11111111                                                 ;2
_hline_down_to0:
        adc ZP_HLINE_SLOPE                                              ;3
        bcc _hline_down_to1                                             ;2/3
        tax                                                             ;2
        lda # %10000000                                                 ;2
        eor [ZP_TEMP_ADDR],y                                            ;5.03125
        sta [ZP_TEMP_ADDR],y                                            ;6
        .hline_next_y_down                                              ;5.75
        txa                                                             ;2
        ldx # %01111111         ; set new start of segment              ;2
_hline_down_to1:
        .hline_down_checkbit %11000000
_hline_down_to2:
        .hline_down_checkbit %11100000
_hline_down_to3:
        .hline_down_checkbit %11110000
_hline_down_to4:
        .hline_down_checkbit %11111000
_hline_down_to5:
        .hline_down_checkbit %11111100
_hline_down_to6:
        .hline_down_checkbit %11111110
_hline_down_to7:
        adc ZP_HLINE_SLOPE      ; carry CLEAR: Stay at this Y           ;3
        sta ZP_HLINE_COUNTER                                            ;3
        txa                                                             ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        bcc @skipy              ;_20 + 188/256                          ;2
        .hline_next_y_down                                              ;5.75
@skipy: .hline_next_x_right                                             ;8
        lda ZP_HLINE_COUNTER                                            ;3
        dec ZP_LINE_BLOCKS;                                             ;5
        ; -> jump to the last block which adds ora ZP_HLINE_ENDMASK,
        ;    beq exit (+5 cycles/segment)
        beq _hline_down_lastblock                                       ;2/3
        jmp _hline_down_startblock                                      ;3
        ; _13  8.448 + 408 + 59,5 + 59,5 = 8975/256 *1 + XX*7 / 8
_hline_exit3:
        ldy ZP_LINE_RESTORE_Y   ; restore Y
        rts                     ; line has been drawn!

_hline_down_lastblock:
        ldx # %11111111         ; set new start of segment              ;2
_hline_last_down_to0:
        adc ZP_HLINE_SLOPE                                              ;3
        bcc _hline_last_down_to1                                        ;2/3
        tax                                                             ;2
        lda # %10000000                                                 ;2
        eor [ZP_TEMP_ADDR], y                                           ;5.03125
        sta [ZP_TEMP_ADDR], y                                           ;6
        .hline_next_y_down                                              ;5.75
        txa                                                             ;2
        ldx # %01111111         ; set new start of segment              ;2
_hline_last_down_to1:
        .hline_last_down_checkbit %11000000, _hline_exit3
_hline_last_down_to2:
        .hline_last_down_checkbit %11100000, _hline_exit3
_hline_last_down_to3:
        .hline_last_down_checkbit %11110000, _hline_last_down_trampoline
_hline_last_down_to4:
        .hline_last_down_checkbit %11111000, _hline_exit4
_hline_last_down_to5:
        .hline_last_down_checkbit %11111100, _hline_exit4
_hline_last_down_to6:
        .hline_last_down_checkbit %11111110, _hline_exit4 
_hline_last_down_to7:
        txa                                                             ;2
        and ZP_HLINE_ENDMASK                                            ;3
        beq _hline_exit4                                                ;2/3
        eor [ZP_TEMP_ADDR],y                                            ;3
        sta [ZP_TEMP_ADDR],y                                            ;3
_hline_exit4:
        ldy ZP_LINE_RESTORE_Y   ; restore Y
_hline_exit4_norestore:     
        rts                     ; line has been drawn!


draw_straight_line:
;===============================================================================
; draw a straight, horizontal line:
;
; in:   ZP_VAR_XX15_1           Y-position
;       ZP_VAR_XX15_0           start X-position, in viewport pixels (0-255)
;       ZP_VAR_XX15_2           end X-position, in viewport pixels (0-255)
; out:  Y                       (preserved)
;------------------------------------------------------------------------------- 
        ; swap X1, X2 if neccessary
        lax ZP_VAR_XX15_0
        cpx ZP_VAR_XX15_2
        ; end pixel (or start pixel if reversed)
        ; seems to be excluded in all lines
        beq _hline_exit4_norestore
        
        sty ZP_LINE_RESTORE_Y   ; preserve Y
        bcc _sline_enter

        lda ZP_VAR_XX15_2
        sta ZP_VAR_XX15_0
        stx ZP_VAR_XX15_2
        clc

_sline_enter:
        ldx # %00000111
        sax ZP_SLINE_XOFF1
        and # %11111000         ; start block * 8
        sta _sline_beginblock8+1

        ; init dst address (start of block)
        ldy ZP_VAR_XX15_1
        adc row_to_bitmap_lo, y
        sta ZP_TEMP_ADDR_LO
        lda row_to_bitmap_hi, y
        adc # 0
        sta ZP_TEMP_ADDR_HI

        tya 
        and # %00000111
        tay 
        lda ZP_VAR_XX15_2
        sax ZP_SLINE_XOFF2
        and # %11111000          ; end block * 8
        sec
_sline_beginblock8:
        sbc # 0                  ; sbc begin_block * 8
        beq _sline_singleblock
        lsr 
        lsr 
        lsr 
        sta ZP_LINE_BLOCKS

        ldx ZP_SLINE_XOFF1
        lda _hline_startmask, x
        ldx ZP_LINE_BLOCKS
_sline_loop:
        eor [ZP_TEMP_ADDR], y
        sta [ZP_TEMP_ADDR], y
        tya 
        adc # $08
        tay 
        lda # $ff
        dex 
        bne _sline_loop

_sline_lastblock:
        ldx ZP_SLINE_XOFF2
        and _hline_endmask, x
        eor [ZP_TEMP_ADDR], y
        sta [ZP_TEMP_ADDR], y
_sline_exit1:
        ldy ZP_LINE_RESTORE_Y
        rts 

_sline_singleblock:
        ldx ZP_SLINE_XOFF1
        lda _hline_startmask, x
        ldx ZP_SLINE_XOFF2
        and _hline_endmask, x
        eor [ZP_TEMP_ADDR], y
        sta [ZP_TEMP_ADDR], y
_sline_exit2:
        ldy ZP_LINE_RESTORE_Y
        rts 