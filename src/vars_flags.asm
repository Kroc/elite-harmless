; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; user preferences & some runtime flags
;
.segment        "VARS_FLAGS"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
_1d00:  ; nothing appears to actually reference $1D00 itself            ;$1D00
        .byte   $00
_1d01:
        .byte   $00
_1d02:
        .byte   $00

flag_music_playing:                                                     ;$1D03
        ; music currently playing?
        ; $00 = no, $FF = yes
        .byte   $00

_1d04:
        .byte   $00
_1d05:
        .byte   $00

        ; series of flags?

_1d06:          ; dampening toggle?
        .byte   $00
_1d07:          ; keyboard auto-recentrering?
        .byte   $00
_1d08:
        .byte   $00
_1d09:
        .byte   $00

opt_flipvert:   ; flip the vertical axis?                               ;$1D0A
        .byte   $00

opt_flipaxis:   ; flip both axises                                      ;$1D0B
        .byte   $00

_1d0c:
        .byte   $00
_1d0d:
        .byte   $00

opt_device:     ; selected media for data load/save:                    ;$1D0E
                ; $FF = disk, $00 = tape
        .byte   $00
_1d0f:
        .byte   $00
_1d10:
        .byte   $00
_1d11:
        .byte   $00

opt_sfx:        ; SFX enabled?                                          ;$1D12
                ; $00 = no, $FF = yes
                ; (this interpretation of this flag might be incorrect;
                ;  it could be an "SFX playing" flag, or for music instead)
        .byte   $00

;-------------------------------------------------------------------------------

_1d13:
        .byte   $00

;-------------------------------------------------------------------------------

_1d14:
        .byte   $01, $36, $29, $2b, $27, $1e, $1b, $1c
        .byte   $2e, $17, $2c, $32, $24
_1d21:                                                                  ;$1D21
        .byte   $60
