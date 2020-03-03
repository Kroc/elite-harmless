; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; NOTE: the segment that this code belongs to will be set by the including
;       file, e.g. "elite-original.asm" / "elite-harmless.asm"

polyobj_addrs:                                                          ;$28A4
;===============================================================================
; a total of 11 3D-objects ("poly-objects") can be 'in-play' at a time,
; each object has a block of runtime storage to keep track of its current
; state including rotation, speed, shield etc. this is a lookup-table of
; addresses for each poly-object slot
;
polyobj_addrs_lo := polyobj_addrs
polyobj_addrs_hi := polyobj_addrs + 1

        .word   POLYOBJ_00
        .word   POLYOBJ_01
        .word   POLYOBJ_02
        .word   POLYOBJ_03
        .word   POLYOBJ_04
        .word   POLYOBJ_05
        .word   POLYOBJ_06
        .word   POLYOBJ_07
        .word   POLYOBJ_08
        .word   POLYOBJ_09
        .word   POLYOBJ_10
        
;===============================================================================

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
        ; loads A & F with $0F!
        lda # $0f
        tax 
        rts 


print_flight_token_and_divider:                                         ;$28D9
;===============================================================================
; print a flight token and then draw a line across the screen
; i.e. screen titles
;
; in:   A       flight-token, already descrambled
;
;-------------------------------------------------------------------------------
        jsr print_flight_token


txt_docked_token0B:                                                     ;$28DC
;===============================================================================
.export txt_docked_token0B

        lda # $13
        bne _28e5               ; (always branches)

_28e0:                                                                  ;$28E0
;===============================================================================
        lda # 23
        jsr cursor_down

_28e5:                                                                  ;$28E5
;===============================================================================
; called from galactic chart screen;
; draws a line across the screen
;
; in:   A       Y-position of line
;
;-------------------------------------------------------------------------------
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_Y1                   ; set Y-position of line,
        sta ZP_VAR_Y2                   ; both start and end (straight)
.else   ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_Y
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set X to go from 0 to 255
        ldx # $00                       ; begin with zero
        stx ZP_VAR_X1                   ; set line-begin
        dex                             ; roll around to 255
        stx ZP_VAR_X2                   ; set line-end
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jmp draw_line
.else   ;///////////////////////////////////////////////////////////////////////
        ; use the faster straight-line routine,
        ; rather than the generic line routine
        jmp draw_straight_line
.endif  ;///////////////////////////////////////////////////////////////////////


_28f3:                                                                  ;$28F3
;===============================================================================
; for `clip_horz_line`:
;
;      YY = middle-point of line, in viewport px (0-255)
;       A = half-width of line
;
; for `draw_straight_line`: 
;
;       Y = Y-pos of line, in viewport px (0-144)
;
        jsr clip_horz_line

        ; set parameter for drawing line
        sty ZP_VAR_Y
        
        ; remove this line from the scanline cache
        lda # $00
        sta VAR_0580, y
        
        jmp draw_straight_line

;===============================================================================

_2900:                                                                  ;$2900
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
; draw a single dust particle
;
;   ZP_VAR_X = X-distance from middle of screen
;   ZP_VAR_Y = Y-distance from middle of screen
;   ZP_VAR_Z = dust Z-distance;
;
        lda ZP_VAR_X
        bpl :+                  ; handle dust to the right
        
        ; X is negative (left of centre) --
        ; negate the value for the math to follow:
        eor # %01111111         ; flip the sign
        clc                     ; carry must be clear
        adc # $01               ; add 1 to create 2's compliment

        ; flip the sign and put aside for later
:       eor # %10000000                                                 ;$2921
        tax 
        
        ; has the dust particle travelled off
        ; the top/bottom of the screen?
        lda ZP_VAR_Y            ; get particle's Y-distance from centre
        and # %01111111         ; ignore the sign
        ; has the dust particle gone beyond the half-height?
        cmp # ELITE_VIEWPORT_HEIGHT / 2
        ; if yes, don't process
        ; (this is an RTS jump)
       .bge _2976

        ; if the dust Y-distance is positive,
        ; the value doesn't need altering
        lda ZP_VAR_Y
        bpl :+
        
        ; negate the Y
        eor # %01111111
        adc # $01

        ; put aside the positive-only Y value
:       sta ZP_VAR_T                                                    ;$2934

        ; get the viewport half-height again
        lda # (ELITE_VIEWPORT_HEIGHT / 2) + 1
        sbc ZP_VAR_T

        ; fall through to the routine that does
        ; the actual bitmap manipulation

paint_particle:                                                         ;$293A
;===============================================================================
; paint a dust particle to the bitmap screen
;
;        A = Y-position (px)
;        X = X-position (px)
; ZP_VAR_Z = dust Z-distance
;        Y is preserved
;
        sty ZP_TEMP_VAR         ; preserve Y through this ordeal
        tay                     ; get a copy of our Y-coordinate
        
        ; get a bitmap address for a char row:
        
        ; reduce the X-position to a multiple of 8,
        ; i.e. a character column
        txa 
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
        
        ; the Z-check makes effectively the same paint operation for Z>=144
        ; and Z>=80, this seems to be a remnant from a different implementation
        ; we could instead use this to grow dust in more detail  using a
        ; single-pixel bitmask for far far away dust particles
        ;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda ZP_VAR_Z            ; "pixel distance"
        cmp # 144               ; is the dust-particle >= 144 Z-distance?
       .bge :+                  ; yes, is very far away
.endif  ;///////////////////////////////////////////////////////////////////////

        lda _28c8, x            ; get mask for desired pixel-position
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        
        lda ZP_VAR_Z            ; again get the dust Z-distance
        cmp # 80                ; is the dust-particle >= 80 Z-distance?
       .bge @restore
        
        dey                     ; move up a pixel-row 
        bpl :+                  ; didn't go off the top of the char?
        
        ldy # $01               ; use row 1 instead of chnaging chars

:       ; draw pixels for very distant dust:                            ;$296D

        lda _28c8, x            ; get mask for desired pixel-position
        eor [ZP_TEMP_ADDR1], y  ; mask the background
        sta [ZP_TEMP_ADDR1], y  ; merge the pixel with the background

@restore:                                                               ;$2974
        ldy ZP_TEMP_VAR         ; restore Y
_2976:                                                                  ;$2976
        rts 

;===============================================================================
; BBC code: "BLINE"; ball-line for circle
;
_2977:                                                                  ;$2977
        txa 
        adc ZP_43
        sta ZP_8B

        lda ZP_44
        adc ZP_VAR_T
        sta ZP_8C
        
        lda ZP_A9
        beq _2998
        inc ZP_A9
_2988:                                                                  ;$2988
        ldy ZP_7E                       ; current line-buffer cursor
        lda # $ff                       ; line terminator
        cmp line_points_y-1, y          ; check the line-buffer Y-coords
        beq _29fa
        sta line_points_y, y            ; line-buffer Y-coords
        inc ZP_7E
        bne _29fa
_2998:                                                                  ;$2998
        lda ZP_85
        sta ZP_VAR_X1
        lda ZP_86
        sta ZP_VAR_Y1
        lda ZP_87
        sta ZP_VAR_X2
        lda ZP_88
        sta ZP_VAR_Y2
        lda ZP_89
        sta ZP_6F
        lda ZP_8A
        sta ZP_70
        lda ZP_8B
        sta ZP_71
        lda ZP_8C
        sta ZP_72
        jsr _a013
        bcs _2988
        lda VAR_06F4
        beq _29d2
        
        lda ZP_VAR_X1
        ldy ZP_VAR_X2
        sta ZP_VAR_X2
        sty ZP_VAR_X1
        lda ZP_VAR_Y1
        ldy ZP_VAR_Y2
        sta ZP_VAR_Y2
        sty ZP_VAR_Y1
