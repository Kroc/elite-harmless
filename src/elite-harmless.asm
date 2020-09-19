; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "elite-harmless.asm":
;
.include        "elite.inc"

.include        "math/math_3d.inc"

.include        "hulls/vars_hulls.inc"

.include        "vars_zeropage.asm"
.include        "text/code_docked_fns.inc"
.include        "code_keyboard.inc"

.include        "code_init.asm"
; (must be below "code_init.asm" due to appending of code to `CODE_INIT` above)
.include        "math/math_data.asm"

; due to a limitation, CA65 cannot 'look-ahead' for scopes (including procs &
; structs) and therefore our `PolyObject` struct must be loaded in before it
; is referenced anywhere, even though the code segment might be addressed
; much higher up in memory than this line might imply
;
.include        "vars_polyobj.asm"

.include        "vars_main.asm"

.include        "gfx/gfx_font.asm"

.include        "vars_flags.asm"

.include        "code_1D81.asm"
.include        "text/code_docked.asm"
.include        "code_28ba.asm"
.include        "math/math_square.asm"

.include        "save_data.asm"
.include        "gfx/gfx_sprites.asm"

.include        "code_6A00.asm"
.include        "code_9900.asm"
.include        "math/math_square_root.asm"

.ifdef  FEATURE_FASTLINES
        ;///////////////////////////////////////////////////////////////////////
        .include        "draw_fastlines.asm"
.else   ;///////////////////////////////////////////////////////////////////////
        ; standard / original line-drawing code
        .include        "draw_lines.asm"
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        .include        "sound/code_sound.asm"
        .include        "sound/data_sound.asm"
.endif  ;///////////////////////////////////////////////////////////////////////

.include        "hulls/data_hulls.asm"
.include        "gfx/gfx_bitmap.asm"