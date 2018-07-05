; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; "var_zeropage.asm" -- special variables in the Zero Page;
; 256 bytes of slightly faster memory

; note that $00 & $01 are hard-wired to the CPU, so can't be used

;-------------------------------------------------------------------------------

; "goat soup" is the algorithm for generating planet descriptions.
; its seed is taken from the last four bytes of the main seed 
ZP_GOATSOUP             = $02
ZP_GOATSOUP_pt1         = $02
ZP_GOATSOUP_pt2         = $03
ZP_GOATSOUP_pt3         = $04
ZP_GOATSOUP_pt4         = $05

;-------------------------------------------------------------------------------

ZP_TEMP_VAR             = $06   ; a temporary single byte
ZP_TEMP_ADDR1           = $07   ; a temporary word / addr
ZP_TEMP_ADDR1_LO        = $07
ZP_TEMP_ADDR1_HI        = $08

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
        ai_attack       .byte                                           ;+$22
        ai_behaviour    .byte                                           ;+$23
        ai_state        .byte                                           ;+$24
.endstruct

ZP_POLYOBJ              = $09
ZP_POLYOBJ_XPOS         = $09
ZP_POLYOBJ_XPOS_pt1     = $09
ZP_POLYOBJ_XPOS_pt2     = $0a
ZP_POLYOBJ_XPOS_pt3     = $0b
ZP_POLYOBJ_YPOS         = $0c
ZP_POLYOBJ_YPOS_pt1     = $0c
ZP_POLYOBJ_YPOS_pt2     = $0d
ZP_POLYOBJ_YPOS_pt3     = $0e
ZP_POLYOBJ_ZPOS         = $0f
ZP_POLYOBJ_ZPOS_pt1     = $0f
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
ZP_POLYOBJ_M1x1         = $1a
ZP_POLYOBJ_M1x1_LO      = $1a
ZP_POLYOBJ_M1x1_HI      = $1b
ZP_POLYOBJ_M1x2         = $1c
ZP_POLYOBJ_M1x2_LO      = $1c
ZP_POLYOBJ_M1x2_HI      = $1d
ZP_POLYOBJ_M2x0         = $1e
ZP_POLYOBJ_M2x0_LO      = $1e
ZP_POLYOBJ_M2x0_HI      = $1f
ZP_POLYOBJ_M2x1         = $20
ZP_POLYOBJ_M2x1_LO      = $20
ZP_POLYOBJ_M2x1_HI      = $21
ZP_POLYOBJ_M2x2         = $22
ZP_POLYOBJ_M2x2_LO      = $22
ZP_POLYOBJ_M2x2_HI      = $23

ZP_POLYOBJ_VERTX        = $24
ZP_POLYOBJ_VERTX_LO     = $24
ZP_POLYOBJ_VERTX_HI     = $25

;-------------------------------------------------------------------------------

ZP_ROTX                 = $26   ; rotate-X counter? "roll"
ZP_ROTZ                 = $27   ; rotate-Z counter? "pitch"

ZP_MISSILE_STATE        = $28   ; BBC says "display/exploding state|missiles"??

;                       = $29   ; something to do with A.I.

ZP_TEMP_ADDR2           = $2a   ; another temporary address
ZP_TEMP_ADDR2_LO        = $2a
ZP_TEMP_ADDR2_HI        = $2b

ZP_VAR_P                = $2e   ; a common variable called "P"
ZP_VAR_P1               = $2e
ZP_VAR_P2               = $2f
ZP_VAR_P3               = $30

;-------------------------------------------------------------------------------

ZP_CURSOR_COL           = $31
ZP_CURSOR_ROW           = $33
;                       = $34   ; case switch for flight strings?

;-------------------------------------------------------------------------------

; the X/Y/Z-position of `POLYOBJ_01` are copied here
ZP_POLYOBJ01            = $35
ZP_POLYOBJ01_XPOS       = $35
ZP_POLYOBJ01_XPOS_pt1   = $35
ZP_POLYOBJ01_XPOS_pt2   = $36
ZP_POLYOBJ01_XPOS_pt3   = $37
ZP_POLYOBJ01_YPOS       = $38
ZP_POLYOBJ01_YPOS_pt1   = $38
ZP_POLYOBJ01_YPOS_pt2   = $39
ZP_POLYOBJ01_YPOS_pt3   = $3a
ZP_POLYOBJ01_ZPOS       = $3b
ZP_POLYOBJ01_ZPOS_pt1   = $3b
ZP_POLYOBJ01_ZPOS_pt2   = $3c
ZP_POLYOBJ01_ZPOS_pt3   = $3d

; only ever used once to check for non-zero X/Y/Z-position
ZP_POLYOBJ01_POS        = $3e

