; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.ifdef      FEATURE_AUDIO
;;      .out  "audio enabled"
.endif
.ifdef      OPTION_MATHTABLES
;;      .out  "math-tables enabled"
.endif
.ifdef      OPTION_DYME_FASTLINE
;;      .out  "fast-lines enabled"
.endif

;===============================================================================
; this is the main include file for common definitions for Elite, that is,
; constants, macros and the like that do not immediately output bytes

.include        "c64/c64.inc"           ; define C64 constants
.include        "text/text.inc"         ; text/string constants

; the linker script ("link/elite-*.cfg") defines the memory layout of the game
; (since it will differ from the original, disk and cartridge versions) so we
; import some memory addresses from there and use these to configure the C64

; the bitmap is the largest portion of memory at 8K
.import ELITE_BITMAP_ADDR

; the VIC-II bank, where Elite places graphics (bitmap, sprites)
; it's a 16 KB block of memory selected from these choices:
;
; bank 0 - $0000...$3FFF        (conflict with CHARROM)
; bank 1 - $4000...$7FFF
; bank 2 - $8000...$BFFF        (conflict with CHARROM)
; bank 3 - $C000...$FFFF
;
; we can caluclate this value from the bitmap address given by the linker
; 
ELITE_VIC_BANK          = .vic_bank_from_bitmap( ELITE_BITMAP_ADDR )
ELITE_VIC_ADDR          = ELITE_VIC_BANK * $4000

; the VIC-II uses a 1 KB block of RAM for the text-screen (40x25 = 1'000 bytes)
; or, in the case of high-resolution bitmap mode, colour-cell information where
; each byte represents the fore/back colour (two nybbles) for each 8x8 cell
;
; Elite uses two game screens: a main-screen (flight) and a menu-screen (such
; as when docked). the flight-screen switches from high-resolution bitmap mode
; to multi-colour bitmap mode for the HUD at the bottom of the screen -- it's
; important to note that the way high-resolution and multi-colour bitmap modes
; store colour is _very_ different
;
.import ELITE_MENUSCR_ADDR
.import ELITE_MAINSCR_ADDR


ELITE_VIC_LAYOUT_MAINSCR := \
     <( (((ELITE_MAINSCR_ADDR .mod $4000) / $0400) << 4) \
      |  ((ELITE_BITMAP_ADDR .mod $4000) >> 10) \
      | vic_layout::unused \
      )

ELITE_VIC_LAYOUT_MENUSCR := \
     <( (((ELITE_MENUSCR_ADDR .mod $4000) / $0400) << 4) \
      |  ((ELITE_BITMAP_ADDR .mod $4000) >> 10) \
      | vic_layout::unused \
      )

.import ELITE_SPRITES_ADDR

; defines the first sprite index
; (offset from ELITE_VIC_ADDR, divided by 64)
ELITE_SPRITES_INDEX     = <((ELITE_SPRITES_ADDR - ELITE_VIC_ADDR) / 64)

; get the address of the bitmap font from the linker
.import ELITE_FONT_ADDR

.import ELITE_ZP_SHADOW
.import ELITE_DISK_BUFFER
.import ELITE_HEAP_TOP

;===============================================================================
; some core, structual values used throughout Elite, often tied directly
; to the structure of the source code -- CHANGING ANY OF THESE IS ALMOST
; CERTAINLY GOING TO RENDER THE GAME INOPERABLE

.define ELITE_SEED      $5a4a, $0248, $b753

; the BBC micro used a 256-px wide screen mode, but the C64 has a 320-px wide
; screen. therefore the C64 only draws in a 256-px wide centered 'screen'.
; the dimensions of this viewport are given here:
;
; (DON'T change this, the code is inextricably tied to this size)
;
ELITE_VIEWPORT_WIDTH    = 256
ELITE_VIEWPORT_HEIGHT   = 144

ELITE_VIEWPORT_COLS     = ELITE_VIEWPORT_WIDTH / 8      ;=32
ELITE_VIEWPORT_ROWS     = ELITE_VIEWPORT_HEIGHT / 8     ;=18

; the HUD occupies 7 lines at the bottom of the screen; this fact is used in
; a wide variety of calculations and implicit values in non-obvious ways
;
ELITE_HUD_HEIGHT_ROWS   = 7
ELITE_HUD_TOP_ROW       = 25 - ELITE_HUD_HEIGHT_ROWS
