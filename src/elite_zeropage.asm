; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; the zero page ($00-$FF) can be accessed faster than other memory, with a few
; caveats and bugs, so the most speed-critical variables should be stored here

; note that a zero page address may very well be re-used for different purposes
; in different code and so expect some overlap

.segment        "ZEROPAGE"