;-------------------------------------------------------------------------------

;                       = $3f   ; a flag, but never gets set; see `_3571`

;                       = $40   ; never used?
;                       = $41   ; never used?
;                       = $42   ; never used?

;                       = $43   ; something to do with viewport height

;                       = $44   ; often related to `ZP_POLYOBJ01_XPOS_pt2`

;-------------------------------------------------------------------------------

; a working copy of the zero-page poly object rotation matrix:

ZP_TEMPOBJ_M2x0         = $45
ZP_TEMPOBJ_M2x0_LO      = $45
ZP_TEMPOBJ_M2x0_HI      = $46
ZP_TEMPOBJ_M2x1         = $47
ZP_TEMPOBJ_M2x1_LO      = $47
ZP_TEMPOBJ_M2x1_HI      = $48
ZP_TEMPOBJ_M2x2         = $49
ZP_TEMPOBJ_M2x2_LO      = $49
ZP_TEMPOBJ_M2x2_HI      = $4a

ZP_TEMPOBJ_M1x0         = $4b
ZP_TEMPOBJ_M1x0_LO      = $4b
ZP_TEMPOBJ_M1x0_HI      = $4c
ZP_TEMPOBJ_M1x1         = $4d   ;TODO: not referenced directly?
ZP_TEMPOBJ_M1x1_LO      = $4d   ; "
ZP_TEMPOBJ_M1x1_HI      = $4e   ; "
ZP_TEMPOBJ_M1x2         = $4f
ZP_TEMPOBJ_M1x2_LO      = $4f
ZP_TEMPOBJ_M1x2_HI      = $50

ZP_TEMPOBJ_M0x0         = $51
ZP_TEMPOBJ_M0x0_LO      = $51
ZP_TEMPOBJ_M0x0_HI      = $52
ZP_TEMPOBJ_M0x1         = $53
ZP_TEMPOBJ_M0x1_LO      = $53
ZP_TEMPOBJ_M0x1_HI      = $54
ZP_TEMPOBJ_M0x2         = $55   ;TODO: not referenced directly?
ZP_TEMPOBJ_M0x2_LO      = $55   ; "
ZP_TEMPOBJ_M0x2_HI      = $56   ; "

;-------------------------------------------------------------------------------

; pointer to a hull data structure:
; (verticies, edges, faces &c.)
ZP_HULL_ADDR            = $57
ZP_HULL_ADDR_LO         = $57
ZP_HULL_ADDR_HI         = $58

; a pointer to a PolyObject in RAM -- i.e. a currently in-play 3D object,
; such as a ship, asteroid or station
ZP_POLYOBJ_ADDR         = $59
ZP_POLYOBJ_ADDR_LO      = $59
ZP_POLYOBJ_ADDR_HI      = $5a

ZP_TEMP_ADDR3           = $5b
ZP_TEMP_ADDR3_LO        = $5b
ZP_TEMP_ADDR3_HI        = $5c

;-------------------------------------------------------------------------------

;                       = $5d   ; "VAR_XX_LO"?
;                       = $5e   ; "VAR_XX_HI"?

;                       = $5f   ; "VAR_YY_LO"?
;                       = $60   ; "VAR_YY_HI"?

;                       = $61   ; "SUNX_LO"?    location of SUN on screen?
;                       = $62   ; "SUNX_HI"?

;                       = $63   ;?
;                       = $64   ;?

;-------------------------------------------------------------------------------

;                       = $65   ; hyperspace counter (inner)
;                       = $66   ; hyperspace counter (outer)

;-------------------------------------------------------------------------------

;                       = $67   ;?

;                       = $68   ; "roll magnitude"?
;                       = $69   ; "roll sign"?

;                       = $6a   ; "move count"?

;-------------------------------------------------------------------------------

ZP_VAR_X                = $6b   ; a common "X" variable
ZP_VAR_Y                = $6c   ; a common "Y" variable

ZP_VAR_X2               = $6d   ; a secondary "X" variable
ZP_VAR_Y2               = $6e   ; a secondary "Y" variable

;                       = $6f   ; `ZP_VAR_Z`?
;                       = $70   ; `ZP_VAR_Y3` / `ZP_VAR_Z2`?

;-------------------------------------------------------------------------------


ZP_SEED                 = $7f
ZP_SEED_pt1             = $7f
ZP_SEED_pt2             = $80
ZP_SEED_pt3             = $81
ZP_SEED_pt4             = $82
ZP_SEED_pt5             = $83
ZP_SEED_pt6             = $84

;-------------------------------------------------------------------------------

PLAYER_SPEED            = $96

;-------------------------------------------------------------------------------

VAR_Z                   = $a1   ; a common "Z" variable
