; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
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


.segment        "CODE_9932"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; flicker-free drawing doesn't erase the ship in one go,
; instead erasing and redrawing each line spearately:
;
; <bbcelite.com/deep_dives/backporting_the_flicker-free_algorithm.html>

draw_ship_dot:                                          ; BBC: SHPPT    ;$9932
;===============================================================================
; draw a ship as a distance dot:
;-------------------------------------------------------------------------------
.ifndef FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr _EE51               ; erase ship first (if present)
.endif  ;///////////////////////////////////////////////////////////////////////

        ; project the ship's position to the screen;
        ; returns the X-position in K3 (16-bits)
        ; and the Y-position in K4 (16-bits)
        ;
        jsr project_ship

        ora ZP_VAR_K3_HI        ; are either of the hi-bytes > 0?
        bne @novis              ; i.e. outside the screen

        lda ZP_VAR_K4           ; is the Y-position below the viewport?
        cmp # VIEWPORT_HEIGHT-2 ; (viewport is 144 high, not 256)
        bcs @novis              ; -> ship is no longer visible

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr @line               ; add first row of 4-pixel "dot"
.else   ;///////////////////////////////////////////////////////////////////////

        ldy # 2                 ; set heap index for Y1
        jsr @line               ; "Ship is point, could end if nono-2"
        ldy # 6                 ; set heap index for next line

.endif  ;///////////////////////////////////////////////////////////////////////

        lda ZP_VAR_K4           ; move to the next pixel row
        adc # $01               ;  and draw the second half of the "dot"
        jsr @line               ; 

        lda # state::redraw     ; set the ship's flag to indicate that
        ora ZP_SHIP_STATE       ;  it has been drawn on screen, and
        sta ZP_SHIP_STATE       ;  therefore must be erased to redraw

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jmp _LL155
.else   ;///////////////////////////////////////////////////////////////////////
        lda # $08               ; "skip first two edges on heap"
        jmp _a174

@995b:  pla                     ; change return address?                ;$995B
        pla                     ; change return address?
.endif  ;///////////////////////////////////////////////////////////////////////

        ; ship has been erased, and is no longer visible:
        ;-----------------------------------------------------------------------
@novis: lda # state::redraw^$FF ; remove flag indicating that ship      ;$995D
        and ZP_SHIP_STATE       ;  has been drawn on screen --
        sta ZP_SHIP_STATE       ;  it will not need erasing again

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jmp _LL155
.else   ;///////////////////////////////////////////////////////////////////////
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

@line:                                                  ; BBC: SHPT     ;$9964
        ;=======================================================================
        ; draw a 4-pixel "line" for one-half of the "dot"; this sub-routine
        ; will be called twice to fill in both halves
        ;
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_LINE_Y1          ; as it's a horizontal line,
        sta ZP_LINE_Y2          ;  Y1 & Y2 will be the same
        
        lda ZP_VAR_K3           ; ship X-coordinate
        sta ZP_LINE_X1          ; start of line
        clc                     ;
        adc # 3                 ; now add 3 to get the X2 co-ordinate
        bcc :+                  ; if clips the viewport,
        lda # VIEWPORT_WIDTH-1  ;  keep it within
:       sta ZP_LINE_X2          ;

        jmp redraw_ship_line    ; erase old line & draw new

.else   ;///////////////////////////////////////////////////////////////////////
        ; as it's a horizontal line, Y1 & Y2 will be the same
        ;
        sta [ZP_SHIP_HEAP], y   ; write Y1 to the line-heap
        iny                     ; (increment to X2)
        iny                     ; (increment to Y2)
        sta [ZP_SHIP_HEAP], y   ; write Y2 to the line-heap
        
        lda ZP_VAR_K3           ; get ship screen X-position
        dey                     ; (decrement to X2)
        sta [ZP_SHIP_HEAP], y   ; write X2 to the line-heap
        adc # 3                 ; add 3 to the X-position
        bcs @995b               ; clips viewport?

        dey                     ; (decrement to Y1)
        dey                     ; (decrement to X1)
        sta [ZP_SHIP_HEAP], y   ; write X1 to the line-heap

        rts 
.endif  ;///////////////////////////////////////////////////////////////////////


; NOTE: in the original, segment "CODE_9978" goes here                  ; $9978
; NOTE: in the original, segment "CODE_99AF" goes here                  ; $99AF


.segment        "CODE_9A0C"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_9a0c:                                                                  ;$9A0C
;===============================================================================
; returns A=Q+R, sign-bit S. regards two sign-bits in A,S.
; only uses A (and stack). this is another example of the curious
; "unsigned value+sign bit" math used at many places in Elite.
; TODO: name proposal? add_bytes_external_sign?
; we probably need a consistent naming for both the
; unsigned_with_sign_bit and the unsigned_with_external_sign-variables
;-------------------------------------------------------------------------------
        eor S
        bmi :+                  ; if (sign1 == sign2) return Q+R, keep sign
        lda Q
        clc 
        adc R
        rts 

:       lda R                                                           ;$9A16
        sec 
        sbc Q
        bcc :+                  ; if (R>=Q) return R-Q
        clc 
        rts 

:       pha                                                             ;$9A1F
        lda S                   ; if (R<Q) sign=-sign; return Q-R
        eor # %10000000
        sta S
        pla 
        eor # %11111111
        adc # $01
        rts 


math_dot_product:                                       ; BBC: LL51     ;$9A2C
;===============================================================================
; <https://www.bbcelite.com/master/main/subroutine/ll51.html>
;-------------------------------------------------------------------------------
        ldx # $00
        ldy # $00
_9a30:                                                                  ;$9A30
        lda ZP_VAR_XX15_0
        sta Q
        lda ZP_ROTATE, x
        jsr _39ea               ; A=(A*Q)/256
        sta T
        lda ZP_VAR_XX15_1
        eor ZP_ROTATE_M2x0_HI, x
        sta S
        lda ZP_VAR_XX15_2
        sta Q
        lda ZP_ROTATE_M2x1_LO, x
        jsr _39ea               ; A=(A*Q)/256
        sta Q
        lda T
        sta R
        lda ZP_VAR_XX15_3
        eor ZP_ROTATE_M2x1_HI, x
        jsr _9a0c
        sta T
        lda ZP_VAR_XX15_4
        sta Q
        lda ZP_ROTATE_M2x2_LO, x
        jsr _39ea               ; A=(A*Q)/256
        sta Q
        lda T
        sta R
        lda ZP_VAR_XX15_5
        eor ZP_ROTATE_M2x2_HI, x
        jsr _9a0c
        sta ZP_VAR_XX12_0, y
        lda S
        sta ZP_VAR_XX12_1, y
        iny 
        iny 
        txa 
        clc 
        adc # $06
        tax 
        cmp # $11
        bcc _9a30

        rts 


.segment        "CODE_9A83"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; draw_ship:
;===============================================================================
; [1]:  
;-------------------------------------------------------------------------------
:       jmp _7d62               ; go draw sun or planet                 ;$9A83

draw_ship:                                              ; BBC: LL9      ;$9A86
        ;=======================================================================
        lda ZP_SHIP_TYPE        ; check ship type
        bmi :-                  ; hi-bit indicates sun or planet
        
        lda # 31                ; set a default ship distance
        sta ZP_VAR_XX4          ;  (will be populated later)

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ldy # 1
        sty ZP_VAR_XX14+0
        dey

        lda # state::redraw
        bit ZP_SHIP_STATE
        bne :+
        lda # 0
       .bit                     ; (skip next instruction)
        lda [ZP_SHIP_HEAP], y
