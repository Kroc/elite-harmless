; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "elite-original.asm":
;
.include        "elite.inc"

.include        "math/math_3d.inc"
.include        "math/math_data.asm"

.include        "hulls/vars_hulls.inc"

.include        "vars_zeropage.asm"
.include        "text/text_docked_fns.inc"
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

.include        "code_1D81.asm"                                         ;$1D81
.include        "orig/orig_debug.asm"                                   ;$1E14
.include        "main_flight.asm"                                       ;$1E21
.include        "text/text_docked_code.asm"                             ;$2372
.include        "save_data.asm"                                         ;$25A6

.include        "code_28ba.asm"                                         ;$28BA
.include        "math/math_square.asm"                                  ;$3986
.include        "gfx/gfx_sprites.asm"                                   ;$6800

.include        "code_6A00.asm"                                         ;$6A00
.include        "orig/orig_init.asm"                                    ;$75E4
.include        "gfx/gfx_bitmap.asm"

.include        "code_9900.asm"                                         ;$9900
.include        "math/math_square_root.asm"                             ;$9978
.include        "code_interrupts.asm"                                   ;$A8D9
.include        "draw_lines.asm"                                        ;$AB31
.include        "orig/clear_screen.asm"                                 ;$B21A
.include        "sound/code_sound.asm"                                  ;$B4CB
.include        "sound/data_sound.asm"                                  ;$B72D
.include        "hulls/data_hulls.asm"                                  ;$D000