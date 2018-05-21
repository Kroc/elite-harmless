; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this file is part of "gma4.prg"

; this file includes two large blocks of scrambled code/data
; with the decryption routine wedged between at $7596

; the 'encryption' is done by simply adding one byte to the next and saving
; the resultant byte. for example, the following original data:

;   $4c, $32, $24, $00, $03, $60, $6b, $a9, ...

; is encoded by adding $4c and $32 = $7e, then $32 + $24, $24 + $00,
; and so on giving: (values > $ff just wrap-around)

;   $7e, $56, $24, $03, $63, $cb, $14, ...

; this requires that there be three extra 'junk' padding bytes
; on the end to ensure that all the actual data is encoded.

; the final caluclated value is the 'decryption key',
; used to reverse the process 

;-------------------------------------------------------------------------------

; the stage 1 loader ("gma1.prg") jumps into here 
.export _7596

.export _75e4

;===============================================================================

.code

.include        "../build/elite_4000.s"

;$7590  junk data -- not encrypted!
        .byte   $c4, $4c, $85, $01

;===============================================================================

_7593:
        .byte   $20, $34, $01

_7596:
        cld                     ; clear decimal mode (why??)
    
        ; first block -- set where to stop
        ; (at the end of this rountine)
        lda #< (_75e4 - 1)
        sta _7593+0
        lda #> (_75e4 - 1)
        sta _7593+1

        lda #> $865a            ; pointer high-byte to data-table, i.e. $8600
        ldy #< $855a            ; indirect index y (=>$865a = $83)
        ldx # $8e
        jsr decrypt_block

        ; second block -- set where to stop
        ; (at the loading address = $4000)
        lda #< ($4000 - 1)
        sta _7593+0
        lda #> ($4000 - 1)
        sta _7593+1

        lda #> $758f            ;TODO: link this!
        ldy #< $758f
        ldx # $6c
        jsr decrypt_block

        ; code is decrypted, begin running it!
        jmp _75e4


.proc   decrypt_block                                                   ;$75C0
        ;=======================================================================
        ; walks backward through code/data un-scrambling it. since it works
        ; backwards, the starting point is provided as an address + offset
        ; where A is the high byte of the 256-byte page werein the data ends
        ; and Y is the offset to the last byte to work from, e.g. $8600+$5A
        ;
        ; A = high byte of where the 'starting' point is
        ; Y = offset from the address assumed above, i.e. where the data ends
        ; X = amount to subtract from value from table? (decryption key?)
        ; _7593/4 contains the address at which to stop processing, less one

        TABLELO = $18
        TABLEHI = $19
        PARAM_X = $1a

        stx PARAM_X

        ; create a pointer in $18/$19 using A, $00
        ; i.e. an aligned data table like $8600
        sta TABLEHI
        lda # $00
        sta TABLELO

decrypt_byte:                                                           ;$75c8
        ;-----------------------------------------------------------------------
        ; look up the data-table given by pointer in $18/$19 and add Y
        lda (TABLELO), y
        sec                 ; set carry flag (?)
        sbc PARAM_X         ; subtract the X parameter value
        sta (TABLELO), y    ; write this back to the table
        sta PARAM_X         ; use this as the next deduction

        tya                 ; examine the index used
        bne :+              ; if the y-index is equal, then...
        dec TABLEHI         ; decrease the high-byte for the lookup-table,
                            ; switching to another table further up
:       dey                 ; move the index down
        cpy _7593+0         ; does it match the low address?
        bne decrypt_byte    ; no -- keep processing
        lda TABLEHI
        cmp _7593+1
        bne decrypt_byte

        rts
.endproc

;===============================================================================

_75e4:

;===============================================================================

; these bytes are not encrypted!!! (they're the background-fill)
; the linker will exclude these from the binary of the data-to-be-encrypted.
; when the code is re-linked with the encrypted blob, these bytes are appended

.segment        "FILL"

;_865b:
        .byte   $83, $00, $ff, $00, $ff, $00

;$8660