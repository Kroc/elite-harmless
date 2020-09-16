; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; NOTE: the segment that this code belongs to will be set by the including
;       file, e.g. "elite-original.asm" / "elite-harmless.asm"

; I think this is when the player has docked,
; it checks for potential mission offers
;
docked:                                                                 ;$1D81
;===============================================================================
        jsr _83df
        jsr _379e

        ; now the player is docked, some variables can be reset
        ; -- the cabin temperature is not reset; oversight / bug?
        lda # $00
        sta ZP_PLAYER_SPEED     ; bring player's ship to a full stop
        sta LASER_HEAT          ; complete laser cooldown
        sta ZP_66               ; reset hyperspace countdown

        ; set shields to maximum,
        ; restore energy:
        lda # $ff
        sta PLAYER_SHIELD_FRONT
        sta PLAYER_SHIELD_REAR
        sta PLAYER_ENERGY

        ldy # 44                ; wait 44 frames
        jsr wait_frames         ; -- why would this be necessary?

        ; check eligibility for the Constrictor mission:
        ;-----------------------------------------------------------------------
        ; available on the first galaxy after 256 or more kills. your job is
        ; to hunt down the prototype Constrictor ship starting at Reesdice
        ;
        ; is the mission already underway or complete?
        lda MISSION_FLAGS
        and # missions::constrictor
       .bnz :+                  ; mission is underway/complete, ignore it

        lda PLAYER_KILLS_HI
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
        lda PLAYER_KILLS_HI
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
        ; TODO: couldn't we use the planet index number
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
        ; TODO: couldn't we use the planet index number
        ;       instead of checking co-ordinates?

        lda PSYSTEM_POS_X
        cmp # 63
        bne @skip

        lda PSYSTEM_POS_Y
        cmp # 72
        bne @skip

        jmp mission_blueprints_birera

@skip:  ; check for Trumbles™ mission                                   ;$1E00
        ;
.ifdef  FEATURE_TRUMBLES
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
;===============================================================================
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
        ;-----------------------------------------------------------------------
        ; movement steps; "0, 1, -1, 0"
        .byte   $00, $01, $ff, $00

_1e25:                                                                  ;$1E25
        ;-----------------------------------------------------------------------
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
        lda MAIN_COUNTER
        and # %00000111         ; modulo 8 (0-7)
        cmp TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .blt :+

        jmp main_roll_pitch

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
        ;-----------------------------------------------------------------------
        lda _1e29, y
        and VIC_SPRITES_X
        sta VIC_SPRITES_X

        ; move the Trumble™ sprite vertically:
        lda VIC_SPRITE2_Y, y    ; current hardware sprite Y-position
        clc                     ; math!
        adc TRUMBLES_MOVE_Y, y  ; add the Trumble™'s Y direction
        sta VIC_SPRITE2_Y, y    ; update the hardware sprite

        ; move the Trumble™ sprite horizontally:
        clc 
        lda VIC_SPRITE2_X, y    ; current hardware sprite X-position (0-255)
        adc TRUMBLES_MOVE_X, y  ; add the Trumble™'s X direction
        sta ZP_VAR_T            ; put aside whilst we handle the MSB (256-319) 

        lda VAR_0531, y
        adc VAR_0521, y
        bpl :+

        lda # $48               ;=72 / %01001000
        sta ZP_VAR_T            ; '328'?

        lda # $01
:       and # %00000001                                                 ;$1E94
        beq :+

        lda ZP_VAR_T
        cmp # $50               ;=80 / %10000000
        lda # $01
        bcc :+

        lda # $00
        sta ZP_VAR_T

:       sta VAR_0531, y                                                 ;$1EA4
        beq :+

        ; MSBs?
        lda _1e29+1, y
        ora VIC_SPRITES_X       ; combine with current hardware sprite MSBs
        sei                     ; disable interrupts whilst repositioning
        sta VIC_SPRITES_X       ; update the 8 hardware sprite MSBs
:       lda ZP_VAR_T                                                    ;$1EB3
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

        jmp main_roll_pitch


_1ec1:                                                                  ;$1EC1
;===============================================================================
        ; seed the random-number-generator:
        lda polyobj_00          ; TODO: why this byte?
        sta ZP_GOATSOUP_pt1

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; are there any Trumbles™ on-screen?
        lda TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .bze :+                  ; =0; don't process Trumbles™

        ; process Trumbles™
        ; (move them about, breed them)
        jmp _1e35
:
.endif  ;///////////////////////////////////////////////////////////////////////

main_roll_pitch:                                                        ;$1ECE
        ;=======================================================================
        ; [1]:  compute roll & pitch
        ;-----------------------------------------------------------------------
        ; take the roll amount and prepare it for use in the 3D math:
        ;
        ldx JOY_ROLL            ; current roll amount (from joy/key input)
        jsr dampen_toward_zero  ; apply damping?
        jsr dampen_toward_zero  ; apply damping?
        txa                     ; transfer roll amount back to A

        ; elite actually rotates the universe around the player(!),
        ; therefore rolling to the right means rolling everything else
        ; to the left which is why we do some sign flipping here whilst
        ; preparing the angle. thanks goes to Mark Moxon's BBC disassembly
        ; for this insight

        ; get the absolute value and some additional values useful
        ; for the math, including an inverted copy of the sign
        ;
        eor # %10000000         ; flip the sign bit
        tay                     ; (put aside)
        and # %10000000         ; extract just the sign bit
        sta ZP_ROLL_SIGN        ; store as our "direction of roll"

        ; (write back the updated original roll value, after dampening;
        ;  this happens not to be related to the above few instructions)
        stx JOY_ROLL
        
        eor # %10000000         ; flip the sign bit
        sta ZP_INV_ROLL_SIGN    ; keep inverse roll direction

        tya                     ; retrieve our roll amount, with flipped sign
        bpl :+                  ; if positive, skip over

        ; roll amount is negative, make it positive (absolute)
        ; via a 2's complement (flip all bits and add 1)
        eor # %11111111
        clc 
        adc # $01

        ; we now have the absolute roll amount
        ;
