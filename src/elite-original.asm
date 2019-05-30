; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "elite.inc"

.include        "gfx/font.asm"                                          ;$0B00

.include        "vars_user.asm"                                         ;$1D00
.include        "code_1D81.asm"                                         ;$1D81
.include        "data_save.asm"                                         ;$25A6
.include        "code_2A84.asm"                                         ;$2A84
.include        "gfx/sprites.asm"                                       ;$6800
.include        "code_6A00.asm"                                         ;$6A00
.include        "orig_init.asm"                                         ;$75E4

.include        "gfx/bitmap.asm"                                        ;$9700

.include        "sound.asm"                                             ;$B4CB

.include        "vars_polyobj.asm"                                      ;$F900