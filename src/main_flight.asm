; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; main loop for flight control. if the player is in flight, this handles
; everything related to the flight simulation such as controls, moving ships
; and handling equipment
;
.segment        "MAIN_FLIGHT"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

.ifdef  FEATURE_TRUMBLES
;///////////////////////////////////////////////////////////////////////////////
; the Trumbles™ added in the C64 port are simply 'patched in' to the main
; flight loop rather than being inlined, therefore the Trumble™ code appears
; first and the main flight loop JMPs backwards to handle the Trumbles™ first
;
trumble_steps:                                                          ;$1E21
        ;-----------------------------------------------------------------------
        ; movement steps; "0, 1, -1, 0"
        .byte   $00, $01, $ff, $00

_1e25:                                                                  ;$1E25
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $ff, $00

trumble_masks:                                                          ;$1E29
        ;-----------------------------------------------------------------------
        ; these are pairs of bit-masks for the hardware sprites (2-7)
        ; for each of the Trumbles™ (0-5)
        ;
        .byte   %11111011, %00000100    ; Trumble™ #0, sprite 2
        .byte   %11110111, %00001000    ; Trumble™ #1, sprite 3
        .byte   %11101111, %00010000    ; Trumble™ #2, sprite 4
        .byte   %11011111, %00100000    ; Trumble™ #3, sprite 5
        .byte   %10111111, %01000000    ; Trumble™ #4, sprite 6
        .byte   %01111111, %10000000    ; Trumble™ #5, sprite 7


move_trumbles:                                                          ;$1E35
;===============================================================================
; [0]:  move Trumbles™ around the screen:
;-------------------------------------------------------------------------------
        ; we will only move one Trumble™ per frame:
        ;
        ; due to the use of two sprites already, one for the laser sights
        ; and one for the shared explosion sprite, there can only be a
        ; maximum of 6 Trumble™ sprites on-screen. out of 8 frames, this
        ; means that Trumbles™ will move on up to six of every 8 frames
        ;
        lda MAIN_COUNTER        ; get current main-loop counter
        and # %00000111         ; modulo 8 (0-7)
        cmp TRUMBLES_ONSCREEN   ; compare with number of Trumbles™ on-screen
       .blt :+                  ; if we have this-many Trumbles™, move one
        jmp main_roll_pitch     ; otherwise, return to the main flight loop

:       ; move a Trumble™:                                              ;$1E41
        ;-----------------------------------------------------------------------
        asl                     ; take the counter 0-5 and multiply by 2,
        tay                     ; for the interlaced X & Y positions

.ifdef  BUILD_ORIGINAL
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
        tax                     ; choice 0-3
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_X, y  ; set the Trumble™'s X direction

        lda _1e25, x            ; TODO: 0, 0, $ff, 0?
        sta TRUMBLES_XPOS_LO, y

        ; select a Y direction:
        ; 50% chance stay still, 25% go up, 25% go down
        jsr get_random_number   ; pick a new random number
        and # %00000011         ; modulo 4 (0-3)
        tax                     ; choice 0-3
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_Y, y  ; set the Trumble™'s Y direction

@move:  ; update the Trumble™'s position on screen                      ;$1E6A
        ;-----------------------------------------------------------------------
        ; mask-out the current Trumble™ sprite from the sprite's MSBs
        ;
        lda trumble_masks, y    ; sprite mask for current Trumble™
        and VIC_SPRITES_X       ; mask against the sprite MSBs
        sta VIC_SPRITES_X       ; update hardware sprites

        ; move the Trumble™ sprite vertically:
        ;
        lda VIC_SPRITE2_Y, y    ; current hardware sprite Y-position
        clc                     ; math!
        adc TRUMBLES_MOVE_Y, y  ; add the Trumble™'s Y direction
        sta VIC_SPRITE2_Y, y    ; update the hardware sprite

        ; move the Trumble™ sprite horizontally:
        clc 
        lda VIC_SPRITE2_X, y    ; current hardware sprite X-position (0-255)
        adc TRUMBLES_MOVE_X, y  ; add the Trumble™'s X direction
        sta T                   ; put aside whilst we handle the MSB (256-319) 

        lda TRUMBLES_XPOS_HI, y
        adc TRUMBLES_XPOS_LO, y
        bpl :+

        lda # $48               ;=72 / %01001000
        sta T                   ; '328'?

        lda # $01
:       and # %00000001                                                 ;$1E94
        beq :+

        lda T
        cmp # $50               ;=80 / %10000000
        lda # $01
        bcc :+

        lda # $00
        sta T

