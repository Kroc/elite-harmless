; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "vars_main.asm":
;
; Elite's main variable space

.segment        "VARS_MAIN"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.res            $0300

VAR_0403                :=$0403
VAR_0441                :=$0441 ;?

; "local bubble"
;-------------------------------------------------------------------------------
; this section, from `SHIP_SLOTS` to `VAR_048C` describes
; the local "bubble" of universe around the player
;
; TODO: this should be bound by a segment to avoid
;       accidental breakage if variables are moved
;
; up to 11 3D-objects ("ships") can be in the game at a time. these are the
; 11 available slots; a value of $00 represents an unused slot, otherwise
; the value is a hull index (see "hull_data.asm") 
;
SHIP_SLOTS              :=$0452                                         ;FRIN

SHIP_SLOT0              :=$0452
SHIP_SLOT1              :=$0453
SHIP_SLOT2              :=$0454
SHIP_SLOT3              :=$0455
SHIP_SLOT4              :=$0456
SHIP_SLOT5              :=$0457
SHIP_SLOT6              :=$0458
SHIP_SLOT7              :=$0459
SHIP_SLOT8              :=$045a
SHIP_SLOT9              :=$045b
SHIP_SLOT10             :=$045c

; this is an array to count the number of each type of ship in play:
; as it is indexed by the ship-type, the order is determined by the
; order of hulls in "hull_data.asm". for the original, unmodified Elite,
; the resepective addresses and ship-types are listed below:
; (do NOT take this order as given for elite-harmless)
;
SHIP_TYPES              :=$045d ; number of ships of type X, indexed
                        ; $045D = unused
                        ; $045E = $01: missile
                        ; $045F = $02: station (coreolis)
                        ; $0460 = $03: escape pod
                        ; $0461 = $04: plate / alloy
                        ; $0462 = $05: cargo cannister
                        ; $0463 = $06: boulder
                        ; $0464 = $07: asteroid
                        ; $0465 = $08: splinter
                        ; $0466 = $09: shuttle
                        ; $0467 = $0A: transporter
                        ; $0468 = $0B: cobra mk.III, trader
                        ; $0469 = $0C: python, trader
                        ; $046A = $0D: boa
                        ; $046B = $0E: anaconda
                        ; $046C = $0F: asteroid, hermit
                        ; $046D = $10: viper
                        ; $046E = $11: sidewinder
                        ; $046F = $12: mamba
                        ; $0470 = $13: krait
                        ; $0471 = $14: adder
                        ; $0472 = $15: gecko
                        ; $0473 = $16: cobra mk.I
                        ; $0474 = $17: worm
                        ; $0475 = $18: cobra mk.III, pirate
                        ; $0476 = $19: asp mk.II
                        ; $0477 = $1A: python, pirate
                        ; $0478 = $1B: fer-de-lance
                        ; $0479 = $1C: moray
                        ; $047A = $1D: thargoid
                        ; $047B = $1E: thargon
                        ; $047C = $1F: constrictor
                        ; $047D = $20: cougar (stealth ship)
                        ; $047E = $21: station (dodo)

NUM_ASTEROIDS           :=$047f ; number of asteroids present

DOCKCOM_STATE           :=$0480 ; docking computer state: $00 = OFF, $FF = ON

ECM_STATE               :=$0481 ; if our ECM is enabled or not          ;ECMP

IS_WITCHSPACE           :=$0482 ; has misjump occurred? (witchspace)    ;MJ
CABIN_HEAT              :=$0483 ; cabin temperature

LASER_POWER             :=$0484 ; power level for current laser         ;LAS2
                                ; (bit 7 = beam)
PLAYER_MISSILE_ARMED    :=$0485 ; armed state of missile                ;MSAR
COCKPIT_VIEW            :=$0486 ; (front, rear, left, right)            ;VIEW

LASER_COUNTER           :=$0487 ; used to space out laser pulses        ;LASCT
LASER_HEAT              :=$0488 ; laser temperature                     ;GNTMP

                        ;;$0489 ; unused?
