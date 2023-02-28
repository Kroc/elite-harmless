; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "code_28BA.asm":
;
.segment        "CODE_28BA"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; unused / unreferenced?
;$28BA:

        ; single pixel masks?
        .byte   %10000000       ;=$80
        .byte   %01000000       ;=$40
        .byte   %00100000       ;=$20
        .byte   %00010000       ;=$10
        .byte   %00001000       ;=$08
        .byte   %00000100       ;=$04
        .byte   %00000010       ;=$02
        .byte   %00000001       ;=$01
        .byte   %10000000       ;=$80
        .byte   %01000000       ;=$40

; unused / unreferenced?
;$28C4:
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03

;///////////////////////////////////////////////////////////////////////////////
.endif

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


_28d5:                                                                  ;$28D5
;===============================================================================
        ; loads A & X with $0F!
        lda # $0f
        tax 
        rts 


print_flight_token_and_divider:                                         ;$28D9
;===============================================================================
; print a flight token and then draw a line across the screen:
; i.e. screen titles
;
; in:   A                       flight-token, already descrambled
;
;-------------------------------------------------------------------------------
        jsr print_flight_token


draw_line_divider_title:                                ; BBC: NLIN4    ;$28DC
;===============================================================================
; draws a line across the screen at Y = 19:
;
;-------------------------------------------------------------------------------
.export draw_line_divider_title

        lda # 19
        bne draw_line_divider           ; (always branches)


draw_line_divider_galactic_chart:                       ; BBC: NLIN     ;$28E0
;===============================================================================
; the galactic chart uses a different position:
;
;-------------------------------------------------------------------------------
        lda # 23                ; set the Y-position to draw the line
       .cursor_down             ; move down one row

        ; fallthrough...
        ;

draw_line_divider:                                      ; BBC: NLIN2    ;$28E5
;===============================================================================
; called from galactic chart screen;
; draws a line across the screen
;
; in:   A                       Y-position of line
;
;-------------------------------------------------------------------------------
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_XX15_1       ; set Y-position of line,
        sta ZP_VAR_XX15_3       ; both start and end (straight)
.else   ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_XX15_1
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set X to go from 0 to 255
        ldx # $00               ; begin with zero
        stx ZP_VAR_XX15_0       ; set line-begin
        dex                     ; roll around to 255
        stx ZP_VAR_XX15_2       ; set line-end
        
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jmp draw_line
.else   ;///////////////////////////////////////////////////////////////////////
        ; use the faster straight-line routine,
        ; rather than the generic line routine
        jmp draw_straight_line
.endif  ;///////////////////////////////////////////////////////////////////////


_28f3:                                                                  ;$28F3
;===============================================================================
; for `clip_sun_line`:
;
;      YY = middle-point of line, in viewport px (0-255)
;       A = half-width of line
;
; for `draw_straight_line`: 
;
;       Y = Y-pos of line, in viewport px (0-144)
;-------------------------------------------------------------------------------
        jsr clip_sun_line

        ; set parameter for drawing line
        sty ZP_VAR_XX15_1

        ; remove this line from the scanline cache
        lda # $00
        sta SUN_BUFFER, y

        jmp draw_straight_line


_2900:                                                                  ;$2900
;===============================================================================
        .byte   %10000000       ;=$80
        .byte   %11000000       ;=$C0
        .byte   %11100000       ;=$E0
        .byte   %11110000       ;=$F0
        .byte   %11111000       ;=$F8
        .byte   %11111100       ;=$FC
        .byte   %11111110       ;=$FE
_2907:                                                                  ;$2907
        .byte   %11111111       ;=$FF
        .byte   %01111111       ;=$7F
        .byte   %00111111       ;=$3F
        .byte   %00011111       ;=$1F
        .byte   %00001111       ;=$0F
        .byte   %00000111       ;=$07
        .byte   %00000011       ;=$03
        .byte   %00000001       ;=$01


_290f:                                                                  ;$209F
;===============================================================================
        jsr multiplied_now_add
        sta ZP_VAR_YY_HI
        txa 
        sta DUST_Y_LO, y


draw_particle:                                                          ;$2918
;===============================================================================
; draw a single dust particle:
;
; in:   ZP_VAR_XX15_0           X-distance from middle of screen
;       ZP_VAR_XX15_1           Y-distance from middle of screen
;       ZP_VAR_Z                dust Z-distance
;-------------------------------------------------------------------------------
        lda ZP_VAR_XX15_0
        bpl :+                  ; handle dust to the right

        ; X is negative (left of centre) --
        ; negate the value for the math to follow:
        eor # %01111111         ; flip the sign
        clc                     ; carry must be clear
        adc # $01               ; add 1 to create 2's compliment

        ; flip the sign and put aside for later
:       eor # %10000000                                                 ;$2921
        tax 

        ; has the dust particle traveled off
        ; the top/bottom of the screen?
        lda ZP_VAR_XX15_1       ; get particle's Y-distance from centre
        and # %01111111         ; ignore the sign
        ; has the dust particle gone beyond the half-height?
        cmp # VIEWPORT_HEIGHT / 2
        ; if yes, don't process
        ; (this is an RTS jump)
       .bge _2976

        ; if the dust Y-distance is positive,
        ; the value doesn't need altering
        lda ZP_VAR_XX15_1
        bpl :+
        
        ; negate the Y
        eor # %01111111
        adc # $01

        ; put aside the positive-only Y value
:       sta T                                                           ;$2934
        ; get the viewport half-height again
        lda # (VIEWPORT_HEIGHT / 2) + 1
        ; calculate "Y-distance from the centre of the screen"
        sbc T

        ; fall through to the routine that does
        ; the actual bitmap manipulation
        ;

paint_particle:                                                         ;$293A
;===============================================================================
; paint a dust particle to the bitmap screen:
;
; in:   A                       Y-position (px)
;       X                       X-position (px)
;       ZP_VAR_Z                dust Z-distance
;
; out:  Y                       (preserved)
;-------------------------------------------------------------------------------
        sty ZP_TEMP_VAR         ; preserve Y through this ordeal
        tay                     ; get a copy of our Y-coordinate

        ; get a bitmap address for a char row:
        ;
        ; reduce the X-position to a multiple of 8,
        ; i.e. a character column
        txa 
        and # %11111000

        ; add this to the bitmap address for the given row
        clc 
        adc row_to_bitmap_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # 0
        sta ZP_TEMP_ADDR1_HI

        ; get the row within the character cell
        tya 
        and # %00000111         ; modulo 8 (0-7)
        tay 

        ; get the pixel within that row
        txa 
        and # %00000111         ; modulo 8 (0-7)
        tax 

        ; the Z-check makes effectively the same paint operation for Z>=144 and
        ; Z>=80, this seems to be a remnant from a different implementation.
        ; we could instead use this to grow dust in more detail, using
        ; a single-pixel bitmask for far, far away dust particles
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda ZP_VAR_Z            ; "pixel distance"
        cmp # 144               ; is the dust-particle >= 144 Z-distance?
       .bge :+                  ; yes, is very far away
.endif  ;///////////////////////////////////////////////////////////////////////

        lda _28c8, x            ; get mask for desired pixel-position
        eor [ZP_TEMP_ADDR1], y  ; mask against the existing pixels
        sta [ZP_TEMP_ADDR1], y  ; paint the pixel to the bitmap
        
        lda ZP_VAR_Z            ; again get the dust Z-distance
        cmp # 80                ; is the dust-particle >= 80 Z-distance?
       .bge @done

        dey                     ; move up a pixel-row 
        bpl :+                  ; didn't go off the top of the char?
        
        ldy # $01               ; use row 1 instead of changing chars

        ; draw pixels for very distant dust:
        ;
:       lda _28c8, x            ; get mask for desired pixel-position   ;$296D
        eor [ZP_TEMP_ADDR1], y  ; mask the background
        sta [ZP_TEMP_ADDR1], y  ; merge the pixel with the background

@done:  ldy ZP_TEMP_VAR         ; restore Y                             ;$2974
_2976:  rts                                                             ;$2976


; segment "CODE_2977" from "draw_circles.asm" goes here


.segment        "CODE_2A12"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

dust_swap_xy:                                                           ;$2A12
;===============================================================================
        ldy DUST_COUNT          ; get number of dust particles

:       ldx DUST_Y_HI, y        ; get dust-particle Y-position          ;$2A15
        lda DUST_X_HI, y        ; get dust-particle X-position
        sta ZP_VAR_XX15_1       ; (put aside X-position)
        sta DUST_Y_HI, y        ; save the Y-value to the X-position
        txa                     ; move the Y-position into A
        sta ZP_VAR_XX15_0       ; (put aside Y-value)
        sta DUST_X_HI, y        ; write the X-value to the Y-position
        lda DUST_Z_HI, y        ; get dust z-position
        sta ZP_VAR_Z            ; (put aside Z-position)

        jsr draw_particle

        dey 
        bne :-

        rts 


move_dust:                                                              ;$2A32
;===============================================================================
; move dust particles based on COCKPIT_VIEW:
;
; TODO: this process is horribly complex and slow,
;       optimisation here might help a lot
;-------------------------------------------------------------------------------
        ldx COCKPIT_VIEW        ; current cockpit view direction
        beq move_dust_front     ; COCKPIT_VIEW == front
        dex 
        bne :+                  ; animate left/right?
        jmp move_dust_rear
:       jmp _37e9                                                       ;$2A3D

move_dust_front:                                                        ;$2A40
        ;-----------------------------------------------------------------------
        ldy DUST_COUNT          ; number of dust particles

        ; calculate ZP_PLAYER_SPEED / DUST_Z_HI, y -> {P.R}
@loop:  jsr get_dust_speed                                              ;$2A43

        ; divide result by 4:
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda R                   ; unnecessary, A is R after `get_dust_speed`
.endif  ;///////////////////////////////////////////////////////////////////////
        lsr ZP_VAR_P            ; divide high byte by 2
        ror                     ; ripple to low-byte
        lsr ZP_VAR_P            ; divide high byte by 2, again
        ror                     ; ripple to low-byte
        ora # %00000001         ; must never be completely zero!
        sta Q                   ; so Q is SPEED/DZ/4 if P is 0..sure?

        ; subtract the fractional speed
        lda DUST_Z_LO, y
        sbc ZP_SPEED_LO         ; is probably still (ZP_PLAYER_SPEED&3)<<6
        sta DUST_Z_LO, y

        lda DUST_Z_HI, y
        sta ZP_VAR_Z            ; backup old dust-z value
        sbc ZP_SPEED_HI
        sta DUST_Z_HI, y

        ; move Y:
        ;-----------------------------------------------------------------------
        ; NOTE: this call is in the `math_square` routine, and reads
        ;       the dust Y-position for the particle index in Y
        jsr _3992
        sta ZP_VAR_YY_HI

        lda ZP_VAR_P
        adc DUST_Y_LO, y
        sta ZP_VAR_YY_LO
        sta R

        lda ZP_VAR_XX15_1
        adc ZP_VAR_YY_HI
        sta ZP_VAR_YY_HI
        sta S

        ; move X:
        ;-----------------------------------------------------------------------
        lda DUST_X_HI, y
        sta ZP_VAR_XX15_0
        jsr _3997
        sta ZP_VAR_XX_HI

        lda ZP_VAR_P
        adc DUST_X_LO, y
        sta ZP_VAR_XX_LO

        lda ZP_VAR_XX15_0
        adc ZP_VAR_XX_HI
        sta ZP_VAR_XX_HI
        eor ZP_INV_ROLL_SIGN
        jsr _393c
        jsr multiplied_now_add
        sta ZP_VAR_YY_HI
        stx ZP_VAR_YY_LO
        eor ZP_ROLL_SIGN        ; roll sign?
        jsr _3934
        jsr multiplied_now_add
        sta ZP_VAR_XX_HI
        stx ZP_VAR_XX_LO
        ldx ZP_PITCH_MAGNITUDE
        lda ZP_VAR_YY_HI
        eor ZP_INV_PITCH_SIGN
        jsr _393e               ; multiply_small_number:A.P = A*X (X<32)
        sta Q
        jsr _3a4c
        asl ZP_VAR_P
        rol 
        sta T

        lda # $00
        ror 
        ora T
        jsr multiplied_now_add  ; A.P + R.S -> X.A
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y
        lda ZP_VAR_YY_LO
        sta R
        lda ZP_VAR_YY_HI
        sta S
        lda # $00
        sta ZP_VAR_P
        lda ZP_BETA
        eor # %10000000
        jsr _290f
        lda ZP_VAR_XX_HI
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y
        and # %01111111
        cmp # $78
        bcs @2b0a
        lda ZP_VAR_YY_HI
        sta DUST_Y_HI, y
        sta ZP_VAR_XX15_1
        and # %01111111
        cmp # $78
        bcs @2b0a
        lda DUST_Z_HI, y
        cmp # $10
        bcc @2b0a
        sta ZP_VAR_Z