:       sta TRUMBLES_XPOS_HI, y                                         ;$1EA4
        beq :+

        ; set the MSB for this sprite:
        ;-----------------------------------------------------------------------
        lda trumble_masks+1, y  ; get the sprite bit for this Trumble™
        ora VIC_SPRITES_X       ; combine with current hardware sprite MSBs
        sei                     ; disable interrupts whilst repositioning
        sta VIC_SPRITES_X       ; update the 8 hardware sprite MSBs
:       lda T                   ; retrieve X-position remainder         ;$1EB3
        sta VIC_SPRITE2_X, y    ; set the Trumble™'s new X-position
        cli                     ; re-enable interrupts

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn I/O off, go back to 64K RAM
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        jmp main_roll_pitch     ; return to the main flight loop

;///////////////////////////////////////////////////////////////////////////////
.endif


main_flight_loop:                                                       ;$1EC1
;===============================================================================
; [1]:  MAIN FLIGHT LOOP
;-------------------------------------------------------------------------------
        ; seed the random-number-generator:
        ;
        ; the byte used here is the low-byte of the planet's X-position --
        ; since the player is always moving forward (speed cannot be 0),
        ; this value is always changing
        ;
        ; TODO: if we make systems without planets, this will need changing
        lda ship_00
        sta ZP_GOATSOUP_pt1

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; are there any Trumbles™ on-screen?
        lda TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .bze main_roll_pitch     ; =0; don't process Trumbles™

        ; move the Trumbles™ about the screen
        jmp move_trumbles

.endif  ;///////////////////////////////////////////////////////////////////////


main_roll_pitch:                                                        ;$1ECE
;===============================================================================
; [2]:  compute roll & pitch:
;-------------------------------------------------------------------------------
        ; take the roll amount and prepare it for use in the 3D math:
        ;
        ldx JOY_ROLL            ; current roll amount (from joy/key input)
        jsr dampen_toward_zero  ; apply damping
        jsr dampen_toward_zero  ; apply damping
        txa                     ; transfer roll amount back to A

        ; elite actually rotates the universe around the player(!), therefore
        ; rolling to the right means rolling everything else to the left which
        ; is why we do some sign flipping here whilst preparing the angle.
        ; thanks goes to Mark Moxon's BBC disassembly for this insight

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
        adc # 1

        ; we now have the absolute roll amount (+|-127),
        ; though this needs to be scaled down (+|-31):
        ;
:       lsr                     ; divide by 2,                          ;$1EEE
        lsr                     ; divide by 4
        cmp # 8                 ; for roll values < 32 to begin with
       .bge :+                  ;  we divide once more so as to provide
        lsr                     ;  finer precision in the small range

:       sta ZP_ROLL_MAGNITUDE   ; store [scaled] roll-amount            ;$1EF5
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
        
        sta ZP_INV_PITCH_SIGN   ; keep the inverted copy of only the sign
        eor # %10000000         ; flip the sign bit back again
        sta ZP_PITCH_SIGN       ; store as our "direction of pitch"

        ; scale the pitch amount. as the universe revolves around us
        ; we start with the pitch input with a fliped sign
        ;
        tya                     ; pitch magnitude (with flipped sign)
        bpl :+                  ; is it positive? skip negating
        eor # %11111111         ; flip all bits
:       adc # 4                 ; for negative numbers, add 4 (why?)    ;$1F15
        lsr                     ; divide by 2
        lsr                     ; divide by 4
        lsr                     ; divide by 8
        lsr                     ; divide by 16
        cmp # 3                 ; for pitch values < 48 to begin with
        bcs :+                  ;  we divide once more so as to provide
        lsr                     ;  finer precision in the small range

:       sta ZP_PITCH_MAGNITUDE  ; store [scaled] pitch amount           ;$1F20
        ora ZP_PITCH_SIGN       ; add sign
        sta ZP_BETA             ; put aside for the matrix math

        ; fallthrough
        ; ...

main_keys:
;===============================================================================
; [3]:  handle key presses:
;
; TODO: this section processes a number of key presses;
;       could we skip this when no keys are pressed by
;       marking a 'no keys' flag?
;-------------------------------------------------------------------------------
        ; accelerate?
        ;-----------------------------------------------------------------------
        lda key_accelerate      ; is accelerate being held?
       .bze :+                  ; if not, continue

        lda ZP_PLAYER_SPEED     ; current speed
        cmp # 40                ; are we at maximum speed?
        bcs :+                  ; "captain, she cannae go any faster!"

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
:       lda ZP_MISSILE_TARGET   ; is there already a missile target?    ;$1F55
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

        ; enable the energy bomb; if present, it's value should be $7F,
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
        jsr stop_sound          ; stop the docking music playing
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

