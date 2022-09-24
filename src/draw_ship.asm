; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
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
        ; this call is exlcuded for flicker-free since the ship is
        ; erased and redrawn line by line rather than all-in-one
        ;
.if     !.defined( FEATURE_FLICKERFREE )
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

        lda ZP_VAR_K4_LO        ; is the Y-position below the viewport?
        cmp # VIEWPORT_HEIGHT-2 ; (viewport is 144 high, not 256)
        bcs @novis              ; -> ship is no longer visible

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr @line               ; draw first half of the "dot"
        
        lda ZP_VAR_K4_LO        ; ship X-position;
        clc                     ;
        adc # 1                 ; move to the next pixel row
        jsr @line               ;  and draw the second half of the "dot"

.else   ;///////////////////////////////////////////////////////////////////////
        ldy # 2                 ; set heap index for Y1
        jsr @line               ; add the first half of the "dot"
        ldy # 6                 ; set heap index for next line

        lda ZP_VAR_K4_LO        ; ship X-position;
        adc # 1                 ; move to the next pixel row
        
        jsr @line               ; draw the second half of the "dot"

.endif  ;///////////////////////////////////////////////////////////////////////

        lda # state::redraw     ; set the ship's flag to indicate that
        ora ZP_SHIP_STATE       ;  it has been drawn on screen, and
        sta ZP_SHIP_STATE       ;  therefore must be erased to redraw

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ; the "dot" has been drawn, but if the ship were a wireframe on the
        ; previous frame the remainder of the lines still need erasing
        ;
        jmp _LL155

.else   ;///////////////////////////////////////////////////////////////////////
        ; two lines have been added to the ship's line heap; the first byte
        ; of the heap needs be updated to the index of the next free byte
        ;
        lda # 8                 ; size of the ship's line heap -- 8 bytes
        jmp _a174               ; jump to `sta [ZP_SHIP_HEAP], 0`

        ;-----------------------------------------------------------------------
@995b:  pla                     ; change return address?                ;$995B
        pla                     ; change return address?
.endif  ;///////////////////////////////////////////////////////////////////////

        ; ship has been erased, and is no longer visible:
        ;-----------------------------------------------------------------------
@novis: lda # state::redraw^$FF ; remove flag indicating the ship       ;$995D
        and ZP_SHIP_STATE       ;  has been drawn on screen --
        sta ZP_SHIP_STATE       ;  it will not need erasing again

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ; we've determined that the ship isn't visible *this frame*,
        ; so erase the old lines from the previous frame and return
        ;
        jmp _LL155

.else   ;///////////////////////////////////////////////////////////////////////
        ; the original code erases the ship first,
        ; so only needs to return at this time
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

        lda ZP_VAR_K3_LO        ; ship X-coordinate
        sta ZP_LINE_X1          ; start of line
        clc                     ;
        adc # 3                 ; now add 3 to get the X2 co-ordinate
        bcc :+                  ; if it clips the viewport,
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


; NOTE: in the original, segment "CODE_9978" goes here                  ;$9978
; NOTE: in the original, segment "CODE_99AF" goes here                  ;$99AF
; NOTE: in the original, segment "CODE_9A0C" goes here                  ;$9A0C


.segment        "CODE_9A83"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; draw_ship:
;===============================================================================
; [1]:  
;-------------------------------------------------------------------------------
:       jmp _PLANET             ; go draw sun or planet                 ;$9A83

