; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "DATA_9900"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; referenced in the `chrout` routine, these are a pair of hi/lo-byte lookup
; tables that index a row number (0-24) to the place in the menu screen memory
; where that row starts -- note that Elite uses a 32-char (256 px) wide
; 'screen' so this equates the the 4th character in each 40-char row
;
.define menuscr_pos \
        ELITE_MENUSCR_ADDR + .scrpos(  0, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  1, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  2, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  3, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  4, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  5, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  6, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  7, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  8, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos(  9, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 10, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 11, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 12, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 13, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 14, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 15, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 16, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 17, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 18, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 19, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 20, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 21, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 22, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 23, 3 ), \
        ELITE_MENUSCR_ADDR + .scrpos( 24, 3 )

menuscr_lo:                                                             ;$9900
;===============================================================================
        .lobytes menuscr_pos

menuscr_hi:                                                             ;$9919
;===============================================================================
        .hibytes menuscr_pos


; NOTE: in the original code, segment "CODE_9932" appears here          ;$9932
; NOTE: in the original code, segment "CODE_A19F" appears here          ;$A19F


.segment        "CODE_A2A0"                                             ;$A2A0
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

move_ship:                                              ; BBC: MVEIT    ;$A2A0
;===============================================================================
; do_ship_ai? checks if A.I. needs running and appears to rotate and move
; the objcet
;
; in:   X                       ship type (i.e. a `hull_pointers` index)
;-------------------------------------------------------------------------------
        ; is the ship exploding?
        lda ZP_SHIP_STATE       ; check the ship's state flags
        and # state::exploding | state::debris
       .bnz @a2cb

        ; handle explosion?
        lda MAIN_COUNTER
        eor ZP_PRESERVE_X
        and # %00001111
        bne :+
        jsr _9105

:       ldx ZP_SHIP_TYPE                                                ;$A2B1
        bpl :+
        jmp _a53d

        ;-----------------------------------------------------------------------
        ; is the A.I. active?
        ;
:       lda ZP_SHIP_ATTACK      ; check current A.I. state              ;$A2B8
        bpl @a2cb               ; is bit 7 ("active") set?

        cpx # HULL_MISSILE      ; is this a missile?
        beq :+                  ; missiles always run A.I. every frame

        ; should we run an A.I. check? when the A.I. is not "active",
        ; it runs at a much lower rate. these instructions here
        ; gear-down the ratio
        ;
        lda MAIN_COUNTER
        eor ZP_PRESERVE_X
        and # %00000111         ; modulo 8
        bne @a2cb               ; skip every 7 out of 8 frames

        ; handle A.I.
:       jsr _32ad                                                       ;$A2C8

@a2cb:                                                                  ;$A2CB
        jsr _SCAN

        lda ZP_SHIP_SPEED       ; scale up the object's speed
        asl                     ; x2
        asl                     ; x4
        sta Q                   ; put aside for some later math

        lda ZP_SHIP_M0x0_HI
        and # %01111111         ; remove sign
        jsr _39ea               ; A=(A*Q)/256
        sta R

        lda ZP_SHIP_M0x0_HI
        ldx # $00
        jsr .move_ship_x_small
        lda ZP_SHIP_M0x1_HI
        and # %01111111
        jsr _39ea               ; A=(A*Q)/256
        sta R

        lda ZP_SHIP_M0x1_HI
        ldx # $03
        jsr .move_ship_x_small
        lda ZP_SHIP_M0x2_HI
        and # %01111111
        jsr _39ea               ; A=(A*Q)/256
        sta R

        lda ZP_SHIP_M0x2_HI
        ldx # $06
        jsr .move_ship_x_small
        lda ZP_SHIP_SPEED
        clc 
        adc ZP_SHIP_ACCEL
        bpl :+
        lda # $00
:       ldy # Hull::speed                                               ;$A30D
        cmp [ZP_HULL_ADDR], y
        bcc :+
        lda [ZP_HULL_ADDR], y
:       sta ZP_SHIP_SPEED                                               ;$A315

        lda # $00
        sta ZP_SHIP_ACCEL

        ldx ZP_ROLL_MAGNITUDE

        lda ZP_SHIP_XPOS_LO
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_SHIP_XPOS_HI
        jsr _3a25
        sta ZP_VAR_P3

        lda ZP_INV_ROLL_SIGN
        eor ZP_SHIP_XPOS_SIGN
        ldx # $03
        jsr _a508
        sta ZP_B5

        lda ZP_VAR_P2
        sta ZP_B3
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_VAR_P3
        sta ZP_B4
        ldx ZP_PITCH_MAGNITUDE
        jsr _3a25
        sta ZP_VAR_P3

        lda ZP_B5
        eor ZP_PITCH_SIGN
        ldx # $06
        jsr _a508
        sta ZP_SHIP_ZPOS_SIGN

        lda ZP_VAR_P2
        sta ZP_SHIP_ZPOS_LO
        eor # %11111111
        sta ZP_VAR_P1

        lda ZP_VAR_P3
        sta ZP_SHIP_ZPOS_HI

        jsr _3a27
        sta ZP_VAR_P3

        lda ZP_B5
        sta ZP_SHIP_YPOS_SIGN
        eor ZP_PITCH_SIGN
        eor ZP_SHIP_ZPOS_SIGN
        bpl :+

        lda ZP_VAR_P2
        adc ZP_B3
        sta ZP_SHIP_YPOS_LO

        lda ZP_VAR_P3
        adc ZP_B4
        sta ZP_SHIP_YPOS_HI

        jmp _a39d

:       lda ZP_B3                                                       ;$A37D
        sbc ZP_VAR_P2
        sta ZP_SHIP_YPOS_LO
        lda ZP_B4
        sbc ZP_VAR_P3
        sta ZP_SHIP_YPOS_HI
        bcs _a39d
        lda # $01
        sbc ZP_SHIP_YPOS_LO
        sta ZP_SHIP_YPOS_LO
        lda # $00
        sbc ZP_SHIP_YPOS_HI
        sta ZP_SHIP_YPOS_HI
        lda ZP_SHIP_YPOS_SIGN
        eor # %10000000
        sta ZP_SHIP_YPOS_SIGN
_a39d:                                                                  ;$A39D
        ldx ZP_ROLL_MAGNITUDE
        lda ZP_SHIP_YPOS_LO
        eor # %11111111
        sta ZP_VAR_P1
        lda ZP_SHIP_YPOS_HI
        jsr _3a25
        sta ZP_VAR_P3
        lda ZP_ROLL_SIGN
        eor ZP_SHIP_YPOS_SIGN
        ldx # $00
        jsr _a508
        sta ZP_SHIP_XPOS_SIGN
        lda ZP_VAR_P3
        sta ZP_SHIP_XPOS_HI
        lda ZP_VAR_P2
        sta ZP_SHIP_XPOS_LO
_a3bf:                                                                  ;$A3BF
        lda ZP_PLAYER_SPEED
        sta R

        lda # $80
        ldx # $06
        jsr move_ship_x

        lda ZP_SHIP_TYPE
        and # %10000001
        cmp # $81
        bne :+

        rts 

        ;-----------------------------------------------------------------------
        ; apply the roll & pitch rotation to the ship's compound matrix:
        ; this creates a single matrix that can apply both roll & pitch to the
        ; vertices in one operation, i.e. we do not have to calculate roll &
        ; pitch separately for each vertex point in the shape
        ;
:       ldy # MATRIX_ROW0                                               ;$A3D3
        jsr rotate_ship_axis
        ldy # MATRIX_ROW1
        jsr rotate_ship_axis
        ldy # MATRIX_ROW2
        jsr rotate_ship_axis

        ; slowly dampen pitch rate toward zero:
        ;-----------------------------------------------------------------------
        ; separate out the pitch sign
        ; (positive / negative)
        ;
        lda ZP_SHIP_PITCH       ; current pitch rate
        and # %10000000         ; isolate pitch sign
        sta ZP_B1               ; put aside sign

        ; TODO: we could use a register transfer instead of doing LDA again
        ; i.e. use `tay` to keep `ZP_SHIP_PITCH` for next use

        ; get the pitch rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_SHIP_PITCH
        and # %01111111         ; isolate pitch magnitude
        beq :+                  ; skip if pitch is level (= %x0000000)

        ; on the 6502 `cmp` effectively subtracts the given value from A
        ; but doesn't write the result back, setting the flags as the result;
        ; if A is less than *or equal to* the value, carry will be set.
        ;
        ; this means that if we compare the magnitude, without sign (%x0000001
        ; to %x1111111), with `%x1111111` then no matter what the magnitude,
        ; the carry *will* be set. when we call 'SuBtract with Carry' only 1
        ; will be subtracted, not the actual difference between the two!
        ;
        cmp # %01111111         ; carry will be set if pitch <= %x1111111,
        sbc # $00               ; and 1 will be subtracted instead of 0
        ora ZP_B1               ; add the sign back in
        sta ZP_SHIP_PITCH       ; save back the pitch rate

        ldx # $0f
        ldy # $09
        jsr _2dc5               ; move ship?
        ldx # $11
        ldy # $0b
        jsr _2dc5               ; move ship?
        ldx # $13
        ldy # $0d
        jsr _2dc5               ; move ship?

        ; slowly dampen roll rate toward zero:
        ;-----------------------------------------------------------------------
        ; separate out the roll sign
        ; (positive / negative)
        ;
:       lda ZP_SHIP_ROLL        ; current roll rate                     ;$A40B
        and # %10000000         ; isolate roll sign
        sta ZP_B1               ; put aside sign

        ; get the roll rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_SHIP_ROLL
        and # %01111111         ; isolate roll magnitude
        beq :+                  ; skip if roll is level (= %x0000000)

        cmp # %01111111         ; carry will be set if roll <= %x1111111,
        sbc # $00               ; and 1 will be subtracted instead of 0
        ora ZP_B1               ; add the sign back in
        sta ZP_SHIP_ROLL        ; save back the roll rate

        ldx # $0f
        ldy # $15
        jsr _2dc5               ; move ship?
        ldx # $11
        ldy # $17
        jsr _2dc5               ; move ship?
        ldx # $13
        ldy # $19
        jsr _2dc5

:       lda ZP_SHIP_STATE                                               ;$A434
        and # state::exploding | state::debris
        bne :+

        lda ZP_SHIP_STATE
        ora # state::scanner
        sta ZP_SHIP_STATE
        jmp _SCAN

        ;-----------------------------------------------------------------------

:       lda ZP_SHIP_STATE                                               ;$A443
        and # state::scanner ^$FF
        sta ZP_SHIP_STATE
        rts 


; NOTE: in the original, segment "CODE_A44A" appears here               ;$A44A
; NOTE: in the original, segment "CODE_A4A1" appears here               ;$A4A1


.segment        "CODE_A508"                                             ;$A508
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_a508:                                                                  ;$A508
;===============================================================================
        tay 
        eor ZP_SHIP_XPOS_SIGN, x
        bmi _a51c
        lda ZP_VAR_P2
        clc 
        adc ZP_SHIP_XPOS_LO, x
        sta ZP_VAR_P2
        lda ZP_VAR_P3
        adc ZP_SHIP_XPOS_HI, x
        sta ZP_VAR_P3
        tya 
        rts 

        ;-----------------------------------------------------------------------

_a51c:                                                                  ;$A51C
        lda ZP_SHIP_XPOS_LO, x
        sec 
        sbc ZP_VAR_P2
        sta ZP_VAR_P2
        lda ZP_SHIP_XPOS_HI, x
        sbc ZP_VAR_P3
        sta ZP_VAR_P3
        bcc _a52f
        tya 
        eor # %10000000
        rts 

        ;-----------------------------------------------------------------------

_a52f:                                                                  ;$A52F
        lda # $01
        sbc ZP_VAR_P2
        sta ZP_VAR_P2
        lda # $00
        sbc ZP_VAR_P3
        sta ZP_VAR_P3
        tya 
        rts 


_a53d:                                                                  ;$A53D
;===============================================================================
        lda ZP_ALPHA
        eor # %10000000
        sta Q

        lda ZP_SHIP_XPOS_LO
        sta ZP_VAR_P1

        lda ZP_SHIP_XPOS_HI
        sta ZP_VAR_P2

        lda ZP_SHIP_XPOS_SIGN
        jsr _38f8

        ldx # $03
        jsr _2d69

        lda ZP_VALUE_pt2
        sta ZP_B3
        sta ZP_VAR_P1

        lda ZP_VALUE_pt3
        sta ZP_B4
        sta ZP_VAR_P2

        lda ZP_BETA
        sta Q

        lda ZP_VALUE_pt4
        sta ZP_B5

        jsr _38f8

        ldx # $06
        jsr _2d69

        lda ZP_VALUE_pt2
        sta ZP_VAR_P1
        sta ZP_SHIP_ZPOS_LO

        lda ZP_VALUE_pt3
        sta ZP_VAR_P2
        sta ZP_SHIP_ZPOS_HI

        lda ZP_VALUE_pt4
        sta ZP_SHIP_ZPOS_SIGN
        eor # %10000000
        jsr _38f8

        lda ZP_VALUE_pt4
        and # %10000000
        sta T
        eor ZP_B5
        bmi _a5a8

        lda ZP_VALUE_pt1
        clc 
        adc ZP_B2

        lda ZP_VALUE_pt2
        adc ZP_B3
        sta ZP_SHIP_YPOS_LO

        lda ZP_VALUE_pt3
        adc ZP_B4
        sta ZP_SHIP_YPOS_HI

        lda ZP_VALUE_pt4
        adc ZP_B5

        jmp _a5db

_a5a8:                                                                  ;$A5A8
        lda ZP_VALUE_pt1
        sec 
        sbc ZP_B2
        lda ZP_VALUE_pt2
        sbc ZP_B3
        sta ZP_SHIP_YPOS_LO
        lda ZP_VALUE_pt3
        sbc ZP_B4
        sta ZP_SHIP_YPOS_HI
        lda ZP_B5
        and # %01111111
        sta ZP_VAR_P1
        lda ZP_VALUE_pt4
        and # %01111111
        sbc ZP_VAR_P1
        sta ZP_VAR_P1
        bcs _a5db
        lda # $01
        sbc ZP_SHIP_YPOS_LO
        sta ZP_SHIP_YPOS_LO
        lda # $00
        sbc ZP_SHIP_YPOS_HI
        sta ZP_SHIP_YPOS_HI
        lda # $00
        sbc ZP_VAR_P1
        ora # %10000000
_a5db:                                                                  ;$A5DB
        eor T
        sta ZP_SHIP_YPOS_SIGN
        lda ZP_ALPHA
        sta Q
        lda ZP_SHIP_YPOS_LO
        sta ZP_VAR_P1
        lda ZP_SHIP_YPOS_HI
        sta ZP_VAR_P2
        lda ZP_SHIP_YPOS_SIGN
        jsr _38f8
        ldx # $00
        jsr _2d69
        lda ZP_VALUE_pt2
        sta ZP_SHIP_XPOS_LO
        lda ZP_VALUE_pt3
        sta ZP_SHIP_XPOS_HI
        lda ZP_VALUE_pt4
        sta ZP_SHIP_XPOS_SIGN
        jmp _a3bf


_a604:                                                                  ;$A604
;===============================================================================
; what calls in to this, where?
;-------------------------------------------------------------------------------
        sec 
        ldy # $00
        sty ZP_TEMP_ADDR2_LO
        ldx # $10
        lda [ZP_TEMP_ADDR1], y
        txa 
_a60e:                                                                  ;$A60E
        stx ZP_TEMP_ADDR2_HI
        sty T
        adc [ZP_TEMP_ADDR2], y
        eor T
        sbc ZP_TEMP_ADDR2_HI
        dey 
        bne _a60e
        inx 
        cpx # $a0
        bcc _a60e
        cmp _1d21
        bne _a604

        rts 


_PLUT:                                                  ; BBC: PLUT     ;$A626
;===============================================================================
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; we've inlined this at the call-site in elite-harmless
        ;
        ldx COCKPIT_VIEW
        beq @rts
.endif  ;///////////////////////////////////////////////////////////////////////
        dex 
        bne @a65f

        ; adjust for rear view: invert sign of X,Z
        ; up stays up, so Y is ok
        ;
        lda ZP_SHIP_XPOS_SIGN
        eor # %10000000
        sta ZP_SHIP_XPOS_SIGN
        lda ZP_SHIP_ZPOS_SIGN
        eor # %10000000
        sta ZP_SHIP_ZPOS_SIGN

        lda ZP_SHIP_M0x0_HI
        eor # %10000000
        sta ZP_SHIP_M0x0_HI
        lda ZP_SHIP_M0x2_HI
        eor # %10000000
        sta ZP_SHIP_M0x2_HI
        lda ZP_SHIP_M1x0_HI
        eor # %10000000
        sta ZP_SHIP_M1x0_HI
        lda ZP_SHIP_M1x2_HI
        eor # %10000000
        sta ZP_SHIP_M1x2_HI
        lda ZP_SHIP_M2x0_HI
        eor # %10000000
        sta ZP_SHIP_M2x0_HI
        lda ZP_SHIP_M2x2_HI
        eor # %10000000
        sta ZP_SHIP_M2x2_HI

        ; adjust for front view: this is the default view, all is ok.
@rts:   rts                                                             ;$A65E


@a65f:                                                                  ;$A65F
        ;-----------------------------------------------------------------------
        ; adjust for side view: swap Z and X, invert according to B0
        ; B0 is set when view is RIGHT (see)
        ;
        lda # $00
        cpx # $02               ; X is COCKPIT_VIEW-1, so this checks for RIGHT
        ror 
        sta ZP_B1               
        eor # %10000000
        sta ZP_B0
        lda ZP_SHIP_XPOS_LO
        ldx ZP_SHIP_ZPOS_LO
        sta ZP_SHIP_ZPOS_LO
        stx ZP_SHIP_XPOS_LO
        lda ZP_SHIP_XPOS_HI
        ldx ZP_SHIP_ZPOS_HI
        sta ZP_SHIP_ZPOS_HI
        stx ZP_SHIP_XPOS_HI
        lda ZP_SHIP_XPOS_SIGN
        eor ZP_B0               ; invert X-sign when looking LEFT
        tax 
        lda ZP_SHIP_ZPOS_SIGN
        eor ZP_B1               ; invert X-sign when looking RIGHT
        sta ZP_SHIP_XPOS_SIGN
        stx ZP_SHIP_ZPOS_SIGN

        ; swap X & Z in the 3x3 matrix?
        ;-----------------------------------------------------------------------
        ldy # MATRIX_ROW0
        jsr :+
        ldy # MATRIX_ROW1
        jsr :+
        ldy # MATRIX_ROW2

:       lda ZP_SHIP + MATRIX_COL0_LO, y                                 ;$A693
        ldx ZP_SHIP + MATRIX_COL2_LO, y
        sta ZP_SHIP + MATRIX_COL2_LO, y
        stx ZP_SHIP + MATRIX_COL0_LO, y
        lda ZP_SHIP + MATRIX_COL0_HI, y
        eor ZP_B0
        tax 
        lda ZP_SHIP + MATRIX_COL2_HI, y
        eor ZP_B1
        sta ZP_SHIP + MATRIX_COL0_HI, y
        stx ZP_SHIP + MATRIX_COL2_HI, y

_a6ad:  rts                                                             ;$A6AD


_a6ae:                                                                  ;$A6AE
;===============================================================================
; set cockpit view:
;
; in:   X                       $00 = front
;                               $01 = rear ("aft")
;                               $02 = left
;                               $03 = right
;-------------------------------------------------------------------------------
        stx COCKPIT_VIEW
        jsr set_page

        jsr _a6d4
        jmp _7af3

_a6ba:                                                                  ;$A6BA
        lda # page::cockpit

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _DOVDU19            ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ldy ZP_SCREEN           ; are we in the cockpit-view?
       .bnz _a6ae               ; no? switch to cockpit-view now

        cpx COCKPIT_VIEW
        beq _a6ad               ; view did not change, rts
        stx COCKPIT_VIEW

        jsr set_page            ; switch to cockpit view
        jsr dust_swap_xy        ; is this an opt: avoid rand
        jsr _WPSHPS             ; clear the scanner

_a6d4:                                                                  ;$A6D4

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

        ldy COCKPIT_VIEW        ; current viewpoint (front, rear, left, right)

        lda PLAYER_LASERS, y    ; get type of laser for current viewpoint
        beq _a700               ; no laser? skip ahead

        ; the index of the first sprite is entirely dependent on where
        ; sprites are located in the selected VIC bank; see "elite.inc"
        ; for where this value is defined
        ldy # ELITE_SPRITES_INDEX
        
        cmp # $0f               ; laser power 15
        beq :+
        iny                     ; select next sprite index
        cmp # laser::beam | $0f ; beam laser, power 15
        beq :+
        iny                     ; select next sprite index
        cmp # laser::beam | $17 ; beam laser, power 23
        beq :+
        iny                     ; select next sprite index

        ; the indices for the 8 hardware sprites are stored just after
        ; the 1'000 bytes used for the screen RAM. since Elite has two
        ; screens (flight or docked+menus), the sprite index needs to
        ; be set for both screens
        ;
:       sty ELITE_MENUSCR_ADDR + VIC_SPRITE0_PTR                        ;$A6F2
        sty ELITE_MAINSCR_ADDR + VIC_SPRITE0_PTR

        ; set colour of cross-hairs
        ; according to type of laser
        ;
        lda _3ea8 - ELITE_SPRITES_INDEX, y
        sta VIC_SPRITE0_COLOR

        ; mark the cross-hairs sprite as enabled
        lda # %00000001

_a700:                                                                  ;$A700

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        sta T

        lda PLAYER_TRUMBLES_HI
        and # %01111111
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda trumbles_sprite_count, x
        sta TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
        lda trumbles_sprite_mask, x
        ora T                   ; other sprites mask?
        sta VIC_SPRITE_ENABLE
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jmp set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  FEATURE_TRUMBLES
;///////////////////////////////////////////////////////////////////////////////

trumbles_sprite_count:                                                  ;$A71F
        ;-----------------------------------------------------------------------
        .byte   $00, $01, $02, $03, $04, $05, $06, $06

trumbles_sprite_mask:                                                   ;$A727
        ;-----------------------------------------------------------------------
        ; table of bit-masks for which sprites to enable for Trumbles™.
        ; up to six Trumbles™ can appear on-screen, two sprites are always
        ; reserved for other uses (cross-hair and explosion-sprite)
        ;
        .byte   %00000000
        .byte   %00000100
        .byte   %00001100
        .byte   %00011100
        .byte   %00111100
        .byte   %01111100
        .byte   %11111100
        .byte   %11111100

;///////////////////////////////////////////////////////////////////////////////
.endif


set_page:                                                               ;$A72F
;===============================================================================
; switch screen page:
;
; in:   A                       page to switch to; e.g. cockpit-view, galactic
;                               chart &c. see the `page` constants defined in
;                               "vars_zeropage.asm"
;-------------------------------------------------------------------------------
        sta ZP_SCREEN           ; set the variable for current active page

_set_page:                                                              ;$A731
        ;-----------------------------------------------------------------------
        jsr print_caps_off      ; reset text case-shifting?

        lda # $00               ; reset the buffer used for drawing circles?
        sta ZP_CIRCLE_INDEX

        lda # %10000000
        sta ZP_PRINT_CASE
        sta txt_ucase_flag

        ; because the screen will be erased, we need to clear the circle
        ; buffer (used to erase the previous frame's sun) to avoid trying
        ; to erase a circle that's no longer there
        jsr clear_sun_buffer

        lda # $00
        sta LASER_POWER
        sta OSD_DELAY
        sta VAR_048C

        ; clear the screen and 'home' the cursor
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        jsr clear_screen

        ; display hyperspace countdown in the menu screens?
        ;
        ldx ZP_66               ; hyperspace countdown (outer)?
        beq _a75d

        jsr _7224

_a75d:                                                                  ;$A75D
        lda # 1
       .set_cursor_row

        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :+                  ; no? skip ahead

        lda # 11
       .set_cursor_col

.import TKN_FLIGHT_DIRECTIONS:direct
        lda COCKPIT_VIEW
        ora # TKN_FLIGHT_DIRECTIONS
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr print_flight_token
        jsr print_space
.else   ;///////////////////////////////////////////////////////////////////////
        jsr print_flight_token_and_space
.endif  ;///////////////////////////////////////////////////////////////////////

.import TKN_FLIGHT_VIEW:direct
        lda # TKN_FLIGHT_VIEW
        jsr print_flight_token

:       ldx # 1                                                         ;$A77B
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW

        dex 
        stx ZP_PRINT_CASE

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================

_a785:                                                                  ;$A785
        rts 


_ECMOF:                                                 ; BBC: ECMOF    ;$A786
;===============================================================================
; switch ECM off; clearing the ECM indicator on the HUD:
;-------------------------------------------------------------------------------
        lda # $00               ; disable ECM:
        sta ECM_COUNTER         ; zero-out ECM counter
        sta ECM_STATE           ; mark our ECM as inactive

        jsr _b0fd               ; clear ECM indicator on HUD
        ldy # $09
        jmp _a822


_a795:                                                                  ;$A795
;===============================================================================
        ldx # HULL_MISSILE
        jsr _3708               ; NOTE: spawns ship-type in X
        bcc _a785
        
.import TKN_FLIGHT_INCOMING_MISSILE:direct
        lda # TKN_FLIGHT_INCOMING_MISSILE
        ; print an on-screen message
        jsr _MESS

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $04
        jmp play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////


ship_killed:                                            ; BBC: EXNO2    ;$A7A6
;===============================================================================
; handles paperwork related to killing a ship;
; adding kill points, showing messages, &c.
;
;-------------------------------------------------------------------------------
        lda PLAYER_KILLS_FRAC
        clc 
        adc hull_kill_lo-1, x
        sta PLAYER_KILLS_FRAC

        lda PLAYER_KILLS_LO
        adc hull_kill_hi-1, x
        sta PLAYER_KILLS_LO
        bcc sound_play_explosion; < 1.0
        inc PLAYER_KILLS_HI     ; +1

        ; every 256 [whole] kills, print "right on commander!"
        ;
.import TKN_FLIGHT_RIGHT_ON_COMMANDER:direct
        lda # TKN_FLIGHT_RIGHT_ON_COMMANDER
        ; show an on-screen message
        jsr _MESS

        ; fallthrough
        ; ...

sound_play_explosion:                                                   ;$A7C3
;===============================================================================
; play an explosion sound:
; the volume is based on distance from the player!
;
; TODO: include this only with FEATURE_AUDIO
;-------------------------------------------------------------------------------
        ; note that the C64's SID chip uses volume levels 0 to 15,
        ; with 15 being the maximum
        ;        
        lda ZP_SHIP_ZPOS_HI     ; distance from player...               
        ldx # 11                ; volume 11
        cmp # $10               ; >=$1000?
        bcs :+
        inx ; 12                ; volume 12
        cmp # $08               ; >=$8000?
        bcs :+
        inx ; 13                ; volume 13
        cmp # $06               ; >=$6000?
        bcs :+
        inx ; 14                ; volume 14
        cmp # $03               ; >=$3000?
        bcs :+
        inx ; 15                ; volume 15

:       txa                                                             ;$A7DB
        asl 
        asl 
        asl 
        asl 
        ora # %00000011         ;?
        ldy # $03               ;?
        ldx # $51               ;?
        jmp _a850


sound_play_laserstrike:                                                 ;$A7E9
;===============================================================================
; play the sound of laser-fire hitting a ship:
; the volume is based upon the distance from the player
;
; TODO: this first bit is a duplicate of the same above,
;       so we could turn it into a JSR
;-------------------------------------------------------------------------------
        lda ZP_SHIP_ZPOS_HI     ; distance from player...
        ldx # 11
        cmp # $08
        bcs :+
        inx ; 12
        cmp # $04
        bcs :+
        inx ; 13
        cmp # $03
        bcs :+
        inx ; 14
        cmp # $02
        bcs :+
        inx ; 15

:       txa                                                             ;$A801
        asl 
        asl 
        asl 
        asl 
        ora # %00000011
        ldy # $02
        ldx # $d0
        jmp _a850


.ifdef  FEATURE_AUDIO
;///////////////////////////////////////////////////////////////////////////////
play_sfx_05:                                                            ;$A80F
;===============================================================================
        ldy # $05
        bne play_sfx            ; (always branches)

play_sfx_03:                                            ; BBC: EXNO3    ;$A813
;===============================================================================
        ldy # $03
        bne play_sfx            ; (always branches)
;///////////////////////////////////////////////////////////////////////////////
.endif

_a817:                                                                  ;$A817
;===============================================================================
        ldy # $03
        lda # $01

:       sta _aa15, y                                                    ;$A81B
        dey 
        bne :-
_a821:                                                                  ;$A821
        rts 


_a822:                                                                  ;$A822
;===============================================================================
        ldx # $03
        iny 
        sty ZP_VAR_XX15_2

:       dex                                                             ;$A827
        bmi _a821
        lda _aa13, x
        and # %00111111
        cmp ZP_VAR_XX15_2
        bne :-

        lda # $01
        sta _aa16, x

        rts 


_a839:                                                                  ;$A839
;===============================================================================
; called only by `_3795`
;-------------------------------------------------------------------------------
        ldy # $07
        lda # $f5
        ldx # $f0
        jsr _a850

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $04
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

        ; wait until the next frame:
        ; TODO: could just call `wait_for_frame` instead
        ldy # 1
        jsr wait_frames

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $87               ; high-bit set
        bne play_sfx            ; (awlays branches)
.endif  ;///////////////////////////////////////////////////////////////////////


_a850:                                                                  ;$A850
;===============================================================================
; in:   A                       X1
;       X                       Y1
;       Y                       ?
;-------------------------------------------------------------------------------
        ; WARN: sets overflow flag because _a821 is an RTS (opcode $60)!
        bit _a821
        
        sta ZP_VAR_XX15_0
        stx ZP_VAR_XX15_1

        ; (this causes the `clv` below to become a `branch on overflow clear`.
        ;  the address, made up of the next 2 bytes, is not important because
        ;  the overflow bit is set above)
        .byte   $50

play_sfx:                                                               ;$A858
;===============================================================================
; play a sound effect?
;
; the actual SID twiddling happens during interrupt,
; so this routine sets up the necessary variables
;
; in:   Y                       SFX index
;-------------------------------------------------------------------------------
        clv                     ;?

        ; do nothing if an option is set? (sound off?)
        lda _1d05
        bne _a821               ; ->RTS

        ;-----------------------------------------------------------------------
        ldx # $02
        iny                     ; use Y 1-based
        sty ZP_VAR_XX15_2
        dey                     ; return to 0-based for the lookup
        lda _aa32, y
        lsr                     ; check bit 1 by pushing it off
        bcs @_a876              ; did the bit fall into the carry?

:       lda _aa13, x                                                    ;$A86A
        and # %00111111
        cmp ZP_VAR_XX15_2
        beq @_a88b
        dex 
        bpl :-

@_a876:                                                                 ;$A876
        ldx # $00
        lda _aa19
        cmp _aa1a
        bcc :+
        inx 

        lda _aa1a
:       cmp _aa1b                                                       ;$A884
        bcc @_a88b

        ldx # $02
@_a88b:                                                                  ;$A88B
        tya 
        and # %01111111
        tay 
        lda _aa32, y
        cmp _aa19, x
        bcc _a821

        sei                     ; disable interrupts
        sta _aa19, x
        bvs _a8a0+1
        lda _aa82, y
_a8a0:                                                                  ;$A8A0
       .cmp
        lda ZP_VAR_XX15_0
        sta _aa29, x
        lda _aa42, y
        sta _aa16, x
        lda _aa92, y
        sta _aa1d, x
        lda _aa62, y
        sta _aa23, x
        bvs _a8bd+1
        lda _aa52, y
_a8bd:                                                                  ;$A8BD
       .cmp
        lda ZP_VAR_XX15_1
        sta _aa20, x
        lda _aa72, y
        sta _aa26, x
        lda _aaa2, y
        sta _aa2c, x
        iny 
        tya 
        ora # %10000000
        sta _aa13, x

        cli                     ; enable interrupts
        sec                     ; exit with carry set
        rts 


; NOTE: in the original code, "code_interrupts.asm" appears here
; NOTE: in the original code, "draw_lines.asm" appears here
;
.segment        "CODE_B09D"                                             ;$B09D
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_b09d:                                                                  ;$B09D
;===============================================================================
; plot a multi-color pixel:
;
; in:   VAR_04EB                Y position, in view-port pixels (0-255).
;                               adjusted automatically to nearest multi-
;                               color pixel (0-127)
;       VAR_04EA                X position, in view-port pixels
;       _1d01                   colour-mask
;
;-------------------------------------------------------------------------------
        lda VAR_04EB
        sta ZP_VAR_XX15_1

        lda VAR_04EA
        sta ZP_VAR_XX15_0

        lda _1d01
        sta ZP_32
        cmp # %10101010
        bne _b0b5

_b0b0:                                                                  ;$B0B0
        ;-----------------------------------------------------------------------
        ; draws two multi-color pixels, one atop the other
        ;
        jsr _b0b5               ; draw first multi-color pixel
        dec ZP_VAR_XX15_1       ; move up one pixel and draw again

_b0b5:                                                                  ;$B0B5
        ;-----------------------------------------------------------------------
        ; get bitmap address from X & Y co-ords
        ;
        ldy ZP_VAR_XX15_1
        lda ZP_VAR_XX15_0       ; X-position, in pixels
        and # %11111000         ; clip X to a char-cell
        clc 
        adc row_to_bitmap_lo, y ; add X to the bitmap address by row
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # $00
        sta ZP_TEMP_ADDR1_HI

        ; let Y be the row within the char-cell (0-7)
        tya 
        and # %00000111
        tay 

        ; let X be the column within the char-cell (0-7)
        lda ZP_VAR_XX15_0
        and # %00000111
        tax 

        ; multi-colour pixels are made from pairs of pixels. this lookup
        ; translates a pixel from 0-7 to the nearest multi-colour pixel
        ; e.g.
        ;
        ;       %10------ | %01------ = %11000000
        ;       %--10---- | %--01---- = %00110000
        ;       %----10-- | %----01-- = %00001100
        ;       %------10 | %------01 = %00000011
        ;
        lda _ab47, x
        ;
        ; this only gives us the pixel mask, the actual colour to be drawn
        ; depends upon the two bits of the multi-colour pixel:
        ;
        ;       %00     = background color, i.e. $D021
        ;       %01     = for screen RAM upper-nybble
        ;       %10     = for screen RAM lower-nybble
        ;       %11     = for colour RAM ($D800+)
        ;
        ; a 'colour mask' is used to convert the multi-colour pixel
        ; (regardless of position) into the desired pair. e.g.
        ;
        ;       pixel:     colour-mask:   result:
        ;
        ;       %11000000 AND %00000000 = %00------ (background)
        ;       %00110000 AND %01010101 = %--01---- (screen RAM upper-nybble)
        ;       %00001100 AND %10101010 = %----10-- (screen RAM lower-nybble)
        ;       %00000011 AND %11111111 = %------11 (colour RAM)
        ;
        and ZP_32               ; set colour, i.e. %11, %10, %01, %00
        eor [ZP_TEMP_ADDR1], y  ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y  ; update the screen

        lda _ab49, x            ; look ahead to the next pixel
        bpl @_b0ed

        lda ZP_TEMP_ADDR1_LO
        clc 
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcc :+
        inc ZP_TEMP_ADDR1_HI
:       lda _ab49, x                                                    ;$B0EA

@_b0ed:                                                                 ;$B0ED
        and ZP_32               ; apply the colour-mask to the pixel
        eor [ZP_TEMP_ADDR1], y  ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y  ; update the screen
        rts 


engage_ecm:                                             ; BBC: ECBLB2   ;$B0F4
;===============================================================================
        lda # 32                ; set the ECM counter to 32
        sta ECM_COUNTER

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $09               ; E.C.M. sound?
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

        ; fallthrough
        ; ...

_b0fd:                                                  ; BBC: ECBLB    ;$B0FD
;===============================================================================
; light up the ECM indicator on the HUD?
;
;-------------------------------------------------------------------------------
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3

        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB

        rts 


_SPBLB:                                                 ; BBC: SPBLB    ;$B10E
;===============================================================================
; light the space station bulb on the dashboard:
;-------------------------------------------------------------------------------
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4

        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC

        rts 


update_missile_indicator:                                               ;$B11F
;===============================================================================
; update a selected missile indicator on the HUD:
;
; in:   X                       missile number, 1-4
;       Y                       a colour nybble pair for the missile block
; out:  Y                       =$00
;-------------------------------------------------------------------------------
        dex                     ; switch to zero-based for our purposes
        txa 
        inx 
        eor # %00000011
        sty ZP_TEMP_ADDR1_LO
        tay 
        lda ZP_TEMP_ADDR1_LO
        ; set colour of missile block on screen
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 6 ), y                    ;=$67C6
        
        ldy # $00
        rts 


; unused / unreferenced?                                                ;$B12F
;===============================================================================
        ; probably data rather than code?
        jsr $ffff               ;irq
        cmp # $80
        bcc _b13a

_b136:                                                                  ;$B136
        lda # $07
        clc 
        rts 

        ;-----------------------------------------------------------------------

_b13a:                                                                  ;$B13A
        cmp # $20
        bcs _b146
        cmp # $0d
        beq _b146
        cmp # $15
        bne _b136
_b146:                                                                  ;$B146
        clc 
        rts 


wait_for_frame:                                                         ;$B148
;===============================================================================
; TODO: we may be able to do this more consistently by waiting
;       on the current scanline value ($D012), as this would work
;       regardless of what interrupt code was running (or not!) 
;
;-------------------------------------------------------------------------------
        pha                     ; preserve A

        ; wait for non-zero in the frame status?
:       lda interrupt_split                                             ;$B149
        beq :-
        ; and then wait for it to return to zero?
:       lda interrupt_split                                             ;$B14E
        bne :-

        pla                     ; restore A
        rts 


chrout:                                                                 ;$B155
;===============================================================================
; print a charcter to the bitmap screen:
;
; replaces the KERNAL's `CHROUT` routine for printing text to screen
; (since Elite uses only the bitmap screen)
;
; IMPORTANT NOTE: Elite stores its text in ASCII, not PETSCII!
; this is due to the data being copied over as-is from the BBC
;
; in:   A                       ASCII code of character to print
;-------------------------------------------------------------------------------
        ; re-define the use of some zero-page variables for this routine
        ZP_CHROUT_CHARADDR      := ZP_VAR_P2
        ZP_CHROUT_DRAWADDR      := ZP_TEMP_ADDR1
        ZP_CHROUT_DRAWADDR_LO   := ZP_TEMP_ADDR1_LO
        ZP_CHROUT_DRAWADDR_HI   := ZP_TEMP_ADDR1_HI

        cmp # $7b               ; is code greater than or equal to $7B?
        bcs :+                  ; if yes, skip it
        cmp # $0d               ; is code less than $0D? (RETURN)
        bcc :+                  ; if yes, skip it
        bne paint_char          ; if it's not RETURN, process it

        ; handle the RETURN code
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # TXT_NEWLINE
        jsr paint_char
.else   ;///////////////////////////////////////////////////////////////////////
        jsr paint_newline
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $0d
:       clc                     ; clear carry flag before returning     ;$B166
        rts 

_b168:                                                                  ;$B168
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_05         ; BEEP?
.endif  ;///////////////////////////////////////////////////////////////////////
        jmp _b210               ; restore state and exit

        ;-----------------------------------------------------------------------

_b16e:                                                                  ;$B16E
        jsr _b384               ; clear screen!
        lda ZP_SHIP01_XPOS_pt1
        jmp _b189

        ;-----------------------------------------------------------------------
        ; this is a trampoline to account for a branch range limitation below
        ; TODO: this could be combined with the one at `_b168` to save 3 bytes
        ;
_b176:  jmp _b210                                                       ;B176


paint_newline:                                                          ;$B179
;===============================================================================
; NOTE: called only ever by `_2c7d`!
;-------------------------------------------------------------------------------
        lda # TXT_NEWLINE

        ; fallthrough
        ; ...

paint_char:                                                             ;$B17B
;===============================================================================
; draws a character on the bitmap screen as if it were the text screen
; (automatically advances the cursor)
;
;-------------------------------------------------------------------------------
        ; store current registers
        ; (compatibility with KERNAL_CHROUT?)
        sta ZP_CIRCLE_XPOS
        sty VAR_0490
        stx VAR_048F

        ; cancel if text reaches a certain point?
        ; prevent off-screen writing?
        ldy ZP_PRINT_CASE
        cpy # %11111111
        beq _b176
_b189:                                                                  ;$B189
        cmp # $07               ; code $07? (unspecified in PETSCII)
        beq _b168
        cmp # $20               ; is it SPC or above? (i.e. printable)
        bcs @b1a1
        cmp # $0a               ; is it $0A? (unspecified in PETSCII)
        beq @b199
@b195:                                                                  ;$B195
        ; start at column 2, i.e. leave a one-char padding from the viewport
        ldx # 1
        stx ZP_CURSOR_COL

@b199:  cmp # $0d               ; is it RETURN? although note that      ;$B199
                                ; `chrout` replaces $0D codes with $0C
        beq _b176

        inc ZP_CURSOR_ROW
        bne _b176

@b1a1:                                                                  ;$B1A1
        ;-----------------------------------------------------------------------
        ; convert the PETSCII code to an address in the char gfx (font):
        ; note that the font is ASCII so a few characters appear different
        ; and font graphics are only provided for 96 characters, from space
        ; (32 / $20) onwards
        ;
        tay                     ; put aside the ASCII code

        ; at 8 bytes per character, each page (256 bytes) occupies 32 chars,
        ; so the initial part of this routine is concerned with finding what
        ; the high-address of the character will be
        ;
        ; Elite's font defines 96 characters (3 usable pages),
        ; consisting (roughly) of:
        ;
        ; page 0 = codes 0-31   : invalid, no font gfx here
        ; page 1 = codes 32-63  : most punctuation and numbers
        ; page 2 = codes 64-95  : "@", "A" to "Z", "[", "\", "]", "^", "_"
        ; page 3 = codes 96-127 : "£", "a" to "z", "{", "|", "}", "~"
        ;
        ; default to 0th page since character codes begin from 0,
        ; but in practice we'll only see codes 32-128
        ;
        ldx # (>ELITE_FONT_ADDR) - 1

        ; if you shift any number twice to the left
        ; then numbers 64 or above will carry (> 255)
        asl 
        asl 
        bcc :+                  ; no carry (char code was < 64),
                                ; char is in the 0th (unlikely) or 1st page

        ; -- char is in the 2rd or 3rd page
        ldx # (>ELITE_FONT_ADDR) + 1

        ; shift left again -- codes 32 or over will carry,
        ; so we can determine which of the two possible pages it's in
