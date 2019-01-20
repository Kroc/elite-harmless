	PROCESSOR 6502
	ORG $c800
	jsr exod_decrunch
	rts
exod_get_crunched_byte:
	lda opbase + 1
	bne nowrap
	dec opbase + 2
nowrap:	dec opbase + 1
	;; change the $ffff to point to the byte immediately following the last
	;; byte of the crunched file data (mem command)
opbase:	lda $ffff
	rts
	;; include the decruncher source
	INCLUDE exodecrunch.s