_29d2:                                                                  ;$29D2
        ldy ZP_7E                       ; current line-buffer cursor (1-based)
        lda line_points_y-1, y          ; check current Y-coord
        cmp # $ff                       ; is it the terminator?
        bne _29e6

        ; add X1/Y1 to line-buffer
        ; (Y is the current cursor position)
        lda ZP_VAR_X1
        sta line_points_x, y            ; line-buffer X-coords
        lda ZP_VAR_Y1
        sta line_points_y, y            ; line-buffer Y-coords
        iny                             ; move to the next point in the buffer

_29e6:                                                                  ;$2936
        ; add X2/Y2 to the line-buffer?
        lda ZP_VAR_X2
        sta line_points_x, y            ; line-buffer X-coords
        lda ZP_VAR_Y2
        sta line_points_y, y            ; line-buffer Y-coords
        iny                             ; move to the next point in the buffer
        sty ZP_7E                       ; update line-buffer cursor
        
        ; draw the current line in X1/Y1/X2/Y2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line

        lda ZP_A2
        bne _2988
_29fa:                                                                  ;$29FA
        lda ZP_89
        sta ZP_85
        lda ZP_8A
        sta ZP_86
        lda ZP_8B
        sta ZP_87
        lda ZP_8C
        sta ZP_88
        lda ZP_AA
        clc 
        adc ZP_AC
        sta ZP_AA

        rts 

dust_swap_xy:                                                           ;$2A12
;===============================================================================
        ldy DUST_COUNT          ; get number of dust particles

:       ldx DUST_Y, y           ; get dust-particle Y-position          ;$2A15
        lda DUST_X, y           ; get dust-particle X-position
        sta ZP_VAR_Y            ; (put aside X-position)
        sta DUST_Y, y           ; save the Y-value to the X-position
        txa                     ; move the Y-position into A
        sta ZP_VAR_X            ; (put aside Y-value)
        sta DUST_X, y           ; write the X-value to the Y-position
        lda DUST_Z, y           ; get dust z-position
        sta ZP_VAR_Z            ; (put aside Z-position)
        
        jsr draw_particle

        dey 
        bne :-

        rts 

;===============================================================================
; animate dust particles based on COCKPIT_VIEW
;
_animate_dust:                                                          ;$2A32

        ldx COCKPIT_VIEW
        beq _animate_dust_front ; COCKPIT_VIEW == front
        dex 
        bne _2a3d
        jmp _animate_dust_rear

;===============================================================================

_2a3d:                                                                  ;$2A3D
        jmp _37e9

_animate_dust_front:                                                    ;$2A40

        ldy DUST_COUNT          ; number of dust particles
_2a43:                                                                  ;$2A43
        jsr _3b30               ; calculate PLAYER_SPEED / DUST_Z, y -> {P.R}
        lda ZP_VAR_R            ; unneccessary, A is R after _3b30
        lsr ZP_VAR_P
        ror 
        lsr ZP_VAR_P
        ror                     ; {P.A} = (PLAYER_SPEED / DUST_Z) / 4
        ora # %00000001         ; cheap way of asserting != 0 ?
        sta ZP_VAR_Q            ; so Q is SPEED/DZ/4 if P is 0..sure?
        lda VAR_06E3, y
        sbc ZP_97               ; ZP_97 is probably still (PLAYER_SPEED&3)<<6
        sta VAR_06E3, y
        lda DUST_Z, y
        sta ZP_VAR_Z
        sbc ZP_98
        sta DUST_Z, y
        jsr _3992
        sta ZP_VAR_YY_HI
        lda ZP_VAR_P1
        adc DUST_Y_LO, y
        sta ZP_VAR_YY_LO
        sta ZP_VAR_R
        lda ZP_VAR_Y
        adc ZP_VAR_YY_HI
        sta ZP_VAR_YY_HI
        sta ZP_VAR_S
        lda DUST_X, y
        sta ZP_VAR_X
        jsr _3997
        sta ZP_VAR_XX_HI
        lda ZP_VAR_P1
        adc DUST_X_LO, y
        sta ZP_VAR_XX_LO
        lda ZP_VAR_X
        adc ZP_VAR_XX_HI
        sta ZP_VAR_XX_HI
        eor ZP_6A               ; move count?
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
        eor ZP_95
        jsr _393e               ; multiply_small_number:A.P = A*X (X<32)
        sta ZP_VAR_Q
        jsr _3a4c
        asl ZP_VAR_P1
        rol 
        sta ZP_VAR_T
        lda # $00
        ror 
        ora ZP_VAR_T
        jsr multiplied_now_add  ; A.P + R.S -> X.A
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y
        lda ZP_VAR_YY_LO
        sta ZP_VAR_R
        lda ZP_VAR_YY_HI
        sta ZP_VAR_S
        lda # $00
        sta ZP_VAR_P1
        lda ZP_BETA
        eor # %10000000
        jsr _290f
        lda ZP_VAR_XX_HI
        sta ZP_VAR_X
        sta DUST_X, y
        and # %01111111
        cmp # $78
        bcs _2b0a
        lda ZP_VAR_YY_HI
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
        jsr draw_particle
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

_animate_dust_rear:                                                     ;$2B2D

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
        sta ZP_VAR_XX_HI
        lda DUST_X_LO, y
        sbc ZP_VAR_P1
        sta ZP_VAR_XX_LO
        lda ZP_VAR_X
        sbc ZP_VAR_XX_HI
        sta ZP_VAR_XX_HI
        jsr _3992
        sta ZP_VAR_YY_HI
        lda DUST_Y_LO, y
        sbc ZP_VAR_P1
        sta ZP_VAR_YY_LO
        sta ZP_VAR_R
        lda ZP_VAR_Y
        sbc ZP_VAR_YY_HI
        sta ZP_VAR_YY_HI
        sta ZP_VAR_S
        lda VAR_06E3, y
        adc ZP_97
        sta VAR_06E3, y
        lda DUST_Z, y
        sta ZP_VAR_Z
        adc ZP_98
        sta DUST_Z, y
        lda ZP_VAR_XX_HI
        eor ZP_ROLL_SIGN        ; roll sign?
        jsr _393c
        jsr multiplied_now_add
        sta ZP_VAR_YY_HI
        stx ZP_VAR_YY_LO
        eor ZP_6A               ; move count?
        jsr _3934
        jsr multiplied_now_add
        sta ZP_VAR_XX_HI
        stx ZP_VAR_XX_LO
        lda ZP_VAR_YY_HI
        eor ZP_95
        ldx ZP_PITCH_MAGNITUDE
        jsr _393e
        sta ZP_VAR_Q
        lda ZP_VAR_XX_HI
        sta ZP_VAR_S
        eor # %10000000
        jsr _3a50
        asl ZP_VAR_P1
        rol 
        sta ZP_VAR_T
        lda # $00
        ror 
        ora ZP_VAR_T
        jsr multiplied_now_add
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y
        lda ZP_VAR_YY_LO
        sta ZP_VAR_R
        lda ZP_VAR_YY_HI
        sta ZP_VAR_S
        lda # $00
        sta ZP_VAR_P1
        lda ZP_BETA
        jsr _290f
        lda ZP_VAR_XX_HI
        sta ZP_VAR_X
        sta DUST_X, y
        lda ZP_VAR_YY_HI
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
        lda ZP_POLYOBJ_XPOS_LO, y
        asl 
        sta ZP_VALUE_pt2
        lda ZP_POLYOBJ_XPOS_MI, y
        rol 
        sta ZP_VALUE_pt3
        lda # $00
        ror 
        sta ZP_VALUE_pt4
        jsr _2d69
        sta ZP_POLYOBJ_XPOS_HI, x
_2c43:                                                                  ;$2C43
        ldy ZP_VALUE_pt2
        sty ZP_POLYOBJ_XPOS_LO, x
        ldy ZP_VALUE_pt3
        sty ZP_POLYOBJ_XPOS_MI, x
        and # %01111111
        rts 

;===============================================================================
; examine a poly-object's X/Y/Z position?
;
;       A = a starting value to merge with
;       Y = a multiple of 37 bytes for each poly-object
;
_2c4e:                                                                  ;$2C4E
        lda # $00
