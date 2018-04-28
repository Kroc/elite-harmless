
; this to be disassembled soon
.byte   $0B
.byte   $08, $01, $00, $9E, $32, $30, $36, $31
.byte   $00, $00, $00, $A2, $65, $BD, $01, $08
.byte   $9D, $A7, $02, $CA, $10, $F7, $4C, $C4
.byte   $02

filename:
.byte   "GM*"       ; $47, $4D, $2A (PETSCII)

start:
    ; call Kernel SETMSG, "Set system error display switch at
    ; memory address $009D". A = the switch value.
    ; i.e. disable error messages?
    lda #$00
    jsr $FF90

    ; set file parameters:
    lda #$02        ; logical file number
    ldx #$08        ; device number == drive 8
    ldy #$FF        ; "secondary address" (i.e. use the PRG load address)
    jsr $FFBA

    ; set file name
    lda #$03        ; length of file name
    ldx #<filename  ; pointer to name address (lo)
    ldy #>filename  ; pointer to name address (hi)
    jsr $FFBD

    ; load file:
    ; note that the "secondary address" has been set as non-zero,
    ; telling the drive to use the load address present in the PRG file
    lda #$00        ; = LOAD
    jsr $FFD5
    
    ; change the address of STOP key routine from $F6ED,
    ; to $FFED: the SCREEN routine which returns row/col count
    ; i.e. does nothing of use -- this effectively disables the STOP key
    lda #$FF
    sta $0329

.repeat 24
.byte   $EA
.endrepeat

    jmp $0334

; these are various vectors for BASIC -- the loader hijacks these to cause
; the loader to start immediately withtout the need for a BASIC bootstrap
basic_vectors:
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
