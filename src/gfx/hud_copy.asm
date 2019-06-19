; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

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
.local  length

        offset .set (2 + (row * 320) + (col * 8))
        length .set (chars * 8)

.incbin "build/hud_koala.koa", offset, length

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .koala_screen   row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the screen data in the Koala file:
;
; - PRG header: 2 bytes
; - skip bitmap data (8'000 bytes)
; - the screen data is a 1'000 byte array of 40x25 chars
;
.local  offset
        offset .set (2 + 8000 + (row * 40) + col)

.incbin "build/hud_koala.koa", offset, chars

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .koala_color    row, col, chars
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; read from the colour RAM data in the Koala file:
;
; - PRG header: 2 bytes
; - skip bitmap data (8'000 bytes)
; - screen data is a 1'000 bytes
; - the colour RAM data is a 1'000 byte array of 40x25 chars
;
.local  offset
        offset .set (2 + 8000 + 1000 + (row * 40) + col)

.incbin "build/hud_koala.koa", offset, chars

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; this is the multi-colour bitmap data for the HUD. note that this is the
; copy of the HUD kept in RAM for restoring a fresh copy of the HUD when
; refreshing the screen, not the HUD as it exists on the bitmap screen
;
.segment        "HUD_COPY"

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

        ;$F870
        
.else   ;///////////////////////////////////////////////////////////////////////
        .koala_bitmap   24, 4, 32
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; screen RAM colour:
;
; TODO: like the HUD, there's wasted bytes here too
;
; in the original game this is a block of data that is copied to the screen RAM
; during initialisation and then erased by the bitmap. in elite-harmless we are
; including the screens pre-filled in the binary, so this temporary copy is not
; needed
;
ELITE_HUD_COLORSCR_ADDR := ELITE_MAINSCR_ADDR + .scrpos(18, 0)

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
.segment        "HUD_COLORSCR"

; `proc` is used so that `.sizeof(hud_screenram_copy)` is available
.proc   hud_screenram_copy                                              ;$783A

        ; include the screen RAM data (for the HUD) from the Koala file
        .koala_screen   18, 0, (7 * 40)
        ; trailing junk bytes that appear in the original game data
        .byte   $60, $d3, $66, $1d, $a0, $40, $b3, $d3

.endproc
;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================
; Elite uses two screens for bitmap colour data (excluding colour RAM at $D800)
; one for the main "flight screen" which needs to include the colour data for
; the HUD and a second screen for the "menu", which doesn't have the HUD
; 
; the linker script ("link/elite-*.cfg") defines where these screens are
; in RAM, we only have to reserve their bytes here
;
.segment        "VIC_SCR_MENU"
;-------------------------------------------------------------------------------
.res            $0400

.segment        "VIC_SCR_MAIN"
;-------------------------------------------------------------------------------
.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; include the entire default screen RAM
        .koala_screen   0, 0, 1000
.else   ;///////////////////////////////////////////////////////////////////////
        .res            $0400
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; colour RAM ($D800..) nybbles:
;
; this data is used only once to initialise colour RAM and is not referred to
; again. ergo, the segment address is not colour RAM itself ($D800) but the
; address in the game binary where the data is to copy to colour RAM during
; initialisation
;
.segment        "HUD_COLORRAM"

; `proc` is used so that `.sizeof(hud_colorram_copy)` is available
.proc   hud_colorram_copy                                               ;$795A

        ; include the screen RAM data from the Koala file
        ; TODO: we could save space in the .PRG by combining the nybbles
        ;       into bytes and unpacking during initialization
        .koala_color    18, 0, (7 * 40)

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; trailing junk bytes that appear in the original game data
        .byte   $8d, $18, $8f, $50, $46, $7e, $a4, $f4
.endif  ;///////////////////////////////////////////////////////////////////////

.endproc