@draw:  jsr draw_particle       ; paint the dust particle to screen     ;$2B00
        dey                     ; one more particle done 
        beq @rts                ; if none left, exit
        jmp @loop               ; process next dust particle

@rts:   rts                                                             ;$2B09

        ;-----------------------------------------------------------------------
@2b0a:  jsr get_random_number                                           ;$2B0A
        ora # %00000100
        sta ZP_VAR_XX15_1
        sta DUST_Y_HI, y

        jsr get_random_number
        ora # %00001000
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y

        jsr get_random_number
        ora # %10010000
        sta DUST_Z_HI, y
        sta ZP_VAR_Z

        lda ZP_VAR_XX15_1
        jmp @draw


move_dust_rear:                                                         ;$2B2D
;===============================================================================
        ldy DUST_COUNT          ; number of dust particles
_2b30:                                                                  ;$2B30
        jsr get_dust_speed
        lda R
        lsr ZP_VAR_P1
        ror 
        lsr ZP_VAR_P1
        ror 
        ora # %00000001
        sta Q
        lda DUST_X_HI, y
        sta ZP_VAR_XX15_0
        jsr _3997
        sta ZP_VAR_XX_HI
        lda DUST_X_LO, y
        sbc ZP_VAR_P1
        sta ZP_VAR_XX_LO
        lda ZP_VAR_XX15_0
        sbc ZP_VAR_XX_HI
        sta ZP_VAR_XX_HI
        ; NOTE: this call is in the `math_square` routine, and reads
        ;       the dust Y-position for the particle index in Y
        jsr _3992
        sta ZP_VAR_YY_HI

        lda DUST_Y_LO, y
        sbc ZP_VAR_P1
        sta ZP_VAR_YY_LO
        sta R

        lda ZP_VAR_XX15_1
        sbc ZP_VAR_YY_HI
        sta ZP_VAR_YY_HI
        sta S

        lda DUST_Z_LO, y
        adc ZP_SPEED_LO
        sta DUST_Z_LO, y

        lda DUST_Z_HI, y
        sta ZP_VAR_Z
        adc ZP_SPEED_HI
        sta DUST_Z_HI, y

        lda ZP_VAR_XX_HI
        eor ZP_ROLL_SIGN
        jsr _393c
        jsr multiplied_now_add
        sta ZP_VAR_YY_HI
        stx ZP_VAR_YY_LO
        eor ZP_INV_ROLL_SIGN
        jsr _3934
        jsr multiplied_now_add
        sta ZP_VAR_XX_HI
        stx ZP_VAR_XX_LO

        lda ZP_VAR_YY_HI
        eor ZP_INV_PITCH_SIGN
        ldx ZP_PITCH_MAGNITUDE
        jsr _393e
        sta Q

        lda ZP_VAR_XX_HI
        sta S
        eor # %10000000
        jsr _3a50
        asl ZP_VAR_P1
        rol 
        sta T

        lda # $00
        ror 
        ora T
        jsr multiplied_now_add
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y

        lda ZP_VAR_YY_LO
        sta R

        lda ZP_VAR_YY_HI
        sta S

        lda # $00
        sta ZP_VAR_P1

        lda ZP_BETA
        jsr _290f

        lda ZP_VAR_XX_HI
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y

        lda ZP_VAR_YY_HI
        sta DUST_Y_HI, y
        sta ZP_VAR_XX15_1
        and # %01111111
        cmp # $6e
        bcs _2bf7

        lda DUST_Z_HI, y
        cmp # $a0
        bcs _2bf7

        sta ZP_VAR_Z
_2bed:                                                                  ;$2BED
        jsr draw_particle
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
        sta DUST_Z_HI, y
        sta ZP_VAR_Z
        lsr 
        bcs _2c1a
        lsr 
        lda # $fc
        ror 
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y
        jsr get_random_number
        sta ZP_VAR_XX15_1
        sta DUST_Y_HI, y
        jmp _2bed

        ;-----------------------------------------------------------------------

_2c1a:                                                                  ;$2C1A
        jsr get_random_number
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y
        lsr 
        lda # $e6
        ror 
        sta ZP_VAR_XX15_1
        sta DUST_Y_HI, y
        bne _2bed

_MAS1:                                                  ; BBC: MAS1     ;$2C2D
;===============================================================================
        lda ZP_SHIP_XPOS_LO, y
        asl 
        sta ZP_VALUE_pt2
        lda ZP_SHIP_XPOS_HI, y
        rol 
        sta ZP_VALUE_pt3
        lda # $00
        ror 
        sta ZP_VALUE_pt4
        jsr _2d69
        sta ZP_SHIP_XPOS_SIGN, x
_2c43:                                                                  ;$2C43
        ldy ZP_VALUE_pt2
        sty ZP_SHIP_XPOS_LO, x
        ldy ZP_VALUE_pt3
        sty ZP_SHIP_XPOS_HI, x
        and # %01111111
        rts 


_2c4e:                                                                  ;$2C4E
;===============================================================================
; examine a ship's X/Y/Z position?
;
; in:   A                       a starting value to merge with
;       Y                       a multiple of 37 bytes for each `Ship` struct
;-------------------------------------------------------------------------------
        lda # $00

        ; fallthrough
        ; ...

_MAS2:                                                  ; BBC: MAS2     ;$2C50
;===============================================================================
; get a [rough] maximum-distance to a ship:
;
; in:   A                       a starting value to merge with
;       Y                       a multiple of 37 bytes for each `Ship` struct
;-------------------------------------------------------------------------------
        ora ships + Ship::xpos + 2, y
        ora ships + Ship::ypos + 2, y
        ora ships + Ship::zpos + 2, y
        and # %01111111         ; strip sign

        rts 


_2c5c:                                                                  ;$2C5C
;===============================================================================
        lda ship_00 + Ship::xpos + 1, y                                 ;=$F901
        jsr math_square
        sta R

        lda ship_00 + Ship::ypos + 1, y                                 ;=$F904
        jsr math_square
        adc R
        bcs _2c7a
        sta R

        lda ship_00 + Ship::zpos + 1, y                                 ;=$F907
        jsr math_square
        adc R
        bcc _2c7c
_2c7a:                                                                  ;$2C7A
        lda # $ff
_2c7c:                                                                  ;$2C7C
        rts 


_2c7d:                                                                  ;$2C7D
;===============================================================================
        ; print "docked"
.import MSG_DOCKED_DOCKED:direct
        lda # MSG_DOCKED_DOCKED
        jsr print_docked_str

        jsr paint_newline
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


status_screen:                                                          ;$2C9B
;===============================================================================
; display status page:
;
;-------------------------------------------------------------------------------
        lda # page::status
        jsr set_page_6a2f
        jsr _TT111

        lda # 7
       .set_cursor_col
        
        ; "COMMANDER ... PRESENT SYSTEM ... HYPERSPACE SYSTEM ... CONDITION"
.import TKN_FLIGHT_STATUS_TITLE:direct
        lda # TKN_FLIGHT_STATUS_TITLE
        jsr print_flight_token_and_divider
        
        lda # $0f
        ldy ZP_IS_DOCKED
        bne _2c7d

        ; print "GREEN", "RED" or "YELLOW":
        ;-----------------------------------------------------------------------
        ; NOTE: the list of colour name strings begins
        ;       with "GREEN", "RED" & "YELLOW"
        ;
.import TKN_FLIGHT_COLORS:direct
        lda # TKN_FLIGHT_COLORS ; flight token: $E6, "GREEN"
        ldy NUM_ASTEROIDS
        ldx SHIP_SLOT2, y
        beq :+                  ; print "GREEN"

        ldy PLAYER_ENERGY
        cpy # $80               ; +1 if PLAYER_ENERGY > $80?
        adc # $01               ; print "RED" or "YELLOW"
:       jsr print_flight_token_and_newline                              ;$2CC4

_2cc7:                                                                  ;$2CC7
        ; print legal status:
        ;-----------------------------------------------------------------------
        ; print "LEGAL STATUS:"
.import TKN_FLIGHT_LEGAL_STATUS:direct
        lda # TKN_FLIGHT_LEGAL_STATUS
        jsr print_flight_token_and_space

.import TKN_FLIGHT_LEGAL_STATE:direct
        lda # TKN_FLIGHT_LEGAL_STATE
        ldy PLAYER_LEGAL        ; get player's legal status
       .bze :+                  ; print "CLEAN"
        cpy # $32               ; +1 if legal state is >= $32 (TODO: why $32?)
        adc # $01               ; print "OFFENDER" or "FUGITIVE"
:       jsr print_flight_token_and_newline                              ;$2CD7

        ; print player rating:
        ;-----------------------------------------------------------------------
        ; print "RATING:"
.import TKN_FLIGHT_RATING:direct
        lda # TKN_FLIGHT_RATING
        jsr print_flight_token_and_space

        lda PLAYER_KILLS_HI     ; number of kills
       .bnz _2c88               ; >0, skip ahead

        tax 
        lda PLAYER_KILLS_LO
        lsr 
        lsr 
_2cea:                                                                  ;$2CEA
        inx 
        lsr 
        bne _2cea
_2cee:                                                                  ;$2CEE
        ; TODO: what is X if the player has 0 kills?
        txa 

        ; print "FUGITIVE"?
        clc 
        adc # $15
        jsr print_flight_token_and_newline

        ; print "EQUIPMENT:"
.import TKN_FLIGHT_EQUIPMENT:direct
        lda # TKN_FLIGHT_EQUIPMENT
        jsr print_flight_token_and_newline_and_indent
        lda PLAYER_ESCAPEPOD
        beq _2d04

        ; print "ESCAPE POD"
.import TKN_FLIGHT_ESCAPE_POD:direct
        lda # TKN_FLIGHT_ESCAPE_POD
        jsr print_flight_token_and_newline_and_indent

_2d04:                                                                  ;$2D04
        lda PLAYER_SCOOP
        beq _2d0e
.import TKN_FLIGHT_FUEL_SCOOPS:direct
        lda # TKN_FLIGHT_FUEL_SCOOPS
        jsr print_flight_token_and_newline_and_indent
_2d0e:                                                                  ;$2D0E
        lda PLAYER_ECM
        beq _2d18
.import TKN_FLIGHT_ECM_SYSTEM:direct
        lda # TKN_FLIGHT_ECM_SYSTEM
        jsr print_flight_token_and_newline_and_indent
_2d18:                                                                  ;$2D18
        lda # $71               ;="ENERGY BOMB"
        sta ZP_VAR_XX4
_2d1c:                                                                  ;$2D1C
        tay 
        ldx SHIP_SLOTS, y       ; ship slots? NB: "$04c3 - $71"
        beq _2d25
        jsr print_flight_token_and_newline_and_indent
_2d25:                                                                  ;$2D25
        inc ZP_VAR_XX4
        lda ZP_VAR_XX4
        cmp # $75
        bcc _2d1c
        ldx # $00
_2d2f:                                                                  ;$2D2F
        stx ZP_TEMP_COUNTER1

        ; print "FRONT" / "REAR" / "LEFT" / "RIGHT"
.import TKN_FLIGHT_DIRECTIONS:direct
        ldy PLAYER_LASERS, x
        beq _2d59
        txa 
        clc 
        adc # TKN_FLIGHT_DIRECTIONS
        jsr print_flight_token_and_space

        lda # $67
        ldx ZP_TEMP_COUNTER1
        ldy PLAYER_LASERS, x
        cpy # laser::beam | $0f
        bne _2d4a
        lda # $68
_2d4a:                                                                  ;$2D4A
        cpy # laser::beam | $17
        bne _2d50
        lda # $75
_2d50:                                                                  ;$2D50
        cpy # $32
        bne _2d56

.import TKN_FLIGHT_MINING_LASER:direct
        lda # TKN_FLIGHT_MINING_LASER
_2d56:                                                                  ;$2D56
        jsr print_flight_token_and_newline_and_indent
_2d59:                                                                  ;$2D59
        ldx ZP_TEMP_COUNTER1
        inx 
        cpx # $04
        bcc _2d2f
        rts 


