; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; NOTE: the segment that this code belongs to will be set by the including
;       file, e.g. "elite-original.asm" / "elite-harmless.asm"

; I think this is when the player has docked,
; it checks for potential mission offers
;
_1d81:                                                                  ;$1D81
        jsr _83df
        jsr _379e

        ; now the player is docked, some variables can be reset
        ; -- the cabin temperature is not reset; oversight / bug?
        lda # $00
        sta PLAYER_SPEED        ; bring player's ship to a full stop
        sta PLAYER_TEMP_LASER   ; complete laser cooldown
        sta ZP_66               ; reset hyperspace countdown

        ; set shields to maximum,
        ; restore energy:
        lda # $ff
        sta PLAYER_SHIELD_FRONT
        sta PLAYER_SHIELD_REAR
        sta PLAYER_ENERGY

        ldy # 44                ; wait 44 frames
        jsr wait_frames         ; -- why would this be necessary?

        ; if the galaxy is not using the original Elite seed, then the missions
        ; will not function as they rely on specific planet name / placement
        ;
.ifndef OPTION_CUSTOMSEED
        ;///////////////////////////////////////////////////////////////////////

        ; check eligibility for the Constrictor mission:
        ;-----------------------------------------------------------------------
        ; available on the first galaxy after 256 or more kills. your job is
        ; to hunt down the prototype Constrictor ship starting at Reesdice
        ;
        ; is the mission already underway or complete?
        lda MISSION_FLAGS
        and # missions::constrictor
       .bnz :+                  ; mission is underway/complete, ignore it

        lda PLAYER_KILLS
        beq @skip               ; ignore mission if kills less than 256

        ; is the player in the first galaxy?
        ;
        lda PLAYER_GALAXY       ; if bit 0 is set, shifting right will cause
        lsr                     ; it to fall off the end, leaving zero;
       .bnz @skip               ; if not first galaxy, ignore mission

        ; start the Constrictor mission
        jmp _3dff

        ; is the mission complete? (both bits set)
:       cmp # missions::constrictor                                     ;$1DB5
       .bnz :+

        ; you've docked at a station, set up the 'tip' that will display in
        ; the planet info for where to find the Constrictor next
        jmp _3daf

