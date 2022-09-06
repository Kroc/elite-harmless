; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "vars_zeropage.asm":
;
; special variables in the Zero Page;
; 256 bytes of slightly faster memory
;
; note that $00 & $01 are hard-wired to the CPU, so cannot be used

.segment        "ZP_SHADOW"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.res            $0100

.zeropage
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; "goat soup" is the algorithm for generating planet descriptions.
; its seed is taken from the last four bytes of the main seed 
ZP_GOATSOUP             := $02
ZP_GOATSOUP_pt1         := $02
ZP_GOATSOUP_pt2         := $03
ZP_GOATSOUP_pt3         := $04
ZP_GOATSOUP_pt4         := $05

;-------------------------------------------------------------------------------

ZP_TEMP_VAR             := $06  ; a temporary single byte
ZP_TEMP_ADDR            := $07  ; a temporary word / addr
ZP_TEMP_ADDR_LO         := $07
ZP_TEMP_ADDR_HI         := $08

;-------------------------------------------------------------------------------
; a poly-object is a runtime 3D object in-play, such as a ship, asteroid or
; space station. see "vars_polyobj.asm" for the structure definition and
; reserved space in RAM. for speed, poly-objects are copied to the
; zero-page each time they are handled
;
ZP_POLYOBJ              := $09
ZP_POLYOBJ_XPOS         := $09
ZP_POLYOBJ_XPOS_LO      := $09
ZP_POLYOBJ_XPOS_HI      := $0a
ZP_POLYOBJ_XPOS_SIGN    := $0b
ZP_POLYOBJ_YPOS         := $0c
ZP_POLYOBJ_YPOS_LO      := $0c
ZP_POLYOBJ_YPOS_HI      := $0d
ZP_POLYOBJ_YPOS_SIGN    := $0e
ZP_POLYOBJ_ZPOS         := $0f
ZP_POLYOBJ_ZPOS_LO      := $0f
ZP_POLYOBJ_ZPOS_HI      := $10
ZP_POLYOBJ_ZPOS_SIGN    := $11

; some math routines take parameters that are offsets
; from the start of the poly-object to the desired matrix row 
MATRIX_ROW0             = (ZP_POLYOBJ_M0x0 - ZP_POLYOBJ)                ;=$09
MATRIX_ROW1             = (ZP_POLYOBJ_M1x0 - ZP_POLYOBJ)                ;=$0f
MATRIX_ROW2             = (ZP_POLYOBJ_M2x0 - ZP_POLYOBJ)                ;=$15

MATRIX_COL0             = $00   ; column 0 of a matrix row
MATRIX_COL0_LO          = $00
MATRIX_COL0_HI          = $01
MATRIX_COL1             = $02   ; column 1 of a matrix row
MATRIX_COL1_LO          = $02
MATRIX_COL1_HI          = $03
MATRIX_COL2             = $04   ; column 2 of a matrix row
MATRIX_COL2_LO          = $04
MATRIX_COL2_HI          = $05

; [ M0x0, M0x1, M0x2 ]
; [ M1x0, M1x1, M1x2 ]
; [ M2x0, M2x1, M2x2 ]
;
ZP_POLYOBJ_M0           := $12  ; matrix row 0
;-----------------------------
ZP_POLYOBJ_M0x0         := $12
ZP_POLYOBJ_M0x0_LO      := $12
ZP_POLYOBJ_M0x0_HI      := $13
ZP_POLYOBJ_M0x1         := $14
ZP_POLYOBJ_M0x1_LO      := $14
ZP_POLYOBJ_M0x1_HI      := $15
ZP_POLYOBJ_M0x2         := $16
ZP_POLYOBJ_M0x2_LO      := $16
ZP_POLYOBJ_M0x2_HI      := $17

ZP_POLYOBJ_M1           := $18  ; matrix row 1
;-----------------------------
ZP_POLYOBJ_M1x0         := $18
ZP_POLYOBJ_M1x0_LO      := $18
ZP_POLYOBJ_M1x0_HI      := $19
ZP_POLYOBJ_M1x1         := $1a
ZP_POLYOBJ_M1x1_LO      := $1a
ZP_POLYOBJ_M1x1_HI      := $1b
ZP_POLYOBJ_M1x2         := $1c
ZP_POLYOBJ_M1x2_LO      := $1c
ZP_POLYOBJ_M1x2_HI      := $1d

