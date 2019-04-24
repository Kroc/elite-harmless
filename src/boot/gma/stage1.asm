; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "stage1.asm" -- this could be considered the 'main' part of the loading
; process as it displays the fastload option and orchestrates the loading /
; decryption of the other modules

.include        "c64/c64.asm"
.include        "c64/c1541.asm"
.include        "elite_consts.asm"

;===============================================================================
; populate the "GMA1.PRG" header using the address given
; by the linker config (see "link/elite-original-gma86.cfg")

.segment        "HEAD_STAGE1"
.import         __GMA1_PRG_START__
        .addr   __GMA1_PRG_START__+2

;===============================================================================

.segment        "CODE_STAGE1A"

; eight bytes of unused (by the KERNAL) RAM exist at $0334, followed by
; the 192 byte Datasette buffer (no use to us here), another 4 unused bytes
; and then the text screen. since the text screen gets moved to $0800,
; this gives us plenty of space in low-memory for the loader

        jmp     gma1_start                                              ;$0334

gma_trksec:                                                             ;$0337
        ;=======================================================================
        ; table of track & sector numbers
        ; (for the fast-loader)

        .byte   0,  0           ; "GMA0" (invalid)
        .byte   0,  0           ; "GMA1" (invalid)
        .byte   17, 4           ; "GMA2" (invalid)
        .byte   17, 5           ; "GMA3"
        .byte   17, 6           ; "GMA4"
        .byte   19, 0           ; "GMA5"
        .byte   20, 8           ; "GMA6"

gma1_start:                                                             ;$0345
        ;=======================================================================
        ; call KERNAL `SETMSG`, "Set system error display switch at memory
        ; address $009D". A = the switch value. i.e. disable error messages?
        lda # $00
        jsr KERNAL_SETMSG

        ; change the address of STOP key routine from $F6ED,
        ; to $FFED: the SCREEN routine which returns row/col count
        ; i.e. does nothing of use -- this effectively disables the STOP key
        lda #> KERNAL_SCREEN
        sta KERNAL_VECTOR_STOP+1

        ; set up the screen, display the "use the fast loader?" message.
        ; if fast-loader is selected, the KERNAL `LOAD` routine is hijacked
        ; with a wedge that uploads a fast-loader into the 1541; therefore
        ; the code that follows is the same with or without fast loading
        jsr _062b

        ; * * *   C O P Y   P R O T E C T I O N !  * * *

        ; load "GMA3" file
        lda # $03
        jsr _03b5

.ifdef  OPTION_NOCOPY
        ; start GMA3's code -- note that the current X & Y
        ; (pointer to filename) are re-used in here
        jsr _c800
.else
        ; "crack" the loader by jumping over the copy-protection check
        jmp :+
.endif

        ; is the value at $02 exactly $97?
        ; (i.e. the result of copy-protection check?)
        lda $02
        eor # $97
        beq :+                  ; skip ahead if [$02] = $97
        jmp [HW_VECTOR_RESET]   ; hard reset!

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
        ora # C64_MEM::IO_KERNAL
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
        ldx # DEV_DRV8  ; drive number
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
        tax                     ; put the current A value aside

        clc                     ; clear carry flag (before doing add)
        adc # '0'               ; convert A to a PETSCII numeral, i.e. "0"+A
        sta _filename_num       ; change the filename to load, e.g. "GMA3"
        
        ; for the fast-loader, find the track / sector:

        txa                     ; get the original file number back
        asl                     ; shift-left, i.e. multiply by 2
        tax                     ; use it as the index

        ; get the address of the block of 1541 code *here on the C64*
        ; (not its address within the 1541, when it gets copied there)
.import __CODE_1541_LOAD__
.import __CODE_1541_RUN__

        ; MODIFY THE 1541 PROGRAM, HERE ON THE C64,
        ; BEFORE IT GETS SENT TO THE 1541 DRIVE!

        ; write the track and sector to the fast-loader
        ; code before it gets uploaded to the drive:
        lda gma_trksec+0, x     ; track
        sta __CODE_1541_LOAD__ + (lda_track  + 1 - __CODE_1541_RUN__)
        lda gma_trksec+1, x     ; sector
        sta __CODE_1541_LOAD__ + (lda_sector + 1 - __CODE_1541_RUN__)

        ; set file name
        ldx #< _filename
        ldy #> _filename
        lda # $04               ; file name length
        jsr KERNAL_SETNAM
        
        rts 

_filename:
        .byte   "gma"
_filename_num:
        .byte   " "

        ; hidden message (not part of the filename)
        .byte   " was here 1985 ok"                                     ;$03EB

_03fc:
        ;=======================================================================
        ; use fast-loader
        ;
        jsr _05da
        jsr fastload_hijack             ; change KERNAL `LOAD` to our routine
        
        rts 

;===============================================================================
; "it belongs in a 1541!"

.segment        "CODE_1541"

