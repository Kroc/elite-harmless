; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.include        "elite.inc"

.include        "vars_zeropage.asm"
.include        "text/text_docked_fns.asm"
.include        "math_3d.inc"
.include        "code_keyboard.inc"

; use replacement line-drawing routines if specified
;
.ifdef  OPTION_DYME_FASTLINE
        ;///////////////////////////////////////////////////////////////////////
        .include        "draw_fastlines.inc"
.else   ;///////////////////////////////////////////////////////////////////////
        ; original Elite line-drawing routine. pretty fast actually,
        ; but it doesn't batch pixels together before writing 
        .include        "draw_lines.inc"
.endif  ;///////////////////////////////////////////////////////////////////////

; yes, I am aware that cc65 allows for 'default import of undefined labels'
; but I want to keep track of things explicitly for clarity and helping others

; from "text_flight.asm"
.import _0700:absolute
.import _0ac0:absolute

; from "vars_1D00.asm"
.import _1d01:absolute
.import _1d02:absolute
.import _1d03:absolute
.import _1d04:absolute
.import _1d05:absolute
.import _1d06:absolute
.import _1d08:absolute
.import opt_flipvert:absolute
.import opt_flipaxis:absolute
.import _1d0c:absolute
.import _1d0d:absolute
.import opt_device:absolute
.import _1d0f:absolute
.import _1d10:absolute
.import _1d11:absolute
.import _1d12:absolute
.import _1d13:absolute
.import _1d14:absolute
.import _1d21:absolute

; from "code_1D81.asm"
.import _1ec1:absolute
.import _202f:absolute
.import _2367:absolute
.import print_docked_str:absolute
.import txt_docked_token02:absolute
.import txt_docked_token0F:absolute
.import txt_flight_pair1:absolute
.import txt_flight_pair2:absolute
.import _25a6:absolute
.import _25aa:absolute
.import _25ab:absolute
.import _25b2:absolute
.import _25b3:absolute
.import _25fd:absolute
.import _25fe:absolute
.import _25ff:absolute
.import _2619:absolute
.import _267e:absolute
.import polyobj_addrs:absolute
.import polyobj_addrs_lo:absolute
.import polyobj_addrs_hi:absolute
.import _28d5:absolute
.import _28d9:absolute
.import txt_docked_token0B:absolute
.import _28e0:absolute
.import _28e5:absolute
.import _28f3:absolute
.import _2900:absolute
.import _2907:absolute
.import draw_particle:absolute
.import paint_particle:absolute
.import _2977:absolute
.import dust_swap_xy:absolute
.import _2c4e:absolute
.import _2c50:absolute
.import status_screen:absolute
.import _2d69:absolute
.import _2dc5:absolute
.import print_tiny_value:absolute
.import print_small_value:absolute
.import print_medium_value:absolute
.import print_large_value:absolute
.import txt_lcase_flag:absolute
.import txt_buffer_flag:absolute
.import txt_buffer_index:absolute
.import print_crlf:absolute
.import print_char:absolute
.import _2fee:absolute
.import _2ff3:absolute
.import _31c6:absolute
.import _32ad:absolute
.import _3385:absolute
.import _34bc:absolute
.import _3695:absolute
.import _3708:absolute
.import _3795:absolute
.import _379e:absolute
.import _37b2:absolute
.import _3895:absolute
.import _38f8:absolute
.import math_square_7bit:absolute
.import math_square:absolute
.import _399b:absolute
.import _39e0:absolute
.import _39ea:absolute
.import _3a25:absolute
.import _3a27:absolute
.import multiply_signed_into_RS:absolute
.import multiply_and_add:absolute
.import multiplied_now_add:absolute
.import _3b0d:absolute
.import _3b37:absolute
.import _3bc1:absolute
.import _3c6f:absolute
.import _3c7f:absolute
.import _3c95:absolute
.import _3d2f:absolute
.import _3ea8:absolute
.import get_polyobj:absolute
.import set_psystem_to_tsystem:absolute
.import wait_frames:absolute

; from "gfx/table_bitmap.asm"
.import row_to_bitmap_lo:absolute
.import row_to_bitmap_hi:absolute

; from "sound.asm"
.import sound_play_addr_lo:absolute
.import sound_play_addr_hi:absolute
.import _b4d2:absolute
.import sound_stop:absolute
.import _b72d:absolute
.import _c164:absolute

; from "math_data.asm"
.import table_log:absolute
.import table_logdiv:absolute
.import _9500:absolute
.import _9600:absolute
.import line_points_y:absolute
.import line_points_x:absolute

; from "gfx/hull_data.asm"
.import hull_pointers:absolute
.import hull_pointer_current_lo:absolute
.import hull_pointer_current_hi:absolute
.import hull_pointer_dodo_lo:absolute
.import hull_pointer_dodo_hi:absolute
.import hull_d042:absolute
.import hull_d062:absolute
.import hull_d083:absolute

.segment        "CODE_6A00"

_6a00:                                                                  ;$6A00
;===============================================================================
; count your current cargo in-use capacity
;
;       A = index of cargo item;
;           see `Cargo` struct for order
;
; returns:
;
;       carry unset = OK
;       carry set   = cargo overflow
;
.export _6a00

        sta VAR_04EF            ; item index?
        lda # $01
        
_6a05:                                                                  ;$6A05
;-------------------------------------------------------------------------------
;       A = initial quantity count
;
        pha                     ; preserve A
        
        ; the precious materials (gold / platinum / gems / alien items)
        ; are measured in Kg
        ;
        ldx # Cargo::minerals   ; minerals or below?
        cpx VAR_04EF            ; item index?
        bcc @kg                 ; skip ahead if precious materials

        ; count the number of tons of cargo:
        ; for each cargo type, add its quantity to the Accumulator
:       adc VAR_CARGO, x                                                ;$6A0D
        dex 
        bpl :-

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; have you ever wondered what a Trumble™ weighs? we count 1 tonne
        ; (1000 Kg) for every 256 Tumbles™, disregarding any remainder, so
        ; anywhere between 256 to 511 Trumbles™ weigh 1 tonne. one Trumble™
        ; will therfore weigh between 1.95 Kg (4.2 lb) & 3.9 Kg (8.5 lb);
        ; a bit under the weight of an average cat (4-5 Kg), except
        ; imagine several thousand of them. and now you know
        ;
        adc PLAYER_TRUMBLES_HI
.endif  ;///////////////////////////////////////////////////////////////////////
        
        ; will the selected cargo fit in your hold?
        ;
        ; carry unset = OK
        ; carry set   = overflow
        ;
        cmp SHIP_HOLD           ; compare cargo capacity of the player's ship
        
        pla                     ; restore A
        rts

@kg:                                                                    ;$6A1B
        ;-----------------------------------------------------------------------
        ; will the selected cargo fit? for precious materials, the limit
        ; is 200 Kg, not taken from your ships hold capacity. maybe you
        ; stuff it behind your seat?
        ;
        ; carry unset = OK
        ; carry set   = overflow
        ;
        ldy VAR_04EF
        adc VAR_CARGO, y        ; number of Kg of selected item
        cmp # 200               ; maximum of 200 Kg

        pla                     ; restore A
        rts 

set_cursor_col:                                                         ;$6A25
;===============================================================================
; set the cursor column (where text printing occurs)
;
;     A = column number
;
.export set_cursor_col

        sta ZP_CURSOR_COL
        rts 

set_cursor_row:                                                         ;$6A28
;===============================================================================
; set the cursor row (where text printing occurs)
;
;     A = row number
;
.export set_cursor_row

        sta ZP_CURSOR_ROW
        rts 

cursor_down:                                                            ;$6A2B
;===============================================================================
; move the cursor down a row (does not change column!)
;
.export cursor_down

        inc ZP_CURSOR_ROW
        rts 

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; stubbed-out routine in the original code
;
_6a2e:                                                                  ;$6A2E
        rts 
;///////////////////////////////////////////////////////////////////////////////
.endif 

_6a2f:                                                                  ;$6A2F
;===============================================================================
; changes page and does some other pre-emptive work?
;
;       A = page ID to change to
;
.export _6a2f

        jsr set_page

        jsr _28d5               ; loads A & X with $0F
        lda # $30

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////
        
        rts 

randomize:                                                              ;$6A3B
;===============================================================================
; moves the random number generator along 4 steps to produce
; fresh random numbers, but does not return a random number
;
.export randomize

        ; this routine calls itself 4 times to ensure
        ; enough scrambling of the random number

        jsr :+                  ; do this twice,
:       jsr randomize_once      ; and that twice                        ;$6A3E

randomize_once:                                                         ;$6A41
        ;=======================================================================
        lda ZP_SEED_W0_LO
        clc 
        adc ZP_SEED_W1_LO
        tax 
        lda ZP_SEED_W0_HI
        adc ZP_SEED_W1_HI
        tay 
        lda ZP_SEED_W1_LO
        sta ZP_SEED_W0_LO
        lda ZP_SEED_W1_HI
        sta ZP_SEED_W0_HI
        lda ZP_SEED_W2_HI
        sta ZP_SEED_W1_HI
        lda ZP_SEED_W2_LO
        sta ZP_SEED_W1_LO
        clc 
        txa 
        adc ZP_SEED_W1_LO
        sta ZP_SEED_W2_LO
        tya 
        adc ZP_SEED_W1_HI
        sta ZP_SEED_W2_HI
        
        rts 

_6a68:                                                                  ;$6A68
;===============================================================================
        ; is target system distance > 0
        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz :+

        jmp cursor_down

        ;-----------------------------------------------------------------------
        ; print "DISTANCE:"
        ;
.import TXT_DISTANCE:direct

:       lda # TXT_DISTANCE                                              ;$6A73
        jsr print_flight_token_with_colon

        ; print the distance as a fixed-point decimal, e.g. "6.4"
        ldx TSYSTEM_DISTANCE_LO
        ldy TSYSTEM_DISTANCE_HI
        sec                             ; carry set = use decimal point
        jsr print_num16                 ; print number in X/Y

        ; print "LIGHT YEARS"
        ;
.import TXT_LIGHT_YEARS:direct
        lda # TXT_LIGHT_YEARS

_6a84:                                                                  ;$6A84
        ;-----------------------------------------------------------------------
        jsr print_flight_token
_6a87:                                                                  ;$6A87
        jsr cursor_down
_6a8a:                                                                  ;$6A8A
        lda # %10000000
        sta ZP_34

print_newline:                                                          ;$6A8E
        ;-----------------------------------------------------------------------
        lda # TXT_NEWLINE
        jmp print_flight_token

_6a93:                                                                  ;$6A93
        ;=======================================================================
        ; print "MAINLY"
        ;
.import TXT_MAINLY:direct
        lda # TXT_MAINLY
        jsr print_flight_token
        jmp _6ad3

_6a9b:                                                                  ;$6A9B
;===============================================================================
.export _6a9b
        jsr print_flight_token
        jmp print_space

;===============================================================================
; planetary information screen
;
planet_screen:                                                          ;$6AA1

        ; switch to planetary information page
        lda # $01
        jsr _6a2f

        lda # 9
        jsr set_cursor_col
        
        ; print "DATA ON " ...
.import TXT_DATA_ON:direct
        lda # TXT_DATA_ON
        jsr _28d9

        jsr _6a87
        jsr _6a68

        ; print "ECONOMY:"
.import TXT_ECONOMY:direct
        lda # TXT_ECONOMY
        jsr print_flight_token_with_colon

        ; is this a "MAINLY" economy?
        lda TSYSTEM_ECONOMY
        clc 
        adc # $01
        lsr 
        cmp # $02
        beq _6a93

        lda TSYSTEM_ECONOMY
        bcc _6ace
        
        sbc # $05
        clc 
_6ace:                                                                  ;$6ACE
.import TXT_RICH:direct
        
        ; "RICH" / "AVERAGE" / "POOR"
        ;
        adc # TXT_RICH
        jsr print_flight_token
_6ad3:                                                                  ;$6AD3
        lda TSYSTEM_ECONOMY
        lsr 
        lsr 

.import TXT_INDUSTRIAL:direct

        ; "INDUSTRIAL" / "AGRICULTURAL"

        clc 
        adc # TXT_INDUSTRIAL
        jsr _6a84

.import TXT_GOVERNMENT:direct
        lda # TXT_GOVERNMENT
        jsr print_flight_token_with_colon
        
.import TXT_ANARCHY:direct

        ; "ANARCHY" / "FEUDAL" / "MULTI-GOVERNMENT" / "DICTATORSHIP" /
        ; "COMMUNIST" / "CONFEDORACY" / "DEMOCRACY" / "CORPORATE STATE"

        lda TSYSTEM_GOVERNMENT
        clc 
        adc # TXT_ANARCHY
        jsr _6a84

.import TXT_TECH_LEVEL:direct
        lda # TXT_TECH_LEVEL
        jsr print_flight_token_with_colon
        
        ldx TSYSTEM_TECHLEVEL
        inx 
        clc 
        jsr print_tiny_value
        jsr _6a87

.import TXT_POPULATION:direct
        lda # TXT_POPULATION
        jsr print_flight_token_with_colon
        
        sec 
        ldx TSYSTEM_POPULATION
        jsr print_tiny_value

.import TXT_BILLION:direct
        lda # TXT_BILLION
        jsr _6a84

        lda # '('
        jsr print_flight_token
        
        lda ZP_SEED_W2_LO
        bmi :+

.import TXT_HUMAN_COLONIAL:direct
        lda # TXT_HUMAN_COLONIAL
        jsr print_flight_token
        
        jmp _6b5a

:       lda ZP_SEED_W2_HI                                               ;$61BE
        lsr 
        lsr 
        pha 
        and # %00000111
        cmp # $03
        bcs :+
        
.import TXT_LARGE:direct

        ; "LARGE" / "FIERCE" / "SMALL" / ?
        
        adc # TXT_LARGE
        jsr _6a9b
:       pla                                                             ;$6B2E
        lsr 
        lsr 
        lsr 
        cmp # $06
        bcs _6b3b

.import TXT_COLORS:direct

        ; "GREEN" / "RED" / "YELLOW" / "BLUE" / "BLACK" / ?

        adc # TXT_COLORS
        jsr _6a9b
_6b3b:                                                                  ;$6B3B
        lda ZP_SEED_W1_HI
        eor ZP_SEED_W0_HI
        and # %00000111
        sta ZP_8E
        cmp # $06
        bcs _6b4c

.import TXT_ADJECTIVES:direct

        ; "HARMLESS" / "SLIMY" / "BUG-EYED" / "HORNED" /
        ; "BONY" / "FAT" / "FURRY"

        adc # TXT_ADJECTIVES+1  ; +1, because of borrow?
        jsr _6a9b
_6b4c:                                                                  ;$6B4C
        lda ZP_SEED_W2_HI
        and # %00000011
        clc 
        adc ZP_8E
        and # %00000111
        
.import TXT_SPECIES:direct

        ; "RODENT" / "FROG" / "LIZARD" / "LOBSTER" / "BIRD" / "HUMANOID" /
        ; "FELINE" / "INSECT"

        adc # TXT_SPECIES
        jsr print_flight_token
_6b5a:                                                                  ;$6B5A
        ; append an "s"
        lda # 's'
        jsr print_flight_token

        lda # ')'
        jsr _6a84

.import TXT_GROSS_PRODUCTIVITY:direct
        lda # TXT_GROSS_PRODUCTIVITY
        jsr print_flight_token_with_colon
        
        ldx TSYSTEM_PRODUCTIVITY_LO
        ldy TSYSTEM_PRODUCTIVITY_HI
        jsr print_int16
        jsr print_space
        lda # $00
        sta ZP_34
        
        lda # 'm'
        jsr print_flight_token
        
.import TXT_CR:direct
        lda # TXT_CR
        jsr _6a84

.import TXT_AVERAGE_RADIUS:direct
        lda # TXT_AVERAGE_RADIUS
        jsr print_flight_token_with_colon
        
        ; extract the avergae planet radius from the seed
        ;
        lda ZP_SEED_W2_HI
        ldx ZP_SEED_W1_HI
        and # %00001111
        
        ; add the minimum scale factor; this ensures that all planets
        ; have a radius of at least 256*11, avoiding a planet of radius 0!
        clc 
        adc # 11
        
        tay 
        jsr print_num16
        jsr print_space

        ; print "KM" (Kilometers)
        ;
        lda # $6b               ;="K"
        jsr print_char
        lda # $6d               ;="M"
        jsr print_char
        
        jsr _6a87
;6ba5?
        jmp _3d2f

        rts 

;===============================================================================
; extract target planet information
;
; a more visual guide to the way planet information
; is generated from the seed can be seen here:
; http://wiki.alioth.net/index.php/Random_number_generator
; 
_6ba9:                                                                  ;$6BA9
        lda ZP_SEED_W0_HI
        and # %00000111
        sta TSYSTEM_ECONOMY

        lda ZP_SEED_W1_LO
        lsr 
        lsr 
        lsr 
        and # %00000111
        sta TSYSTEM_GOVERNMENT
        
        lsr 
        bne :+
        lda TSYSTEM_ECONOMY
        ora # %00000010
        sta TSYSTEM_ECONOMY
:       lda TSYSTEM_ECONOMY                                              ;$6BC5
        eor # %00000111
        clc 
        sta TSYSTEM_TECHLEVEL

        lda ZP_SEED_W1_HI
        and # %00000011
        adc TSYSTEM_TECHLEVEL
        sta TSYSTEM_TECHLEVEL
        
        lda TSYSTEM_GOVERNMENT
        lsr 
        adc TSYSTEM_TECHLEVEL
        sta TSYSTEM_TECHLEVEL
        
        asl 
        asl 
        adc TSYSTEM_ECONOMY
        adc TSYSTEM_GOVERNMENT
        adc # $01
        sta TSYSTEM_POPULATION
        
        lda TSYSTEM_ECONOMY
        eor # %00000111
        adc # $03
        sta ZP_VAR_P
        
        lda TSYSTEM_GOVERNMENT
        adc # $04
        sta ZP_VAR_Q
        
        jsr _399b
        
        lda TSYSTEM_POPULATION
        sta ZP_VAR_Q
        
        jsr _399b
        
        asl ZP_VAR_P
        rol 
        asl ZP_VAR_P
        rol 
        asl ZP_VAR_P
        rol 
        sta TSYSTEM_PRODUCTIVITY_HI
        
        lda ZP_VAR_P
        sta TSYSTEM_PRODUCTIVITY_LO
        
        rts 

;===============================================================================
; galactic chart
;
galactic_chart:                                                         ;$6C1C

        lda # $40               ; page-ID for galactic chart
        jsr set_page            ; switch pages, clearing the screen
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # $10
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////
        lda # 7
        jsr set_cursor_col
        
        jsr _70a0

.import TXT_GALACTIC_CHART:direct
        lda # TXT_GALACTIC_CHART
        jsr print_flight_token
        
        jsr _28e0               ; cursor down 23 times!!!
                                ; (clear HUD colours off screen?)
        
        ; draw line across bottom of chart?
        ;
        lda # $98               ; Y=152
        jsr _28e5

        jsr _6cda

        ; draw stars on galactic chart
        ldx # $00
_6c40:                                                                  ;$6C40
        ;-----------------------------------------------------------------------
        stx ZP_9D               ; current star index?
        ldx ZP_SEED_W1_HI
        ldy ZP_SEED_W2_LO
        tya 
        ora # %01010000
        sta ZP_VAR_Z            ; star size?

        lda ZP_SEED_W0_HI
        lsr 
        clc 
        adc # $18
        sta ZP_VAR_Y
        
        jsr paint_particle

        jsr randomize
        ldx ZP_9D               ; retrieve star index
        inx                     ; move to next star
       .bnz _6c40               ; more stars to draw?

        ;-----------------------------------------------------------------------

        lda TSYSTEM_POS_X
        sta ZP_8E
        lda TSYSTEM_POS_Y
        lsr 
        sta ZP_8F
        lda # $04
        sta ZP_90
_6c6d:                                                                  ;$6C6D
        lda # $18
        ldx ZP_SCREEN
        bpl _6c75
        lda # $00
_6c75:                                                                  ;$6C75
        sta ZP_93
        lda ZP_8E
        sec 
        sbc ZP_90
        bcs _6c80
        lda # $00
_6c80:                                                                  ;$6C80
        sta ZP_VAR_X
        lda ZP_8E
        clc 
        adc ZP_90
        bcc _6c8b
        lda # $ff
_6c8b:                                                                  ;$6C8B
        sta ZP_VAR_X2
        lda ZP_8F
        clc 
        adc ZP_93
        sta ZP_VAR_Y1
        sta ZP_VAR_Y2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line
        lda ZP_8F
        sec 
        sbc ZP_90
        bcs _6ca2
        lda # $00
_6ca2:                                                                  ;$6CA2
        clc 
        adc ZP_93
        sta ZP_VAR_Y
        lda ZP_8F
        clc 
        adc ZP_90
        adc ZP_93
        cmp # $98
        bcc _6cb8
        ldx ZP_SCREEN
        bmi _6cb8
        lda # $97
_6cb8:                                                                  ;$6CB8
        sta ZP_VAR_Y2
        lda ZP_8E
        sta ZP_VAR_X1
        sta ZP_VAR_X2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jmp draw_line

;===============================================================================

dial_addr = ELITE_BITMAP_ADDR + .bmppos(21, 5)

_6cc3:                                                                  ;$6CC3
        lda #< dial_addr
        sta ZP_8E
        lda #> dial_addr
        sta ZP_8F
        lda # $10
        sta ZP_90
        jsr _6c6d
        lda PLAYER_FUEL
        sta ZP_VALUE_pt1
        jmp _6cfe

_6cda:                                                                  ;$6CDA
        lda ZP_SCREEN
        bmi _6cc3

        lda PLAYER_FUEL
        lsr 
        lsr 
        sta ZP_VALUE_pt1

        lda PSYSTEM_POS_X
        sta ZP_8E
        
        lda PSYSTEM_POS_Y
        lsr 
        sta ZP_8F
        
        lda # $07
        sta ZP_90
        
        jsr _6c6d
        
        lda ZP_8F
        clc 
        adc # $18
        sta ZP_8F
_6cfe:                                                                  ;$6CFE
        lda ZP_8E
        sta ZP_POLYOBJ01_XPOS_pt1
        
        lda ZP_8F
        sta ZP_43
        
        ldx # $00
        stx ZP_44
        stx ZP_POLYOBJ01_XPOS_pt2
        
        inx 
        stx ZP_7E
        
        ldx # $02
        stx ZP_AC
        
        jmp _805e

;===============================================================================
; buy cargo screen
;
buy_screen:                                                             ;$6D16

        ; switch to page "2"(?)
        lda # $02
        jsr _6a2f

        jsr _72db

        lda # $80
        sta ZP_34
        
        lda # $00
        sta VAR_04EF            ; item index?
_6d27:                                                                  ;$6D27
        jsr _7246
        lda VAR_04ED
        bne _6d3e
        jmp _6da4

_6d32:                                                                  ;$6D32
        ldy # $b0
_6d34:                                                                  ;$6D34
        jsr print_space
        tya 
        jsr _723c
        jsr _7627
_6d3e:                                                                  ;$6D3E
        jsr txt_docked_token15
        
.import TXT_QUANTITY_OF:direct
        lda # TXT_QUANTITY_OF
        jsr print_flight_token

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"
.import TXT_FOOD:direct

        lda VAR_04EF            ; item index?
        clc 
        adc # TXT_FOOD
        jsr print_flight_token
        
        lda # $2f
        jsr print_flight_token
        
        jsr _72b8

        lda # $3f
        jsr print_flight_token
        
        jsr print_newline
        ldx # $00
        stx ZP_VAR_R
        ldx # $0c
        stx ZP_TEMP_VAR
        jsr _6dc9
        bcs _6d32
        sta ZP_VAR_P1
        jsr _6a05               ; count cargo
        ldy # $ce
        lda ZP_VAR_R
        beq _6d79
        bcs _6d34
_6d79:                                                                  ;$6D79
        lda VAR_04EC
        sta ZP_VAR_Q
        jsr _74a2
        jsr _745a
        ldy # $c5
        bcc _6d34
        ldy VAR_04EF            ; item index?
        lda ZP_VAR_R
        pha 
        clc 
        adc VAR_CARGO, y
        sta VAR_CARGO, y
        lda VAR_MARKET_FOOD, y  ; update quantity available for sale?
        sec 
        sbc ZP_VAR_R
        sta VAR_MARKET_FOOD, y  ; quantity available for sale?
        pla 
        beq _6da4
        jsr _761f
_6da4:                                                                  ;$6DA4
        lda VAR_04EF            ; item index?
        clc 
        adc # 5
        jsr set_cursor_row
        lda # 0
        jsr set_cursor_col
        
        inc VAR_04EF            ; item index?
        lda VAR_04EF            ; item index?
        cmp # $11
        bcs _6dbf
        jmp _6d27
_6dbf:                                                                  ;$6DBF
        lda # $10
        sta VAR_050C
        lda # $20
        jmp _86a4

_6dc9:                                                                  ;$6DC9
        lda # $40
        sta VAR_050C
        ldx # $00
        stx ZP_VAR_R
        ldx # $0c
        stx ZP_TEMP_VAR
_6dd6:                                                                  ;$6DD6
        jsr _8fea
        ldx ZP_VAR_R
        bne _6de5
        cmp # $59
        beq _6e1b
        cmp # $4e
        beq _6e26
_6de5:                                                                  ;$6DE5
        sta ZP_VAR_Q
        sec 
        sbc # $30
        bcc _6e13
        cmp # $0a
        bcs _6dbf
        sta ZP_VAR_S
        lda ZP_VAR_R
        cmp # $1a
        bcs _6e13
        asl 
        sta ZP_VAR_T
        asl 
        asl 
        adc ZP_VAR_T
        adc ZP_VAR_S
        sta ZP_VAR_R
        cmp VAR_04ED
        beq _6e0a
        bcs _6e13
_6e0a:                                                                  ;$6E0A
        lda ZP_VAR_Q
        jsr print_char

        dec ZP_TEMP_VAR
        bne _6dd6
_6e13:                                                                  ;$6E13
        lda # $10
        sta VAR_050C
        lda ZP_VAR_R
        rts 
_6e1b:                                                                  ;$6E1b
        jsr print_char
        lda VAR_04ED
        sta ZP_VAR_R
        jmp _6e13
_6e26:                                                                  ;$6E26
        jsr print_char
        lda # $00
        sta ZP_VAR_R
        jmp _6e13
_6e30:                                                                  ;$6E30
        jsr print_newline

.import TXT_QUANTITY:direct
        lda # TXT_QUANTITY
        jsr _723c

        jsr _7627
        ldy VAR_04EF            ; item index?
        jmp _6e5d

;===============================================================================
; sell cargo screen
;
sell_cargo:                                                             ;$6E41
        ; switch to page "4"(?)
        lda # $04
        jsr _6a2f

        lda # 10
        jsr set_cursor_col
        
.import TXT_SELL:direct
        lda # TXT_SELL
        jsr print_flight_token

.import TXT_CARGO:direct
        lda # TXT_CARGO
        jsr _28d9

        jsr print_newline
_6e58:                                                                  ;$6E58
        ldy # $00
_6e5a:                                                                  ;$6E5a
        sty VAR_04EF            ; item index?
_6e5d:                                                                  ;$6E5d
        ldx VAR_CARGO, y        ; cargo qty?
       .bze _6eca               ; none of that cargo

        tya 
        asl 
        asl 
        tay 
        lda _90a6, y
        sta ZP_8F
       .phx                     ; push X to stack (via A)
        jsr _6a8a
        
        clc 
        lda VAR_04EF            ; item index?

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"

.import TXT_FOOD:direct
        adc # TXT_FOOD
        jsr print_flight_token

        lda # 14
        jsr set_cursor_col
        
        pla 
        tax 
        sta VAR_04ED
        clc 
        jsr print_tiny_value
        jsr _72b8

        lda ZP_SCREEN
        cmp # $04
        bne _6eca

.import TXT_SELL:direct
        lda # TXT_SELL
        jsr print_flight_token
        
        lda # $ce
        jsr print_docked_str

        jsr _6dc9
        beq _6eca
        bcs _6e30
        lda VAR_04EF            ; item index?
        
        ldx # $ff
        stx ZP_34
        jsr _7246
        ldy VAR_04EF            ; item index?
        lda VAR_CARGO, y
        sec 
        sbc ZP_VAR_R
        sta VAR_CARGO, y
        lda ZP_VAR_R
        sta ZP_VAR_P1
        lda VAR_04EC
        sta ZP_VAR_Q
        jsr _74a2
        jsr _7481
        
        lda # $00
        sta ZP_34
_6eca:                                                                  ;$6ECA
        ldy VAR_04EF            ; item index?
        iny 
        cpy # $11
        bcc _6e5a

        lda ZP_SCREEN
        cmp # $04
        bne _6ede
        
        jsr _7627
        jmp _6dbf
_6ede:                                                                  ;$6EDE
        jsr _6a8a
        lda PLAYER_TRUMBLES_LO
        ora PLAYER_TRUMBLES_HI
        bne _6eea
_6ee9:                                                                  ;$6EE9
        rts 

_6eea:                                                                  ;$6EEA
        ;-----------------------------------------------------------------------
        ; have you got Trumbles™ in your hold?
        ;
        clc                     ; "no decimal point"
        lda # $00               ; "no padding"
        ldx PLAYER_TRUMBLES_LO
        ldy PLAYER_TRUMBLES_HI
        jsr print_medium_value

        ; get a 'random' number between 0 & 3
        jsr get_random_number
        and # %00000011

        ; print "CUDDLY" / "CUTE" / "FURRY" or "FRIENDLY"
.import TXT_DOCKED_CUDDLY:direct

        clc 
        adc # TXT_DOCKED_CUDDLY
        jsr print_docked_str
        
        ; print "LITTLE TRUMBLE"
.import TXT_DOCKED_LITTLE_TRUMBLE:direct
        lda # TXT_DOCKED_LITTLE_TRUMBLE
        jsr print_docked_str
        
        ; more than 1?
        lda PLAYER_TRUMBLES_HI
       .bnz :+
        ldx PLAYER_TRUMBLES_LO
        dex 
        beq _6ee9
        
:       lda # $73               ;="S"                                   ;$6F11
        jmp print_char

;===============================================================================
; inventory screen
;
inventory_screen:                                                       ;$6F16

        lda # $08
        jsr _6a2f

        lda # 11
        jsr set_cursor_col
        
.import TXT_INVENTORY:direct
        lda # TXT_INVENTORY
        jsr _6a84

        jsr txt_docked_token0B
        jsr print_fuel_and_cash
        lda SHIP_HOLD            ; cargo capacity of the player's ship
        cmp # $1a
        bcc _6f37

.import TXT_LARGE_CARGO_BAY:direct
        lda # TXT_LARGE_CARGO_BAY
        jsr print_flight_token
_6f37:                                                                  ;$6F37
        jmp _6e58

;===============================================================================

; dead code?

_6f3a:                                                                  ;$6F3a
        jsr print_flight_token

        lda # $ce
        jsr print_docked_str

        jsr _8fea
        ora # %00100000
        cmp # $79
        beq _6f50

        lda # $6e               ;="N"
        jmp print_char
_6f50:                                                                  ;$6F50
        jsr print_char
        sec 
        rts 

;===============================================================================

_6f55:                                                                  ;$6F55
       .phx                     ; push X to stack (via A)
        dey 
        tya 
        eor # %11111111
        pha 
        jsr wait_for_frame
        jsr _6f82
        pla 
        sta ZP_91

        lda TSYSTEM_POS_Y
        jsr _6f98
        
        lda ZP_92
        sta TSYSTEM_POS_Y
        sta ZP_8F
        
        pla 
        sta ZP_91
        
        lda TSYSTEM_POS_X
        jsr _6f98
        
        lda ZP_92
        sta TSYSTEM_POS_X
        sta ZP_8E
_6f82:                                                                  ;$6F82
.export _6f82
        lda ZP_SCREEN
        bmi _6fa9

        lda TSYSTEM_POS_X
        sta ZP_8E
        lda TSYSTEM_POS_Y
        lsr 
        sta ZP_8F
        lda # $04
        sta ZP_90
        jmp _6c6d
_6f98:                                                                  ;$6F98
        sta ZP_92
        clc 
        adc ZP_91
        ldx ZP_91
        bmi _6fa4
        bcc _6fa6
        rts 

_6fa4:                                                                  ;$6FA4
        bcc _6fa8
_6fa6:                                                                  ;$6FA6
        sta ZP_92
_6fa8:                                                                  ;$6FA8
        rts 

_6fa9:                                                                  ;$6FA9
        lda TSYSTEM_POS_X
        sec 
        sbc PSYSTEM_POS_X
        cmp # $26
        bcc _6fb8
        cmp # $e6
        bcc _6fa8
_6fb8:                                                                  ;$6FB8
        asl 
        asl 
        clc 
        adc # $68
        sta ZP_8E
        lda TSYSTEM_POS_Y
        sec 
        sbc PSYSTEM_POS_Y
        cmp # $26
        bcc _6fce
        cmp # $dc
        bcc _6fa8
_6fce:                                                                  ;$6FCE
        asl 
        clc 
        adc # $5a
        sta ZP_8F
        lda # $08
        sta ZP_90
        jmp _6c6d

;===============================================================================
; short-range (local) chart
;
local_chart:                                                            ;$6FDB

        lda # $c7
        sta ZP_B8
        sta ZP_B7

        lda # $80               ; screen-ID for short-range (local) chart
        jsr set_page            ; switch pages, clearing the screen
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # $10
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # 7
        jsr set_cursor_col
        
.import TXT_SHORT_RANGE_CHART:direct
        lda # TXT_SHORT_RANGE_CHART
        jsr _28d9

        jsr _6cda
        jsr _6f82
        jsr _70a0
        lda # $00
        sta ZP_AE
        ldx # $18
_7004:                                                                  ;$7004
        sta ZP_POLYOBJ_XPOS_LO, x
        dex 
        bpl _7004
_7009:                                                                  ;$7009
        lda ZP_SEED_W1_HI
        sec 
        sbc PSYSTEM_POS_X
        bcs _7015
        eor # %11111111
        adc # $01
_7015:                                                                  ;$7015
        cmp # $14
        bcs _708d
        lda ZP_SEED_W0_HI
        sec 
        sbc PSYSTEM_POS_Y
        bcs _7025
        eor # %11111111
        adc # $01
_7025:                                                                  ;$7025
        cmp # $26
        bcs _708d
        lda ZP_SEED_W1_HI
        sec 
        sbc PSYSTEM_POS_X
        asl 
        asl 
        adc # $68
        sta ZP_71
        lsr 
        lsr 
        lsr 
        clc 
        adc # 1
        jsr set_cursor_col

        lda ZP_SEED_W0_HI
        sec 
        sbc PSYSTEM_POS_Y
        asl 
        adc # $5a
        sta ZP_43
        
        lsr 
        lsr 
        lsr 
        tay 
        ldx ZP_POLYOBJ_XPOS_LO, y
        beq _705c
        iny 
        ldx ZP_POLYOBJ_XPOS_LO, y
        beq _705c
        dey 
        dey 
        ldx ZP_POLYOBJ_XPOS_LO, y
        bne _7070
_705c:                                                                  ;$705C
        tya 
        jsr set_cursor_row

        cpy # $03
        bcc _708d
        lda # $ff
        sta ZP_POLYOBJ_XPOS_LO, y
        
        lda # $80
        sta ZP_34
        
        jsr _76e9
_7070:                                                                  ;$7070
        lda # $00
        sta ZP_POLYOBJ01_XPOS_pt2
        sta ZP_44
        sta ZP_VALUE_pt2

        lda ZP_71
        sta ZP_POLYOBJ01_XPOS_pt1
        lda ZP_SEED_W2_HI
        and # %00000001
        adc # $02
        sta ZP_VALUE_pt1
        jsr _7b4f
        jsr _7f22
        jsr _7b4f
_708d:                                                                  ;$708D
        jsr randomize
        inc ZP_AE
        beq _7097
        jmp _7009

_7097:                                                                  ;$7097
        lda #< $8F00            ;?
        sta ZP_B7
        lda #> $8F00            ;?
        sta ZP_B8

        rts 

;===============================================================================

; to do with the seed

_70a0:                                                                  ;$70A0
.export _70a0
        ldx # 5                 ; seed is 6 bytes