draw_ship:                                              ; BBC: LL9      ;$9A86
        ;=======================================================================
        lda ZP_SHIP_TYPE        ; check ship type
        bmi :-                  ; hi-bit indicates sun or planet
        
        lda # 31                ; set a default ship distance
        sta ZP_VAR_XX4          ;  (will be populated later)

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ; for flicker-free drawing we will need to walk through the lines
        ; already in the ship's line-heap (from previous frame). the first
        ; byte of the heap contains an index to the next free byte in the
        ; heap (i.e. how many bytes were used), and the line co-ords start
        ; from the 2nd byte onwards
        ;
        ldy # 1                 ; initialise a variable for reading lines
        sty ZP_VAR_XX14+0       ; from the heap, starting at the 2nd byte
        dey                     ; (set Y to zero for later)

        ; take a copy of the number of bytes in the ship's line heap:
        ; however, if the ship isn't on-screen this field will contain
        ; invalid data so first check if the ship was drawn previously
        ;
        lda # state::redraw     ; check the redraw flag on the ship
        bit ZP_SHIP_STATE       ;  if set, we'll use the line-heap index
        bne :+                  ;  as the number of bytes in the heap
        lda # 0                 ; use 0 if ship is not on-screen
       .bit                     ; (skip next instruction)
:       lda [ZP_SHIP_HEAP], y   ; use the first byte, the size of the heap

        sta ZP_VAR_XX14+1       ; number of (old) bytes in heap to process
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
        bne @_EE28              ; is debris
        bpl @_EE28              ; ? 

        ; erase ship and explode it:
        ;-----------------------------------------------------------------------
        ; stop the ship firing and remove its 'just killed'
        ; state as we're going to create the debris cloud
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
        cpy # 6                 ; was this the 6th byte in the heap?
        bne :-                  ; if not, keep going

@_EE28: lda ZP_SHIP_ZPOS_SIGN   ; ship's z-sign, i.e. fore or aft to us ;$9AC5
        bpl _LL10               ; if in-front, skip ahead to check FOV

        ; fallthrough implies
        ; ship is behind us...
        ;

_LL14:                                                  ; BBC: LL14     ;$9AC9
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

_LL10:                                                  ; BBC: LL10     ;$9AE6
;===============================================================================
; [2]:  check if a ship is within visible position / range:
;
; in:   ZP_VAR_XX4              default ship distance, 31, set in `draw_ship`
;-------------------------------------------------------------------------------
        lda ZP_SHIP_ZPOS_HI     ; check the ship's Z-position (fore/aft)
        cmp # 192               ; if > 192 distance ahead? ship is out of range,
        bcs _LL14               ;  so erase it from screen by drawing over it

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
        bcs _LL14               ; if X >= Z, erase ship from screen

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
        bcs _LL14               ; if Y >= Z, erase ship from screen

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
        ; downscale the Z-position;
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
        bne :+                  ; 

        lda T
        ror 
        lsr 
        lsr 
        lsr 
        sta ZP_VAR_XX4          ; update ship-distance byte set in `draw_ship`
        bpl _LL17               ; (always branches!)
        
        ; read the byte from the ship's hull definition that sets
        ; the LOD-distance at which the ship should become a dot
        ;
:       ldy # Hull::lod_distance                                        ;$9B29
        lda [ZP_HULL_ADDR], y
        cmp ZP_SHIP_ZPOS_HI     ; compare ship distance (hi) and LOD-distance;
        bcs _LL17               ; if below LOD-distance, draw full wireframe

        lda # state::debris     ; has the ship exploded into a debris cloud?
        and ZP_SHIP_STATE       ; if yes, draw as normal,
        bne _LL17               ;  which will draw the particles

        jmp draw_ship_dot       ; if no, draw the ship as a distant dot


_LL17:                                                  ; BBC: LL17     ;$9B3A
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
.ifdef  BUILD_ORIGINAL
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
        beq _EE29               ; solid? -> draw wireframe

        ; fallthrough
        ; ...

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