:       sta ZP_VAR_XX14+1
.endif  ;///////////////////////////////////////////////////////////////////////

        ; is the ship being manually removed? (has to be erased from screen)
        ; this occurs when a ship either docks or is scooped (for cannisters)
        ;
        lda ZP_SHIP_BEHAVIOUR
        bmi _EE51               ; -> remove ship from screen

        ; exploded?
        ;=======================================================================
        ; before erasing + drawing the ship we should check if it's been
        ; destroyed; there are two states, a flag to indicate that a ship has
        ; just been killed and needs erasing, and a flag to indicate that the
        ; ship is a cloud of debris and shouldn't have its lines drawn
        ;
        lda # state::debris     ; = is debris?
        bit ZP_SHIP_STATE       ; check against state of the ship
        bne @9ac5               ; is debris
        bpl @9ac5               ; 

        ; erase ship and explode it:
        ;-----------------------------------------------------------------------
        ; stop the ship firing and remove its 'just killed' state
        ; as we're going to create the debris cloud
        ;
        ora ZP_SHIP_STATE
        and # (state::exploding | state::firing)^$FF    ;=%00111111
        sta ZP_SHIP_STATE

        ; halt acceleration + pitch
        ; TODO: should we keep this so that the debris "sprays"?
        ;
        lda # $00
        ldy # Ship::acceleration
        sta [ZP_SHIP_ADDR], y
        ldy # Ship::pitch
        sta [ZP_SHIP_ADDR], y
        jsr _EE51               ; remove ship from screen

        ; create debris cloud:
        ;-----------------------------------------------------------------------
        ldy # 1                 ; set byte 1 of ship heap to the
        lda # 18                ; initial size (scale) of the debris cloud
        sta [ZP_SHIP_HEAP], y

        ldy # Hull::_07         ; read the number of debris
        lda [ZP_HULL_ADDR], y   ;  particles this ship produces
        ldy # 2                 ;  and place that into byte 2
        sta [ZP_SHIP_HEAP], y   ;  of the ship heap

        ; randomize the next 4 bytes in the ship heap:
        ;
:       iny                     ; increment heap index (bytes 3-6)      ;$9ABB
        jsr get_random_number
        sta [ZP_SHIP_HEAP], y
        cpy # $06               ; was this the 6th byte in the heap?
        bne :-                  ; if not, keep going

@9ac5:  lda ZP_SHIP_ZPOS_SIGN   ; z-sign, i.e. fore or aft to us        ;$9AC5
        bpl _9ae6               ; if visible to us, erase the ship

        ; fallthrough implies
        ; ship is behind us...
        ;

_9ac9:                                                  ; BBC: LL14     ;$9AC9
        ;-----------------------------------------------------------------------
        lda ZP_SHIP_STATE       ; is the ship solid or a debris cloud?
        and # state::debris
        beq _EE51               ; -> remove ship from screen

        lda ZP_SHIP_STATE
        and # state::redraw^$FF
        sta ZP_SHIP_STATE
        jmp draw_explosion      ; -> draw explosion cloud


_EE51:                                                  ; BBC: EE51     ;$9AD8
        ;-----------------------------------------------------------------------
        lda # state::redraw     ; sanity check: check the state bit that
        bit ZP_SHIP_STATE       ;  indicates if the ship has been drawn before
        beq :+                  ; if not, it doesn't need erasing, skip out

        eor ZP_SHIP_STATE       ; flip the state bit,
        sta ZP_SHIP_STATE       ;  to indicate the ship is not on screen
        jmp _LL155              ;  before erasing ship by redrawing it

:       rts                                                             ;$9AE5

_9ae6:                                                  ; BBC: LL10     ;$9AE6
;===============================================================================
; [2]:  check if a ship is within visible position / range:
;
; in:   ZP_VAR_XX4              default ship distance, 31, set in `draw_ship`
;-------------------------------------------------------------------------------
        lda ZP_SHIP_ZPOS_HI     ; check the ship's Z-position (fore/aft)
        cmp # 192               ; if > 192 distance ahead? ship is out of range,
        bcs _9ac9               ;  so erase it from screen by drawing over it

        ; ship is ahead of us, but is it visible to us?
        ;
        ; check the ship position against a 90deg field of view;
        ; 90deg is used so that the X/Z cross-over creates an easy
        ; visbility boundary: (overhead view)
        ;
        ;                (fore)
        ;          Z=-X    +Z     X=Z
        ;              \    |    /
        ;               \   |   /
        ;                \  |  /
        ;                 \ | /
        ;    (left) -X ----[ ]---- +X (right)
        ;
        lda ZP_SHIP_XPOS_LO     ; comparing the hi-bytes of X & Z sets carry
        cmp ZP_SHIP_ZPOS_LO     ;  as the sign, so that the subtraction below
        lda ZP_SHIP_XPOS_HI     ;  borrows according to sign, allowing for
        sbc ZP_SHIP_ZPOS_HI     ;  comparing both positive & negative bounds
        bcs _9ac9               ; if X >= Z, erase ship from screen

        ; the same applies the the vertical visiblity range,
        ; with a 90deg field of view: (sideways view)
        ;
        ;      (up) -Y    Z=-Y
        ;            |   /
        ;            |  /
        ;            | /
        ;           [ ]--- +Z (fore)
        ;            | \
        ;            |  \
        ;            |   \
        ;    (down) +Y    Y=Z
        ;
        lda ZP_SHIP_YPOS_LO     ; comparing the hi-bytes of Y & Z sets carry
        cmp ZP_SHIP_ZPOS_LO     ;  as the sign, so that the subtraction below
        lda ZP_SHIP_YPOS_HI     ;  borrows according to sign, allowing for
        sbc ZP_SHIP_ZPOS_HI     ;  comparing both positive & negative bounds
        bcs _9ac9               ; if Y >= Z, erase ship from screen

        ; are they firing their laser?
        ;-----------------------------------------------------------------------
        ; get the vertex where the ship's lasers come from
        ldy # Hull::laser_vertex
        lda [ZP_HULL_ADDR], y
        tax 

        ; TODO: the screen-coordinates for all visible vertices will be stored
        ;       in the stack space. what's the maximum size of this -- can we
        ;       put it in zero page, where there's 38+ bytes free around $D2?
        ;
        lda # $ff
        sta $0100, x
        sta $0101, x

        ; determine level-of-detail to use:
        ;-----------------------------------------------------------------------
        ; downscale the Z-position
        ; divide ship Z-position by 16:
        ;
        lda ZP_SHIP_ZPOS_LO     ; read Z-position (16-bits) into T.A
        sta T
        lda ZP_SHIP_ZPOS_HI
        lsr                     ; divide by 2
        ror T                   ; (ripple to hi-byte)
        lsr                     ; divide by 4
        ror T                   ; (ripple to hi-byte)
        lsr                     ; divide by 8
        ror T                   ; (ripple to hi-byte)
        lsr                     ; divide by 16
        bne _9b29               ; 

        lda T
        ror 
        lsr 
        lsr 
        lsr 
        sta ZP_VAR_XX4          ; update ship-distance byte set in `draw_ship`
        bpl _9b3a               ; (always branches!)
        
        ; read the byte from the ship's hull definition that sets
        ; the LOD-distance at which the ship should become a dot
        ;
_9b29:  ldy # Hull::lod_distance                                        ;$9B29
        lda [ZP_HULL_ADDR], y
        cmp ZP_SHIP_ZPOS_HI     ; compare ship distance (hi) and LOD-distance;
        bcs _9b3a               ; if below LOD-distance, draw full wireframe

        lda # state::debris     ; has the ship exploded into a debris cloud?
        and ZP_SHIP_STATE       ; if yes, draw as normal,
        bne _9b3a               ;  which will draw the particles

        ; TODO: only place this routine is called,
        ;       could inline it here
        ;
        jmp draw_ship_dot       ; if no, draw the ship as a distant dot


_9b3a:                                                  ; BBC: LL17     ;$9B3A
;===============================================================================
; [3]:  
;-------------------------------------------------------------------------------
        ldx # 5                 ; 6-byte counter (0-based)
:       lda ZP_SHIP_M2x0, x     ; take a copy of ship matrix            ;$9B3C
        sta ZP_ROTATE_M2x0, x   ;  2x0, 2x1 & 2x2, aka "side"
        lda ZP_SHIP_M1x0, x     ; take a copy of ship matrix
        sta ZP_ROTATE_M1x0, x   ;  1x0, 1x1 & 1x2, aka "roof"
        lda ZP_SHIP_M0x0, x     ; take a copy of ship matrix
        sta ZP_ROTATE_M0x0, x   ;  0x0, 0x1 & 0x2, aka "nose"
        dex 
        bpl :-

        ; scale the vectors:
        ;-----------------------------------------------------------------------
        lda # 197
        sta Q

        ; work through the co-ordinates:
        ; each vector is a 2-byte word
        ;
        ldy # 16                ; 16 bytes

:       lda ZP_ROTATE_LO, y     ;                                       ;$9B51
        asl                     ;  multiply the vector by two, 
        lda ZP_ROTATE_HI, y     ;   removing the sign-bit
        rol                     ;
        jsr math_divide_AQ      ; divide by Q (why is Q 197??)

        ldx R                   ; store result in lo-byte
        stx ZP_ROTATE, y        ;
        
        dey                     ; move to the next vector
        dey                     ; (skip both bytes)
        bpl :-

        ; copy ship co-ordinates:
        ;-----------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ldx # 8                 ; copy 9 bytes (0-based)
