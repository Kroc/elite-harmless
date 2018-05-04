; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this file is part of "firebird.prg", the first stage in loading

.code

; this to be disassembled soon
.byte   $0b
.byte   $08, $01, $00, $9e, $32, $30, $36, $31
.byte   $00, $00, $00, $a2, $65, $bd, $01, $08
.byte   $9d, $a7, $02, $ca, $10, $f7, $4c, $c4
.byte   $02

filename:
.byte   "gm*"       ; $47, $4D, $2A (PETSCII)

start:
    ; call Kernel SETMSG, "Set system error display switch at
    ; memory address $009D". A = the switch value.
    ; i.e. disable error messages?
    lda # $00
    jsr $ff90

    ; set file parameters:
    lda # $02       ; logical file number
    ldx # $08       ; device number == drive 8
    ldy # $ff       ; "secondary address" (i.e. use the PRG load address)
    jsr $ffba

    ; set file name
    lda # $03       ; length of file name
    ldx #< filename ; pointer to name address (lo)
    ldy #> filename ; pointer to name address (hi)
    jsr $ffbd

    ; load file:
    ; note that the "secondary address" has been set as non-zero,
    ; telling the drive to use the load address present in the PRG file
    lda # $00       ; = LOAD
    jsr $ffd5
    
    ; change the address of STOP key routine from $F6ED,
    ; to $FFED: the SCREEN routine which returns row/col count
    ; i.e. does nothing of use -- this effectively disables the STOP key
    lda # $ff
    sta $0329

.repeat 24
    nop
.endrepeat

    jmp $0334

;===============================================================================

.segment    "VECTORS"

; these are various vectors for BASIC -- the loader hijacks these to cause
; the loader to start immediately withtout the need for a BASIC bootstrap

    ;$0300/1    execution address of warm reset, displaying optional BASIC
    ;           error message and entering BASIC idle loop. default: $E38B
.addr   start
    ;$0302/3    execution address of BASIC idle loop. default: $A483
.addr   start
    ;$0304/5    execution address of BASIC line tokenizater routine.
    ;           default: $A57C
.addr   start
    ;$0306/7    execution address of BASIC token decoder routine.
    ;           default: $A71A
.addr   start
    ;$0308/9    execution address of BASIC instruction executor routine.
    ;           default: $A7E4
.addr   start
    ;$030A/B    execution address of routine reading next item of BASIC
    ;           expression. default: $AE86
.addr   start
