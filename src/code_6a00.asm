; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.linecont+

; yes, I am aware that ca65 allows for 'default import of undefined labels'
; but I want to keep track of things explicitly for clarity and helping others
;
; from "text_flight.asm"
.import _0700:absolute
; from "text_pairs.asm"
.import TKN_FLIGHT_pair1:absolute
.import TKN_FLIGHT_pair2:absolute


.segment        "CODE_6A00"                                             ;$6A00
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

check_cargo_capacity_add1:                              ; BBC: tnpr1    ;$6A00
;===============================================================================
; check if 1 tonne of a given item will fit in your cargo:
;
; in:   A       index of cargo item;
;               see `Cargo` struct for order
; out:  carry   clear = fits, set = overflow
;-------------------------------------------------------------------------------
        sta CARGO_ITEM          ; item index?
        lda # 1

        ; fallthrough
        ; ...

check_cargo_capacity:                                   ; BBC: tnpr     ;$6A05
;===============================================================================
; check if a purchase would fit your cargo hold:

; in:   A               initial quantity count
;       CARGO_ITEM      set to the type of item to count
; out:  carry           clear = fits, set = overflow
;       A               (preserved)
;-------------------------------------------------------------------------------
        pha                     ; preserve A

        ; the precious materials (gold / platinum / gems / alien items)
        ; are measured in Kg
        ;
        ldx # Cargo::minerals   ; minerals or below?
        cpx CARGO_ITEM          ; check against the compare type
        bcc @kg                 ; skip ahead if precious materials

        ; count the number of tonnes of cargo:
        ; for each cargo type, add its quantity to the Accumulator
:       adc PLAYER_CARGO, x                                             ;$6A0D
        dex 
        bpl :-

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; Elite Facts!®
        ;
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

        ;-----------------------------------------------------------------------
        ; for precious materials, the limit is 200 Kg each, not taken from
        ; your ship's hold capacity. maybe you stuff it behind your seat?
        ;
        ; carry unset = OK
        ; carry set   = overflow
        ;
        ; TODO: the BBC disk version has a slight variation between flight &
        ; docked allowing you to scoop gems that wouldn't otherwise fit, see
        ; <https://www.bbcelite.com/compare/main/subroutine/tnpr.html>
        ;
@kg:    ldy CARGO_ITEM                                                  ;$6A1B
        adc PLAYER_CARGO, y     ; number of Kg of selected item
        cmp # 200               ; maximum of 200 Kg

        pla                     ; restore A
        rts 


; NOTE: in the original code, "orig/cursor.asm" appears here            ;$6A25


.segment        "CODE_6A2F"                                             ;$6A2F
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set_page_6a2f:                                                          ;$6A2F
;===============================================================================
; changes page and does some other pre-emptive work?
;
; in:   A       page ID to change to
;
; TODO: is this even necessary? (dead code)
;-------------------------------------------------------------------------------
        jsr set_page

        jsr _28d5               ; loads A & X with $0F
        lda # $30

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr _DOVDU19            ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        rts 


randomize:                                              ; BBC: TT20     ;$6A3B
;===============================================================================
; moves the random number generator along 4 steps to produce
; fresh random numbers, but does not return a random number
;
;-------------------------------------------------------------------------------
        ; this routine calls itself 4 times to ensure
        ; enough scrambling of the random number
        ;
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


print_target_system_distance:                           ; BBC: TT146    ;$6A68
;===============================================================================
; print distance to target system in light-years:
; this includes "distance: ", and "light years"
;
;-------------------------------------------------------------------------------
        ; is target system distance > 0
        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz :+

       .cursor_down_jmp

        ;-----------------------------------------------------------------------
        ; print "DISTANCE:"
        ;
.import TKN_FLIGHT_DISTANCE:direct
:       lda # TKN_FLIGHT_DISTANCE                                       ;$6A73
        jsr print_flight_token_with_colon

        ldx TSYSTEM_DISTANCE_LO ; print the distance as a fixed-
        ldy TSYSTEM_DISTANCE_HI ;  point decimal, e.g. "6.4"
        sec                     ; carry set = use decimal point
        jsr print_num16         ; print number in X/Y

        ; print "LIGHT YEARS"
        ;
.import TKN_FLIGHT_LIGHT_YEARS:direct
        lda # TKN_FLIGHT_LIGHT_YEARS

        ; fallthrough
        ; ...

print_flight_token_and_newpara:                         ; BBC: TT60     ;$6A84
;===============================================================================
; prints a flight text token, a blank line and enables
; sentance case for starting a new paragrpah:
;
;-------------------------------------------------------------------------------
        jsr print_flight_token

        ; fallthrough
        ; ...

print_newpara:                                          ; BBC: TTX69    ;$6A87
;===============================================================================
; prints a blank line and switches to sentance case:
;
;-------------------------------------------------------------------------------
       .cursor_down             ; move cursor down a row,
                                ; but does not reset col
        ; fallthrough
        ; ...

print_newline_para:                                     ; BBC: TT69     ;$6A8A
;===============================================================================
        lda # %10000000         ; set bit 7 - sentance case
        sta ZP_PRINT_CASE

        ; fallthrough
        ; ...

print_newline:                                          ; BBC: TT67     ;$6A8E
;===============================================================================
        lda # TXT_NEWLINE
        jmp print_flight_token


print_mainly:                                           ; BBC: TT70     ;$6A93
;===============================================================================
; print "MAINLY", e.g. for economy, "mainly industrial"
;
;-------------------------------------------------------------------------------
.import TKN_FLIGHT_MAINLY:direct
        lda # TKN_FLIGHT_MAINLY
        jsr print_flight_token
        jmp _6ad3


print_flight_token_and_space:                           ; BBC: spc      ;$6A9B
;===============================================================================
; prints the given flight token and then a space:
;
;-------------------------------------------------------------------------------
        jsr print_flight_token
        jmp print_space


planet_screen:                                          ; BBC: TT25     ;$6AA1
;===============================================================================
; planetary information screen:
;
;-------------------------------------------------------------------------------
        lda # page::empty       ; switch to the menu screen,
        jsr set_page_6a2f       ;  starting with a blank page

        lda # 9
       .set_cursor_col

        ; print "DATA ON " ...
