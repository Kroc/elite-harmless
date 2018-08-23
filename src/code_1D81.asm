; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

.include        "c64.asm"
.include        "elite_vars.asm"
.include        "var_zeropage.asm"
.include        "gfx/hull_struct.asm"

; from "text_flight.asm"
.import _0ac0:absolute
.import _0ae0:absolute

; from "text_docked.asm"
.import _0e00:absolute
.import _1a27:absolute
.import _1a41:absolute

; from "code_1D00.asm"
.import _1d06:absolute
.import _1d07:absolute
.import _1d09:absolute

; from "code_6A00.asm"
.import _6a00:absolute
.import set_cursor_col:absolute
.import set_cursor_row:absolute
.import cursor_down:absolute
.import _6a2f:absolute
.import _6a3b:absolute
.import _6a9b:absolute
.import _6f82:absolute
.import _70a0:absolute
.import _70ab:absolute
.import _745a:absolute
.import _7481:absolute
.import _76e9:absolute
.import _7773:absolute
.import print_flight_token:absolute
.import _7b61:absolute
.import _7b64:absolute
.import _7b6f:absolute
.import _7bd2:absolute
.import _7c24:absolute
.import _7c6b:absolute
.import _7d0c:absolute
.import _7d0e:absolute
.import _805e:absolute
.import _80ff:absolute
.import _811e:absolute
.import _81ee:absolute
.import set_memory_layout:absolute
.import _829a:absolute
.import _83df:absolute
.import _8447:absolute
.import get_random_number:absolute
.import _872f:absolute
.import _877e:absolute
.import _87a4:absolute
.import _87a6:absolute
.import _87b1:absolute
.import debug_brk:absolute
.import _87d0:absolute
.import _88e7:absolute
.import txt_docked_token1A:absolute
.import txt_docked_token1E:absolute
.import txt_docked_token1F:absolute
.import _8c7b:absolute
.import _8c8a:absolute
.import _8cad:absolute
.import _8d0f:absolute
.import _8d10:absolute
.import _8d13:absolute
.import _8d15:absolute
.import _8d23:absolute
.import _8d28:absolute
.import _8d2a:absolute
.import _8d2e:absolute
.import _8d35:absolute
.import _8d36:absolute
.import _8d38:absolute
.import _8d3e:absolute
.import _8d42:absolute
.import _8d53:absolute
.import _8e29:absolute
.import _900d:absolute
.import _9204:absolute
.import _923b:absolute

.import _9300:absolute
.import _9400:absolute
.import _9500:absolute
.import _9600:absolute
.import row_to_bitmap_lo:absolute
.import row_to_bitmap_hi:absolute

.import _9978:absolute
.import _99af:absolute
.import _9a2c:absolute
.import _9a86:absolute
.import _9d8e:absolute
.import _9db3:absolute
.import _9dee:absolute
.import _9e27:absolute
.import _a013:absolute
.import _a2a0:absolute
.import _a44c:absolute
.import _a626:absolute
.import _a72f:absolute
.import _a7a6:absolute
.import _a786:absolute
.import _a795:absolute
.import _a7e9:absolute
.import _a80f:absolute
.import _a813:absolute
.import _a839:absolute
.import _a858:absolute
.import _a8e0:absolute
.import _a8e6:absolute
.import _ab91:absolute
.import _affa:absolute
.import _b0f4:absolute
.import _b11f:absolute
.import wait_for_frame:absolute
.import _b179:absolute
.import paint_char:absolute
.import txt_docked_token15:absolute
.import _b410:absolute

; from "hull_data.asm"
.import hull_pointers

;-------------------------------------------------------------------------------

.segment        "CODE_1D81"

; I think this is when the player has docked,
; it checks for potential mission offers

_1d81:                                                                  ;$1D81
        jsr _83df
        jsr _379e

        ; now the player is docked, some variables can be reset
        ; -- the cabin temperature is not reset; oversight / bug?
        lda # $00
        sta $96                 ; bring player's ship to a full stop
        sta PLAYER_TEMP_LASER   ; complete laser cooldown
        sta $66                 ; reset hyperspace countdown

        ; set shields to maximum:
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

        ; check eligibility for the Constrictor mission:
        ;-----------------------------------------------------------------------
        ; available on the first galaxy after 256 or more kills. your job is
        ; to hunt down the prototype Constrictor ship starting at Reesdice

        ; is the mission already underway or complete?
        lda MISSION_FLAGS
        and # missions::constrictor
       .bnz :+                  ; mission is underway/complete, ignore it
        
        lda PLAYER_KILLS
        beq @skip               ; ignore mission if kills less than 256

        ; is the player in the first galaxy?

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

.endif

@skip:  ; check for Trumbles™ mission                                   ;$1E00
        ;-----------------------------------------------------------------------
.ifndef OPTION_NOTRUMBLES
        
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
.endif

:       jmp _88e7                                                       ;$1E11


debug_for_brk:                                                          ;$1E14
        ;=======================================================================
        ; set a routine to capture use of the `brk` instruction.
        ; not actually used, but present, in original Elite
        ;
        lda #< debug_brk
        sei                     ; disable interrupts
        sta $0316               ; vector for BRK routine 
        lda #> debug_brk
        sta $0317               ; vector for BRK routine
        cli                     ; enable interrupts

        rts 

;===============================================================================
; Trumble™ A.I. data?

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
        lda $a3                 ; "move counter"?
        and # %00000111         ; modulo 8 (0-7)
        cmp TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .blt :+

        jmp _1ece

        ; take the counter 0-7 and multiply by 2
        ; for use in a table of 16-bit values later
:       asl                                                             ;$1E41
        tay 

        ; turn the I/O area on to manage the sprites
        lda # MEM_IO_ONLY
        jsr set_memory_layout
        
        ; should the Trumbles™ change direction?

        jsr get_random_number   ; select a random number
        cmp # 235               ; is it > 234 (about 8% probability)
       .blt @move               ; no, just keep moving

        ; pick a direction for the Trumble™
        
        ; select an X direction:
        ; 50% chance stay still, 25% go left, 25% go right
        and # %00000011         ; random number modulo 4 (0-3)
        tax                     ; choice 1-4
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_X, y  ; set the Trumble™'s X direction

        lda _1e25, x
        sta $0521, y

        ; select a Y direction:
        ; 50% chance stay still, 25% go up, 25% go down
        jsr get_random_number   ; pick a new random number
        and # %00000011         ; modulo 4 (0-3)
        tax                     ; choice 1-4
        lda trumble_steps, x    ; pick a direction, i.e. 0, 1 or -1
        sta TRUMBLES_MOVE_Y, y  ; set the Trumble™'s Y direction

@move:                                                                  ;$1E6A
        ; turn *OFF* sprite MSB?
        ; why do this?

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
        
        lda $0531, y
        adc $0521, y
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
        sta $0531, y
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

        ; turn I/O off, go back to 64K RAM
        lda # MEM_64K
        jsr set_memory_layout
        
        jmp _1ece

_1ec1:                                                                  ;$1EC1
        ;=======================================================================
.export _1ec1

.import POLYOBJ_00
        lda POLYOBJ_00          ;=$F900?
        sta ZP_GOATSOUP_pt1     ;?

        ; are there any Trumbles™ on-screen?
        lda TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
       .bze _1ece               ; =0; don't process Trumbles™
        
        ; process Trumbles™
        ; (move them about, breed them)
        jmp _1e35

_1ece:                                                                  ;$1ECE
        ;-----------------------------------------------------------------------
        ldx $048d
        jsr _3c58
        jsr _3c58
        txa 
        eor # %10000000
        tay 
        and # %10000000
        sta $69                 ; roll sign?
        stx $048d
        eor # %10000000
        sta $6a                 ; move count?
        tya 
        bpl _1eee
        eor # %11111111
        clc 
        adc # $01
_1eee:                                                                  ;$1EEE
        lsr 
        lsr 
        cmp # $08
        bcs _1ef5
        lsr 
_1ef5:                                                                  ;$1EF5
        sta $68                 ; roll magnitude
        ora $69                 ; roll sign?
        sta $a6
        ldx $048e
        jsr _3c58
        txa 
        eor # %10000000
        tay 
        and # %10000000
        stx $048e
        sta $95
        eor # %10000000
        sta $94
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
        sta $64
        ora $94
        sta $63
        
        lda _8d10
        beq _1f33
        
        lda $96                 ; player's ship speed?
        cmp # $28
        bcs _1f33
        
        inc $96                 ; player's ship speed?
_1f33:                                                                  ;$1F33
        lda _8d15
        beq _1f3e
        dec $96                 ; player's ship speed?
        bne _1f3e
        inc $96                 ; player's ship speed?
_1f3e:                                                                  ;$1F3E
        lda _8d2e
        and PLAYER_MISSILES
        beq _1f55

        ldy # $57
        jsr _7d0c
        ldy # $06
        jsr _a858

        lda # $00
        sta PLAYER_MISSILE_ARMED
_1f55:                                                                  ;$1F55
        lda $7c
        bpl _1f6b
        lda _8d36
        beq _1f6b

        ldx PLAYER_MISSILES
        beq _1f6b

        sta PLAYER_MISSILE_ARMED

        ldy # $87
        jsr _b11f
_1f6b:                                                                  ;$1F6B
        lda _8d28
        beq _1f77
        lda $7c
        bmi _1fc2
        jsr _36a6
_1f77:                                                                  ;$1F77
        lda _8d0f
        beq _1f8b
        asl $04c3
        beq _1f8b
        ldy # $d0
        sty _a8e0
        ldy # $0d
        jsr _a858
_1f8b:                                                                  ;$1F8B
        lda _8d23
        beq _1f98
        lda # $00
        sta $0480
        jsr _923b
_1f98:                                                                  ;$1F98
        lda _8d13
        and $04c7
        beq _1fa8
        lda $0482
        bne _1fa8
        jmp _316e

        ;-----------------------------------------------------------------------

_1fa8:                                                                  ;$1FA8
        lda _8d2a
        beq _1fb0
        jsr _8e29
_1fb0:                                                                  ;$1FB0
        lda _8d3e
        and $04c1
        beq _1fc2
        lda $67
        bne _1fc2
        dec $0481
        jsr _b0f4
_1fc2:                                                                  ;$1FC2
        lda _8d38
        and $04c5
        beq _1fd5
        eor _8d35
        beq _1fd5
        sta $0480
        jsr _9204
_1fd5:                                                                  ;$1FD5
        lda # $00
        sta $7b
        sta $97
        lda $96                 ; player's ship speed?
        lsr 
        ror $97
        lsr 
        ror $97
        sta $98
        lda $0487
        bne _202d
        lda _8d42
        beq _202d
        lda PLAYER_TEMP_LASER
        cmp # $f2
        bcs _202d
        ldx $0486
        lda PLAYER_LASERS, x
        beq _202d
        pha 
        and # %01111111
        sta $7b
        sta $0484
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
        jsr _3cdb
        pla 
        bpl _2028
        lda # $00
_2028:                                                                  ;$2028
        and # %11111010
        sta $0487
_202d:                                                                  ;$202D
        ldx # $00
_202f:                                                                  ;$202F
.export _202f
        stx $9d
        lda $0452, x            ; ship slots?
        bne _2039

        jmp _21fa

        ;-----------------------------------------------------------------------

_2039:                                                                  ;$2039
        sta $a5
        jsr get_polyobj
        
        ; copy the given PolyObject to the zero page:
        ; ($09..$2D)
        ;
        ldy # .sizeof(PolyObject) - 1
:       lda [ZP_POLYOBJ_ADDR], y                                        ;$2040
        sta ZP_POLYOBJ, y
        dey 
        bpl :-

        lda $a5
        bmi @skip
        
        asl 
        tay 
        lda hull_pointers - 2, y
        sta ZP_HULL_ADDR_LO
        lda hull_pointers - 1, y
        sta ZP_HULL_ADDR_HI
        
        lda $04c3               ; energy bomb?
        bpl @skip
        
        cpy # $04               ;=$02(x2): space station (coreolis)?
        beq @skip

        cpy # $3a               ;=$1D(x2): thargoid?
        beq @skip

        cpy # $3e               ;=$1F(x2): constrictor
        bcs @skip

        ; has enough energy?
        lda ZP_POLYOBJ_ENERGY
        and # %00100000
        bne @skip

        asl ZP_POLYOBJ_ENERGY   ;?
        sec 
        ror ZP_POLYOBJ_ENERGY   ;?

        ldx $a5
        jsr _a7a6
        
@skip:  jsr _a2a0                                                       ;$2079

        ; copy the zero-page PolyObject back to its storage

        ldy # .sizeof(PolyObject) - 1
:       lda ZP_POLYOBJ, y                                               ;$207E
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        bpl :-

        lda ZP_POLYOBJ_ENERGY
        and # %10100000
        jsr _87b1
        bne _20e0

        lda ZP_POLYOBJ_XPOS_pt1 ;=$09
        ora ZP_POLYOBJ_YPOS_pt1 ;=$0C
        ora ZP_POLYOBJ_ZPOS_pt1 ;=$0F
        bmi _20e0

        ldx $a5
        bmi _20e0
        
        cpx # $02
        beq _20e3
        
        and # %11000000
        bne _20e0
        
        cpx # $01
        beq _20e0
        lda $04c2
        and ZP_POLYOBJ_YPOS_pt3 ;=$0E
        bpl _2122
        cpx # $05
        beq _20c0

        ldy # Hull::_00         ;=$00: "scoop / debris"?
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
        jsr _6a00
        ldy # $4e
        bcs _2110
        ldy $04ef               ; item index?
        adc $04b0, y            ; cargo qty?
        sta $04b0, y            ; cargo qty?
        tya 
        adc # $d0
        jsr _900d
        asl $2d
        sec 
        ror $2d
_20e0:                                                                  ;$20E0
        jmp _2131

        ;-----------------------------------------------------------------------

_20e3:                                                                  ;$20E3
        ;(last byte of `POLYOBJ_01`?)
        lda POLYOBJ_01 + PolyObject::ai_state   ;=$F949
        and # %00000100
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
        lda $96                 ; player's ship speed?
        cmp # $05
        bcc _211a
        jmp _87d0

        ;-----------------------------------------------------------------------

_2110:                                                                  ;$2110
        jsr _a813
        asl $28
        sec 
        ror $28
        bne _2131
_211a:                                                                  ;$211A
        lda # $01
        sta $96                 ; player's ship speed?
        lda # $05
        bne _212b
_2122:                                                                  ;$2122
        asl $28
        sec 
        ror $28
        lda $2c
        sec 
        ror 
_212b:                                                                  ;$212B
        jsr _7bd2
        jsr _a813
_2131:                                                                  ;$2131
        lda $2d
        bpl _2138
        jsr _b410
_2138:                                                                  ;$2138
        lda $a0
        bne _21ab
        jsr _a626
        jsr _363f
        bcc _21a8

        lda PLAYER_MISSILE_ARMED
        beq _2153
        
        jsr _a80f
        ldx $9d
        ldy # $27
        jsr _7d0e
_2153:                                                                  ;$2153
        lda $7b
        beq _21a8
        ldx # $0f
        jsr _a7e9
        lda $a5
        cmp # $02
        beq _21a3
        cmp # $1f
        bcc _2170
        lda $7b
        cmp # $17
        bne _21a3
        lsr $7b
        lsr $7b
_2170:                                                                  ;$2170
        lda $2c
        sec 
        sbc $7b
        bcs _21a1
        asl $28
        sec 
        ror $28
        lda $a5
        cmp # $07
        bne _2192
        lda $7b
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

        ldx $a5
        jsr _a7a6
_21a1:                                                                  ;$21A1
        sta $2c
_21a3:                                                                  ;$21A3
        lda $a5
        jsr _36c5
_21a8:                                                                  ;$21A8
        jsr _9a86
_21ab:                                                                  ;$21AB
        ldy # $23
        lda $2c
        sta [ZP_POLYOBJ_ADDR], y
        lda $2d
        bmi _21e2
        lda $28
        bpl _21e5
        and # %00100000
        beq _21e5
        lda $2d
        and # %01000000
        ora PLAYER_LEGAL
        sta PLAYER_LEGAL
        lda $048b
        ora $0482
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
        lda $a5
        bmi _21ee
        jsr _87a4
        bcc _21e2
_21ee:                                                                  ;$21EE
        ldy # $1f
        lda $28
        sta [ZP_POLYOBJ_ADDR], y
        ldx $9d
        inx 
        jmp _202f

        ;-----------------------------------------------------------------------

_21fa:                                                                  ;$21FA
        lda $04c3               ; energy bomb?
        bpl _2207
        asl $04c3
        bmi _2207
        jsr _2367
_2207:                                                                  ;$2207
        lda $a3                 ; move counter?
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
        lda $04c4               ; energy charge rate?
        adc PLAYER_ENERGY
        bcs _2230
        sta PLAYER_ENERGY
_2230:                                                                  ;$2230
        lda $0482
        bne _2277
        
        lda $a3                 ; move counter?
        and # %00011111
        bne _2283
        
        lda $045f
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
        jsr _80ff
        jsr _7c24
_2277:                                                                  ;$2277
        jmp _231c

        ;-----------------------------------------------------------------------

_227a:                                                                  ;$227A
        lda $0482
        bne _2277
        
        lda $a3                 ; move counter?
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
        sty $06f3
        iny 
        jsr _2c4e
        bne _231c
        jsr _2c5c
        bcs _231c
        sbc # $24
        bcc _22b2
        sta ZP_VAR_R
        jsr _9978
        lda ZP_VAR_Q
        sta $06f3
        bne _231c
_22b2:                                                                  ;$22B2
        jmp _87d0

        ;-----------------------------------------------------------------------

_22b5:                                                                  ;$22B5
        cmp # $0f
        bne _22c2
        lda $0480
        beq _231c
        lda # $7b
        bne _2319
