; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; special variables in the Zero Page;
; 256 bytes of slightly faster memory
;
; note that $00 & $01 are hard-wired to the CPU, so cannot be used

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
; a poly-object is a runtime 3D object in-play, such as a ship, asteroid or
; space station. see "vars_polyobj.asm" for the structure definition and
; reserved space in RAM. for speed, poly-objects are copied to the
; zero-page each time they are handled
;
ZP_POLYOBJ              = $09
ZP_POLYOBJ_XPOS         = $09
ZP_POLYOBJ_XPOS_LO      = $09
ZP_POLYOBJ_XPOS_MI      = $0a
ZP_POLYOBJ_XPOS_HI      = $0b
ZP_POLYOBJ_YPOS         = $0c
ZP_POLYOBJ_YPOS_LO      = $0c
ZP_POLYOBJ_YPOS_MI      = $0d
ZP_POLYOBJ_YPOS_HI      = $0e
ZP_POLYOBJ_ZPOS         = $0f
ZP_POLYOBJ_ZPOS_LO      = $0f
ZP_POLYOBJ_ZPOS_MI      = $10
ZP_POLYOBJ_ZPOS_HI      = $11

; some math routines take parameters that are offsets
; from the start of the poly-object to the desired matrix row 
MATRIX_ROW_0  = (ZP_POLYOBJ_M0x0 - ZP_POLYOBJ)  ;+$09
MATRIX_ROW_1  = (ZP_POLYOBJ_M1x0 - ZP_POLYOBJ)  ;+$0f
MATRIX_ROW_2  = (ZP_POLYOBJ_M2x0 - ZP_POLYOBJ)  ;+$15

; [ M0x0, M0x1, M0x2 ]
; [ M1x0, M1x1, M1x2 ]
; [ M2x0, M2x1, M2x2 ]
;
ZP_POLYOBJ_M0           = $12   ; matrix row 0
;----------------------------
ZP_POLYOBJ_M0x0         = $12
ZP_POLYOBJ_M0x0_LO      = $12
ZP_POLYOBJ_M0x0_HI      = $13
ZP_POLYOBJ_M0x1         = $14
ZP_POLYOBJ_M0x1_LO      = $14
ZP_POLYOBJ_M0x1_HI      = $15
ZP_POLYOBJ_M0x2         = $16
ZP_POLYOBJ_M0x2_LO      = $16
ZP_POLYOBJ_M0x2_HI      = $17

ZP_POLYOBJ_M1           = $18   ; matrix row 1
;----------------------------
ZP_POLYOBJ_M1x0         = $18
ZP_POLYOBJ_M1x0_LO      = $18
ZP_POLYOBJ_M1x0_HI      = $19
ZP_POLYOBJ_M1x1         = $1a
ZP_POLYOBJ_M1x1_LO      = $1a
ZP_POLYOBJ_M1x1_HI      = $1b
ZP_POLYOBJ_M1x2         = $1c
ZP_POLYOBJ_M1x2_LO      = $1c
ZP_POLYOBJ_M1x2_HI      = $1d

ZP_POLYOBJ_M2           = $1e   ; matrix row 2
;----------------------------
ZP_POLYOBJ_M2x0         = $1e
ZP_POLYOBJ_M2x0_LO      = $1e
ZP_POLYOBJ_M2x0_HI      = $1f
ZP_POLYOBJ_M2x1         = $20
ZP_POLYOBJ_M2x1_LO      = $20
ZP_POLYOBJ_M2x1_HI      = $21
ZP_POLYOBJ_M2x2         = $22
ZP_POLYOBJ_M2x2_LO      = $22
ZP_POLYOBJ_M2x2_HI      = $23

ZP_POLYOBJ_VERTX        = $24   ; an address where vertex data is cached
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
ZP_VAR_P1               = $2e   ; additional bytes for storing-
ZP_VAR_P2               = $2f   ; 16 or 24-bit values in P
ZP_VAR_P3               = $30

;-------------------------------------------------------------------------------