print_flight_token_and_newline_and_indent:                              ;$2D61
;===============================================================================
        jsr print_flight_token_and_newline
        lda # 6
.ifdef  BUILD_ORIGINAL
        jmp set_cursor_col
.else
        sta ZP_CURSOR_COL
        rts
.endif


_2d69:                                                                  ;$2D69
;===============================================================================
        lda ZP_VALUE_pt4
        sta S
        and # %10000000
        sta T
        eor ZP_SHIP_XPOS_SIGN, x
        bmi _2d8d
        lda ZP_VALUE_pt2
        clc 
        adc ZP_SHIP_XPOS_LO, x
        sta ZP_VALUE_pt2
        lda ZP_VALUE_pt3
        adc ZP_SHIP_XPOS_HI, x
        sta ZP_VALUE_pt3
        lda ZP_VALUE_pt4
        adc ZP_SHIP_XPOS_SIGN, x
        and # %01111111
        ora T
        sta ZP_VALUE_pt4
        rts 

        ;-----------------------------------------------------------------------

_2d8d:                                                                  ;$2D8D
        lda S
        and # %01111111
        sta S
        lda ZP_SHIP_XPOS_LO, x
        sec 
        sbc ZP_VALUE_pt2
        sta ZP_VALUE_pt2
        lda ZP_SHIP_XPOS_HI, x
        sbc ZP_VALUE_pt3
        sta ZP_VALUE_pt3
        lda ZP_SHIP_XPOS_SIGN, x
        and # %01111111
        sbc S
        ora # %10000000
        eor T
        sta ZP_VALUE_pt4
        bcs _2dc4
        lda # $01
        sbc ZP_VALUE_pt2
        sta ZP_VALUE_pt2
        lda # $00
        sbc ZP_VALUE_pt3
        sta ZP_VALUE_pt3
        lda # $00
        sbc ZP_VALUE_pt4
        and # %01111111
        ora T
        sta ZP_VALUE_pt4
_2dc4:                                                                  ;$2DC4
        rts 


_2dc5:                                                                  ;$2DC5
;===============================================================================
; in:   X                       offset from `ZP_SHIP` to the desired
;                               matrix row; i.e. a `MATRIX_ROW_*` constant
;
;       Y                       offset from `ZP_SHIP` to the desired
;                               matrix row; i.e. a `MATRIX_ROW_*` constant
;-------------------------------------------------------------------------------
        ; ROW X
        ;-----------------------------------------------------------------------
        lda ZP_SHIP + MATRIX_COL0_HI, x
        and # %01111111         ; extract HI byte without sign
        lsr                     ; divide by 2
        sta T

        lda ZP_SHIP + MATRIX_COL0_LO, x
        sec 
        sbc T
        sta R

        lda ZP_SHIP + MATRIX_COL0_HI, x
        sbc # $00
        sta S

        ; ROW Y
        ;-----------------------------------------------------------------------
        lda ZP_SHIP + MATRIX_COL0_LO, y
        sta ZP_VAR_P

        lda ZP_SHIP + MATRIX_COL0_HI, y
        and # %10000000         ; extract sign
        sta T                   ; put sign aside
        
        lda ZP_SHIP + MATRIX_COL0_HI, y
        and # %01111111         ; extract magnitude
        lsr                     ; divide by 2
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        ora T                   ; restore sign
        eor ZP_B1               ; rotation sign?
        stx Q

        jsr multiplied_now_add
        sta ZP_VALUE_pt2
        stx ZP_VALUE_pt1
        ldx Q
        lda ZP_SHIP + MATRIX_COL0_HI, y
        and # %01111111
        lsr 
        sta T
        lda ZP_SHIP + MATRIX_COL0_LO, y
        sec 
        sbc T
        sta R
        lda ZP_SHIP + MATRIX_COL0_HI, y
        sbc # $00
        sta S
        lda ZP_SHIP + MATRIX_COL0_LO, x
        sta ZP_VAR_P
        lda ZP_SHIP + MATRIX_COL0_HI, x
        and # %10000000
        sta T
        lda ZP_SHIP + MATRIX_COL0_HI, x
        and # %01111111
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        ora T
        eor # %10000000
        eor ZP_B1
        stx Q
        jsr multiplied_now_add
        sta ZP_SHIP + MATRIX_COL0_HI, y
        stx ZP_SHIP + MATRIX_COL0_LO, y
        ldx Q
        lda ZP_VALUE_pt1
        sta ZP_SHIP + MATRIX_COL0_LO, x
        lda ZP_VALUE_pt2
        sta ZP_SHIP + MATRIX_COL0_HI, x

        rts 

; convert values to strings:
; TODO: this to be its own segment, we WILL want to replace it
;===============================================================================

; the number to be converted:
; (a 4-byte big-endian buffer is defined for $77..$7A)
ZP_VALUE_OVFLW  := $9c  ; because, why not!?

; working copy of the number:
ZP_VCOPY        := $6b
ZP_VCOPY_pt1    := $6b
ZP_VCOPY_pt2    := $6c
ZP_VCOPY_pt3    := $6d
ZP_VCOPY_pt4    := $6e
ZP_VCOPY_OVFLW  := $6f
ZP_PADDING      := $99
ZP_MAXLEN       := $bb  ; maximum length of string

_max_value:                                                             ;$2E51
        ; maximum value:
        ;
        ; this is the maximum printable value: 100-billion ($17_4876_E800);
        ; note that this lacks the first byte, $17, as that is handled
        ; directly in the code itself
        .byte   $48, $76, $e8, $00


print_tiny_value:                                                       ;$2E55
;===============================================================================
; print an 8-bit value, given in X, padded to 3 chars:
;
; in:   X                       value to print
;-------------------------------------------------------------------------------
        ; set the padding to a max. number of digits to 3, i.e. "  0"-"255"
        lda # $03

print_small_value:                                                      ;$2E57
;===============================================================================
; print an 8-bit value, given in X, with A specifying
; the number of characters to pad to:
;
; in:   X                       value to print
;       A                       width in chars to pad to
;-------------------------------------------------------------------------------
        ; strip the hi-byte for what follows; only use X
        ldy # $00

print_medium_value:                                                     ;$2E59
;===============================================================================
; print a 16-bit value stored in X/Y:
;
; in:   A                       max. no. of expected digits
;       X                       lo-byte of value
;       Y                       hi-byte of value
;-------------------------------------------------------------------------------
        sta ZP_PADDING

        ; zero out the upper-bytes of the 32-bit value to print
        lda # $00
        sta ZP_VALUE_pt1
        sta ZP_VALUE_pt2

        ; insert the 16-bit value given
        sty ZP_VALUE_pt3
        stx ZP_VALUE_pt4

print_large_value:                                      ; BBC: BPRNT    ;$2E65
;===============================================================================
; print a large value, up to 100-billion:
;
; in:   $77-$7A numerical value (note: big-endian)
;       $99     max. number of expected digits, i.e. left-pad the number
;       c       carry set: use decimal point
;-------------------------------------------------------------------------------
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
        sta ZP_VAR_XX17         ; put original max.length of text aside

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
        bpl :+

        inc ZP_MAXLEN

:       dec ZP_VAR_XX17                                                 ;$2F06
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


; a block of text-printing related flags and variables
;===============================================================================
txt_lcase_mask:                                                         ;$2F18
        ; this byte is used to lower-case charcters, it's ORed with the
        ; character value. its default value $20 sets bit 5 of characters,
        ; changing them to lower-case, e.g. $41 "A" > $61 "a". this byte
        ; gets set to $00 to neuter the effect
        .byte   %00100000

txt_ucase_flag:                                                         ;$2F19
        .byte   %11111111

TKN_FLIGHT_flag:                                                        ;$2F1A
        ; when printing docked strings ("text_docked.asm"), this flag causes
        ; the docked tokens to be printed as flight tokens ("text_flight.asm")
        ; instead! only function tokens ($00-$20, unscrambled) are exempt, so
        ; as to be able to be able to switch back to docked tokens
        .byte   %00000000

txt_buffer_flag:                                                        ;$2F1B
        .byte   %00000000

txt_buffer_index:                                                       ;$2F1C
        .byte   $00

txt_lcase_flag:                                                         ;$2F1D
        .byte   %00000000

txt_ucase_mask:                                                         ;$2F1E
        ; this byte is used to upper-case charcters, it's ANDed with the
        ; character value -- therefore its default value $FF does nothing.
        ; this byte is changed to %11011111 to enable upper-casing, which
        ; removes bit 5 ($20) from characters, e.g. $61 "a" > $41 "A"
        .byte   %11111111


print_crlf:                                                             ;$2F1F
;===============================================================================
; 'print' a new-line character. i.e. move to the next row, starting column
;-------------------------------------------------------------------------------
        lda # TXT_NEWLINE

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

print_a:                                                                ;$2F22
;===============================================================================
; print "a". that's it
;-------------------------------------------------------------------------------
.export print_a

        lda # 'a'

print_char:                                                             ;$2F24
;===============================================================================
; prints an ASCII character to screen (eventually). note that this routine can
; buffer output to produce effects like text-justification. the actual routine
; that copies pixels to screen is `paint_char`, but this routine is the one
; the text-handling works with
;
; in:   A                       ASCII code
;-------------------------------------------------------------------------------
.export print_char

        ; put X parameter aside,
        ; we need the X register for now
        stx ZP_TEMP_ADDR1_LO

        ; don't automatically upper-case letters?
        ; the upper-case mask is ANDed with the character, so a value
        ; of %11111111 does nothing (a value of %11011111 is used to
        ; remove bit 5, converting characters to upper-case)
        ldx # %11111111
        stx txt_ucase_mask

        cmp # '.'               ; end of sentence?
        beq :+
        cmp # ':'               ; colon?
        beq :+
        cmp # $0a               ;?
        beq :+
        cmp # TXT_NEWLINE       ; end of line
        beq :+
        cmp # ' '
        beq :+
        inx                     ; X = 0

        ; set the capitalisation: if X = $FF then the character
        ; will be automatically upper-cased
:       stx txt_ucase_flag                                              ;$24F0

        ; get back the original X value
        ldx ZP_TEMP_ADDR1_LO

        ; check 'use buffer' flag
        bit txt_buffer_flag     ; check if bit 7 is set
        bmi @add_to_buffer      ; yes? switch to buffered printing

        ; no buffer, print character as-is
        jmp paint_char

@add_to_buffer:                                                         ;$2F4D
        ;=======================================================================
        bit txt_buffer_flag     ; check bit 6
        bvs :+                  ; skip if bit 6 set

        cmp # TXT_NEWLINE       ; new-line character?
        beq @flush_buffer       ; flush buffer

:       ldx txt_buffer_index                                            ;$2F56
        sta TXT_BUFFER, x       ; add the character to the buffer
        
        ldx ZP_TEMP_ADDR1_LO
        inc txt_buffer_index

        clc 
        rts 

@flush_buffer:                                                          ;$2F63
        ;=======================================================================
        ; flush the text buffer to screen
        ;
        ; backup X & Y registers:
       .phx                     ; push X to stack (via A)
       .phy                     ; push Y to stack (via A)

@flush_line:                                                            ;$2F67
        ;-----------------------------------------------------------------------
        ldx txt_buffer_index    ; get current buffer index
       .bze _exit               ; if buffer is empty, exit

        ; does the buffer need to be justified?
        ;
        cpx # 31                ; is the buffer <= 30 chars?
       .blt _print_all          ; if so, the buffer is one line, print as-is

        ; there is more than one line to print, ergo all but the last line
        ; must be justified -- insert extra spaces until the text reaches
        ; the full length of the line
        ;
        ; since we must insert spaces evenly between words, a 'space-counter'
        ; is used to ensure that we ignore an increasing number of spaces
        ; so that new spaces are added further and further down the line,
        ; providing even distribution
        ;
        ; for speed optimisation, the space-counter is implemented as
        ; a 'walking bit', a single bit in a byte that is shifted along
        ; at each step. when the bit falls off the end it gets reset
        ;
        ; the space-counter begins at bit 6; this is so that the first
        ; space encountered triggers justification
        ;
        ; note that whatever the value of $08 prior to calling this routine,
        ; shifting it right once will ensure that the 'minus' check below will
        ; always fail, so $08 will be 'reset' to %01000000 for this routine
        ;
        lsr ZP_TEMP_ADDR1_HI

@justify_line:                                                          ;$2F72
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
        bmi @justify_line       ; catch underflow? max buffer length is 90
        beq @justify_line       ; hit the start of the line? go again

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
        bmi @justify_line