read_sector:                                            ;C64:$0403, 1541:$0300
        ;=======================================================================
        ; reads a sector from the disk; this is 324 GCR-encoded bytes
        ; which get decoded to 256 bytes of actual data

        ; change the selected buffer to $0600
        ; (buffer 0, $0300, contains this code)
        lda #> C1541_BUFF3
        sta C1541_ZP_CURBUFF_HI

@get_sector:                                                            ;$0407
        ;-----------------------------------------------------------------------
        ; read 324 GCR-encoded bytes from the disk surface:

        ; "find start of data block"; this locates the selected
        ; track / sector on the disk and reads the header
        jsr $f50a

        ; read the first 256 bytes

:       bvc *                           ; wait for drive head "ready"   ;$040A
        clv                             ; (clear overflow flag)

        lda C1541_VIA2_PORTA            ; read byte from the magnet
        sta C1541_BUFF3, y              ; put it into the data buffer
        iny                             ; move to next buffer byte,
       .bnz :-                          ; and wait for next byte to come in

        ; now read the remaining 69 bytes
        ; (these go onto the "overflow buffer", $01BF...$01FF)

        ldy # 255 - 69

:       bvc *                           ; wait for drive head "ready"   ;$0418
        clv                             ; (clear overflow flag)

        lda C1541_VIA2_PORTA            ; read byte from the magnet
        sta $0100, y                    ; put it on the overflow-buffer
        iny                             ; move to next overflow-buffer byte,
       .bnz :-                          ; and wait for next byte to come in
        
        jsr $f8e0                       ; 'decode 69 GCR bytes'
        
        ; get the "data block signature" byte of sector just read
        lda $38
        cmp $47                         ; check against the expected value
        beq :+                          ; OK?

        lda # C1541_ERR::READ_ERROR_22
        bne @_0470

        ; 'calculate parity of the data buffer'
:       jsr $f5e9                                                       ;$0431
        ; test against the checksum
        cmp $3a
        beq :+

        lda # C1541_ERR::READ_ERROR_23
        bne @_0470

        ; is there more data to read for this file?
        ; (the first two bytes of sector data are the track + sector numbers
        ;  for additional file data. "$00, $FF" indicates no further data)
:       lda C1541_BUFF3+1               ; get next sector               ;$043C
        sta C1541_ZP_BUFF0_SEC          ; set next sector to load
        
        ; use of the actual data in the sector begins
        ; at offset 2 due to the track / sector numbers
        ldy # $02
        
        ldx # $ff

        ; if the track number is 0, 
        ; there is no further data
        lda C1541_BUFF3
       .bze :+

        stx C1541_BUFF3+1
:       inc C1541_BUFF3+1                                               ;$044D

@_0450:
        ldx C1541_BUFF3, y
        cpx # $01
        bne :+

        jsr _0485                       ; send two bytes (inc. the one below)
:       jsr _0485                       ; send one byte                 ;$045A
        iny 
        cpy C1541_BUFF3+1
        bne @_0450
        lda C1541_BUFF3
        beq _0476
        cmp $06
        sta $06
        beq @_0473                      ; read the next sector
        
        lda # C1541_ERR::OK

@_0470:
        ; finish the job; `A` will be the error code, 1 = OK (no error)
        jmp C1541_KERNAL_error

@_0473:
        ;-----------------------------------------------------------------------
        jmp @get_sector

_0476:
        ;-----------------------------------------------------------------------
        ldx # $01
        jsr _0485
        ldx # $02
        jsr _0485
        
        lda # $7f                       ;?
        jmp C1541_KERNAL_error

        
_0485:                                                                  ;$0485
        ;-----------------------------------------------------------------------
        ; check bits 6 & 7 of the serial port
        bit C1541_VIA1_PORTB
        ; wait for the ATN ("attention") line to go high
        bpl _0485

        ; send the ATN ("attention") signal to the C64
        lda # %00010000
        sta C1541_VIA1_PORTB
        
_048f:  ; send byte to the C64?                                         ;$048F
        ;-----------------------------------------------------------------------
        ; check bits 6 & 7 of the serial port
        bit C1541_VIA1_PORTB
        ; wait for the ATN ("attention") line to go low,
        ; this indicates a "ready" signal from the C64
        bmi _048f

        txa 
        lsr a
        lsr a
        lsr a
        lsr a
        sta C1541_VIA1_PORTB

        asl a
        and # $0f
        sta C1541_VIA1_PORTB
        
        txa 
        and # $0f
        sta C1541_VIA1_PORTB
        
        asl a
        and # $0f
        sta C1541_VIA1_PORTB
        
        lda # $0f
        nop 
        sta C1541_VIA1_PORTB
        
        rts 

_04b5:
        ;=======================================================================
        ; this is where the 1541 program execution begins
        ;
        jsr C1541_KERNAL_loadBAM        ; load the disk's Block Allocation Map

        ; set track and sector:
        ; note that the values of these `LDA`s are modified
        ; prior to this code being uploaded to the 1541
lda_track:
        lda # $ff
        sta C1541_ZP_BUFF0_TRK

lda_sector:
        lda # $ff
        sta C1541_ZP_BUFF0_SEC

        ; execute the scheduled job