VAR_048A                :=$048a ; "extra vessels" spawning counter      ;EV
OSD_DELAY               :=$048b ; delay counter for on-screen messages  ;DLY
VAR_048C                :=$048c ; message ID on screen

;-------------------------------------------------------------------------------

JOY_ROLL                :=$048d ; roll amount coming from input         ;JSTX
JOY_PITCH               :=$048e ; pitch amount coming from input        ;JSTY

VAR_048F                :=$048f ;?
VAR_0490                :=$0490 ;?

; beginning of save data:
;===============================================================================
GAME_DATA               :=$0491

; commander / file name?
;
VAR_0491                :=$0491 ; 7-bytes, 8th byte is $0D (carriage-return?)

.enum   missions
        constrictor_begin       = %00000001
        constrictor_complete    = %00000010
        constrictor             = constrictor_begin | constrictor_complete

        blueprints_begin        = %00000100
        blueprints_birera       = %00001000
        blueprints              = blueprints_begin | blueprints_birera

        trumbles                = %00010000
.endenum

MISSION_FLAGS           :=$0499                                         ;TP

PSYSTEM_POS             :=$049a
PSYSTEM_POS_X           :=$049a                                         ;QQ0
PSYSTEM_POS_Y           :=$049b                                         ;QQ1

SEED_GALAXY             :=$049c ; seed for the current galaxy:          ;QQ21
SEED_GALAXY_W0          :=$049c ; first word
SEED_GALAXY_W0_LO       :=$049c ; lo-byte of first word
SEED_GALAXY_W0_HI       :=$049d ; hi-byte of first word
SEED_GALAXY_W1          :=$049e ; second word
SEED_GALAXY_W1_LO       :=$049e ; lo-byte of second word
SEED_GALAXY_W1_HI       :=$049f ; hi-byte of second word
SEED_GALAXY_W2          :=$04a0 ; third word
SEED_GALAXY_W2_LO       :=$04a0 ; lo-byte of third word
SEED_GALAXY_W2_HI       :=$04a1 ; hi-byte of third word

; player's cash:
PLAYER_CASH             :=$04a2                                         ;CASH
PLAYER_CASH_pt1         :=$04a2
PLAYER_CASH_pt2         :=$04a3
PLAYER_CASH_pt3         :=$04a4
PLAYER_CASH_pt4         :=$04a5

PLAYER_FUEL             :=$04a6                                         ;QQ14

PLAYER_COMPETITION      :=$04a7 ; competition flags                     ;COK

PLAYER_GALAXY           :=$04a8 ; current galaxy number                 ;GCNT


PLAYER_LASERS           :=$04a9 ; which laser is mounted to each view   ;LASER

.enum   laser
        none            = %00000000     ; value for no laser fitted
        power           = %01111111     ; bits 0-6 contain power-level
        beam            = %10000000     ; bit 7 sets continuous fire (beam)
.endenum

PLAYER_LASER_FRONT      :=$04a9 ; front laser
PLAYER_LASER_REAR       :=$04aa ; rear (aft) laser
PLAYER_LASER_LEFT       :=$04ab ; left laser
PLAYER_LASER_RIGHT      :=$04ac ; right laser

; $04AD/E are unused; up and down lasers were planned originally, but removed

; cargo:
;-------------------------------------------------------------------------------
SHIP_HOLD               :=$04af ; cargo capacity of the player's ship   ;CRGO

.struct Cargo
        food            .byte   ;+$00
        textiles        .byte   ;+$01
        radioactives    .byte   ;+$02
        slaves          .byte   ;+$03
        alcohol         .byte   ;+$04
        luxuries        .byte   ;+$05
        narcotics       .byte   ;+$06
        computers       .byte   ;+$07
        machinery       .byte   ;+$08
        alloys          .byte   ;+$09
        firearms        .byte   ;+$0A
        furs            .byte   ;+$0B
        minerals        .byte   ;+$0C
        gold            .byte   ;+$0D
        platinum        .byte   ;+$0E
        gems            .byte   ;+$0F
        aliens          .byte   ;+$10
