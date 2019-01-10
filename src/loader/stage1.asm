; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "stage1.asm" -- this could be considered the 'main' part of the loading
; process as it displays the fastload option and orchestrates the loading /
; decryption of the other modules

.include        "c64.asm"
.include        "c1541.asm"

;===============================================================================
; populate the "GMA1.PRG" header using the address given
; by the linker config (see "link/elite-original-gma86.cfg")

.segment        "HEAD_STAGE1"
.import         __GMA1_PRG_START__
        .addr   __GMA1_PRG_START__+2

;===============================================================================

.segment        "CODE_STAGE1A"

; eight bytes of unused (by the Kernal) RAM exist at $0334, followed by
; the 192 byte Datasette buffer (no use to us here), another 4 unused bytes
; and then the text screen. since the text screen gets moved to $0800,
; this gives us plenty of space in low-memory for the loader

        jmp     gma1_start                                              ;$0334

gma_trksec:                                                             ;$0337
        ; track & sector numbers (for the fast-loader)

        .byte   0,  0           ; "GMA0" (invalid)
        .byte   0,  0           ; "GMA1" (invalid)
        .byte   17, 4           ; "GMA2" (invalid)
        .byte   17, 5           ; "GMA3"
        .byte   17, 6           ; "GMA4"
        .byte   19, 0           ; "GMA5"
        .byte   20, 8           ; "GMA6"

gma1_start:                                                             ;$0345
        ; call Kernel SETMSG, "Set system error display switch at
        ; memory address $009D". A = the switch value.
        ; i.e. disable error messages?
        lda # $00
        jsr KERNAL_SETMSG

        ; change the address of STOP key routine from $F6ED,
        ; to $FFED: the SCREEN routine which returns row/col count
        ; i.e. does nothing of use -- this effectively disables the STOP key
        lda #> KERNAL_SCREEN
        sta $0329

        ; set up the screen, display the "use the fast loader?" message.
        ; if fast-loader is selected, control will have gone to `_03fc`,
        ; if slow-loader is selected, we will have returned here
        jsr _062b

        ; * * *   C O P Y   P R O T E C T I O N !  * * *

        ; load "GMA3" file
        lda # $03
        jsr _03b5

.ifdef  OPTION_NOCOPY
        ; start GMA3's code -- note that the current X & Y
        ; (pointer to filename) are re-used in here
.import __CODE_STAGE3_START__:absolute
        jsr __CODE_STAGE3_START__
.else
        ; "crack" the loader by jumping over the copy-protection check
        jmp :+
.endif

        ; is the value at $02 exactly $97?
        ; (i.e. the result of copy-protection check?)
        lda $02
        eor # $97
        beq :+                  ; skip ahead if [$02] = $97
        jmp [$fffc]             ; hard reset!

        ; * * * * * *

        ; load "GMA4" file
:       lda # $04
        jsr _03b5

        jsr KERNAL_SCINIT       ; re-init the screen again

        ; change background / border colour to red
        lda # RED
        sta VIC_BORDER
        sta VIC_BACKGROUND
    
        ; change the text-screen back to $0400:
        lda #> $0400
        sta $0288

        ; change code somewhere?
        lda # $4c
        sta $ce0e
        lda #< _038a
        sta $ce0f
        lda #> _038a
        sta $ce10

        ; jump into the stage 4 loader ("GMA4.PRG")
.import _7596:absolute
        jmp _7596

        ;-----------------------------------------------------------------------
        ; after GMA4's post-decrypt code, we jump here!

_038a:  clc 
        jsr _0619
        
        lda CPU_CONTROL         ; read the processor port
        and # %11111000         ; unset the bottom three bits
        ora # %00101110         ; KERNAL ROM on / turn off the datasette!?
        sta CPU_CONTROL
        
        ; load "gma5.prg"
        lda # $05
        jsr _03b5

        ; load "gma6.prg"
        lda # $06
        jsr _03b5
        
        lda CPU_CONTROL
        and # %11111000
        ora # MEM_IO_KERNAL     ; I/O & KERNAL ROM on
        sta CPU_CONTROL

        sec 
        jsr _0619

        jsr KERNAL_RESTOR       ; restore the vector table ($0314-$0333)
        jsr KERNAL_CLALL        ; close all open files

        ; jump into the stage 5 loader ("GMA5.PRG")
        ; -- another decryption routine follows that unscrambles
        ;    the payload in GAM6.PRG
.import _1d22:absolute
        jmp _1d22

