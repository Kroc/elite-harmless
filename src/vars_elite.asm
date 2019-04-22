; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "vars_elite.asm" -- some common variables Elite stores in $0400..$0700

.include        "elite_consts.asm"

VAR_0403                = $0403

VAR_0441                = $0441 ;?

; up to 11 3D-objects ("poly objcets") can be in the game at a time.
; these are the 11 available slots; a value of $00 represents an unused slot,
; otherwise the value is a hull index (see "hull_data.asm") 

SHIP_SLOTS              = $0452

SHIP_SLOT0              = $0452
SHIP_SLOT1              = $0453
SHIP_SLOT2              = $0454
SHIP_SLOT3              = $0455
SHIP_SLOT4              = $0456
SHIP_SLOT5              = $0457
SHIP_SLOT6              = $0458
SHIP_SLOT7              = $0459
SHIP_SLOT8              = $045a
SHIP_SLOT9              = $045b
SHIP_SLOT10             = $045c

VAR_045D                = $045d ;? (indexed by X)

VAR_045F                = $045f ;?

VAR_0467                = $0467 ;?

VAR_046D                = $046d ;?

VAR_047A                = $047a ;?

VAR_047C                = $047c ;?

VAR_047F                = $047f ;?

;-------------------------------------------------------------------------------

DOCKCOM_STATE           = $0480 ; docking computer state: $00 = OFF, $FF = ON

VAR_0481                = $0481 ;?

IS_WITCHSPACE           = $0482 ; has misjump occurred?

VAR_0484                = $0484 ;?
VAR_0486                = $0486 ;?
VAR_0487                = $0487 ;?

VAR_048A                = $048a ;?
VAR_048B                = $048b ;?
VAR_048C                = $048c ;?
VAR_048D                = $048d ;? x8   X-dampen?
VAR_048E                = $048e ;?      Y-dampen?
VAR_048F                = $048f ;?
VAR_0490                = $0490 ;? (indexed by X)
VAR_0491                = $0491 ;?

MISSION_FLAGS           = $0499

VAR_04C4                = $04c4 ;?

.enum   missions
        constrictor_begin       = %00000001
        constrictor_complete    = %00000010
        constrictor             = constrictor_begin | constrictor_complete

        blueprints_begin        = %00000100
        blueprints_birera       = %00001000
        blueprints              = blueprints_begin | blueprints_birera

        trumbles                = %00010000
.endenum

; got Trumbles™?
;
.ifndef OPTION_NOTRUMBLES
;///////////////////////////////////////////////////////////////////////////////

PLAYER_TRUMBLES         = $04c9 ; number of Trumbles™ in the player's hold
PLAYER_TRUMBLES_LO      = $04c9
PLAYER_TRUMBLES_HI      = $04ca

TRUMBLES_ONSCREEN       = $0510 ; number of Trumbles™ on-screen; up to 6

; the amount each Trumble™ moves X / Y

TRUMBLES_MOVE_X         = $0511
TRUMBLES_MOVE_Y         = $0512

TRUMBLES_MOVE_X0        = $0511
TRUMBLES_MOVE_Y0        = $0512
TRUMBLES_MOVE_X1        = $0513
TRUMBLES_MOVE_Y1        = $0514
TRUMBLES_MOVE_X2        = $0515
TRUMBLES_MOVE_Y2        = $0516
TRUMBLES_MOVE_X3        = $0517
TRUMBLES_MOVE_Y3        = $0518
TRUMBLES_MOVE_X4        = $0519
TRUMBLES_MOVE_Y4        = $051A
TRUMBLES_MOVE_X5        = $051B
TRUMBLES_MOVE_Y5        = $051C
TRUMBLES_MOVE_X6        = $051D
TRUMBLES_MOVE_Y6        = $051E
TRUMBLES_MOVE_X7        = $051F ; UNUSED! There is no 7th Trumble™ on-screen!
TRUMBLES_MOVE_Y7        = $0520 ; UNUSED! There is no 7th Trumble™ on-screen!

VAR_0521                = $0521 ;? (indexed by Y) -- Trumble™ related

;///////////////////////////////////////////////////////////////////////////////
.endif

VAR_0531                = $0531 ;? (indexed by Y)

;-------------------------------------------------------------------------------

; player's cash:
PLAYER_CASH             = $04a2
PLAYER_CASH_pt1         = $04a2
PLAYER_CASH_pt2         = $04a3
PLAYER_CASH_pt3         = $04a4
PLAYER_CASH_pt4         = $04a5

PLAYER_FUEL             = $04a6

PLAYER_COMPETITION      = $04a7 ; status byte for competition requirements?

PLAYER_GALAXY           = $04a8 ; current galaxy number

PLAYER_LASERS           = $04a9 ; which laser is mounted to each view
PLAYER_LASER_FRONT      = $04a9 ; front laser type
PLAYER_LASER_2          = $04aa ;TODO: is this left, right, or rear?
PLAYER_LASER_3          = $04ab ;TODO: is this left, right, or rear?
PLAYER_LASER_4          = $04ac ;TODO: is this left, right, or rear?