_22c2:                                                                  ;$22C2
        cmp # $14
        bne _231c
        lda # $1e
        sta PLAYER_TEMP_CABIN
        lda $045f
        bne _231c
        ldy # $25
        jsr _2c50
        bne _231c
        jsr _2c5c
        eor # %11111111
        adc # $1e
        sta PLAYER_TEMP_CABIN
        bcs _22b2
        cmp # $e0
        bcc _231c
        cmp # $f0
        bcc _2303

        lda # MEM_IO_ONLY
        jsr set_memory_layout
        
        lda VIC_SPRITE_ENABLE
        and # %00000011
        sta VIC_SPRITE_ENABLE
        
        lda # MEM_64K
        jsr set_memory_layout
        
.ifndef OPTION_NOTRUMBLES

        ; divide number of Trumbles™ by 2
        lsr PLAYER_TRUMBLES_HI
        ror PLAYER_TRUMBLES_LO
.endif

_2303:                                                                  ;$2303
        lda $04c2
        beq _231c
        lda $98
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
        lda $0484
        beq _2330
        lda $0487
        cmp # $08
        bcs _2330
        jsr _3cfa
        lda # $00
        sta $0484
_2330:                                                                  ;$2330
        lda $0481
        beq _233a
        jsr _7b64
        beq _2342
_233a:                                                                  ;$233A
        lda $67
        beq _2345
        dec $67
        bne _2345
_2342:                                                                  ;$2342
        jsr _a786
_2345:                                                                  ;$2345
        lda $a0
        bne _2366
        jmp _2a32

;===============================================================================

_234c:                                                                  ;$234C
        jsr get_random_number
        bpl _2366

        tya 
        tax 
        ldy # Hull::_00         ;=$00: "scoop / debris"?
        and [ZP_HULL_ADDR], y
        and # %00001111
_2359:                                                                  ;$2359
        sta $aa
        beq _2366
_235d:                                                                  ;$235D
        lda # $00
        jsr _370a
        dec $aa
        bne _235d
_2366:                                                                  ;$2366
        rts 

_2367:                                                                  ;$2367
;===============================================================================
.export _2367
        lda # $c0
        sta _a8e0

        lda # $00
        sta _a8e6

        rts 

txt_docked_token1B:                                                     ;$2372
;===============================================================================
.export txt_docked_token1B

        ; print some message from msg index $D9(217)+?
        ; ("CURRUTHERS" / "FOSDYKE_SMYTHE" / "FORTESQUE")
        lda # $d9
        bne _2378               ; always branches

txt_docked_token1C:                                                     ;$2376
;===============================================================================
.export txt_docked_token1C

        ; print some message from msg index $DC(220)+?
        lda # $dc
_2378:                                                                  ;$2378
        clc 
        adc PLAYER_GALAXY
        bne print_docked_str    ; always branches
        

_237e:                                                                  ;$237E
        ;=======================================================================
        ; print a message from the message table at `_1a5c` rather than the
        ; standard one (`_0e00`)
        ; 
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
;       A = index of string to print
;
; preserves A, Y & $5B/$5C
; (due to recursion)
;
.export print_docked_str

        pha                     ; preserve A (message index)
        tax                     ; move message index to X
        
        ; when recursing, $5B/$5C+Y represent the
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
.import TXT_DOCKED_XOR:direct

        lda [ZP_TEMP_ADDR3], y
        eor # TXT_DOCKED_XOR    ;=$57 -- descramble token
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
        ; $81-$D6 = ?
        ; $D7-$FF = some pre-defined character pairs ("text_pairs.asm")
        ;
        lda [ZP_TEMP_ADDR3], y  ; read a token
        eor # TXT_DOCKED_XOR    ;=$57 -- descramble token
        beq @rts                ; has message ended? (token $00)

        jsr print_docked_token
        jmp @read_token

@rts:   ; finished printing, clean up and exit                          ;$23C5
        ;-----------------------------------------------------------------------
        pla 
        sta ZP_TEMP_ADDR3_HI
        pla 
        sta ZP_TEMP_ADDR3_LO
        pla 
        tay 
        pla 
        rts

print_docked_token:                                                     ;$23CF
        ;=======================================================================
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

:                                                                       ;$23E8
        ;-----------------------------------------------------------------------
        cmp # 'z'+1             ; letters "A" to "Z"?
       .blt _2404               ; print letters, handling auto-casing

        cmp # $81               ; tokens $5B...$80?
       .blt _2441               ; handle planet description tokens
        
        cmp # $d7               ; tokens $81...$D6 are expansions,
       .blt print_docked_str    ; use the token as a message index
        
        ; tokens $D7 and above:
        ; (character pairs)

.import txt_docked_pair1
.import txt_docked_pair2

        sbc # $d7               ; re-index as $00...$28
        asl                     ; double, for lookup-table
        pha                     ; (put aside)
        tax                     ; use as index to table
        lda txt_docked_pair1, x ; read 1st character and print it

        jsr _2404
        
        pla                     ; get the offset again 
        tax 
        lda txt_docked_pair2, x ; read 2nd character and print it

_2404:  ; print a character                                             ;$2404
        ;-----------------------------------------------------------------------
        
        ; print the punctuation characters ($20...$40), as is

        cmp # '@'+1
       .blt @print
        
        ; shall we change the letter case?
        
        ; check for the upper-case flag: -- note that this will have no effect
        ; if the upper-case mask is not set or if the lower-case mask is set
        ; which takes precedence

        bit txt_ucase_flag      ; check if bit 7 is set
        bmi @ucase              ; if so, skip ahead
        
        ; check for the lower-case flag: -- this will only have an effect if
        ; the lower-case mask is set to remove bit 5

        bit txt_lcase_flag      ; check if bit 7 is set
        bmi @lcase              ; if so, skip ahead

@ucase: ora txt_ucase_mask      ; upper case (if enabled)               ;$2412
        
@lcase: and txt_lcase_mask      ; lower-case (if enabled)               ;$2415

@print: jmp print_char                                                  ;$2418


_format_code:                                                           ;$241B
        ;=======================================================================
        ; tokens $00..$1F are format codes, each has a different behaviour:
        ;
        ;    $00 = invalid
        ;    $01 = ?
        ;    $02 = ?
        ;    $03 = ?
        ;    $04 = ?
        ;    $05 = ?
        ;    $06 = ?
        ;    $07 = ?
        ;    $08 = ?
        ;    $09 = ?
        ;    $0A = ?
        ;    $0B = ?
        ;    $0C = ?
        ;    $0D = ?
        ;    $0E = ?
        ;    $0F = ?
        ;    $10 = ?
        ;    $11 = ?
        ;    $12 = ?
        ;    $13 = set lower-case
        ;    $14 = ?
        ;    $15 = ?
        ;    $16 = ?
        ;    $17 = ?
        ;    $18 = ?
        ;    $19 = ?
        ;    $1A = ?
        ;    $1B = ?
        ;    $1C = ?
        ;    $1D = ?
        ;    $1E = ?
        ;    $1F = ?

        ; snapshot current state:
        ; -- these format codes can get recursive
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 
        
        ; multiply token by two (lookup into table)
        txa 
        asl 
        tax 

        ; note that the lookup table is indexed two-bytes early, making an
        ; index of zero land in some code -- this is why token $00 is invalid

        ; we read an address from the table and rewrite a `jsr` instruction
        ; further down, i.e. the token is a lookup to a routine to call
.import _250c

        lda _250c - 2, x
        sta @jsr + 1
        lda _250c - 1, x
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
        pla 
        tay 
        rts 

_2441:  ; process msg tokens $5B..$80                                   ;$2441
        ;-----------------------------------------------------------------------
        sta ZP_TEMP_ADDR1_LO    ; put token aside
        
        ; put aside our current location in the text data
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; choose planet description template 0-4:

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

.import _3eac

        ; get back the token value and lookup another message index to print
        ; (since these tokens are $5B..$80, we index the table back $5B bytes)
        ldx ZP_TEMP_ADDR1_LO
        adc _3eac - $5B, x

        jsr print_docked_str    ; print the new message

        jmp _2438               ; clean up and exit


txt_docked_token01:                                                     ;$246A
        ;=======================================================================
.export txt_docked_token01

        lda # %00000000

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token02:                                                     ;$246D
        ;=======================================================================
.export txt_docked_token02

        lda # %00100000
        sta txt_ucase_mask

        lda # %00000000
        sta txt_ucase_flag

        rts

txt_docked_token08:                                                     ;$2478
        ;=======================================================================
.export txt_docked_token08

        lda # 6
        jsr set_cursor_col

        lda # %11111111
        sta txt_lcase_flag

        rts 

txt_docked_token09:                                                     ;$2483
        ;=======================================================================
.export txt_docked_token09

        lda # 1
        jsr set_cursor_col

        jmp _a72f

txt_docked_token0D:                                                     ;$248B
        ;=======================================================================
.export txt_docked_token0D
        
        ; enable the change-case flag?
        lda # %10000000
        sta txt_ucase_flag
        
        ; enable upper-casing
        lda # %00100000
        sta txt_ucase_mask

        rts 

txt_docked_token06:                                                     ;$2496
        ;=======================================================================
.export txt_docked_token06
        
        lda # $80
        sta $34
        lda # $ff

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token05:                                                     ;$249D
        ;=======================================================================
.export txt_docked_token05

        lda # %00000000
        sta txt_flight_flag

        rts 

txt_docked_token0E:                                                     ;$24A3
        ;=======================================================================
.export txt_docked_token0E

        lda # %10000000

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token0F:                                                     ;$24A6
        ;=======================================================================
.export txt_docked_token0F
        
        lda # %00000000
        sta txt_buffer_flag
        asl 
        sta txt_buffer_index
        rts 

txt_docked_token11:                                                     ;$24B0
        ;=======================================================================
.export txt_docked_token11

        lda $34
        and # %10111111         ;=$BF
        sta $34

        lda # $03
        jsr print_flight_token
        
        ldx txt_buffer_index
        lda $0647, x
        jsr is_vowel
        bcc _24c9
        dec txt_buffer_index
_24c9:                                                                  ;$24C9
        lda # $99
        jmp print_docked_str

txt_docked_token12:                                                     ;$24CE
        ;=======================================================================
.export txt_docked_token12

        jsr txt_docked_token_set_lowercase

        jsr get_random_number
        and # %00000011
        tay 
_24d7:                                                                  ;$24D7
        jsr get_random_number
        and # %00111110
        tax 

.import _254e

        lda _254e+0, x
        jsr _2404
        
        lda _254e+1, x
        jsr _2404
        
        dey 
        bpl _24d7
        
        rts 

txt_docked_token_set_lowercase:                                         ;$24ED
        ;=======================================================================
.export txt_docked_token_set_lowercase
        
        ; msg token $13
        ;
        lda # %11011111
        sta txt_lcase_mask

        rts 

is_vowel:                                                               ;$24F3
        ;=======================================================================
        ora # %00100000
        cmp # $61               ; 'A'?
        beq _250a
        cmp # $65               ; 'E'?
        beq _250a
        cmp # $69               ; 'I'?
        beq _250a
        cmp # $6f               ; 'O'?
        beq _250a
        cmp # $75               ; 'U'?
        beq _250a
        
        clc 
_250a:  rts                                                             ;$250A

;===============================================================================

_250b:  rts                                                             ;$250B

;===============================================================================

.segment        "DATA_SAVE"

_25a6:                                                                  ;$25A6
.export _25a6
        .byte   $3a, $30, $2e,$45                       ;":0.E"?

; 85 bytes here get copied by `_88f0` to $0490..$04E4

_25aa:                                                                  ;$25AA
.export _25aa
        .byte   $2e                                     ;"."?
_25ab:                                                                  ;$25AB
.export _25ab
        .byte   $6a, $61, $6d, $65, $73, $6f, $6e       ;"jameson"?
_25b2:                                                                  ;$25B2
.export _25b2
        .byte   $0d

_25b3:                                                                  ;$25B3
;-------------------------------------------------------------------------------
.export _25b3
        
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $10, $0f, $11
        .byte   $00, $03, $1c, $0e, $00, $00, $0a, $00
        .byte   $11, $3a, $07, $09, $08, $00, $00, $00
        .byte   $00, $80

_25fd:                                                                  ;$25FD
.export _25fd
        .byte   $00
_25fe:                                                                  ;$25FE
.export _25fe
        .byte   $00
_25ff:                                                                  ;$25FF
.export _25ff
        .byte   $00

;-------------------------------------------------------------------------------

.segment        "DATA_2600"

;$2600: unreferenced / unused data?

        .byte   $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00
        
        .byte   $3a, $30, $2e  ;":0.E."?
        .byte   $45, $2e
_2619:                                                                  ;$2619
.export _2619
        .byte   $4a ,$41, $4d, $45, $53, $4f, $4e, $0d  ;"JAMESON"
        .byte   $00 ,$14, $ad
        
        ; universe seed -- see "elite_consts.asm"
        .byte   ELITE_SEED
        
        .byte   $00, $00, $03, $e8, $46, $00, $00
        .byte   $0f ,$00, $00, $00, $00, $00, $16, $00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00
        .byte   $00 ,$00, $00, $03, $00, $10, $0f, $11
        .byte   $00 ,$03, $1c, $0e, $00, $00, $0a, $00
        .byte   $11 ,$3a, $07, $09, $08, $00, $00, $00
        .byte   $00 ,$80, $aa, $27, $03, $00, $00, $00
        .byte   $00 ,$00, $00, $00, $00, $00, $00, $00
        .byte   $00 ,$00, $00, $00, $00
_267e:                                                                  ;$267E
.export _267e
        .byte   $00, $ff, $ff, $aa, $aa, $aa, $55, $55
        .byte   $55, $aa, $aa, $aa, $aa, $aa, $aa, $55
        .byte   $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
        .byte   $aa, $aa, $aa, $aa, $aa, $5a, $aa, $aa
        .byte   $00, $aa, $00, $00, $00, $00
_26a4:                                                                  ;$26A4
.export _26a4
        .byte   $76, $85, $9c, $a5, $8b, $85, $9a, $a5
        .byte   $8d, $20, $0c, $9a, $b0, $d2, $85, $6f
        .byte   $a5, $9c, $85, $70, $a5, $6b, $85, $9b
        .byte   $a5, $72, $85, $9c, $a5, $85, $85, $9a
        .byte   $a5, $87, $20, $0c, $9a, $b0, $b9, $85
        .byte   $6b, $a5, $9c, $85, $6c, $a5, $6d, $85
        .byte   $9b, $a5, $74, $85, $9c, $a5, $88, $85
        .byte   $9a, $a5, $8a, $20, $0c, $9a, $b0, $a0
        .byte   $85, $6d, $a5, $9c, $85, $6e, $a5, $71
        .byte   $85, $9a, $a5, $6b, $20, $ea, $39, $85
        .byte   $bb, $a5, $72, $45, $6c, $85, $9c, $a5
        .byte   $73, $85, $9a, $a5, $6d, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $74
        .byte   $45, $6e, $20, $0c, $9a, $85, $bb, $a5
        .byte   $75, $85, $9a, $a5, $6f, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $70
        .byte   $45, $76, $20, $0c, $9a, $48, $98, $4a
        .byte   $4a, $aa, $68, $24, $9c, $30, $02, $a9
        .byte   $00, $95, $35, $c8, $c4, $ae, $b0, $fe
        .byte   $4c, $f2, $9b, $a4, $47, $a6, $48, $a5
        .byte   $4b, $85, $47, $a5, $4c, $85, $48, $84
        .byte   $4b, $86, $4c, $a4, $49, $a6, $4a, $a5
        .byte   $51, $85, $49, $a5, $52, $85, $4a, $84
        .byte   $51, $86, $52, $a4, $4f, $a6, $50, $a5
        .byte   $53, $85, $4f, $a5, $54, $85, $50, $84
        .byte   $53, $86, $54, $a0, $08, $b1, $57, $85
        .byte   $ae, $a5, $57, $18, $69, $14, $85, $5b
        .byte   $a5, $58, $69, $00, $85, $5c, $a0, $00
        .byte   $84, $aa, $84, $9f, $b1, $5b, $85, $6b
        .byte   $c8, $b1, $5b, $85, $6d, $c8, $b1, $5b
        .byte   $85, $6f, $c8, $b1, $5b, $85, $bb, $29
        .byte   $1f, $c5, $ad, $90, $fb, $c8, $b1

;===============================================================================

.segment        "CODE_27A3"

_27a3:                                                                  ;$27A3
        .byte   $5b
_27a4:                                                                  ;$27A4
.export _27a4
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
_27ab:  bne _27ab               ; infinite loop, why?                   ;$27AB
        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
_27b6:  bne _27b6               ; infinite loop, why?                   $27B6
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
_27c2:  bne _27c2               ; infinite loop, why?                   ;$27C2
        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
_27cd:  bne _27cd               ; infinite loop, why?                   ;$27CD
        jmp _9d8e               ; SPEED: jump to a jump (`_9f06`)

;===============================================================================

; unreferenced / unused?
;$27D2:
        lda ZP_VAR_T
        sta ZP_VAR_Y
        asl 
        sta ZP_VAR_Y2
        asl 
        sta $70
        jsr _9a2c
        lda ZP_POLYOBJ_XPOS_pt3 ;=$0b
        sta ZP_VAR_X2
        eor $72
_27e5:                                                                  ;$27E5
        bmi _27e5               ; infinite loop, why??
        clc 
        lda $71
        adc ZP_POLYOBJ_XPOS_pt1 ;=$09
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_pt2 ;=$0A
        adc # $00
        sta ZP_VAR_Y
        jmp _9db3               ; SPEED: jump to a jump (`_9dd9`)

;===============================================================================

; unreferenced / unused?
;$27f7:
        lda ZP_POLYOBJ_XPOS_pt1 ;=$09
        sec 
        sbc $71
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_pt2 ;=$0a
        sbc # $00
        sta ZP_VAR_Y
