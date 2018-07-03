; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.define ELITE_SEED      $4a, $5a, $48, $02, $53, $B7

; the BBC micro used a 256-px wide screen mode, but the C64 has a 320-px wide
; screen. therefore the C64 only draws in a 256-px wide centered 'screen'.
; the dimensions of this viewport are given here:

ELITE_VIEWPORT_WIDTH    = 256
ELITE_VIEWPORT_HEIGHT   = 144

;-------------------------------------------------------------------------------

; Elite has a number of 'slots' for 3D-objects currently in play;
; e.g. ships, asteroids, space stations and other such polygon-objects
;
; huge thanks to "DrBeeb" for documenting the data structure on the Elite Wiki
; http://wiki.alioth.net/index.php/Classic_Elite_entity_states
;
.struct PolyObject                                                      ;offset
        ; NOTE: these are not addresses, but they are 24-bit
        ;SPEED: do we need 24 bits for this? Can we get away with 16?
        ;       surely +/- 32'767 is enough distance relative to the player?
        xpos            .faraddr                                        ;+$00
        ypos            .faraddr                                        ;+$03
        zpos            .faraddr                                        ;+$06

        ; a 3x3 rotation matrix?
        ; TODO: I don't know how best to name these yet
        m00             .word                                           ;+$09
        m01             .word                                           ;+$0B
        m02             .word                                           ;+$0D
        m10             .word                                           ;+$0F
        m11             .word                                           ;+$11
        m12             .word                                           ;+$13
        m20             .word                                           ;+$15
        m21             .word                                           ;+$17
        m22             .word                                           ;+$19

        ; a pointer to already processed vertex data
        vertexData      .addr                                           ;+$1B

        speed           .byte                                           ;+$1D
        acceleration    .byte                                           ;+$1E
        energy          .byte                                           ;+$1F
        roll            .byte                                           ;+$20
        pitch           .byte                                           ;+$21

        ; A.I. state
        attack          .byte                                           ;+$22
        behaviour       .byte                                           ;+$23
        state           .byte                                           ;+$24
.endstruct