:       ; shoot lasers?                                                 ;$1FD5
        ;-----------------------------------------------------------------------
        lda # $00                                                       
        sta ZP_LASER            ; clear laser-power for current view

        ; multiply player speed by 64:
        ;
        ; we take the player's ship speed, `ZP_PLAYER_SPEED`, 8-bit,
        ; and multiply this by 64 into a 16-bit number `ZP_SPEED_LO|HI`
        ;
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
        sta ZP_SPEED_LO         ; lo-byte of calculated speed starts at 0
        lda ZP_PLAYER_SPEED     ; take current player speed, 8-bit
                                ; (this will be the high-byte)
        lsr                     ; right-shift once
        ror ZP_SPEED_LO         ; ripple down to the result, lo-byte
        lsr                     ; right shift again
        ror ZP_SPEED_LO         ; ripple down to the result, lo-byte
        sta ZP_SPEED_HI         ; store result hi-byte

        ; if the laser is a pulse laser, it can't be shot continuously.
        ; this counter spaces out the shots and is updated every vsync
        ;
        lda LASER_COUNTER       ; is the laser between pulses?
        bne @nolaser            ; skip ahead if laser is between pulses

        lda joy_fire            ; is fire-key pressed?
        beq @nolaser            ; no? skip ahead

        lda LASER_HEAT          ; check current laser heat
        cmp # 242               ; laser temp >= 242?
        bcs @nolaser            ; don't fire if too hot

        ; is there a laser mounted on this direction?
        ;
        ldx COCKPIT_VIEW        ; current facing direction
        lda PLAYER_LASERS, x    ; get type of laser mounted here
        beq @nolaser            ; if zero, no laser, skip ahead

        ; all checks passed, laser goes pew pew!
        ;
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

        jsr shoot_lasers        ; draw laser lines
        
        pla                     ; retrieve laser type
        bpl :+                  ; (skip over if not beam laser)
        lda # 0                 ; zero pulse-wait for beam-laser
:       and # %11111010         ; set pulse-wait based on power-level   ;$2028
        sta LASER_COUNTER       ; more power = slower fire rate

        ; laser handled, fallthrough
        ; to the next step
        ;
@nolaser:

;===============================================================================
; [4]:  process ship instances:
;-------------------------------------------------------------------------------
        ldx # $00               ; begin with ship-slot 0                ;$202D

process_ship:                                           ; BBC: MAL1     ;$202F
        ;=======================================================================
        stx ZP_PRESERVE_X       ; set aside ship slot for later
        lda SHIP_SLOTS, x       ; is that a ship in your slot?
        bne :+                  ; if so, process it
        jmp _MA18               ; no more ships to process,
                                ; you're just happy to see me

:       sta ZP_SHIP_TYPE        ; put ship type aside                   ;$2039
        jsr get_ship_addr       ; look up the ship's instance data

        ; copy the given Ship to the
        ; working space in zero page:
        ;
        ; see "vars_ship.asm" for the code in this macro as different
        ; approaches are taken for optimisation depending on the build
        ;
        ; TODO: given the ~1'100 cycles to copy the object back and forth,
        ;       would it be faster to stick to indexing the object instead?
        ;       i.e. `... [ship], x`. we might get away with copying less
        ;       of the struct to ZP and index the lesser used properties
        ;
        .ship_to_zp

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

        ; fallthrough
        ; ...

        ;=======================================================================
        ; [5]:  handle e-bomb explosion: if an e-bomb is going off,
        ;       check if this ship can be destroyed by it
        ;-----------------------------------------------------------------------
        ; is the e-bomb active? (bit 7 set)
        ;
        lda PLAYER_EBOMB        ; check e-bomb state
        bpl @move               ; inactive, skip over

        ; look for some exclusions:
        ;
        ; TODO: this should be a property of the hull so that
        ;       it can be defined by data rather than code
        ;
        cpy # HULL_STATION *2   ; space station?
        beq @move               ; cannot be destroyed by e-bomb

        cpy # HULL_THARGOID *2  ; thargoid?
        beq @move               ; also cannot be e-bombed

        ; constrictor, cougar & dodo-station? -- also cannot be e-bombed
        ; WARN: this assumes any ID of constrictor or above are valid!
        cpy # HULL_CONSTRICTOR *2
        bcs @move

        ; make ship disappear?
        ;
        lda ZP_SHIP_STATE       ; get the ship's state
        and # state::debris     ; check for exploding (is debris)
       .bnz @move               ; skip if already exploding

        ; set bit 7 to indicate the ship is exploding
        ; (this assumes bit 7 is the exploding bit)
        ;
