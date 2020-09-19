; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "elite.inc"

.include        "math/math_3d.inc"
.include        "math/math_data.asm"

.include        "hulls/vars_hulls.inc"

.include        "vars_zeropage.asm"
.include        "text/code_docked_fns.inc"
.include        "code_keyboard.inc"

; due to a limitation, CA65 cannot 'look-ahead' for scopes (including procs &
; structs) and therefore our `PolyObject` struct must be loaded in before it
; is referenced anywhere, even though the code segment might be addressed
; much higher up in memory than this line might imply
;
.include        "vars_polyobj.asm"                                      ;$F900

.include        "vars_main.asm"                                         ;$0400
.include        "gfx/gfx_font.asm"                                      ;$0B00
.include        "vars_flags.asm"                                        ;$1D00

.segment        "CODE_1D81"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.include        "code_1D81.asm"                                         ;$1D81
.include        "text/code_docked.asm"                                  ;$2372
.include        "save_data.asm"                                         ;$25A6

.segment        "CODE_28BA"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.include        "code_28ba.asm"                                         ;$2ABA
.include        "gfx/gfx_sprites.asm"                                   ;$6800

.segment        "CODE_6A00"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.include        "code_6A00.asm"                                         ;$6A00
.include        "orig/orig_init.asm"                                    ;$75E4
.include        "gfx/gfx_bitmap.asm"

.segment        "CODE_9900"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.include        "code_9900.asm"                                         ;$9900
.include        "sound/code_sound.asm"                                  ;$B4CB
.include        "sound/data_sound.asm"                                  ;$B72D
.include        "hulls/data_hulls.asm"                                  ;$D000