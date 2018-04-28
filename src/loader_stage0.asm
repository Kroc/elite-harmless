
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
    ldy #$FF        ; "secondary address"
    jsr $FFBA

    ; set file name
    lda #$03        ; length of file name
    ldx #<filename   ; pointer to name address (lo)
    ldy #>filename   ; pointer to name address (hi)
    jsr $FFBD

    ; load file:
    ; note that the "secondary address" has been set as non-zero,
    ; telling the drive to use the load address present in the PRG file
    lda #$00        ; = LOAD
    jsr $FFD5
    
    lda #$FF
    sta $0329

.repeat 24
.byte   $EA
.endrepeat

    jmp $0334

.addr   start
.addr   start
.addr   start
.addr   start
.addr   start
.addr   start