.if     (state::exploding <> %10000000)
        .fatal  "`process_ship` assumes that `state::exploding` is bit 7"
.endif
        asl ZP_SHIP_STATE       ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_SHIP_STATE       ; ...shift the carry into bit 7

        ldx ZP_SHIP_TYPE        ; retrieve ship-type again
        jsr ship_killed         ; add points to kill rank

        ; fallthrough
        ; ...

        ;=======================================================================
        ; [6]:  move ship forward:
        ;-----------------------------------------------------------------------
@move:  jsr move_ship                                                   ;$2079

        ; copy the zero-page Ship back to its storage
        ;
        .zp_to_ship

        ;=======================================================================
        ; [7]:  collision checks:
        ;-----------------------------------------------------------------------
        ; is the ship already exploding?
        ;
        lda ZP_SHIP_STATE
        and # state::exploding | state::debris

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr or_xyz_hi           ; combine check with distance
.else   ;///////////////////////////////////////////////////////////////////////
        ora ZP_SHIP_XPOS_HI     ; there's really no need for a JSR for this
        ora ZP_SHIP_YPOS_HI
        ora ZP_SHIP_ZPOS_HI
.endif  ;///////////////////////////////////////////////////////////////////////

        ; if the ship is exploding / exploded, or is otherwise too far away
        ; to be considered for docking or scooping, then skip ahead
       .bnz @20e0               

        lda ZP_SHIP_XPOS_LO     ; check the near distance
        ora ZP_SHIP_YPOS_LO
        ora ZP_SHIP_ZPOS_LO
        ; if the high-bit is set on the lo-byte of any axis (>=128)
        ; then the ship is still far enough away, skip ahead
        bmi @20e0

        ; potential for collision:
        ;-----------------------------------------------------------------------
        ldx ZP_SHIP_TYPE        ; sun or planet?
        bmi @20e0               ; yes, cannot scoop or dock it, skip!

        cpx # HULL_STATION      ; space station?
        beq @dock               ; yes, handle space-station behaviour

        and # %11000000         ; is distance within 64?
        bne @20e0               ; if no, still too far away

        cpx # HULL_MISSILE      ; is it a missile?
        beq @20e0               ; yes, cannot scoop or dock, skip!

        ; can we scoop this object?
        ;
        lda PLAYER_SCOOP        ; fuel scoops? ($00 = none, $FF = present)
        
        ; is the object below the player? i.e. if its Y-position is negative;
        ; we've already established that it's near enough to us
        and ZP_SHIP_YPOS_SIGN
        bpl big_damage          ; if no scoops / above us, collision!

        ;=======================================================================
        ; [8]:  scooping:
        ;-----------------------------------------------------------------------
        ; attempt to scoop object
        ;
        cpx # HULL_CANNISTER    ; is this a cargo cannister?
        beq @can                ; yes, pick it up

        ; read scoop data from the hull:
        ;
        ldy # Hull::scoop_debris
        lda [ZP_HULL_ADDR], y
        lsr                     ; down shift the top-nybble
        lsr                     ;  into the bottom nybble
        lsr                     ; (cargo-data is held in the top-nybble,
        lsr                     ;  debris-data in the low-nybble)
       .bze big_damage          ; if zero, cannot be scooped?
        
        ; the scoop-data in a hull definition sets which cargo type it gives
        ; when scooped, already decremented by 1 to account for the non-zero
        ; check below. a side-effect of this is that it's not possible
        ; for a hull definition to forcibly drop food or textiles(?)
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

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this has no effect due to the LDY after; it was probably
        ; the original offset for the cargo name strings
        ldy # 78
.endif  ;///////////////////////////////////////////////////////////////////////
        bcs explode_obj         ; cargo full, explode the cannister!

        ldy CARGO_ITEM          ; retrieve type of cargo
        adc PLAYER_CARGO, y     ; add 1 to current cargo count
        sta PLAYER_CARGO, y     ; update your cargo holdings
        tya

        ; print the name of the cargo:
.import TKN_FLIGHT_CARGO_TYPES:direct
        adc # TKN_FLIGHT_CARGO_TYPES
        jsr _MESS               ; print a message on-screen

        asl ZP_SHIP_BEHAVIOUR   ; mark cannister for removal
        sec                     ; (set bit 7)
        ror ZP_SHIP_BEHAVIOUR

        ; the ship has been scooped, and therefore cannot
        ; be docked with, skip over the docking section