:       lda ZP_SHIP, x                                             ;$9B66
        sta ZP_VAR_XX18, x
        dex 
        bpl :-
.else   ;///////////////////////////////////////////////////////////////////////
        ; unroll the above for a very small optimisation
        ;
        lda ZP_SHIP_XPOS_LO
        sta ZP_VAR_XX18_0
        lda ZP_SHIP_XPOS_HI
        sta ZP_VAR_XX18_1
        lda ZP_SHIP_XPOS_SIGN
        sta ZP_VAR_XX18_2
        lda ZP_SHIP_YPOS_LO
        sta ZP_VAR_XX18_3
        lda ZP_SHIP_YPOS_HI
        sta ZP_VAR_XX18_4
        lda ZP_SHIP_YPOS_SIGN
        sta ZP_VAR_XX18_5
        lda ZP_SHIP_ZPOS_LO
        sta ZP_VAR_XX18_6
        lda ZP_SHIP_ZPOS_HI
        sta ZP_VAR_XX18_7
        lda ZP_SHIP_ZPOS_SIGN
        sta ZP_VAR_XX18_8
.endif  ;///////////////////////////////////////////////////////////////////////

        ; force ship face #15 to be always visible(?)
        lda # $ff
        sta ZP_CIRCLE_YPOS_HI   ; BBC: 15th byte of XX2

        ; solid or exploding?
        ;-----------------------------------------------------------------------
        ldy # Hull::face_count  ; select the face-count property
        lda ZP_SHIP_STATE       ; check the ship's state to see if
        and # state::debris     ;  it's solid or a cloud of debris
        beq _9b8b               ; solid? -> draw wireframe

;===============================================================================
; [4]:  set visibility for exploding ship
;-------------------------------------------------------------------------------
        lda [ZP_HULL_ADDR], y   ; read the ship face-count;
        lsr                     ;  this is stored as the number of vertices,
        lsr                     ;  for looping convenience, so divide by 4
        tax                     ;  to get the actual face-count

        ; set all faces to visible:
        ; (for an explosion)
        ;
        lda # $ff
:       sta ZP_SHIP01_XPOS_pt1, x                                       ;$9B80
        dex 
        bpl :-

        inx                     ; (roll A over to 0)
        stx ZP_VAR_XX4          ; set distance to 0 (part of forced visibility)

        ; skip over face-visbility checks since we've
        ; forced them all visible for the explosion
_9b88:  jmp _LL42                                                       ;$9B88


_9b8b:                                                  ; BBC: EE29     ;$9B8B
;===============================================================================
; [5]:  
;-------------------------------------------------------------------------------
        lda [ZP_HULL_ADDR], y   ; read number of faces (*4)
        beq _9b88               ; no faces?

        sta ZP_VAR_XX20

        ldy # Hull::_12         ;=$12: "scaling of normals"?
        lda [ZP_HULL_ADDR], y
        tax 
        lda ZP_VAR_K6_3
        tay 
        beq _9baa

:       inx                                                             ;$9B9B
        lsr ZP_VAR_K6
        ror ZP_VAR_K5_3
        lsr ZP_VAR_K5_1
        ror ZP_VAR_K5
        lsr 
        ror ZP_VAR_K6_2
        tay 
        bne :-

_9baa:  stx ZP_VAR_XX17                                                 ;$9BAA
        lda ZP_VAR_XX18_8
        sta ZP_VAR_XX15_5
        lda ZP_VAR_K5
        sta ZP_VAR_XX15_0
        lda ZP_VAR_K5_2
        sta ZP_VAR_XX15_1
        lda ZP_VAR_K5_3
        sta ZP_VAR_XX15_2
        lda ZP_VAR_K6_1
        sta ZP_VAR_XX15_3
        lda ZP_VAR_K6_2
        sta ZP_VAR_XX15_4
        jsr math_dot_product

        lda ZP_VAR_XX12_0
        sta ZP_VAR_K5
        lda ZP_VAR_XX12_1
        sta ZP_VAR_K5_2
        lda ZP_VAR_XX12_2
        sta ZP_VAR_K5_3
        lda ZP_VAR_XX12_3
        sta ZP_VAR_K6_1
        lda ZP_VAR_XX12_4
        sta ZP_VAR_K6_2
        lda ZP_VAR_XX12_5
        sta ZP_VAR_XX18_8

        ldy # Hull::face_data_lo
        lda [ZP_HULL_ADDR], y
        clc 
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR2_LO

        ldy # Hull::face_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR2_HI

        ldy # Hull::scoop_debris

_9bf2:  lda [ZP_TEMP_ADDR2], y                                          ;$9BF2
        sta ZP_VAR_XX12_1
        and # %00011111
        cmp ZP_VAR_XX4
        bcs _9c0b

        tya 
        lsr 
        lsr 
        tax 
        lda # $ff
        sta ZP_SHIP01_XPOS_pt1, x
        tya 
        adc # $04
        tay 
        jmp _9cf7

_9c0b:  lda ZP_VAR_XX12_1                                               ;$9C0B
        asl 
        sta ZP_VAR_XX12_3
        asl 
        sta ZP_VAR_XX12_5

        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_XX12_0
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_XX12_2
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_XX12_4

        ldx ZP_VAR_XX17
        cpx # $04
        bcc _9c4b

        lda ZP_VAR_K5
        sta ZP_VAR_XX15_0
        lda ZP_VAR_K5_2
        sta ZP_VAR_XX15_1
        lda ZP_VAR_K5_3
        sta ZP_VAR_XX15_2
        lda ZP_VAR_K6_1
        sta ZP_VAR_XX15_3
        lda ZP_VAR_K6_2
        sta ZP_VAR_XX15_4
        lda ZP_VAR_XX18_8
        sta ZP_VAR_XX15_5
        jmp _9ca9

_9c43:  lsr ZP_VAR_K5                                                   ;$9C43
        lsr ZP_VAR_K6_2
        lsr ZP_VAR_K5_3
        ldx # $01

_9c4b:  lda ZP_VAR_XX12_0                                               ;$9C4B
        sta ZP_VAR_XX15_0
        lda ZP_VAR_XX12_2
        sta ZP_VAR_XX15_2
        lda ZP_VAR_XX12_4
        dex 
        bmi _9c60

_9c58:  lsr ZP_VAR_XX15_0                                               ;$9C58
        lsr ZP_VAR_XX15_2
        lsr 
        dex 
        bpl _9c58

_9c60:  sta R                                                           ;$9C60
        lda ZP_VAR_XX12_5
        sta S
        lda ZP_VAR_K6_2
        sta Q
        lda ZP_VAR_XX18_8
        jsr _9a0c
        bcs _9c43

        sta ZP_VAR_XX15_4
        lda S
        sta ZP_VAR_XX15_5
        lda ZP_VAR_XX15_0
        sta R
        lda ZP_VAR_XX12_1
        sta S
        lda ZP_VAR_K5
        sta Q
        lda ZP_VAR_K5_2
        jsr _9a0c
        bcs _9c43

        sta ZP_VAR_XX15_0
        lda S
        sta ZP_VAR_XX15_1
        lda ZP_VAR_XX15_2
        sta R
        lda ZP_VAR_XX12_3
        sta S
        lda ZP_VAR_K5_3
        sta Q
        lda ZP_VAR_K6_1
        jsr _9a0c
        bcs _9c43

        sta ZP_VAR_XX15_2
        lda S
        sta ZP_VAR_XX15_3

_9ca9:  lda ZP_VAR_XX12_0                                               ;$9CA9
        sta Q
        lda ZP_VAR_XX15_0
        jsr _39ea               ; A=(A*Q)/256
        sta T

        lda ZP_VAR_XX12_1
        eor ZP_VAR_XX15_1
        sta S
        lda ZP_VAR_XX12_2
        sta Q
        lda ZP_VAR_XX15_2
        jsr _39ea               ; A=(A*Q)/256
        sta Q
        lda T
        sta R
        lda ZP_VAR_XX12_3
        eor ZP_VAR_XX15_3
        jsr _9a0c
        sta T
        lda ZP_VAR_XX12_4
        sta Q
        lda ZP_VAR_XX15_4
        jsr _39ea               ; A=(A*Q)/256
        sta Q
        lda T
        sta R
        lda ZP_VAR_XX15_5
        eor ZP_VAR_XX12_5
        jsr _9a0c

        pha 
        tya 
        lsr 
        lsr 
        tax 
        pla 
        bit S
        bmi _9cf4

        lda # $00