_2804:  bcs _2804               ; infinite loop, why??                  ;$2804
        eor # %11111111
        sta ZP_VAR_Y
        lda # $01
        sbc ZP_VAR_X
        sta ZP_VAR_X
        bcc _2814
        inc ZP_VAR_Y
_2814:                                                                  ;$2814
        lda ZP_VAR_X2
        eor # %10000000
        sta ZP_VAR_X2
        lda ZP_POLYOBJ_YPOS_pt3 ;$0E
        sta $70
        eor $74
_2820:  bmi _2820               ; infinite loop, why??                  ;$2820
        clc 
        lda $73
        adc ZP_POLYOBJ_YPOS_pt1 ;=$0C
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_pt2 ;=$0D
        adc # $00
        sta $6f

        jmp _9dee               ; SPEED: jump to a jump (`_9e16`)

;===============================================================================

; unreferenced / unused?
;$2832:
        lda ZP_POLYOBJ_YPOS_pt1 ;=$0C
        sec 
        sbc $73
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_pt2 ;=$0D
        sbc # $00
        sta $6f
_283f:  bcs _283f               ; infinite loop, why??                  ;$283F
        eor # %11111111
        sta $6f
        lda ZP_VAR_Y2
        eor # %11111111
        adc # $01
        sta ZP_VAR_Y2
        lda $70
        eor # %10000000
        sta $70
_2853:  bcc _2853               ; infinite loop, why??                  ;$2853
        inc $6f
        lda $76
_2859:  bmi _2859               ; inifinite loop, why??                 ;$2859
        lda $75
        clc 
        adc ZP_POLYOBJ_ZPOS_pt1 ;=$0F
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_pt2 ;=$10
        adc # $00
        sta ZP_VAR_U
        jmp _9e27               ; SPEED: jump to a jump (`_9e27`)

;===============================================================================

; unreferenced / unused?
;$286b:
        ldx ZP_VAR_Q
_286d:  beq _286d               ; infinite loop, why??                  ;$286D
        ldx # $00
_2871:                                                                  ;$2871
        lsr 
        inx 
        cmp ZP_VAR_Q
        bcs _2871
        stx ZP_VAR_S
        jsr _99af
        ldx ZP_VAR_S
        lda ZP_VAR_R
_2880:                                                                  ;$2880
        asl 
        rol ZP_VAR_U
_2883:  bmi _2883               ; infinite loop, why??                  ;$2883
        dex 
        bne _2880
        sta ZP_VAR_R
        rts 

;===============================================================================

; unreferenced / unused?
;$288b:
        lda # $32
        sta ZP_VAR_R
        sta ZP_VAR_U
        rts 

;===============================================================================

; unreferenced / unused?
;$2892:
        lda # $80
        sec 
        sbc ZP_VAR_R
        sta $0100, x
        inx 
        lda # $00
        sbc ZP_VAR_U
        sta $0100, x
_28a2:                                                                  ;$28A2
        .byte   $4c             ;=`jmp`
        .byte   $61             ;=$??61


polyobj_addrs:                                                          ;$28A4
;===============================================================================
; a total of 11 3D-objects ("poly-objects") can be 'in-play' at a time,
; each object has a block of runtime storage to keep track of its current
; state including rotation, speed, shield etc. this is a lookup-table of
; addresses for each poly-object slot
;
.export polyobj_addrs
.export polyobj_addrs_lo = polyobj_addrs
.export polyobj_addrs_hi = polyobj_addrs + 1

.import POLYOBJ_00
        .word   POLYOBJ_00
.import POLYOBJ_01
        .word   POLYOBJ_01
.import POLYOBJ_02
        .word   POLYOBJ_02
.import POLYOBJ_03
        .word   POLYOBJ_03
.import POLYOBJ_04
        .word   POLYOBJ_04
.import POLYOBJ_05
        .word   POLYOBJ_05
.import POLYOBJ_06
        .word   POLYOBJ_06
.import POLYOBJ_07
        .word   POLYOBJ_07
.import POLYOBJ_08
        .word   POLYOBJ_08
.import POLYOBJ_09
        .word   POLYOBJ_09
.import POLYOBJ_10
        .word   POLYOBJ_10
        
;===============================================================================

; unused / unreferenced?
;$28BA:

        .byte             $80, $40, $20, $10, $08, $04
        .byte   $02, $01, $80, $40

; unused / unreferenced?
;$28C4:
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03

_28c8:  ; pixel pairs, in single step (for drawing dust)                ;$28C8
        .byte   %11000000       ;=$C0
        .byte   %11000000       ;=$C0
        .byte   %01100000       ;=$60
        .byte   %00110000       ;=$30
        .byte   %00011000       ;=$18
        .byte   %00001100       ;=$0C
        .byte   %00000110       ;=$06
        .byte   %00000011       ;=$03

_28d0:  ; this looks like masks for multi-colour pixels?                ;$28D0
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03
        .byte   %11000000       ;=$C0

;===============================================================================

_28d5:                                                                  ;$28D5
.export _28d5
        lda # $0f
        tax 
        rts 

_28d9:                                                                  ;$28D9
;===============================================================================
.export _28d9

        jsr print_flight_token

txt_docked_token0B:                                                     ;$28DC
;===============================================================================
.export txt_docked_token0B

        lda # $13
        bne _28e5

_28e0:                                                                  ;$28E0
;===============================================================================
.export _28e0

        lda # $17
        jsr cursor_down

_28e5:                                                                  ;$28E5
;===============================================================================
.export _28e5

        sta ZP_VAR_Y
        sta ZP_VAR_Y2
        ldx # $00
        stx ZP_VAR_X
        dex 
        stx ZP_VAR_X2
        jmp _ab91

_28f3:                                                                  ;$28F3
;===============================================================================
.export _28f3

        jsr _811e
        sty ZP_VAR_Y
        lda # $00
        sta $0580, y
        jmp _affa

;===============================================================================

_2900:                                                                  ;$2900
.export _2900
        .byte   %10000000       ;=$80
        .byte   %11000000       ;=$C0
        .byte   %11100000       ;=$E0
        .byte   %11110000       ;=$F0
        .byte   %11111000       ;=$F8
        .byte   %11111100       ;=$FC
        .byte   %11111110       ;=$FE
_2907:                                                                  ;$2907
.export _2907
        .byte   %11111111       ;=$FF
        .byte   %01111111       ;=$7F
        .byte   %00111111       ;=$3F
        .byte   %00011111       ;=$1F
        .byte   %00001111       ;=$0F
        .byte   %00000111       ;=$07
        .byte   %00000011       ;=$03
        .byte   %00000001       ;=$01

;===============================================================================

_290f:                                                                  ;$209F
        jsr _3ad1
        sta $60
        txa 
        sta $06c9, y            ; "dust y-lo"

_2918:                                                                  ;$2918
;===============================================================================
;
;       Y = ?
;   ZP_VAR_X = ?
;   ZP_VAR_Y = ?
;
.export _2918

        lda ZP_VAR_X
        bpl :+
        
        ; swap negative number to positive?
        eor # %01111111
        clc 
        adc # $01

:       eor # %10000000                                                 ;$2921
        tax 
        
        lda ZP_VAR_Y
        and # %01111111
        cmp # ELITE_VIEWPORT_HEIGHT / 2
       .bge _2976

        lda ZP_VAR_Y
        bpl :+
        
        ; flip pos/neg sign
        eor # %01111111
        adc # $01

:       sta ZP_VAR_T                                                    ;$2934
        lda # (ELITE_VIEWPORT_HEIGHT / 2) + 1
        sbc ZP_VAR_T

_293a:                                                                  ;$293A
;===============================================================================
;
;        A = Y-position (px)
;        X = X-position (px)
; ZP_VAR_Z = pixel Z-distance
;
; preserves Y
;
.export _293a

        sty ZP_TEMP_VAR         ; preserve Y through this ordeal

        tay 
        txa 
        
        ; get a bitmap address for a char row:
        
        ; reduce the X-position to a multiple of 8, i.e. a character column
        and # %11111000

        ; add this to the bitmap address for the given row
        clc 
        adc row_to_bitmap_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # $00
        sta ZP_TEMP_ADDR1_HI

        ; get the row within the character cell
        tya 
        and # %00000111         ; modulo 8 (0-7)
        tay 

        ; get the pixel within that row
        txa 
        and # %00000111         ; modulo 8 (0-7)
        tax 
        
        lda ZP_VAR_Z
        cmp # 144               ; is the dust-particle >= 144 Z-distance?
       .bge _296d               
        
        lda _28c8, x            ; get mask for desired pixel-position
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        
        lda ZP_VAR_Z
        cmp # 80                ; is the dust-particle >= 80 Z-distance?
       .bge _2974
        
        dey                     ; move up a pixel-row 
        bpl _296d               ; didn't go off the top of the char?
        
        ldy # $01

_296d:                                                                  ;$296D
        lda _28c8, x
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y

_2974:                                                                  ;$2974
        ldy ZP_TEMP_VAR         ; restore Y
_2976:                                                                  ;$2976
        rts 

;===============================================================================

_2977:                                                                  ;$2977
.export _2977
        txa 
        adc $43
        sta $8b

        lda $44
        adc ZP_VAR_T
        sta $8c
        
        lda $a9
        beq _2998
        inc $a9
_2988:                                                                  ;$2988
        ldy $7e
        lda # $ff
        cmp _27a3, y
        beq _29fa
        sta _27a4, y            ; writing to code??
        inc $7e
        bne _29fa
_2998:                                                                  ;$2998
        lda $85
        sta ZP_VAR_X
        lda $86
        sta ZP_VAR_Y
        lda $87
        sta ZP_VAR_X2
        lda $88
        sta ZP_VAR_Y2
        lda $89
        sta $6f
        lda $8a
        sta $70
        lda $8b
        sta $71
        lda $8c
        sta $72
        jsr _a013
        bcs _2988
        lda $06f4
        beq _29d2
        lda ZP_VAR_X
        ldy ZP_VAR_X2
        sta ZP_VAR_X2
        sty ZP_VAR_X
        lda ZP_VAR_Y
        ldy ZP_VAR_Y2
        sta ZP_VAR_Y2
        sty ZP_VAR_Y
_29d2:                                                                  ;$29D2
        ldy $7e
        lda _27a3, y
        cmp # $ff
        bne _29e6
        lda ZP_VAR_X
        sta _26a4, y
        lda ZP_VAR_Y
        sta _27a4, y            ; writing to code??
        iny 
_29e6:                                                                  ;$2936
        lda ZP_VAR_X2
        sta _26a4, y
        lda ZP_VAR_Y2
        sta _27a4, y            ; writing to code??
        iny 
        sty $7e
        jsr _ab91
        lda $a2
        bne _2988
_29fa:                                                                  ;$29FA
        lda $89
        sta $85
        lda $8a
        sta $86
        lda $8b
        sta $87
        lda $8c
        sta $88
        lda $aa
        clc 
        adc $ac
        sta $aa
        rts 

dust_swap_xy:                                                           ;$2A12
;===============================================================================
.export dust_swap_xy

        ldy DUST_COUNT          ; get number of dust particles

:       ldx DUST_Y, y           ; get dust-particle Y-position          ;$2A15
        lda DUST_X, y           ; get dust-particle X-position
        sta ZP_VAR_Y               ; (put aside X-position)
        sta DUST_Y, y           ; save the Y-value to the X-position
        txa                     ; move the Y-position into A
        sta ZP_VAR_X               ; (put aside Y-value)
        sta DUST_X, y           ; write the X-value to the Y-position
        lda DUST_Z, y           ; get dust z-position
        sta ZP_VAR_Z            ; (put aside Z-position)
        
        jsr _2918

        dey 
        bne :-

        rts 

;===============================================================================

_2a32:                                                                  ;$2A32
        ldx $0486
        beq _2a40
        dex 
        bne _2a3d
        jmp _2b2d

;===============================================================================

_2a3d:                                                                  ;$2A3D
        jmp _37e9

        ;-----------------------------------------------------------------------

_2a40:                                                                  ;$2A40
        ldy DUST_COUNT          ; number of dust particles
_2a43:                                                                  ;$2A43
        jsr _3b30
        lda ZP_VAR_R
        lsr ZP_VAR_P1
        ror 
        lsr ZP_VAR_P1
        ror 
        ora # %00000001
        sta ZP_VAR_Q
        lda $06e3, y
        sbc $97
        sta $06e3, y
        lda DUST_Z, y
        sta ZP_VAR_Z
        sbc $98
        sta DUST_Z, y
        jsr _3992
        sta $60
        lda ZP_VAR_P1
        adc $06c9, y
        sta $5f
        sta ZP_VAR_R
        lda ZP_VAR_Y
        adc $60
        sta $60
        sta ZP_VAR_S
        lda DUST_X, y
        sta ZP_VAR_X
        jsr _3997
        sta $5e
        lda ZP_VAR_P1
        adc $06af, y
        sta $5d
        lda ZP_VAR_X
        adc $5e
        sta $5e
        eor $6a                 ; move count?
        jsr _393c
        jsr _3ad1
        sta $60
        stx $5f
        eor $69                 ; roll sign?
        jsr _3934
        jsr _3ad1
        sta $5e
        stx $5d
        ldx $64
        lda $60
        eor $95
        jsr _393e
        sta ZP_VAR_Q
        jsr _3a4c
        asl ZP_VAR_P1
        rol 
        sta ZP_VAR_T
        lda # $00
        ror 
        ora ZP_VAR_T
        jsr _3ad1
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta ZP_VAR_R
        lda $60
        sta ZP_VAR_S
        lda # $00
        sta ZP_VAR_P1
        lda $63
        eor # %10000000
        jsr _290f
        lda $5e
        sta ZP_VAR_X
        sta DUST_X, y
        and # %01111111
        cmp # $78
        bcs _2b0a
        lda $60
        sta DUST_Y, y
        sta ZP_VAR_Y
        and # %01111111
        cmp # $78
        bcs _2b0a
        lda DUST_Z, y
        cmp # $10
        bcc _2b0a
        sta ZP_VAR_Z
_2b00:                                                                  ;$2B00
        jsr _2918
        dey 
        beq _2b09
        jmp _2a43

_2b09:                                                                  ;$2B09
        rts 

        ;-----------------------------------------------------------------------

_2b0a:                                                                  ;$2B0A
        jsr get_random_number
        ora # %00000100
        sta ZP_VAR_Y
        sta DUST_Y, y

        jsr get_random_number
        ora # %00001000
        sta ZP_VAR_X
        sta DUST_X, y
        
        jsr get_random_number
        ora # %10010000
        sta DUST_Z, y
        sta ZP_VAR_Z
        
        lda ZP_VAR_Y
        jmp _2b00

;===============================================================================

_2b2d:                                                                  ;$2B2D
        ldy DUST_COUNT          ; number of dust particles
_2b30:                                                                  ;$2B30
        jsr _3b30
        lda ZP_VAR_R
        lsr ZP_VAR_P1
        ror 
        lsr ZP_VAR_P1
        ror 
        ora # %00000001
        sta ZP_VAR_Q
        lda DUST_X, y
        sta ZP_VAR_X
        jsr _3997
        sta $5e
        lda $06af, y
        sbc ZP_VAR_P1
        sta $5d
        lda ZP_VAR_X
        sbc $5e
        sta $5e
        jsr _3992
        sta $60
        lda $06c9, y
        sbc ZP_VAR_P1
        sta $5f
        sta ZP_VAR_R
        lda ZP_VAR_Y
        sbc $60
        sta $60
        sta ZP_VAR_S
        lda $06e3, y
        adc $97
        sta $06e3, y
        lda DUST_Z, y
        sta ZP_VAR_Z
        adc $98
        sta DUST_Z, y
        lda $5e
        eor $69                 ; roll sign?
        jsr _393c
        jsr _3ad1
        sta $60
        stx $5f
        eor $6a                 ; move count?
        jsr _3934
        jsr _3ad1
        sta $5e
        stx $5d
        lda $60
        eor $95
        ldx $64
        jsr _393e
        sta ZP_VAR_Q
        lda $5e
        sta ZP_VAR_S
        eor # %10000000
        jsr _3a50
        asl ZP_VAR_P1
        rol 
        sta ZP_VAR_T
        lda # $00
        ror 
        ora ZP_VAR_T
        jsr _3ad1
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta ZP_VAR_R
        lda $60
        sta ZP_VAR_S
        lda # $00
        sta ZP_VAR_P1
        lda $63
        jsr _290f
        lda $5e
        sta ZP_VAR_X
        sta DUST_X, y
        lda $60
        sta DUST_Y, y
        sta ZP_VAR_Y
        and # %01111111
        cmp # $6e
        bcs _2bf7
        lda DUST_Z, y
        cmp # $a0
        bcs _2bf7
        sta ZP_VAR_Z
_2bed:                                                                  ;$2BED
        jsr _2918
        dey 
        beq _2bf6
        jmp _2b30

_2bf6:                                                                  ;$2BF6
        rts 

        ;-----------------------------------------------------------------------

_2bf7:                                                                  ;$2BF7
        jsr get_random_number
        and # %01111111
        adc # $0a
        sta DUST_Z, y
        sta ZP_VAR_Z
        lsr 
        bcs _2c1a
        lsr 
        lda # $fc
        ror 
        sta ZP_VAR_X
        sta DUST_X, y
        jsr get_random_number
        sta ZP_VAR_Y
        sta DUST_Y, y
        jmp _2bed

        ;-----------------------------------------------------------------------

_2c1a:                                                                  ;$2C1A
        jsr get_random_number
        sta ZP_VAR_X
        sta DUST_X, y
        lsr 
        lda # $e6
        ror 
        sta ZP_VAR_Y
        sta DUST_Y, y
        bne _2bed
