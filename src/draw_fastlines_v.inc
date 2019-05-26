; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.macro  .vline_next_y_lastblock
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is and stays set
;
        lda # 7                 ; __20
        sbc ZP_VLINE_YEND
        tay 
        lda ZP_TEMP_ADDR1_LO
        ora ZP_VLINE_YEND
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .vline_next_y_up
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is and stays set
;
        sbc #< 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc #> 320 
        sta ZP_TEMP_ADDR1_HI
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .vline_next_x_right
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is set on exit
;
        bcs @nx_end
        lsr ZP_VLINE_BIT
        bcc @nx_sc
        ror ZP_VLINE_BIT
        lda ZP_TEMP_ADDR1_LO
        adc # 8
        sta ZP_TEMP_ADDR1_LO
        bcc @nx_sc
        inc ZP_TEMP_ADDR1_HI
@nx_sc: sec 
@nx_end:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .vline_next_x_left
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; carry is set on exit                                                  ;cycles
;
        bcs @nx_end
        asl ZP_VLINE_BIT
        bcc @nx_sc
        rol ZP_VLINE_BIT
        lda ZP_TEMP_ADDR1_LO                                            ;3
        sbc # 7                                                         ;2
        sta ZP_TEMP_ADDR1_LO                                            ;3
        bcs @nx_end                                                     ;3/2
        dec ZP_TEMP_ADDR1_HI                                            ;5
@nx_sc: sec
@nx_end:
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .vline_draw
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

_vline_bitmask:
        .byte   %10000000
        .byte   %01000000
        .byte   %00100000
        .byte   %00010000
        .byte   %00001000
        .byte   %00000100
        .byte   %00000010
        .byte   %00000001

draw_line_vert:
.export draw_line_vert

        ldx ZP_VAR_Y1
        cpx ZP_VAR_Y2
        bcs :+
        
        ; flip line so that Y1 > Y2
        lda ZP_VAR_Y2
        sta ZP_VAR_Y1
        stx ZP_VAR_Y2
        ldx ZP_VAR_X2
        ldy ZP_VAR_X1
        stx ZP_VAR_X1
        sty ZP_VAR_X2
        sec 

        ;-----------------------------------------------------------------------
        ; START A = 256 * width/height
        ;-----------------------------------------------------------------------
        ; is the line straight? (completely vertical)
        ;
:       lax ZP_LINE_WIDTH       ; get line-width
        beq _vline_draw_set_slope
        lda table_log, x
        ldx ZP_LINE_HEIGHT
        sbc table_log, x
        bcs @deg45
        tay
        sec 
        ldx ZP_LINE_WIDTH
        lda table_logdiv, x
        ldx ZP_LINE_HEIGHT
        sbc table_logdiv, x
        bmi @use9600
        
        lda _9500, y
        jmp _vline_draw_set_slope
@deg45:
        lda # $ff
        bne _vline_draw_set_slope
@use9600:
        lda _9600, y
        ; ==== END   A = 256 * width/height
        
_vline_draw_set_slope:
        sta _vline_slope+1
        
        ldx # %00000111
        lda ZP_VAR_X1
        sax _vline_begin_bit+1
        and # %11111000         ; start xblock * 8
        sta ZP_TEMP_ADDR1_LO

        lda ZP_VAR_Y2
        sax ZP_VLINE_YEND
        and # %11111000
        sta _vline_yblock_end+1

        lda ZP_VAR_Y1
        sax ZP_VLINE_YSTART
        and # %11111000         ; start y % 8
        tay
        sec
_vline_yblock_end:
        sbc #0
        
;; 0 BLOCKS? ADJUST!!
        bne :+
        sta ZP_LINE_BLOCKS
        lda ZP_VLINE_YSTART
        sbc ZP_VLINE_YEND
        sta ZP_VLINE_YSTART
        clc 
        lda row_to_bitmap_lo, y
        ora ZP_VLINE_YEND       ; same as adc
        bne _vline_zeroblocks_cont
        
:       lsr 
        lsr 
        lsr 
        sta ZP_LINE_BLOCKS
                
        ; init screen pointer
        clc 
        lda row_to_bitmap_lo, y
_vline_zeroblocks_cont:
        adc ZP_TEMP_ADDR1_LO    ; at the moment, x%8
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # 0
        sta ZP_TEMP_ADDR1_HI

_vline_begin_bit:
        ldx # 0
        lda _vline_bitmask,x
        sta ZP_VLINE_BIT
        ldy ZP_VLINE_YSTART

        ldx # $80               ; slope counter
        lda ZP_VAR_X2
        cmp ZP_VAR_X1
        
_vline_slope:
        lda # 0
        bcc _vline_jump_left

_vline_jump_right:
        sta _vline_right_slope+1
        jmp _vline_right_loop
        
_vline_jump_left:
        sta _vline_left_slope+1
        jmp _vline_left_loop

_vline_left_lastblock:
        .vline_next_y_lastblock
        
_vline_left_loop_nexty:
        .vline_next_y_up

        ; blit pixel in BE
_vline_left_loop:
        lda ZP_VLINE_BIT
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y

        ; step counter:
        txa                 ; 2
_vline_left_slope:          ; AXS ignores carry for input, but sets it on out
        axs # 0             ; 2 this only works IMM, so without loop unrolling
        .vline_next_x_left

        dey 
        bpl _vline_left_loop
        lda ZP_TEMP_ADDR1_LO
        ldy # 7
        dec ZP_LINE_BLOCKS
        beq _vline_left_lastblock
        bpl _vline_left_loop_nexty
_vline_left_exit:
        ldy ZP_LINE_RESTORE_Y   ; restore Y
        rts                     ; line has been drawn!
        
; old minimum loop: 36 cycles
; this one: 26
_vline_right_lastblock:
        .vline_next_y_lastblock
        
_vline_right_loop_nexty:
        .vline_next_y_up
        
        ; blit pixel in BE
_vline_right_loop:
        lda ZP_VLINE_BIT
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y

        ; step counter:
        txa                 ; 2
_vline_right_slope:         ; AXS ignores carry for input, but sets it on out
        axs # 0             ; 2 this only works IMM, so without loop unrolling
        .vline_next_x_right

        dey 
        bpl _vline_right_loop
        lda ZP_TEMP_ADDR1_LO
        ldy # 7 
        dec ZP_LINE_BLOCKS
        beq _vline_right_lastblock
        bpl _vline_right_loop_nexty
_vline_right_exit:
        ldy ZP_LINE_RESTORE_Y
        rts 
        
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro