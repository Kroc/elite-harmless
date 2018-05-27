; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; unknown data table / scratch area

.segment        "DATA_1D00"

_1d00:                                                                  ;$1D00
.export _1d00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00                  ;$1D00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00                  ;$1D08
        .byte   $00 ,$00, $00, $00, $01, $36, $29, $2b                  ;$1D10
        .byte   $27, $1e, $1b, $1c, $2e, $17, $2c, $32                  ;$1D18
        .byte   $24                                                     ;$1D20
_1d21:                                                                  ;$1D21
        .byte   $60