ZP_POLYOBJ_M2           := $1e  ; matrix row 2
;-----------------------------
ZP_POLYOBJ_M2x0         := $1e
ZP_POLYOBJ_M2x0_LO      := $1e
ZP_POLYOBJ_M2x0_HI      := $1f
ZP_POLYOBJ_M2x1         := $20
ZP_POLYOBJ_M2x1_LO      := $20
ZP_POLYOBJ_M2x1_HI      := $21
ZP_POLYOBJ_M2x2         := $22
ZP_POLYOBJ_M2x2_LO      := $22
ZP_POLYOBJ_M2x2_HI      := $23

ZP_POLYOBJ_SPEED        := $24
ZP_POLYOBJ_ACCEL        := $25

ZP_POLYOBJ_ROLL         := $26
ZP_POLYOBJ_PITCH        := $27

ZP_POLYOBJ_STATE        := $28

ZP_POLYOBJ_ATTACK       := $29

ZP_POLYOBJ_HEAP         := $2a
ZP_POLYOBJ_HEAP_LO      := $2a
ZP_POLYOBJ_HEAP_HI      := $2b

ZP_POLYOBJ_ENERGY       := $2c
ZP_POLYOBJ_BEHAVIOUR    := $2d

;-------------------------------------------------------------------------------

ZP_VAR_P                := $2e  ; a common variable called "P"
ZP_VAR_P1               := $2e  ; additional bytes for storing-
ZP_VAR_P2               := $2f  ; 16 or 24-bit values in P
ZP_VAR_P3               := $30

;-------------------------------------------------------------------------------

ZP_CURSOR_COL           := $31                                          ; XC
ZP_32                   := $32  ;?
ZP_CURSOR_ROW           := $33                                          ; YC

ZP_PRINT_CASE           := $34  ; auto capitalisation for printing      ; QQ17

; used as a 16-bit X-position when drawing circles
; WARNING: overlaps with ZP_POLYOBJ01_XPOS_pt1/2!
;
ZP_CIRCLE_XPOS          := $35                                          ; K3
ZP_CIRCLE_XPOS_LO       := $35                                          ; K3+0
ZP_CIRCLE_XPOS_HI       := $36                                          ; K3+1

;-------------------------------------------------------------------------------

; the X/Y/Z-position of `POLYOBJ_01` are copied here
ZP_POLYOBJ01            := $35
ZP_POLYOBJ01_XPOS       := $35
ZP_POLYOBJ01_XPOS_pt1   := $35
ZP_POLYOBJ01_XPOS_pt2   := $36
ZP_POLYOBJ01_XPOS_pt3   := $37
ZP_POLYOBJ01_YPOS       := $38
ZP_POLYOBJ01_YPOS_pt1   := $38
ZP_POLYOBJ01_YPOS_pt2   := $39
ZP_POLYOBJ01_YPOS_pt3   := $3a
ZP_POLYOBJ01_ZPOS       := $3b
ZP_POLYOBJ01_ZPOS_pt1   := $3b
ZP_POLYOBJ01_ZPOS_pt2   := $3c
ZP_POLYOBJ01_ZPOS_pt3   := $3d

; only ever used once to check for non-zero X/Y/Z-position
ZP_POLYOBJ01_POS        := $3e

;-------------------------------------------------------------------------------

ZP_3F                   := $3f  ; a flag, but never gets set; see `_3571`

;                       := $40  ;UNUSED?
;                       := $41  ;UNUSED?
;                       := $42  ;UNUSED?

; a variable named "K4" in the BBC code;
; used as a 16-bit Y-position when drawing circles
;
ZP_VAR_K4               := $43                                          ; K4
ZP_VAR_K4_LO            := $43                                          ; K4+0
ZP_VAR_K4_HI            := $44                                          ; K4+1

ZP_CIRCLE_YPOS          := ZP_VAR_K4
ZP_CIRCLE_YPOS_LO       := ZP_VAR_K4_LO
ZP_CIRCLE_YPOS_HI       := ZP_VAR_K4_HI

;-------------------------------------------------------------------------------

