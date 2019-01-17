; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.define ELITE_SEED      $4a, $5a, $48, $02, $53, $B7

; the BBC micro used a 256-px wide screen mode, but the C64 has a 320-px wide
; screen. therefore the C64 only draws in a 256-px wide centered 'screen'.
; the dimensions of this viewport are given here:

; (DON'T change this, the code is inextricably tied to this size)

ELITE_VIEWPORT_WIDTH    = 256
ELITE_VIEWPORT_HEIGHT   = 144

ELITE_VIEWPORT_COLS     = ELITE_VIEWPORT_WIDTH / 8      ;=32