:       asl                                                             ;$B1AA
        bcc :+                  ; < 32, lower-page
        inx                     ; >= 32, upper-page

        ; note that shifting left 3 times has multiplied our character code
        ; by 8 -- producing an offset appropriate for the font gfx

:       sta ZP_CHROUT_CHARADDR+0                                        ;$B1AE
        stx ZP_CHROUT_CHARADDR+1

        ;-----------------------------------------------------------------------

        ; line-wrap?
        ; TODO: this causes the character address to
        ;       have to be recalculated again!
        lda ZP_CURSOR_COL
        cmp # 31                ; max width of line? (32 chars = 256 px)
        bcs @b195               ; reach the end of the line, carriage-return!

        lda # $80
        sta ZP_CHROUT_DRAWADDR_LO

        lda ZP_CURSOR_ROW
        cmp # 24
        bcc :+

        ; TODO: just copy that code here, or change the branch above to go
        ;       to `_b16e` and favour falling through for the majority case
        jmp _b16e

        ;-----------------------------------------------------------------------

        ; calculate the size of the offset needed for bitmap rows
        ; (320 bytes each). note that A is the current `chrout` row

        ; TODO: this whole thing could seriously do with a lookup table

        ; divide into 64?
:       lsr                                                             ;$B1C5
        ror ZP_CHROUT_DRAWADDR_LO
        lsr 
        ror ZP_CHROUT_DRAWADDR_LO

        ; taking a number and making it the high-byte of a word is just
        ; multiplying it by 256, i.e. shifting left 8 bits

        adc ZP_CURSOR_ROW
        ; re-base to the start of the bitmap screen
        adc #> ELITE_BITMAP_ADDR
        sta ZP_CHROUT_DRAWADDR_HI

        ; calculte the offset of the column
        ; (each character is 8-bytes in the bitmap screen)
        lda ZP_CURSOR_COL
        asl                     ; x2
        asl                     ; x4
        asl                     ; x8
        adc ZP_CHROUT_DRAWADDR_LO
        sta ZP_CHROUT_DRAWADDR_LO
        bcc :+
        inc ZP_CHROUT_DRAWADDR_HI

        ; is this the character code for the solid-block character?
        ; TODO: generate this index in "gfx/font.asm"?