; a working copy of the zero-page poly object rotation matrix:
;
ZP_TEMPOBJ_MATRIX       := $45
ZP_TEMPOBJ_M2x0         := $45
ZP_TEMPOBJ_M2x0_LO      := $45
ZP_TEMPOBJ_M2x0_HI      := $46
ZP_TEMPOBJ_M2x1         := $47
ZP_TEMPOBJ_M2x1_LO      := $47
ZP_TEMPOBJ_M2x1_HI      := $48
ZP_TEMPOBJ_M2x2         := $49
ZP_TEMPOBJ_M2x2_LO      := $49
ZP_TEMPOBJ_M2x2_HI      := $4a

ZP_TEMPOBJ_M1x0         := $4b
ZP_TEMPOBJ_M1x0_LO      := $4b
ZP_TEMPOBJ_M1x0_HI      := $4c
ZP_TEMPOBJ_M1x1         := $4d  ; NOTE: not referenced directly?
ZP_TEMPOBJ_M1x1_LO      := $4d  ; "
ZP_TEMPOBJ_M1x1_HI      := $4e  ; "
ZP_TEMPOBJ_M1x2         := $4f
ZP_TEMPOBJ_M1x2_LO      := $4f
ZP_TEMPOBJ_M1x2_HI      := $50

ZP_TEMPOBJ_M0x0         := $51
ZP_TEMPOBJ_M0x0_LO      := $51
ZP_TEMPOBJ_M0x0_HI      := $52
ZP_TEMPOBJ_M0x1         := $53
ZP_TEMPOBJ_M0x1_LO      := $53
ZP_TEMPOBJ_M0x1_HI      := $54
ZP_TEMPOBJ_M0x2         := $55  ; NOTE: not referenced directly?
ZP_TEMPOBJ_M0x2_LO      := $55  ; "
ZP_TEMPOBJ_M0x2_HI      := $56  ; "

;-------------------------------------------------------------------------------

; pointer to a hull data structure:
; (verticies, edges, faces &c.)
ZP_HULL_ADDR            := $57
ZP_HULL_ADDR_LO         := $57
ZP_HULL_ADDR_HI         := $58

; a pointer to a PolyObject in RAM -- i.e. a currently in-play 3D object,
; such as a ship, asteroid or station
ZP_POLYOBJ_ADDR         := $59
ZP_POLYOBJ_ADDR_LO      := $59
ZP_POLYOBJ_ADDR_HI      := $5a

ZP_TEMP_ADDR3           := $5b
ZP_TEMP_ADDR3_LO        := $5b
ZP_TEMP_ADDR3_HI        := $5c

ZP_VAR_XX               := $5d
ZP_VAR_XX_LO            := $5d
ZP_VAR_XX_HI            := $5e

ZP_VAR_YY               := $5f
ZP_VAR_YY_LO            := $5f
ZP_VAR_YY_HI            := $60

;-------------------------------------------------------------------------------

ZP_SUNX_LO              := $61  ; something to do with drawing the sun
ZP_SUNX_HI              := $62  ; as above

ZP_BETA                 := $63  ; a rotation variable used in matrix math

ZP_PITCH_MAGNITUDE      := $64  ; unsigned pitch rotation value,
                                ; note that $94 is the pitch rotation sign

ZP_65                   := $65  ; hyperspace counter (inner)?
ZP_66                   := $66  ; hyperspace counter (outer)?

ECM_COUNTER             := $67  ; ECM counter

ZP_ROLL_MAGNITUDE       := $68  ; unsigned roll rotation value
ZP_ROLL_SIGN            := $69  ; roll rotation sign
ZP_INV_ROLL_SIGN        := $6a  ; inverse roll rotation sign (for easier math)

;-------------------------------------------------------------------------------

ZP_VAR_X                := $6b  ; a common "X" variable
ZP_VAR_X1               := $6b  ; also known as X1 when used with X2
ZP_VAR_Y                := $6c  ; a common "Y" variable
ZP_VAR_Y1               := $6c  ; also known as Y1 when used with Y2

ZP_VAR_X2               := $6d  ; a secondary "X" variable
ZP_VAR_Y2               := $6e  ; a secondary "Y" variable

ZP_6F                   := $6f  ; `ZP_VAR_Z`?
ZP_70                   := $70  ; `ZP_VAR_Y3` / `ZP_VAR_Z2`?

; energy banks?
ZP_71                   := $71  ;? x22
ZP_72                   := $72  ;? x16
ZP_73                   := $73  ;? x20
ZP_74                   := $74

ZP_75                   := $75  ;? x14
ZP_76                   := $76  ;? x12

