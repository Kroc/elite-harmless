; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; unknown variable space

.export _1d01
.export _1d02
.export _1d03
.export _1d04
.export _1d05
.export _1d06
.export _1d07
.export _1d08
.export _1d09
.export opt_flipvert
.export opt_flipaxis
.export _1d0c
.export _1d0d
.export _1d0e
.export _1d0f
.export _1d10
.export _1d11
.export _1d12
.export _1d13
.export _1d14
.export _1d21

.segment        "VARS_1D00"


_1d00:  ; nothing appears to actually reference $1D00 itself            ;$1D00
        .byte   $00
_1d01:
        .byte   $00
_1d02:
        .byte   $00
_1d03:
        .byte   $00
_1d04:
        .byte   $00
_1d05:
        .byte   $00

        ; series of flags?
_1d06:
        .byte   $00
_1d07:
        .byte   $00
_1d08:
        .byte   $00
_1d09:
        .byte   $00

opt_flipvert:           .byte   $00     ; flip the vertical axis?       ;$1D0A

opt_flipaxis:           .byte   $00     ; flip both axises              ;$1D0B

_1d0c:
        .byte   $00
_1d0d:
        .byte   $00
_1d0e:
        .byte   $00
_1d0f:
        .byte   $00
_1d10:
        .byte   $00
_1d11:
        .byte   $00
_1d12:
        .byte   $00
_1d13:
        .byte   $00

        ; default values (or some-such) for the above flags?
_1d14:
        .byte   $01, $36, $29, $2b, $27, $1e, $1b, $1c
        .byte   $2e, $17, $2c, $32, $24
_1d21:                                                                  ;$1D21
        .byte   $60