@20e0:  jmp _MA26                                       ; BBC: MA65     ;$20E0


        ;=======================================================================
        ; [9]:  docking:
        ;-----------------------------------------------------------------------
        ; is the station hostile? ship slot 1 is always reserved for
        ; the sun or space-station, so we can refer to its bytes directly
        ;
@dock:  lda ship_01 + Ship::behaviour                                   ;$20E3
        and # behaviour::angry  ; check the angry flag
       .bnz dock_fail           ; cannot dock!

        ; check the rotation of the station:
        ; the angle of rotation around our nose
        ; must be within 26 degrees (either way)
        ;
        lda ZP_SHIP_M0x2_HI
        cmp # 214               ; (radians?) < 26 degrees?
        bcc dock_fail

        ; check angle of approach: we must be pointing
        ; within a 22 degree up/down angle of approach
        ;
        jsr _SPS4               ; get vector to station
        lda ZP_VEC_Z
        cmp # 89                ; (radians?) < 22 degrees?
        bcc dock_fail

        ; check rotation of slot: we must be pointing
        ; within 36.6 degrees left/right of the slot
        ;
        lda ZP_SHIP_M1x0_HI     ; rotation from "roof" (top, looking down)
        and # %01111111         ; (remove sign)
        cmp # 80                ; (radians?) < 36.6 degrees?
        bcc dock_fail

        ; all conditions met for docking
        ; with the station, we can go in!

dock_ok:                                                ; BBC: GOIN     ;$2101
        ;=======================================================================
        ; docking successful!
        ;
        ; NOTE: escape capsule jumps here to return you to the station
        ;
        jsr stop_sound          ; stop all sound playing
        jmp docked              ; handle docked screen
        
dock_fail:                                              ; BBC: MA62     ;$2107
        ;=======================================================================
        ; docking fail!
        ;
        lda ZP_PLAYER_SPEED     ; check approach speed
        cmp # 5                 ; going slow?
        bcc small_damage        ; slow; take damage
        jmp _87d0               ; fast; explode


        ;=======================================================================
        ; [10]: collision!
        ;-----------------------------------------------------------------------
explode_obj:                                                            ;$2110
        ;=======================================================================
        ; this entry point is for when a cannister is destroyed,
        ; by colliding with it / scooping with a full hull
        ;
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03         ; cannister exploding sound
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set 'exploding' state (bit 7) on the ship
        ;
        asl ZP_SHIP_STATE       ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_SHIP_STATE       ; ...shift the carry into bit 7
        bne _MA26               ; (always brunches)

small_damage:                                           ; BBC: MA67     ;$211A
        ;=======================================================================
        ; player takes damage from colliding with ship
        ; (either a cannister that cannot be scooped, or the mailslot)
        ;
        ; TODO: should the player's ship be sent into a spin instead?
        ;       this slow-down is perhaps intentionally for stopping the
        ;       player flying through the space station at full speed?
        ;
        lda # 1                 ; slow down
        sta ZP_PLAYER_SPEED
        lda # 5                 ; take '5' damage
        bne apply_damage        ; (always branches)

big_damage:                                             ; BBC: MA58     ;$2122
        ;=======================================================================
        ; set 'exploding' state (bit 7) on the ship
        ;
        asl ZP_SHIP_STATE       ; push bit 7 off
        sec                     ; set carry and...
        ror ZP_SHIP_STATE       ; ...shift the carry into bit 7
        
        ; take damage proportional to the energy level of the ship you collided
        ; with; the ship's energy level is divided by 2 and 128 is added
        ;
        lda ZP_SHIP_ENERGY      ; ship's energy level...
        sec                     ; we'll introduce a high-bit (128)   
        ror                     ; divide by 2 and insert the high-bit (+128)

apply_damage:                                           ; BBC: MA63     ;$212B
        ;-----------------------------------------------------------------------
        ; apply the amount of damage in A to the player, depleting the shields.
        ; if they're gone, take damage directly which may cause loss of cargo
        ;
        jsr damage_player

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03
.endif  ;///////////////////////////////////////////////////////////////////////

        ; collision damage applied,
        ; fallthrough to next step
        ; ...

        ;=======================================================================
        ; [11]: missile & laser hit testing:
        ;-----------------------------------------------------------------------
        ; if the ship has been scooped (cannister)
        ; or docked, remove it from the scanner
        ;
_MA26:  lda ZP_SHIP_BEHAVIOUR   ; check the "remove" flag, if set       ;$2131
        bpl :+                  ;  the ship is removed from the scanner
        jsr _SCAN               ;  by redrawing the stalk to erase it