_70a2:                                                                  ;$70A2
        lda VAR_049C, x
        sta ZP_SEED, x          ; store at $7F...$84
        dex 
        bpl _70a2
        rts 

;===============================================================================

_70ab:                                                                  ;$70AB
.export _70ab
        jsr _70a0
        ldy # $7f
        sty ZP_VAR_T
        lda # $00
        sta ZP_VAR_U
_70b6:                                                                  ;$70B6
        lda ZP_SEED_W1_HI
        sec 
        sbc TSYSTEM_POS_X
        bcs _70c2
        eor # %11111111
        adc # $01
_70c2:                                                                  ;$70C2
        lsr 
        sta ZP_VAR_S
        lda ZP_SEED_W0_HI
        sec 
        sbc TSYSTEM_POS_Y
        bcs _70d1
        eor # %11111111
        adc # $01
_70d1:                                                                  ;$70D1
        lsr 
        clc 
        adc ZP_VAR_S
        cmp ZP_VAR_T
        bcs _70e8
        sta ZP_VAR_T
        ldx # 5
_70dd:                                                                  ;$70DD
        lda ZP_SEED, x
        sta ZP_8E, x
        dex 
        bpl _70dd
        lda ZP_VAR_U
        sta ZP_VAR_Z
_70e8:                                                                  ;$70E8
        jsr randomize
        inc ZP_VAR_U
        bne _70b6
        ldx # $05
_70f1:                                                                  ;$70F1
        lda ZP_8E, x
        sta ZP_SEED, x
        dex 
        bpl _70f1

        ; select a random planet?

        lda ZP_SEED_W0_HI
        sta TSYSTEM_POS_Y
        lda ZP_SEED_W1_HI
        sta TSYSTEM_POS_X
        
        sec 
        sbc PSYSTEM_POS_X
        bcs :+
        eor # %11111111
        adc # $01
:       jsr math_square                                                 ;$710C
        sta ZP_VALUE_pt2

        lda ZP_VAR_P1
        sta ZP_VALUE_pt1
        lda TSYSTEM_POS_Y
        sec 
        sbc PSYSTEM_POS_Y
        bcs _7122
        eor # %11111111
        adc # $01
_7122:                                                                  ;$7122
        lsr 
        jsr math_square
        pha 
        lda ZP_VAR_P1
        clc 
        adc ZP_VALUE_pt1
        sta ZP_VAR_Q
        pla 
        adc ZP_VALUE_pt2
        bcc _7135
        lda # $ff
_7135:                                                                  ;$7135
        sta ZP_VAR_R
        jsr _9978
        lda ZP_VAR_Q
        asl 
        ldx # $00
        stx TSYSTEM_DISTANCE_HI
        rol TSYSTEM_DISTANCE_HI
        asl 
        rol TSYSTEM_DISTANCE_HI
        sta TSYSTEM_DISTANCE_LO
        jmp _6ba9

;===============================================================================

_714f:                                                                  ;$714F
        jsr txt_docked_token15

        lda # 15
        jsr set_cursor_col

        ; print "DOCKED"...
.import TXT_DOCKED_DOCKED:direct
        lda # TXT_DOCKED_DOCKED
        jmp print_docked_str

_715c:                                                                  ;$715C
        lda ZP_A7
        bne _714f

        lda ZP_66               ; hyperspace countdown (outer)?
        beq _7165
        
        rts 

_7165:                                                                  ;$7165
        jsr get_ctrl
        bmi _71ca

        ; are we in the cockpit-view?
        lda ZP_SCREEN
        beq _71c4

        and # %11000000
        bne _7173
        
        rts 

_7173:                                                                  ;$7173
        jsr _7695
_7176:                                                                  ;$7176
        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
        bne _717f
        rts 

_717f:                                                                  ;$717F
        ldx # 5
_7181:                                                                  ;$7181
        lda ZP_SEED, x
        sta VAR_04FA, x
        dex 
        bpl _7181

        lda # 7
        jsr set_cursor_col
        
        lda # $17
        ldy ZP_SCREEN
        bne _7196

        lda # $11
_7196:                                                                  ;$7196
        jsr set_cursor_row
        lda # $00
        sta ZP_34

.import TXT_HYPERSPACE:direct
        lda # TXT_HYPERSPACE
        jsr print_flight_token
        
        lda TSYSTEM_DISTANCE_HI
        bne _71af
        lda PLAYER_FUEL
        cmp TSYSTEM_DISTANCE_LO
        bcs _71b2
_71af:                                                                  ;$71AF
        jmp _723a

_71b2:                                                                  ;$71B2
        lda # $2d
        jsr print_flight_token

        jsr _76e9
        lda # $0f
_71bc:                                                                  ;$71BC
        sta ZP_66               ; hyperspace countdown -- outer
        sta ZP_65               ; hyperspace countdown -- inner
        tax 
        jmp _7224

_71c4:                                                                  ;$71C4
        jsr _70ab
        jmp _7176

_71ca:                                                                  ;$71CA
        ldx PLAYER_GDRIVE
        beq _71f2 + 1              ; bug or optimisation?
        inx 
        stx PLAYER_GDRIVE
        stx PLAYER_LEGAL
        lda # $02
        jsr _71bc
        ldx # $05
        inc PLAYER_GALAXY
        lda PLAYER_GALAXY
        and # %11110111
        sta PLAYER_GALAXY
_71e8:                                                                  ;$71E8
        lda VAR_049C, x
        asl 
        rol VAR_049C, x
        dex 
        bpl _71e8
_71f2:  ; the $60 also forms an RTS, jumped to from just after _71ca    ;$71F2
        lda # $60

;71f4:
         sta TSYSTEM_POS_X
         sta TSYSTEM_POS_Y
         jsr _741c
         jsr _70ab
         ldx # $05
_7202:                                                                  ;$7202
        lda ZP_SEED, x
        sta VAR_04FA, x
        dex 
        bpl _7202
        ldx # $00
        stx TSYSTEM_DISTANCE_LO
        stx TSYSTEM_DISTANCE_HI
        lda # $74
        jsr _900d
_7217:                                                                  ;$7217
        lda TSYSTEM_POS_X
        sta PSYSTEM_POS_X
        lda TSYSTEM_POS_Y
        sta PSYSTEM_POS_Y
        rts 

_7224:                                                                  ;$7224
;===============================================================================
        lda # 1
        jsr set_cursor_col
        jsr set_cursor_row
        
        ldy # $00
        clc 
        lda # $03
        jmp print_medium_value


print_int16:                                                            ;$7234
        ;=======================================================================
        ; print 16-bit value in X/Y, without decimal point
        ;
        clc 

print_num16:                                                            ;$7235
        ;=======================================================================
        ; print 16-bit value in X/Y -- decimal point included if carry set
        ;
        lda # $05               ; max. no. digits -- is this 5 or 6?
        jmp print_medium_value

_723a:                                                                  ;$723A
.import TXT_RANGE:direct
        lda # TXT_RANGE

_723c:                                                                  ;$723C
        jsr print_flight_token

        lda # $3f
        jmp print_flight_token

;===============================================================================

_7244:                                                                  ;$7244
        pla 
        rts 

_7246:                                                                  ;$7246
        pha 
        sta ZP_92
        asl 
        asl 
        sta ZP_8E
        lda IS_WITCHSPACE
        bne _7244

        lda # 1
        jsr set_cursor_col
        
        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"
.import TXT_FOOD:direct

        pla 
        adc # TXT_FOOD
        jsr print_flight_token

        lda # 14
        jsr set_cursor_col
        
        ldx ZP_8E
        lda _90a6, x
        sta ZP_8F
        lda VAR_04DF
        and _90a8, x
        clc 
        adc _90a5, x
        sta VAR_04EC
        jsr _72b8
        jsr _731a
        lda ZP_8F
        bmi _7288
        lda VAR_04EC
        adc ZP_91
        jmp _728e

_7288:                                                                  ;$7288
        lda VAR_04EC
        sec 
        sbc ZP_91
_728e:                                                                  ;$728E
        sta VAR_04EC
        sta ZP_VAR_P1
        lda # $00
        jsr _74a5
        sec 
        jsr print_num16

        ldy ZP_92
        lda # $05
        ldx VAR_MARKET_FOOD, y
        stx VAR_04ED
        clc 
        beq _72af
        jsr print_small_value
        jmp _72b8
_72af:                                                                  ;$72AF
        lda # 25
        jsr set_cursor_col

        lda # $2d
        bne _72c7
_72b8:                                                                  ;$72B8
        lda ZP_8F
        and # %01100000
        beq _72ca
        cmp # $20
        beq _72d1
        jsr _72d6

print_space:                                                            ;$72C5
        lda # $20
_72c7:                                                                  ;$72C7
        jmp print_flight_token

_72ca:                                                                  ;$72CA
        lda # $74               ;="T"
        jsr print_char
        bcc print_space
_72d1:                                                                  ;$72D1
        lda # $6b               ;="K"
        jsr print_char
_72d6:                                                                  ;$72D6
        lda # $67               ;="G"
        jmp print_char

;===============================================================================

_72db:                                                                  ;$72DB
        lda # 17
        jsr set_cursor_col

        lda # $ff
        bne _72c7

market_screen:                                                          ;$72E4

        lda # $10
        jsr _6a2f

        lda # 5
        jsr set_cursor_col

.import TXT_MARKET_PRICES:direct
        lda # TXT_MARKET_PRICES
        jsr _28d9

        lda # 3
        jsr set_cursor_row
        
        jsr _72db

        lda # 6
        jsr set_cursor_row
        
        lda # $00
        sta VAR_04EF            ; item index?
_7305:                                                                  ;$7305
        ldx # $80
        stx ZP_34
        jsr _7246
        jsr cursor_down
        inc VAR_04EF            ; item index?
        lda VAR_04EF            ; item index?
        cmp # $11
        bcc _7305
        rts 

;===============================================================================

_731a:                                                                  ;$731A
        lda ZP_8F
        and # %00011111
        ldy PSYSTEM_ECONOMY
        sta ZP_90
        clc 
        lda # $00
        sta VAR_MARKET_ALIENS
_7329:                                                                  ;$7329
        dey 
        bmi _7331
        adc ZP_90
        jmp _7329

_7331:                                                                  ;$7331
        sta ZP_91
        rts 

;===============================================================================

;7334 - dead code?

        jsr _70ab
_7337:                                                                  ;$7337
        jsr _7217

        ldx # $05
:       lda VAR_04FA, x                                                    ;$733C
        sta VAR_04F4, x
        dex 
        bpl :-

        inx 
        stx VAR_048A
        
        lda TSYSTEM_ECONOMY
        sta PSYSTEM_ECONOMY
        lda TSYSTEM_TECHLEVEL
        sta PSYSTEM_TECHLEVEL
        lda TSYSTEM_GOVERNMENT
        sta PSYSTEM_GOVERNMENT
        
        jsr get_random_number
        sta VAR_04DF
        
        ldx # $00
        stx ZP_AD
_7365:                                                                  ;$7365
        lda _90a6, x
        sta ZP_8F
        jsr _731a
        lda _90a8, x
        and VAR_04DF
        clc 
        adc _90a7, x
        ldy ZP_8F
        bmi _7381
        sec 
        sbc ZP_91
        jmp _7384

_7381:                                                                  ;$7381
        clc 
        adc ZP_91
_7384:                                                                  ;$7384
        bpl _7388
        lda # $00
_7388:                                                                  ;$7388
        ldy ZP_AD
        and # %00111111
        sta VAR_MARKET_FOOD, y
        iny 
        tya 
        sta ZP_AD
        asl 
        asl 
        tax 
        cmp # $3f
        bcc _7365
        rts 

;===============================================================================

_739b:                                                                  ;$739B
        jsr _848d
        lda # %11111111         ; why max-out? (is this a space-station?)
        sta ZP_POLYOBJ_ATTACK
        
        lda # $1d
        jsr _7c6b
        
        lda # $1e
        jmp _7c6b

;===============================================================================

_73ac:                                                                  ;$73AC
        lsr PLAYER_COMPETITION
        sec 
        rol PLAYER_COMPETITION
_73b3:                                                                  ;$73B3
        lda # $03
        jsr set_page

        jsr _3795
        jsr _83df
        sty IS_WITCHSPACE
_73c1:                                                                  ;$73C1
        jsr _739b
        lda # $03
        cmp VAR_047A
        bcs _73c1
        sta DUST_COUNT          ; number of dust particles

        ; change to cockpit front view
        ldx # $00               ; =front view
        jsr _a6ba               ; switch to cockpit

        lda PSYSTEM_POS_Y
        eor # %00011111
        sta PSYSTEM_POS_Y

        rts 

;===============================================================================

_73dc:                                                                  ;$73DC
        rts 

_73dd:                                                                  ;$73DD
        lda PLAYER_FUEL
        sec 
        sbc TSYSTEM_DISTANCE_LO
        bcs _73e8
        lda # $00
_73e8:                                                                  ;$73E8
        sta PLAYER_FUEL
        
        lda ZP_SCREEN
        bne _73f5

        jsr set_page
        jsr _3795
_73f5:                                                                  ;$73F5
        jsr get_ctrl
        and _1d08
        bmi _73ac
        jsr get_random_number
        cmp # $fd
        bcs _73b3
        jsr _7337
        jsr _83df
        jsr _7a9f

        lda ZP_SCREEN
        and # %00111111
        bne _73dc
        
        jsr _a731

        lda ZP_SCREEN
        bne _7452
        inc ZP_SCREEN

_741c:  ; launch ship from docking?                                     ;$741C
        ldx ZP_A7
        beq _744b
        jsr _379e
        jsr _83df
        jsr _70ab
        inc ZP_POLYOBJ_ZPOS_HI
        jsr _7a8c
        lda # $80
        sta ZP_POLYOBJ_ZPOS_HI
        inc ZP_POLYOBJ_ZPOS_MI
        jsr _7c24
        lda # $0c
        sta PLAYER_SPEED
        jsr _8798
        ora PLAYER_LEGAL
        sta PLAYER_LEGAL

        lda # $ff
        sta ZP_SCREEN
        
        jsr _37b2
_744b:                                                                  ;$744B
        ldx # $00
        stx ZP_A7
        jmp _a6ba

_7452:                                                                  ;$7452
        bmi _7457
        jmp galactic_chart
_7457:                                                                  ;$7457
        jmp local_chart


; increase / decrease cash

_745a:                                                                  ;$745A
;===============================================================================
.export _745a
        stx ZP_TEMP_VAR
        lda PLAYER_CASH_pt4
        sec 
        sbc ZP_TEMP_VAR
        sta PLAYER_CASH_pt4
        sty ZP_TEMP_VAR
        lda PLAYER_CASH_pt3
        sbc ZP_TEMP_VAR
        sta PLAYER_CASH_pt3
        lda PLAYER_CASH_pt2
        sbc # $00
        sta PLAYER_CASH_pt2
        lda PLAYER_CASH_pt1
        sbc # $00
        sta PLAYER_CASH_pt1
        bcs _74a1
        
_7481:                                                                  ;$7481
;===============================================================================
.export _7481
        txa 
        clc 
        adc PLAYER_CASH_pt4
        sta PLAYER_CASH_pt4
        tya 
        adc PLAYER_CASH_pt3
        sta PLAYER_CASH_pt3
        lda PLAYER_CASH_pt2
        adc # $00
        sta PLAYER_CASH_pt2
        lda PLAYER_CASH_pt1
        adc # $00
        sta PLAYER_CASH_pt1
        clc 
_74a1:                                                                  ;$74A1
        rts 

;===============================================================================

_74a2:                                                                  ;$74A2
        jsr _399b
_74a5:                                                                  ;$74A5
        asl ZP_VAR_P1
        rol 
        asl ZP_VAR_P1
        rol 
        tay 
        ldx ZP_VAR_P1
        rts 

;===============================================================================

;$74af  unused?

        .byte   $52, $2e, $44, $2e, $43, $4f ,$44, $45  ;"R.D.CODE"
        .byte   $0d

;-------------------------------------------------------------------------------

_74b8:   jmp _88e7                                                      ;$74B8

;===============================================================================
; buy equipment screen
;
equipment_screen:                                                       ;$74BB

        lda # $20
        jsr _6a2f

        lda # 12
        jsr set_cursor_col
        
        lda # $cf               ;="EQUIP"?
        jsr _6a9b

.import TXT_SHIP:direct
        lda # TXT_SHIP
        jsr _28d9
        
        lda # $80
        sta ZP_34
        jsr cursor_down
        lda PSYSTEM_TECHLEVEL
        clc 
        adc # $03
        cmp # $0c
        bcc _74e2
        lda # $0e
_74e2:                                                                  ;$74E2
        sta ZP_VAR_Q
        sta VAR_04ED
        inc ZP_VAR_Q
        lda # $46
        sec 
        sbc PLAYER_FUEL
        asl 
        sta _76cd+0
        ldx # $01
_74f5:                                                                  ;$74F5
        stx ZP_A2
        jsr print_newline
        ldx ZP_A2
        clc 
        jsr print_tiny_value
        jsr print_space
        
        lda ZP_A2
        clc 
        adc # $68
        jsr print_flight_token
        
        lda ZP_A2
        jsr _763f
        sec 

        lda # 25
        jsr set_cursor_col
        
        lda # $06
        jsr print_medium_value
        ldx ZP_A2
        inx 
        cpx ZP_VAR_Q
        bcc _74f5
        jsr txt_docked_token15

.import TXT_ITEM:direct
        lda # TXT_ITEM
        jsr _723c

        jsr _6dc9
        beq _74b8
        bcs _74b8
        sbc # $00
        pha 

        lda # 2
        jsr set_cursor_col
        jsr cursor_down

        pla 
        pha 
        jsr _762f
        pla 
        bne _7549
        ldx # $46
        stx PLAYER_FUEL
_7549:                                                                  ;$7549
        cmp # $01
        bne _755f
        ldx PLAYER_MISSILES
        inx 
        ldy # $7c
        cpx # $05
        bcs _75a1

        stx PLAYER_MISSILES
        
        jsr _845c               ; update missile blocks on HUD
        lda # $01
_755f:                                                                  ;$755F
        ldy # $6b
        cmp # $02
        bne _756f
        ldx # $25
        cpx SHIP_HOLD           ; cargo capacity of the player's ship
        beq _75a1
        stx SHIP_HOLD           ; cargo capacity of the player's ship
_756f:                                                                  ;$756F
        cmp # $03
        bne _757c
        iny 
        ldx PLAYER_ECM
        bne _75a1
        dec PLAYER_ECM
_757c:                                                                  ;$757C
        cmp # $04
        bne _758a
        jsr _764c
        lda # $0f
        jsr _76a1
        lda # $04
_758a:                                                                  ;$758A
        cmp # $05
        bne _7596
        jsr _764c
        lda # $8f
        jsr _76a1
_7596:                                                                  ;$7596
        ldy # $6f
        cmp # $06
        bne _75bc
        ldx VAR_04C2
        beq _75b9
_75a1:                                                                  ;$75A1
        sty ZP_VALUE_pt1
        jsr _7642
        jsr _7481
        lda ZP_VALUE_pt1
        jsr _6a9b
        
.import TXT_PRESENT:direct
        lda # TXT_PRESENT       ;?
        jsr print_flight_token
_75b3:                                                                  ;$75B3
        jsr _7627
        jmp _88e7

;===============================================================================

_75b9:                                                                  ;$75B9
        dec VAR_04C2
_75bc:                                                                  ;$75BC
        iny 
        cmp # $07
        bne _75c9
        ldx PLAYER_ESCAPEPOD
        bne _75a1
        dec PLAYER_ESCAPEPOD
_75c9:                                                                  ;$75C9
        iny 
        cmp # $08
        bne _75d8
        ldx PLAYER_EBOMB
        bne _75a1
        ldx # $7f
        stx PLAYER_EBOMB
_75d8:                                                                  ;$75D8
        iny 
        cmp # $09
        bne _75e5
        ldx VAR_04C4            ; energy charge rate?
        bne _75a1
        inc VAR_04C4            ; energy charge rate?
_75e5:                                                                  ;$75E5
        iny 
        cmp # $0a
        bne _75f2

        ldx PLAYER_DOCKCOM      ; does the player have a docking computer?
       .bnz _75a1               ; yes: no need to give them one
        dec PLAYER_DOCKCOM      ; no: change flag from $00 to $FF

_75f2:                                                                  ;$75F2
        iny 
        cmp # $0b
        bne _75ff
        ldx PLAYER_GDRIVE
        bne _75a1
        dec PLAYER_GDRIVE
_75ff:                                                                  ;$75FF
        iny 
        cmp # $0c
        bne _760c
        jsr _764c
        lda # $97
        jsr _76a1
_760c:                                                                  ;$760C
        iny 
        cmp # $0d
        bne _7619
        jsr _764c
        lda # $32
        jsr _76a1
_7619:                                                                  ;$7619
        jsr _761f
        jmp equipment_screen

_761f:                                                                  ;$761F
        jsr print_space

        lda # $77
        jsr _6a9b
_7627:                                                                  ;$7627
        jsr _a80f

        ldy # 50
        jmp wait_frames

;===============================================================================

_762f:                                                                  ;$762F
        jsr _7642
        jsr _745a
        bcs _764b

.import TXT_CASH:direct
        lda # TXT_CASH
        jsr _723c
        
        jmp _75b3

;===============================================================================

_763f:                                                                  ;$763F
        sec 
        sbc # $01
_7642:                                                                  ;$7642
        asl 
        tay 
        ldx _76cd+0, y
        lda _76cd+1, y
        tay 
_764b:                                                                  ;$764B
        rts 

;===============================================================================

_764c:                                                                  ;$764C
        lda PSYSTEM_TECHLEVEL
        cmp # $08
        bcc _7658

        lda # $20
        jsr set_page
_7658:                                                                  ;$7658
        lda # 16
        tay 
        jsr set_cursor_row
_765e:                                                                  ;$765E
        lda # 12
        jsr set_cursor_col

        tya 
        clc 
        adc # $20
        jsr _6a9b
        lda ZP_CURSOR_ROW
        clc 
        adc # $50
        jsr print_flight_token
        
        jsr cursor_down
        ldy ZP_CURSOR_ROW
        cpy # $14
        bcc _765e
        jsr txt_docked_token15
_767e:                                                                  ;$767E
.import TXT_VIEW:direct
        lda # TXT_VIEW
        jsr _723c

        jsr _8fea
        sec 
        sbc # $30
        cmp # $04
        bcc _7693
        jsr txt_docked_token15
        jmp _767e

_7693:                                                                  ;$7693
        tax 
        rts 

;===============================================================================

_7695:                                                                  ;$7695
        jsr _6f82
        jsr _70ab
        jsr _6f82
        jmp txt_docked_token15

;===============================================================================

_76a1:                                                                  ;$76A1
        sta ZP_TEMP_VAR
        lda PLAYER_LASERS, x
        beq _76c7
        ldy # $04
        cmp # $0f
        beq _76bc
        ldy # $05
        cmp # $8f
        beq _76bc
        ldy # $0c
        cmp # $97
        beq _76bc
        ldy # $0d
_76bc:                                                                  ;$76BC
        stx ZP_VAR_Z
        tya 
        jsr _7642
        jsr _7481
        ldx ZP_VAR_Z
_76c7:                                                                  ;$76C7
        lda ZP_TEMP_VAR
        sta PLAYER_LASERS, x
        rts 

;===============================================================================
; price list?

_76cd:                                                                  ;$76CD
        .word   $0001, $012c, $0fa0, $1770, $0fa0
        .word   $2710, $1482, $2710, $2328, $3a98
        .word   $2710, $c350, $ea60, $1f40

;===============================================================================

_76e9:                                                                  ;$76E9
.export _76e9
        ldx # $05

:       lda ZP_SEED, x                                                  ;$76EB
        sta ZP_8E, x
        dex 
        bpl :-
        
        ldy # $03
        bit ZP_SEED_W0_LO
        bvs :+
        dey 

:       sty ZP_VAR_T                                                    ;$76F9

@_76fb:                                                                 ;$76FB
        lda ZP_SEED_W2_HI
        and # %00011111
        beq :+
        ora # %10000000
        jsr print_flight_token

:       jsr randomize_once                                              ;$7706
        dec ZP_VAR_T
        bpl @_76fb
        ldx # $05

:       lda ZP_8E, x                                                    ;$770F
        sta ZP_SEED, x
        dex 
        bpl :-

        rts

;===============================================================================

_7717:                                                                  ;$7717
        ldy # $00
_7719:                                                                  ;$7719
        lda VAR_0491, y
        cmp # $0d
        beq _7726
        jsr print_char
        iny 
        bne _7719
_7726:                                                                  ;$7726
        rts 

print_local_planet_name:                                                ;$7727
;===============================================================================
; print planet name for the system the player is currently in
;
        ; if the player is in witchspace, there is no planet!
        bit IS_WITCHSPACE
        bmi @rts

        jsr :+                          ; copy the seed for name-expansion
        jsr _76e9

:       ldx # $05                                                       ;$7732

:       lda ZP_SEED, x                                                  ;$7734
        ldy VAR_04F4, x
        sta VAR_04F4, x
        sty ZP_SEED, x
        dex 
        bpl :-

@rts:   rts                                                             ;$7741

print_galaxy_no:                                                        ;$7742
;===============================================================================
; print galaxy number

        clc 
        ldx PLAYER_GALAXY       ; current galaxy number
        inx                     ; print as 1-8, not 0-7
        jmp print_tiny_value

print_fuel_and_cash:                                                    ;$774A
;===============================================================================
; print fuel & cash totals
;
.import TXT_FUEL:direct

        ; print "FUEL:"
        lda # TXT_FUEL
        jsr print_flight_token_with_colon

        ; print the player's fuel quantity
        ldx PLAYER_FUEL
        sec                             ; use decimal point
        jsr print_tiny_value

        ; print "LIGHT YEARS"
.import TXT_LIGHT_YEARS:direct
        lda # TXT_LIGHT_YEARS
        jsr print_flight_token_and_newline
        
.import TXT_CASH_:direct
        lda # TXT_CASH_                 ; "CASH:" (colon in the string)
        bne print_flight_token

        ; print cash value?  
_775f:                                                                  ;$775F
        ldx # 3

        ; copy $04A2..$04A5 to $77..$7A?
:       lda PLAYER_CASH, x                                              ;$7761
        sta ZP_VALUE, x
        dex 
        bpl :-

        lda # $09               ; align to 10 digits
        sta ZP_VAR_U
        
        sec                     ; set carry flag - use decimal point
        jsr print_large_value   ; convert value to string

        ; print "CR" ("credits") after the cash value
.import TXT_CR:direct
        lda # TXT_CR
        ;
        ; fall-through below to print "CR" and new-line
        ;

print_flight_token_and_newline:                                         ;$7773
        ;=======================================================================
.export print_flight_token_and_newline

        jsr print_flight_token
        jmp print_newline


print_flight_token_with_colon:                                          ;$7779
        ;=======================================================================
        ; prints the string token in A and appends a colon character
        ;
        ;    A = an already *de-scrambled* string token
        ;
        jsr print_flight_token

print_colon:                                                            ;$777C
        ;=======================================================================
        ; prints a colon, nothing else
        ;
        lda # ':'

print_flight_token:                                                     ;$777E
        ;=======================================================================
        ; prints an already *de-scrambled* string token. this can be a single
        ; letter, a variable (like cash or planet name), a string-expansion,
        ; or a meta-command
        ;
        ;    A = an already *de-scrambled* string token
        ;
        ; brief token breakdown:
        ;
        ;      $00 = print "cash:" & cash value
        ;      $01 = print current galaxy number?
        ;      $02 = ?
        ;      $03 = ?
        ;      $04 = ?
        ;      $05 = ?
        ;      $06 = ?
        ;      $07 = ?
        ;      $08 = ?
        ;      $09 = ?
        ;      $0A = ?
        ;      $0B = ?
        ;      $0C = newline
        ;      $0D = (also newline)
        ;  $0E-$20 = canned messages 128-146
        ;  $21-$5F = ASCII characters $21-$5F -- see "gfx/font.asm"
        ;  $60-$7F = canned messages  96-127
        ;  $80-$BF = canned messages   0-95
        ;
.export print_flight_token

        tax                     ; put aside token for later test

        ; handle variables / meta-commands:
        ;-----------------------------------------------------------------------
        ; token $00:
        ;
       .bze _775f               ; is A 0? -- print "Cash: " and credit count
        
        ; token $80-$FF:
        ;
        ; any token value 128 or higher (i.e. bit 7 set) is a
        ; canned-message, the index of which is in the remaining bits
        ;
        bmi _print_str          ; is bit 7 set? (i.e. is token)
        
        ; token $01:
        ;
        dex                     ; decrement token value
       .bze print_galaxy_no     ; if now 0, it was 1 -- print galaxy number
        
        ; token $02:
        ;
        dex                     ; decrement token value
                                ; if now 0, it was 2 -- print local planet name
       .bze print_local_planet_name
        
        ; token $03:
        ;
        dex                     ; decrement token value 
       .bnz :+                  ; skip ahead if it isn't now zero
        jmp _76e9               ; it was 3 -- print target planet name

        ; token $04:
        ;
:       dex                     ; decrement token value                 ;$778F 
       .bze _7717               ; if now 0, it was 4 -- commander's name

        ; token $05:
        ;
        dex                     ; decrement token value
       .bze print_fuel_and_cash ; if now 0, it was 5 -- print fuel & cash
        
        dex                     ; decrement token value
       .bnz :+                  ; skip ahead if not 0
        
        ; token $06:
        ;
        lda # $80               ; put 128 (bit 7) into A
        sta ZP_34               ; set case-switch flag
        rts 

        ; NOTE: token $07 will fall through here
        ;       and be handled later!

        ; token $08:
        ;
:       dex                     ; decrement token value twice more      ;$779D
        dex                     ; i.e. if it was 8, it would be 0
       .bnz :+                  ; skip ahead if token was not originally 8
        stx ZP_34               ; token was 8, store the 0 in the case-switch
        rts                     ; flag and return

        ; token $09:
        ;
:       dex                     ; decrement token again                 ;$77A4
       .bze _indent             ; if token was 9, process a tab

        ; NOTE: A is still the original token number,
        ;       only X has been decremented!
        
        ; tokens 96...127 are canned messages
        ; (tokens 128...255 have already been checked for above)
        cmp # $60
       .bge print_canned_message

        ; tokens $0A-$0D will be passed through to the character printing
        ; routine where they are special-cased as ASCII codes $09-$0D are
        ; not printable characters!
        ;
        cmp # $0e               ; tokens < $0E that have not already been done
       .blt :+                  ; skip ahead
        
        cmp # $20               ; tokens < 32?
       .blt _77db               ; treat as token A+114

        ; switch case?
        ;
:       ldx ZP_34               ; check case-switch flag                ;$77B3
        beq _77f6               ; =0, leave case as-is and print char
        bmi _is_captial         ; or bit 7 set, switch case
        
        bit ZP_34               ; check bits 7 & 6 (bit 7 already handled)
        bvs _77ef               ; bit 6 set -- print char and reset bit 6

_77bd:                                                                  ;$77BD
        ;-----------------------------------------------------------------------
        ; print in lower-case:
        ; first though, print any non A-Z character without changing case
        ;
        cmp # 'a'               ; less than 'A'?
        bcc _goto_print_char    ; yes: print as is
        
        cmp # 'z'+1             ; higher than 'Z'?
        bcs _goto_print_char    ; yes: print as is

        adc # $20               ; otherwise shift letter into lower-case

_goto_print_char:                                                       ;$77C7
        jmp print_char          ; just print char

_is_captial:                                                            ;$77CA
        ;-----------------------------------------------------------------------
        bit ZP_34               ; bit 6 set?
        bvs _77e7               

        cmp # 'a'               ; less than 'A'?
        bcc _77f6               ; yes: print as is
        
        pha 
        txa 

        ; set bit 6 on the case-switch flag
        ora # %01000000
        sta ZP_34

        pla 
        bne _goto_print_char    ; print character as-is, but next will be
                                ; lower-cased (bit 6 of case-flag)

_77db:  ; add 114 to the token number and print the canned message:     ;$77DB
        adc # 114
        bne print_canned_message

_indent:                                                                ;$77DF
        ;-----------------------------------------------------------------------
        ; set cursor to column 22
        ;
        lda # 21
        jsr set_cursor_col
        jmp print_colon

        ;-----------------------------------------------------------------------

_77e7:  ; don't do anything if case-switch flag = %11111111             ;$77E7
        cpx # $ff
        beq _784e

        ; if 'A' or above, print in lower-case
        cmp # 'a'
        bcs _77bd

        ; clear bit-6 of case-switch flag
_77ef:  pha                                                             ;$77EF
        txa 
        and # %10111111
        sta ZP_34
        pla 

_77f6:  jmp print_char                                                  ;$77F6


_print_str:                                                             ;$77F9
        ;-----------------------------------------------------------------------
        ; note that canned message tokens have bit 7 set, so really this is
        ; asking if the message index is > 32 -- the first 32 canned messages
        ; are letter pairs
        ;
        cmp # 160               ; is token >= 160?
       .bge @canned_token       ; if yes, go to canned messages 33+ 
        
        ; token is a character pair
        ;
        and # %01111111         ; clear token flag, leave message index
        asl                     ; double it for a lookup-table offset,
        tay                     ; this would have cleared bit 7 anyway!
        lda txt_flight_pair1, y ; read the first character,
        jsr print_flight_token  ; print it
        lda txt_flight_pair2, y ; read second character
        cmp # $3f               ; is it 63? (some kind of continuation token?)
        beq _784e               ; yes, skip -- although never seen in practice
        jmp print_flight_token  ; print second character (and return)

@canned_token:                                                          ;$7811  
        ; token messages 160+; subtract 160 for the message index
        sbc # 160

print_canned_message:                                                   ;$7813
        ;=======================================================================
        ; prints a canned message from the messages table
        ;
        ;    A = message index 
        ;
        tax                     ; put the message index aside 

        ; select the table of canned-messages
        lda #< _0700
        sta ZP_TEMP_ADDR3_LO
        lda #> _0700
        sta ZP_TEMP_ADDR3_HI

        ; initialise loop counter
        ldy # $00
        
        ; ignore message no.0,
        ; i.e. you can't skip zero messages
        txa                     ; return the original message index
        beq print_flight_token_string

@skip_message:                                                           ;$7821

        lda [ZP_TEMP_ADDR3], y  ; read a code from the compressed text
        beq :+                  ; if zero terminator, end string
        iny                     ; next character 
        bne @skip_message       ; loop if not at 256 chars
        inc ZP_TEMP_ADDR3_HI    ; move to the next page,
        bne @skip_message       ; and keep reading

:       iny                     ; move forward over the zero            ;$782C 
        bne :+                  ; skip if we haven't overflowed a page
        inc ZP_TEMP_ADDR3_HI    ; next page if the zero happened there
:       dex                     ; decrement message skip counter        ;$7831 
        bne @skip_message       ; keep looping if we haven't reached
                                ; the desired message index yet

print_flight_token_string:                                              ;$7834
        ;-----------------------------------------------------------------------
        ; remember the current index
        ; (this routine can call recursively)
       .phy                     ; push Y to stack (via A)
        ; remember the current page
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; get the 'key' used for de-scrambling the text
        ; (see "text_flight.asm")
.import TXT_FLIGHT_XOR:direct

        lda [ZP_TEMP_ADDR3], y  ; read a token
        eor # TXT_FLIGHT_XOR    ; 'descramble' token
        jsr print_flight_token  ; process it

        ; restore the previous page
        pla 
        sta ZP_TEMP_ADDR3_HI
        ; and index
        pla 
        tay 
        
        iny                     ; next character
        bne :+                  ; overflowed the page?
        inc ZP_TEMP_ADDR3_HI    ; move to the next page

        ; is this the end of the string?
        ; (check for a $00 token)
:       lda [ZP_TEMP_ADDR3], y                                          ;$784A
        bne print_flight_token_string

_784e:  rts                                                             ;$784E 


swap_zp_shadow:                                                         ;$784F
;===============================================================================
; swap zero-page with its shadow
; (copies $36...$FF to $CE36...$CEFF)
;
        ldx # $36               ; $36 makes no sense
:       lda $00, x              ; read A from the zero-page               ;$7851
        ldy ELITE_ZP_SHADOW, x  ; read Y form the shadow
        sta ELITE_ZP_SHADOW, x  ; write A to the shadow
        sty $00, x              ; write Y to the zero-page
        inx 
       .bnz :-
        
        rts 

