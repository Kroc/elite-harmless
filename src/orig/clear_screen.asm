; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; clear the screen entirely. the HUD will be drawn or erased according to the
; current screen (main / menu) so this handles the transition between the two
;
clear_screen:                                                           ;$B21A
;===============================================================================
        ; reset the colour-map (the colour-nybbles held in the text screen)
        ;-----------------------------------------------------------------------
        ; set starting position in top-left of the centred
        ; 32-char (256px) viewport Elite uses
        lda #< (ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ))
        sta ZP_TEMP_ADDR1_LO
        lda #> (ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ))
        sta ZP_TEMP_ADDR1_HI

        ldx # 24                        ; colour 24 rows

@row:   lda # .color_nybble( WHITE, BLACK )                             ;$B224
        ldy # ELITE_VIEWPORT_COLS-1     ; 32 columns (0-31)

        ; colour one row
:       sta [ZP_TEMP_ADDR1], y                                          ;$B228
        dey
        bpl :-

        ; move to the next row
        lda ZP_TEMP_ADDR1_LO    ; get the row lo-address
        clc
        adc # 40                ; add 40 chars (one screen row)
        sta ZP_TEMP_ADDR1_LO
        bcc :+                  ; remains under 255?
        inc ZP_TEMP_ADDR1_HI    ; if not, increase the hi-address

:       dex                     ; decrement remaining row count         ;$B238
        bne @row

        ;-----------------------------------------------------------------------
        ; erase the bitmap area above the HUD,
        ; i.e. the viewport
        ;
        ; calculate the number of bytes in the bitmap above the HUD
        erase_bytes             = .bmppos( ELITE_HUD_TOP_ROW, 0 )
        ; from this calculate the number of bytes in *whole* pages
        erase_bytes_pages       = (erase_bytes / 256) * 256
        ; and the remaining bytes that don't fill one page
        erase_bytes_remain      = erase_bytes - erase_bytes_pages

        ldx #> ELITE_BITMAP_ADDR
:       jsr erase_page                                                  ;$B23D
        inx
        cpx #> (ELITE_BITMAP_ADDR + erase_bytes_pages)
        bne :-

        ; erase the non-whole-page remainder
        ldy #< (ELITE_BITMAP_ADDR + erase_bytes_pages + erase_bytes_remain - 1)
        jsr erase_page_from
        sta [ZP_TEMP_ADDR1], y

        ; set cursor position to row/col 2 on Elite's screen
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bze :+                  ; yes -- HUD will be redrawn

        cmp # $0d               ;?
        bne @_b25d

:       jmp _b301                                                       ;$B25A

@_b25d:                                                                 ;$B25D
        ;-----------------------------------------------------------------------
        ; will switch to menu screen during the interrupt
        lda # ELITE_VIC_LAYOUT_MENUSCR
        sta interrupt_layout2

        lda # vic_screen_ctl2::unused
        sta interrupt_screenmode2

        ; erase bitmap to end?
        ; TODO: fix for VIC bank 3
:       jsr erase_page                                                  ;$B267
        inx
        cpx #> (ELITE_BITMAP_ADDR + $2000)
        bne :-

        ldx # $00
        stx _1d01               ;?
        stx _1d04               ;?

        ; set text-cursor to row/col 2
        inx
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW

        jsr fill_sides          ; fills outside the viewport!?
        jsr hide_all_ships
        jsr disable_sprites

        ldy # ELITE_VIEWPORT_COLS-1
        lda # .color_nybble( YELLOW, BLACK )

:       sta ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ), y                     ;$B289
        dey
        bpl :-

        ldx ZP_SCREEN
        cpx # $02
        beq drawViewportBorders

        cpx # $40
        beq drawViewportBorders
        cpx # $80
        beq drawViewportBorders
        
        ; apply the yellow colour to the second header-border on some screens
        ldy # ELITE_VIEWPORT_COLS-1
:       sta ELITE_MENUSCR_ADDR + .scrpos( 2, 4 ), y                     ;$B29F
        dey
        bpl :-

drawViewportBorders:                                                    ;$B2A5
        ;-----------------------------------------------------------------------
        ldx # 199               ; last pixel row
        jsr drawViewportBorderH ; draw the bottom screen border

        ; ?
        lda # %11111111
        sta ELITE_BITMAP_ADDR + 7 + .bmppos( 24, 35 )                   ;=$5F1F

        ; for menu, draw the side-borders
        ; down the whole screen (25 rows)
        ldx # 25
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