_9cf4:  sta ZP_SHIP01_XPOS_pt1, x                                       ;$9CF4
        iny 

_9cf7:  cpy ZP_VAR_XX20                                                 ;$9CF7
        bcs _LL42
        jmp _9bf2

_LL42:                                                  ; BBC: LL42     ;$9CFE
;===============================================================================
; [6]:  calculate the visibility of each vertex in the ship
;       and transpose to screen co-ordinates
;-------------------------------------------------------------------------------
        ; invert the matrix:
        ldy ZP_ROTATE_M2x1_LO
        ldx ZP_ROTATE_M2x1_HI
        lda ZP_ROTATE_M1x0_LO
        sta ZP_ROTATE_M2x1_LO
        lda ZP_ROTATE_M1x0_HI
        sta ZP_ROTATE_M2x1_HI
        sty ZP_ROTATE_M1x0_LO
        stx ZP_ROTATE_M1x0_HI
        ldy ZP_ROTATE_M2x2_LO
        ldx ZP_ROTATE_M2x2_HI
        lda ZP_ROTATE_M0x0_LO
        sta ZP_ROTATE_M2x2_LO
        lda ZP_ROTATE_M0x0_HI
        sta ZP_ROTATE_M2x2_HI
        sty ZP_ROTATE_M0x0_LO
        stx ZP_ROTATE_M0x0_HI
        ldy ZP_ROTATE_M1x2_LO
        ldx ZP_ROTATE_M1x2_HI
        lda ZP_ROTATE_M0x1_LO
        sta ZP_ROTATE_M1x2_LO
        lda ZP_ROTATE_M0x1_HI
        sta ZP_ROTATE_M1x2_HI
        sty ZP_ROTATE_M0x1_LO
        stx ZP_ROTATE_M0x1_HI

        ; read number of vertices:
        ;
        ldy # Hull::vertex_count
        lda [ZP_HULL_ADDR], y
        sta ZP_VAR_XX20

        ; create a pointer in the ship's hull data to start
        ; at the vertex data that follows the hull definition:
        ; -- see the files in "/src/hulls"
        lda ZP_HULL_ADDR_LO
        clc 
        adc # .sizeof( Hull )   ; first byte after the Hull struct
        sta ZP_TEMP_ADDR2_LO
        lda ZP_HULL_ADDR_HI
        adc # $00
        sta ZP_TEMP_ADDR2_HI

        ldy # 0                 ; set counter for vertices;
        sty ZP_TEMP_COUNTER     ; (each is 6-bytes)
        ;-----------------------------------------------------------------------
_9d45:  sty ZP_VAR_XX17         ; set heap pointer to zero              ;$9D45
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #0: X-magnitude
        sta ZP_VAR_XX15_0
        iny 
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #1: Y-magnitude
        sta ZP_VAR_XX15_2
        iny 
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #2: Z-magnitude
        sta ZP_VAR_XX15_4
        iny 

        ; TODO: can this byte come first to save reading the three bytes
        ;       above? is this data needed after the vertex is skipped?
        ;
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #3: signs & vis-distance
        sta T                   ; (keep this value in T)
        and # %00011111         ; extract the vertex visibility distance
        cmp ZP_VAR_XX4          ; compare with ship's z-distance (0-31)
        bcc :+                  ; if not visible, skip vertex

        iny 
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #4: face 1 & 2
        sta ZP_VAR_P            ; (keep this value in P)
        and # %00001111         ; extract face 1 index
        tax                     ; check this face against
        lda ZP_VAR_XX2, x       ;  the visbility test done earlier
        bne _9d91               ; if visible, skip other checks

        lda ZP_VAR_P            ; retrieve face 1 & 2 byte
        lsr                     ;
        lsr                     ; extract the upper nybble
        lsr                     ;  by shifting down 4 times
        lsr                     ;
        tax                     ; check face 2 against
        lda ZP_VAR_XX2, x       ;  the visibility test done earlier
        bne _9d91               ; if visible, skip other checks

        iny
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #5: face 3 & 4
        sta ZP_VAR_P            ; (keep this value in P)
        and # %00001111         ; extract face 3 index
        tax                     ; check this face against
        lda ZP_VAR_XX2, x       ;  the visbility test done earlier
        bne _9d91               ; if visible, skip other checks

        lda ZP_VAR_P1           ; retrieve face 3 & 4 byte
        lsr                     ;
        lsr                     ; extract the upper nybble
        lsr                     ;  by shifting down 4 times
        lsr                     ;
        tax                     ; check face 4 against
        lda ZP_VAR_XX2, x       ;  the visibility test done earlier
        bne _9d91               ; if visible, skip other checks

        ; no faces attached to this vertex are visible,
        ; so the vertex itself does not need to be visible
:       jmp _9f06                                                       ;$9D8E

_9d91:                                                  ; BBC: LL49     ;$9D91
        ;=======================================================================
        lda T                   ; retrieve the byte with the X/Y/Z sign-bits
        sta ZP_VAR_XX15_1       ; store the X sign bit (other bits ignored)
        asl                     ; shift the Y sign-bit up
        sta ZP_VAR_XX15_3       ; store the Y sign bit (other bits ignored)
        asl                     ; shift the Z sign-bit up
        sta ZP_VAR_XX15_5       ; store the Z sign-bit (other bits ignored)
        
        ; dot product XX15 (the vertex co-ords) and XX16 (the rotation matrix)
        ; into XX12, which will contain the vector from the centre of the ship
        ; to the vertex
        jsr math_dot_product

        ; compare signs:
        lda ZP_SHIP_XPOS_SIGN   ; sign-bit of the ship's X-position
        sta ZP_VAR_XX15_2
        eor ZP_VAR_XX12_1       ; XOR with translated X-position
        bmi :+                  ; if the signs differ, skip over

        ; X-signs match:
        ;-----------------------------------------------------------------------
        clc                     ; add vertex X-position to the ship's X-position
        lda ZP_VAR_XX12_0
        adc ZP_SHIP_XPOS_LO
        sta ZP_VAR_XX15_0
        lda ZP_SHIP_XPOS_HI
        adc # 0
        sta ZP_VAR_XX15_1

        jmp @ysign               ; X-coord done, skip to Y-coord

        ; X-signs differ:
        ;-----------------------------------------------------------------------
:       lda ZP_SHIP_XPOS_LO                                             ;$9DB6
        sec 
        sbc ZP_VAR_XX12_0
        sta ZP_VAR_XX15_0
        lda ZP_SHIP_XPOS_HI
        sbc # 0
        sta ZP_VAR_XX15_1
        bcs @ysign

        eor # %11111111
        sta ZP_VAR_XX15_1
        lda # 1
        sbc ZP_VAR_XX15_0
        sta ZP_VAR_XX15_0
        bcc :+
        inc ZP_VAR_XX15_1
:       lda ZP_VAR_XX15_2                                               ;$9DD3
        eor # %10000000
        sta ZP_VAR_XX15_2

        ; compare Y-signs:                                              ;$9DD9
        ;-----------------------------------------------------------------------
@ysign: lda ZP_SHIP_YPOS_SIGN
        sta ZP_VAR_XX15_5
        eor ZP_VAR_XX12_3
        bmi :+

        ; Y-signs match:
        ;-----------------------------------------------------------------------
        clc 
        lda ZP_VAR_XX12_2
        adc ZP_SHIP_YPOS_LO
        sta ZP_VAR_XX15_3
        lda ZP_SHIP_YPOS_HI
        adc # 0
        sta ZP_VAR_XX15_4

        jmp @zsign

        ; Y-signs differ:
        ;-----------------------------------------------------------------------
:       lda ZP_SHIP_YPOS_LO                                             ;$9DF1
        sec 
        sbc ZP_VAR_XX12_2
        sta ZP_VAR_XX15_3
        lda ZP_SHIP_YPOS_HI
        sbc # 0
        sta ZP_VAR_XX15_4
        bcs @zsign

        eor # %11111111
        sta ZP_VAR_XX15_4
        lda ZP_VAR_XX15_3
        eor # %11111111
        adc # 1
        sta ZP_VAR_XX15_3
        lda ZP_VAR_XX15_5
        eor # %10000000
        sta ZP_VAR_XX15_5
        bcc @zsign
        inc ZP_VAR_XX15_4

        ; Z-sign:
        ;-----------------------------------------------------------------------
        ; we know the sign of the ship's Z-position has to be 0,
        ; otherwise the ship wouldn't be visible (in front of us)
        ;
