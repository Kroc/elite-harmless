; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "gma5.prg"

; $1D00 +--------+
;       |  VARS  |    variable / scratch space used by Elite
; $1D22 |--------|
;       |  CODE  |    stage 5 decryption routine
; $1D81 |--------|
;       |        |
;       |  DATA  |    encrypted payload
;       |        |
; $3ED5 +--------+

; this is the entry point, jumped to by the stage 1 loader
.export _1d22

.import init_mem:absolute
.import _8863:absolute

; populate the .PRG header using the address given
; by the linker config (see "link/elite-original-gma86.cfg")
.segment        "HEAD_STAGE5"
.import         __GMA5_PRG_START__
        .addr   __GMA5_PRG_START__+2

;-------------------------------------------------------------------------------

.segment        "CODE_GMA5"

        ; another bloody decryption routine
.import ELITE_ZP_SHADOW

_1d22:
        cld                     ; clear decimal mode (why?)

        ; backup zero-page to $ce02-$ceff
        ; -- this was already done by the loader before jumping here 
        ldx # $02
:       lda $00, x
        sta ELITE_ZP_SHADOW, x
        inx 
        bne :-

        ; decrypt the payload from GMA6.PRG
        jsr _1d36

        ; initialise interrupts,
        ; clears $0400..$0700
        jsr init_mem            ;<-- GMA6.PRG; $6A00..$CCE0             ;$1d30

        jmp _8863               ;<-- GMA6.PRG; $6A00..$CCE0

_1d36:                                                                  ;$13d6
        ;-----------------------------------------------------------------------
        ; walks backward through code/data un-scrambling it

        ; decrypt $1D81..$3ED1

        ; set where to stop decryption
        lda #< (_1d81 - 1)
        sta $0452
        lda #> (_1d81 - 1)
        sta $0453

        lda #> $3e00
        ldy # $d1
        ldx # $36
        jsr _1d59

        ; decrypt $6700..$CCD6

        lda #< $69ff
        sta $0452
        lda #> $69ff
        sta $0453

        lda #> $ccd6
        ldy #< $ccd6
        ldx # $49

.proc   _1d59
        ;=======================================================================
        ; A = high-byte of address
        ; Y = index into address

        stx $bb

        sta $08
        lda # $00
        sta $07
_1d61:
        lda [$07], y
        sec 
        sbc $bb
        sta [$07], y
        sta $bb
        tya 
        bne _1d6f
        dec $08
_1d6f:  dey 
        cpy $0452
        bne _1d61
        lda $08
        cmp $0453
        bne _1d61

        rts
.endproc

_1d7d:
        .byte   $b7, $aa, $45, $23

_1d81:
.export _1d81

;$3ED5

;===============================================================================

.segment        "JUNK_GMA5"

        ; trailing, un-ecrypted bytes
        .byte   $00, $ff, $00