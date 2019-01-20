; -------------------------------------------------------------------
; this file is intended to be assembled and linked with the cc65 toolchain.
; It has not been tested with any other assemblers or linkers.
; -------------------------------------------------------------------
; -------------------------------------------------------------------
; example usage of Krill's forward decruncher
; this program will just decrunch some data to memory and print
; the amount of time it took.
; -------------------------------------------------------------------
.import decrunch
.export get_crunched_byte

	.byte $01,$08,$0b,$08,<2003,>2003,$9e,'2','0','6','1',0,0,0
; -------------------------------------------------------------------
; we begin here
; -------------------------------------------------------------------
	lda $02
	sta _byte_lo
	lda $03
	sta _byte_hi
	jmp decrunch
; -------------------------------------------------------------------
get_crunched_byte:
_byte_lo = * + 1
_byte_hi = * + 2
	lda $ffff		; needs to be set correctly before
				; decrunch_file is called.
	inc _byte_lo
	bne _byte_skip_hi
	inc _byte_hi
_byte_skip_hi:
	rts
; end_of_data needs to point to the address just after the address
; of the last byte of crunched data.
; -------------------------------------------------------------------