:       lsr                     ; divide by 2,                           ;$1EEE
        lsr                     ; divide by 4
        cmp # $08               ;?
       .bge :+
        lsr 

:       sta ZP_ROLL_MAGNITUDE                                           ;$1EF5
        ora ZP_ROLL_SIGN        ; add sign
        sta ZP_ALPHA            ; put aside for use in the matrix math

        ; process pitch amount:
        ;-----------------------------------------------------------------------
        ldx JOY_PITCH           ; current pitch amount (from joy/key input)
        jsr dampen_toward_zero  ; apply damping (if enabled)
        txa                     ; transfer pitch amount back to A

        eor # %10000000         ; flip the sign-bit
        tay                     ; put aside for later
        and # %10000000         ; extract just the sign bit
        
        ; (write back the updated original pitch value, after dampening;
        ;  this happens not to be related to the above few instructions)
        stx JOY_PITCH
        
        sta ZP_INV_PITCH_SIGN
        eor # %10000000
        sta ZP_PITCH_SIGN       ; store as our "direction of pitch"
        tya 
        bpl :+
        eor # %11111111
:       adc # $04                                                       ;$1F15
        lsr 
        lsr 
        lsr 
        lsr 
        cmp # $03
        bcs :+
        lsr 

:       sta ZP_PITCH_MAGNITUDE                                          ;$1F20
        ora ZP_PITCH_SIGN
        sta ZP_BETA             ; put aside for the matrix math

        ; TODO: this section processes a number of key presses;
        ;       could we skip this when no keys are pressed by
        ;       marking a 'no keys' flag?
main_keys:
        ;=======================================================================
        ; [2]:  handle key presses
        ;-----------------------------------------------------------------------
        ; accelerate?
        ;-----------------------------------------------------------------------
        lda key_accelerate      ; is accelerate being held?
       .bze :+                  ; if not, continue

        lda ZP_PLAYER_SPEED     ; current speed
        cmp # 40                ; are we at maximum speed?
        bcs :+

        inc ZP_PLAYER_SPEED     ; increase player's speed

:       ; decelerate?                                                   ;$1F33
        ;-----------------------------------------------------------------------
        lda key_decelerate      ; is decelerate being held?
       .bze :+                  ; if not, continue

        dec ZP_PLAYER_SPEED     ; reduce player's speed
       .bnz :+                  ; still above zero?
        inc ZP_PLAYER_SPEED     ; if zero, set to 1

:       ; disarm missile?                                               ;$1F3E
        ;-----------------------------------------------------------------------
        lda key_missile_disarm  ; is disarm missile key being pressed?
        and PLAYER_MISSILES     ; does the player have any missiles?
       .bze :+                  ; no? skip ahead

        ; untarget missile and change colour of the missile-block on the HUD
        ldy # .color_nybble( GREEN, HUD_COLOUR )
        jsr untarget_missile

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $06
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $00               ; set loaded missile as disarmed ($00)
        sta PLAYER_MISSILE_ARMED

        ; target missile?
        ;-----------------------------------------------------------------------
:       lda ZP_MISSILE_TARGET   ; is there a missile target?            ;$1F55
        bpl :+                  ; if yes, skip, cannot re-target

        lda key_missile_target  ; target missile key pressed?
       .bze :+                  ; no, continue...

        ldx PLAYER_MISSILES     ; does the player have any missiles?
       .bze :+                  ; if missiles are zero, skip

        ; set missile armed flag
        ; (A = $FF from `key_missile_target`)
        sta PLAYER_MISSILE_ARMED
        ; update the colour of the HUD missile indicator. note that X is
        ; the missile number which chooses which missile block to colour
        ldy # .color_nybble( ORANGE, HUD_COLOUR )
        jsr update_missile_indicator

        ; fire missile?
        ;-----------------------------------------------------------------------
:       lda key_missile_fire    ; fire missile key held?                ;$1F6B
       .bze :+                  ; no, skip ahead

        lda ZP_MISSILE_TARGET   ; check the missile target...
        ; if no target, skip ahead. this skips over most of the
        ; remaining key-press checks and is likely an oversight
        bmi :++++++             ;(=$1FC2)
        
        jsr fire_missile

        ; energy bomb?
        ;-----------------------------------------------------------------------
