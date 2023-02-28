; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "orig_debug.asm":
;
.segment    "ORIG_1E14"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

debug_for_brk:                                                          ;$1E14
;===============================================================================
; set a routine to capture use of the `brk` instruction:
; not actually used, but present, in original Elite
;-------------------------------------------------------------------------------
        lda #< debug_brk
        sei                     ; disable interrupts
        sta KERNAL_VECTOR_BRK+0
        lda #> debug_brk
        sta KERNAL_VECTOR_BRK+1
        cli                     ; enable interrupts

        rts 