_2c50:                                                                  ;$2C50
        ora POLYOBJECTS + PolyObject::xpos + 2, y
        ora POLYOBJECTS + PolyObject::ypos + 2, y
        ora POLYOBJECTS + PolyObject::zpos + 2, y
        and # %01111111         ; strip sign

        rts 

_2c5c:                                                                  ;$2C5C
;===============================================================================
        lda POLYOBJ_00 + PolyObject::xpos + 1, y                        ;=$F901
        jsr math_square
        sta ZP_VAR_R

        lda POLYOBJ_00 + PolyObject::ypos + 1, y                        ;=$F904
        jsr math_square
        adc ZP_VAR_R
        bcs _2c7a
        sta ZP_VAR_R
        
        lda POLYOBJ_00 + PolyObject::zpos + 1, y                        ;=$F907
        jsr math_square
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
; display status page
;
;-------------------------------------------------------------------------------
        lda # page::status
        jsr set_page_6a2f
        jsr _70ab

        lda # 7
        jsr set_cursor_col
        
        ; "COMMANDER ... PRESENT SYSTEM ... HYPERSPACE SYSTEM ... CONDITION"
.import TXT_STATUS_TITLE:direct
        lda # TXT_STATUS_TITLE
        jsr print_flight_token_and_divider
        
        lda # $0f
        ldy ZP_A7
        bne _2c7d

        ; print "GREEN", "RED" or "YELLOW":
        ;-----------------------------------------------------------------------
        ; NOTE: the list of colour name strings begins
        ;       with "GREEN", "RED" & "YELLOW"
        ;
.import TXT_COLORS:direct
        lda # TXT_COLORS        ; flight token: $E6, "GREEN"
        ldy VAR_047F
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
.import TXT_LEGAL_STATUS:direct
        lda # TXT_LEGAL_STATUS
        jsr print_flight_token_and_space

.import TXT_LEGAL_STATE:direct
        lda # TXT_LEGAL_STATE   ;="CLEAN"
        ldy PLAYER_LEGAL        ; get player's legal status
       .bze :+                  ; print "CLEAN"
        cpy # $32               ; +1 if legal state is >= $32 (TODO: why $32?)
        adc # $01               ; print "OFFENDER" or "FUGITIVE"
:       jsr print_flight_token_and_newline                              ;$2CD7

        ; print player rating:
        ;-----------------------------------------------------------------------
        ; print "RATING:"
.import TXT_RATING:direct
        lda # TXT_RATING
        jsr print_flight_token_and_space

        lda PLAYER_KILLS        ; number of kills
       .bnz _2c88               ; >0, skip ahead
        
        tax 
        lda VAR_04E0
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
.import TXT_EQUIPMENT:direct
        lda # TXT_EQUIPMENT
        jsr print_flight_token_and_newline_and_indent
        lda PLAYER_ESCAPEPOD
        beq _2d04

        ; print "ESCAPE POD"
.import TXT_ESCAPE_POD:direct
        lda # TXT_ESCAPE_POD
        jsr print_flight_token_and_newline_and_indent

_2d04:                                                                  ;$2D04
        lda VAR_04C2
        beq _2d0e
.import TXT_FUEL_SCOOPS:direct
        lda # TXT_FUEL_SCOOPS
        jsr print_flight_token_and_newline_and_indent
_2d0e:                                                                  ;$2D0E
        lda PLAYER_ECM
        beq _2d18
.import TXT_ECM_SYSTEM:direct
        lda # TXT_ECM_SYSTEM
        jsr print_flight_token_and_newline_and_indent
_2d18:                                                                  ;$2D18
        lda # $71               ;="ENERGY BOMB"
        sta ZP_AD
_2d1c:                                                                  ;$2D1C
        tay 
        ldx SHIP_SLOTS, y       ; ship slots? NB: "$04c3 - $71"
        beq _2d25
        jsr print_flight_token_and_newline_and_indent
_2d25:                                                                  ;$2D25
        inc ZP_AD
        lda ZP_AD
        cmp # $75
        bcc _2d1c
        ldx # $00
_2d2f:                                                                  ;$2D2F
        stx ZP_AA
        
        ; print "FRONT" / "REAR" / "LEFT" / "RIGHT"
.import TXT_DIRECTIONS:direct
        ldy PLAYER_LASERS, x
        beq _2d59
        txa 
        clc 
        adc # TXT_DIRECTIONS
        jsr print_flight_token_and_space

        lda # $67
        ldx ZP_AA
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

.import TXT_MINING_LASER:direct
        lda # TXT_MINING_LASER
_2d56:                                                                  ;$2D56
        jsr print_flight_token_and_newline_and_indent
_2d59:                                                                  ;$2D59
        ldx ZP_AA
        inx 
        cpx # $04
        bcc _2d2f
        rts 


print_flight_token_and_newline_and_indent:                              ;$2D61
;===============================================================================
        jsr print_flight_token_and_newline
        lda # 6
        jmp set_cursor_col


_2d69:                                                                  ;$2D69
;===============================================================================
        lda ZP_VALUE_pt4
        sta ZP_VAR_S
        and # %10000000
        sta ZP_VAR_T
        eor ZP_POLYOBJ_XPOS_HI, x
        bmi _2d8d
        lda ZP_VALUE_pt2
        clc 
        adc ZP_POLYOBJ_XPOS_LO, x
        sta ZP_VALUE_pt2
        lda ZP_VALUE_pt3
        adc ZP_POLYOBJ_XPOS_MI, x
        sta ZP_VALUE_pt3
        lda ZP_VALUE_pt4
        adc ZP_POLYOBJ_XPOS_HI, x
        and # %01111111
        ora ZP_VAR_T
        sta ZP_VALUE_pt4
        rts 

        ;-----------------------------------------------------------------------

_2d8d:                                                                  ;$2D8D
        lda ZP_VAR_S
        and # %01111111
        sta ZP_VAR_S
        lda ZP_POLYOBJ_XPOS_LO, x
        sec 
        sbc ZP_VALUE_pt2
        sta ZP_VALUE_pt2
        lda ZP_POLYOBJ_XPOS_MI, x
        sbc ZP_VALUE_pt3
        sta ZP_VALUE_pt3
        lda ZP_POLYOBJ_XPOS_HI, x
        and # %01111111
        sbc ZP_VAR_S
        ora # %10000000
        eor ZP_VAR_T
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
        ora ZP_VAR_T
        sta ZP_VALUE_pt4
_2dc4:                                                                  ;$2DC4
        rts 

;===============================================================================
;
;       X = offset from `ZP_POLYOBJECT` to the desired matrix row;
;           that is, a `MATRIX_ROW_*` constant
;
;       Y = offset from `ZP_POLYOBJECT` to the desired matrix row;
;           that is, a `MATRIX_ROW_*` constant
;
_2dc5:                                                                  ;$2DC5

COL0    = $00           ; column 0 of the matrix row
COL0_LO = $00
COL0_HI = $01
COL1    = $02           ; column 1 of the matrix row
COL1_LO = $02
COL1_HI = $03
COL2    = $04           ; column 2 of the matrix row
COL2_LO = $04
COL2_HI = $05

        ; ROW X
        ;-----------------------------------------------------------------------

        lda ZP_POLYOBJ + COL0_HI, x
        and # %01111111         ; extract HI byte without sign
        lsr                     ; divide by 2
        sta ZP_VAR_T

        lda ZP_POLYOBJ + COL0_LO, x
        sec 
        sbc ZP_VAR_T
        sta ZP_VAR_R
        
        lda ZP_POLYOBJ + COL0_HI, x
        sbc # $00
        sta ZP_VAR_S

        ; ROW Y
        ;-----------------------------------------------------------------------

        lda ZP_POLYOBJ + COL0_LO, y
        sta ZP_VAR_P
        
        lda ZP_POLYOBJ + COL0_HI, y
        and # %10000000         ; extract sign
        sta ZP_VAR_T            ; put sign aside
        
        lda ZP_POLYOBJ + COL0_HI, y
        and # %01111111         ; extract magnitude
        lsr                     ; divide by 2
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        ora ZP_VAR_T            ; restore sign
        eor ZP_B1               ; rotation sign?
        stx ZP_VAR_Q
        
        jsr multiplied_now_add
        sta ZP_VALUE_pt2
        stx ZP_VALUE_pt1
        ldx ZP_VAR_Q
        lda ZP_POLYOBJ + COL0_HI, y
        and # %01111111
        lsr 
        sta ZP_VAR_T
        lda ZP_POLYOBJ + COL0_LO, y
        sec 
        sbc ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_POLYOBJ + COL0_HI, y
        sbc # $00
        sta ZP_VAR_S
        lda ZP_POLYOBJ + COL0_LO, x
        sta ZP_VAR_P
        lda ZP_POLYOBJ + COL0_HI, x
        and # %10000000
        sta ZP_VAR_T
        lda ZP_POLYOBJ + COL0_HI, x
        and # %01111111
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        lsr 
        ror ZP_VAR_P
        ora ZP_VAR_T
        eor # %10000000
        eor ZP_B1
        stx ZP_VAR_Q
        jsr multiplied_now_add
        sta ZP_POLYOBJ + COL0_HI, y
        stx ZP_POLYOBJ + COL0_LO, y
        ldx ZP_VAR_Q
        lda ZP_VALUE_pt1
        sta ZP_POLYOBJ + COL0_LO, x
        lda ZP_VALUE_pt2
        sta ZP_POLYOBJ + COL0_HI, x

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
        ;=======================================================================
        ; print an 8-bit value, given in X, padded to 3 chars
        ;
        ;    X = value to print
        ;
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
        sta ZP_9F               ; put original max.length of text aside

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
        dec ZP_9F
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
        .byte   %11111111

txt_flight_flag:                                                        ;$2F1A
        .byte   %00000000

txt_buffer_flag:                                                        ;$2F1B
        .byte   %00000000

txt_buffer_index:                                                       ;$2F1C
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
        lda # TXT_NEWLINE

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
        
        cmp # TXT_NEWLINE
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

        cmp # TXT_NEWLINE       ; new-line character?
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
        lda # TXT_NEWLINE
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
        lda # TXT_NEWLINE
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

_2fee:                                                                  ;$2FEE
        ;=======================================================================
        ; the BBC code says that char 7 is a beep
        ;
        lda # $07               ; BEEP?
        jmp paint_char

;===============================================================================
; BBC code says this is "update displayed dials"
;
_2ff3:                                                                  ;$2FF3
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
        
        lda PLAYER_SPEED
        jsr hud_drawbar_32
        
        ;-----------------------------------------------------------------------

        lda # $00
        sta ZP_VAR_R
        sta ZP_VAR_P1
        
        lda # $08
        sta ZP_VAR_S
        
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
        
        lda ZP_A3               ; move counter?
        and # %00000011
        bne _2fe0
        
        ldy # $00
        jsr _30bb
        stx ZP_VALUE_pt1
        sta ZP_VALUE_pt2

        ldx # $03               ; 4 energy banks
        stx ZP_TEMP_VAR
_3044:                                                                  ;$3044
        sty ZP_71, x
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
        sta ZP_71, x
        lda ZP_VAR_Q
        dex 
        bpl _3052
        bmi _3068
_3064:                                                                  ;$3064
        lda ZP_VAR_Q
        sta ZP_71, x
_3068:                                                                  ;$3068
        lda ZP_71, y
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
        lda # .color_nybble(LTRED, LTRED)
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

        lda PLAYER_TEMP_CABIN
        jsr hud_drawbar_128
        
        lda PLAYER_TEMP_LASER
        jsr hud_drawbar_128

        lda # $f0               ; "threshold to change colour"
        sta ZP_TEMP_VAR

        lda VAR_06F3            ; altitude?
        jsr hud_drawbar_128
        
        jmp _7b6f

;===============================================================================
; decide to flash a dial?
;
_30bb:                                                                  ;$30BB
        ldx # .color_nybble(LTRED, LTRED)

        lda ZP_A3               ; move counter?
        and # %00001000         ; every 8th frame?
        and _1d09               ; is flashing enabled?
       .bze :+

        txa 

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit 
:       lda # .color_nybble(GREEN, GREEN)                               ;$30C8
        
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
        sta ZP_VAR_Q            ; "bar value 1-15"

        ldx # %11111111         ; mask?
        stx ZP_VAR_R
        cmp ZP_TEMP_VAR         ; "threshold to change colour"
        bcs :+
        
        lda ZP_VALUE_pt2
        bne :++

:       lda ZP_VALUE_pt1                                                ;$30DD

:       sta ZP_32               ; colour to use                         ;$30DF

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
        sta ZP_VAR_Q
        lda ZP_VAR_R
        
:       asl                                                             ;$310F
        asl 
        dec ZP_VAR_Q
        bpl :-
        pha 
        lda # $00
        sta ZP_VAR_R
        lda # $63
        sta ZP_VAR_Q
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

;===============================================================================
; ".DIL2 -> roll/pitch indicator takes X.A"
;
_3130:                                                                  ;$3130
        ldy # $01               ; counter Y = 1
        sta ZP_VAR_Q
@_3134:                                                                 ;$3134
        sec 
        lda ZP_VAR_Q
        sbc # $04
        bcs @_3149               ; >= 4?

        lda # $ff
        ldx ZP_VAR_Q
        sta ZP_VAR_Q
        lda _28d0, x
        and # %10101010         ; colour mask
        
        jmp @_314d

@_3149:                                                                 ;$3149
        ; clear the bar
        sta ZP_VAR_Q
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

;===============================================================================
; eject escape pod
;
eject_escapepod:                                                        ;$316E

        jsr _83df

        ldx # $0b
        stx ZP_A5
        
        jsr _3680
        bcs _317f
        
        ldx # $18
        jsr _3680
_317f:                                                                  ;$317F
        lda # $08
        sta ZP_POLYOBJ_VERTX_LO
        
        lda # %11000010
        sta ZP_POLYOBJ_PITCH
        lsr 
        sta ZP_POLYOBJ_ATTACK
_318a:                                                                  ;$318A
        jsr _a2a0
        jsr _9a86

        dec ZP_POLYOBJ_ATTACK
        bne _318a
        
        jsr _b410
        
        lda # $00
        ldx # .sizeof( Cargo )-1

:       sta VAR_CARGO, x        ; empty cargo slot                      ;$319B
        dex 
        bpl :-

        sta PLAYER_LEGAL        ; clear legal status
        sta PLAYER_ESCAPEPOD    ; you no longer own an escape pod
        
        ; some Trumbles™ will slip away
        ; with you, the sneaky things!
.ifndef OPTION_NOTRUMBLES
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
        lda # $46
        sta PLAYER_FUEL
        jmp _2101

;===============================================================================

_31c6:                                                                  ;$31C6
        lda # $0e
        jsr print_docked_str

        jsr _6f82
        jsr _70a0
        lda # $00
        sta ZP_AE
_31d5:                                                                  ;$31D5
        jsr txt_docked_token0E
        jsr _76e9

        ldx txt_buffer_index
        lda ZP_POLYOBJ_YPOS_HI, x       ;=$0E?
        cmp # $0d
        bne _31f1
_31e4:                                                                  ;$31E4
        dex 
        lda ZP_POLYOBJ_YPOS_HI, x       ;=$0E?
        ora # %00100000
        cmp VAR_0648, x
        beq _31e4
        txa 
        bmi _3208
_31f1:                                                                  ;$31F1
        jsr randomize
        inc ZP_AE
        bne _31d5
        jsr _70ab
        jsr _6f82
        ldy # $06
        jsr _a858

        lda # $d7
        jmp print_docked_str

        ;-----------------------------------------------------------------------