:       cpy # $7f                                                       ;$B1DE
        bne :+

        ; backspace?
        dec ZP_CURSOR_COL
        ; go back 256 pixels??
        dec ZP_CHROUT_DRAWADDR_HI

        ; TODO: erase 8-bytes????
        ldy # $f8
        jsr erase_page_to_end
        beq _b210

:       inc ZP_CURSOR_COL                                               ;$B1ED
        ; this is `sta ZP_TEMP_ADDR1_HI` if you jump in after the `bit`
        ; instruction, but it doesn't look like this actually occurs
       .bit
        sta ZP_TEMP_ADDR1_HI

        ; paint the character (8-bytes) to the screen
        ; TODO: this could be unrolled

        ldy # 7
:       lda [ZP_CHROUT_CHARADDR], y                                     ;$B1F4
        eor [ZP_CHROUT_DRAWADDR], y
        sta [ZP_CHROUT_DRAWADDR], y
        dey 
        bpl :-

        ; lookup the character colour cell from the row/col index:
        ; -- note that Elite has a 256-px (32-char) centred screen,
        ;    so this table returns column 4 ($03) as the 'first' column
        ldy ZP_CURSOR_ROW
        lda menuscr_lo, y
        sta ZP_CHROUT_DRAWADDR_LO
        lda menuscr_hi, y
        sta ZP_CHROUT_DRAWADDR_HI

        ldy ZP_CURSOR_COL
        lda VAR_050C            ; colour?
        sta [ZP_CHROUT_DRAWADDR], y

        ; exit and clean-up:
        ;-----------------------------------------------------------------------
