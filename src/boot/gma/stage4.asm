; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "stage4.asm":
;
; the stage-4 loader ("GMA4.PRG") consists of two large blocks of scrambled
; code/data with the decryption routine wedged between. after decryption, most
; of this data is relocated in RAM, which is why DATA1 is split into A/B parts
;
; $4000 +---------+
;       | DATA1A  |
;       |         |
;       |         |
; $5600 |- - - - -|
;       | DATA1B  |
; $7593 +---------+
;       | CODE    |    decryption routine
; $75E4 +---------+               
;       | DATA2   |
;       |         |
;       |         |
; $8660 +---------+
;
; a python script "link/encrypt.py" will handle encrypting the data blocks.
; the 'encryption' is done by simply adding one byte to the next and saving
; the resultant byte. for example, the following original data:
;
;   $4c, $32, $24, $00, $03, $60, $6b, $a9, ...
;
; is encoded by adding $4c and $32 = $7e, then $32 + $24, $24 + $00,
; and so on giving: (values > $ff just wrap-around)
;
;   $7e, $56, $24, $03, $63, $cb, $14, ...


.segment        "HEAD_STAGE4"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; populate the .PRG header using the address given by the linker config
; (see "link/elite-original-gma86.cfg")
;
.import         __GMA4_PRG_START__
        .addr   __GMA4_PRG_START__+2


.segment        "GMA4_JUNK1"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; after the DATA1 block follow some unused junk bytes. these are not encrypted,
; which is why they must be in their own segement
;
.export         __GMA4_JUNK1__:absolute = 1

        .byte   $4c, $85, $01                                           ;$7590


.segment        "CODE_STAGE4"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; now begin the decryption routine
;
_7593:                                                                  ;$7593
        .byte   $20, $34, $01

; the stage 1 loader ("GMA1.PRG") jumps into here 
_7596:                                                                  ;$7596
.export _7596

        cld                     ; clear decimal mode (why??)
    
.import __GMA4_DATA2_START__
.import __GMA4_DATA2_LAST__

        ; decrypt DATA2 block -- set where to stop:
        ; (at the end of this rountine)
        lda #< (__GMA4_DATA2_START__ - 1)
        sta _7593+0
        lda #> (__GMA4_DATA2_START__ - 1)
        sta _7593+1

        lda #> (__GMA4_DATA2_LAST__ - 1)
        ldy #< (__GMA4_DATA2_LAST__ - 1)
        ldx # $8e
        jsr decrypt_block

.import __GMA4_DATA1A_START__
.import __GMA4_DATA1B_LAST__

        ; decrypt DATA1 block -- set where to stop:
        ; (at the loading address = $4000)
        lda #< (__GMA4_DATA1A_START__ - 1)
        sta _7593+0
        lda #> (__GMA4_DATA1A_START__ - 1)
        sta _7593+1

        lda #> (__GMA4_DATA1B_LAST__ - 1)
        ldy #< (__GMA4_DATA1B_LAST__ - 1)
        ldx # $6c
        jsr decrypt_block

        ; code is decrypted, begin running it!
.import _75e4
        jmp _75e4


.proc   decrypt_block                                                   ;$75C0
        ;=======================================================================
        ; walks backward through code/data un-scrambling it. since it works
        ; backwards, the starting point is provided as an address + offset
        ; where A is the high byte of the 256-byte page werein the data ends
        ; and Y is the offset to the last byte to work from, e.g. $8600+$5A
        ;
        ;       A = high byte of where the 'starting' point is
        ;       Y = offset from the address assumed above,
        ;           i.e. where the encrypted data block ends
        ;       X = 'decryption key'
        ; _7593/4 = contains the address at which to stop processing, less one
        ;
        TABLELO = $18
        TABLEHI = $19
        PARAM_X = $1a

        stx PARAM_X

        ; create a pointer in $18/$19 using A, $00
        ; i.e. an aligned data table like $8600
        sta TABLEHI
        lda # $00
        sta TABLELO

decrypt_byte:                                                           ;$75C8
        ;-----------------------------------------------------------------------
        ; look up the data-table given by pointer in $18/$19 and add Y
        lda [TABLELO], y
        sec                 ; set carry flag (?)
        sbc PARAM_X         ; subtract the X parameter value
        sta [TABLELO], y    ; write this back to the table
        sta PARAM_X         ; use this as the next deduction

        tya                 ; examine the index used
        bne :+              ; if > 0, then skip ahead, otherwise..
        dec TABLEHI         ; move down a page
:       dey                 ; move the index down

        cpy _7593+0         ; does it match the low address?
        bne decrypt_byte    ; no -- keep processing
        
        lda TABLEHI
        cmp _7593+1
        bne decrypt_byte

        rts
.endproc


.segment        "GMA4_JUNK2"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; after the DATA2 block follows some unused junk bytes.
; these are not encrypted, which is why they must be in their own segement
;
.export         __GMA4_JUNK2__:absolute = 1

        .byte   $00, $ff, $00, $ff, $00                                 ;$865B

;$8660