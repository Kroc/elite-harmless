; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; colours
;===============================================================================

.define BLACK   $00
.define WHITE   $01
.define RED     $02
.define CYAN    $03
.define PURPLE  $04
.define GREEN   $05
.define BLUE    $06
.define YELLOW  $07
.define ORANGE  $08
.define BROWN   $09
.define LTRED   $0a
.define DKGREY  $0b
.define GREY    $0c
.define LTGREEN $0d
.define LTBLUE  $0e
.define LTGREY  $0f

.define .color_nybbles(fore, back) \
        (fore & 15) << 4 | (back & 15)

.define .scrpos(ypos, xpos) \
        ((ypos * 40) + xpos)

; given a screen row + column, return a bitmap offset in bytes
; where 1 char = 8 bytes, therefore one row is 320 bytes
.define .bmppos(ypos, xpos) \
        ((ypos * 320) + (xpos * 8))

;===============================================================================
; VIC-II registers:
;===============================================================================

.define VIC_SPRITE0_X           $d000
.define VIC_SPRITE0_Y           $d001
.define VIC_SPRITE1_X           $d002
.define VIC_SPRITE1_Y           $d003
.define VIC_SPRITE2_X           $d004
.define VIC_SPRITE2_Y           $d005
.define VIC_SPRITE3_X           $d006
.define VIC_SPRITE3_Y           $d007
.define VIC_SPRITE4_X           $d008
.define VIC_SPRITE4_Y           $d009
.define VIC_SPRITE5_X           $d00a
.define VIC_SPRITE5_Y           $d00b
.define VIC_SPRITE6_X           $d00c
.define VIC_SPRITE6_Y           $d00d
.define VIC_SPRITE7_X           $d00e
.define VIC_SPRITE7_Y           $d00f

.define VIC_SPRITES_X           $d010

.define VIC_SCREEN_CTL1         $d011   ; screen-control register

.enum   screen_ctl1
        scroll_vert     = %00000111     ; vertical scroll offset
        rows            = %00001000     ; 0 = 24 rows, 1 = 25 rows
        display         = %00010000     ; 1 = screen on, 0 = off
        bitmap          = %00100000     ; 0 = text, 1 = bitmap
        extended        = %01000000     ; 1 = extended background mode
        raster_line     = %10000000     ; hi-bit of the raster line
.endenum

.define VIC_SCREEN_CTL2         $d016

.enum   screen_ctl2
        scroll_horz     = %00000111     ; horizontal scroll offset
        cols            = %00001000     ; 1 = 38 cols, 0 = 40 cols
        multicolor      = %00010000     ; 1 = multi-color mode on
.endenum

.define VIC_SCREEN_VERT         $d011   ; vertical scroll offset (bits 0-2)
.define VIC_SCREEN_HORZ         $d016   ; horizontal scroll offset (bits 0-2)

.define VIC_RASTER              $d012

.define VIC_LIGHT_X             $d013
.define VIC_LIGHT_Y             $d014

.define VIC_SPRITE_ENABLE       $d015

.define VIC_SPRITE_DBLHEIGHT    $d017
.define VIC_SPRITE_DBLWIDTH     $d01d

.define VIC_MEMORY              $d018

.define VIC_INTERRUPT_STATUS    $d019
.define VIC_INTERRUPT_CONTROL   $d01a

.define INTERRUPT_RASTER        %0001
.define INTERRUPT_BGCOLLISION   %0010
.define INTERRUPT_SPCOLLISION   %0100
.define INTERRUPT_LIGHTPEN      %1000

.define VIC_SPRITE_PRIORITY     $d01b

.define VIC_SPRITE_MULTICOLOR   $d01c

.define VIC_SPRITE_SPCOLLISION  $d01e
.define VIC_SPRITE_BGCOLLISION  $d01f

.define VIC_BORDER              $d020
.define VIC_BACKGROUND          $d021

.define VIC_BKGND_EXTRA1        $d022   ; extended background colour 1
.define VIC_BKGND_EXTRA2        $d023   ; extended background colour 2
.define VIC_BKGND_EXTRA3        $d024   ; extended background colour 3

.define VIC_SPRITE_EXTRA1       $d025   ; sprite extra colour 1
.define VIC_SPRITE_EXTRA2       $d026   ; sprite extra colour 2

.define VIC_SPRITE0_COLOR       $d027
.define VIC_SPRITE1_COLOR       $d028
.define VIC_SPRITE2_COLOR       $d029
.define VIC_SPRITE3_COLOR       $d02a
.define VIC_SPRITE4_COLOR       $d02b
.define VIC_SPRITE5_COLOR       $d02c
.define VIC_SPRITE6_COLOR       $d02d
.define VIC_SPRITE7_COLOR       $d02e

; $D02F..$D040 are unused
; $D040..$D400 are repeats of the VIC registers (every $40/64 bytes)