@print_line:                                                            ;$2FB0
        ; a line is already 30-chars long, or has
        ; been justified to the same, print it
        ldx # 30
        jsr _print_chars

        ; move to the next line
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # TXT_NEWLINE
        jsr paint_char
.else   ;///////////////////////////////////////////////////////////////////////
        jsr paint_newline
.endif  ;///////////////////////////////////////////////////////////////////////

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
       .bze @flush_line         ; always branches!

_print_chars:                                                           ;$2FD4
        ;=======================================================================
        ; print X number of characters in the buffer to the screen
        ;
        ; in:   X       length of string to print from the buffer
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
        lda # TXT_NEWLINE
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

_2fee:                                                                  ;$2FEE
        ;=======================================================================
        ; the BBC code says that char 7 is a beep
        ;
        lda # $07               ; BEEP?
        jmp paint_char


_2ff3:                                                                  ;$2FF3
;===============================================================================
; BBC code says this is "update displayed dials"
;
;-------------------------------------------------------------------------------
        ; location of the speed bar on the HUD
        ; TODO: this should be defined in the file with the HUD graphics
        dial_speed_addr = ELITE_BITMAP_ADDR + .bmppos( 18, 30 )

        lda #< dial_speed_addr
        sta ZP_TEMP_ADDR1_LO
        lda #> dial_speed_addr
        sta ZP_TEMP_ADDR1_HI

        jsr _30bb               ; flashing?
        stx ZP_VALUE_pt2
        sta ZP_VALUE_pt1
        
        lda # 14                ; threshold to change colour?
        sta ZP_TEMP_VAR

        lda ZP_PLAYER_SPEED
        jsr hud_drawbar_32

        ;-----------------------------------------------------------------------

        lda # $00
        sta R
        sta ZP_VAR_P1

        lda # $08
        sta S

        lda ZP_ROLL_MAGNITUDE
        lsr 
        lsr 
        ora ZP_ROLL_SIGN
        eor # %10000000
        jsr multiplied_now_add
        jsr _3130
        lda ZP_BETA
        ldx ZP_PITCH_MAGNITUDE
        beq _302b
        sbc # $01
_302b:                                                                  ;$302B
        jsr multiplied_now_add
        jsr _3130

        lda MAIN_COUNTER
        and # %00000011
        bne _2fe0

        ldy # $00
        jsr _30bb
        stx ZP_VALUE_pt1
        sta ZP_VALUE_pt2

        ldx # $03               ; 4 energy banks
        stx ZP_TEMP_VAR
_3044:                                                                  ;$3044
        sty ZP_VAR_XX12_0, x
        dex 
        bpl _3044

        ldx # $03
        lda PLAYER_ENERGY
        lsr 
        lsr 
        sta Q
_3052:                                                                  ;$3052
        sec 
        sbc # $10
        bcc _3064
        sta Q
        lda # $10
        sta ZP_VAR_XX12_0, x
        lda Q
        dex 
        bpl _3052
        bmi _3068
_3064:                                                                  ;$3064
        lda Q
        sta ZP_VAR_XX12_0, x
_3068:                                                                  ;$3068
        lda ZP_VAR_XX12_0, y
        sty ZP_VAR_P1
        jsr hud_drawbar

        ldy ZP_VAR_P1
        iny 
        cpy # $04
        bne _3068

        ; location of the fore-shield bar on the HUD
        dial_fore_addr = ELITE_BITMAP_ADDR + .bmppos( 18, 6 )

        lda #< dial_fore_addr
        sta ZP_TEMP_ADDR1_LO
        lda #> dial_fore_addr
        sta ZP_TEMP_ADDR1_HI
        lda # .color_nybble( LTRED, LTRED )
        sta ZP_VALUE_pt1
        sta ZP_VALUE_pt2

        lda PLAYER_SHIELD_FRONT
        jsr hud_drawbar_128

        lda PLAYER_SHIELD_REAR
        jsr hud_drawbar_128

        lda PLAYER_FUEL
        jsr hud_drawbar_64

        jsr _30bb               ; setup flashing colours
        stx ZP_VALUE_pt2
        sta ZP_VALUE_pt1
        ldx # $0b               ; "threshold to change colour"
        stx ZP_TEMP_VAR

        lda CABIN_HEAT
        jsr hud_drawbar_128

        lda LASER_HEAT
        jsr hud_drawbar_128

        lda # $f0               ; "threshold to change colour"
        sta ZP_TEMP_VAR

        lda VAR_06F3            ; altitude?
        jsr hud_drawbar_128

        jmp _7b6f


_30bb:                                                                  ;$30BB
;===============================================================================
; decide to flash a dial?
;-------------------------------------------------------------------------------
        ldx # .color_nybble(LTRED, LTRED)

        lda MAIN_COUNTER
        and # %00001000         ; every 8th frame?
        and _1d09               ; is flashing enabled?
       .bze :+

        txa 

        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit 
:       lda # .color_nybble( GREEN, GREEN )                             ;$30C8
        
        rts 

;===============================================================================
; draw a bar on the HUD. e.g. for speed, temperature, shield etc.
;
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
        ; divide value by 2 before drawing the bar:
        ; 
        ;       A = value to represent on the bar, 0-31
        ;
        lsr 

hud_drawbar:                                                            ;$30CF
        ;-----------------------------------------------------------------------
        ;
        ;       A = value to represent on the bar, 0-15
        ;
        sta Q                   ; "bar value 1-15"

        ldx # %11111111         ; mask?
        stx R
        cmp ZP_TEMP_VAR         ; "threshold to change colour"
        bcs :+
        
        lda ZP_VALUE_pt2
        bne :++

:       lda ZP_VALUE_pt1                                                ;$30DD

:       sta ZP_32               ; colour to use                         ;$30DF

        ldy # $02               ; "height offset"
        ldx # $03               ; "height of bar - 1"

_30e5:                                                                  ;$30E5
        lda Q                   ; get bar value 0-15

        ; subtract 4 if >= 4?
        cmp # $04
       .blt _3109

        sbc # $04
        sta Q

        lda R                   ; mask
_30f1:                                                                  ;$30F1
        and ZP_32
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        tya 
        clc 
        adc # $06
        bcc :+
        inc ZP_TEMP_ADDR1_HI

:       tay                                                             ;$3103
        dex 
        bmi _next_row
        bpl _30e5
_3109:                                                                  ;$3109
        eor # %00000011
        sta Q
        lda R
        
:       asl                                                             ;$310F
        asl 
        dec Q
        bpl :-
        pha 
        lda # $00
        sta R
        lda # $63
        sta Q
        pla 
        jmp _30f1

        
_next_row:                                                              ;$3122
        ;-----------------------------------------------------------------------
        ; move to the next row in the bitmap:
        ; -- i.e. add 320-px to the bitmap pointer
        ;
        lda ZP_TEMP_ADDR1_LO
        clc 
        adc #< 320
        sta ZP_TEMP_ADDR1_LO

        lda ZP_TEMP_ADDR1_HI
        adc #> 320
        sta ZP_TEMP_ADDR1_HI

        rts 


_3130:                                                                  ;$3130
;===============================================================================
; ".DIL2 -> roll/pitch indicator takes X.A"
;-------------------------------------------------------------------------------
        ldy # $01               ; counter Y = 1
        sta Q
@_3134:                                                                 ;$3134
        sec 
        lda Q
        sbc # $04
        bcs @_3149               ; >= 4?

        lda # $ff
        ldx Q
        sta Q
        lda _28d0, x
        and # %10101010         ; colour mask
        
        jmp @_314d

@_3149:                                                                 ;$3149
        ; clear the bar
        sta Q
        lda # $00
@_314d:                                                                 ;$314D
        ; fill four pixel rows?
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        iny 
        sta [ZP_TEMP_ADDR1], y
        tya 

        ; move to the next cell?
        clc 
        adc # $05
        tay 
        cpy # $1e
        bcc @_3134

        lda ZP_TEMP_ADDR1_LO
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI

        rts 


eject_escapepod:                                        ; BBC: ESCAPE   ;$316E
;===============================================================================
; eject escape pod:
;
;-------------------------------------------------------------------------------
        jsr _83df

        ldx # HULL_COBRAMK3
        stx ZP_SHIP_TYPE
        jsr _3680               ; NOTE: spawns ship-type in X
        bcs :+

        ldx # HULL_MK3_PIRATE
        jsr _3680               ; NOTE: spawns ship-type in X

:       lda # $08                                                       ;$317F
        sta ZP_SHIP_SPEED

        lda # %11000010
        sta ZP_SHIP_PITCH
        lsr 
        sta ZP_SHIP_ATTACK
_318a:                                                                  ;$318A
        jsr move_ship
        jsr draw_ship

        dec ZP_SHIP_ATTACK
        bne _318a

        jsr _SCAN

        lda # $00
        ldx # .sizeof( Cargo )-1

:       sta PLAYER_CARGO, x     ; empty cargo slot                      ;$319B
        dex 
        bpl :-

        sta PLAYER_LEGAL        ; clear legal status
        sta PLAYER_ESCAPEPOD    ; you no longer own an escape pod

        ; some Trumbles™ will slip away
        ; with you, the sneaky things!
        ;
.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////

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

.endif  ;///////////////////////////////////////////////////////////////////////

_31be:                                                                  ;$31BE
        lda # $46               ; default fuel qty
        sta PLAYER_FUEL
        jmp dock_ok             ; docking successful


_31c6:                                                                  ;$31C6
;===============================================================================
; chart search function?
;
;-------------------------------------------------------------------------------
.import MSG_DOCKED_PLANET_NAME_QMARK:direct
        lda # MSG_DOCKED_PLANET_NAME_QMARK
        jsr print_docked_str

        jsr _6f82
        jsr get_galaxy_seed
        lda # $00
        sta ZP_VAR_XX20
_31d5:                                                                  ;$31D5
        jsr text_buffer_on
        jsr _76e9

        ldx txt_buffer_index
        lda ZP_SHIP_YPOS_SIGN, x
        cmp # $0d
        bne _31f1
_31e4:                                                                  ;$31E4
        dex 
        lda ZP_SHIP_YPOS_SIGN, x
        ora # %00100000
        cmp TXT_BUFFER, x
        beq _31e4
        txa 
        bmi _3208
_31f1:                                                                  ;$31F1
        jsr randomize
        inc ZP_VAR_XX20
        bne _31d5
        jsr _TT111
        jsr _6f82

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $06
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

.import MSG_DOCKED_UNKNOWN_PLANET:direct
        lda # MSG_DOCKED_UNKNOWN_PLANET
        jmp print_docked_str

        ;-----------------------------------------------------------------------

_3208:                                                                  ;$3208
        lda ZP_SEED_W1_HI
        sta TSYSTEM_POS_X
        lda ZP_SEED_W0_HI
        sta TSYSTEM_POS_Y
        jsr _TT111
        jsr _6f82
        jsr text_buffer_off
        jmp _877e


_321e:                                                                  ;$321E
;===============================================================================
        lda ZP_SHIP_XPOS_LO     ;=$09
        ora ZP_SHIP_YPOS_LO     ;=$0C
        ora ZP_SHIP_ZPOS_LO     ;=$0F
        bne _322b

        lda # $50
        jsr damage_player
_322b:                                                                  ;$322B
        ldx # $04
        bne _3290
_322f:                                                                  ;$322F
        lda # $00
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr or_xyz_hi           ; combine check with distance
.else   ;///////////////////////////////////////////////////////////////////////
        ora ZP_SHIP_XPOS_HI     ; there's really no need for a JSR for this
        ora ZP_SHIP_YPOS_HI
        ora ZP_SHIP_ZPOS_HI
.endif  ;///////////////////////////////////////////////////////////////////////
        beq _3239
        jmp _3365

        ;-----------------------------------------------------------------------

_3239:                                                                  ;$3239
        jsr _3293

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $fa
        jmp damage_player

        ;-----------------------------------------------------------------------

_3244:                                                                  ;$3244
        lda ECM_COUNTER         ; is an ECM already active?
        bne _321e

        lda ZP_SHIP_ATTACK
        asl 
        bmi _322f

        lsr 
        tax 
        lda ship_addrs_lo, x
        sta ZP_TEMP_ADDR2_LO
        lda ship_addrs_hi, x
        jsr _3581

        lda ZP_SHIP01_XPOS_pt3
        ora ZP_SHIP01_YPOS_pt3
        ora ZP_SHIP01_ZPOS_pt3
        and # %01111111
        ora ZP_SHIP01_XPOS_pt2
        ora ZP_SHIP01_YPOS_pt2
        ora ZP_SHIP01_ZPOS_pt2
        bne _3299

        lda ZP_SHIP_ATTACK
        cmp # attack::active | attack::aggr1    ;=%10000010
        beq _321e

        ldy # $1f
        lda [ZP_TEMP_ADDR2], y
        ; this might be a `ldy # $32`, but I don't see any jump into it
        bit _32a0+1             ;!?
        bne _327d
        ora # %10000000
        sta [ZP_TEMP_ADDR2], y
