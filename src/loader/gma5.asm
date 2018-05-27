; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.segment    "CODE_1D00"

.include    "../../build/gma5_bin.s"

; trailing, un-ecrypted bytes
        .byte   $b3, $00, $ff, $00