:       lda ZP_SCREEN           ; are we in the cockpit-view?           ;$2138
       .bnz @_MA15              ; no? skip ahead

        ; since the universe rotates around the player in Elite, we need to
        ; make sure that the X/Y/Z axes in the ship instance match the current
        ; view into space, i.e. when looking left or right the X & Z axes are
        ; flipped. this is so that code below does not have to differentiate
        ; between view directions
        ;
.if     !.defined( BUILD_ORIGINAL )
        ;///////////////////////////////////////////////////////////////////////
        ; in the BBC code, this check is inlined to save the JSR,
        ; but was not included in the C64 version
        ;
        ldx COCKPIT_VIEW        ; if already facing forward,
        beq @hitch              ;  no correction needed
.endif  ;///////////////////////////////////////////////////////////////////////
        jsr _PLUT               ; flip the axes

        ; check if the current ship instance
        ; is within the player's sights
        ;
@hitch: jsr _HITCH
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
:       lda ZP_LASER            ; is your laser firing?                 ;$2153
       .bze @draw               ; no, skip onwards

        ; ship is in player's sights, lasers are firing;
        ; make the sound of laser striking metal
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldx # $0f               ; (this gets lost by the routine below)
        jsr sound_play_laserstrike
.endif  ;///////////////////////////////////////////////////////////////////////

        lda ZP_SHIP_TYPE        ; things we've shot with our laser:
        cmp # HULL_STATION      ; the station!?
        beq @angry              ; shot the station, uh oh...
        
        ; the Constrictor and Cougar cannot be damaged
        ; with anything less than military lasers:
        ;
        ; TODO: this check must be considered when adding new ships, i.e.
        ; ships placed after the Constrictor require military lasers
        ;
        cmp # HULL_CONSTRICTOR  ; constrictor & cougar (and above)?
        bcc @hit                ; no, skip over

        lda ZP_LASER            ; player's laser power
        cmp # 23                ; TODO: confirm and const this!
        bne @angry              ; hit!

        lsr ZP_LASER            ; divide laser power by 4, making it highly
        lsr ZP_LASER            ; ineffective against the Constrictor or Cougar

        ; laser has hit ship!
        ;-----------------------------------------------------------------------
        ; calculate if your laser fire has destroyed the ship:
        ;
@hit:   lda ZP_SHIP_ENERGY      ; ship's energy-level                   ;$2170
        sec 
        sbc ZP_LASER            ; subtract player's laser power
        bcs @noexp              ; if energy remains, skip ahead

        ; explode the ship:
        ;-----------------------------------------------------------------------
        ; set the "exploding" bit on the ship:
        ;
        asl ZP_SHIP_STATE       ; remove bit 7
        sec                     ; take a 1 from the bit bucket
        ror ZP_SHIP_STATE       ; shift it into bit 7

        ; what type of debris should it drop?
        ; check for asteroids first (for mining)
        ;
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

@noexp: sta ZP_SHIP_ENERGY      ; update the ships energy level         ;$21A1

