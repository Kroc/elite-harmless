; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; "gma6.prg" - this is an encrypted payload and will be disassembled soon

.data
.org    $6a00

.include        "../build/gma6_bin.s"

.reloc

; these bytes are not encrypted!!! (they're the background-fill)
; the linker will exclude these from the binary of the data-to-be-encrypted.
; when the code is re-linked with the encrypted blob, these bytes are appended

.segment        "FILL"

        .byte   $49, $ff, $00, $ff, $00, $ff, $00, $ff                  ;$CCD7
        .byte   $00, $ff                                                ;$CCDF

;$CCE1