@zsign: lda ZP_VAR_XX12_5                                               ;$9E16
        bmi _9e64

        lda ZP_VAR_XX12_4
        clc 
        adc ZP_SHIP_ZPOS_LO
        sta T
        lda ZP_SHIP_ZPOS_HI
        adc # 0
        sta U

        jmp _9e83

_9e2a:                                                  ; BBC: LL61     ;$9E2A
        ;=======================================================================
        ; ".LL61 ; Handling division R=A/Q for case further down"
        ;
        ldx Q
        beq @9e4a
        ldx # $00

        ; ".LL63 ; roll Acc count Xreg"
:       lsr                                                             ;$9E30
        inx 
        cmp Q
        bcs :-
        stx S
        jsr math_divide_AQ
        ldx S
        lda R

        ; ".LL64 ; counter Xreg"
:       asl                                                             ;$9E3F
        rol U
        bmi @9e4a
        dex 
        bne :-
        sta R
        rts 

        ; ".LL84 ; div error R=U=#50"
@9e4a:  lda # $32                                                       ;$9E4A
        sta R
        sta U
        rts 

; ".LL62 ; Arrive from LL65 just below,
;  screen for -ve RU onto XX3 heap, index X=CNT"
;
_9e51:                                                  ; BBC: LL62     ;$9E51
        ;=======================================================================
        lda # $80
        sec 
        sbc R
        sta $0100, x
        inx 
        lda # $00
        sbc U
        sta $0100, x
        jmp _9ec3

_9e64:                                                  ; BBC: LL56     ;$9E64
;===============================================================================
; [7]:  
;===============================================================================
        lda ZP_SHIP_ZPOS_LO     ; "z org lo"
        sec 
        sbc ZP_VAR_XX12_4       ; "rotated z node lo"
        sta T

        lda ZP_SHIP_ZPOS_HI     ; "z hi"
        sbc # 0
        sta U
        bcc _9e7b               ; "underflow, make node close"
        bne _9e83               ; "Enter Node additions done, UT=z"
        
        lda T                   ; "restore z lo"
        cmp # 4                 ; "">= 4?"
        bcs _9e83               ; "zlo big enough, Enter Node additions done"

        ; ".LL140 ; else make node close"
_9e7b:                                                                  ;$9E7B
        lda # $00               ; "hi"?
        sta U
        lda # $04               ; "lo"?
        sta T

        ; scale result down to 8-bits
        ;-----------------------------------------------------------------------
_9e83:  lda U                                           ; BBC: LL57     ;$9E83
        ora ZP_VAR_XX15_1
        ora ZP_VAR_XX15_4
        beq _LL60

        lsr ZP_VAR_XX15_1
        ror ZP_VAR_XX15_0
        lsr ZP_VAR_XX15_4
        ror ZP_VAR_XX15_3
        lsr U
        ror T
        jmp _9e83

_LL60:                                                  ; BBC: LL60     ;$9E9A
;===============================================================================
; [8]:  
;===============================================================================
        lda T
        sta Q

        lda ZP_VAR_XX15_0
        cmp Q
        bcc :+

        jsr _9e2a
        jmp _9ead

        ; ".LL69 ; small x angle"
:       jsr math_divide_AQ                                              ;$9EAA

        ; ".LL65 ; both continue for scaling based on z"
_9ead:  ldx ZP_TEMP_COUNTER                                             ;$9EAD

        lda ZP_VAR_XX15_2
        bmi _9e51

        lda R
        clc 
        adc # $80
        sta $0100, x
        inx 
        lda U
        adc # $00
        sta $0100, x

        ; ".LL66 ; also from LL62, XX3 node heap has xscreen node so far"
        ;
_9ec3: .phx                     ; push X to stack (via A)               ;$9EC3

        lda # $00
        sta U
        lda T
        sta Q
        lda ZP_VAR_XX15_3
        cmp Q
        bcc _9eec

        jsr _9e2a
        jmp _9eef

        ; ".LL70 ; arrive from below, Yscreen for -ve RU
        ; onto XX3 node heap, index X=CNT"
_9ed9:  lda # $48                                                       ;$9ED9
        clc 
        adc R
        sta $0100, x
        inx 
        lda # $00
        adc U
        sta $0100, x
        jmp _9f06

        ; ".LL67 ; Arrive from LL66 above if XX15+3 < Q ; small yangle"
_9eec:  jsr math_divide_AQ                                              ;$9EEC

        ; ".LL68 ; both carry on, also arrive from LL66, scaling y based on z."
_9eef:  pla                                                             ;$9EEF
        tax 
        inx 
        lda ZP_VAR_XX15_5
        bmi _9ed9

        lda # $48
        sec 
        sbc R
        sta $0100, x
        inx 
        lda # $00
        sbc U
        sta $0100, x

        ; ".LL50 ; also from LL70, Also from LL49-3.
        ; XX3 heap has yscreen, Next vertex."
_9f06:  clc                                                             ;$9F06
        lda ZP_TEMP_COUNTER
        adc # $04
        sta ZP_TEMP_COUNTER
        lda ZP_VAR_XX17
        adc # $06
        tay 
        bcs _LL72

        cmp ZP_VAR_XX20
        bcs _LL72

        jmp _9d45

_LL72:                                                  ; BBC: LL72     ;$9F1B
;===============================================================================
; [9]:  laser beam?
;===============================================================================
        lda ZP_SHIP_STATE       ; is the ship exploding?
        and # state::debris
        beq _9f2a

        ; ship is exploding:
        ;
        lda ZP_SHIP_STATE       ; set the state bit that indicates
        ora # state::redraw     ;  that the ship is [will be] drawn
        sta ZP_SHIP_STATE       ;  on the screen, so that the game
        jmp draw_explosion      ;  knows to redraw it to erase it

_9f2a:                                                  ; BBC: EE31     ;$9F2A
;-------------------------------------------------------------------------------
        lda # state::redraw                                             
        bit ZP_SHIP_STATE
        beq @redraw

        jsr _LL155

        ; set the redraw bit
        lda # state::redraw
@redraw:ora ZP_SHIP_STATE                                               ;$9F35
        sta ZP_SHIP_STATE

        ldy # Hull::edge_count  ; number of edges in the ship's hull
        lda [ZP_HULL_ADDR], y
        sta ZP_VAR_XX20

        ldy # 0                 ; edge counter
        sty U
        sty ZP_VAR_XX17
        inc U

        bit ZP_SHIP_STATE       ; is ship firing its laser?
        bvc _9f9f               ; no? skip over laser lines

        lda ZP_SHIP_STATE       ; stop the ship firing its laser
        and # state::firing^$FF ;  so it doesn't do so endlessly
        sta ZP_SHIP_STATE

        ldy # Hull::laser_vertex
        lda [ZP_HULL_ADDR], y
        tay 
        ldx $0100, y
        stx ZP_VAR_XX15_0
        inx 
        beq _9f9f

        ldx $0101, y
        stx ZP_VAR_XX15_1
        inx 
        beq _9f9f

        ldx $0102, y
        stx ZP_VAR_XX15_2
        ldx $0103, y
        stx ZP_VAR_XX15_3

        lda # $00
        sta ZP_VAR_XX15_4
        sta ZP_VAR_XX15_5
        sta ZP_VAR_XX12_1
        lda ZP_SHIP_ZPOS_LO
        sta ZP_VAR_XX12_0
        lda ZP_SHIP_XPOS_SIGN
        bpl :+

        dec ZP_VAR_XX15_4
:       jsr clip_line                                                   ;$9F82

        bcs _9f9f

        ; laser line:
        ;-----------------------------------------------------------------------
        ; insert a laser line into the ship's line-heap
        ;
        ldy U                   ; get heap index (next free byte)
        lda ZP_LINE_X1          ; push laser line's X1 co-ordinate
        sta [ZP_SHIP_HEAP], y
        iny                     ; move to next byte in heap
        lda ZP_LINE_Y1          ; push laser line's Y1 co-ordinate
        sta [ZP_SHIP_HEAP], y
        iny                     ; move to next byte in heap
        lda ZP_LINE_X2          ; push laser lines' X2 co-ordinate
        sta [ZP_SHIP_HEAP], y
        iny                     ; move to next byte in heap
        lda ZP_LINE_Y2          ; push laser line's Y2 co-ordinate
        sta [ZP_SHIP_HEAP], y
        iny                     ; move to next (free) byte in heap
        sty U                   ; update the heap index

        ; fallthrough
        ; ...