;===============================================================================
; unused / unreferenced?
;
_785f:                                                                  ;$785F
        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::exploding | visibility::display
        sta ZP_POLYOBJ_VISIBILITY
        rts 

;===============================================================================

_7866:                                                                  ;$7866
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::firing
        beq _786f
        jsr _78d6
_786f:                                                                  ;$786F
        lda ZP_POLYOBJ_ZPOS_LO
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        cmp # $20
        bcc _787d
        lda # $fe
        bne _7885
_787d:                                                                  ;$787D
        asl ZP_VAR_T
        rol 
        asl ZP_VAR_T
        rol 
        sec 
        rol 
_7885:                                                                  ;$7885
        sta ZP_VAR_Q
        ldy # $01
        lda [ZP_TEMP_ADDR2], y
        sta VAR_050D
        adc # $04
        bcs _785f
        sta [ZP_TEMP_ADDR2], y
        jsr _3b37
        lda ZP_VAR_P1
        cmp # $1c
        bcc _78a1
        lda # $fe
        bne _78aa
_78a1:                                                                  ;$78A1
        asl ZP_VAR_R
        rol 
        asl ZP_VAR_R
        rol 
        asl ZP_VAR_R
        rol 
_78aa:                                                                  ;$78AA
        dey 
        sta [ZP_TEMP_ADDR2], y
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::firing ^$FF   ;=%10111111
        sta ZP_POLYOBJ_VISIBILITY
        and # visibility::redraw
        beq _784e

        ldy # $02
        lda [ZP_TEMP_ADDR2], y
        tay 
_78bc:                                                                  ;$78BC
        lda ZP_F9, y            ;???
        sta [ZP_TEMP_ADDR2], y
        dey 
        cpy # $06
        bne _78bc
        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::firing
        sta ZP_POLYOBJ_VISIBILITY
        ldy VAR_050D
        cpy # $12
        bne _78d6
        jmp _795a

_78d6:                                                                  ;$78D6
        ldy # $00
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Q
        iny 
        lda [ZP_TEMP_ADDR2], y
        bpl _78e3
        eor # %11111111
_78e3:                                                                  ;$78E3
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta ZP_VAR_U
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_A8
        lda ZP_GOATSOUP_pt2     ;?
        pha 
        ldy # $06
_78f5:                                                                  ;$78F5
        ldx # $03
_78f7:                                                                  ;$78F7
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex 
        bpl _78f7
        sty ZP_AA
        ldy # $02
_7903:                                                                  ;$7903
        iny 
        lda [ZP_TEMP_ADDR2], y
        eor ZP_AA
        sta $ffff, y                    ;!?
        cpy # $06
        bne _7903
        ldy ZP_VAR_U
_7911:                                                                  ;$7911
        clc 
        lda ZP_GOATSOUP_pt1
        rol 
        tax 
        adc ZP_GOATSOUP_pt3
        sta ZP_GOATSOUP_pt1
        stx ZP_GOATSOUP_pt3
        lda ZP_GOATSOUP_pt2
        tax 
        adc ZP_GOATSOUP_pt4
        sta ZP_GOATSOUP_pt2
        stx ZP_GOATSOUP_pt4
        sta ZP_VAR_Z
        lda ZP_POLYOBJ01_XPOS_pt2
        sta ZP_VAR_R
        lda ZP_POLYOBJ01_XPOS_pt1
        jsr _7974
        bne _795d
        cpx # $8f
        bcs _795d
        stx ZP_VAR_Y
        lda ZP_POLYOBJ01_YPOS_pt1
        sta ZP_VAR_R
        lda ZP_POLYOBJ01_XPOS_pt3
        jsr _7974
        bne _7948
        lda ZP_VAR_Y
        jsr paint_particle
_7948:                                                                  ;$7948
        dey 
        bpl _7911
        ldy ZP_AA
        cpy ZP_A8
        bcc _78f5
        pla 
        sta ZP_GOATSOUP_pt2

.import POLYOBJ_00

        lda POLYOBJ_00 + PolyObject::zpos                               ;=$F906
        sta ZP_GOATSOUP_pt4
        rts 

;===============================================================================

_795a:                                                                  ;$795A
        jmp _79a9

;===============================================================================

_795d:                                                                  ;$795D
        clc 
        lda ZP_GOATSOUP_pt1
        rol 
        tax 
        adc ZP_GOATSOUP_pt3
        sta ZP_GOATSOUP_pt1
        stx ZP_GOATSOUP_pt3
        lda ZP_GOATSOUP_pt2
        tax 
        adc ZP_GOATSOUP_pt4
        sta ZP_GOATSOUP_pt2
        stx ZP_GOATSOUP_pt4
        jmp _7948

;===============================================================================

_7974:                                                                  ;$7974
        sta ZP_VAR_S
        clc 
        lda ZP_GOATSOUP_pt1
        rol 
        tax 
        adc ZP_GOATSOUP_pt3
        sta ZP_GOATSOUP_pt1
        stx ZP_GOATSOUP_pt3
        lda ZP_GOATSOUP_pt2
        tax 
        adc ZP_GOATSOUP_pt4
        sta ZP_GOATSOUP_pt2
        stx ZP_GOATSOUP_pt4
        rol 
        bcs _7998
        jsr _39ea
        adc ZP_VAR_R
        tax 
        lda ZP_VAR_S
        adc # $00
        rts 

_7998:                                                                  ;$7998
        jsr _39ea
        sta ZP_VAR_T
        lda ZP_VAR_R
        sbc ZP_VAR_T
        tax 
        lda ZP_VAR_S
        sbc # $00
        rts 

;===============================================================================

_79a7:                                                                  ;$79A7
        .byte   $00, $02

_79a9:                                                                  ;$79A9
;===============================================================================
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

        lda ZP_POLYOBJ_ZPOS_MI
        cmp # $07
        lda # $fd
        ldx # $2c
        ldy # $28
        bcs _79c0
        lda # $ff
        ldx # $20
        ldy # $1e
_79c0:                                                                  ;$79C0
        sta VIC_SPRITE_DBLHEIGHT
        sta VIC_SPRITE_DBLWIDTH
        stx VAR_050E
        sty VAR_050F
        ldy # $00
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Q
        iny 
        lda [ZP_TEMP_ADDR2], y
        bpl _79d9
        eor # %11111111
_79d9:                                                                  ;$79D9
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta ZP_VAR_U
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_A8
        lda ZP_GOATSOUP_pt2
        pha 
        ldy # $06
_79eb:                                                                  ;$79EB
        ldx # $03
_79ed:                                                                  ;$79ED
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex 
        bpl _79ed
        sty ZP_AA
        lda ZP_POLYOBJ01_YPOS_pt1
        clc 
        adc VAR_050E
        sta ZP_TEMP_ADDR1_LO
        lda ZP_POLYOBJ01_XPOS_pt3
        adc # $00
        bmi _7a36
        cmp # $02
        bcs _7a36
        tax 
        lda ZP_POLYOBJ01_XPOS_pt2
        clc 
        adc VAR_050F
        tay 
        lda ZP_POLYOBJ01_XPOS_pt1
        adc # $00
        bne _7a36
        cpy # $c2
        bcs _7a36
        lda VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        and # %11111101
        ora _79a7, x
        sta VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        ldx ZP_TEMP_ADDR1_LO
        sty VIC_SPRITE1_Y
        stx VIC_SPRITE1_X
        lda VIC_SPRITE_ENABLE
        ora # %00000010
        sta VIC_SPRITE_ENABLE
_7a36:                                                                  ;$7A36
        ldy # $02
_7a38:                                                                  ;$7A38
        iny 
        lda [ZP_TEMP_ADDR2], y
        eor ZP_AA
        sta $ffff, y            ;!?
        cpy # $06
        bne _7a38
        ldy ZP_VAR_U
_7a46:                                                                  ;$7A46
        jsr _84ae
        sta ZP_VAR_Z
        lda ZP_POLYOBJ01_XPOS_pt2
        sta ZP_VAR_R
        lda ZP_POLYOBJ01_XPOS_pt1
        jsr _7974
        bne _7a86
        cpx # $8f
        bcs _7a86
        stx ZP_VAR_Y
        lda ZP_POLYOBJ01_YPOS_pt1
        sta ZP_VAR_R
        lda ZP_POLYOBJ01_XPOS_pt3
        jsr _7974
        bne _7a6c
        lda ZP_VAR_Y
        jsr paint_particle
_7a6c:                                                                  ;$7A6C
        dey 
        bpl _7a46
        ldy ZP_AA
        cpy ZP_A8
        bcs _7a78
        jmp _79eb

_7a78:                                                                  ;$7A78
        pla 
        sta ZP_GOATSOUP_pt2     ;?
        
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

        lda POLYOBJ_00 + PolyObject::zpos                               ;=$F906
        sta ZP_GOATSOUP_pt4
        rts 

_7a86:                                                                  ;$7A86
        jsr _84ae
        jmp _7a6c

;===============================================================================

_7a8c:                                                                  ;$7A8C
        jsr _845c               ; update missile blocks on HUD

        lda # $7f
        sta ZP_POLYOBJ_ROLL
        sta ZP_POLYOBJ_PITCH

        lda PSYSTEM_TECHLEVEL
        and # %00000010
        ora # %10000000
        jmp _7c6b

;===============================================================================

_7a9f:                                                                  ;$7A9F
        lda PLAYER_TRUMBLES_LO  ; does the player have any Trumbles™?
       .bze _7ac2               ; if not, skip ahead

        ; they've eaten your goods!
        lda # $00
        sta VAR_CARGO_FOOD
        sta VAR_CARGO_NARCOTICS

        jsr get_random_number   ; choose a random number
        and # %00001111         ; between 0-15
        adc PLAYER_TRUMBLES_LO
        ora # %00000100
        rol 
        sta PLAYER_TRUMBLES_LO
        rol PLAYER_TRUMBLES_HI
        bpl _7ac2
        ror PLAYER_TRUMBLES_HI  ; undo that

_7ac2:                                                                  ;$7AC2
        lsr PLAYER_LEGAL
        jsr clear_zp_polyobj

        lda ZP_SEED_W0_HI
        and # %00000011
        adc # $03
        sta ZP_POLYOBJ_ZPOS_HI
        ror 
        sta ZP_POLYOBJ_XPOS_HI
        sta ZP_POLYOBJ_YPOS_HI
        jsr _7a8c
        lda ZP_SEED_W1_HI
        and # %00000111
        ora # %10000001
        sta ZP_POLYOBJ_ZPOS_HI
        lda ZP_SEED_W2_HI
        and # %00000011
        sta ZP_POLYOBJ_XPOS_HI
        sta ZP_POLYOBJ_XPOS_MI
        
        lda # $00
        sta ZP_POLYOBJ_ROLL
        sta ZP_POLYOBJ_PITCH
        
        lda # $81
        jsr _7c6b
_7af3:                                                                  ;$7AF3
        lda ZP_SCREEN
        bne _7b1a
_7af7:                                                                  ;$7AF7
        ldy DUST_COUNT          ; number of dust particles
_7afa:                                                                  ;$7AFA
        jsr get_random_number
        ora # %00001000
        sta DUST_Z, y
        sta ZP_VAR_Z
        jsr get_random_number
        sta DUST_X, y
        sta ZP_VAR_X
        jsr get_random_number
        sta DUST_Y, y
        sta ZP_VAR_Y
        jsr draw_particle
        dey 
        bne _7afa
_7b1a:                                                                  ;$7B1A
        ; begin with ship-slot 0
        ldx # $00
_7b1c:                                                                  ;$7B1C
        lda SHIP_SLOTS, x
        beq _7b44
        bmi _7b41
        sta ZP_A5
        
        jsr get_polyobj

        ldy # PolyObject::visibility
_7b2a:                                                                  ;$7B2A
        lda [ZP_POLYOBJ_ADDR], y
        sta ZP_POLYOBJ_XPOS_LO, y
        dey 
        bpl _7b2a
        stx ZP_9D
        jsr _b410
        ldx ZP_9D
        
        ldy # PolyObject::visibility
        lda [ZP_POLYOBJ_ADDR], y
        and # visibility::exploding | visibility::display \
            | visibility::missiles      ;=%10100111
        sta [ZP_POLYOBJ_ADDR], y
_7b41:                                                                  ;$7B41
        inx 
        bne _7b1c
_7b44:                                                                  ;$7B44
        ldx # $00
        stx ZP_7E
        dex                     ; change X to $FF
        stx line_points_x       ; mark line-buffer-X as 'empty'
        stx line_points_y       ; makr line-buffer-Y as 'empty'

_7b4f:                                                                  ;$7B4F
        ; clear $0580..$0647
        ;
        ldy # $c7               ; length of thing at $0580
        lda # $00               ; erase...

:       sta VAR_0580, y         ; set sun scanline half-width to 0      ;$7B53
        dey 
       .bnz :-
        dey                     ; change Y to $FF
        sty VAR_0580            ; write to first entry

        rts 

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
        ; dummied-out code
_7b5e:  rts                                                             ;$75BE
;///////////////////////////////////////////////////////////////////////////////
.endif

;===============================================================================

_7b5f:                                                                  ;$7B5F
        dex 
        rts 

_7b61:                                                                  ;$7B61
.export _7b61
        inx 
        beq _7b5f
_7b64:                                                                  ;$7B64
.export _7b64
        dec PLAYER_ENERGY
        php 
        bne _7b6d
        inc PLAYER_ENERGY
_7b6d:                                                                  ;$7B6D
        plp 
        rts 

;===============================================================================

_7b6f:                                                                  ;$7B6F
.export _7b6f
        jsr _b09d                       ; draw multi-color pixel?

        lda VAR_045F
        bne _7ba8

        jsr _8c7b
        
        jmp _7bab

;===============================================================================

_7b7d:                                                                  ;$7B7D
        asl 
        tax 
        lda # $00
        ror 
        tay 
        lda # $14
        sta ZP_VAR_Q
        txa 
        jsr _3b37
        ldx ZP_VAR_P1
        tya 
        bmi _7b93
        ldy # $00
        rts 

_7b93:                                                                  ;$7B93
        ldy # $ff
        txa 
        eor # %11111111
        tax 
        inx 
        rts 


_7b9b:                                                                  ;$7B9B
        ;=======================================================================
        ; copy the X/Y/Z-position of `POLYOBJ_01` to the zero page
        ;
        ldx # (.sizeof(PolyObject::xpos) + .sizeof(PolyObject::ypos) \
            + .sizeof(PolyObject::zpos) - 1)

.import POLYOBJ_01
:       lda POLYOBJ_01, x       ;=$F925..                               ;$7B9D
        sta ZP_POLYOBJ01, x     ;=$35..
        dex 
        bpl :-

        jmp _8c8a

;===============================================================================

_7ba8:                                                                  ;$7BA8
        jsr _7b9b
_7bab:                                                                  ;$7BAB
        lda ZP_VAR_X
        jsr _7b7d
        txa 
        adc # $c3
        sta VAR_04EA
        lda ZP_VAR_Y
        jsr _7b7d
        stx ZP_VAR_T
        
        lda # $9c
        sbc ZP_VAR_T
        sta VAR_04EB

        ; use the colour from the lower-nybble of screen RAM
        ; i.e. a multi-colour pixel of %10
        lda # %10101010

        ldx ZP_VAR_X2
        
        bpl _7bcc                       ; always branches

        ; use the colour from the colour RAM ($D800+)
        ; i.e. a multi-colour pixel of %11
        lda # %11111111
_7bcc:                                                                  ;$7BCC
        sta _1d01                       ; set the colour-mask
        jmp _b09d                       ; draw multi-color pixel?

;===============================================================================

_7bd2:                                                                  ;$7BD2
.export _7bd2
        sta ZP_VAR_T
        ldx # $00
        ldy # $08
        lda [ZP_POLYOBJ_ADDR], y
        bmi _7bee

        lda PLAYER_SHIELD_FRONT
        sbc ZP_VAR_T
        bcc _7be7
        sta PLAYER_SHIELD_FRONT
        
        rts 

_7be7:                                                                  ;$7BE7
        ldx # $00
        stx PLAYER_SHIELD_FRONT
        bcc _7bfe
_7bee:                                                                  ;$7BEE
        lda PLAYER_SHIELD_REAR
        sbc ZP_VAR_T
        bcc _7bf9
        sta PLAYER_SHIELD_REAR

        rts 

_7bf9:                                                                  ;$7BF9
        ldx # $00
        stx PLAYER_SHIELD_REAR
_7bfe:                                                                  ;$7BFE
        adc PLAYER_ENERGY
        sta PLAYER_ENERGY
        beq _7c08
        bcs _7c0b
_7c08:                                                                  ;$7C08
        jmp _87d0

_7c0b:                                                                  ;$7C0B
        jsr _a813
        jmp _906a

;===============================================================================

_7c11:                                                                  ;$7C11
        lda POLYOBJ_00 + PolyObject::xpos + 1, x        ;=$F901
        sta ZP_POLYOBJ01_XPOS_pt1, x
        lda POLYOBJ_00 + PolyObject::xpos + 2, x        ;=$F902
        tay 
        and # %01111111
        sta ZP_POLYOBJ01_XPOS_pt2, x
        tya 
        and # %10000000
        sta ZP_POLYOBJ01_XPOS_pt3, x
        rts 

;===============================================================================

_7c24:                                                                  ;$7C24
.export _7c24
        jsr _b10e
        ldx # attack::active | attack::ecm      ;=%10000001
        stx ZP_POLYOBJ_ATTACK

        ldx # $00
        stx ZP_POLYOBJ_PITCH
        stx ZP_POLYOBJ_BEHAVIOUR
        stx SHIP_SLOT1
        
        dex 
        stx ZP_POLYOBJ_ROLL
        
        ldx # $0a
        jsr _7d03
        jsr _7d03
        jsr _7d03

        lda _8861
        sta hull_pointer_current_lo
        lda _8862
        sta hull_pointer_current_hi
        
        lda PSYSTEM_TECHLEVEL
        cmp # $0a
        bcc _7c61
        
        lda hull_pointer_dodo_lo
        sta hull_pointer_current_lo
        lda hull_pointer_dodo_hi
        sta hull_pointer_current_hi
_7c61:                                                                  ;$7C61
        ; scanlines for sun?
        lda #< VAR_0580
        sta ZP_TEMP_ADDR2_LO
        lda #> VAR_0580
        sta ZP_TEMP_ADDR2_HI

        lda # $02

_7c6b:                                                                  ;$7C6B
.export _7c6b

        sta ZP_VAR_T            ; put aside ship-type
        ldx # $00

:       lda SHIP_SLOTS, x       ; is this ship-slot occupied?           ;$7C6F
       .bze _7c7b               ; no, this slot is free
        inx                     ; continue to the next slot
        cpx # 10                ; maximum number of poly-objects (11)
        bcc :-                  ; keep looping if slots remain

_7c79:  ; return carry-clear for error                                  ;$7C79
        clc 
_7c7a:                                                                  ;$7C7A
        rts 

_7c7b:                                                                  ;$7C7B
        jsr get_polyobj

        lda ZP_VAR_T            ; ship type
        bmi _7cd4               ; high-bit means planet/sun?
        
        asl 
        tay 
        lda hull_pointers - 1, y
        beq _7c79
        sta ZP_HULL_ADDR_HI
        lda hull_pointers - 2, y
        sta ZP_HULL_ADDR_LO

        cpy # $04               ; is space station (coreolis)?
        beq _7cc4
        
        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_VAR

        lda SHIP_LINES_LO
        sec 
        sbc ZP_TEMP_VAR
        sta ZP_TEMP_ADDR2_LO
        
        lda SHIP_LINES_HI
        sbc # $00
        sta ZP_TEMP_ADDR2_HI
        
        lda ZP_TEMP_ADDR2_LO
        sbc ZP_POLYOBJ_ADDR_LO
        tay 
        
        lda ZP_TEMP_ADDR2_HI
        sbc ZP_POLYOBJ_ADDR_HI
        bcc _7c7a
        bne _7cba
        
        cpy # $25
        bcc _7c7a
_7cba:                                                                  ;$7CBA
        lda ZP_TEMP_ADDR2_LO
        sta SHIP_LINES_LO
        lda ZP_TEMP_ADDR2_HI
        sta SHIP_LINES_HI
_7cc4:                                                                  ;$7CC4
        ldy # Hull::energy      ;=$0E: energy
        lda [ZP_HULL_ADDR], y
        sta ZP_POLYOBJ_ENERGY

        ldy # Hull::_13         ;=$13: "laser / missile count"?
        lda [ZP_HULL_ADDR], y
        and # visibility::missiles
        sta ZP_POLYOBJ_VISIBILITY
        
        lda ZP_VAR_T
_7cd4:                                                                  ;$7CD4
        sta SHIP_SLOTS, x
        tax 
        bmi _7cec               ; is sun/planet?

        cpx # $0f
        beq _7ce6
        cpx # $03
        bcc _7ce9
        cpx # $0b
        bcs _7ce9
_7ce6:                                                                  ;$7CE6
        inc VAR_047F
_7ce9:                                                                  ;$7CE9
        inc VAR_045D, x

_7cec:  ; sun or planet                                                 ;$7CEC
        ldy ZP_VAR_T
        lda hull_d042 - 1, y
        and # (behaviour::remove | behaviour::docking)^$FF    ;=%01101111
        ora ZP_POLYOBJ_BEHAVIOUR
        sta ZP_POLYOBJ_BEHAVIOUR

        ldy # $24               ; `PolyObject::behaviour`?
_7cf9:                                                                  ;$7CF9
        lda ZP_POLYOBJ_XPOS_LO, y       ; what has this to do with behaviour???
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        bpl _7cf9
        sec 
        rts 

;-------------------------------------------------------------------------------

_7d03:                                                                  ;$7D03
        lda ZP_POLYOBJ_XPOS_LO, x
        eor # %10000000
        sta ZP_POLYOBJ_XPOS_LO, x
        inx 
        inx 
        rts 

;===============================================================================

_7d0c:                                                                  ;$7D0C
.export _7d0c
        ldx # $ff
_7d0e:                                                                  ;$7D0E
.export _7d0e
        stx ZP_MISSILE_TARGET
        ldx PLAYER_MISSILES
        jsr _b11f
        
        sty PLAYER_MISSILE_ARMED

        rts 

;===============================================================================

;$7d1a:
        .byte   $04, $00, $00, $00, $00

_7d1f:                                                                  ;$7D1F
        lda ZP_POLYOBJ_XPOS_LO
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_XPOS_MI
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_XPOS_HI
        jsr _81c9
        bcs _7d56
        lda ZP_VALUE_pt1
        adc # $80
        sta ZP_POLYOBJ01_XPOS_pt1
        txa 
        adc # $00
        sta ZP_POLYOBJ01_XPOS_pt2
        lda ZP_POLYOBJ_YPOS_LO
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_YPOS_MI
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_YPOS_HI
        eor # %10000000
        jsr _81c9
        bcs _7d56
        
        lda ZP_VALUE_pt1
        adc # $48               ;TODO: half viewport height?
        sta ZP_43

        txa 
        adc # $00
        sta ZP_44
        
        clc 
_7d56:                                                                  ;$7D56
        rts 


;===============================================================================

_7d57:                                                                  ;$7D57
        lda ZP_A5
        lsr 
        bcs _7d5f
        jmp _80bb

_7d5f:                                                                  ;$7D5F
        jmp wipe_sun

;===============================================================================

_7d62:                                                                  ;$7D62
        lda ZP_POLYOBJ_ZPOS_HI
        cmp # $30
        bcs _7d57
        ora ZP_POLYOBJ_ZPOS_MI
        beq _7d57
        jsr _7d1f
        bcs _7d57
        lda #> ELITE_MENUSCR_ADDR
        sta ZP_VAR_P2
        lda #< ELITE_MENUSCR_ADDR
        sta ZP_VAR_P1
        jsr _3bc1
        lda ZP_VALUE_pt2
        beq _7d84
        lda # $f8
        sta ZP_VALUE_pt1
_7d84:                                                                  ;$7D84
        lda ZP_A5
        lsr 
        bcc _7d8c
        jmp _7f22

_7d8c:                                                                  ;$7D8C
        jsr _80bb
        jsr _8044
        bcs _7d98
        lda ZP_VALUE_pt2
        beq _7d99
_7d98:                                                                  ;$7D98
        rts 

_7d99:                                                                  ;$7D99
        lda _1d0f
        beq _7d98
        lda ZP_A5
        cmp # $80
        bne _7de0
        lda ZP_VALUE_pt1
        cmp # $06
        bcc _7d98
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_M1x2_HI
        jsr _81aa
        ldx # $09
        jsr _7e36
        sta ZP_B2
        sty $45
        jsr _7e36
        sta ZP_B3
        sty ZP_TEMPOBJ_M2x0_HI
        ldx # $0f
        jsr _81ba
        jsr _7e54
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_M2x2_HI
        jsr _81aa
        ldx # $15
        jsr _81ba
        jmp _7e54

_7de0:                                                                  ;$7DE0
        lda ZP_POLYOBJ_M1x2_HI
        bmi _7d98
        ldx # $0f
        jsr _8189
        clc 
        adc ZP_POLYOBJ01_XPOS_pt1
        sta ZP_POLYOBJ01_XPOS_pt1
        tya 
        adc ZP_POLYOBJ01_XPOS_pt2
        sta ZP_POLYOBJ01_XPOS_pt2
        jsr _8189
        sta ZP_VAR_P1
        
        lda ZP_43
        sec 
        sbc ZP_VAR_P1
        sta ZP_43
        
        sty ZP_VAR_P1
        
        lda ZP_44
        sbc ZP_VAR_P1
        sta ZP_44
        
        ldx # $09
        jsr _7e36
        lsr 
        sta ZP_B2
        sty $45
        jsr _7e36
        lsr 
        sta ZP_B3
        sty ZP_TEMPOBJ_M2x0_HI
        ldx # $15
        jsr _7e36
        lsr 
        sta ZP_B4
        sty ZP_TEMPOBJ_M2x1_LO
        jsr _7e36
        lsr 
        sta ZP_B5
        sty ZP_TEMPOBJ_M2x1_HI
        lda # $40
        sta ZP_A8
        lda # $00
        sta ZP_AB
        jmp _7e58

_7e36:                                                                  ;$7E36
        lda ZP_POLYOBJ_XPOS_LO, x
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_XPOS_MI, x
        and # %01111111
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_XPOS_MI, x
        and # %10000000
        jsr _3bc1
        lda ZP_VALUE_pt1
        ldy ZP_VALUE_pt2
        beq _7e4f
        lda # $fe
_7e4f:                                                                  ;$7E4F
        ldy ZP_VALUE_pt4
        inx 
        inx 
        rts 

_7e54:                                                                  ;$7E54
        lda # $1f
        sta ZP_A8
_7e58:                                                                  ;$7E58
        ldx # $00
        stx ZP_AA
        dex 
        stx ZP_A9
_7e5f:                                                                  ;$7E5F
        lda ZP_AB
        and # %00011111
        tax 
        lda _0ac0, x
        sta ZP_VAR_Q
        lda ZP_B4
        jsr _39ea
        sta ZP_VAR_R
        lda ZP_B5
        jsr _39ea
        sta ZP_VALUE_pt1
        ldx ZP_AB
        cpx # $21
        lda # $00
        ror 
        sta ZP_TEMPOBJ_M2x2_HI
        lda ZP_AB
        clc 
        adc # $10
        and # %00011111
        tax 
        lda _0ac0, x
        sta ZP_VAR_Q
        lda ZP_B3
        jsr _39ea
        sta ZP_VALUE_pt3
        lda ZP_B2
        jsr _39ea
        sta ZP_VAR_P1
        lda ZP_AB
        adc # $0f
        and # %00111111
        cmp # $21
        lda # $00
        ror 
        sta ZP_TEMPOBJ_M2x2_LO
        lda ZP_TEMPOBJ_M2x2_HI
        eor ZP_TEMPOBJ_M2x1_LO
        sta ZP_VAR_S
        lda ZP_TEMPOBJ_M2x2_LO
        eor $45
        jsr multiplied_now_add
        sta ZP_VAR_T
        bpl _7ec8
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda ZP_VAR_T
        eor # %01111111
        adc # $00
        sta ZP_VAR_T
_7ec8:                                                                  ;$7EC8
        txa 
        adc ZP_POLYOBJ01_XPOS_pt1
        sta ZP_89
        lda ZP_VAR_T
        adc ZP_POLYOBJ01_XPOS_pt2
        sta ZP_8A
        lda ZP_VALUE_pt1
        sta ZP_VAR_R
        lda ZP_TEMPOBJ_M2x2_HI
        eor ZP_TEMPOBJ_M2x1_HI
        sta ZP_VAR_S
        lda ZP_VALUE_pt3
        sta ZP_VAR_P1
        lda ZP_TEMPOBJ_M2x2_LO
        eor ZP_TEMPOBJ_M2x0_HI
        jsr multiplied_now_add
        eor # %10000000
        sta ZP_VAR_T
        bpl _7efd
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda ZP_VAR_T
        eor # %01111111
        adc # $00
        sta ZP_VAR_T
_7efd:                                                                  ;$7EFD
        jsr _2977
        cmp ZP_A8
        beq _7f06
        bcs _7f12
_7f06:                                                                  ;$7F06
        lda ZP_AB
        clc 
        adc ZP_AC
        and # %00111111
        sta ZP_AB
        jmp _7e5f

_7f12:                                                                  ;$7F12
        rts 

;===============================================================================

_7f13:                                                                  ;$7F13
        jmp wipe_sun

_7f16:                                                                  ;$7F16
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
_7f1d:                                                                  ;$7F1D
        lda # $ff
        jmp _7f67

;-------------------------------------------------------------------------------

_7f22:                                                                  ;$7F22
        lda # $01
        sta VAR_0580

        jsr _814f
        bcs _7f13
        
        lda # $00
        ldx ZP_VALUE_pt1
        cpx # $60
        rol 
        cpx # $28
        rol 
        cpx # $10
        rol 
        sta ZP_AA
        lda ZP_B8
        ldx ZP_VAR_P3
        bne :+
        cmp ZP_VAR_P2
        bcc :+
        lda ZP_VAR_P2
        bne :+

        lda # $01

:       sta ZP_A8               ; first scanline of the sun             ;$7F4B
        
        lda ZP_B8               ; last scanline of the sun
        sec 
        sbc ZP_43
        tax 
        
        lda # $00
        sbc ZP_44
        bmi _7f16
        bne _7f63

        inx 
        dex 
        beq _7f1d
        cpx ZP_VALUE_pt1
        bcc _7f67
_7f63:                                                                  ;$7F63
        ldx ZP_VALUE_pt1
        lda # $00
_7f67:                                                                  ;$7F67
        stx ZP_TEMP_ADDR3_LO
        sta ZP_TEMP_ADDR3_HI    ; flag $00 = up, $FF = down?

        lda ZP_VALUE_pt1
        jsr math_square         ; square the number
        sta ZP_B3               ; squared 16-bit radius hi
        
        lda ZP_VAR_P1
        sta ZP_B2               ; squared 16-bit radius lo

        ;-----------------------------------------------------------------------
        
        ldy ZP_B8               ; begin with the lowest scanline for the sun

        ; copy sun middle-point to YY-LO/HI for the
        ; line-clipping and drawing routines used
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI
_7f80:                                                                  ;$7F80
        cpy ZP_A8               ; have we reach the top of the sun?
        beq _7f8f               ; if yes, move ahead with next step

        lda VAR_0580, y
       .bze :+                  ; if half-width is 0, no line
        jsr _28f3               ; calculate the line-width/pos & draw
:       dey                     ; next scanline                         ;$7F8C
       .bnz _7f80               ; continue scanning. reaching zero
                                ; (top of screen) also exits 

_7f8f:                                                                  ;$7F8F
        ;-----------------------------------------------------------------------
        lda ZP_TEMP_ADDR3_LO
        jsr math_square
        sta ZP_VAR_T

        lda ZP_B2
        sec 
        sbc ZP_VAR_P1
        sta ZP_VAR_Q
        lda ZP_B3
        sbc ZP_VAR_T
        sta ZP_VAR_R
        sty ZP_VAR_Y
        jsr _9978
        ldy ZP_VAR_Y
        jsr get_random_number
        and ZP_AA
        clc 
        adc ZP_VAR_Q
        bcc _7fb6
        lda # $ff
_7fb6:                                                                  ;$7FB6
        ldx VAR_0580, y
        sta VAR_0580, y
        beq _8008
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI
        txa 
        jsr clip_horz_line
        lda ZP_VAR_X
        sta ZP_VAR_XX_LO
        lda ZP_VAR_X2
        sta ZP_VAR_XX_HI
        lda ZP_POLYOBJ01_XPOS_pt1
        sta ZP_VAR_YY_LO
        lda ZP_POLYOBJ01_XPOS_pt2
        sta ZP_VAR_YY_HI
        lda VAR_0580, y
        jsr clip_horz_line
        bcs _7fed
        lda ZP_VAR_X2
        ldx ZP_VAR_XX_LO
        stx ZP_VAR_X2
        sta ZP_VAR_XX_LO
        jsr draw_straight_line
_7fed:                                                                  ;$7FED
        lda ZP_VAR_XX_LO
        sta ZP_VAR_X
        lda ZP_VAR_XX_HI
        sta ZP_VAR_X2
_7ff5:                                                                  ;$7FF5
        jsr draw_straight_line
_7ff8:                                                                  ;$7FF8
        dey 
        beq _803a
        lda ZP_TEMP_ADDR3_HI
        bne _801c
        dec ZP_TEMP_ADDR3_LO
        bne _7f8f
        dec ZP_TEMP_ADDR3_HI
_8005:                                                                  ;$8005
        jmp _7f8f

_8008:                                                                  ;$8008
        ldx ZP_POLYOBJ01_XPOS_pt1
        stx ZP_VAR_YY_LO
        ldx ZP_POLYOBJ01_XPOS_pt2
        stx ZP_VAR_YY_HI
        jsr clip_horz_line
        bcc _7ff5
        lda # $00
        sta VAR_0580, y
        beq _7ff8
_801c:                                                                  ;$801C
        ldx ZP_TEMP_ADDR3_LO
        inx 
        stx ZP_TEMP_ADDR3_LO
        cpx ZP_VALUE_pt1
        bcc _8005
        beq _8005
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI
_802f:                                                                  ;$02F
        lda VAR_0580, y
        beq _8037
        jsr _28f3               ;...draw_straight_line
_8037:                                                                  ;$8037
        dey 
        bne _802f
_803a:                                                                  ;$803A
        clc 
        lda ZP_POLYOBJ01_XPOS_pt1
        sta ZP_SUNX_LO
        lda ZP_POLYOBJ01_XPOS_pt2
        sta ZP_SUNX_HI
_8043:                                                                  ;$8043
        rts 

;===============================================================================

_8044:                                                                  ;$8044
        jsr _814f
        bcs _8043

        lda # $00
        sta line_points_x
        
        ldx ZP_VALUE_pt1
        lda # $08
        cpx # $08
        bcc _805c
        lsr 
        cpx # $3c
        bcc _805c
        lsr 
_805c:                                                                  ;$805C
        sta ZP_AC
_805e:                                                                  ;$805E
.export _805e
        ldx # $ff
        stx ZP_A9
        inx 
        stx ZP_AA
_8065:                                                                  ;$8065
        lda ZP_AA
        jsr _39e0

        ldx # $00
        stx ZP_VAR_T

        ldx ZP_AA
        cpx # $21
        bcc _8081
        
        eor # %11111111
        adc # $00
        tax 
        lda # $ff
        adc # $00
        sta ZP_VAR_T
        txa 
        clc 
_8081:                                                                  ;$8081
        adc ZP_POLYOBJ01_XPOS_pt1
        sta ZP_89
        lda ZP_POLYOBJ01_XPOS_pt2
        adc ZP_VAR_T
        sta ZP_8A
        lda ZP_AA
        clc 
        adc # $10
        jsr _39e0
        tax 
        lda # $00
        sta ZP_VAR_T
        lda ZP_AA
        adc # $0f
        and # %00111111
        cmp # $21
        bcc _80af
        txa 
        eor # %11111111
        adc # $00
        tax 
        lda # $ff
        adc # $00
        sta ZP_VAR_T
        clc 
_80af:                                                                  ;$80AF
        jsr _2977
        cmp # $41
        bcs _80b9
        jmp _8065

_80b9:                                                                  ;$80B9
        clc 
        rts 