_2c2d:                                                                  ;$2C2D
        lda ZP_POLYOBJ_XPOS_pt1, y
        asl 
        sta $78
        lda ZP_POLYOBJ_XPOS_pt2, y
        rol 
        sta $79
        lda # $00
        ror 
        sta $7a
        jsr _2d69
        sta ZP_POLYOBJ_XPOS_pt3, x
_2c43:                                                                  ;$2C43
.export _2c43
        ldy $78
        sty ZP_POLYOBJ_XPOS_pt1, x
        ldy $79
        sty ZP_POLYOBJ_XPOS_pt2, x
        and # %01111111
        rts 

;===============================================================================

_2c4e:                                                                  ;$2C4E
.export _2c4e
        lda # $00
_2c50:                                                                  ;$2C50
.export _2c50
.import POLYOBJ_00, PolyObject

        ora POLYOBJ_00 + PolyObject::xpos + 2, y
        ora POLYOBJ_00 + PolyObject::ypos + 2, y
        ora POLYOBJ_00 + PolyObject::zpos + 2, y
        and # %01111111

        rts 

;===============================================================================

_2c5c:                                                                  ;$2C5C
        lda POLYOBJ_00 + PolyObject::xpos + 1, y        ;=$F901
        jsr _3988
        sta ZP_VAR_R

        lda POLYOBJ_00 + PolyObject::ypos + 1, y        ;=$F904
        jsr _3988
        adc ZP_VAR_R
        bcs _2c7a
        sta ZP_VAR_R
        
        lda POLYOBJ_00 + PolyObject::zpos + 1, y        ;=$F907
        jsr _3988
        adc ZP_VAR_R
        bcc _2c7c
_2c7a:                                                                  ;$2C7A
        lda # $ff
_2c7c:                                                                  ;$2C7C
        rts 

;===============================================================================

_2c7d:                                                                  ;$2C7D
.import TXT_DOCKED_DOCKED:direct
        lda # TXT_DOCKED_DOCKED
        jsr print_docked_str

        jsr _b179
        jmp _2cc7

_2c88:                                                                  ;$2C88
        ldx # $09               ; "Elite" status
        cmp #> 6400             ; 25*256 = 6400 kills
       .bge _2cee

        dex                     ; "Deadly" status
        cmp #> 2560             ; 10*256 = 2560 kills
       .bge _2cee

        dex                     ; "Dangerous" status
        cmp #> 512              ; 2*256 = 512 kills
       .bge _2cee

        dex                     ; "Competent" status or below
        bne _2cee
_2c9b:                                                                  ;$2C9B
.export _2c9b
        lda # $08
        jsr _6a2f
        jsr _70ab

        lda # 7
        jsr set_cursor_col
        
        lda # $7e               ; txt token -- status line?
        jsr _28d9
        
        lda # $0f
        ldy $a7
        bne _2c7d
        lda # $e6
        ldy $047f
        ldx $0454, y
        beq _2cc4
        ldy PLAYER_ENERGY
        cpy # $80
        adc # $01
_2cc4:                                                                  ;$2CC4
        jsr _7773
_2cc7:                                                                  ;$2CC7
        lda # $7d
        jsr _6a9b
        lda # $13
        ldy PLAYER_LEGAL
        beq _2cd7
        cpy # $32
        adc # $01
_2cd7:                                                                  ;$2CD7
        jsr _7773

        lda # $10
        jsr _6a9b

        lda PLAYER_KILLS
        bne _2c88
        
        tax 
        lda $04e0
        lsr 
        lsr 
_2cea:                                                                  ;$2CEA
        inx 
        lsr 
        bne _2cea
_2cee:                                                                  ;$2CEE
        txa 
        
        clc 
        adc # $15
        jsr _7773

        lda # $12
        jsr _2d61
        lda $04c7
        beq _2d04
        lda # $70
        jsr _2d61
_2d04:                                                                  ;$2D04
        lda $04c2
        beq _2d0e
        lda # $6f
        jsr _2d61
_2d0e:                                                                  ;$2D0E
        lda $04c1
        beq _2d18
        lda # ZP_VAR_Y
        jsr _2d61
_2d18:                                                                  ;$2D18
        lda # $71
        sta $ad
_2d1c:                                                                  ;$2D1C
        tay 
        ldx $04c3 - $71, y      ; equipment slots?
        beq _2d25
        jsr _2d61
_2d25:                                                                  ;$2D25
        inc $ad
        lda $ad
        cmp # $75
        bcc _2d1c
        ldx # $00
_2d2f:                                                                  ;$2D2F
        stx $aa
        ldy PLAYER_LASERS, x
        beq _2d59
        txa 
        clc 
        adc # $60
        jsr _6a9b
        lda # $67
        ldx $aa
        ldy PLAYER_LASERS, x
        cpy # $8f
        bne _2d4a
        lda # $68
_2d4a:                                                                  ;$2D4A
        cpy # $97
        bne _2d50
        lda # $75
_2d50:                                                                  ;$2D50
        cpy # $32
        bne _2d56
        lda # $76
_2d56:                                                                  ;$2D56
        jsr _2d61
_2d59:                                                                  ;$2D59
        ldx $aa
        inx 
        cpx # $04
        bcc _2d2f
        rts 

;===============================================================================

_2d61:                                                                  ;$2D61
        jsr _7773
        lda # 6
        jmp set_cursor_col

;===============================================================================

_2d69:                                                                  ;$2D69
.export _2d69

        lda $7a
        sta ZP_VAR_S
        and # %10000000
        sta ZP_VAR_T
        eor ZP_POLYOBJ_XPOS_pt3, x
        bmi _2d8d
        lda $78
        clc 
        adc ZP_POLYOBJ_XPOS_pt1, x
        sta $78
        lda $79
        adc ZP_POLYOBJ_XPOS_pt2, x
        sta $79
        lda $7a
        adc ZP_POLYOBJ_XPOS_pt3, x
        and # %01111111
        ora ZP_VAR_T
        sta $7a
        rts 

        ;-----------------------------------------------------------------------

_2d8d:                                                                  ;$2D8D
        lda ZP_VAR_S
        and # %01111111
        sta ZP_VAR_S
        lda ZP_POLYOBJ_XPOS_pt1, x
        sec 
        sbc $78
        sta $78
        lda ZP_POLYOBJ_XPOS_pt2, x
        sbc $79
        sta $79
        lda ZP_POLYOBJ_XPOS_pt3, x
        and # %01111111
        sbc ZP_VAR_S
        ora # %10000000
        eor ZP_VAR_T
        sta $7a
        bcs _2dc4
        lda # $01
        sbc $78
        sta $78
        lda # $00
        sbc $79
        sta $79
        lda # $00
        sbc $7a
        and # %01111111
        ora ZP_VAR_T
        sta $7a
_2dc4:                                                                  ;$2DC4
        rts 

;===============================================================================

_2dc5:                                                                  ;$2DC5
.export _2dc5

        lda ZP_POLYOBJ_XPOS_pt2, x
        and # %01111111
        lsr 
        sta ZP_VAR_T
        lda ZP_POLYOBJ_XPOS_pt1, x
        sec 
        sbc ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_POLYOBJ_XPOS_pt2, x
        sbc # $00
        sta ZP_VAR_S
        lda ZP_POLYOBJ_XPOS_pt1, y
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_XPOS_pt2, y
        and # %10000000
        sta ZP_VAR_T
        lda ZP_POLYOBJ_XPOS_pt2, y
        and # %01111111
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        ora ZP_VAR_T
        eor $b1
        stx ZP_VAR_Q
        jsr _3ad1
        sta $78
        stx $77
        ldx ZP_VAR_Q
        lda ZP_POLYOBJ_XPOS_pt2, y
        and # %01111111
        lsr 
        sta ZP_VAR_T
        lda ZP_POLYOBJ_XPOS_pt1, y
        sec 
        sbc ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_POLYOBJ_XPOS_pt2, y
        sbc # $00
        sta ZP_VAR_S
        lda ZP_POLYOBJ_XPOS_pt1, x
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_XPOS_pt2, x
        and # %10000000
        sta ZP_VAR_T
        lda ZP_POLYOBJ_XPOS_pt2, x
        and # %01111111
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        ora ZP_VAR_T
        eor # %10000000
        eor $b1
        stx ZP_VAR_Q
        jsr _3ad1
        sta ZP_POLYOBJ_XPOS_pt2, y
        stx ZP_POLYOBJ_XPOS_pt1, y
        ldx ZP_VAR_Q
        lda $77
        sta ZP_POLYOBJ_XPOS_pt1, x
        lda $78
        sta ZP_POLYOBJ_XPOS_pt2, x

        rts 

; convert values to strings:
; TODO: this to be its own segment, we WILL want to replace it
;===============================================================================

; the number to be converted:
.exportzp       ZP_VALUE        := $77
.exportzp       ZP_VALUE_pt1    := $77
.exportzp       ZP_VALUE_pt2    := $78
.exportzp       ZP_VALUE_pt3    := $79
.exportzp       ZP_VALUE_pt4    := $7a
.exportzp       ZP_VALUE_OVFLW  := $9c  ; because, why not!?

; working copy of the number:
.exportzp       ZP_VCOPY        := $6b
.exportzp       ZP_VCOPY_pt1    := $6b
.exportzp       ZP_VCOPY_pt2    := $6c
.exportzp       ZP_VCOPY_pt3    := $6d
.exportzp       ZP_VCOPY_pt4    := $6e
.exportzp       ZP_VCOPY_OVFLW  := $6f

.exportzp       ZP_PADDING      := $99
.exportzp       ZP_MAXLEN       := $bb  ; maximum length of string

_max_value:                                                             ;$2E51
        ; maximum value:
        ;
        ; this is the maximum printable value: 100-billion ($17_4876_E800);
        ; note that this lacks the first byte, $17, as that is handled directly
        ; in the code itself
        .byte   $48, $76, $e8, $00

print_tiny_value:                                                       ;$2E55
        ;=======================================================================
        ; print an 8-bit value, given in X, padded to 3 chars
        ;
        ;    X = value to print
        ;
.export print_tiny_value

        ; set the padding to a max. number of digits to 3, i.e. "  0"-"255"
        lda # $03

print_small_value:                                                      ;$2E57
        ;=======================================================================
        ; print an 8-bit value, given in X, with A specifying the number of
        ; characters to pad to
        ;
        ;    X = value to print
        ;    A = width in chars to pad to
        ;
.export print_small_value

        ; strip the hi-byte for what follows; only use X
        ldy # $00

print_medium_value:                                                     ;$2E59
        ;=======================================================================
        ; print a 16-bit value stored in X/Y
        ;
        ;    A = max. no. of expected digits
        ;    X = lo-byte of value
        ;    Y = hi-byte of value
        ;
.export print_medium_value

        sta ZP_PADDING

        ; zero out the upper-bytes of the 32-bit value to print
        lda # $00
        sta ZP_VALUE_pt1
        sta ZP_VALUE_pt2

        ; insert the 16-bit value given
        sty ZP_VALUE_pt3
        stx ZP_VALUE_pt4

print_large_value:                                                      ;$2E65
        ;=======================================================================
        ; print a large value, up to 100-billion
        ;
        ; $77-$7A = numerical value (note: big-endian)
        ;     $99 = max. number of expected digits, i.e. left-pad the number
        ;       c = carry set: use decimal point
        ;
.export print_large_value

        ; set max. text width
        ; i.e. for "100000000000" (100-billion)
        ldx # 11                ; 12 chars
        stx ZP_MAXLEN

        ; keep a copy of the carry-flag
        ; parameter ('use decimal point')
        php 
        bcc :+                  ; skip ahead when carry = 0
        
        ; carry flag is set:
        ; a decimal point will be printed
        dec ZP_MAXLEN           ; one less char available
        dec ZP_PADDING          ; reduce amount of left-padding

:       lda # 11                ; max length of text (12 chars)         ;$2E70
        sec                     ; set carry-flag, see note below
        sta $9f                 ; put original max.length of text aside

        ; subtract the max. number of digits from the max. length of text.
        ; since carry is set, this will underflow (sign-bit) if equal
        sbc ZP_PADDING
        sta ZP_PADDING          ; remainder
        inc ZP_PADDING          ; fix use of carry

        ; clear the overflow byte used during calculations with the value.
        ; note that this is also setting Y to zero
        ldy # $00
        sty ZP_VALUE_OVFLW
        
        jmp _2ec1               ; jump into the main loop
                                ; (below is not a direct follow-on from here)
        
_x10:   ; multiply by 10:                                               ;$2E82
        ;-----------------------------------------------------------------------
        ; since you can't 'just' multiply by 10 in binary, we first multiply
        ; by 2 and put that aside, do a multiply by 8 and then add the two
        ; values together

        ; first, multiply by 2
        asl ZP_VALUE_pt4
        rol ZP_VALUE_pt3
        rol ZP_VALUE_pt2
        rol ZP_VALUE_pt1
        rol ZP_VALUE_OVFLW      ; catch any overflow

        ; make a copy of our 2x value
        ldx # 3                 ; numerical value is 4-bytes long (0..3)
:       lda ZP_VALUE, x                                                 ;$2E8E
        sta ZP_VCOPY, x
        dex 
        bpl :-
        
        lda ZP_VALUE_OVFLW      ; copy the overflow value
        sta ZP_VCOPY_OVFLW      ; to the 2x value copy too

        ; multiply again by 2
        ; (i.e. 4x original value)
        asl ZP_VALUE_pt4
        rol ZP_VALUE_pt3
        rol ZP_VALUE_pt2
        rol ZP_VALUE_pt1
        rol ZP_VALUE_OVFLW
        ; multiply again by 2;
        ; (i.e. 8x original value)
        asl ZP_VALUE_pt4
        rol ZP_VALUE_pt3
        rol ZP_VALUE_pt2
        rol ZP_VALUE_pt1
        rol ZP_VALUE_OVFLW
        clc 

        ; add our 2x value to our 8x value:

        ldx # 3                 ; numerical value is 4-bytes long (0..3)
:       lda ZP_VALUE, x         ; load x2 byte                          ;$2EB0
        adc ZP_VCOPY, x         ; add to x8 byte
        sta ZP_VALUE, x         ; write the value back
        dex 
        bpl :-

        ; add the overflow bytes together
        lda ZP_VCOPY_OVFLW
        adc ZP_VALUE_OVFLW
        sta ZP_VALUE_OVFLW

        ldy # 0

_2ec1:  ;                                                               ;$2EC1
        ;-----------------------------------------------------------------------
        ldx # 3                 ; numerical value is 4-bytes long (0..3)

       .clb                     ; clear the borrow before subtracting
:       lda ZP_VALUE, x         ; read a byte from the numerical value  ;$2EC4
        sbc _max_value, x       ; subtract against '100-billion'
        sta ZP_VCOPY, x         ; store the result separately
        dex 
        bpl :-

        ; and then the 5th byte separately
        lda ZP_VALUE_OVFLW
        sbc # $17               ; this is the $17 in '$17_4876_E800',
                                ; i.e. 100-billion decimal
        sta ZP_VCOPY_OVFLW

        ; no matter what I do I can't grasp what is happening with the bits
        ; to spit out decimal digits here 
       .bbw _print_digit

        ldx # 3                 ; numerical value is 4-bytes long (0..3)
:       lda ZP_VCOPY, x                                                 ;$2ED8
        sta ZP_VALUE, x
        dex 
        bpl :-

        lda ZP_VCOPY_OVFLW
        sta ZP_VALUE_OVFLW

        iny 
        jmp _2ec1

_print_digit:                                                           ;$2EE7 
        ;-----------------------------------------------------------------------
        ; is there a digit waiting to be printed?
        ; (when we first enter this routine, Y will be zero)
        tya 
       .bnz @ascii
        
        lda ZP_MAXLEN
       .bze @ascii

        dec ZP_PADDING
        bpl _2f00               

        lda # ' '               ; print leading white-space
        bne @print              ; skip over the next bit (always branches)

@ascii: ; convert value 0-9 to ASCII/PETSCII character                  ;$2EF6
        
        ldy # $00
        sty ZP_MAXLEN
        
        clc 
        adc # '0'               ; re-base as an ASCII/PETSCII numeral

@print: jsr print_char                                                  ;$2EFD        

_2f00:
        dec ZP_MAXLEN
        bpl _2f06
        inc ZP_MAXLEN
_2f06:
        dec $9f
        bmi @rts
        bne :+

        ; are we printing a decimal point?
        plp                     ; get the original carry-flag parameter
        bcc :+                  ; carry clear skips printing decimal point

        ; carry set: print the decimal point
        lda # '.'
        jsr print_char

        ; handle the next decimal digit...
:       jmp _x10                                                        ;$2F14

@rts:   rts                                                             ;$2F17 

;===============================================================================
; a block of text-printing related flags and variables

txt_ucase_mask:                                                         ;$2F18
        ; a mask for converting a character A-Z to upper-case.
        ; this byte gets changed to 0 to neuter the effect
        .byte   %00100000

txt_lcase_flag:                                                         ;$2F19
.export txt_lcase_flag
        
        .byte   %11111111

txt_flight_flag:                                                        ;$2F1A
        .byte   %00000000

txt_buffer_flag:                                                        ;$2F1B
.export txt_buffer_flag

        .byte   %00000000

txt_buffer_index:                                                       ;$2F1C
.export txt_buffer_index
        
        .byte   $00

txt_ucase_flag:                                                         ;$2F1D
        .byte   %00000000

txt_lcase_mask:                                                         ;$2F1E
        ; this byte is used to lower-case charcters, it's ANDed with the
        ; character value -- therefore its default value $FF does nothing.
        ; this byte is changed to %11011111 to enable lower-casing, which
        ; removes bit 5 ($20) from characters, e.g. $61 "A" > $41 "a"
        .byte   %11111111


print_crlf:                                                             ;$2F1F
;===============================================================================
; 'print' a new-line character. i.e. move to the next row, starting column
;
.export print_crlf

        lda # $0c

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token10:                                                     ;$2F22
;===============================================================================
; print "A"!?
;
.export txt_docked_token10

        lda # 'a'