_b210:  ; restore registers before returning                            ;$B210
        ; (compatibility with KERNAL_CHROUT?)
        ;
        ldy VAR_0490
        ldx VAR_048F
        lda ZP_CIRCLE_XPOS

        clc 
        rts 

; NOTE: the original code inserts "orig/clear_screen.asm" here

.segment        "CODE_B3D4"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

tkn_docked_fn15:                                                        ;$B3D4
;===============================================================================
.export tkn_docked_fn15

        lda # $00
        sta OSD_DELAY
        sta VAR_048C

        lda # %11111111
        sta txt_ucase_flag

        lda # %10000000
        sta ZP_PRINT_CASE

        ; clears rows 21, 22 & 23?? (goat soup description?)
        ;-----------------------------------------------------------------------
        lda # 21
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL

        @txt_bmp_addr = ELITE_BITMAP_ADDR + .bmppos( 21, 4 )

        lda #> @txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_HI
        lda #< @txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_LO

        ldx # $03

@_b3f7:                                                                 ;$B3F7
        lda # $00
        tay 

:       sta [ZP_TEMP_ADDR1], y                                          ;$B3FA
        dey 
        bne :-

        ; add 320 to the bitmap address
        ; (move to the next pixel row)
        clc 
        lda ZP_TEMP_ADDR1_LO
        adc #< 320
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc #> 320
        sta ZP_TEMP_ADDR1_HI
        dex 
        bne @_b3f7