; a 4-byte big-endian number buffer for working with big integers:
;
ZP_VALUE                := $77                                          ; K
ZP_VALUE_pt1            := $77                                          ; K+0
ZP_VALUE_pt2            := $78                                          ; K+1
ZP_VALUE_pt3            := $79                                          ; K+2?
ZP_VALUE_pt4            := $7a                                          ; K+3?

; also used as a parameter "K"
ZP_VAR_K                := ZP_VALUE_pt1                                 ; K

; and as a radius parameter for circles
ZP_CIRCLE_RADIUS        := ZP_VALUE_pt1                                 ; K
ZP_CIRCLE_RADIUS_LO     := ZP_VALUE_pt1                                 ; K+0
ZP_CIRCLE_RADIUS_HI     := ZP_VALUE_pt2                                 ; K+1

ZP_LASER                := $7b  ; laser power for current view (bit 7 = beam)
ZP_MISSILE_TARGET       := $7c  ; missile target?
ZP_7D                   := $7d  ;

ZP_7E                   := $7e  ; circle line-buffer cursor             ; LSP

;-------------------------------------------------------------------------------
; Elite's random-number seed that defines the entire universe
; see: <http://wiki.alioth.net/index.php/Random_number_generator>
;
ZP_SEED                 := $7f                                          ; QQ15
ZP_SEED_W0              := $7f   ; first word
ZP_SEED_W0_LO           := $7f   ; lo-byte of first word
ZP_SEED_W0_HI           := $80   ; hi-byte of first word
ZP_SEED_W1              := $81   ; second word
ZP_SEED_W1_LO           := $81   ; lo-byte of second word
ZP_SEED_W1_HI           := $82   ; hi-byte of second word
ZP_SEED_W2              := $83   ; third word
ZP_SEED_W2_LO           := $83   ; lo-byte of third word
ZP_SEED_W2_HI           := $84   ; hi-byte of third word

;-------------------------------------------------------------------------------

ZP_85                   := $85  ;? x9
ZP_86                   := $86  ;? x3
ZP_87                   := $87  ;? x6
ZP_88                   := $88  ;? x8

ZP_VAR_K6               := $89  ;                                       ; K6
ZP_VAR_K6_LO            := $89  ;                                       ; K6+0
ZP_VAR_K6_HI            := $8a  ;                                       ; K6+1

ZP_8B                   := $8b  ;                                       ; K6+2
ZP_8C                   := $8c  ;                                       ; K6+3
ZP_8D                   := $8d  ;

; temp variable storage?
; these three are reused sometimes as temporaries
;
ZP_8E                   := $8e  ; cross-hair X-position                 ; QQ19
ZP_8F                   := $8f  ; cross-hair Y-position                 ; QQ19+1
ZP_90                   := $90  ; cross-hair size                       ; QQ19+2

ZP_91                   := $91  ;? x9
ZP_92                   := $92  ;? x6
ZP_93                   := $93  ;? x4

ZP_PITCH_SIGN           := $94  ; pitch sign
ZP_INV_PITCH_SIGN       := $95  ; inverted pitch sign

ZP_PLAYER_SPEED         := $96
ZP_SPEED_LO             := $97  ; player speed * 64, lo-byte
ZP_SPEED_HI             := $98  ; player speed * 64, hi-byte

ZP_VAR_U                := $99  ; a common variable named "U"
ZP_VAR_Q                := $9a  ; a common variable named "Q"
ZP_VAR_R                := $9b  ; a common variable named "R"
ZP_VAR_S                := $9c  ; a common variable named "S"

ZP_PRESERVE_X           := $9d  ; temp backup of X
ZP_9E                   := $9e  ; tmep backup of Y

ZP_9F                   := $9f  ; edge index

; which screen the game is on, e.g. cockpit-view, galactic chart &c.
; not to be confused with the bitmap screen and colour screens
;
; NOTE: for the cockpit view, fore/aft/left/right is a separate variable
;
ZP_SCREEN               := $a0                                          ; QQ11

.enum   page
        ;-----------------------------------------------------------------------
        cockpit         = $00   ; MUST BE ZERO (due to numerous BEQ/BNE checks)
        
        empty           = $01   ;=%00000001     a non-specific, empty menu page
        buy_cargo       = $02   ;=%00000010
        sell_cargo      = $04   ;=%00000100
        status          = $08   ;=%00001000
        inventory       = $08   ;=%00001000     same, why?
        title           = $0d   ;=%00001101     ?
        market          = $10   ;=%00010000
        buy_equip       = $20   ;=%00100000
        
        chart_galaxy    = $40   ;=%01000000
        chart_local     = $80   ;=%10000000
