; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; this is the multi-colour bitmap data for the HUD

.segment        "HUD_DATA"

; the game's default viewport/HUD data is stored in "hud_koala.asm",
; and during the build process, this is assembled into a Koala Painter
; image file "build/hud_koala.koa" -- the bytes that will go into the
; game are extracted from that image file here

.macro  .koala_bitmap   row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the bitmap data in the Koala file:
;
; - PRG header: 2 bytes
; - bitmap data comes first so we just need to multiply up row & column
;
.local  offset
        offset .set (2 + (row * 320) + (col * 8))
.local  length
        length .set (chars * 8)

.incbin "build/hud_koala.koa", offset, length

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; in what is probably one of the most egregious cases of wasted CPU time and
; space in Elite C64, the backup HUD bitmap actually contains all the blank
; space on the left and right from where the C64's screen is 320px wide,
; rather than 256px like on the BBC
; 
; therefore in elite-harmless, we only include 256px wide rows,
; and the routine to redraw the HUD accounts for this
;
; ROW 1                                                                 ;$EF90
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   18, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   18, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 2
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   19, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   19, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 3
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   20, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   20, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 4
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   21, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   21, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 5
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   22, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   22, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 6
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   23, 0, 40
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   23, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

; ROW 7
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   24, 0, 40

        ; blank padding in the original game
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00

        ; who are you, and what are
        ; you doing in my house!?
        .byte   $f5

.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   24, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

;$F870:

;===============================================================================
; TODO: like the HUD, there's wasted bytes here too
;
.segment        "HUD_COLORSCR"

ELITE_HUD_COLORSCR_ADDR = ELITE_MAINSCR_ADDR + .scrpos(18, 0)

; screen RAM colour

; `proc` is used so that `.sizeof(hud_screenram_copy)` is available
;
.proc   hud_screenram_copy                                              ;$783A

        .byte   $00, $00, $00, $07, $17, $17, $74, $74
        .byte   $74, $74, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $67, $27, $27, $27
        .byte   $27, $27, $37, $37, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $17, $17, $24, $24
        .byte   $24, $24, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $67, $67, $67, $67, $23, $23
        .byte   $23, $23, $37, $37, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $37, $37, $29, $29
        .byte   $29, $29, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $67, $27, $23, $23
        .byte   $23, $23, $37, $37, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $37, $37, $28, $28
        .byte   $28, $28, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $24, $24
        .byte   $24, $24, $17, $17, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $37, $37, $2a, $2a
        .byte   $2a, $2a, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $24, $24
        .byte   $24, $24, $17, $17, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $37, $37, $2d, $2d
        .byte   $2d, $2d, $27, $07, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $07, $27, $24, $24
        .byte   $24, $24, $17, $17, $07, $00, $00, $00
        .byte   $00, $00, $00, $07, $c7, $c7, $07, $07
        .byte   $07, $07, $27, $07, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $27, $27, $27, $27
        .byte   $27, $27, $27, $27, $07, $27, $24, $24
        .byte   $24, $24, $17, $17, $07, $00, $00, $00

        .byte   $60, $d3, $66, $1d, $a0, $40, $b3, $d3
.endproc

.segment        "HUD_COLORRAM"

; colour RAM ($D800..) nybbles

; TODO: we could save space in the .PRG by storing these by combining
;       the nybbles into bytes and unpacking during initialization

; `proc` is used so that `.sizeof(hud_colorram_copy)` is available
;
.proc   hud_colorram_copy                                               ;$795A

        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $05, $05, $05, $05, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $05, $05, $05, $05, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $05, $05, $05, $05, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $05, $05, $05, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $05, $05, $05, $05
        .byte   $05, $05, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $05, $05
        .byte   $05, $05, $05, $05, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $0f, $0f, $07, $07
        .byte   $07, $07, $0d, $0d, $0d, $0d, $0d, $0d
        .byte   $0d, $03, $03, $03, $03, $03, $0d, $0d
        .byte   $0d, $0d, $0d, $0d, $0d, $0d, $07, $07
        .byte   $07, $07, $05, $05, $00, $00, $00, $00

        .byte   $8d, $18, $8f, $50, $46, $7e, $a4, $f4
.endproc