_327d:                                                                  ;$327D
        lda ZP_SHIP_XPOS_LO     ;=$09
        ora ZP_SHIP_YPOS_LO     ;=$0C
        ora ZP_SHIP_ZPOS_LO     ;=$0F
        bne _328a

        lda # $50
        jsr damage_player
_328a:                                                                  ;$328A
        lda ZP_SHIP_ATTACK
        and # attack::active ^$FF       ;=%01111111
        lsr 
        tax 
_3290:                                                                  ;$3290
        jsr ship_killed
_3293:                                                                  ;$3293
        asl ZP_SHIP_STATE
        sec 
        ror ZP_SHIP_STATE
_3298:                                                                  ;$3298
        rts 

        ;-----------------------------------------------------------------------

_3299:                                                                  ;$3299
        jsr get_random_number
        cmp # $10
        bcs _32a7
_32a0:                                                                  ;$32A0
        ldy # $20
        lda [ZP_TEMP_ADDR2], y
        lsr 
        bcs _32aa
_32a7:                                                                  ;$32A7
        jmp _336e

_32aa:                                                                  ;$32AA
        jmp engage_ecm


_32ad:                                                                  ;$32AD
;===============================================================================
        lda #< VAR_0403
        sta ZP_B0
        lda #> VAR_0403
        sta ZP_B1
        lda # $16
        sta ZP_TEMP_COUNTER2
        cpx # $01
        beq _3244
        cpx # $02
        bne _32ef

        lda ZP_SHIP_BEHAVIOUR
        and # behaviour::angry
        bne _32da

        ; is this ship a transporter?
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_TRANSPORTER )
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

        ; how many police ships are present?
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_VIPER )
        cmp # $04
        bcs _3328

        ; spawn a police viper ship
        ldx # HULL_VIPER
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

        ldx # %00000000
        stx ZP_SHIP_ATTACK

        ldx # behaviour::protected | behaviour::angry   ;=%00100100
        stx ZP_SHIP_BEHAVIOUR

        and # %00000011
        adc # $11
        tax 
        jsr _32ea

        lda # %00000000
        sta ZP_SHIP_ATTACK
        rts 

        ;-----------------------------------------------------------------------

_330f:                                                                  ;$330F
        ldy # Hull::energy
        lda ZP_SHIP_ENERGY
        cmp [ZP_HULL_ADDR], y
        bcs _3319
        inc ZP_SHIP_ENERGY
_3319:                                                                  ;$3319
        cpx # $1e
        bne _3329

        ; are any thargoids present?
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_THARGOID )
        bne _3329
        
        lsr ZP_SHIP_ATTACK
        asl ZP_SHIP_ATTACK
        lsr ZP_SHIP_SPEED
_3328:                                                                  ;$3328
        rts 

        ;-----------------------------------------------------------------------

_3329:                                                                  ;$3329
        jsr get_random_number
        lda ZP_SHIP_BEHAVIOUR
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
        lda ZP_SHIP_BEHAVIOUR
        ora # behaviour::angry
        sta ZP_SHIP_BEHAVIOUR
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
        jsr _SPS4
        jmp _34ac

        ;-----------------------------------------------------------------------

_3357:                                                                  ;$3357
        lsr 
        bcc _3365

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        beq _3365

        lda ZP_SHIP_ATTACK
        and # attack::active | attack::ecm      ;=%10000001
        sta ZP_SHIP_ATTACK
_3365:                                                                  ;$3365
        ldx # $08
_3367:                                                                  ;$3367
        lda ZP_SHIP_XPOS_LO, x
        sta ZP_SHIP01_XPOS_pt1, x
        dex 
        bpl _3367
_336e:                                                                  ;$336E
        jsr _8c8a
        ldy # $0a
        jsr _3ab2
        sta ZP_TEMP_COUNTER1
        lda ZP_SHIP_TYPE
        cmp # $01
        bne _3381
        jmp _344b

        ;-----------------------------------------------------------------------

_3381:                                                                  ;$3381
        cmp # $0e
        bne _339a
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
        sta ZP_SHIP_ROLL
_33a8:                                                                  ;$33A8
        ldy # Hull::energy
        lda [ZP_HULL_ADDR], y
        lsr 
        cmp ZP_SHIP_ENERGY
        bcc _33fd
        lsr 
        lsr 
        cmp ZP_SHIP_ENERGY
        bcc _33d6
        jsr get_random_number
        cmp # $e6
        bcc _33d6

        ldx ZP_SHIP_TYPE
        lda hull_type - 1, x
        bpl _33d6

        lda ZP_SHIP_BEHAVIOUR
        and # behaviour::remove    | behaviour::police \
            | behaviour::protected | behaviour::docking ;=%11110000
        sta ZP_SHIP_BEHAVIOUR
        ldy # Ship::behaviour
        sta [ZP_SHIP_ADDR], y
        
        lda # %00000000
        sta ZP_SHIP_ATTACK
        jmp _3706               ; spawns escape pod?

        ;-----------------------------------------------------------------------

_33d6:                                                                  ;$33D6
        lda ZP_SHIP_STATE
        and # state::missiles
        beq _33fd
        sta T

        jsr get_random_number
        and # %00011111
        cmp T
        bcs _33fd
        
        lda ECM_COUNTER         ; is an ECM already active?
        bne _33fd
        dec ZP_SHIP_STATE       ; reduce number of missiles?

        lda ZP_SHIP_TYPE
        cmp # $1d
        bne _33fa

        ; spawn a thargon!
        ldx # HULL_THARGON
        lda ZP_SHIP_ATTACK
        jmp _370a

        ;-----------------------------------------------------------------------

_33fa:                                                                  ;$33FA
        jmp _a795

        ;-----------------------------------------------------------------------

_33fd:                                                                  ;$33FD
        lda # $00
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr or_xyz_hi           ; combine check with distance
.else   ;///////////////////////////////////////////////////////////////////////
        ora ZP_SHIP_XPOS_HI     ; there's really no need for a JSR for this
        ora ZP_SHIP_YPOS_HI
        ora ZP_SHIP_ZPOS_HI
.endif  ;///////////////////////////////////////////////////////////////////////
        and # %11100000
        bne _3434
        ldx ZP_TEMP_COUNTER1
        cpx # $a0
        bcc _3434

        ldy # Hull::laser_missiles
        lda [ZP_HULL_ADDR], y
        and # %11111000
        beq _3434

        lda ZP_SHIP_STATE
        ora # state::firing
        sta ZP_SHIP_STATE
        cpx # $a3
        bcc _3434

        lda [ZP_HULL_ADDR], y
        lsr 
        jsr damage_player
        dec ZP_SHIP_ACCEL
        lda ECM_COUNTER         ; is an ECM already active?
        bne _3499
        
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $01
        jsr play_sfx

        ldy # $0f
        jmp play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////

_3434:                                                                  ;$3434
        ;-----------------------------------------------------------------------
        lda ZP_SHIP_ZPOS_HI     ;=$10
        cmp # $03
        bcs _3442
        lda ZP_SHIP_XPOS_HI     ;=$0A
        ora ZP_SHIP_YPOS_HI     ;=$0D
        and # %11111110
        beq _3454
_3442:                                                                  ;$3442
        ; randomly generate an attacking ship?
        jsr get_random_number
        ora # attack::active    ;=%10000000
        cmp ZP_SHIP_ATTACK
        bcs _3454
_344b:                                                                  ;$344B
        jsr _35d5
        lda ZP_TEMP_COUNTER1
        eor # %10000000
_3452:                                                                  ;$3452
        sta ZP_TEMP_COUNTER1
_3454:                                                                  ;$3454
        ldy # $10
        jsr _3ab2
        tax 
        eor # %10000000
        and # %10000000
        sta ZP_SHIP_PITCH
        txa 
        asl 
        cmp ZP_B1
        bcc _346c
        lda ZP_B0
        ora ZP_SHIP_PITCH
        sta ZP_SHIP_PITCH
_346c:                                                                  ;$346C
        lda ZP_SHIP_ROLL
        asl 
        cmp # $20
        bcs _348d
        ldy # $16
        jsr _3ab2
        tax 
        eor ZP_SHIP_PITCH
        and # %10000000
        eor # %10000000
        sta ZP_SHIP_ROLL
        txa 
        asl 
        cmp ZP_B1
        bcc _348d
        lda ZP_B0
        ora ZP_SHIP_ROLL
        sta ZP_SHIP_ROLL
_348d:                                                                  ;$348D
        lda ZP_TEMP_COUNTER1
        bmi _349a
        cmp ZP_TEMP_COUNTER2
        bcc _349a
        lda #> $0300            ; TODO: ???
        sta ZP_SHIP_ACCEL
_3499:                                                                  ;$3499
        rts 

        ;-----------------------------------------------------------------------

_349a:                                                                  ;$349A
        and # %01111111
        cmp # $12
        bcc _34ab

        lda # $ff
        ldx ZP_SHIP_TYPE
        cpx # $01
        bne _34a9

        asl 
_34a9:                                                                  ;$34A9
        sta ZP_SHIP_ACCEL
_34ab:                                                                  ;$34AB
        rts 

        ;-----------------------------------------------------------------------

_34ac:                                                                  ;$34AC
        ldy # $0a
        jsr _3ab2
        cmp # $98
        bcc _34b9
        ldx # $00
        stx ZP_B1
_34b9:                                                                  ;$24B9
        jmp _3452


_34bc:                                                                  ;$34BC
;===============================================================================
        lda # $06
        sta ZP_B1
        lsr 
        sta ZP_B0
        lda # $1d
        sta ZP_TEMP_COUNTER2

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        bne _34cf
_34cc:                                                                  ;$34CC
        jmp _3351

        ;-----------------------------------------------------------------------

_34cf:                                                                  ;$34CF
        jsr _357b
        lda ZP_SHIP01_XPOS_pt3
        ora ZP_SHIP01_YPOS_pt3
        ora ZP_SHIP01_ZPOS_pt3
        and # %01111111
        bne _34cc
        jsr _8cad
        lda Q
        sta ZP_VALUE_pt1
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
        lda ZP_VALUE_pt1
        cmp # $9d
        bcc _3504

        lda ZP_SHIP_TYPE
        bmi _352c
_3504:                                                                  ;$3504
        jsr _35d5
        jsr _34ac
_350a:                                                                  ;$350A
        ldx # $00
        stx ZP_SHIP_ACCEL
        inx 
        stx ZP_SHIP_SPEED

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
        inc ZP_SHIP_ACCEL
        lda # $7f
        sta ZP_SHIP_ROLL
        bne _3571
_352c:                                                                  ;$352C
        ldx # $00
        stx ZP_B1
        stx ZP_SHIP_PITCH

        lda ZP_SHIP_TYPE
        bpl _3556

        eor ZP_VAR_XX15_0
        eor ZP_VAR_XX15_1
        asl 
        lda # $02
        ror 
        sta ZP_SHIP_ROLL
        lda ZP_VAR_XX15_0
        asl 
        cmp # $0c
        bcs _350a
        lda ZP_VAR_XX15_1
        asl 
        lda # $02
        ror 
        sta ZP_SHIP_PITCH
        lda ZP_VAR_XX15_1
        asl 
        cmp # $0c
        bcs _350a
_3556:                                                                  ;$3556
        stx ZP_SHIP_ROLL
        lda ZP_SHIP_M2x0_HI
        sta ZP_VAR_XX15_0
        lda ZP_SHIP_M2x1_HI
        sta ZP_VAR_XX15_1
        lda ZP_SHIP_M2x2_HI
        sta ZP_VAR_XX15_2
        ldy # $10
        jsr _35b3
        asl 
        cmp # $42
        bcs _3524
        jsr _350a
_3571:                                                                  ;$3571
        lda ZP_3F               ; only use, ever. does not get set!
        bne _357a

        asl ZP_SHIP_BEHAVIOUR
        sec 
        ror ZP_SHIP_BEHAVIOUR
_357a:                                                                  ;$357A
        rts 


