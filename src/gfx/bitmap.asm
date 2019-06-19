; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

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
        ; this macro is defined in "hud_copy.asm" and it extracts bitmap
        ; data from the Koala image file of the viewport/HUD image
        ;
        .koala_bitmap   0, 0, 1000

.endif  ;///////////////////////////////////////////////////////////////////////
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