_EE29:                                                  ; BBC: EE29     ;$9B8B
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
        bne _LL49               ; if visible, skip other checks

        lda ZP_VAR_P            ; retrieve face 1 & 2 byte
        lsr                     ;
        lsr                     ; extract the upper nybble
        lsr                     ;  by shifting down 4 times
        lsr                     ;
        tax                     ; check face 2 against
        lda ZP_VAR_XX2, x       ;  the visibility test done earlier
        bne _LL49               ; if visible, skip other checks

        iny
        lda [ZP_TEMP_ADDR2], y  ; read vertex byte #5: face 3 & 4
        sta ZP_VAR_P            ; (keep this value in P)
        and # %00001111         ; extract face 3 index
        tax                     ; check this face against
        lda ZP_VAR_XX2, x       ;  the visbility test done earlier
        bne _LL49               ; if visible, skip other checks

        lda ZP_VAR_P1           ; retrieve face 3 & 4 byte
        lsr                     ;
        lsr                     ; extract the upper nybble
        lsr                     ;  by shifting down 4 times
        lsr                     ;
        tax                     ; check face 4 against
        lda ZP_VAR_XX2, x       ;  the visibility test done earlier
        bne _LL49               ; if visible, skip other checks

        ; no faces attached to this vertex are visible,
        ; so the vertex itself does not need to be visible
:       jmp _LL50                                                       ;$9D8E

_LL49:                                                  ; BBC: LL49     ;$9D91
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
        bmi _LL56

        lda ZP_VAR_XX12_4
        clc 
        adc ZP_SHIP_ZPOS_LO
        sta T
        lda ZP_SHIP_ZPOS_HI
        adc # 0
        sta U

        jmp _LL57

_LL61:                                                  ; BBC: LL61     ;$9E2A
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
_LL62:                                                  ; BBC: LL62     ;$9E51
        ;=======================================================================
        lda # $80
        sec 
        sbc R
        sta $0100, x
        inx 
        lda # $00
        sbc U
        sta $0100, x
        jmp _LL66

_LL56:                                                  ; BBC: LL56     ;$9E64
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
        bcc _LL140               ; "underflow, make node close"
        bne _LL57               ; "Enter Node additions done, UT=z"
        
        lda T                   ; "restore z lo"
        cmp # 4                 ; "">= 4?"
        bcs _LL57               ; "zlo big enough, Enter Node additions done"

        ; ".LL140 ; else make node close"
        ;
_LL140: lda # $00               ; "hi"?                                 ;$9E7B
        sta U
        lda # $04               ; "lo"?
        sta T

        ; scale result down to 8-bits
        ;-----------------------------------------------------------------------
_LL57:  lda U                                           ; BBC: LL57     ;$9E83
        ora ZP_VAR_XX15_1
        ora ZP_VAR_XX15_4
        beq _LL60

        lsr ZP_VAR_XX15_1
        ror ZP_VAR_XX15_0
        lsr ZP_VAR_XX15_4
        ror ZP_VAR_XX15_3
        lsr U
        ror T
        jmp _LL57

_LL60:                                                  ; BBC: LL60     ;$9E9A
;===============================================================================
; [8]:  
;===============================================================================
        lda T
        sta Q

        lda ZP_VAR_XX15_0
        cmp Q
        bcc :+

        jsr _LL61
        jmp _LL65

        ; ".LL69 ; small x angle"
:       jsr math_divide_AQ                                              ;$9EAA

        ; ".LL65 ; both continue for scaling based on z"
_LL65:  ldx ZP_TEMP_COUNTER                                             ;$9EAD

        lda ZP_VAR_XX15_2
        bmi _LL62

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
_LL66: .phx                     ; push X to stack (via A)               ;$9EC3

        lda # $00
        sta U
        lda T
        sta Q
        lda ZP_VAR_XX15_3
        cmp Q
        bcc _LL67

        jsr _LL61
        jmp _LL68

        ; ".LL70 ; arrive from below, Yscreen for -ve RU
        ; onto XX3 node heap, index X=CNT"
_LL70:  lda # $48                                                       ;$9ED9
        clc 
        adc R
        sta $0100, x
        inx 
        lda # $00
        adc U
        sta $0100, x
        jmp _LL50

        ; ".LL67 ; Arrive from LL66 above if XX15+3 < Q ; small yangle"
