


; the VIC-II bank, where Elite places graphics (bitmap, sprites)
; it's a 16 KB block of memory selected from these choices:
;
; bank 0 - $0000...$3FFF
; bank 1 - $4000...$7FFF
; bank 2 - $8000...$BFFF
; bank 3 - $C000...$FFFF
;
vic_bank = 1

; the lower two-bits of register $DD00 controls the VIC-II bank
; use this exported value to set the correct VIC-II bank chosen above
; (the binary value is inverted compared to the canonical bank numbers)
.export ELITE_VIC_BANK = ~vic_bank & %00000011
.export ELITE_VIC_ADDR = vic_bank * $4000

; the text screen is relative to the bank adress, above.
; provide a value from 0 to 15:
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
vic_screen = 8

.export ELITE_SCREEN_ADDR := vic_screen * $0400

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

.export ELITE_CHARSET_ADDR = vic_memory * $0800
.export ELITE_BITMAP_ADDR  = ((vic_memory & %0000100) >> 2) * $2000

.export ELITE_D018 = ((vic_screen & 15) << 4) | (((vic_memory & 7) << 1) & %00001110 )

