; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this file is part of "gma3.prg",
; it contains the copy-protection routines

.include        "c64.asm"

.zeropage

; 4 unused (by the Kernal) bytes exist at $FB-$FE
ZP_C1541_MEM            := $fb
ZP_C1541_PROGRAM        := $fd

.code                                                                   ;$C800
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
        jsr KERNAL_CHROUT

        ; specify the memory address in the drive, read from $FB/FC,
        ; set at the top of this routine = $0300. these are the data-buffers
        lda ZP_C1541_MEM+0     
        jsr KERNAL_CHROUT
        lda ZP_C1541_MEM+1
        jsr KERNAL_CHROUT
        ; uploads are done 32-bytes at a time
        ; (the 1541 manual says 32 bytes maximum)
        lda # $20
        jsr KERNAL_CHROUT

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
        jsr KERNAL_CHROUT

        ; move to the next byte
        inc ZP_C1541_PROGRAM+0
        ; has the 8-bit number wrapped?
        bne :+
        ; increase the 16-bit number
        inc ZP_C1541_PROGRAM+1

        ; decrease the remaining bytes counter
        ; and keep looping if it hasn't reached zero yet
:       dex
        bne @upload_bytes
    
        ; close deafult output channel
        jsr KERNAL_CLRCHN

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
        jsr KERNAL_CHROUT
        ; write the drive memory address to execute
        lda #< drive_program_init
        jsr KERNAL_CHROUT
        lda #> drive_program_init
        jsr KERNAL_CHROUT
        ; close deafult output channel
        jsr KERNAL_CLRCHN

        ; wait on the serial bus:
:       bit $dd00
        bmi :-          ; wait for the sign-bit to zero
:       bit $dd00
        bpl :-          ; wait for the sign-bit to set

        rts

_c873:
        ; set the file name. X & Y are taken from the stage 1 loader and set
        ; the pointer to the file name, "gma3", although a file name is not
        ; used yet
        lda # $00               ; no file name length!
        jsr KERNAL_SETNAM       

        ; set file parameters
        lda # $0f               ; open file "15" (any non-zero number would do)
        tay                     ; set Y to open the disk command channel
        ldx # $08               ; drive 8
        jsr KERNAL_SETLFS       ; set file parameters
        jsr KERNAL_OPEN         ; open the command channel

        ; default all output to the disk drive:
        ldx # $0f               ; logical file 15 (as above)
        jsr KERNAL_CHKOUT       ; define the default output

        ; unused byte at $02
        ; -- not used again in this file 
        lda # $97
        sta $02        

        ; send bytes to command drive to access its memory:
        ; the last letter is left off for the caller to specify
        ; "m-w" = memory write, "m-e" = memory execute
        lda # 'm'
        jsr KERNAL_CHROUT
        lda # '-'
        jsr KERNAL_CHROUT

        rts

; this is a program uploaded to the drive:
.proc   drive_program
        ;=======================================================================
        ; address from the perspective of the drive's memory
        .org    $0300

        ; strobe the serial line (why?)
        lda # $0f
        sta $1800
        sta $1800

        lda $1c00           ; read the port B status
        and # %10011111     ; set data density to lowest (why?)
        sta $1c00
        
        ldy # $5a           ; = 90

_0312:  ; countdown for a time-out
        dey
        bne :+

        ; time-out
        lda # $02
        jmp $f969

:       bit $1c00
        bmi :-

        lda $1c01
        clv
        ldx # $04
:       bvc *                   ; infinite loop waiting for CPU overflow flag
                                ; to change to 1
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

:       bit $1c00
        bmi :-
        clv 
        lda $1c01
        ldx # $00

:       bvc *
        clv 
        lda $1c01
        sta $0508, x
        inx 
        bne :-

:       bvc *
        clv 
        lda $1c01
        sta $0608, x
        inx 
        bne :-

        lda # $01
        jmp $f969

init:
        ;-----------------------------------------------------------------------
        jsr $d042       ; initialise drive
    
        ; buffer#0 track no.
        lda # 37
        sta $06
        ; buffer#0 sector no.
        lda # 1
        sta $07

        jsr $c118       ; turn on drive LED
    
        ; * * *   C O P Y   P R O T E C T I O N !  * * *

        ; write to buffer#0 commad/status register:
        ; "Read in sector header and then execute code in buffer"
        ; i.e. look at T37:S01 (outside the normal disk range!), but no data
        ; is loaded. buffer#0 is executed (which contains this drive program)
        ; so execution jumps to the start of `drive_program`
        lda # $e0       
        sta $00

        ; wait for the drive to finish loading:
:       lda $00         ; read the status register
        bmi :-          ; wait for bit 7 to switch to 0, i.e. "job done"
        cmp # $02       ; block header not found on disk?
        bcc :+
        jmp *           ; kill the disk drive!
        jsr $c12c       ; turn on error LED

        ; strobe the serial line to alert
        ; the C64 that we're finished here
:       lda # $00
        sta $1800
        sta $1800
        
        rts 

; note the address of the last byte, as this is used by
; the upload routine to check for the end of the program
init_end:

        ; switch off addressing from the drive's memory
        .reloc
.endproc

; make these available for use before the .proc definition,
; https://github.com/cc65/cc65/issues/479
drive_program_init      := drive_program::init
drive_program_end       := drive_program::init_end