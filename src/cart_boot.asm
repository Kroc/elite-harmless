; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "c64/c64.asm"

.segment        "CART_HEAD"

.cart_header    CART_TYPE::OCEAN, 0, 0, "elite : harmless"

.segment        "CART_CHIP_00"
.import         __CART_BANK_00_SIZE__, __CART_BANK_00_START__
.chip_header    __CART_BANK_00_SIZE__, 0, 0, __CART_BANK_00_START__

.segment        "CART_CHIP_01"
.import         __CART_BANK_01_SIZE__, __CART_BANK_01_START__
.chip_header    __CART_BANK_01_SIZE__, 0, 1, __CART_BANK_01_START__

.segment        "CART_CHIP_02"
.import         __CART_BANK_02_SIZE__, __CART_BANK_02_START__
.chip_header    __CART_BANK_02_SIZE__, 0, 2, __CART_BANK_02_START__

.segment        "CART_CHIP_03"
.import         __CART_BANK_03_SIZE__, __CART_BANK_03_START__
.chip_header    __CART_BANK_03_SIZE__, 0, 3, __CART_BANK_03_START__

.segment        "CART_CHIP_04"
.import         __CART_BANK_04_SIZE__, __CART_BANK_04_START__
.chip_header    __CART_BANK_04_SIZE__, 0, 4, __CART_BANK_04_START__

.segment        "CART_CHIP_05"
.import         __CART_BANK_05_SIZE__, __CART_BANK_05_START__
.chip_header    __CART_BANK_05_SIZE__, 0, 5, __CART_BANK_05_START__

.segment        "CART_CHIP_06"
.import         __CART_BANK_06_SIZE__, __CART_BANK_06_START__
.chip_header    __CART_BANK_06_SIZE__, 0, 6, __CART_BANK_06_START__

.segment        "CART_CHIP_07"
.import         __CART_BANK_07_SIZE__, __CART_BANK_07_START__
.chip_header    __CART_BANK_07_SIZE__, 0, 7, __CART_BANK_07_START__

.segment        "CART_CHIP_08"
.import         __CART_BANK_08_SIZE__, __CART_BANK_08_START__
.chip_header    __CART_BANK_08_SIZE__, 0, 8, __CART_BANK_08_START__

.segment        "CART_CHIP_09"
.import         __CART_BANK_09_SIZE__, __CART_BANK_09_START__
.chip_header    __CART_BANK_09_SIZE__, 0, 9, __CART_BANK_09_START__

.segment        "CART_CHIP_10"
.import         __CART_BANK_10_SIZE__, __CART_BANK_10_START__
.chip_header    __CART_BANK_10_SIZE__, 0, 10, __CART_BANK_10_START__

.segment        "CART_CHIP_11"
.import         __CART_BANK_11_SIZE__, __CART_BANK_11_START__
.chip_header    __CART_BANK_11_SIZE__, 0, 11, __CART_BANK_11_START__

.segment        "CART_CHIP_12"
.import         __CART_BANK_12_SIZE__, __CART_BANK_12_START__
.chip_header    __CART_BANK_12_SIZE__, 0, 12, __CART_BANK_12_START__

.segment        "CART_CHIP_13"
.import         __CART_BANK_13_SIZE__, __CART_BANK_13_START__
.chip_header    __CART_BANK_13_SIZE__, 0, 13, __CART_BANK_13_START__

.segment        "CART_CHIP_14"
.import         __CART_BANK_14_SIZE__, __CART_BANK_14_START__
.chip_header    __CART_BANK_14_SIZE__, 0, 14, __CART_BANK_14_START__

.segment        "CART_CHIP_15"
.import         __CART_BANK_15_SIZE__, __CART_BANK_15_START__
.chip_header    __CART_BANK_15_SIZE__, 0, 15, __CART_BANK_15_START__

.segment        "CART_CHIP_16"
.import         __CART_BANK_16_SIZE__, __CART_BANK_16_START__
.chip_header    __CART_BANK_16_SIZE__, 0, 16, __CART_BANK_16_START__

.segment        "CART_CHIP_17"
.import         __CART_BANK_17_SIZE__, __CART_BANK_17_START__
.chip_header    __CART_BANK_17_SIZE__, 0, 17, __CART_BANK_17_START__

.segment        "CART_CHIP_18"
.import         __CART_BANK_18_SIZE__, __CART_BANK_18_START__
.chip_header    __CART_BANK_18_SIZE__, 0, 18, __CART_BANK_18_START__

.segment        "CART_CHIP_19"
.import         __CART_BANK_19_SIZE__, __CART_BANK_19_START__
.chip_header    __CART_BANK_19_SIZE__, 0, 19, __CART_BANK_19_START__

