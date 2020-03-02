; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "elite.inc"

.include        "math/math_3d.inc"

.include        "gfx/hull_struct.inc"

.include        "vars_zeropage.asm"
.include        "text/text_docked_fns.inc"
.include        "code_keyboard.inc"

.include        "code_init.asm"                                         ;$0400
; (must be below "code_init.asm" due to appending of code to `CODE_INIT` above)
.include        "math/math_data.asm"

; due to a limitation, CA65 cannot 'look-ahead' for scopes (including procs &
; structs) and therefore our `PolyObject` struct must be loaded in before it
; is referenced anywhere, even though the code segment might be addressed
; much higher up in memory than this line might imply
;
.include        "vars_polyobj.asm"                                      ;$F900

.include        "vars_main.inc"                                         ;$0400

.include        "gfx/gfx_font.asm"                                      ;$0B00

.include        "vars_flags.asm"                                        ;$1D00

; in elite-harmless we conjoin
; these code segments together:
;
.segment        "CODE_LORAM"
;-------------------------------------------------------------------------------
.include        "code_1D81.asm"                                         ;$1D81
.include        "code_2A84.asm"                                         ;$2A84
.include        "save_data.asm"                                         ;$25A6
.include        "gfx/gfx_sprites.asm"                                   ;$6800

; in elite-harmless we conjoin
; these code segments together:
;
.segment        "CODE_HIRAM"
;-------------------------------------------------------------------------------
.include        "code_6A00.asm"                                         ;$6A00
.include        "code_9900.asm"                                         ;$9900

.ifndef         OPTION_NOSOUND
;///////////////////////////////////////////////////////////////////////////////
.include        "sound.asm"                                             ;$B4CB
;///////////////////////////////////////////////////////////////////////////////
.endif

.include        "gfx/hull_data.asm"                                     ;$D000

.include        "gfx/gfx_bitmap.asm"