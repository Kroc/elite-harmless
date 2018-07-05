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
        m0x0            .word                                           ;+$09
        m0x1            .word                                           ;+$0B
        m0x2            .word                                           ;+$0D
        m1x0            .word                                           ;+$0F
        m1x1            .word                                           ;+$11
        m1x2            .word                                           ;+$13
        m2x0            .word                                           ;+$15
        m2x1            .word                                           ;+$17
        m2x2            .word                                           ;+$19

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

ZP_POLYOBJ              = $09
ZP_POLYOBJ_XPOS         = $09
ZP_POLYOBJ_XPOS_pt1     = $09
ZP_POLYOBJ_XPOS_pt2     = $0A
ZP_POLYOBJ_XPOS_pt3     = $0B
ZP_POLYOBJ_YPOS         = $0C
ZP_POLYOBJ_YPOS_pt1     = $0C
ZP_POLYOBJ_YPOS_pt2     = $0D
ZP_POLYOBJ_YPOS_pt3     = $0E
ZP_POLYOBJ_ZPOS         = $0F
ZP_POLYOBJ_ZPOS_pt1     = $0F
ZP_POLYOBJ_ZPOS_pt2     = $10
ZP_POLYOBJ_ZPOS_pt3     = $11

ZP_POLYOBJ_M0x0         = $12
ZP_POLYOBJ_M0x0_LO      = $12
ZP_POLYOBJ_M0x0_HI      = $13
ZP_POLYOBJ_M0x1         = $14
ZP_POLYOBJ_M0x1_LO      = $14
ZP_POLYOBJ_M0x1_HI      = $15
ZP_POLYOBJ_M0x2         = $16
ZP_POLYOBJ_M0x2_LO      = $16
ZP_POLYOBJ_M0x2_HI      = $17
ZP_POLYOBJ_M1x0         = $18
ZP_POLYOBJ_M1x0_LO      = $18
ZP_POLYOBJ_M1x0_HI      = $19
ZP_POLYOBJ_M1x1         = $1A
ZP_POLYOBJ_M1x1_LO      = $1A
ZP_POLYOBJ_M1x1_HI      = $1B
ZP_POLYOBJ_M1x2         = $1C
ZP_POLYOBJ_M1x2_LO      = $1C
ZP_POLYOBJ_M1x2_HI      = $1D
ZP_POLYOBJ_M2x0         = $1E
ZP_POLYOBJ_M2x0_LO      = $1E
ZP_POLYOBJ_M2x0_HI      = $1F
ZP_POLYOBJ_M2x1         = $20
ZP_POLYOBJ_M2x1_LO      = $20
ZP_POLYOBJ_M2x1_HI      = $21
ZP_POLYOBJ_M2x2         = $22
ZP_POLYOBJ_M2x2_LO      = $22
ZP_POLYOBJ_M2x2_HI      = $23

ZP_POLYOBJ_VERTX        = $24
ZP_POLYOBJ_VERTX_LO     = $24
ZP_POLYOBJ_VERTX_HI     = $25