_80bb:                                                                  ;$80BB
        ldy line_points_x
        bne _80f5
_80c0:                                                                  ;$80C0
        cpy ZP_7E
        bcs _80f5

        lda line_points_y, y
        cmp # $ff
        beq _80e6

        sta ZP_VAR_Y2
        lda line_points_x, y
        sta ZP_VAR_X2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line
        iny 
        lda VAR_06F4
        bne _80c0
        lda ZP_VAR_X2
        sta ZP_VAR_X
        lda ZP_VAR_Y2
        sta ZP_VAR_Y
        jmp _80c0

_80e6:                                                                  ;$80E6
        iny 
        lda line_points_x, y
        sta ZP_VAR_X
        lda line_points_y, y
        sta ZP_VAR_Y
        iny 
        jmp _80c0

_80f5:                                                                  ;$80F5
        lda # $01
        sta ZP_7E
        lda # $ff
        sta line_points_x
_80fe:                                                                  ;$80FE
        rts 

wipe_sun:                                                               ;$80FF
;===============================================================================
; wipe sun
;
.export wipe_sun

        lda VAR_0580
        bmi _80fe

        ; copy sun's horizontal position to YY-LO/HI,
        ; as this is what the drawing operations use
        lda ZP_SUNX_LO
        sta ZP_VAR_YY_LO
        lda ZP_SUNX_HI
        sta ZP_VAR_YY_HI

        ; this is the vertical cut-off point
        ldy # ELITE_VIEWPORT_HEIGHT-1
@loop:                                                                  ;$810E
        ; check if a line needs to be drawn at this Y-position
        lda VAR_0580, y         ; read half-width of line
       .bze:+                   ; if zero, skip

        jsr _28f3               ; work out X1/X2 from middle+width, and draw

:       dey                                                             ;$8116
       .bnz @loop
        
        dey 
        sty VAR_0580
        
        rts 

;===============================================================================
; clip a centred, horizontal line so that it fits within the viewport. this
; routine is used when drawing the sun as that is stored as a centre-point
; and a series of half-widths for each scanline to trace the shape
;
; note that YY is a signed 16-bit number because the sun can be so large as to
; be way off the sides of the screen, but still be partially visible on screen
;
;      YY = middle-point of line (16-bit)
;       A = half-width
;       Y must be preserved!
;
clip_horz_line:                                                         ;$811E
;-------------------------------------------------------------------------------
.export clip_horz_line

        sta ZP_VAR_T            ; put aside half-width

        ; find right-hand point (X2); i.e. middle (YY) + half-width (T)
        ; and clip if it goes beyond the viewport right edge (256)
        ;
        clc 
        adc ZP_VAR_YY_LO        ; "add centre of line X mid-point"?
        sta ZP_VAR_X2           ; this is the right-hand X-coord
        lda ZP_VAR_YY_HI        ; did it overflow?
        adc # $00               ; apply the carry

        bmi @clear              ; too large, don't draw!
        beq @left               ; fits, now do left-side

        ; line clips to right of viewport (256)
        lda # ELITE_VIEWPORT_WIDTH-1
        sta ZP_VAR_X2

@left:                                                                  ;$8131
        ;-----------------------------------------------------------------------
        ; find left-hand point (X1); i.e. middle (YY) - half-width (T)
        ; and clip if it goes byeond the viewport left edge (0)
        ;
        lda ZP_VAR_YY_LO        ; begin with middle-point
        sec 
        sbc ZP_VAR_T            ; subtract the half-width
        sta ZP_VAR_X1           ; this is the left-hand X-coord
        lda ZP_VAR_YY_HI        
        sbc # $00               ; apply the carry
       .bnz :+                  ; did it overflow?
        
        ; it fits, X1 is fine
        ; return carry clear = OK
        clc 
        rts 

        ;-----------------------------------------------------------------------
        ; too large, don't draw?
:       bpl @clear                                                      ;$8140

        ; line clips to the left of the viewport (0)
        lda # $00
        sta ZP_VAR_X1
        
        ; return carry clear = OK
        clc 
        rts 

@clear:                                                                  ;$8148
        ;-----------------------------------------------------------------------
        ; remove the line from the line-queue
        ;
        lda # $00
        sta VAR_0580, y
        
        ; return carry set = error
        sec 
        rts 

;===============================================================================
; ".CHKON ; check extent of circles, P+1 set to maxY, Y protected."
;
_814f:                                                                  ;$814F

        lda ZP_POLYOBJ01_XPOS_pt1
        clc 
        adc ZP_VALUE_pt1
        lda ZP_POLYOBJ01_XPOS_pt2
        adc # $00
        bmi _8187
        lda ZP_POLYOBJ01_XPOS_pt1
        sec 
        sbc ZP_VALUE_pt1
        lda ZP_POLYOBJ01_XPOS_pt2
        sbc # $00
        bmi _8167
        bne _8187
_8167:                                                                  ;$8167
        lda ZP_43
        clc 
        adc ZP_VALUE_pt1
        sta ZP_VAR_P2
        
        lda ZP_44
        adc # $00
        bmi _8187
        sta ZP_VAR_P3
        
        lda ZP_43
        sec 
        sbc ZP_VALUE_pt1
        tax 
        
        lda ZP_44
        sbc # $00
        bmi _81ec
        bne _8187
        cpx ZP_B8
        rts 

_8187:                                                                  ;$8187
        sec 
        rts 

_8189:                                                                  ;$8189
        jsr _7e36
        sta ZP_VAR_P1
        lda # $de
        sta ZP_VAR_Q
        stx ZP_VAR_U
        jsr _399b
        ldx ZP_VAR_U
        ldy ZP_VALUE_pt4
        bpl _81a7
        eor # %11111111
        clc 
        adc # $01
        beq _81a7
        ldy # $ff
        rts 

_81a7:                                                                  ;$81A7
        ldy # $00
        rts 

_81aa:                                                                  ;$81AA
        sta ZP_VAR_Q
        jsr _3c95
        ldx ZP_POLYOBJ_M0x2_HI
        bmi _81b5
        eor # %10000000
_81b5:                                                                  ;$81B5
        lsr 
        lsr 
        sta ZP_AB
        rts 

_81ba:                                                                  ;$81BA
        jsr _7e36
        sta ZP_B4
        sty ZP_TEMPOBJ_M2x1_LO
        jsr _7e36
        sta ZP_B5
        sty ZP_TEMPOBJ_M2x1_HI
        rts 

_81c9:                                                                  ;$81C9
        jsr _3bc1
        lda ZP_VALUE_pt4
        and # %01111111
        ora ZP_VALUE_pt3
        bne _8187
        ldx ZP_VALUE_pt2
        cpx # $04
        bcs _81ed
        lda ZP_VALUE_pt4
        bpl _81ed
        lda ZP_VALUE_pt1
        eor # %11111111
        adc # $01
        sta ZP_VALUE_pt1
        txa 
        eor # %11111111
        adc # $00
        tax 
_81ec:                                                                  ;$81EC
        clc 
_81ed:                                                                  ;$81ED
        rts 

;===============================================================================

_81ee:                                                                  ;$81EE
.export _81ee
        jsr wait_for_input
        cmp # $59
        beq _81ed
        cmp # $4e
        bne _81ee
        clc 
        rts 

;===============================================================================

_81fb:                                                                  ;$81FB
        lda ZP_SCREEN
        bne _8204

        jsr _8ee3
        txa 
        rts 

_8204:                                                                  ;$8204
        jsr _8ee3
        lda _1d0c
        beq _8244
        lda joy_left
        bit joy_right
        bpl _8216
        lda # $01
_8216:                                                                  ;$8216
        bit joy_fire
        bpl _821d
        asl 
        asl 
_821d:                                                                  ;$821D
        tax 
        lda joy_down
        bit joy_up
        bpl _8228
        lda # $01
_8228:                                                                  ;$8228
        bit joy_fire
        bpl _822f
        asl 
        asl 
_822f:                                                                  ;$822F
        tay 
        lda # $00
        sta joy_left
        sta joy_right
        sta joy_down
        sta joy_up
        sta joy_fire
        lda ZP_7D
        rts 

;===============================================================================

_8244:                                                                  ;$8244
        lda key_right
        beq _8251

        lda # $01
        ora key_lshft
        ora key_rshft
_8251:                                                                  ;$8251
        bit key_return
        bpl _8258
        asl 
        asl 
_8258:                                                                  ;$8258
        tax 
        lda key_down
        beq _8268
        lda # $01
        ora key_lshft
        ora key_rshft
        eor # %11111110
_8268:                                                                  ;$8268
        bit key_return
        bpl _826f
        asl 
        asl 
_826f:                                                                  ;$826F
        tay 
        lda ZP_7D
        rts 


disable_sprites:                                                        ;$8273
;===============================================================================
; disable all sprites: (for example, when switching to menu screen)
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; ensure the I/O is enabled so we can talk to the VIC-II:
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; disable all sprites
        lda # %00000000
        sta VIC_SPRITE_ENABLE

.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL
        rts 
.else   ;///////////////////////////////////////////////////////////////////////
        ; switch back to 64K RAM layout
        lda # C64_MEM::ALL

        ; fall-through to the routine below

set_memory_layout:                                                      ;$827F
;===============================================================================
.export set_memory_layout

        sei                     ; disable interrupts
        
        ; remember the requested memory layout state
        sta current_memory_layout
        
        ; set the given memory layout:
        ; (update the processor port)
        lda CPU_CONTROL
        and # %11111000         ; clear lower 3-bits whilst keeping upper bits
        ora current_memory_layout
        sta CPU_CONTROL
        
        cli                     ; enable interrupts
        rts 

current_memory_layout:                                                  ;$828E
        .byte   C64_MEM::ALL

.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; transfer the address in P1/P2 to the ship lines pointer
;
_828f:                                                                  ;$828F
        lda ZP_VAR_P1
        sta SHIP_LINES_LO
        lda ZP_VAR_P2
        sta SHIP_LINES_HI

        rts 

;===============================================================================

_829a:                                                                  ;$829A
.export _829a
        ldx ZP_9D
        jsr _82f3
        ldx ZP_9D
        jmp _202f

;===============================================================================

_82a4:                                                                  ;$82A4
        jsr clear_zp_polyobj
        jsr _7b4f
        sta SHIP_SLOT1
        sta VAR_045F
        jsr _b10e
        lda # $06
        sta ZP_POLYOBJ_YPOS_HI
        lda # $81
        jmp _7c6b

;===============================================================================

.import hull_missile_index:direct
.import hull_coreolis_index:direct
.import hull_constrictor_index:direct

_82bc:                                                                  ;$82BC
        ldx # $ff
_82be:                                                                  ;$82BE
        inx                     ; move to the next slot
        lda SHIP_SLOTS, x
       .bze _828f               ; nothing in that slot?

        ; is it a missile?
        cmp # hull_missile_index
        bne _82be               ; no -- check next ship slot

        ; missile?

        txa                     ; slot index
        asl                     ; double for lookup table
        tay                     ; move to index register
        
        ; get the PolyObject address from that index
        lda polyobj_addrs_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda polyobj_addrs_hi, y
        sta ZP_TEMP_ADDR1_HI
        
        ldy # PolyObject::attack
        lda [ZP_TEMP_ADDR1], y
        bpl _82be               ; if +ve, check next ship slot

        and # %01111111         ; remove the sign
        lsr                     ; divide by 2
        cmp ZP_AD               ;?
       .blt _82be               ;?
        beq _82ed               ;?
        sbc # $01               ; adjust for two's compliment
        asl                     ; multiply by 2
        ora # %10000000         ; add the sign on again
        sta [ZP_TEMP_ADDR1], y  ; update the roll value
        bne _82be               ; if not zero, check next ship slot

_82ed:                                                                  ;$82ED
        lda # PolyObject::xpos  ;=$00
        sta [ZP_TEMP_ADDR1], y
        beq _82be               ; if zero, check the next ship slot

_82f3:                                                                  ;$82F3
        stx ZP_AD
        lda ZP_MISSILE_TARGET
        cmp ZP_AD
        bne _8305

        ldy # $57
        jsr _7d0c

        lda # $c8
        jsr _900d
_8305:                                                                  ;$8305
        ldy ZP_AD
        ldx SHIP_SLOTS, y

        ; is space station?
        cpx # hull_coreolis_index
        beq _82a4

        ; is Constrictor?
        cpx # hull_constrictor_index
        bne _831d

        ; the Constrictor has been destroyed!
        ; set the Constrictor mission complete
        lda MISSION_FLAGS
        ora # missions::constrictor_complete
        sta MISSION_FLAGS
        
        inc PLAYER_KILLS

_831d:                                                                  ;$831D
        cpx # $0f               ; is asteroid?
        beq _8329
        cpx # $03               ; is escape capsule?
        bcc _832c
        cpx # $0b               ; is cobra mk-III? (trader)
        bcs _832c
_8329:                                                                  ;$8329
        dec VAR_047F
_832c:                                                                  ;$832C
        dec VAR_045D, x

        ldx ZP_AD

        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y

        ldy # PolyObject::speed ;=$21
        clc 
        adc [ZP_POLYOBJ_ADDR], y
        sta ZP_VAR_P1
        
        iny                     ;=$22: acceleration
        lda [ZP_POLYOBJ_ADDR], y
        adc # $00
        sta ZP_VAR_P2
_8343:                                                                  ;$8343
        ; move the ship slots down?
        inx 
        lda SHIP_SLOTS, x
        sta SHIP_SLOTS-1, x
        bne _834f
        jmp _82bc               ; search again from the top

_834f:                                                                  ;$834F
        asl 
        tay 
        lda hull_pointers - 2, y
        sta ZP_TEMP_ADDR1_LO
        lda hull_pointers - 1, y
        sta ZP_TEMP_ADDR1_HI
        
        ldy # $05
        lda [ZP_TEMP_ADDR1], y
        sta ZP_VAR_T
        lda ZP_VAR_P1
        sec 
        sbc ZP_VAR_T
        sta ZP_VAR_P1
        lda ZP_VAR_P2
        sbc # $00
        sta ZP_VAR_P2
        txa 
        asl 
        tay 
        lda polyobj_addrs_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda polyobj_addrs_hi, y
        sta ZP_TEMP_ADDR1_HI

        ldy # $24
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta ZP_VALUE_pt2
        lda ZP_VAR_P2
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta ZP_VALUE_pt1
        lda ZP_VAR_P1
        sta [ZP_POLYOBJ_ADDR], y
        dey 
_8399:                                                                  ;$8399
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_POLYOBJ_ADDR], y
        dey 
        bpl _8399
        lda ZP_TEMP_ADDR1_LO
        sta ZP_POLYOBJ_ADDR_LO
        lda ZP_TEMP_ADDR1_HI
        sta ZP_POLYOBJ_ADDR_HI
        ldy ZP_VAR_T
_83aa:                                                                  ;$83AA
        dey 
        lda [$77], y
        sta [$2e], y
        tya 
        bne _83aa
        beq _8343
_83b4:                                                                  ;$83B4
        ; is the player in Galaxy 2?
        ldx PLAYER_GALAXY
        dex 
        bne _83c8

        ; is the player at Orarra?

        lda PSYSTEM_POS_X
        cmp # 144
        bne _83c8
        lda PSYSTEM_POS_Y
        cmp # 33
        beq _83c9
_83c8:                                                                  ;$83C8
        clc 
_83c9:                                                                  ;$83C9
        rts 

;===============================================================================

_83ca:                                                                  ;$83CA
        ; clear ships slots and some other data?
        jsr _8ac7               ; erase $0452...$048C (58 bytes)

        ; erase $63...$69
        ; (pitch, roll, hyperspace countdown?)
        ldx # $06
:       sta ZP_BETA, x                                                  ;$83CF
        dex 
        bpl :-

        txa                     ; set A = 0 (saves a byte over `lda # $00`)
        sta ZP_A7               ; docked flag?

        ; erase $04E7...$04E9
        ; player sheild and energy
        ldx # $02
:       sta PLAYER_SHIELD_FRONT, x                                      ;$83D9
        dex 
        bpl :-

_83df:                                                                  ;$83DF
;-------------------------------------------------------------------------------
.export _83df
        ; clears SID registers?
        jsr _923b

        lda PLAYER_EBOMB
        bpl _83ed

        jsr _2367
        sta PLAYER_EBOMB
_83ed:                                                                  ;$83ED
        lda # $0c
        sta DUST_COUNT          ; number of dust particles

        ; clear line-buffer?
        ldx # $ff
        stx line_points_x
        stx line_points_y

        stx ZP_MISSILE_TARGET   ; no missile target

        lda # $80
        sta VAR_048E            ; joystick Y?
        sta ZP_ROLL_SIGN
        sta ZP_PITCH_SIGN

        asl                     ;=0
        sta ZP_BETA
        sta ZP_PITCH_MAGNITUDE
        sta ZP_6A               ; move count?
        sta ZP_95
        sta ZP_A3               ; move counter?
.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        sta TRUMBLES_ONSCREEN   ; number of Trumble™ sprites on-screen
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $03
        sta PLAYER_SPEED
        sta ZP_ALPHA
        sta ZP_ROLL_MAGNITUDE
        
        lda # $10
        sta VAR_050C
        
        lda # $00               ;?
        sta ZP_B7
        lda # $8F               ;?
        sta ZP_B8
        
        lda VAR_045F
        beq _8430
        jsr _b10e
_8430:                                                                  ;$8430
        lda ZP_67
        beq _8437
        jsr _a786
_8437:                                                                  ;$8437
        jsr _7b1a
        jsr _8ac7               ; clear ship slots and other vars
        
        lda #< $ffc0            ;?
        sta SHIP_LINES_LO
        lda #> $ffc0            ;?
        sta SHIP_LINES_HI

clear_zp_polyobj:                                                       ;$8447
        ;-----------------------------------------------------------------------
        ; clear the zero-page PolyObject storage
        ;
.export clear_zp_polyobj

        ldy # .sizeof(PolyObject) - 1
        lda # $00
:       sta ZP_POLYOBJ_XPOS_LO, y                                       ;$844B
        dey 
        bpl :-

        ; set the default $6000 vector scale?
        lda # $60
        sta ZP_POLYOBJ_M1x1_HI
        sta ZP_POLYOBJ_M2x0_HI
        ora # %10000000
        sta ZP_POLYOBJ_M0x2_HI
        
        rts 

;===============================================================================
; update missile blocks on HUD?
;
_845c:                                                                  ;$845C
        ldx # $04               ; number of missile blocks

:       cpx PLAYER_MISSILES     ; player missile count                  ;$845E
        beq @_846c              ; colour remaining missiles

        ldy # $b7
        jsr _b11f
        dex 
        bne :-

        rts 

@_846c:                                                                 ;$846C
        ldy # $57
        jsr _b11f
        dex 
        bne @_846c

        rts 

;===============================================================================

_8475:                                                                  ;$8475
        lda ZP_SCREEN
        bne _8487

        lda VAR_04E6
        jsr _900d
        lda # $00
        sta VAR_048B
        jmp _84fa

_8487:                                                                  ;$8487
        jsr txt_docked_token15
        jmp _84fa

;===============================================================================

_848d:                                                                  ;$848D
        jsr clear_zp_polyobj
        jsr get_random_number
        sta ZP_TEMP_VAR
        and # %10000000
        sta ZP_POLYOBJ_XPOS_HI
        txa 
        and # %10000000
        sta ZP_POLYOBJ_YPOS_HI
        lda # $19
        sta ZP_POLYOBJ_XPOS_MI
        sta ZP_POLYOBJ_YPOS_MI
        sta ZP_POLYOBJ_ZPOS_MI
        txa 
        cmp # $f5
        rol                     ; increase aggression level?
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_POLYOBJ_ATTACK
_84ae:                                                                  ;$84AE
        clc 

get_random_number:                                                      ;$84AF
        ;=======================================================================
        ; generate an 8-bit 'random' number
        ;
.export get_random_number
        lda ZP_GOATSOUP_pt1
        rol 
        tax 
        adc ZP_GOATSOUP_pt3
        sta ZP_GOATSOUP_pt1
        stx ZP_GOATSOUP_pt3
        lda ZP_GOATSOUP_pt2
        tax 
        adc ZP_GOATSOUP_pt4
        sta ZP_GOATSOUP_pt2
        stx ZP_GOATSOUP_pt4
        rts 

;===============================================================================

_84c3:                                                                  ;$84C3
        jsr get_random_number
        lsr 
        sta ZP_POLYOBJ_ATTACK
        sta ZP_POLYOBJ_ROLL
        rol ZP_POLYOBJ_VISIBILITY       ;?
        and # %00011111
        ora # %00010000
        sta ZP_POLYOBJ_VERTX_LO
        
        jsr get_random_number
        bmi _84e2

        lda ZP_POLYOBJ_ATTACK
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_POLYOBJ_ATTACK
        
        ldx # behaviour::docking
        stx ZP_POLYOBJ_BEHAVIOUR
_84e2:                                                                  ;$84E2
        and # %00000010
        adc # $0b
        cmp # $0f
        beq _84ed
        jsr _7c6b

; main loop?
;
_84ed:                                                                  ;$84ED
        jsr _1ec1
        dec VAR_048B            ; reduce delay?
        beq _8475
        bpl _84fa
        inc VAR_048B
_84fa:                                                                  ;$84FA
        dec ZP_A3               ; move counter?
        beq _8501
_84fe:                                                                  ;$84FE
        jmp _8627               ; jump down to main loop?

_8501:                                                                  ;$8501
        lda IS_WITCHSPACE       ; are we in witchspace?
       .bnz _84fe               ; yes -- skip to the main loop

        jsr get_random_number
        cmp # $23
        bcs _8562
        lda VAR_047F            ; number of asteroids?
        cmp # $03               ; more than 2?
        bcs _8562

        jsr clear_zp_polyobj    ; clear the temp polyobject ready for spawning

        lda # $26
        sta ZP_POLYOBJ_ZPOS_MI  ; set the middle distance
        jsr get_random_number   ; vary the distance a little
        sta ZP_POLYOBJ_XPOS_LO  ; spread the objects about horionzontally...
        stx ZP_POLYOBJ_YPOS_LO  ; ...and vertically
        and # %10000000         ; pick the sign from the random number
        sta ZP_POLYOBJ_XPOS_HI  ; position object either left or right of us
        txa 
        and # %10000000         ; pick another sign from the random number
        sta ZP_POLYOBJ_YPOS_HI  ; position the object either above or below
        rol ZP_POLYOBJ_XPOS_MI  ; increase the scale of the left/right spread
        rol ZP_POLYOBJ_XPOS_MI  ; now, with more feeling

        jsr get_random_number
        bvs _84c3
        ora # %01101111
        sta ZP_POLYOBJ_ROLL
        lda VAR_045F
        bne _8562
        txa 
        bcs _8548
        and # %00011111
        ora # %00010000
        sta ZP_POLYOBJ_VERTX_LO
        bcc _854c
_8548:                                                                  ;$8548
        ora # %01111111
        sta ZP_POLYOBJ_PITCH
_854c:                                                                  ;$854C
        jsr get_random_number
        cmp # $fc
        bcc _8559

        lda # attack::ecm | attack::aggr1 | attack::aggr2 | attack::aggr3
        sta ZP_POLYOBJ_ATTACK   ;=%00001111
        bne _855f
_8559:                                                                  ;$8559
        cmp # $0a
        and # %00000001
        adc # $05
_855f:                                                                  ;$855F
        jsr _7c6b
_8562:                                                                  ;$8562
        lda VAR_045F
        beq _856a
_8567:                                                                  ;$8567
        jmp _8627

_856a:                                                                  ;$856A
        jsr _8798
        asl 
        ldx VAR_046D
        beq _8576
        ora PLAYER_LEGAL
_8576:                                                                  ;$8576
        sta ZP_VAR_T
        jsr _848d
        cmp # $88
        beq _85f8
        cmp ZP_VAR_T
        bcs _8588
        lda # $10
        jsr _7c6b
_8588:                                                                  ;$8588
        lda VAR_046D
        bne _8567
        dec VAR_048A
        bpl _8567
        inc VAR_048A
        lda MISSION_FLAGS
        and # %00001100
        cmp # $08
        bne _85a8
        jsr get_random_number
        cmp # $c8
        bcc _85a8
_85a5:                                                                  ;$85A5
        jsr _739b
_85a8:                                                                  ;$85A8
        jsr get_random_number
        ldy PSYSTEM_GOVERNMENT
        beq _85bb
        cmp # $5a
        bcs _8567
        and # %00000111
        cmp PSYSTEM_GOVERNMENT
        bcc _8567
_85bb:                                                                  ;$85BB
        jsr _848d
        cmp # $64
        bcs _860b
        inc VAR_048A
        and # %00000011
        adc # $18
        tay 
        jsr _83b4
        bcc _85e0

        ; perhaps this bit-pattern has an alternative meaning?
        lda # attack::active | attack::target \
            | attack::aggr5 | attack::aggr4 | attack::aggr3 \
            | attack::ecm
        sta ZP_POLYOBJ_ATTACK   ;=%11111001

        lda MISSION_FLAGS
        and # missions::constrictor
        lsr 
        bcc _85e0
        
        ora VAR_047C
        beq _85f0
_85e0:                                                                  ;$85E0
        lda # behaviour::angry
        sta ZP_POLYOBJ_BEHAVIOUR

        jsr get_random_number
        cmp # $c8
        rol 
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_POLYOBJ_ATTACK
        tya 
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_85f0:                                                                  ;$85F0
        lda # $1f
_85f2:                                                                  ;$85F2
        jsr _7c6b
        jmp _8627

_85f8:                                                                  ;$85F8
        lda POLYOBJ_00 + PolyObject::zpos                               ;=$F906
        and # %00111110
        bne _85a5
        
        lda # $12
        sta ZP_POLYOBJ_VERTX_LO
        
        ; perhaps this bit-pattern has an alternative meaning?
        lda # attack::target \
            | attack::aggr5 | attack::aggr4 | attack::aggr3 \
            | attack::ecm
        sta ZP_POLYOBJ_ATTACK   ;=%01111001
        
        lda # $20
        bne _85f2
_860b:                                                                  ;$860B
        and # %00000011
        sta VAR_048A
        sta ZP_A2
_8612:                                                                  ;$8612
        jsr get_random_number
        sta ZP_VAR_T
        jsr get_random_number
        and ZP_VAR_T
        and # %00000111
        adc # $11
        jsr _7c6b
        dec ZP_A2
        bpl _8612

; main loop?
;
_8627:                                                                  ;$8627
        ;=======================================================================
        ; reset the stack pointer!
        ldx # $ff
        txs 

        ; cool down lasers:
        ;
        ldx PLAYER_TEMP_LASER   ; get current laser temperature
        beq :+                  ; skip if > 0
        dec PLAYER_TEMP_LASER   ; reduce laser temperature

:       ldx VAR_0487                                                    ;$8632
        beq @_863e
        dex 
        beq :+
        dex 
:       stx VAR_0487                                                    ;$863B

@_863e:                                                                 ;$863E
        lda ZP_SCREEN
       .bnz :+                  ; not flight screen? skip

        jsr _2ff3

:       lda ZP_SCREEN                                                ;$8645
       .bze @_8654              ; on flight screen? skip

        and _1d08
        lsr 
        bcs @_8654
        
        ldy # 2
        jsr wait_frames

@_8654:                                                                 ;$8654
        ; handle breeding for < 256 Trumbles™
        ;-----------------------------------------------------------------------
        ; does the player have more than 256 Trumbles™?
        lda PLAYER_TRUMBLES_HI
       .bze :+                  ; no? skip ahead

        ; check for breeding:
        ;
        jsr get_random_number   ; pick a random number between 0-255
        cmp # 220               ; is it >= 220? (about 10% chance)
                                ; note that this will set carry

        ; add the carry, if present
        lda PLAYER_TRUMBLES_LO
        adc # $00
        sta PLAYER_TRUMBLES_LO
        bcc :+                  ; if that didn't exceed 256, skip over
        
        inc PLAYER_TRUMBLES_HI  ; increase the Trumble™ count hi-byte
        bpl :+                  ; OK if the hi-byte remains < 128
        dec PLAYER_TRUMBLES_HI  ; when above 32'768 Trumbles™, step back one

        ; handle breeding for > 255 Trumbles™
        ;-----------------------------------------------------------------------
        ; skip over if less than 256 Trumbles™
:       lda PLAYER_TRUMBLES_HI                                          ;$8670
       .bze @_86a1
        
        sta ZP_VAR_T            ; put aside the Trumble™ hi-byte
                                ; this will be the 'odds' (n/256)
        lda PLAYER_TEMP_CABIN   ; get current cabin temperature
        cmp # 224               ; is it >= 224?
        bcs :+                  ; yes, skip the next instruction
                                ; (reduces Trumble™ growth in hot conditions)

        asl ZP_VAR_T            ; double the odds

:       jsr get_random_number   ; pick a random number 0-255            ;$8680
        cmp ZP_VAR_T            ; compare against our odds
        bcs @_86a1              ; if random number >= odds, skip

        jsr get_random_number
        ora # %01000000         ;?
        tax 

        lda # $80
        ldy PLAYER_TEMP_CABIN   ; get current cabin temperature
        cpy # 224               ; is it >= 224?
        bcc :+                  ; if not, skip over

        txa 
        and # %00001111
        tax 

        lda # $f1
        
:       ldy # $0e                                                       ;$869C
        jsr _a850               ;???

@_86a1:                                                                 ;$86A1
        jsr _81fb
_86a4:                                                                  ;$86A4
        jsr @_86b1
        lda ZP_A7
        beq :+
        jmp _8627
:       jmp _84ed                                                       ;$86AE

        ; key commands:
        ;-----------------------------------------------------------------------
@_86b1:                                                                 ;$86B1
        ; key for status page pressed?
        ; (default '8' in original Elite)
        cmp # .key_index(key_status)
        bne :+                  ; no? skip over
        jmp status_screen       ; switch to the status screen

        ; key for galactic chart pressed?
        ; (default '4' in original Elite)
:       cmp # .key_index(key_chart_galactic)                            ;$86B8
        bne :+                  ; no? skip over
        jmp galactic_chart      ; switch to galactic chart screen

        ; key for local (short-range) chart pressed?
        ; (default '5' in original Elite)
:       cmp # .key_index(key_chart_local)                               ;$86BF
        bne :+                  ; no? skip over
        jmp local_chart         ; switch to local chart screen

        ; key for planetary information pressed?
        ; (default '6' in original Elite)
:       cmp # .key_index(key_planet)                                    ;$86C6
        bne :+                  ; no? skip over
        jsr _70ab               ; prepare planet seed?
        jmp planet_screen       ; switch to planetary information screen

        ; key for inventory screen pressed?
        ; (default '9' in original Elite)
:       cmp # .key_index(key_inventory)                                 ;$68D0
        bne :+                  ; no? skip over
        jmp inventory_screen    ; switch to inventory screen

        ; key for market prices screen pressed?
        ; (default '7' in original Elite)
:       cmp # .key_index(key_market)                                    ;$86D7
        bne :+                  ; no? skip over
        jmp market_screen       ; switch to market prices screen

:       cmp # $3c               ; 'F1'?                                 ;$86DE
        bne :+                  ; no? skip over
        jmp _741c               ; launch?!

:       bit ZP_A7                                                       ;$86E5
        bpl @_870d

        ; key for buy equipment screen pressed?
        ; (default '3' in original Elite)
        cmp # .key_index(key_buy_equipment)
        bne :+                  ; no? skip over
        jmp equipment_screen    ; switch to buy equipment screen

        ; key for buy cargo screen pressed?
        ; (default '1' in original Elite)
:       cmp # .key_index(key_buy_cargo)                                 ;$86F0
        bne :+                  ; no? skip over
        jmp buy_screen          ; switch to buy cargo screen

:       cmp # $12               ; '@'?                                  ;$86F7
        bne @_8706
        jsr _8ae7
        bcc :+
        jmp _88ac               ;? (do something on disk-error?)
:       jmp _88e7                                                       ;$8703

        ; key for sell cargo screen pressed?
        ; (default '2' in original Elite)
@_8706:                                                                 ;$8706
        cmp # .key_index(key_sell_cargo)
        bne @_8724
        jmp sell_cargo          ; switch to sell cargo screen

@_870d: ; cockpit view keys:                                            ;$870D
        ;-----------------------------------------------------------------------
        ; rear view -- 'F3' by default
        cmp # .key_index(key_view_rear)
        beq @rear
        ; left view -- 'F5' by default
        cmp # .key_index(key_view_left)
        beq @left
        ; right view -- 'F7' by default
        cmp # .key_index(key_view_right)
        bne @_8724

        ; select right view:
@right: ldx # $03

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

        ; select left view:
@left:  ldx # $02                                                       ;$871C

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
        
        ; select rear view:
@rear:  ldx # $01                                                       ;$871F

        ; set cockpit camera view?
        jmp _a6ba

@_8724:                                                                 ;$872F
        ;-----------------------------------------------------------------------
        ; TODO: why not `cmp #xx`? (2 cycles faster)
        bit key_hyperspace      ; hyperspace key pressed?
        bpl :+
        
        jmp _715c

:       cmp # $2e               ; 'f'?                                  ;$872C
        beq _877e
        cmp # $2b               ; 'c'?
        bne :+
        lda ZP_A7
        beq _877d

        lda ZP_SCREEN
        and # %11000000
        beq _877d
        
        jmp _31c6

:       sta ZP_TEMP_VAR                                                 ;$8741

        lda ZP_SCREEN
        and # %11000000

        beq _875f
        lda ZP_66               ; hyperspace countdown (outer)?
        bne _875f
        
        lda ZP_TEMP_VAR
        cmp # $1a
        bne :+

        jsr _6f82
        jsr set_psystem_to_tsystem
        jmp _6f82

:       jsr _6f55                                                       ;$875C

_875f:                                                                  ;$875F
        lda ZP_66               ; hyperspace countdown (outer)?
        beq _877d
        dec ZP_65               ; hyperspace countdown (inner)?
        bne _877d
        ldx ZP_66               ; hyperspace countdown (outer)?
        dex 
        jsr _7224
        lda # $05
        sta ZP_65               ; hyperspace countdown (inner)?
        ldx ZP_66               ; hyperspace countdown (outer)?
        jsr _7224
        dec ZP_66               ; hyperspace countdown (outer)?
        bne _877d
        jmp _73dd

_877d:                                                                  ;$877D
        rts 

_877e:                                                                  ;$877E
.export _877e

        lda ZP_SCREEN
        and # %11000000
        beq _877d

        jsr _7695
        sta ZP_34
        jsr _76e9
        lda # $80
        sta ZP_34

        lda # TXT_NEWLINE
        jsr print_char
        
        jmp _6a68

;===============================================================================

_8798:                                                                  ;$8798
        lda VAR_CARGO_SLAVES
        clc 
        adc VAR_CARGO_NARCOTICS
        asl 
        adc VAR_CARGO_FIREARMS
        rts 

;===============================================================================

_87a4:                                                                  ;$87A4
.export _87a4
        lda # $e0
_87a6:                                                                  ;$87A6
.export _87a6
        cmp ZP_POLYOBJ_XPOS_MI
        bcc _87b0
        cmp ZP_POLYOBJ_YPOS_MI
        bcc _87b0
        cmp ZP_POLYOBJ_ZPOS_MI
_87b0:                                                                  ;$87B0
        rts 

_87b1:                                                                  ;$87B1
;===============================================================================
.export _87b1
        ora ZP_POLYOBJ_XPOS_MI
        ora ZP_POLYOBJ_YPOS_MI
        ora ZP_POLYOBJ_ZPOS_MI

        rts 

_87b8:                                                                  ;$87B8
        ; counter of some kind, possibly related to debug errors?
        .byte   $00

;===============================================================================
; the unused and incomplete debug code can be removed
; in non-original builds
;
.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; BRK routine, set up by `debug_for_brk`
;
debug_brk:                                                              ;$87B9
.export debug_brk

        dec _87b8

        ; clear the stack!
        ; this puts the stack pointer back to the top of the stack
        ldx # $ff
        txs 

        jsr _8c60               ; just returns -- removed code
        tay 

        ; beep and print error message?

        lda # $07               ; BEEP?
:       jsr paint_char                                                  ;$87C5
        iny 
        lda [ZP_FD], y          ;???
        bne :-

        ; this would typically be overwritten
        ; with the address to jump to
        jmp $8888

;///////////////////////////////////////////////////////////////////////////////
.endif