@exec:  lda # C1541_JOB::EXECUTE                                        ;$04C0
        sta C1541_ZP_JOB0

        ; wait for the job to complete
:       lda C1541_ZP_JOB0                                               ;$04C4
        bmi :-

        ;-----------------------------------------------------------------------

        ; bit 7 will be 0 for "job finished", the rest of the bits
        ; determine result. 1 = OK, all other values are errors
        cmp # %01111111
        beq :+
        bcc @exec

:       jmp $d048               ; re-read BAM!??                        ;$04CE

;===============================================================================

.segment        "CODE_STAGE1B"

_04d1:
        lda $a4                         ; get buffered byte
        sta CIA2_PORTA                  ; write it to the serial port
:       lda CIA2_PORTA                  ; read the serial port          ;$04D6
        bpl :-                          ; wait for ATN to go high

:       lda VIC_RASTER                  ; get current raster-line       ;$04DB
        cmp # $31                       ; 0-31?
       .blt :+                          ; skip unless every 32nd raster-line
        
        and # %00000110                 ; "2, 2, 4, 4, 6, 6, 2, 2, ..."
        cmp # %00000010                 ; for every 2 lines out of 6...
        beq :-                          ; 

:       lda $a5                                                         ;$04E8
        sta CIA2_PORTA
        nop 
        nop 
        nop 
        nop 
        nop 
        nop 
        nop 
        nop 
        nop 
        nop 
        ldx CIA2_PORTA
        lda ELITE_DISK_BUFFER, x
        ldx CIA2_PORTA
        ora ELITE_DISK_BUFFER+$08, x
        ldx CIA2_PORTA
        ora ELITE_DISK_BUFFER+$10, x
        ldx CIA2_PORTA
        ora ELITE_DISK_BUFFER+$18, x
        
        rts 

        ;=======================================================================
        ; hijack of the KERNAL `LOAD` routine
        ;
fastload:
        lda #< C1541_BUFF0      ; low-byte of write address in 1541 RAM
        sta $a4                 ; byte-buffer for serial communication  
_0514:
        ; open the disk-drive command-channel; begin a command with "M-"
        ; (memory "R" read / "W" write / "E" execute)
        jsr _05a4

        ; append the "W" to make a Memory-Write command
        lda # 'w'
        jsr KERNAL_IECOUT_ADDR
        
        ; set the write-address within 1541 RAM
        lda $a4
        jsr KERNAL_IECOUT_ADDR
        lda #> C1541_BUFF0
        jsr KERNAL_IECOUT_ADDR
        
        ; "sending 32-bytes"
        lda # 32
        jsr KERNAL_IECOUT_ADDR

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
        jsr KERNAL_IECOUT_ADDR
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

        ;-----------------------------------------------------------------------
        ; open the command channel again
        jsr _05a4
        ; start a memory-exexute command
        lda # 'e'
        jsr KERNAL_IECOUT_ADDR

        ; send the address (lo-hi) to execute inside the 1541.
        ; the code inside the 1541 will begin executing independently!

        lda #< _04b5
        jsr KERNAL_IECOUT_ADDR
        lda #> _04b5
        jsr KERNAL_IECOUT_ADDR

        ; close the command-channel
        jsr KERNAL_CLRCHN

        lda $dd00               ; read the C64 serial port
        and # %00000111         ; mask out VIC-bank and RS232 bits
        sta $a5                 ; "Bit counter during serial bus input/output"
        ora # %00001000         ; pull ATN ("attention") line high
        sta $a4
        
        sei                     ; disable interrupts 
        jsr _05c4
        
        ldy # $00
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
        ldx # DEV_DRV8          ; device number
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

_05c4:
        ;-----------------------------------------------------------------------
        jsr _04d1
        sta $ae
        
        jsr _04d1
        sta $af
        
        rts 

fastload_hijack:                                                        ;$05CF
        ;=======================================================================
        ; hijack the C64 KERNAL's `LOAD` routine
        ;
        lda #< fastload
        sta KERNAL_VECTOR_LOAD+0
        lda #> fastload
        sta KERNAL_VECTOR_LOAD+1

        rts 

        ;=======================================================================

_05da:                                                                  ;$05DA
        ldx # $00
        ldy # $00
_05de:                                                                  ;$05DE
        lda # $08               ; no. of bytes to copy?
        sta _0618               ; counter?

.import ELITE_DISK_BUFFER

        lda _05fc, x
:       sta ELITE_DISK_BUFFER, y                                        ;$05E6
        iny 
        dec _0618
       .bnz :-
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


;===============================================================================
; backup the zero-page to the zero-page shadow ($CE00 in the original game)
;
        ; carry is a flag
_0619:  ldx # $02               ; always begin from $02

@loop:  lda $00, x              ; read a byte from the zero-page        ;$061B
        bcc :+
        lda ELITE_ZP_SHADOW, x
:       sta $00, x              ; write to the zero-page
        sta ELITE_ZP_SHADOW, x
        inx 
        bne @loop
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
