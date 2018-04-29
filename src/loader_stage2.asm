
.zeropage
; 4 unused (by the Kernal) bytes exist at $FB-$FE
ZP_C1541_MEM       := $fb
ZP_C1541_PROGRAM   := $fd

;$C800:
.code
    ; save a pointer for a memory address inside the drive
    lda #<$0300
    sta ZP_C1541_MEM+0
    lda #>$0300
    sta ZP_C1541_MEM+1

    lda #<_c897
    sta ZP_C1541_PROGRAM+0
    lda #>_c897
    sta ZP_C1541_PROGRAM+1

    ; open the disk command channel for memory-access
    ; i.e. we're going to upload a program to the 1541
_c810:
    jsr _c873

    ; add the "w" to the disk command to specify memory-write
    lda #'w'
    jsr $ffd2

    ; specify the memory address in the drive, read from $FB/FC,
    ; set at the top of this routine = $0300. these are the data-buffers
    lda ZP_C1541_MEM+0     
    jsr $ffd2
    lda ZP_C1541_MEM+1
    jsr $ffd2
    lda #$20        ; length of data being written
    jsr $ffd2

    ldx #$20        ; length of data, counts down
    ldy #$00
    clc

    ; change the pointer to "$0320"
    lda ZP_C1541_MEM+0
    adc #$20
    sta ZP_C1541_MEM+0
    lda #$00
    adc ZP_C1541_MEM+1
    sta ZP_C1541_MEM+1

_c838:
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
:   dex
    bne _c838
    
    ; close deafult output channel
    jsr $ffcc

    lda $fb
    cmp #$8d
    lda $fc
    sbc #$03
    bcc _c810
    jsr _c873
    lda #$45
    jsr $ffd2
    lda #$64
    jsr $ffd2
    lda #$03
    jsr $ffd2
    jsr $ffcc
:   bit $dd00
    bmi :-
:   bit $dd00
    bpl :-

    rts

_c873:
    ; set the file name. X & Y are taken from the stage 1 loader and set the
    ; pointer to the file name, "gma3", although a file name is not used yet
    lda #$00        ; no file name length!
    jsr $ffbd       

    ; set file parameters
    lda #$0f        ; open file "15" (any non-zero number would do)
    tay             ; set Y to open the disk command channel
    ldx #$08        ; drive 8
    jsr $ffba       ; set file parameters
    jsr $ffc0       ; open the command channel

    ; default all output to the disk drive:
    ldx #$0f        ; logical file 15 (as above)
    jsr $ffc9       ; CHKOUT - define the default output

    ; unused byte at $02
    lda #$97
    sta $02        

    ; send bytes to command drive to access its memory -
    ; the "w" is left off the end to actually specify memory-write.
    ; the caller will have to do this
    lda #'m'
    jsr $ffd2
    lda #'-'
    jsr $ffd2

    rts

_c897:
; this is a program uploaded to the drive:
.proc   c1541_program
    
    .scope  pt1

        lda #$0f
        sta $1800
        sta $1800
        lda $1c00
        and #$9f
        sta $1c00
        ldy #$5a

    .endscope

_c8a9:
    dey
    bne :+
    lda #$02
    jmp $f969

:   bit $1c00
    bmi :-

    lda $1c01
    clv
    ldx #$04
:   bvc *       ; infinite loop waiting for CPU overflow flag to change to 1
    clv

    lda $1c01
    sta $0500, x
    dex
    bpl :-

    cmp #$69
    bne _c8a9

    lda $0501
    cmp #$a9
    bne _c8a9

:   bit $1c00
    bmi :-
    clv 
    lda $1c01
    ldx #$00

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

    lda #$01
    jmp $f969

;c8fb:
.byte                  $20, $42, $d0, $a9, $25
.byte   $85, $06, $a9, $01, $85, $07, $20, $18
.byte   $c1, $a9, $e0, $85, $00

;   c8fb 20 42 d0 jsr $d042
;   c8fe a9 25    lda #$25
;   c900 85 06    sta $06
;   c902 a9 01    lda #$01
;   c904 85 07    sta $07
;   c906 20 18 c1 jsr $c118
;   c909 a9 e0    lda #$e0
;   c90b 85 00    sta $00

_c90d:
    lda $00
    bmi _c90d
    cmp #$02
    bcc _c91b
    jmp $037e
    jsr $c12c
_c91b:
    lda #$00
    sta $1800
    sta $1800
    rts 

.endproc
