; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; "stage5.asm":
;
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


.segment        "HEAD_STAGE5"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; populate the .PRG header using the address given
; by the linker config (see "link/elite-original-gma86.cfg")
;
.import         __GMA5_PRG_START__
        .addr   __GMA5_PRG_START__+2


.segment        "CODE_GMA5"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.import ELITE_ZP_SHADOW
.import init_mem:absolute
.import _8863:absolute

; another bloody decryption routine
;
_1d22:                                                                  ;$1D22
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
        jsr init_mem            ;<-- GMA6.PRG; $6A00..$CCE0             ;$1D30

        jmp _8863               ;<-- GMA6.PRG; $6A00..$CCE0

_1d36:                                                                  ;$13D6
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

.proc   _1d59                                                           ;$1D59
        ;=======================================================================
        ; A = high-byte of address
        ; Y = index into address

        stx $bb

        sta $08
        lda # $00
        sta $07
_1d61:                                                                  ;$1D61
        lda [$07], y
        sec 
        sbc $bb
        sta [$07], y
        sta $bb
        tya 
        bne _1d6f
        dec $08
_1d6f:  dey                                                             ;$1D6F
        cpy $0452
        bne _1d61
        lda $08
        cmp $0453
        bne _1d61

        rts
.endproc

_1d7d:                                                                  ;$1D7D
        .byte   $b7, $aa, $45, $23

_1d81:                                                                  ;$1D81
.export _1d81


.segment        "JUNK_GMA5"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        ; trailing, un-ecrypted bytes
        .byte   $00, $ff, $00                                           ;$3ED5