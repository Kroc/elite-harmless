; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; colours
;===============================================================================

;                 hex     ¦ nybble
BLACK           = $00     ; %0000
WHITE           = $01     ; %0001
RED             = $02     ; %0010
CYAN            = $03     ; %0011
PURPLE          = $04     ; %0100
GREEN           = $05     ; %0101
BLUE            = $06     ; %0110
YELLOW          = $07     ; %0111
ORANGE          = $08     ; %1000
BROWN           = $09     ; %1001
LTRED           = $0a     ; %1010
DKGREY          = $0b     ; %1011
GREY            = $0c     ; %1100
LTGREEN         = $0d     ; %1101
LTBLUE          = $0e     ; %1110
LTGREY          = $0f     ; %1111

.define .color_nybble( fore, back ) \
        (fore & 15) << 4 | (back & 15)

.define .scrpos( row, col ) \
        ((row * 40) + col)

; given a screen row + column, return a bitmap offset in bytes
; where 1 char = 8 bytes, therefore one row is 320 bytes
.define .bmppos( row, col ) \
        (row * 320) + (col * 8)

;===============================================================================
; VIC-II registers:
;===============================================================================

; produces a value to be written to CIA2_PORTA ($DD00),
; for selecting the VIC bank -- the bits are inverted
;
.define .vic_bank_bits( bank ) \
        (<(~bank & %00000011))

; returns the address of the given VIC bank number
.define .vic_bank_addr( bank ) \
        (bank * $4000)

; gives you the VIC bank number based on the bitmap address.
; the bitmap is 8K so can appear at the lower or upper half of any bank
;
.define .vic_bank_from_bitmap( addr ) \
        .min (addr / $4000, (addr + $2000) / $4000)

; given a bitmap address returns %0000 if it appears in the lower-half
; of the VIC bank (+$0000), or %1000 if it appears in the upper half (+$2000)
; -- this is for use as bit 3 of $D018; see `VIC_LAYOUT` below
;
.define .vic_layout_bitmap( addr ) \
        ((addr .mod $4000) >> 10)

; for a given screen memory address (any multiple of $0400), returns the
; bit-pattern for use with the VIC-II memory register $D018 that sets the
; location of the text-screen (and bitmap and charset)
;
.define .vic_layout_screen( addr ) \
        ((( addr .mod $4000) / $0400) << 4)

; the sprite pointers are stored in the unused space directly after the screen
; RAM (default $0400) since the screen is 1'000 chars long and there are 24
; bytes available there. these constants are offsets you should add to your
; screen location. sprites in memory must be aligned to 64 bytes, so the value
; used in the sprite pointers is the offset of the sprite from the beginning
; of the selected VIC bank (see "vic.inc"), divided by 64
;
; for example, if the VIC bank is set to 1 ($4000..$8000) and sprites are
; stored at $6800 then the first sprite index is $A0 (+$2800 / 64)

VIC_SPRITE0_PTR                 = $03f8
VIC_SPRITE1_PTR                 = $03f9
VIC_SPRITE2_PTR                 = $03fa
VIC_SPRITE3_PTR                 = $03fb
VIC_SPRITE4_PTR                 = $03fc
VIC_SPRITE5_PTR                 = $03fd
VIC_SPRITE6_PTR                 = $03fe
VIC_SPRITE7_PTR                 = $03ff

VIC_SPRITE0_X                   = $d000
VIC_SPRITE0_Y                   = $d001
VIC_SPRITE1_X                   = $d002
VIC_SPRITE1_Y                   = $d003
VIC_SPRITE2_X                   = $d004
VIC_SPRITE2_Y                   = $d005
VIC_SPRITE3_X                   = $d006
VIC_SPRITE3_Y                   = $d007
VIC_SPRITE4_X                   = $d008
VIC_SPRITE4_Y                   = $d009
VIC_SPRITE5_X                   = $d00a
VIC_SPRITE5_Y                   = $d00b
VIC_SPRITE6_X                   = $d00c
VIC_SPRITE6_Y                   = $d00d
VIC_SPRITE7_X                   = $d00e
VIC_SPRITE7_Y                   = $d00f

VIC_SPRITES_X                   = $d010

VIC_SCREEN_CTL1                 = $d011 ; screen-control register

.enum   vic_screen_ctl1
        scroll_vert     = %00000111     ; vertical scroll offset
        rows            = %00001000     ; 0 = 24 rows, 1 = 25 rows
        display         = %00010000     ; 1 = screen on, 0 = off
        bitmap          = %00100000     ; 0 = text, 1 = bitmap
        extended        = %01000000     ; 1 = extended background mode
        raster_line     = %10000000     ; hi-bit of the raster line
.endenum

VIC_SCREEN_CTL2                 = $d016

.enum   vic_screen_ctl2
        unused          = %11000000     ;=$C0 - unused, but always present
        scroll_horz     = %00000111     ;=$07 - horizontal scroll offset
        cols            = %00001000     ;=$08 - 1 = 38 cols, 0 = 40 cols
        multicolor      = %00010000     ;=$10 - 1 = multi-color mode on

        default         = %11001000     ;=$C8 - default value at system-on