_3208:                                                                  ;$3208
        lda ZP_SEED_W1_HI
        sta TSYSTEM_POS_X
        lda ZP_SEED_W0_HI
        sta TSYSTEM_POS_Y
        jsr _70ab
        jsr _6f82
        jsr txt_docked_token0F
        jmp _877e

;===============================================================================

_321e:                                                                  ;$321E
        lda ZP_POLYOBJ_XPOS_LO  ;=$09
        ora ZP_POLYOBJ_YPOS_LO  ;=$0C
        ora ZP_POLYOBJ_ZPOS_LO  ;=$0F
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
        lda ZP_67
        bne _321e

        lda ZP_POLYOBJ_ATTACK
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

        lda ZP_POLYOBJ_ATTACK
        cmp # attack::active | attack::aggr1    ;=%10000010
        beq _321e
        
        ldy # $1f
        lda [ZP_TEMP_ADDR3], y
        ; this might be a `ldy # $32`, but I don't see any jump into it
        bit _32a0+1             ;!?
        bne _327d
        ora # %10000000
        sta [ZP_TEMP_ADDR3], y
_327d:                                                                  ;$327D
        lda ZP_POLYOBJ_XPOS_LO  ;=$09
        ora ZP_POLYOBJ_YPOS_LO  ;=$0C
        ora ZP_POLYOBJ_ZPOS_LO  ;=$0F
        bne _328a

        lda # $50
        jsr _7bd2
_328a:                                                                  ;$328A
        lda ZP_POLYOBJ_ATTACK
        and # attack::active ^$FF       ;=%01111111
        lsr 
        tax 
_3290:                                                                  ;$3290
        jsr _a7a6
_3293:                                                                  ;$3293
        asl ZP_POLYOBJ_VISIBILITY
        sec 
        ror ZP_POLYOBJ_VISIBILITY
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
        lda #< VAR_0403
        sta ZP_B0
        lda #> VAR_0403
        sta ZP_B1
        lda # $16
        sta ZP_AB
        cpx # $01
        beq _3244
        cpx # $02
        bne _32ef

        lda ZP_POLYOBJ_BEHAVIOUR
        and # behaviour::angry
        bne _32da
        
        lda VAR_0467
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
        lda VAR_046D
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

        ldx # %00000000
        stx ZP_POLYOBJ_ATTACK

        ldx # behaviour::protected | behaviour::angry   ;=%00100100
        stx ZP_POLYOBJ_BEHAVIOUR

        and # %00000011
        adc # $11
        tax 
        jsr _32ea

        lda # %00000000
        sta ZP_POLYOBJ_ATTACK
        rts 

        ;-----------------------------------------------------------------------

_330f:                                                                  ;$330F
        ldy # Hull::energy      ;=$0E: energy
        lda ZP_POLYOBJ_ENERGY
        cmp [ZP_HULL_ADDR], y
        bcs _3319
        inc ZP_POLYOBJ_ENERGY
_3319:                                                                  ;$3319
        cpx # $1e
        bne _3329

        lda VAR_047A
        bne _3329
        
        lsr ZP_POLYOBJ_ATTACK
        asl ZP_POLYOBJ_ATTACK
        lsr ZP_POLYOBJ_VERTX_LO
_3328:                                                                  ;$3328
        rts 

        ;-----------------------------------------------------------------------

_3329:                                                                  ;$3329
        jsr get_random_number
        lda ZP_POLYOBJ_BEHAVIOUR
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
        lda ZP_POLYOBJ_BEHAVIOUR
        ora # behaviour::angry
        sta ZP_POLYOBJ_BEHAVIOUR
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
        
        lda VAR_045F
        beq _3365

        lda ZP_POLYOBJ_ATTACK
        and # attack::active | attack::ecm      ;=%10000001
        sta ZP_POLYOBJ_ATTACK
_3365:                                                                  ;$3365
        ldx # $08
_3367:                                                                  ;$3367
        lda ZP_POLYOBJ_XPOS_LO, x
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex 
        bpl _3367
_336e:                                                                  ;$336E
        jsr _8c8a
        ldy # $0a
        jsr _3ab2
        sta ZP_AA
        lda ZP_A5
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
        sta ZP_POLYOBJ_ROLL
_33a8:                                                                  ;$33A8
        ldy # Hull::energy      ;=$0E: energy
        lda [ZP_HULL_ADDR], y
        lsr 
        cmp ZP_POLYOBJ_ENERGY
        bcc _33fd
        lsr 
        lsr 
        cmp ZP_POLYOBJ_ENERGY
        bcc _33d6
        jsr get_random_number
        cmp # $e6
        bcc _33d6
        ldx ZP_A5
        lda hull_d042 - 1, x
        bpl _33d6
        lda ZP_POLYOBJ_BEHAVIOUR
        and # behaviour::remove    | behaviour::police \
            | behaviour::protected | behaviour::docking ;=%11110000
        sta ZP_POLYOBJ_BEHAVIOUR
        ldy # PolyObject::behaviour
        sta [ZP_POLYOBJ_ADDR], y
        
        lda # %00000000
        sta ZP_POLYOBJ_ATTACK
        jmp _3706

        ;-----------------------------------------------------------------------

_33d6:                                                                  ;$33D6
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::missiles
        beq _33fd
        sta ZP_VAR_T

        jsr get_random_number
        and # %00011111
        cmp ZP_VAR_T
        bcs _33fd
        
        lda ZP_67
        bne _33fd
        dec ZP_POLYOBJ_VISIBILITY       ; reduce number of missiles?
        lda ZP_A5
        cmp # $1d
        bne _33fa

        ldx # %00011110
        lda ZP_POLYOBJ_ATTACK
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
        ldx ZP_AA
        cpx # $a0
        bcc _3434

        ldy # Hull::_13         ;=$13: "laser / missile count"?
        lda [ZP_HULL_ADDR], y
        and # %11111000
        beq _3434
        
        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::firing
        sta ZP_POLYOBJ_VISIBILITY
        cpx # $a3
        bcc _3434

        lda [ZP_HULL_ADDR], y
        lsr 
        jsr _7bd2
        dec ZP_POLYOBJ_VERTX_HI
        lda ZP_67
        bne _3499
        ldy # $01
        jsr _a858
        ldy # $0f
        jmp _a858

        ;-----------------------------------------------------------------------

_3434:                                                                  ;$3434
        lda ZP_POLYOBJ_ZPOS_MI  ;=$10
        cmp # $03
        bcs _3442
        lda ZP_POLYOBJ_XPOS_MI  ;=$0A
        ora ZP_POLYOBJ_YPOS_MI  ;=$0D
        and # %11111110
        beq _3454
_3442:                                                                  ;$3442
        ; randomly generate an attacking ship?
        jsr get_random_number
        ora # attack::active    ;=%10000000
        cmp ZP_POLYOBJ_ATTACK
        bcs _3454
_344b:                                                                  ;$344B
        jsr _35d5
        lda ZP_AA
        eor # %10000000
_3452:                                                                  ;$3452
        sta ZP_AA
_3454:                                                                  ;$3454
        ldy # $10
        jsr _3ab2
        tax 
        eor # %10000000
        and # %10000000
        sta ZP_POLYOBJ_PITCH
        txa 
        asl 
        cmp ZP_B1
        bcc _346c
        lda ZP_B0
        ora ZP_POLYOBJ_PITCH
        sta ZP_POLYOBJ_PITCH
_346c:                                                                  ;$346C
        lda ZP_POLYOBJ_ROLL
        asl 
        cmp # $20
        bcs _348d
        ldy # $16
        jsr _3ab2
        tax 
        eor ZP_POLYOBJ_PITCH
        and # %10000000
        eor # %10000000
        sta ZP_POLYOBJ_ROLL
        txa 
        asl 
        cmp ZP_B1
        bcc _348d
        lda ZP_B0
        ora ZP_POLYOBJ_ROLL
        sta ZP_POLYOBJ_ROLL