_87d0:                                                                  ;$87D0
.export _87d0
        jsr _a813
        jsr _83df
        asl PLAYER_SPEED        ;?
        asl PLAYER_SPEED        ;?
        ldx # $18
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _7b5e               ; dead code, just an rts
.endif  ;///////////////////////////////////////////////////////////////////////
        jsr set_page
        jsr _b2a5
        lda # $00

        sta ELITE_BITMAP_ADDR + 7 + .bmppos( 24, 35 )
        sta ELITE_BITMAP_ADDR + 0 + .bmppos( 0, 35 )
        jsr _7af7

        lda # 12
        jsr set_cursor_row
        jsr set_cursor_col
        
        lda # $92
        jsr print_canned_message
_87fd:                                                                  ;$87FD
        jsr _848d
        lsr 
        lsr 
        sta ZP_POLYOBJ_XPOS_LO

        ldy # $00
        sty ZP_SCREEN
        sty ZP_POLYOBJ_XPOS_MI
        sty ZP_POLYOBJ_YPOS_MI
        sty ZP_POLYOBJ_ZPOS_MI
        sty ZP_POLYOBJ_ATTACK
        dey 
        sty ZP_A3               ; move counter?
        eor # %00101010
        sta ZP_POLYOBJ_YPOS_LO
        ora # %01010000
        sta ZP_POLYOBJ_ZPOS_LO
        txa 
        and # %10001111
        sta ZP_POLYOBJ_ROLL
        ldy # $40
        sty VAR_0487
        sec 
        ror 
        and # %10000111
        sta ZP_POLYOBJ_PITCH
        ldx # $05
        lda VIC_SPRITE3_Y
        beq _8835
        bcc _8835
        dex 
_8835:                                                                  ;$8835
        jsr _3695
        jsr get_random_number
        and # %10000000
        ldy # $1f
        sta [ZP_POLYOBJ_ADDR], y
        lda SHIP_SLOT4
        beq _87fd

        jsr _8ed5               ; clears 56 key-states, not 64

        sta PLAYER_SPEED
        jsr _1ec1
        jsr disable_sprites
_8851:                                                                  ;$8851
        jsr _1ec1
        dec VAR_0487
        bne _8851
        ldx # $1f

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _7b5e               ; dead code, just an rts
.endif  ;///////////////////////////////////////////////////////////////////////

        jmp _8882

;===============================================================================
; pointer to the 3D hull to show on the title screen
;
_8861:                                                                  ;$8861
        .byte   $88
_8862:                                                                  ;$8862
        .byte   $88

;===============================================================================

; LOADER JUMPS HERE! -- THIS IS THE ENTRY POINT

_8863:                                                                  ;$8863
.export _8863

        ; erase $1D12..$1D01
        ; (user settings?)
        ldx # $11
        lda # $00

:       sta _1d01, x                                                    ;$8867
        dex 
        bpl :-

        ; backup the original hull address (which 3D object to display)
        ; as we will change this on the title screen
        lda hull_pointer_current_lo
        sta _8861
        lda hull_pointer_current_hi
        sta _8862
        
        jsr _8a0c               ; reset the save data to default

        ; set the stack pointer to the top ($01FF),
        ; (i.e. disregard all stack-use prior to this point)
        ldx # $ff
        txs 

        jsr _83ca

_8882:                                                                  ;$8882
        ; set the stack pointer to the top ($01FF),
        ; (i.e. disregard all stack-use prior to this point)
        ldx # $ff
        txs 

        jsr _83df
        jsr clear_keyboard
        
        lda # 3
        jsr set_cursor_col
        
        jsr _91fe

        ldx # $0b
.import TXT_DOCKED_06:direct
        lda # TXT_DOCKED_06
        ldy # $d2
        jsr _8920
        
        cmp # $27
        bne _88ac
        
        jsr _9245
        jsr _88f0
        jsr _8ae7
        jsr _91fe
_88ac:                                                                  ;$88AC
        jsr _88f0
        jsr _845c               ; update missile blocks on HUD

        ; "press space or fire commander"
.import TXT_DOCKED_07:direct
        lda # TXT_DOCKED_07
        ldx # $14
        ldy # $30
        jsr _8920

        jsr _9245
        jsr set_psystem_to_tsystem
        jsr _70ab
        jsr _7217

        ; restore default galaxy seed?
        ldx # $05
:       lda ZP_SEED, x                                                  ;$88C9
        sta VAR_04F4, x
        dex 
        bpl :-

        inx 
        stx VAR_048A

        ; set the present system from the target system
        lda TSYSTEM_ECONOMY
        sta PSYSTEM_ECONOMY
        lda TSYSTEM_TECHLEVEL
        sta PSYSTEM_TECHLEVEL
        lda TSYSTEM_GOVERNMENT
        sta PSYSTEM_GOVERNMENT
_88e7:                                                                  ;$88E7
.export _88e7
        lda # $ff
        sta ZP_A7

        lda # $25
        jmp _86a4

;===============================================================================
; new game file?
;
_88f0:                                                                  ;$88F0
        ldx # 84                ; size of new-game data?
:       lda _25aa, x                                                    ;$88F2
        sta VAR_0490, x         ; seed goes in $049C+
        dex 
        bne :-

        stx ZP_SCREEN
_88fd:                                                                  ;$88FD
        jsr _89eb
        cmp _25ff
        bne _88fd
        eor # %10101001
        tax 
        lda PLAYER_COMPETITION
        cpx _25fd
        beq _8912
        ora # %10000000
_8912:                                                                  ;$8912
        ora # %01000000
        sta PLAYER_COMPETITION
        jsr _89f9
        cmp _25fe
        bne _88fd
        rts 

;===============================================================================
; draw the title screen?
;
;       A = a docked-string token to print
;       X = ? e.g. $0B
;       Y = ? e.g. $D2
;
_8920:                                                                  ;$8920
        sty VAR_06FB            ; z-distance?

        pha                     ; keep A parameter
        stx ZP_A5

        lda # $ff
        sta _1d13
        jsr _83ca               ; this has nothing to do with `_1d13`??
        lda # $00
        sta _1d13

        jsr clear_keyboard

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # $20
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////
        
        lda # $0d
        jsr set_page
        
        lda # $00
        sta ZP_SCREEN

        lda # $60
        sta ZP_POLYOBJ_M0x2_HI
        lda # $60
        sta ZP_POLYOBJ_ZPOS_MI
        ldx # $7f
        stx ZP_POLYOBJ_ROLL
        stx ZP_POLYOBJ_PITCH
        inx 
        stx ZP_34
        lda ZP_A5
        jsr _7c6b

        ; print "--- E L I T E ---"

.ifdef  OPTION_ORIGINAL
        lda # 6
.else
        lda # 2
.endif
        jsr set_cursor_col

.import TXT_ELITE:direct
        lda # TXT_ELITE
        jsr print_flight_token_and_newline

        lda # $0a
        jsr print_char

        lda # 6
        jsr set_cursor_col
        
        lda _1d08
        beq :+

        lda # $0d
        jsr print_docked_str

:       lda _87b8                                                       ;$8978
        beq @_8994
        inc _87b8

        lda # 7
        jsr set_cursor_col
        lda # 10
        jsr set_cursor_row
        
        ldy # $00
:       jsr paint_char                                                  ;$898C
        iny 
        lda [ZP_FD], y
        bne :-

@_8994:                                                                 ;$8994
        ldy # $00
        sty PLAYER_SPEED
        sty _1d0c

        lda # 15
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL
        
        pla                     ; retrieve the original A parameter
        jsr print_docked_str    ; use this as a docked string token
                                ; (see "text/text_docked.asm")

        lda # 3
        jsr set_cursor_col
        lda # TXT_NEWLINE
        jsr print_docked_str
        
        lda # $0c
        sta ZP_AB

        lda # $05
        sta ZP_A3               ; move counter?
        
        lda # $ff
        sta _1d0c
@_89be:                                                                 ;$89BE
        lda ZP_POLYOBJ_ZPOS_MI
        cmp # $01
        beq :+
        dec ZP_POLYOBJ_ZPOS_MI
:       jsr _a2a0                                                       ;$89C6
        
        ldx VAR_06FB            ; title screen poly-object z-distance?
        stx ZP_POLYOBJ_ZPOS_LO
        
        lda ZP_A3               ; move counter?
        and # %00000011
        lda # $00
        sta ZP_POLYOBJ_XPOS_LO
        sta ZP_POLYOBJ_YPOS_LO
        jsr _9a86
        jsr get_input

        dec ZP_A3               ; move counter?
        bit joy_fire
        bmi :+
        bcc @_89be
        inc _1d0c

:       rts                                                             ;$89EA

;===============================================================================

; checksum file data?

_89eb:                                                                  ;$89EB
        ldx # 73
        clc 
        txa 
_89ef:                                                                  ;$89EF
        adc _25b2, x
        eor _25b3, x
        dex 
        bne _89ef
        rts 

;===============================================================================

_89f9:                                                                  ;$89F9
        ldx # 73
        clc 
        txa 
_89fd:                                                                  ;$89FD
        stx ZP_VAR_T
        eor ZP_VAR_T
        ror 
        adc _25b2, x
        eor _25b3, x
        dex 
        bne _89fd
        rts 

;===============================================================================
; reset the current save-game -- copies a dummy save game
; over the current save game data
;
_8a0c:                                                                  ;$8A0C
        ; copy $2619..$267A to $25AB..$260C

        ldy # $61               ;=97; length of the save-data

:       lda _2619, y                                                    ;$8A0E
        sta _25ab, y            ; seed would be in $25B6?
        dey 
        bpl :-

        ldy # $07
        sty _8bbf

        rts 

;===============================================================================

_8a1d:                                                                  ;$8A1D
        ldx # $07
        lda _8bbe
        sta _8bbf
_8a25:                                                                  ;$8A25
        lda ZP_POLYOBJ_YPOS_HI, x
        sta _25ab, x
        dex 
        bpl _8a25
_8a2d:                                                                  ;$8A2D
        ldx # $07
_8a2f:                                                                  ;$8A2F
        lda _25ab, x
        sta ZP_POLYOBJ_YPOS_HI, x
        dex 
        bpl _8a2f
        rts 

_8a38:                                                                  ;$8A38
        ldx # $04
_8a3a:                                                                  ;$8A3A
        lda _25a6, x
        sta ZP_POLYOBJ_XPOS_LO, x
        dex 
        bpl _8a3a
        lda # $07
        sta _8ab2

        lda # $08
        jsr print_docked_str
        
        jsr txt_docked_token1A
        lda # $09
        sta _8ab2
        tya 
        beq _8a2d
        sty _8bbe
        rts 

txt_docked_token1A:                                                     ;$8A5B
        ;=======================================================================
.export txt_docked_token1A

        lda # $40
        sta VAR_050C

        ldy # 8
        jsr wait_frames

        jsr _28d5               ; loads A & X with $0F
        ldy # $00
_8a6a:                                                                  ;$8A6A
        jsr _8fea               ; get input?
        cmp # $0d               ; return key?
        beq @_8a94
        cmp # $1b               ; K?
        beq @_8aa1
        cmp # $7f
        beq @_8aa8
        cpy _8ab2
        bcs @_8a8d
        cmp _8ab3
        bcc @_8a8d
        cmp _8ab4
        bcs @_8a8d
        sta ZP_POLYOBJ_YPOS_HI, y       ;?
        iny 
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit 
@_8a8d:
        lda # $07               ; BEEP?                                 ;$8A8D
@_8a8f:
        jsr paint_char                                                  ;$8A8F
        bcc _8a6a               ; always branches?

@_8a94:                                                                 ;$8A94
        sta ZP_POLYOBJ_YPOS_HI, y       ;?

        lda # $10
        sta VAR_050C
        
        lda # TXT_NEWLINE
        jmp paint_char

@_8aa1:                                                                 ;$8AA1
        lda # $10
        sta VAR_050C
        sec 
        rts 

@_8aa8:                                                                 ;$8AA8
        tya 
        beq @_8a8d
        dey 

        lda # $7f
        bne @_8a8f                      ; (always branches)

        .byte   $0e, $00
_8ab2:                                                                  ;$8AB2
        .byte   $09
_8ab3:                                                                  ;$8AB3
        .byte   $21
_8ab4:                                                                  ;$8AB4
        .byte   $7b

;===============================================================================
; insert from "text/text_docked_fns.asm"
;
.txt_docked_token_mediaCurrent                                          ;$8AB5
.txt_docked_token_mediaOther                                            ;$8ABE

;===============================================================================
; erase $0452...$048C
;
_8ac7:                                                                  ;$8AC7
        ldx # $3a               ;=58
        lda # $00

        ; $0452 is SHIP_SLOTS, but in this context
        ; is some kind of larger data-block
:       sta SHIP_SLOTS, x                                               ;$8ACB
        dex 
        bpl :-

        rts 
         
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; extraneous `rts`

;$8AD3  unused code?

        ldx # $0c
        jsr _8ad9
        dex 

_8ad9:                                                                  ;$8AD9
        ldy # $00
        sty ZP_TEMP_ADDR1_LO
        lda # $00
        stx ZP_TEMP_ADDR1_HI

:       sta [ZP_TEMP_ADDR1], y                                          ;$8AE1
        iny 
        bne :-
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; data menu
;
_8ae7:                                                                  ;$8AE7
        ; display the data menu on screen
.import TXT_DOCKED_DATA_MENU:direct

        lda # TXT_DOCKED_DATA_MENU
        jsr print_docked_str

        jsr wait_for_input
        cmp # '1'
        beq @_8b1c
        cmp # '2'
        beq @_8b27
        cmp # '3'
        beq @_8b11
        cmp # '4'
        bne @_8b0f
        
.import TXT_DOCKED_ARE_YOU_SURE:direct
        lda # TXT_DOCKED_ARE_YOU_SURE
        jsr print_docked_str
        
        jsr _81ee
        bcc @_8b0f
        jsr _8a0c               ; reset save data to default
        jmp _88f0

@_8b0f:                                                                 ;$8B0F
        ;-----------------------------------------------------------------------
        clc 
        rts 

@_8b11:                                                                 ;$8B11
        ;-----------------------------------------------------------------------
        ; change disk to tape and vice versa
        ;
        lda opt_device          ; get current device $FF = disk, $00 = tape
        eor # %11111111         ; flip!
        sta opt_device          ; and write back
        jmp _8ae7

@_8b1c:                                                                 ;$8B1C
        ;-----------------------------------------------------------------------
        jsr _8a38
        jsr _8c0d
        jsr _8a1d
        sec 
        rts 

@_8b27:                                                                 ;$8B27
        ;-----------------------------------------------------------------------
        jsr _8a38
        jsr _8a1d
        lsr VAR_04E2

.import TXT_DOCKED_COMPETITION_NUMBER:direct
        lda # TXT_DOCKED_COMPETITION_NUMBER     ;=$04
        jsr print_docked_str
        
        ; copy $0499..$04E5 (data to be saved?)
        ldx # $4c
:       lda MISSION_FLAGS, x                                            ;$8B37
        sta _25b3, x
        dex 
        bpl :-

        jsr _89f9
        sta _25fe
        jsr _89eb
        sta _25ff
        pha 
        ora # %10000000
        sta ZP_VALUE_pt1
        eor PLAYER_COMPETITION
        sta ZP_VALUE_pt3
        eor PLAYER_CASH_pt3     ;?
        sta ZP_VALUE_pt2
        eor # %01011010
        eor PLAYER_KILLS
        sta ZP_VALUE_pt4
        clc 
        jsr print_large_value
        jsr print_newline
        jsr print_newline
        pla 
        eor # %10101001
        sta _25fd
        jsr _8bc0               ; NOTE: enables KERNAL

        lda #< _25b3
        sta ZP_FD
        lda #> _25b3
        sta ZP_FE
        
        ; save to disk:
        ; the linker will define the location and size of the save-data block
.import __DATA_SAVE_RUN__
.import __DATA_SAVE_SIZE__

        ; data is located at the pointer in $FD/$FE
        lda # ZP_FD
        ldx #< (__DATA_SAVE_RUN__ + __DATA_SAVE_SIZE__)
        ldy #> (__DATA_SAVE_RUN__ + __DATA_SAVE_SIZE__)
        jsr KERNAL_SAVE
        php 
        
        sei 
        bit CIA1_INTERRUPT
        lda # %00000001
        sta CIA1_INTERRUPT

        ldx # $00
        stx _a8d9
        inx 
        stx VIC_INTERRUPT_CONTROL

        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1
        
        lda # 40                ; raster line 40
        sta VIC_RASTER

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn KERNAL & I/O area off
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL         ; turn off KERNAL
        dec CPU_CONTROL         ; turn off I/O
.endif  ;///////////////////////////////////////////////////////////////////////
        
        cli 
        jsr swap_zp_shadow      ; TODO: why is this needed?
        plp 
        cli 
        bcs :+
        jsr _88f0
        jsr wait_for_input
        
        clc 
        rts 
             
:       jmp _8c61                                                       ;$8BBB

;===============================================================================

_8bbe:                                                                  ;$8BBE
        .byte   $07             ; file name length?
_8bbf:                                                                  ;$8BBF
        .byte   $07

_8bc0:                                                                  ;$8BC0
        jsr swap_zp_shadow      ; why is this needed?
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # C64_MEM::IO_KERNAL
        sei                     ; disable interrupts
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        sei                     ; disable interrupts
        inc CPU_CONTROL
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////
        
        lda # %00000000
        sta VIC_INTERRUPT_CONTROL
        cli 
        lda # %10000001
        sta CIA1_INTERRUPT
        
        lda # $c0               ;?
        jsr KERNAL_SETMSG   
        
        ; select TAPE or DISK
        ldx opt_device          ; selected load/save device (disk/tape)
        inx                     ; $FF = disk, $00 = tape?
        lda _8c0b, x            ; $00 = disk, $01 = tape 
        tax                     ; X = device ID
        
        lda # $01               ; logical file number
        ldy # $00               ; secondary address
        jsr KERNAL_SETLFS       ; note that X is device ID
        
        ; TODO: why should the filename be in $0E??
        lda _8bbe               ; filename length
        ldx # $0e               ; $000E?
        ldy # $00               ; X.Y is filename address
        jmp KERNAL_SETNAM
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ;bug / unused code? (`jmp` instead of `jsr` above)
        ;
        lda # $02
        jsr print_docked_str

        jsr wait_for_input
        ora # %00010000
        jsr paint_char
        pha 
        jsr print_crlf
        pla 
        cmp # $30
        bcc _8c53
        cmp # $34

        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

_8c0b:  ; device number table                                           ;$8C0B
        ;-----------------------------------------------------------------------
        ; TODO: remove tape code
        ;
        .byte   DEV_DRV8
        .byte   DEV_TAPE

;===============================================================================

_8c0d:                                                                  ;$8C0D
        jsr _8bc0               ; select drive & filename?
                                ; NOTE: enables KERNAL
        
        ; load the file into the disk buffer
        lda # $00               ; "LOAD"
        ldx #< ELITE_DISK_BUFFER
        ldy #> ELITE_DISK_BUFFER
        jsr KERNAL_LOAD    
        
        ; push load result to stack
        ; (carry is set if there was an error)
        php                      
        
        lda # %00000001
        sta CIA1_INTERRUPT
        sei 

        ldx # $00
        stx _a8d9
        inx 
        stx VIC_INTERRUPT_CONTROL

        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1
        
        lda # 40                ; raster line 40
        sta VIC_RASTER
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off KERNAL & I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL         ; turn off KERNAL
        dec CPU_CONTROL         ; turn off I/O
.endif  ;///////////////////////////////////////////////////////////////////////
        
        cli 
        jsr swap_zp_shadow      ; why is this needed?
        
        ; check the result of the load
        plp 
        cli 
        bcs _8c61               ; carry set = error
        lda ELITE_DISK_BUFFER
        bmi _illegal

        ; copy the save file from the disk buffer over the current data?
        ; copy $CF00...$CF4C to $25B3...$25FF
        ldy # $4c                       ; length is $FF-$4C
        
:       lda ELITE_DISK_BUFFER, y                                        ;$8C4A
        sta _25b3, y
        dey 
        bpl :-
_8c53:                                                                  ;$8C53
        sec 
        rts 

_illegal:                                                               ;$8C55
        ;-----------------------------------------------------------------------
        ; file is invalid
        ;
.import TXT_DOCKED_ILLEGAL_FILE:direct
        lda # TXT_DOCKED_ILLEGAL_FILE   ; display "illegal Elite II file"
        jsr print_docked_str
        
        jsr wait_for_input              ; press any key
        jmp _8ae7

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
_8c60:  rts                                                             ;$8C60
;///////////////////////////////////////////////////////////////////////////////
.endif

_8c61:                                                                  ;$8C61
.import TXT_DOCKED_ERROR:direct
        lda # TXT_DOCKED_ERROR
        jsr print_docked_str

        jsr wait_for_input
        jmp _8ae7

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; not needed due to `jmp` above
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================
; include code from "code_keyboard.inc"
;
.clear_keyboard                                                         ;$8C6D

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; superfluous rts                       ;$8C7A
.endif  ;///////////////////////////////////////////////////////////////////////

_8c7b:                                                                  ;$8C7B
.export _8c7b
        ldx # $00
        jsr _7c11

        ldx # $03
        jsr _7c11

        ldx # $06
        jsr _7c11
_8c8a:                                                                  ;$8C8A
.export _8c8a
        lda ZP_POLYOBJ01_XPOS_pt1
        ora ZP_POLYOBJ01_YPOS_pt1
        ora ZP_POLYOBJ01_ZPOS_pt1
        ora # %00000001
        sta ZP_POLYOBJ01_POS

        lda ZP_POLYOBJ01_XPOS_pt2
        ora ZP_POLYOBJ01_YPOS_pt2
        ora ZP_POLYOBJ01_ZPOS_pt2
_8c9a:                                                                  ;$8C9A
        asl ZP_POLYOBJ01_POS
        rol 
        bcs _8cad
        
        asl ZP_POLYOBJ01_XPOS_pt1
        rol ZP_POLYOBJ01_XPOS_pt2
        asl ZP_POLYOBJ01_YPOS_pt1
        rol ZP_POLYOBJ01_YPOS_pt2
        asl ZP_POLYOBJ01_ZPOS_pt1
        rol ZP_POLYOBJ01_ZPOS_pt2
        bcc _8c9a
_8cad:                                                                  ;$8CAD
.export _8cad
        lda ZP_POLYOBJ01_XPOS_pt2
        lsr 
        ora ZP_POLYOBJ01_XPOS_pt3
        sta ZP_VAR_X
        lda ZP_POLYOBJ01_YPOS_pt2
        lsr 
        ora ZP_POLYOBJ01_YPOS_pt3
        sta ZP_VAR_Y
        lda ZP_POLYOBJ01_ZPOS_pt2
        lsr 
        ora ZP_POLYOBJ01_ZPOS_pt3
        sta ZP_VAR_X2
_8cc2:                                                                  ;$8CC2
        lda ZP_VAR_X
        jsr math_square_7bit
        sta ZP_VAR_R
        lda ZP_VAR_P1
        sta ZP_VAR_Q
        lda ZP_VAR_Y
        jsr math_square_7bit
        sta ZP_VAR_T
        lda ZP_VAR_P1
        adc ZP_VAR_Q
        sta ZP_VAR_Q
        lda ZP_VAR_T
        adc ZP_VAR_R
        sta ZP_VAR_R
        lda ZP_VAR_X2
        jsr math_square_7bit
        sta ZP_VAR_T
        lda ZP_VAR_P1
        adc ZP_VAR_Q
        sta ZP_VAR_Q
        lda ZP_VAR_T
        adc ZP_VAR_R
        sta ZP_VAR_R
        jsr _9978
        lda ZP_VAR_X
        jsr _918b
        sta ZP_VAR_X
        lda ZP_VAR_Y
        jsr _918b
        sta ZP_VAR_Y
        lda ZP_VAR_X2
        jsr _918b
        sta ZP_VAR_X2
        rts 

;===============================================================================
; insert code from "code_keyboard.inc"
;
.key_states                                                             ;$8D0C
.get_input                                                              ;$8D53

do_quickjump:                                                           ;$8E29
;===============================================================================
.export do_quickjump

        ; reasons not to quickjump:
        ldx VAR_047F            ; there are asteroids?
        lda SHIP_SLOT2, x
        ora VAR_045F            ;?
        ora IS_WITCHSPACE       ; we are in witchspace
       .bnz @nojump             ; -- cannot quick-jump

        ; check player's Z-position 
        ;
        ldy POLYOBJ_00 + PolyObject::zpos + 2                           ;=$F908
        bmi :+
        
        ; note that A is zero due to the
        ; tests above mandating a zero result
        tay 
        jsr _2c50
        cmp # $02               ; minimum distance? ($020000?)
        bcc @nojump

:       ldy POLYOBJ_01 + PolyObject::zpos + 2                           ;$8E44
        bmi :+
        ; check the sun's position?
        ldy # .sizeof(PolyObject)
        jsr _2c4e
        cmp # $02               ; minimum distance?
        bcc @nojump
            
:       lda # $81               ; jump distance?                        ;$8E52
        sta ZP_VAR_S
        sta ZP_VAR_R
        sta ZP_VAR_P
        
        ; push the player forward
        ;
        lda POLYOBJ_00 + PolyObject::zpos + 2
        jsr multiplied_now_add
        sta POLYOBJ_00 + PolyObject::zpos + 2

        lda POLYOBJ_01 + PolyObject::zpos + 2
        jsr multiplied_now_add
        sta POLYOBJ_01 + PolyObject::zpos + 2

        lda # $01
        sta ZP_SCREEN
        sta ZP_A3               ; move counter?
        lsr 
        sta VAR_048A

        ldx VAR_0486
        jmp _a6ba               ; redraw viewport?

@nojump:                                                                ;$8E7C
        ;-----------------------------------------------------------------------
        ldy # $06
        jmp _a858               ; "sound low beep"?

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; extraneous `rts`                      ;$8E81
.endif  ;///////////////////////////////////////////////////////////////////////

;===============================================================================

; unsued / unreferenced?
;$8e82
        .byte   $e8, $e2, $e6, $e7, $c2, $d1, $c1, $60
        .byte   $70, $23, $35, $65, $22, $45, $52, $37

get_ctrl:                                                               ;$8E92
        ;=======================================================================
        ; get the state of the CTRL key
        ;
        ldx # (key_ctrl - key_states)
        lda key_states, x
        tax 

        rts 

;===============================================================================
; read key?

; ununsed / unreferenced?
; $8e99:

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn the I/O area on to manage the CIA ports
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////
        
        sei 
        stx CIA1_PORTA
        ldx CIA1_PORTB
        cli 
        inx 
        beq _8eab
        ldx # $ff

_8eab:                                                                  ;$8EAB
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

        txa 
        rts 

;$8eb2:
        rts 

;===============================================================================

;$8eb3: unused / unreferenced?

        lda _9274, x
        eor opt_flipaxis

        rts 

;===============================================================================
; flip flags?
;
;       Y = some index
;       X = some comparison value
;
_8eba:                                                                  ;$8EBA
        txa 
        cmp _1d14, y
        bne @rts

        lda _1d06, y
        eor # %11111111
        ; note: this is the only place $1D06 is writen to
        sta _1d06, y
        
        jsr _2fee               ; BEEP?
       .phy                     ; push Y to stack (via A) 
        
        ; wait for a bit

        ldy # 20
        jsr wait_frames

        pla 
        tay 
@rts:                                                                   ;$8ED4
        rts 

;===============================================================================
; clears the key-states for 56 keys, not 64
;
_8ed5:                                                                  ;$8ED5
        lda # $00
        ldy # 56                ; only 56 keys, not 64

:       sta key_states, y                                               ;$8ED9
        dey 
        bne :-

        sta VAR_0441
        rts 

;===============================================================================

_8ee3:                                                                  ;$8EE3
        jsr get_input
        
        lda DOCKCOM_STATE
        beq _8f4d

        jsr clear_zp_polyobj

        lda # $60               ; this is the $6000 vector scale?
        sta ZP_POLYOBJ_M0x2_HI
        ora # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        sta ZP_A5

        lda PLAYER_SPEED
        sta ZP_POLYOBJ_VERTX_LO
        jsr _34bc
        lda ZP_POLYOBJ_VERTX_LO                                         ;$8EFF
_8f01:                                                                  ;$8F01
        cmp # $16
        bcc :+

        lda # $16
:       sta PLAYER_SPEED                                                ;$8F07

        lda # $ff
        ldx # $09
        ldy ZP_POLYOBJ_VERTX_HI
        beq _8f18
        bmi _8f15
        
        ldx # $04
_8f15:                                                                  ;$8F15
        sta key_states, x
_8f18:                                                                  ;$8F18
        lda # $80
        ldx # $11
        asl ZP_POLYOBJ_ROLL
        beq _8f35
        bcc _8f24

        ldx # $14
_8f24:                                                                  ;$8F24
        bit ZP_POLYOBJ_ROLL
        bpl _8f2f

        lda # $40
        sta VAR_048D
        lda # $00
_8f2f:                                                                  ;$8F2F
        sta key_states, x
        lda VAR_048D
_8f35:                                                                  ;$8F35
        sta VAR_048D
        lda # $80
        ldx # $29
        asl ZP_POLYOBJ_PITCH
        beq _8f4a
        bcs _8f44
        ldx # $33
_8f44:                                                                  ;$8F44
        sta key_states, x
        lda VAR_048E
_8f4a:                                                                  ;$8F4A
        sta VAR_048E
_8f4d:                                                                  ;$8F4D
        ldx VAR_048D
        lda # $0e
        ldy joy_left
        beq _8f5a
        jsr _3c6f
_8f5a:                                                                  ;$8F5A
        ldy joy_right
        beq _8f62
        jsr _3c7f
_8f62:                                                                  ;$8F62
        stx VAR_048D
        ldx VAR_048E
        ldy joy_down
        beq _8f70
        jsr _3c7f
_8f70:                                                                  ;$8F70
        ldy joy_up
        beq _8f78
        jsr _3c6f
_8f78:                                                                  ;$8F78
        stx VAR_048E
        lda _1d0c
        beq _8f9d
        lda DOCKCOM_STATE
        bne _8f9d
        ldx # $80
        lda joy_left
        ora joy_right
        bne _8f92
        stx VAR_048D
_8f92:                                                                  ;$8F92
        lda joy_down
        ora joy_up
        bne _8f9d
        stx VAR_048E
_8f9d:                                                                  ;$8F9D
        ldx ZP_7D
        stx VAR_0441
        cpx # $40
        bne _8fe9
_8fa6:                                                                  ;$8FA6
        jsr wait_for_frame
        jsr get_input

        cpx # $02               ; "Q"?
        bne :+
        stx _1d05
:       ldy # $00                                                       ;$8FB3

_8fb5:                                                                  ;$8FB5
        jsr _8eba               ; flip a flag?
        iny 
        cpy # $0a
        bne _8fb5
        bit _1d08
        bpl _8fca
_8fc2:                                                                  ;$8FC2
        jsr _8eba               ; flip a flag?
        iny 
        cpy # $0d
        bne _8fc2
_8fca:                                                                  ;$8FCA
        lda _1d0d
        cmp _1d02
        beq _8fd5
        jsr _9231
_8fd5:                                                                  ;$8FD5
        cpx # $33               ; "S"?
        bne _8fde
        lda # $00
        sta _1d05
_8fde:                                                                  ;$8FDE
        cpx # $07               ; "<-"?
        bne _8fe5
        jmp _8882

_8fe5:                                                                  ;$8FE5
        cpx # $0d               ; "HOME"?
        bne _8fa6

_8fe9:                                                                  ;$8FE9
        rts 

;===============================================================================

_8fea:                                                                  ;$8FEA
        sty ZP_9E               ; backup Y

wait_for_input:                                                         ;$8FEC
        ;-----------------------------------------------------------------------
        ldy # 2
        jsr wait_frames

        jsr get_input
        bne wait_for_input

:       jsr get_input                                                   ;$8FF6
        beq :-

        lda _927e, x
        
        ldy ZP_9E               ; restore Y
        tax 
_9001:                                                                  ;$9001
        rts 

;===============================================================================

_9002:                                                                  ;$9002
        stx VAR_048B
        pha 
        lda VAR_04E6
        jsr _905d
        pla 
_900d:                                                                  ;$900D
.export _900d
        pha 
        
        lda # $10
        ldx ZP_SCREEN
        beq _9019+1

        jsr txt_docked_token15
        lda # $19
_9019:                                                                  ;$9019
        bit _3385
        ldx # $00
        stx ZP_34

        lda ZP_B9
        jsr set_cursor_col
        
        pla 
        ldy # $14
        cpx VAR_048B
        bne _9002
        sty VAR_048B
        sta VAR_04E6
        lda # $c0
        sta txt_buffer_flag
        lda VAR_048C
        lsr 
        lda # $00
        bcc _9042
        lda # $0a
_9042:                                                                  ;$9042
        sta txt_buffer_index
        
        lda VAR_04E6
        jsr print_flight_token

        lda # $20
        sec 
        sbc txt_buffer_index
        lsr 
        sta ZP_B9
        jsr set_cursor_col
        
        jsr txt_docked_token0F
        lda VAR_04E6
_905d:                                                                  ;$905D
        jsr print_flight_token

        lsr VAR_048C
        bcc _9001
        
.import TXT_DESTROYED:direct
        lda # TXT_DESTROYED
        jmp print_flight_token

;===============================================================================

_906a:                                                                  ;$906A
        jsr get_random_number
        bmi _9001
        cpx # $16
        bcs _9001

        lda VAR_CARGO, x
        beq _9001
        lda VAR_048B
        bne _9001
        ldy # $03
        sty VAR_048C
        sta VAR_CARGO, x
        cpx # $11
        bcs _908f
        txa 
        adc # $d0
        jmp _900d

_908f:                                                                  ;$908F
        beq _909b
        cpx # $12
        beq _90a0
        txa 
        adc # $5d
        jmp _900d

_909b:                                                                  ;$909B
        lda # $6c
        jmp _900d

_90a0:                                                                  ;$90A0
        lda # $6f
        jmp _900d

;===============================================================================

_90a5:                                                                  ;$90A5
        .byte   $13
_90a6:                                                                  ;$90A6
        .byte   $82
_90a7:                                                                  ;$90A7
        .byte   $06
_90a8:                                                                  ;$90A8
        .byte   $01, $14, $81, $0a, $03, $41, $83, $02
        .byte   $07, $28, $85, $e2, $1f, $53, $85, $fb
        .byte   $0f, $c4, $08, $36, $03, $eb, $1d, $08
        .byte   $78, $9a, $0e, $38, $03 ,$75, $06, $28
        .byte   $07, $4e, $01, $11, $1f, $7c, $0d, $1d
        .byte   $07, $b0, $89, $dc, $3f, $20, $81, $35
        .byte   $03, $61, $a1, $42, $07, $ab, $a2, $37
        .byte   $1f, $2d, $c1, $fa, $0f

; unused code?
;$90e5:
        and ZP_POLYOBJ_ZPOS_LO, x
        cpy # $07

_90e9:                                                                  ;$90E9
        tya 
        ldy # $02
        jsr _91b8
        sta ZP_POLYOBJ_M1x2_HI
        jmp _9131

;===============================================================================

_90f4:                                                                  ;$90F4
        tax 
        lda ZP_VAR_Y
        and # %01100000
        beq _90e9
        lda # $02
        jsr _91b8
        sta ZP_POLYOBJ_M1x1_HI
        jmp _9131

;===============================================================================

_9105:                                                                  ;$9105
        lda ZP_POLYOBJ_M0x0_HI
        sta ZP_VAR_X
        lda ZP_POLYOBJ_M0x1_HI
        sta ZP_VAR_Y
        lda ZP_POLYOBJ_M0x2_HI
        sta ZP_VAR_X2
        jsr _8cc2
        lda ZP_VAR_X
        sta ZP_POLYOBJ_M0x0_HI
        lda ZP_VAR_Y
        sta ZP_POLYOBJ_M0x1_HI
        lda ZP_VAR_X2
        sta ZP_POLYOBJ_M0x2_HI
        ldy # $04
        lda ZP_VAR_X
        and # %01100000
        beq _90f4
        ldx # $02
        lda # $00
        jsr _91b8
        sta ZP_POLYOBJ_M1x0_HI
