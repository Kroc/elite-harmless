; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "stage0.asm":
;
; this file is the code for "firebird.prg", the first stage in loading, it's
; what gets loaded by the normal C64 KERNAL. the program is designed to hijack
; BASIC via the BASIC vectors located at $0300+, this means that the program
; starts automatically without a BASIC bootstrap or `RUN`
;
; interesting tidbit: the `,1` in `LOAD"*",8,1` tells the C64 to use the
; load address given by the program, in this case $02A7. if the user uses
; `LOAD"*",8` instead, the program will be placed in the BASIC area -- $0801
; onwards -- which obviously breaks this program's attempt at hijacking the
; BASIC vectors. a BASIC bootstrap picks up this scenario and copies the
; program to the intended load address before executing it
;
.include        "c64/c64.inc"

; populate the .PRG header using the address given
; by the linker config (see "link/elite-original-gma86.cfg")
.segment        "HEAD_STAGE0"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.import         __FIREBIRD_PRG_START__
        .addr   __FIREBIRD_PRG_START__+2

; the BASIC bootstrap needs to be stored at the beginning of the program,
; canonically $02A7, but needs to be addressed as running from $0801.
; the linker configuration handles this ("link/elite-original-gma86.cfg")

.segment        "BASIC_STAGE0"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        ; the C64 BASIC binary format is described here:
        ; <https://www.c64-wiki.com/wiki/BASIC_token> 

        .addr   @end            ; pointer to next line
        .word   1               ; BASIC line-number
        
        .byte   $9e             ; "SYS"

        ; convert the address of the machine language routine, that comes after
        ; this BASIC program, to PETSCII decimals, i.e. "2061". this trick
        ; taken from CC65's "exehdr.s" file by Ullrich von Bassewitz
        .byte   <(((@copy /  1000) .mod 10) + '0')
        .byte   <(((@copy /   100) .mod 10) + '0')
        .byte   <(((@copy /    10) .mod 10) + '0')
        .byte   <(((@copy /     1) .mod 10) + '0')

        .byte   0               ; end of line
        
        ; end of program
@end:   .word   $0000
        
        ; immediately following the BASIC bootstrap is a small
        ; machine-langauge routine to copy the program to its intended location
        ;-----------------------------------------------------------------------

        ; NOTE: the linker configuration ("link/elite-original-gma86.cfg")
        ;       defines the segments, their addresses, and exports those
        ;       values for use here:

.import __FIREBIRD_START__      ; get the load address of the program
.import __FIREBIRD_LAST__       ; and the last address used (i.e. size)
.import __BASIC_STAGE0_RUN__    ; and, as seen by BASIC, i.e. $0801

        ; get the size of the segments to be able to
        ; calculate the size of the whole program

@copy:  ; the BASIC bootstrap `SYS` calls here:                         ;$080D

        ; calculate the length of FIREBIRD.PRG (sans PRG header)
        size = __FIREBIRD_LAST__ - __FIREBIRD_START__

        ; note that these are 16-bit data types and the `ldx` is limited to
        ; 8-bit values so we have to coerce the result to 8-bits using the
        ; lower-byte `<`. this means that the total program size CANNOT exceed
        ; 255 bytes! for reasons of disk optimisation, we use a limit of 254
        ; bytes instead to fit wholly within one disk sector
        ldx #< size

        .assert (size <= 254), error, "Program exceeds one disk sector!"
        
:       lda __BASIC_STAGE0_RUN__, x     ; copy from $0801..
        sta __FIREBIRD_START__, x       ; to $02A7..
        dex 
        bpl :-

        jmp start


.segment        "CODE_STAGE0"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
filename:                                                               ;$02c1
        ;-----------------------------------------------------------------------
        .byte   "gm*"           ; $47, $4D, $2A (PETSCII)

start:                                                                  ;$02c1
        ;-----------------------------------------------------------------------
        ; call Kernel SETMSG, "Set system error display switch at
        ; memory address $009D". A = the switch value.
        ; i.e. disable error messages?
        lda # $00
        jsr KERNAL_SETMSG

        ; set file parameters:
        lda # $02               ; logical file number
        ldx # $08               ; device number == drive 8
        ldy # $ff               ; "secondary address"
                                ; (i.e. use the PRG load address)
        jsr KERNAL_SETLFS

        ; set file name
        lda # $03               ; length of file name
        ldx #< filename         ; pointer to name address (lo)
        ldy #> filename         ; pointer to name address (hi)
        jsr KERNAL_SETNAM

        ; load file:
        ; note that the "secondary address" has been set as non-zero,
        ; telling the drive to use the load address present in the PRG file
        lda # $00               ; = LOAD
        jsr KERNAL_LOAD
    
        ; change the address of STOP key routine from $F6ED, to $FFED:
        ; the SCREEN routine which returns row/col count, i.e. does
        ; nothing of use -- this effectively disables the STOP key
        lda #> KERNAL_SCREEN
        sta KERNAL_VECTOR_STOP+1

        .repeat 24
        nop 
        .endrepeat

        ; get the address where GMA1.PRG loads from the linker
        ; (see "link/elite-original-gma86.cfg")
.import __CODE_STAGE1A_LOAD__

        jmp __CODE_STAGE1A_LOAD__


.segment        "BASIC_VECTORS"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; these are various vectors for BASIC -- the loader hijacks these to cause
; the loader to start immediately without the need for a BASIC bootstrap

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