_03b5:                                                                  ;$03B5
        ;-----------------------------------------------------------------------
        ; select the filename
        jsr _03c7

        ; set file parameters:
        lda # $01       ; file number
        ldx # $08       ; drive number
        ldy # $01       ; "secondary address"
        jsr KERNAL_SETLFS

        ; load file from disk:
        lda # $00
        jsr KERNAL_LOAD
    
        rts

_03c7:                                                                  ;$03C7
        ;-----------------------------------------------------------------------
        ; select file name:
        ;
        ;     A = number of file to load, i.e. $03 = "GMA3"
        ;
        tax                 ; put the current A value aside

        clc                 ; clear carry flag (before doing add)
        adc # '0'           ; convert A to a PETSCII numeral, i.e. "0"+A
        sta _filename_num   ; change the filename to load, e.g. "GMA3"
        
        ; for the fast-loader, find the track / sector:

        txa                 ; get the original file number back
        asl                 ; shift-left, i.e. multiply by 2
        tax                 ; use it as the index

        ; get the address of the block of 1541 code *here on the C64*
        ; (not its address within the 1541, when it gets copied there)
.import __CODE_1541_LOAD__
.import __CODE_1541_RUN__

        ; MODIFY THE 1541 PROGRAM, HERE ON THE C64,
        ; BEFORE IT GETS SENT TO THE 1541 DRIVE!

        ; write the track and sector to the fast-loader code:
        lda gma_trksec+0, x     ; track
        sta __CODE_1541_LOAD__ + (_04b9 - __CODE_1541_RUN__)
        lda gma_trksec+1, x     ; sector
        sta __CODE_1541_LOAD__ + (_04bd - __CODE_1541_RUN__)

        ; set file name
        ldx #< _filename
        ldy #> _filename
        lda # $04           ; file name length
        jsr KERNAL_SETNAM
        rts 

_filename:
        .byte   "gma"
_filename_num:
        .byte   " "

        ;$03EB: hidden message (not part of the filename)
        .byte   " was here 1985 ok"

_03fc:
        ;=======================================================================
        ; fast-loader:
        ; (to be decompiled later)

        jsr _05da
        jsr _05cf
        rts 

;===============================================================================

.segment        "CODE_1541"

_0403:
        ;=======================================================================
        ; change buffer to $0600
        lda #> C1541_BUFF3
        sta C1541_ZP_CURBUFF_HI

        ; read 256 bytes?
_0407:
        ; "find start of data block"?
        jsr $f50a
_040a:
        bvc *                   ; wait for completion
        clv                     ; clear overflow flag

        lda $1c01
        sta C1541_BUFF3, y
        iny 
        bne _040a

        ldy # $ba
_0418:
        bvc *
        clv 

        lda $1c01
        sta $0100, y
        iny 
        bne _0418
        
        ; decode GCR bytes
        .byte   $20, $e0, $f8   ;0424 20 e0 f8 jsr $f8e0
        .byte   $a5, $38        ;0427 a5 38    lda $38
        .byte   $c5, $47        ;0429 c5 47    cmp $47
        .byte   $f0, $04        ;042b f0 04    beq _0431
        .byte   $a9, $04        ;042d a9 04    lda # $04
        .byte   $d0, $3f        ;042f d0 3f    bne _0470
_0431:
        .byte   $20, $e9, $f5   ;0431 20 e9 f5 jsr $f5e9
        .byte   $c5, $3a        ;0434 c5 3a    cmp $3a
        .byte   $f0, $04        ;0436 f0 04    beq _043c
        .byte   $a9, $05        ;0438 a9 05    lda # $05
        .byte   $d0, $34        ;043a d0 34    bne _0470
_043c:
        .byte   $ad, $01, $06   ;043c ad 01 06 lda $0601
        .byte   $85, $07        ;043f 85 07    sta $07
        .byte   $a0, $02        ;0441 a0 02    ldy # $02
        .byte   $a2, $ff        ;0443 a2 ff    ldx # $ff
        .byte   $ad, $00, $06   ;0445 ad 00 06 lda C1541_BUFF3
        .byte   $f0, $03        ;0448 f0 03    beq _044d
        .byte   $8e, $01, $06   ;044a 8e 01 06 stx C1541_BUFF3+1
_044d:
        .byte   $ee, $01, $06   ;044d ee 01 06 inc C1541_BUFF3+1
