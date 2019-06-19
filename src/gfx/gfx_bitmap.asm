; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; the game's default viewport/HUD data is stored in "gfx_koala_main.asm",
; and during the build process, this is assembled into a Koala Painter
; image file "build/bitmap_main.koa" -- the bytes that will go into the
; game are extracted from that image file here

.macro  .koala_bitmap   file, row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the bitmap data in the Koala file:
;
; - PRG header: 2 bytes
; - bitmap data comes first so we just need to multiply up row & column
;
.local  offset
.local  length

        offset .set (2 + (row * 320) + (col * 8))
        length .set (chars * 8)

.incbin file, offset, length

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .koala_screen   file, row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the screen data in the Koala file:
;
; - PRG header: 2 bytes
; - skip bitmap data (8'000 bytes)
; - the screen data is a 1'000 byte array of 40x25 chars
;
.local  offset
        offset .set (2 + 8000 + (row * 40) + col)

.incbin file, offset, chars

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .koala_color    file, row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the colour RAM data in the Koala file:
;
; - PRG header: 2 bytes
; - skip bitmap data (8'000 bytes)
; - screen data is a 1'000 bytes
; - the colour RAM data is a 1'000 byte array of 40x25 chars
;
.local  offset
        offset .set (2 + 8000 + 1000 + (row * 40) + col)

.incbin file, offset, chars

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

;===============================================================================
; reserve the bitmap screen in the C64 memory map
;
.segment        "VIC_BITMAP"

; in the original game, the bitmap screen is constructed by code and the bitmap
; area is instead used as packing space for initialisation. in elite-harmless
; we store a pre-constructed bitmap screen in the binary, doing away with
; a lot of code spread throughout the game to erase and rebuild the screen
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; simply reserve the 8K of space for the original game
        .res    $2000

.else   ;///////////////////////////////////////////////////////////////////////
        ; import the pre-constructed default bitmap screen:
        ;
        ; note that whilst the bitmap screen is aligned to 8'192 bytes,
        ; it doesn't occupy all of them. 8 bytes per char, times 40 columns,
        ; times 25 rows equals 8'000 bytes. typically code just writes/erases
        ; the whole 8'192 bytes, but when VIC bank #3 is being used with the
        ; bitamp at $E000-$FFFF, the last few bytes hold the hardware registers
        ; and erasing these will crash the machine!
        ;
        .koala_bitmap   "build/screen_main.koa", 0, 0, 1000

.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; Elite uses two screens for bitmap colour data (excluding colour RAM at $D800)
; one for the main "flight screen" which needs to include the colour data for
; the HUD and a second screen for the "menu", which doesn't have the HUD
; 
; the linker script ("link/elite-*.cfg") defines where these screens are
; in RAM, we only have to reserve their bytes here
;
.segment        "VIC_SCR_MAIN"
;-------------------------------------------------------------------------------
.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; include the entire default main screen RAM
        .koala_screen   "build/screen_main.koa", 0, 0, 1000
.else   ;///////////////////////////////////////////////////////////////////////
        .res            $0400
.endif  ;///////////////////////////////////////////////////////////////////////

.segment        "VIC_SCR_MENU"
;-------------------------------------------------------------------------------
.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; include the entire default menu screen RAM
        .koala_screen   "build/screen_menu.koa", 0, 0, 1000
.else   ;///////////////////////////////////////////////////////////////////////
        .res            $0400
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; this is the multi-colour bitmap data for the HUD. note that this is the
; copy of the HUD kept in RAM for restoring a fresh copy of the HUD when
; refreshing the screen, not the HUD as it exists on the bitmap screen
;
.segment        "HUD_COPY"

; in what is probably one of the most egregious cases of wasted CPU time and
; space in Elite C64, the backup HUD bitmap actually contains all the blank
; space on the left and right from where the C64's screen is 320px wide,
; rather than 256px like on the BBC
; 
; therefore in elite-harmless, we only include 256px wide rows,
; and the routine to redraw the HUD accounts for this
;
; ROW 1                                                                 ;$EF90
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 18, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 18, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 2
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 19, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 19, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 3
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 20, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 20, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 4
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 21, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 21, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 5
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 22, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 22, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 6
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 23, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 23, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 7
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 24, 0, 40

        ; blank padding in the original game
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00

        ; who are you, and what are
        ; you doing in my house!?
        .byte   $f5

        ;$F870
        
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   "build/screen_main.koa", 24, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; screen RAM colour:
;
; TODO: like the HUD, there's wasted bytes here too
;
; in the original game this is a block of data that is copied to the screen RAM
; during initialisation and then erased by the bitmap. in elite-harmless we are
; including the screens pre-filled in the binary, so this temporary copy is not
; needed
;
ELITE_HUD_COLORSCR_ADDR := ELITE_MAINSCR_ADDR + .scrpos(18, 0)

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
.segment        "HUD_COLORSCR"

; `proc` is used so that `.sizeof(hud_screenram_copy)` is available
.proc   hud_screenram_copy                                              ;$783A

        ; include the screen RAM data (for the HUD) from the Koala file
        .koala_screen   "build/screen_main.koa", 18, 0, (7 * 40)
        ; trailing junk bytes that appear in the original game data
        .byte   $60, $d3, $66, $1d, $a0, $40, $b3, $d3

.endproc
;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================
; colour RAM ($D800..) nybbles:
;
; this data is used only once to initialise colour RAM and is not referred to
; again. ergo, the segment address is not colour RAM itself ($D800) but the
; address in the game binary where the data is to copy to colour RAM during
; initialisation
;
; in the original game, this is only the colour data for the HUD (7 rows)
; since the rest of the colour data is constructed programatically.
; in elite-harmless the whole colour RAM is stored
;
.segment        "GFX_COLORRAM"

; `proc` is used so that `.sizeof(gfx_colorram_init)` is available
.proc   gfx_colorram_init                                               ;$795A

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; include the HUD's colour RAM data from the Koala image
        .koala_color    "build/screen_main.koa", 18, 0, (7 * 40)
        ; trailing junk bytes that appear in the original game data
        .byte   $8d, $18, $8f, $50, $46, $7e, $a4, $f4
.else   ;///////////////////////////////////////////////////////////////////////
        ; include the whole colour RAM data from the Koala image 
        ; TODO: we could save space in the .PRG by combining the nybbles
        ;       into bytes and unpacking during initialization
        .koala_color    "build/screen_main.koa", 0, 0, 1000
.endif  ;///////////////////////////////////////////////////////////////////////

.endproc

;===============================================================================
; the BBC Micro, unusually for an 8-bit, has programmable display circuitry
; allowing the developer to create custom display modes. On the BBC, Elite uses
; a 256-px wide display for easy math (x-coordinates do not have to be 2 bytes)
; but on the C64 the screen is always 320-px wide and has a non-linear bitmap
; layout (pixels are in order of char-cells, not scanlines)
;
; therefore on the C64, there is some level of translation between a centred
; 256-px (32 char) display and the C64 screen (40 chars).
;
;        1  4                             36  40
;       +---=------------------------------=---+
;       |   1                             32   |
;       |  .--------------------------------.  |
;       |  |                                |  |
;       :  :                                :  :
;       '  '                                '  '
;     
; we're going to build a pair of lookup tables that translate a row index
; to a bitmap address for the 1st column of the centred display. each entry
; is repeated 8 times, probably to account for scanlines-per-char(?)

; TODO: could this be shortened by doing away with the 8x repetition?

; first, calculate each row address:
_bmprow00 = ELITE_BITMAP_ADDR + .bmppos(  0, 4 ) ;=$4020
_bmprow01 = ELITE_BITMAP_ADDR + .bmppos(  1, 4 ) ;=$4160
_bmprow02 = ELITE_BITMAP_ADDR + .bmppos(  2, 4 ) ;=$42A0
_bmprow03 = ELITE_BITMAP_ADDR + .bmppos(  3, 4 ) ;=$43E0
_bmprow04 = ELITE_BITMAP_ADDR + .bmppos(  4, 4 ) ;=$4520
_bmprow05 = ELITE_BITMAP_ADDR + .bmppos(  5, 4 ) ;=$4660
_bmprow06 = ELITE_BITMAP_ADDR + .bmppos(  6, 4 ) ;=$47A0
_bmprow07 = ELITE_BITMAP_ADDR + .bmppos(  7, 4 ) ;=$48E0
_bmprow08 = ELITE_BITMAP_ADDR + .bmppos(  8, 4 ) ;=$4A20
_bmprow09 = ELITE_BITMAP_ADDR + .bmppos(  9, 4 ) ;=$4B60
_bmprow10 = ELITE_BITMAP_ADDR + .bmppos( 10, 4 ) ;=$4CA0
_bmprow11 = ELITE_BITMAP_ADDR + .bmppos( 11, 4 ) ;=$4DE0
_bmprow12 = ELITE_BITMAP_ADDR + .bmppos( 12, 4 ) ;=$4F20
_bmprow13 = ELITE_BITMAP_ADDR + .bmppos( 13, 4 ) ;=$5060
_bmprow14 = ELITE_BITMAP_ADDR + .bmppos( 14, 4 ) ;=$51A0
_bmprow15 = ELITE_BITMAP_ADDR + .bmppos( 15, 4 ) ;=$52E0
_bmprow16 = ELITE_BITMAP_ADDR + .bmppos( 16, 4 ) ;=$5420
_bmprow17 = ELITE_BITMAP_ADDR + .bmppos( 17, 4 ) ;=$5560
_bmprow18 = ELITE_BITMAP_ADDR + .bmppos( 18, 4 ) ;=$56A0
_bmprow19 = ELITE_BITMAP_ADDR + .bmppos( 19, 4 ) ;=$57E0
_bmprow20 = ELITE_BITMAP_ADDR + .bmppos( 20, 4 ) ;=$5920
_bmprow21 = ELITE_BITMAP_ADDR + .bmppos( 21, 4 ) ;=$5A60
_bmprow22 = ELITE_BITMAP_ADDR + .bmppos( 22, 4 ) ;=$5BA0
_bmprow23 = ELITE_BITMAP_ADDR + .bmppos( 23, 4 ) ;=$5CE0
_bmprow24 = ELITE_BITMAP_ADDR + .bmppos( 24, 4 ) ;=$5E20

; what is this madness!? despite the C64 screen being 25 rows, the data table
; just keeps going! this is purely because the lo/hi tables are indexed and it
; makes it faster to have these aligned a page ($00..$FF)

_bmprow25 = ELITE_BITMAP_ADDR + .bmppos( 25, 4 ) ;=$5F60
_bmprow26 = ELITE_BITMAP_ADDR + .bmppos( 26, 4 ) ;=$60A0
_bmprow27 = ELITE_BITMAP_ADDR + .bmppos( 27, 4 ) ;=$61E0
_bmprow28 = ELITE_BITMAP_ADDR + .bmppos( 28, 4 ) ;=$6320
_bmprow29 = ELITE_BITMAP_ADDR + .bmppos( 29, 4 ) ;=$6460
_bmprow30 = ELITE_BITMAP_ADDR + .bmppos( 30, 4 ) ;=$65A0
_bmprow31 = ELITE_BITMAP_ADDR + .bmppos( 31, 4 ) ;=$66E0

; repeat each row address 8 times:
.define _rowtobmp_rows \
        _bmprow00, _bmprow00, _bmprow00, _bmprow00, \
        _bmprow00, _bmprow00, _bmprow00, _bmprow00, \
        _bmprow01, _bmprow01, _bmprow01, _bmprow01, \
        _bmprow01, _bmprow01, _bmprow01, _bmprow01, \
        _bmprow02, _bmprow02, _bmprow02, _bmprow02, \
        _bmprow02, _bmprow02, _bmprow02, _bmprow02, \
        _bmprow03, _bmprow03, _bmprow03, _bmprow03, \
        _bmprow03, _bmprow03, _bmprow03, _bmprow03, \
        _bmprow04, _bmprow04, _bmprow04, _bmprow04, \
        _bmprow04, _bmprow04, _bmprow04, _bmprow04, \
        _bmprow05, _bmprow05, _bmprow05, _bmprow05, \
        _bmprow05, _bmprow05, _bmprow05, _bmprow05, \
        _bmprow06, _bmprow06, _bmprow06, _bmprow06, \
        _bmprow06, _bmprow06, _bmprow06, _bmprow06, \
        _bmprow07, _bmprow07, _bmprow07, _bmprow07, \
        _bmprow07, _bmprow07, _bmprow07, _bmprow07, \
        _bmprow08, _bmprow08, _bmprow08, _bmprow08, \
        _bmprow08, _bmprow08, _bmprow08, _bmprow08, \
        _bmprow09, _bmprow09, _bmprow09, _bmprow09, \
        _bmprow09, _bmprow09, _bmprow09, _bmprow09, \
        _bmprow10, _bmprow10, _bmprow10, _bmprow10, \
        _bmprow10, _bmprow10, _bmprow10, _bmprow10, \
        _bmprow11, _bmprow11, _bmprow11, _bmprow11, \
        _bmprow11, _bmprow11, _bmprow11, _bmprow11, \
        _bmprow12, _bmprow12, _bmprow12, _bmprow12, \
        _bmprow12, _bmprow12, _bmprow12, _bmprow12, \
        _bmprow13, _bmprow13, _bmprow13, _bmprow13, \
        _bmprow13, _bmprow13, _bmprow13, _bmprow13, \
        _bmprow14, _bmprow14, _bmprow14, _bmprow14, \
        _bmprow14, _bmprow14, _bmprow14, _bmprow14, \
        _bmprow15, _bmprow15, _bmprow15, _bmprow15, \
        _bmprow15, _bmprow15, _bmprow15, _bmprow15, \
        _bmprow16, _bmprow16, _bmprow16, _bmprow16, \
        _bmprow16, _bmprow16, _bmprow16, _bmprow16, \
        _bmprow17, _bmprow17, _bmprow17, _bmprow17, \
        _bmprow17, _bmprow17, _bmprow17, _bmprow17, \
        _bmprow18, _bmprow18, _bmprow18, _bmprow18, \
        _bmprow18, _bmprow18, _bmprow18, _bmprow18, \
        _bmprow19, _bmprow19, _bmprow19, _bmprow19, \
        _bmprow19, _bmprow19, _bmprow19, _bmprow19, \
        _bmprow20, _bmprow20, _bmprow20, _bmprow20, \
        _bmprow20, _bmprow20, _bmprow20, _bmprow20, \
        _bmprow21, _bmprow21, _bmprow21, _bmprow21, \
        _bmprow21, _bmprow21, _bmprow21, _bmprow21, \
        _bmprow22, _bmprow22, _bmprow22, _bmprow22, \
        _bmprow22, _bmprow22, _bmprow22, _bmprow22, \
        _bmprow23, _bmprow23, _bmprow23, _bmprow23, \
        _bmprow23, _bmprow23, _bmprow23, _bmprow23, \
        _bmprow24, _bmprow24, _bmprow24, _bmprow24, \
        _bmprow24, _bmprow24, _bmprow24, _bmprow24

.define _rowtobmp_orig \
        _bmprow25, _bmprow25, _bmprow25, _bmprow25, \
        _bmprow25, _bmprow25, _bmprow25, _bmprow25, \
        _bmprow26, _bmprow26, _bmprow26, _bmprow26, \
        _bmprow26, _bmprow26, _bmprow26, _bmprow26, \
        _bmprow27, _bmprow27, _bmprow27, _bmprow27, \
        _bmprow27, _bmprow27, _bmprow27, _bmprow27, \
        _bmprow28, _bmprow28, _bmprow28, _bmprow28, \
        _bmprow28, _bmprow28, _bmprow28, _bmprow28, \
        _bmprow29, _bmprow29, _bmprow29, _bmprow29, \
        _bmprow29, _bmprow29, _bmprow29, _bmprow29, \
        _bmprow30, _bmprow30, _bmprow30, _bmprow30, \
        _bmprow30, _bmprow30, _bmprow30, _bmprow30, \
        _bmprow31, _bmprow31, _bmprow31, _bmprow31, \
        _bmprow31, _bmprow31, _bmprow31, _bmprow31

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////

.define _rowtobmp \
        _rowtobmp_rows, _rowtobmp_orig

.else   ;///////////////////////////////////////////////////////////////////////

.define _rowtobmp \
        _rowtobmp_rows

.endif  ;///////////////////////////////////////////////////////////////////////

; write out separate tables for lo-address / hi-address:

.segment        "TABLE_BITMAP_LO"

row_to_bitmap_lo:                                                       ;$9700
        .lobytes _rowtobmp

.segment        "TABLE_BITMAP_HI"

row_to_bitmap_hi:                                                       ;$9800
        .hibytes _rowtobmp
