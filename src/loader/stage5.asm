; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; "gma5.prg"

; this is the entry point, jumped to by the stage 1 loader
.export _1d22


.import _aab2:absolute
.import _8863:absolute

;-------------------------------------------------------------------------------

.segment        "LOADER_STAGE5"

        ; another bloody decryption routine
        
_1d22:
        cld                     ; clear decimal mode (why?)

        ; backup zero-page to $ce02-$ceff
        ; -- this was already done by the loader before jumping here 
        ldx # $02
:       lda $00, x
        sta $ce00, x
        inx 
        bne :-

        ; decrypt the payload from GMA6.PRG
        jsr _1d36

        jsr _aab2               ;<-- GMA6.PRG; $6A00..$CCE0             ;$1d30

        jmp _8863               ;<-- GMA6.PRG; $6A00..$CCE0

_1d36:                                                                  ;$13d6
        ;-----------------------------------------------------------------------
        ; walks backward through code/data un-scrambling it

        ; decrypt $1D80..$3ED1

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
        lda ($07), y
        sec 
        sbc $bb
        sta ($07), y
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

;-------------------------------------------------------------------------------

_1d7d:
        .byte   $b7, $aa, $45, $23

_1d81:
.export _1d81

;$3ED5
.code