_9f9f:                                                  ; BBC: LL170    ;$9F9F
;===============================================================================
; [10]: calculate which edges are visible:
;===============================================================================
        ldy # Hull::edge_data_lo
        clc 
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR2_LO

        ldy # Hull::edge_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR2_HI

        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_VAR

        ldy ZP_VAR_XX17

_9fb8:  ; in the original code, this label              ; BBC: LL75     ;$9FB8
        ; has to come *after* the `ldy`

        lda [ZP_TEMP_ADDR2], y
        cmp ZP_VAR_XX4
        bcc _9fd6

        iny 
        lda [ZP_TEMP_ADDR2], y

        iny 
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_SHIP01_XPOS_pt1, x
        bne _9fd9

        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_SHIP01_XPOS_pt1, x
        bne _9fd9

        ; ".LLx78 ; edge not visible"
_9fd6:  jmp _LL78               ; "edge not visible"?                   ;$9FD6

_9fd9:  ; ".LL79 ; Visible edge"                                        ;$9FD9
        ;-----------------------------------------------------------------------
        lda [ZP_TEMP_ADDR2], y  ; "edge data byte #2"
        tax                     ; "index into node heap for first node of edge"
        iny                     ; "Y = 3"
        lda [ZP_TEMP_ADDR2], y  ; "edge data byte #3"
        sta Q                   ; "index into node heap for other node of edge"

        lda $0101, x
        sta ZP_VAR_XX15_1
        lda $0100, x
        sta ZP_VAR_XX15_0
        lda $0102, x
        sta ZP_VAR_XX15_2
        lda $0103, x
        sta ZP_VAR_XX15_3

        ldx Q                   ; "other index into node heap for second node"
        lda $0100, x
        sta ZP_VAR_XX15_4
        lda $0103, x
        sta ZP_VAR_XX12_1
        lda $0102, x
        sta ZP_VAR_XX12_0
        lda $0101, x
        sta ZP_VAR_XX15_5

        jsr clip_line_flip      ; "CLIP2, take care of swop and clips"?
        bcs _9fd6               ; "edge not visible"?

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr redraw_ship_line
        jmp _LL78
.else   ;///////////////////////////////////////////////////////////////////////
        ; add lines to heap / draw lines?
        ; TODO: only ever called here -- we could inline it here
        jmp _LL80
.endif  ;///////////////////////////////////////////////////////////////////////


; NOTE: in the original, segment "CODE_A013" appears here               ;$A013


.segment        "CODE_A13F"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_LL80:                                                  ; BBC: LL80     ;$A13F
;===============================================================================
; [11]: BBC code says "Shove visible edge onto XX19 ship lines heap counter U"
;-------------------------------------------------------------------------------
; in:   ZP_SHIP_HEAP            address of heap
;       U                       heap-index
;       ZP_LINE_X1              line-coord X1
;       ZP_LINE_Y1              line-coord Y1
;       ZP_LINE_X2              line-coord X2
;       ZP_LINE_Y2              line-coord Y2
;       ZP_TEMP_VAR             TODO: unknown
;-------------------------------------------------------------------------------
        ldy U                   ; index of next free byte in heap

        ; push the line's co-ordinates (X1, Y1, X2, Y2),
        ; one after the other, onto the heap
        ; 
        lda ZP_LINE_X1
        sta [ZP_SHIP_HEAP], y
        iny 
        lda ZP_LINE_Y1
        sta [ZP_SHIP_HEAP], y
        iny 
        lda ZP_LINE_X2
        sta [ZP_SHIP_HEAP], y
        iny 
        lda ZP_LINE_Y2
        sta [ZP_SHIP_HEAP], y
        iny 
        sty U                   ; update new index position

        cpy ZP_TEMP_VAR         ; limit for edge-lines reached
       .bge _LL81

_LL78:                                                  ; BBC: LL78     ;$A15B
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        lda ZP_VAR_XX14         
        cmp $30
        bcs _LL81

        lda ZP_TEMP_ADDR2_LO    ; take the low-address
        adc # 4                 ; add 4-bytes
        sta ZP_TEMP_ADDR2_LO    ; write it back...
        bcc :+                  ; but, did it overflow?
        inc ZP_TEMP_ADDR2_HI    ; yes, also increment the high-byte
:
        inc ZP_VAR_XX17         ; increment edge counter
        ldy ZP_VAR_XX17
        cpy ZP_VAR_XX20         ; all edges done?
        bcs _LL81               ;

        jmp _9fb8
_LL81:

.else   ;///////////////////////////////////////////////////////////////////////
        inc ZP_VAR_XX17         ; increment edge counter
        ldy ZP_VAR_XX17
        cpy ZP_VAR_XX20         ; all edges done?
        bcs _LL81               ;

        ; move to the next edge in the hull:
        ;
        ldy # 0                 ; return edge byte index to 0
        lda ZP_TEMP_ADDR2_LO    ; take the low-address
        adc # 4                 ; add 4-bytes
        sta ZP_TEMP_ADDR2_LO    ; write it back...
        bcc :+                  ; but, did it overflow?
        inc ZP_TEMP_ADDR2_HI    ; yes, also increment the high-byte

:       jmp _9fb8                                                       ;$A16F

        ;-----------------------------------------------------------------------
_LL81:  lda U                   ; heap index?           ; BBC: LL81     ;$A172
_a174:  ldy # 0                                                         ;$A174
        sta [ZP_SHIP_HEAP], y
.endif  ;///////////////////////////////////////////////////////////////////////


_LL155:                                                 ; BBC: LL155    ;$A178
;===============================================================================
; [12]: 
;-------------------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ldy ZP_VAR_XX14+0
.else   ;///////////////////////////////////////////////////////////////////////
        ldy # 0                 ; check number of lines
        lda [ZP_SHIP_HEAP], y   ;  drawn for the ship
        sta ZP_VAR_XX20         ; set this as number of points?
        cmp # 4                 ; 1-point only? (4 bytes per point)
        bcc @rts                ; exit, not enough points for a line!

        iny
.endif  ;///////////////////////////////////////////////////////////////////////

@draw:  ; draw a line from the line-heap:               ; BBC: LL27     ;$A183
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        cpy ZP_VAR_XX14+1
        bcs :+
.endif  ;///////////////////////////////////////////////////////////////////////
        ; read line start and end co-ords from the heap
        ;
        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_X1
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_Y1
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_X2
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_Y2

        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine?
        jsr draw_line

        iny 

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jmp @draw

:       lda ZP_VAR_XX14+0
        ldy # 0
        sta [ZP_SHIP_HEAP], y

.else   ;///////////////////////////////////////////////////////////////////////
        cpy ZP_VAR_XX20         ; keep drawing?
        bcc @draw
.endif  ;///////////////////////////////////////////////////////////////////////

@rts:   rts                                                             ;$A19E


.ifdef  FEATURE_FLICKERFREE
;///////////////////////////////////////////////////////////////////////////////

redraw_ship_line:                                       ; BBC: LLX30
;===============================================================================
; erase an old line and draw a new version of the same line:
;
;-------------------------------------------------------------------------------
        ldy ZP_VAR_XX4
        cpy ZP_VAR_XX20
        php

        ldx # 3                 ; copy 4 bytes for line-coords (X1/Y1/X2/Y2)
:       lda ZP_VAR_XX15, x
        sta ZP_VAR_XX12, x
        dex
        bpl :-

        jsr draw_line
        
        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_X1

        lda ZP_VAR_XX12+0
        sta [ZP_SHIP_HEAP], y

        iny

        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_Y1

        lda ZP_VAR_XX12+1
        sta [ZP_SHIP_HEAP], y

        iny

        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_X2

        lda ZP_VAR_XX12+2
        sta [ZP_SHIP_HEAP], y

        iny

        lda [ZP_SHIP_HEAP], y
        sta ZP_LINE_Y2

        lda ZP_VAR_XX12+3
        sta [ZP_SHIP_HEAP], y

        iny
        sta ZP_VAR_XX4

        plp
        bcs @rts

        jmp draw_line

@rts:   rts

;///////////////////////////////////////////////////////////////////////////////
.endif


