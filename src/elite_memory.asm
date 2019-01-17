; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; the VIC-II bank, where Elite places graphics (bitmap, sprites)
; it's a 16 KB block of memory selected from these choices:
;
; bank 0 - $0000...$3FFF
; bank 1 - $4000...$7FFF
; bank 2 - $8000...$BFFF
; bank 3 - $C000...$FFFF
;
vic_bank = 1

; the lower two-bits of register $DD00 controls the VIC-II bank.
; use this exported value to set the correct VIC-II bank chosen above
; (the binary value is inverted compared to the canonical bank numbers)
; you should retain the top 6 bits, e.g.:
;
;       lda $dd00               ; read the serial bus / VIC-II bank state
;       and # %11111100         ; keep current value except bits 0-1 (VIC bank)
;       ora # ELITE_VIC_DD00    ; set bits for the VIC-II bank
;       sta $dd00
;
.export ELITE_VIC_DD00 :direct   = ~vic_bank & %00000011
.export ELITE_VIC_ADDR :absolute = vic_bank * $4000

; the VIC-II uses a 1 KB block of RAM for the text-screen (40x25 = 1'000 bytes)
; or, in the case of high-resolution bitmap mode, colour-cell information where
; each byte represents the fore/back colour (two nybbles) for each 8x8 cell.
;
; elite uses two game screens -- a main-screen (flight) and a menu-screen
; (such as when docked). the flight-screen switches from high-resolution bitmap
; mode to multi-colour bitmap mode for the HUD at the bottom of the screen
; -- it's important to note that the way high-resolution and multi-colour
; bitmap modes store colour is _very_ different
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
elite_menuscr_vic = 8
elite_mainscr_vic = 9

.export ELITE_MENUSCR_COLOR_ADDR :absolute \
        = ELITE_VIC_ADDR + elite_menuscr_vic * $0400
.export ELITE_MAINSCR_COLOR_ADDR :absolute \
        = ELITE_VIC_ADDR + elite_mainscr_vic * $0400

; the upper bits of register $D018 select the location of the character set,
; or the bitmap screen (if enabled). Again, note that this is relative to the
; chosen VIC-II bank above
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
vic_memory = 0

.export ELITE_BITMAP_ADDR :absolute \
        = ELITE_VIC_ADDR + ((vic_memory & %0000100) >> 2) * $2000

;;.out .sprintf("%s%04x", ": ELITE_BITMAP_ADDR        = $", ELITE_BITMAP_ADDR)
;;.out .sprintf("%s%04x", ": ELITE_MAINSCR_COLOR_ADDR = $", ELITE_MAINSCR_COLOR_ADDR)
;;.out .sprintf("%s%04x", ": ELITE_MENUSCR_COLOR_ADDR = $", ELITE_MENUSCR_COLOR_ADDR)

.export ELITE_BITMAP_D018 :direct \
        = ((elite_menuscr_vic & 15) << 4) | (((vic_memory & 7) << 1) & %00001110)
.export ELITE_TXTSCR_D018 :direct \
        = ((elite_menuscr_vic & 15) << 4) | (((vic_memory & 7) << 1) & %00001110)