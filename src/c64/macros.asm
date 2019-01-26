; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.macro .phx             ; "Push X"
        txa 
        pha 
.endmacro

.macro .plx             ; "Pull X"
        pla 
        tax 
.endmacro

.macro .phy             ; "Push Y"
        tya 
        pha 
.endmacro

.macro .ply             ; "Pull Y"
        pla 
        tay 
.endmacro

; the 6502 CPU has very difficult to grasp semantics when it comes to
; comparisons and branching when compared to the Z80. this can make it
; very non-obvious whether a branch is `>`, `>=`, `<` or `<=`
;
; see this page for details on comparisons and branching:
; http://www.6502.org/tutorials/compare_instructions.html
;
; the set of macros below provide more visibly recognisable names;
; these macros are already defined in CC65's "generic.mac", but this is pretty
; non-obvious, even to a CC65 user and I'd prefer to place them somewhere
; visible. (in these, a leading dot is included in the names, to make it
; obvious that they are macros, and not original instructions)

.macro .bge     Arg     ; "branch on greater-than or equal"
        bcs     Arg
.endmacro

.macro .blt     Arg     ; "branch on less-than"
        bcc     Arg
.endmacro

.macro .bgt     Arg     ; "branch on greater-than"
        .local  L
        beq     L
        bcs     Arg
L:
.endmacro

.macro .ble     Arg     ; "branch on less-than or equal"
        beq     Arg
        bcc     Arg
.endmacro

.macro .bnz     Arg     ; "branch on not zero"
        bne     Arg
.endmacro

.macro .bze     Arg     ; "branch on zero"
        beq     Arg
.endmacro

.macro .seb             ; "set borrow"
        clc 
.endmacro

.macro .clb             ; "clear borrow"
        sec 
.endmacro

.macro .bbw     Arg     ; "branch on borrow"
        bcc     Arg
.endmacro

.macro .bnb     Arg     ; "branch on no-borrow"
        bcs     Arg
.endmacro

; an optimisation, to avoid extra branching, is to jump into the middle of an
; instruction which is then interpretted as some other instruction. a common
; example of this is using the `bit` instruction as a 'do nothing' instruction
; with the option to jump over the `bit` opcode and treat the 2-byte parameter
; as a different instruction:
;
;     bit $00a9 ;<-- this is `lda # $00` if you skip the `bit` opcode
;
; this macro simply outputs the opcode for the `bit` instruction, causing the
; next 2-byte instruction to be 'ignored'. for example:
;
;     do_one_thing:
;         lda # $ff
;        .bit           ; skip the next `lda` by making it a `bit` instruction
;
;     do_a_different_thing:
;         lda # $00
;
.macro .bit
        .byte   $2c
.endmacro

; this does the same thing,
; but using a `cmp $????` instruction

.macro .cmp
        .byte   $cd
.endmacro