_9131:                                                                  ;$9131
        lda ZP_POLYOBJ_M1x0_HI
        sta ZP_VAR_X
        lda ZP_POLYOBJ_M1x1_HI
        sta ZP_VAR_Y
        lda ZP_POLYOBJ_M1x2_HI
        sta ZP_VAR_X2
        jsr _8cc2
        lda ZP_VAR_X
        sta ZP_POLYOBJ_M1x0_HI
        lda ZP_VAR_Y
        sta ZP_POLYOBJ_M1x1_HI
        lda ZP_VAR_X2
        sta ZP_POLYOBJ_M1x2_HI
        lda ZP_POLYOBJ_M0x1_HI
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_M1x2_HI
        jsr multiply_signed_into_RS
        ldx ZP_POLYOBJ_M0x2_HI
        lda ZP_POLYOBJ_M1x1_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        lda ZP_POLYOBJ_M1x0_HI
        jsr multiply_signed_into_RS
        ldx ZP_POLYOBJ_M0x0_HI
        lda ZP_POLYOBJ_M1x2_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x1_HI
        lda ZP_POLYOBJ_M1x1_HI
        jsr multiply_signed_into_RS
        ldx ZP_POLYOBJ_M0x1_HI
        lda ZP_POLYOBJ_M1x0_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x2_HI
        lda # $00
        ldx # $0e
_9184:                                                                  ;$9184
        sta ZP_POLYOBJ_M0x0_LO, x
        dex 
        dex 
        bpl _9184
        rts 

;===============================================================================

_918b:                                                                  ;$918B
        tay 
        and # %01111111
        cmp ZP_VAR_Q
        bcs _91b2
        ldx # $fe
        stx ZP_VAR_T
_9196:                                                                  ;$9196
        asl 
        cmp ZP_VAR_Q
        bcc _919d
        sbc ZP_VAR_Q
_919d:                                                                  ;$919D
        rol ZP_VAR_T
        bcs _9196
        lda ZP_VAR_T
        lsr 
        lsr 
        sta ZP_VAR_T
        lsr 
        adc ZP_VAR_T
        sta ZP_VAR_T
        tya 
        and # %10000000
        ora ZP_VAR_T
        rts 

_91b2:                                                                  ;$91B2
        tya 
        and # %10000000
        ora # %01100000
        rts 

;===============================================================================

_91b8:                                                                  ;$91B8
        sta ZP_VAR_P3
        lda ZP_POLYOBJ_M0x0_HI, x
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_M1x0_HI, x
        jsr multiply_signed_into_RS
        ldx ZP_POLYOBJ_M0x0_HI, y
        stx ZP_VAR_Q
        lda ZP_POLYOBJ_M1x0_HI, y
        jsr multiply_and_add
        stx ZP_VAR_P1
        ldy ZP_VAR_P3
        ldx ZP_POLYOBJ_M0x0_HI, y
        stx ZP_VAR_Q
        eor # %10000000
        sta ZP_VAR_P2
        eor ZP_VAR_Q
        and # %10000000
        sta ZP_VAR_T
        lda # $00
        ldx # $10
        asl ZP_VAR_P1
        rol ZP_VAR_P2
        asl ZP_VAR_Q
        lsr ZP_VAR_Q
_91eb:                                                                  ;$91EB
        rol 
        cmp ZP_VAR_Q
        bcc _91f2
        sbc ZP_VAR_Q
_91f2:                                                                  ;$91F2
        rol ZP_VAR_P1
        rol ZP_VAR_P2
        dex 
        bne _91eb
        lda ZP_VAR_P1
        ora ZP_VAR_T
_91fd:                                                                  ;$91FD
        rts 

;===============================================================================

_91fe:                                                                  ;$91FE
        lda #< (_c164 - 1)
        ldx #> (_c164 - 1)
        bne _920d

_9204:                                                                  ;$9204
;-------------------------------------------------------------------------------
.export _9204
        bit _1d11
        bmi _91fe
        
        lda #< (_b72d - 1)
        ldx #> (_b72d - 1)
_920d:                                                                  ;$920D
        sta sound_play_addr_lo
        stx sound_play_addr_hi

        bit _1d03
        bmi _91fd
        bit _1d10
        bmi _9222
        bit _1d0d
        bmi _91fd               ; rts
      
_9222:                                                                  ;$9222

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        inc CPU_CONTROL         ; enable I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        jsr sound_stop
        
.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL         ; disable I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $ff
        sta _1d03
        bne _9266
_9231:                                                                  ;$9231
        sta _1d02
        eor # %11111111
        and DOCKCOM_STATE
        bmi _9222

_923b:                                                                  ;$923B
        ;-----------------------------------------------------------------------
.export _923b
        bit _1d13               ; user option?
        bmi _91fd               ; `rts`
        bit _1d10               ; user option?
        bmi _9204

_9245:                                                                  ;$9245
        bit _1d03               ; user option?
        bpl _91fd

        jsr _a817

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn on I/O to access the SID
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////
        
        lda # $00
        sta _1d03

        ; clear the SID registers
        ; ($D400..$D418)
        ldx # $18
        sei 

:       sta SID_REGISTERS, x                                            ;$925A
        dex 
        bpl :-

        ; set volume to maximum
        lda # 15
        sta SID_VOLUME_CTRL
        
.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL         ; disable I/O
.endif  ;///////////////////////////////////////////////////////////////////////
        cli 

_9266:                                                                  ;$9266

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jmp set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; we must *not* decrement the memory map twice so the decrements have
        ; been moved above to avoid a fall-through condition that would crash
        ; the machine if we decrement here at the end of the routine
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////


; unused / unreferenced?
;$926b:
        .byte   $02, $0f, $31, $32, $33, $34, $35, $36
        .byte   $37
_9274:                                                                  ;$9274
        .byte   $38, $39, $30, $31, $32, $33, $34, $35
        .byte   $36, $37

; screen-code or PETSCII code mappings to the key-matrix?
_927e:                                                                  ;$927E
        .byte   $00, $01, $51, $02 ,$20, $32, $03, $1b                  ;$927E
        .byte   $31, $2f, $5e, $3d ,$05, $06, $3b, $2a                  ;$9286
        .byte   $60, $2c, $40, $3a ,$2e, $2d, $4c, $50                  ;$928E
        .byte   $2b, $4e, $4f, $4b ,$4d, $30, $4a, $49                  ;$9296
        .byte   $39, $56, $55, $48 ,$42, $38, $47, $59                  ;$929E
        .byte   $37, $58, $54, $46 ,$43, $36, $44, $52                  ;$92A6
        .byte   $35, $07, $45, $53 ,$5a, $34, $41, $57                  ;$92AE
        .byte   $33, $08, $09, $0a ,$0b, $0c, $0e, $0d                  ;$92B6
        .byte   $7f, $a9, $05, $20 ,$7f, $82, $a9, $00                  ;$92BE
        .byte   $8d, $15, $d0, $a9 ,$04, $78, $8d, $8e                  ;$92C6
        .byte   $82, $a5, $01, $29 ,$f8, $0d, $8e, $82                  ;$92CE
        .byte   $85, $01, $58, $60 ,$04, $a5, $2e, $8d                  ;$92D6
        .byte   $f2, $04, $a5, $2f ,$8d, $f3, $04, $60                  ;$92DE
        .byte   $a6, $9d, $20, $f3 ,$82, $a6, $9d, $4c                  ;$92E6
        .byte   $2f, $20, $20, $47 ,$84, $20, $4f, $7b                  ;$92EE
        .byte   $8d, $53, $04, $8d ,$5f, $04, $20, $0e                  ;$92F6
        .byte   $b1, $a9                                                ;$92FE

;===============================================================================

; $9300..$9700 is in "math_tables.asm"
; $9700..$9900 is in "gfx/table_bitmap.asm"

;===============================================================================

.segment        "CODE_9900"

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
        .lobytes menuscr_pos
menuscr_hi:                                                             ;$9919
        .hibytes menuscr_pos

;===============================================================================

_9932:                                                                  ;$9932
        jsr _9ad8
        jsr _7d1f
        ora ZP_POLYOBJ01_XPOS_pt2
        bne _995d
        
        lda ZP_43
        cmp # $8e
        bcs _995d
        
        ldy # $02
        jsr _9964
        ldy # $06
        
        lda ZP_43
        adc # $01
        jsr _9964
        
        lda # visibility::redraw
        ora ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY
        
        lda # $08
        jmp _a174

_995b:                                                                  ;$995B
        pla 
        pla 
_995d:                                                                  ;$995D
        lda # visibility::redraw ^$FF   ;=%11110111
        and ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY
        rts 

;===============================================================================

_9964:                                                                  ;$9964
        sta [ZP_TEMP_ADDR2], y
        iny 
        iny 
        sta [ZP_TEMP_ADDR2], y
        lda ZP_POLYOBJ01_XPOS_pt1
        dey 
        sta [ZP_TEMP_ADDR2], y
        adc # $03
        bcs _995b
        dey 
        dey 
        sta [ZP_TEMP_ADDR2], y
        rts 

;===============================================================================

_9978:                                                                  ;$9978
.export _9978
        ldy ZP_VAR_R
        lda ZP_VAR_Q
        sta ZP_VAR_S
        ldx # $00
        stx ZP_VAR_Q
        lda # $08
        sta ZP_VAR_T
_9986:                                                                  ;$9986
        cpx ZP_VAR_Q
        bcc _9998
        bne _9990
        cpy # $40
        bcc _9998
_9990:                                                                  ;$9990
        tya 
        sbc # $40
        tay 
        txa 
        sbc ZP_VAR_Q
        tax 
_9998:                                                                  ;$9998
        rol ZP_VAR_Q
        asl ZP_VAR_S
        tya 
        rol 
        tay 
        txa 
        rol 
        tax 
        asl ZP_VAR_S
        tya 
        rol 
        tay 
        txa 
        rol 
        tax 
        dec ZP_VAR_T
        bne _9986
        rts 

;===============================================================================

_99af:                                                                  ;$99AF
.export _99af
        cmp ZP_VAR_Q
        bcs _9a07
        sta ZP_B6
        tax 
        beq _99d3
        lda table_logdiv, x
        ldx ZP_VAR_Q
        sec 
        sbc table_logdiv, x
        bmi _99d6
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _9a07
        tax 
        lda _9500, x
_99d3:                                                                  ;$99D3
        sta ZP_VAR_R
        rts 

_99d6:                                                                  ;$99D6
        ldx ZP_B6
        lda table_log, x
        ldx ZP_VAR_Q
        sbc table_log, x
        bcs _9a07
        tax 
        lda _9600, x
        sta ZP_VAR_R
        rts 

;===============================================================================

; unused / unreferenced?
;$99e9:
        bcs _9a07
        ldx # $fe
        stx ZP_VAR_R
_99ef:                                                                  ;$99EF
        asl 
        bcs _99fd
        cmp ZP_VAR_Q
        bcc _99f8
        sbc ZP_VAR_Q
_99f8:                                                                  ;$99F8
        rol ZP_VAR_R
        bcs _99ef
        rts 

_99fd:                                                                  ;$99FD
        sbc ZP_VAR_Q
        sec 
        rol ZP_VAR_R
        bcs _99ef
        lda ZP_VAR_R
        rts 

_9a07:                                                                  ;$9A07
        lda # $ff
        sta ZP_VAR_R
        rts 

;===============================================================================

_9a0c:                                                                  ;$9A0C
        eor ZP_VAR_S
        bmi _9a16
        lda ZP_VAR_Q
        clc 
        adc ZP_VAR_R
        rts 

_9a16:                                                                  ;$9A16
        lda ZP_VAR_R
        sec 
        sbc ZP_VAR_Q
        bcc _9a1f
        clc 
        rts 

_9a1f:                                                                  ;$9A1F
        pha 
        lda ZP_VAR_S
        eor # %10000000
        sta ZP_VAR_S
        pla 
        eor # %11111111
        adc # $01
        rts 

;===============================================================================

_9a2c:                                                                  ;$9A2C
.export _9a2c
        ldx # $00
        ldy # $00
_9a30:                                                                  ;$9A30
        lda ZP_VAR_X
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_MATRIX, x
        jsr _39ea
        sta ZP_VAR_T
        lda ZP_VAR_Y
        eor ZP_TEMPOBJ_M2x0_HI, x
        sta ZP_VAR_S
        lda ZP_VAR_X2
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_M2x1_LO, x
        jsr _39ea
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_VAR_Y2
        eor ZP_TEMPOBJ_M2x1_HI, x
        jsr _9a0c
        sta ZP_VAR_T
        lda ZP_6F
        sta ZP_VAR_Q
        lda ZP_TEMPOBJ_M2x2_LO, x
        jsr _39ea
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_70
        eor ZP_TEMPOBJ_M2x2_HI, x
        jsr _9a0c
        sta ZP_71, y
        lda ZP_VAR_S
        sta ZP_72, y
        iny 
        iny 
        txa 
        clc 
        adc # $06
        tax 
        cmp # $11
        bcc _9a30
        rts 

;===============================================================================

_9a83:                                                                  ;$9A83
        jmp _7d62

_9a86:                                                                  ;$9A86
.export _9a86
        lda ZP_A5
        bmi _9a83
        lda # $1f
        sta ZP_AD

        lda ZP_POLYOBJ_BEHAVIOUR
        bmi _9ad8
        
        lda # visibility::display
        bit ZP_POLYOBJ_VISIBILITY
        bne _9ac5
        bpl _9ac5
        
        ora ZP_POLYOBJ_VISIBILITY
        and # (visibility::exploding | visibility::firing)^$FF  ;=%00111111
        sta ZP_POLYOBJ_VISIBILITY
        lda # $00
        ldy # $1c
        sta [ZP_POLYOBJ_ADDR], y
        ldy # $1e
        sta [ZP_POLYOBJ_ADDR], y
        jsr _9ad8
        ldy # $01
        lda # $12
        sta [ZP_TEMP_ADDR2], y

        ldy # Hull::_07                  ;=$07: "explosion count"?
        lda [ZP_HULL_ADDR], y
        
        ldy # $02                       ;?
        sta [ZP_TEMP_ADDR2], y
_9abb:                                                                  ;$9ABB
        iny 
        jsr get_random_number
        sta [ZP_TEMP_ADDR2], y
        cpy # $06
        bne _9abb
_9ac5:                                                                  ;$9AC5
        lda ZP_POLYOBJ_ZPOS_HI
        bpl _9ae6
_9ac9:                                                                  ;$9AC9
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9ad8

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::redraw ^$FF   ;=%11110111
        sta ZP_POLYOBJ_VISIBILITY
        jmp _7866

_9ad8:                                                                  ;$9AD8
        lda # visibility::redraw
        bit ZP_POLYOBJ_VISIBILITY
        beq _9ae5
        eor ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY
        jmp _a178

_9ae5:                                                                  ;$9AE5
        rts 

_9ae6:                                                                  ;$9AE6
        lda ZP_POLYOBJ_ZPOS_MI
        cmp # $c0
        bcs _9ac9
        lda ZP_POLYOBJ_XPOS_LO
        cmp ZP_POLYOBJ_ZPOS_LO
        lda ZP_POLYOBJ_XPOS_MI
        sbc ZP_POLYOBJ_ZPOS_MI
        bcs _9ac9
        lda ZP_POLYOBJ_YPOS_LO
        cmp ZP_POLYOBJ_ZPOS_LO
        lda ZP_POLYOBJ_YPOS_MI
        sbc ZP_POLYOBJ_ZPOS_MI
        bcs _9ac9

        ldy # Hull::_06                 ;=$06: "gun vertex"?
        lda [ZP_HULL_ADDR], y
        tax 
        
        lda # $ff
        sta $0100, x
        sta $0101, x
        lda ZP_POLYOBJ_ZPOS_LO
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        lsr 
        ror ZP_VAR_T
        lsr 
        ror ZP_VAR_T
        lsr 
        ror ZP_VAR_T
        lsr 
        bne _9b29
        lda ZP_VAR_T
        ror 
        lsr 
        lsr 
        lsr 
        sta ZP_AD
        bpl _9b3a
_9b29:                                                                  ;$9B29
        ldy # Hull::_0d                 ;=$0D: level-of-detail distance
        lda [ZP_HULL_ADDR], y
        cmp ZP_POLYOBJ_ZPOS_MI
        bcs _9b3a

        lda # visibility::display
        and ZP_POLYOBJ_VISIBILITY
        bne _9b3a
        jmp _9932

_9b3a:                                                                  ;$9B3A
        ldx # $05                       ; 6-byte counter

        ; take a copy of matrix 2x0, 2x1 & 2x2
:       lda ZP_POLYOBJ_M2x0, x                                          ;$9B3C
        sta ZP_TEMPOBJ_M2x0, x
        ; take a copy of matrix 1x0, 1x1 & 1x2
        lda ZP_POLYOBJ_M1x0, x
        sta ZP_TEMPOBJ_M1x0, x
        ; take a copy of matrix 0x0, 0x1 & 0x2
        lda ZP_POLYOBJ_M0x0, x
        sta ZP_TEMPOBJ_M0x0, x
        dex 
        bpl :-

        lda # $c5
        sta ZP_VAR_Q
        ldy # $10
_9b51:                                                                  ;$9B51
        lda ZP_TEMPOBJ_M2x0_LO, y
        asl 
        lda ZP_TEMPOBJ_M2x0_HI, y
        rol 
        jsr _99af
        ldx ZP_VAR_R
        stx ZP_TEMPOBJ_MATRIX, y
        dey 
        dey 
        bpl _9b51
        ldx # $08
_9b66:                                                                  ;$9B66
        lda ZP_POLYOBJ_XPOS_LO, x
        sta ZP_85, x
        dex 
        bpl _9b66
        
        lda # $ff
        sta ZP_44
        
        ldy # Hull::face_count          ;=$0C: face count
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9b8b
        lda [ZP_HULL_ADDR], y
        lsr 
        lsr 
        tax 
        lda # $ff
_9b80:                                                                  ;$9B80
        sta ZP_POLYOBJ01_XPOS_pt1, x
        dex 
        bpl _9b80
        inx 
        stx ZP_AD
_9b88:                                                                  ;$9B88
        jmp _9cfe

_9b8b:                                                                  ;$9B8B
        lda [ZP_HULL_ADDR], y
        beq _9b88
        sta ZP_AE

        ldy # Hull::_12                 ;=$12: "scaling of normals"?
        lda [ZP_HULL_ADDR], y
        tax 
        lda ZP_8C
        tay 
        beq _9baa
_9b9b:                                                                  ;$9B9B
        inx 
        lsr ZP_89
        ror ZP_88
        lsr ZP_86
        ror ZP_85
        lsr 
        ror ZP_8B
        tay 
        bne _9b9b
_9baa:                                                                  ;$9BAA
        stx ZP_9F
        lda ZP_8D
        sta ZP_70
        lda ZP_85
        sta ZP_VAR_X
        lda ZP_87
        sta ZP_VAR_Y
        lda ZP_88
        sta ZP_VAR_X2
        lda ZP_8A
        sta ZP_VAR_Y2
        lda ZP_8B
        sta ZP_6F
        jsr _9a2c
        lda ZP_71
        sta ZP_85
        lda ZP_72
        sta ZP_87
        lda ZP_73
        sta ZP_88
        lda ZP_74
        sta ZP_8A
        lda ZP_75
        sta ZP_8B
        lda ZP_76
        sta ZP_8D

        ldy # Hull::face_data_lo
        lda [ZP_HULL_ADDR], y
        clc 
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR3_LO

        ldy # Hull::face_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR3_HI

        ldy # Hull::_00         ;=$00: "scoop / debris"?
_9bf2:                                                                  ;$9BF2
        lda [ZP_TEMP_ADDR3], y
        sta ZP_72
        and # %00011111
        cmp ZP_AD
        bcs _9c0b
        tya 
        lsr 
        lsr 
        tax 
        lda # $ff
        sta ZP_POLYOBJ01_XPOS_pt1, x
        tya 
        adc # $04
        tay 
        jmp _9cf7

_9c0b:                                                                  ;$9C0B
        lda ZP_72
        asl 
        sta ZP_74
        asl 
        sta ZP_76
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_71
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_73
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_75
        ldx ZP_9F
        cpx # $04
        bcc _9c4b
        lda ZP_85
        sta ZP_VAR_X
        lda ZP_87
        sta ZP_VAR_Y
        lda ZP_88
        sta ZP_VAR_X2
        lda ZP_8A
        sta ZP_VAR_Y2
        lda ZP_8B
        sta ZP_6F
        lda ZP_8D
        sta ZP_70
        jmp _9ca9

;===============================================================================

_9c43:                                                                  ;$9C43
        lsr ZP_85
        lsr ZP_8B
        lsr ZP_88
        ldx # $01
_9c4b:                                                                  ;$9C4B
        lda ZP_71
        sta ZP_VAR_X
        lda ZP_73
        sta ZP_VAR_X2
        lda ZP_75
        dex 
        bmi _9c60
_9c58:                                                                  ;$9C58
        lsr ZP_VAR_X
        lsr ZP_VAR_X2
        lsr 
        dex 
        bpl _9c58
_9c60:                                                                  ;$9C60
        sta ZP_VAR_R
        lda ZP_76
        sta ZP_VAR_S
        lda ZP_8B
        sta ZP_VAR_Q
        lda ZP_8D
        jsr _9a0c
        bcs _9c43
        sta ZP_6F
        lda ZP_VAR_S
        sta ZP_70
        lda ZP_VAR_X
        sta ZP_VAR_R
        lda ZP_72
        sta ZP_VAR_S
        lda ZP_85
        sta ZP_VAR_Q
        lda ZP_87
        jsr _9a0c
        bcs _9c43
        sta ZP_VAR_X
        lda ZP_VAR_S
        sta ZP_VAR_Y
        lda ZP_VAR_X2
        sta ZP_VAR_R
        lda ZP_74
        sta ZP_VAR_S
        lda ZP_88
        sta ZP_VAR_Q
        lda ZP_8A
        jsr _9a0c
        bcs _9c43
        sta ZP_VAR_X2
        lda ZP_VAR_S
        sta ZP_VAR_Y2
_9ca9:                                                                  ;$9CA9
        lda ZP_71
        sta ZP_VAR_Q
        lda ZP_VAR_X
        jsr _39ea
        sta ZP_VAR_T
        lda ZP_72
        eor ZP_VAR_Y
        sta ZP_VAR_S
        lda ZP_73
        sta ZP_VAR_Q
        lda ZP_VAR_X2
        jsr _39ea
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_74
        eor ZP_VAR_Y2
        jsr _9a0c
        sta ZP_VAR_T
        lda ZP_75
        sta ZP_VAR_Q
        lda ZP_6F
        jsr _39ea
        sta ZP_VAR_Q
        lda ZP_VAR_T
        sta ZP_VAR_R
        lda ZP_70
        eor ZP_76
        jsr _9a0c
        pha 
        tya 
        lsr 
        lsr 
        tax 
        pla 
        bit ZP_VAR_S
        bmi _9cf4
        lda # $00
_9cf4:                                                                  ;$9CF4
        sta ZP_POLYOBJ01_XPOS_pt1, x
        iny 
_9cf7:                                                                  ;$9CF7
        cpy ZP_AE
        bcs _9cfe
        jmp _9bf2

        ;-----------------------------------------------------------------------

_9cfe:                                                                  ;$9CFE
        ldy ZP_TEMPOBJ_M2x1_LO
        ldx ZP_TEMPOBJ_M2x1_HI
        lda ZP_TEMPOBJ_M1x0_LO
        sta ZP_TEMPOBJ_M2x1_LO
        lda ZP_TEMPOBJ_M1x0_HI
        sta ZP_TEMPOBJ_M2x1_HI
        sty ZP_TEMPOBJ_M1x0_LO
        stx ZP_TEMPOBJ_M1x0_HI
        ldy ZP_TEMPOBJ_M2x2_LO
        ldx ZP_TEMPOBJ_M2x2_HI
        lda ZP_TEMPOBJ_M0x0_LO
        sta ZP_TEMPOBJ_M2x2_LO
        lda ZP_TEMPOBJ_M0x0_HI
        sta ZP_TEMPOBJ_M2x2_HI
        sty ZP_TEMPOBJ_M0x0_LO
        stx ZP_TEMPOBJ_M0x0_HI
        ldy ZP_TEMPOBJ_M1x2_LO
        ldx ZP_TEMPOBJ_M1x2_HI
        lda ZP_TEMPOBJ_M0x1_LO
        sta ZP_TEMPOBJ_M1x2_LO
        lda ZP_TEMPOBJ_M0x1_HI
        sta ZP_TEMPOBJ_M1x2_HI
        sty ZP_TEMPOBJ_M0x1_LO
        stx ZP_TEMPOBJ_M0x1_HI

        ldy # Hull::_08         ;=$08: verticies byte length
        lda [ZP_HULL_ADDR], y
        sta ZP_AE
        
        lda ZP_HULL_ADDR_LO
        clc 
        adc # $14
        sta ZP_TEMP_ADDR3_LO
        lda ZP_HULL_ADDR_HI
        adc # $00
        sta ZP_TEMP_ADDR3_HI
        ldy # $00
        sty ZP_AA
_9d45:                                                                  ;$9D45
        sty ZP_9F
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_X
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_X2
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_6F
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_T
        and # %00011111
        cmp ZP_AD
        bcc _9d8e
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9d91
_9d8e:                                                                  ;$9D8E
.export _9d8e
        jmp _9f06

        ;-----------------------------------------------------------------------

_9d91:                                                                  ;$9D91
        lda ZP_VAR_T
        sta ZP_VAR_Y
        asl 
        sta ZP_VAR_Y2
        asl 
        sta ZP_70
        jsr _9a2c
        lda ZP_POLYOBJ_XPOS_HI
        sta ZP_VAR_X2
        eor ZP_72
        bmi _9db6
        clc 
        lda ZP_71
        adc ZP_POLYOBJ_XPOS_LO
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_MI
        adc # $00
        sta ZP_VAR_Y
_9db3:                                                                  ;$9DB3
.export _9db3
        jmp _9dd9

_9db6:                                                                  ;$9DB6
        lda ZP_POLYOBJ_XPOS_LO
        sec 
        sbc ZP_71
        sta ZP_VAR_X
        lda ZP_POLYOBJ_XPOS_MI
        sbc # $00
        sta ZP_VAR_Y
        bcs _9dd9
        eor # %11111111
        sta ZP_VAR_Y
        lda # $01
        sbc ZP_VAR_X
        sta ZP_VAR_X
        bcc _9dd3
        inc ZP_VAR_Y
_9dd3:                                                                  ;$9DD3
        lda ZP_VAR_X2
        eor # %10000000
        sta ZP_VAR_X2
_9dd9:                                                                  ;$9DD9
        lda ZP_POLYOBJ_YPOS_HI
        sta ZP_70
        eor ZP_74
        bmi _9df1
        clc 
        lda ZP_73
        adc ZP_POLYOBJ_YPOS_LO
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_MI
        adc # $00
        sta ZP_6F
_9dee:                                                                  ;$9DEE
.export _9dee
        jmp _9e16

        ;-----------------------------------------------------------------------

_9df1:                                                                  ;$9DF1
        lda ZP_POLYOBJ_YPOS_LO
        sec 
        sbc ZP_73
        sta ZP_VAR_Y2
        lda ZP_POLYOBJ_YPOS_MI
        sbc # $00
        sta ZP_6F
        bcs _9e16
        eor # %11111111
        sta ZP_6F
        lda ZP_VAR_Y2
        eor # %11111111
        adc # $01
        sta ZP_VAR_Y2
        lda ZP_70
        eor # %10000000
        sta ZP_70
        bcc _9e16
        inc ZP_6F
_9e16:                                                                  ;$9E16
        lda ZP_76
        bmi _9e64
        lda ZP_75
        clc 
        adc ZP_POLYOBJ_ZPOS_LO
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        adc # $00
        sta ZP_VAR_U
_9e27:                                                                  ;$9E27
.export _9e27
        jmp _9e83

;===============================================================================

_9e2a:                                                                  ;$9E2A
        ldx ZP_VAR_Q
        beq _9e4a
        ldx # $00
_9e30:                                                                  ;$9E30
        lsr 
        inx 
        cmp ZP_VAR_Q
        bcs _9e30
        stx ZP_VAR_S
        jsr _99af
        ldx ZP_VAR_S
        lda ZP_VAR_R
_9e3f:                                                                  ;$9E3F
        asl 
        rol ZP_VAR_U
        bmi _9e4a
        dex 
        bne _9e3f
        sta ZP_VAR_R
        rts 

_9e4a:                                                                  ;$9E4A
        lda # $32
        sta ZP_VAR_R
        sta ZP_VAR_U
        rts 

;===============================================================================

_9e51:                                                                  ;$9E51
        lda # $80
        sec 
        sbc ZP_VAR_R
        sta $0100, x
        inx 
        lda # $00
        sbc ZP_VAR_U
        sta $0100, x
        jmp _9ec3

;===============================================================================

_9e64:                                                                  ;$9E64
        lda ZP_POLYOBJ_ZPOS_LO
        sec 
        sbc ZP_75
        sta ZP_VAR_T
        lda ZP_POLYOBJ_ZPOS_MI
        sbc # $00
        sta ZP_VAR_U
        bcc _9e7b
        bne _9e83
        lda ZP_VAR_T
        cmp # $04
        bcs _9e83
_9e7b:                                                                  ;$9E7B
        lda # $00
        sta ZP_VAR_U
        lda # $04
        sta ZP_VAR_T
_9e83:                                                                  ;$9E83
        lda ZP_VAR_U
        ora ZP_VAR_Y
        ora ZP_6F
        beq _9e9a
        lsr ZP_VAR_Y
        ror ZP_VAR_X
        lsr ZP_6F
        ror ZP_VAR_Y2
        lsr ZP_VAR_U
        ror ZP_VAR_T
        jmp _9e83

_9e9a:                                                                  ;$9E9A
        lda ZP_VAR_T
        sta ZP_VAR_Q
        lda ZP_VAR_X
        cmp ZP_VAR_Q
        bcc _9eaa
        jsr _9e2a
        jmp _9ead

_9eaa:                                                                  ;$9EAA
        jsr _99af
_9ead:                                                                  ;$9EAD
        ldx ZP_AA
        lda ZP_VAR_X2
        bmi _9e51
        lda ZP_VAR_R
        clc 
        adc # $80
        sta $0100, x
        inx 
        lda ZP_VAR_U
        adc # $00
        sta $0100, x
_9ec3:                                                                  ;$9EC3
       .phx                     ; push X to stack (via A)
        lda # $00
        sta ZP_VAR_U
        lda ZP_VAR_T
        sta ZP_VAR_Q
        lda ZP_VAR_Y2
        cmp ZP_VAR_Q
        bcc _9eec
        jsr _9e2a
        jmp _9eef

_9ed9:                                                                  ;$9ED9
        lda # $48
        clc 
        adc ZP_VAR_R
        sta $0100, x
        inx 
        lda # $00
        adc ZP_VAR_U
        sta $0100, x
        jmp _9f06

_9eec:                                                                  ;$9EEC
        jsr _99af
_9eef:                                                                  ;$9EEF
        pla 
        tax 
        inx 
        lda ZP_70
        bmi _9ed9
        lda # $48
        sec 
        sbc ZP_VAR_R
        sta $0100, x
        inx 
        lda # $00
        sbc ZP_VAR_U
        sta $0100, x
_9f06:                                                                  ;$9F06
        clc 
        lda ZP_AA
        adc # $04
        sta ZP_AA
        lda ZP_9F
        adc # $06
        tay 
        bcs _9f1b
        cmp ZP_AE
        bcs _9f1b
        jmp _9d45

_9f1b:                                                                  ;$9F1B
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::display
        beq _9f2a

        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::redraw
        sta ZP_POLYOBJ_VISIBILITY
        jmp _7866

_9f2a:                                                                  ;$9F2A
        lda # visibility::redraw
        bit ZP_POLYOBJ_VISIBILITY
        beq _9f35
        jsr _a178
        lda # visibility::redraw
_9f35:                                                                  ;$9F35
        ora ZP_POLYOBJ_VISIBILITY
        sta ZP_POLYOBJ_VISIBILITY

        ldy # Hull::edge_count  ;=$09: edge count
        lda [ZP_HULL_ADDR], y
        sta ZP_AE
        
        ldy # $00
        sty ZP_VAR_U
        sty ZP_9F
        inc ZP_VAR_U
        bit ZP_POLYOBJ_VISIBILITY
        bvc _9f9f
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::firing ^$FF
        sta ZP_POLYOBJ_VISIBILITY

        ldy # Hull::_06         ;=$06: gun vertex
        lda [ZP_HULL_ADDR], y
        tay 
        ldx $0100, y
        stx ZP_VAR_X
        inx 
        beq _9f9f
        ldx $0101, y
        stx ZP_VAR_Y
        inx 
        beq _9f9f
        ldx $0102, y
        stx ZP_VAR_X2
        ldx $0103, y
        stx ZP_VAR_Y2
        lda # $00
        sta ZP_6F
        sta ZP_70
        sta ZP_72
        lda ZP_POLYOBJ_ZPOS_LO
        sta ZP_71
        lda ZP_POLYOBJ_XPOS_HI
        bpl _9f82
        dec ZP_6F
_9f82:                                                                  ;$9F82
        jsr _a013
        bcs _9f9f
        ldy ZP_VAR_U
        lda ZP_VAR_X
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_Y
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_X2
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_Y2
        sta [ZP_TEMP_ADDR2], y
        iny 
        sty ZP_VAR_U
_9f9f:                                                                  ;$9F9F
        ldy # Hull::edge_data_lo
        clc 
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_LO
        sta ZP_TEMP_ADDR3_LO

        ldy # Hull::edge_data_hi
        lda [ZP_HULL_ADDR], y
        adc ZP_HULL_ADDR_HI
        sta ZP_TEMP_ADDR3_HI

        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y
        sta ZP_TEMP_VAR

        ldy ZP_9F
_9fb8:                                                                  ;$9FB8
        lda [ZP_TEMP_ADDR3], y
        cmp ZP_AD
        bcc _9fd6
        iny 
        lda [ZP_TEMP_ADDR3], y
        iny 
        sta ZP_VAR_P1
        and # %00001111
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9fd9
        lda ZP_VAR_P1
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda ZP_POLYOBJ01_XPOS_pt1, x
        bne _9fd9
_9fd6:                                                                  ;$9FD6
        jmp _a15b

_9fd9:                                                                  ;$9FD9
        lda [ZP_TEMP_ADDR3], y
        tax 
        iny 
        lda [ZP_TEMP_ADDR3], y
        sta ZP_VAR_Q
        lda $0101, x
        sta ZP_VAR_Y
        lda $0100, x
        sta ZP_VAR_X
        lda $0102, x
        sta ZP_VAR_X2
        lda $0103, x
        sta ZP_VAR_Y2
        ldx ZP_VAR_Q
        lda $0100, x
        sta ZP_6F
        lda $0103, x
        sta ZP_72
        lda $0102, x
        sta ZP_71
        lda $0101, x
        sta ZP_70
        jsr _a01a
        bcs _9fd6
        jmp _a13f

;===============================================================================

_a013:                                                                  ;$A013
.export _a013
        lda # $00
        sta VAR_06F4
        lda ZP_70
_a01a:                                                                  ;$A01A
        bit ZP_B7
        bmi _a03c
        ldx # $8f
        ora ZP_72
        bne _a02a
        cpx ZP_71
        bcc _a02a
        ldx # $00
_a02a:                                                                  ;$A02A
        stx ZP_A2
        lda ZP_VAR_Y
        ora ZP_VAR_Y2
        bne _a04e
        lda # $8f
        cmp ZP_VAR_X2
        bcc _a04e
        lda ZP_A2
        bne _a04c
_a03c:                                                                  ;$A03C
        lda ZP_VAR_X2
        sta ZP_VAR_Y
        lda ZP_6F
        sta ZP_VAR_X2
        lda ZP_71
        sta ZP_VAR_Y2
        clc 
        rts 

;===============================================================================

_a04a:                                                                  ;$A04A
        sec 
        rts 

_a04c:                                                                  ;$A04C
        lsr ZP_A2
_a04e:                                                                  ;$A04E
        lda ZP_A2
        bpl _a081
        lda ZP_VAR_Y
        and ZP_70
        bmi _a04a
        lda ZP_VAR_Y2
        and ZP_72
        bmi _a04a
        ldx ZP_VAR_Y
        dex 
        txa 
        ldx ZP_70
        dex 
        stx ZP_73
        ora ZP_73
        bpl _a04a
        lda ZP_VAR_X2
        cmp # $90
        lda ZP_VAR_Y2
        sbc # $00
        sta ZP_73
        lda ZP_71
        cmp # $90
        lda ZP_72
        sbc # $00
        ora ZP_73
        bpl _a04a
