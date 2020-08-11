; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; clear the screen entirely. the HUD will be drawn or erased according to the
; current screen (main / menu) so this handles the transition between the two
;
clear_screen:
;===============================================================================
; improved screen-clearing code for elite-harmless:
; (doesn't erase the bytes outside of the 256px-wide viewport)
;
;-------------------------------------------------------------------------------
        ; erase the bitmap area above the HUD:
        ; i.e. the viewport

        ; set text-cursor to row/col 2
        ldx # $01
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW
        
        ; we need to loop a full 256 times and we want to keep the exit check
        ; fast (so testing for zero/non-zero). starting at $FF won't do, as a
        ; zero-check at the bottom will exit out before the 0'th loop has been
        ; done. ergo, we start at 0, the `dex` at the bottom will underflow
        ; back to $FF and we loop around until back to $00 where the loop
        ; will exit without repeating the 0'th iteration
        ;
        dex                     ; X = 0
        txa                     ; A = %00000000 (i.e. erase bitmap bits...)

:       ; begin loop, erasing one byte
        ; of all viewport rows at once
        ;
        sta ELITE_BITMAP_ADDR + .bmppos(  0, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  1, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  2, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  3, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  4, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  5, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  6, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  7, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  8, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos(  9, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 10, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 11, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 12, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 13, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 14, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 15, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 16, 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( 17, 4 ), x
        dex 
       .bnz :-

        ; TODO: we need to restore (or skip)
        ;       the top/bottom screen border 
        ;
        ; for now, we're going to fully redraw the top-border,
        ; but if we can avoid this somehow, I'd be pleased
        ;
        ldy # 0
        jsr drawViewportBorderH

        ; are we in the cockpit-view?
        ldy ZP_SCREEN           ; (Y is used here to keep A & X = $00)
       .bze :+                  ; yes -- HUD will be redrawn

        cpy # $0d               ;?
        bne @nohud

        ; redraw the HUD
:       jmp _b301

        ;-----------------------------------------------------------------------
        ; erase the HUD to make way for the menu screen:
        ;
@nohud: ldx # 0                 ; begin loop, erasing 1 byte of all HUD rows
        txa                     ; A = %00000000 (i.e. erase bitmap bits...)
:       sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 0), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 1), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 2), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 3), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 4), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 5), 4 ), x
        sta ELITE_BITMAP_ADDR + .bmppos( (ELITE_HUD_TOP_ROW + 6), 4 ), x
        dex 
       .bnz :-

        ; (note that X will be $00 due to loop condition above)
        stx _1d01               ;?
        stx _1d04               ;?
        
        ; will switch to menu screen during the interrupt
        lda # ELITE_VIC_LAYOUT_MENUSCR
        sta interrupt_layout2

        lda # vic_screen_ctl2::unused
        sta interrupt_screenmode2

        jsr hide_all_ships
        jsr disable_sprites

        ;-----------------------------------------------------------------------
        ; apply the yellow colour to the second header-border on some screens
        ;
        ; TODO: can we get away with this on every menu screen, and just bake
        ;       it into the menu-screen data?
        ;
;;        ldx ZP_SCREEN
;;        cpx # $02
;;        beq drawViewportBorders

;;        cpx # $40
;;        beq drawViewportBorders
;;        cpx # $80
;;        beq drawViewportBorders

;;        ldy # ELITE_VIEWPORT_COLS-1
;;:       sta ELITE_MENUSCR_ADDR + .scrpos( 2, 4 ), y
;;        dey
;;        bpl :-

;;        rts

        ; when switching to the menu pages, redraw the bottom border
        ; as it gets removed when erasing the HUD
        ;
        ldy # 199

drawViewportBorderH:
        ;-----------------------------------------------------------------------
        ; in:   Y       pixel row to draw border line across
        ;
        sty ZP_VAR_Y            ; set the pixel row
        ldx # 0                 ; setup the X-positions:
        stx ZP_VAR_X1           ; X1 = 0
        dex                     ; ($00 -> $FF)
        stx ZP_VAR_X2           ; X2 = 255
        jmp draw_straight_line


; redraw the HUD:
;
_b301:
;-------------------------------------------------------------------------------
        lda # ELITE_VIC_LAYOUT_MAINSCR
        sta interrupt_layout2

        lda # vic_screen_ctl2::unused | vic_screen_ctl2::multicolor
        sta interrupt_screenmode2

        lda _1d04               ; is HUD visible? (main or menu screen?)
        bne _b335

        ; reset the HUD graphics from the copy kept in RAM
        ;-----------------------------------------------------------------------
        ; the HUD is a 256px wide bitmap (with borders on the outside though).
        ; this routine 'clears' the HUD by restoring a clean copy from RAM
        ;