:       lda key_bomb            ; energy bomb key held?                 ;$1F77
       .bze :+                  ; no, skip ahead

        ; enable the energy bomb; if present, it's value should be $FF,
        ; so shifting left makes it %11111110. if the player does not
        ; have a bomb (=$00), the value will remain zero
        ;
        asl PLAYER_EBOMB        ; activate the bomb
        beq :+                  ; did that work? skip if no bomb present

        ; create a 'screen glitch' effect by changing the hi-res portion
        ; of the screen to multi-colour when the bomb goes off(?)
        ldy # vic_screen_ctl2::unused | vic_screen_ctl2::multicolor
        sty interrupt_screenmode1

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $0d               ; e-bomb sound?
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

        ; turn docking computer off?
        ;-----------------------------------------------------------------------
:       lda key_docking_off     ; docking-computer off pressed?         ;$1F8B
       .bze :+                  ; no? skip ahead

        lda # $00               ; $00 = OFF
        sta DOCKCOM_STATE       ; turn docking computer off

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr stop_sound          ; stop all sound playing
.endif  ;///////////////////////////////////////////////////////////////////////

        ; activate escape pod?
        ;-----------------------------------------------------------------------
:       lda key_escape_pod      ; escape pod key pressed?               ;$1F98
        and PLAYER_ESCAPEPOD    ; does the player have an escape pod?
       .bze :+                  ; no? keep moving

        lda IS_WITCHSPACE       ; is the player stuck in witchspace?
       .bnz :+                  ; yes? cannot eject in witchspace!
                                ; TODO: play sound / display warning?

        jmp eject_escapepod     ; eject the escpae pod!

        ; quick-jump?
        ;-----------------------------------------------------------------------
:       lda key_jump            ; quick-jump key pressed?               ;$1FA8
       .bze :+                  ; no? skip ahead

        jsr do_quickjump        ; handle the quick-jump

        ; activate E.C.M.?
        ;-----------------------------------------------------------------------