ZP_CURSOR_COL           = $31
ZP_32                   = $32   ;?
ZP_CURSOR_ROW           = $33
ZP_34                   = $34   ; case switch for flight strings?

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

ZP_3F                   = $3f   ; a flag, but never gets set; see `_3571`

;                       = $40   ;UNUSED?
;                       = $41   ;UNUSED?
;                       = $42   ;UNUSED?

ZP_43                   = $43   ; something to do with viewport height
ZP_44                   = $44   ; often related to `ZP_POLYOBJ01_XPOS_pt2`

;-------------------------------------------------------------------------------

; a working copy of the zero-page poly object rotation matrix:
;
ZP_TEMPOBJ_MATRIX       = $45
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

ZP_VAR_XX               = $5d
ZP_VAR_XX_LO            = $5d
ZP_VAR_XX_HI            = $5e

ZP_VAR_YY               = $5f
ZP_VAR_YY_LO            = $5f
ZP_VAR_YY_HI            = $60

;-------------------------------------------------------------------------------

ZP_SUNX_LO              = $61   ; something to do with drawing the sun
ZP_SUNX_HI              = $62   ; as above

ZP_BETA                 = $63   ; a rotation variable used in matrix math

ZP_PITCH_MAGNITUDE      = $64   ; unsigned pitch rotation value,
                                ; note that $94 is the pitch rotation sign

ZP_65                   = $65   ; hyperspace counter (inner)?
ZP_66                   = $66   ; hyperspace counter (outer)?

ZP_67                   = $67   ;? x9

ZP_ROLL_MAGNITUDE       = $68   ; unsigned roll rotation value
ZP_ROLL_SIGN            = $69   ; roll rotation sign

ZP_6A                   = $6a   ; "move count"?

;-------------------------------------------------------------------------------

ZP_VAR_X                = $6b   ; a common "X" variable
ZP_VAR_X1               = $6b   ; also referred to as X1 when used with X2
ZP_VAR_Y                = $6c   ; a common "Y" variable
ZP_VAR_Y1               = $6c   ; also referred to as Y1 when used with Y2

ZP_VAR_X2               = $6d   ; a secondary "X" variable
ZP_VAR_Y2               = $6e   ; a secondary "Y" variable

ZP_6F                   = $6f   ; `ZP_VAR_Z`?
ZP_70                   = $70   ; `ZP_VAR_Y3` / `ZP_VAR_Z2`?

; energy banks?
ZP_71                   = $71   ;? x22
ZP_72                   = $72   ;? x16
ZP_73                   = $73   ;? x20
ZP_74                   = $74

ZP_75                   = $75   ;? x14
ZP_76                   = $76   ;? x12

; a 4-byte big-endian number buffer for working with big integers:

ZP_VALUE                = $77
ZP_VALUE_pt1            = $77
ZP_VALUE_pt2            = $78
ZP_VALUE_pt3            = $79
ZP_VALUE_pt4            = $7a

ZP_7B                   = $7b   ;? x8
ZP_MISSILE_TARGET       = $7c   ; missile target?
ZP_7D                   = $7d   ;? x6
ZP_7E                   = $7e   ;? x10

;-------------------------------------------------------------------------------
; Elite's random-number seed that defines the entire universe
; see: http://wiki.alioth.net/index.php/Random_number_generator
;
ZP_SEED                 = $7f
ZP_SEED_W0              = $7f   ; first word
ZP_SEED_W0_LO           = $7f   ; lo-byte of first word
ZP_SEED_W0_HI           = $80   ; hi-byte of first word
ZP_SEED_W1              = $81   ; second word
ZP_SEED_W1_LO           = $81   ; lo-byte of second word
ZP_SEED_W1_HI           = $82   ; hi-byte of second word
ZP_SEED_W2              = $83   ; third word
ZP_SEED_W2_LO           = $83   ; lo-byte of third word
ZP_SEED_W2_HI           = $84   ; hi-byte of third word

;-------------------------------------------------------------------------------