.import TKN_FLIGHT_DATA_ON:direct
        lda # TKN_FLIGHT_DATA_ON
        jsr print_flight_token_and_divider
        jsr print_newpara

        ; if the distance is non-zero (i.e. we're not AT the system),
        ; print "DISTANCE: nn.n LIGHT YEARS", otherwise a blank line
        jsr print_target_system_distance

        ; economy:
        ;-----------------------------------------------------------------------
        ; print "ECONOMY:"
.import TKN_FLIGHT_ECONOMY:direct
        lda # TKN_FLIGHT_ECONOMY
        jsr print_flight_token_with_colon

        ; decode the economy wealth:
        ;
        ;       %000 (0) or %101 (5) = Rich
        ;       %001 (1) or %110 (6) = Average
        ;       %010 (2) or %111 (7) = Poor
        ;       %011 (3) or %100 (4) = Mainly
        ;
        lda TSYSTEM_ECONOMY     ; economy byte of target system

        clc                     ; (ready for math!)
        adc # %01               ; check for 3 or 4 by adding 1
        lsr                     ;  and shifting right, giving 
        cmp # %10               ;  %011(3)->%10 or $100(4)->%10
        beq print_mainly        ; is "mainly", go print

        ; there are three text tokens for "rich", "average" and "poor",
        ; but economy values 0-7. for values 0-2 we can print as-is --
        ; the `cmp` will set carry for values 3+ (%011+1=%100>>1=%10)
        ;
        lda TSYSTEM_ECONOMY     ; go back to original economy value
        bcc :+                  ; print for economy values 0-2

        ; (due to the `bcc` above, carry is guaranteed to be set
        ; ensuring that the subtraction does not borrow)
        ;
        sbc # $05               ; shift 5-thru-7 down to 0-thru-2
        clc                     ; clear carry for the following add

        ; print "RICH" | "AVERAGE" | "POOR"
        ;
.import TKN_FLIGHT_ECONOMY_WEALTH:direct
:       adc # TKN_FLIGHT_ECONOMY_WEALTH                                 ;$6ACE
        jsr print_flight_token

        ; economy type:
        ;
_6ad3:  lda TSYSTEM_ECONOMY                                             ;$6AD3
        lsr                     ; bit 2 is used for the economy type
        lsr                     ; argricultural (1) / industrial (0)

        ; print "INDUSTRIAL" | "AGRICULTURAL"
.import TKN_FLIGHT_ECONOMY_TYPE:direct
        clc 
        adc # TKN_FLIGHT_ECONOMY_TYPE
        jsr print_flight_token_and_newpara

        ; government:
        ;-----------------------------------------------------------------------
        ; print "GOVERNMENT: "
.import TKN_FLIGHT_GOVERNMENT:direct
        lda # TKN_FLIGHT_GOVERNMENT
        jsr print_flight_token_with_colon

        ; print "ANARCHY" | "FEUDAL" | "MULTI-GOVERNMENT" | "DICTATORSHIP" |
        ;       "COMMUNIST" | "CONFEDORACY" | "DEMOCRACY" | "CORPORATE STATE"
        ;
        lda TSYSTEM_GOVERNMENT  ; system government byte (0-7)
        clc
.import TKN_FLIGHT_GOVERNMENT_TYPE:direct 
        adc # TKN_FLIGHT_GOVERNMENT_TYPE
        jsr print_flight_token_and_newpara

        ; tech-level:
        ;-----------------------------------------------------------------------
        ; print "TECH LEVEL: "
.import TKN_FLIGHT_TECH_LEVEL:direct
        lda # TKN_FLIGHT_TECH_LEVEL
        jsr print_flight_token_with_colon

        ldx TSYSTEM_TECHLEVEL   ; current/target system tech-level
        inx                     ; adjust to 1-based
        clc                     ; carry-clear = no decimal point
        jsr print_tiny_value    ; print the tech-level number
        jsr print_newpara

        ; population:
        ;-----------------------------------------------------------------------
        ; print "POPULATION: "
.import TKN_FLIGHT_POPULATION:direct
        lda # TKN_FLIGHT_POPULATION
        jsr print_flight_token_with_colon

        sec                     ; print with decimal point
        ldx TSYSTEM_POPULATION  ; print population number / 10
        jsr print_tiny_value

        ; print "BILLION"
.import TKN_FLIGHT_BILLION:direct
        lda # TKN_FLIGHT_BILLION
        jsr print_flight_token_and_newpara

        ; species:
        ;-----------------------------------------------------------------------
.import TKN_FLIGHT_LPAREN:direct
        lda # TKN_FLIGHT_LPAREN ; print "("
        jsr print_flight_token

        ; choose species: this is 50/50
        ; either humans or an alien species
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                                        ^
        ;                                       humans or aliens?
        ;
        lda ZP_SEED_W2_LO       ; check bit 7 in word 2 of the seed
        bmi :+                  ; if 1, skip ahead to alien species

.import TKN_FLIGHT_HUMAN_COLONIAL:direct
        lda # TKN_FLIGHT_HUMAN_COLONIAL
        jsr print_flight_token  ; print "HUMAN COLONIALS", and jump
        jmp _6b5a               ;  ahead to the closing paranthesis

        ; choose an alien species:
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                               ^^^^^^
        ;                                      alien species
        ;
:       lda ZP_SEED_W2_HI                                               ;$61BE
        lsr                     ; remove bits 0 & 1,
        lsr                     ;  leaving bits 2-7 shifted down
        pha                     ; keep this value for later
        
        ; 1st adjective:
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                                  ^^^
        ;
        and # %00000111         ; look at the lower 3 bits
        cmp # %00000011         ; of that, the lower 3 values
        bcs :+                  ;  will be given an adjective

        ; print "LARGE" | "FIERCE" | "SMALL"
        ;
.import TKN_FLIGHT_LARGE:direct
        adc # TKN_FLIGHT_LARGE
        jsr print_flight_token_and_space

        ; 2nd adjective (colour):
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                               ^^^
        ;
:       pla                     ; retrieve our species again            ;$6B2E
        lsr                     ; isolate the upper 3 bits
        lsr                     ;  by shifting off the lower 3 bits
        lsr 
        cmp # $06               ; the lower 5 values will get
        bcs :+                  ;  a colour assigned

        ; print "GREEN" | "RED" | "YELLOW" | "BLUE" | "BLACK"
        ;
.import TKN_FLIGHT_COLORS:direct
        adc # TKN_FLIGHT_COLORS
        jsr print_flight_token_and_space

        ; 3rd adjective:
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;            ^^^                 ^^^
        ;       3rd adj.            <-- (XOR)
        ;
:       lda ZP_SEED_W1_HI       ; XOR this byte                         ;$6B3B
        eor ZP_SEED_W0_HI       ;  with that byte
        and # %00000111         ;  and take the low 3 bits
        sta ZP_8E               ; (preserve for later)
        cmp # 6                 ; the lower 5 values
        bcs :+                  ;  will get the adjective

        ; print "HARMLESS" | "SLIMY" | "BUG-EYED" | "HORNED" |
        ;       "BONY" | "FAT" | "FURRY"
        ;
.import TKN_FLIGHT_ADJECTIVES:direct
        adc # TKN_FLIGHT_ADJECTIVES+1   ; +1, because of borrow?
        jsr print_flight_token_and_space

        ; species:
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                                     ^^
        ;
:       lda ZP_SEED_W2_HI                                               ;$6B4C
        and # %00000011         ; take two bits from the seed
        clc                     ;  and add the bits we XORed
        adc ZP_8E               ;  together earlier, and from this
        and # %00000111         ;  modulo 8 to select species

        ; print "RODENT" | "FROG" | "LIZARD" | "LOBSTER" | "BIRD" |
        ;       "HUMANOID" | "FELINE" | "INSECT"
        ;
.import TKN_FLIGHT_SPECIES:direct
        adc # TKN_FLIGHT_SPECIES
        jsr print_flight_token

_6b5a:                                                                  ;$6B5A
        ; append "s)"
.import TKN_FLIGHT_S:direct
        lda # TKN_FLIGHT_S      ; print "s"; e.g. "RODENTS"
        jsr print_flight_token
.import TKN_FLIGHT_RPAREN:direct
        lda # TKN_FLIGHT_RPAREN ; and the closing paren
        jsr print_flight_token_and_newpara

        ; productivity:
        ;-----------------------------------------------------------------------
.import TKN_FLIGHT_GROSS_PRODUCTIVITY:direct
        lda # TKN_FLIGHT_GROSS_PRODUCTIVITY
        jsr print_flight_token_with_colon

        ldx TSYSTEM_PRODUCTIVITY_LO
        ldy TSYSTEM_PRODUCTIVITY_HI
        jsr print_int16         ; print the 16-bit number
        jsr print_space         ;  for gross productivity

        lda # %00000000         ; enable all-caps
        sta ZP_PRINT_CASE       ;  for the next string

.import TKN_FLIGHT_M:direct
        lda # TKN_FLIGHT_M      ; print "M" (million)
        jsr print_flight_token
.import TKN_FLIGHT_CR:direct
        lda # TKN_FLIGHT_CR     ; print " CR" (credits)
        jsr print_flight_token_and_newpara

        ; average radius:
        ;-----------------------------------------------------------------------
.import TKN_FLIGHT_AVERAGE_RADIUS:direct
        lda # TKN_FLIGHT_AVERAGE_RADIUS
        jsr print_flight_token_with_colon

        ; extract the average planet radius from the seed:
        ;
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                           ^^^^^^^^                ^^^^
        ;                            lo-bits                hi-bits
        lda ZP_SEED_W2_HI
        ldx ZP_SEED_W1_HI
        and # %00001111

        clc                     ; add the minimum scale factor;
        adc # 11                ;  this ensures that all planets
        tay                     ;  have a radius of at least 256*11,
        jsr print_num16         ;  avoiding a planet of radius 0!
        jsr print_space

        ; print "KM" (Kilometers)
        ;
        lda # $6b               ;="K"
        jsr print_char
        lda # $6d               ;="M"
        jsr print_char

        jsr print_newpara
        jmp _3d2f               ; (not in the BBC code)

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; extraneous
.endif  ;///////////////////////////////////////////////////////////////////////


get_system_info:                                        ; BBC: TT24     ;$6BA9
;===============================================================================
; extract target planet information:
;
; a more visual guide to the way planet information is generated from the seed
; can be seen here: <http://wiki.alioth.net/index.php/Random_number_generator>
;-------------------------------------------------------------------------------
        ; economy:
        ;-----------------------------------------------------------------------
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;            ^^^
        ;
        lda ZP_SEED_W0_HI
        and # %00000111
        sta TSYSTEM_ECONOMY

        ; government:
        ;-----------------------------------------------------------------------
        ;       W0:   HI       LO | W1:   HI       LO | W2:   HI       LO
        ; seed: 01011010-01001010 | 00000010-01001000 | 10110111-01010011
        ;                                      ^^^
        ;
        lda ZP_SEED_W1_LO
        lsr 
        lsr 
        lsr 
        and # %00000111
        sta TSYSTEM_GOVERNMENT

        ; anarchy (0) and fuedal (1) systems cannot be rich
        ; (Japan would like a word)
        lsr                     ; push off bit 0, any number above 1
        bne :+                  ;  will have bits remaining

        lda TSYSTEM_ECONOMY     ; patch the economy byte
        ora # %00000010         ;  to avoid "rich" (value 0)
        sta TSYSTEM_ECONOMY

        ; tech-level is determined by a combination of economy,
        ; a random jitter, and the type of government:
        ;
:       lda TSYSTEM_ECONOMY     ; use the economy as the base   ;$6BC5
        eor # %00000111         ;  but flip the bits
        clc                     ;  to form the base tech-level
        sta TSYSTEM_TECHLEVEL

        lda ZP_SEED_W1_HI       ; add a random jitter from the seed
        and # %00000011         ;  (0-3)
        adc TSYSTEM_TECHLEVEL
        sta TSYSTEM_TECHLEVEL

        lda TSYSTEM_GOVERNMENT  ; take the government type,
        lsr                     ;  right-shift (/2)
        adc TSYSTEM_TECHLEVEL   ;  and apply to
        sta TSYSTEM_TECHLEVEL   ;  the tech-level

        ; now use the tech-level as a basis of population:
        ;
        asl                     ; x2
        asl                     ; x4
        adc TSYSTEM_ECONOMY     ; add the economy level
        adc TSYSTEM_GOVERNMENT  ;  and the government type
        adc # $01               ;  +1, and use as population
        sta TSYSTEM_POPULATION  ;  in billions, /10 (fractional)

        ; productivity:
        ;-----------------------------------------------------------------------
        lda TSYSTEM_ECONOMY     ; again, begin with the
        eor # %00000111         ;  inverse of economy
        adc # $03               ;  add a floor of 3 (in case of zero)
        sta ZP_VAR_P            ;  put this aside for multiplication

        lda TSYSTEM_GOVERNMENT  ; use the government as the other side
        adc # $04               ;  of the equation; with a floor
        sta Q                   ;  of 4 (in case of zero)

        jsr multiply_unsigned_PQ

        lda TSYSTEM_POPULATION  ; multiply the result (in P)
        sta Q                   ;  against the population

        ; TODO: couldn't we just use `ldx` and call `multiply_unsigned_PX`?
        jsr multiply_unsigned_PQ

        ; lastly multiply the 16-bit result (A.P) by 8
        asl ZP_VAR_P            ; x2 (lo)
        rol                     ; x2 (hi)
        asl ZP_VAR_P            ; x4 (lo)
        rol                     ; x4 (hi)
        asl ZP_VAR_P            ; x8 (lo)
        rol                     ; x8 (hi)
        sta TSYSTEM_PRODUCTIVITY_HI
        ; store productivity lo-byte
        lda ZP_VAR_P
        sta TSYSTEM_PRODUCTIVITY_LO

        rts 


galactic_chart:                                         ; BBC: TT22     ;$6C1C
;===============================================================================
; show the long-range (galactic) chart:
;
;-------------------------------------------------------------------------------
        lda # page::chart_galaxy
        jsr set_page            ; switch pages, clearing the screen

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # 16                ; BBC: set colour palette for viewport
        jsr _DOVDU19            ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # 7
       .set_cursor_col

        ; reset the seed to the first system in the galaxy
        ; (to enumerate them all)
        jsr get_galaxy_seed

        ; print "GALACTIC CHART <galaxy-number>"
.import TKN_FLIGHT_GALACTIC_CHART:direct
        lda # TKN_FLIGHT_GALACTIC_CHART
        jsr print_flight_token

        ; draw line across top of chart (under title)
        ; this routine also moves the cursor down one row
        jsr draw_line_divider_galactic_chart

        lda # 152               ; draw line across bottom of chart
        jsr draw_line_divider   ; (chart is 128px high)

        ; draw the circle for the current system
        jsr draw_range_circle

        ; draw stars on chart:
        ;-----------------------------------------------------------------------
        ldx # $00
:       stx ZP_PRESERVE_X       ; backup current star index?            ;$6C40

        ldx ZP_SEED_W1_HI
        ldy ZP_SEED_W2_LO
        tya 
        ora # %01010000
        sta ZP_VAR_Z            ; star size?

        lda ZP_SEED_W0_HI
        lsr 
        clc 
        adc # $18
        sta ZP_VAR_XX15_1

        jsr paint_particle

        jsr randomize
        
        ldx ZP_PRESERVE_X       ; retrieve star index
        inx                     ; move to next star
       .bnz :-                  ; more stars to draw?

        ;-----------------------------------------------------------------------

        lda TSYSTEM_POS_X
        sta ZP_8E
        lda TSYSTEM_POS_Y
        lsr 
        sta ZP_8F
        lda # $04
        sta ZP_90

        ; fallthrough
        ; ...

draw_crosshair:                                         ; BBC: TT15     ;$6C6D
;===============================================================================
; draws a cross-hair:
;
; in:   ZP_8E                   cross-hair X-position
;       ZP_8F                   cross-hair Y-position
;       ZP_90                   cross-hair size
;-------------------------------------------------------------------------------
        lda # 24                ; a default offset of 24. why?
        ldx ZP_SCREEN           ; check current screen
        bpl :+                  ; skip over if not short-range chart
        lda # $00               ; change the offset to 0

:       sta ZP_93               ; record the offset chosen              ;$6C75

        ; clip the cross-hair:
        ;-----------------------------------------------------------------------
        ; left edge:
        ;
        lda ZP_8E               ; retrieve cross-hair X-position
        sec                     ; subtract cross-hair size
        sbc ZP_90               ;  to get left-most position
        bcs :+                  ; underflow?
        lda # $00               ; clip against left edge
:       sta ZP_VAR_XX15_0       ; set line starting X                   ;$6C80

        ; right edge:
        ;
        lda ZP_8E               ; retrieve cross-hair X-position
        clc                     ; add cross-hair size
        adc ZP_90               ;  to get right-most position
        bcc :+                  ; overflow?
        lda # $ff               ; clip against right edge
:       sta ZP_VAR_XX15_2       ; set line ending X                     ;$6C8B

        ; centre-point:
        ;
        lda ZP_8F               ; retrieve cross-hair Y-position
        clc                     ; add the offset (?)
        adc ZP_93               ;  to get centre-point Y position

        ; draw the horizontal line of the cross-hair:
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        sta ZP_VAR_XX15_1
        sta ZP_VAR_XX15_3
        jsr draw_line
.else   ;///////////////////////////////////////////////////////////////////////
        ; TODO: line-validation not required (X1 & X2 are in correct order),
        ;       so we could skip over validation in the routine
        ;
        sta ZP_VAR_XX15_1       ; use the optimised routine
        jsr draw_straight_line  ;  for drawing straight lines
.endif  ;///////////////////////////////////////////////////////////////////////

        ; top edge:
        ;
        lda ZP_8F               ; retrieve cross-hair Y-position
        sec                     ; subtract cross-hair size
        sbc ZP_90               ;  to get top-most position
        bcs :+                  ; underflow?
        lda # $00               ; clip against top edge
:       clc                     ; add the offset (?)                    ;$6CA2
        adc ZP_93
        sta ZP_VAR_XX15_1

        ; bottom edge:
        ;
        lda ZP_8F               ; retrieve cross-hair Y-position
        clc
        adc ZP_90               ; add cross-hair size
        adc ZP_93               ;  and the offset (?)
        cmp # 152               ; overrun bottom of chart?
        bcc :+
        ldx ZP_SCREEN           ; check which screen
        bmi :+                  ; ignore for long-range
        lda # 151               ; clip for short-range
:       sta ZP_VAR_XX15_3                                               ;$6CB8

        lda ZP_8E
        sta ZP_VAR_XX15_0
        sta ZP_VAR_XX15_2
        ; TODO: line-validation not required (Y1 & Y2 are in correct order),
        ;       so we could skip over validation in the routine
        jmp draw_line


draw_range_local:                                       ; BBC: TT126    ;$6CC3
;===============================================================================
; TODO: calculate position from constants
;-------------------------------------------------------------------------------
        lda # 104               ; cross-hair X-position
        sta ZP_8E
        lda # 90                ; cross-hair Y-position
        sta ZP_8F

        lda # 16                ; cross-hair size
        sta ZP_90

        jsr draw_crosshair

        lda PLAYER_FUEL         ; use the player's fuel count...
        sta ZP_CIRCLE_RADIUS    ; ... as the circle-radius! (no scaling)

        jmp draw_chart_circle   ; continue drawing the circle


draw_range_circle:                                      ; BBC: TT14     ;$6CDA
;===============================================================================
; draw the jump range circle on a chart (short-range or galactic)
; for the current system:
;
;-------------------------------------------------------------------------------
        ; is this the short-range or the galactic chart?
        ;
        lda ZP_SCREEN           ; are we on the local chart?
        bmi draw_range_local    ; do setup for the local chart...

        ; draw range circle for long-range (galactic) chart:
        ;-----------------------------------------------------------------------
        lda PLAYER_FUEL         ; fuel amount determines jump distance
        lsr                     ; divide by 4 to scale
        lsr                     ; (max fuel is 70)
        sta ZP_CIRCLE_RADIUS

        lda PSYSTEM_POS_X       ; get X-position of present system
        sta ZP_8E               ; this will be cross-hair centre position X

        lda PSYSTEM_POS_Y       ; get Y-position of present system
        lsr                     ; divide by 2 to scale down to 128 height
        sta ZP_8F               ; this will be cross-hair centre position Y

        lda # 7                 ; set cross-hair size
        sta ZP_90

        jsr draw_crosshair

        lda ZP_8F               ; add 24 (?) to the Y-position of
        clc                     ;  the cross-hair so that the centre
        adc # 24                ;  of the circle matches the centre
        sta ZP_8F               ;  of the cross hair

        ; fallthrough to draw the circle
        ; ...

draw_chart_circle:                                      ; BBC: TT128    ;$6CFE
;===============================================================================
; draw a circle on a chart:
;
; this routine transfers the 8-bit cross-hair parameters
; into the 16-bit circle-drawing parameters before invoking
;-------------------------------------------------------------------------------
        lda ZP_8E               ; get cross-hair X-position
        sta ZP_CIRCLE_XPOS_LO   ; set circle X-position, lo-byte

        lda ZP_8F               ; get cross-hair Y-position
        sta ZP_CIRCLE_YPOS_LO   ; set circle Y-position, lo-byte

        ; the circle X & Y positions are 16-bit, so set the hi-bytes to 0
        ; as our centre-point is guaranteed to be within the screen
        ldx # $00
        stx ZP_CIRCLE_YPOS_HI
        stx ZP_CIRCLE_XPOS_HI

        inx                     ; BBC: set X=1 to reset ball line-heap
        stx ZP_CIRCLE_INDEX

        ldx # $02               ; BBC: set X=2 for step-size
        stx ZP_CIRCLE_STEP

        jmp draw_circle


buy_screen:                                                             ;$6D16
;===============================================================================
; buy cargo screen
;
;-------------------------------------------------------------------------------
        lda # page::buy_cargo
        jsr set_page_6a2f

        jsr _72db

        lda # %10000000
        sta ZP_PRINT_CASE

        lda # $00
        sta CARGO_ITEM          ; item index?
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
        jsr tkn_docked_fn15

.import TKN_FLIGHT_QUANTITY_OF:direct
        lda # TKN_FLIGHT_QUANTITY_OF
        jsr print_flight_token

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"
.import TKN_FLIGHT_CARGO_TYPES:direct

        lda CARGO_ITEM          ; item index?
        clc 
        adc # TKN_FLIGHT_CARGO_TYPES
        jsr print_flight_token

.import TKN_FLIGHT_SLASH:direct
        lda # TKN_FLIGHT_SLASH
        jsr print_flight_token

        jsr _72b8

.import TKN_FLIGHT_QMARK:direct
        lda # TKN_FLIGHT_QMARK
        jsr print_flight_token

        jsr print_newline
        ldx # $00
        stx R
        ldx # $0c
        stx ZP_TEMP_VAR
        jsr _6dc9
        bcs _6d32
        
        sta ZP_VAR_P1
        jsr check_cargo_capacity

        ldy # $ce
        lda R
        beq _6d79
        bcs _6d34
_6d79:                                                                  ;$6D79
        lda VAR_04EC
        sta Q
        jsr _74a2
        jsr _745a
        ldy # $c5
        bcc _6d34
        ldy CARGO_ITEM          ; item index?
        lda R
        pha 
        clc 
        adc PLAYER_CARGO, y
        sta PLAYER_CARGO, y
        lda MARKET_FOOD, y      ; update quantity available for sale?
        sec 
        sbc R
        sta MARKET_FOOD, y      ; quantity available for sale?
        pla 
        beq _6da4
        jsr _761f
_6da4:                                                                  ;$6DA4
        lda CARGO_ITEM          ; item index?
        clc 
        adc # 5
       .set_cursor_row
        lda # 0
       .set_cursor_col

        inc CARGO_ITEM          ; item index?
        lda CARGO_ITEM          ; item index?
        cmp # $11
        bcs _6dbf
        jmp _6d27
_6dbf:                                                                  ;$6DBF
        lda # $10
        sta VAR_050C
        lda # $20
        jmp _FRCE

_6dc9:                                                                  ;$6DC9
        lda # $40
        sta VAR_050C
        ldx # $00
        stx R
        ldx # $0c
        stx ZP_TEMP_VAR
_6dd6:                                                                  ;$6DD6
        jsr _8fea
        ldx R
        bne _6de5
        cmp # $59
        beq _6e1b
        cmp # $4e
        beq _6e26
_6de5:                                                                  ;$6DE5
        sta Q
        sec 
        sbc # $30
        bcc _6e13
        cmp # $0a
        bcs _6dbf
        sta S
        lda R
        cmp # $1a
        bcs _6e13
        asl 
        sta T
        asl 
        asl 
        adc T
        adc S
        sta R
        cmp VAR_04ED
        beq _6e0a
        bcs _6e13
_6e0a:                                                                  ;$6E0A
        lda Q
        jsr print_char

        dec ZP_TEMP_VAR
        bne _6dd6
_6e13:                                                                  ;$6E13
        lda # $10
        sta VAR_050C
        lda R
        rts 
_6e1b:                                                                  ;$6E1b
        jsr print_char
        lda VAR_04ED
        sta R
        jmp _6e13
_6e26:                                                                  ;$6E26
        jsr print_char
        lda # $00
        sta R
        jmp _6e13
_6e30:                                                                  ;$6E30
        jsr print_newline

.import TKN_FLIGHT_QUANTITY:direct
        lda # TKN_FLIGHT_QUANTITY
        jsr _723c

        jsr _7627
        ldy CARGO_ITEM          ; item index?
        jmp _6e5d


sell_cargo:                                                             ;$6E41
;===============================================================================
; sell cargo screen
;
;-------------------------------------------------------------------------------
        lda # page::sell_cargo
        jsr set_page_6a2f

        lda # 10
       .set_cursor_col

.import TKN_FLIGHT_SELL:direct
        lda # TKN_FLIGHT_SELL
        jsr print_flight_token

.import TKN_FLIGHT_CARGO:direct
        lda # TKN_FLIGHT_CARGO
        jsr print_flight_token_and_divider

        jsr print_newline
_6e58:                                                                  ;$6E58
        ldy # $00
_6e5a:                                                                  ;$6E5a
        sty CARGO_ITEM          ; item index?
_6e5d:                                                                  ;$6E5d
        ldx PLAYER_CARGO, y     ; cargo qty?
       .bze _6eca               ; none of that cargo

        tya 
        asl 
        asl 
        tay 
        lda _90a6, y
        sta ZP_8F
       .phx                     ; push X to stack (via A)
        jsr print_newline_para

        clc 
        lda CARGO_ITEM          ; item index?

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"

.import TKN_FLIGHT_CARGO_TYPES:direct
        adc # TKN_FLIGHT_CARGO_TYPES
        jsr print_flight_token

        lda # 14
       .set_cursor_col

        pla 
        tax 
        sta VAR_04ED
        clc 
        jsr print_tiny_value
        jsr _72b8

        lda ZP_SCREEN
        cmp # $04
        bne _6eca

.import TKN_FLIGHT_SELL:direct
        lda # TKN_FLIGHT_SELL
        jsr print_flight_token

.import MSG_DOCKED_YES_OR_NO:direct
        lda # MSG_DOCKED_YES_OR_NO
        jsr print_docked_str

        jsr _6dc9
        beq _6eca
        bcs _6e30
        lda CARGO_ITEM          ; item index?

        ldx # %11111111
        stx ZP_PRINT_CASE
        jsr _7246
        ldy CARGO_ITEM          ; item index?
        lda PLAYER_CARGO, y
        sec 
        sbc R
        sta PLAYER_CARGO, y
        lda R
        sta ZP_VAR_P1
        lda VAR_04EC
        sta Q
        jsr _74a2
        jsr give_cash           ; pay monies

        lda # %00000000
        sta ZP_PRINT_CASE
_6eca:                                                                  ;$6ECA
        ldy CARGO_ITEM          ; item index?
        iny 
        cpy # $11
        bcc _6e5a

        lda ZP_SCREEN
        cmp # $04
        bne _6ede

        jsr _7627
        jmp _6dbf
_6ede:                                                                  ;$6EDE
        jsr print_newline_para
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
.import MSG_DOCKED_CUDDLY:direct

        clc 
        adc # MSG_DOCKED_CUDDLY
        jsr print_docked_str

        ; print "LITTLE TRUMBLE"
.import MSG_DOCKED_LITTLE_TRUMBLE:direct
        lda # MSG_DOCKED_LITTLE_TRUMBLE
        jsr print_docked_str

        ; more than 1?
        lda PLAYER_TRUMBLES_HI
       .bnz :+
        ldx PLAYER_TRUMBLES_LO
        dex 
        beq _6ee9

:       lda # $73               ;="S"                                   ;$6F11
        jmp print_char


inventory_screen:                                                       ;$6F16
;===============================================================================
        lda # page::inventory
        jsr set_page_6a2f

        lda # 11
       .set_cursor_col

.import TKN_FLIGHT_INVENTORY:direct
        lda # TKN_FLIGHT_INVENTORY
        jsr print_flight_token_and_newpara

        jsr draw_line_divider_title
        jsr print_fuel_and_cash
        lda SHIP_HOLD           ; cargo capacity of the player's ship
        cmp # $1a
        bcc :+

.import TKN_FLIGHT_LARGE_CARGO_BAY:direct
        lda # TKN_FLIGHT_LARGE_CARGO_BAY
        jsr print_flight_token

:       jmp _6e58                                                       ;$6F37


; dead code?
;
_6f3a:                                                                  ;$6F3a
;===============================================================================
        jsr print_flight_token

        ; print "(Y/N)?"
.import MSG_DOCKED_YES_OR_NO:direct
        lda # MSG_DOCKED_YES_OR_NO
        jsr print_docked_str

        jsr _8fea
        ora # %00100000
        cmp # $79
        beq :+

        lda # $6e               ;="N"
        jmp print_char
:       jsr print_char                                                  ;$6F50
        sec 
        rts 


_6f55:                                                                  ;$6F55
;===============================================================================
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

        ; fallthrough
        ; ...

_6f82:                                                                  ;$6F82
;===============================================================================
        lda ZP_SCREEN
        bmi _6fa9

        lda TSYSTEM_POS_X
        sta ZP_8E
        lda TSYSTEM_POS_Y
        lsr 
        sta ZP_8F
        lda # $04
        sta ZP_90
        jmp draw_crosshair


_6f98:                                                                  ;$6F98
;===============================================================================
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
        jmp draw_crosshair


local_chart:                                                            ;$6FDB
;===============================================================================
; short-range (local) chart:
;
;-------------------------------------------------------------------------------
        ; set the clipping height?
        ;
        lda # 199               ; (height of screen)
        sta ZP_VIEWH
        sta ZP_B7

        lda # page::chart_local ; screen-ID for short-range (local) chart
        jsr set_page            ; switch pages, clearing the screen

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # 16                ; BBC: set colour palette for viewport
        jsr _DOVDU19            ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ; print the page title:
        ;
        lda # 7
       .set_cursor_col

.import TKN_FLIGHT_SHORT_RANGE_CHART:direct
        lda # TKN_FLIGHT_SHORT_RANGE_CHART
        jsr print_flight_token_and_divider

        jsr draw_range_circle
        jsr _6f82
        jsr get_galaxy_seed

        lda # $00
        sta ZP_VAR_XX20

        ; to avoid names overlapping, the chart will not print any two system
        ; names on the same screen row (even if they would fit). the zero-page
        ; 'current' ship instance is erased to use that space
        ;
        ldx # 24                ; make room for 24 screen rows
:       sta ZP_SHIP, x                                                  ;$7004
        dex 
        bpl :-

        ;-----------------------------------------------------------------------
        ; loop through all planets in the galaxy
        ; and display those visible locally:
        ;
        ; the X-coordinate of a planet is taken from the hi-byte of W1:
        ; <http://wiki.alioth.net/index.php/Random_number_generator>
        ;
@loop:  lda ZP_SEED_W1_HI                                               ;$7009
        sec                     ; subtract our current X location,
        sbc PSYSTEM_POS_X       ;  from the given planet
        bcs :+

        ; we want to reduce the relative distance to a positive number;
        ; negate the result when the subtraction happens to do so
        eor # %11111111         ; flip the bits,
        adc # 1                 ; add 1: -ve => +ve

        ; is the given planet within the
        ; visible range of the local chart?
        ;
:       cmp # 20                                                        ;$7015
        bcs @next               ; no? move to the next planet

        ; the Y-coordinate of a planet is taken from the hi-byte of W0:
        ; <http://wiki.alioth.net/index.php/Random_number_generator>
        ;
        lda ZP_SEED_W0_HI
        sec                     ; subtract our current Y location,
        sbc PSYSTEM_POS_Y       ; from the given planet
        bcs :+

        ; we want to reduce the relative distance to a positive number;
        ; negate the result when the subtraction happens to do so
        eor # %11111111         ; flip the bits,
        adc # 1                 ; add 1: -ve => +ve

        ; within visible range of the local chart(?)
:       cmp # $26               ;=38                                    ;$7025
        bcs @next               ; no? move to the next planet

        ; planet is visible locally:
        ;-----------------------------------------------------------------------
        lda ZP_SEED_W1_HI       ; get planet X-coordinate again
        sec                     ; subtract from our current location,
        sbc PSYSTEM_POS_X       ; to get the relative X-coord (signed)
        
        ; scale the local chart to 4x zoom, horizontally
        asl                     ; zoom, enhance
        asl                     ; again

        ; offset so that the centre-point
        ; is in the middle of the screen
        adc # 104               ; why 104?
        sta ZP_VAR_XX12_0

        ; for printing the planet name,
        ; work out the column number
        lsr                     ; /2 
        lsr                     ; /4
        lsr                     ; /8
        clc 
        adc # 1
       .set_cursor_col

        ;-----------------------------------------------------------------------
        lda ZP_SEED_W0_HI       ; get planet Y-coordinate again
        sec                     ; subtract from our current location,
        sbc PSYSTEM_POS_Y       ; to get the relative X-coord (signed)

        ; the Y-range is at 2x scale, not 4x so that the galaxy map
        ; fits on the screen, 256x128, rather than 256x256
        ;
        asl                     ; zoom, enhance!

        ; offset so that the centre-point
        ; is in the middle of the screen
        ;
        adc # 90                ; why 90?
        sta ZP_CIRCLE_YPOS_LO   ; set circle Y-position, lo-byte

        ; for printing the planet name,
        ; work out the row number
        lsr                     ; /2
        lsr                     ; /4
        lsr                     ; /8
        tay 

        ; check if a planet-name has already
        ; been printed on this row:
        ;
        ldx ZP_SHIP, y          ; look up the current row
       .bze @name               ; empty? ok, print name here
        iny 
        ldx ZP_SHIP, y          ; look up the row below
       .bze @name               ; empty? ok, print name here
        dey 
        dey 
        ldx ZP_SHIP, y          ; look up the row above
       .bnz @draw               ; in use? can't print name anywhere, skip

        ; print star's name:
        ;-----------------------------------------------------------------------
@name:  tya                     ; set the row number                    ;$705C
       .set_cursor_row          ; to print at

        ; we cannot print within the title space,
        ; so skip attempting to print there or above
        cpy # 3
        bcc @next
        ; mark the given row as "full" so other
        ; other names are not printed there
        lda # $ff
        sta ZP_SHIP, y

        ; capitalise the first letter of the name
        lda # %10000000
        sta ZP_PRINT_CASE

        ; print system's name?
        jsr _76e9

        ; draw the star's shape:
        ;-----------------------------------------------------------------------
        ; NOTE: the X-position on screen of a circle is a 16-bit number
        ; (this is to handle suns, where the centre of the sun can be
        ; off-screen, but the sides can be visible on-screen)
        ;
@draw:  lda # $00               ; clear some variables:                 ;$7070
        sta ZP_CIRCLE_XPOS_HI   ; set circle X-position hi-byte to 0
        sta ZP_CIRCLE_YPOS_HI   ; set circle Y-position hi-byte to 0
        sta ZP_CIRCLE_RADIUS_HI ; circle-radius hi-byte(?)

        lda ZP_VAR_XX12_0       ; retrieve screen X-positon of star
        sta ZP_CIRCLE_XPOS_LO   ; set the circle X-position lo-byte

        ; the hi-byte of W2 is used to calculate both the star's
        ; radius and determine the first two letters of the planet's name:
        ; <http://wiki.alioth.net/index.php/Random_number_generator>
        ;
        lda ZP_SEED_W2_HI
        and # %00000001
        adc # $02
        sta ZP_CIRCLE_RADIUS

        ; draw the star:
        ;
        ; TODO: investigate if we can remember the first & last scanlines
        ;       used for drawing a circle, and do away with the need to
        ;       clear the circle buffer -- twice! -- every time
        ;
        jsr clear_sun_buffer
        jsr draw_sun
        jsr clear_sun_buffer

        ; move to next planet in the galaxy
        ;-----------------------------------------------------------------------
        ; the randomiser will cycle the seed bytes such that the next planet's
        ; information can be extracted. every 256 cycles, it will repeat, so we
        ; don't need to backup / restore the seed
        ;
@next:  jsr randomize                                                   ;$708D
        inc ZP_VAR_XX20         ; increment the planet counter
       .bze :+                  ; 256 planets done? exit
        jmp @loop               ; more planets to go, loop

        ;-----------------------------------------------------------------------
:       lda # $00               ;?                                      ;$7097
        sta ZP_B7
        lda # VIEWPORT_HEIGHT-1
        sta ZP_VIEWH

        rts 


get_galaxy_seed:                                        ; BBC: TT81     ;$70A0
;===============================================================================
; reset the seed to that of the current galaxy:
;
;-------------------------------------------------------------------------------
        ldx # 5                 ; seed is 6 bytes (3 words)
:       lda SEED_GALAXY, x      ; copy from the galaxy seed             ;$70A2
        sta ZP_SEED, x          ;  to the "working" seed
        dex 
        bpl :-

        rts 


_TT111:                                                 ; BBC: TT111    ;$70AB
;===============================================================================
        jsr get_galaxy_seed
        ldy # $7f
        sty T
        lda # $00
        sta U
_70b6:                                                                  ;$70B6
        lda ZP_SEED_W1_HI
        sec 
        sbc TSYSTEM_POS_X
        bcs _70c2
        eor # %11111111
        adc # $01
_70c2:                                                                  ;$70C2
        lsr 
        sta S
        lda ZP_SEED_W0_HI
        sec 
        sbc TSYSTEM_POS_Y
        bcs _70d1
        eor # %11111111
        adc # $01
_70d1:                                                                  ;$70D1
        lsr 
        clc 
        adc S
        cmp T
        bcs _70e8
        sta T
        ldx # 5
_70dd:                                                                  ;$70DD
        lda ZP_SEED, x
        sta ZP_8E, x
        dex 
        bpl _70dd
        lda U
        sta ZP_VAR_Z
_70e8:                                                                  ;$70E8
        jsr randomize
        inc U
        bne _70b6
        ldx # $05
_70f1:                                                                  ;$70F1
        lda ZP_8E, x
        sta ZP_SEED, x
        dex 
        bpl _70f1

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
        sta ZP_VALUE_pt1        ; radius?
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
        adc ZP_VALUE_pt1        ; radius?
        sta Q
        pla 
        adc ZP_VALUE_pt2
        bcc _7135
        lda # $ff
_7135:                                                                  ;$7135
        sta R
        jsr square_root
        lda Q
        asl 
        ldx # $00
        stx TSYSTEM_DISTANCE_HI
        rol TSYSTEM_DISTANCE_HI
        asl 
        rol TSYSTEM_DISTANCE_HI
        sta TSYSTEM_DISTANCE_LO
        jmp get_system_info


_714f:                                                                  ;$714F
;===============================================================================
        jsr tkn_docked_fn15

        lda # 15
       .set_cursor_col

        ; print "DOCKED"...
.import MSG_DOCKED_DOCKED:direct
        lda # MSG_DOCKED_DOCKED
        jmp print_docked_str

_715c:                                                                  ;$715C
        lda ZP_IS_DOCKED
        bne _714f

        lda ZP_66               ; hyperspace countdown (outer)?
        beq _7165

        rts 

_7165:                                                                  ;$7165
        jsr get_ctrl
        bmi _71ca

        lda ZP_SCREEN           ; are we in the cockpit-view?
        beq _71c4               ; yes? skip ahead

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
       .set_cursor_col

        lda # 23                ; screen row 23(?)
        ldy ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :+                  ; no? skip over

        lda # 17                ; screen row 17(?)
:      .set_cursor_row                                                  ;$7196

        lda # %00000000
        sta ZP_PRINT_CASE

.import TKN_FLIGHT_HYPERSPACE:direct
        lda # TKN_FLIGHT_HYPERSPACE
        jsr print_flight_token

        lda TSYSTEM_DISTANCE_HI
        bne _71af
        lda PLAYER_FUEL
        cmp TSYSTEM_DISTANCE_LO
        bcs _71b2
_71af:                                                                  ;$71AF
        jmp _723a

_71b2:                                                                  ;$71B2
.import TKN_FLIGHT_HYPHEN:direct
        lda # TKN_FLIGHT_HYPHEN
        jsr print_flight_token

        jsr _76e9
        lda # $0f
_71bc:                                                                  ;$71BC
        sta ZP_66               ; hyperspace countdown -- outer
        sta ZP_65               ; hyperspace countdown -- inner
        tax 
        jmp _7224

_71c4:                                                                  ;$71C4
        jsr _TT111
        jmp _7176

_71ca:                                                                  ;$71CA
        ldx PLAYER_GDRIVE
        beq _71f2 + 1           ; bug or optimisation?
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
        lda SEED_GALAXY, x
        asl 
        rol SEED_GALAXY, x
        dex 
        bpl _71e8
_71f2:  ; the $60 also forms an RTS, jumped to from just after _71ca    ;$71F2
        lda # $60

;71f4:
        sta TSYSTEM_POS_X
        sta TSYSTEM_POS_Y
        jsr _741c
        jsr _TT111
        ldx # $05

:       lda ZP_SEED, x                                                  ;$7202
        sta VAR_04FA, x
        dex 
        bpl :-

        ldx # $00
        stx TSYSTEM_DISTANCE_LO
        stx TSYSTEM_DISTANCE_HI
        
.import TKN_FLIGHT_GALACTIC_HYPERSPACE:direct
        lda # TKN_FLIGHT_GALACTIC_HYPERSPACE
        jsr _MESS               ; print on-screen message?

        ; fallthrough
        ; ...

_jmp:                                                   ; BBC: jmp      ;$7217
;===============================================================================
        lda TSYSTEM_POS_X
        sta PSYSTEM_POS_X
        lda TSYSTEM_POS_Y
        sta PSYSTEM_POS_Y
        rts 

_7224:                                                                  ;$7224
;===============================================================================
        lda # 1
       .set_cursor_col
       .set_cursor_row

        ldy # $00
        clc 
        lda # $03
        jmp print_medium_value


print_int16:                                                            ;$7234
;===============================================================================
; print 16-bit value in X/Y, without decimal point:
;-------------------------------------------------------------------------------
        clc 

        ; fallthrough
        ; ...

print_num16:                                            ; BBC: pr5      ;$7235
;===============================================================================
; print 16-bit value in X/Y: -- decimal point included if carry set
;-------------------------------------------------------------------------------
        lda # $05               ; max. no. digits -- is this 5 or 6?
        jmp print_medium_value


_723a:                                                                  ;$723A
.import TKN_FLIGHT_RANGE:direct
        lda # TKN_FLIGHT_RANGE

_723c:                                                                  ;$723C
        jsr print_flight_token

.import TKN_FLIGHT_QMARK:direct
        lda # TKN_FLIGHT_QMARK
        jmp print_flight_token


_7244:                                                                  ;$7244
;===============================================================================
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
       .set_cursor_col

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"
.import TKN_FLIGHT_CARGO_TYPES:direct

        pla 
        adc # TKN_FLIGHT_CARGO_TYPES
        jsr print_flight_token

        lda # 14
       .set_cursor_col

        ldx ZP_8E
        lda _90a6, x
        sta ZP_8F
        lda MARKET_RANDOM
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
        ldx MARKET_FOOD, y
        stx VAR_04ED
        clc 
        beq _72af
        jsr print_small_value
        jmp _72b8
_72af:                                                                  ;$72AF
        lda # 25
       .set_cursor_col

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

.import TKN_FLIGHT__:direct     ;=" "
        lda # TKN_FLIGHT__
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


_72db:                                                                  ;$72DB
;===============================================================================
        lda # 17
       .set_cursor_col

        lda # $ff
        bne _72c7

market_screen:                                                          ;$72E4

        lda # page::market
        jsr set_page_6a2f

        lda # 5
       .set_cursor_col

.import TKN_FLIGHT_MARKET_PRICES:direct
        lda # TKN_FLIGHT_MARKET_PRICES
        jsr print_flight_token_and_divider

        lda # 3
       .set_cursor_row

        jsr _72db

        lda # 6
       .set_cursor_row

        lda # $00
        sta CARGO_ITEM          ; item index?
_7305:                                                                  ;$7305
        ldx # %10000000
        stx ZP_PRINT_CASE
        jsr _7246
       .cursor_down
        inc CARGO_ITEM          ; item index?
        lda CARGO_ITEM          ; item index?
        cmp # $11
        bcc _7305
        rts 


_731a:                                                                  ;$731A
;===============================================================================
        lda ZP_8F
        and # %00011111
        ldy PSYSTEM_ECONOMY
        sta ZP_90
        clc 
        lda # $00
        sta MARKET_ALIENS

:       dey                                                             ;$7329
        bmi :+
        adc ZP_90
        jmp :-

:       sta ZP_91                                                       ;$7331
        rts 

;===============================================================================

;7334 - dead code?

        jsr _TT111
_7337:                                                                  ;$7337
        jsr _jmp

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
        sta MARKET_RANDOM

        ldx # $00
        stx ZP_VAR_XX4
_7365:                                                                  ;$7365
        lda _90a6, x
        sta ZP_8F
        jsr _731a
        lda _90a8, x
        and MARKET_RANDOM
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
        ldy ZP_VAR_XX4
        and # %00111111
        sta MARKET_FOOD, y
        iny 
        tya 
        sta ZP_VAR_XX4
        asl 
        asl 
        tax 
        cmp # $3f
        bcc _7365
        rts 


_739b:                                                                  ;$739B
;===============================================================================
; spawn in a thargoid?
;-------------------------------------------------------------------------------
        jsr _848d

        lda # %11111111
        sta ZP_SHIP_ATTACK

        ; spawn a thargoid!
        lda # HULL_THARGOID
        jsr spawn_ship

        ; and one thargon to go with it!
        lda # HULL_THARGON
        jmp spawn_ship


_73ac:                                                                  ;$73AC
;===============================================================================
        lsr PLAYER_COMPETITION
        sec 
        rol PLAYER_COMPETITION
_73b3:                                                                  ;$73B3
        lda # $03               ;?
        jsr set_page

        jsr _3795
        jsr _83df
        sty IS_WITCHSPACE
_73c1:                                                                  ;$73C1
        jsr _739b
        ; how many thargoids are present?
        lda # $03
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        cmp .loword( SHIP_TYPES + HULL_THARGOID )
        bcs _73c1
        sta DUST_COUNT          ; number of dust particles

        ; change to cockpit front view
        ldx # $00               ; =front view
        jsr _a6ba               ; switch to cockpit

        lda PSYSTEM_POS_Y
        eor # %00011111
        sta PSYSTEM_POS_Y

        rts 


_73dc:                                                                  ;$73DC
        rts 

_73dd:                                                                  ;$73DD
;===============================================================================
        lda PLAYER_FUEL
        sec 
        sbc TSYSTEM_DISTANCE_LO
        bcs :+

        lda # $00
:       sta PLAYER_FUEL                                                 ;$73E8

        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :+                  ; no? skip over

        jsr set_page            ; switch to cockpit view (A = 0)
        jsr _3795

:       jsr get_ctrl                                                    ;$73F5
        and _PATG
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

        ; changes the screen page, without setting `ZP_SCREEN`
        jsr _set_page

        lda ZP_SCREEN
       .bnz _7452
        inc ZP_SCREEN

_741c:  ; launch ship from docking?                                     ;$741C
        ldx ZP_IS_DOCKED
        beq _744b
        jsr _379e
        jsr _83df
        jsr _TT111
        inc ZP_SHIP_ZPOS_SIGN
        jsr _7a8c
        lda # $80
        sta ZP_SHIP_ZPOS_SIGN
        inc ZP_SHIP_ZPOS_HI
        jsr _7c24
        lda # $0c
        sta ZP_PLAYER_SPEED
        jsr illegal_cargo
        ora PLAYER_LEGAL
        sta PLAYER_LEGAL

        lda # $ff               ;?
        sta ZP_SCREEN

        jsr _37b2
_744b:                                                                  ;$744B
        ldx # $00               ; change cockpit view direction
        stx ZP_IS_DOCKED
        jmp _a6ba

_7452:                                                                  ;$7452
        bmi _7457
        jmp galactic_chart
_7457:                                                                  ;$7457
        jmp local_chart


; increase / decrease cash
;
; TODO: must fix the overflow bug here
;       (earning more than 64K Cr at once fails)

_745a:                                                                  ;$745A
;===============================================================================
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

        ; fallthrough
        ; ...

give_cash:                                              ; BBC: MCASH    ;$7481
;===============================================================================
; give the player cash:
; 
; in:   X                       cash-value, lo-byte
;       Y                       cash-value, hi-byte
;-------------------------------------------------------------------------------
.export give_cash

        ; note that the cash total is a big-endian 4-byte number
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


_74a2:                                                                  ;$74A2
;===============================================================================
        jsr multiply_unsigned_PQ

        ; fallthrough
        ; ...

_74a5:                                                                  ;$74A5
;===============================================================================
        asl ZP_VAR_P1
        rol 
        asl ZP_VAR_P1
        rol 
        tay 
        ldx ZP_VAR_P1

        rts 


.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .byte   $52, $2e, $44, $2e, $43, $4f ,$44, $45  ;="R.D.CODE"    ;$74AF
        .byte   $0d                                     ;=\n
.endif  ;///////////////////////////////////////////////////////////////////////


.segment        "CODE_74B8"                                             ;$74B8
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_74b8:   jmp _BAY                                                       ;$74B8

equipment_screen:                                                       ;$74BB
;===============================================================================
; switches to the "buy equipment" screen?
; TODO: is this the player status/equipment screen instead?
;
;-------------------------------------------------------------------------------
        lda # page::buy_equip   ; change the screen to a menu page,
        jsr set_page_6a2f       ; clearing off the HUD if present

        lda # 12
       .set_cursor_col

.import TKN_FLIGHT_EQUIP:direct
        lda # TKN_FLIGHT_EQUIP
        jsr print_flight_token_and_space

.import TKN_FLIGHT_SHIP:direct
        lda # TKN_FLIGHT_SHIP
        jsr print_flight_token_and_divider

        lda # %10000000
        sta ZP_PRINT_CASE
       .cursor_down
        lda PSYSTEM_TECHLEVEL
        clc 
        adc # $03
        cmp # $0c
        bcc _74e2
        lda # $0e
_74e2:                                                                  ;$74E2
        sta Q
        sta VAR_04ED
        inc Q
        lda # $46
        sec 
        sbc PLAYER_FUEL
        asl 
        sta price_list+0
        ldx # $01
_74f5:                                                                  ;$74F5
        stx ZP_VAR_XX13
        jsr print_newline
        ldx ZP_VAR_XX13
        clc 
        jsr print_tiny_value
        jsr print_space

        lda ZP_VAR_XX13
        clc 
        adc # $68               ; TODO: what's being calculated here?
        jsr print_flight_token

        lda ZP_VAR_XX13
        jsr _763f
        sec 

        lda # 25
       .set_cursor_col

        lda # $06
        jsr print_medium_value
        ldx ZP_VAR_XX13
        inx 
        cpx Q
        bcc _74f5
        jsr tkn_docked_fn15

.import TKN_FLIGHT_ITEM:direct
        lda # TKN_FLIGHT_ITEM
        jsr _723c

        jsr _6dc9
        beq _74b8
        bcs _74b8
        sbc # $00
        pha 

        lda # 2
       .set_cursor_col
       .cursor_down

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

        jsr _msblob             ; update missile blocks on HUD
        lda # $01
_755f:                                                                  ;$755F
.import TKN_FLIGHT_LARGE_CARGO_BAY:direct
        ldy # TKN_FLIGHT_LARGE_CARGO_BAY

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
.import TKN_FLIGHT_FUEL_SCOOPS:direct
        ldy # TKN_FLIGHT_FUEL_SCOOPS
        cmp # $06
        bne _75bc
        ldx PLAYER_SCOOP
        beq _75b9
_75a1:                                                                  ;$75A1
        sty ZP_VALUE_pt1        ; (being used as a temp value)
        jsr _7642
        jsr give_cash           ; pay monies
        lda ZP_VALUE_pt1        ; (being used as a temp value)
        jsr print_flight_token_and_space

.import TKN_FLIGHT_PRESENT:direct
        lda # TKN_FLIGHT_PRESENT
        jsr print_flight_token
_75b3:                                                                  ;$75B3
        jsr _7627
        jmp _BAY


_75b9:                                                                  ;$75B9
;===============================================================================
        dec PLAYER_SCOOP
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
        ldx PLAYER_EUNIT
        bne _75a1
        inc PLAYER_EUNIT
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

        ; print "CASH:"
.import TKN_FLIGHT_CASH_:direct
        lda # TKN_FLIGHT_CASH_
        jsr print_flight_token_and_space
_7627:                                                                  ;$7627
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_05
.endif  ;///////////////////////////////////////////////////////////////////////

        ldy # 50
        jmp wait_frames


_762f:                                                                  ;$762F
;===============================================================================
        jsr _7642
        jsr _745a
        bcs _764b

.import TKN_FLIGHT_CASH:direct
        lda # TKN_FLIGHT_CASH
        jsr _723c

        jmp _75b3


_763f:                                                                  ;$763F
;===============================================================================
        sec 
        sbc # $01
_7642:                                                                  ;$7642
        asl 
        tay 
        ldx price_list+0, y
        lda price_list+1, y
        tay 
_764b:                                                                  ;$764B
        rts 


_764c:                                                                  ;$764C
;===============================================================================
        lda PSYSTEM_TECHLEVEL
        cmp # $08
        bcc _7658

        lda # $20               ;?
        jsr set_page
_7658:                                                                  ;$7658
        lda # 16
        tay 
       .set_cursor_row
_765e:                                                                  ;$765E
        lda # 12
       .set_cursor_col

        ; print character and space
        tya 
        clc 
.import TKN_FLIGHT__:direct     ; (beginning of ASCII flight-tokens)
        adc # TKN_FLIGHT__
        jsr print_flight_token_and_space

        lda ZP_CURSOR_ROW
        clc 
.import TKN_FLIGHT_P:direct
        adc # TKN_FLIGHT_P
        jsr print_flight_token

       .cursor_down
        ldy ZP_CURSOR_ROW
        cpy # $14
        bcc _765e
        jsr tkn_docked_fn15
_767e:                                                                  ;$767E
.import TKN_FLIGHT_VIEW:direct
        lda # TKN_FLIGHT_VIEW
        jsr _723c

        jsr _8fea
        sec 
        sbc # $30
        cmp # $04
        bcc _7693
        jsr tkn_docked_fn15
        jmp _767e

_7693:                                                                  ;$7693
        tax 
        rts 


_7695:                                                                  ;$7695
;===============================================================================
        jsr _6f82
        jsr _TT111
        jsr _6f82
        jmp tkn_docked_fn15


_76a1:                                                                  ;$76A1
;===============================================================================
        sta ZP_TEMP_VAR
        
        lda PLAYER_LASERS, x
        beq _76c7               ; no laser on this view, skip
        
        ldy # $04
        cmp # $0f               ; laser-strength 15
        beq :+
        ldy # $05
        cmp # laser::beam | $0f ; beam-laser strength 15
        beq :+
        ldy # $0c
        cmp # laser::beam + $17 ; beam-laser strength 23 (military laser?)
        beq :+
        
        ldy # $0d
:       stx ZP_VAR_Z                                                    ;$76BC
        tya 
        jsr _7642
        jsr give_cash           ; pay monies
        ldx ZP_VAR_Z
_76c7:                                                                  ;$76C7
        lda ZP_TEMP_VAR
        sta PLAYER_LASERS, x
        rts 


price_list:                                                             ;$76CD
;===============================================================================
; the associations here were gleaned from Andy McFadden's Apple ][ Elite
; disassembly: <https://6502disassembly.com/a2-elite/Elite.html>
;
;-------------------------------------------------------------------------------
        .word   1               ; fuel -- updated according to ship qty
        .word   300             ; missile: 30.0 Cr
        .word   4000            ; large cargo bay: 400.0 Cr
        .word   6000            ; E.C.M: 600.0 Cr
        .word   4000            ; pulse laser: 400.0 Cr
        .word   10000           ; beam laser: 1000.0 Cr
        .word   5250            ; fuel scoops: 525.0 Cr
        .word   10000           ; escape pod: 1000.0 Cr
        .word   9000            ; energy bomb: 900.0 Cr
        .word   15000           ; energy unit: 1500.0 Cr
        .word   10000           ; docking computer: 1000.0 Cr
        .word   50000           ; galatic hyperdrive: 5000.0 Cr
        .word   60000           ; military laser: 6000.0 Cr
        .word   8000            ; mining laser: 800.0 Cr


_76e9:                                                                  ;$76E9
;===============================================================================
        ; backup seed?
        ldx # $05
:       lda ZP_SEED, x                                                  ;$76EB
        sta ZP_8E, x
        dex 
        bpl :-

        ldy # $03
        bit ZP_SEED_W0_LO
        bvs :+
        dey 

:       sty T                                                           ;$76F9

@_76fb:                                                                 ;$76FB
        ; print a random letter pair?:
        ;-----------------------------------------------------------------------
        ; TODO: this effectively hard-codes the order of flight-tokens
        lda ZP_SEED_W2_HI
        and # %00011111
        beq :+
        ora # %10000000         ; flight-token letter pairs $80-$9F
        jsr print_flight_token

:       jsr randomize_once                                              ;$7706
        dec T
        bpl @_76fb
        ldx # $05

        ;-----------------------------------------------------------------------
:       lda ZP_8E, x                                                    ;$770F
        sta ZP_SEED, x
        dex 
        bpl :-

        rts 


; NOTE: in the original code, segment "CODE_7717" appears here          ;$7717


.segment        "CODE_784F"                                             ;$784F
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

swap_zp_shadow:                                                         ;$784F
;===============================================================================
; swap zero-page with its shadow
; (copies $36...$FF to $CE36...$CEFF)
;-------------------------------------------------------------------------------
        ldx # $36               ; $36 makes no sense
:       lda $00, x              ; read A from the zero-page             ;$7851
        ldy ELITE_ZP_SHADOW, x  ; read Y from the shadow
        sta ELITE_ZP_SHADOW, x  ; write A to the shadow
        sty $00, x              ; write Y to the zero-page
        inx 
       .bnz :-

        rts 

_785f:                                                                  ;$785F
;===============================================================================
; unused / unreferenced?
;
        lda ZP_SHIP_STATE
        ora # state::exploding | state::debris
        sta ZP_SHIP_STATE
rts_7865:
        rts 


draw_explosion:                                         ; BBC: DOEXP    ;$7866
;===============================================================================
; draw explosion cloud:
;-------------------------------------------------------------------------------
        lda ZP_SHIP_STATE
        and # state::firing
        beq _786f
        jsr _78d6
_786f:                                                                  ;$786F
        lda ZP_SHIP_ZPOS_LO
        sta T
        lda ZP_SHIP_ZPOS_HI
        cmp # $20
        bcc _787d
        lda # $fe
        bne _7885
_787d:                                                                  ;$787D
        asl T
        rol 
        asl T
        rol 
        sec 
        rol 
_7885:                                                                  ;$7885
        sta Q
        ldy # $01
        lda [ZP_SHIP_HEAP], y
        sta VAR_050D
        adc # $04
        bcs _785f
        sta [ZP_SHIP_HEAP], y
        jsr divide_unsigned
        lda ZP_VAR_P1
        cmp # $1c
        bcc _78a1
        lda # $fe
        bne _78aa
_78a1:                                                                  ;$78A1
        asl R
        rol 
        asl R
        rol 
        asl R
        rol 
_78aa:                                                                  ;$78AA
        dey 
        sta [ZP_SHIP_HEAP], y
        lda ZP_SHIP_STATE
        and # state::firing ^$FF        ;=%10111111
        sta ZP_SHIP_STATE
        and # state::redraw

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; in the original code, this branches to an `rts` instruction
        ; way, way back which is now in another segement ("CODE_7717")
        ; so we have to specify this branch destination manually
        ;
        beq *-($78b5-$784e)     ;=`rts_784e`
.else   ;///////////////////////////////////////////////////////////////////////
        ; for elite-harmless we can pick a nearer RTS within the segment
        beq rts_7865
.endif  ;///////////////////////////////////////////////////////////////////////
        ldy # $02
        lda [ZP_SHIP_HEAP], y
        tay 
_78bc:                                                                  ;$78BC
        lda ZP_F9, y            ;???
        sta [ZP_SHIP_HEAP], y
        dey 
        cpy # $06
        bne _78bc
        lda ZP_SHIP_STATE
        ora # state::firing
        sta ZP_SHIP_STATE
        ldy VAR_050D
        cpy # $12
        bne _78d6

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jmp _795a               ; in the original, this is a double-jump
.else   ;///////////////////////////////////////////////////////////////////////
        jmp _79a9
.endif  ;///////////////////////////////////////////////////////////////////////

_78d6:                                                                  ;$78D6
        ldy # $00
        lda [ZP_SHIP_HEAP], y
        sta Q
        iny
        lda [ZP_SHIP_HEAP], y
        bpl _78e3
        eor # %11111111
_78e3:                                                                  ;$78E3
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta U
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_A8
        lda ZP_GOATSOUP_pt2     ;?
        pha 
        ldy # $06
_78f5:                                                                  ;$78F5
        ldx # $03
_78f7:                                                                  ;$78F7
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_SHIP01_XPOS_pt1, x
        dex 
        bpl _78f7
        sty ZP_TEMP_COUNTER1
        ldy # $02
_7903:                                                                  ;$7903
        iny 
        lda [ZP_SHIP_HEAP], y
        eor ZP_TEMP_COUNTER1
        sta $ffff, y                    ;!?
        cpy # $06
        bne _7903
        ldy U
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
        lda ZP_SHIP01_XPOS_pt2
        sta R
        lda ZP_SHIP01_XPOS_pt1
        jsr _7974
        bne _795d
        cpx # $8f
        bcs _795d
        stx ZP_VAR_XX15_1
        lda ZP_SHIP01_YPOS_pt1
        sta R
        lda ZP_SHIP01_XPOS_pt3
        jsr _7974
        bne _7948
        lda ZP_VAR_XX15_1
        jsr paint_particle
_7948:                                                                  ;$7948
        dey 
        bpl _7911
        ldy ZP_TEMP_COUNTER1
        cpy ZP_A8
        bcc _78f5
        pla 
        sta ZP_GOATSOUP_pt2

        lda ship_00 + Ship::zpos                                     ;=$F906
        sta ZP_GOATSOUP_pt4

        rts 


.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
_795a:                                                                  ;$795A
;===============================================================================
        jmp _79a9
;///////////////////////////////////////////////////////////////////////////////
.endif


_795d:                                                                  ;$795D
;===============================================================================
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


_7974:                                                                  ;$7974
;===============================================================================
        sta S                   ; retain A
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
        rol                     ; -> A is still random, carry is random
        bcs _7998               
        jsr _39ea               ; A=(A*Q)/256 isn't that still simply random?
        adc R                   ; A+=R
        tax                     ; why do we need x?
        lda S                   ; restore A
        adc # $00               ; add 1 on overflow?
        rts 

_7998:                                                                  ;$7998
        jsr _39ea               ; A=(A*Q)/256 isn't that still simply random?
        sta T
        lda R
        sbc T                   ; A = R-A
        tax                     ; why do we need x?
        lda S                   ; restore A
        sbc # $00               ; sub 1 on underflow?
        rts 


_79a7:                                                                  ;$79A7
;===============================================================================
        .byte   $00, $02


_79a9:                                                                  ;$79A9
;===============================================================================
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

        lda ZP_SHIP_ZPOS_HI
        cmp # $07
        lda # %11111101
        ldx # $2c
        ldy # $28
        bcs _79c0

        lda # %11111111
        ldx # $20
        ldy # $1e
_79c0:                                                                  ;$79C0
        sta VIC_SPRITE_DBLHEIGHT
        sta VIC_SPRITE_DBLWIDTH
        stx VAR_050E
        sty VAR_050F
        ldy # $00
        lda [ZP_SHIP_HEAP], y
        sta Q
        iny 
        lda [ZP_SHIP_HEAP], y
        bpl _79d9
        eor # %11111111
_79d9:                                                                  ;$79D9
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta U
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_A8
        lda ZP_GOATSOUP_pt2
        pha 
        ldy # $06
_79eb:                                                                  ;$79EB
        ldx # $03
_79ed:                                                                  ;$79ED
        iny 
        lda [ZP_SHIP_HEAP], y
        sta ZP_SHIP01_XPOS_pt1, x
        dex 
        bpl _79ed
        sty ZP_TEMP_COUNTER1
        lda ZP_SHIP01_YPOS_pt1
        clc 
        adc VAR_050E
        sta ZP_TEMP_ADDR1_LO
        lda ZP_SHIP01_XPOS_pt3
        adc # $00
        bmi _7a36
        cmp # $02
        bcs _7a36
        tax 
        lda ZP_SHIP01_XPOS_pt2
        clc 
        adc VAR_050F
        tay 
        lda ZP_SHIP01_XPOS_pt1
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
        lda [ZP_SHIP_HEAP], y
        eor ZP_TEMP_COUNTER1
        sta $ffff, y            ;!?
        cpy # $06
        bne _7a38
        ldy U
_7a46:                                                                  ;$7A46
        jsr get_random_number_clc
        sta ZP_VAR_Z
        lda ZP_SHIP01_XPOS_pt2
        sta R
        lda ZP_SHIP01_XPOS_pt1
        jsr _7974
        bne _7a86
        cpx # $8f
        bcs _7a86
        stx ZP_VAR_XX15_1
        lda ZP_SHIP01_YPOS_pt1
        sta R
        lda ZP_SHIP01_XPOS_pt3
        jsr _7974
        bne _7a6c
        lda ZP_VAR_XX15_1
        jsr paint_particle
_7a6c:                                                                  ;$7A6C
        dey 
        bpl _7a46
        ldy ZP_TEMP_COUNTER1
        cpy ZP_A8
        bcs _7a78
        jmp _79eb

_7a78:                                                                  ;$7A78
        pla 
        sta ZP_GOATSOUP_pt2     ;?

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

        lda ship_00 + Ship::zpos                                        ;=$F906
        sta ZP_GOATSOUP_pt4
        rts 

_7a86:                                                                  ;$7A86
        jsr get_random_number_clc
        jmp _7a6c


_7a8c:                                                                  ;$7A8C
;===============================================================================
        jsr _msblob             ; update missile blocks on HUD

        lda # $7f
        sta ZP_SHIP_ROLL
        sta ZP_SHIP_PITCH

        lda PSYSTEM_TECHLEVEL
        and # %00000010         ; select tech levels 2, 4, 6, 8...
        ora # %10000000         ; add high-bit (type of station?)
        jmp spawn_ship


_7a9f:                                                                  ;$7A9F
;===============================================================================
; TODO: this is Trumbles™ only code
;-------------------------------------------------------------------------------
        lda PLAYER_TRUMBLES_LO  ; does the player have any Trumbles™?
       .bze @7ac2               ; if not, skip ahead

        ; they've eaten your goods!
        lda # $00
        sta CARGO_FOOD
        sta CARGO_NARCOTICS

        jsr get_random_number   ; choose a random number
        and # %00001111         ; between 0-15
        adc PLAYER_TRUMBLES_LO
        ora # %00000100
        rol 
        sta PLAYER_TRUMBLES_LO
        rol PLAYER_TRUMBLES_HI
        bpl @7ac2
        ror PLAYER_TRUMBLES_HI  ; undo that

        ; fallthrough
        ; ...
        
@7ac2:                                                                  ;$7AC2
;===============================================================================
        lsr PLAYER_LEGAL
        jsr clear_zp_ship

        lda ZP_SEED_W0_HI
        and # %00000011
        adc # $03
        sta ZP_SHIP_ZPOS_SIGN
        ror 
        sta ZP_SHIP_XPOS_SIGN
        sta ZP_SHIP_YPOS_SIGN
        jsr _7a8c
        lda ZP_SEED_W1_HI
        and # %00000111
        ora # %10000001
        sta ZP_SHIP_ZPOS_SIGN
        lda ZP_SEED_W2_HI
        and # %00000011
        sta ZP_SHIP_XPOS_SIGN
        sta ZP_SHIP_XPOS_HI

        lda # $00
        sta ZP_SHIP_ROLL
        sta ZP_SHIP_PITCH

        lda # $81               ; TODO?
        jsr spawn_ship
_7af3:                                                                  ;$7AF3
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz _WPSHPS             ; no? skip ahead
_7af7:                                                                  ;$7AF7
        ldy DUST_COUNT          ; number of dust particles
_7afa:                                                                  ;$7AFA
        ; initialize all DUST completely random
        jsr get_random_number
        ora # %00001000         ; but Z is >= 16
        sta DUST_Z_HI, y
        sta ZP_VAR_Z
        jsr get_random_number
        sta DUST_X_HI, y
        sta ZP_VAR_XX15_0
        jsr get_random_number
        sta DUST_Y_HI, y
        sta ZP_VAR_XX15_1
        jsr draw_particle
        dey 
        bne _7afa

        ; fallthrough
        ; ...

_WPSHPS:                                                ; BBC: WPSHPS   ;$7B1A
;===============================================================================
; clear all ships from the scanner:
;-------------------------------------------------------------------------------
        ldx # 0                 ; begin with ship-slot 0
_7b1c:                                                                  ;$7B1C
        lda SHIP_SLOTS, x
        beq _7b44
        bmi _7b41
        sta ZP_SHIP_TYPE

        jsr get_ship_addr

        ldy # Ship::state
_7b2a:                                                                  ;$7B2A
        lda [ZP_SHIP_ADDR], y
        sta ZP_SHIP_XPOS_LO, y
        dey 
        bpl _7b2a
        stx ZP_PRESERVE_X
        jsr _SCAN
        ldx ZP_PRESERVE_X

        ldy # Ship::state
        lda [ZP_SHIP_ADDR], y
        and # state::exploding | state::debris | state::missiles
        sta [ZP_SHIP_ADDR], y
_7b41:                                                                  ;$7B41
        inx 
        bne _7b1c
_7b44:                                                                  ;$7B44
        ldx # $00
        stx ZP_CIRCLE_INDEX
        dex                     ; change X to $FF
        stx circle_lines_x      ; mark line-buffer-X as 'empty'
        stx circle_lines_y      ; mark line-buffer-Y as 'empty'

        ; fallthrough
        ; ...

clear_sun_buffer:                                                       ;$7B4F
;===============================================================================
; clear the sun buffer:
;-------------------------------------------------------------------------------
        ldy # 199               ; size of the sun buffer (199 scanlines)
        lda # 0                 ; erase...

        ; TODO: unrolling this a little might help
        ;
:       sta SUN_BUFFER, y       ; set to 0                              ;$7B53
        dey                     ; move to next line
       .bnz :-                  ; all lines?

        dey                     ; change Y to $FF
        sty SUN_BUFFER          ; write to first entry (TODO: why?)

        rts 

.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
original_7b5e:                                                          ;$75BE
;===============================================================================
        rts                     ; dummied-out code
;///////////////////////////////////////////////////////////////////////////////
.endif


:       dex                     ; overflow, set to max (255)            ;$7B5F
        rts 

recharge_shield:                                        ; BBC: SHD      ;$7B61
;===============================================================================
; recharge a shield by one tick:
;
; in:   X                       selected shield current energy level
;-------------------------------------------------------------------------------
.export recharge_shield

        inx                     ; add 1 to shield level
       .bze :-                  ; did we overflow? (255 -> 0)
_7b64:                                                                  ;$7B64
        dec PLAYER_ENERGY       ; take energy from the ship's main banks
        php 
        bne :+
        inc PLAYER_ENERGY
:       plp                                                             ;$7B6D
        rts 


_7b6f:                                                                  ;$7B6F
;===============================================================================
        jsr _b09d               ; draw multi-color pixel?

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        bne _7ba8

        jsr _SPS4

        jmp _7bab


_7b7d:                                                                  ;$7B7D
;===============================================================================
        asl 
        tax 
        lda # $00
        ror 
        tay 
        lda # $14
        sta Q
        txa 
        jsr divide_unsigned
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
;===============================================================================
; copy the X/Y/Z-position of `SHIP_01` to the zero page
;-------------------------------------------------------------------------------
        ldx # .sizeof( Ship::xpos ) + .sizeof( Ship::ypos ) \
            + .sizeof( Ship::zpos ) - 1

:       lda ship_01, x          ;=$F925..                               ;$7B9D
        sta ZP_SHIP01, x        ;=$35..
        dex 
        bpl :-

        jmp _8c8a


_7ba8:                                                                  ;$7BA8
;===============================================================================
        jsr _7b9b
_7bab:                                                                  ;$7BAB
        lda ZP_VAR_XX15_0
        jsr _7b7d
        txa 
        adc # $c3
        sta VAR_04EA
        lda ZP_VAR_XX15_1
        jsr _7b7d
        stx T

        lda # $9c
        sbc T
        sta VAR_04EB

        ; use the colour from the lower-nybble of screen RAM
        ; i.e. a multi-colour pixel of %10
        lda # %10101010

        ldx ZP_VAR_XX15_2

        bpl _7bcc                       ; always branches

        ; use the colour from the colour RAM ($D800+)
        ; i.e. a multi-colour pixel of %11
        lda # %11111111
_7bcc:                                                                  ;$7BCC
        sta _1d01                       ; set the colour-mask
        jmp _b09d                       ; draw multi-color pixel?


damage_player:                                          ; BBC: OOPS     ;$7BD2
;===============================================================================
; applies a damage amount to the player's shields and, if they're depleted,
; directly to the hull (energy banks). if the player's energy-level reaches
; zero or below, the routine will kill the player 
;
; in:   A                       amount to damage the player
;-------------------------------------------------------------------------------
        sta T                   ; put aside damage value

        ldx # $00

        ; front or rear hit?
        ; read the sign byte of the ship's z-position
        ;
        ldy # Ship::zpos+2
        lda [ZP_SHIP_ADDR], y
        ; if the ship's z-sign is negative, we were hit in the trunk
        bmi @rear

        ; take damage to the front:
        ;
        lda PLAYER_SHIELD_FRONT ; subtract the damage from your [front] shields
        sbc T                   ; (shouldn't carry be set before doing this?)
        bcc :+                  ; more damage than shields? skip down
        sta PLAYER_SHIELD_FRONT ; update your shield level

        rts 

        ; front shields depleted!
        ;-----------------------------------------------------------------------
:       ldx # $00               ; cap shields to zero                   ;$7BE7
        stx PLAYER_SHIELD_FRONT ; -- prevent underflow to max-shields
        bcc @hull               ; apply excess damage to the hull!

        ; take damage to the rear:
        ;-----------------------------------------------------------------------
@rear:  lda PLAYER_SHIELD_REAR  ; damage your [rear] shields            ;$7BEE
        sbc T                   ; (shouldn't carry be set before doing this?)
        bcc :+
        sta PLAYER_SHIELD_REAR

        rts 

        ; rear shields depleted!
        ;-----------------------------------------------------------------------
:       ldx # $00               ; cap shields to zero                   ;$7BF9
        stx PLAYER_SHIELD_REAR  ; -- prevent underflow to max-shields

        ; apply excess damage directly to your hull!
        ;
        ; due to the subtraction before, the A register contains the
        ; negative amount of overflow. we add this to the player energy
        ; level to effectively subtract it instead
        ;
@hull:  adc PLAYER_ENERGY                                               ;$7BFE
        sta PLAYER_ENERGY       ; update your current energy-level
        beq @die                ; if zero, you die, skip onto that
        bcs @ok                 ; your energy-level is positive, exit

@die:   jmp _87d0               ; handle your untimely demise...        ;$7C08

@ok:                                                                    ;$7C0B
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03         ; play damage sound?
.endif  ;///////////////////////////////////////////////////////////////////////
        
        ; when taking damage directly, there's a chance that
        ; you might lose cargo. this routine handles that possibility
        ;
        jmp damage_cargo


_7c11:                                                                  ;$7C11
;===============================================================================
        lda ship_00 + Ship::xpos + 1, x                                 ;=$F901
        sta ZP_SHIP01_XPOS_pt1, x
        lda ship_00 + Ship::xpos + 2, x                                 ;=$F902
        tay 
        and # %01111111
        sta ZP_SHIP01_XPOS_pt2, x
        tya 
        and # %10000000
        sta ZP_SHIP01_XPOS_pt3, x
        rts


_7c24:                                                                  ;$7C24
;===============================================================================
        jsr _SPBLB
        ldx # attack::active | attack::ecm      ;=%10000001
        stx ZP_SHIP_ATTACK

        ldx # $00
        stx ZP_SHIP_PITCH
        stx ZP_SHIP_BEHAVIOUR
        stx SHIP_SLOT1

        dex 
        stx ZP_SHIP_ROLL

        ldx # $0a
        jsr _7d03
        jsr _7d03
        jsr _7d03

        lda _8861+0
        sta hull_pointer_station_lo
        lda _8861+1
        sta hull_pointer_station_hi

        lda PSYSTEM_TECHLEVEL
        cmp # $0a
        bcc _7c61

        lda hull_pointer_dodo_lo
        sta hull_pointer_station_lo
        lda hull_pointer_dodo_hi
        sta hull_pointer_station_hi
_7c61:                                                                  ;$7C61
        ; scanlines for sun?
        lda #< SUN_BUFFER
        sta ZP_SHIP_HEAP_LO
        lda #> SUN_BUFFER
        sta ZP_SHIP_HEAP_HI

        ; select 'station' ship-type
        lda # HULL_STATION

        ; fallthrough...
        ;

spawn_ship:                                                             ;$7C6B
;===============================================================================
; in:   A                       ship-type ID
;-------------------------------------------------------------------------------
        sta T                   ; put aside ship-type

        ; find an empty slot to add the ship:
        ;-----------------------------------------------------------------------
        ldx # 0
:       lda SHIP_SLOTS, x       ; is this ship-slot occupied?           ;$7C6F
       .bze @new                ; no, this slot is free
        inx                     ; continue to the next slot
        cpx # SHIP_COUNT-1      ; maximum number of ships
        bcc :-                  ; keep looping if slots remain

@err:   clc                     ; return carry-clear for error          ;$7C79
@rts:   rts                                                             ;$7C7A

        ;-----------------------------------------------------------------------
        ; retrieve the ship struct storage address for the given slot
        ; (address returned in `ZP_SHIP_ADDR`)
@new:   jsr get_ship_addr                                               ;$7C7B

        lda T                   ; retrieve ship type again
        bmi _7cd4               ; handle planet or sun!

        asl                     ; double ship type for table lookup
        tay                     ; transfer to Y for indexing...
        
        ; look up the hull data structure for the type of ship
        lda hull_pointers-1, y
        beq @err
        sta ZP_HULL_ADDR_HI
        lda hull_pointers-2, y
        sta ZP_HULL_ADDR_LO

        ; is space station?
        ; TODO: why does the space-station not use the line heap?
        cpy # HULL_STATION *2
        beq _7cc4

        ; allocate the max. number of lines needed to draw the ship
        ;-----------------------------------------------------------------------
        ldy # Hull::_05         ; hull max.lines
        lda [ZP_HULL_ADDR], y   ; read from the hull data
        sta ZP_TEMP_VAR         ; put aside

        lda SHIP_LINES_LO       ; heap-pointer address, lo byte
        sec 
        sbc ZP_TEMP_VAR         ; subtract the bytes for the max. lines
        sta ZP_SHIP_HEAP_LO
        lda SHIP_LINES_HI       ; heap-pointer address, lo byte
        sbc # 0                 ; (ripple the carry)
        sta ZP_SHIP_HEAP_HI

        ; TODO: this assumes that the `Ship` structure selected is always the
        ;       highest numbered one, such that the heap could come as far down
        ;       as the end of the `Ship` structure -- this would not be true if
        ;       we were using a free slot between other used slots!
        ; 
        lda ZP_SHIP_HEAP_LO     ; bottom of the heap, lo-byte
        sbc ZP_SHIP_ADDR_LO
        tay 

        lda ZP_SHIP_HEAP_HI     ; bottom of the heap, hi-byte
        sbc ZP_SHIP_ADDR_HI
        bcc @rts                ; overflow? cannot allocate the ship!
        bne :+

        cpy # $25               ;=.sizeof( Ship )?
        bcc @rts

        ; move the heap pointer backwards to its new position
:       lda ZP_SHIP_HEAP_LO                                             ;$7CBA
        sta SHIP_LINES_LO
        lda ZP_SHIP_HEAP_HI
        sta SHIP_LINES_HI

_7cc4:                                                                  ;$7CC4
        ldy # Hull::energy
        lda [ZP_HULL_ADDR], y
        sta ZP_SHIP_ENERGY

        ldy # Hull::laser_missiles
        lda [ZP_HULL_ADDR], y
        and # state::missiles
        sta ZP_SHIP_STATE

        lda T
_7cd4:                                                                  ;$7CD4
        sta SHIP_SLOTS, x
        
        tax 
        bmi _7cec               ; is sun/planet?

        cpx # HULL_HERMIT
        beq _7ce6
        cpx # HULL_ESCAPE
       .blt _7ce9
        cpx # HULL_COBRAMK3
       .bge _7ce9

_7ce6:  inc NUM_ASTEROIDS                                               ;$7CE6

        ; increment the ship-count for this type of ship
_7ce9:  inc SHIP_TYPES, x                                               ;$7CE9

        ; update behaviour?
_7cec:  ldy T                   ; ship type                             ;$7CEC
        lda hull_type - 1, y
        and # (behaviour::remove | behaviour::docking)^$FF    ;=%01101111
        ora ZP_SHIP_BEHAVIOUR
        sta ZP_SHIP_BEHAVIOUR

        ; copy the ship from the working-space in the zero-page
        ; to its position in the ship struct array
        ldy # .sizeof( Ship )-1
:       lda ZP_SHIP_XPOS_LO, y                                          ;$7CF9
        sta [ZP_SHIP_ADDR], y
        dey 
        bpl :-

        sec                     ; return success? 
        rts 

;-------------------------------------------------------------------------------

_7d03:                                                                  ;$7D03
        lda ZP_SHIP_XPOS_LO, x
        eor # %10000000
        sta ZP_SHIP_XPOS_LO, x
        inx 
        inx 
        rts 


untarget_missile:                                       ; BBC: ABORT    ;$7D0C
;===============================================================================
        ldx # $ff               ; clear missile target

        ; fallthrough
        ; ...

target_missile:                                         ; BBC: ABORT2   ;$7D0E
;===============================================================================
; in:   X                       slot number of ship to target
;       Y                       a pair of colour nybbles, as used on the bitmap
;                               screen, to colour the missile block on the HUD
;-------------------------------------------------------------------------------
        stx ZP_MISSILE_TARGET   ; set missile target
        ldx PLAYER_MISSILES     ; get the number of missiles
        jsr update_missile_indicator

        sty PLAYER_MISSILE_ARMED

        rts 

;===============================================================================
; something to do with circles?
;
;$7d1a:
        .byte   $04, $00, $00, $00, $00

project_ship:                                           ; BBC: PROJ     ;$7D1F
;===============================================================================
        lda ZP_SHIP_XPOS_LO
        sta ZP_VAR_P1
        lda ZP_SHIP_XPOS_HI
        sta ZP_VAR_P2
        lda ZP_SHIP_XPOS_SIGN
        jsr _PLS6
        bcs _7d56
        lda ZP_VALUE_pt1        ; radius?
        adc # $80
        sta ZP_SHIP01_XPOS_pt1
        txa 
        adc # $00
        sta ZP_SHIP01_XPOS_pt2
        lda ZP_SHIP_YPOS_LO
        sta ZP_VAR_P1
        lda ZP_SHIP_YPOS_HI
        sta ZP_VAR_P2
        lda ZP_SHIP_YPOS_SIGN
        eor # %10000000
        jsr _PLS6
        bcs _7d56

        lda ZP_VALUE_pt1        ; radius?
        adc # $48               ;TODO: half viewport height?
        sta ZP_CIRCLE_YPOS_LO   ; set circle Y-position, lo-byte

        txa 
        adc # $00
        sta ZP_CIRCLE_YPOS_HI

        clc 
_7d56:                                                                  ;$7D56
        rts 


; NOTE: in the original code, segment "CODE_7D57" appears here          ;$7D57
; NOTE: in the original code, segment "CODE_81EE" appears here          ;$81EE


.segment        "CODE_81FB"                                             ;$81FB
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_81fb:                                                                  ;$81FB
;===============================================================================
        lda ZP_SCREEN           ; are we in the cockpit view?
       .bnz _8204               ; no? skip over

        jsr _8ee3
        txa 
        rts 

_8204:                                                                  ;$8204
        ;-----------------------------------------------------------------------
        jsr _8ee3
        lda opt_joystick
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


_8244:                                                                  ;$8244
;===============================================================================
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


.segment        "CODE_8273"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

disable_sprites:                                                        ;$8273
;===============================================================================
; disable all sprites: (for example, when switching to menu screen)
;
;-------------------------------------------------------------------------------
.ifdef  BUILD_ORIGINAL
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

.ifndef BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL
        rts 
.else   ;///////////////////////////////////////////////////////////////////////
        ; switch back to 64K RAM layout
        lda # C64_MEM::ALL

        ; fall-through to the routine below

set_memory_layout:                                                      ;$827F
;===============================================================================
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
        ;-----------------------------------------------------------------------
        .byte   C64_MEM::ALL

.endif  ;///////////////////////////////////////////////////////////////////////


.segment        "CODE_828F"                                             ;$828F
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_828f:                                                                  ;$828F
;===============================================================================
; change the line-heap address:
;
; in:   P2.P1                   address
;-------------------------------------------------------------------------------
        ; transfer the address in P1/P2 to the ship lines pointer
        lda ZP_VAR_P1
        sta SHIP_LINES_LO
        lda ZP_VAR_P2
        sta SHIP_LINES_HI

        rts 

; NOTE: this routine is inlined in elite-harmless,
;       see `process_ship`
;
.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////

clear_ship_slot:                                                        ;$829A
;===============================================================================
; empty a `Ship`-instance slot and shuffle down the rest:
; this is part of `process_ship` and is no use outside of that routine
;
;-------------------------------------------------------------------------------
        ldx ZP_PRESERVE_X
        jsr _82f3
        ldx ZP_PRESERVE_X
        jmp process_ship

;///////////////////////////////////////////////////////////////////////////////
.endif

_82a4:                                                                  ;$82A4
;===============================================================================
        jsr clear_zp_ship
        jsr clear_sun_buffer
        
        sta SHIP_SLOT1
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        sta .loword( SHIP_TYPES + HULL_STATION )
        
        jsr _SPBLB
        
        lda # $06
        sta ZP_SHIP_YPOS_SIGN

        lda # $81               ; TODO: ?
        jmp spawn_ship


_82bc:                                                                  ;$82BC
;===============================================================================
        ldx # $ff
_82be:                                                                  ;$82BE
        inx                     ; move to the next slot
        lda SHIP_SLOTS, x
        ; NOTE: sets line-heap address to P2.P1
       .bze _828f               ; nothing in that slot?

        cmp # HULL_MISSILE      ; is it a missile?
        bne _82be               ; no -- check next ship slot

        ; missile?

        txa                     ; slot index
        asl                     ; double for lookup table
        tay                     ; move to index register

        ; get the Ship address from that index
        lda ship_addrs_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda ship_addrs_hi, y
        sta ZP_TEMP_ADDR1_HI

        ldy # Ship::attack
        lda [ZP_TEMP_ADDR1], y
        bpl _82be               ; if bit 7 is unset, check next ship slot

        and # %01111111         ; remove the sign
        lsr                     ; divide by 2
        cmp ZP_VAR_XX4          ;?
       .blt _82be               ;?
        beq _82ed               ;?
        sbc # $01               ; adjust for two's compliment
        asl                     ; multiply by 2
        ora # %10000000         ; add the sign on again
        sta [ZP_TEMP_ADDR1], y  ; update the roll value
        bne _82be               ; if not zero, check next ship slot

_82ed:                                                                  ;$82ED
        lda # $00
        sta [ZP_TEMP_ADDR1], y
        beq _82be               ; (always branches)


_82f3:                                                                  ;$82F3
;===============================================================================
; remove ship slot?
;
;-------------------------------------------------------------------------------
        ; is the ship being removed the current missile target?
        ;
        stx ZP_VAR_XX4
        lda ZP_MISSILE_TARGET
        cmp ZP_VAR_XX4
        bne :+

        ldy # .color_nybble( GREEN, HUD_COLOUR )
        jsr untarget_missile

.import TKN_FLIGHT_TARGET_LOST:direct
        lda # TKN_FLIGHT_TARGET_LOST
        jsr _MESS

:                                                                       ;$8305
        ldy ZP_VAR_XX4
        ldx SHIP_SLOTS, y

        ; is space station?
        cpx # HULL_STATION
        beq _82a4

        ; is constrictor?
        cpx # HULL_CONSTRICTOR
        bne _831d

        ; the constrictor has been destroyed!
        ; set the constrictor mission complete
        lda MISSION_FLAGS
        ora # missions::constrictor_complete
        sta MISSION_FLAGS

        inc PLAYER_KILLS_HI

_831d:                                                                  ;$831D
        cpx # HULL_HERMIT       ; is asteroid hermit?
        beq _8329
        cpx # HULL_ESCAPE       ; is escape capsule?
        bcc _832c
        cpx # HULL_COBRAMK3     ; is cobra mk-III? (trader)
        bcs _832c
_8329:                                                                  ;$8329
        dec NUM_ASTEROIDS
_832c:                                                                  ;$832C
        dec SHIP_TYPES, x

        ldx ZP_VAR_XX4

        ldy # Hull::_05         ;=$05: max.lines
        lda [ZP_HULL_ADDR], y

        ldy # Ship::vertexData
        clc 
        adc [ZP_SHIP_ADDR], y
        sta ZP_VAR_P1

        iny                     ;=$22: acceleration
        lda [ZP_SHIP_ADDR], y
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
        sta T
        lda ZP_VAR_P1
        sec 
        sbc T
        sta ZP_VAR_P1
        lda ZP_VAR_P2
        sbc # $00
        sta ZP_VAR_P2
        txa 
        asl 
        tay 
        lda ship_addrs_lo, y
        sta ZP_TEMP_ADDR1_LO
        lda ship_addrs_hi, y
        sta ZP_TEMP_ADDR1_HI

        ldy # $24
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_SHIP_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_SHIP_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta ZP_VALUE_pt2
        lda ZP_VAR_P2
        sta [ZP_SHIP_ADDR], y
        dey 
        lda [ZP_TEMP_ADDR1], y
        sta ZP_VALUE_pt1        ; radius?
        lda ZP_VAR_P1
        sta [ZP_SHIP_ADDR], y
        dey 
_8399:                                                                  ;$8399
        lda [ZP_TEMP_ADDR1], y
        sta [ZP_SHIP_ADDR], y
        dey 
        bpl _8399
        lda ZP_TEMP_ADDR1_LO
        sta ZP_SHIP_ADDR_LO
        lda ZP_TEMP_ADDR1_HI
        sta ZP_SHIP_ADDR_HI
        ldy T
_83aa:                                                                  ;$83AA
        dey 
        lda [ZP_VALUE], y
        sta [ZP_VAR_P], y
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


_RESET:                                                 ; BBC: RESET    ;$83CA
;===============================================================================
; clears the "local bubble" of universe around the player:
;-------------------------------------------------------------------------------
        ; empty the local bubble of ships
        jsr _ZERO

        ; erase variables for pitch, roll
        ; and ECM / hyperspace countdown
        ; 
        ; NOTE: this doesn't erase `ZP_INV_ROLL_SIGN`
        ;       at the end but happens not to matter
        ldx # 6
:       sta ZP_BETA, x                                                  ;$83CF
        dex 
        bpl :-

        txa                     ; set A = $FF
        sta ZP_IS_DOCKED        ; flag as being docked

        ; fill the aft & fore shields and energy banks:
        ; note that A is still $FF
        ldx # 2
:       sta PLAYER_SHIELD_FRONT, x                                      ;$83D9
        dex 
        bpl :-

        ; fallthrough
        ; ...

_83df:                                                  ; BBC: RES2?    ;$83DF
;===============================================================================
; NOTE: this interposer is not present in the BBC code!
;-------------------------------------------------------------------------------
        jsr stop_sound          ; stop all sound playing

        lda PLAYER_EBOMB
        bpl _83ed

        jsr _2367
        sta PLAYER_EBOMB

        ; fallthrough
        ; ...

_83ed:                                                  ; BBC: RES2     ;$83ED
;===============================================================================
        ; reset the space dust:
        ;
        lda # DUST_MAX-1
        sta DUST_COUNT          ; number of dust particles

        ldx # $ff               ; mark ball-line heap,
        stx circle_lines_x      ;  used for drawing planets,
        stx circle_lines_y      ;  as empty

        stx ZP_MISSILE_TARGET   ; set no missile target

        ; reset pitch & roll to centre:
        ;
        lda # $80
        sta JOY_PITCH
        sta ZP_ROLL_SIGN        ; set roll and pitch sign
        sta ZP_PITCH_SIGN
        asl                     ;=0
        sta ZP_BETA
        sta ZP_PITCH_MAGNITUDE
        sta ZP_INV_ROLL_SIGN    ; set the inverted signs too!
        sta ZP_INV_PITCH_SIGN

        ; reset frame counter used for spacing actions across frames
        sta MAIN_COUNTER

.ifdef  FEATURE_TRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        sta TRUMBLES_ONSCREEN   ; clear number of Trumble™ sprites on-screen
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # 3
        sta ZP_PLAYER_SPEED
        sta ZP_ALPHA
        sta ZP_ROLL_MAGNITUDE

        ; text printing colour?
        lda # .color_nybble( WHITE, BLACK )                             ;=$10
        sta VAR_050C

        lda # $00               ; TODO: something to do with viewport height,
        sta ZP_B7               ;       but not present in BBC code
        lda # VIEWPORT_HEIGHT-1
        sta ZP_VIEWH

        ; are we within space station range?
        ; (check for the presence of a station in the ship count)
        ; 
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        beq :+

        jsr _SPBLB              ; light the "space station" bulb

:       lda ECM_COUNTER         ; is an ECM already active?             ;$8430
        beq :+                  ; if not, skip over

        jsr _ECMOF              ; clear ECM state / HUD indicator

:       jsr _WPSHPS             ; remove all ships from the scanner     ;$8437
        jsr _ZERO               ; clear ship slots and other vars

        lda #< ELITE_HEAP_TOP   ; reset the ship line heap to the top
        sta SHIP_LINES_LO
        lda #> ELITE_HEAP_TOP
        sta SHIP_LINES_HI

        ; fallthrough
        ; ...

clear_zp_ship:                                          ; BBC: ZINF     ;$8447
;===============================================================================
; clear the zero-page `Ship` instance:
;-------------------------------------------------------------------------------
        ldy # .sizeof( Ship )-1
        lda # $00
:       sta ZP_SHIP, y                                                  ;$844B
        dey 
        bpl :-

        ; configure the scaling / rotation matrix:
        ;
        ; "96 * 256 (&6000) represents 1 in the orientation vectors, while
        ; -96 * 256 (&E000) represents -1. We already set the vectors to zero
        ; above, so we just need to set up the high bytes of the diagonal 
        ; values and we're done. The negative nosev [z] makes the ship
        ; point towards us, as the z-axis points into the screen"
        ;
        ;       X: [  1,  0,  0 ]
        ;       Y: [  0,  1,  0 ]
        ;       Z: [  0,  0, -1 ]
        ;
        ; <https://www.bbcelite.com/master/main/subroutine/zinf.html>
        ;
        lda # >(96 * 256)       ;=$6000
        sta ZP_SHIP_M1x1_HI
        sta ZP_SHIP_M2x0_HI
        ora # %10000000         ; set negative sign for last number
        sta ZP_SHIP_M0x2_HI

        rts 


_msblob:                                                ; BBC: msblob   ;$845C
;===============================================================================
; update missile blocks on HUD?
;
;-------------------------------------------------------------------------------
        ldx # $04               ; number of missile blocks

:       cpx PLAYER_MISSILES     ; player missile count                  ;$845E
        beq @_846c              ; colour remaining missiles

        ldy # .color_nybble( DKGREY, HUD_COLOUR )
        jsr update_missile_indicator
        dex 
        bne :-

        rts 

@_846c:                                                                 ;$846C
        ldy # .color_nybble( GREEN, HUD_COLOUR )
        jsr update_missile_indicator
        dex 
        bne @_846c

        rts 


_8475:                                                                  ;$8475
;===============================================================================
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :+                  ; no? skip over

        lda VAR_04E6
        jsr _MESS               ; print on-screen message
        
        ; clear the on-screen message(?)
        lda # $00
        sta OSD_DELAY
        jmp _84fa

:       jsr tkn_docked_fn15     ; clear rows 21, 22 & 23(?)             ;$8487
        jmp _84fa


_848d:                                                                  ;$848D
;===============================================================================
        jsr clear_zp_ship
        jsr get_random_number
        sta ZP_TEMP_VAR
        and # %10000000
        sta ZP_SHIP_XPOS_SIGN
        txa 
        and # %10000000
        sta ZP_SHIP_YPOS_SIGN
        lda # $19
        sta ZP_SHIP_XPOS_HI
        sta ZP_SHIP_YPOS_HI
        sta ZP_SHIP_ZPOS_HI
        txa 
        cmp # $f5
        rol                     ; increase aggression level?
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_SHIP_ATTACK

        ; fallthrough
        ; ...

get_random_number_clc:                                                  ;$84AE
;===============================================================================
        clc 

        ; fallthrough
        ; ...

get_random_number:                                      ; BBC: DORND    ;$84AF
;===============================================================================
; generate an 8-bit 'random' number:
;
; out:  A                       random number between 0-255?
;       X                       (clobbered?)
;       Y                       (preserved)
;-------------------------------------------------------------------------------
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


_84c3:                                                                  ;$84C3
;===============================================================================
        jsr get_random_number
        lsr 
        sta ZP_SHIP_ATTACK
        sta ZP_SHIP_ROLL
        rol ZP_SHIP_STATE
        and # %00011111
        ora # %00010000
        sta ZP_SHIP_SPEED

        jsr get_random_number
        bmi _84e2

        lda ZP_SHIP_ATTACK
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_SHIP_ATTACK

        ldx # behaviour::docking
        stx ZP_SHIP_BEHAVIOUR
_84e2:                                                                  ;$84E2
        and # %00000010         ; = 0 or 2?
        adc # $0b               ; = $0B or $0D?
        cmp # $0f
        beq _84ed
        jsr spawn_ship

; main loop?
;
; ".TT100 ; Start of Main loop and check messages"
_84ed:                                                                  ;$84ED
        jsr main_flight_loop

        dec OSD_DELAY           ; "reduce delay?"
        beq _8475               ; "if 0 erase message, up"
        bpl _84fa               ; "skip inc"
        inc OSD_DELAY           ; "else undershot, set to 0"

; ".me3 ; also arrive back from me2"
_84fa:                                                                  ;$84FA
        dec MAIN_COUNTER
        beq _8501

; ".ytq ; a lot of this not needed while docked"
_84fe:                                                                  ;$84FE
        jmp _8627               ; jump down to main loop?

_8501:                                                                  ;$8501
        lda IS_WITCHSPACE       ; are we in witchspace?
       .bnz _84fe               ; yes -- skip to the main loop

        jsr get_random_number
        cmp # $23
        bcs _8562

        lda NUM_ASTEROIDS
        cmp # $03               ; more than 2?
        bcs _8562

        jsr clear_zp_ship       ; clear the temp `Ship` ready for spawning

        lda # $26
        sta ZP_SHIP_ZPOS_HI     ; set the middle distance
        jsr get_random_number   ; vary the distance a little
        sta ZP_SHIP_XPOS_LO     ; spread the objects about horionzontally...
        stx ZP_SHIP_YPOS_LO     ; ...and vertically
        and # %10000000         ; pick the sign from the random number
        sta ZP_SHIP_XPOS_SIGN   ; position object either left or right of us
        txa 
        and # %10000000         ; pick another sign from the random number
        sta ZP_SHIP_YPOS_SIGN   ; position the object either above or below
        rol ZP_SHIP_XPOS_HI     ; increase the scale of the left/right spread
        rol ZP_SHIP_XPOS_HI     ; now, with more feeling

        jsr get_random_number
        bvs _84c3
        ora # %01101111
        sta ZP_SHIP_ROLL

        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        bne _8562
        
        txa 
        bcs _8548
        and # %00011111
        ora # %00010000
        sta ZP_SHIP_SPEED
        bcc _854c
_8548:                                                                  ;$8548
        ora # %01111111
        sta ZP_SHIP_PITCH
_854c:                                                                  ;$854C
        jsr get_random_number
        cmp # $fc
        bcc _8559

        lda # attack::ecm | attack::aggr1 | attack::aggr2 | attack::aggr3
        sta ZP_SHIP_ATTACK      ;=%00001111
        bne _855f
_8559:                                                                  ;$8559
        cmp # $0a
        and # %00000001
        adc # $05               ; cargo cannister or boulder?
_855f:                                                                  ;$855F
        jsr spawn_ship
_8562:                                                                  ;$8562
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        lda .loword( SHIP_TYPES + HULL_STATION )
        beq _856a
_8567:                                                                  ;$8567
        jmp _8627

_856a:                                                                  ;$856A
        jsr illegal_cargo
        asl 

        ; are any police ships present?
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        ldx .loword( SHIP_TYPES + HULL_VIPER )
        beq _8576
        
        ora PLAYER_LEGAL
_8576:                                                                  ;$8576
        sta T
        jsr _848d
        cmp # $88
        beq _85f8
        cmp T
        bcs :+

        ; spawn a police viper ship
        lda # HULL_VIPER
        jsr spawn_ship

        ; are any police ships present?
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
:       lda .loword( SHIP_TYPES + HULL_VIPER )                          ;$8588
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
            | attack::aggr5  | attack::aggr4 | attack::aggr3 \
            | attack::ecm
        sta ZP_SHIP_ATTACK      ;=%11111001

        lda MISSION_FLAGS
        and # missions::constrictor
        lsr 
        bcc _85e0

        ; is the constrictor present?
        ;
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        ora .loword( SHIP_TYPES + HULL_CONSTRICTOR )
        beq _85f0
_85e0:                                                                  ;$85E0
        lda # behaviour::angry
        sta ZP_SHIP_BEHAVIOUR

        jsr get_random_number
        cmp # $c8
        rol 
        ora # attack::active | attack::target   ;=%11000000
        sta ZP_SHIP_ATTACK
        tya 
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

_85f0:  ; spawn the constrictor!                                        ;$85F0
        lda # HULL_CONSTRICTOR
_85f2:                                                                  ;$85F2
        jsr spawn_ship
        jmp _8627

_85f8:                                                                  ;$85F8
        ;-----------------------------------------------------------------------
        lda ship_00 + Ship::zpos                                        ;=$F906
        and # %00111110
        bne _85a5

        lda # $12
        sta ZP_SHIP_SPEED

        ; perhaps this bit-pattern has an alternative meaning?
        lda # attack::target \
            | attack::aggr5  | attack::aggr4 | attack::aggr3 \
            | attack::ecm
        sta ZP_SHIP_ATTACK      ;=%01111001

        lda # $20
        bne _85f2
_860b:                                                                  ;$860B
        and # %00000011
        sta VAR_048A
        sta ZP_VAR_XX13
_8612:                                                                  ;$8612
        jsr get_random_number
        sta T

        jsr get_random_number
        and T
        and # %00000111
        adc # $11
        jsr spawn_ship

        dec ZP_VAR_XX13
        bpl _8612

        ; fallthrough
        ; ...

_8627:                                                                  ;$8627
;===============================================================================
; main loop?
;-------------------------------------------------------------------------------
        ldx # $ff               ; reset the stack pointer,
        txs                     ; we won't be returning to BASIC :P

        ; cool down lasers:
        ;
        ldx LASER_HEAT          ; get current laser temperature
        beq :+                  ; skip if > 0
        dec LASER_HEAT          ; reduce laser temperature

        ; the pulse laser cannot shoot continuously like the beam laser,
        ; so this counter enforces a wait between each shot
        ;
:       ldx LASER_COUNTER       ; current pulse countdown               ;$8632
        beq @_863e              ; if already zero, skip ahead

        dex                     ; decrement the pulse countdown once
        beq :+                  ; if zero, that's enough
        dex                     ; decrement again...
:       stx LASER_COUNTER       ; update the pulse counter              ;$863B

@_863e:                                                                 ;$863E
        lda ZP_SCREEN           ; are we in the cockpit-view?
       .bnz :+                  ; no, skip over

        jsr _2ff3               ; update dials(?)

:       lda ZP_SCREEN           ; are we in the cockpit-view?           ;$8645
       .bze @_8654              ; yes, skip ahead

        and _PATG
        lsr 
        bcs @_8654

        ldy # 2
        jsr wait_frames

@_8654:                                                                 ;$8654
        ; handle breeding for < 256 Trumbles™
        ;-----------------------------------------------------------------------
        ; does the player have more than 256 Trumbles™?
        ;
        lda PLAYER_TRUMBLES_HI  ; (hi-byte of Trumble™ count)
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

        sta T                   ; put aside the Trumble™ hi-byte
                                ; this will be the 'odds' (n/256)
        lda CABIN_HEAT          ; get current cabin temperature
        cmp # 224               ; is it >= 224?
        bcs :+                  ; yes, skip the next instruction
                                ; (reduces Trumble™ growth in hot conditions)

        asl T                   ; double the odds

:       jsr get_random_number   ; pick a random number 0-255            ;$8680
        cmp T                   ; compare against our odds
        bcs @_86a1              ; if random number >= odds, skip

        ; get random number between 64 and 255
        jsr get_random_number   ; get random number 0-255
        ora # %01000000         ; always at least 64
        tax 

        lda # $80
        ldy CABIN_HEAT          ; get current cabin temperature
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

_FRCE:                                                  ; BBC: FRCE     ;$86A4
        jsr @_86b1

        lda ZP_IS_DOCKED
        beq :+

        ; begin next frame?
        ; (restart main loop)
        jmp _8627

:       jmp _84ed                                                       ;$86AE


; key commands:
;===============================================================================
@_86b1:                                                                 ;$86B1
        ; key for status page pressed?
        ; (default '8' in original Elite)
        cmp # .key_index( key_status )
        bne :+                  ; no? skip over
        jmp status_screen       ; switch to the status screen

        ; key for galactic chart pressed?
        ; (default '4' in original Elite)
:       cmp # .key_index( key_chart_galactic )                          ;$86B8
        bne :+                  ; no? skip over
        jmp galactic_chart      ; switch to galactic chart screen

        ; key for local (short-range) chart pressed?
        ; (default '5' in original Elite)
:       cmp # .key_index( key_chart_local )                             ;$86BF
        bne :+                  ; no? skip over
        jmp local_chart         ; switch to local chart screen

        ; key for planetary information pressed?
        ; (default '6' in original Elite)
:       cmp # .key_index( key_planet )                                  ;$86C6
        bne :+                  ; no? skip over
        jsr _TT111              ; prepare planet seed?
        jmp planet_screen       ; switch to planetary information screen

        ; key for inventory screen pressed?
        ; (default '9' in original Elite)
:       cmp # .key_index( key_inventory )                               ;$68D0
        bne :+                  ; no? skip over
        jmp inventory_screen    ; switch to inventory screen

        ; key for market prices screen pressed?
        ; (default '7' in original Elite)
:       cmp # .key_index( key_market )                                  ;$86D7
        bne :+                  ; no? skip over
        jmp market_screen       ; switch to market prices screen

:       cmp # $3c               ; 'F1'?                                 ;$86DE
        bne :+                  ; no? skip over
        jmp _741c               ; launch?!

:       bit ZP_IS_DOCKED                                                ;$86E5
        bpl @_870d

        ; key for buy equipment screen pressed?
        ; (default '3' in original Elite)
        cmp # .key_index( key_buy_equipment )
        bne :+                  ; no? skip over
        jmp equipment_screen    ; switch to buy equipment screen

        ; key for buy cargo screen pressed?
        ; (default '1' in original Elite)
:       cmp # .key_index( key_buy_cargo )                               ;$86F0
        bne :+                  ; no? skip over
        jmp buy_screen          ; switch to buy cargo screen

:       cmp # $12               ; '@'?                                  ;$86F7
        bne @_8706
        jsr _SVE
        bcc :+
        jmp _QU5                ;? (do something on disk-error?)
:       jmp _BAY                                                        ;$8703

        ; key for sell cargo screen pressed?
        ; (default '2' in original Elite)
@_8706:                                                                 ;$8706
        cmp # .key_index( key_sell_cargo )
        bne @_8724
        jmp sell_cargo          ; switch to sell cargo screen

@_870d: ; cockpit view keys:                                            ;$870D
        ;-----------------------------------------------------------------------
        ; rear view -- 'F3' by default
        cmp # .key_index( key_view_rear )
        beq @rear
        ; left view -- 'F5' by default
        cmp # .key_index( key_view_left )
        beq @left
        ; right view -- 'F7' by default
        cmp # .key_index( key_view_right )
        bne @_8724

        ; select right view:
        ;
@right: ldx # $03
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

        ; select left view:
        ;
@left:  ldx # $02                                                       ;$871C
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

        ; select rear view:
        ;
@rear:  ldx # $01                                                       ;$871F
        ; set cockpit camera view?
        jmp _a6ba

@_8724:                                                                 ;$872F
        ;-----------------------------------------------------------------------
        bit key_hyperspace      ; hyperspace key pressed?
        bpl :+

        jmp _715c               ; do hyperspace jump

:       cmp # $2e               ; 'f'?                                  ;$872C
        beq _877e

        cmp # $2b               ; 'c'?
        bne :+
        lda ZP_IS_DOCKED
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
        jsr set_tsystem_to_psystem
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
        lda ZP_SCREEN
        and # %11000000
        beq _877d

        jsr _7695
        sta ZP_PRINT_CASE
        jsr _76e9
        lda # %10000000
        sta ZP_PRINT_CASE

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # TXT_NEWLINE
        jsr print_char
.else   ;///////////////////////////////////////////////////////////////////////
        jsr print_crlf
.endif  ;///////////////////////////////////////////////////////////////////////

        jmp print_target_system_distance


illegal_cargo:                                                          ;$8798
;===============================================================================
; do you have any illegal cargo?
;-------------------------------------------------------------------------------
        lda CARGO_SLAVES
        clc 
        adc CARGO_NARCOTICS
        asl 
        adc CARGO_FIREARMS
        rts 


_FAROF:                                                 ; BBC: FAROF    ;$87A4
;===============================================================================
; is a ship too far away (left scanner range?)
;-------------------------------------------------------------------------------
        lda # 224               ; this is the distance upper-bound

_87a6:  cmp ZP_SHIP_XPOS_HI                                             ;$87A6
        bcc :+
        cmp ZP_SHIP_YPOS_HI
        bcc :+
        cmp ZP_SHIP_ZPOS_HI

:       rts                                                             ;$87B0


.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; this routine is inlined in elite-harmless
;
or_xyz_hi:                                              ; BBC: MAS4     ;$87B1
;===============================================================================
; is the current ship being inspected > 255 distance in any direction?
;-------------------------------------------------------------------------------
        ora ZP_SHIP_XPOS_HI
        ora ZP_SHIP_YPOS_HI
        ora ZP_SHIP_ZPOS_HI
        rts 
;///////////////////////////////////////////////////////////////////////////////
.endif


_87b8:                                                                  ;$87B8
;===============================================================================
        ; counter of some kind, possibly related to debug errors?
        .byte   $00

;===============================================================================
; the unused and incomplete debug code can be removed
; in non-original builds
;
.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; BRK routine, set up by `debug_for_brk`
;
debug_brk:                                                              ;$87B9
;===============================================================================
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


_87d0:                                                  ; BBC: DEATH    ;$87D0
;===============================================================================
; the player did exploder:
;-------------------------------------------------------------------------------
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr play_sfx_03
.endif  ;///////////////////////////////////////////////////////////////////////
        jsr _83df
        asl ZP_PLAYER_SPEED
        asl ZP_PLAYER_SPEED
        ldx # $18
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr original_7b5e       ; dead code, just an rts
.endif  ;///////////////////////////////////////////////////////////////////////
        jsr set_page

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr drawViewportBorders
.endif  ;///////////////////////////////////////////////////////////////////////
        
        lda # $00
        sta ELITE_BITMAP_ADDR + 7 + .bmppos( 24, 35 )
        sta ELITE_BITMAP_ADDR + 0 + .bmppos(  0, 35 )
        jsr _7af7

        lda # 12
       .set_cursor_row
       .set_cursor_col

        lda # $92
        jsr print_canned_message
_87fd:                                                                  ;$87FD
        jsr _848d
        lsr 
        lsr 
        sta ZP_SHIP_XPOS_LO

        ; switch to cockpit-view(?)
        ; (does not call `set_page` though)
        ldy # page::cockpit     ; NOTE: Y = 0
        sty ZP_SCREEN

        sty ZP_SHIP_XPOS_HI
        sty ZP_SHIP_YPOS_HI
        sty ZP_SHIP_ZPOS_HI
        sty ZP_SHIP_ATTACK
        dey 
        sty MAIN_COUNTER
        eor # %00101010
        sta ZP_SHIP_YPOS_LO
        ora # %01010000
        sta ZP_SHIP_ZPOS_LO
        txa 
        and # %10001111
        sta ZP_SHIP_ROLL
        ldy # $40
        sty LASER_COUNTER
        sec 
        ror 
        and # %10000111
        sta ZP_SHIP_PITCH

        ; spawn a cargo-cannister or plate-alloy:
        ; WARN: this assumes the plate/alloy ID
        ;       comes before the cargo-cannister
        ldx # HULL_CANNISTER
        lda VIC_SPRITE3_Y       ;?
        beq :+
        bcc :+
        dex                     ; change from cargo-cannister to plate/alloy

:       jsr _3695               ; NOTE: spawns ship-type in X           ;$8835
        
        jsr get_random_number
        and # %10000000
        ldy # $1f
        sta [ZP_SHIP_ADDR], y
        lda SHIP_SLOT4
        beq _87fd

        jsr _8ed5               ; clears 56 key-states, not 64

        sta ZP_PLAYER_SPEED
        jsr main_flight_loop
        jsr disable_sprites
_8851:                                                                  ;$8851
        jsr main_flight_loop
        dec LASER_COUNTER
        bne _8851
        ldx # $1f

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr original_7b5e       ; dead code, just an rts
.endif  ;///////////////////////////////////////////////////////////////////////

        jmp _8882


_8861:                                                                  ;$8861
;===============================================================================
; pointer to the 3D hull to show on the title screen
;-------------------------------------------------------------------------------
        .addr   $8888

_8863:                                                                  ;$8863
;===============================================================================
; LOADER JUMPS HERE! -- THIS IS THE ENTRY POINT
;-------------------------------------------------------------------------------
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
        lda hull_pointer_station_lo
        sta _8861+0
        lda hull_pointer_station_hi
        sta _8861+1

        jsr _JAMESON            ; reset the save data to default

        ; set the stack pointer to the top ($01FF),
        ; (i.e. disregard all stack-use prior to this point)
        ldx # $ff
        txs 

        jsr _RESET

_8882:                                                  ; BBC: BR1      ;$8882
;===============================================================================
        ; set the stack pointer to the top ($01FF),
        ; (i.e. disregard all stack-use prior to this point)
        ldx # $ff
        txs 

        jsr _83df
        jsr clear_keyboard

        lda # 3                 ; move text-cursor to column 3
       .set_cursor_col          ; (on viewport)

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr _91fe
.endif  ;///////////////////////////////////////////////////////////////////////

        ; which ship model to show on the title screen
        ldx # HULL_COBRAMK3

        ; print "load new commander (Y/N)?"
.import MSG_DOCKED_LOAD_NEW_COMMANDER_YN:direct
        lda # MSG_DOCKED_LOAD_NEW_COMMANDER_YN

        ldy # 210               ; ship distance
        jsr _TITLE              ; draw title screen, wait for keypress

        cmp # $27               ; "Y"? (PETSCII? scancode?)
        bne _QU5

        jsr _9245               ; (something to do with sound)
        jsr _DFAULT             ; reset game to last saved state
        jsr _SVE                ; show load menu

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        jsr _91fe
.endif  ;///////////////////////////////////////////////////////////////////////

_QU5:   jsr _DFAULT             ; reset game to last saved state        ;$88AC
        jsr _msblob             ; reset missile blocks on HUD

        ; "press space or fire commander"
.import MSG_DOCKED_PRESS_SPACE_OR_FIRE_COMMANDER:direct
        lda # MSG_DOCKED_PRESS_SPACE_OR_FIRE_COMMANDER

        ldx # HULL_ADDER        ; switch ship to an Adder
        ldy # 48                ; ship distance
        jsr _TITLE              ; draw title screen, wait for keypress

        ; start new game:
        ;-----------------------------------------------------------------------
        jsr _9245               ; (something to do with sound)

        jsr set_tsystem_to_psystem
        jsr _TT111              ; initialise planet seed?
        jsr _jmp

        ; copy current random seed
        ldx # 5                 ; 6-byte counter
:       lda ZP_SEED, x                                                  ;$88C9
        sta VAR_04F4, x
        dex 
        bpl :-

        inx                     ; set X to 0 (loop exits with X = $FF)
        stx VAR_048A            ; set extra vesels spawning counter to 0

        ; set the present system data
        ; from the target system
        lda TSYSTEM_ECONOMY
        sta PSYSTEM_ECONOMY
        lda TSYSTEM_TECHLEVEL
        sta PSYSTEM_TECHLEVEL
        lda TSYSTEM_GOVERNMENT
        sta PSYSTEM_GOVERNMENT

        ; fallthrough to begin
        ; docked at station
        ; ...

_BAY:                                                   ; BBC: BAY      ;$88E7
;===============================================================================
; this is the entry point for docking
; -- execution jumps here when:
;
; 1.    loading or starting a new game
; 2.    docking your ship via normal means
; 3.    after using an escape pod
; 4.    after selling cargo
; 5.    various input errors such as not enough cash,
;       not enough cargo or inputting out-of-range numbers
;-------------------------------------------------------------------------------
        lda # $ff               ; set "docked" flag
        sta ZP_IS_DOCKED

        ; "press" the status page key to jump to the status screen first
        lda # .key_index( key_status )
        jmp _FRCE


_DFAULT:                                                ; BBC: DFAULT   ;$88F0
;===============================================================================
; resets the game to the last-saved state; e.g. if the player dies, the game
; reverts to the last save. a copy of the last save is always kept in RAM
; to avoid having to go to disk
;
;-------------------------------------------------------------------------------
        ; note that X decrements downwards toward zero but the zeroth-byte
        ; is not copied (`bne` check) so the addresses are -1'd to compensate
        ; and the counter is +1'd to account for the unused 0th iteration.
        ; this was done to allow the posibility of save data to be >128
        ; bytes, even though it isn't in original elite
        ;
        ldx # save_reset_size+1 ; note: defined in "save_data.asm"
:       lda save_name-1, x      ; copy from the last saved game...      ;$88F2
        sta GAME_DATA-1, x      ; ...to the in-play game state
        dex 
        bne :-

        ; set the screen to cockpit-view
        ; (note that X = 0 due to the loop logic above)
        stx ZP_SCREEN

@chk:   jsr calc_checksum1                                              ;$88FD
        cmp checksum1           ; compare against last-saved checksum1
        bne @chk                ; if no-match, infinite loop?

        eor # %10101001
        tax 
        lda PLAYER_COMPETITION
        cpx checksum_bytes
        beq :+
        ora # %10000000
:       ora # %01000000                                                 ;$8912
        sta PLAYER_COMPETITION

        jsr calc_checksum2      ; run second-checksum (C64 only)
        cmp checksum2
        bne @chk

        rts 


_TITLE:                                                 ; BBC: TITLE    ;$8920
;===============================================================================
; draw the title screen:
;
; in:   A                       a docked-string token to print
;       X                       which ship model to display
;       Y                       ship distance, i.e. scale on screen
;-------------------------------------------------------------------------------
        sty VAR_SDIST           ; z-distance
        pha                     ; keep A parameter
        stx ZP_SHIP_TYPE        ; put aside ship-type

        lda # $ff               ; TODO: flag, only on C64?
        sta _1d13

        jsr _RESET              ; reset ship parameters in order
                                ; to use a different model

        lda # $00               ; TODO: flag, only on C64
        sta _1d13

        jsr clear_keyboard      ; clear keyboard state so that the
                                ; title screen isn't instantly skipped

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # 32                ; BBC: set colour palette for viewport
        jsr _DOVDU19            ; DEAD CODE! this is just an RTS!
.endif  ;///////////////////////////////////////////////////////////////////////

        ; clear the screen, setting the 'page' for the title screen
        lda # page::title
        jsr set_page

        ; set screen to cockpit-view
        lda # page::cockpit
        sta ZP_SCREEN

        ; reset the scaling / rotation vector:
        ; TODO: this matrix is different from the one set via `_RESET`, why?
        ;
        lda # >(96 * 256)       ;=$6000
        sta ZP_SHIP_M0x2_HI
        lda # >(96 * 256)       ;=$6000 (unceccesary instruction?)
        sta ZP_SHIP_ZPOS_HI
        ldx # $7f
        stx ZP_SHIP_ROLL
        stx ZP_SHIP_PITCH

        inx 
        stx ZP_PRINT_CASE
        
        lda ZP_SHIP_TYPE
        jsr spawn_ship

        ; print "--- E L I T E ---"
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # 6
.else   ;///////////////////////////////////////////////////////////////////////
        lda # 2
.endif  ;///////////////////////////////////////////////////////////////////////
       .set_cursor_col

.import TKN_FLIGHT_ELITE:direct
        lda # TKN_FLIGHT_ELITE
        jsr print_flight_token_and_newline

        lda # $0a               ; newline, but should be $0C? `TXT_NEWLINE`
        jsr print_char

        lda # 6
       .set_cursor_col

        lda _PATG               ; flag to skip printing credits!?
        beq :+

        ; print "by d.braben & i.bell"
.import MSG_DOCKED_BY_DBRABEN_AND_IBELL:direct
        lda # MSG_DOCKED_BY_DBRABEN_AND_IBELL
        jsr print_docked_str

        ; this was some debug code that prints the whole font to screen:
        ;
        ; NOTE: `_87b8` appears in the unused debug handler
:       lda _87b8                                                       ;$8978
        beq @_8994
        inc _87b8

        lda # 7
       .set_cursor_col
        lda # 10
       .set_cursor_row

        ldy # $00
:       jsr paint_char                                                  ;$898C
        iny 
        lda [ZP_FD], y
        bne :-

@_8994: ldy # $00               ; set player speed to 0 so that         ;$8994
        sty ZP_PLAYER_SPEED     ;  the ship remains in place!
        sty opt_joystick        ; reset to keyboard controls

        ; print the docked string token passed into the routine, i.e.
        ; "load new commander (Y/N)" or "press space or fire commander"
        ;
        lda # 15
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL

        pla                     ; retrieve the original A parameter
        jsr print_docked_str    ; use this as a docked string token
                                ; (see "text/text_docked.asm")

        lda # 3
       .set_cursor_col

        ; this has been stubbed out; in the BBC code
        ; this is where "ACORNSOFT 1986" would be
        lda # TXT_NEWLINE
        jsr print_docked_str

        lda # 12
        sta ZP_TEMP_COUNTER2

        lda # 5
        sta MAIN_COUNTER

        lda # $ff               ; enable joystick??
        sta opt_joystick        ; (default for C64?)

        ; spin the ship!
        ;-----------------------------------------------------------------------
@spin:  lda ZP_SHIP_ZPOS_HI                                             ;$89BE
        cmp # $01
        beq :+
        dec ZP_SHIP_ZPOS_HI
:       jsr move_ship                                                   ;$89C6

        ; the ship's X / Y & Z position are fixed each frame to avoid
        ; slight drift occurring from mathematical imprecision
        ;
        ldx VAR_SDIST           ; retrieve title screen ship z-distance
        stx ZP_SHIP_ZPOS_LO     ; keep the ship from moving away

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda MAIN_COUNTER        ; these instructions have no effect; they must
        and # %00000011         ;  have been from an older implementation
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $00               ; fix the ship's X & Y position
        sta ZP_SHIP_XPOS_LO
        sta ZP_SHIP_YPOS_LO

        jsr draw_ship           ; redraw the ship

        ; read in the key / joystick state:
        ;
        ; NOTE: returns carry set if a key was pressed. this carry
        ;       will be held through the next few instructions
        ;
        jsr get_input

        dec MAIN_COUNTER        ; (unused?)

        bit joy_fire            ; check for joystick fire button
        bmi :+                  ; if pressed, skip out

        bcc @spin               ; if no key pressed, keep spinning

        ; if key is pressed instead of fire,
        ; disable joystick input
        inc opt_joystick

:       rts                                                             ;$89EA


calc_checksum1:                                         ; BBC: CHECK    ;$89EB
;===============================================================================
; checksum last saved player data:
;
; out:  A                       checksum byte
;-------------------------------------------------------------------------------
        ; see "save_data.asm", where the region of save data checksummed
        ; is defined as this doesn't include the checksum bytes themselves
        ;
        ldx # checksum_data_size
        clc 
        txa                     ; seed the checksum with the data size
:       adc checksum_data-1, x  ; add the X-1'th byte to the checksum   ;$89EF
        eor checksum_data-0, x  ; and XOR with the X'th byte
        dex                     ; decrement count
        bne :-                  ; keep going until the first byte

        rts 


calc_checksum2:                                                         ;$89F9
;===============================================================================
; secondary checksum for last saved player data:
;
; a more involved checksum routine that scrambles by XORing with the
; byte index first and shifting right; this was obviously intended to
; be tougher to hack than the BBC variant
;
; out:  A                       checksum byte
;-------------------------------------------------------------------------------
        ; see "save_data.asm", where the region of save data checksummed
        ; is defined as this doesn't include the checksum bytes themselves
        ;
        ldx # checksum_data_size
        clc 
        txa 
:       stx T                   ; use the byte-index to scramble        ;$89FD
        eor T
        ror 
        adc checksum_data-1, x
        eor checksum_data-0, x
        dex 
        bne :-
        rts 


_JAMESON:                                               ; BBC: JAMESON  ;$8A0C
;===============================================================================
; reset the current save-game:
;
; copies a dummy save game over the last-saved game data; note that
; this doesn't change the in-play game state, only the last-saved state
;-------------------------------------------------------------------------------
        ; copy $2619..$267A to $25AB..$260C

        ldy # $61               ;=97; length of the save-data

:       lda default_name, y                                             ;$8A0E
        sta save_name, y
        dey 
        bpl :-

        ldy # $07               ; reset commander-name length
        sty _8bbf

        rts 


_8a1d:                                                                  ;$8A1D
;===============================================================================
        ldx # $07
        lda _8bbe
        sta _8bbf
_8a25:                                                                  ;$8A25
        lda ZP_SHIP_YPOS_SIGN, x
        sta save_name, x
        dex 
        bpl _8a25
_8a2d:                                                                  ;$8A2D
        ldx # $07
_8a2f:                                                                  ;$8A2F
        lda save_name, x
        sta ZP_SHIP_YPOS_SIGN, x
        dex 
        bpl _8a2f
        rts 

        ; get filename input?
_8a38:                                                                  ;$8A38
        ldx # $04
_8a3a:                                                                  ;$8A3A
        lda save_prefix, x
        sta ZP_SHIP_XPOS_LO, x
        dex 
        bpl _8a3a
        lda # $07
        sta _8ab2

.import MSG_DOCKED_COMMANDERS_NAME_QMARK:direct
        lda # MSG_DOCKED_COMMANDERS_NAME_QMARK
        jsr print_docked_str

        jsr tkn_docked_fn1A
        lda # $09
        sta _8ab2
        tya 
        beq _8a2d
        sty _8bbe
        rts 


tkn_docked_fn1A:                                                        ;$8A5B
;===============================================================================
.export tkn_docked_fn1A

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
        sta ZP_SHIP_YPOS_SIGN, y
        iny 
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit
@_8a8d:
        lda # $07               ; BEEP?                                 ;$8A8D
@_8a8f:
        jsr paint_char                                                  ;$8A8F
        bcc _8a6a               ; always branches?

@_8a94:                                                                 ;$8A94
        sta ZP_SHIP_YPOS_SIGN, y

        lda # $10
        sta VAR_050C

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # TXT_NEWLINE
        jmp paint_char
.else   ;///////////////////////////////////////////////////////////////////////
        jmp paint_newline
.endif  ;///////////////////////////////////////////////////////////////////////

@_8aa1:                                                                 ;$8AA1
        ;-----------------------------------------------------------------------
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


; in the original code, segment "CODE_8AB5" appears here                ;$8AB5


.segment        "CODE_8AC7"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_ZERO:                                                  ; BBC: ZERO     ;$8AC7
;===============================================================================
; clear the ship slots and related variables:
;-------------------------------------------------------------------------------
        ; erase the ship slots and the flight variables
        ; up to and including `VAR_048C`
        ;
        ; TODO: this should be made into its own segement
        ;
        ldx # VAR_048C - SHIP_SLOTS
        lda # 0
:       sta SHIP_SLOTS, x                                               ;$8ACB
        dex 
        bpl :-

        rts 

.ifdef  BUILD_ORIGINAL
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


; NOTE: in the original code, segment "CODE_8AE7" appears here          ;$8AE7
; NOTE: in the original code, segment "CODE_8C6D" appears here          ;$8C6D


.segment        "CODE_8C7A"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
        rts                     ; superfluous rts                       ;$8C7A
;///////////////////////////////////////////////////////////////////////////////
.endif

_SPS4:                                                  ; BBC: SPS4     ;$8C7B
;===============================================================================
; get vector to space-station:
;-------------------------------------------------------------------------------
        ldx # $00
        jsr _7c11

        ldx # $03
        jsr _7c11

        ldx # $06
        jsr _7c11
_8c8a:                                                                  ;$8C8A
        lda ZP_SHIP01_XPOS_pt1
        ora ZP_SHIP01_YPOS_pt1
        ora ZP_SHIP01_ZPOS_pt1
        ora # %00000001
        sta ZP_SHIP01_POS

        lda ZP_SHIP01_XPOS_pt2
        ora ZP_SHIP01_YPOS_pt2
        ora ZP_SHIP01_ZPOS_pt2
_8c9a:                                                                  ;$8C9A
        asl ZP_SHIP01_POS
        rol 
        bcs _8cad

        asl ZP_SHIP01_XPOS_pt1
        rol ZP_SHIP01_XPOS_pt2
        asl ZP_SHIP01_YPOS_pt1
        rol ZP_SHIP01_YPOS_pt2
        asl ZP_SHIP01_ZPOS_pt1
        rol ZP_SHIP01_ZPOS_pt2
        bcc _8c9a
_8cad:                                                                  ;$8CAD
        lda ZP_SHIP01_XPOS_pt2
        lsr 
        ora ZP_SHIP01_XPOS_pt3
        sta ZP_VAR_XX15_0
        lda ZP_SHIP01_YPOS_pt2
        lsr 
        ora ZP_SHIP01_YPOS_pt3
        sta ZP_VAR_XX15_1
        lda ZP_SHIP01_ZPOS_pt2
        lsr 
        ora ZP_SHIP01_ZPOS_pt3
        sta ZP_VAR_XX15_2
_8cc2:                                                                  ;$8CC2
        lda ZP_VAR_XX15_0
        jsr math_square_7bit
        sta R
        lda ZP_VAR_P1
        sta Q
        lda ZP_VAR_XX15_1
        jsr math_square_7bit
        sta T
        lda ZP_VAR_P1
        adc Q
        sta Q
        lda T
        adc R
        sta R
        lda ZP_VAR_XX15_2
        jsr math_square_7bit
        sta T
        lda ZP_VAR_P1
        adc Q
        sta Q
        lda T
        adc R
        sta R
        jsr square_root
        lda ZP_VAR_XX15_0
        jsr _918b
        sta ZP_VAR_XX15_0
        lda ZP_VAR_XX15_1
        jsr _918b
        sta ZP_VAR_XX15_1
        lda ZP_VAR_XX15_2
        jsr _918b
        sta ZP_VAR_XX15_2
        rts 


; NOTE: in the original code, segment "CODE_8D0C" appears here          ;$8D0C


.segment        "CODE_8E29"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

do_quickjump:                                           ; BBC: WARP     ;$8E29
;===============================================================================
        ; reasons not to quick-jump:
        ;
        ldx NUM_ASTEROIDS       ; there are asteroids?
        lda SHIP_SLOT2, x
        ; NOTE: `.loword` is needed here to force a 16-bit
        ;       parameter size and silence an assembler warning
        ora .loword( SHIP_TYPES + HULL_STATION )
        ora IS_WITCHSPACE       ; we are in witchspace
       .bnz @nojump             ; -- cannot quick-jump

        ; check player's Z-position
        ;
        ldy ship_00 + Ship::zpos + 2                                    ;=$F908
        bmi :+

        ; note that A is zero due to the
        ; tests above mandating a zero result
        tay 
        jsr _MAS2
        cmp # $02               ; minimum distance? ($020000?)
        bcc @nojump

:       ldy ship_01 + Ship::zpos + 2                                    ;$8E44
        bmi :+
        ; check the sun's position?
        ldy # .sizeof( Ship )
        jsr _2c4e
        cmp # $02               ; minimum distance?
        bcc @nojump

:       lda # $81               ; jump distance?                        ;$8E52
        sta S
        sta R
        sta ZP_VAR_P

        ; push the player forward
        ;
        lda ship_00 + Ship::zpos + 2
        jsr multiplied_now_add
        sta ship_00 + Ship::zpos + 2

        lda ship_01 + Ship::zpos + 2
        jsr multiplied_now_add
        sta ship_01 + Ship::zpos + 2

        lda # $01
        sta ZP_SCREEN
        sta MAIN_COUNTER
        lsr 
        sta VAR_048A

        ldx COCKPIT_VIEW
        jmp _a6ba               ; redraw viewport?

@nojump:                                                                ;$8E7C
        ;-----------------------------------------------------------------------
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        ldy # $06               ; "sound low beep"?
        jmp play_sfx
.else   ;///////////////////////////////////////////////////////////////////////
        rts
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  BUILD_ORIGINAL
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


.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; read key?
; ununsed / unreferenced?

        ; turn the I/O area on to manage the CIA ports
        lda # C64_MEM::IO_ONLY                                          ;$8E99
        jsr set_memory_layout

        sei                     ; disable interrupts
        stx CIA1_PORTA
        ldx CIA1_PORTB
        cli                     ; enable interrupts
        inx 
        beq :+
        ldx # $ff

        ; turn off I/O, go back to 64K RAM
:       lda # C64_MEM::ALL                                              ;$8EAB
        jsr set_memory_layout
        txa 
        rts 

        rts                                                             ;$8EB2

        ; unused / unreferenced?
        lda _9274, x                                                    ;$8EB3
        eor opt_flipaxis

        rts

;///////////////////////////////////////////////////////////////////////////////
.endif


_8eba:                                                                  ;$8EBA
;===============================================================================
; flip flags?
;
; in:   Y       some index
;       X       some comparison value
;-------------------------------------------------------------------------------
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
@rts:   rts                                                             ;$8ED4


_8ed5:                                                                  ;$8ED5
;===============================================================================
; clears the key-states for 56 keys, not 64?
;-------------------------------------------------------------------------------
        lda # $00
        ldy # 56                ; only 56 keys, not 64

:       sta key_states, y                                               ;$8ED9
        dey 
        bne :-

        sta VAR_0441
        rts 


_8ee3:                                                                  ;$8EE3
;===============================================================================
        jsr get_input

        lda DOCKCOM_STATE
        beq _8f4d

        jsr clear_zp_ship

        lda # $60               ; this is the $6000 vector scale?
        sta ZP_SHIP_M0x2_HI
        ora # %10000000
        sta ZP_SHIP_M2x0_HI
        sta ZP_SHIP_TYPE

        lda ZP_PLAYER_SPEED
        sta ZP_SHIP_SPEED
        jsr _34bc
        lda ZP_SHIP_SPEED
_8f01:                                                                  ;$8F01
        cmp # $16
        bcc :+

        lda # $16
:       sta ZP_PLAYER_SPEED                                             ;$8F07

        lda # $ff
        ldx # $09
        ldy ZP_SHIP_ACCEL
        beq _8f18
        bmi _8f15

        ldx # $04
_8f15:                                                                  ;$8F15
        sta key_states, x
_8f18:                                                                  ;$8F18
        lda # $80
        ldx # $11
        asl ZP_SHIP_ROLL
        beq _8f35
        bcc _8f24

        ldx # $14
_8f24:                                                                  ;$8F24
        bit ZP_SHIP_ROLL
        bpl _8f2f

        lda # $40
        sta JOY_ROLL

        lda # $00
_8f2f:                                                                  ;$8F2F
        sta key_states, x

        lda JOY_ROLL
_8f35:                                                                  ;$8F35
        sta JOY_ROLL
        lda # $80
        ldx # $29
        asl ZP_SHIP_PITCH
        beq _8f4a
        bcs _8f44
        ldx # $33
_8f44:                                                                  ;$8F44
        sta key_states, x
        lda JOY_PITCH
_8f4a:                                                                  ;$8F4A
        sta JOY_PITCH
_8f4d:                                                                  ;$8F4D
        ldx JOY_ROLL
        lda # $0e
        ldy joy_left
        beq _8f5a
        jsr _3c6f
_8f5a:                                                                  ;$8F5A
        ldy joy_right
        beq _8f62
        jsr _3c7f
_8f62:                                                                  ;$8F62
        stx JOY_ROLL
        ldx JOY_PITCH
        ldy joy_down
        beq _8f70
        jsr _3c7f
_8f70:                                                                  ;$8F70
        ldy joy_up
        beq _8f78
        jsr _3c6f
_8f78:                                                                  ;$8F78
        stx JOY_PITCH
        lda opt_joystick
        beq _8f9d
        lda DOCKCOM_STATE
        bne _8f9d
        ldx # $80
        lda joy_left
        ora joy_right
        bne _8f92
        stx JOY_ROLL
_8f92:                                                                  ;$8F92
        lda joy_down
        ora joy_up
        bne _8f9d
        stx JOY_PITCH
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
        bit _PATG
        bpl _8fca
_8fc2:                                                                  ;$8FC2
        jsr _8eba               ; flip a flag?
        iny 
        cpy # $0d
        bne _8fc2
_8fca:                                                                  ;$8FCA
.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        lda _1d0d
        cmp _1d02
        beq _8fd5
        jsr _9231
.endif  ;///////////////////////////////////////////////////////////////////////

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


_8fea:                                                                  ;$8FEA
;===============================================================================
        sty ZP_PRESERVE_Y       ; backup Y

wait_for_input:                                         ; BBC: DOKEY    ;$8FEC
        ;-----------------------------------------------------------------------
        ldy # 2
        jsr wait_frames

        jsr get_input
        bne wait_for_input

:       jsr get_input                                                   ;$8FF6
        beq :-

        lda _927e, x

        ldy ZP_PRESERVE_Y       ; restore Y
        tax 
_9001:                                                                  ;$9001
        rts 


_9002:                                                                  ;$9002
;===============================================================================
        stx OSD_DELAY
        pha 
        lda VAR_04E6
        jsr _905d
        pla 

        ; fallthrough
        ; ...

_MESS:                                                  ; BBC: MESS     ;$900D
;===============================================================================
; prints an on-screen message:
; e.g. "INCOMING MISSILE"
;
; in:   A                       flight token
;-------------------------------------------------------------------------------
.export _MESS
        pha                     ; put aside flight message to print
        lda # 16                ; ident-level of message?

        ldx ZP_SCREEN           ; are we in the cockpit-view?
        beq _901a               ; yes, skip over

        ; clear bottom three lines of menu-screen
        ; to be able to print the on-screen message?
        jsr tkn_docked_fn15
        ; when in the menu (rather than the cockpit),
        ; display the message on row 25?? (this would be off-screen!)
        lda # 25

_9019: .bit                                                             ;$9019
       
_901a:  sta ZP_CURSOR_ROW                                               ;$901A

        ; set all capitals?
        ldx # %00000000
        stx ZP_PRINT_CASE

        ; set column, but why this variable?
        lda ZP_B9
       .set_cursor_col

        pla                     ; retrieve message-ID parameter
        ldy # 20
        cpx OSD_DELAY
        bne _9002
        sty OSD_DELAY
        sta VAR_04E6

        lda # %11000000
        sta txt_buffer_flag
        
        lda VAR_048C
        lsr                     ; note that this might set the carry
        lda # $00
        bcc :+
        lda # $0a
:       sta txt_buffer_index                                            ;$9042

        lda VAR_04E6
        jsr print_flight_token

        lda # $20
        sec 
        sbc txt_buffer_index
        lsr 
        sta ZP_B9
       .set_cursor_col

        jsr text_buffer_off
        lda VAR_04E6
_905d:                                                                  ;$905D
        jsr print_flight_token

        ; check bit 0 of the OSD flags by shifting it right
        ; and popping the bit off, if it exists
        lsr VAR_048C
        bcc _9001               ; if no bit, just exit

        ; append "destroyed" to the end
.import TKN_FLIGHT_DESTROYED:direct
        lda # TKN_FLIGHT_DESTROYED
        jmp print_flight_token


damage_cargo:                                                           ;$906A
;===============================================================================
; when the player takes damage with no shields, there's a chance
; that their cargo might be destroyed
;
;-------------------------------------------------------------------------------
        jsr get_random_number   ; get a random number in A & X
        bmi _9001               ; for A >= 128/256 (50% chance), exit (RTS)

        ; in addition to losing their cargo some of the player's equipment
        ; can be destroyed. whilst there are 17 types of tradable goods,
        ; random numbers 21 or below are selected which includes the equipment
        ; slots for their E.C.M., scoops, e-bomb, e-unit and docking computers.
        ; this does not include the galactic hyperdrive or escape pod, which
        ; could be included in this list by increasing the number below
        ;
        ; for X >= 22/256, (91% chance), also exit
        cpx # (PLAYER_DOCKCOM-PLAYER_CARGO)+1
        bcs _9001

        ; using X as our random cargo index,
        ; check if we have any
        ;
        lda PLAYER_CARGO, x     ; how much of that do we have?
        beq _9001               ; nothing to lose, exit
        
        lda OSD_DELAY           ; is there a message already on screen?
        bne _9001               ; yes, don't double-up messages

        ; note that due to the nature of the check above,
        ; A must be zero; i.e. OSD_DELAY = 0
        ;
        ldy # %00000011
        sty VAR_048C            ; message flag?

        sta PLAYER_CARGO, x     ; remove all of that type of cargo
        cpx # .sizeof( Cargo )  ; was it equipment? (i.e X > tradable goods)
        bcs :+

        txa 
.import TKN_FLIGHT_CARGO_TYPES:direct
        adc # TKN_FLIGHT_CARGO_TYPES
        jmp _MESS               ; print on-screen message?

        ;-----------------------------------------------------------------------
:       beq @ecm                                                        ;$908F
        cpx # $12
        beq @scoop

        txa 
        adc # $5d               ; TODO: flight token, but what one??
        jmp _MESS               ; print on-screen message?

@ecm:                                                                   ;$909B
.import TKN_FLIGHT_ECM_SYSTEM:direct
        lda # TKN_FLIGHT_ECM_SYSTEM
        jmp _MESS               ; print on-screen message?

@scoop:                                                                 ;$90A0
.import TKN_FLIGHT_FUEL_SCOOPS:direct
        lda # TKN_FLIGHT_FUEL_SCOOPS
        jmp _MESS               ; print on-screen message?


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
        and ZP_SHIP_ZPOS_LO, x
        cpy # $07

_90e9:                                                                  ;$90E9
        tya 
        ldy # $02
        jsr _91b8
        sta ZP_SHIP_M1x2_HI
        jmp _9131


_90f4:                                                                  ;$90F4
;===============================================================================
        tax 
        lda ZP_VAR_XX15_1
        and # %01100000
        beq _90e9
        lda # $02
        jsr _91b8
        sta ZP_SHIP_M1x1_HI
        jmp _9131


_9105:                                                                  ;$9105
;===============================================================================
        lda ZP_SHIP_M0x0_HI
        sta ZP_VAR_XX15_0
        lda ZP_SHIP_M0x1_HI
        sta ZP_VAR_XX15_1
        lda ZP_SHIP_M0x2_HI
        sta ZP_VAR_XX15_2
        jsr _8cc2
        lda ZP_VAR_XX15_0
        sta ZP_SHIP_M0x0_HI
        lda ZP_VAR_XX15_1
        sta ZP_SHIP_M0x1_HI
        lda ZP_VAR_XX15_2
        sta ZP_SHIP_M0x2_HI
        ldy # $04
        lda ZP_VAR_XX15_0
        and # %01100000
        beq _90f4
        ldx # $02
        lda # $00
        jsr _91b8
        sta ZP_SHIP_M1x0_HI
_9131:                                                                  ;$9131
        lda ZP_SHIP_M1x0_HI
        sta ZP_VAR_XX15_0
        lda ZP_SHIP_M1x1_HI
        sta ZP_VAR_XX15_1
        lda ZP_SHIP_M1x2_HI
        sta ZP_VAR_XX15_2
        jsr _8cc2
        lda ZP_VAR_XX15_0
        sta ZP_SHIP_M1x0_HI
        lda ZP_VAR_XX15_1
        sta ZP_SHIP_M1x1_HI
        lda ZP_VAR_XX15_2
        sta ZP_SHIP_M1x2_HI
        lda ZP_SHIP_M0x1_HI
        sta Q
        lda ZP_SHIP_M1x2_HI
        jsr multiply_signed_into_RS
        ldx ZP_SHIP_M0x2_HI
        lda ZP_SHIP_M1x1_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_SHIP_M2x0_HI
        lda ZP_SHIP_M1x0_HI
        jsr multiply_signed_into_RS
        ldx ZP_SHIP_M0x0_HI
        lda ZP_SHIP_M1x2_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_SHIP_M2x1_HI
        lda ZP_SHIP_M1x1_HI
        jsr multiply_signed_into_RS
        ldx ZP_SHIP_M0x1_HI
        lda ZP_SHIP_M1x0_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_SHIP_M2x2_HI
        lda # $00
        ldx # $0e
_9184:                                                                  ;$9184
        sta ZP_SHIP_M0x0_LO, x
        dex 
        dex 
        bpl _9184
        rts 


_918b:                                                                  ;$918B
;===============================================================================
        tay 
        and # %01111111
        cmp Q
        bcs _91b2
        ldx # $fe
        stx T
_9196:                                                                  ;$9196
        asl 
        cmp Q
        bcc _919d
        sbc Q
_919d:                                                                  ;$919D
        rol T
        bcs _9196
        lda T
        lsr 
        lsr 
        sta T
        lsr 
        adc T
        sta T
        tya 
        and # %10000000
        ora T
        rts 

_91b2:                                                                  ;$91B2
        tya 
        and # %10000000
        ora # %01100000
        rts 


_91b8:                                                                  ;$91B8
;===============================================================================
        sta ZP_VAR_P3
        lda ZP_SHIP_M0x0_HI, x
        sta Q
        lda ZP_SHIP_M1x0_HI, x
        jsr multiply_signed_into_RS
        ldx ZP_SHIP_M0x0_HI, y
        stx Q
        lda ZP_SHIP_M1x0_HI, y
        jsr multiply_and_add
        stx ZP_VAR_P1
        ldy ZP_VAR_P3
        ldx ZP_SHIP_M0x0_HI, y
        stx Q
        eor # %10000000
        sta ZP_VAR_P2
        eor Q
        and # %10000000
        sta T
        lda # $00
        ldx # $10
        asl ZP_VAR_P1
        rol ZP_VAR_P2
        asl Q
        lsr Q
_91eb:                                                                  ;$91EB
        rol 
        cmp Q
        bcc _91f2
        sbc Q
_91f2:                                                                  ;$91F2
        rol ZP_VAR_P1
        rol ZP_VAR_P2
        dex 
        bne _91eb
        lda ZP_VAR_P1
        ora T
_91fd:                                                                  ;$91FD
        rts 

;===============================================================================
; if sound is disabled, this entire block can be ignored
;
.ifdef  FEATURE_AUDIO
;///////////////////////////////////////////////////////////////////////////////
_91fe:                                                                  ;$91FE
;-------------------------------------------------------------------------------
        ; title screen music?
        lda #< (_c164 - 1)
        ldx #> (_c164 - 1)
        bne _920d               ; (always branches, unless somehow
                                ;  the music data was in zero-page :P)

_9204:                                                                  ;$9204
;-------------------------------------------------------------------------------
        bit _1d11               ; docking music enabled?
        bmi _91fe

        ; docking music?
        lda #< (_b72d - 1)
        ldx #> (_b72d - 1)

_920d:                                                                  ;$920D
        ; set the address of the song data to play;
        ; the interrupt routine ("code_interrupts.asm")
        sta sound_play_addr_lo
        stx sound_play_addr_hi

        bit flag_music_playing  ; is any music currently playing?
        bmi _91fd               ; yes, exit

        bit _1d10
        bmi _9222
        
        bit _1d0d
        bmi _91fd               ; rts

        ; fallthrough
        ; ...

_9222:                                                                  ;$9222

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        inc CPU_CONTROL         ; enable I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        ; stop the currently playing song
        jsr sound_stop

.if     !.defined( BUILD_ORIGINAL )
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL         ; disable I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set flag to say music is playing?
        lda # $ff
        sta flag_music_playing
        bne _9266               ; (always branches)

_9231:                                                                  ;$9231
        sta _1d02               ;=$FF
        eor # %11111111
        and DOCKCOM_STATE
        bmi _9222

;///////////////////////////////////////////////////////////////////////////////
.endif

stop_sound:                                                             ;$923B
;===============================================================================
; stop SID chip?
;-------------------------------------------------------------------------------
        bit _1d13               ; user option?
        bmi _91fd               ; `rts`

.ifdef  FEATURE_AUDIO
        ;///////////////////////////////////////////////////////////////////////
        bit _1d10               ; user option?
        bmi _9204
.endif  ;///////////////////////////////////////////////////////////////////////

_9245:                                                                  ;$9245
        bit flag_music_playing
        bpl _91fd               ; $00 = no, exit

        jsr _a817

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn on I/O to access the SID
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # $00               ; clear 'music playing' flag
        sta flag_music_playing

        ; clear the SID registers ($D400...$D418)
        ldx # (SID_VOLUME_CTRL - SID_REGISTERS)
        ; interrupts must be disabled whilst we clear the SID registers as
        ; the interrupt routine ("code_interrupts.asm") writes to the SID
        ; if music is currently playing
        sei 

:       sta SID_REGISTERS, x    ; clear a SID register                  ;$925A
        dex                     ; move to the next
        bpl :-                  ; keep going?

        lda # 15                ; set SID volume
        sta SID_VOLUME_CTRL     ; (TODO: is 15 considered min or max?)

.if     !.defined( BUILD_ORIGINAL )
        ;///////////////////////////////////////////////////////////////////////
        dec CPU_CONTROL         ; disable I/O
.endif  ;///////////////////////////////////////////////////////////////////////
        cli                     ; enable interrupts

_9266:                                                                  ;$9266

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jmp set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; we must *not* decrement the memory map twice, so the decrements have
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