:       lda key_ecm             ; E.C.M. key pressed?                   ;$1FB0
        and PLAYER_ECM          ; does the player have an E.C.M.?
       .bze :+                  ; no? skip ahead

        lda ECM_COUNTER         ; is any ECM already active? (ours or enemy's!)
       .bnz :+                  ; yes? skip

        dec ECM_STATE           ; underflow our ECM state from $00 to $FF
        jsr engage_ecm          ; handle ECM effects...

        ; turn docking computer on?
        ;-----------------------------------------------------------------------
:       lda key_docking_on      ; key for docking computer pressed?     ;$1FC2
        and PLAYER_DOCKCOM      ; does the player have a docking computer?
       .bze :+                  ; no, skip

        ; the X (down) & C (docking-computer) keys are next to each other --
        ; don't accidentally enable the docking computer when pushing down!
        ; (with thanks to Mark Moxon for this insight)
        ;
        ; TODO: how should this be handled if key layout is changed?
        ;
        eor joy_down            ; if down is pressed, flip the bits
       .bze :+                  ; ignore mis-press

        sta DOCKCOM_STATE       ; turn docking computer on (A = $FF)

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr _9204               ; play docking computer music
.endif  ;///////////////////////////////////////////////////////////////////////
:

main_lasers:                                                            ;$1FD5
        ;=======================================================================
        ; [3]:  shoot lasers!
        ;-----------------------------------------------------------------------
        lda # $00                                                       
        sta ZP_LASER            ; clear laser-power for current view
        sta ZP_SPEED_LO

        ; multiply player speed by 64:
        ; this could be done with 6 left-shifts,
        ;
        ;       %--------00111111       =$3F
        ;                  //////       x2
        ;                 //////        x4
        ;                //////         x8
        ;               //////          x16
        ;              //////           x32
        ;             //////            x64
        ;       %0000111111000000       =$0FC0
        ;
        ; but we can do this quicker by moving the lo-byte to the hi-byte
        ; (equivalent to multiplying by 256) and shifting right twice,
        ; reducing the multiplication to 64
        ;       
        ;       %--------00111111       =$3F
        ;               <--             *256
        ;       %0011111100000000       =$3F00
        ;          \\\\\\               /2
        ;           \\\\\\              /4
        ;       %0000111111000000       =$0FC0
        ;
        ; TODO: should this be cached and only re-calced on speed change?
        ;
        lda ZP_PLAYER_SPEED     ; current player speed
                                ; (this will be the high-byte)
        lsr                     ; right-shift once
        ror ZP_SPEED_LO         ; ripple down to the result, lo-byte
        lsr                     ; right shift again again
        ror ZP_SPEED_LO         ; ripple down to the result, lo-byte
        sta ZP_SPEED_HI         ; store result hi-byte

        ; if the laser is a pulse laser, it can't be shot continuously.
        ; this counter spaces out the shots and is updated every vsync
        ;
        lda LASER_COUNTER       ; is the laser between pulses?
        bne @ships              ; skip ahead if laser is between pulses

        lda joy_fire            ; is fire-key pressed?
        beq @ships              ; no? skip ahead

        lda LASER_HEAT          ; check current laser heat
        cmp # $f2               ; laser temp >= 242?
        bcs @ships              ; don't fire if too hot

        ; is there a laser mounted on this direction?
        ; TODO: shouldn't we check for this first??
        ;
        ldx COCKPIT_VIEW        ; current facing direction
        lda PLAYER_LASERS, x    ; get type of laser mounted here
        beq @ships              ; if zero, no laser, skip ahead

        pha                     ; put aside laser type
        and # laser::power      ; extract just the laser power-level
        sta ZP_LASER            ; update laser-power for current view
        sta LASER_POWER         ; update laser-power for current laser

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ; play laser sound (based on laser-type):
        ;
        ldy # $00               ; (no sound?)
        pla                     ; retrieve laser power
        pha                     ; 
        bmi :++                 ; beam laser
        cmp # $32
        bne :+                  ; (BNE to another BNE! should be `bne @201d`)
        ldy # $0c               ; lase sound #3?
:       bne @201d                                                       ;$2012
:       cmp # laser::beam | $17                                         ;$2014
        beq @201b

        ldy # $0a               ; laser sound #1?
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit
@201b:  ldy # $0b               ; laser sound #2?                       ;$201B
@201d:  jsr play_sfx                                                    ;$201D
.endif  ;///////////////////////////////////////////////////////////////////////

        jsr shoot_lasers        ; pew-pew!
        
        pla                     ; retrieve laser type
        bpl :+                  ; (skip over if not beam laser)
        lda # $00               ; zero pulse-wait for beam-laser
:       and # %11111010         ; set pulse-wait based on power-level   ;$2028
        sta LASER_COUNTER

        ;=======================================================================
        ; [4]:  process ship instances
        ;-----------------------------------------------------------------------
@ships: ldx # $00               ; begin with ship-slot 0                ;$202D


process_ship:                                                           ;$202F
        ;-----------------------------------------------------------------------
        stx ZP_PRESERVE_X       ; set aside ship slot for later
        lda SHIP_SLOTS, x       ; is that a ship in your slot?
        bne :+                  ; if so, process it
        jmp _21fa               ; no more ships to process,
                                ; you're just happy to see me

:       sta ZP_SHIP_TYPE        ; put ship type aside                   ;$2039
        jsr get_polyobj_addr    ; look up the ship's instance data

        ; copy the given PolyObject to
        ; the working space in zero page:
        ;
        ; see "vars_polyobj.asm" for the code in this macro as different
        ; approaches are taken for optimisation depending on the build
        ;
        ; TODO: given the ~1'100 cycles to copy the object back and forth,
        ;       would it be faster to stick to indexing the object instead?
        ;       i.e. `... [polyobj], x`
        ;
        .polybj_to_zp

        ; TODO: if we use LDX instead, we can preserve the ship-type through
        ;       this logic and do away with a number of additional LDA's?
        ;
        lda ZP_SHIP_TYPE        ; get ship type back
        bmi @move               ; if sun / planet, skip over

        ; lookup the ship's hull data:
        ;
        asl                     ; multiply ship type by 2,
        tay                     ; for use as a table lookup
        lda hull_pointers-2, y  ; look up the hull data, lo-byte
        sta ZP_HULL_ADDR_LO
        lda hull_pointers-1, y  ; look up the hull data, hi-byte
        sta ZP_HULL_ADDR_HI

        ;=======================================================================
        ; [5]:  handle e-bomb explosion
        ;-----------------------------------------------------------------------
        ; is the e-bomb active? (bit 7 set)
        ;
        lda PLAYER_EBOMB        ; check e-bomb state
        bpl @move               ; inactive, skip over

        ; space station? -- cannot be destroyed by e-bomb
        cpy # HULL_COREOLIS *2
        beq @move

        ; thargoid? -- also cannot be e-bombed
        cpy # HULL_THARGOID *2
        beq @move

        ; constrictor, cougar & dodo-station? -- also cannot be e-bombed
        ; WARN: this assumes any ID of constrictor or above are valid!
        cpy # HULL_CONSTRICTOR *2
        bcs @move

        ; make ship disappear?
        ;
        lda ZP_POLYOBJ_STATE    ; get the ship's state
        and # state::debris     ; check for exploding (is debris)
       .bnz @move               ; skip if already exploding

        ; set bit 7 to indicate the ship is exploding
        ; (this assumes bit 7 is the exploding bit)
        ;
.if     (state::exploding <> %10000000)
        .fatal  "`process_ship` assumes that `state::exploding` is bit 7"
.endif
        asl ZP_POLYOBJ_STATE    ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_POLYOBJ_STATE    ; ...shift the carry into bit 7

        ldx ZP_SHIP_TYPE        ; retrieve ship-type again
        jsr ship_killed         ; add points to kill rank

        ;=======================================================================
        ; [6]:  move ship forward
        ;-----------------------------------------------------------------------
@move:  jsr move_ship                                                   ;$2079

        ; copy the zero-page PolyObject back to its storage
        ;
        .zp_to_polyobj

        ;=======================================================================
        ; [7]:  collision checks
        ;-----------------------------------------------------------------------
        ; is the ship exploding?
        ;
        lda ZP_POLYOBJ_STATE
        and # state::exploding | state::debris

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _87b1               ; combine check with distance
.else   ;///////////////////////////////////////////////////////////////////////
        ora ZP_POLYOBJ_XPOS_HI  ; there's really no need for a JSR for this
        ora ZP_POLYOBJ_YPOS_HI
        ora ZP_POLYOBJ_ZPOS_HI
.endif  ;///////////////////////////////////////////////////////////////////////

        ; if the ship is exploding / exploded or far away then skip
       .bnz @20e0               

        ; check the near distance
        lda ZP_POLYOBJ_XPOS_LO
        ora ZP_POLYOBJ_YPOS_LO
        ora ZP_POLYOBJ_ZPOS_LO
        ; if the high-bit is set on the lo-byte of any axis (>=128)
        ; then the ship is still far enough away, skip ahead
        bmi @20e0

        ; collision!
        ;-----------------------------------------------------------------------
        ldx ZP_SHIP_TYPE        ; sun or planet?
        bmi @20e0               ; yes, deal with crashing into planet/star!

        cpx # HULL_COREOLIS     ; space station?
        beq @dock               ; yes, handle space-station behaviour

        and # %11000000         ; is distance within 64?
        bne @20e0

        cpx # HULL_MISSILE      ; is it a missile?
        beq @20e0               ; yes, skip

        ;=======================================================================
        ; [8]:  scooping
        ;-----------------------------------------------------------------------
        ; can we scoop this object?
        ;
        ; get fuel scoop status ($00 = none, $80 = present)
        lda PLAYER_SCOOP
        ; is the object below the player? i.e. if its Y-position is negative.
        ; we've already established that it's near enough to us
        and ZP_POLYOBJ_YPOS_SIGN
        bpl big_damage          ; if not scoopable, skip

        ; attempt to scoop object
        ;
        cpx # HULL_CANNISTER    ; is this a cargo cannister?
        beq @can                ; yes, pick it up

        ; read scoop data from the hull
        ;
        ldy # Hull::scoop_debris
        lda [ZP_HULL_ADDR], y
        lsr                     ; down shift the top-nybble
        lsr                     ; into the bottom nybble
        lsr                     ; (cargo-data is held in the top-nybble,
        lsr                     ;  debris-data in the low-nybble)
       .bze big_damage          ; if zero, cannot be scooped?
        
        ; the scoop-data in a hull definition provides which cargo type it
        ; gives when scooped, already decremented by 1 to account for the
        ; below non-zero check. a side-effect of this is that it's not
        ; possible for a hull definition to drop food or textiles(?)
        ;
        adc # $01               ; add 1 to cargo type
       .bnz @add                ; (always branches)

        ; scooped cargo:
        ;-----------------------------------------------------------------------
        ; the scooped item was a cargo cannister,
        ; give the player some random loot!
        ;
@can:   jsr get_random_number   ; choose a random type of cargo         ;$20C0
        and # %00000111         ; limit to 0-7

        ; test to see if you can hold 1 more of the given item
        ; carry clear = yes, carry set = no. note that this returns A=1
@add:   jsr check_cargo_capacity_add1                                   ;$20C5

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this has no effect due to the LDY after; it was probably
        ; the original offset for the cargo name strings
        ldy # $4e
.endif  ;///////////////////////////////////////////////////////////////////////
        bcs explode_obj         ; cargo full, explode the cannister!

        ldy CARGO_ITEM          ; retrieve type of cargo
        adc PLAYER_CARGO, y     ; add 1 to current cargo count
        sta PLAYER_CARGO, y     ; update your cargo holdings
        tya

        ; print the name of the cargo 
.import TKN_FLIGHT_CARGO_TYPES:direct
        adc # TKN_FLIGHT_CARGO_TYPES
        jsr _900d               ; print a message on-screen

        ; mark cannister for removal:
        ; (set bit 7)
        asl ZP_POLYOBJ_BEHAVIOUR
        sec 
        ror ZP_POLYOBJ_BEHAVIOUR

        ; (remove ship?)
@20e0:  jmp _2131                                                       ;$20E0

        ;=======================================================================
        ; [9]:  docking
        ;-----------------------------------------------------------------------
        ; is the station hostile? poly-object slot 1 is always reserved for
        ; the sun or space-station, so we can refer to its bytes directly
        ;
@dock:  lda polyobj_01 + PolyObject::behaviour                          ;$20E3
        and # behaviour::angry  ; check the angry flag
       .bnz dock_fail           ; cannot dock!

        ; check the rotation of the station:
        ;
        lda ZP_POLYOBJ_M0x2_HI
        cmp # 214
        bcc dock_fail

        ; check angle of approach:
        ;
        jsr _8c7b               ; get vector to station
        lda ZP_VAR_X2           
        cmp # 89
        bcc dock_fail

        ; check rotation of slot:
        ;
        lda ZP_POLYOBJ_M1x0_HI
        and # %01111111         ; (remove sign)
        cmp # 80
        bcc dock_fail

dock_ok:                                                                ;$2101
        ;-----------------------------------------------------------------------
        ; docking successful!
        ; NOTE: escape capsule jumps here to return you to the station
        ;
        jsr stop_sound          ; stop all sound playing
        jmp docked              ; handle docked screen
        
dock_fail:                                                              ;$2107
        ;-----------------------------------------------------------------------
        ; docking fail!
        ;
        lda ZP_PLAYER_SPEED     ; check approach speed
        cmp # $05               ; going slow?
        bcc small_damage        ; slow; take damage
        jmp _87d0               ; fast; explode

explode_obj:                                                            ;$2110
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set 'exploding' state (bit 7)
        ;
        ; TODO: can this be more efficiently combined with the below copy?
        asl ZP_POLYOBJ_STATE    ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_POLYOBJ_STATE    ; ...shift the carry into bit 7
        bne _2131               ; (always brunches)

small_damage:                                                           ;$211A
        ;-----------------------------------------------------------------------
        ; player takes damage from colliding with object
        ; (either a cannister that cannot be scooped, or the mailslot)
        ;
        lda # 1                 ; slow down
        sta ZP_PLAYER_SPEED
        lda # 5                 ; take '5' damage
        bne apply_damage        ; (always branches)

big_damage:                                                             ;$2122
        ;-----------------------------------------------------------------------
        ; set 'exploding' state (bit 7)
        ;
        ; TODO: can this be more efficiently combined with the above copy?
        asl ZP_POLYOBJ_STATE    ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_POLYOBJ_STATE    ; ...shift the carry into bit 7
        
        ; take damage proportional to the energy level of the ship you collided
        ; with; the ship's energy level is divided by 2 and 128 is added
        ;
        lda ZP_POLYOBJ_ENERGY   ; ship's energy level...
        sec                     ; we'll introduce a high-bit (128)   
        ror                     ; divide by 2 and insert the high-bit (+128)

apply_damage:                                                           ;$212B
        ;-----------------------------------------------------------------------
        ; apply the amount of damage in A to the player, depleting the shields.
        ; if they're gone, take damage directly which may cause loss of cargo
        ;
        jsr damage_player

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03
.endif  ;///////////////////////////////////////////////////////////////////////

        ; should the ship be removed?
        ;
_2131:  lda ZP_POLYOBJ_BEHAVIOUR                                        ;$2131
        bpl :+                  ; is bit 7 set? if no, skip over
        jsr _b410               ; remove from scanner dispay (?)

        ;=======================================================================
        ; [10]: missile & laser hit testing
        ;-----------------------------------------------------------------------
:       lda ZP_SCREEN           ; are we in the cockpit-view?           ;$2138
       .bnz @_21ab              ; no? skip ahead

        ; since the universe rotates around the player in elite, we need to
        ; make sure that the X/Y/Z axes in the ship instance match the current
        ; view into space, i.e. when looking left or right the X & Z axes are
        ; flipped. this is so that code below does not have to differentiate
        ; between view directions
        ;
        jsr _a626               ; BBC: PLUT

        ; check if the current ship instance is within the player's sights
        ;
        jsr _363f               ; BBC: HITCH
        bcc @draw               ; not in sights, skip over

        ; ship is in player's sights:
        ;-----------------------------------------------------------------------
        ; if a player's missile is armed, the ship can be targetted
        ;
        lda PLAYER_MISSILE_ARMED; is the player's missile armed?
       .bze :+                  ; if not, skip over

        ; missile is armed and target is locked:
        ;
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_05         ; beep?
.endif  ;///////////////////////////////////////////////////////////////////////
        ; retrieve the current ship's slot-number, which
        ; was set aside way, way back up at `process_ship`
        ldx ZP_PRESERVE_X
        ; set the player's target ship instance, and change
        ; the missile indicator on the HUD to show locked state
        ldy # .color_nybble( RED, HUD_COLOUR )
        jsr target_missile

        ; are we firing our laser?
        ;-----------------------------------------------------------------------
        ; `ZP_LASER` is only set if our laser is actually firing
        ;
:       lda ZP_LASER            ; is there a laser on the current view? ;$2153
       .bze @draw               ; no laser, skip onwards

        ; ship is in player's sights, lasers are firing;
        ; make the sound of laser striking metal
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldx # $0f               ; (this gets lost by the routine below)
        jsr sound_play_laserstrike
.endif  ;///////////////////////////////////////////////////////////////////////

        lda ZP_SHIP_TYPE        ; things we've shot with our laser:
        cmp # HULL_COREOLIS     ; the station!?
        beq @hostile            ; shot the station, uh oh...
        cmp # HULL_CONSTRICTOR  ; constrictor & cougar (and above)?
        bcc @hit                ; no, skip over

        ; the Constrictor and Cougar cannot be damaged
        ; with anything less than military lasers:
        ;
        lda ZP_LASER            ; player's laser power
        cmp # 23                ; TODO: confirm and const this!
        bne @hostile            ; hit!

        ; divide laser power by 4, making it highly ineffective
        ; against the Constrictor or Cougar
        ;
        ; TODO: does this not account for bit 7 (beam)?
        lsr ZP_LASER
        lsr ZP_LASER

        ; laser has hit ship!
        ;-----------------------------------------------------------------------
        ; calculate if your laser fire has destroyed the ship:
        ;
@hit:   lda ZP_POLYOBJ_ENERGY   ; ship's energy-level                   ;$2170
        sec 
        sbc ZP_LASER            ; subtract player's laser power
        bcs @_21a1              ; if energy remains, skip ahead

        ; explode the ship:
        ;-----------------------------------------------------------------------
        asl ZP_POLYOBJ_STATE    ; remove bit 7
        sec                     ; take a 1 from the bit bucket
        ror ZP_POLYOBJ_STATE    ; shift it into bit 7

        lda ZP_SHIP_TYPE        ; retrieve which type of ship this is
        cmp # HULL_ASTEROID     ; an asteroid?
        bne @debris             ; skip for non-asteroids

        ; explode an asteroid:
        ;-----------------------------------------------------------------------
        ; is the player using a mining laser?
        ; (other lasers have no effect)
        ;
        lda ZP_LASER            ; check laser power for current view
        cmp # $32               ; is it yey much?
        bne @debris             ; not a mining laser?

        ; spawn some rock splinters when exploding
        ; an asteroid shot with a mining laser:
        jsr get_random_number   ; pick a number, any number
        ldx # HULL_SPLINTER     ; we'll be spawning a rock splinter
        and # %00000011         ; limit to 0-3 pieces
        jsr spawn_multiple      ; go spawn the pieces

        ; drop loot:
        ;-----------------------------------------------------------------------
        ; each hull definition has a nybble (0-15) for how many items of debris
        ; it should drop, although randomisation is used to vary how much
        ; actually gets dropped
@debris:                                                                ;$2192
        ldy # HULL_PLATE        ; let's try drop some plates
        jsr spawn_debris        ; spawn a random amount according to hull
        ldy # HULL_CANNISTER    ; let's try drop some cargo cannisters
        jsr spawn_debris        ; spawn a random amount according to hull

        ldx ZP_SHIP_TYPE        ; retrieve ship-type again
        jsr ship_killed         ; add points to the player's kill-rank
                                ; TODO: returns A = 0, no?
@_21a1:                                                                 ;$21A1
        sta ZP_POLYOBJ_ENERGY   ; update the ships energy level

@hostile:                                                               ;$21A3
        lda ZP_SHIP_TYPE
        jsr _36c5               ; make hostile?

        ; *** DRAW THE SHIP ON THE SCREEN ***
        ; (I felt this needed drawing attention to as it's easy to miss)
@draw:  jsr draw_ship                                                   ;$21A8

@_21ab:                                                                 ;$21AB
        ; update the zero-page copy of the ship's energy level
        ; back to the ship's instance storage
        ;
        ; TODO: why do we do this, when we could defer copying the whole
        ;       ship instance to later in the main loop??
        ldy # PolyObject::energy
        lda ZP_POLYOBJ_ENERGY
        sta [ZP_POLYOBJ_ADDR], y

        ; when will you learn that your actions have consequences?
        ;-----------------------------------------------------------------------
        ; check the high-bit of the behaviour flags,
        ; this indicates if the ship needs to be removed from play
        lda ZP_POLYOBJ_BEHAVIOUR
        bmi @clear              ; bit 7 set?

        ; is the ship currently exploding?
        lda ZP_POLYOBJ_STATE
        bpl @_21e5              ; bit 7 not set?

        and # state::debris
        beq @_21e5

        ; did we blow up a police ship?
        ; the behaviour bit for police (%01000000 = 64) is used as the
        ; felony-level to set, making the player immediately "Fugitive"
        ;
        lda ZP_POLYOBJ_BEHAVIOUR
        and # behaviour::police ; keep just bit 6
        ora PLAYER_LEGAL        ; add this to the felony-level (if set)
        sta PLAYER_LEGAL        ; update player's felony level

        ; check if we're able to display an on-screen message:
        ;
        ; BUG:  if any on-screen message is displayed when you destroy
        ;       another ship, you *won't* get paid the bounty!
        ;
        ; TODO: fix this bug for harmless
        ;
        lda OSD_DELAY           ; is a message already on screen? (>0)
        ora IS_WITCHSPACE       ; are we in witchspace? (why?)
       .bnz @clear              ; can't display, skip

        ; pay bounty:
        ;-----------------------------------------------------------------------
        ; NOTE: since a zero in the low-byte of the bounty amount is assumed
        ;       to be "no bounty", care must be taken to not give a ship a
        ;       round hexadecimal bounty, i.e. $??00
        ;
        ldy # Hull::bounty      ; (bounty lo-byte)
        lda [ZP_HULL_ADDR], y   ; read from the hull structure
       .bze @clear              ; skip if no bountry (=0)

        tax                     ; put aside the lo-byte
        iny                     ; (bounty hi-byte)
        lda [ZP_HULL_ADDR], y   ; read the bounty hi-byte
        tay                     ; put aside hi-byte
        jsr _7481               ; pay monies

        ; TODO: GitHub issue #50:
        ;       Display credits earnerd after kill, not total credits
        ;
        ; (flight token for printing player's current cash)
        lda # TKN_FLIGHT_FN_PLAYER_CASH
        jsr _900d               ; print an in-flight message

        ; clear the ship-slot and shuffle down the rest:
        ; elite relies upon there not being free gaps between ship-instances
        ; for detecting when the last ship-instance is reached
        ;
        ; TODO: since skipping over unused slots is plenty fast enough,
        ;       maybe we could do away with this requirement
        ;
@clear: jmp _829a                                                       ;$21E2

@_21e5:                                                                 ;$21E5
        ;-----------------------------------------------------------------------
        lda ZP_SHIP_TYPE
        bmi :+
        jsr _87a4
        bcc @clear

        ; update the poly-object's stored state
        ; with the current working state
:       ldy # PolyObject::state                                         ;$21EE
        lda ZP_POLYOBJ_STATE
        sta [ZP_POLYOBJ_ADDR], y

        ldx ZP_PRESERVE_X       ; retrieve current ship-slot being processed...
        inx                     ; move to the next ship-slot
        jmp process_ship        ; process the next ship


        ;-----------------------------------------------------------------------

_21fa:                                                                  ;$21FA
        lda PLAYER_EBOMB        ; player has energy bomb?
        bpl _2207
        asl PLAYER_EBOMB
        bmi _2207
        jsr _2367
_2207:                                                                  ;$2207
        lda MAIN_COUNTER
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
        lda PLAYER_EUNIT
        adc PLAYER_ENERGY
        bcs _2230
        sta PLAYER_ENERGY
_2230:                                                                  ;$2230
        lda IS_WITCHSPACE
        bne _2277

        lda MAIN_COUNTER
        and # %00011111
        bne _2283

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_COREOLIS )
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
        ; $24:          speed           .byte
        ; $25:          acceleration    .byte
        ;
        ; number of bytes to copy:
        ; (up to, and including, the `acceleration` property)
        ldx # PolyObject::acceleration + .sizeof( PolyObject::acceleration )-1

:       lda polyobj_00, x       ;=$F900                                 ;$2248
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

        lda MAIN_COUNTER
        and # %00011111
_2283:                                                                  ;$2283
        cmp # $0a
        bne _22b5
        lda # $32
        cmp PLAYER_ENERGY
        bcc _2292
        asl                     ; !! print "energy low"? (msg 100 / $64)
        jsr _900d               ; print an on-screen message
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

_22b5:                                                                  ;$22B5
        ;-----------------------------------------------------------------------
        cmp # $0f
        bne _22c2

        lda DOCKCOM_STATE
       .bze _231c

        lda # $7b
        bne _2319               ; (always branches)

_22c2:                                                                  ;$22C2
        ;-----------------------------------------------------------------------
        cmp # $14
        bne _231c

        lda # $1e
        sta CABIN_HEAT

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_COREOLIS )
        bne _231c

        ldy # .sizeof( PolyObject )
        jsr _2c50
       .bnz _231c

        jsr _2c5c

        eor # %11111111
        adc # $1e
        sta CABIN_HEAT
        bcs _22b2

        cmp # $e0               ; high temperature?
        bcc _231c
        cmp # $f0               ; critical temperature?
        bcc _2303

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
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

        ; kill the Trumbles™ from over-heating?
        ; remove their sprites on screen
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

        ; halve the number of Trumbles™
        lsr PLAYER_TRUMBLES_HI  ; divide the top 8-bits by two, with carry out
        ror PLAYER_TRUMBLES_LO  ; divide bottom 8-bits by two, with carry in
.endif  ;///////////////////////////////////////////////////////////////////////

_2303:                                                                  ;$2303
        lda PLAYER_SCOOP        ; does the player have a fuel-scoop?
       .bze _231c               ; skip over if not

        lda ZP_SPEED_HI
        lsr 
        adc PLAYER_FUEL
        cmp # $46
        bcc :+
        lda # $46
:       sta PLAYER_FUEL                                                 ;$2314

        lda # $a0               ; "FUEL SCOOPS ON"?
_2319:                                                                  ;$2319
        jsr _900d               ; print an on-screen message
_231c:                                                                  ;$231C
        lda LASER_POWER
        beq _2330

        lda LASER_COUNTER
        cmp # $08
        bcs _2330
        
        jsr _3cfa
        
        lda # $00
        sta LASER_POWER
_2330:                                                                  ;$2330
        lda ECM_STATE           ; is our ECM enabled?
        beq _233a

        jsr _7b64
        beq _2342
_233a:                                                                  ;$233A
        lda ECM_COUNTER         ; is an ECM already active?
        beq _2345
        dec ECM_COUNTER
        bne _2345
_2342:                                                                  ;$2342
        jsr _a786
_2345:                                                                  ;$2345
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz rts_2366            ; (no? exit)

        jmp move_dust


spawn_debris:                                                           ;$234C
;===============================================================================
; when a ship is destroyed, attempt to spawn debris according
; to the debris info in the ship's hull structure
;
; in:   Y               ship-type
;       ZP_HULL_ADDR    must be loaded with a pointer to a hull structure
;-------------------------------------------------------------------------------
        ; randomise the chance of dropping loot:
        ; note that this returns A & X, which is why
        ; the ship-type must be in Y
        ;
        jsr get_random_number   ; choose random number,
        bpl rts_2366            ; 50/50 do nothing

        ; look up the debris information in the hull data
        ;
        tya                     ; ship type to A,
        tax                     ; and then to X
        
        ; use Y for the byte-index in the structure. this byte contains
        ; scoop information in the upper nybble and debris information
        ; in the lower-nybble
        ;
        ldy # Hull::scoop_debris
        and [ZP_HULL_ADDR], y   ; combine debris count with random number
        and # %00001111         ; clip out the scoop info


spawn_multiple:                                                         ;$2359
;===============================================================================
; spawn multiple of one type of ship:
;
; in:   A       number of items to spawn
;       X       ship-type to spawn, e.g. cargo cannister
;-------------------------------------------------------------------------------
        sta TEMP_COUNTER
        beq rts_2366            ; zero-flag will not be set by STA!

:       lda # $00                                                       ;$235D
        jsr _370a               ; NOTE: spawns ship-type in X
        
        dec TEMP_COUNTER
        bne :-

rts_2366:                                                               ;$2366
        rts


_2367:                                                                  ;$2367
;===============================================================================
        lda # %11000000
        sta interrupt_screenmode1

        lda # $00
        sta _a8e6

        rts 
