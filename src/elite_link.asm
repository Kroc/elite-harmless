; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; "elite_link.asm" : exports some values for the linker to use. this is
; designed to avoid having to define values both in the source and in
; the linker configs (and keep them in sync)

.include        "c64/c64.asm"
.include        "elite_consts.asm"

;-------------------------------------------------------------------------------

; get from the linker the base address of the selected VIC bank. this is used
; to position the segments that *must* be present within the 16K memory region
; that the VIC is limited to; this includes the bitmap screen, the text/colour
; screens and the sprites
.import LINK_VIC_ADDR

.export ELITE_MENUSCR_ADDR :absolute \
        = LINK_VIC_ADDR + ELITE_VIC_MENUSCR * $0400
.export ELITE_MAINSCR_ADDR :absolute \
        = LINK_VIC_ADDR + ELITE_VIC_MAINSCR * $0400

.import __GFX_SPRITES_RUN__
.export ELITE_SPRITES_ADDR :absolute \
        = __GFX_SPRITES_RUN__

; defines the first sprite index
; (offset from LINK_VIC_ADDR, divided by 64)
.export ELITE_SPRITES_INDEX :direct \
        =< ((ELITE_SPRITES_ADDR - LINK_VIC_ADDR) / 64)

.segment        "VIC_BITMAP"

; if we force the 8K alignment required by bitmap screens, the linker will
; issue a warning that this is "suspiciously large"!
;.align          $2000

.res    $2000