print_char:                                                             ;$2F24
;===============================================================================
; prints an ASCII character to screen (eventually). note that this routine can
; buffer output to produce effects like text-justification. the actual routine
; that copies pixels to screen is `paint_char`, but this routine is the one
; the text-handling works with
;
;       A = ASCII code
;
.export print_char

; TODO: this to be defined structurally at some point
TXT_BUFFER = $0648              ; $0648..$06A2? -- 3 lines

        ; put X parameter aside,
        ; we need the X register for now
        stx ZP_TEMP_ADDR1_LO

        ; disable the automatic lower-case transformation
        ldx # %11111111
        stx txt_lcase_mask
        
        ; check for characters that aren't cased

        cmp # '.'
        beq :+
        
        cmp # ':'
        beq :+
        
        cmp # $0a               ;?
        beq :+
        
        cmp # $0c               ;?
        beq :+
        
        cmp # ' '
        beq :+

        ; X is $FF for all characters, except ".", ":", $0A, $0C & space,
        ; otherwise $00 -- some kind of flag?
        inx 

:       stx txt_lcase_flag                                              ;$24F0

        ; get back the original X value
        ldx ZP_TEMP_ADDR1_LO

        ; check 'use buffer' flag
        bit txt_buffer_flag     ; check if bit 7 is set
        bmi _add_to_buffer      ; yes? switch to buffered printing

        ; no buffer, print character as-is
        jmp paint_char
        

_add_to_buffer:                                                         ;$2F4D
        ;=======================================================================
        ; a flag to ignore line-breaks?
        bit txt_buffer_flag     ; check bit 6
        bvs :+                  ; skip if bit 6 set

        cmp # $0c               ; new-line character?
        beq _flush_buffer       ; flush buffer

:       ldx txt_buffer_index                                            ;$2F56
        sta TXT_BUFFER, x       ; add the character to the buffer
        
        ldx ZP_TEMP_ADDR1_LO
        inc txt_buffer_index

        clc 
        rts 

_flush_buffer:                                                          ;$2F63
        ;=======================================================================
        ; flush the text buffer to screen
        ;
        
        ; backup X & Y registers:
       .phx                     ; push X to stack (via A)
       .phy                     ; push Y to stack (via A)

_flush_line:                                                            ;$2F67
        ;-----------------------------------------------------------------------
        ldx txt_buffer_index    ; get current buffer index
       .bze _exit               ; if buffer is empty, exit

        ; does the buffer need to be justified?

        cpx # 31                ; is the buffer <= 30 chars?
       .blt _print_all          ; if so, the buffer is one line, print as-is

        ; there is more than one line to print, ergo all but the last line
        ; must be justified -- insert extra spaces until the text reaches
        ; the full length of the line

        ; since we must insert spaces evenly between words, a 'space-counter'
        ; is used to ensure that we ignore an increasing number of spaces
        ; so that new spaces are added further and further down the line,
        ; providing even distribution

        ; for speed optimisation, the space-counter is implemented as
        ; a 'walking bit', a single bit in a byte that is shifted along
        ; at each step. when the bit falls off the end it gets reset

        ; the space-counter begins at bit 6; this is so that the first
        ; space encountered triggers justification

        ; note that whatever the value of $08 prior to calling this routine,
        ; shifting it right once will ensure that the 'minus' check below will
        ; always fail, so $08 will be 'reset' to %01000000 for this routine
        lsr ZP_TEMP_ADDR1_HI

_justify_line:                                                          ;$2F72
        ;-----------------------------------------------------------------------
        lda ZP_TEMP_ADDR1_HI    ; check the space-counter
        bmi :+                  

        lda # %01000000         ; reset space-counter
        sta ZP_TEMP_ADDR1_HI    ; to its starting position

        ; begin at the end of the line and walk backwards through it:
:       ldy # 29                                                        ;$2F7A

@justify:                                                               ;$2F7C
        ;-----------------------------------------------------------------------
        ; is the justification complete?
        lda TXT_BUFFER + 30     ; check the last char in the line
        cmp # ' '               ; is it a space?
        beq @print_line         ; if so, skip ahead to printing the line

@find_spc:                                                              ;$2F83
        dey                     ; step back through the line-length     
        bmi _justify_line       ; catch underflow? max buffer length is 90
        beq _justify_line       ; hit the start of the line? go again

        lda TXT_BUFFER, y       ; read character from buffer
        cmp # ' '               ; is it a space?
        bne @find_spc           ; not a space, keep going
        
        ; space found:
        asl ZP_TEMP_ADDR1_HI    ; move the space-counter along
        bmi @find_spc           ; if it's hit the end, we ignore this space
                                ; and look for the next one
        
        ; remember the current position,
        ; i.e. where the space is
        sty ZP_TEMP_ADDR1_LO

        ; insert another space, pushing everything forward
        ; (increase the spacing between two words)
        ldy txt_buffer_index
:       lda TXT_BUFFER, y                                               ;$2F98
        sta TXT_BUFFER+1, y
        dey 
        cpy ZP_TEMP_ADDR1_LO
       .bge :-

        ; given the space we added, increase the text-buffer length by 1
        inc txt_buffer_index

:       cmp TXT_BUFFER, y                                               ;$2FA6
        bne @justify
        dey 
        bpl :-
        bmi _justify_line

@print_line:                                                            ;$2FB0
        ; a line is already 30-chars long, or has
        ; been justified to the same, print it
        ldx # 30
        jsr _print_chars

        ; move to the next line
        lda # $0c
        jsr paint_char
        
        lda txt_buffer_index
        sbc # 30
        sta txt_buffer_index
        tax 
        beq _exit
        ldy # $00
        inx 

        ; downshift the buffer, moving lines 2+, down to line 1 since the 
        ; routine here only works with the start of the buffer

:       lda TXT_BUFFER + 30 + 1, y                                      ;$2FC8
        sta TXT_BUFFER, y
        iny 
        dex 
       .bnz :-

        ; go back and process the remaining buffer
       .bze _flush_line         ; always branches!

_print_chars:                                                           ;$2FD4
        ;=======================================================================
        ; print X number of characters in the buffer to the screen
        ;
        ;       X = length of string to print from the buffer
        ;
        ldy # $00               ; begin at index 0
:       lda TXT_BUFFER, y       ; read a character from the buffer      ;$2FD6
        jsr paint_char          ; paint it to screen
        iny                     ; move to the next character
        dex                     ; reduce number of remaining characters
        bne :-                  ; keep looping if some remain

_2fe0:  rts                                                             ;$2FE0

_print_all:                                                             ;$2FE1
        ;=======================================================================
        jsr _print_chars

_exit:  stx txt_buffer_index    ; save remaining buffer length          ;$2FE4

        ; restore state
        pla 
        tay 
        pla 
        tax 

        ; 'paint' a carriage return, which will move the cursor accordingly
        lda # $0c
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

_2fee:                                                                  ;$2FEE
        ;=======================================================================
        ; the BBC code says that char 7 is a beep
.export _2fee
        
        lda # $07               ; BEEP?
        jmp paint_char

;===============================================================================
; BBC code says this is "update displayed dials"

_2ff3:                                                                  ;$2FF3
.export _2ff3

        lda #< $5770
        sta ZP_TEMP_ADDR1_LO
        lda #> $5770
        sta ZP_TEMP_ADDR1_HI
        
        jsr _30bb
        stx $78
        sta $77
        
        lda # $0e               ; threshold to change colour?
        sta ZP_TEMP_VAR
        
        lda $96                 ; player's ship speed?
        jsr hud_drawbar_32
        
        lda # $00
        sta ZP_VAR_R
        sta ZP_VAR_P1
        
        lda # $08
        sta ZP_VAR_S
        
        lda $68                 ; roll magnitude?
        lsr 
        lsr 
        ora $69                 ; roll sign?
        eor # %10000000
        jsr _3ad1
        jsr _3130
        lda $63
        ldx $64
        beq _302b
        sbc # $01
_302b:                                                                  ;$302B
        jsr _3ad1
        jsr _3130
        
        lda $a3                 ; move counter?
        and # %00000011
        bne _2fe0
        
        ldy # $00
        jsr _30bb
        stx $77
        sta $78

        ldx # $03               ; 4 energy banks
        stx ZP_TEMP_VAR
_3044:                                                                  ;$3044
        sty $71, x
        dex 
        bpl _3044

        ldx # $03
        lda PLAYER_ENERGY
        lsr 
        lsr 
        sta ZP_VAR_Q
_3052:                                                                  ;$3052
        sec 
        sbc # $10
        bcc _3064
        sta ZP_VAR_Q
        lda # $10
        sta $71, x
        lda ZP_VAR_Q
        dex 
        bpl _3052
        bmi _3068
_3064:                                                                  ;$3064
        lda ZP_VAR_Q
        sta $71, x
_3068:                                                                  ;$3068
        lda $0071, y
        sty ZP_VAR_P1
        jsr hud_drawbar
        ldy ZP_VAR_P1
        iny 
        cpy # $04
        bne _3068
        lda #< $56b0
        sta ZP_TEMP_ADDR1_LO
        lda #> $56b0
        sta ZP_TEMP_ADDR1_HI
        lda # $aa
        sta $77
        sta $78

        lda PLAYER_SHIELD_FRONT
        jsr hud_drawbar_128
        
        lda PLAYER_SHIELD_REAR
        jsr hud_drawbar_128

        lda PLAYER_FUEL
        jsr hud_drawbar_64

        jsr _30bb
        stx $78
        sta $77
        ldx # $0b
        stx ZP_TEMP_VAR

        lda PLAYER_TEMP_CABIN
        jsr hud_drawbar_128
        
        lda PLAYER_TEMP_LASER
        jsr hud_drawbar_128

        lda # $f0
        sta ZP_TEMP_VAR

        lda $06f3
        jsr hud_drawbar_128
        
        jmp _7b6f

;===============================================================================

_30bb:                                                                  ;$30BB
        ldx # $aa

        lda $a3                 ; move counter?
        and # %00001000
        and _1d09
        beq :+

        txa 

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit 
:       lda # $55                                                       ;$30C8
        rts 

;===============================================================================

hud_drawbar_128:                                                        ;$30CB
        ;-----------------------------------------------------------------------
        ; divide value by 8 before drawing the bar:
        ; (accounting for the `lsr`s below)
        ;
        ;       A = value to represent on the bar, 0-127
        ;
        lsr 
        lsr 

hud_drawbar_64:                                                         ;$3C0D
        ;-----------------------------------------------------------------------
        ; divide value by 4 before drawing the bar:
        ; (accounting for the `lsr` below)
        ;
        ;       A = value to represent on the bar, 0-63
        lsr

hud_drawbar_32:                                                         ;$30CE
        ;-----------------------------------------------------------------------
        ; divide balue by 2 before drawing the bar:
        ; 
        ;       A = value to represent on the bar, 0-31
        ;
        lsr 

hud_drawbar:                                                            ;$30CF
        ;-----------------------------------------------------------------------
        ;
        ;       A = value to represent on the bar, 0-15
        ;
        sta ZP_VAR_Q            ; "bar value 1-15"

        ldx # %11111111         ; mask?
        stx ZP_VAR_R
        cmp ZP_TEMP_VAR         ; "threshold to change colour"
        bcs :+
        
        lda $78
        bne :++                 ;SPEED: could use `.bit` here?

:       lda $77                                                         ;$30DD

:       sta $32                 ; colour to use                         ;$30DF

        ldy # $02               ; "height offset"
        ldx # $03               ; "height of bar - 1"

_30e5:                                                                  ;$30E5
        lda ZP_VAR_Q            ; get bar value 0-15
        
        ; subtract 4 if >= 4?
        cmp # $04
       .blt _3109

        sbc # $04
        sta ZP_VAR_Q

        lda ZP_VAR_R            ; mask
_30f1:                                                                  ;$30F1
        and $32
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        tya 
        clc 
        adc # $06
        bcc _3103
        inc ZP_TEMP_ADDR1_HI
_3103:                                                                  ;$3103
        tay 
        dex 
        bmi _next_row
        bpl _30e5
_3109:                                                                  ;$3109
        eor # %00000011
        sta ZP_VAR_Q
        lda ZP_VAR_R
_310f:                                                                  ;$310F
        asl 
        asl 
        dec ZP_VAR_Q
        bpl _310f
        pha 
        lda #> $63
        sta ZP_VAR_R
        lda #< $63
        sta ZP_VAR_Q
        pla 
        jmp _30f1

        
_next_row:                                                              ;$3122
        ;-----------------------------------------------------------------------
        ; move to the next row in the bitmap:
        ; -- i.e. add 320-px to the bitmap pointer

        lda ZP_TEMP_ADDR1_LO
        clc 
        adc #< 320
        sta ZP_TEMP_ADDR1_LO

        lda ZP_TEMP_ADDR1_HI
        adc #> 320
        sta ZP_TEMP_ADDR1_HI
        
        rts 

;===============================================================================

_3130:                                                                  ;$3130
        ldy # $01
        sta ZP_VAR_Q
_3134:                                                                  ;$3134
        sec 
        lda ZP_VAR_Q
        sbc # $04
        bcs _3149
        lda # $ff
        ldx ZP_VAR_Q
        sta ZP_VAR_Q
        lda _28d0, x
        and # %10101010
        jmp _314d
_3149:                                                                  ;$3149
        sta ZP_VAR_Q
        lda # $00
_314d:                                                                  ;$314D
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        tya 
        clc 
        adc # $05
        tay 
        cpy # $1e
        bcc _3134
        lda ZP_TEMP_ADDR1_LO
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
        rts 

;===============================================================================

_316e:                                                                  ;$316E
        jsr _83df
        ldx # $0b
        stx $a5
        jsr _3680
        bcs _317f
        ldx # $18
        jsr _3680
_317f:                                                                  ;$317F
        lda # $08
        sta ZP_POLYOBJ_VERTX_LO
        
        lda # $c2
        sta $27
        lsr 
        sta $29
_318a:                                                                  ;$318A
        jsr _a2a0
        jsr _9a86
        dec $29
        bne _318a
        jsr _b410
        lda # $00
        ldx # $10
_319b:                                                                  ;$319B
        sta $04b0, x            ; cargo qty?
        dex 
        bpl _319b
        sta PLAYER_LEGAL
        sta $04c7
        
.ifndef OPTION_NOTRUMBLES

        ; does the player have any Trumbles™?
        lda PLAYER_TRUMBLES_LO
        ora PLAYER_TRUMBLES_HI
        beq _31be               ; no Trumbles™; skip
        
        ; cull the number of Trumbles™
        jsr get_random_number
        and # %00000111         ; select a range of 0-7
        ora # %00000001         ; restrict to 1, 3, 5 or 7
        sta PLAYER_TRUMBLES_LO
        lda # $00
        sta PLAYER_TRUMBLES_HI
.endif

_31be:                                                                  ;$31BE
        lda # $46
        sta PLAYER_FUEL
        jmp _2101

;===============================================================================

_31c6:                                                                  ;$31C6
.export _31c6

        lda # $0e
        jsr print_docked_str

        jsr _6f82
        jsr _70a0
        lda # $00
        sta $ae
_31d5:                                                                  ;$31D5
        jsr txt_docked_token0E
        jsr _76e9

        ldx txt_buffer_index
        lda ZP_POLYOBJ_YPOS_pt3, x      ;=$0E?
        cmp # $0d
        bne _31f1
_31e4:                                                                  ;$31E4
        dex 
        lda ZP_POLYOBJ_YPOS_pt3, x      ;=$0E?
        ora # %00100000
        cmp $0648, x
        beq _31e4
        txa 
        bmi _3208
_31f1:                                                                  ;$31F1
        jsr _6a3b
        inc $ae
        bne _31d5
        jsr _70ab
        jsr _6f82
        ldy # $06
        jsr _a858

        lda # $d7
        jmp print_docked_str

        ;-----------------------------------------------------------------------

_3208:                                                                  ;$3208
        lda ZP_SEED_pt4
        sta TSYSTEM_POS_X
        lda ZP_SEED_pt2
        sta TSYSTEM_POS_Y
        jsr _70ab
        jsr _6f82
        jsr txt_docked_token0F
        jmp _877e

;===============================================================================

_321e:                                                                  ;$321E
        lda ZP_POLYOBJ_XPOS_pt1 ;=$09
        ora ZP_POLYOBJ_YPOS_pt1 ;=$0C
        ora ZP_POLYOBJ_ZPOS_pt1 ;=$0F
        bne _322b

        lda # $50
        jsr _7bd2
_322b:                                                                  ;$322B
        ldx # $04
        bne _3290
_322f:                                                                  ;$322F
        lda # $00
        jsr _87b1
        beq _3239
        jmp _3365

        ;-----------------------------------------------------------------------

_3239:                                                                  ;$3239
        jsr _3293
        jsr _a813
        lda # $fa
        jmp _7bd2

        ;-----------------------------------------------------------------------

_3244:                                                                  ;$3244
        lda $67
        bne _321e
        lda $29
        asl 
        bmi _322f
        
        lsr 
        tax 
        lda polyobj_addrs_lo, x
        sta ZP_TEMP_ADDR3_LO
        lda polyobj_addrs_hi, x
        jsr _3581

        lda ZP_POLYOBJ01_XPOS_pt3
        ora ZP_POLYOBJ01_YPOS_pt3
        ora ZP_POLYOBJ01_ZPOS_pt3
        and # %01111111
        ora ZP_POLYOBJ01_XPOS_pt2
        ora ZP_POLYOBJ01_YPOS_pt2
        ora ZP_POLYOBJ01_ZPOS_pt2
        bne _3299
        lda $29
        cmp # $82
        beq _321e
        ldy # $1f
        lda [ZP_TEMP_ADDR3], y
        ; this might be a `ldy # $32`, but I don't see any jump into it
        bit _32a0+1             ;!?
        bne _327d
        ora # %10000000
        sta [ZP_TEMP_ADDR3], y
