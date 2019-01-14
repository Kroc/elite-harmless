; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "elite_vars.asm" -- some common variables Elite stores in $0400..$0700

.include        "elite_consts.asm"

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

;-------------------------------------------------------------------------------

;                       = $0480 ; something to do with roll-dampening

MISSION_FLAGS           = $0499

.enum   missions
        constrictor_begin       = %00000001
        constrictor_complete    = %00000010
        constrictor             = constrictor_begin | constrictor_complete

        blueprints_begin        = %00000100
        blueprints_birera       = %00001000
        blueprints              = blueprints_begin | blueprints_birera

        trumbles                = %00010000
.endenum

PLAYER_DOCKCOM          = $04C5 ; flag for player having a docking computer

; got Trumbles™?
.ifndef OPTION_NOTRUMBLES

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

;                       = $0521
;                       = $0522 ; UNUSED!

;                       = $0531
;                       = $0532 ; UNUSED!

.endif

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

PLAYER_GDRIVE           = $04c6 ; player has a galactic hyper-drive?

PLAYER_MISSILES         = $04cc ; number of missiles the player has
PLAYER_MISSILE_ARMED    = $0485 ; armed state of missile

PLAYER_LEGAL            = $04cd ; player's legal status

;                       = $04e0 ; number of kills (lo byte?)
PLAYER_KILLS            = $04e1 ; number of kills (hi byte?)

PLAYER_SHIELD_FRONT     = $04e7
PLAYER_SHIELD_REAR      = $04e8
PLAYER_ENERGY           = $04e9

PLAYER_TEMP_LASER       = $0488 ; laser temperature
PLAYER_TEMP_CABIN       = $0483 ; cabin temperature

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

; present system:
PSYSTEM_ECONOMY         = $04ee
PSYSTEM_GOVERNMENT      = $04f0
PSYSTEM_TECHLEVEL       = $04f1
PSYSTEM_POS             = $049a
PSYSTEM_POS_X           = $049a
PSYSTEM_POS_Y           = $049b

;-------------------------------------------------------------------------------

; NOTE: there are up-to 25 dust-particles at a time
; TODO: define the arrays below based on this
DUST_MAX                = 25

DUST_COUNT              = $050b ; number of dust particles
DUST_X                  = $06a2 ; X-positions of dust-particles
DUST_Y                  = $06bc ; Y-positions of dust-particles
DUST_Z                  = $06d6 ; Z-positions of dust-particles

                        ; $06EF