_357b:                                                                  ;$357B
;===============================================================================
        lda #< ship_01                                                  ;=$F925
        sta ZP_TEMP_ADDR2_LO
        lda #> ship_01                                                  ;=$F925
_3581:  sta ZP_TEMP_ADDR2_HI                                            ;$3581

        ldy # $02
        jsr _358f

        ldy # $05
        jsr _358f

        ldy # $08
_358f:                                                                  ;$358F
        lda [ZP_TEMP_ADDR2], y
        eor # %10000000
        sta ZP_VALUE_pt4

        dey 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VALUE_pt3

        dey 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VALUE_pt2

        sty U
        ldx U
        jsr _2d69

        ldy U
        sta ZP_SHIP01_XPOS_pt3, x
        lda ZP_VALUE_pt3
        sta ZP_SHIP01_XPOS_pt2, x
        lda ZP_VALUE_pt2
        sta ZP_SHIP01_XPOS_pt1, x
        rts 


_35b3:                                                                  ;$35B3
;===============================================================================
        ldx ship_01 + Ship::xpos + 0, y                                 ;=$F925
        stx Q
        lda ZP_VAR_XX15_0
        jsr multiply_signed_into_RS
        ldx ship_01 + Ship::xpos + 2, y                                 ;=$F927
        stx Q
        lda ZP_VAR_XX15_1
        jsr multiply_and_add
        sta S
        stx R
        ldx ship_01 + Ship::ypos + 1, y                                 ;=$F929
        stx Q
        lda ZP_VAR_XX15_2
        jmp multiply_and_add


_35d5:                                                                  ;$35D5
;===============================================================================
        lda ZP_VAR_XX15_0
        eor # %10000000
        sta ZP_VAR_XX15_0
        lda ZP_VAR_XX15_1
        eor # %10000000
        sta ZP_VAR_XX15_1
        lda ZP_VAR_XX15_2
        eor # %10000000
        sta ZP_VAR_XX15_2
        rts 


_35e8:                                                                  ;$35E8
;===============================================================================
        jsr _35eb
_35eb:                                                                  ;$35EB
        lda ship_01 + Ship::m0x0 + 1                                    ;=$F92F
        ldx # $00
        jsr _3600
        lda ship_01 + Ship::m0x1 + 1                                    ;=$F931
        ldx # $03
        jsr _3600
        lda ship_01 + Ship::m0x2 + 1                                    ;=$F933
        ldx # $06
_3600:                                                                  ;$3600
        asl 
        sta R
        lda # $00
        ror 
        eor # %10000000
        eor ZP_SHIP01_XPOS_pt3, x
        bmi _3617
        lda R
        adc ZP_SHIP01_XPOS_pt1, x
        sta ZP_SHIP01_XPOS_pt1, x
        bcc _3616
        inc ZP_SHIP01_XPOS_pt2, x
_3616:                                                                  ;$3616
        rts 

        ;-----------------------------------------------------------------------

_3617:                                                                  ;$3617
        lda ZP_SHIP01_XPOS_pt1, x
        sec 
        sbc R
        sta ZP_SHIP01_XPOS_pt1, x
        lda ZP_SHIP01_XPOS_pt2, x
        sbc # $00
        sta ZP_SHIP01_XPOS_pt2, x
        bcs _3616
        lda ZP_SHIP01_XPOS_pt1, x
        eor # %11111111
        adc # $01
        sta ZP_SHIP01_XPOS_pt1, x
        lda ZP_SHIP01_XPOS_pt2, x
        eor # %11111111
        adc # $00
        sta ZP_SHIP01_XPOS_pt2, x
        lda ZP_SHIP01_XPOS_pt3, x
        eor # %10000000
        sta ZP_SHIP01_XPOS_pt3, x
        jmp _3616


_HITCH:                                                 ; BBC: HITCH    ;$363F
;===============================================================================
; is the current ship within the player's sights?
;-------------------------------------------------------------------------------
        clc 
        lda ZP_SHIP_ZPOS_SIGN
        bne _367d

        lda ZP_SHIP_TYPE
        bmi _367d

        lda ZP_SHIP_STATE
        and # state::debris
        ora ZP_SHIP_XPOS_HI
        ora ZP_SHIP_YPOS_HI
        bne _367d

        lda ZP_SHIP_XPOS_LO
        jsr math_square
        sta S

        lda ZP_VAR_P1
        sta R
        
        lda ZP_SHIP_YPOS_LO
        jsr math_square

        tax 
        lda ZP_VAR_P1
        adc R
        sta R
        txa 
        adc S
        bcs _367e
        sta S
        ldy # Hull::target_area+1   ;=$02: "missile lock area" hi-byte?
        lda [ZP_HULL_ADDR], y
        cmp S
        bne _367d
        dey                     ;=$01: "missile lock area" lo-byte?
        lda [ZP_HULL_ADDR], y
        cmp R
_367d:                                                                  ;$367D
        rts 

        ;-----------------------------------------------------------------------

_367e:                                                                  ;$367E
        clc 
        rts 


_3680:                                                                  ;$3680
;===============================================================================
; in:   X                       ship-type to spawn
;-------------------------------------------------------------------------------
        jsr clear_zp_ship

        lda # $1c
        sta ZP_SHIP_YPOS_LO
        lsr 
        sta ZP_SHIP_ZPOS_LO
        lda # $80
        sta ZP_SHIP_YPOS_SIGN

        lda ZP_MISSILE_TARGET
        asl 
        ora # attack::active
        sta ZP_SHIP_ATTACK

_3695:                                                                  ;$3695
;===============================================================================
; in:   X                       ship-type to spawn
;-------------------------------------------------------------------------------
        lda # $60
        sta ZP_SHIP_M0x2_HI
        ora # %10000000
        sta ZP_SHIP_M2x0_HI

        lda ZP_PLAYER_SPEED
        rol 
        sta ZP_SHIP_SPEED

        txa 
        jmp spawn_ship


fire_missile:                                           ; BBC: FRMIS    ;$36A6
;===============================================================================
        ; spawn a missile
        ldx # HULL_MISSILE
        jsr _3680               ; NOTE: spawns ship-type in X
        bcc _3701
        
        ldx ZP_MISSILE_TARGET
        jsr get_ship_addr

        lda SHIP_SLOTS, x
        jsr _ANGRY

        ldy # .color_nybble( DKGREY, HUD_COLOUR )
        jsr untarget_missile
        
        dec PLAYER_MISSILES
        
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $04
        jmp play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////


_ANGRY:                                                 ; BBC: ANGRY    ;$36C5
;===============================================================================
;-------------------------------------------------------------------------------
        ; firing at space station?
        ; (not a good idea)
        cmp # HULL_STATION
        ; make the space-station hostile?
        beq _36f8

        ldy # Ship::behaviour
        lda [ZP_SHIP_ADDR], y
        and # behaviour::protected
        beq _36d4

        jsr _36f8
_36d4:                                                                  ;$36D4
        ldy # Ship::attack
        lda [ZP_SHIP_ADDR], y
        beq _367d

        ora # %10000000
        sta [ZP_SHIP_ADDR], y
        
        ldy # $1c
        lda # $02
        sta [ZP_SHIP_ADDR], y
        asl 
        ldy # $1e
        sta [ZP_SHIP_ADDR], y

        lda ZP_SHIP_TYPE
        cmp # $0b
        bcc _36f7

        ldy # Ship::behaviour
        lda [ZP_SHIP_ADDR], y
        ora # behaviour::angry
        sta [ZP_SHIP_ADDR], y
_36f7:                                                                  ;$36F7
        rts 

        ;-----------------------------------------------------------------------

_36f8:                                                                  ;$36F8
        ; make hostile?
        lda ship_01 + Ship::behaviour                                   ;=$F949
        ora # behaviour::angry
        sta ship_01 + Ship::behaviour                                   ;=$F949
        rts 

_3701:                                                                  ;$3701
.import TKN_FLIGHT_MISSILE_JAMMED:direct
        lda # TKN_FLIGHT_MISSILE_JAMMED
        jmp _MESS               ; print an on-screen message


_3706:                                                                  ;$3706
;===============================================================================
        ; TODO: this is probably the ID for an escape-pod,
        ;       given the logic below
        ldx # HULL_ESCAPE
_3708:                                                                  ;$3708
        lda # $fe
_370a:                                                                  ;$370A
        ; preserve A & X?
        sta ZP_TEMP_VAR
       .phx                     ; push X to stack (via A)

        lda ZP_HULL_ADDR_LO
        pha 
        lda ZP_HULL_ADDR_HI
        pha 
        lda ZP_SHIP_ADDR_LO
        pha 
        lda ZP_SHIP_ADDR_HI
        pha 

        ; temporarily backup the current ship struct to the bottom
        ; of the stack, and copy in the new ship struct in
        ldy # .sizeof( Ship )-1
:       lda ZP_SHIP, y                                                  ;$371C
        sta $0100, y
        lda [ZP_SHIP_ADDR], y
        sta ZP_SHIP, y
        dey 
        bpl :-

        lda ZP_SHIP_TYPE
        cmp # $02
        bne _374d

       .phx                     ; push X to stack (via A)
        lda # $20
        sta ZP_SHIP_SPEED
        ldx # $00
        lda ZP_SHIP_M0x0_HI
        jsr _378c
        ldx # $03
        lda ZP_SHIP_M0x1_HI
        jsr _378c
        ldx # $06
        lda ZP_SHIP_M0x2_HI
        jsr _378c
       .plx                     ; pull X from stack (via A)

_374d:                                                                  ;$374D
        lda ZP_TEMP_VAR
        sta ZP_SHIP_ATTACK
        lsr ZP_SHIP_ROLL
        asl ZP_SHIP_ROLL

        txa 
        cmp # HULL_SHUTTLE
       .bge @spawn
       ; missile, station or escape pod?
       ; WARN: this assumes that these are the first three IDs
        cmp # HULL_ESCAPE + 1
       .blt @spawn
        
        pha 
        jsr get_random_number
        asl 
        sta ZP_SHIP_PITCH

        txa 
        and # %00001111
        sta ZP_SHIP_SPEED
        lda # $ff
        ror 
        sta ZP_SHIP_ROLL
        
        pla 
@spawn: jsr spawn_ship                                                  ;$3770
        
        pla 
        sta ZP_SHIP_ADDR_HI
        pla 
        sta ZP_SHIP_ADDR_LO
        ldx # $24
_377b:                                                                  ;$377B
        lda $0100, x
        sta ZP_SHIP_XPOS_LO, x
        dex 
        bpl _377b
        pla 
        sta ZP_HULL_ADDR_HI
        pla 
        sta ZP_HULL_ADDR_LO
        pla 
        tax 
        rts 


_378c:                                                                  ;$378C
;===============================================================================
        asl 
        sta R
        lda # $00
        ror 
        jmp move_ship_x

_3795:                                                                  ;$3795
        jsr _a839
        lda # $04
        jsr _37a5
        
        rts 


_379e:                                                                  ;$397E
;===============================================================================
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $04
        jsr play_sfx
.endif  ;///////////////////////////////////////////////////////////////////////
        
        lda # $08
_37a5:  sta ZP_CIRCLE_STEP                                              ;$37A5

        ; TODO: why does this change the screen,
        ;       but keep the ZP_SCREEN value?
        ;
        lda ZP_SCREEN           ; backup current screen number
        pha                     ; (i.e. cockpit / menu-page)
        
        lda # page::cockpit     ; switch to cockpit-view
        jsr set_page            ; update the screen
        
        pla                     ; restore screen number
        sta ZP_SCREEN           ; (i.e. cockpit / menu-page)

_37b2:                                                                  ;$37B2
        ldx # $80
        stx ZP_CIRCLE_XPOS_LO

        ldx # $48               ; half viewport height?
        stx ZP_CIRCLE_YPOS_LO   ; circle Y-position, lo-byte
        
        ldx # $00
        stx ZP_VAR_XX4
        stx ZP_CIRCLE_XPOS_HI
        stx ZP_CIRCLE_YPOS_HI
_37c2:                                                                  ;$37C2
        jsr _37ce
        inc ZP_VAR_XX4
        ldx ZP_VAR_XX4
        cpx # $08
        bne _37c2
        rts 


_37ce:                                                                  ;$37CE
;===============================================================================
        lda ZP_VAR_XX4
        and # %00000111
        clc 
        adc # $08
        sta ZP_VALUE_pt1        ; radius?