.endstruct

; cargo storage:
; NOTE: the order here has to mimic that of the strings in "text_flight.asm",
;       (or vice-versa depending on how you see it)
;
PLAYER_CARGO            :=$04b0                                         ;QQ20
CARGO_FOOD              :=$04b0 ; food                                  ;QQ20+0
CARGO_TEXTILES          :=$04b1 ; textiles                              ;QQ20+1
CARGO_RADIOACTIVES      :=$04b2 ; radioactives                          ;QQ20+2
CARGO_SLAVES            :=$04b3 ; slaves                                ;QQ20+3
CARGO_ALCOHOL           :=$04b4 ; liquor & wines                        ;QQ20+4
CARGO_LUXURIES          :=$04b5 ; luxuries                              ;QQ20+5
CARGO_NARCOTICS         :=$04b6 ; narcotics                             ;QQ20+6
CARGO_COMPUTERS         :=$04b7 ; computers                             ;QQ20+7
CARGO_MACHINERY         :=$04b8 ; machinery                             ;QQ20+8
CARGO_ALLOYS            :=$04b9 ; alloys                                ;QQ20+9
CARGO_FIREARMS          :=$04ba ; firearms                              ;QQ20+10
CARGO_FURS              :=$04bb ; furs                                  ;QQ20+11
CARGO_MINERALS          :=$04bc ; minerals                              ;QQ20+12
CARGO_GOLD              :=$04bd ; gold                                  ;QQ20+13
CARGO_PLATINUM          :=$04be ; platinum                              ;QQ20+14
CARGO_GEMS              :=$04bf ; gem-stones                            ;QQ20+15
CARGO_ALIENS            :=$04c0 ; alien items                           ;QQ20+16

; note that when the player is taking damage and has no shields
; there's a possibility of their cargo being destroyed but also
; the following equipment, which is why they are placed here
;
PLAYER_ECM              :=$04c1 ; flag, player has an E.C.M.            ;ECM
PLAYER_SCOOP            :=$04c2 ; flag, player has a fuel scoop         ;BST
PLAYER_EBOMB            :=$04c3 ; flag, player has energy bomb          ;BOMB
PLAYER_EUNIT            :=$04c4 ; flag, player has extra energy unit    ;ENGY
PLAYER_DOCKCOM          :=$04c5 ; flag, player has a docking computer   ;DKCMP
;-------------------------------------------------------------------------------

PLAYER_GDRIVE           :=$04c6 ; player has a galactic hyper-drive?    ;GYHP
PLAYER_ESCAPEPOD        :=$04c7 ; player has an escape pod?             ;ESCP

PLAYER_KILLS_FRAC       :=$04cb ; kill total, fractional part

PLAYER_MISSILES         :=$04cc ; number of missiles the player has     ;NOMSL

PLAYER_LEGAL            :=$04cd ; player's legal status                 ;FIST

; market availability:
;-------------------------------------------------------------------------------
; (quantity of goods on sale)
;
MARKET                  :=$04ce                                         ;AVL
MARKET_FOOD             :=$04ce ; quantity of food on sale              ;AVL+0
MARKET_TEXTILES         :=$04cf ; quantity of textiles on sale          ;AVL+1
MARKET_RADIOACTIVES     :=$04d0 ; quantity of radioactives on sale      ;AVL+2
MARKET_SLAVES           :=$04d1 ; quantity of slaves on sale            ;AVL+3
MARKET_ALCOHOL          :=$04d2 ; quantity of liquor & wines on sale    ;AVL+4
MARKET_LUXURIES         :=$04d3 ; quantity of luxuries on sale          ;AVL+5
MARKET_NARCOTICS        :=$04d4 ; quantity of narcotics on sale         ;AVL+6
MARKET_COMPUTERS        :=$04d5 ; quantity of computers on sale         ;AVL+7
MARKET_MACHINERY        :=$04d6 ; quantity of machinery on sale         ;AVL+8
MARKET_ALLOYS           :=$04d7 ; quantity of alloys on sale            ;AVL+9
MARKET_FIREARMS         :=$04d8 ; quantity of firearms on sale          ;AVL+10
MARKET_FURS             :=$04d9 ; quantity of furs on sale              ;AVL+11
MARKET_MINERALS         :=$04da ; quantity of minerals on sale          ;AVL+12
MARKET_GOLD             :=$04db ; quantity of gold on sale              ;AVL+13
MARKET_PLATINUM         :=$04dc ; quantity of platinum on sale          ;AVL+14
MARKET_GEMS             :=$04dd ; quantity of gem-stones on sale        ;AVL+15
MARKET_ALIENS           :=$04de ; quantity of alien items on sale       ;AVL+16