_348d:                                                                  ;$348D
        lda ZP_AA
        bmi _349a
        cmp ZP_AB
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
        ldx ZP_A5
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
        stx ZP_B1
_34b9:                                                                  ;$24B9
        jmp _3452

;===============================================================================

_34bc:                                                                  ;$34BC
        lda # $06
        sta ZP_B1
        lsr 
        sta ZP_B0
        lda # $1d
        sta ZP_AB
        lda VAR_045F
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
        lda ZP_A5
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
        sta ZP_POLYOBJ_ROLL
        bne _3571
_352c:                                                                  ;$352C
        ldx # $00
        stx ZP_B1
        stx ZP_POLYOBJ_PITCH
        lda ZP_A5
        bpl _3556
        eor ZP_VAR_X
        eor ZP_VAR_Y
        asl 
        lda # $02
        ror 
        sta ZP_POLYOBJ_ROLL
        lda ZP_VAR_X
        asl 
        cmp # $0c
        bcs _350a
        lda ZP_VAR_Y
        asl 
        lda # $02
        ror 
        sta ZP_POLYOBJ_PITCH
        lda ZP_VAR_Y
        asl 
        cmp # $0c
        bcs _350a
_3556:                                                                  ;$3556
        stx ZP_POLYOBJ_ROLL
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
        lda ZP_3F               ; only use, ever. does not get set!
        bne _357a

        asl ZP_POLYOBJ_BEHAVIOUR
        sec 
        ror ZP_POLYOBJ_BEHAVIOUR
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
        sta ZP_VALUE_pt4

        dey 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VALUE_pt3
        
        dey 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VALUE_pt2
        
        sty ZP_VAR_U
        ldx ZP_VAR_U
        jsr _2d69
        
        ldy ZP_VAR_U
        sta ZP_POLYOBJ01_XPOS_pt3, x
        lda ZP_VALUE_pt3
        sta ZP_POLYOBJ01_XPOS_pt2, x
        lda ZP_VALUE_pt2
        sta ZP_POLYOBJ01_XPOS_pt1, x
        rts 

;===============================================================================

_35b3:                                                                  ;$35B3
        ldx POLYOBJ_01 + PolyObject::xpos + 0, y                        ;=$F925
        stx ZP_VAR_Q
        lda ZP_VAR_X
        jsr multiply_signed_into_RS
        ldx POLYOBJ_01 + PolyObject::xpos + 2, y                        ;=$F927
        stx ZP_VAR_Q
        lda ZP_VAR_Y
        jsr multiply_and_add
        sta ZP_VAR_S
        stx ZP_VAR_R
        ldx POLYOBJ_01 + PolyObject::ypos + 1, y                        ;=$F929
        stx ZP_VAR_Q
        lda ZP_VAR_X2
        jmp multiply_and_add

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
        lda POLYOBJ_01 + PolyObject::m0x0 + 1                           ;=$F92F
        ldx # $00
        jsr _3600
        lda POLYOBJ_01 + PolyObject::m0x1 + 1                           ;=$F931
        ldx # $03
        jsr _3600
        lda POLYOBJ_01 + PolyObject::m0x2 + 1                           ;=$F933
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

_363f:                                                                  ;$363F
;===============================================================================
        clc 
        lda ZP_POLYOBJ_ZPOS_HI
        bne _367d

        lda ZP_A5
        bmi _367d
        
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        ora ZP_POLYOBJ_XPOS_MI
        ora ZP_POLYOBJ_YPOS_MI
        bne _367d
        
        lda ZP_POLYOBJ_XPOS_LO
        jsr math_square
        sta ZP_VAR_S
        
        lda ZP_VAR_P1
        sta ZP_VAR_R
        
        lda ZP_POLYOBJ_YPOS_LO
        jsr math_square
        
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
        jsr clear_zp_polyobj
        lda # $1c
        sta ZP_POLYOBJ_YPOS_LO
        lsr 
        sta ZP_POLYOBJ_ZPOS_LO
        lda # $80
        sta ZP_POLYOBJ_YPOS_HI
        
        lda ZP_MISSILE_TARGET
        asl 
        ora # attack::active
        sta ZP_POLYOBJ_ATTACK

_3695:                                                                  ;$3695
        lda # $60
        sta ZP_POLYOBJ_M0x2_HI
        ora # %10000000
        sta ZP_POLYOBJ_M2x0_HI

        lda PLAYER_SPEED
        rol 
        sta ZP_POLYOBJ_VERTX_LO
        
        txa 
        jmp _7c6b

_36a6:                                                                  ;$36A6
;===============================================================================
        ldx # $01
        jsr _3680
        bcc _3701
        
        ldx ZP_MISSILE_TARGET
        jsr get_polyobj

        lda SHIP_SLOTS, x
        jsr _36c5

        ldy # $b7
        jsr _7d0c
        
        dec PLAYER_MISSILES
        
        ldy # $04
        jmp _a858

;===============================================================================
; target / fire missile?
;
_36c5:                                                                  ;$36C5
        ; firing misisle at space station?
        ; (not a good idea)
        cmp # hull_coreolis_index       ;$02
        ; make the space-station hostile?
        beq _36f8

        ldy # PolyObject::behaviour
        lda [ZP_POLYOBJ_ADDR], y
        and # behaviour::protected
        beq _36d4

        jsr _36f8
_36d4:                                                                  ;$36D4
        ldy # PolyObject::attack
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

        lda ZP_A5
        cmp # $0b
        bcc _36f7

        ldy # PolyObject::behaviour
        lda [ZP_POLYOBJ_ADDR], y
        ora # behaviour::angry
        sta [ZP_POLYOBJ_ADDR], y
_36f7:                                                                  ;$36F7
        rts 

        ;-----------------------------------------------------------------------

_36f8:                                                                  ;$36F8
        ; make hostile?
        lda POLYOBJ_01 + PolyObject::behaviour                         ;=$F949
        ora # behaviour::angry
        sta POLYOBJ_01 + PolyObject::behaviour                         ;=$F949
        rts 

_3701:                                                                  ;$3701
        lda # $c9
        jmp _900d

;===============================================================================

_3706:                                                                  ;$3706
        ldx # $03
_3708:                                                                  ;$3708
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
        lda ZP_POLYOBJ_XPOS_LO, y
        sta $0100, y            ; the stack!?
        lda [ZP_POLYOBJ_ADDR], y
        sta ZP_POLYOBJ_XPOS_LO, y
        dey 
        bpl _371c
        lda ZP_A5
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
        sta ZP_POLYOBJ_ATTACK
        lsr ZP_POLYOBJ_ROLL
        asl ZP_POLYOBJ_ROLL
        txa 
        cmp # $09
        bcs _3770
        cmp # $04
        bcc _3770
        pha 
        jsr get_random_number
        asl 
        sta ZP_POLYOBJ_PITCH
        txa 
        and # %00001111
        sta ZP_POLYOBJ_VERTX_LO
        lda # $ff
        ror 
        sta ZP_POLYOBJ_ROLL
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
        sta ZP_POLYOBJ_XPOS_LO, x
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
        jmp move_polyobj_x

_3795:                                                                  ;$3795
        jsr _a839
        lda # $04
        jsr _37a5
        
        rts 

;===============================================================================

_379e:                                                                  ;$397E
        ldy # $04
        jsr _a858
        lda # $08
_37a5:                                                                  ;$37A5
        sta ZP_AC

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
        stx ZP_POLYOBJ01_XPOS_pt1

        ldx # $48               ;TODO: half viewport height?
        stx ZP_43
        
        ldx # $00
        stx ZP_AD
        stx ZP_POLYOBJ01_XPOS_pt2
        stx ZP_44
_37c2:                                                                  ;$37C2
        jsr _37ce
        inc ZP_AD
        ldx ZP_AD
        cpx # $08
        bne _37c2
        rts 

;===============================================================================

_37ce:                                                                  ;$37CE
        lda ZP_AD
        and # %00000111
        clc 
        adc # $08
        sta ZP_VALUE_pt1