_37d7:                                                                  ;$37D7
        lda # $01
        sta ZP_CIRCLE_INDEX
        jsr draw_circle
        asl ZP_VALUE_pt1        ; radius?
        bcs _37e8
        lda ZP_VALUE_pt1        ; radius?
        cmp # $a0
        bcc _37d7
_37e8:                                                                  ;$37E8
        rts 


_37e9:                                                                  ;$37E9
;===============================================================================
; move dust left / right?
;-------------------------------------------------------------------------------
        lda # $00
        cpx # $02
        ror 
        sta ZP_B0
        eor # %10000000
        sta ZP_B1
        jsr _38a3
        
        ldy DUST_COUNT          ; number of dust particles
_37fa:                                                                  ;$37FA
        lda DUST_Z_HI, y
        sta ZP_VAR_Z
        lsr 
        lsr 
        lsr 
        jsr divide_by_player_speed

        lda ZP_VAR_P1
        sta ZP_BA
        eor ZP_B1
        sta S
        
        lda DUST_X_LO, y
        sta ZP_VAR_P1
        
        lda DUST_X_HI, y
        sta ZP_VAR_XX15_0
        jsr multiplied_now_add
        sta S
        stx R
        
        lda DUST_Y_HI, y
        sta ZP_VAR_XX15_1
        eor ZP_PITCH_SIGN
        ldx ZP_PITCH_MAGNITUDE
        jsr _393e
        jsr multiplied_now_add
        stx ZP_VAR_XX_LO
        sta ZP_VAR_XX_HI
        
        ldx DUST_Y_LO, y
        stx R
        
        ldx ZP_VAR_XX15_1
        stx S
        
        ldx ZP_PITCH_MAGNITUDE
        eor ZP_INV_PITCH_SIGN
        jsr _393e
        jsr multiplied_now_add
        stx ZP_VAR_YY_LO
        sta ZP_VAR_YY_HI
        
        ldx ZP_ROLL_MAGNITUDE
        eor ZP_ROLL_SIGN
        jsr _393e
        sta Q
        lda ZP_VAR_XX_LO
        sta R
        lda ZP_VAR_XX_HI
        sta S
        eor # %10000000
        jsr multiply_and_add
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y
        lda ZP_VAR_YY_LO
        sta R
        lda ZP_VAR_YY_HI
        sta S
        jsr multiply_and_add
        sta S
        stx R
        lda # $00
        sta ZP_VAR_P1
        lda ZP_ALPHA
        jsr _290f
        lda ZP_VAR_XX_HI
        sta DUST_X_HI, y
        sta ZP_VAR_XX15_0
        and # %01111111
        eor # %01111111
        cmp ZP_BA
        bcc _38be
        beq _38be
        lda ZP_VAR_YY_HI
        sta DUST_Y_HI, y
        sta ZP_VAR_XX15_1
        and # %01111111
_3895:                                                                  ;$3895
        cmp # $74
        bcs _38d1
_389a:                                                                  ;$389A
        jsr draw_particle
        dey 
        beq _38a3
        jmp _37fa

        ;-----------------------------------------------------------------------

_38a3:                                                                  ;$38A3
        lda ZP_ALPHA
        eor ZP_B0
        sta ZP_ALPHA
        lda ZP_ROLL_SIGN        ; roll sign?
        eor ZP_B0
        sta ZP_ROLL_SIGN        ; roll sign?
        eor # %10000000
        sta ZP_INV_ROLL_SIGN
        lda ZP_PITCH_SIGN
        eor ZP_B0
        sta ZP_PITCH_SIGN
        eor # %10000000
        sta ZP_INV_PITCH_SIGN
        rts 

        ;-----------------------------------------------------------------------

_38be:                                                                  ;$38BE
        jsr get_random_number
        sta ZP_VAR_XX15_1
        sta DUST_Y_HI, y
        lda # $73
        ora ZP_B0
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y
        bne _38e2
_38d1:                                                                  ;$38D1
        jsr get_random_number
        sta ZP_VAR_XX15_0
        sta DUST_X_HI, y
        lda # $6e
        ora ZP_INV_ROLL_SIGN
        sta ZP_VAR_XX15_1
        sta DUST_Y_HI, y
_38e2:                                                                  ;$38E2
        jsr get_random_number
        ora # %00001000
        sta ZP_VAR_Z
        sta DUST_Z_HI, y
        bne _389a
_38ee:                                                                  ;$38EE
        sta ZP_VALUE_pt1
        sta ZP_VALUE_pt2
        sta ZP_VALUE_pt3
        sta ZP_VALUE_pt4
        clc 
        rts 

        ;-----------------------------------------------------------------------

_38f8:                                                                  ;$38F8
        sta R
        and # %01111111
        sta ZP_VALUE_pt3
        lda Q
        and # %01111111
        beq _38ee
        sec 
        sbc # $01
        sta T
        lda ZP_VAR_P2
        lsr ZP_VALUE_pt3
        ror 
        sta ZP_VALUE_pt2
        lda ZP_VAR_P1
        ror 
        sta ZP_VALUE_pt1
        lda # $00
        ldx # $18
_3919:                                                                  ;$3919
        bcc _391d
        adc T
_391d:                                                                  ;$391D
        ror 
        ror ZP_VALUE_pt3
        ror ZP_VALUE_pt2
        ror ZP_VALUE_pt1
        dex 
        bne _3919
        sta T
        lda R
        eor Q
        and # %10000000
        ora T
        sta ZP_VALUE_pt4
        rts 


_3934:                                                                  ;$3934
;===============================================================================
        ; copy XX to R.S
        ldx ZP_VAR_XX_LO
        stx R
        ldx ZP_VAR_XX_HI
        stx S

_393c:                                                                  ;$393C
;===============================================================================
; TODO: is this is a multiply routine?
;
; in:   A                       ?
;-------------------------------------------------------------------------------
        ldx ZP_ROLL_MAGNITUDE

_393e:                                                                  ;$393E
;===============================================================================
; TODO: is this is a multiply routine?
;
; in:   A                       ?
;       X                       ?
;-------------------------------------------------------------------------------
        stx ZP_VAR_P
        tax 
        and # %10000000         ; extract the sign-bit
        sta T                   ; put aside (to add back later)

        txa 
        and # %01111111         ; extract the magnitude
        beq @zero               ; are we multiplying by zero? (=0)

        tax                     ; multiplicand
        dex                     ; subtract 1 (carry will compensate for this)
        stx ZP_TEMP_VAR         ; store this as our starting multiplicand
        
        lda # $00
        lsr ZP_VAR_P
        bcc :+
        adc ZP_TEMP_VAR

:       ror                                                             ;$3956 
        ror ZP_VAR_P
        bcc :+
        adc ZP_TEMP_VAR

:       ror                                                             ;$395D
        ror ZP_VAR_P
        bcc :+
        adc ZP_TEMP_VAR

:       ror                                                             ;$3964
        ror ZP_VAR_P
        bcc :+
        adc ZP_TEMP_VAR

:       ror                                                             ;$396B
        ror ZP_VAR_P
        bcc :+
        adc ZP_TEMP_VAR

:       ror                                                             ;$3972
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        ora T                   ; restore the sign
        
        rts 

        ; if multiplying by zero, return zero!
        ;-----------------------------------------------------------------------
@zero:  sta ZP_VAR_P2           ;?                                      ;$3981
        sta ZP_VAR_P1
        rts 

; NOTE: in the original code, "math_square.asm" will be inserted
;       here between these two segments
;
.segment        "CODE_39E0"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

multiply_by_sin:                                        ; BBC: FMLTU2   ;$39E0
;===============================================================================
; K * abs(sin(A))
;-------------------------------------------------------------------------------
        and # %00011111
        tax                     ; X = A%31, with 0..31 equiv. 0..pi
        lda table_sin, x
        sta Q                   ; Q = abs(sin(A))*256
        lda ZP_CIRCLE_RADIUS

_39ea:                                                                  ;$39EA
        ; calculate A=(A*Q)/256 via log-tables
        ;
        stx ZP_VAR_P            ; preserve X
        sta ZP_B6
        tax 
        beq _3a1d
        lda table_loglo, x
        ldx Q
        beq _3a20
        clc 
        adc table_loglo, x
        bmi _3a0f
        lda table_log, x
        ldx ZP_B6
        adc table_log, x
        bcc _3a20               ; no overflow: A*Q < 256
        tax 
        lda table_antilog, x
        ldx ZP_VAR_P            ; restore X
        rts 

        ;-----------------------------------------------------------------------

_3a0f:                                                                  ;$3A0F
        lda table_log, x
        ldx ZP_B6
        adc table_log, x
        bcc _3a20               ; no overflow: A*Q < 256
        tax 
        lda table_antilog_odd, x; A = X*ZP_B6
_3a1d:                                                                  ;$3A1D
        ldx ZP_VAR_P            ; restore X
        rts 

        ;-----------------------------------------------------------------------

_3a20:                                                                  ;$3A20
        lda # $00               ; A=0 when either A or Q was 0 or A*Q < 256
        ldx ZP_VAR_P            ; restore X
        rts 


_3a25:                                                                  ;$3A25
;===============================================================================
        stx Q
_3a27:                                                                  ;$3A27
        eor # %11111111
        lsr 
        sta ZP_VAR_P2
        lda # $00
        ldx # $10
        ror ZP_VAR_P1
_3a32:                                                                  ;$3A32
        bcs _3a3f
        adc Q
        ror 
        ror ZP_VAR_P2
        ror ZP_VAR_P1
        dex 
        bne _3a32
        rts 

_3a3f:                                                                  ;$3A3F
        ;-----------------------------------------------------------------------
        lsr 
        ror ZP_VAR_P2
        ror ZP_VAR_P1
        dex 
        bne _3a32
        rts 


; NOTE: in the original, segment "CODE_3A48" appears here               ;$34A8
; NOTE: in the original, segment "CODE_3AB2" appears here               ;$3AB2 
; NOTE: in the original, segment "CODE_3B30" appears here               ;$3B30


.segment        "CODE_3BC1"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_3bc1:                                                                  ;$3BC1
;===============================================================================
        sta ZP_VAR_P3
        lda ZP_SHIP_ZPOS_LO
        ora # %00000001
        sta Q
        lda ZP_SHIP_ZPOS_HI
        sta R
        lda ZP_SHIP_ZPOS_SIGN
        sta S
        lda ZP_VAR_P1
        ora # %00000001
        sta ZP_VAR_P1
        lda ZP_VAR_P3
        eor S
        and # %10000000
        sta T
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
        lda S
        and # %01111111
_3bf7:                                                                  ;$3BF7
        dey 
        asl Q
        rol R
        rol 
        bpl _3bf7
        sta Q
        lda # $fe
        sta R
        lda ZP_VAR_P3
_3c07:                                                                  ;$3C07
        asl 
        bcs _3c17
        cmp Q
        bcc _3c10
        sbc Q
_3c10:                                                                  ;$3C10
        rol R
        bcs _3c07
        jmp _3c20

_3c17:                                                                  ;$3C17
        sbc Q
        sec 
        rol R
        bcs _3c07
        lda R
_3c20:                                                                  ;$3C20
        lda # $00
        sta ZP_VALUE_pt2
        sta ZP_VALUE_pt3
        sta ZP_VALUE_pt4
        tya 
        bpl _3c49
        lda R
_3c2d:                                                                  ;$3C2D
        asl 
        rol ZP_VALUE_pt2
        rol ZP_VALUE_pt3
        rol ZP_VALUE_pt4
        iny 
        bne _3c2d
        sta ZP_VALUE_pt1
        lda ZP_VALUE_pt4
        ora T
        sta ZP_VALUE_pt4
        rts 


_3c40:                                                                  ;$3C40
;===============================================================================
        lda R
        sta ZP_VALUE_pt1
        lda T
        sta ZP_VALUE_pt4
        rts 

        ;-----------------------------------------------------------------------

_3c49:                                                                  ;$3C49
        beq _3c40
        lda R
_3c4d:                                                                  ;$3C4D
        lsr 
        dey 
        bne _3c4d
        sta ZP_VALUE_pt1
        lda T
        sta ZP_VALUE_pt4
        rts 


dampen_toward_zero:                                     ; BBC: cntr     ;$3C58
;===============================================================================
; reduce a signed value toward zero by adding/subtracting 1 according to sign:
; this is used to dampen the roll/pitch values 
;
; in:   X                       value to dampen
; out:  X                       updated X value
;-------------------------------------------------------------------------------
        lda DOCKCOM_STATE       ; is docking computer enabled?
       .bnz :+                  ; yes, skip over the following

        lda _1d06               ; check dampening toggle
        bne @rts                ; dampening off? exit

        ;-----------------------------------------------------------------------
