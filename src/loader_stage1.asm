
; eight bytes of unused (by the Kernal) RAM exist at $0334, followed by
; the 192 byte Datasette buffer (no use to us here), another 4 unused bytes
; and then the text screen. since the text screen gets moved to $0800,
; this gives us plenty of space in low-memory for the loader

    jmp start

_0337:
.byte   $00, $00    ; "GMA0" (invalid)
.byte   $00, $00    ; "GMA1" (invalid)
.byte   $11, $04    ; "GMA2" (invalid?)
.byte   $11, $05    ; "GMA3" (slow-loader)
.byte   $11, $06    ; "GMA4"
.byte   $13, $00    ; "GMA5"
.byte   $14, $08    ; "GMA6"

start:
    ; call Kernel SETMSG, "Set system error display switch at
    ; memory address $009D". A = the switch value.
    ; i.e. disable error messages?
    lda #$00
    jsr $ff90

    ; change the address of STOP key routine from $F6ED,
    ; to $FFED: the SCREEN routine which returns row/col count
    ; i.e. does nothing of use -- this effectively disables the STOP key
    lda #$ff
    sta $0329

    ; set up the screen, display the "use the fast loader?" message.
    ; if fast-loader is selected, control will have gone to _03fc,
    ; if slow-loader is selected, we will have returned here
    jsr _062b

    ; load "GMA3" file
    lda #$03
    jsr _03b5

    ; start GMA3's code -- note that the current X & Y are used in here
    jsr $c800

;035a a5 02    lda $02
;035c 49 97    eor #$97
;035e f0 03    beq $0363
;0360 6c fc ff jmp ($fffc)
;0363 a9 04    lda #$04
;0365 20 b5 03 jsr $03b5
;0368 20 81 ff jsr $ff81
;036b a9 02    lda #$02
;036d 8d 20 d0 sta $d020
;0370 8d 21 d0 sta $d021
;0373 a9 04    lda #$04
;0375 8d 88 02 sta $0288
;0378 a9 4c    lda #$4c
;037a 8d 0e ce sta $ce0e
;037d a9 8a    lda #$8a
;037f 8d 0f ce sta $ce0f
;0382 a9 03    lda #$03
;0384 8d 10 ce sta $ce10
;0387 4c 96 75 jmp $7596
;038a 18       clc 
;038b 20 19 06 jsr $0619
;038e a5 01    lda $01
;0390 29 f8    and #$f8
;0392 09 2e    ora #$2e
;0394 85 01    sta $01
;0396 a9 05    lda #$05
;0398 20 b5 03 jsr $03b5
;039b a9 06    lda #$06
;039d 20 b5 03 jsr $03b5
;03a0 a5 01    lda $01
;03a2 29 f8    and #$f8
;03a4 09 06    ora #$06
;03a6 85 01    sta $01
;03a8 38       sec 
;03a9 20 19 06 jsr $0619
;03ac 20 8a ff jsr $ff8a
;03af 20 e7 ff jsr $ffe7
;03b2 4c 22 1d jmp $1d22

_03b5:
    ; select the filename
    jsr _03c7

    ; set file parameters:
    lda #$01        ; file number
    ldx #$08        ; drive number
    ldy #$01        ; "secondary address"
    jsr $ffba

    ; load file from disk:
    lda #$00
    jsr $ffd5
    
    rts

_03c7:
    ; select file name:
    ;---------------------------------------------------------------------------
    ; A = number of file to load, i.e. $03 = "GMA3"
    
    tax                 ; put the current A value aside

    clc                 ; clear carry flag (before doing add)
    adc #'0'            ; convert A to a PETSCII numeral "0"+A
    sta _filename_num   ; change the filename to load, e.g. "GMA3"
    
    ; lookup the number in a table:

    txa                 ; get the original number back
    asl a               ; shift-left, i.e. multiply by 2
    tax                 ; use it as the index

    lda _0337+0, x      ; load 16-bit low-byte
    sta _04b9
    lda _0337+1, x      ; load 16-bit high-byte
    sta _04bd

    ; set file name
    ldx #<_filename
    ldy #>_filename
    lda #$04    ; file name length
    jsr $ffbd
    rts 

_filename:
.byte   "gma"
_filename_num:
.byte   $20

;$03eb:
.byte   " was here 1985 ok"