:       ; check eligibility for Thargoid Blueprints mission             ;$1DBC
        ;-----------------------------------------------------------------------
        ; once you've met the criteria for this mission (3rd galaxy, have
        ; completed the Constrictor mission, >=1280 kills) you're presented
        ; with a message to fly to Ceerdi. Once there, you're given some
        ; top-secret blueprints which you have to get to Birera
        ;
        ; is the player in the third galaxy?
        lda PLAYER_GALAXY
        cmp # 2
        bne @skip               ; no; ignore mission

        ; player is in the third galaxy; has the player completed the
        ; Constrictor mission already? (and hasn't started blueprints mission)
        lda MISSION_FLAGS
        and # missions::constrictor | missions::blueprints
        cmp # missions::constrictor_complete
        bne :+

        ; has the player at least 1280 kills? (halfway to Deadly)
        lda PLAYER_KILLS
        cmp #> 1280
       .blt @skip               ; no; skip ahead if not enough

        ; 'start' the mission: the player has to fly
        ; to Ceerdi to actually get the blueprints
        jmp mission_blueprints_begin

:       ; has the player started the blueprints mission?                ;$1DD6
        ; (and by association, completed the Constrictor mission)
        cmp # missions::constrictor_complete | missions::blueprints_begin
        bne :+

        ; is the player at Ceerdi?
        ;SPEED: couldn't we use the planet index number
        ;       instead of checking co-ordinates?

        lda PSYSTEM_POS_X
        cmp # 215
        bne @skip

        lda PSYSTEM_POS_Y
        cmp # 84
        bne @skip

        jmp mission_blueprints_ceerdi

:       cmp # %00001010                                                 ;$1DEB
        bne @skip

        ; is the player at Birera?
        ;SPEED: couldn't we use the planet index number
        ;       instead of checking co-ordinates?

        lda PSYSTEM_POS_X
        cmp # 63
        bne @skip

        lda PSYSTEM_POS_Y
        cmp # 72
        bne @skip

        jmp mission_blueprints_birera

.endif  ;///////////////////////////////////////////////////////////////////////

@skip:  ; check for Trumbles™ mission                                   ;$1E00
        ;
.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////

        ; at least 6'553.5 cash?
        lda PLAYER_CASH_pt3
        cmp # $c4               ;TODO: not sure how this works out as 6'553.5?
       .blt :+

        ; has the mission already been done?
        lda MISSION_FLAGS
        and # missions::trumbles
        bne :+

        ; initiate Trumbles™ mission
        jmp mission_trumbles

.endif  ;///////////////////////////////////////////////////////////////////////

:       jmp _88e7                                                       ;$1E11

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; the unused and incomplete debug code can be removed
; in non-original builds
;
debug_for_brk:                                                          ;$1E14
        ; set a routine to capture use of the `brk` instruction.
        ; not actually used, but present, in original Elite
        ;
        lda #< debug_brk
        sei                     ; disable interrupts
        sta KERNAL_VECTOR_BRK+0
        lda #> debug_brk
        sta KERNAL_VECTOR_BRK+1
        cli                     ; enable interrupts

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================
; Trumble™ A.I. data?
;
trumble_steps:                                                          ;$1E21
        ; movement steps; "0, 1, -1, 0"
        .byte   $00, $01, $ff, $00
_1e25:                                                                  ;$1E25
        .byte   $00, $00, $ff, $00

; masks for sprite MSBs?
_1e29:                                                                  ;$1E29
        .byte   %11111011, %00000100
        .byte   %11110111, %00001000
        .byte   %11101111, %00010000
        .byte   %11011111, %00100000
        .byte   %10111111, %01000000
        .byte   %01111111, %10000000

_1e35:
        ;-----------------------------------------------------------------------
        ; move Trumbles™ around the screen
        ;
        lda ZP_A3               ; "move counter"?
        and # %00000111         ; modulo 8 (0-7)
        cmp TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .blt :+

        jmp _1ece

        ; take the counter 0-7 and multiply by 2
        ; for use in a table of 16-bit values later
:       asl                                                             ;$1E41
        tay 

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn the I/O area on to manage the sprites
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; should the Trumbles™ change direction?
        ;
        jsr get_random_number   ; select a random number
        cmp # 235               ; is it > 234 (about 8% probability)
       .blt @move               ; no, just keep moving

        ; pick a direction for the Trumble™
        ;
        ; select an X direction:
        ; 50% chance stay still, 25% go left, 25% go right
        and # %00000011         ; random number modulo 4 (0-3)
        tax                     ; choice 1-4
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_X, y  ; set the Trumble™'s X direction

        lda _1e25, x
        sta VAR_0521, y

        ; select a Y direction:
        ; 50% chance stay still, 25% go up, 25% go down
        jsr get_random_number   ; pick a new random number
        and # %00000011         ; modulo 4 (0-3)
        tax                     ; choice 1-4
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_Y, y  ; set the Trumble™'s Y direction

@move:                                                                  ;$1E6A
        lda _1e29, y
        and VIC_SPRITES_X
        sta VIC_SPRITES_X

        ; move the Trumble™ sprite vertically
        lda VIC_SPRITE2_Y, y
        clc 
        adc TRUMBLES_MOVE_Y, y
        sta VIC_SPRITE2_Y, y

        ; move the Trumble™ sprite horizontally
        clc 
        lda VIC_SPRITE2_X, y
        adc TRUMBLES_MOVE_X, y
        sta ZP_VAR_T

        lda VAR_0531, y
        adc VAR_0521, y
        bpl :+

        lda # $48               ;=72 / %01001000
        sta ZP_VAR_T

        lda # $01
:       and # %00000001                                                 ;$1E94
        beq _1ea4

        lda ZP_VAR_T
        cmp # $50               ;=80 / %10000000
        lda # $01
        bcc _1ea4

        lda # $00
        sta ZP_VAR_T
_1ea4:                                                                  ;$1EA4
        sta VAR_0531, y
        beq _1eb3

        ; MSBs?
        lda _1e29+1, y
        ora VIC_SPRITES_X
        sei                     ; disable interrupts whilst repositioning
        sta VIC_SPRITES_X
_1eb3:                                                                  ;$1EB3
        lda ZP_VAR_T
        sta VIC_SPRITE2_X, y
        cli                     ; re-enable interrupts

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn I/O off, go back to 64K RAM
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        jmp _1ece

_1ec1:                                                                  ;$1EC1
;===============================================================================
; main cockpit-view game-play loop perhaps?
; (handles many key presses)
;
        lda POLYOBJ_00          ;=$F900?
        sta ZP_GOATSOUP_pt1     ;? randomize?

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////

        ; are there any Trumbles™ on-screen?
        lda TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .bze _1ece               ; =0; don't process Trumbles™

        ; process Trumbles™
        ; (move them about, breed them)
        jmp _1e35

.endif  ;///////////////////////////////////////////////////////////////////////

_1ece:                                                                  ;$1ECE
        ;-----------------------------------------------------------------------
        ldx VAR_048D
        jsr _3c58
        jsr _3c58

        txa 
        eor # %10000000         ; flip the sign bit
        tay                     ; put aside
        and # %10000000         ; strip down to just the sign bit
        sta ZP_ROLL_SIGN        ; store as our "direction of roll"

        stx VAR_048D            ; X-dampen?
        eor # %10000000
        sta ZP_6A               ; inverse roll direction

        tya 
        bpl :+

        ; negate
        eor # %11111111
        clc 
        adc # $01

:       lsr                                                             ;$1EEE
        lsr 
        cmp # $08
        bcs :+
        lsr 

:       sta ZP_ROLL_MAGNITUDE                                           ;$1EF5
        ora ZP_ROLL_SIGN        ; add sign
        sta ZP_ALPHA            ; put aside for use in the matrix math

        ;-----------------------------------------------------------------------

        ldx VAR_048E
        jsr _3c58

        txa 
        eor # %10000000
        tay 
        and # %10000000
        stx VAR_048E
        sta ZP_95
        eor # %10000000
        sta ZP_PITCH_SIGN
        tya 
        bpl _1f15
        eor # %11111111
_1f15:                                                                  ;$1F15
        adc # $04
        lsr 
        lsr 
        lsr 
        lsr 
        cmp # $03
        bcs _1f20
        lsr 
_1f20:                                                                  ;$1F20
        ; get the player ship's pitch;
        ; stored as separate sign & magnitude
        ;
        sta ZP_PITCH_MAGNITUDE
        ora ZP_PITCH_SIGN
        sta ZP_BETA             ; put aside for the matrix math

        ; accelerate?
        ;-----------------------------------------------------------------------
        lda key_accelerate      ; is accelerate being held?
       .bze :+                  ; if not, continue

        lda PLAYER_SPEED        ; current speed
        cmp # $28               ; are we at maximum speed?
        bcs :+

        inc PLAYER_SPEED        ; increase player's speed

:       ; decelerate?                                                   ;$1F33
        ;-----------------------------------------------------------------------
        lda key_decelerate      ; is decelerate being held?
       .bze :+                  ; if not, continue

        dec PLAYER_SPEED        ; reduce player's speed
       .bnz :+                  ; still above zero?
        inc PLAYER_SPEED        ; if zero, set to 1?

        ; disarm missile?
        ;-----------------------------------------------------------------------
:       lda key_missile_disarm  ; is disarm missile key being pressed?  ;$1F3E
        and PLAYER_MISSILES     ; does the player have any missiles?
       .bze :+                  ; no? skip ahead

        ldy # $57
        jsr _7d0c
        ldy # $06
        jsr _a858

        lda # $00               ; set loaded missile as disarmed ($00)
        sta PLAYER_MISSILE_ARMED

:       lda ZP_MISSILE_TARGET                                           ;$1F55
        bpl :+

        ; target missile?
        ;-----------------------------------------------------------------------
        lda key_missile_target  ; target missile key pressed?
       .bze :+

        ldx PLAYER_MISSILES     ; does the player have any missiles?
       .bze :+

        ; set missile armed flag on
        ; (A = $FF from `key_missile_target`)
        sta PLAYER_MISSILE_ARMED

        ldy # $87
        jsr _b11f

        ; fire missile?
        ;-----------------------------------------------------------------------
:       lda key_missile_fire    ; fire missile key held?                ;$1F6B
       .bze :+                  ; no, skip ahead

        lda ZP_MISSILE_TARGET
        bmi _1fc2
        jsr _36a6

        ; energy bomb?
        ;-----------------------------------------------------------------------
:       lda key_bomb            ; energy bomb key held?                 ;$1F77
       .bze :+

        asl PLAYER_EBOMB        ; does player have an energy bomb?
        beq :+                  ; no? keep going

        ldy # vic_screen_ctl2::unused | vic_screen_ctl2::multicolor
        sty interrupt_screenmode1

        ldy # $0d
        jsr _a858               ; handle e-bomb?

        ; turn docking computer off?
        ;-----------------------------------------------------------------------
:       lda key_docking_off     ; docking-computer off pressed?         ;$1F8B
       .bze :+                  ; no? skip ahead

        lda # $00               ; $00 = OFF
        sta DOCKCOM_STATE       ; turn docking computer off

        jsr _923b

        ; activate escape pod?
        ;-----------------------------------------------------------------------
:       lda key_escape_pod      ; escape pod key pressed?               ;$1F98
        and PLAYER_ESCAPEPOD    ; does the player have an escape pod?
       .bze :+                  ; no? keep moving

        lda IS_WITCHSPACE       ; is the player stuck in witchspace?
       .bnz :+                  ; yes...

        jmp eject_escapepod     ; no: eject escpae pod

        ; quick-jump?
        ;-----------------------------------------------------------------------
:       lda key_jump            ; quick-jump key pressed?               ;$1FA8
       .bze :+                  ; no? skip ahead

        jsr do_quickjump        ; handle the quick-jump

        ; activate E.C.M.?
        ;-----------------------------------------------------------------------
:       lda key_ecm             ; E.C.M. key pressed?                   ;$1FB0
        and PLAYER_ECM          ; does the player have an E.C.M.?
        beq _1fc2

        lda ZP_67
        bne _1fc2

        dec VAR_0481
        jsr _b0f4

_1fc2:  ; turn docking computer on?                                     ;$1FC2
        ;-----------------------------------------------------------------------
        lda key_docking_on      ; key for docking computers pressed?
        and PLAYER_DOCKCOM      ; does the player have a docking computer?
       .bze :+                  ; no, skip
        eor joy_down            ; stops ship climbing, but why?
       .bze :+
        sta DOCKCOM_STATE       ; turn docking computer on (A = $FF)

.ifndef OPTION_NOSOUND
        ;///////////////////////////////////////////////////////////////////////
        jsr _9204               ; handle docking computer music?
.endif  ;///////////////////////////////////////////////////////////////////////

:       lda # $00                                                       ;$1FD5
        sta ZP_7B
        sta ZP_97

        lda PLAYER_SPEED
        lsr 
        ror ZP_97
        lsr 
        ror ZP_97
        sta ZP_98               ; ZP_98.ZP_97 = PLAYER_SPEED*64

        lda VAR_0487
        bne _202d

        lda joy_fire
        beq _202d

        lda PLAYER_TEMP_LASER
        cmp # $f2
        bcs _202d

        ; is there a laser mounted on this direction?
        ldx COCKPIT_VIEW
        lda PLAYER_LASERS, x
        beq _202d

        pha 
        and # %01111111
        sta ZP_7B
        sta VAR_0484

        ldy # $00
        pla 
        pha 
        bmi _2014
        cmp # $32
        bne _2012
        ldy # $0c
_2012:                                                                  ;$2012
        bne _201d
_2014:                                                                  ;$2014
        cmp # $97
        beq _201b
        ldy # $0a

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_201b:                                                                  ;$201B
        ldy # $0b
_201d:                                                                  ;$201D
        jsr _a858
        jsr shoot_lasers
        pla 
        bpl _2028
        lda # $00
_2028:                                                                  ;$2028
        and # %11111010
        sta VAR_0487
_202d:                                                                  ;$202D
        ldx # $00
_202f:                                                                  ;$202F
        stx ZP_9D

        lda SHIP_SLOTS, x
        bne _2039

        jmp _21fa

        ;-----------------------------------------------------------------------

_2039:                                                                  ;$2039
        sta ZP_A5               ; put ship type aside
        jsr get_polyobj

        ; copy the given PolyObject to the zero page:
        ; ($09..$2D)
        ;
        ldy # .sizeof(PolyObject) - 1
:       lda [ZP_POLYOBJ_ADDR], y                                        ;$2040
        sta ZP_POLYOBJ, y
        dey 
        bpl :-

        lda ZP_A5               ; get ship type back
        bmi @skip               ; if sun / planet, skip over

        asl 
        tay 
        lda hull_pointers - 2, y
        sta ZP_HULL_ADDR_LO
        lda hull_pointers - 1, y
        sta ZP_HULL_ADDR_HI

        lda PLAYER_EBOMB        ; player has energy bomb?
        bpl @skip

        ; space station?
        cpy # hull_coreolis_index *2
        beq @skip

        ; thargoid?
        cpy # hull_thargoid_index *2
        beq @skip

        ; constrictor?
        cpy # hull_constrictor_index *2
        bcs @skip

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        bne @skip

        asl ZP_POLYOBJ_VISIBILITY
        sec 
        ror ZP_POLYOBJ_VISIBILITY

        ldx ZP_A5
        jsr _a7a6

@skip:  jsr _a2a0                                                       ;$2079

        ; copy the zero-page PolyObject back to its storage

        ldy # .sizeof(PolyObject) - 1
:       lda ZP_POLYOBJ, y                                               ;$207E
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        bpl :-

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::exploding | visibility::display
        jsr _87b1
        bne _20e0

        lda ZP_POLYOBJ_XPOS_LO
        ora ZP_POLYOBJ_YPOS_LO
        ora ZP_POLYOBJ_ZPOS_LO
        bmi _20e0

        ldx ZP_A5
        bmi _20e0

        cpx # $02
        beq _20e3

        and # %11000000
        bne _20e0

        cpx # $01
        beq _20e0
        lda VAR_04C2
        and ZP_POLYOBJ_YPOS_HI  ;=$0E
        bpl _2122
        cpx # $05
        beq _20c0

        ldy # Hull::scoop_debris
        lda [ZP_HULL_ADDR], y
        lsr 
        lsr 
        lsr 
        lsr 
        beq _2122
        adc # $01
        bne _20c5
_20c0:                                                                  ;$20C0
        jsr get_random_number
        and # %00000111
_20c5:                                                                  ;$20C5
        jsr _6a00               ; count cargo?
        ldy # $4e
        bcs _2110

        ldy VAR_04EF            ; item index?
        adc VAR_CARGO, y
        sta VAR_CARGO, y
        tya 
        adc # $d0
        jsr _900d

        asl ZP_POLYOBJ_BEHAVIOUR
        sec 
        ror ZP_POLYOBJ_BEHAVIOUR
_20e0:                                                                  ;$20E0
        jmp _2131

        ;-----------------------------------------------------------------------

_20e3:                                                                  ;$20E3
        lda POLYOBJ_01 + PolyObject::behaviour                         ;=$F949
        and # behaviour::angry
        bne _2107

        lda ZP_POLYOBJ_M0x2_HI
        cmp # $d6
        bcc _2107
        jsr _8c7b
        lda ZP_VAR_X2
        cmp # $59
        bcc _2107
        lda ZP_POLYOBJ_M1x0_HI
        and # %01111111
        cmp # $50
        bcc _2107
_2101:                                                                  ;$2101
        jsr _923b
        jmp _1d81

        ;-----------------------------------------------------------------------

_2107:                                                                  ;$2107
        lda PLAYER_SPEED
        cmp # $05
        bcc _211a
        jmp _87d0

        ;-----------------------------------------------------------------------

_2110:                                                                  ;$2110
        jsr _a813

        ; set top-bit of visibility state?
        asl ZP_POLYOBJ_VISIBILITY
        sec 
        ror ZP_POLYOBJ_VISIBILITY
        bne _2131
_211a:                                                                  ;$211A
        lda # $01
        sta PLAYER_SPEED
        lda # $05
        bne _212b
_2122:                                                                  ;$2122
        asl ZP_POLYOBJ_VISIBILITY
        sec 
        ror ZP_POLYOBJ_VISIBILITY
        lda ZP_POLYOBJ_ENERGY
        sec 
        ror 
_212b:                                                                  ;$212B
        jsr _7bd2
        jsr _a813
_2131:                                                                  ;$2131
        lda ZP_POLYOBJ_BEHAVIOUR
        bpl _2138
        jsr _b410
_2138:                                                                  ;$2138
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz _21ab               ; no? skip ahead

        jsr _a626
        jsr _363f
        bcc _21a8

        lda PLAYER_MISSILE_ARMED
        beq _2153

        jsr _a80f
        ldx ZP_9D
        ldy # $27
        jsr _7d0e
_2153:                                                                  ;$2153
        lda ZP_7B
        beq _21a8
        ldx # $0f
        jsr _a7e9
        lda ZP_A5
        cmp # $02
        beq _21a3
        cmp # $1f
        bcc _2170
        lda ZP_7B
        cmp # $17
        bne _21a3
        lsr ZP_7B
        lsr ZP_7B
_2170:                                                                  ;$2170
        lda ZP_POLYOBJ_ENERGY
        sec 
        sbc ZP_7B
        bcs _21a1

        asl ZP_POLYOBJ_VISIBILITY
        sec 
        ror ZP_POLYOBJ_VISIBILITY

        lda ZP_A5
        cmp # $07
        bne _2192
        lda ZP_7B
        cmp # $32
        bne _2192
        jsr get_random_number
        ldx # $08
        and # %00000011
        jsr _2359
_2192:                                                                  ;$2192
        ldy # $04
        jsr _234c
        ldy # $05
        jsr _234c

        ldx ZP_A5
        jsr _a7a6
_21a1:                                                                  ;$21A1
        sta ZP_POLYOBJ_ENERGY
_21a3:                                                                  ;$21A3
        lda ZP_A5
        jsr _36c5
_21a8:                                                                  ;$21A8
        jsr _9a86
_21ab:                                                                  ;$21AB
        ldy # PolyObject::energy
        lda ZP_POLYOBJ_ENERGY
        sta [ZP_POLYOBJ_ADDR], y

        lda ZP_POLYOBJ_BEHAVIOUR
        bmi _21e2

        lda ZP_POLYOBJ_VISIBILITY
        bpl _21e5               ; bit 7 set?

        and # visibility::display
        beq _21e5

        lda ZP_POLYOBJ_BEHAVIOUR
        and # behaviour::police
        ora PLAYER_LEGAL
        sta PLAYER_LEGAL
        lda VAR_048B
        ora IS_WITCHSPACE
        bne _21e2

        ldy # Hull::bounty      ;=$0A: (bounty lo-byte)
        lda [ZP_HULL_ADDR], y
        beq _21e2

        tax 
        iny                     ;=$0B: (bounty hi-byte)
        lda [ZP_HULL_ADDR], y
        tay 
        jsr _7481
        lda # $00
        jsr _900d
_21e2:                                                                  ;$21E2
        jmp _829a

        ;-----------------------------------------------------------------------

_21e5:                                                                  ;$21E5
        lda ZP_A5
        bmi _21ee
        jsr _87a4
        bcc _21e2
_21ee:                                                                  ;$21EE
        ldy # PolyObject::visibility
        lda ZP_POLYOBJ_VISIBILITY
        sta [ZP_POLYOBJ_ADDR], y

        ldx ZP_9D
        inx 
        jmp _202f

        ;-----------------------------------------------------------------------

_21fa:                                                                  ;$21FA
        lda PLAYER_EBOMB        ; player has energy bomb?
        bpl _2207
        asl PLAYER_EBOMB        ; player has energy bomb?
        bmi _2207
        jsr _2367
_2207:                                                                  ;$2207
        lda ZP_A3               ; move counter?
        and # %00000111
        bne _227a

        ldx PLAYER_ENERGY
        bpl _2224

        ldx PLAYER_SHIELD_REAR
        jsr _7b61
        stx PLAYER_SHIELD_REAR

        ldx PLAYER_SHIELD_FRONT
        jsr _7b61
        stx PLAYER_SHIELD_FRONT
_2224:                                                                  ;$2224
        sec 
        lda VAR_04C4            ; energy charge rate?
        adc PLAYER_ENERGY
        bcs _2230
        sta PLAYER_ENERGY
_2230:                                                                  ;$2230
        lda IS_WITCHSPACE
        bne _2277

        lda ZP_A3               ; move counter?
        and # %00011111
        bne _2283

        lda VAR_045F
        bne _2277

        tay 
        jsr _2c50
        bne _2277

        ; copy some of the PolyObject data to zeropage:
        ;
        ; the X/Y/Z position of the PolyObject
        ; (these are not addresses, but they are 24-bit)
        ;
        ; $09-$0B:      xpos            .faraddr
        ; $0C-$0E:      ypos            .faraddr
        ; $0F-$11:      zpos            .faraddr
        ;
        ; a 3x3 rotation matrix?
        ;
        ; $12-$13:      m0x0            .word
        ; $14-$15:      m0x1            .word
        ; $16-$17:      m0x2            .word
        ; $18-$19:      m1x0            .word
        ; $1A-$1B:      m1x1            .word
        ; $1C-$1D:      m1x2            .word
        ; $1E-$1F:      m2x0            .word
        ; $20-$21:      m2x1            .word
        ; $22-$23:      m2x2            .word
        ;
        ; a pointer to already processed vertex data
        ;
        ; $24-$25:      vertexData      .addr

        ; number of bytes to copy:
        ; (up to, and including, the `vertexData` property)
        ldx # PolyObject::vertexData + .sizeof(PolyObject::vertexData) - 1

        ;?
:       lda POLYOBJ_00, x       ;=$F900                                 ;$2248
        sta ZP_POLYOBJ, x       ;=$09
        dex 
        bpl :-

        inx 
        ldy # $09
        jsr _2c2d
        bne _2277

        ldx # $03
        ldy # $0b
        jsr _2c2d
        bne _2277
        ldx # $06
        ldy # $0d
        jsr _2c2d
        bne _2277
        lda # $c0
        jsr _87a6
        bcc _2277

        jsr wipe_sun
        jsr _7c24
_2277:                                                                  ;$2277
        jmp _231c

        ;-----------------------------------------------------------------------

_227a:                                                                  ;$227A
        lda IS_WITCHSPACE
        bne _2277

        lda ZP_A3               ; move counter?
        and # %00011111
_2283:                                                                  ;$2283
        cmp # $0a
        bne _22b5
        lda # $32
        cmp PLAYER_ENERGY
        bcc _2292
        asl 
        jsr _900d
_2292:                                                                  ;$2292
        ldy # $ff
        sty VAR_06F3
        iny 
        jsr _2c4e
        bne _231c
        jsr _2c5c
        bcs _231c
        sbc # $24
        bcc _22b2
        sta ZP_VAR_R
        jsr square_root
        lda ZP_VAR_Q
        sta VAR_06F3
        bne _231c
_22b2:                                                                  ;$22B2
        jmp _87d0

        ;-----------------------------------------------------------------------

_22b5:                                                                  ;$22B5
        cmp # $0f
        bne _22c2

        lda DOCKCOM_STATE
       .bze _231c

        lda # $7b
        bne _2319
_22c2:                                                                  ;$22C2
        cmp # $14
        bne _231c

        lda # $1e
        sta PLAYER_TEMP_CABIN

        lda VAR_045F
        bne _231c

        ldy # .sizeof(PolyObject)
        jsr _2c50
       .bnz _231c

        jsr _2c5c

        eor # %11111111
        adc # $1e
        sta PLAYER_TEMP_CABIN
        bcs _22b2
        cmp # $e0
        bcc _231c
        cmp # $f0
        bcc _2303

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn the I/O area on to manage the sprites
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        lda VIC_SPRITE_ENABLE
        and # %00000011
        sta VIC_SPRITE_ENABLE

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; halve the number of Trumbles™
        lsr PLAYER_TRUMBLES_HI  ; divide the top 8-bits by two, with carry out
        ror PLAYER_TRUMBLES_LO  ; divide bottom 8-bits by two, with carry in
.endif  ;///////////////////////////////////////////////////////////////////////

_2303:                                                                  ;$2303
        lda VAR_04C2
        beq _231c

        lda ZP_98
        lsr 
        adc PLAYER_FUEL
        cmp # $46
        bcc _2314
        lda # $46
_2314:                                                                  ;$2314
        sta PLAYER_FUEL

        lda # $a0
_2319:                                                                  ;$2319
        jsr _900d
_231c:                                                                  ;$231C
        lda VAR_0484
        beq _2330
        lda VAR_0487
        cmp # $08
        bcs _2330
        jsr _3cfa
        lda # $00
        sta VAR_0484
_2330:                                                                  ;$2330
        lda VAR_0481
        beq _233a

        jsr _7b64
        beq _2342
_233a:                                                                  ;$233A
        lda ZP_67
        beq _2345
        dec ZP_67
        bne _2345
_2342:                                                                  ;$2342
        jsr _a786
_2345:                                                                  ;$2345
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz _2366               ; (no? skip over)

        jmp _animate_dust

;===============================================================================

_234c:                                                                  ;$234C
        jsr get_random_number
        bpl _2366

        tya 
        tax 
        ldy # Hull::scoop_debris
        and [ZP_HULL_ADDR], y
        and # %00001111
_2359:                                                                  ;$2359
        sta ZP_AA
        beq _2366
_235d:                                                                  ;$235D
        lda # $00
        jsr _370a
        dec ZP_AA
        bne _235d
_2366:                                                                  ;$2366
        rts 

_2367:                                                                  ;$2367
;===============================================================================
        lda # %11000000
        sta interrupt_screenmode1

        lda # $00
        sta _a8e6

        rts 

;===============================================================================
; insert these docked token functions from "text_docked_fns.asm"
;
.tkn_docked_fns_theirName_protoGalaxy                                   ;$2372

_237e:                                                                  ;$237E
;===============================================================================
; print a message from the message table at `_1a5c`
; rather than the standard one (`_0e00`)
;-------------------------------------------------------------------------------
        ; push the current state:
        pha 
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; switch base-address of the message pool and jump into the print
        ; routine using this new address. note that in this case, X is the
        ; message-index to print
.import _1a5c
        
        lda # < _1a5c
        sta ZP_TEMP_ADDR3_LO
        lda # > _1a5c
        bne _23a0


print_docked_str:                                                       ;$2390
;===============================================================================
; prints one of the strings from "text_docked.asm"
;
; in:   A       index of string to print
;
; out:  A, Y    preserves A, Y & ZP_TEMP_ADDR3
;               (due to recursion)
;-------------------------------------------------------------------------------
.import _0e00

        pha                     ; preserve A (message index)
        tax                     ; move message index to X

        ; when recursing, [ZP_TEMP_ADDR3]+Y represent the
        ; current position in the message data
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; load the message table
        lda #< _0e00
        sta ZP_TEMP_ADDR3_LO
        lda #> _0e00
_23a0:                                                                  ;$23A0
        sta ZP_TEMP_ADDR3_HI
        ldy # $00

@skip_str:                                                              ;$23A4
        ;-----------------------------------------------------------------------
        ; skip over the messages until we find the one we want:
        ; -- this is insane!
        ;
.import TKN_DOCKED_XOR:direct

        lda [ZP_TEMP_ADDR3], y
        eor # TKN_DOCKED_XOR    ;=$57 -- descramble token
        bne :+                  ; keep going if not a message terminator ($00)
        dex                     ; message has ended, decrement index
        beq @read_token         ; if we've found our message, exit loop
:       iny                     ; move to next token                    ;$23AD
        bne @skip_str           ; if we haven't crossed the page, keep going
        inc ZP_TEMP_ADDR3_HI    ; move to the next page (256 bytes)
        bne @skip_str           ; and continue

@read_token:                                                            ;$23B4
        ;-----------------------------------------------------------------------
        iny                     ; step over the terminator byte ($00)
        bne :+                  ; did we step over the page boundary?
        inc ZP_TEMP_ADDR3_HI    ; if so, move forward to next page

:       ; read and descramble a token:                                  ;$23B9
        ;
        ; tokens: (descrambled)
        ;     $00 = invalid
        ; $01-$1F = format token, function varies
        ; $20-$40 = print ASCII chars $20-$40 (space, punctuation, numbers)
        ; $41-$5A = print ASCII characters @, A-Z
        ; $5B-$80 = planet description tokens
        ; $81-$D6 = text expansions
        ; $D7-$FF = some pre-defined character pairs ("text_pairs.asm")
        ;
        lda [ZP_TEMP_ADDR3], y  ; read a token
        eor # TKN_DOCKED_XOR    ;=$57 -- descramble token
        beq @rts                ; has message ended? (token $00)

        jsr print_docked_token
        jmp @read_token

@rts:   ; finished printing, clean up and exit                          ;$23C5
        ;-----------------------------------------------------------------------
        pla 
        sta ZP_TEMP_ADDR3_HI
        pla 
        sta ZP_TEMP_ADDR3_LO
       .ply 
        pla 

        rts 


print_docked_token:                                                     ;$23CF
;===============================================================================
        cmp # ' '               ; tokens less than $20 (space)
       .blt _format_code        ; are format codes

        bit txt_flight_flag     ; if flight string mode is off,
        bpl :+                  ; skip the next bit

        ; save state before we recurse
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 
        txa 

        ; print from the commonly shared 'flight' strings
        jsr print_flight_token

        jmp _2438

        ; print docked token:
        ;-----------------------------------------------------------------------
:       cmp # 'z'+1             ; letters "A" to "Z"?                   ;$23E8
       .blt print_docked_char   ; print letters, handling auto-casing

        cmp # $81               ; tokens $5B...$80?
       .blt _2441               ; handle planet description tokens

        cmp # $d7               ; tokens $81...$D6 are expansions,
       .blt print_docked_str    ; use the token as a message index

        ; tokens $D7 and above: (character pairs)
        ;-----------------------------------------------------------------------
.import tkn_docked_pair1
.import tkn_docked_pair2

        ; TODO: use a constant
        sbc # $d7               ; re-index as $00...$28
        asl                     ; double, for lookup-table
        pha                     ; (put aside)
        tax                     ; use as index to table
        lda tkn_docked_pair1, x ; read 1st character...
        jsr print_docked_char   ; ...and print it

        pla                     ; get the offset again
        tax                     ; use as index to table
        lda tkn_docked_pair2, x ; read 2nd character...
                                ; ...and print it (fallthrough)
        
print_docked_char:                                                      ;$2404
        ;-----------------------------------------------------------------------
        ; print the punctuation characters ($20...$40), as is
        ;
        cmp # '@'+1
       .blt @print

        ; shall we change the letter case?
        ;
        ; check for the upper-case flag: -- note that this will have no effect
        ; if the upper-case mask is not set or if the lower-case mask is set
        ; which takes precedence
        ;
        bit txt_ucase_flag      ; check if bit 7 is set
        bmi @ucase              ; if so, skip ahead

        ; check for the lower-case flag: -- this will only have an effect if
        ; the lower-case mask is set to remove bit 5
        ;
        bit txt_lcase_flag      ; check if bit 7 is set
        bmi @lcase              ; if so, skip ahead

@ucase: ora txt_ucase_mask      ; upper case (if enabled)               ;$2412

@lcase: and txt_lcase_mask      ; lower-case (if enabled)               ;$2415

@print: jmp print_char                                                  ;$2418


_format_code:                                                           ;$241B
        ;=======================================================================
        ; tokens $00..$1F are format codes, each has a different behaviour:
        ; see "txt_docked.asm" for details

        ; snapshot current state:
        ; -- these format codes can get recursive
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; multiply token by two
        ; (lookup into table)
        txa 
        asl 
        tax 

        ; note that the lookup table is indexed two-bytes early, making an
        ; index of zero land in some code -- this is why token $00 is invalid
        ;
        ; we read an address from the table and rewrite a `jsr` instruction
        ; further down, i.e. the token is a lookup to a routine to call
.import tkn_docked_functions

        lda tkn_docked_functions - 2, x
        sta @jsr + 1
        lda tkn_docked_functions - 1, x
        sta @jsr + 2

        ; convert the token back to its original value
        ; (to be used as a parameter for whatever we jump to)
        txa 
        lsr 

        ; NOTE: this address gets overwritten by the code above!!
@jsr:   jsr print_char                                                  ;$2435

_2438:  ; restore state and exit                                        ;$2438
        ;-----------------------------------------------------------------------
        pla 
        sta ZP_TEMP_ADDR3_HI
        pla 
        sta ZP_TEMP_ADDR3_LO
       .ply 
        rts 

_2441:  ; process msg tokens $5B..$80 (planet description tokens)       ;$2441
        ;-----------------------------------------------------------------------
        sta ZP_TEMP_ADDR1_LO    ; put token aside

        ; put aside our current location in the text data
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; choose planet description template 0-4:
        ;
        jsr get_random_number
        tax 
        lda # $00               ; select description template 0
        cpx # $33               ; is random number over $33?
        adc # $00               ; select description template 1
        cpx # $66               ; is random number over $66?
        adc # $00               ; select description template 2
        cpx # $99               ; is random number over $99?
        adc # $00               ; select description template 3
        cpx # $cc               ; is random number over $CC? note that if so,
                                ; carry is set, to be added later

        ; get back the token value and lookup another message index to print
        ; (since these tokens are $5B..$80, we index the table back $5B bytes)
        ;
.import _3eac
        
        ldx ZP_TEMP_ADDR1_LO
        adc _3eac - $5B, x      ; TODO: use a constant for $5B
        jsr print_docked_str    ; print the new message

        jmp _2438               ; clean up and exit

;===============================================================================
; insert these docked token functions from "text_docked_fns.asm"
;
.tkn_docked_fn01_02                                                     ;$246A
.tkn_docked_fn08                                                        ;$2478
.tkn_docked_clearScreen                                                 ;$2483
.tkn_docked_fn0D                                                        ;$248B
.tkn_docked_fn06_05                                                     ;$2496
.tkn_docked_fn0E_0F                                                     ;$24A3
.tkn_docked_fn11                                                        ;$24B0
.tkn_docked_fn12                                                        ;$24CE
.tkn_docked_capitalizeNext                                              ;$24ED

is_vowel:                                                               ;$24F3
;===============================================================================
        ora # %00100000         ; force upper-case for comparison
        cmp # $61               ; 'A'?
        beq :+
        cmp # $65               ; 'E'?
        beq :+
        cmp # $69               ; 'I'?
        beq :+
        cmp # $6f               ; 'O'?
        beq :+
        cmp # $75               ; 'U'?
        beq :+

        clc 
:       rts                                                             ;$250A

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
original_250b:                                                          ;$250B
;===============================================================================
        rts
;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================
; segments from "save_data.asm" goes here
;
; SAVE_DATA                                                             ;$25A6
; SAVE_DEFAULT                                                          ;$2600

;===============================================================================
; "LINE_DATA" segment goes here in the original game, see "draw_lines.inc"
;
;line_points_x:                                                         ;$26A4
;line_points_y:                                                         ;$27A4
