; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "var_zeropage.asm" -- special variables in the Zero Page;
; 256 bytes of slightly faster memory

; note that $00 & $01 are hard-wired to the CPU, so can't be used

; unanmed zero-page usage can be found with the following regex search:
; "\b([a-z]{3})(\s+)\$xx\b" where xx is the zero-page address

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

        roll            .byte                                           ;+$1D
        pitch           .byte                                           ;+$1E
        
        ; visibility state, see enum below
        visibility      .byte                                           ;+$1F
        ; attack state, see enum below
        attack          .byte                                           ;+$20

        speed           .byte                                           ;+$21
        acceleration    .byte                                           ;+$22
        energy          .byte                                           ;+$23

        ; behaviour state, see enum below
        behaviour       .byte                                           ;+$24
.endstruct

; visibilty state and missile count
.enum   visibility
        exploding       = %10000000     ; is exploding!
        firing          = %01000000     ; is firing at player!
        display         = %00100000     ; display nodes (not distant dot)
        scanner         = %00010000     ; visible on scanner
        redraw          = %00001000     ; needs a redraw
        missiles        = %00000111     ; no. of missiles (or thargons)
.endenum

; A.I. attack state
.enum   attack
        active          = %10000000     ; use tactics; missiles updated often
        target          = %01000000     ; is targeting player
        aggression      = %00111110     ; aggression level / missile target I.D.
        aggr1           = %00000010     ; - aggression lvl.1
        aggr2           = %00000100     ; - aggression lvl.2
        aggr3           = %00001000     ; - aggression lvl.3
        aggr4           = %00010000     ; - aggression lvl.4
        aggr5           = %00100000     ; - agrression lvl.5
        ecm             = %00000001     ; has E.C.M.
.endenum

; A.I. behaviour state
.enum   behaviour
        remove          = %10000000     ; remove -- too far away
        police          = %01000000     ; is police vessel
        protected       = %00100000     ; protected by space-station
        docking         = %00010000     ; is docking
        pirate          = %00001000     ; is pirate
        angry           = %00000100     ; is angry with the player
        hunter          = %00000010     ; is a bounty-hunter
        trader          = %00000001     ; is a peaceful trader          
.endenum

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

ZP_POLYOBJ_ROLL         = $26
ZP_POLYOBJ_PITCH        = $27

ZP_POLYOBJ_VISIBILITY   = $28

ZP_POLYOBJ_ATTACK       = $29

ZP_POLYOBJ_SPEED        = $2a
ZP_POLYOBJ_ACCEL        = $2b
ZP_POLYOBJ_ENERGY       = $2c

ZP_POLYOBJ_BEHAVIOUR    = $2d

;-------------------------------------------------------------------------------

ZP_TEMP_ADDR2           = $2a   ; another temporary address
ZP_TEMP_ADDR2_LO        = $2a
ZP_TEMP_ADDR2_HI        = $2b

;-------------------------------------------------------------------------------

ZP_VAR_P                = $2e   ; a common variable called "P"
ZP_VAR_P1               = $2e
ZP_VAR_P2               = $2f
ZP_VAR_P3               = $30

;-------------------------------------------------------------------------------

ZP_CURSOR_COL           = $31
;                       = $32   ;?
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
;                       = $40   ;UNUSED?
;                       = $41   ;UNUSED?
;                       = $42   ;UNUSED?
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
;                       = $63   ;? x8
;                       = $64   ;? x8
;                       = $65   ; hyperspace counter (inner)
;                       = $66   ; hyperspace counter (outer)
;                       = $67   ;? x9
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
;                       = $71   ;? x22
;                       = $72   ;? x16
;                       = $73   ;? x20
;                       = $74   ;? x12
;                       = $75   ;? x14
;                       = $76   ;? x12

; a 4-byte big-endian number buffer for working with big integers:

ZP_VALUE                = $77
ZP_VALUE_pt1            = $77
ZP_VALUE_pt2            = $78
ZP_VALUE_pt3            = $79
ZP_VALUE_pt4            = $7a

;                       = $7b   ;? x8
;                       = $7c   ;? x7
;                       = $7d   ;? x6
;                       = $7e   ;? x10

;-------------------------------------------------------------------------------

ZP_SEED                 = $7f
ZP_SEED_pt1             = $7f
ZP_SEED_pt2             = $80
ZP_SEED_pt3             = $81
ZP_SEED_pt4             = $82
ZP_SEED_pt5             = $83
ZP_SEED_pt6             = $84

;-------------------------------------------------------------------------------