MARKET_RANDOM           :=$04df ; random variance for market prices     ;QQ26
;-------------------------------------------------------------------------------

PLAYER_KILLS            :=$04e0                                         ;TALLY
PLAYER_KILLS_LO         :=$04e0 ; number of kills, lo-byte
PLAYER_KILLS_HI         :=$04e1 ; number of kills, hi-byte

; checksum:
;-------------------------------------------------------------------------------
VAR_04E2                :=$04e2 ; save count                            ;SVC
VAR_04E3                :=$04e3                                         ;CHK2
VAR_04E4                :=$04e4                                         ;CHK
;===============================================================================
; (end of save data block)


; got Trumbles™?
;
.ifdef  FEATURE_TRUMBLES
;///////////////////////////////////////////////////////////////////////////////

PLAYER_TRUMBLES         :=$04c9 ; number of Trumbles™ in the player's hold
PLAYER_TRUMBLES_LO      :=$04c9
PLAYER_TRUMBLES_HI      :=$04ca

TRUMBLES_ONSCREEN       :=$0510 ; number of Trumbles™ on-screen; up to 6

; the amount each Trumble™ moves X / Y
; (these are interlaced)
;
TRUMBLES_MOVE_X         :=$0511
TRUMBLES_MOVE_Y         :=$0512

TRUMBLES_MOVE_X0        :=$0511
TRUMBLES_MOVE_Y0        :=$0512
TRUMBLES_MOVE_X1        :=$0513
TRUMBLES_MOVE_Y1        :=$0514
TRUMBLES_MOVE_X2        :=$0515
TRUMBLES_MOVE_Y2        :=$0516
TRUMBLES_MOVE_X3        :=$0517
TRUMBLES_MOVE_Y3        :=$0518
TRUMBLES_MOVE_X4        :=$0519
TRUMBLES_MOVE_Y4        :=$051A
TRUMBLES_MOVE_X5        :=$051B
TRUMBLES_MOVE_Y5        :=$051C
TRUMBLES_MOVE_X6        :=$051D
TRUMBLES_MOVE_Y6        :=$051E
TRUMBLES_MOVE_X7        :=$051F ; UNUSED! There is no 7th Trumble™ on-screen!
TRUMBLES_MOVE_Y7        :=$0520 ; UNUSED! There is no 7th Trumble™ on-screen!

TRUMBLES_XPOS_LO        :=$0521 ; X-positions 0-328, for Trumble™ 0-5, lo-bytes
TRUMBLES_XPOS_HI        :=$0531 ; X-positions 0-328, for Trumble™ 0-5, hi-bytes

;///////////////////////////////////////////////////////////////////////////////
.endif

;-------------------------------------------------------------------------------

VAR_04E6                :=$04e6 ;?

; TODO: these variables are erased together by `_RESET`
;       so should be bound by a segment
;-------------------------------------------------------------------------------
PLAYER_SHIELD_FRONT     :=$04e7                                         ;FSH
PLAYER_SHIELD_REAR      :=$04e8                                         ;ASH
PLAYER_ENERGY           :=$04e9                                         ;ENERGY
;-------------------------------------------------------------------------------