_03fc:
;03fc 20 da 05 jsr $05da
;03ff 20 cf 05 jsr $05cf
;0402 60       rts 
;0403 a9 06    lda #$06
;0405 85 31    sta $31
;0407 20 0a f5 jsr $f50a
;040a 50 fe    bvc $040a
;040c b8       clv 
;040d ad 01 1c lda $1c01
;0410 99 00 06 sta $0600,y
;0413 c8       iny 
;0414 d0 f4    bne $040a
;0416 a0 ba    ldy #$ba
;0418 50 fe    bvc $0418
;041a b8       clv 
;041b ad 01 1c lda $1c01
;041e 99 00 01 sta $0100,y
;0421 c8       iny 
;0422 d0 f4    bne $0418
;0424 20 e0 f8 jsr $f8e0
;0427 a5 38    lda $38
;0429 c5 47    cmp $47
;042b f0 04    beq $0431
;042d a9 04    lda #$04
;042f d0 3f    bne $0470
;0431 20 e9 f5 jsr $f5e9
;0434 c5 3a    cmp $3a
;0436 f0 04    beq $043c
;0438 a9 05    lda #$05
;043a d0 34    bne $0470
;043c ad 01 06 lda $0601
;043f 85 07    sta $07
;0441 a0 02    ldy #$02
;0443 a2 ff    ldx #$ff
;0445 ad 00 06 lda $0600
;0448 f0 03    beq $044d
;044a 8e 01 06 stx $0601
;044d ee 01 06 inc $0601
;0450 be 00 06 ldx $0600,y
;0453 e0 01    cpx #$01
;0455 d0 03    bne $045a
;0457 20 82 03 jsr $0382
;045a 20 82 03 jsr $0382
;045d c8       iny 
;045e cc 01 06 cpy $0601
;0461 d0 ed    bne $0450
;0463 ad 00 06 lda $0600
;0466 f0 0e    beq $0476
;0468 c5 06    cmp $06
;046a 85 06    sta $06
;046c f0 05    beq $0473
;046e a9 01    lda #$01
;0470 4c 69 f9 jmp $f969
;0473 4c 04 03 jmp $0304
;0476 a2 01    ldx #$01
;0478 20 82 03 jsr $0382
;047b a2 02    ldx #$02
;047d 20 82 03 jsr $0382
;0480 a9 7f    lda #$7f
;0482 4c 69 f9 jmp $f969
;0485 2c 00 18 bit $1800
;0488 10 fb    bpl $0485
;048a a9 10    lda #$10
;048c 8d 00 18 sta $1800
;048f 2c 00 18 bit $1800
;0492 30 fb    bmi $048f
;0494 8a       txa 
;0495 4a       lsr a
;0496 4a       lsr a
;0497 4a       lsr a
;0498 4a       lsr a
;0499 8d 00 18 sta $1800
;049c 0a       asl a
;049d 29 0f    and #$0f
;049f 8d 00 18 sta $1800
;04a2 8a       txa 
;04a3 29 0f    and #$0f
;04a5 8d 00 18 sta $1800
;04a8 0a       asl a
;04a9 29 0f    and #$0f
;04ab 8d 00 18 sta $1800
;04ae a9 0f    lda #$0f
;04b0 ea       nop 
;04b1 8d 00 18 sta $1800
;04b4 60       rts 
;04b5 20 42 d0 jsr $d042
;04b8 a9 ff    lda #$ff

_04b9:
.byte   $ff
;04ba 85 06    sta $06
;04bc a9 ff    lda #$ff