@angry: lda ZP_SHIP_TYPE        ; again, go by ship type                ;$21A3
        jsr _ANGRY              ; make hostile

        ;=======================================================================
        ; [12]: bounties & felonies:
        ;=======================================================================
        ; *** DRAW THE SHIP ON THE SCREEN ***
        ; (I felt this needed drawing attention to as it's easy to miss)
        ;
@draw:  jsr draw_ship                                   ; BBC: MA8      ;$21A8

        ; update the zero-page copy of the ship's energy level
        ; back to the ship's instance storage
        ;
        ; TODO: why do we do this, when we could defer copying the whole
        ;       ship instance to later in the main loop??
@_MA15: ldy # Ship::energy                              ; BBC: MA15     ;$21AB
        lda ZP_SHIP_ENERGY
        sta [ZP_SHIP_ADDR], y

        ; when will you learn that your actions have consequences?
        ;-----------------------------------------------------------------------
        ; check the high-bit of the behaviour flags, this indicates if the ship
        ; needs to be removed from play -- you can't get bounties for ships
        ; that have disappeared (e.g. docked)
        ;
        lda ZP_SHIP_BEHAVIOUR
        bmi @clear              ; if bit 7 set, ship has been removed, skip

        lda ZP_SHIP_STATE       ; is the ship currently exploding?
        bpl @_MAC1              ; if not exploding, skip ahead

        and # state::debris     ; has the ship finished exploding?
        beq @_MAC1              ; if no, keep waiting

        ; did we blow up a police ship?
        ; the behaviour bit for police (%01000000 = 64) is used as the
        ; felony-level to set, making the player immediately "Fugitive"
        ;
        lda ZP_SHIP_BEHAVIOUR
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
        ldy # Hull::bounty+0    ; (bounty lo-byte)
        lda [ZP_HULL_ADDR], y   ; read from the hull structure
       .bze @clear              ; skip if no bountry (=0)

        tax                     ; put aside the lo-byte
        iny                     ; (bounty hi-byte)
        lda [ZP_HULL_ADDR], y   ; read the bounty hi-byte
        tay                     ; put aside hi-byte
        jsr give_cash           ; pay monies

        ; TODO: GitHub issue #50:
        ;       Display credits earnerd after kill, not total credits
        ;
        ; (flight token for printing player's current cash)
        lda # TKN_FLIGHT_FN_PLAYER_CASH
        jsr _MESS               ; print an in-flight message

@clear: ; clear the ship-slot and shuffle down the rest:                ;$21E2
        ;-----------------------------------------------------------------------
        ; elite relies upon there not being free gaps between ship-instances
        ; for detecting when the last ship-instance is reached
        ;
        ; TODO: since skipping over unused slots is plenty fast enough,
        ;       maybe we could do away with this requirement
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; once shuffled down, execution jumps back to `process_ship`,
        ; so this jump can be considered an end-point of the loop
        jmp clear_ship_slot
.else   ;///////////////////////////////////////////////////////////////////////
        ; in the original code it jumps to another routine that only contains
        ; a handful of instructions, is not used by any other code, and would
        ; only function as part of `process_ship` anyway, so we inline it here
        ; instead
        ;
        ldx ZP_PRESERVE_X       ; retrieve current ship-slot
        jsr _82f3               ; empty it and shuffle ship-instances down
        ldx ZP_PRESERVE_X       ; retrieve to current ship-slot (next ship)
        jmp process_ship        ; process next ship (continue loop)
.endif  ;///////////////////////////////////////////////////////////////////////

        ; execution jumps here if the ship has not been destroyed
        ;-----------------------------------------------------------------------
@_MAC1: lda ZP_SHIP_TYPE        ; skip over for planets and suns        ;$21E5
        bmi :+                  ;

        ; has the ship gone out of range?
        ; (> 224 in any direction)
        jsr _FAROF
        bcc @clear              ; if yes, remove the ship from the slot

        ; process next ship:
        ;-----------------------------------------------------------------------
        ; update the ship's stored state with the current working state
        ;
:       ldy # Ship::state       ; index of ship state byte              ;$21EE
        lda ZP_SHIP_STATE       ; read working copy in zero-page
        sta [ZP_SHIP_ADDR], y   ; write back to the ship slot

        ldx ZP_PRESERVE_X       ; retrieve current ship-slot being processed...
        inx                     ; move to the next ship-slot
        jmp process_ship        ; process the next ship

        ; this ends the `process_ship` loop
        ; started back in stage 4

_MA18:                                                  ; BBC: MA18     ;$21FA
;===============================================================================
; [13]: bomb & shields:
;-------------------------------------------------------------------------------
        lda PLAYER_EBOMB        ; check energy bomb state
        bpl :+                  ; skip over if not going off

        ; the on-going state of the e-bomb is managed by shifting bits
        ; off the top of a byte instead of using a typical counter
        asl PLAYER_EBOMB
        bmi :+                  ; so long as a 1 is popped off, skip over

        ; when the ebomb counter empties, return
        ; the viewport to monochrome rendering
        jsr _2367

        ; only every 8 frames...
        ;=======================================================================
:       lda MAIN_COUNTER                                                ;$2207
        and # %00000111         ; module 8 (0-7)
        bne _227a               ; =0? (skip for 7 of 8 frames) 

        ; recharge shields:
        ;-----------------------------------------------------------------------
        ; shields will only begin recharging after the ship's
        ; energy level reaches 50% or more
        ;
        ldx PLAYER_ENERGY       ; current hull energy level
        bpl :+                  ; skip for < 128 of 256

        ; recharge rear-shield:
        ;
        ldx PLAYER_SHIELD_REAR
        jsr recharge_shield
        stx PLAYER_SHIELD_REAR

        ; recharge front-shield:
        ;
        ldx PLAYER_SHIELD_FRONT
        jsr recharge_shield
        stx PLAYER_SHIELD_FRONT

        ; recharge ship's main energy banks
        ;-----------------------------------------------------------------------
        ; energy increase by 1 normally, but the presence
        ; of an energy unit increases charge rate to 2
:       sec                     ; add 1 by default                      ;$2224
        lda PLAYER_EUNIT        ; if this is zero, carry will do the +1
        adc PLAYER_ENERGY
        bcs :+
        sta PLAYER_ENERGY

;===============================================================================
; [14]: spawn space-station:
;       
;       every 32 iterations of the main loop, we check to see if
;       the player is near enough to the planet to spawn the space-station
;-------------------------------------------------------------------------------
        ; there is no space-station in witchspace!
        ;
:       lda IS_WITCHSPACE       ; check witchspace flag, $FF = true     ;$2230
       .bnz _MA23S              ; if non-zero, skip spawning station

        ; we only check that the space-station
        ; is within range every 32 frames
        ;
        lda MAIN_COUNTER        ; current frame-count
        and # %00011111         ; modulo 32, i.e. 0-31
       .bnz _MA93               ; skip every frame other than 0

        ; is the space-station already present?
        ;
        ; NOTE: rather than checking the ship slot reserved for the station
        ; the pointer in the hull table is checked as this gets rewritten
        ; based on which station is present, if any
        ;
        ; TODO: for a ROM-based hull-table, use a ship-slot detection instead 
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
       .bnz _MA23S

        tay                     ; set Y to zero (because of previous branch)
        jsr _MAS2               ; calculate rough distance to planet
        bne _MA23S              ; not close enough, skip

        ; spawn the station in:
        ;-----------------------------------------------------------------------
        ; since the station is positioned around the planet, we copy the ship
        ; instance data used for the planet and modify that. we don't need all
        ; the attributes (planets don't have A.I.)
        ;
        ; number of bytes to copy:
        ; (up to, and including, the `acceleration` property)
        ldx # Ship::acceleration + .sizeof( Ship::acceleration )-1

        ; copy from ship slot 0 to the zero-page working space
        ; TODO: this can be optionally unrolled
        ;
:       lda ship_00, x                                                  ;$2248
        sta ZP_SHIP, x
        dex 
        bpl :-

        inx                     ; X=0
        ldy # 9                 ; MATRIX_ROW0?
        jsr _MAS1
        bne _MA23S

        ldx # $03
        ldy # $0b
        jsr _MAS1
        bne _MA23S

        ldx # $06
        ldy # $0d
        jsr _MAS1
        bne _MA23S
        
        lda # $c0
        jsr _87a6
        bcc _MA23S

        jsr wipe_sun
        jsr _7c24
_MA23S:                                                                 ;$2277
        jmp _231c

        ;-----------------------------------------------------------------------

_227a:                                                                  ;$227A
        lda IS_WITCHSPACE
        bne _MA23S

        lda MAIN_COUNTER
        and # %00011111
_MA93:                                                                  ;$2283
        cmp # $0a
        bne _22b5
        lda # $32
        cmp PLAYER_ENERGY
        bcc _2292
        asl                     ; !! print "energy low"? (msg 100 / $64)
        jsr _MESS               ; print an on-screen message
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
        sta R
        jsr square_root
        lda Q
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
        lda .loword( SHIP_TYPES + HULL_STATION )
        bne _231c

        ldy # .sizeof( Ship )
        jsr _MAS2
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
.ifdef  BUILD_ORIGINAL
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

.ifdef  BUILD_ORIGINAL
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
        jsr _MESS               ; print an on-screen message
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
        jsr _ECMOF
_2345:                                                                  ;$2345
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz rts_2366            ; (no? exit)

        jmp move_dust


spawn_debris:                                           ; BBC: SPIN2    ;$234C
;===============================================================================
; when a ship is destroyed, attempt to spawn debris according
; to the debris info in the ship's hull structure
;
; in:   Y                       ship-type
;       ZP_HULL_ADDR            must be loaded with a pointer to a hull struct
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
; in:   A                       number of items to spawn
;       X                       ship-type to spawn, e.g. cargo cannister
;-------------------------------------------------------------------------------
        sta ZP_TEMP_COUNTER
        beq rts_2366            ; zero-flag will not be set by STA!

:       lda # $00                                                       ;$235D
        jsr _370a               ; NOTE: spawns ship-type in X
        
        dec ZP_TEMP_COUNTER
        bne :-

rts_2366:                                                               ;$2366
        rts


_2367:                                                                  ;$2367
;===============================================================================
; TODO: something to do with the e-bomb effect:
;
;-------------------------------------------------------------------------------
        ; set the viewport back to monochrome?
        lda # vic_screen_ctl2::unused
        sta interrupt_screenmode1

        lda # $00
        sta _a8e6

        rts 