:       txa                     ; test bits                             ;$3C62 
        bpl :+                  ; positive?

        dex                     ; decrease negative number towards zero
        bmi @rts                ; if still negative, finish

:       inx                     ; increase counter                      ;$3C68 
       .bnz @rts                ; if still positive, finish
        
        dex                     
       .bze :-                  ; if zero, make 1?

@rts:   rts                                                             ;$3C68 


_3c6f:                                                                  ;$3C6F
;===============================================================================
        sta T
        txa 
        clc 
        adc T
        tax 
        bcc _3c7a
        ldx # $ff
_3c7a:                                                                  ;$3C7A
        bpl _3c8c
_3c7c:                                                                  ;$3C7C
        lda T
        rts 

        ;-----------------------------------------------------------------------

_3c7f:                                                                  ;$3C7F
        sta T
        txa 
        sec 
        sbc T
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
        lda ZP_VAR_P1
        eor Q
        sta ZP_TEMP_VAR
        lda Q
        beq _3cc4
        asl 
        sta Q
        lda ZP_VAR_P1
        asl 
        cmp Q
        bcs _3cb2
        jsr _3cce
        sec 
_3cad:                                                                  ;$3CAD
        ldx ZP_TEMP_VAR
        bmi _3cc7
        rts 

        ;-----------------------------------------------------------------------

_3cb2:                                                                  ;$3CB2
        ldx Q
        sta Q
        stx ZP_VAR_P1
        txa 
        jsr _3cce
        sta T
        lda # $40
        sbc T
        bcs _3cad
_3cc4:                                                                  ;$3CC4
        lda # $3f
        rts 

        ;-----------------------------------------------------------------------

_3cc7:                                                                  ;$3CC7
        sta T
        lda # $80
        sbc T
        rts 

        ;-----------------------------------------------------------------------

_3cce:                                                                  ;$3CCE
        jsr math_divide_AQ
        lda R
        lsr 
        lsr 
        lsr 
        tax 

        lda _0ae0, x
_3cda:                                                                  ;$3CDA
        rts 


shoot_lasers:                                                           ;$3CDB
;===============================================================================
; pew! pew!
;
;-------------------------------------------------------------------------------
        ; jitter the laser beam's position a bit:
        ; pick the starting Y-position (Y1)
        ;
        jsr get_random_number
        and # %00000111                 ; clip to 0-7
        adc # $44                       ; offset by 68px
        sta VAR_06F1

        ; pick the starting X-position (X1)
        ;
        jsr get_random_number
        and # %00000111                 ; clip to 0-7
        adc # $7C                       ; offset by 124 (256-8 / 2?)
        sta VAR_06F0

        ; increase laser temperature!
        ;
        lda LASER_HEAT
        adc # $08
        sta LASER_HEAT
        jsr _7b64                       ; handle laser temperature limits?

_3cfa:                                                                  ;$3CFA
        ;=======================================================================
        lda ZP_SCREEN                   ; are we in the cockpit-view?
       .bnz _3cda                       ; no, exit (`rts` above us)

        lda # 32                        ; X2
        ldy # 224
        jsr @_3d09

        lda # 48                        ; X2
        ldy # 208

@_3d09:                                                                 ;$3D09
        ;-----------------------------------------------------------------------
        ; the horizontal end of the line, which will
        ; be somewhere along the bottom of the viewport
        sta ZP_VAR_XX15_2

        ; set the start point of the line, in the middle
        ; of the screen (slightly randomised, by above)
        lda VAR_06F0
        sta ZP_VAR_XX15_0
        lda VAR_06F1
        sta ZP_VAR_XX15_1
        
        ; the bottom of the line is always at
        ; the bottom of the viewport
        lda # VIEWPORT_HEIGHT - 1
        sta ZP_VAR_XX15_3

        ; TODO: skip validation and jump straight to
        ;       the vertical up/down line routine?
        jsr draw_line

        lda VAR_06F0
        sta ZP_VAR_XX15_0
        lda VAR_06F1
        sta ZP_VAR_XX15_1
        sty ZP_VAR_XX15_2
        lda # VIEWPORT_HEIGHT - 1
        sta ZP_VAR_XX15_3

        ; TODO: skip validation and jump straight to
        ;       the vertical up/down line routine?
        jmp draw_line


_3d2f:                                                                  ;$3D2F
;===============================================================================
; from "text/text_docked.asm"
.import _1a27
.import _1a41

        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz _3d6f

        lda ZP_IS_DOCKED
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

        jsr text_buffer_on

        lda # $01
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

:       lda # $b0                                                       ;$3D5F
        jsr print_docked_token

        tya 
        jsr _237e

        ; print ".", newline, buffer-off
.import MSG_DOCKED_B1:direct
        lda # MSG_DOCKED_B1
        bne _3d7a
_3d6c:                                                                  ;$3D6C
        dey 
        bne _3d3d
_3d6f:                                                                  ;$3D6F
        ; copy the last four bytes of the main seed to the "goat soup"
        ; seed, used for generating the planet descriptions
        ldx # $03
:       lda ZP_SEED_W1_LO, x                                            ;$3D71
        sta ZP_GOATSOUP, x
        dex 
        bpl :-

.import MSG_DOCKED_05:direct
        lda # MSG_DOCKED_05
_3d7a:  jmp print_docked_str                                            ;$3D7A


mission_blueprints_begin:                                               ;$3D7D
;===============================================================================
; begin the Thargoid Blueprints mission:
;-------------------------------------------------------------------------------
        lda MISSION_FLAGS
        ora # missions::blueprints_begin
        sta MISSION_FLAGS

        ; display "go to Ceerdi" mission text
.import MSG_DOCKED_0B:direct
        lda # MSG_DOCKED_0B

_3d87:                                                                  ;$3D87
        jsr print_docked_str
_3d8a:                                                                  ;$3D8A
        jmp _BAY


mission_blueprints_ceerdi:                                              ;$3D8D
;===============================================================================
        lda MISSION_FLAGS
        and # %11110000
        ora # %00001010
        sta MISSION_FLAGS

        ; print mission text
.import MSG_DOCKED_DE:direct
        lda # MSG_DOCKED_DE
        bne _3d87               ; (always branches)

mission_blueprints_birera:                                              ;$3D9B
;===============================================================================
        lda MISSION_FLAGS
        ora # %00000100
        sta MISSION_FLAGS

        ; give the player the military energy unit?
        lda # 2
        sta PLAYER_EUNIT

        inc PLAYER_KILLS_HI

        ; print mission text
.import MSG_DOCKED_DF:direct
        lda # MSG_DOCKED_DF
        bne _3d87               ; (always branches)

_3daf:                                                                  ;$3DAF
;===============================================================================
        lsr MISSION_FLAGS
        asl MISSION_FLAGS

        ldx # < 50000
        ldy # > 50000
        jsr give_cash           ; pay monies

.import MSG_DOCKED_CONGRATULATIONS:direct
        lda # MSG_DOCKED_CONGRATULATIONS
_3dbe:                                                                  ;$3DBE
        bne _3d87               ; (always branches)

.ifdef  FEATURE_TRUMBLES
;///////////////////////////////////////////////////////////////////////////////

mission_trumbles:                                                       ;$3DC0
;===============================================================================
; begin Trumbles™ mission
;-------------------------------------------------------------------------------
        ;set the mission bit:
        lda MISSION_FLAGS
        ora # missions::trumbles
        sta MISSION_FLAGS

        ; display the Trumbles™ mission text
.import MSG_DOCKED_MISSION_TRUMBLES:direct
        lda # MSG_DOCKED_MISSION_TRUMBLES
        jsr print_docked_str

        jsr _GETYN
        bcc _3d8a

        ldy # $c3
        ldx # $50
        jsr _745a

        ;put a Trumble™ in the hold...
        inc PLAYER_TRUMBLES_LO

        ; start the normal docked screen?
        jmp _BAY

;///////////////////////////////////////////////////////////////////////////////
.endif

_3dff:                                                                  ;$3DFF
;===============================================================================
        ; and this is how you set bit 0,
        ; without using registers!
        ;
        lsr MISSION_FLAGS       ; push bit 0 into the bit-bucket
        sec                     ; put a 1 into the carry
        rol MISSION_FLAGS       ; push the carry into bit 0

        jsr tkn_docked_incoming_message
        jsr clear_zp_ship
        
        ; spawn the constrictor!
        lda # HULL_CONSTRICTOR
        sta ZP_SHIP_TYPE
        jsr spawn_ship

.if     page::empty <> 1
        .fatal  "optimisation requires that `page::empty` is 1 in `_3dff`"
.endif
        lda # 1                 ;=page::empty
       .set_cursor_col
        sta ZP_SHIP_ZPOS_HI
        jsr set_page            ; switch to an empty menu page

        lda # $40
        sta MAIN_COUNTER
_3e01:                                                                  ;$3E01
        ldx # $7f
        stx ZP_SHIP_ROLL
        stx ZP_SHIP_PITCH
        jsr draw_ship
        jsr move_ship
        dec MAIN_COUNTER
        bne _3e01
_3e11:                                                                  ;$3E11
        lsr ZP_SHIP_XPOS_LO
        inc ZP_SHIP_ZPOS_LO
        beq _3e31

        inc ZP_SHIP_ZPOS_LO
        beq _3e31

        ldx ZP_SHIP_YPOS_LO
        inx 
        cpx # $50
        bcc _3e24

        ldx # $50
_3e24:                                                                  ;$3E24
        stx ZP_SHIP_YPOS_LO
        jsr draw_ship
        jsr move_ship
        dec MAIN_COUNTER
        jmp _3e11
_3e31:                                                                  ;$3E31
        inc ZP_SHIP_ZPOS_HI

        ; print mission text
.import MSG_DOCKED_0A:direct
        lda # MSG_DOCKED_0A
        bne _3dbe               ; always branches

;===============================================================================
; insert the docked-token functions from "text_docked_fns.asm"
;
; NOTE: in the original code, segment "CODE_3E37" apperas here          ;$3E37
; NOTE: in the original code, segment "CODE_3E41" appears here          ;$3E41


.segment        "CODE_3E65"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_3e65:                                                                  ;$3E65
;===============================================================================
        lda # $50
        sta ZP_SHIP_YPOS_LO

        lda # $00
        sta ZP_SHIP_XPOS_LO
        sta ZP_SHIP_ZPOS_LO

        lda # $02
        sta ZP_SHIP_ZPOS_HI

        jsr draw_ship
        jsr move_ship

        jmp get_input


;===============================================================================
; insert this docked-token function from "text_docked_fns.asm"
;
; NOTE: in the original code, segment "CODE_3E7C" appears here          ;$3E7C


.segment        "CODE_3E87"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

get_ship_addr:                                          ; BBC: GINF     ;$3E87
;===============================================================================
; a total of 11 3D-objects ("ships") can be 'in-play' at a time, each object
; has a block of runtime storage to keep track of its current state including
; rotation, speed, shield etc.
;
; given an index for a ship 0-10, this routine will
; return an address for the ship's variable storage
;
; in:   X                       index
;
; out:  ZP_SHIP_ADDR            address
;       X                       (preserved)
;       A, Y                    (clobbered)
;-------------------------------------------------------------------------------
        txa                     ; take ship index,
        asl                     ; multiply by 2 (for 2-byte table-lookup)
        tay                     ; move to Y for indexing...

        lda ship_addrs_lo, y
        sta ZP_SHIP_ADDR_LO
        lda ship_addrs_hi, y
        sta ZP_SHIP_ADDR_HI

        rts 


set_tsystem_to_psystem:                                 ; BBC: ping     ;$3E95
;===============================================================================
; copy target system co-ordinates to present system co-ordinates:
;-------------------------------------------------------------------------------
        ldx # 1
:       lda PSYSTEM_POS, x                                              ;$3E97
        sta TSYSTEM_POS, x
        dex 
        bpl :-

        rts 


wait_frames:                                                            ;$3EA1
;===============================================================================
; wait for a given number of frames to complete:
;
; in:   Y       number of frames to wait
;
;-------------------------------------------------------------------------------
        jsr wait_for_frame
        dey 
        bne wait_frames
        rts 


_3ea8:                                                                  ;$3EA8
;===============================================================================
; colour of different type of laser cross-hairs?
;-------------------------------------------------------------------------------
        .byte   YELLOW, YELLOW, LTGREEN, PURPLE

                                                                        ;$3EAC