_a081:                                                                  ;$A081
       .phy                     ; push Y to stack (via A)
        lda ZP_6F
        sec 
        sbc ZP_VAR_X
        sta ZP_73
        lda ZP_70
        sbc ZP_VAR_Y
        sta ZP_74
        lda ZP_71
        sec 
        sbc ZP_VAR_X2
        sta ZP_75
        lda ZP_72
        sbc ZP_VAR_Y2
        sta ZP_76
        eor ZP_74
        sta ZP_VAR_S
        lda ZP_76
        bpl _a0b2
        lda # $00
        sec 
        sbc ZP_75
        sta ZP_75
        lda # $00
        sbc ZP_76
        sta ZP_76
_a0b2:                                                                  ;$A0B2
        lda ZP_74
        bpl _a0c1
        sec 
        lda # $00
        sbc ZP_73
        sta ZP_73
        lda # $00
        sbc ZP_74
_a0c1:                                                                  ;$A0C1
        tax 
        bne _a0c8
        ldx ZP_76
        beq _a0d2
_a0c8:                                                                  ;$A0C8
        lsr 
        ror ZP_73
        lsr ZP_76
        ror ZP_75
        jmp _a0c1

        ;-----------------------------------------------------------------------

_a0d2:                                                                  ;$A0D2
        stx ZP_VAR_T
        lda ZP_73
        cmp ZP_75
        bcc _a0e4
        sta ZP_VAR_Q
        lda ZP_75
        jsr _99af
        jmp _a0ef

_a0e4:                                                                  ;$A0E4
        lda ZP_75
        sta ZP_VAR_Q
        lda ZP_73
        jsr _99af
        dec ZP_VAR_T
_a0ef:                                                                  ;$A0EF
        lda ZP_VAR_R
        sta ZP_73
        lda ZP_VAR_S
        sta ZP_74
        lda ZP_A2
        beq _a0fd
        bpl _a110
_a0fd:                                                                  ;$A0FD
        jsr _a19f
        lda ZP_A2
        bpl _a136
        lda ZP_VAR_Y
        ora ZP_VAR_Y2
        bne _a13b
        lda ZP_VAR_X2
        cmp # $90
        bcs _a13b
_a110:                                                                  ;$A110
        ldx ZP_VAR_X
        lda ZP_6F
        sta ZP_VAR_X
        stx ZP_6F
        lda ZP_70
        ldx ZP_VAR_Y
        stx ZP_70
        sta ZP_VAR_Y
        ldx ZP_VAR_X2
        lda ZP_71
        sta ZP_VAR_X2
        stx ZP_71
        lda ZP_72
        ldx ZP_VAR_Y2
        stx ZP_72
        sta ZP_VAR_Y2
        jsr _a19f
        dec VAR_06F4
_a136:                                                                  ;$A136
        pla 
        tay 
        jmp _a03c

        ;-----------------------------------------------------------------------

_a13b:                                                                  ;$A13B
        pla 
        tay 
        sec 
        rts 

;===============================================================================

_a13f:                                                                  ;$A13F
        ldy ZP_VAR_U
        lda ZP_VAR_X
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_Y
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_X2
        sta [ZP_TEMP_ADDR2], y
        iny 
        lda ZP_VAR_Y2
        sta [ZP_TEMP_ADDR2], y
        iny 
        sty ZP_VAR_U
        cpy ZP_TEMP_VAR
        bcs _a172
_a15b:                                                                  ;$A15B
        inc ZP_9F
        ldy ZP_9F
        cpy ZP_AE
        bcs _a172
        ldy # $00
        lda ZP_TEMP_ADDR3_LO
        adc # $04
        sta ZP_TEMP_ADDR3_LO
        bcc _a16f
        inc ZP_TEMP_ADDR3_HI
_a16f:                                                                  ;$A16F
        jmp _9fb8

        ;-----------------------------------------------------------------------

_a172:                                                                  ;$A172
        lda ZP_VAR_U
_a174:                                                                  ;$A174
        ldy # $00
        sta [ZP_TEMP_ADDR2], y
_a178:                                                                  ;$A178
        ldy # $00
        lda [ZP_TEMP_ADDR2], y
        sta ZP_AE
        cmp # $04
        bcc _a19e
        iny 
_a183:                                                                  ;$A183
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_X
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Y
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_X2
        iny 
        lda [ZP_TEMP_ADDR2], y
        sta ZP_VAR_Y2
        ; TODO: do validation of line direction here so as to allow
        ;       removal of validation in the line routine
        jsr draw_line
        iny 
        cpy ZP_AE
        bcc _a183
_a19e:                                                                  ;$A19E
        rts 

;===============================================================================

_a19f:                                                                  ;$A19F
        lda ZP_VAR_Y
        bpl _a1ba
        sta ZP_VAR_S
        jsr _a219
        txa 
        clc 
        adc ZP_VAR_X2
        sta ZP_VAR_X2
        tya 
        adc ZP_VAR_Y2
        sta ZP_VAR_Y2
        lda # $00
        sta ZP_VAR_X
        sta ZP_VAR_Y
        tax 
_a1ba:                                                                  ;$A1BA
        beq _a1d5
        sta ZP_VAR_S
        dec ZP_VAR_S
        jsr _a219
        txa 
        clc 
        adc ZP_VAR_X2
        sta ZP_VAR_X2
        tya 
        adc ZP_VAR_Y2
        sta ZP_VAR_Y2
        ldx # $ff
        stx ZP_VAR_X
        inx 
        stx ZP_VAR_Y
_a1d5:                                                                  ;$A1D5
        lda ZP_VAR_Y2
        bpl _a1f3
        sta ZP_VAR_S
        lda ZP_VAR_X2
        sta ZP_VAR_R
        jsr _a248
        txa 
        clc 
        adc ZP_VAR_X
        sta ZP_VAR_X
        tya 
        adc ZP_VAR_Y
        sta ZP_VAR_Y
        lda # $00
        sta ZP_VAR_X2
        sta ZP_VAR_Y2
_a1f3:                                                                  ;$A1F3
        lda ZP_VAR_X2
        sec 
        sbc # $90
        sta ZP_VAR_R
        lda ZP_VAR_Y2
        sbc # $00
        sta ZP_VAR_S
        bcc _a218
        jsr _a248
        txa 
        clc 
        adc ZP_VAR_X
        sta ZP_VAR_X
        tya 
        adc ZP_VAR_Y
        sta ZP_VAR_Y
        lda # $8f
        sta ZP_VAR_X2
        lda # $00
        sta ZP_VAR_Y2
_a218:                                                                  ;$A218
        rts 

;===============================================================================

_a219:                                                                  ;$A219
        lda ZP_VAR_X
        sta ZP_VAR_R
        jsr _a284
        pha 
        ldx ZP_VAR_T
        bne _a250
_a225:                                                                  ;$A225
        lda # $00
        tax 
        tay 
        lsr ZP_VAR_S
        ror ZP_VAR_R
        asl ZP_VAR_Q
        bcc _a23a
_a231:                                                                  ;$A231
        txa 
        clc 
        adc ZP_VAR_R
        tax 
        tya 
        adc ZP_VAR_S
        tay 
_a23a:                                                                  ;$A23A
        lsr ZP_VAR_S
        ror ZP_VAR_R
        asl ZP_VAR_Q
        bcs _a231
        bne _a23a
        pla 
        bpl _a277
        rts 

;===============================================================================

_a248:                                                                  ;$A248
        jsr _a284
        pha 
        ldx ZP_VAR_T
        bne _a225
_a250:                                                                  ;$A250
        lda # $ff
        tay 
        asl 
        tax 
_a255:                                                                  ;$A255
        asl ZP_VAR_R
        rol ZP_VAR_S
        lda ZP_VAR_S
        bcs _a261
        cmp ZP_VAR_Q
        bcc _a26c
_a261:                                                                  ;$A261
        sbc ZP_VAR_Q
        sta ZP_VAR_S
        lda ZP_VAR_R
        sbc # $00
        sta ZP_VAR_R
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
_a283:                                                                  ;$A283
        rts 

;===============================================================================

_a284:                                                                  ;$A284
        ldx ZP_73
        stx ZP_VAR_Q
        lda ZP_VAR_S
        bpl _a29d
        lda # $00
        sec 
        sbc ZP_VAR_R
        sta ZP_VAR_R
        lda ZP_VAR_S
        pha 
        eor # %11111111
        adc # $00
        sta ZP_VAR_S
        pla 
_a29d:                                                                  ;$A29D
        eor ZP_74
        rts 

;===============================================================================
; process object? checks if A.I. needs running and appears to rotate and move
; the objcet
;
;       X = ship type (i.e. a `hull_pointers` index)
;
_a2a0:                                                                  ;$A2A0
.export _a2a0

        ; is the ship exploding? must be 'near'
        ; (i.e. not a distant dot), and in exploding state
        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::exploding | visibility::display
       .bnz _a2cb

        ; handle explosion?

        lda ZP_A3               ; move counter?
        eor ZP_9D
        and # %00001111
        bne _a2b1
        jsr _9105
_a2b1:                                                                  ;$A2B1
        ldx ZP_A5
        bpl _a2b8
        jmp _a53d

        ;-----------------------------------------------------------------------
        ; is the A.I. active?
        ;
_a2b8:  lda ZP_POLYOBJ_ATTACK   ; check current A.I. state              ;$A2B8
        bpl _a2cb               ; is bit 7 ("active") set?
        
        ;is this a missile?
        cpx # hull_missile_index
        ; missiles always run A.I. every frame
        beq :+

        ; should we run an A.I. check? when the A.I. is not "active",
        ; it runs at a much lower rate. these instructions here gear-down
        ; the ratio
        ;
        lda ZP_A3               ; move counter?
        eor ZP_9D
        and # %00000111         ; modulo 8
        bne _a2cb

        ; handle A.I.
:       jsr _32ad                                                       ;$A2C8

_a2cb:                                                                  ;$A2CB
        jsr _b410

        lda ZP_POLYOBJ_VERTX_LO
        asl                     ; x2
        asl                     ; x4 (i.e. each vertex is 4 bytes)
        sta ZP_VAR_Q

        lda ZP_POLYOBJ_M0x0_HI
        and # %01111111         ; remove sign
        jsr _39ea
        sta ZP_VAR_R

        lda ZP_POLYOBJ_M0x0_HI
        ldx # $00
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_M0x1_HI
        and # %01111111
        jsr _39ea
        sta ZP_VAR_R
        
        lda ZP_POLYOBJ_M0x1_HI
        ldx # $03
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_M0x2_HI
        and # %01111111
        jsr _39ea
        sta ZP_VAR_R
        
        lda ZP_POLYOBJ_M0x2_HI
        ldx # $06
        jsr .move_polyobj_x_small
        lda ZP_POLYOBJ_VERTX_LO
        clc 
        adc ZP_POLYOBJ_VERTX_HI
        bpl :+
        lda # $00
:       ldy # Hull::speed       ;=$0F                                   ;$A30D
        cmp [ZP_HULL_ADDR], y
        bcc :+
        lda [ZP_HULL_ADDR], y
:       sta ZP_POLYOBJ_VERTX_LO                                         ;$A315

        lda # $00
        sta ZP_POLYOBJ_VERTX_HI
        
        ldx ZP_ROLL_MAGNITUDE

        lda ZP_POLYOBJ_XPOS_LO
        eor # %11111111
        sta ZP_VAR_P1
        
        lda ZP_POLYOBJ_XPOS_MI
        jsr _3a25
        sta ZP_VAR_P3
        
        lda ZP_6A               ; move count?
        eor ZP_POLYOBJ_XPOS_HI
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
        sta ZP_POLYOBJ_ZPOS_HI
        
        lda ZP_VAR_P2
        sta ZP_POLYOBJ_ZPOS_LO
        eor # %11111111
        sta ZP_VAR_P1
        
        lda ZP_VAR_P3
        sta ZP_POLYOBJ_ZPOS_MI
        
        jsr _3a27
        sta ZP_VAR_P3
        
        lda ZP_B5
        sta ZP_POLYOBJ_YPOS_HI
        eor ZP_PITCH_SIGN
        eor ZP_POLYOBJ_ZPOS_HI
        bpl :+
        
        lda ZP_VAR_P2
        adc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO
        
        lda ZP_VAR_P3
        adc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI
        
        jmp _a39d

:       lda ZP_B3                                                       ;$A37D
        sbc ZP_VAR_P2
        sta ZP_POLYOBJ_YPOS_LO
        lda ZP_B4
        sbc ZP_VAR_P3
        sta ZP_POLYOBJ_YPOS_MI
        bcs _a39d
        lda # $01
        sbc ZP_POLYOBJ_YPOS_LO
        sta ZP_POLYOBJ_YPOS_LO
        lda # $00
        sbc ZP_POLYOBJ_YPOS_MI
        sta ZP_POLYOBJ_YPOS_MI
        lda ZP_POLYOBJ_YPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_YPOS_HI
_a39d:                                                                  ;$A39D
        ldx ZP_ROLL_MAGNITUDE
        lda ZP_POLYOBJ_YPOS_LO
        eor # %11111111
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_YPOS_MI
        jsr _3a25
        sta ZP_VAR_P3
        lda ZP_ROLL_SIGN        ; roll sign?
        eor ZP_POLYOBJ_YPOS_HI
        ldx # $00
        jsr _a508
        sta ZP_POLYOBJ_XPOS_HI
        lda ZP_VAR_P3
        sta ZP_POLYOBJ_XPOS_MI
        lda ZP_VAR_P2
        sta ZP_POLYOBJ_XPOS_LO
_a3bf:                                                                  ;$A3BF
        lda PLAYER_SPEED
        sta ZP_VAR_R

        lda # $80
        ldx # $06
        jsr move_polyobj_x
        
        lda ZP_A5
        and # %10000001
        cmp # $81
        bne :+
        
        rts 

        ;-----------------------------------------------------------------------
        ; apply the roll & pitch rotation to the poly-object's compound matrix.
        ; this creates a single matrix that can apply both roll & pitch to the
        ; verticies in one operation, i.e. we do not have to calculate roll &
        ; pitch separately for each vertex point in the shape
        ;
:       ldy # MATRIX_ROW_0                                              ;$A3D3
        jsr rotate_polyobj_axis
        ldy # MATRIX_ROW_1
        jsr rotate_polyobj_axis
        ldy # MATRIX_ROW_2
        jsr rotate_polyobj_axis

        ; slowly dampen pitch rate toward zero:
        ;-----------------------------------------------------------------------
        ; separate out the pitch sign
        ; (positive / negative)
        ;
        lda ZP_POLYOBJ_PITCH    ; current pitch rate
        and # %10000000         ; isolate pitch sign
        sta ZP_B1               ; put aside sign
        
        ; TODO: we could use a register transfer instead of doing LDA again
        ; i.e. use `tay` to keep `ZP_POLYOBJ_PITCH` for next use

        ; get the pitch rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_POLYOBJ_PITCH
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
        sta ZP_POLYOBJ_PITCH    ; save back the pitch rate
        
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
:       lda ZP_POLYOBJ_ROLL     ; current roll rate                     ;$A40B
        and # %10000000         ; isolate roll sign
        sta ZP_B1               ; put aside sign
        
        ; get the roll rate magnitude
        ; (the "absolute" value, without sign)
        ;
        lda ZP_POLYOBJ_ROLL
        and # %01111111         ; isolate roll magnitude
        beq :+                  ; skip if roll is level (= %x0000000)

        cmp # %01111111         ; carry will be set if roll <= %x1111111,
        sbc # $00               ; and 1 will be subtracted instead of 0
        ora ZP_B1               ; add the sign back in
        sta ZP_POLYOBJ_ROLL     ; save back the roll rate

        ldx # $0f
        ldy # $15
        jsr _2dc5               ; move ship?
        ldx # $11
        ldy # $17
        jsr _2dc5               ; move ship?
        ldx # $13
        ldy # $19
        jsr _2dc5

:       lda ZP_POLYOBJ_VISIBILITY                                       ;$A434
        and # visibility::exploding | visibility::display
        bne :+
        lda ZP_POLYOBJ_VISIBILITY
        ora # visibility::scanner
        sta ZP_POLYOBJ_VISIBILITY
        jmp _b410

        ;-----------------------------------------------------------------------

:       lda ZP_POLYOBJ_VISIBILITY                                       ;$A443
        and # visibility::scanner ^$FF
        sta ZP_POLYOBJ_VISIBILITY
        rts 

;===============================================================================
; insert these routines from "math_3d.inc"
;
.move_polyobj_x                                                         ;$A44A
.rotate_polyobj_axis                                                    ;$A4A1

;===============================================================================

_a508:                                                                  ;$A508
        tay 
        eor ZP_POLYOBJ_XPOS_HI, x
        bmi _a51c
        lda ZP_VAR_P2
        clc 
        adc ZP_POLYOBJ_XPOS_LO, x
        sta ZP_VAR_P2
        lda ZP_VAR_P3
        adc ZP_POLYOBJ_XPOS_MI, x
        sta ZP_VAR_P3
        tya 
        rts 
        
        ;-----------------------------------------------------------------------

_a51c:                                                                  ;$A51C
        lda ZP_POLYOBJ_XPOS_LO, x
        sec 
        sbc ZP_VAR_P2
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_XPOS_MI, x
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

;===============================================================================

_a53d:                                                                  ;$A53D
        lda ZP_ALPHA
        eor # %10000000
        sta ZP_VAR_Q

        lda ZP_POLYOBJ_XPOS_LO
        sta ZP_VAR_P1
        
        lda ZP_POLYOBJ_XPOS_MI
        sta ZP_VAR_P2
        
        lda ZP_POLYOBJ_XPOS_HI
        jsr _38f8
        
        ldx # $03
        jsr _2d69
        
        lda ZP_VALUE_pt2
        sta ZP_B3
        sta ZP_VAR_P1
        
        lda ZP_VALUE_pt3
        sta ZP_B4
        sta ZP_VAR_P2
        
        lda $63
        sta ZP_VAR_Q
        
        lda ZP_VALUE_pt4
        sta ZP_B5
        
        jsr _38f8
        
        ldx # $06
        jsr _2d69
        
        lda ZP_VALUE_pt2
        sta ZP_VAR_P1
        sta ZP_POLYOBJ_ZPOS_LO
        
        lda ZP_VALUE_pt3
        sta ZP_VAR_P2
        sta ZP_POLYOBJ_ZPOS_MI
        
        lda ZP_VALUE_pt4
        sta ZP_POLYOBJ_ZPOS_HI
        eor # %10000000
        jsr _38f8
        
        lda ZP_VALUE_pt4
        and # %10000000
        sta ZP_VAR_T
        eor ZP_B5
        bmi _a5a8
        
        lda ZP_VALUE_pt1
        clc 
        adc ZP_B2
        
        lda ZP_VALUE_pt2
        adc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO
        
        lda ZP_VALUE_pt3
        adc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI
        
        lda ZP_VALUE_pt4
        adc ZP_B5
        
        jmp _a5db

_a5a8:                                                                  ;$A5A8
        lda ZP_VALUE_pt1
        sec 
        sbc ZP_B2
        lda ZP_VALUE_pt2
        sbc ZP_B3
        sta ZP_POLYOBJ_YPOS_LO
        lda ZP_VALUE_pt3
        sbc ZP_B4
        sta ZP_POLYOBJ_YPOS_MI
        lda ZP_B5
        and # %01111111
        sta ZP_VAR_P1
        lda ZP_VALUE_pt4
        and # %01111111
        sbc ZP_VAR_P1
        sta ZP_VAR_P1
        bcs _a5db
        lda # $01
        sbc ZP_POLYOBJ_YPOS_LO
        sta ZP_POLYOBJ_YPOS_LO
        lda # $00
        sbc ZP_POLYOBJ_YPOS_MI
        sta ZP_POLYOBJ_YPOS_MI
        lda # $00
        sbc ZP_VAR_P1
        ora # %10000000
_a5db:                                                                  ;$A5DB
        eor ZP_VAR_T
        sta ZP_POLYOBJ_YPOS_HI
        lda ZP_ALPHA
        sta ZP_VAR_Q
        lda ZP_POLYOBJ_YPOS_LO
        sta ZP_VAR_P1
        lda ZP_POLYOBJ_YPOS_MI
        sta ZP_VAR_P2
        lda ZP_POLYOBJ_YPOS_HI
        jsr _38f8
        ldx # $00
        jsr _2d69
        lda ZP_VALUE_pt2
        sta ZP_POLYOBJ_XPOS_LO
        lda ZP_VALUE_pt3
        sta ZP_POLYOBJ_XPOS_MI
        lda ZP_VALUE_pt4
        sta ZP_POLYOBJ_XPOS_HI
        jmp _a3bf

;===============================================================================

; what calls in to this, where?

_a604:                                                                  ;$A604
        sec 
        ldy # $00
        sty ZP_TEMP_ADDR3_LO
        ldx # $10
        lda [ZP_TEMP_ADDR1], y
        txa 
_a60e:                                                                  ;$A60E
        stx ZP_TEMP_ADDR3_HI
        sty ZP_VAR_T
        adc [ZP_TEMP_ADDR3], y
        eor ZP_VAR_T
        sbc ZP_TEMP_ADDR3_HI
        dey 
        bne _a60e
        inx 
        cpx # $a0
        bcc _a60e
        cmp _1d21
        bne _a604

        rts 

;===============================================================================

_a626:                                                                  ;$A626
.export _a626
        ldx VAR_0486
        beq _a65e
        dex 
        bne _a65f
        lda ZP_POLYOBJ_XPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_XPOS_HI
        lda ZP_POLYOBJ_ZPOS_HI
        eor # %10000000
        sta ZP_POLYOBJ_ZPOS_HI
        lda ZP_POLYOBJ_M0x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M0x0_HI
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M0x2_HI
        lda ZP_POLYOBJ_M1x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M1x0_HI
        lda ZP_POLYOBJ_M1x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M1x2_HI
        lda ZP_POLYOBJ_M2x0_HI
        eor # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        lda ZP_POLYOBJ_M2x2_HI
        eor # %10000000
        sta ZP_POLYOBJ_M2x2_HI
_a65e:                                                                  ;$A65E
        rts 

        ;-----------------------------------------------------------------------

_a65f:                                                                  ;$A65F
        lda # $00
        cpx # $02
        ror 
        sta ZP_B1
        eor # %10000000
        sta ZP_B0
        lda ZP_POLYOBJ_XPOS_LO
        ldx ZP_POLYOBJ_ZPOS_LO
        sta ZP_POLYOBJ_ZPOS_LO
        stx ZP_POLYOBJ_XPOS_LO
        lda ZP_POLYOBJ_XPOS_MI
        ldx ZP_POLYOBJ_ZPOS_MI
        sta ZP_POLYOBJ_ZPOS_MI
        stx ZP_POLYOBJ_XPOS_MI
        lda ZP_POLYOBJ_XPOS_HI
        eor ZP_B0
        tax 
        lda ZP_POLYOBJ_ZPOS_HI
        eor ZP_B1
        sta ZP_POLYOBJ_XPOS_HI
        stx ZP_POLYOBJ_ZPOS_HI
        ldy # $09
        jsr _a693
        ldy # $0f
        jsr _a693
        ldy # $15
_a693:                                                                  ;$A693
        lda ZP_POLYOBJ_XPOS_LO, y
        ldx ZP_POLYOBJ_YPOS_MI, y
        sta ZP_POLYOBJ_YPOS_MI, y
        stx ZP_POLYOBJ_XPOS_LO, y
        lda ZP_POLYOBJ_XPOS_MI, y
        eor ZP_B0
        tax 
        lda ZP_POLYOBJ_YPOS_HI, y
        eor ZP_B1
        sta ZP_POLYOBJ_XPOS_MI, y
        stx ZP_POLYOBJ_YPOS_HI, y
_a6ad:                                                                  ;$A6AD
        rts 

;===============================================================================

_a6ae:                                                                  ;$A6AE
        stx VAR_0486
        jsr set_page
        jsr _a6d4
        jmp _7af3

;===============================================================================
; set cockpit view (front / rear / left / right)
;
;       X = $00 = front
;           $01 = rear
;           $02 = left
;           $03 = right
;
_a6ba:                                                                  ;$A6BA
        lda # $00

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _6a2e               ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ldy ZP_SCREEN
        bne _a6ae
        
        cpx VAR_0486
        beq _a6ad
        stx VAR_0486
        
        jsr set_page
        jsr dust_swap_xy
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

        ldy VAR_0486            ; current viewpoint? (front, rear, left, right)
        lda PLAYER_LASERS, y    ; get type of laser for current viewpoint
        beq _a700               ; no laser? skip ahead

        ; the index of the first sprite is entirely dependent on where
        ; sprites are located in the selected VIC bank; see "elite.inc"
        ; for where this value is defined
        ldy # ELITE_SPRITES_INDEX
        cmp # $0f               ; a type of laser?
        beq :+
        iny                     ; select next sprite index
        cmp # $8f               ; a type of laser?
        beq :+
        iny                     ; select next sprite index
        cmp # $97               ; a type of laser?
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
.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_T

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
        ora ZP_VAR_T            ; other sprites mask?
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

.ifndef OPTION_NOTRUMBLES
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

;===============================================================================
; switch screen page?
;
;       A = page to switch to; e.g. cockpit-view, galactic chart &c.
;
set_page:                                                               ;$A72F

.export set_page

        sta ZP_SCREEN
_a731:                                                                  ;$A731
        jsr txt_docked_token02

        lda # $00
        sta ZP_7E               ; "arc counter"?
        
        lda # %10000000
        sta ZP_34
        sta txt_lcase_flag

        jsr _7b4f

        lda # $00
        sta VAR_0484
        sta VAR_048B
        sta VAR_048C
        
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        jsr _b21a               ; clear screen -- called only here
        
        ; display hyperspace countdown in the menu screens?

        ldx ZP_66               ; hyperspace countdown (outer)?
        beq _a75d

        jsr _7224

_a75d:                                                                  ;$A75D
        lda # 1
        jsr set_cursor_row
        
        ; are we in the cockpit-view?
        lda ZP_SCREEN
        bne :+
        
        lda # 11
        jsr set_cursor_col

        lda VAR_0486
        ora # %01100000
        jsr print_flight_token
        jsr print_space

.import TXT_VIEW:direct

        lda # TXT_VIEW
        jsr print_flight_token

:       ldx # 1                                                         ;$A77B
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW

        dex 
        stx ZP_34

.ifdef  OPTION_ORIGINAL
        rts 
.endif

;===============================================================================

_a785:                                                                  ;$A785
        rts 

_a786:                                                                  ;$A786
.export _a786
        lda # $00
        sta ZP_67
        sta VAR_0481
        
        jsr _b0fd
        ldy # $09
        jmp _a822

;===============================================================================

_a795:                                                                  ;$A795
.export _a795
        ldx # $01
        jsr _3708
        bcc _a785
        lda # $78
        jsr _900d
        ldy # $04
        jmp _a858

_a7a6:                                                                  ;$A7A6
;===============================================================================
; kill a PolyObject?
;
.export _a7a6
        lda VAR_04CB
        clc 
        adc hull_d062, x
        sta VAR_04CB
        
        ; add fractional kill value?
        lda VAR_04E0
        adc hull_d083, x
        sta VAR_04E0
        
        bcc _a7c3               ; < 1.0

        inc PLAYER_KILLS        ; +1
        
        lda # $65
        jsr _900d
_a7c3:                                                                  ;$A7C3
        lda ZP_POLYOBJ_ZPOS_MI
        ldx # $0b
        cmp # $10
        bcs _a7db
        inx 
        cmp # $08
        bcs _a7db
        inx 
        cmp # $06
        bcs _a7db
        inx 
        cmp # $03
        bcs _a7db
        inx 
_a7db:                                                                  ;$A7DB
        txa 
        asl 
        asl 
        asl 
        asl 
        ora # %00000011
        ldy # $03
        ldx # $51
        jmp _a850

;===============================================================================

_a7e9:                                                                  ;$A7E9
.export _a7e9
        lda ZP_POLYOBJ_ZPOS_MI
        ldx # $0b
        cmp # $08
        bcs _a801
        inx 
        cmp # $04
        bcs _a801
        inx 
        cmp # $03
        bcs _a801
        inx 
        cmp # $02
        bcs _a801
        inx 
_a801:                                                                  ;$A801
        txa 
        asl 
        asl 
        asl 
        asl 
        ora # %00000011
        ldy # $02
        ldx # $d0
        jmp _a850


_a80f:                                                                  ;$A80F
;===============================================================================
.export _a80f
        ldy # $05
        bne _a858               ; always branches

_a813:                                                                  ;$A813
;===============================================================================
.export _a813
        ldy # $03
        bne _a858               ; always branches

_a817:                                                                  ;$A817
;===============================================================================
        ldy # $03
        lda # $01

:       sta _aa15, y                                                    ;$A81B
        dey 
        bne :-
_a821:                                                                  ;$A821
        rts 

;===============================================================================

_a822:                                                                  ;$A822
        ldx # $03
        iny 
        sty ZP_VAR_X2
_a827:                                                                  ;$A827
        dex 
        bmi _a821
        lda _aa13, x
        and # %00111111
        cmp ZP_VAR_X2
        bne _a827
        lda # $01
        sta _aa16, x
        rts 


_a839:                                                                  ;$A839
;===============================================================================
; called only by `_3795`
;
.export _a839

        ldy # $07
        lda # $f5
        ldx # $f0
        jsr _a850

        ldy # $04
        jsr _a858

        ; wait until the next frame:
        ; SPEED: could just call `wait_for_frame` instead
        ldy # 1
        jsr wait_frames

        ldy # $87
        bne _a858               ; awlays branches

;===============================================================================
;       A = X1
;       X = Y1
;       Y = ?
;
_a850:                                                                  ;$A850
        bit _a821               ; an unused skip?

        sta ZP_VAR_X1
        stx ZP_VAR_Y1
        ; this causes the `clv` below to become a `branch on overflow clear`
        ; to $A811 -- the address is defined by the opcode of `clv` ($B8)
.ifdef  OPTION_ORIGINAL
        .byte   $50
.else
        .byte   $a5             ; lda ZP
.endif

_a858:                                                                  ;$A858
;       Y = $00-$0F?
.export _a858
        clv 
        
        ; do nothing if an option is set?
        lda _1d05
        bne _a821               ; `rts`

        ldx # $02
        iny                     ; use Y 1-based
        sty ZP_VAR_X2
        dey                     ; return to 0-based for the lookup
        lda _aa32, y
        lsr                     ; check bit 1 by pushing it off
        bcs @_a876              ; did the bit fall into the carry?

:       lda _aa13, x                                                    ;$A86A
        and # %00111111
        cmp ZP_VAR_X2
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
        lda ZP_VAR_X
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
        lda ZP_VAR_Y
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

;===============================================================================

_a8d9:                                                                  ;$A8D9
        .byte   $00

; these are VIC_MEMORY states
_a8da:                                                                  ;$A8DA
        .byte   vic_memory::screen_2000 | vic_memory::unused
_a8db:                                                                  ;$A8DB
        .byte   vic_memory::screen_2000 | vic_memory::unused

; this is a toggle for `_a8d9`
_a8dc:                                                                  ;$A8DC
        .byte   $01, $00

; these are VIC_RASTER values
_a8de:                                                                  ;$A8DE
        ; top of screen, plus height of viewport
        .byte   51 + ELITE_VIEWPORT_HEIGHT-1
        ; scanline 51, 2nd pixel row in screen
        ; i.e. changes after the yellow border at the top
        .byte   51

; these are VIC_SCREEN_CTL2 states
_a8e0:                                                                  ;$A8E0
.export _a8e0
        .byte   %11000000
_a8e1:                                                                  ;$A8E1
        .byte   %11000000

; these are VIC_SPRITE_MULTICOLOR states
_a8e2:                                                                  ;$A8E2
        .byte   %11111110, %11111100

; these are VIC_SPRITE1_COLOR states
_a8e4:                                                                  ;$A8E4
        .byte   RED, BLACK
_a8e6:                                                                  ;$A8E6
.export _a8e6
        .byte   $00, $00

; e-bomb explosion?
;
_a8e8:                                                                  ;$A8E8
        ;-----------------------------------------------------------------------
        dey 
        bpl _a958
        pla 
        tay 

interrupt_end_XA:                                                       ;$A8ED
        ;=======================================================================
        ; interrupt finished! restores X & A.
        ;
       .plx                     ; restore X

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla 
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL
        
        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================
; this is Elite's main interrupt routine
;
interrupt:                                                              ;$A8FA

        pha                     ; preserve A
        
        ; the current memory map (BASIC, KERNAL, and/or I/O) could be anything
        ; when this interrupt occurs; for the purposes of the interrupt routine
        ; we want to have the ROMs off and I/O on
        ;
        ; in the original Elite code, changing the memory map is handled by
        ; a central routine `set_memory_layout` which keeps a record of the
        ; "current" state. assuming that this routine is *always* used when
        ; changing the memory map, the interrupt routine can restore the
        ; previous state
        ;
        lda CPU_CONTROL         ; read current memory map

.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless, we use an optimisation technique described by
        ; Gregory Naçu in his article "The 6510 Processor Port":
        ; <http://www.c64os.com/post?p=83>
        ;
        ; this method removes the need to store extra state, doesn't require
        ; an expensive subroutine and doesn't even use any registers(!) but
        ; it does mean we have to be very, very careful that before we change
        ; it, the memory map is guaranteed to be an expected value every time
        ; (otherwise the machine usually crashes hard)
        ;
        ; the interrupt routine complicates this as we cannot guarantee that
        ; the memory map will be a certain value any time the interrupt occurs.
        ; nested interrupts (when an interrupt interrupts an interrupt) need to
        ; be handled too, so whilst the original code 'knows' what memory map
        ; to return to, elite-harmless pushes the current value to the stack
        ; during the interrupt. whilst this adds 3 cycles to the initialisation
        ; it does greatly reduce the cleanup at the end -- a simple pull and
        ; set (7 cycles) does everything, without needing to `lda, and, ora`
        ; first and then set (12 cycles)
        ; 
        pha                     ; push current memory-map value on stack
.endif  ;///////////////////////////////////////////////////////////////////////
        and # %11111000         ; mask out current value in the memory map bits
        ora # C64_MEM::IO_ONLY  ; set I/O on, ROMs off
        sta CPU_CONTROL         ; make it so!

        ; acknowledge the interrupt?
        lda VIC_INTERRUPT_STATUS
        ora # %10000000
        sta VIC_INTERRUPT_STATUS
        
       .phx                     ; push X to stack (via A)
        
        ldx _a8d9

        ; flicker the VIC memory map!?
        ; the two values are the same, so this does nothing in practice
        ;
        lda _a8da, x
        sta VIC_MEMORY

        lda _a8e0, x
        sta VIC_SCREEN_CTL2

        lda _a8de, x
        sta VIC_RASTER
        
        lda _a8e2, x
        sta VIC_SPRITE_MULTICOLOR
        
        lda _a8e4, x
        sta VIC_SPRITE1_COLOR
        
        ; flash screen with e-bomb explosion?
        bit PLAYER_EBOMB
        bpl :+
        inc _a8e6
:       lda _a8e6, x                                                    ;$A936
        sta VIC_BACKGROUND

        ; toggle frame index (0 & 1)?
        lda _a8dc, x
        sta _a8d9

        ; just exit every other frame
        ; (this is the short routine above this one)
       .bnz interrupt_end_XA

        ; push Y to stack (via A).
        ; from this point we must restore Y before ending the interrupt,
        ; so a different exit point is used than the one above
       .phy

        bit _1d03               ; if this option,
        bpl _a956               ; is off, skip ahead

        jsr _b4d2               ; handle music?

        bit _1d12               ; sound effects enabled?
        bmi _a956               ; yes, do SFX
        
        jmp interrupt_end_YXA

_a956:                                                                  ;$A956
        ldy # $02
_a958:                                                                  ;$A958
        lda _aa13, y
        beq _a8e8
        bmi _a969

        ldx _aa2f, y
        lda _aa1d, y
        beq _a9ae
        bne _a990
_a969:                                                                  ;$A969
        lda _aa2f, y
        sta _a973+1             ;low-byte, i.e. $d4xx
        lda # $00
        ldx # $06
