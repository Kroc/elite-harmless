; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; can't 'export' macros?

.define ELITE_SEED  $4a, $5a, $48, $02, $53, $B7

; TODO: ideally this would be defined structurally; `.tag`?

ZP_SEED     = $7F
ZP_SEED_pt1 = $7F
ZP_SEED_pt2 = $80
ZP_SEED_pt3 = $81
ZP_SEED_pt4 = $82
ZP_SEED_pt5 = $83
ZP_SEED_pt6 = $84