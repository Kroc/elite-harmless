; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.segment    "ENCRYPTED_GMA5"

.include    "../../build/gma5_bin.s"

        ; trailing, un-ecrypted bytes
        .byte   $00, $ff, $00