_a973:                                                                  ;$A973
        sta SID_VOICE1, x
        dex 
        bpl _a973
        ldx _aa2f, y
        lda _aa23, y
        sta SID_VOICE1_CTRL, x
        lda _aa26, y
        sta SID_VOICE1_ATKDCY, x
        lda _aa29, y
        sta SID_VOICE1_SUSREL, x
        lda # $00
_a990:                                                                  ;$A990
        clc 
        cld 
        adc _aa20, y
        sta _aa20, y
        pha 
        lsr 
        lsr 
        sta SID_VOICE1_FREQ_HI, x
        pla 
        asl 
        asl 
        asl 
        asl 
        asl 
        asl 
        sta SID_VOICE1_FREQ_LO, x
        lda _aa1c
        sta SID_VOICE1_PULSE_HI, x
_a9ae:                                                                  ;$A9AE
        lda _aa13, y
        bmi _a9f1
        tya 
        tax 
        dec _aa19, x
        bne _a9bd
        inc _aa19, x
_a9bd:                                                                  ;$A9BD
        dec _aa16, x
        beq _a9dc
        lda _aa16, x
        and _aa2c, y
        bne _a9f6
        lda _aa29, y
        sec 
        sbc # $10
        sta _aa29, y
        ldx _aa2f, y
        sta SID_VOICE1_SUSREL, x
        jmp _a9f6

_a9dc:                                                                  ;$A9DC
        ldx _aa2f, y
        lda _aa23, y
        and # %11111110
        sta SID_VOICE1_CTRL, x
        lda # $00
        sta _aa13, y
        sta _aa19, y
        beq _a9f6
_a9f1:                                                                  ;$A9F1
        and # %01111111
        sta _aa13, y
_a9f6:                                                                  ;$A9F6
        dey 
        bmi _a9fc
        jmp _a958

_a9fc:                                                                  ;$A9FC
        lda _aa1c
        eor # %00000100
        sta _aa1c

interrupt_end_YXA:                                                      ;$AA04
        ;-----------------------------------------------------------------------
       .ply                     ; restore Y
       .plx                     ; restore X

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla 
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================

_aa13:                                                                  ;$AA13
        .byte   $00, $00
_aa15:                                                                  ;$AA15
        .byte   $00
_aa16:                                                                  ;$AA16
        .byte   $00, $00, $00
_aa19:                                                                  ;$AA19
        .byte   $00
_aa1a:                                                                  ;$AA1A
        .byte   $00
_aa1b:                                                                  ;$AA1B
        .byte   $00
_aa1c:                                                                  ;$AA1C
        .byte   $02
_aa1d:                                                                  ;$AA1D
        .byte   $00, $00, $00
_aa20:                                                                  ;$AA20
        .byte   $00, $00, $00
_aa23:                                                                  ;$AA23
        .byte   $00, $00, $00
_aa26:                                                                  ;$AA26
        .byte   $00, $00, $00
_aa29:                                                                  ;$AA29
        .byte   $00, $00, $00
_aa2c:                                                                  ;$AA2C
        .byte   $00, $00, $00
_aa2f:                                                                  ;$AA2F
        .byte   $00, $07, $0e
_aa32:                                                                  ;$AA32
        .byte   $72, $70, $74, $77, $73, $68, $60, $f0
        .byte   $30, $fe, $72, $72, $92, $e1, $51, $02
_aa42:                                                                  ;$AA42
        .byte   $14, $0e, $0c, $50, $3f, $05, $18, $80
        .byte   $30, $ff, $10, $10, $70, $40, $0f, $0e
_aa52:                                                                  ;$AA52
        .byte   $45, $48, $d0, $51, $40, $f0, $40, $80
        .byte   $10, $50, $34, $33, $60, $55, $80, $40
_aa62:                                                                  ;$AA62
        .byte   $41, $11, $81, $81, $81, $11, $11, $41
        .byte   $21, $41, $21, $21, $11, $81, $11, $21
_aa72:                                                                  ;$AA72
        .byte   $01, $09, $20, $08, $0c, $00, $63, $18
        .byte   $44, $11, $00, $00, $44, $11, $18, $09
_aa82:                                                                  ;$AA82
        .byte   $d1, $f1, $e5, $fb, $dc, $f0, $f3, $d8
        .byte   $00, $e1, $e1, $f1, $f4, $e3, $b0, $a1
_aa92:                                                                  ;$AA92
        .byte   $fe, $fe, $f3, $ff, $00, $00, $00, $44
        .byte   $00, $55, $fe, $ff, $ef, $77, $7b, $fe
_aaa2:                                                                  ;$AAA2
        .byte   $03, $03, $03, $0f, $0f, $ff, $ff, $1f
        .byte   $ff, $ff, $03, $03, $0f, $ff, $ff, $03


; CALL FROM LOADER; this is the first thing called after initialisation

.export init_mem
.proc   init_mem                                                        ;$AAB2
        ;=======================================================================
        ; clear the main variable space
        ;
.import __VARS_0400_RUN__       ; runtime location
.import __VARS_0400_SIZE__      ; and length

        lda #> __VARS_0400_RUN__
        sta ZP_TEMP_ADDR1_HI

        ; number of whole pages to copy
        ldx #< .page_count(__VARS_0400_SIZE__)

        lda #< __VARS_0400_RUN__ 
        sta ZP_TEMP_ADDR1_LO
        tay                     ; =0

:       sta [ZP_TEMP_ADDR1], y                                          ;$AABD
        iny 
        bne :-

        inc ZP_TEMP_ADDR1_HI     ; move to the next page
        dex 
        bne :-

        ;-----------------------------------------------------------------------
        ; set non-maskable interrupt location when the KERNAL is on.
        ; pressing the RESTORE key will fire this routine
        ;
        ; note that when the KERNAL is switched off, the RAM underneath will
        ; define the NMI interrupt address -- this gets rectified further down
        ;
        lda #< nmi_null
        sta KERNAL_VECTOR_NMI+0
        lda #> nmi_null
        sta KERNAL_VECTOR_NMI+1
        
        ; set new KERNAL_CHROUT (print character) routine
        ; -- re-route printing to the bitmap screen
        ;
        lda #< chrout
        sta KERNAL_VECTOR_CHROUT+0
        lda #> chrout
        sta KERNAL_VECTOR_CHROUT+1

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; change the C64's memory layout, turn off the BASIC & KERNAL ROMs
        ; leaving just the I/O registers ($D000...)
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the KERNAL is currently on, so stepping down
        ; once will switch from KERNAL+I/O to I/O only
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        sei                     ; disable interrupts

        ; configure interrupts (regular and non-interruptable)
        ; for system timers A & B -- do not use the TimeOfDay timer
        ;
        lda # CIA::TIMER_A | CIA::TIMER_B
        sta CIA1_INTERRUPT
        sta CIA2_INTERRUPT
        
        ; configure SID chip
        ;
        lda # 15                ; max volume, filters off 
        sta SID_VOLUME_CTRL
        
        ; frame indicator?
        ldx # $00
        stx _a8d9

        ; set the flag for raster interrupts, but note that with CIA1 & 2
        ; interrupts currently enabled, the raster interrupt won't fire
        inx 
        stx VIC_INTERRUPT_CONTROL
        
        ; the 9th bit (for scanlines 256-312) of the raster line register 
        ; is held in the MSB of $D011. in Elite's case our raster-splits
        ; all occur before 256 so this bit just needs to be zero
        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1
        
        ; set the interrupt to occur at line 40.
        ; this is above the top screen border (~50)
        lda # 40
        sta VIC_RASTER
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; switch off the ROMs, leaving 64K of RAM
        lda CPU_CONTROL
        and # %11111000
        ora # C64_MEM::ALL
        sta CPU_CONTROL
        
        ; record this as the game's
        ; current memory-layout state
        lda # C64_MEM::ALL
        sta current_memory_layout
        
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the I/O shield is currently on so stepping down
        ; once will turn I/O off leaving 64K of RAM
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////
        
        ; set up the routines for the interrupts:
        ;
        ; NOTE: with the KERNAL ROM off, the hardware vectors at $FFFA...$FFFF
        ;       are now being defined by empty RAM -- we need to set something
        ;       there to prevent crashes when KERNAL ROM is off 

        ; non-maskable interrupt:
        lda #< nmi_null
        sta HW_VECTOR_NMI+0
        lda #> nmi_null
        sta HW_VECTOR_NMI+1

        ; regular interrupt:
        lda #> interrupt
        sta HW_VECTOR_IRQ+1
        lda #< interrupt
        sta HW_VECTOR_IRQ+0
        
        cli                     ; enable interrupts
        rts 
.endproc

.proc   nmi_null                                                        ;$AB27
        ;=======================================================================
        ; a Non-Maskable-Interrupt that does nothing; used to disable the
        ; RESTORE key and to prevent crashes when the KERNAL ROM is off
        ;
        cli                     ; re-enable interrupts
        rti                     ; "ReTurn from Interrupt"
.endproc

;===============================================================================

; unused / unreferenced?
; $ab29:
        lda # $ff
        sta ZP_32
        rts 

;===============================================================================

; unused / unreferenced?
; $ab2e:
        sta ZP_32
        rts 

;===============================================================================
; from "draw_lines.inc" insert the line-drawing code
;
.draw_lines                                                             ;$AB31

.ifdef  OPTION_DYME_FASTLINE
;///////////////////////////////////////////////////////////////////////////////
.hline_draw
.vline_draw
;///////////////////////////////////////////////////////////////////////////////
.endif


_b09d:                                                                  ;$B09DB
;===============================================================================
; plot a multi-color pixel
;
;       VAR_04EB        = Y position, in view-port pixels (0-255). adjusted
;                         automatically to nearest multi-color pixel (0-127)
;       VAR_04EA        = X position, in view-port pixels
;       _1d01           = colour-mask
;
        lda VAR_04EB
        sta ZP_VAR_Y

        lda VAR_04EA
        sta ZP_VAR_X
        
        lda _1d01
        sta ZP_32
        cmp # %10101010
        bne _b0b5

_b0b0:                                                                  ;$B0B0
        ;-----------------------------------------------------------------------
        ; draws two multi-color pixels, one atop the other
        ;
        jsr _b0b5                       ; draw first multi-color pixel
        dec ZP_VAR_Y                    ; move up one pixel and draw again

_b0b5:                                                                  ;$B0B5
        ;-----------------------------------------------------------------------
        ; get bitmap address from X & Y co-ords
        ;
        ldy ZP_VAR_Y
        lda ZP_VAR_X                    ; X-position, in pixels
        and # %11111000                 ; clip X to a char-cell
        clc 
        adc row_to_bitmap_lo, y         ; add X to the bitmap address by row
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, y
        adc # $00
        sta ZP_TEMP_ADDR1_HI
        
        ; let Y be the row within the char-cell (0-7)
        tya 
        and # %00000111
        tay 
        
        ; let X be the column within the char-cell (0-7)
        lda ZP_VAR_X
        and # %00000111
        tax 

        ; multi-colour pixels are made from pairs of pixels. this lookup
        ; translates a pixel from 0-7 to the nearest multi-colour pixel
        ; e.g.
        ;
        ;       %10------ & %01------ = %11000000
        ;       %--10---- & %--01---- = %00110000
        ;       %----10-- & %----01-- = %00001100
        ;       %------10 & %------01 = %00000011
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
        and ZP_32                       ; set colour, i.e. %11, %10, %01, %00
        eor [ZP_TEMP_ADDR1], y          ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y          ; update the screen
        
        lda _ab49, x                    ; look ahead to the next pixel
        bpl @_b0ed
        
        lda ZP_TEMP_ADDR1_LO
        clc 
        adc # $08
        sta ZP_TEMP_ADDR1_LO
        bcc :+
        inc ZP_TEMP_ADDR1_HI
:       lda _ab49, x                                                    ;$B0EA

@_b0ed:                                                                 ;$B0ED
        and ZP_32                       ; apply the colour-mask to the pixel
        eor [ZP_TEMP_ADDR1], y          ; mask new pixel against existing ones
        sta [ZP_TEMP_ADDR1], y          ; update the screen
        rts 

;===============================================================================

_b0f4:                                                                  ;$B0F4
.export _b0f4
        lda # $20
        sta ZP_67
        ldy # $09
        jsr _a858
_b0fd:                                                                  ;$B0FD
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 11 )      ;=$67A3
        
        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 11 )      ;=$67CB
        
        rts 

;===============================================================================

_b10e:                                                                  ;$B10E
        lda ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 23, 28 )      ;=$67B4

        lda ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC
        eor # %11100000
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 28 )      ;=$67DC

        rts 

;===============================================================================
; "draw missile block"
;
_b11f:                                                                  ;$B11F
.export _b11f
        dex 
        txa 
        inx 
        eor # %00000011
        sty ZP_TEMP_ADDR1_LO
        tay 
        lda ZP_TEMP_ADDR1_LO
        sta ELITE_MAINSCR_ADDR + .scrpos( 24, 6 ), y    ;=$67C6
        ldy # $00

        rts 

;===============================================================================

; unused / unreferenced?
;$b12f:
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
        ;=======================================================================
        ; I think this function waits for a frame to complete
        ;
.export wait_for_frame

        pha                     ; preserve A

        ; wait for non-zero in the frame status?
:       lda _a8d9                                                       ;$B149
        beq :-
        ; and then wait for it to return to zero?
:       lda _a8d9                                                       ;$B14E
        bne :-

        pla                     ; restore A 
        rts 


;===============================================================================
; print a charcter to the bitmap screen
;
; replaces the KERNAL's `CHROUT` routine for printing text to screen
; (since Elite uses only the bitmap screen)
;
; IMPORTANT NOTE: Elite stores its text in ASCII, not PETSCII!
; this is due to the data being copied over as-is from the BBC
;
;       A = ASCII code of character to print
;
chrout:                                                                 ;$B155

        cmp # $7b               ; is code greater than or equal to $7B?
        bcs :+                  ; if yes, skip it
        cmp # $0d               ; is code less than $0D? (RETURN)
        bcc :+                  ; if yes, skip it
        bne paint_char          ; if it's not RETURN, process it

        ; handle the RETURN code
        lda # TXT_NEWLINE
        jsr paint_char

        lda # $0d
:       clc                     ; clear carry flag before returning     ;$B166 
        rts 

;define the use of some zero-page variables for this routine
.exportzp       ZP_CHROUT_CHARADDR      := $2f  ; $2F/$30
.exportzp       ZP_CHROUT_DRAWADDR      := $07  ; $07/$08
.exportzp       ZP_CHROUT_DRAWADDR_LO   := $07
.exportzp       ZP_CHROUT_DRAWADDR_HI   := $08

_b168:                                                                  ;$B168
        jsr _a80f               ; BEEP?
        jmp _b210               ; restore state and exit

        ;-----------------------------------------------------------------------

_b16e:                                                                  ;$B16E
        jsr _b384
        lda ZP_POLYOBJ01_XPOS_pt1
        jmp _b189

        ;-----------------------------------------------------------------------

        ; this is a trampoline to account for a branch range limitation below
        ; TODO: this could be combined with the one at `_b168` to save 3 bytes
        ;
_b176:  jmp _b210                                                       ;B176

paint_newline:                                                          ;$B179
        ;-----------------------------------------------------------------------
        ; NOTE: called only ever by `_2c7d`!
        ;
.export paint_newline

        lda # TXT_NEWLINE

paint_char:                                                             ;$B17B
;===============================================================================
; draws a character on the bitmap screen as if it were the text screen
; (automatically advances the cursor)
;
.export paint_char

        ; store current registers
        ; (compatibility with KERNAL_CHROUT?)
        sta ZP_POLYOBJ01_XPOS_pt1
        sty VAR_0490
        stx VAR_048F

        ; cancel if text reaches a certain point?
        ; prevent off-screen writing?
        ldy ZP_34
        cpy # $ff
        beq _b176
_b189:                                                                  ;$B189
        cmp # $07               ; code $07? (unspecified in PETSCII)
        beq _b168
        cmp # $20               ; is it SPC or above? (i.e. printable)
        bcs _b1a1
        cmp # $0a               ; is it $0A? (unspecified in PETSCII)
        beq _b199
_b195:                                                                  ;$B195
        ; start at column 2, i.e. leave a one-char padding from the viewport
        ldx # 1
        stx ZP_CURSOR_COL
_b199:                                                                  ;$B199
        cmp # $0d               ; is it RETURN? although note that `chrout`
                                ; replaces $0D codes with $0C
        beq _b176

        inc ZP_CURSOR_ROW
        bne _b176

_b1a1:                                                                  ;$B1A1
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
        ; SPEED: this causes the character address to
        ;        have to be recalculated again!
        lda ZP_CURSOR_COL
        cmp # 31                ; max width of line? (32 chars = 256 px)
        bcs _b195               ; reach the end of the line, carriage-return!
        
        lda # $80
        sta ZP_CHROUT_DRAWADDR_LO
        
        lda ZP_CURSOR_ROW
        cmp # 24
        bcc :+
        
        ; SPEED: just copy that code here, or change the branch above to go
        ;        to `_b16e` and favour falling through for the majority case
        jmp _b16e

        ;-----------------------------------------------------------------------

        ; calculate the size of the offset needed for bitmap rows
        ; (320 bytes each). note that A is the current `chrout` row

        ; SPEED: this whole thing could seriously do with a lookup table

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
        
        ldy # $f8
        jsr erase_page_to_end
        beq _b210

:       inc ZP_CURSOR_COL                                               ;$B1ED
        ; this is `sta ZP_TEMP_ADDR1_HI` if you jump in after the `bit`
        ; instruction, but it doesn't look like this actually occurs
       .bit
        sta ZP_TEMP_ADDR1_HI

        ; paint the character (8-bytes) to the screen
        ; SPEED: this could be unrolled

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
        lda ZP_POLYOBJ01_XPOS_pt1

        clc 
        rts 

;===============================================================================
; clear screen
;
_b21a:                                                                  ;$B21A
        ; set starting position in top-left of the centred
        ; 32-char (256px) screen Elite uses
        lda #< (ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ))
        sta ZP_TEMP_ADDR1_LO
        lda #> (ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ))
        sta ZP_TEMP_ADDR1_HI

        ldx # 24                        ; colour 24 rows

@row:   lda # .color_nybble( WHITE, BLACK )                            ;$B224
        ldy # ELITE_VIEWPORT_COLS-1     ; 32 columns (0-31)

        ; colour one row
:       sta [ZP_TEMP_ADDR1], y                                          ;$B228
        dey 
        bpl :-

        ; move to the next row
        lda ZP_TEMP_ADDR1_LO    ; get the row lo-address
        clc 
        adc # 40                ; add 40 chars (one screen row)
        sta ZP_TEMP_ADDR1_LO
        bcc :+                  ; remains under 255?
        inc ZP_TEMP_ADDR1_HI    ; if not, increase the hi-address

:       dex                     ; decrement remaining row count         ;$B238
        bne @row

        ;-----------------------------------------------------------------------
        ; erase the bitmap area above the HUD,
        ; i.e. the viewport
        ;
        ; calculate the number of bytes in the bitmap above the HUD
        .export erase_bytes             = .bmppos( ELITE_HUD_TOP_ROW, 0 )
        ; from this calculate the number of bytes in *whole* pages
        .export erase_bytes_pages       = (erase_bytes / 256) * 256
        ; and the remaining bytes that don't fill one page
        .export erase_bytes_remain      = erase_bytes - erase_bytes_pages

        ldx #> ELITE_BITMAP_ADDR
:       jsr erase_page                                                  ;$B23D
        inx 
        cpx #> (ELITE_BITMAP_ADDR + erase_bytes_pages)
        bne :-

        ; erase the non-whole-page remainder
        ldy #< (ELITE_BITMAP_ADDR + erase_bytes_pages + erase_bytes_remain - 1)
        jsr erase_page_from
        sta [ZP_TEMP_ADDR1], y

        ;-----------------------------------------------------------------------

        ; set cursor position to row/col 2 on Elite's screen
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        
        ;-----------------------------------------------------------------------

        ; are we in the cockpit-view?
        lda ZP_SCREEN
       .bze :+

        cmp # $0d
        bne _b25d

:       jmp _b301                                                       ;$B25A

        ;-----------------------------------------------------------------------

_b25d:                                                                  ;$B25D
        lda # $81               ; default value
        sta _a8db
        
        lda # $c0               ; default value
        sta _a8e1

:       jsr erase_page                                                  ;$B267
        inx 
        cpx #> (ELITE_BITMAP_ADDR + $2000)
        bne :-

        ldx # $00
        stx _1d01
        stx _1d04

        inx 
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW
        
        jsr _b359
        jsr hide_all_ships
        jsr disable_sprites
        
        ldy # ELITE_VIEWPORT_COLS-1
        lda # .color_nybble( YELLOW, BLACK )

:       sta ELITE_MENUSCR_ADDR + .scrpos( 0, 4 ), y                     ;$B289
        dey 
        bpl :-

        ldx ZP_SCREEN
        cpx # $02
        beq _b2a5
        
        cpx # $40
        beq _b2a5
        cpx # $80
        beq _b2a5

        ldy # ELITE_VIEWPORT_COLS-1

:       sta ELITE_MENUSCR_ADDR + .scrpos( 2, 4 ), y                     ;$B29F
        dey 
        bpl :-

_b2a5:                                                                  ;$B2A5
        ldx # $c7
        jsr _b2d5

        lda # %11111111
        sta ELITE_BITMAP_ADDR + 7 + .bmppos( 24, 35 )                   ;=$5F1F

        ldx # $19
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_b2b2:                                                                  ;$B2B2
        ldx # $12

        stx ZP_C0

        ldy # 3 * 8             ; 3rd char in bitmap cells
        sty ZP_TEMP_ADDR1_LO

        ldy #> ELITE_BITMAP_ADDR
        lda # %00000011
        jsr _b2e1
        
        ldy #< (ELITE_BITMAP_ADDR + .bmppos( 0, 36 ))   ;=$4120
        sty ZP_TEMP_ADDR1_LO
        
        ldy #> (ELITE_BITMAP_ADDR + .bmppos( 0, 36 ))   ;=$4120
        lda # %11000000
        ldx ZP_C0
        jsr _b2e1
        
        lda # $01
        sta ELITE_BITMAP_ADDR + .bmppos( 0, 35 )                        ;=$4118
        
        ldx # $00
_b2d5:                                                                  ;$B2D5
        stx ZP_VAR_Y
        ldx # $00
        stx ZP_VAR_X1
        dex 
        stx ZP_VAR_X2
        jmp draw_straight_line

;===============================================================================

_b2e1:                                                                  ;$B2E1
        sta ZP_BE
        sty ZP_TEMP_ADDR1_HI
@loop:                                                                  ;$B2E5
        ldy # $07
:       lda ZP_BE                                                       ;$B2E7
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        dey 
        bpl :-
        lda ZP_TEMP_ADDR1_LO
        clc 
        adc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
        
        dex 
        bne @loop

        rts 

;===============================================================================

_b301:                                                                  ;$B301
        jsr _b2b2
        
        lda # $91
        sta _a8db               ; default value is $81
        
        lda # $d0
        sta _a8e1               ; default value is $C0
        
        lda _1d04               ; is HUD visible? (main or menu screen?)
        bne _b335
        
        ; reset the HUD graphics from the copy kept in RAM
        ;-----------------------------------------------------------------------
        ; the HUD is a 256px wide bitmap (with borders on the outside though).
        ; this routine 'clears' the HUD by restoring a clean copy from RAM
        ;
.import __HUD_DATA_RUN__
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ;
        ; the original Elite code does a rather inefficient byte-by-byte copy.
        ; for every byte copied, additional cycles are spent on decrementing
        ; the 16-bit address pointers and the slower indirect-X addressing
        ; mode is used -- but in a rather rediculous case of this being a
        ; rushed port from the BBC this routine also copies all the blank
        ; space left and right of the HUD *every frame*!
        ;
        ldx # 8                 ; numbe of pages to copy (8*256)
        lda #< __HUD_DATA_RUN__
        sta ZP_TEMP_ADDR3_LO
        lda #> __HUD_DATA_RUN__
        sta ZP_TEMP_ADDR3_HI

        hud_bmp = ELITE_BITMAP_ADDR + .bmppos(ELITE_HUD_TOP_ROW, 0)     ;=$5680

        lda #< hud_bmp
        sta ZP_TEMP_ADDR1_LO
        lda #> hud_bmp
        sta ZP_TEMP_ADDR1_HI
        jsr block_copy

        ldy # $c0               ; remainder bytes?
        ldx # $01
        jsr block_copy_from

.else   ;///////////////////////////////////////////////////////////////////////
        ;
        ; improved HUD-copy for Elite : Harmless
        ;
        ; we need to loop a full 256 times and we want to keep the exit check
        ; fast (so testing for zero/non-zero). starting at $FF won't do, as a
        ; zero-check at the bottom will exit out before the 0'th loop has been
        ; done. ergo, we start at 0, the `dex` at the bottom will underflow
        ; back to $FF and we loop around until back to $00 where the loop
        ; will exit without repeating the 0'th iteration
        ;
        ldx # $00

        ; here we copy one byte of 7 bitmap rows at a time. note that the
        ; bitmap data is stored in 256px strips (in Elite : Harmless),
        ; not 320px. doing 7 copies per loop reduces the cost of loop-testing
        ; (very slow to exit-test for every byte copied!) and also allows us
        ; to use the absolute-X adressing mode which costs 5 cycles each rather
        ; than 6 for the original code's use of indirect-X addressing
        ;
        bmp = ELITE_BITMAP_ADDR

        ; TODO: we could `.repeat` this for the number of rows defined by
        ; ELITE_HUD_HEIGHT_ROWS`
        ;
:       lda __HUD_DATA_RUN__, x         ; read from row 1 of backup HUD
        sta bmp + .bmppos(18, 4), x     ; write to row 18 of bitmap screen
        lda __HUD_DATA_RUN__ + $100 , x ; read from row 2 of backup HUD
        sta bmp + .bmppos(19, 4), x     ; write to row 19 of bitmap screen
        lda __HUD_DATA_RUN__ + $200, x  ; read from row 3 of backup HUD
        sta bmp + .bmppos(20, 4), x     ; write to row 20 of bitmap screen
        lda __HUD_DATA_RUN__ + $300, x  ; read from row 4 of backup HUD
        sta bmp + .bmppos(21, 4), x     ; write to row 21 of bitmap screen
        lda __HUD_DATA_RUN__ + $400, x  ; read from row 5 of backup HUD
        sta bmp + .bmppos(22, 4), x     ; write to row 22 of bitmap screen
        lda __HUD_DATA_RUN__ + $500, x  ; read from row 6 of backup HUD
        sta bmp + .bmppos(23, 4), x     ; write to row 23 of bitmap screen
        lda __HUD_DATA_RUN__ + $600, x  ; read from row 7 of backup HUD
        sta bmp + .bmppos(24, 4), x
        dex 
       .bnz :-

        ; borders to the left and right of the HUD lay outside the 256px
        ; centred HUD. 
        ;
        ; TODO: this should be drawn only once during initialisation,
        ;       as with the new HUD-copying method it never gets erased
        ;
        ldx # $08
:       dex 
        lda # %00000010                 ; yellow multi-color pixel on the right
        sta bmp + .bmppos(18, 3), x     ; draw left-border on bitmap row 18
        sta bmp + .bmppos(19, 3), x     ; draw left-border on bitmap row 19
        sta bmp + .bmppos(20, 3), x     ; draw left-border on bitmap row 20
        sta bmp + .bmppos(21, 3), x     ; draw left-border on bitmap row 21
        sta bmp + .bmppos(22, 3), x     ; draw left-border on bitmap row 22
        sta bmp + .bmppos(23, 3), x     ; draw left-border on bitmap row 23
        sta bmp + .bmppos(24, 3), x     ; draw left-border on bitmap row 24
        lda # %10000000                 ; yellow multi-color pixel on the left
        sta bmp + .bmppos(18, 36), x    ; draw right-border on bitmap row 18
        sta bmp + .bmppos(19, 36), x    ; draw right-border on bitmap row 19
        sta bmp + .bmppos(20, 36), x    ; draw right-border on bitmap row 20
        sta bmp + .bmppos(21, 36), x    ; draw right-border on bitmap row 21
        sta bmp + .bmppos(22, 36), x    ; draw right-border on bitmap row 22
        sta bmp + .bmppos(23, 36), x    ; draw right-border on bitmap row 23
        sta bmp + .bmppos(24, 36), x    ; draw right-border on bitmap row 24
        txa 
        bne :-

.endif  ;///////////////////////////////////////////////////////////////////////

        jsr hide_all_ships
        jsr _2ff3

_b335:  jsr _b359                                                       ;$B335
        jsr disable_sprites

        lda # $ff
        sta _1d04
        
        rts 

hide_all_ships:                                                         ;$B341
;===============================================================================
; appears to make all entities invisible to the radar scanner.
;
        ; search through the poly objects in-play
        ldx # $00

@next:  lda SHIP_SLOTS, x       ; what type of entitiy is here?         ;$B343
       .bze @rts                ; no more ships once we hit a $00 marker
        bmi :+                  ; skip over planets/suns

        jsr get_polyobj         ; get address of entity storage

        ; make the entitiy invisible to the radar!

        ldy # PolyObject::visibility
        lda [ZP_POLYOBJ_ADDR], y
        and # visibility::scanner ^$FF  ;=%11101111
        sta [ZP_POLYOBJ_ADDR], y

:       inx                                                             ;$B355
        bne @next

@rts:   rts                                                             ;$B358

;===============================================================================

_b359:                                                                  ;$B359
        ldx # $00
        ldy # $40
        jsr _b364

        ldx #< (ELITE_BITMAP_ADDR + .bmppos( 0, 37 ))                   ;=$4128
        ldy #> (ELITE_BITMAP_ADDR + .bmppos( 0, 37 ))                   ;=$4128
_b364:                                                                  ;$B364
        stx ZP_TEMP_ADDR1_LO
        sty ZP_TEMP_ADDR1_HI
        ldx # $12
_b36a:                                                                  ;$B36A
        ldy # $17
_b36c:                                                                  ;$B36C
        lda # $ff
        sta [ZP_TEMP_ADDR1], y
        dey 
        bpl _b36c

        lda ZP_TEMP_ADDR1_LO
        clc 
        adc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
        dex 
        bne _b36a
        
        rts 

;===============================================================================
; clear screen?
;
_b384:                                                                  ;$B384
        ldx # 8
        ldy # 0
        clc 
_b389:                                                                  ;$B389
        lda row_to_bitmap_lo, x
        sta ZP_TEMP_ADDR1_LO
        lda row_to_bitmap_hi, x
        sta ZP_TEMP_ADDR1_HI
        
        tya 

:       sta [ZP_TEMP_ADDR1], y                                          ;$B394
        dey 
        bne :-

        txa 
        adc # $08
        tax 
        cmp # $c0
        bcc _b389
        
        iny 
        sty ZP_CURSOR_COL
        sty ZP_CURSOR_ROW

        rts 

erase_page:                                                             ;$B3A7
        ;=======================================================================
        ; erase a page (256 bytes, aligned to $00...$FF)
        ;
        ;       X = page-number, i.e. hi-address
        ;
        ldy # $00
        sty ZP_TEMP_ADDR1_LO

erase_page_from:                                                        ;$B3AB
        ;=======================================================================
        ; erase some bytes:
        ;
        ;     $07 = lo-address
        ;       X = hi-address
        ;       Y = offset
        ;
        lda # $00
        stx ZP_TEMP_ADDR1_HI

:       sta [ZP_TEMP_ADDR1], y                                          ;$B3AF
        dey 
        bne :-

        rts 

erase_page_to_end:                                                      ;$B3B5
        ;=======================================================================
        lda # $00
:       sta [ZP_TEMP_ADDR1], y                                          ;$B3B7
        iny 
        bne :-

        rts 

; unreferenced / unused?
;$b3bd:
        sta ZP_CURSOR_COL
        rts 

_b3c0:                                                                  ;$B3C0
        sta ZP_CURSOR_ROW
        rts 

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
;
; does a large block-copy of bytes. used to wipe the HUD
; by copying over a clean copy of the HUD in RAM.
;
; [ZP_TEMP_ADDR3] = from address
; [ZP_TEMP_ADDR1] = to address
;               X = number of pages to copy
;
; the copy method is replaced with a faster alternative
; in elite-harmless, so this code is no longer used there
; 
block_copy:                                                             ;$B3C3
        ;-----------------------------------------------------------------------
        ; start copying from the beginning of the page
        ldy # $00

block_copy_from:                                                        ;$B3C5
        ;-----------------------------------------------------------------------
        lda [ZP_TEMP_ADDR3], y  ; read from
        sta [ZP_TEMP_ADDR1], y  ; write to
        dey                     ; roll the byte-counter
       .bnz block_copy_from     ; keep going until it looped

        ; move to the next page
        inc ZP_TEMP_ADDR3_HI
        inc ZP_TEMP_ADDR1_HI
        dex                     ; one less page to copy
       .bnz block_copy_from     ; still pages to do?
        
        rts 

;///////////////////////////////////////////////////////////////////////////////  
.endif

txt_docked_token15:                                                     ;$B3D4
;===============================================================================
.export txt_docked_token15
        
        lda # $00
        sta VAR_048B
        sta VAR_048C

        lda # %11111111
        sta txt_lcase_flag
        
        lda # %10000000
        sta ZP_34

        lda # 21
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL
        
        txt_bmp_addr = ELITE_BITMAP_ADDR + .bmppos( 21, 4 )

        lda #> txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_HI
        lda #< txt_bmp_addr     ;=$5A60
        sta ZP_TEMP_ADDR1_LO
        ldx # $03

@_b3f7:                                                                 ;$B3F7
        lda # $00
        tay 

:       sta [ZP_TEMP_ADDR1], y                                          ;$B3FA
        dey 
        bne :-
        clc 
        lda ZP_TEMP_ADDR1_LO
        adc # $40
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
        dex 
        bne @_b3f7
_b40f:                                                                  ;$B40F
        rts 

;===============================================================================

_b410:                                                                  ;$B410
.export _b410

        lda ZP_SCREEN
        bne _b40f

        lda ZP_POLYOBJ_VISIBILITY
        and # visibility::scanner
        beq _b40f
        
        ldx ZP_A5
        bmi _b40f
        lda _267e, x
        sta ZP_32

        lda ZP_POLYOBJ_XPOS_MI
        ora ZP_POLYOBJ_YPOS_MI
        ora ZP_POLYOBJ_ZPOS_MI
        and # %11000000
        bne _b40f

        lda ZP_POLYOBJ_XPOS_MI
        clc 
        
        ldx ZP_POLYOBJ_XPOS_HI
        bpl :+
        eor # %11111111
        adc # $01
:       adc # $7b                                                       ;$B438
        sta ZP_VAR_X

        lda ZP_POLYOBJ_ZPOS_MI
        lsr 
        lsr 
        clc 
        ldx ZP_POLYOBJ_ZPOS_HI
        bpl :+
        eor # %11111111
        sec 
:       adc # $53                                                       ;$B448
        eor # %11111111
        sta ZP_TEMP_ADDR1_LO
        
        lda ZP_POLYOBJ_YPOS_MI
        lsr 
        clc 
        ldx ZP_POLYOBJ_YPOS_HI
        bmi :+
        eor # %11111111
        sec 
:       adc ZP_TEMP_ADDR1_LO                                            ;$B459
        cmp # $92
        bcs :+
        lda # $92
:       cmp # $c7                                                       ;$B461
        bcc :+
        lda # $c6
:       sta ZP_VAR_Y                                                    ;$B467
        
        sec 
        sbc ZP_TEMP_ADDR1_LO
        php 
        pha 
        jsr _b0b0                       ; draw two multi-color pixels?
        lda _ab49, x
        and ZP_32
        sta ZP_VAR_X
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
        lda ZP_VAR_X
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
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
_b4ae:                                                                  ;$B4AE
        iny 
        cpy # $08
        bne _b4c1
        ldy # $00
        lda ZP_TEMP_ADDR1_LO
        adc # $3f
        sta ZP_TEMP_ADDR1_LO
        lda ZP_TEMP_ADDR1_HI
        adc # $01
        sta ZP_TEMP_ADDR1_HI
_b4c1:                                                                  ;$B4C1
        lda ZP_VAR_X
        eor [ZP_TEMP_ADDR1], y
        sta [ZP_TEMP_ADDR1], y
        inx 
        bne _b4ae
        
        rts                                                             ;$B4CA