.import __HUD_COPY_RUN__
        ;
        ; improved HUD-copy for Elite : Harmless
        ;
        ; we need to loop a full 256 times and we want to keep the exit check
        ; fast (so testing for zero/non-zero). starting at $FF won't do, as a
        ; zero-check at the bottom will exit out before the 0'th loop has been
        ; done. ergo, we start at 0, the `dex` at the bottom will underflow
        ; back to $FF and we loop around until back to $00 where the loop
        ; will exit without repeating the 0'th iteration
        ;
        ldx # $00

        ; here we copy one byte of 7 bitmap rows at a time. note that the
        ; bitmap data is stored in 256px strips (in Elite : Harmless),
        ; not 320px. doing 7 copies per loop reduces the cost of loop-testing
        ; (very slow to exit-test for every byte copied!) and also allows us
        ; to use the absolute-X adressing mode which costs 5 cycles each rather
        ; than 6 for the original code's use of indirect-X addressing
        ;
        bmp = ELITE_BITMAP_ADDR

        ; TODO: we could `.repeat` this for the number of rows defined by
        ;       `ELITE_HUD_HEIGHT_ROWS`
        ;
:       lda __HUD_COPY_RUN__, x         ; read from row 1 of backup HUD
        sta bmp + .bmppos( 18, 4 ), x   ; write to row 18 of bitmap screen
        lda __HUD_COPY_RUN__ + $100 , x ; read from row 2 of backup HUD
        sta bmp + .bmppos( 19, 4 ), x   ; write to row 19 of bitmap screen
        lda __HUD_COPY_RUN__ + $200, x  ; read from row 3 of backup HUD
        sta bmp + .bmppos( 20, 4 ), x   ; write to row 20 of bitmap screen
        lda __HUD_COPY_RUN__ + $300, x  ; read from row 4 of backup HUD
        sta bmp + .bmppos( 21, 4 ), x   ; write to row 21 of bitmap screen
        lda __HUD_COPY_RUN__ + $400, x  ; read from row 5 of backup HUD
        sta bmp + .bmppos( 22, 4 ), x   ; write to row 22 of bitmap screen
        lda __HUD_COPY_RUN__ + $500, x  ; read from row 6 of backup HUD
        sta bmp + .bmppos( 23, 4 ), x   ; write to row 23 of bitmap screen
        lda __HUD_COPY_RUN__ + $600, x  ; read from row 7 of backup HUD
        sta bmp + .bmppos( 24, 4 ), x
        dex
       .bnz :-

        jsr hide_all_ships
        jsr _2ff3               ; update dials?

_b335:
        ;-----------------------------------------------------------------------
        jsr disable_sprites

        lda # $ff
        sta _1d04

        rts

hide_all_ships:
;===============================================================================
; appears to make all entities invisible to the radar scanner?
;
;-------------------------------------------------------------------------------
        ; search through the poly objects in-play
        ldx # $00
@next:  lda SHIP_SLOTS, x       ; what type of entitiy is here?
       .bze @rts                ; no more ships once we hit a $00 marker
        bmi :+                  ; skip over planets/suns

        jsr get_polyobj_addr    ; get address of entity storage

        ; make the entitiy invisible to the radar!

        ldy # PolyObject::visibility
        lda [ZP_POLYOBJ_ADDR], y
        and # visibility::scanner ^$FF  ;=%11101111
        sta [ZP_POLYOBJ_ADDR], y

:       inx
        bne @next

@rts:   rts


;===============================================================================
; clear the screen when switching between cockpit/menus:
;
_b384:
        ldx # 8
        ldy # 0
        clc

@loop:  lda row_to_bitmap_lo, x
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, x
        sta ZP_TEMP_ADDR1_HI

        tya

:       sta [ZP_TEMP_ADDR1], y
        dey
        bne :-

        txa
        adc # 8
        tax
        cmp # 8 * 24            ;=$C0
        bcc @loop

        iny                     ; Y = 0
        sty ZP_CURSOR_COL
        sty ZP_CURSOR_ROW

        rts

erase_page:
        ;=======================================================================
        ; erase a page (256 bytes, aligned to $00...$FF)
        ;
        ;       X = page-number, i.e. hi-address
        ;
        ldy # $00
        sty ZP_TEMP_ADDR1_LO

erase_page_from:
        ;=======================================================================
        ; erase some bytes:
        ;
        ;     $07 = lo-address
        ;       X = hi-address
        ;       Y = offset
        ;
        lda # $00
        stx ZP_TEMP_ADDR1_HI

:       sta [ZP_TEMP_ADDR1], y
        dey
        bne :-

        rts

erase_page_to_end:
        ;=======================================================================
        lda # $00
:       sta [ZP_TEMP_ADDR1], y
        iny
        bne :-

        rts