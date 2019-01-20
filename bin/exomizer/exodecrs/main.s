; -------------------------------------------------------------------
; this file is intended to be assembled and linked with the cc65 toolchain.
; It has not been tested with any other assemblers or linkers.
; -------------------------------------------------------------------
; -------------------------------------------------------------------
; example usage of the standard decruncher
; this program decrunches data to memory
; -------------------------------------------------------------------
.import decrunch
.export get_crunched_byte
.import end_of_data

	.byte $01,$08,$0b,$08,<2003,>2003,$9e,'2','0','6','1',0,0,0
; -------------------------------------------------------------------
; we begin here
; -------------------------------------------------------------------
	lda $04
	sta _byte_lo
	lda $05
	sta _byte_hi
	jmp decrunch
; -------------------------------------------------------------------
get_crunched_byte:
	lda _byte_lo
	bne _byte_skip_hi
	dec _byte_hi
_byte_skip_hi:
	dec _byte_lo
_byte_lo = * + 1
_byte_hi = * + 2
	lda $ffff		; needs to be set correctly before
	rts			; decrunch_file is called.
; end_of_data needs to point to the address just after the address
; of the last byte of crunched data.
; -------------------------------------------------------------------