_LL67:  jsr math_divide_AQ                                              ;$9EEC

        ; ".LL68 ; both carry on, also arrive from LL66, scaling y based on z."
_LL68:  pla                                                             ;$9EEF
        tax 
        inx 
        lda ZP_VAR_XX15_5
        bmi _LL70

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
_LL50:  clc                                                             ;$9F06
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
        beq :+

        ; ship is exploding:
        ;
        lda ZP_SHIP_STATE       ; set the state bit that indicates
        ora # state::redraw     ;  that the ship is [will be] drawn
        sta ZP_SHIP_STATE       ;  on the screen, so that the game
        jmp draw_explosion      ;  knows to redraw it to erase it

        ;=======================================================================
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
:       ldy # Hull::edge_count
        lda [ZP_HULL_ADDR], y
        sta ZP_VAR_XX20
.else   ;///////////////////////////////////////////////////////////////////////
:       lda # state::redraw                             ; BBC: EE31     ;$9F2A
        bit ZP_SHIP_STATE
        beq @redraw

        jsr _LL155
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set the redraw bit
        lda # state::redraw
@redraw:ora ZP_SHIP_STATE                                               ;$9F35
        sta ZP_SHIP_STATE

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ldy # 0
        sty ZP_VAR_XX17         ; edge counter
        
.else   ;///////////////////////////////////////////////////////////////////////
        ldy # Hull::edge_count  ; number of edges in the ship's hull
        lda [ZP_HULL_ADDR], y
        sta ZP_VAR_XX20

        ldy # 0                 ; edge counter
        sty U
        sty ZP_VAR_XX17
        inc U
.endif  ;///////////////////////////////////////////////////////////////////////

        bit ZP_SHIP_STATE       ; is ship firing its laser?
        bvc _LL170              ; no? skip over laser lines

        lda ZP_SHIP_STATE       ; stop the ship firing its laser
        and # state::firing^$FF ;  so it doesn't do so endlessly
        sta ZP_SHIP_STATE

        ldy # Hull::laser_vertex
        lda [ZP_HULL_ADDR], y
        tay 
        ldx $0100, y
        stx ZP_VAR_XX15_0
        inx 
        beq _LL170

        ldx $0101, y
        stx ZP_VAR_XX15_1
        inx 
        beq _LL170

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

        bcs _LL170

        ; laser line:
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr redraw_ship_line
.else   ;///////////////////////////////////////////////////////////////////////
        ; insert a laser line into the ship's line-heap:
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
.endif  ;///////////////////////////////////////////////////////////////////////

        ; fallthrough
        ; ...

_LL170:                                                 ; BBC: LL170    ;$9F9F
;===============================================================================
; [10]: calculate which edges are visible:
;===============================================================================
        ; set up a pointer to walk the edge data:
        ;
        ; the ship's hull structure contains an offset from
        ; the beginning of the hull structure to the list of edges
        ;
        ; TODO: this field is probably relative because of the way the data
        ; was assembled separately on BBC; we could make it an absolute
        ; address for harmless to save a few cycles
        ;
        ldy # Hull::edge_data_lo
        clc 
        lda [ZP_HULL_ADDR], y   ; read lo-byte offset
        adc ZP_HULL_ADDR_LO     ; add to the hull struct address
        sta ZP_TEMP_ADDR2_LO

        ldy # Hull::edge_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR2_HI

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_COUNTER

_LL75:  ldy # 0

.else   ;///////////////////////////////////////////////////////////////////////
        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_VAR

        ldy ZP_VAR_XX17

_LL75:  ; in the original code, this label              ; BBC: LL75     ;$9FB8
        ; has to come *after* the `ldy`
.endif  ;///////////////////////////////////////////////////////////////////////

        lda [ZP_TEMP_ADDR2], y
        cmp ZP_VAR_XX4
        bcc _LLx78

        iny 
        lda [ZP_TEMP_ADDR2], y