_327d:                                                                  ;$327D
        lda ZP_POLYOBJ_XPOS_pt1 ;=$09
        ora ZP_POLYOBJ_YPOS_pt1 ;=$0C
        ora ZP_POLYOBJ_ZPOS_pt1 ;=$0F
        bne _328a

        lda # $50
        jsr _7bd2
_328a:                                                                  ;$328A
        lda $29
        and # %01111111
        lsr 
        tax 
_3290:                                                                  ;$3290
        jsr _a7a6
_3293:                                                                  ;$3293
        asl $28
        sec 
        ror $28
_3298:                                                                  ;$3298
        rts 

        ;-----------------------------------------------------------------------

_3299:                                                                  ;$3299
        jsr get_random_number
        cmp # $10
        bcs _32a7
_32a0:                                                                  ;$32A0
        ldy # $20
        lda [ZP_TEMP_ADDR3], y
        lsr 
        bcs _32aa
_32a7:                                                                  ;$32A7
        jmp _336e

_32aa:                                                                  ;$32AA
        jmp _b0f4

;===============================================================================

_32ad:                                                                  ;$32AD
.export _32ad

        lda #< $0403
        sta $b0
        lda #> $0403
        sta $b1
        lda # $16
        sta $ab
        cpx # $01
        beq _3244
        cpx # $02
        bne _32ef
        lda $2d
        and # %00000100
        bne _32da
        lda $0467
        bne _3298
        jsr get_random_number
        cmp # $fd
        bcc _3298
        and # %00000001
        adc # $08
        tax 
        bne _32ea
_32da:                                                                  ;$32DA
        jsr get_random_number
        cmp # $f0
        bcc _3298
        lda $046d
        cmp # $04
        bcs _3328
        ldx # $10
_32ea:                                                                  ;$32EA
        lda # $f1
        jmp _370a

        ;-----------------------------------------------------------------------

_32ef:                                                                  ;$32EF
        cpx # $0f
        bne _330f
        jsr get_random_number
        cmp # $c8
        bcc _3328
        ldx # $00
        stx $29
        ldx # $24
        stx $2d
        and # %00000011
        adc # $11
        tax 
        jsr _32ea
        lda # $00
        sta $29
        rts 

        ;-----------------------------------------------------------------------

_330f:                                                                  ;$330F
        ldy # Hull::energy      ;=$0E: energy
        lda $2c
        cmp [ZP_HULL_ADDR], y
        bcs _3319
        inc $2c
_3319:                                                                  ;$3319
        cpx # $1e
        bne _3329

        lda $047a
        bne _3329
        
        lsr $29
        asl $29
        lsr ZP_POLYOBJ_VERTX_LO
_3328:                                                                  ;$3328
        rts 

        ;-----------------------------------------------------------------------

_3329:                                                                  ;$3329
        jsr get_random_number
        lda $2d
        lsr 
        bcc _3335
        cpx # $32
        bcs _3328
_3335:                                                                  ;$3335
        lsr 
        bcc _3347
        ldx PLAYER_LEGAL
        cpx # $28
        bcc _3347
        lda $2d
        ora # %00000100
        sta $2d
        lsr 
        lsr 
_3347:                                                                  ;$3347
        lsr 
        bcs _3357
        lsr 
        lsr 
        bcc _3351
        jmp _34bc

        ;-----------------------------------------------------------------------

_3351:                                                                  ;$3351
        jsr _8c7b
        jmp _34ac

        ;-----------------------------------------------------------------------

_3357:                                                                  ;$3357
        lsr 
        bcc _3365
        lda $045f
        beq _3365
        lda $29
        and # %10000001
        sta $29
_3365:                                                                  ;$3365
        ldx # $08
_3367:                                                                  ;$3367
        lda ZP_POLYOBJ_XPOS_pt1, x
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex 
        bpl _3367
_336e:                                                                  ;$336E
        jsr _8c8a
        ldy # $0a
        jsr _3ab2
        sta $aa
        lda $a5
        cmp # $01
        bne _3381
        jmp _344b

        ;-----------------------------------------------------------------------

_3381:                                                                  ;$3381
        cmp # $0e
        bne _339a
_3385:                                                                  ;$3385
.export _3385

        jsr get_random_number
        cmp # $c8
        bcc _339a
        jsr get_random_number
        ldx # $17
        cmp # $64
        bcs _3397
        ldx # $11
_3397:                                                                  ;$3397
        jmp _32ea

        ;-----------------------------------------------------------------------

_339a:                                                                  ;$339A
        jsr get_random_number
        cmp # $fa
        bcc _33a8
        jsr get_random_number
        ora # %01101000
        sta $26
_33a8:                                                                  ;$33A8
        ldy # Hull::energy      ;=$0E: energy
        lda [ZP_HULL_ADDR], y
        lsr 
        cmp $2c
        bcc _33fd
        lsr 
        lsr 
        cmp $2c
        bcc _33d6
        jsr get_random_number
        cmp # $e6
        bcc _33d6
        ldx $a5
        lda $d042 - 1, x        ;TODO: why is this less one?
        bpl _33d6
        lda $2d
        and # %11110000
        sta $2d
        ldy # $24
        sta [ZP_POLYOBJ_ADDR], y
        lda # $00
        sta $29
        jmp _3706

        ;-----------------------------------------------------------------------

_33d6:                                                                  ;$33D6
        lda $28
        and # %00000111
        beq _33fd
        sta ZP_VAR_T
        jsr get_random_number
        and # %00011111
        cmp ZP_VAR_T
        bcs _33fd
        lda $67
        bne _33fd
        dec $28
        lda $a5
        cmp # $1d
        bne _33fa
        ldx # $1e
        lda $29
        jmp _370a

        ;-----------------------------------------------------------------------

_33fa:                                                                  ;$33FA
        jmp _a795

        ;-----------------------------------------------------------------------

_33fd:                                                                  ;$33FD
        lda # $00
        jsr _87b1
        and # %11100000
        bne _3434
        ldx $aa
        cpx # $a0
        bcc _3434

        ldy # Hull::_13         ;=$13: "laser / missile count"?
        lda [ZP_HULL_ADDR], y
        and # %11111000
        beq _3434
        
        lda $28
        ora # %01000000
        sta $28
        cpx # $a3                 ; move counter?
        bcc _3434

        lda [ZP_HULL_ADDR], y
        lsr 
        jsr _7bd2
        dec ZP_POLYOBJ_VERTX_HI
        lda $67
        bne _3499
        ldy # $01
        jsr _a858
        ldy # $0f
        jmp _a858

        ;-----------------------------------------------------------------------

_3434:                                                                  ;$3434
        lda ZP_POLYOBJ_ZPOS_pt2 ;=$10
        cmp # $03
        bcs _3442
        lda ZP_POLYOBJ_XPOS_pt2 ;=$0A
        ora ZP_POLYOBJ_YPOS_pt2 ;=$0D
        and # %11111110
        beq _3454
_3442:                                                                  ;$3442
        jsr get_random_number
        ora # %10000000
        cmp $29
        bcs _3454
_344b:                                                                  ;$344B
        jsr _35d5
        lda $aa
        eor # %10000000
_3452:                                                                  ;$3452
        sta $aa
_3454:                                                                  ;$3454
        ldy # $10
        jsr _3ab2
        tax 
        eor # %10000000
        and # %10000000
        sta $27
        txa 
        asl 
        cmp $b1
        bcc _346c
        lda $b0
        ora $27
        sta $27
_346c:                                                                  ;$346C
        lda $26
        asl 
        cmp # $20
        bcs _348d
        ldy # $16
        jsr _3ab2
        tax 
        eor $27
        and # %10000000
        eor # %10000000
        sta $26
        txa 
        asl 
        cmp $b1
        bcc _348d
        lda $b0
        ora $26
        sta $26
_348d:                                                                  ;$348D
        lda $aa
        bmi _349a
        cmp $ab
        bcc _349a
        lda #> $0300            ; processed vertex data is stored at $0300+
        sta ZP_POLYOBJ_VERTX_HI
_3499:                                                                  ;$3499
        rts 

        ;-----------------------------------------------------------------------

_349a:                                                                  ;$349A
        and # %01111111
        cmp # $12
        bcc _34ab

        lda # $ff
        ldx $a5
        cpx # $01
        bne _34a9
        
        asl 
_34a9:                                                                  ;$34A9
        sta ZP_POLYOBJ_VERTX_HI
_34ab:                                                                  ;$34AB
        rts 

        ;-----------------------------------------------------------------------

_34ac:                                                                  ;$34AC
        ldy # $0a
        jsr _3ab2
        cmp # $98
        bcc _34b9
        ldx # $00
        stx $b1
_34b9:                                                                  ;$24B9
        jmp _3452

;===============================================================================

_34bc:                                                                  ;$34BC
.export _34bc

        lda # $06
        sta $b1
        lsr 
        sta $b0
        lda # $1d
        sta $ab
        lda $045f
        bne _34cf
_34cc:                                                                  ;$34CC
        jmp _3351

        ;-----------------------------------------------------------------------

_34cf:                                                                  ;$34CF
        jsr _357b
        lda ZP_POLYOBJ01_XPOS_pt3
        ora ZP_POLYOBJ01_YPOS_pt3
        ora ZP_POLYOBJ01_ZPOS_pt3
        and # %01111111
        bne _34cc
        jsr _8cad
        lda ZP_VAR_Q
        sta $77
        jsr _8c8a
        ldy # $0a
        jsr _35b3
        bmi _3512
        cmp # $23
        bcc _3512
        ldy # $0a
        jsr _3ab2
        cmp # $a2
        bcs _352c
        lda $77
        cmp # $9d
        bcc _3504
        lda $a5
        bmi _352c
_3504:                                                                  ;$3504
        jsr _35d5
        jsr _34ac
_350a:                                                                  ;$350A
        ldx # $00
        stx ZP_POLYOBJ_VERTX_HI
        inx 
        stx ZP_POLYOBJ_VERTX_LO

        rts 

        ;-----------------------------------------------------------------------

_3512:                                                                  ;$3512
        jsr _357b
        jsr _35e8
        jsr _35e8
        jsr _8c8a
        jsr _35d5
        jmp _34ac

        ;-----------------------------------------------------------------------

_3524:                                                                  ;$3524
        inc ZP_POLYOBJ_VERTX_HI
        lda # $7f
        sta $26
        bne _3571
_352c:                                                                  ;$352C
        ldx # $00
        stx $b1
        stx $27
        lda $a5
        bpl _3556
        eor ZP_VAR_X
        eor ZP_VAR_Y
        asl 
        lda # $02
        ror 
        sta $26
        lda ZP_VAR_X
        asl 
        cmp # $0c
        bcs _350a
        lda ZP_VAR_Y
        asl 
        lda # $02
        ror 
        sta $27
        lda ZP_VAR_Y
        asl 
        cmp # $0c
        bcs _350a
_3556:                                                                  ;$3556
        stx $26
        lda ZP_POLYOBJ_M2x0_HI
        sta ZP_VAR_X
        lda ZP_POLYOBJ_M2x1_HI
        sta ZP_VAR_Y
        lda ZP_POLYOBJ_M2x2_HI
        sta ZP_VAR_X2
        ldy # $10
        jsr _35b3
        asl 
        cmp # $42
        bcs _3524
        jsr _350a
_3571:                                                                  ;$3571
        lda $3f                 ; only use, ever. does not get set!
        bne _357a

        asl $2d
        sec 
        ror $2d
_357a:                                                                  ;$357A
        rts 

;===============================================================================

_357b:                                                                  ;$357B
        lda #< POLYOBJ_01       ;=$F925
        sta ZP_TEMP_ADDR3_LO
        lda #> POLYOBJ_01       ;=$F925
_3581:  sta ZP_TEMP_ADDR3_HI                                            ;$3581

        ldy # $02
        jsr _358f

        ldy # $05
        jsr _358f
        
        ldy # $08
_358f:                                                                  ;$358F
        lda [ZP_TEMP_ADDR3], y
        eor # %10000000
        sta $7a

        dey 
        lda [ZP_TEMP_ADDR3], y
        sta $79
        
        dey 
        lda [ZP_TEMP_ADDR3], y
        sta $78
        
        sty ZP_VAR_U
        ldx ZP_VAR_U
        jsr _2d69
        
        ldy ZP_VAR_U
        sta ZP_POLYOBJ01_XPOS_pt3, x
        lda $79
        sta ZP_POLYOBJ01_XPOS_pt2, x
        lda $78
        sta ZP_POLYOBJ01_XPOS_pt1, x
        rts 

;===============================================================================

_35b3:                                                                  ;$35B3
        ldx POLYOBJ_01 + PolyObject::xpos + 0, y        ;=$F925
        stx ZP_VAR_Q
        lda ZP_VAR_X
        jsr _3aa8
        ldx POLYOBJ_01 + PolyObject::xpos + 2, y        ;=$F927
        stx ZP_VAR_Q
        lda ZP_VAR_Y
        jsr _3ace
        sta ZP_VAR_S
        stx ZP_VAR_R
        ldx POLYOBJ_01 + PolyObject::ypos + 1, y        ;=$F929
        stx ZP_VAR_Q
        lda ZP_VAR_X2
        jmp _3ace

;===============================================================================

_35d5:                                                                  ;$35D5
        lda ZP_VAR_X
        eor # %10000000
        sta ZP_VAR_X
        lda ZP_VAR_Y
        eor # %10000000
        sta ZP_VAR_Y
        lda ZP_VAR_X2
        eor # %10000000
        sta ZP_VAR_X2
        rts 

;===============================================================================

_35e8:                                                                  ;$35E8
        jsr _35eb
_35eb:                                                                  ;$35EB
        lda POLYOBJ_01 + PolyObject::m0x0 + 1   ;=$F92F
        ldx # $00
        jsr _3600
        lda POLYOBJ_01 + PolyObject::m0x1 + 1   ;=$F931
        ldx # $03
        jsr _3600
        lda POLYOBJ_01 + PolyObject::m0x2 + 1   ;=$F933
        ldx # $06
_3600:                                                                  ;$3600
        asl 
        sta ZP_VAR_R
        lda # $00
        ror 
        eor # %10000000
        eor ZP_POLYOBJ01_XPOS_pt3, x
        bmi _3617
        lda ZP_VAR_R
        adc ZP_POLYOBJ01_XPOS_pt1, x
        sta ZP_POLYOBJ01_XPOS_pt1, x
        bcc _3616
        inc ZP_POLYOBJ01_XPOS_pt2, x
_3616:                                                                  ;$3616
        rts 

        ;-----------------------------------------------------------------------

_3617:                                                                  ;$3617
        lda ZP_POLYOBJ01_XPOS_pt1, x
        sec 
        sbc ZP_VAR_R
        sta ZP_POLYOBJ01_XPOS_pt1, x
        lda ZP_POLYOBJ01_XPOS_pt2, x
        sbc # $00
        sta ZP_POLYOBJ01_XPOS_pt2, x
        bcs _3616
        lda ZP_POLYOBJ01_XPOS_pt1, x
        eor # %11111111
        adc # $01
        sta ZP_POLYOBJ01_XPOS_pt1, x
        lda ZP_POLYOBJ01_XPOS_pt2, x
        eor # %11111111
        adc # $00
        sta ZP_POLYOBJ01_XPOS_pt2, x
        lda ZP_POLYOBJ01_XPOS_pt3, x
        eor # %10000000
        sta ZP_POLYOBJ01_XPOS_pt3, x
        jmp _3616

;===============================================================================

_363f:                                                                  ;$363F
        clc 
        lda ZP_POLYOBJ_ZPOS_pt3
        bne _367d

        lda $a5
        bmi _367d
        
        lda $28
        and # %00100000
        ora ZP_POLYOBJ_XPOS_pt2
        ora ZP_POLYOBJ_YPOS_pt2
        bne _367d
        
        lda ZP_POLYOBJ_XPOS_pt1
        jsr _3988
        sta ZP_VAR_S
        
        lda ZP_VAR_P1
        sta ZP_VAR_R
        
        lda ZP_POLYOBJ_YPOS_pt1
        jsr _3988
        
        tax 
        lda ZP_VAR_P1
        adc ZP_VAR_R
        sta ZP_VAR_R
        txa 
        adc ZP_VAR_S
        bcs _367e
        sta ZP_VAR_S
        ldy # Hull::_0102 + 1   ;=$02: "missile lock area" hi-byte?
        lda [ZP_HULL_ADDR], y
        cmp ZP_VAR_S
        bne _367d
        dey                     ;=$01: "missile lock area" lo-byte?
        lda [ZP_HULL_ADDR], y
        cmp ZP_VAR_R
_367d:                                                                  ;$367D
        rts 

        ;-----------------------------------------------------------------------

_367e:                                                                  ;$367E
        clc 
        rts 

;===============================================================================

_3680:                                                                  ;$3680
        jsr _8447
        lda # $1c
        sta ZP_POLYOBJ_YPOS_pt1
        lsr 
        sta ZP_POLYOBJ_ZPOS_pt1
        lda # $80
        sta ZP_POLYOBJ_YPOS_pt3
        lda $7c
        asl 
        ora # %10000000
        sta $29

_3695:                                                                  ;$3695
.export _3695

        lda # $60
        sta ZP_POLYOBJ_M0x2_HI
        ora # %10000000
        sta ZP_POLYOBJ_M2x0_HI

        lda $96                 ; player's ship speed?
        rol 
        sta ZP_POLYOBJ_VERTX_LO
        
        txa 
        jmp _7c6b

;===============================================================================

_36a6:                                                                  ;$36A6
        ldx # $01
        jsr _3680
        bcc _3701
        
        ldx $7c                 ; missile target?
        jsr get_polyobj

        lda $0452, x            ; ship slots?
        jsr _36c5

        ldy # $b7
        jsr _7d0c
        
        dec PLAYER_MISSILES
        
        ldy # $04
        jmp _a858