VAR_04AF                = $04af ;?
VAR_04B0                = $04b0 ;? (indexed by Y)

VAR_04B3                = $04b3 ;?
VAR_04B6                = $04b6 ;?

VAR_04BA                = $04ba ;?

PLAYER_ECM              = $04c1 ; player has an E.C.M.?

VAR_04C2                = $04c2 ;?

PLAYER_EBOMB            = $04c3 ; player has energy bomb?
PLAYER_DOCKCOM          = $04c5 ; player has a docking computer?
PLAYER_GDRIVE           = $04c6 ; player has a galactic hyper-drive?
PLAYER_ESCAPEPOD        = $04c7 ; player has an escape pod?

VAR_04CB                = $04cb ;?

PLAYER_MISSILES         = $04cc ; number of missiles the player has
PLAYER_MISSILE_ARMED    = $0485 ; armed state of missile

PLAYER_LEGAL            = $04cd ; player's legal status

VAR_04CE                = $04ce ;? (indexed by Y)

VAR_04DE                = $04de ;?
VAR_04DF                = $04df ;?

VAR_04E0                = $04e0 ; number of kills (lo byte?)
PLAYER_KILLS            = $04e1 ; number of kills (hi byte?)

VAR_04E2                = $04e2 ;?

VAR_04E6                = $04e6 ;?

PLAYER_SHIELD_FRONT     = $04e7
PLAYER_SHIELD_REAR      = $04e8
PLAYER_ENERGY           = $04e9

VAR_04EA                = $04ea ;?
VAR_04EB                = $04eb ;?

PLAYER_TEMP_LASER       = $0488 ; laser temperature
PLAYER_TEMP_CABIN       = $0483 ; cabin temperature

VAR_04F2                = $04f2 ;?
VAR_04F3                = $04f3 ;?
VAR_04F4                = $04f4 ;? (indexed by X)
VAR_04FA                = $04fa ;? (indexed by X)

;-------------------------------------------------------------------------------

; target system:
TSYSTEM_DATA            = $0500
TSYSTEM_ECONOMY         = $0500
TSYSTEM_GOVERNMENT      = $0501
TSYSTEM_TECHLEVEL       = $0502
TSYSTEM_POPULATION      = $0503 ; & $0504?
TSYSTEM_PRODUCTIVITY    = $0505
TSYSTEM_PRODUCTIVITY_LO = $0505
TSYSTEM_PRODUCTIVITY_HI = $0506
TSYSTEM_DISTANCE        = $0507
TSYSTEM_DISTANCE_LO     = $0507
TSYSTEM_DISTANCE_HI     = $0508
TSYSTEM_POS             = $0509
TSYSTEM_POS_X           = $0509
TSYSTEM_POS_Y           = $050a

VAR_050C                = $050c ;?
VAR_050D                = $050d ;?
VAR_050E                = $050e ;?
VAR_050F                = $050f ;?

; present system:
PSYSTEM_ECONOMY         = $04ee

VAR_04EC                = $04ec
VAR_04ED                = $04ed

VAR_04EF                = $04ef

PSYSTEM_GOVERNMENT      = $04f0
PSYSTEM_TECHLEVEL       = $04f1
PSYSTEM_POS             = $049a
PSYSTEM_POS_X           = $049a
PSYSTEM_POS_Y           = $049b

VAR_049C                = $049c ;? (indexed by X)

;-------------------------------------------------------------------------------

; NOTE: there are up-to 25 dust-particles at a time
; TODO: define the arrays below based on this
DUST_MAX                = 25

DUST_COUNT              = $050b ; number of dust particles
DUST_X                  = $06a2 ;..$06BB: X-positions of dust-particles
DUST_Y                  = $06bc ;..$06D5: Y-positions of dust-particles
DUST_Z                  = $06d6 ;..$06EF: Z-positions of dust-particles

VAR_06AF                = $06af ; within `DUST_X`?
VAR_06C9                = $06c9 ; within `DUST_Y`?

;-------------------------------------------------------------------------------

; the sun is converted into a list of half-widths for each scan-line, i.e.
; for each scanline in the viewport (0-144), this array provides a radius
; for that scanline where the centre point of the sun is already known
;
; length of this is given as $C7 (199) in code,
; despite the viewport being 144 px tall
;
; TODO: define this structurally based on `ELITE_VIEWPORT_HEIGHT`
; TODO: also, as this is indexed, keep it within one page
VAR_0580                = $0580

VAR_0647                = $0647 ;? (indexed by X)
VAR_0648                = $0648 ;? (indexed by X)

VAR_06E3                = $06e3 ;? (indexed by Y)

VAR_06F0                = $06f0 ;?
VAR_06F1                = $06f1 ;?
VAR_06F3                = $06f3 ;?
VAR_06F4                = $06f4 ;?

VAR_06FB                = $06fb ;?