_37d7:                                                                  ;$37D7
        lda # $01
        sta ZP_7E
        jsr _805e
        asl ZP_VALUE_pt1
        bcs _37e8
        lda ZP_VALUE_pt1
        cmp # $a0
        bcc _37d7
_37e8:                                                                  ;$37E8
        rts 

;===============================================================================

_37e9:                                                                  ;$37E9
        lda # $00
        cpx # $02
        ror 
        sta ZP_B0
        eor # %10000000
        sta ZP_B1
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
        sta ZP_BA
        eor ZP_B1
        sta ZP_VAR_S
        lda DUST_X_LO, y
        sta ZP_VAR_P1
        lda DUST_X, y
        sta ZP_VAR_X
        jsr multiplied_now_add
        sta ZP_VAR_S
        stx ZP_VAR_R
        lda DUST_Y, y
        sta ZP_VAR_Y
        eor ZP_PITCH_SIGN
        ldx ZP_PITCH_MAGNITUDE
        jsr _393e
        jsr multiplied_now_add
        stx ZP_VAR_XX_LO
        sta ZP_VAR_XX_HI
        ldx DUST_Y_LO, y
        stx ZP_VAR_R
        ldx ZP_VAR_Y
        stx ZP_VAR_S
        ldx ZP_PITCH_MAGNITUDE
        eor ZP_95
        jsr _393e
        jsr multiplied_now_add
        stx ZP_VAR_YY_LO
        sta ZP_VAR_YY_HI
        ldx ZP_ROLL_MAGNITUDE
        eor ZP_ROLL_SIGN
        jsr _393e
        sta ZP_VAR_Q
        lda ZP_VAR_XX_LO
        sta ZP_VAR_R
        lda ZP_VAR_XX_HI
        sta ZP_VAR_S
        eor # %10000000
        jsr multiply_and_add
        sta ZP_VAR_XX_HI
        txa 
        sta DUST_X_LO, y
        lda ZP_VAR_YY_LO
        sta ZP_VAR_R
        lda ZP_VAR_YY_HI
        sta ZP_VAR_S
        jsr multiply_and_add
        sta ZP_VAR_S
        stx ZP_VAR_R
        lda # $00
        sta ZP_VAR_P1
        lda ZP_ALPHA
        jsr _290f
        lda ZP_VAR_XX_HI
        sta DUST_X, y
        sta ZP_VAR_X
        and # %01111111
        eor # %01111111
        cmp ZP_BA
        bcc _38be
        beq _38be
        lda ZP_VAR_YY_HI
        sta DUST_Y, y
        sta ZP_VAR_Y
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
        sta ZP_6A               ; move count?
        lda ZP_PITCH_SIGN
        eor ZP_B0
        sta ZP_PITCH_SIGN
        eor # %10000000
        sta ZP_95
        rts 

        ;-----------------------------------------------------------------------

_38be:                                                                  ;$38BE
        jsr get_random_number
        sta ZP_VAR_Y
        sta DUST_Y, y
        lda # $73
        ora ZP_B0
        sta ZP_VAR_X
        sta DUST_X, y
        bne _38e2
_38d1:                                                                  ;$38D1
        jsr get_random_number
        sta ZP_VAR_X
        sta DUST_X, y
        lda # $6e
        ora ZP_6A               ; move count?
        sta ZP_VAR_Y
        sta DUST_Y, y
_38e2:                                                                  ;$38E2
        jsr get_random_number
        ora # %00001000
        sta ZP_VAR_Z
        sta DUST_Z, y
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
        sta ZP_VAR_R
        and # %01111111
        sta ZP_VALUE_pt3
        lda ZP_VAR_Q
        and # %01111111
        beq _38ee
        sec 
        sbc # $01
        sta ZP_VAR_T
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
        adc ZP_VAR_T
_391d:                                                                  ;$391D
        ror 
        ror ZP_VALUE_pt3
        ror ZP_VALUE_pt2
        ror ZP_VALUE_pt1
        dex 
        bne _3919
        sta ZP_VAR_T
        lda ZP_VAR_R
        eor ZP_VAR_Q
        and # %10000000
        ora ZP_VAR_T
        sta ZP_VALUE_pt4
        rts 

;===============================================================================

_3934:                                                                  ;$3934
        ldx ZP_VAR_XX_LO
        stx ZP_VAR_R
        ldx ZP_VAR_XX_HI
        stx ZP_VAR_S
_393c:                                                                  ;$393C
        ldx ZP_ROLL_MAGNITUDE
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
; insert math square (?^2) routine
;
.include        "math/math_square.asm"                                  ;$3986

;===============================================================================
; calculate ZP_VALUE_pt1 * abs(sin(A))
;
_39e0:                                                                  ;$39E0
        and # %00011111
        tax                     ; X = A%31, with 0..31 equiv. 0..pi
        lda table_sin, x
        sta ZP_VAR_Q            ; Q = abs(sin(A))*256
        lda ZP_VALUE_pt1

_39ea:                                                                  ;$39EA
        ; calculate A=(A*Q)/256 via log-tables
        ;
        stx ZP_VAR_P            ; preserve X
        sta ZP_B6
        tax 
        beq _3a1d
        lda table_logdiv, x
        ldx ZP_VAR_Q
        beq _3a20
        clc 
        adc table_logdiv, x
        bmi _3a0f
        lda table_log, x
        ldx ZP_B6
        adc table_log, x
        bcc _3a20               ; no overflow: A*Q < 256
        tax 
        lda _9500, x
        ldx ZP_VAR_P            ; restore X
        rts 

        ;-----------------------------------------------------------------------

_3a0f:                                                                  ;$3A0F
        lda table_log, x
        ldx ZP_B6
        adc table_log, x
        bcc _3a20               ; no overflow: A*Q < 256
        tax 
        lda _9600, x            ; A = X*ZP_B6
_3a1d:                                                                  ;$3A1D
        ldx ZP_VAR_P            ; restore X
        rts 

        ;-----------------------------------------------------------------------

_3a20:                                                                  ;$3A20
        lda # $00               ; A=0 when either A or Q was 0 or A*Q < 256
        ldx ZP_VAR_P            ; restore X
        rts 

;===============================================================================

_3a25:                                                                  ;$3A25
        stx ZP_VAR_Q
_3a27:                                                                  ;$3A27
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
; insert `multiply_signed` (and some precedents)
;
.include        "math/math_multiply_signed.asm"                         ;$3A48

;===============================================================================

_3ab2:                                                                  ;$3AB2
        ldx ZP_POLYOBJ_XPOS_LO, y
        stx ZP_VAR_Q
        lda ZP_VAR_X
        jsr multiply_signed_into_RS
        ldx ZP_POLYOBJ_XPOS_HI, y
        stx ZP_VAR_Q
        lda ZP_VAR_Y
        jsr multiply_and_add
        sta ZP_VAR_S
        stx ZP_VAR_R
        ldx ZP_POLYOBJ_YPOS_MI, y
        stx ZP_VAR_Q
        lda ZP_VAR_X2

;===============================================================================
; insert the `multiply_and_add` routine
;
.include        "math/math_multiply+add.asm"                            ;$3ACE 

;===============================================================================

_3b0d:                                                                  ;$3B0D
        stx ZP_VAR_Q
        eor # %10000000
        jsr multiply_and_add
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

        lda PLAYER_SPEED

;===============================================================================
; unsigned integer division
;
; params:
;       A =
;       Q =
;
; returns:
;       A/Q*256 as 16-bit value in P.R  (A is the same as R on exit)
;
divide_unsigned:                                                        ;$3B37

        ; This calculates A / Q by repeatedly shifting A (16bit) left
        ; and subtracting from the hi-byte whenever possible.
_3b37:                                                                  ;$3B37
        asl 
        sta ZP_VAR_P
        
        lda # $00
        rol 
        cmp ZP_VAR_Q
        bcc _3b43
        
        sbc ZP_VAR_Q