_0450:
        .byte   $be, $00, $06   ;0450 be 00 06 ldx C1541_BUFF3, y
        .byte   $e0, $01        ;0453 e0 01    cpx # $01
        .byte   $d0, $03        ;0455 d0 03    bne _045a
        .byte   $20, $82, $03   ;0457 20 82 03 jsr _0485
_045a:
        .byte   $20, $82, $03   ;045a 20 82 03 jsr _0485
        .byte   $c8             ;045d c8       iny 
        .byte   $cc, $01, $06   ;045e cc 01 06 cpy C1541_BUFF3+1
        .byte   $d0, $ed        ;0461 d0 ed    bne _0450
        .byte   $ad, $00, $06   ;0463 ad 00 06 lda C1541_BUFF3
        .byte   $f0, $0e        ;0466 f0 0e    beq _0476
        .byte   $c5, $06        ;0468 c5 06    cmp $06
        .byte   $85, $06        ;046a 85 06    sta $06
        .byte   $f0, $05        ;046c f0 05    beq _0473
        .byte   $a9, $01        ;046e a9 01    lda # $01
_0470:
        .byte   $4c, $69, $f9   ;0470 4c 69 f9 jmp $f969

_0473:
        .byte   $4c, $04, $03   ;0473 4c 04 03 jmp _0407

_0476:
        .byte   $a2, $01        ;0476 a2 01    ldx # $01
        .byte   $20, $82, $03   ;0478 20 82 03 jsr _0485
        .byte   $a2, $02        ;047b a2 02    ldx # $02
        .byte   $20, $82, $03   ;047d 20 82 03 jsr _0485
        .byte   $a9, $7f        ;0480 a9 7f    lda # $7f
        .byte   $4c, $69, $f9   ;0482 4c 69 f9 jmp $f969
_0485:
        .byte   $2c, $00, $18   ;0485 2c 00 18 bit $1800
        .byte   $10, $fb        ;0488 10 fb    bpl _0485
        .byte   $a9, $10        ;048a a9 10    lda # $10
        .byte   $8d, $00, $18   ;048c 8d 00 18 sta $1800
_048f:
        .byte   $2c, $00, $18   ;048f 2c 00 18 bit $1800
        .byte   $30, $fb        ;0492 30 fb    bmi _048f
        .byte   $8a             ;0494 8a       txa 
        .byte   $4a             ;0495 4a       lsr a
        .byte   $4a             ;0496 4a       lsr a
        .byte   $4a             ;0497 4a       lsr a
        .byte   $4a             ;0498 4a       lsr a
        .byte   $8d, $00, $18   ;0499 8d 00 18 sta $1800
        .byte   $0a             ;049c 0a       asl a
        .byte   $29, $0f        ;049d 29 0f    and # $0f
        .byte   $8d, $00, $18   ;049f 8d 00 18 sta $1800
        .byte   $8a             ;04a2 8a       txa 
        .byte   $29, $0f        ;04a3 29 0f    and # $0f
        .byte   $8d, $00, $18   ;04a5 8d 00 18 sta $1800
        .byte   $0a             ;04a8 0a       asl a
        .byte   $29, $0f        ;04a9 29 0f    and # $0f
        .byte   $8d, $00, $18   ;04ab 8d 00 18 sta $1800
        .byte   $a9, $0f        ;04ae a9 0f    lda # $0f
        .byte   $ea             ;04b0 ea       nop 
        .byte   $8d, $00, $18   ;04b1 8d 00 18 sta $1800
        .byte   $60             ;04b4 60       rts 

_04b5:
        ;=======================================================================
        ; this is where program execution begins

        jsr $d042               ;load BAM

        ; set track and sector

        .byte   $a9             ;04b8 a9 ff    lda # $ff
_04b9:  .byte   $ff

        sta C1541_ZP_BUFF0_TRK
        
        .byte   $a9             ;04bc a9 ff    lda # $ff
_04bd:  .byte   $ff

        sta C1541_ZP_BUFF0_SEC
_04c0:
        lda # C1541_JOB::EXECUTE
        sta C1541_ZP_JOB0

        ; wait for the job to complete
:       lda C1541_ZP_JOB0                                               ;$04C4
        bmi :-

        ;-----------------------------------------------------------------------

        cmp # $7f
        beq _04ce
        bcc _04c0
_04ce:
        jmp $d048               ; ; re-read BAM!??

;===============================================================================

.segment        "CODE_STAGE1B"

_04d1:
        .byte   $a5, $a4        ;04d1 a5 a4    lda %10100100    ;=$A4
        .byte   $8d, $00, $dd   ;04d3 8d 00 dd sta CIA2_PORTA