;                       = $85   ;? x9
;                       = $86   ;? x3
;                       = $87   ;? x6
;                       = $88   ;? x8
;                       = $89   ;? x5
;                       = $8a   ;? x8
;                       = $8b   ;? x9
;                       = $8c   ;? x4
;                       = $8d   ;? x4
;                       = $8e   ;? x18
;                       = $8f   ;? x19
;                       = $90   ;? x11
;                       = $91   ;? x9
;                       = $92   ;? x6
;                       = $93   ;? x4
;                       = $94   ;? x8
;                       = $95   ;? x6

PLAYER_SPEED            = $96

;                       = $97   ;? x5
;                       = $98   ;? x4

ZP_VAR_U                = $99   ; a common variable named "U"
ZP_VAR_Q                = $9a   ; a common variable named "Q"
ZP_VAR_R                = $9b   ; a common variable named "R"
ZP_VAR_S                = $9c   ; a common variable named "S"

;                       = $9d   ;? x11
;                       = $9e   ;? x12
;                       = $9f   ;? x10
;                       = $a0   ;? x38

ZP_VAR_Z                = $a1   ; a common "Z" variable

;                       = $a2   ;? x14
;                       = $a3   ;? x18 "MOVE COUNTER"?
;                       = $a4   ;UNUSED?
;                       = $a5   ;? x31
;                       = $a6   ;? x8 "ALPHA"?
;                       = $a7   ;? x10
;                       = $a8   ;? x9
;                       = $a9   ;? x4
;                       = $aa   ;? x30
;                       = $ab   ;? x12
;                       = $ac   ;? x5
;                       = $ad   ;? x21
;                       = $ae   ;? x12
;                       = $af   ;UNUSED?
;                       = $b0   ;? x12
;                       = $b1   ;? x17
;                       = $b2   ;? x7
;                       = $b3   ;? x11
;                       = $b4   ;? x9
;                       = $b5   ;? x10
;                       = $b6   ;? x9
;                       = $b7   ;? x4
;                       = $b8   ;? x7
;                       = $b9   ;? x2
;                       = $ba   ;? x2

ZP_VAR_T                = $bb   ; a common variable named "T"

;                       = $bc   ;? x15
;                       = $bd   ;? x25
;                       = $be   ;? x11
;                       = $bf   ;? x37 "S"?
;                       = $c0   ;? x6
;                       = $c1   ;UNUSED?
;                       = $c2   ;? x2
;                       = $c3   ;? x3
;                       = $c4   ;? x2
;                       = $c5   ;? x2
;                       = $c6   ;? x5
;                       = $c7   ;? x5
;                       = $c8   ;? x5
;                       = $c9   ;? x2
;                       = $ca   ;? x2
;                       = $cb   ;? x3
;                       = $cc   ;? x4
;                       = $cd   ;? x2
;                       = $ce   ;? x2
;                       = $cf   ;? x3
;                       = $d0   ;? x4
;                       = $d1   ;? x8

;                       = $d2   ;UNUSED?
;                       = $d3   ;UNUSED?
;                       = $d4   ;UNUSED?
;                       = $d5   ;UNUSED?
;                       = $d6   ;UNUSED?
;                       = $d7   ;UNUSED?
;                       = $d8   ;UNUSED?
;                       = $d9   ;UNUSED?
;                       = $da   ;UNUSED?
;                       = $db   ;UNUSED?
;                       = $dc   ;UNUSED?
;                       = $dd   ;UNUSED?
;                       = $de   ;UNUSED?
;                       = $df   ;UNUSED?
;                       = $e0   ;UNUSED?
;                       = $e1   ;UNUSED?
;                       = $e2   ;UNUSED?
;                       = $e3   ;UNUSED?
;                       = $e4   ;UNUSED?
;                       = $e5   ;UNUSED?
;                       = $e6   ;UNUSED?
;                       = $e7   ;UNUSED?
;                       = $e8   ;UNUSED?
;                       = $e9   ;UNUSED?
;                       = $ea   ;UNUSED?
;                       = $eb   ;UNUSED?
;                       = $ec   ;UNUSED?
;                       = $ed   ;UNUSED?
;                       = $ee   ;UNUSED?
;                       = $ef   ;UNUSED?
;                       = $f0   ;UNUSED?
;                       = $f1   ;UNUSED?
;                       = $f2   ;UNUSED?
;                       = $f3   ;UNUSED?
;                       = $f4   ;UNUSED?
;                       = $f5   ;UNUSED?
;                       = $f6   ;UNUSED?
;                       = $f7   ;UNUSED?
;                       = $f8   ;UNUSED?

;                       = $f9   ;? x1

;                       = $fa   ;UNUSED?
;                       = $fb   ;UNUSED?
;                       = $fc   ;UNUSED?

;                       = $fd   ;? x1
;                       = $fe   ;? x1

;                       = $ff   ;UNUSED?