.segment        "CART_CHIP_20"
.import         __CART_BANK_20_SIZE__, __CART_BANK_20_START__
.chip_header    __CART_BANK_20_SIZE__, 0, 20, __CART_BANK_20_START__

.segment        "CART_CHIP_21"
.import         __CART_BANK_21_SIZE__, __CART_BANK_21_START__
.chip_header    __CART_BANK_21_SIZE__, 0, 21, __CART_BANK_21_START__

.segment        "CART_CHIP_22"
.import         __CART_BANK_22_SIZE__, __CART_BANK_22_START__
.chip_header    __CART_BANK_22_SIZE__, 0, 22, __CART_BANK_22_START__

.segment        "CART_CHIP_23"
.import         __CART_BANK_23_SIZE__, __CART_BANK_23_START__
.chip_header    __CART_BANK_23_SIZE__, 0, 23, __CART_BANK_23_START__

.segment        "CART_CHIP_24"
.import         __CART_BANK_24_SIZE__, __CART_BANK_24_START__
.chip_header    __CART_BANK_24_SIZE__, 0, 24, __CART_BANK_24_START__

.segment        "CART_CHIP_25"
.import         __CART_BANK_25_SIZE__, __CART_BANK_25_START__
.chip_header    __CART_BANK_25_SIZE__, 0, 25, __CART_BANK_25_START__

.segment        "CART_CHIP_26"
.import         __CART_BANK_26_SIZE__, __CART_BANK_26_START__
.chip_header    __CART_BANK_26_SIZE__, 0, 26, __CART_BANK_26_START__

.segment        "CART_CHIP_27"
.import         __CART_BANK_27_SIZE__, __CART_BANK_27_START__
.chip_header    __CART_BANK_27_SIZE__, 0, 27, __CART_BANK_27_START__

.segment        "CART_CHIP_28"
.import         __CART_BANK_28_SIZE__, __CART_BANK_28_START__
.chip_header    __CART_BANK_28_SIZE__, 0, 28, __CART_BANK_28_START__

.segment        "CART_CHIP_29"
.import         __CART_BANK_29_SIZE__, __CART_BANK_29_START__
.chip_header    __CART_BANK_29_SIZE__, 0, 29, __CART_BANK_29_START__

.segment        "CART_CHIP_30"
.import         __CART_BANK_30_SIZE__, __CART_BANK_30_START__
.chip_header    __CART_BANK_30_SIZE__, 0, 30, __CART_BANK_30_START__

.segment        "CART_CHIP_31"
.import         __CART_BANK_31_SIZE__, __CART_BANK_31_START__
.chip_header    __CART_BANK_31_SIZE__, 0, 31, __CART_BANK_31_START__

;===============================================================================

.segment        "CODE_INIT"

; <http://blog.worldofjani.com/?p=879>

        .addr   cold_start      ; jump when powering on the C64         ;$8000
        .addr   warm_start      ; jump when the RESTORE key is pressed  ;$8002
     
        ; "CBM80" cartridge identifier
        .byte   $c3, $c2, $cd, $38, $30                                 ;$8004

; the C64's RESTORE key fires a Non-Maskable Interrupt -- the CPU stops what-
; ever it was doing and jumps to the memory location given by the KERNAL ROM
; (if present) in $FFFE/F. the KERNAL pushes the reigsters to the stack and
; then exectues (in the case of cartridges) the "warm start" address above.
; this process was intended as a way for users to escape back to BASIC without
; having to physically remove the cartridge. this isn't typically the pattern
; used today as people are either playing emulators or are using flash-carts
; with their own menus & escape procedures. also, it's not nice to crash out
; of the game you were playing because you accidentally hit the RESTORE key!
;
warm_start:                                                             ;$8009
        ;-----------------------------------------------------------------------
        ; this is a location within the KERNAL that returns from an interrupt
        ; -- it restores the registers from the stack and returns execution
        ; back to before the interrupt happened
        jmp $FEBC

cold_start:                                                             ;$800C
        ;-----------------------------------------------------------------------
        ; this is the bootstrap for the cartridge; we have side-stepped the
        ; standard C64 initialisation routines so we should ensure the machine
        ; is setup how we expect it to be
        ;
        sei                     ; disable interrupts (for speed purposes)
        stx VIC_SCREEN_CTL2     ; turn on VIC for PAL / NTSC check
	jsr KERNAL_IOINIT       ; initialise CIA chips
	jsr KERNAL_RAMTAS       ; clear zero-page, RAM, and set screen address
	jsr KERNAL_RESTOR       ; initialise the table of KERNAL vectors
	jsr $FF5B		; CINT   - Init VIC and screen editor
	cli			; Re-enable IRQ interrupts

        inc $d020
        jmp *-3