drawViewportBordersV:                                                   ;$B2B2
        ;-----------------------------------------------------------------------
        ; for the flight screen, draw the side borders
        ; just for the viewport portion of the screen
        ldx # ELITE_VIEWPORT_ROWS
        ; remember line-length for later
        stx ZP_C0

        ; the bitmap address for the start of
        ; the line must be set in ZP_TEMP_ADDR1
        ;
        ; the viewport begins at the 4th column,
        ; so the border is drawn down the 3rd column
        ;
        ldy # 3 * 8             ; 3rd char in bitmap cells
        sty ZP_TEMP_ADDR1_LO    ; set as the bitmap address lo-byte

        ; this is the hi-byte of the bitmap address
        ; which is passed into the routine
        ldy #> ELITE_BITMAP_ADDR
        ; this is the pixel pattern to draw down the rows
        lda # %00000011
        jsr drawViewportBorderV

        ldy #< (ELITE_BITMAP_ADDR + .bmppos( 0, 36 ))   ;=$4120
        sty ZP_TEMP_ADDR1_LO

        ldy #> (ELITE_BITMAP_ADDR + .bmppos( 0, 36 ))   ;=$4120
        lda # %11000000
        ldx ZP_C0               ; length of line in screen rows
        jsr drawViewportBorderV

        lda # $01
        sta ELITE_BITMAP_ADDR + .bmppos( 0, 35 )                        ;=$4118

        ldx # $00

drawViewportBorderH:                                                    ;$B2D5
        ;-----------------------------------------------------------------------
        ; draw a horizontal viewport border:
        ;
        ; in:    X       pixel row (i.e. 0 or 199)
        ;
        stx ZP_VAR_Y            ; first pixel row
        ldx # $00
        stx ZP_VAR_X1           ; X1 = 0
        dex                     ; $00 -> $FF
        stx ZP_VAR_X2           ; X2 = 255
        jmp draw_straight_line

drawViewportBorderV:                                                    ;$B2E1
        ;-----------------------------------------------------------------------
        ; draw a vertical viewport border:
        ;
        ; in:   A       pixel pattern to draw line, e.g. %00010000
        ;       X       length of line, in rows
        ;       Y       hi-byte of bitmap address to use as starting position
        ;               (lo-byte must already be set in ZP_TEMP_ADDR1_LO)
        ;
        sta ZP_BE               ; put aside the pixel pattern to draw
        sty ZP_TEMP_ADDR1_HI    ; set the starting bitmap address, hi-byte

@loop:                                                                  ;$B2E5
        ldy # 7                 ; 8 pixel rows per cell
:       lda ZP_BE               ; retrieve pixel pattern to draw        ;$B2E7
        eor [ZP_TEMP_ADDR1], y  ; mask out the existing pixels
        sta [ZP_TEMP_ADDR1], y  ; apply the new pixels
        dey                     ; one less pixel row
        bpl :-                  ; any remain?

        ; add 320 to the bitmap address
        ; to move to the next row:
        lda ZP_TEMP_ADDR1_LO
        clc
        adc #< 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc #> 320
        sta ZP_TEMP_ADDR1_HI

        dex                     ; one less screen row
        bne @loop               ; any more?

        rts

; redraw the HUD:
;
_b301:                                                                  ;$B301
;-------------------------------------------------------------------------------
        ; restore the borders around the viewport
        jsr drawViewportBordersV
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
        
        ; the original Elite code does a rather inefficient byte-by-byte copy.
        ; for every byte copied, additional cycles are spent on decrementing
        ; the 16-bit address pointers and the slower indirect-X addressing
        ; mode is used -- but in a rather rediculous case of this being a
        ; rushed port from the BBC this routine also copies all the blank
        ; space left and right of the HUD *every frame*!
        ;
        ldx # 8                 ; number of pages to copy (8*256)
        lda #< __HUD_COPY_RUN__
        sta ZP_TEMP_ADDR3_LO
        lda #> __HUD_COPY_RUN__
        sta ZP_TEMP_ADDR3_HI

        hud_bmp = ELITE_BITMAP_ADDR + .bmppos( ELITE_HUD_TOP_ROW, 0 )   ;=$5680

        lda #< hud_bmp
        sta ZP_TEMP_ADDR1_LO
        lda #> hud_bmp
        sta ZP_TEMP_ADDR1_HI
        jsr block_copy

        ldy # $c0               ; remainder bytes?
        ldx # $01
        jsr block_copy_from

        jsr hide_all_ships
        jsr _2ff3               ; update dials?

_b335:                                                                  ;$B335
        jsr fill_sides          ; fills outside the viewport!
        jsr disable_sprites

        lda # $ff
        sta _1d04

        rts


hide_all_ships:                                                         ;$B341
;===============================================================================
; appears to make all entities invisible to the radar scanner?
;
        ; search through the poly objects in-play
        ldx # $00