_3b43:                                                                  ;$3B43
        rol ZP_VAR_P            ; 1
        rol 
        cmp ZP_VAR_Q
        bcc _3b4c
        sbc ZP_VAR_Q
_3b4c:                                                                  ;$3B4C
        rol ZP_VAR_P            ; 2
        rol 
        cmp ZP_VAR_Q
        bcc _3b55
        sbc ZP_VAR_Q
_3b55:                                                                  ;$3B55
        rol ZP_VAR_P            ; 4
        rol 
        cmp ZP_VAR_Q
        bcc _3b5e
        sbc ZP_VAR_Q
_3b5e:                                                                  ;$3B5E
        rol ZP_VAR_P            ; 8
        rol 
        cmp ZP_VAR_Q
        bcc _3b67
        sbc ZP_VAR_Q
_3b67:                                                                  ;$3B67
        rol ZP_VAR_P            ; 16
        rol 
        cmp ZP_VAR_Q
        bcc _3b70
        sbc ZP_VAR_Q
_3b70:                                                                  ;$3B70
        rol ZP_VAR_P            ; 32
        rol 
        cmp ZP_VAR_Q
        bcc _3b79
        sbc ZP_VAR_Q
_3b79:                                                                  ;$3B79
        rol ZP_VAR_P            ; 64
        rol 
        cmp ZP_VAR_Q
        bcc _3b82
        sbc ZP_VAR_Q
_3b82:                                                                  ;$3B82
        rol ZP_VAR_P            ; 128
        
        ; end of P = A/Q

        ldx # $00               ; unneccessary, cancelled out by the tax below
        sta ZP_B6               ; A and ZP_B6 are now both the remainder of A/Q
        tax 
        beq _3ba6               ; no remainder: finish

        ; calculate (remainder/Q)*256 via the log-tables
        lda table_logdiv, x
        ldx ZP_VAR_Q
        sec 
        sbc table_logdiv, x
        bmi _3bae
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _3ba9               ; carry is set: log(remainder) < log(Q)
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
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _3ba9
        tax 
        lda _9600, x
        sta ZP_VAR_R
        rts 

;===============================================================================

_3bc1:                                                                  ;$3BC1
        sta ZP_VAR_P3
        lda ZP_POLYOBJ_ZPOS_LO
        ora # %00000001
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_ZPOS_MI
        sta ZP_VAR_R
        lda ZP_POLYOBJ_ZPOS_HI
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
        sta ZP_VALUE_pt2
        sta ZP_VALUE_pt3
        sta ZP_VALUE_pt4
        tya 
        bpl _3c49
        lda ZP_VAR_R
_3c2d:                                                                  ;$3C2D
        asl 
        rol ZP_VALUE_pt2
        rol ZP_VALUE_pt3
        rol ZP_VALUE_pt4
        iny 
        bne _3c2d
        sta ZP_VALUE_pt1
        lda ZP_VALUE_pt4
        ora ZP_VAR_T
        sta ZP_VALUE_pt4
        rts 

;===============================================================================

_3c40:                                                                  ;$3C40
        lda ZP_VAR_R
        sta ZP_VALUE_pt1
        lda ZP_VAR_T
        sta ZP_VALUE_pt4
        rts 

        ;-----------------------------------------------------------------------

_3c49:                                                                  ;$3C49
        beq _3c40
        lda ZP_VAR_R
_3c4d:                                                                  ;$3C4D
        lsr 
        dey 
        bne _3c4d
        sta ZP_VALUE_pt1
        lda ZP_VAR_T
        sta ZP_VALUE_pt4
        rts 

;===============================================================================
; BBC code says "centre ship indicators"
; roll/pitch dampening? -- slowly reduces X to 1
;
;       X :  
;
_3c58:                                                                  ;$3C58
        lda DOCKCOM_STATE       ; is docking computer enabled?
       .bnz :+                  ; yes, skip over the following

        lda _1d06               ; is this the dampening flag?
        bne @rts                ; do not dampen

:       txa                                                             ;$3C62 
        bpl :+                  ; >= 0?

        dex                     ; decrease negative number towards zero
        bmi @rts                ; if still negative, finish

:       inx                     ; increase counter                      ;$3C68 
       .bnz @rts                ; do nothing 255/256 times
        
        dex 
       .bze :-

@rts:   rts                                                             ;$3C68 

;===============================================================================

_3c6f:                                                                  ;$3C6F
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

shoot_lasers:                                                           ;$3CDB
;===============================================================================
; pew! pew!
;
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
        lda PLAYER_TEMP_LASER
        adc # $08
        sta PLAYER_TEMP_LASER
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
        sta ZP_VAR_X2

        ; set the start point of the line, in the middle
        ; of the screen (slightly randomised, by above)
        lda VAR_06F0
        sta ZP_VAR_X1
        lda VAR_06F1
        sta ZP_VAR_Y1
        
        ; the bottom of the line is always at
        ; the bottom of the viewport
        lda # ELITE_VIEWPORT_HEIGHT - 1
        sta ZP_VAR_Y2

        ; TODO: skip validation and jump straight to
        ;       the vertical up/down line routine?
        jsr draw_line

        lda VAR_06F0
        sta ZP_VAR_X1
        lda VAR_06F1
        sta ZP_VAR_Y1
        sty ZP_VAR_X2
        lda # ELITE_VIEWPORT_HEIGHT - 1
        sta ZP_VAR_Y2

        ; TODO: skip validation and jump straight to
        ;       the vertical up/down line routine?
        jmp draw_line

;===============================================================================

_3d2f:                                                                  ;$3D2F

; from "text/text_docked.asm"
.import _1a27
.import _1a41

        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz _3d6f
       
        lda ZP_A7
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
:       lda ZP_SEED_W1_LO, x                                            ;3D71
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
        sta VAR_04C4            ; energy charge rate?

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
        bne _3d87               ; (always branches)

.ifndef OPTION_NOTRUMBLES
;///////////////////////////////////////////////////////////////////////////////

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

        jsr txt_docked_incoming_message
        jsr clear_zp_polyobj
        
        lda # $1f
        sta ZP_A5
        jsr _7c6b

        lda # 1
        jsr set_cursor_col
        
        sta ZP_POLYOBJ_ZPOS_MI
        
        ; switch to page "1"(?)
        jsr set_page

        lda # $40
        sta ZP_A3               ; move counter?
_3e01:                                                                  ;$3E01
        ldx # $7f
        stx ZP_POLYOBJ_ROLL
        stx ZP_POLYOBJ_PITCH
        jsr _9a86
        jsr _a2a0
        dec ZP_A3               ; move counter?
        bne _3e01
_3e11:                                                                  ;$3E11
        lsr ZP_POLYOBJ_XPOS_LO
        inc ZP_POLYOBJ_ZPOS_LO
        beq _3e31

        inc ZP_POLYOBJ_ZPOS_LO
        beq _3e31
        
        ldx ZP_POLYOBJ_YPOS_LO
        inx 
        cpx # $50
        bcc _3e24
        
        ldx # $50
_3e24:                                                                  ;$3E24
        stx ZP_POLYOBJ_YPOS_LO
        jsr _9a86
        jsr _a2a0
        dec ZP_A3               ; move counter?
        jmp _3e11
_3e31:                                                                  ;$3E31
        inc ZP_POLYOBJ_ZPOS_MI
        lda # $0a
        bne _3dbe               ; always branches

;===============================================================================
; insert these docked token functions from "text_docked_fns.asm"
;
.txt_docked_incoming_message                                            ;$3E37
.txt_docked_token16_17_1D                                               ;$3E41
.txt_docked_token18                                                     ;$3E7C

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
        jsr wait_for_frame
        dey 
        bne wait_frames
        rts 

;===============================================================================
; colour of different type of laser cross-hairs?
;
_3ea8:                                                                  ;$3EA8
        .byte   YELLOW, YELLOW, LTGREEN, PURPLE


;$3EAC