_04d6:
        .byte   $ad, $00, $dd   ;04d6 ad 00 dd lda CIA2_PORTA
        .byte   $10, $fb        ;04d9 10 fb    bpl _04d6
_04db:
        .byte   $ad, $12, $d0   ;04db ad 12 d0 lda VIC_RASTER
        .byte   $c9, $31        ;04de c9 31    cmp # $31
        .byte   $90, $06        ;04e0 90 06    bcc _04e8
        .byte   $29, $06        ;04e2 29 06    and # $06
        .byte   $c9, $02        ;04e4 c9 02    cmp # $02
        .byte   $f0, $f3        ;04e6 f0 f3    beq _04db
_04e8:
        .byte   $a5, $a5        ;04e8 a5 a5    lda $a5
        .byte   $8d, $00, $dd   ;04ea 8d 00 dd sta CIA2_PORTA
        .byte   $ea             ;04ed ea       nop 
        .byte   $ea             ;04ee ea       nop 
        .byte   $ea             ;04ef ea       nop 
        .byte   $ea             ;04f0 ea       nop 
        .byte   $ea             ;04f1 ea       nop 
        .byte   $ea             ;04f2 ea       nop 
        .byte   $ea             ;04f3 ea       nop 
        .byte   $ea             ;04f4 ea       nop 
        .byte   $ea             ;04f5 ea       nop 
        .byte   $ea             ;04f6 ea       nop 
        .byte   $ae, $00, $dd   ;04f7 ae 00 dd ldx CIA2_PORTA
        .byte   $bd, $00, $cf   ;04fa bd 00 cf lda $cf00, x
        .byte   $ae, $00, $dd   ;04fd ae 00 dd ldx CIA2_PORTA
        .byte   $1d, $08, $cf   ;0500 1d 08 cf ora $cf08, x
        .byte   $ae, $00, $dd   ;0503 ae 00 dd ldx CIA2_PORTA
        .byte   $1d, $10, $cf   ;0506 1d 10 cf ora $cf10, x
        .byte   $ae, $00, $dd   ;0509 ae 00 dd ldx CIA2_PORTA
        .byte   $1d, $18, $cf   ;050c 1d 18 cf ora $cf18, x
        .byte   $60             ;050f 60       rts 

        ;=======================================================================
        ; hijack of the KERNAL `LOAD` routine
        ;
_0510:
        lda #< C1541_BUFF0      ; low-byte of write address in 1541 RAM
        sta $a4                 ; byte-buffer for serial communication  
_0514:
        ; open the disk-drive command-channel; begin a command with "M-"
        ; (memory "R" read / "W" write / "E" execute)
        jsr _05a4

        ; append the "W" to make a Memory-Write command
        lda # 'w'
        jsr $eddd               ;=KERNAL_IECOUT
        
        ; set the write-address within 1541 RAM
        lda $a4
        jsr $eddd               ;=KERNAL_IECOUT
        lda #> C1541_BUFF0
        jsr $eddd               ;=KERNAL_IECOUT
        
        ; "sending 32-bytes"
        lda # 32
        jsr $eddd               ;=KERNAL_IECOUT

        ; move the write cursor forward 32-bytes
        ldy $a4
        clc 
        lda $a4
        adc # 32
        sta $a4

_0534:
        ; send the code to the 1541 drive:
        ; get the address of the block of 1541 code *here on the C64*
        ; (not its address within the 1541, when it gets copied there)
.import __CODE_1541_LOAD__
        ; read a byte of program code
        lda __CODE_1541_LOAD__, y
        jsr $eddd               ;=KERNAL_IECOUT
        iny 
        cpy $a4
        bne _0534

        ; close the command-channel,
        ; reset default output to screen
        jsr KERNAL_CLRCHN

        ; have we reached the end of the 1541 code?
        lda $a4
        cmp # $ce
        bcc _0514

        ; open the command channel again
        jsr _05a4
        ; start a memory-exexute command
        lda # 'e'
        jsr $eddd               ;=KERNAL_IECOUT

        ; send the address (lo-hi) to execute inside the 1541.
        ; the code inside the 1541 will begin executing independently!
        lda #< $03b2            ;=$04B5 here
        jsr $eddd               ;=KERNAL_IECOUT
        lda #> $03b2            ;=$04B5 here
        jsr $eddd               ;=KERNAL_IECOUT

        ; close the command-channel
        jsr KERNAL_CLRCHN

        ; query the serial port; this will signal to the 1541's code that
        ; the C64 is ready?
        .byte   $ad, $00, $dd   ;055d ad 00 dd lda $dd00
        .byte   $29, $07        ;0560 29 07    and # $07
        .byte   $85, $a5        ;0562 85 a5    sta $a5
        .byte   $09, $08        ;0564 09 08    ora # $08
        .byte   $85, $a4        ;0566 85 a4    sta $a4
        .byte   $78             ;0568 78       sei 
        .byte   $20, $c4, $05   ;0569 20 c4 05 jsr _05c4
        .byte   $a0, $00        ;056c a0 00    ldy # $00