.endenum

ZP_VAR_Z                := $a1  ; a common "Z" variable

ZP_A2                   := $a2  ;? x14
MAIN_COUNTER            := $a3  ;? x18 "MOVE COUNTER"?

;                       := $a4  ;UNUSED?

ZP_SHIP_TYPE            := $a5  ; temporary holding place for X-register

ZP_ALPHA                := $a6  ; a rotation variable used in matrix math

ZP_A7                   := $a7  ;? x10  ; docked flag?
ZP_A8                   := $a8  ;? x9
ZP_A9                   := $a9  ;                                       ; FLAG
ZP_TEMP_COUNTER         := $aa  ; temporary counter, e.g. ball lines    ; CNT
ZP_AB                   := $ab  ;? x12
ZP_CIRCLE_STEP          := $ac  ; step size for drawing circles         ; STP
ZP_AD                   := $ad  ;? x21
ZP_AE                   := $ae  ;? x12

;                       := $af  ;UNUSED?

ZP_B0                   := $b0  ;? x12
ZP_B1                   := $b1  ;? x17
ZP_B2                   := $b2  ;? x7
ZP_B3                   := $b3  ;? x11
ZP_B4                   := $b4  ;? x9
ZP_B5                   := $b5  ;? x10
ZP_B6                   := $b6  ;? x9
ZP_B7                   := $b7  ;? x4

ZP_VIEWH                := $b8  ; screen Y-value for clipping drawing

ZP_B9                   := $b9  ;? x2
ZP_BA                   := $ba  ;? x2

ZP_VAR_T                := $bb  ; a common variable named "T"

; used in line-drawing:
;
ZP_REG_W                := $bc  ; "width" ZP register, used in line-drawing
ZP_REG_H                := $bd  ; "height" ZP register, used in line-drawing
ZP_BE                   := $be  ;? x11
ZP_BF                   := $bf  ;? x37 "S"?
ZP_C0                   := $c0  ; stores a mask for < 8px-length lines

;                       := $c1  ;UNUSED?

; sound: $C2-$D1
; (defined in "sound.asm" rather than here)

;                       := $d2  ;UNUSED?
;                       := $d3  ;UNUSED?
;                       := $d4  ;UNUSED?
;                       := $d5  ;UNUSED?
;                       := $d6  ;UNUSED?
;                       := $d7  ;UNUSED?
;                       := $d8  ;UNUSED?
;                       := $d9  ;UNUSED?
;                       := $da  ;UNUSED?
;                       := $db  ;UNUSED?
;                       := $dc  ;UNUSED?
;                       := $dd  ;UNUSED?
;                       := $de  ;UNUSED?
;                       := $df  ;UNUSED?
;                       := $e0  ;UNUSED?
;                       := $e1  ;UNUSED?
;                       := $e2  ;UNUSED?
;                       := $e3  ;UNUSED?
;                       := $e4  ;UNUSED?
;                       := $e5  ;UNUSED?
;                       := $e6  ;UNUSED?
;                       := $e7  ;UNUSED?
;                       := $e8  ;UNUSED?
;                       := $e9  ;UNUSED?
;                       := $ea  ;UNUSED?
;                       := $eb  ;UNUSED?
;                       := $ec  ;UNUSED?
;                       := $ed  ;UNUSED?
;                       := $ee  ;UNUSED?
;                       := $ef  ;UNUSED?
;                       := $f0  ;UNUSED?
;                       := $f1  ;UNUSED?
;                       := $f2  ;UNUSED?
;                       := $f3  ;UNUSED?
;                       := $f4  ;UNUSED?
;                       := $f5  ;UNUSED?
;                       := $f6  ;UNUSED?
;                       := $f7  ;UNUSED?
;                       := $f8  ;UNUSED?

ZP_F9                   := $f9  ;? x1

;                       := $fa  ;UNUSED?
;                       := $fb  ;UNUSED?
;                       := $fc  ;UNUSED?

ZP_FD                   := $fd  ; KERNAL use?
ZP_FE                   := $fe  ; KERNAL use?

;                       := $ff  ;UNUSED?