_04bd:
.byte   $ff
;04be 85 07    sta $07
;04c0 a9 e0    lda #$e0
;04c2 85 00    sta $00
;04c4 a5 00    lda $00
;04c6 30 fc    bmi $04c4
;04c8 c9 7f    cmp #$7f
;04ca f0 02    beq $04ce
;04cc 90 f2    bcc $04c0
;04ce 4c 48 d0 jmp $d048
;04d1 a5 a4    lda $a4
;04d3 8d 00 dd sta $dd00
;04d6 ad 00 dd lda $dd00
;04d9 10 fb    bpl $04d6
;04db ad 12 d0 lda $d012
;04de c9 31    cmp #$31
;04e0 90 06    bcc $04e8
;04e2 29 06    and #$06
;04e4 c9 02    cmp #$02
;04e6 f0 f3    beq $04db
;04e8 a5 a5    lda $a5
;04ea 8d 00 dd sta $dd00
;04ed ea       nop 
;04ee ea       nop 
;04ef ea       nop 
;04f0 ea       nop 
;04f1 ea       nop 
;04f2 ea       nop 
;04f3 ea       nop 
;04f4 ea       nop 
;04f5 ea       nop 
;04f6 ea       nop 
;04f7 ae 00 dd ldx $dd00
;04fa bd 00 cf lda $cf00,x
;04fd ae 00 dd ldx $dd00
;0500 1d 08 cf ora $cf08,x
;0503 ae 00 dd ldx $dd00
;0506 1d 10 cf ora $cf10,x
;0509 ae 00 dd ldx $dd00
;050c 1d 18 cf ora $cf18,x
;050f 60       rts 
;0510 a9 00    lda #$00
;0512 85 a4    sta $a4
;0514 20 a4 05 jsr $05a4
;0517 a9 57    lda #$57
;0519 20 dd ed jsr $eddd
;051c a5 a4    lda $a4
;051e 20 dd ed jsr $eddd
;0521 a9 03    lda #$03
;0523 20 dd ed jsr $eddd
;0526 a9 20    lda #$20
;0528 20 dd ed jsr $eddd
;052b a4 a4    ldy $a4
;052d 18       clc 
;052e a5 a4    lda $a4
;0530 69 20    adc #$20
;0532 85 a4    sta $a4
;0534 b9 03 04 lda $0403,y
;0537 20 dd ed jsr $eddd
;053a c8       iny 
;053b c4 a4    cpy $a4
;053d d0 f5    bne $0534
;053f 20 cc ff jsr $ffcc
;0542 a5 a4    lda $a4
;0544 c9 ce    cmp #$ce
;0546 90 cc    bcc $0514
;0548 20 a4 05 jsr $05a4
;054b a9 45    lda #$45
;054d 20 dd ed jsr $eddd
;0550 a9 b2    lda #$b2
;0552 20 dd ed jsr $eddd
;0555 a9 03    lda #$03
;0557 20 dd ed jsr $eddd
;055a 20 cc ff jsr $ffcc
;055d ad 00 dd lda $dd00
;0560 29 07    and #$07
;0562 85 a5    sta $a5
;0564 09 08    ora #$08
;0566 85 a4    sta $a4
;0568 78       sei 
;0569 20 c4 05 jsr $05c4
;056c a0 00    ldy #$00
;056e 20 f5 05 jsr $05f5
;0571 20 d1 04 jsr $04d1
;0574 c9 01    cmp #$01
;0576 d0 07    bne $057f
;0578 20 d1 04 jsr $04d1
;057b c9 01    cmp #$01
;057d d0 09    bne $0588
;057f 91 ae    sta ($ae),y
;0581 c8       iny 
;0582 d0 ea    bne $056e
;0584 e6 af    inc $af
;0586 d0 e6    bne $056e
;0588 a5 a5    lda $a5
;058a 8d 18 06 sta $0618
;058d 20 46 f6 jsr $f646
;0590 ad 11 d0 lda $d011
;0593 10 fb    bpl $0590
;0595 20 a3 fd jsr $fda3
;0598 ad 00 dd lda $dd00
;059b 29 f8    and #$f8
;059d 0d 18 06 ora $0618
;05a0 8d 00 dd sta $dd00
;05a3 60       rts 
;05a4 a9 00    lda #$00
;05a6 20 bd ff jsr $ffbd
;05a9 a9 0f    lda #$0f
;05ab a8       tay 
;05ac a2 08    ldx #$08
;05ae 20 ba ff jsr $ffba
;05b1 20 c0 ff jsr $ffc0
;05b4 a2 0f    ldx #$0f
;05b6 20 c9 ff jsr $ffc9
;05b9 a9 4d    lda #$4d
;05bb 20 d2 ff jsr $ffd2
;05be a9 2d    lda #$2d
;05c0 20 d2 ff jsr $ffd2
;05c3 60       rts 
;05c4 20 d1 04 jsr $04d1
;05c7 85 ae    sta $ae
;05c9 20 d1 04 jsr $04d1
;05cc 85 af    sta $af
;05ce 60       rts 
;05cf a9 10    lda #$10
;05d1 8d 30 03 sta $0330
;05d4 a9 05    lda #$05
;05d6 8d 31 03 sta $0331
;05d9 60       rts 
;05da a2 00    ldx #$00
;05dc a0 00    ldy #$00
;05de a9 08    lda #$08
;05e0 8d 18 06 sta $0618
;05e3 bd fc 05 lda $05fc,x
;05e6 99 00 cf sta $cf00,y
;05e9 c8       iny 
;05ea ce 18 06 dec $0618
;05ed d0 f7    bne $05e6
;05ef e8       inx 
;05f0 e0 1c    cpx #$1c
;05f2 90 ea    bcc $05de
;05f4 60       rts 
;05f5 ee 20 d0 inc $d020
;05f8 ce 20 d0 dec $d020
;05fb 60       rts 
;05fc a0 50    ldy #$50
;05fe 0a       asl a
;05ff 05 00    ora $00
;0601 00       brk 
;0602 00       brk 
;0603 00       brk 
;0604 20 10 02 jsr $0210
;0607 01 ff    ora ($ff,x)
;0609 ff       ???
;060a ff       ???
;060b ff       ???
;060c 80       ???
;060d 40       rti 
;060e 08       php 
;060f 04       ???
;0610 ff       ???
;0611 ff       ???
;0612 ff       ???
;0613 ff       ???
;0614 00       brk 
;0615 00       brk 
;0616 00       brk 
;0617 00       brk 
;0618 ff       ???
;0619 a2 02    ldx #$02
;061b b5 00    lda $00,x
;061d 90 03    bcc $0622
;061f bd 00 ce lda $ce00,x
;0622 95 00    sta $00,x
;0624 9d 00 ce sta $ce00,x
;0627 e8       inx 
;0628 d0 f1    bne $061b
;062a 60       rts

