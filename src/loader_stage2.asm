
.zeropage
; 4 unused (by the Kernal) bytes exist at $FB-$FE
ZP_C1541_MEM       := $fb
ZP_C1541_PROGRAM   := $fd

;$C800:
.code
    ; save a pointer for a memory address inside the drive
    lda #< $0300
    sta ZP_C1541_MEM+0
    lda #> $0300
    sta ZP_C1541_MEM+1

    lda #< drive_program
    sta ZP_C1541_PROGRAM+0
    lda #> drive_program
    sta ZP_C1541_PROGRAM+1

@upload_block:
    ; open the disk command channel for memory-access
    ; i.e. we're going to upload a program to the 1541
    jsr _c873

    ; add the "w" to the disk command to specify memory-write
    lda # 'w'
    jsr $ffd2

    ; specify the memory address in the drive, read from $FB/FC,
    ; set at the top of this routine = $0300. these are the data-buffers
    lda ZP_C1541_MEM+0     
    jsr $ffd2
    lda ZP_C1541_MEM+1
    jsr $ffd2
    ; uploads are done 32-bytes at a time
    ; (the 1541 manual says 32 bytes maximum)
    lda # $20
    jsr $ffd2

    ; set a countdown for writing the bytes out
    ldx # $20
    ldy # $00

    ; add 32-bytes to the pointer
    ; (move it ahead for the next upload)
    clc
    lda ZP_C1541_MEM+0
    adc # $20
    sta ZP_C1541_MEM+0
    lda # $00
    adc ZP_C1541_MEM+1
    sta ZP_C1541_MEM+1

@upload_bytes:
    ; read a byte from the program (via pointer)
    ; and send to the drive
    lda (ZP_C1541_PROGRAM+0), y
    jsr $ffd2

    ; move to the next byte
    inc ZP_C1541_PROGRAM+0
    ; has the 8-bit number wrapped?
    bne :+
    ; increase the 16-bit number
    inc ZP_C1541_PROGRAM+1

    ; decrease the remaining bytes counter
    ; and keep looping if it hasn't reached zero yet
:   dex
    bne @upload_bytes
    
    ; close deafult output channel
    jsr $ffcc

    ; have we reached the end of the program?
    lda ZP_C1541_MEM+0
    cmp #< drive_program_end
    lda ZP_C1541_MEM+1
    sbc #> drive_program_end
    bcc @upload_block

    ; re-open the command channel
    jsr _c873
    ; add an E to the command ("M-E"), for Memory-Execute
    lda #'e'
    jsr $ffd2
    ; write the drive memory address to execute
    lda #< drive_program_init
    jsr $ffd2
    lda #> drive_program_init
    jsr $ffd2
    ; close deafult output channel
    jsr $ffcc

:   bit $dd00
    bmi :-
:   bit $dd00
    bpl :-

    rts

_c873:
    ; set the file name. X & Y are taken from the stage 1 loader and set the
    ; pointer to the file name, "gma3", although a file name is not used yet
    lda # $00       ; no file name length!
    jsr $ffbd       

    ; set file parameters
    lda # $0f       ; open file "15" (any non-zero number would do)
    tay             ; set Y to open the disk command channel
    ldx # $08       ; drive 8
    jsr $ffba       ; set file parameters
    jsr $ffc0       ; open the command channel

    ; default all output to the disk drive:
    ldx # $0f       ; logical file 15 (as above)
    jsr $ffc9       ; CHKOUT - define the default output

    ; unused byte at $02
    ; -- not used again in this file 
    lda # $97
    sta $02        

    ; send bytes to command drive to access its memory:
    ; the last letter is left off for the caller to specify
    ; "m-w" = memory write, "m-e" = memory execute
    lda #'m'
    jsr $ffd2
    lda #'-'
    jsr $ffd2

    rts

;===============================================================================
; address from the perspective of the drive's memory
.org    $0300

; this is a program uploaded to the drive:
.proc   drive_program

    lda # $0f
    sta $1800
    sta $1800
    lda $1c00
    and # $9f
    sta $1c00
    ldy # $5a

_0312:
    dey
    bne :+
    lda # $02
    jmp $f969

:   bit $1c00
    bmi :-

    lda $1c01
    clv
    ldx # $04
:   bvc *       ; infinite loop waiting for CPU overflow flag to change to 1
    clv

    lda $1c01
    sta $0500, x
    dex
    bpl :-

    cmp # $69
    bne _0312

    lda $0501
    cmp # $a9
    bne _0312

:   bit $1c00
    bmi :-
    clv 
    lda $1c01
    ldx # $00

:   bvc *
    clv 
    lda $1c01
    sta $0508, x
    inx 
    bne :-

:   bvc *
    clv 
    lda $1c01
    sta $0608, x
    inx 
    bne :-

    lda # $01
    jmp $f969

init:
    jsr $d042       ; initialise drive
    lda # $25
    sta $06
    lda # $01
    sta $07
    jsr $c118
    lda # $e0
    sta $00

:   lda $00
    bmi :-
    cmp # $02
    bcc :+
    jmp $037e
    jsr $c12c       ; turn on error LED
:   lda # $00
    sta $1800
    sta $1800
    rts 

; note the address of the last byte, as this is used by
; the upload routine to check for the end of the program
end:

.endproc
; make these available for use before the .proc definition,
; https://github.com/cc65/cc65/issues/479
drive_program_init  := drive_program::init
drive_program_end   := drive_program::end

; switch off addressing from the drive's memory
.reloc