;===============================================================================

_36c5:                                                                  ;$36C5
        cmp # $02
        beq _36f8
        ldy # $24
        lda [ZP_POLYOBJ_ADDR], y
        and # %00100000
        beq _36d4
        jsr _36f8
_36d4:                                                                  ;$36D4
        ldy # $20
        lda [ZP_POLYOBJ_ADDR], y
        beq _367d
        ora # %10000000
        sta [ZP_POLYOBJ_ADDR], y
        ldy # $1c
        lda # $02
        sta [ZP_POLYOBJ_ADDR], y
        asl 
        ldy # $1e
        sta [ZP_POLYOBJ_ADDR], y
        lda $a5
        cmp # $0b
        bcc _36f7
        ldy # $24
        lda [ZP_POLYOBJ_ADDR], y
        ora # %00000100
        sta [ZP_POLYOBJ_ADDR], y
_36f7:                                                                  ;$36F7
        rts 

        ;-----------------------------------------------------------------------

_36f8:                                                                  ;$36F8
        ; last byte of `POLYOBJ_01`?
        lda POLYOBJ_01 + PolyObject::ai_state   ;=$F949
        ora # %00000100
        sta POLYOBJ_01 + PolyObject::ai_state   ;=$F949
        rts 

_3701:                                                                  ;$3701
        lda # $c9
        jmp _900d

;===============================================================================

_3706:                                                                  ;$3706
        ldx # $03
_3708:                                                                  ;$3708
.export _3708

        lda # $fe
_370a:                                                                  ;$370A
        sta ZP_TEMP_VAR
       .phx                     ; push X to stack (via A)
        lda ZP_HULL_ADDR_LO
        pha 
        lda ZP_HULL_ADDR_HI
        pha 
        lda ZP_POLYOBJ_ADDR_LO
        pha 
        lda ZP_POLYOBJ_ADDR_HI
        pha 
        ldy # $24
_371c:                                                                  ;$371C
        lda ZP_POLYOBJ_XPOS_pt1, y
        sta $0100, y            ; the stack!?
        lda [ZP_POLYOBJ_ADDR], y
        sta ZP_POLYOBJ_XPOS_pt1, y
        dey 
        bpl _371c
        lda $a5
        cmp # $02
        bne _374d
       .phx                     ; push X to stack (via A)
        lda # $20
        sta ZP_POLYOBJ_VERTX_LO
        ldx # $00
        lda ZP_POLYOBJ_M0x0_HI
        jsr _378c
        ldx # $03
        lda ZP_POLYOBJ_M0x1_HI
        jsr _378c
        ldx # $06
        lda ZP_POLYOBJ_M0x2_HI
        jsr _378c
        pla 
        tax 
_374d:                                                                  ;$374D
        lda ZP_TEMP_VAR
        sta $29
        lsr $26
        asl $26
        txa 
        cmp # $09
        bcs _3770
        cmp # $04
        bcc _3770
        pha 
        jsr get_random_number
        asl 
        sta $27
        txa 
        and # %00001111
        sta ZP_POLYOBJ_VERTX_LO
        lda # $ff
        ror 
        sta $26
        pla 
_3770:                                                                  ;$3770
        jsr _7c6b
        pla 
        sta ZP_POLYOBJ_ADDR_HI
        pla 
        sta ZP_POLYOBJ_ADDR_LO
        ldx # $24
_377b:                                                                  ;$377B
        lda $0100, x
        sta ZP_POLYOBJ_XPOS_pt1, x
        dex 
        bpl _377b
        pla 
        sta ZP_HULL_ADDR_HI
        pla 
        sta ZP_HULL_ADDR_LO
        pla 
        tax 
        rts 

;===============================================================================

_378c:                                                                  ;$378C
        asl 
        sta ZP_VAR_R
        lda # $00
        ror 
        jmp _a44c

_3795:                                                                  ;$3795
.export _3795

        jsr _a839
        lda # $04
        jsr _37a5
        rts 

;===============================================================================

_379e:                                                                  ;$397E
.export _379e

        ldy # $04
        jsr _a858
        lda # $08
_37a5:                                                                  ;$37A5
        sta $ac
        lda $a0
        pha 
        lda # $00
        jsr _a72f
        pla 
        sta $a0

_37b2:                                                                  ;$37B2
.export _37b2

        ldx # $80
        stx ZP_POLYOBJ01_XPOS_pt1

        ldx # $48               ;TODO: half viewport height?
        stx $43
        
        ldx # $00
        stx $ad
        stx ZP_POLYOBJ01_XPOS_pt2
        stx $44
_37c2:                                                                  ;$37C2
        jsr _37ce
        inc $ad
        ldx $ad
        cpx # $08
        bne _37c2
        rts 

;===============================================================================

_37ce:                                                                  ;$37CE
        lda $ad
        and # %00000111
        clc 
        adc # $08
        sta $77
_37d7:                                                                  ;$37D7
        lda # $01
        sta $7e
        jsr _805e
        asl $77
        bcs _37e8
        lda $77
        cmp # $a0
        bcc _37d7
_37e8:                                                                  ;$37E8
        rts 

;===============================================================================

_37e9:                                                                  ;$37E9
        lda # $00
        cpx # $02
        ror 
        sta $b0
        eor # %10000000
        sta $b1
        jsr _38a3
        ldy DUST_COUNT          ; number of dust particles
_37fa:                                                                  ;$37FA
        lda DUST_Z, y
        sta ZP_VAR_Z
        lsr 
        lsr 
        lsr 
        jsr _3b33
        lda ZP_VAR_P1
        sta $ba
        eor $b1
        sta ZP_VAR_S
        lda $06af, y
        sta ZP_VAR_P1
        lda DUST_X, y
        sta ZP_VAR_X
        jsr _3ad1
        sta ZP_VAR_S
        stx ZP_VAR_R
        lda DUST_Y, y
        sta ZP_VAR_Y
        eor $94
        ldx $64
        jsr _393e
        jsr _3ad1
        stx $5d
        sta $5e
        ldx $06c9, y
        stx ZP_VAR_R
        ldx ZP_VAR_Y
        stx ZP_VAR_S
        ldx $64
        eor $95
        jsr _393e
        jsr _3ad1
        stx $5f
        sta $60
        ldx $68                 ; roll magnitude?
        eor $69                 ; roll sign?
        jsr _393e
        sta ZP_VAR_Q
        lda $5d
        sta ZP_VAR_R
        lda $5e
        sta ZP_VAR_S
        eor # %10000000
        jsr _3ace
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta ZP_VAR_R
        lda $60
        sta ZP_VAR_S
        jsr _3ace
        sta ZP_VAR_S
        stx ZP_VAR_R
        lda # $00
        sta ZP_VAR_P1
        lda $a6
        jsr _290f
        lda $5e
        sta DUST_X, y
        sta ZP_VAR_X
        and # %01111111
        eor # %01111111
        cmp $ba
        bcc _38be
        beq _38be
        lda $60
        sta DUST_Y, y
        sta ZP_VAR_Y
        and # %01111111
_3895:                                                                  ;$3895
.export _3895

        cmp # $74
        bcs _38d1
_389a:                                                                  ;$389A
        jsr _2918
        dey 
        beq _38a3
        jmp _37fa

        ;-----------------------------------------------------------------------

_38a3:                                                                  ;$38A3
        lda $a6
        eor $b0
        sta $a6
        lda $69                 ; roll sign?
        eor $b0
        sta $69                 ; roll sign?
        eor # %10000000
        sta $6a                 ; move count?
        lda $94
        eor $b0
        sta $94
        eor # %10000000
        sta $95
        rts 

        ;-----------------------------------------------------------------------

_38be:                                                                  ;$38BE
        jsr get_random_number
        sta ZP_VAR_Y
        sta DUST_Y, y
        lda # $73
        ora $b0
        sta ZP_VAR_X
        sta DUST_X, y
        bne _38e2
_38d1:                                                                  ;$38D1
        jsr get_random_number
        sta ZP_VAR_X
        sta DUST_X, y
        lda # $6e
        ora $6a                 ; move count?
        sta ZP_VAR_Y
        sta DUST_Y, y
_38e2:                                                                  ;$38E2
        jsr get_random_number
        ora # %00001000
        sta ZP_VAR_Z
        sta DUST_Z, y
        bne _389a
_38ee:                                                                  ;$38EE
        sta $77
        sta $78
        sta $79
        sta $7a
        clc 
        rts 

        ;-----------------------------------------------------------------------

_38f8:                                                                  ;$38F8
.export _38f8

        sta ZP_VAR_R
        and # %01111111
        sta $79
        lda ZP_VAR_Q
        and # %01111111
        beq _38ee
        sec 
        sbc # $01
        sta ZP_VAR_T
        lda ZP_VAR_P2
        lsr $79
        ror 
        sta $78
        lda ZP_VAR_P1
        ror 
        sta $77
        lda # $00
        ldx # $18
_3919:                                                                  ;$3919
        bcc _391d
        adc ZP_VAR_T
_391d:                                                                  ;$391D
        ror 
        ror $79
        ror $78
        ror $77
        dex 
        bne _3919
        sta ZP_VAR_T
        lda ZP_VAR_R
        eor ZP_VAR_Q
        and # %10000000
        ora ZP_VAR_T
        sta $7a
        rts 

;===============================================================================

_3934:                                                                  ;$3934
        ldx $5d
        stx ZP_VAR_R
        ldx $5e
        stx ZP_VAR_S
_393c:                                                                  ;$393C
        ldx $68                 ; roll magnitude?
_393e:                                                                  ;$393E
        stx ZP_VAR_P1
        tax 
        and # %10000000
        sta ZP_VAR_T
        txa 
        and # %01111111
        beq _3981
        tax 
        dex 
        stx ZP_TEMP_VAR
        lda # $00
        lsr ZP_VAR_P1
        bcc _3956
        adc ZP_TEMP_VAR
_3956:                                                                  ;$3956
        ror 
        ror ZP_VAR_P1
        bcc _395d
        adc ZP_TEMP_VAR
_395d:                                                                  ;$395D
        ror 
        ror ZP_VAR_P1
        bcc _3964
        adc ZP_TEMP_VAR
_3964:                                                                  ;$3964
        ror 
        ror ZP_VAR_P1
        bcc _396b
        adc ZP_TEMP_VAR
_396b:                                                                  ;$396B
        ror 
        ror ZP_VAR_P1
        bcc _3972
        adc ZP_TEMP_VAR
_3972:                                                                  ;$3972
        ror 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        ora ZP_VAR_T
        rts 

        ;-----------------------------------------------------------------------

_3981:                                                                  ;$3981
        sta ZP_VAR_P2
        sta ZP_VAR_P1
        rts 

;===============================================================================

_3986:                                                                  ;$3986
.export _3986

        and # %01111111
_3988:                                                                  ;$3988
.export _3988

        sta ZP_VAR_P1
        tax 
        bne _399f
_398d:                                                                  ;$398D
        clc 
        stx ZP_VAR_P1
        txa 
        rts 

        ;-----------------------------------------------------------------------

_3992:                                                                  ;$3992
        lda DUST_Y, y
        sta ZP_VAR_Y
_3997:                                                                  ;$3997
        and # %01111111
        sta ZP_VAR_P1
_399b:                                                                  ;$399B
.export _399b

        ldx ZP_VAR_Q
        beq _398d
_399f:                                                                  ;$399F
        dex 
        stx ZP_VAR_T
        lda # $00
        tax 
        lsr ZP_VAR_P1
        bcc _39ab
        adc ZP_VAR_T
_39ab:                                                                  ;$39AB
        ror 
        ror ZP_VAR_P1
        bcc _39b2
        adc ZP_VAR_T
_39b2:                                                                  ;$39B2
        ror 
        ror ZP_VAR_P1
        bcc _39b9
        adc ZP_VAR_T
_39b9:                                                                  ;$39B9
        ror 
        ror ZP_VAR_P1
        bcc _39c0
        adc ZP_VAR_T
_39c0:                                                                  ;$39C0
        ror 
        ror ZP_VAR_P1
        bcc _39c7
        adc ZP_VAR_T
_39c7:                                                                  ;$39C7
        ror 
        ror ZP_VAR_P1
        bcc _39ce
        adc ZP_VAR_T
_39ce:                                                                  ;$39CE
        ror 
        ror ZP_VAR_P1
        bcc _39d5
        adc ZP_VAR_T
_39d5:                                                                  ;$39D5
        ror 
        ror ZP_VAR_P1
        bcc _39dc
        adc ZP_VAR_T
_39dc:                                                                  ;$39DC
        ror 
        ror ZP_VAR_P1
        rts 

;===============================================================================

_39e0:                                                                  ;$39E0
.export _39e0

        and # %00011111
        tax 
        lda _0ac0, x
        sta ZP_VAR_Q
        lda $77
_39ea:                                                                  ;$39EA
.export _39ea

        stx ZP_VAR_P1
        sta $b6
        tax 
        beq _3a1d
        lda _9400, x
        ldx ZP_VAR_Q
        beq _3a20
        clc 
        adc _9400, x
        bmi _3a0f
        lda _9300, x
        ldx $b6
        adc _9300, x
        bcc _3a20
        tax 
        lda _9500, x
        ldx ZP_VAR_P1
        rts 

        ;-----------------------------------------------------------------------

_3a0f:                                                                  ;$3A0F
        lda _9300, x
        ldx $b6
        adc _9300, x
        bcc _3a20
        tax 
        lda _9600, x
_3a1d:                                                                  ;$3A1D
        ldx ZP_VAR_P1
        rts 

        ;-----------------------------------------------------------------------

_3a20:                                                                  ;$3A20
        lda # $00
        ldx ZP_VAR_P1
        rts 

;===============================================================================

_3a25:                                                                  ;$3A25
.export _3a25

        stx ZP_VAR_Q
_3a27:                                                                  ;$3A27
.export _3a27

        eor # %11111111
        lsr 
        sta ZP_VAR_P2
        lda # $00
        ldx # $10
        ror ZP_VAR_P1
_3a32:                                                                  ;$3A32
        bcs _3a3f
        adc ZP_VAR_Q
        ror 
        ror ZP_VAR_P2
        ror ZP_VAR_P1
        dex 
        bne _3a32
        rts 

        ;-----------------------------------------------------------------------

_3a3f:                                                                  ;$3A3F
        lsr 
        ror ZP_VAR_P2
        ror ZP_VAR_P1
        dex 
        bne _3a32
        rts 

;===============================================================================

; unused / unreferenced?
;$3a48
        ldx $68                 ; roll magnitude?
        stx ZP_VAR_P1
_3a4c:                                                                  ;$3A4C
        ldx $5e
        stx ZP_VAR_S
_3a50:                                                                  ;$3A50
        ldx $5d
        stx ZP_VAR_R
_3a54:                                                                  ;$3A54
        tax 
        and # %01111111
        lsr 
        sta ZP_VAR_P1
        txa 
        eor ZP_VAR_Q
        and # %10000000
        sta ZP_VAR_T
        lda ZP_VAR_Q
        and # %01111111
        beq _3aa5
        tax 
        dex 
        stx ZP_TEMP_VAR
        lda # $00
        tax 
        bcc _3a72
        adc ZP_TEMP_VAR
_3a72:                                                                  ;$3A72
        ror 
        ror ZP_VAR_P1
        bcc _3a79
        adc ZP_TEMP_VAR
_3a79:                                                                  ;$3A79
        ror 
        ror ZP_VAR_P1
        bcc _3a80
        adc ZP_TEMP_VAR
_3a80:                                                                  ;$3A80
        ror 
        ror ZP_VAR_P1
        bcc _3a87
        adc ZP_TEMP_VAR
_3a87:                                                                  ;$3A87
        ror 
        ror ZP_VAR_P1
        bcc _3a8e
        adc ZP_TEMP_VAR
_3a8e:                                                                  ;$3A8E
        ror 
        ror ZP_VAR_P1
        bcc _3a95
        adc ZP_TEMP_VAR
_3a95:                                                                  ;$3A95
        ror 
        ror ZP_VAR_P1
        bcc _3a9c
        adc ZP_TEMP_VAR
_3a9c:                                                                  ;$3A9C
        ror 
        ror ZP_VAR_P1
        lsr 
        ror ZP_VAR_P1
        ora ZP_VAR_T
        rts 

_3aa5:                                                                  ;$3AA5
        sta ZP_VAR_P1
        rts 

;===============================================================================

_3aa8:                                                                  ;$3AA8
.export _3aa8

        jsr _3a54
        sta ZP_VAR_S
        lda ZP_VAR_P1
        sta ZP_VAR_R
        rts 

;===============================================================================

_3ab2:                                                                  ;$3AB2
        ldx ZP_POLYOBJ_XPOS_pt1, y
        stx ZP_VAR_Q
        lda ZP_VAR_X
        jsr _3aa8
        ldx ZP_POLYOBJ_XPOS_pt3, y
        stx ZP_VAR_Q
        lda ZP_VAR_Y
        jsr _3ace
        sta ZP_VAR_S
        stx ZP_VAR_R
        ldx ZP_POLYOBJ_YPOS_pt2, y
        stx ZP_VAR_Q
        lda ZP_VAR_X2
_3ace:                                                                  ;$3ACE
.export _3ace

        jsr _3a54
_3ad1:                                                                  ;$3AD1
.export _3ad1

        sta ZP_TEMP_VAR
        and # %10000000
        sta ZP_VAR_T
        eor ZP_VAR_S
        bmi _3ae8
        lda ZP_VAR_R
        clc 
        adc ZP_VAR_P1
        tax 
        lda ZP_VAR_S
        adc ZP_TEMP_VAR
        ora ZP_VAR_T
        rts 

        ;-----------------------------------------------------------------------

