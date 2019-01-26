; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "elite_consts.asm" : some core, structual values used throughout Elite,
; often tied directly to the structure of the source code -- CHANGING ANY
; OF THESE IS ALMOST CERTAINLY GOING TO RENDER THE GAME INOPERABLE

.define ELITE_SEED      $4a, $5a, $48, $02, $53, $B7

;-------------------------------------------------------------------------------

; the BBC micro used a 256-px wide screen mode, but the C64 has a 320-px wide
; screen. therefore the C64 only draws in a 256-px wide centered 'screen'.
; the dimensions of this viewport are given here:

; (DON'T change this, the code is inextricably tied to this size)

ELITE_VIEWPORT_WIDTH    = 256
ELITE_VIEWPORT_HEIGHT   = 144

ELITE_VIEWPORT_COLS     = ELITE_VIEWPORT_WIDTH / 8      ;=32

;-------------------------------------------------------------------------------

; the VIC-II bank, where Elite places graphics (bitmap, sprites)
; it's a 16 KB block of memory selected from these choices:
;
; bank 0 - $0000...$3FFF        (conflict with CHARROM)
; bank 1 - $4000...$7FFF
; bank 2 - $8000...$BFFF        (conflict with CHARROM)
; bank 3 - $C000...$FFFF
;
ELITE_VIC_BANK          = 1

; the VIC-II uses a 1 KB block of RAM for the text-screen (40x25 = 1'000 bytes)
; or, in the case of high-resolution bitmap mode, colour-cell information where
; each byte represents the fore/back colour (two nybbles) for each 8x8 cell
;
; elite uses two game screens: a main-screen (flight) and a menu-screen (such
; as when docked). the flight-screen switches from high-resolution bitmap mode
; to multi-colour bitmap mode for the HUD at the bottom of the screen -- it's
; important to note that the way high-resolution and multi-colour bitmap modes
; store colour is _very_ different
;
; the location in memory of the text-screen / colour-data, character-set and
; bitmap are determined by a single register, $D018, consisting of two fields:
;
; bits 4-7 select the location of the text-screen / colour-data, which can be
; any of these values: (note that these addresses are relative to the VIC-II
; bank address above)
; 
;  0 = +$0000   /    8 = +$2000
;  1 = +$0400   /    9 = +$2400
;  2 = +$0800   /   10 = +$2800
;  3 = +$0C00   /   11 = +$2C00
;  4 = +$1000   /   12 = +$3000
;  5 = +$1400   /   13 = +$3400
;  6 = +$1800   /   14 = +$3800
;  7 = +$1C00   /   15 = +$3C00
;
ELITE_VIC_MENUSCR       = 8
ELITE_VIC_MAINSCR       = 9

; the upper bits of register $D018 select the location of the character set,
; or the bitmap screen (if enabled). note that this is relative to the chosen
; VIC-II bank above
;
; 0 = charset: +$0000, bitmap: +$0000
; 1 = charset: +$0800, bitmap: +$0000
; 2 = charset: +$1000, bitmap: +$0000 (nb: character ROM in VIC-II banks 0/2)
; 3 = charset: +$1800, bitmap: +$0000 (nb: character ROM in VIC-II banks 0/2)
; 4 = charset: +$2000, bitmap: +$2000
; 5 = charset: +$2800, bitmap: +$2000
; 6 = charset: +$3000, bitmap: +$2000
; 7 = charset: +$3800, bitmap: +$2000
;
ELITE_VIC_CHARBMP       = 0


ELITE_BITMAP_D018       = \
        ((ELITE_VIC_MENUSCR & 15) << 4) \
      | (((ELITE_VIC_CHARBMP & 7) << 1) & %00001110)

ELITE_TXTSCR_D018       = \
        ((ELITE_VIC_MENUSCR & 15) << 4) \
      | (((ELITE_VIC_CHARBMP & 7) << 1) & %00001110)