_062b:
    ; wait until the screen register is non-zero
    ; since the screen will be blanked during disk loading,
    ; this should wait here until loading is complete?
    lda $d011
    bpl _062b

    ; move the text screen (from $0400) to $0800 by changing the value at
    ; $0288 that contains the high byte for the screen address. this means
    ; that the text screen now appears within the BASIC program area
    lda #$08
    sta $0288

    ; reset the VIC II chip; clears the screen (at its new location)
    jsr $ff81

    ; change the RAM / ROM layout
    lda $d018       ; read the current state
    and #%00001111  ; strip out bits 4-7 leaving the bits 0-3 intact
    ora #%00100000  ; set bit 5 "%0010xxxx" to move the screen to $0800
    sta $d018            

    ; change border / background colour
    lda $02
    sta $d020
    sta $d021

    ; write text to the screen
    ; "do you want to use the fast loader?"
    ldx #$00
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
    lda #$1c        ; red colour
    sta _06b3

    ; read a keypress
    ; (returns A = keycode)
_keypress:
    jsr $ffe4
    beq _keypress

    cmp #'n'
    beq _066e       ; user pressed N, print the next string and return

    cmp #'y'        ; if user did not press Y, get another keypress
    bne _keypress

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
    beq _067b       ; is the value zero? (exit routine)

    jsr $ffd2       ; print char to screen
    inx             ; move to next char in string
    bne _0670       ; loop, unless 255 characters have been printed

_067b:
    inx
    rts

_067d:
.byte   $00

_067e:
.byte   $93     ; clear screen
.byte   $96     ; pink text
.byte   $8e     ; upper-case
.byte   $08     ; disable case-switching with C= key
.repeat 35
.byte   " "     ; 35 spaces (i.e. move to the right corner)
.endrepeat
.byte   "GMA86"
.repeat 9
.byte   $11     ; cursor down 9 times
.endrepeat
_06b3:
.byte   $9e     ; yellow text
.byte   " do you want to use", $0d, $0d
.byte   " the fast loader? (y/n)"
.byte   $00     ; terminate string

.byte   $93     ; clear the screen
.byte   $96     ; pink text
.byte   $8e     ; upper-case
.byte   $08     ; disable case-switching with C= key
.repeat 35
.byte   " "     ; 35 spaces (i.e. move to the right corner)
.endrepeat
.byte   "GMA86"
.repeat 9
.byte   $11     ; cursor down 9 times
.endrepeat
.byte   $9e     ; yellow text
.repeat 14
.byte   " "     ; 14 spaces (centre text)
.endrepeat
.byte   "loading", $0d, $0d
.repeat 14
.byte   " "     ; 15 spaces (centre text)
.endrepeat
.byte   "elite."
.byte   $00     ; terminate string