VAR_04EA                :=$04ea ;?
VAR_04EB                :=$04eb ;?

SHIP_LINES_LO           :=$04f2 ; ship lines pointer lo-byte            ;SLSP+0
SHIP_LINES_HI           :=$04f3 ; ship lines pointer hi-byte            ;SLSP+1

VAR_04F4                :=$04f4 ; temp copy of seed? (indexed by X)     ;QQ2
VAR_04FA                :=$04fa ; temp copy of seed? (indexed by X)

; target system:                                                        ; BBC:
;-------------------------------------------------------------------------------
TSYSTEM_DATA            :=$0500
TSYSTEM_ECONOMY         :=$0500 ; economy type 0-7                      ;QQ3
TSYSTEM_GOVERNMENT      :=$0501 ; government type 0-7                   ;QQ4
TSYSTEM_TECHLEVEL       :=$0502 ; tech-level 0-14                       ;QQ5
TSYSTEM_POPULATION      :=$0503                                         ;QQ6
TSYSTEM_PRODUCTIVITY    :=$0505                                         ;QQ7
TSYSTEM_PRODUCTIVITY_LO :=$0505                                         ;QQ7+0
TSYSTEM_PRODUCTIVITY_HI :=$0506                                         ;QQ7+1
TSYSTEM_DISTANCE        :=$0507                                         ;QQ8
TSYSTEM_DISTANCE_LO     :=$0507                                         ;QQ8+0
TSYSTEM_DISTANCE_HI     :=$0508                                         ;QQ8+1
TSYSTEM_POS             :=$0509
TSYSTEM_POS_X           :=$0509
TSYSTEM_POS_Y           :=$050a

VAR_050C                :=$050c ; char colour?
VAR_050D                :=$050d ;?
VAR_050E                :=$050e ;?
VAR_050F                :=$050f ;?

PSYSTEM_ECONOMY         :=$04ee ; present system economy size

VAR_04EC                :=$04ec ; used with market prices
VAR_04ED                :=$04ed ; quantity of item
CARGO_ITEM              :=$04ef ; type of item                          ;QQ29

PSYSTEM_GOVERNMENT      :=$04f0
PSYSTEM_TECHLEVEL       :=$04f1

;-------------------------------------------------------------------------------
; NOTE: there are up-to 13 dust-particles at a time. `DUST_COUNT`
; is only ever set to $0C (in `_83ed`) or $03 (in `_73c1`)
; TODO: define the arrays below based on this
;
DUST_MAX                = 13

DUST_COUNT              :=$050b ; number of dust particles              ;NOSTM
DUST_X_HI               :=$06a2 ;..$06AE: X-positions of dust-particles
DUST_X_LO               :=$06af ;..$06BB: fractional X-positions
DUST_Y_HI               :=$06bc ;..$06C8: Y-positions of dust-particles
DUST_Y_LO               :=$06c9 ;..$06D5: fractional Y-positions
DUST_Z_HI               :=$06d6 ;..$06E2: Z-positions of dust-particles
DUST_Z_LO               :=$06e3 ;..$06EF: fractional Z-positions

;-------------------------------------------------------------------------------
; sun circles are converted into a list of half-widths for each scan-line,
; i.e. for each scanline in the viewport, this array provides a radius for
; that scanline where the centre point of the circle is already known
;
; the stars in the local chart are also drawn using this system,
; so up to 200 scan-lines are accounted for despite the viewport
; being 144 px tall
;
; TODO: as this is indexed, keep it within one page
;
SUN_BUFFER              :=$0580

TXT_BUFFER              :=$0648 ; printing text-buffer

VAR_06F0                :=$06f0 ;?
VAR_06F1                :=$06f1 ;?
VAR_06F3                :=$06f3 ;?

LINE_SWAP               :=$06f4 ; flag for line start/end swapped       ;SWAP

VAR_SDIST               :=$06fb ; title screen ship z-distance          ;SDIST