.if     !.defined( FEATURE_FLICKERFREE )
        ;///////////////////////////////////////////////////////////////////////
        iny 
.endif  ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_P
        and # %00001111
        tax 
        lda ZP_VAR_XX2, x
        bne _LL79

        lda ZP_VAR_P
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_VAR_XX2, x
        bne _LL79

_LLx78: jmp _LL78               ; "edge not visible"?                   ;$9FD6

_LL79:                                                  ; BBC: LL79     ;$9FD9
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        iny
        lda [ZP_TEMP_ADDR2], y
        tax
.else   ;///////////////////////////////////////////////////////////////////////
        lda [ZP_TEMP_ADDR2], y  ; "edge data byte #2"
        tax                     ; "index into node heap for first node of edge"
        iny                     ; "Y = 3"
        lda [ZP_TEMP_ADDR2], y  ; "edge data byte #3"
        sta Q                   ; "index into node heap for other node of edge"
.endif  ;///////////////////////////////////////////////////////////////////////

        lda $0101, x
        sta ZP_VAR_XX15_1
        lda $0100, x
        sta ZP_VAR_XX15_0
        lda $0102, x
        sta ZP_VAR_XX15_2
        lda $0103, x
        sta ZP_VAR_XX15_3

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        iny
        lda [ZP_TEMP_ADDR2], y
        tax
.else   ;///////////////////////////////////////////////////////////////////////
        ldx Q                   ; "other index into node heap for second node"
.endif  ;///////////////////////////////////////////////////////////////////////

        lda $0100, x
        sta ZP_VAR_XX15_4
        lda $0103, x
        sta ZP_VAR_XX12_1
        lda $0102, x
        sta ZP_VAR_XX12_0
        lda $0101, x
        sta ZP_VAR_XX15_5

        jsr clip_line_flip      ; "CLIP2, take care of swop and clips"?
        bcs _LLx78              ; "edge not visible"?

.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        jsr redraw_ship_line
.endif  ;///////////////////////////////////////////////////////////////////////

        ; add lines to heap / draw lines?
        ; TODO: only ever called here -- we could inline it here
        jmp _LL80

; NOTE: in the original code, segment "CODE_A013" appears here          ;$A013


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
.if     !.defined( FEATURE_FLICKERFREE )
        ;///////////////////////////////////////////////////////////////////////
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
.endif  ;///////////////////////////////////////////////////////////////////////

_LL78:                                                  ; BBC: LL78     ;$A15B
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_FLICKERFREE
        ;///////////////////////////////////////////////////////////////////////
        lda ZP_VAR_XX14         
        cmp ZP_TEMP_COUNTER
        bcs _LL81

        lda ZP_TEMP_ADDR2_LO    ; take the low-address
        clc
        adc # 4                 ; add 4-bytes
        sta ZP_TEMP_ADDR2_LO    ; write it back...
        bcc :+                  ; but, did it overflow?
        inc ZP_TEMP_ADDR2_HI    ; yes, also increment the high-byte
:
        inc ZP_VAR_XX17         ; increment edge counter
        ldy ZP_VAR_XX17
        cpy ZP_VAR_XX20         ; all edges done?
        bcs _LL81               ;
        jmp _LL75

_LL81:  ; fallthrough to LL155
        ; ...

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

:       jmp _LL75                                                       ;$A16F

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
        ldy ZP_VAR_XX14+0
        cpy ZP_VAR_XX14+1
        php

        ldx # 3                 ; copy 4 bytes for line-coords (X1/Y1/X2/Y2)
:       lda ZP_LINE_X1, x
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
        sty ZP_VAR_XX14+0

        plp
        bcs @rts

        jmp draw_line

@rts:   rts

;///////////////////////////////////////////////////////////////////////////////
.endif