clip_point:                                             ; BBC: LL118    ;$A19F
;===============================================================================
; move the point X1,Y1 along a given direction /
; slope until it's within the viewport:
;
; the "slope" of the line can be thought of a ratio of how far to move along
; the line before having to move up/down; the units are arbitrary, and when
; drawing lines we use pixels, where the slope describes how many pixels
; along to draw before having to move up/down a pixel
;
; when a point is outside the viewport, we need to work out where the line
; would intersect the edge of the viewport if we followed it. rather than
; iteratively walk down the line we can just treat the distance from the point
; to the viewport as one "unit" and use the slope's ratio to determine what the
; equivalent "unit" amount down is!
;
; this assumes a "horizontal" (or "shallow") line which is wider than it is
; tall but a line can also be "vertical" (or "steep"), this routine doesn't
; deal with this difference but the routines it calls may flip the axis
; internally to normalise the direction and return the equivalent result
;
; in:   ZP_LINE_XX1             point X-position (16-bit)
;       ZP_LINE_YY1             point Y-position (16-bit)
;       ZP_LINE_SLOPE           slope
;       ZP_LINE_DIR             direction of slope, flag:
;                               $00 = vertical slope, $FF = horitzontal slope
;
; out:  ZP_LINE_X1              new X-position (8-bit)
;       ZP_LINE_Y1              new Y-position (8-bit)
;-------------------------------------------------------------------------------
        ; is the X-postion outside the left or right side of the viewport?
        ;
        lda ZP_LINE_XX1_HI      ; hi-byte of X-position
        bpl @right              ; positive? in or off right-side of viewport

        ;-----------------------------------------------------------------------
        ; X1 is outside the left of the viewport; use the distance from the
        ; point back to 0 to calculate the distance Y1 has to be adjusted
        ; for the two to meet:
        ;
        ; TODO: note that only this routine ever calls `deltax_from_slope` &
        ; `deltay_from_slope` meaning we could just bake the parameters
        ; in directly?
        ;
@left:  sta S                   ; put X1 hi-byte into S for the call
        jsr deltay_from_slope   ; calculate the delta-Y given the delta-X

        txa                     ; add the result to Y1:
        clc                     ;
        adc ZP_LINE_YY1_LO      ; add result lo-byte to Y1 lo-byte
        sta ZP_LINE_YY1_LO      ; write back to Y1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_YY1_HI      ; add result hi-byte to Y1 hi-byte
        sta ZP_LINE_YY1_HI      ; write back to Y1 hi-byte
        
        ; because we've calculated the Y-position where the line intersects
        ; the left-edge of the viewport, X1 can now be moved to the first
        ; pixel in the viewport
        ;
        lda # $00               ; set X1 to zero
        sta ZP_LINE_XX1_LO      ;  lo-byte &
        sta ZP_LINE_XX1_HI      ;  hi-byte
        tax                     ; set X-register to zero too, for later

        ; note that we fall through
        ; with A & X set to zero...
        ;

        ;-----------------------------------------------------------------------
        ; if the X-coordinate is already within
        ; the viewport (0-255), skip ahead
        ;
@right: beq @above                                                      ;$A1BA

        ; X1 is outside the right-edge of the viewport; to calculate the
        ; intersection point we need the distance from the right edge of the
        ; viewport to the point which, given the viewport is 256px wide, is
        ; simply X1 - 256
        ;
        sta S                   ; put X1 hi-byte into S for the call    
        dec S                   ; "subtract" 256 by decrementing hi-byte
        jsr deltay_from_slope   ; calculate the delta-Y given the delta-X

        txa                     ; add the result to Y1:
        clc                     ;
        adc ZP_LINE_YY1_LO      ; add result lo-byte to Y1 lo-byte
        sta ZP_LINE_YY1_LO      ; write back to Y1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_YY1_HI      ; add result hi-byte to Y1 hi-byte
        sta ZP_LINE_YY1_HI      ; write back to Y1 hi-byte

        ; because we've calculated the Y-position where the line intersects
        ; the right-edge of the viewport, X1 can now be moved to the last
        ; pixel in the viewport
        ;
        ldx # VIEWPORT_WIDTH-1  ; set X1 to 255
        stx ZP_LINE_XX1_LO      ;  lo-byte
        inx                     ; overflow to $00
        stx ZP_LINE_XX1_HI      ;  set X1 hi-byte to zero

        ;-----------------------------------------------------------------------
        ; even though X1 is now within the viewport's left<->right boundaries,
        ; the point could still be above the screen!
        ;
@above: lda ZP_LINE_YY1_HI      ; check the point's Y-position          ;$A1D5
        bpl @below              ; skip if positive (0, 1 -- in or below)

        ; Y1 is negative, above the viewport
        ;
        sta S                   ; put Y1 hi-byte into S for the call
        lda ZP_LINE_YY1_LO      ; put Y1 lo-byte
        sta R                   ;  into R for the call
        jsr deltax_from_slope   ; calculate the delta-X given the delta-Y

        txa                     ; add the result to X1:
        clc                     ;
        adc ZP_LINE_XX1_LO      ; add result lo-byte to X1 lo-byte
        sta ZP_LINE_XX1_LO      ; write back to X1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_XX1_HI      ; add result hi-byte to X1 hi-byte
        sta ZP_LINE_XX1_HI      ; write back to X1 hi-byte

        ; because we've calculated the X-position where the line intersects
        ; the top-edge of the viewport, Y1 can now be moved to the first
        ; pixel in the viewport
        ;
        lda # $00               ; set Y1 to zero
        sta ZP_LINE_YY1_LO      ;  lo-byte &
        sta ZP_LINE_YY1_HI      ;  hi-byte

        ;-----------------------------------------------------------------------
        ; moving the point to the bottom of the viewport is trickier
        ; because it's neither a 0 or 255 co-ord
        ;
@below: lda ZP_LINE_YY1_LO      ; we subtract 144 (viewport height)     ;$A1F3
        sec                     ;  from the Y-position to get the
        sbc # VIEWPORT_HEIGHT   ;  distance from the bottom of the
        sta R                   ;  viewport to the point, which will
        lda ZP_LINE_YY1_HI      ;  form the one "unit" (delta-Y)
        sbc # $00               ;  needed to calculate the delta-X
        sta S
        bcc :+                  ; skip if Y-position is within the viewport!

        jsr deltax_from_slope   ; calculate the delta-X given the delta-Y

        txa                     ; add the result to X1:
        clc                     ;
        adc ZP_LINE_XX1_LO      ; add result lo-byte to X1 lo-byte
        sta ZP_LINE_XX1_LO      ; write back to X1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_XX1_HI      ; add result hi-byte to X1 hi-byte
        sta ZP_LINE_XX1_HI      ; write back to X1 hi-byte

        ; because we've calculated the X-position where the line intersects
        ; the bottom-edge of the viewport, Y1 can now be moved to the last
        ; pixel in the viewport
        ;
        lda # VIEWPORT_HEIGHT-1 ; set Y1 to viewport height-1
        sta ZP_LINE_YY1_LO      ; lo-byte is last pixel
        lda # $00               ; hi-byte is zero
        sta ZP_LINE_YY1_HI

:       rts                                                             ;$A218


deltay_from_slope:                                      ; BBC: LL120    ;$A219
;===============================================================================
; in:   T                       flag;
;                               $00 = vertical slope
;                               $FF = horitzontal slope
;-------------------------------------------------------------------------------
        lda ZP_LINE_XX1_LO      ; load R with X-position, lo-byte
        sta R

        jsr _a284
        pha 

        ldx T                   ; "vertical" or "horizontal" line?
        bne _a250               ; skip ahead to handle horizontal line

_a225:                                                                  ;$A225
        lda # $00
        tax 
        tay 
        lsr S
        ror R
        asl Q
        bcc _a23a
_a231:                                                                  ;$A231
        txa 
        clc 
        adc R
        tax 
        tya 
        adc S
        tay 
_a23a:                                                                  ;$A23A
        lsr S
        ror R
        asl Q
        bcs _a231
        bne _a23a
        pla 
        bpl _a277
        rts 


deltax_from_slope:                                      ; BBC: LL123    ;$A248
;===============================================================================
        jsr _a284
        pha 
        ldx T
        bne _a225

_a250:                                                                  ;$A250
        lda # $ff
        tay 
        asl 
        tax 
_a255:                                                                  ;$A255
        asl R
        rol S
        lda S
        bcs _a261
        cmp Q
        bcc _a26c
_a261:                                                                  ;$A261
        sbc Q
        sta S
        lda R
        sbc # $00
        sta R
        sec 