.endenum

VIC_SCREEN_VERT                 = $d011 ; vertical scroll offset (bits 0-2)
VIC_SCREEN_HORZ                 = $d016 ; horizontal scroll offset (bits 0-2)

VIC_RASTER                      = $d012

VIC_LIGHT_X                     = $d013
VIC_LIGHT_Y                     = $d014

VIC_SPRITE_ENABLE               = $d015

VIC_SPRITE_DBLHEIGHT            = $d017
VIC_SPRITE_DBLWIDTH             = $d01d

VIC_LAYOUT                      = $d018
;
; the location in memory of the text-screen / colour-data, character-set and
; bitmap are determined by a single register, $D018, consisting of two fields:
;
.enum   vic_layout
        ;
        ; bits 4-7 select the location of the text-screen / colour-data, which
        ; can be any of these values: (note that these addresses are relative
        ; to the VIC-II bank address)
        ; 
        screen_mask             = %11110000
        screen_0000             = %00000000     ;=$00 - VIC+$0000
        screen_0400             = %00010000     ;=$10 - VIC+$0400
        screen_0800             = %00100000     ;=$20 - VIC+$0800
        screen_0c00             = %00110000     ;=$30 - VIC+$0C00
        screen_1000             = %01000000     ;=$40 - VIC+$1000
        screen_1400             = %01010000     ;=$50 - VIC+$1400
        screen_1800             = %01100000     ;=$60 - VIC+$1800
        screen_1c00             = %01110000     ;=$70 - VIC+$1C00
        screen_2000             = %10000000     ;=$80 - VIC+$2000
        screen_2400             = %10010000     ;=$90 - VIC+$2400
        screen_2800             = %10100000     ;=$A0 - VIC+$2800
        screen_2c00             = %10110000     ;=$B0 - VIC+$2C00
        screen_3000             = %11000000     ;=$C0 - VIC+$3000
        screen_3400             = %11010000     ;=$D0 - VIC+$3400
        screen_3800             = %11100000     ;=$E0 - VIC+$3800
        screen_3c00             = %11110000     ;=$F0 - VIC+$3C00

        ; in text-mode bits 1-3 control the
        ; location of the character graphics
        ;
        char_mask               = %00001110
        char_0000               = %00000000     ;=$00 - VIC+$0000
        char_0800               = %00000010     ;=$02 - VIC+$0800
        char_1000               = %00000100     ;=$04 - VIC+$1000
        char_1800               = %00000110     ;=$06 - VIC+$1800
        char_2000               = %00001000     ;=$08 - VIC+$2000
        char_2800               = %00001010     ;=$0A - VIC+$2800
        char_3000               = %00001100     ;=$0C - VIC+$3000
        char_3800               = %00001110     ;=$0E - VIC+$3800

        ; if bitmap mode is enabled, bit 3
        ; controls the offset of the bitmap
        ;
        bitmap_mask             = %00001000
        bitmap_0000             = %00000000     ;=$00 - VIC+$0000
        bitmap_2000             = %00001000     ;=$08 - VIC+$2000

        ; bit 0 has no effect, but you may see it set by software;
        ; some believed that it must always be set to 1
        unused                  = %00000001
.endenum

VIC_INTERRUPT_STATUS            = $d019
VIC_INTERRUPT_CONTROL           = $d01a

INTERRUPT_RASTER                = %0001
INTERRUPT_BGCOLLISION           = %0010
INTERRUPT_SPCOLLISION           = %0100
INTERRUPT_LIGHTPEN              = %1000

VIC_SPRITE_PRIORITY             = $d01b

VIC_SPRITE_MULTICOLOR           = $d01c

VIC_SPRITE_SPCOLLISION          = $d01e
VIC_SPRITE_BGCOLLISION          = $d01f

VIC_BORDER                      = $d020
VIC_BACKGROUND                  = $d021

VIC_BKGND_EXTRA1                = $d022 ; extended background colour 1
VIC_BKGND_EXTRA2                = $d023 ; extended background colour 2
VIC_BKGND_EXTRA3                = $d024 ; extended background colour 3

VIC_SPRITE_EXTRA1               = $d025 ; sprite extra colour 1
VIC_SPRITE_EXTRA2               = $d026 ; sprite extra colour 2

VIC_SPRITE0_COLOR               = $d027
VIC_SPRITE1_COLOR               = $d028
VIC_SPRITE2_COLOR               = $d029
VIC_SPRITE3_COLOR               = $d02a
VIC_SPRITE4_COLOR               = $d02b
VIC_SPRITE5_COLOR               = $d02c
VIC_SPRITE6_COLOR               = $d02d
VIC_SPRITE7_COLOR               = $d02e

; $D02F..$D040 are unused
; $D040..$D400 are repeats of the VIC registers (every $40/64 bytes)
