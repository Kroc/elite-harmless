; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "elite.inc"

.include        "math.inc"
.include        "math_3d.inc"
.include        "math_data.asm"

.include        "gfx/hull_struct.inc"

.include        "vars_zeropage.asm"
.include        "text/text_docked_fns.inc"
.include        "code_keyboard.inc"

; due to a limitation, CA65 cannot 'look-ahead' for scopes (including procs &
; structs) and therefore our `PolyObject` struct must be loaded in before it
; is referenced anywhere, even though the code segment might be addressed
; much higher up in memory than this line might imply
;
.include        "vars_polyobj.asm"                                      ;$F900

.include        "vars_main.inc"                                         ;$0400

.include        "gfx/gfx_font.asm"                                      ;$0B00

.include        "vars_user.asm"                                         ;$1D00

.segment        "CODE_1D81"
.include        "code_1D81.asm"                                         ;$1D81

.include        "save_data.asm"                                         ;$25A6

.segment        "CODE_28A4"
.include        "code_2A84.asm"                                         ;$2A84

.include        "gfx/gfx_sprites.asm"                                   ;$6800

.segment        "CODE_6A00"
.include        "code_6A00.asm"                                         ;$6A00

.include        "orig_init.asm"                                         ;$75E4

.include        "gfx/bitmap.asm"                                        ;$9700

.segment        "CODE_9900"
.include        "code_9900.asm"                                         ;$9900

.include        "sound.asm"                                             ;$B4CB

.include        "gfx/hull_data.asm"                                     ;$D000
.include        "gfx/hud_copy.asm"                                      ;$EF90