_a26c:                                                                  ;$A26C
        txa 
        rol 
        tax 
        tya 
        rol 
        tay 
        bcs _a255
        pla 
        bmi _a283
_a277:                                                                  ;$A277
        txa 
        eor # %11111111
        adc # $01
        tax 
        tya 
        eor # %11111111
        adc # $00
        tay 

_a283:  rts                                                             ;$A283


_a284:                                                  ; BBC: LL129    ;$A284
;===============================================================================
; in:   ZP_LINE_SLOPE           the line's slope, a single byte value where
;                               $FF = 1.0, $80 = 0.5 and $00 = 0
;       R                       the lo-byte of the point's X or Y position;
;                               that is, `ZP_LINE_XX1_LO` or `ZP_LINE_YY1_LO`
;       S                       the hi-byte of the point's X or Y position;
;                               that is, `ZP_LINE_XX1_HI` or `ZP_LINE_YY1_HI`
;-------------------------------------------------------------------------------
        ldx ZP_LINE_SLOPE       ; transfer slope to Q
        stx Q                   ;  for the calculation

        lda S                   ; check the position hi-byte
        bpl :+                  ; for positive values, skip ahead

        lda # $00
        sec 
        sbc R
        sta R
        lda S
        pha 

        eor # %11111111
        adc # $00
        sta S

        pla 

:       eor ZP_LINE_DIR         ; flip direction flag                   ;$A29D
        rts 


move_ship:                                                              ;$A2A0
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
        jsr _b410

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
        ; verticies in one operation, i.e. we do not have to calculate roll &
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
        jmp _b410

        ;-----------------------------------------------------------------------

:       lda ZP_SHIP_STATE                                               ;$A443
        and # state::scanner ^$FF
        sta ZP_SHIP_STATE
        rts 


; NOTE: in the original, segment "CODE_A44A" appears here               ;$A44A
; NOTE: in the original, segment "CODE_A4A1" appears here               ;$A4A1


.segment        "CODE_A508"
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
        lda [ZP_TEMP_ADDR], y
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


_a626:                                                                  ;$A626
;===============================================================================
        ldx COCKPIT_VIEW
        beq @rts
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

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr unused__6a2e        ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ldy ZP_SCREEN           ; are we in the cockpit-view?
       .bnz _a6ae               ; no? switch to cockpit-view now

        cpx COCKPIT_VIEW
        beq _a6ad               ; view did not change, rts
        stx COCKPIT_VIEW

        jsr set_page            ; switch to cockpit view
        jsr dust_swap_xy        ; is this an opt: avoid rand
        jsr _7b1a

_a6d4:                                                                  ;$A6D4

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

.ifdef  OPTION_ORIGINAL
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
;                                chart &c. see the `page` constants defined in
;                                "vars_zeropage.asm"
;
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
.ifdef  OPTION_ORIGINAL
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

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================

_a785:                                                                  ;$A785
        rts 

_a786:                                                                  ;$A786
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
        jsr _900d

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $04
        jmp play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////


ship_killed:                                                            ;$A7A6
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
        jsr _900d


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

play_sfx_03:                                                            ;$A813
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
.segment        "CODE_B09D"
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
        sta ZP_TEMP_ADDR_LO
        lda row_to_bitmap_hi, y
        adc # $00
        sta ZP_TEMP_ADDR_HI

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
        eor [ZP_TEMP_ADDR], y   ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR], y   ; update the screen

        lda _ab49, x            ; look ahead to the next pixel
        bpl @_b0ed

        lda ZP_TEMP_ADDR_LO
        clc 
        adc # $08
        sta ZP_TEMP_ADDR_LO
        bcc :+
        inc ZP_TEMP_ADDR_HI
:       lda _ab49, x                                                    ;$B0EA

@_b0ed:                                                                 ;$B0ED
        and ZP_32               ; apply the colour-mask to the pixel
        eor [ZP_TEMP_ADDR], y   ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR], y   ; update the screen
        rts 


engage_ecm:                                                             ;$B0F4
;===============================================================================
        lda # 32                ; set the ECM counter to 32
        sta ECM_COUNTER

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $09               ; E.C.M. sound?
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

_b0fd:                                                                  ;$B0FD
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


_b10e:                                                                  ;$B10E
;===============================================================================
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
        sty ZP_TEMP_ADDR_LO
        tay 
        lda ZP_TEMP_ADDR_LO
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
;
;-------------------------------------------------------------------------------
        ; re-define the use of some zero-page variables for this routine
        ZP_CHROUT_CHARADDR      := ZP_VAR_P2
        ZP_CHROUT_DRAWADDR      := ZP_TEMP_ADDR
        ZP_CHROUT_DRAWADDR_LO   := ZP_TEMP_ADDR_LO
        ZP_CHROUT_DRAWADDR_HI   := ZP_TEMP_ADDR_HI

        cmp # $7b               ; is code greater than or equal to $7B?
        bcs :+                  ; if yes, skip it
        cmp # $0d               ; is code less than $0D? (RETURN)
        bcc :+                  ; if yes, skip it
        bne paint_char          ; if it's not RETURN, process it

        ; handle the RETURN code
.ifdef  OPTION_ORIGINAL
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
        ; this is `sta ZP_TEMP_ADDR_HI` if you jump in after the `bit`
        ; instruction, but it doesn't look like this actually occurs
       .bit
        sta ZP_TEMP_ADDR_HI

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
        sta ZP_TEMP_ADDR_HI
        lda #< @txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR_LO

        ldx # $03

@_b3f7:                                                                 ;$B3F7
        lda # $00
        tay 

:       sta [ZP_TEMP_ADDR], y                                           ;$B3FA
        dey 
        bne :-

        ; add 320 to the bitmap address
        ; (move to the next pixel row)
        clc 
        lda ZP_TEMP_ADDR_LO
        adc #< 320
        sta ZP_TEMP_ADDR_LO
        lda ZP_TEMP_ADDR_HI
        adc #> 320
        sta ZP_TEMP_ADDR_HI
        dex 
        bne @_b3f7

_b40f:                                                                  ;$B40F
:       rts 


_b410:                                                                  ;$B410
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

        lda _267e, x
        sta ZP_32

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
        bne _b40f

        lda ZP_SHIP_XPOS_HI
        clc 

        ; if the middle-byte is within range,
        ; we still need to check the hi-byte
        ;
        ldx ZP_SHIP_XPOS_SIGN
        bpl :+                  ; if positive, skip over the invert

        eor # %11111111         ; flip the bits...
        adc # $01               ; and add 1

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
        sta ZP_TEMP_ADDR_LO

        lda ZP_SHIP_YPOS_HI
        lsr 
        clc 
        ldx ZP_SHIP_YPOS_SIGN
        bmi :+
        eor # %11111111
        sec 
:       adc ZP_TEMP_ADDR_LO                                             ;$B459
        cmp # $92
        bcs :+
        lda # $92
:       cmp # $c7                                                       ;$B461
        bcc :+
        lda # $c6
:       sta ZP_VAR_XX15_1                                               ;$B467

        sec 
        sbc ZP_TEMP_ADDR_LO
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
        lda ZP_TEMP_ADDR_LO
        sec 
        sbc # $40
        sta ZP_TEMP_ADDR_LO
        lda ZP_TEMP_ADDR_HI
        sbc # $01
        sta ZP_TEMP_ADDR_HI
_b491:                                                                  ;$B491
        lda ZP_VAR_XX15_0
        eor [ZP_TEMP_ADDR], y
        sta [ZP_TEMP_ADDR], y
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
        lda ZP_TEMP_ADDR_LO
        adc #< (320-1)
        sta ZP_TEMP_ADDR_LO
        lda ZP_TEMP_ADDR_HI
        adc #> (320-1)
        sta ZP_TEMP_ADDR_HI
_b4ae:                                                                  ;$B4AE
        iny 
        cpy # $08
        bne _b4c1
        ldy # $00
        lda ZP_TEMP_ADDR_LO
        adc #< (320-1)
        sta ZP_TEMP_ADDR_LO
        lda ZP_TEMP_ADDR_HI
        adc #> (320-1)
        sta ZP_TEMP_ADDR_HI
_b4c1:                                                                  ;$B4C1
        lda ZP_VAR_XX15_0
        eor [ZP_TEMP_ADDR], y
        sta [ZP_TEMP_ADDR], y
        inx 
        bne _b4ae

        rts                                                             ;$B4CA