_056e:
        .byte   $20, $f5, $05   ;056e 20 f5 05 jsr _05f5
        .byte   $20, $d1, $04   ;0571 20 d1 04 jsr _04d1
        .byte   $c9, $01        ;0574 c9 01    cmp # $01
        .byte   $d0, $07        ;0576 d0 07    bne _057f
        .byte   $20, $d1, $04   ;0578 20 d1 04 jsr _04d1
        .byte   $c9, $01        ;057b c9 01    cmp # $01
        .byte   $d0, $09        ;057d d0 09    bne _0588
_057f:
        .byte   $91, $ae        ;057f 91 ae    sta [$ae], y
        .byte   $c8             ;0581 c8       iny 
        .byte   $d0, $ea        ;0582 d0 ea    bne _056e
        .byte   $e6, $af        ;0584 e6 af    inc $af
        .byte   $d0, $e6        ;0586 d0 e6    bne _056e
_0588:
        .byte   $a5, $a5        ;0588 a5 a5    lda $a5
        .byte   $8d, $18, $06   ;058a 8d 18 06 sta _0618
        .byte   $20, $46, $f6   ;058d 20 46 f6 jsr $f646
_0590:
        .byte   $ad, $11, $d0   ;0590 ad 11 d0 lda $d011
        .byte   $10, $fb        ;0593 10 fb    bpl _0590
        .byte   $20, $a3, $fd   ;0595 20 a3 fd jsr $fda3
        .byte   $ad, $00, $dd   ;0598 ad 00 dd lda $dd00
        .byte   $29, $f8        ;059b 29 f8    and # $f8
        .byte   $0d, $18, $06   ;059d 0d 18 06 ora _0618
        .byte   $8d, $00, $dd   ;05a0 8d 00 dd sta $dd00
        .byte   $60             ;05a3 60       rts 

_05a4:                                                                  ;$05A4
        ;-----------------------------------------------------------------------
        ; open the command-channel to the 1541 drive and prepare a memory
        ; action "M-". send "R" for read, "W" for write and "E" for execute
        ;

        ; no file name required for writing to the command-channel
        lda # $00               ; file-name length
        jsr KERNAL_SETNAM
        
        lda # 15                ; logical number
        tay                     ; secondary-address (channel)
        ldx # $08               ; device number
        jsr KERNAL_SETLFS
        jsr KERNAL_OPEN
        
        ; write to logical file 15 by default
        ; (rather than printing to screen, for example)
        ldx # 15
        jsr KERNAL_CHKOUT
        lda # 'm'
        jsr KERNAL_CHROUT
        lda # '-'
        jsr KERNAL_CHROUT
        
        rts 

        ;=======================================================================

_05c4:
        .byte   $20, $d1, $04   ;05c4 20 d1 04 jsr _04d1
        .byte   $85, $ae        ;05c7 85 ae    sta $ae
        .byte   $20, $d1, $04   ;05c9 20 d1 04 jsr _04d1
        .byte   $85, $af        ;05cc 85 af    sta $af
        .byte   $60             ;05ce 60       rts 

        ;=======================================================================

_05cf:                                                                  ;$05CF
        lda #< _0510
        sta $0330               ; vector for `LOAD` routine
        lda #> _0510
        sta $0331               ; vector for `LOAD` routine
        rts 

        ;=======================================================================

_05da:                                                                  ;$05DA
        ldx # $00
        ldy # $00
_05de:                                                                  ;$05DE
        lda # $08
        sta _0618               ; counter?

        lda _05fc, x
:       sta $cf00, y            ; decode buffer?                        ;$05E6
        iny 
        dec _0618
        bne :-
        inx 
        cpx # $1c               ;=28
        bcc _05de
        
        rts 
        
_05f5:                                                                  ;$05F5
        inc VIC_BORDER
        dec VIC_BORDER
        rts 

        ;=======================================================================