@next:  lda SHIP_SLOTS, x       ; what type of entitiy is here?         ;$B343
       .bze @rts                ; no more ships once we hit a $00 marker
        bmi :+                  ; skip over planets/suns

        jsr get_polyobj         ; get address of entity storage

        ; make the entitiy invisible to the radar!

        ldy # PolyObject::visibility
        lda [ZP_POLYOBJ_ADDR], y
        and # visibility::scanner ^$FF  ;=%11101111
        sta [ZP_POLYOBJ_ADDR], y

:       inx                                                             ;$B355
        bne @next

@rts:   rts                                                             ;$B358

; fill the borders down the sides of the viewport!
; not required in elite-harmless because the bitmap is pre-filled
;
; (probably used to clip the explosion sprite -- it appears below graphics --
;  but that doesn't cover the borders to the sides of the viewport)
;
fill_sides:                                                             ;$B359

        ; first the left-hand-side
        ; cols 0, 1, 2
        ldx #< ELITE_BITMAP_ADDR
        ldy #> ELITE_BITMAP_ADDR
        jsr @fill

        ; fill the right-hand-side
        ; cols 37, 38, 39
        ldx #< (ELITE_BITMAP_ADDR + .bmppos( 0, 37 ))
        ldy #> (ELITE_BITMAP_ADDR + .bmppos( 0, 37 ))

@fill:  ;                                                               ;$B364
        ; put the given address in the zero-page
        stx ZP_TEMP_ADDR1_LO
        sty ZP_TEMP_ADDR1_HI
        ldx # 18                ; 17 rows
@row:                                                                   ;$B36A
        ldy # (3 * 8) - 1       ; 3 chars, 24 bytes, 0-23

:       lda # %11111111         ; set all bitmap bits                   ;$B36C
        sta [ZP_TEMP_ADDR1], y  ; write to the bitmap
        dey                     ; move to next byte
        bpl :-                  ; keep going until $00->$FF

        ; move to the next bitmap char-row
        lda ZP_TEMP_ADDR1_LO
        clc
        adc #< 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc #> 320
        sta ZP_TEMP_ADDR1_HI

        dex                     ; row complete
        bne @row                ; more rows to do? (exits at $00)

        rts


;===============================================================================
; clear the screen when switching between cockpit/menus:
;
_b384:                                                                  ;$B384
        ldx # 8
        ldy # 0
        clc

@loop:  lda row_to_bitmap_lo, x                                         ;$B389
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, x
        sta ZP_TEMP_ADDR1_HI

        tya

:       sta [ZP_TEMP_ADDR1], y                                          ;$B394
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

erase_page:                                                             ;$B3A7
        ;=======================================================================
        ; erase a page (256 bytes, aligned to $00...$FF)
        ;
        ;       X = page-number, i.e. hi-address
        ;
        ldy # $00
        sty ZP_TEMP_ADDR1_LO

erase_page_from:                                                        ;$B3AB
        ;=======================================================================
        ; erase some bytes:
        ;
        ;     $07 = lo-address
        ;       X = hi-address
        ;       Y = offset
        ;
        lda # $00
        stx ZP_TEMP_ADDR1_HI

:       sta [ZP_TEMP_ADDR1], y                                          ;$B3AF
        dey
        bne :-

        rts

erase_page_to_end:                                                      ;$B3B5
        ;=======================================================================
        lda # $00
:       sta [ZP_TEMP_ADDR1], y                                          ;$B3B7
        iny
        bne :-

        rts

; unreferenced / unused?
;
        sta ZP_CURSOR_COL                                               ;$B3BD
        rts

        sta ZP_CURSOR_ROW                                               ;$B3C0
        rts

block_copy:                                                             ;$B3C3
        ;=======================================================================
        ; does a large block-copy of bytes. used to wipe the HUD
        ; by copying over a clean copy of the HUD in RAM.
        ;
        ; [ZP_TEMP_ADDR3] = from address
        ; [ZP_TEMP_ADDR1] = to address
        ;               X = number of pages to copy
        ;
        ; the copy method is replaced with a faster alternative
        ; in elite-harmless, so this routine is no longer used
        ;
        ; start copying from the beginning of the page
        ldy # $00

block_copy_from:                                                        ;$B3C5
        ;-----------------------------------------------------------------------
        lda [ZP_TEMP_ADDR3], y  ; read from
        sta [ZP_TEMP_ADDR1], y  ; write to
        dey                     ; roll the byte-counter
       .bnz block_copy_from     ; keep going until it looped

        ; move to the next page
        inc ZP_TEMP_ADDR3_HI
        inc ZP_TEMP_ADDR1_HI
        dex                     ; one less page to copy
       .bnz block_copy_from     ; still pages to do?

        rts