ZP_85                   = $85   ;? x9
ZP_86                   = $86   ;? x3
ZP_87                   = $87   ;? x6
ZP_88                   = $88   ;? x8
ZP_89                   = $89   ;? x5
ZP_8A                   = $8a   ;? x8
ZP_8B                   = $8b   ;? x9
ZP_8C                   = $8c   ;? x4
ZP_8D                   = $8d   ;? x4
ZP_8E                   = $8e   ;? x18
ZP_8F                   = $8f   ;? x19
ZP_90                   = $90   ;? x11
ZP_91                   = $91   ;? x9
ZP_92                   = $92   ;? x6
ZP_93                   = $93   ;? x4

ZP_PITCH_SIGN           = $94   ; pitch rotation sign (see $64 for magnitude)

ZP_95                   = $95   ;? x6

PLAYER_SPEED            = $96

ZP_97                   = $97   ;? x5
ZP_98                   = $98   ;? x4

ZP_VAR_U                = $99   ; a common variable named "U"
ZP_VAR_Q                = $9a   ; a common variable named "Q"
ZP_VAR_R                = $9b   ; a common variable named "R"
ZP_VAR_S                = $9c   ; a common variable named "S"

ZP_9D                   = $9d   ;? x11
ZP_9E                   = $9e   ;? x12
ZP_9F                   = $9f   ;? x10

; which screen the game is on, e.g. cockpit-view, galactic chart &c.
; not to be confused with the bitmap screen and colour screens
;
;       $00 = cockpit-view (fore/left/right/aft-view is a separate variable)
;       $01 = ?
;       $03 = ?
;       $04 = ?
;       $08 = status screen
;       $0D = ?
;       $10 = ?
;       $20 = ?
;       $40 = galactic chart
;       $80 = short-range (local) chart
;
ZP_SCREEN               = $a0

ZP_VAR_Z                = $a1   ; a common "Z" variable

ZP_A2                   = $a2   ;? x14
ZP_A3                   = $a3   ;? x18 "MOVE COUNTER"?

;                       = $a4   ;UNUSED?

ZP_A5                   = $a5   ;? x31

ZP_ALPHA                = $a6   ; a rotation variable used in matrix math

ZP_A7                   = $a7   ;? x10  ; docked flag?
ZP_A8                   = $a8   ;? x9
ZP_A9                   = $a9   ;? x4
ZP_AA                   = $aa   ;? x30
ZP_AB                   = $ab   ;? x12
ZP_AC                   = $ac   ;? x5
ZP_AD                   = $ad   ;? x21
ZP_AE                   = $ae   ;? x12

;                       = $af   ;UNUSED?

ZP_B0                   = $b0   ;? x12
ZP_B1                   = $b1   ;? x17
ZP_B2                   = $b2   ;? x7
ZP_B3                   = $b3   ;? x11
ZP_B4                   = $b4   ;? x9
ZP_B5                   = $b5   ;? x10
ZP_B6                   = $b6   ;? x9
ZP_B7                   = $b7   ;? x4
ZP_B8                   = $b8   ;? x7
ZP_B9                   = $b9   ;? x2
ZP_BA                   = $ba   ;? x2

ZP_VAR_T                = $bb   ; a common variable named "T"

; used in line-drawing:
;
ZP_REG_W                = $bc   ; "width" ZP register, used in line-drawing
ZP_REG_H                = $bd   ; "height" ZP register, used in line-drawing
ZP_BE                   = $be   ;? x11
ZP_BF                   = $bf   ;? x37 "S"?
ZP_C0                   = $c0   ; stores a mask for < 8px-length lines

;                       = $c1   ;UNUSED?

; sound: $C2-$D1
; (defined in "sound.asm" rather than here)

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

ZP_F9                   = $f9   ;? x1

;                       = $fa   ;UNUSED?
;                       = $fb   ;UNUSED?
;                       = $fc   ;UNUSED?

ZP_FD                   = $fd   ; KERNAL use?
ZP_FE                   = $fe   ; KERNAL use?

;                       = $ff   ;UNUSED?