_05fc:                                                                  ;$05FC
        .byte   $a0, $50, $0a, $05
_0600:                                                                  ;$0600
        .byte   $00, $00, $00, $00, $20, $10, $02, $01
        .byte   $ff, $ff, $ff, $ff, $80, $40, $08, $04
        .byte   $ff, $ff, $ff, $ff, $00, $00, $00, $00
_0618:                                                                  ;$0618
        .byte   $ff


;-------------------------------------------------------------------------------

        ; backup $02-$FF to $CE02-$CEFF

        ; carry is a flag
_0619:  ldx # $02
_061b:  lda $00, x
        bcc :+
        lda $ce00, x
:       sta $00, x
        sta $ce00, x
        inx 
        bne _061b
        rts

_062b:
        ;=======================================================================
        ; wait until the screen register is non-zero
        ; since the screen will be blanked during disk loading,
        ; this should wait here until loading is complete?
        lda $d011
        bpl _062b

        ; move the text screen (from $0400) to $0800 by changing the value at
        ; $0288 that contains the high byte for the screen address. this means
        ; that the text screen now appears within the BASIC program area
        lda # $08
        sta $0288

        ; reset the VIC II chip; clears the screen (at its new location)
        jsr KERNAL_SCINIT

        ; change the RAM / ROM layout
        lda VIC_MEMORY  ;=$D018, read the current state
        and # %00001111 ; strip out bits 4-7 leaving the bits 0-3 intact
        ora # %00100000 ; set bit 5 "%0010xxxx" to move the screen to $0800
        sta VIC_MEMORY

        ; change border / background colour
        lda # RED
        sta VIC_BORDER
        sta VIC_BACKGROUND

        ; write text to the screen
        ; "do you want to use the fast loader?"
        ldx # $00
        jsr _0670

        ; store the character index of the next string on the stack
        txa
        pha
    
        ; check $067D for a non-zero value,
        ; and if so, print the next string
        lda _067d
        bne _066e

        ; increase the counter
        inc _067d

        ; write the red colour to the string, so when it gets printed again,
        ; the "use the fast loader?" text is made 'invisible'. this appears
        ; not to actually be used in practice
        lda # $1c               ; red colour PETSCII code
        sta _06b3

        ; read a keypress
        ; (returns A = keycode)
@keypress:
        jsr KERNAL_GETIN
        beq @keypress

        cmp # 'n'               ; user pressed N?
        beq _066e               ; print the next string and return

        cmp # 'y'               ; if user did not press Y,
        bne @keypress           ; get another keypress

        ; use fast-loader?
        jsr _03fc

_066e:
        ; pull the string-index from the stack
        ; (and print the next string -- fallthrough)
        pla
        tax

_0670:
        ; 
        lda _067e, x
        beq _067b               ; is the value zero? (exit routine)

        jsr KERNAL_CHROUT       ; print char to screen
        inx                     ; move to next char in string
        bne _0670               ; loop, unless 255 characters have been printed

_067b:  inx
        rts

        ;-----------------------------------------------------------------------
        
_067d:  .byte   $00

_067e:  .byte   $93             ; clear screen
        .byte   $96             ; pink text
        .byte   $8e             ; upper-case
        .byte   $08             ; disable case-switching with C= key
        .repeat 35
                .byte   " "     ; 35 spaces (i.e. move to the right corner)
        .endrepeat
        .byte   "gma86"
        .repeat 9
                .byte   $11     ; cursor down 9 times
        .endrepeat
_06b3:  .byte   $9e             ; yellow text
        .byte   " do you want to use", $0d, $0d
        .byte   " the fast loader? (y/n)"
        .byte   $00             ; terminate string
        
        .byte   $93             ; clear the screen
        .byte   $96             ; pink text
        .byte   $8e             ; upper-case
        .byte   $08             ; disable case-switching with C= key
        .repeat 35
                .byte   " "     ; 35 spaces (i.e. move to the right corner)
        .endrepeat
        .byte   "gma86"
        .repeat 9
                .byte   $11     ; cursor down 9 times
        .endrepeat
        .byte   $9e             ; yellow text
        .repeat 14
                .byte   " "     ; 14 spaces (centre text)
        .endrepeat
        .byte   "loading", $0d, $0d
        .repeat 15
                .byte   " "     ; 15 spaces (centre text)
        .endrepeat
        .byte   "elite."
        .byte   $00             ; terminate string