_b40f:                                                                  ;$B40F
:       rts 


_SCAN:                                                  ; BBC: SCAN     ;$B410
;===============================================================================
; draw scanner stalk?
;
;-------------------------------------------------------------------------------
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :-                  ; no? exit now (RTS above us)

        ; is the object visible?
        lda ZP_SHIP_STATE
        and # state::scanner
        beq _b40f               ; no? exit now (RTS above us)

        ldx ZP_SHIP_TYPE        ; is it a sun or planet? (bit 7)
        bmi :-                  ; no? exit now (RTS above us)

        lda _267e, x            ; TODO: colour or bitmask for multi-colour
        sta ZP_32               ;       pixels on the scanner?

        ; within range? (scanner shows 16-bits of 24-bit range?)
        ; object X/Y/Z position is 24-bits, so this is the
        ; 2nd byte, what would be the hi-byte in a word
        lda ZP_SHIP_XPOS_HI
        ora ZP_SHIP_YPOS_HI
        ora ZP_SHIP_ZPOS_HI
        ; the maximum value of a 24-bit number is $FF_FFFF,
        ; or +/- 8388607 signed, or 16'777'215 unsigned
        ;
        and # %11000000         ; modulo 16'384? (1024 divisions of 24-bits)
        bne :-                  ; (RTS above us)

        lda ZP_SHIP_XPOS_HI
        clc 

        ; if the middle-byte is within range,
        ; we still need to check the hi-byte
        ;
        ldx ZP_SHIP_XPOS_SIGN
        bpl :+                  ; if positive, skip over the invert

        eor # %11111111         ; flip the bits...
        adc # 1                 ; and add 1