_3ae8:                                                                  ;$3AE8
        lda ZP_VAR_S
        and # %01111111
        sta ZP_VAR_U
        lda ZP_VAR_P1
        sec 
        sbc ZP_VAR_R
        tax 
        lda ZP_TEMP_VAR
        and # %01111111
        sbc ZP_VAR_U
        bcs _3b0a
        sta ZP_VAR_U
        txa 
        eor # %11111111
        adc # $01
        tax 
        lda # $00
        sbc ZP_VAR_U
        ora # %10000000
_3b0a:                                                                  ;$3B0A
        eor ZP_VAR_T
        rts 

;===============================================================================

_3b0d:                                                                  ;$3B0D
.export _3b0d

        stx ZP_VAR_Q
        eor # %10000000
        jsr _3ace
        tax 
        and # %10000000
        sta ZP_VAR_T
        txa 
        and # %01111111
        ldx # $fe
        stx ZP_TEMP_VAR
_3b20:                                                                  ;$3B20
        asl 
        cmp # $60
        bcc _3b27
        sbc # $60
_3b27:                                                                  ;$3B27
        rol ZP_TEMP_VAR
        bcs _3b20
        lda ZP_TEMP_VAR
        ora ZP_VAR_T
        rts 

;===============================================================================

_3b30:                                                                  ;$3B30
        lda DUST_Z, y
_3b33:                                                                  ;$3B33
        sta ZP_VAR_Q

        lda $96                 ; player's ship speed?
_3b37:                                                                  ;$3B37
.export _3b37

        asl 
        sta ZP_VAR_P1
        
        lda # $00
        rol 
        cmp ZP_VAR_Q
        bcc _3b43
        
        sbc ZP_VAR_Q
_3b43:                                                                  ;$3B43
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b4c
        sbc ZP_VAR_Q
_3b4c:                                                                  ;$3B4C
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b55
        sbc ZP_VAR_Q
_3b55:                                                                  ;$3B55
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b5e
        sbc ZP_VAR_Q
_3b5e:                                                                  ;$3B5E
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b67
        sbc ZP_VAR_Q
_3b67:                                                                  ;$3B67
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b70
        sbc ZP_VAR_Q
_3b70:                                                                  ;$3B70
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b79
        sbc ZP_VAR_Q
_3b79:                                                                  ;$3B79
        rol ZP_VAR_P1
        rol 
        cmp ZP_VAR_Q
        bcc _3b82
        sbc ZP_VAR_Q
_3b82:                                                                  ;$3B82
        rol ZP_VAR_P1
        ldx # $00
        sta $b6
        tax 
        beq _3ba6
        lda _9400, x
        ldx ZP_VAR_Q
        sec 
        sbc _9400, x
        bmi _3bae
        ldx $b6
        lda _9300, x
        ldx ZP_VAR_Q
        sbc _9300, x
        bcs _3ba9
        tax 
        lda _9500, x
_3ba6:                                                                  ;$3BA6
        sta ZP_VAR_R
        rts 
        
        ;-----------------------------------------------------------------------

_3ba9:                                                                  ;$3BA9
        lda # $ff
        sta ZP_VAR_R
        rts 

        ;-----------------------------------------------------------------------

_3bae:                                                                  ;$3ABE
        ldx $b6
        lda _9300, x
        ldx ZP_VAR_Q
        sbc _9300, x
        bcs _3ba9
        tax 
        lda _9600, x
        sta ZP_VAR_R
        rts 

;===============================================================================

_3bc1:                                                                  ;$3BC1
.export _3bc1

        sta ZP_VAR_P3
        lda ZP_POLYOBJ_ZPOS_pt1
        ora # %00000001
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_ZPOS_pt2
        sta ZP_VAR_R
        lda ZP_POLYOBJ_ZPOS_pt3
        sta ZP_VAR_S
        lda ZP_VAR_P1
        ora # %00000001
        sta ZP_VAR_P1
        lda ZP_VAR_P3
        eor ZP_VAR_S
        and # %10000000
        sta ZP_VAR_T
        ldy # $00
        lda ZP_VAR_P3
        and # %01111111
_3be5:                                                                  ;$3BE5
        cmp # $40
        bcs _3bf1
        asl ZP_VAR_P1
        rol ZP_VAR_P2
        rol 
        iny 
        bne _3be5
_3bf1:                                                                  ;$3BF1
        sta ZP_VAR_P3
        lda ZP_VAR_S
        and # %01111111
_3bf7:                                                                  ;$3BF7
        dey 
        asl ZP_VAR_Q
        rol ZP_VAR_R
        rol 
        bpl _3bf7
        sta ZP_VAR_Q
        lda # $fe
        sta ZP_VAR_R
        lda ZP_VAR_P3
_3c07:                                                                  ;$3C07
        asl 
        bcs _3c17
        cmp ZP_VAR_Q
        bcc _3c10
        sbc ZP_VAR_Q
_3c10:                                                                  ;$3C10
        rol ZP_VAR_R
        bcs _3c07
        jmp _3c20

_3c17:                                                                  ;$3C17
        sbc ZP_VAR_Q
        sec 
        rol ZP_VAR_R
        bcs _3c07
        lda ZP_VAR_R
_3c20:                                                                  ;$3C20
        lda # $00
        sta $78
        sta $79
        sta $7a
        tya 
        bpl _3c49
        lda ZP_VAR_R
_3c2d:                                                                  ;$3C2D
        asl 
        rol $78
        rol $79
        rol $7a
        iny 
        bne _3c2d
        sta $77
        lda $7a
        ora ZP_VAR_T
        sta $7a
        rts 

;===============================================================================

_3c40:                                                                  ;$3C40
        lda ZP_VAR_R
        sta $77
        lda ZP_VAR_T
        sta $7a
        rts 

        ;-----------------------------------------------------------------------

_3c49:                                                                  ;$3C49
        beq _3c40
        lda ZP_VAR_R
_3c4d:                                                                  ;$3C4D
        lsr 
        dey 
        bne _3c4d
        sta $77
        lda ZP_VAR_T
        sta $7a
        rts 

;===============================================================================

_3c58:                                                                  ;$3C58
        lda $0480
        bne :+
        lda _1d06
        bne @rts

:       txa                                                             ;$3C62 
        bpl :+
        dex 
        bmi @rts

:       inx                                                             ;$3C68 
        bne @rts
        dex 
        beq :-

@rts:   rts                                                             ;$3C68 

;===============================================================================

_3c6f:                                                                  ;$3C6F
.export _3c6f

        sta ZP_VAR_T
        txa 
        clc 
        adc ZP_VAR_T
        tax 
        bcc _3c7a
        ldx # $ff
_3c7a:                                                                  ;$3C7A
        bpl _3c8c
_3c7c:                                                                  ;$3C7C
        lda ZP_VAR_T
        rts 

        ;-----------------------------------------------------------------------

_3c7f:                                                                  ;$3C7F
.export _3c7f

        sta ZP_VAR_T
        txa 
        sec 
        sbc ZP_VAR_T
        tax 
        bcs _3c8a
        ldx # $01
_3c8a:                                                                  ;$3C8A
        bpl _3c7c
_3c8c:                                                                  ;$3C8C
        lda _1d07
        bne _3c7c
        ldx # $80
        bmi _3c7c
_3c95:                                                                  ;$3C95
.export _3c95

        lda ZP_VAR_P1
        eor ZP_VAR_Q
        sta ZP_TEMP_VAR
        lda ZP_VAR_Q
        beq _3cc4
        asl 
        sta ZP_VAR_Q
        lda ZP_VAR_P1
        asl 
        cmp ZP_VAR_Q
        bcs _3cb2
        jsr _3cce
        sec 
_3cad:                                                                  ;$3CAD
        ldx ZP_TEMP_VAR
        bmi _3cc7
        rts 

        ;-----------------------------------------------------------------------

_3cb2:                                                                  ;$3CB2
        ldx ZP_VAR_Q
        sta ZP_VAR_Q
        stx ZP_VAR_P1
        txa 
        jsr _3cce
        sta ZP_VAR_T
        lda # $40
        sbc ZP_VAR_T
        bcs _3cad
_3cc4:                                                                  ;$3CC4
        lda # $3f
        rts 

        ;-----------------------------------------------------------------------

_3cc7:                                                                  ;$3CC7
        sta ZP_VAR_T
        lda # $80
        sbc ZP_VAR_T
        rts 

        ;-----------------------------------------------------------------------

_3cce:                                                                  ;$3CCE
        jsr _99af
        lda ZP_VAR_R
        lsr 
        lsr 
        lsr 
        tax 
        lda _0ae0, x
_3cda:                                                                  ;$3CDA
        rts 

;===============================================================================

_3cdb:                                                                  ;$3CDB
        jsr get_random_number
        and # %00000111
        adc # $44
        sta $06f1

        jsr get_random_number
        and # %00000111
        adc # $7c
        sta $06f0
        
        lda PLAYER_TEMP_LASER
        adc # $08
        sta PLAYER_TEMP_LASER
        jsr _7b64
_3cfa:                                                                  ;$3CFA
        lda $a0
        bne _3cda
        lda # $20
        ldy # $e0
        jsr _3d09
        lda # $30
        ldy # $d0
_3d09:                                                                  ;$3D09
        sta ZP_VAR_X2
        lda $06f0
        sta ZP_VAR_X
        lda $06f1
        sta ZP_VAR_Y
        lda # $8f
        sta ZP_VAR_Y2
        jsr _ab91
        lda $06f0
        sta ZP_VAR_X
        lda $06f1
        sta ZP_VAR_Y
        sty ZP_VAR_X2
        lda # $8f
        sta ZP_VAR_Y2
        jmp _ab91

;===============================================================================

_3d2f:                                                                  ;$3D2F
.export _3d2f

        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz _3d6f
       
        lda $a7
        bpl _3d6f
        ldy # $00
_3d3d:                                                                  ;$3D3D
        lda _1a27, y
        cmp ZP_VAR_Z
        bne _3d6c
        lda _1a41, y
        and # %01111111
        cmp PLAYER_GALAXY
        bne _3d6c
        lda _1a41, y
        bmi :+

        lda MISSION_FLAGS
        lsr 
        bcc _3d6f
        
        jsr txt_docked_token0E
        
        lda # $01
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

:       lda # $b0                                                       ;$3D5F
        jsr print_docked_token
        
        tya 
        jsr _237e

        lda # $b1
        bne _3d7a
_3d6c:                                                                  ;$3D6C
        dey 
        bne _3d3d
_3d6f:                                                                  ;$3D6F
        ; copy the last four bytes of the main seed to the "goat soup"
        ; seed, used for generating the planet descriptions
        ldx # $03
:       lda ZP_SEED_pt3, x                                              ;3D71
        sta ZP_GOATSOUP, x
        dex 
        bpl :-

        lda # $05
_3d7a:  jmp print_docked_str                                            ;$3D7A


mission_blueprints_begin:                                               ;$3D7D
        ;=======================================================================
        ; begin the Thargoid Blueprints mission:
        ;
        lda MISSION_FLAGS
        ora # missions::blueprints_begin
        sta MISSION_FLAGS

        ; display "go to Ceerdi" mission text
.import TXT_DOCKED_0B:direct
        lda # TXT_DOCKED_0B

_3d87:                                                                  ;$3D87
        jsr print_docked_str
_3d8a:                                                                  ;$3D8A
        jmp _88e7


mission_blueprints_ceerdi:                                              ;$3D8D
        ;=======================================================================
        lda MISSION_FLAGS
        and # %11110000
        ora # %00001010
        sta MISSION_FLAGS

        lda # $de
        bne _3d87

mission_blueprints_birera:                                              ;$3D9B
        ;=======================================================================
        lda MISSION_FLAGS
        ora # %00000100
        sta MISSION_FLAGS

        ; give the player the military energy unit?
        lda # 2
        sta $04c4               ; energy charge rate?

        inc PLAYER_KILLS
        
        lda # $df
        bne _3d87               ; always branches

_3daf:                                                                  ;$3DAF
        ;=======================================================================
        lsr MISSION_FLAGS
        asl MISSION_FLAGS
        
        ldx # $50
        ldy # $c3
        jsr _7481
        
        lda # $0f
_3dbe:                                                                  ;$3DBE
        bne _3d87               ; always branches

.ifndef OPTION_NOTRUMBLES

mission_trumbles:                                                       ;$3DC0
        ;=======================================================================
        ; begin Trumbles™ mission
        ;

        ;set the mission bit:
        lda MISSION_FLAGS
        ora # missions::trumbles
        sta MISSION_FLAGS

        ; display the Trumbles™ mission text
.import TXT_DOCKED_TRUMBLES:direct
        lda # TXT_DOCKED_TRUMBLES
        jsr print_docked_str
        
        jsr _81ee
        bcc _3d8a

        ldy # $c3
        ldx # $50
        jsr _745a
        
        ;put a Trumble™ in the hold...
        inc PLAYER_TRUMBLES_LO

        ; start the normal docked screen?
        jmp _88e7

.endif

;===============================================================================

_3dff:                                                                  ;$3DFF
        ; and this is how you set bit 0, without using registers!

        lsr MISSION_FLAGS       ; push bit 0 into the bit-bucket
        sec                     ; put a 1 into the carry
        rol MISSION_FLAGS       ; push the carry into bit 0

        jsr txt_docked_incoming_message
        jsr _8447
        
        lda # $1f
        sta $a5
        jsr _7c6b

        lda # 1
        jsr set_cursor_col
        
        sta ZP_POLYOBJ_ZPOS_pt2
        jsr _a72f

        lda # $40
        sta $a3                 ; move counter?
_3e01:                                                                  ;$3E01
        ldx # $7f
        stx $26
        stx $27
        jsr _9a86
        jsr _a2a0
        dec $a3                 ; move counter?
        bne _3e01
_3e11:                                                                  ;$3E11
        lsr ZP_POLYOBJ_XPOS_pt1
        inc ZP_POLYOBJ_ZPOS_pt1
        beq _3e31

        inc ZP_POLYOBJ_ZPOS_pt1
        beq _3e31
        
        ldx ZP_POLYOBJ_YPOS_pt1
        inx 
        cpx # $50
        bcc _3e24
        
        ldx # $50
_3e24:                                                                  ;$3E24
        stx ZP_POLYOBJ_YPOS_pt1
        jsr _9a86
        jsr _a2a0
        dec $a3                 ; move counter?
        jmp _3e11
_3e31:                                                                  ;$3E31
        inc ZP_POLYOBJ_ZPOS_pt2
        lda # $0a
        bne _3dbe               ; always branches


txt_docked_incoming_message:                                            ;$3E37
        ;=======================================================================
        ; print "INCOMING MESSAGE" on screen and wait a bit
        ;
.export txt_docked_incoming_message

        ; print "INCOMING MESSAGE" on screen

.import TXT_DOCKED_INCOMING_MESSAGE:direct
        lda # TXT_DOCKED_INCOMING_MESSAGE
        jsr print_docked_str

        ldy # 100
        jmp wait_frames

txt_docked_token16:                                                     ;$3E41
        ;=======================================================================
.export txt_docked_token16
        
        jsr _3e65
        bne txt_docked_token16
_3e46:                                                                  ;$3E46
        jsr _3e65
        beq _3e46
        
        lda # $00
        sta $28
        
        lda # $01
        jsr _a72f
        jsr _9a86

txt_docked_token17:                                                     ;$3E57  
        ;=======================================================================
.export txt_docked_token17

        lda # 10
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token1D:                                                     ;$3E5A
        ;=======================================================================
.export txt_docked_token1D

        lda # 6
        jsr set_cursor_row

        ;SPEED: dummy code -- it just returns!
        jsr _250b
        
        jmp txt_docked_token0D

_3e65:                                                                  ;$3E65
        ;-----------------------------------------------------------------------
        lda # $50
        sta ZP_POLYOBJ_YPOS_pt1

        lda # $00
        sta ZP_POLYOBJ_XPOS_pt1
        sta ZP_POLYOBJ_ZPOS_pt1
        
        lda # $02
        sta ZP_POLYOBJ_ZPOS_pt2
        
        jsr _9a86
        jsr _a2a0
        
        jmp _8d53

txt_docked_token18:                                                     ;$3E7C
        ;=======================================================================
.export txt_docked_token18
        
        jsr _8d53
        bne txt_docked_token18

        jsr _8d53
        beq txt_docked_token18
        
        rts 

get_polyobj:                                                            ;$3E87
;===============================================================================
; a total of 11 3D-objects ("poly-objects") can be 'in-play' at a time,
; each object has a block of runtime storage to keep track of its current
; state including rotation, speed, shield etc.
;
; given an index for a poly-object 0-10, this routine will
; return an address for the poly-object's variable storage
;
;       X = index
;
; returns address in $59/$5A
;
.export get_polyobj

        txa 
        asl                     ; multiply by 2 (for 2-byte table-lookup)
        tay 
        lda polyobj_addrs_lo, y
        sta ZP_POLYOBJ_ADDR_LO
        lda polyobj_addrs_hi, y
        sta ZP_POLYOBJ_ADDR_HI
        
        rts 

set_psystem_to_tsystem:                                                 ;$3E95
;===============================================================================
; copy present system co-ordinates to target system co-ordinates,
; i.e. you have arrived at your destination
;
.export set_psystem_to_tsystem

        ldx # 1
:       lda PSYSTEM_POS, x                                              ;$3E97
        sta TSYSTEM_POS, x
        dex 
        bpl :-
        
        rts 

wait_frames:                                                            ;$3EA1
;===============================================================================
; wait for a given number of frames to complete
;
;       Y = number of frames to wait
;
.export wait_frames

        jsr wait_for_frame
        dey 
        bne wait_frames
        rts 

;===============================================================================
; colour of different type of laser cross-hairs?

_3ea8:                                                                  ;$3EA8
.export _3ea8
        .byte   YELLOW, YELLOW, LTGREEN, PURPLE                         ;$3EA8


;$3EAC