:       adc # $7b               ;=123 (centre X on scanner?)            ;$B438
        sta ZP_VAR_XX15_0

        lda ZP_SHIP_ZPOS_HI
        lsr 
        lsr 
        clc 
        ldx ZP_SHIP_ZPOS_SIGN
        bpl :+
        eor # %11111111
        sec 
:       adc # $53               ;=83                                    ;$B448
        eor # %11111111
        sta ZP_TEMP_ADDR1_LO

        lda ZP_SHIP_YPOS_HI
        lsr 
        clc 
        ldx ZP_SHIP_YPOS_SIGN
        bmi :+
        eor # %11111111
        sec 
:       adc ZP_TEMP_ADDR1_LO                                             ;$B459
        cmp # $92
        bcs :+
        lda # $92
:       cmp # $c7                                                       ;$B461
        bcc :+
        lda # $c6
:       sta ZP_VAR_XX15_1                                               ;$B467

        sec 
        sbc ZP_TEMP_ADDR1_LO
        php 
        pha 
        jsr _b0b0               ; draw two multi-color pixels?
        lda _ab49, x
        and ZP_32
        sta ZP_VAR_XX15_0
        pla 
        plp 
        tax 
        beq _b49a
        bcc _b49b
_b47f:                                                                  ;$B47F
        dey 
        bpl _b491
        ldy # $07
        lda ZP_TEMP_ADDR1_LO
        sec 
        sbc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        sbc # $01
        sta ZP_TEMP_ADDR1_HI
_b491:                                                                  ;$B491
        lda ZP_VAR_XX15_0
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        dex 
        bne _b47f
_b49a:                                                                  ;$B49A
        rts 

        ;-----------------------------------------------------------------------

_b49b:                                                                  ;$B49B
        iny 
        cpy # $08
        bne _b4ae
        ldy # $00
        lda ZP_TEMP_ADDR1_LO
        adc #< (320-1)
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc #> (320-1)
        sta ZP_TEMP_ADDR1_HI
_b4ae:                                                                  ;$B4AE
        iny 
        cpy # $08
        bne _b4c1
        ldy # $00
        lda ZP_TEMP_ADDR1_LO
        adc #< (320-1)
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc #> (320-1)
        sta ZP_TEMP_ADDR1_HI
_b4c1:                                                                  ;$B4C1
        lda ZP_VAR_XX15_0
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        inx 
        bne _b4ae

        rts                                                             ;$B4CA
