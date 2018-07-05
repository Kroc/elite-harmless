; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================
.linecont+

.include        "c64.asm"
.include        "elite_vars.asm"

; yes, I am aware that cc65 allows for 'default import of undefined labels'
; but I want to keep track of things explicitly for clarity and helping others

; from "text_flight.asm"
.import _0700:absolute
.import _0ac0:absolute

; from "code_1D00.asm"
.import _1d01:absolute
.import _1d02:absolute
.import _1d03:absolute
.import _1d04:absolute
.import _1d05:absolute
.import _1d06:absolute
.import _1d08:absolute
.import _1d0a:absolute
.import _1d0b:absolute
.import _1d0c:absolute
.import _1d0d:absolute
.import _1d0e:absolute
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
.import _26a4:absolute
.import _27a4:absolute
.import _28a4:absolute
.import _28d5:absolute
.import _28d9:absolute
.import txt_docked_token0B:absolute
.import _28e0:absolute
.import _28e5:absolute
.import _28f3:absolute
.import _2900:absolute
.import _2907:absolute
.import _2918:absolute
.import _293a:absolute
.import _2977:absolute
.import dust_swap_xy:absolute
.import _2c4e:absolute
.import _2c50:absolute
.import _2c9b:absolute
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
.import _3986:absolute
.import _3988:absolute
.import _399b:absolute
.import _39e0:absolute
.import _39ea:absolute
.import _3a25:absolute
.import _3a27:absolute
.import _3aa8:absolute
.import _3ace:absolute
.import _3ad1:absolute
.import _3b0d:absolute
.import _3b37:absolute
.import _3bc1:absolute
.import _3c6f:absolute
.import _3c7f:absolute
.import _3c95:absolute
.import _3d2f:absolute
.import _3e08:absolute
.import _3e87:absolute
.import _3e95:absolute
.import wait_frames:absolute

; from "gfx/hulls.asm"
.import _d000:absolute


.exportzp       ZP_CURSOR_COL   := $31
.exportzp       ZP_CURSOR_ROW   := $33

;===============================================================================

.segment        "CODE_6A00"

_6a00:                                                                  ;$6A00
.export _6a00
        sta $04ef
        lda # $01
_6a05:  pha                                                             ;$6a05 
        ldx # $0c
        cpx $04ef
        bcc _6a1b                                                       
_6a0d:  adc $04b0, x                                                    ;$6a0d
        dex 
        bpl _6a0d
        adc PLAYER_TRUMBLES_HI
        cmp $04af
        pla 
        rts

_6a1b:                                                                  ;$6a1b
        ldy $04ef
        adc $04b0, y
        cmp # $c8
        pla 
        rts


.proc   set_cursor_col                                                  ;$6A25
        ;=======================================================================
        ; set the cursor column (where text printing occurs)
        ;
        ; A = column number
        ;
.export set_cursor_col

        sta ZP_CURSOR_COL
        rts 
.endproc

.proc   set_cursor_row                                                  ;$6A28
        ;=======================================================================
        ; set the cursor row (where text printing occurs)
        ;
        ; A = row number
        ;
.export set_cursor_row

        sta ZP_CURSOR_ROW
        rts 
.endproc

.proc   cursor_down                                                     ;$6A2b
        ;=======================================================================
        ; move the cursor down a row (does not change column!)
        ;
.export cursor_down

        inc ZP_CURSOR_ROW
        rts 
.endproc

;===============================================================================

_6a2e:                                                                  ;$62ae
        rts 
_6a2f:                                                                  ;$6a2f
.export _6a2f
        jsr _a72f
        jsr _28d5
        lda # $30
        jsr _6a2e
        rts 

; RNG?

_6a3b:  ; roll RNG seed four times?                                     ;$6A3b
;===============================================================================
.export _6a3b

        ; this routine calls itself 4 times to ensure
        ; enough scrambling of the random number
        jsr :+                  ; do this twice,                                             
:       jsr _6a41               ; and that twice                        ;$6A3e

_6a41:  ; roll the RNG seed once?                                       ;$6A41
        ;=======================================================================
        lda ZP_SEED_pt1                                                 
        clc 
        adc ZP_SEED_pt3
        tax 
        lda ZP_SEED_pt2
        adc ZP_SEED_pt4
        tay 
        lda ZP_SEED_pt3
        sta ZP_SEED_pt1
        lda ZP_SEED_pt4
        sta ZP_SEED_pt2
        lda ZP_SEED_pt6
        sta ZP_SEED_pt4
        lda ZP_SEED_pt5
        sta ZP_SEED_pt3
        clc 
        txa 
        adc ZP_SEED_pt3
        sta ZP_SEED_pt5
        tya 
        adc ZP_SEED_pt4
        sta ZP_SEED_pt6
        
        rts 

;===============================================================================

_6a68:                                                                  ;$6a68
        ; is target system distance > 0
        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
       .bnz :+

        jmp cursor_down

        ;-----------------------------------------------------------------------
        ; print "DISTANCE:"

.import TXT_DISTANCE:direct

:       lda # TXT_DISTANCE                                              ;$6A73
        jsr print_flight_token_with_colon

        ldx TSYSTEM_DISTANCE_LO
        ldy TSYSTEM_DISTANCE_HI
        sec 
        jsr _7235

.import TXT_LIGHT_YEARS:direct
        lda # TXT_LIGHT_YEARS

_6a84:                                                                  ;$6A84
        ;-----------------------------------------------------------------------
        jsr print_flight_token
_6a87:                                                                  ;$6a87
        jsr cursor_down
_6a8a:                                                                  ;$6a8a
        lda # $80
        sta $34

_6a8e:                                                                  ;$6a8e
        lda # $0c
        jmp print_flight_token


_6a93:                                                                  ;$6A93
;===============================================================================
        ; print "MAINLY"
        ;
.import TXT_MAINLY:direct
        lda # TXT_MAINLY
        jsr print_flight_token
        jmp _6ad3

;===============================================================================

_6a9b:                                                                  ;$6a9b
.export _6a9b
        jsr print_flight_token
        jmp _72c5

;===============================================================================

_6aa1:                                                                  ;$6aa1:
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
_6ace:                                                                  ;$6ace
.import TXT_RICH:direct
        
        ; "RICH" / "AVERAGE" / "POOR"
        
        adc # TXT_RICH
        jsr print_flight_token
_6ad3:                                                                  ;$6ad3
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
        
        lda ZP_SEED_pt5
        bmi :+

.import TXT_HUMAN_COLONIAL:direct
        lda # TXT_HUMAN_COLONIAL
        jsr print_flight_token
        
        jmp _6b5a

:       lda ZP_SEED_pt6                                                 ;$61BE
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
_6b3b:                                                                  ;$6b3b
        lda ZP_SEED_pt4
        eor ZP_SEED_pt2
        and # %00000111
        sta $8e
        cmp # $06
        bcs _6b4c

.import TXT_ADJECTIVES:direct

        ; "HARMLESS" / "SLIMY" / "BUG-EYED" / "HORNED" /
        ; "BONY" / "FAT" / "FURRY"

        adc # TXT_ADJECTIVES+1  ; +1, because of borrow?
        jsr _6a9b
_6b4c:                                                                  ;$6b4c
        lda ZP_SEED_pt6
        and # %00000011
        clc 
        adc $8e
        and # %00000111
        
.import TXT_SPECIES:direct

        ; "RODENT" / "FROG" / "LIZARD" / "LOBSTER" / "BIRD" / "HUMANOID" /
        ; "FELINE" / "INSECT"

        adc # TXT_SPECIES
        jsr print_flight_token
_6b5a:                                                                  ;$6b5a
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
        jsr _7234
        jsr _72c5
        lda # $00
        sta $34
        
        lda # 'm'
        jsr print_flight_token
        
.import TXT_CR:direct
        lda # TXT_CR
        jsr _6a84

.import TXT_AVERAGE_RADIUS:direct
        lda # TXT_AVERAGE_RADIUS
        jsr print_flight_token_with_colon
        
        lda ZP_SEED_pt6
        ldx ZP_SEED_pt4
        and # %00001111
        clc 
        adc # $0b
        tay 
        jsr _7235
        jsr _72c5

        lda # $6b               ;="K"
        jsr print_char
        
        lda # $6d               ;="M"
        jsr print_char
        
        jsr _6a87
;6ba5?
        jmp _3d2f

        rts 

;===============================================================================

_6ba9:                                                                  ;$6ba9
        lda ZP_SEED_pt2
        and # %00000111
        sta TSYSTEM_ECONOMY

        lda ZP_SEED_pt3
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

        lda ZP_SEED_pt4
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
        sta $2e
        
        lda TSYSTEM_GOVERNMENT
        adc # $04
        sta $9a
        
        jsr _399b
        
        lda TSYSTEM_POPULATION
        sta $9a
        
        jsr _399b
        
        asl $2e
        rol 
        asl $2e
        rol 
        asl $2e
        rol 
        sta TSYSTEM_PRODUCTIVITY_HI
        
        lda $2e
        sta TSYSTEM_PRODUCTIVITY_LO
        
        rts 

;===============================================================================

_6c1c:                                                                  ;$6c1c
        lda # $40
        jsr _a72f
        
        lda # $10
        jsr _6a2e

        lda # 7
        jsr set_cursor_col
        
        jsr _70a0

.import TXT_GALACTIC_CHART:direct
        lda # TXT_GALACTIC_CHART
        jsr print_flight_token
        
        jsr _28e0
        lda # $98
        jsr _28e5
        jsr _6cda
        ldx # $00
_6c40:                                                                  ;$6c40
        stx $9d
        ldx ZP_SEED_pt4
        ldy ZP_SEED_pt5
        tya 
        ora # %01010000
        sta VAR_Z
        lda ZP_SEED_pt2
        lsr 
        clc 
        adc # $18
        sta VAR_Y
        jsr _293a
        jsr _6a3b
        ldx $9d
        inx 
        bne _6c40
        lda TSYSTEM_POS_X
        sta $8e
        lda TSYSTEM_POS_Y
        lsr 
        sta $8f
        lda # $04
        sta $90
_6c6d:                                                                  ;$6c6d
        lda # $18
        ldx $a0
        bpl _6c75
        lda # $00
_6c75:                                                                  ;$6c75
        sta $93
        lda $8e
        sec 
        sbc $90
        bcs _6c80
        lda # $00
_6c80:                                                                  ;$6c80
        sta VAR_X
        lda $8e
        clc 
        adc $90
        bcc _6c8b
        lda # $ff
_6c8b:                                                                  ;$6c8b
        sta $6d
        lda $8f
        clc 
        adc $93
        sta VAR_Y
        sta $6e
        jsr _ab91
        lda $8f
        sec 
        sbc $90
        bcs _6ca2
        lda # $00
_6ca2:                                                                  ;$6ca2
        clc 
        adc $93
        sta VAR_Y
        lda $8f
        clc 
        adc $90
        adc $93
        cmp # $98
        bcc _6cb8
        ldx $a0
        bmi _6cb8
        lda # $97
_6cb8:                                                                  ;$6cb8
        sta $6e
        lda $8e
        sta VAR_X
        sta $6d
        jmp _ab91

;===============================================================================

_6cc3:                                                                  ;$6cc3
        lda #< $5a68
        sta $8e
        lda #> $5a68
        sta $8f
        lda # $10
        sta $90
        jsr _6c6d
        lda PLAYER_FUEL
        sta $77
        jmp _6cfe

_6cda:                                                                  ;$6cda
        lda $a0
        bmi _6cc3
        lda PLAYER_FUEL
        lsr 
        lsr 
        sta $77

        lda PSYSTEM_POS_X
        sta $8e
        
        lda PSYSTEM_POS_Y
        lsr 
        sta $8f
        
        lda # $07
        sta $90
        
        jsr _6c6d
        
        lda $8f
        clc 
        adc # $18
        sta $8f
_6cfe:                                                                  ;$6cfe
        lda $8e
        sta $35
        lda $8f
        sta $43
        ldx # $00
        stx $44
        stx $36
        inx 
        stx $7e
        ldx # $02
        stx $ac
        jmp _805e

;===============================================================================

_6d16:                                                                  ;$6d16
        lda # $02
        jsr _6a2f
        jsr _72db
        lda # $80
        sta $34
        lda # $00
        sta $04ef
_6d27:                                                                  ;$6d27
        jsr _7246
        lda $04ed
        bne _6d3e
        jmp _6da4

_6d32:                                                                  ;$6d32
        ldy # $b0
_6d34:                                                                  ;$6d34
        jsr _72c5
        tya 
        jsr _723c
        jsr _7627
_6d3e:                                                                  ;$6d3e
        jsr txt_docked_token15
        
.import TXT_QUANTITY_OF:direct
        lda # TXT_QUANTITY_OF
        jsr print_flight_token

        ; "FOOD", "TEXTILES", "RADIOACTIVES", "SLAVES", "LIQUOR/WINES",
        ; "LUXURIES", "NARCOTICS", "COMPUTERS", "MACHINERY", "ALLOYS",
        ; "FIREARMS", "FURS", "MINERALS", "GOLD", "PLATINUM", "GEM-STONES"
.import TXT_FOOD:direct

        lda $04ef
        clc 
        adc # TXT_FOOD
        jsr print_flight_token
        
        lda # $2f
        jsr print_flight_token
        
        jsr _72b8

        lda # $3f
        jsr print_flight_token
        
        jsr _6a8e
        ldx # $00
        stx $9b
        ldx # $0c
        stx $06
        jsr _6dc9
        bcs _6d32
        sta $2e
        jsr _6a05
        ldy # $ce
        lda $9b
        beq _6d79
        bcs _6d34
_6d79:                                                                  ;$6d79
        lda $04ec
        sta $9a
        jsr _74a2
        jsr _745a
        ldy # $c5
        bcc _6d34
        ldy $04ef
        lda $9b
        pha 
        clc 
        adc $04b0, y
        sta $04b0, y
        lda $04ce, y
        sec 
        sbc $9b
        sta $04ce, y
        pla 
        beq _6da4
        jsr _761f
_6da4:                                                                  ;$6da4
        lda $04ef
        clc 
        adc # 5
        jsr set_cursor_row
        lda # 0
        jsr set_cursor_col
        
        inc $04ef
        lda $04ef
        cmp # $11
        bcs _6dbf
        jmp _6d27
_6dbf:                                                                  ;$6dbf
        lda # $10
        sta $050c
        lda # $20
        jmp _86a4

_6dc9:                                                                  ;$6dc9
        lda # $40
        sta $050c
        ldx # $00
        stx $9b
        ldx # $0c
        stx $06
_6dd6:                                                                  ;$6dd6
        jsr _8fea
        ldx $9b
        bne _6de5
        cmp # $59
        beq _6e1b
        cmp # $4e
        beq _6e26
_6de5:                                                                  ;$6de5
        sta $9a
        sec 
        sbc # $30
        bcc _6e13
        cmp # $0a
        bcs _6dbf
        sta $9c
        lda $9b
        cmp # $1a
        bcs _6e13
        asl 
        sta $bb
        asl 
        asl 
        adc $bb
        adc $9c
        sta $9b
        cmp $04ed
        beq _6e0a
        bcs _6e13
_6e0a:                                                                  ;$6e0a
        lda $9a
        jsr print_char

        dec $06
        bne _6dd6
_6e13:                                                                  ;$6e13
        lda # $10
        sta $050c
        lda $9b
        rts 
_6e1b:                                                                  ;$6e1b
        jsr print_char
        lda $04ed
        sta $9b
        jmp _6e13
_6e26:                                                                  ;$6e26
        jsr print_char
        lda # $00
        sta $9b
        jmp _6e13
_6e30:                                                                  ;$6e30
        jsr _6a8e

.import TXT_QUANTITY:direct
        lda # TXT_QUANTITY
        jsr _723c

        jsr _7627
        ldy $04ef
        jmp _6e5d
_6e41:                                                                  ;$6e41
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

        jsr _6a8e
_6e58:                                                                  ;$6e58
        ldy # $00
_6e5a:                                                                  ;$6e5a
        sty $04ef
_6e5d:                                                                  ;$6e5d
        ldx $04b0, y
        beq _6eca
        tya 
        asl 
        asl 
        tay 
        lda _90a6, y
        sta $8f
       .phx                     ; push X to stack (via A)
        jsr _6a8a
        
        clc 
        lda $04ef

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
        sta $04ed
        clc 
        jsr print_tiny_value
        jsr _72b8
        lda $a0
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
        lda $04ef
        ldx # $ff
        stx $34
        jsr _7246
        ldy $04ef
        lda $04b0, y
        sec 
        sbc $9b
        sta $04b0, y
        lda $9b
        sta $2e
        lda $04ec
        sta $9a
        jsr _74a2
        jsr _7481
        lda # $00
        sta $34
_6eca:                                                                  ;$6eca
        ldy $04ef
        iny 
        cpy # $11
        bcc _6e5a
        lda $a0
        cmp # $04
        bne _6ede
        jsr _7627
        jmp _6dbf
_6ede:                                                                  ;$6ede
        jsr _6a8a
        lda PLAYER_TRUMBLES_LO
        ora PLAYER_TRUMBLES_HI
        bne _6eea
_6ee9:                                                                  ;$6ee9
        rts 

_6eea:                                                                  ;$6eea
        ;-----------------------------------------------------------------------
        ; have you got Trumbles™ in your hold?

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
        
.import TXT_DOCKED_LITTLE_TRUMBLE:direct
        lda # TXT_DOCKED_LITTLE_TRUMBLE
        jsr print_docked_str
        
        lda PLAYER_TRUMBLES_HI
        bne _6f11
        ldx PLAYER_TRUMBLES_LO
        dex 
        beq _6ee9
_6f11:                                                                  ;$6f11
        lda # $73               ;="S"
        jmp print_char

;===============================================================================

_6f16:                                                                  ;$6f16
        lda # $08
        jsr _6a2f

        lda # 11
        jsr set_cursor_col
        
.import TXT_INVENTORY:direct
        lda # TXT_INVENTORY
        jsr _6a84

        jsr txt_docked_token0B
        jsr _774a
        lda $04af
        cmp # $1a
        bcc _6f37

.import TXT_LARGE_CARGO_BAY:direct
        lda # TXT_LARGE_CARGO_BAY
        jsr print_flight_token
_6f37:                                                                  ;$6f37
        jmp _6e58

;===============================================================================

; dead code?

_6f3a:                                                                  ;$6f3a
        jsr print_flight_token

        lda # $ce
        jsr print_docked_str

        jsr _8fea
        ora # %00100000
        cmp # $79
        beq _6f50

        lda # $6e               ;="N"
        jmp print_char
_6f50:                                                                  ;$6f50
        jsr print_char
        sec 
        rts 

;===============================================================================

_6f55:                                                                  ;$6f55
       .phx                     ; push X to stack (via A)
        dey 
        tya 
        eor # %11111111
        pha 
        jsr wait_for_frame
        jsr _6f82
        pla 
        sta $91

        lda TSYSTEM_POS_Y
        jsr _6f98
        
        lda $92
        sta TSYSTEM_POS_Y
        sta $8f
        
        pla 
        sta $91
        
        lda TSYSTEM_POS_X
        jsr _6f98
        
        lda $92
        sta TSYSTEM_POS_X
        sta $8e
_6f82:                                                                  ;$6f82
.export _6f82
        lda $a0
        bmi _6fa9
        lda TSYSTEM_POS_X
        sta $8e
        lda TSYSTEM_POS_Y
        lsr 
        sta $8f
        lda # $04
        sta $90
        jmp _6c6d
_6f98:                                                                  ;$6f98
        sta $92
        clc 
        adc $91
        ldx $91
        bmi _6fa4
        bcc _6fa6
        rts 

_6fa4:                                                                  ;$6fa4
        bcc _6fa8
_6fa6:                                                                  ;$6fa6
        sta $92
_6fa8:                                                                  ;$6fa8
        rts 

_6fa9:                                                                  ;$6fa9
        lda TSYSTEM_POS_X
        sec 
        sbc PSYSTEM_POS_X
        cmp # $26
        bcc _6fb8
        cmp # $e6
        bcc _6fa8
_6fb8:                                                                  ;$6fb8
        asl 
        asl 
        clc 
        adc # $68
        sta $8e
        lda TSYSTEM_POS_Y
        sec 
        sbc PSYSTEM_POS_Y
        cmp # $26
        bcc _6fce
        cmp # $dc
        bcc _6fa8
_6fce:                                                                  ;$6fce
        asl 
        clc 
        adc # $5a
        sta $8f
        lda # $08
        sta $90
        jmp _6c6d

;===============================================================================

_6fdb:                                                                  ;$6fdb
        lda # $c7
        sta $b8
        sta $b7
        lda # $80
        jsr _a72f
        lda # $10
        jsr _6a2e

        lda # 7
        jsr set_cursor_col
        
.import TXT_SHORT_RANGE_CHART:direct
        lda # TXT_SHORT_RANGE_CHART
        jsr _28d9

        jsr _6cda
        jsr _6f82
        jsr _70a0
        lda # $00
        sta $ae
        ldx # $18
_7004:                                                                  ;$7004
        sta ZP_POLYOBJ_XPOS_pt1, x
        dex 
        bpl _7004
_7009:                                                                  ;$7009
        lda ZP_SEED_pt4
        sec 
        sbc PSYSTEM_POS_X
        bcs _7015
        eor # %11111111
        adc # $01
_7015:                                                                  ;$7015
        cmp # $14
        bcs _708d
        lda ZP_SEED_pt2
        sec 
        sbc PSYSTEM_POS_Y
        bcs _7025
        eor # %11111111
        adc # $01
_7025:                                                                  ;$7025
        cmp # $26
        bcs _708d
        lda ZP_SEED_pt4
        sec 
        sbc PSYSTEM_POS_X
        asl 
        asl 
        adc # $68
        sta $71
        lsr 
        lsr 
        lsr 
        clc 
        adc # 1
        jsr set_cursor_col

        lda ZP_SEED_pt2
        sec 
        sbc PSYSTEM_POS_Y
        asl 
        adc # $5a
        sta $43
        lsr 
        lsr 
        lsr 
        tay 
        ldx ZP_POLYOBJ_XPOS_pt1, y
        beq _705c
        iny 
        ldx ZP_POLYOBJ_XPOS_pt1, y
        beq _705c
        dey 
        dey 
        ldx ZP_POLYOBJ_XPOS_pt1, y
        bne _7070
_705c:                                                                  ;$705c
        tya 
        jsr set_cursor_row

        cpy # $03
        bcc _708d
        lda # $ff
        sta $0009, y            ;16-bit reference?
        lda # $80
        sta $34
        jsr _76e9
_7070:                                                                  ;$7070
        lda # $00
        sta $36
        sta $44
        sta $78
        lda $71
        sta $35
        lda ZP_SEED_pt6
        and # %00000001
        adc # $02
        sta $77
        jsr _7b4f
        jsr _7f22
        jsr _7b4f
_708d:                                                                  ;$708d
        jsr _6a3b
        inc $ae
        beq _7097
        jmp _7009

_7097:                                                                  ;$7097
        lda #< (_8eff+1)        ;incorrect disassembly?
        sta $b7
        lda #> (_8eff+1)        ;incorrect disassembly?
        sta $b8
        rts 

;===============================================================================

; to do with the seed

_70a0:                                                                  ;$70a0
.export _70a0
        ldx # 5                 ; seed is 6 bytes
_70a2:                                                                  ;$70a2
        lda $049c, x
        sta ZP_SEED, x          ; store at $7F...$84
        dex 
        bpl _70a2
        rts 

;===============================================================================

_70ab:                                                                  ;$70ab
.export _70ab
        jsr _70a0
        ldy # $7f
        sty $bb
        lda # $00
        sta $99
_70b6:                                                                  ;$70b6
        lda ZP_SEED_pt4
        sec 
        sbc TSYSTEM_POS_X
        bcs _70c2
        eor # %11111111
        adc # $01
_70c2:                                                                  ;$70c2
        lsr 
        sta $9c
        lda ZP_SEED_pt2
        sec 
        sbc TSYSTEM_POS_Y
        bcs _70d1
        eor # %11111111
        adc # $01
_70d1:                                                                  ;$70d1
        lsr 
        clc 
        adc $9c
        cmp $bb
        bcs _70e8
        sta $bb
        ldx # 5
_70dd:                                                                  ;$70dd
        lda ZP_SEED, x
        sta $8e, x
        dex 
        bpl _70dd
        lda $99
        sta VAR_Z
_70e8:                                                                  ;$70e8
        jsr _6a3b
        inc $99
        bne _70b6
        ldx # $05
_70f1:                                                                  ;$70f1
        lda $8e, x
        sta ZP_SEED, x
        dex 
        bpl _70f1

        ; select a random planet?

        lda ZP_SEED_pt2
        sta TSYSTEM_POS_Y
        lda ZP_SEED_pt4
        sta TSYSTEM_POS_X
        
        sec 
        sbc PSYSTEM_POS_X
        bcs :+
        eor # %11111111
        adc # $01
:       jsr _3988                                                       ;$710C
        sta $78

        lda $2e
        sta $77
        lda TSYSTEM_POS_Y
        sec 
        sbc PSYSTEM_POS_Y
        bcs _7122
        eor # %11111111
        adc # $01
_7122:                                                                  ;$7122
        lsr 
        jsr _3988
        pha 
        lda $2e
        clc 
        adc $77
        sta $9a
        pla 
        adc $78
        bcc _7135
        lda # $ff
_7135:                                                                  ;$7135
        sta $9b
        jsr _9978
        lda $9a
        asl 
        ldx # $00
        stx TSYSTEM_DISTANCE_HI
        rol TSYSTEM_DISTANCE_HI
        asl 
        rol TSYSTEM_DISTANCE_HI
        sta TSYSTEM_DISTANCE_LO
        jmp _6ba9

;===============================================================================

_714f:                                                                  ;$714f
        jsr txt_docked_token15

        lda # 15
        jsr set_cursor_col

        ; print "DOCKED"...
.import TXT_DOCKED_DOCKED:direct
        lda # TXT_DOCKED_DOCKED
        jmp print_docked_str

_715c:                                                                  ;$715c
        lda $a7
        bne _714f

        lda $66                 ; hyperspace countdown (outer)?
        beq _7165
        
        rts 

_7165:                                                                  ;$7165
        jsr _8e92
        bmi _71ca
        lda $a0
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

_717f:                                                                  ;$717f
        ldx # 5
_7181:                                                                  ;$7181
        lda ZP_SEED, x
        sta $04fa, x
        dex 
        bpl _7181

        lda # 7
        jsr set_cursor_col
        
        lda # $17
        ldy $a0
        bne _7196
        lda # $11
_7196:                                                                  ;$7196
        jsr set_cursor_row
        lda # $00
        sta $34

.import TXT_HYPERSPACE:direct
        lda # TXT_HYPERSPACE
        jsr print_flight_token
        
        lda TSYSTEM_DISTANCE_HI
        bne _71af
        lda PLAYER_FUEL
        cmp TSYSTEM_DISTANCE_LO
        bcs _71b2
_71af:                                                                  ;$71af
        jmp _723a

_71b2:                                                                  ;$71b2
        lda # $2d
        jsr print_flight_token

        jsr _76e9
        lda # $0f
_71bc:                                                                  ;$71bc
        sta $66                 ; hyperspace countdown -- outer
        sta $65                 ; hyperspace countdown -- inner
        tax 
        jmp _7224

_71c4:                                                                  ;$71c4
        jsr _70ab
        jmp _7176

_71ca:                                                                  ;$71ca
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
_71e8:                                                                  ;$71e8
        lda $049c, x
        asl 
        rol $049c, x
        dex 
        bpl _71e8
_71f2:  ; the $60 also forms an RTS, jumped to from just after _71ca    ;$71f2
        lda # $60

;71f4:
         sta TSYSTEM_POS_X
         sta TSYSTEM_POS_Y
         jsr _741c
         jsr _70ab
         ldx # $05
_7202:                                                                  ;$7202
        lda ZP_SEED, x
        sta $04fa, x
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

;===============================================================================

_7224:                                                                  ;$7224
        lda # 1
        jsr set_cursor_col
        jsr set_cursor_row
        
        ldy # $00
        clc 
        lda # $03
        jmp print_medium_value


_7234:                                                                  ;$7234
        ;=======================================================================
        ; print 16-bit value in X/Y, without decimal point
        ;
        clc 
_7235:                                                                  ;$7235
        ;=======================================================================
        ; print 16-bit value in X/Y -- decimal point included if carry set
        ;
        lda # $05               ; max. no. digits -- is this 5 or 6?
        jmp print_medium_value

_723a:                                                                  ;$723a
.import TXT_RANGE:direct
        lda # TXT_RANGE

_723c:                                                                  ;$723c
        jsr print_flight_token

        lda # $3f
        jmp print_flight_token

;===============================================================================

_7244:                                                                  ;$7244
        pla 
        rts 

_7246:                                                                  ;$7246                         
        pha 
        sta $92
        asl 
        asl 
        sta $8e
        lda $0482
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
        
        ldx $8e
        lda _90a6, x
        sta $8f
        lda $04df
        and _90a8, x
        clc 
        adc _90a5, x
        sta $04ec
        jsr _72b8
        jsr _731a
        lda $8f
        bmi _7288
        lda $04ec
        adc $91
        jmp _728e

_7288:                                                                  ;$7288
        lda $04ec
        sec 
        sbc $91
_728e:                                                                  ;$728e
        sta $04ec
        sta $2e
        lda # $00
        jsr _74a5
        sec 
        jsr _7235
        ldy $92
        lda # $05
        ldx $04ce, y
        stx $04ed
        clc 
        beq _72af
        jsr print_small_value
        jmp _72b8
_72af:                                                                  ;$72af
        lda # 25
        jsr set_cursor_col

        lda # $2d
        bne _72c7
_72b8:                                                                  ;$72b8
        lda $8f
        and # %01100000
        beq _72ca
        cmp # $20
        beq _72d1
        jsr _72d6
_72c5:                                                                  ;$72c5
        lda # $20
_72c7:                                                                  ;$72c7
        jmp print_flight_token

_72ca:                                                                  ;$72ca
        lda # $74               ;="T"
        jsr print_char
        bcc _72c5
_72d1:                                                                  ;$72d1
        lda # $6b               ;="K"
        jsr print_char
_72d6:                                                                  ;$72d6
        lda # $67               ;="G"
        jmp print_char

;===============================================================================

_72db:                                                                  ;$72db
        lda # 17
        jsr set_cursor_col

        lda # $ff
        bne _72c7
_72e4:                                                                  ;$72e4
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
        sta $04ef
_7305:                                                                  ;$7305
        ldx # $80
        stx $34
        jsr _7246
        jsr cursor_down
        inc $04ef
        lda $04ef
        cmp # $11
        bcc _7305
        rts 

;===============================================================================

_731a:                                                                  ;$731a
        lda $8f
        and # %00011111
        ldy PSYSTEM_ECONOMY
        sta $90
        clc 
        lda # $00
        sta $04de
_7329:                                                                  ;$7329
        dey 
        bmi _7331
        adc $90
        jmp _7329

_7331:                                                                  ;$7331
        sta $91
        rts 

;===============================================================================

;7334 - dead code?

        jsr _70ab
_7337:                                                                  ;$7337
        jsr _7217
        ldx # $05
_733c:                                                                  ;$733c
        lda $04fa, x
        sta $04f4, x
        dex 
        bpl _733c
        inx 
        stx $048a
        lda TSYSTEM_ECONOMY
        sta PSYSTEM_ECONOMY
        lda TSYSTEM_TECHLEVEL
        sta PSYSTEM_TECHLEVEL
        lda TSYSTEM_GOVERNMENT
        sta PSYSTEM_GOVERNMENT
        jsr get_random_number
        sta $04df
        ldx # $00
        stx $ad
_7365:                                                                  ;$7365
        lda _90a6, x
        sta $8f
        jsr _731a
        lda _90a8, x
        and $04df
        clc 
        adc _90a7, x
        ldy $8f
        bmi _7381
        sec 
        sbc $91
        jmp _7384

_7381:                                                                  ;$7381
        clc 
        adc $91
_7384:                                                                  ;$7384
        bpl _7388
        lda # $00
_7388:                                                                  ;$7388
        ldy $ad
        and # %00111111
        sta $04ce, y
        iny 
        tya 
        sta $ad
        asl 
        asl 
        tax 
        cmp # $3f
        bcc _7365
        rts 

;===============================================================================

_739b:                                                                  ;$739b
        jsr _848d
        lda # $ff
        sta $29
        lda # $1d
        jsr _7c6b
        lda # $1e
        jmp _7c6b

;===============================================================================

_73ac:                                                                  ;$73ac
        lsr PLAYER_COMPETITION
        sec 
        rol PLAYER_COMPETITION
_73b3:                                                                  ;$73b3
        lda # $03
        jsr _a72f
        jsr _3795
        jsr _83df
        sty $0482
_73c1:                                                                  ;$73c1
        jsr _739b
        lda # $03
        cmp $047a
        bcs _73c1
        sta DUST_COUNT          ; number of dust particles

        ldx # $00
        jsr _a6ba
        lda PSYSTEM_POS_Y
        eor # %00011111
        sta PSYSTEM_POS_Y
        rts 

;===============================================================================

        ; seriously!?
_73dc:                                                                  ;$73dc
        rts 

;===============================================================================

_73dd:                                                                  ;$73dd
        lda PLAYER_FUEL
        sec 
        sbc TSYSTEM_DISTANCE_LO
        bcs _73e8
        lda # $00
_73e8:                                                                  ;$73e8
        sta PLAYER_FUEL
        lda $a0
        bne _73f5
        jsr _a72f
        jsr _3795
_73f5:                                                                  ;$73f5
        jsr _8e92
        and _1d08
        bmi _73ac
        jsr get_random_number
        cmp # $fd
        bcs _73b3
        jsr _7337
        jsr _83df
        jsr _7a9f
        lda $a0
        and # %00111111
        bne _73dc
        jsr _a731
        lda $a0
        bne _7452
        inc $a0
_741c:                                                                  ;$741c
        ldx $a7
        beq _744b
        jsr _379e
        jsr _83df
        jsr _70ab
        inc ZP_POLYOBJ_ZPOS_pt3
        jsr _7a8c
        lda # $80
        sta ZP_POLYOBJ_ZPOS_pt3
        inc ZP_POLYOBJ_ZPOS_pt2
        jsr _7c24
        lda # $0c
        sta $96                 ; player's ship speed?
        jsr _8798
        ora PLAYER_LEGAL
        sta PLAYER_LEGAL
        lda # $ff
        sta $a0
        jsr _37b2
_744b:                                                                  ;$744b
        ldx # $00
        stx $a7
        jmp _a6ba

_7452:                                                                  ;$7452
        bmi _7457
        jmp _6c1c
_7457:                                                                  ;$7457
        jmp _6fdb


; increase / decrease cash

_745a:                                                                  ;$745A
;===============================================================================
.export _745a
        stx $06
        lda PLAYER_CASH_pt4
        sec 
        sbc $06
        sta PLAYER_CASH_pt4
        sty $06
        lda PLAYER_CASH_pt3
        sbc $06
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
_74a1:                                                                  ;$74a1
        rts 

;===============================================================================

_74a2:                                                                  ;$74a2
        jsr _399b
_74a5:                                                                  ;$74a5
        asl $2e
        rol 
        asl $2e
        rol 
        tay 
        ldx $2e
        rts 

;===============================================================================

;$74af  unused?

        .byte $52,$2e,$44,$2e,$43,$4f,$44,$45   ;"R.D.CODE"
        .byte $0d

;-------------------------------------------------------------------------------

_74b8:   jmp _88e7                                                      ;$74b8

_74bb:                                                                  ;$74bb
        lda # $20
        jsr _6a2f

        lda # 12
        jsr set_cursor_col
        
        lda # $cf
        jsr _6a9b

.import TXT_SHIP:direct
        lda # TXT_SHIP
        jsr _28d9
        
        lda # $80
        sta $34
        jsr cursor_down
        lda PSYSTEM_TECHLEVEL
        clc 
        adc # $03
        cmp # $0c
        bcc _74e2
        lda # $0e
_74e2:                                                                  ;$74e2
        sta $9a
        sta $04ed
        inc $9a
        lda # $46
        sec 
        sbc PLAYER_FUEL
        asl 
        sta _76cd+0
        ldx # $01
_74f5:                                                                  ;$74f5
        stx $a2
        jsr _6a8e
        ldx $a2
        clc 
        jsr print_tiny_value
        jsr _72c5
        
        lda $a2
        clc 
        adc # $68
        jsr print_flight_token
        
        lda $a2
        jsr _763f
        sec 

        lda # 25
        jsr set_cursor_col
        
        lda # $06
        jsr print_medium_value
        ldx $a2
        inx 
        cpx $9a
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
        
        jsr _845c
        lda # $01
_755f:                                                                  ;$755f
        ldy # VAR_X
        cmp # $02
        bne _756f
        ldx # $25
        cpx $04af
        beq _75a1
        stx $04af
_756f:                                                                  ;$756f
        cmp # $03
        bne _757c
        iny 
        ldx $04c1
        bne _75a1
        dec $04c1
_757c:                                                                  ;$757c
        cmp # $04
        bne _758a
        jsr _764c
        lda # $0f
        jsr _76a1
        lda # $04
_758a:                                                                  ;$758a
        cmp # $05
        bne _7596
        jsr _764c
        lda # $8f
        jsr _76a1
_7596:                                                                  ;$7596
        ldy # $6f
        cmp # $06
        bne _75bc
        ldx $04c2
        beq _75b9
_75a1:                                                                  ;$75a1
        sty $77
        jsr _7642
        jsr _7481
        lda $77
        jsr _6a9b
        
.import TXT_PRESENT:direct
        lda # TXT_PRESENT       ;?
        jsr print_flight_token
_75b3:                                                                  ;$75b3
        jsr _7627
        jmp _88e7

;===============================================================================

_75b9:                                                                  ;$75b9
        dec $04c2
_75bc:                                                                  ;$75bc
        iny 
        cmp # $07
        bne _75c9
        ldx $04c7
        bne _75a1
        dec $04c7
_75c9:                                                                  ;$75c9
        iny 
        cmp # $08
        bne _75d8
        ldx $04c3
        bne _75a1
        ldx # $7f
        stx $04c3
_75d8:                                                                  ;$75d8
        iny 
        cmp # $09
        bne _75e5
        ldx $04c4               ; energy charge rate?
        bne _75a1
        inc $04c4               ; energy charge rate?
_75e5:
        iny 
        cmp # $0a
        bne _75f2
        ldx $04c5
        bne _75a1
        dec $04c5
_75f2:
        iny 
        cmp # $0b
        bne _75ff
        ldx PLAYER_GDRIVE
        bne _75a1
        dec PLAYER_GDRIVE
_75ff:
        iny 
        cmp # $0c
        bne _760c
        jsr _764c
        lda # $97
        jsr _76a1
_760c:
        iny 
        cmp # $0d
        bne _7619
        jsr _764c
        lda # $32
        jsr _76a1
_7619:
        jsr _761f
        jmp _74bb

_761f:
        jsr _72c5
        lda # $77
        jsr _6a9b
_7627:
        jsr _a80f

        ldy # 50
        jmp wait_frames

;===============================================================================

_762f:
        jsr _7642
        jsr _745a
        bcs _764b

.import TXT_CASH:direct
        lda # TXT_CASH
        jsr _723c
        
        jmp _75b3

;===============================================================================

_763f:
        sec 
        sbc # $01
_7642:
        asl 
        tay 
        ldx _76cd+0, y
        lda _76cd+1, y
        tay 
_764b:
        rts 

;===============================================================================

_764c:
        lda PSYSTEM_TECHLEVEL
        cmp # $08
        bcc _7658
        lda # $20
        jsr _a72f
_7658:
        lda # 16
        tay 
        jsr set_cursor_row
_765e:
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
_767e:
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

_7693:
        tax 
        rts 

;===============================================================================

_7695:
        jsr _6f82
        jsr _70ab
        jsr _6f82
        jmp txt_docked_token15

;===============================================================================

_76a1:
        sta $06
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
_76bc:
        stx VAR_Z
        tya 
        jsr _7642
        jsr _7481
        ldx VAR_Z
_76c7:
        lda $06
        sta PLAYER_LASERS, x
        rts 

;===============================================================================

_76cd:
        .word   $0001, $012c, $0fa0, $1770, $0fa0
        .word   $2710, $1482, $2710, $2328, $3a98
        .word   $2710, $c350, $ea60, $1f40

;===============================================================================

_76e9:
.export _76e9
        ldx # $05
_76eb:
        lda ZP_SEED, x
        sta $8e, x
        dex 
        bpl _76eb
        ldy # $03
        bit ZP_SEED_pt1
        bvs _76f9
        dey 
_76f9:
        sty $bb
_76fb:
        lda ZP_SEED_pt6
        and # %00011111
        beq _7706
        ora # %10000000
        jsr print_flight_token
_7706:
        jsr _6a41
        dec $bb
        bpl _76fb
        ldx # $05
_770f:
        lda $8e, x
        sta ZP_SEED, x
        dex 
        bpl _770f
        rts

;===============================================================================

_7717:
        ldy # $00
_7719:
        lda $0491, y
        cmp # $0d
        beq _7726
        jsr print_char
        iny 
        bne _7719
_7726:
        rts 

;===============================================================================

_7727:
        bit $0482
        bmi _7741
        jsr _7732
        jsr _76e9
_7732:
        ldx # $05
_7734:
        lda ZP_SEED, x
        ldy $04f4, x
        sta $04f4, x
        sty ZP_SEED, x
        dex 
        bpl _7734
_7741:
        rts 

;===============================================================================

_7742:
        clc 
        ldx PLAYER_GALAXY
        inx 
        jmp print_tiny_value

;===============================================================================

_774a:  ; $774A
.import TXT_FUEL:direct

        lda # TXT_FUEL
        jsr print_flight_token_with_colon

        ldx PLAYER_FUEL
        sec 
        jsr print_tiny_value

.import TXT_LIGHT_YEARS:direct
        lda # TXT_LIGHT_YEARS
        jsr _7773
        
.import TXT_CASH_:direct
        lda # TXT_CASH_         ; "CASH:" (colon in the string)
        bne print_flight_token

        ; print cash value?  
_775f:  ;$775F
        ldx # 3

        ; copy $04A2..$04A5 to $77..$7A?
:       lda PLAYER_CASH, x                                              ;$7761
        sta $77, x
        dex 
        bpl :-

        lda # $09               ; align to 10 digits
        sta $99
        
        sec                     ; set carry flag - use decimal point
        jsr print_large_value   ; convert value to string

        ; print "CR" ("credits") after the cash value
.import TXT_CR:direct
        lda # TXT_CR
_7773:
.export _7773
        jsr print_flight_token
        jmp _6a8e


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

print_flight_token:                                                            ;$777E
        ;=======================================================================
        ; prints an already *de-scrambled* string token. this can be a single
        ; letter, a variable (like cash or planet name), a string-expansion,
        ; or a meta-command
        ;
        ;    A = an already *de-scrambled* string token
        ;
        ; brief token breakdown:
        ;
        ;      $00 = ?
        ;      $01 = ?
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
        ;      $0C = ?
        ;      $0D = ?
        ;      $0E = ?
        ;  $0E-$20 = canned messages 128-146
        ;  $21-$5F = ASCII characters $21-$5F -- see "gfx/font.asm"
        ;  $60-$7F = canned messages  96-127
        ;  $80-$BF = canned messages   0-95

.export print_flight_token

        tax                     ; put aside token for later test

        ; handle variables / meta-commands:
        ;-----------------------------------------------------------------------

        ; token $00:
        ;
        beq _775f               ; is A 0? -- print "Cash: " and credit count
        
        ; token $80-$FF:
        ;
        ; any token value 128 or higher (i.e. bit 7 set) is a canned-message,
        ; the index of which is in the remaining 6 bits
        ;
        bmi _print_str          ; is bit 7 set? (i.e. is token)
        
        ; token $01:
        ;
        dex                     ; decrement token value
       .bze _7742               ; if now 0, it was 1 -- process 'tally'(?)
        
        ; token $02:
        ;
        dex                     ; decrement token value
       .bze _7727               ; if now 0, it was 2 -- current planet name
        
        ; token $03:
        ;
        dex                     ; decrement token value 
       .bnz :+                  ; skip ahead if it isn't now zero
        jmp _76e9               ; it was 3 -- selected planet name

        ; token $04:
        ;
:       dex                     ; decrement token value                 ;$778F 
       .bze _7717               ; if now 0, it was 4 -- commander's name

        ; token $05:
        dex                     ; decrement token value
       .bze _774a               ; if now 0, it was 5 -- cash value only
        
        dex                     ; decrement token value
       .bnz :+                  ; skip ahead if not 0
        
        ; token $06:
        ;
        lda # $80               ; put 128 (bit 7) into A
        sta $34                 ; set case-switch flag
        rts 

        ; NOTE: token $07 will fall through here
        ;       and be handled later!

        ; token $08:
        ;
:       dex                     ; decrement token value twice more      ;$779D
        dex                     ; i.e. if it was 8, it would be 0
        bne :+                  ; skip ahead if token was not originally 8
        stx $34                 ; token was 8, store the 0 in the case-switch
        rts                     ; flag and return

        ; token $09:
        ;
:       dex                     ; decrement token again                 ;$77A4
        beq _indent             ; if token was 9, process a tab

        ; tokens 96...127 are canned messages
        ; (tokens 128...255 have already been checked for above)
        cmp # $60
       .bge print_canned_message

        cmp # $0e               ; < $0E? -- i.e. only token $07
       .blt :+                  ; skip ahead -- switch case?
        
        cmp # $20               ; < 32?
       .blt _77db               ; treat as token A+114

        ; switch case?

:       ldx $34                 ; check case-switch flag                ;$77B3
        beq _77f6               ; =0, leave case as-is
        bmi _is_captial         ; or bit 7 set, switch case
        
        bit $34                 ; check bits 7 & 6 (bit 7 already handled)
        bvs _77ef               ; bit 6 set -- print char and reset bit 6

        ;-----------------------------------------------------------------------

_77bd:
        cmp # 'a'               ; less than 'A'?
        bcc _goto_print_char    ; yes: print as is
        
        cmp # 'z'+1             ; higher than 'Z'?
        bcs _goto_print_char    ; yes: print as is

        adc # $20               ; otherwise shift letter into lower-case

_goto_print_char:                                                       ;$77C7
        jmp print_char          ; just print char

_is_captial:                                                            ;$77CA
        ;-----------------------------------------------------------------------
        bit $34                 ; bit 6 set?
        bvs _77e7               

        cmp # 'a'               ; less than 'A'?
        bcc _77f6               ; yes: print as is
        
        pha 
        txa 

        ; set bit 6 on the case-switch flag
        ora # %01000000
        sta $34

        pla 
        bne _goto_print_char    ; print character as-is, but next will be
                                ; lower-cased (bit 6 of case-flag)

_77db:  ; add 114 to the token number and print the canned message:
        adc # 114
        bne print_canned_message

_indent:                                                                ;$77DF
        ;-----------------------------------------------------------------------
        ; set cursor to column 22

        lda # 21
        jsr set_cursor_col
        jmp print_colon

        ;-----------------------------------------------------------------------

_77e7:  ; don't do anything if case-switch flag = %11111111
        cpx # $ff
        beq _784e

        ; if 'A' or above, print in lower-case
        cmp # 'a'
        bcs _77bd

        ; clear bit-6 of case-switch flag
_77ef:  pha 
        txa 
        and # %10111111
        sta $34
        pla 

_77f6:  jmp print_char


_print_str:                                                             ;$77F9
        ;-----------------------------------------------------------------------
        ; note that canned message tokens have bit 7 set, so really this is
        ; asking if the message index is > 32 -- the first 32 canned messages
        ; are letter pairs

        cmp # 160               ; is token >= 160?
       .bge @canned_token       ; if yes, go to canned messages 33+ 
        
        ; token is a character pair

        and # %01111111         ; clear token flag, leave message index
        asl                     ; double it for a lookup-table offset,
        tay                     ; this would have cleared bit 7 anyway!
        lda txt_flight_pair1, y ; read the first character,
        jsr print_flight_token         ; print it
        lda txt_flight_pair2, y ; read second character
        cmp # $3f               ; is it 63? (some kind of continuation token?)
        beq _784e               ; yes, skip -- although never seen in practice
        jmp print_flight_token         ; print second character (and return)

@canned_token:                                                          ;$7811  
        ; token messages 160+; subtract 160 for the message index
        sbc # 160

print_canned_message:                                                   ;$7813
        ;=======================================================================
        ; prints a canned message from the messages table
        ;
        ;    A = message index 
        
        tax                     ; put the message index aside 

        ; select the table of canned-messages
        lda #< _0700
        sta $5b
        lda #> _0700
        sta $5c

        ; initialise loop counter
        ldy # $00
        
        ; ignore message no.0,
        ; i.e. you can't skip zero messages
        txa                     ; return the original message index
        beq print_flight_token_string

@skip_message:                                                           ;$7821

        lda [$5b], y            ; read a code from the compressed text
        beq :+                  ; if zero terminator, end string
        iny                     ; next character 
        bne @skip_message       ; loop if not at 256 chars
        inc $5c                 ; move to the next page,
        bne @skip_message       ; and keep reading

:       iny                     ; move forward over the zero            ;$782C 
        bne :+                  ; skip if we haven't overflowed a page
        inc $5c                 ; next page if the zero happened there
:       dex                     ; decrement message skip counter        ;$7831 
        bne @skip_message       ; keep looping if we haven't reached
                                ; the desired message index yet

print_flight_token_string:                                                     ;$7834
        ;-----------------------------------------------------------------------
        ; remember the current index
        ; (this routine can call recursively)
       .phy                     ; push Y to stack (via A)
        ; remember the current page
        lda $5c
        pha 

        ; get the 'key' used for de-scrambling the text
        ; (see "text_flight.asm")
.import TXT_FLIGHT_XOR:direct

        lda [$5b], y            ; read a token
        eor # TXT_FLIGHT_XOR    ; 'descramble' token
        jsr print_flight_token         ; process it

        ; restore the previous page
        pla 
        sta $5c
        ; and index
        pla 
        tay 
        
        iny                     ; next character
        bne :+                  ; overflowed the page?
        inc $5c                 ; move to the next page

        ; is this the end of the string?
        ; (check for a $00 token)
:       lda [$5b], y                                                    ;$784A
        bne print_flight_token_string

_784e:  rts                                                             ;$784E 

;===============================================================================

_784f:
        ldx # $36
_7851:
        lda $00, x
        ldy $ce00, x
        sta $ce00, x
        sty $00, x
        inx 
        bne _7851
        rts 

;===============================================================================

_785f:
        lda $28
        ora # %10100000
        sta $28
        rts 

;===============================================================================

_7866:
        lda $28
        and # %01000000
        beq _786f
        jsr _78d6
_786f:
        lda ZP_POLYOBJ_ZPOS_pt1
        sta $bb
        lda ZP_POLYOBJ_ZPOS_pt2
        cmp # $20
        bcc _787d
        lda # $fe
        bne _7885
_787d:
        asl $bb
        rol 
        asl $bb
        rol 
        sec 
        rol 
_7885:
        sta $9a
        ldy # $01
        lda [$2a], y
        sta $050d
        adc # $04
        bcs _785f
        sta [$2a], y
        jsr _3b37
        lda $2e
        cmp # $1c
        bcc _78a1
        lda # $fe
        bne _78aa
_78a1:
        asl $9b
        rol 
        asl $9b
        rol 
        asl $9b
        rol 
_78aa:
        dey 
        sta [$2a], y
        lda $28
        and # %10111111
        sta $28
        and # %00001000
        beq _784e
        ldy # $02
        lda [$2a], y
        tay 
_78bc:
        lda $f9, y
        sta [$2a], y
        dey 
        cpy # $06
        bne _78bc
        lda $28
        ora # %01000000
        sta $28
        ldy $050d
        cpy # $12
        bne _78d6
        jmp _795a

_78d6:
        ldy # $00
        lda [$2a], y
        sta $9a
        iny 
        lda [$2a], y
        bpl _78e3
        eor # %11111111
_78e3:
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta $99
        iny 
        lda [$2a], y
        sta $a8
        lda ZP_GOATSOUP_pt2     ;?
        pha 
        ldy # $06
_78f5:
        ldx # $03
_78f7:
        iny 
        lda [$2a], y
        sta $35, x
        dex 
        bpl _78f7
        sty $aa
        ldy # $02
_7903:
        iny 
        lda [$2a], y
        eor $aa
        sta $ffff, y            ;irq
        cpy # $06
        bne _7903
        ldy $99
_7911:
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
        sta VAR_Z
        lda $36
        sta $9b
        lda $35
        jsr _7974
        bne _795d
        cpx # $8f
        bcs _795d
        stx VAR_Y
        lda $38
        sta $9b
        lda $37
        jsr _7974
        bne _7948
        lda VAR_Y
        jsr _293a
_7948:
        dey 
        bpl _7911
        ldy $aa
        cpy $a8
        bcc _78f5
        pla 
        sta ZP_GOATSOUP_pt2

.import POLYOBJ_00

        lda POLYOBJ_00 + PolyObject::zpos       ;=$F906
        sta ZP_GOATSOUP_pt4
        rts 

;===============================================================================

_795a:
        jmp _79a9

;===============================================================================

_795d:
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

_7974:
        sta $9c
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
        adc $9b
        tax 
        lda $9c
        adc # $00
        rts 

_7998:
        jsr _39ea
        sta $bb
        lda $9b
        sbc $bb
        tax 
        lda $9c
        sbc # $00
        rts 

;===============================================================================

_79a7:
        .byte   $00, $02

;===============================================================================

_79a9:
        lda # MEM_IO_ONLY
        jsr set_memory_layout

        lda ZP_POLYOBJ_ZPOS_pt2
        cmp # $07
        lda # $fd
        ldx # $2c
        ldy # $28
        bcs _79c0
        lda # $ff
        ldx # $20
        ldy # $1e
_79c0:
        sta VIC_SPRITE_DBLHEIGHT
        sta VIC_SPRITE_DBLWIDTH
        stx $050e
        sty $050f
        ldy # $00
        lda [$2a], y
        sta $9a
        iny 
        lda [$2a], y
        bpl _79d9
        eor # %11111111
_79d9:
        lsr 
        lsr 
        lsr 
        lsr 
        ora # %00000001
        sta $99
        iny 
        lda [$2a], y
        sta $a8
        lda ZP_GOATSOUP_pt2
        pha 
        ldy # $06
_79eb:
        ldx # $03
_79ed:
        iny 
        lda [$2a], y
        sta $35, x
        dex 
        bpl _79ed
        sty $aa
        lda $38
        clc 
        adc $050e
        sta $07
        lda $37
        adc # $00
        bmi _7a36
        cmp # $02
        bcs _7a36
        tax 
        lda $36
        clc 
        adc $050f
        tay 
        lda $35
        adc # $00
        bne _7a36
        cpy # $c2
        bcs _7a36
        lda VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        and # %11111101
        ora _79a7, x
        sta VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        ldx $07
        sty VIC_SPRITE1_Y
        stx VIC_SPRITE1_X
        lda VIC_SPRITE_ENABLE
        ora # %00000010
        sta VIC_SPRITE_ENABLE
_7a36:
        ldy # $02
_7a38:
        iny 
        lda [$2a], y
        eor $aa
        sta $ffff, y            ;irq
        cpy # $06
        bne _7a38
        ldy $99
_7a46:
        jsr _84ae
        sta VAR_Z
        lda $36
        sta $9b
        lda $35
        jsr _7974
        bne _7a86
        cpx # $8f
        bcs _7a86
        stx VAR_Y
        lda $38
        sta $9b
        lda $37
        jsr _7974
        bne _7a6c
        lda VAR_Y
        jsr _293a
_7a6c:
        dey 
        bpl _7a46
        ldy $aa
        cpy $a8
        bcs _7a78
        jmp _79eb

_7a78:
        pla 
        sta ZP_GOATSOUP_pt2     ;?
        
        lda # MEM_64K
        jsr set_memory_layout

        lda POLYOBJ_00 + PolyObject::zpos       ;=$F906
        sta ZP_GOATSOUP_pt4
        rts 

_7a86:
        jsr _84ae
        jmp _7a6c

;===============================================================================

_7a8c:
        jsr _845c
        lda # $7f
        sta $26
        sta $27
        lda PSYSTEM_TECHLEVEL
        and # %00000010
        ora # %10000000
        jmp _7c6b

;===============================================================================

_7a9f:
        lda PLAYER_TRUMBLES_LO
        beq _7ac2

        lda # $00
        sta $04b0
        sta $04b6
        jsr get_random_number
        and # %00001111
        adc PLAYER_TRUMBLES_LO
        ora # %00000100
        rol 
        sta PLAYER_TRUMBLES_LO
        rol PLAYER_TRUMBLES_HI
        bpl _7ac2
        ror PLAYER_TRUMBLES_HI
_7ac2:
        lsr PLAYER_LEGAL
        jsr _8447
        lda ZP_SEED_pt2
        and # %00000011
        adc # $03
        sta ZP_POLYOBJ_ZPOS_pt3
        ror 
        sta ZP_POLYOBJ_XPOS_pt3
        sta ZP_POLYOBJ_YPOS_pt3
        jsr _7a8c
        lda ZP_SEED_pt4
        and # %00000111
        ora # %10000001
        sta ZP_POLYOBJ_ZPOS_pt3
        lda ZP_SEED_pt6
        and # %00000011
        sta ZP_POLYOBJ_XPOS_pt3
        sta ZP_POLYOBJ_XPOS_pt2
        lda # $00
        sta $26
        sta $27
        lda # $81
        jsr _7c6b
_7af3:
        lda $a0
        bne _7b1a
_7af7:
        ldy DUST_COUNT          ; number of dust particles
_7afa:
        jsr get_random_number
        ora # %00001000
        sta DUST_Z, y
        sta VAR_Z
        jsr get_random_number
        sta DUST_X, y
        sta VAR_X
        jsr get_random_number
        sta DUST_Y, y
        sta VAR_Y
        jsr _2918
        dey 
        bne _7afa
_7b1a:
        ldx # $00
_7b1c:
        lda $0452, x            ; ship slots?
        beq _7b44
        bmi _7b41
        sta $a5
        
        jsr _3e87

        ldy # $1f
_7b2a:
        lda [$59], y
        sta $0009, y
        dey 
        bpl _7b2a
        stx $9d
        jsr _b410
        ldx $9d
        ldy # $1f
        lda [$59], y
        and # %10100111
        sta [$59], y
_7b41:
        inx 
        bne _7b1c
_7b44:
        ldx # $00
        stx $7e
        dex 
        stx _26a4
        stx _27a4               ; write to code??
_7b4f:
        ldy # $c7
        lda # $00
_7b53:
        sta $0580, y
        dey 
        bne _7b53
        dey 
        sty $0580
        rts 

;===============================================================================

        ; dummied-out code
_7b5e:  rts

;===============================================================================

_7b5f:
        dex 
        rts 

_7b61:
.export _7b61
        inx 
        beq _7b5f
_7b64:
.export _7b64
        dec PLAYER_ENERGY
        php 
        bne _7b6d
        inc PLAYER_ENERGY
_7b6d:
        plp 
        rts 

;===============================================================================

_7b6f:
.export _7b6f
        jsr _b09d

        lda $045f
        bne _7ba8

        jsr _8c7b
        
        jmp _7bab

;===============================================================================

_7b7d:
        asl 
        tax 
        lda # $00
        ror 
        tay 
        lda # $14
        sta $9a
        txa 
        jsr _3b37
        ldx $2e
        tya 
        bmi _7b93
        ldy # $00
        rts 

_7b93:
        ldy # $ff
        txa 
        eor # %11111111
        tax 
        inx 
        rts 

;===============================================================================

_7b9b:
        ldx # $08
_7b9d:
        lda $f925, x            ;?
        sta $35, x
        dex 
        bpl _7b9d
        jmp _8c8a

;===============================================================================

_7ba8:
        jsr _7b9b
_7bab:
        lda VAR_X
        jsr _7b7d
        txa 
        adc # $c3
        sta $04ea
        lda VAR_Y
        jsr _7b7d
        stx $bb
        lda # $9c
        sbc $bb
        sta $04eb
        lda # $aa
        ldx $6d
        bpl _7bcc
        lda # $ff
_7bcc:
        sta _1d01
        jmp _b09d

;===============================================================================

_7bd2:
.export _7bd2
        sta $bb
        ldx # $00
        ldy # $08
        lda [$59], y
        bmi _7bee

        lda PLAYER_SHIELD_FRONT
        sbc $bb
        bcc _7be7
        sta PLAYER_SHIELD_FRONT
        
        rts 

_7be7:
        ldx # $00
        stx PLAYER_SHIELD_FRONT
        bcc _7bfe
_7bee:
        lda PLAYER_SHIELD_REAR
        sbc $bb
        bcc _7bf9
        sta PLAYER_SHIELD_REAR

        rts 

_7bf9:
        ldx # $00
        stx PLAYER_SHIELD_REAR
_7bfe:
        adc PLAYER_ENERGY
        sta PLAYER_ENERGY
        beq _7c08
        bcs _7c0b
_7c08:
        jmp _87d0

_7c0b:
        jsr _a813
        jmp _906a

;===============================================================================

_7c11:
        lda POLYOBJ_00 + PolyObject::xpos + 1, x        ;=$F901
        sta $35, x
        lda POLYOBJ_00 + PolyObject::xpos + 2, x        ;=$F902
        tay 
        and # %01111111
        sta $36, x
        tya 
        and # %10000000
        sta $37, x
        rts 

;===============================================================================

_7c24:
.export _7c24
        jsr _b10e
        ldx # $81
        stx $29
        ldx # $00
        stx $27
        stx $2d
        stx $0453
        dex 
        stx $26
        ldx # $0a
        jsr _7d03
        jsr _7d03
        jsr _7d03

        lda _8861
        sta $d002               ;I/O or ship-data?
        lda _8862
        sta $d003               ;I/O or ship-data?
        
        lda PSYSTEM_TECHLEVEL
        cmp # $0a
        bcc _7c61
        
        lda $d040               ;I/O or ship-data?
        sta $d002
        lda $d041               ;I/O or ship-data?
        sta $d003
_7c61:
        lda #< $0580
        sta $2a
        lda #> $0580
        sta $2b
        lda # $02
_7c6b:
.export _7c6b
        sta $bb
        ldx # $00
_7c6f:
        lda $0452, x            ; ship slots?
        beq _7c7b
        inx 
        cpx # $0a
        bcc _7c6f
_7c79:
        clc 
_7c7a:
        rts 

_7c7b:
        jsr _3e87

        lda $bb
        bmi _7cd4
        asl 
        tay 
        lda _d000 - 1, y        ;?
        beq _7c79               ;!?
        sta $58
        lda _d000 - 2, y        ;?
        sta $57
        cpy # $04
        beq _7cc4
        ldy # $05
        lda [$57], y
        sta $06
        lda $04f2
        sec 
        sbc $06
        sta $2a
        lda $04f3
        sbc # $00
        sta $2b
        lda $2a
        sbc $59
        tay 
        lda $2b
        sbc $5a
        bcc _7c7a
        bne _7cba
        cpy # $25
        bcc _7c7a
_7cba:
        lda $2a
        sta $04f2
        lda $2b
        sta $04f3
_7cc4:
        ldy # $0e
        lda [$57], y
        sta $2c
        ldy # $13
        lda [$57], y
        and # %00000111
        sta $28
        lda $bb
_7cd4:
        sta $0452, x            ; ship slots?
        tax 
        bmi _7cec
        cpx # $0f
        beq _7ce6
        cpx # $03
        bcc _7ce9
        cpx # $0b
        bcs _7ce9
_7ce6:
        inc $047f
_7ce9:
        inc $045d, x
_7cec:
        ldy $bb
        lda $d041, y
        and # %01101111
        ora $2d
        sta $2d
        ldy # $24
_7cf9:
        lda ZP_POLYOBJ_XPOS_pt1, y
        sta [$59], y
        dey 
        bpl _7cf9
        sec 
        rts 

;-------------------------------------------------------------------------------

_7d03:
        lda ZP_POLYOBJ_XPOS_pt1, x
        eor # %10000000
        sta ZP_POLYOBJ_XPOS_pt1, x
        inx 
        inx 
        rts 

;===============================================================================

_7d0c:
.export _7d0c
        ldx # $ff
_7d0e:
.export _7d0e
        stx $7c
        ldx PLAYER_MISSILES
        jsr _b11f
        
        sty PLAYER_MISSILE_ARMED

        rts 

;===============================================================================

;$7d1a:
        .byte   $04, $00, $00, $00, $00

_7d1f:
        lda ZP_POLYOBJ_XPOS_pt1
        sta $2e
        lda ZP_POLYOBJ_XPOS_pt2
        sta $2f
        lda ZP_POLYOBJ_XPOS_pt3
        jsr _81c9
        bcs _7d56
        lda $77
        adc # $80
        sta $35
        txa 
        adc # $00
        sta $36
        lda ZP_POLYOBJ_YPOS_pt1
        sta $2e
        lda ZP_POLYOBJ_YPOS_pt2
        sta $2f
        lda ZP_POLYOBJ_YPOS_pt3
        eor # %10000000
        jsr _81c9
        bcs _7d56
        lda $77
        adc # $48
        sta $43
        txa 
        adc # $00
        sta $44
        clc 
_7d56:
        rts 


;===============================================================================

_7d57:
        lda $a5
        lsr 
        bcs _7d5f
        jmp _80bb

_7d5f:
        jmp _80ff

;===============================================================================

_7d62:
        lda ZP_POLYOBJ_ZPOS_pt3
        cmp # $30
        bcs _7d57
        ora ZP_POLYOBJ_ZPOS_pt2
        beq _7d57
        jsr _7d1f
        bcs _7d57
        lda #> $6000
        sta $2f
        lda #< $6000
        sta $2e
        jsr _3bc1
        lda $78
        beq _7d84
        lda # $f8
        sta $77
_7d84:
        lda $a5
        lsr 
        bcc _7d8c
        jmp _7f22

_7d8c:
        jsr _80bb
        jsr _8044
        bcs _7d98
        lda $78
        beq _7d99
_7d98:
        rts 

_7d99:
        lda _1d0f
        beq _7d98
        lda $a5
        cmp # $80
        bne _7de0
        lda $77
        cmp # $06
        bcc _7d98
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta $2e
        lda ZP_POLYOBJ_M1x2_HI
        jsr _81aa
        ldx # $09
        jsr _7e36
        sta $b2
        sty $45
        jsr _7e36
        sta $b3
        sty $46
        ldx # $0f
        jsr _81ba
        jsr _7e54
        lda ZP_POLYOBJ_M0x2_HI
        eor # %10000000
        sta $2e
        lda ZP_POLYOBJ_M2x2_HI
        jsr _81aa
        ldx # $15
        jsr _81ba
        jmp _7e54

_7de0:
        lda ZP_POLYOBJ_M1x2_HI
        bmi _7d98
        ldx # $0f
        jsr _8189
        clc 
        adc $35
        sta $35
        tya 
        adc $36
        sta $36
        jsr _8189
        sta $2e
        lda $43
        sec 
        sbc $2e
        sta $43
        sty $2e
        lda $44
        sbc $2e
        sta $44
        ldx # $09
        jsr _7e36
        lsr 
        sta $b2
        sty $45
        jsr _7e36
        lsr 
        sta $b3
        sty $46
        ldx # $15
        jsr _7e36
        lsr 
        sta $b4
        sty $47
        jsr _7e36
        lsr 
        sta $b5
        sty $48
        lda # $40
        sta $a8
        lda # $00
        sta $ab
        jmp _7e58

_7e36:
        lda ZP_POLYOBJ_XPOS_pt1, x
        sta $2e
        lda ZP_POLYOBJ_XPOS_pt2, x
        and # %01111111
        sta $2f
        lda ZP_POLYOBJ_XPOS_pt2, x
        and # %10000000
        jsr _3bc1
        lda $77
        ldy $78
        beq _7e4f
        lda # $fe
_7e4f:
        ldy $7a
        inx 
        inx 
        rts 

_7e54:
        lda # $1f
        sta $a8
_7e58:
        ldx # $00
        stx $aa
        dex 
        stx $a9
_7e5f:
        lda $ab
        and # %00011111
        tax 
        lda _0ac0, x
        sta $9a
        lda $b4
        jsr _39ea
        sta $9b
        lda $b5
        jsr _39ea
        sta $77
        ldx $ab
        cpx # $21
        lda # $00
        ror 
        sta $4a
        lda $ab
        clc 
        adc # $10
        and # %00011111
        tax 
        lda _0ac0, x
        sta $9a
        lda $b3
        jsr _39ea
        sta $79
        lda $b2
        jsr _39ea
        sta $2e
        lda $ab
        adc # $0f
        and # %00111111
        cmp # $21
        lda # $00
        ror 
        sta $49
        lda $4a
        eor $47
        sta $9c
        lda $49
        eor $45
        jsr _3ad1
        sta $bb
        bpl _7ec8
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda $bb
        eor # %01111111
        adc # $00
        sta $bb
_7ec8:
        txa 
        adc $35
        sta $89
        lda $bb
        adc $36
        sta $8a
        lda $77
        sta $9b
        lda $4a
        eor $48
        sta $9c
        lda $79
        sta $2e
        lda $49
        eor $46
        jsr _3ad1
        eor # %10000000
        sta $bb
        bpl _7efd
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
        lda $bb
        eor # %01111111
        adc # $00
        sta $bb
_7efd:
        jsr _2977
        cmp $a8
        beq _7f06
        bcs _7f12
_7f06:
        lda $ab
        clc 
        adc $ac
        and # %00111111
        sta $ab
        jmp _7e5f

_7f12:
        rts 

;===============================================================================

_7f13:
        jmp _80ff

_7f16:
        txa 
        eor # %11111111
        clc 
        adc # $01
        tax 
_7f1d:
        lda # $ff
        jmp _7f67

;-------------------------------------------------------------------------------

_7f22:
        lda # $01
        sta $0580
        jsr _814f
        bcs _7f13
        lda # $00
        ldx $77
        cpx # $60
        rol 
        cpx # $28
        rol 
        cpx # $10
        rol 
        sta $aa
        lda $b8
        ldx $30
        bne _7f4b
        cmp $2f
        bcc _7f4b
        lda $2f
        bne _7f4b
        lda # $01
_7f4b:
        sta $a8
        lda $b8
        sec 
        sbc $43
        tax 
        lda # $00
        sbc $44
        bmi _7f16
        bne _7f63
        inx 
        dex 
        beq _7f1d
        cpx $77
        bcc _7f67
_7f63:
        ldx $77
        lda # $00
_7f67:
        stx $5b
        sta $5c
        lda $77
        jsr _3988
        sta $b3
        lda $2e
        sta $b2
        ldy $b8
        lda $61
        sta $5f
        lda $62
        sta $60
_7f80:
        cpy $a8
        beq _7f8f
        lda $0580, y
        beq _7f8c
        jsr _28f3
_7f8c:
        dey 
        bne _7f80
_7f8f:
        lda $5b
        jsr _3988
        sta $bb
        lda $b2
        sec 
        sbc $2e
        sta $9a
        lda $b3
        sbc $bb
        sta $9b
        sty VAR_Y
        jsr _9978
        ldy VAR_Y
        jsr get_random_number
        and $aa
        clc 
        adc $9a
        bcc _7fb6
        lda # $ff
_7fb6:
        ldx $0580, y
        sta $0580, y
        beq _8008
        lda $61
        sta $5f
        lda $62
        sta $60
        txa 
        jsr _811e
        lda VAR_X
        sta $5d
        lda $6d
        sta $5e
        lda $35
        sta $5f
        lda $36
        sta $60
        lda $0580, y
        jsr _811e
        bcs _7fed
        lda $6d
        ldx $5d
        stx $6d
        sta $5d
        jsr _affa
_7fed:
        lda $5d
        sta VAR_X
        lda $5e
        sta $6d
_7ff5:
        jsr _affa
_7ff8:
        dey 
        beq _803a
        lda $5c
        bne _801c
        dec $5b
        bne _7f8f
        dec $5c
_8005:
        jmp _7f8f

_8008:
        ldx $35
        stx $5f
        ldx $36
        stx $60
        jsr _811e
        bcc _7ff5
_8015:                          ; incorrectly-disassembled?
        lda # $00
        sta $0580, y
        beq _7ff8
_801c:
        ldx $5b
        inx 
        stx $5b
        cpx $77
        bcc _8005
        beq _8005
        lda $61
        sta $5f
        lda $62
        sta $60
_802f:
        lda $0580, y
        beq _8037
        jsr _28f3
_8037:
        dey 
        bne _802f
_803a:
        clc 
        lda $35
        sta $61
        lda $36
        sta $62
_8043:
        rts 

;===============================================================================

_8044:
        jsr _814f
        bcs _8043
        lda # $00
        sta _26a4
        ldx $77
        lda # $08
        cpx # $08
        bcc _805c
        lsr 
        cpx # $3c
        bcc _805c
        lsr 
_805c:
        sta $ac
_805e:
.export _805e
        ldx # $ff
        stx $a9
        inx 
        stx $aa
_8065:
        lda $aa
        jsr _39e0
        ldx # $00
        stx $bb
        ldx $aa
        cpx # $21
        bcc _8081
        eor # %11111111
        adc # $00
        tax 
        lda # $ff
        adc # $00
        sta $bb
        txa 
        clc 
_8081:
        adc $35
        sta $89
        lda $36
        adc $bb
        sta $8a
        lda $aa
        clc 
        adc # $10
        jsr _39e0
        tax 
        lda # $00
        sta $bb
        lda $aa
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
        sta $bb
        clc 
_80af:
        jsr _2977
        cmp # $41
        bcs _80b9
        jmp _8065

_80b9:
        clc 
        rts 

_80bb:
        ldy _26a4
        bne _80f5
_80c0:
        cpy $7e
        bcs _80f5
        lda _27a4, y            ; write to code??
        cmp # $ff
        beq _80e6
        sta $6e
        lda _26a4, y
        sta $6d
        jsr _ab91
        iny 
        lda $06f4
        bne _80c0
        lda $6d
        sta VAR_X
        lda $6e
        sta VAR_Y
        jmp _80c0

_80e6:
        iny 
        lda _26a4, y
        sta VAR_X
        lda _27a4, y            ; write to code??
        sta VAR_Y
        iny 
        jmp _80c0

_80f5:
        lda # $01
        sta $7e
        lda # $ff
        sta _26a4
_80fe:
        rts 

_80ff:
.export _80ff
        lda $0580
        bmi _80fe
        lda $61
        sta $5f
        lda $62
        sta $60
        ldy # $8f
_810e:
        lda $0580, y
        beq _8116
        jsr _28f3
_8116:
        dey 
        bne _810e
        dey 
        sty $0580
        rts 

_811e:
.export _811e
        sta $bb
        clc 
        adc $5f
        sta $6d
        lda $60
        adc # $00
        bmi _8148
        beq _8131
        lda # $ff
        sta $6d
_8131:
        lda $5f
        sec 
        sbc $bb
        sta VAR_X
        lda $60
        sbc # $00
        bne _8140
        clc 
        rts 

_8140:
        bpl _8148
        lda # $00
        sta VAR_X
        clc 
        rts 

_8148:
        lda # $00
        sta $0580, y
        sec 
        rts 

_814f:
        lda $35
        clc 
        adc $77
        lda $36
        adc # $00
        bmi _8187
        lda $35
        sec 
        sbc $77
        lda $36
        sbc # $00
        bmi _8167
        bne _8187
_8167:
        lda $43
        clc 
        adc $77
        sta $2f
        lda $44
        adc # $00
        bmi _8187
        sta $30
        lda $43
        sec 
        sbc $77
        tax 
        lda $44
        sbc # $00
        bmi _81ec
        bne _8187
        cpx $b8
        rts 

_8187:
        sec 
        rts 

_8189:
        jsr _7e36
        sta $2e
        lda # $de
        sta $9a
        stx $99
        jsr _399b
        ldx $99
        ldy $7a
        bpl _81a7
        eor # %11111111
        clc 
        adc # $01
        beq _81a7
        ldy # $ff
        rts 

_81a7:
        ldy # $00
        rts 

_81aa:
        sta $9a
        jsr _3c95
        ldx ZP_POLYOBJ_M0x2_HI
        bmi _81b5
        eor # %10000000
_81b5:
        lsr 
        lsr 
        sta $ab
        rts 

_81ba:
        jsr _7e36
        sta $b4
        sty $47
        jsr _7e36
        sta $b5
        sty $48
        rts 

_81c9:
        jsr _3bc1
        lda $7a
        and # %01111111
        ora $79
        bne _8187
        ldx $78
        cpx # $04
        bcs _81ed
        lda $7a
        bpl _81ed
        lda $77
        eor # %11111111
        adc # $01
        sta $77
        txa 
        eor # %11111111
        adc # $00
        tax 
_81ec:
        clc 
_81ed:
        rts 

;===============================================================================

_81ee:
.export _81ee
        jsr _8fec
        cmp # $59
        beq _81ed
        cmp # $4e
        bne _81ee
        clc 
        rts 

;===============================================================================

_81fb:
        lda $a0
        bne _8204
        jsr _8ee3
        txa 
        rts 

_8204:
        jsr _8ee3
        lda _1d0c
        beq _8244
        lda _8d1d
        bit _8d20
        bpl _8216
        lda # $01
_8216:
        bit _8d42
        bpl _821d
        asl 
        asl 
_821d:
        tax 
        lda _8d35
        bit _8d3f
        bpl _8228
        lda # $01
_8228:
        bit _8d42
        bpl _822f
        asl 
        asl 
_822f:
        tay 
        lda # $00
        sta _8d1d
        sta _8d20
        sta _8d35
        sta _8d3f
        sta _8d42
        lda $7d
        rts 

;===============================================================================

_8244:
        lda _8d4a
        beq _8251
        lda # $01
        ora _8d3d
        ora _8d18
_8251:
        bit _8d4b
        bpl _8258
        asl 
        asl 
_8258:
        tax 
        lda _8d45
        beq _8268
        lda # $01
        ora _8d3d
        ora _8d18
        eor # %11111110
_8268:
        bit _8d4b
        bpl _826f
        asl 
        asl 
_826f:
        tay 
        lda $7d
        rts 


disable_sprites:                                                        ;$8273
        ;=======================================================================
        ; disable all sprites: (for example, when switching to menu screen)

        ; ensure the I/O is enabled so we can talk to the VIC-II:

        lda # MEM_IO_ONLY
        jsr set_memory_layout

        ; disable all sprites
        lda # %00000000
        sta VIC_SPRITE_ENABLE

        ; switch back to 64K RAM layout
        lda # MEM_64K

set_memory_layout:                                                      ;$827f
        ;=======================================================================
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

current_memory_layout:                                                  ;$828e
        .byte   MEM_64K

;===============================================================================

_828f:
        lda $2e
        sta $04f2
        lda $2f
        sta $04f3
        rts 

;===============================================================================

_829a:
.export _829a
        ldx $9d
        jsr _82f3
        ldx $9d
        jmp _202f

;===============================================================================

_82a4:
        jsr _8447
        jsr _7b4f
        sta $0453
        sta $045f
        jsr _b10e
        lda # $06
        sta ZP_POLYOBJ_YPOS_pt3
        lda # $81
        jmp _7c6b

;===============================================================================

_82bc:
        ldx # $ff
_82be:
        inx 
        lda $0452, x            ; ship slots?
        beq _828f
        cmp # $01
        bne _82be
        txa 
        asl 
        tay 
        lda _28a4 + 0, y
        sta $07
        lda _28a4 + 1, y
        sta $08
        ldy # $20
        lda [$07], y
        bpl _82be
        and # %01111111
        lsr 
        cmp $ad
        bcc _82be
        beq _82ed
        sbc # $01
        asl 
        ora # %10000000
        sta [$07], y
        bne _82be
_82ed:
        lda # $00
        sta [$07], y
        beq _82be
_82f3:
        stx $ad
        lda $7c
        cmp $ad
        bne _8305
        ldy # $57
        jsr _7d0c
        lda # $c8
        jsr _900d
_8305:
        ldy $ad
        ldx $0452, y            ; ship slots?
        cpx # $02
        beq _82a4
        cpx # $1f
        bne _831d

        ; set the Constrictor mission complete
        lda MISSION_FLAGS
        ora # missions::constrictor_complete
        sta MISSION_FLAGS
        
        inc PLAYER_KILLS
_831d:
        cpx # $0f
        beq _8329
        cpx # $03
        bcc _832c
        cpx # $0b
        bcs _832c
_8329:
        dec $047f
_832c:
        dec $045d, x
        ldx $ad
        ldy # $05
        lda [$57], y
        ldy # $21
        clc 
        adc [$59], y
        sta $2e
        iny 
        lda [$59], y
        adc # $00
        sta $2f
_8343:
        ; move the ship slots down?
        inx 
        lda $0452, x
        sta $0451, x
        bne _834f
        jmp _82bc

_834f:
        asl 
        tay 
        lda _d000-2, y
        sta $07
        lda _d000-1, y
        sta $08
        
        ldy # $05
        lda [$07], y
        sta $bb
        lda $2e
        sec 
        sbc $bb
        sta $2e
        lda $2f
        sbc # $00
        sta $2f
        txa 
        asl 
        tay 
        lda _28a4 + 0, y
        sta $07
        lda _28a4 + 1, y
        sta $08

        ldy # $24
        lda [$07], y
        sta [$59], y
        dey 
        lda [$07], y
        sta [$59], y
        dey 
        lda [$07], y
        sta $78
        lda $2f
        sta [$59], y
        dey 
        lda [$07], y
        sta $77
        lda $2e
        sta [$59], y
        dey 
_8399:
        lda [$07], y
        sta [$59], y
        dey 
        bpl _8399
        lda $07
        sta $59
        lda $08
        sta $5a
        ldy $bb
_83aa:
        dey 
        lda [$77], y
        sta [$2e], y
        tya 
        bne _83aa
        beq _8343
_83b4:
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
_83c8:
        clc 
_83c9:
        rts 

;===============================================================================

_83ca:
        jsr _8ac7               ; erase $0452...$048C

        ; erase $63...$69

        ldx # $06
:       sta $63, x                                                      ;$83CF
        dex 
        bpl :-

        txa                     ; set A = 0 (saves a byte over `lda # $00`)
        sta $a7

        ; erase $04e7...$04e9

        ldx # $02
:       sta $04e7, x                                                    ;$83D9
        dex 
        bpl :-

_83df:
.export _83df
        jsr _923b

        lda $04c3
        bpl _83ed

        jsr _2367
        sta $04c3
_83ed:
        lda # $0c
        sta DUST_COUNT          ; number of dust particles

        ldx # $ff
        stx _26a4
        stx _27a4               ; write to code??
        stx $7c

        lda # $80
        sta $048e
        sta $69
        sta $94

        asl                     ;=0
        sta $63
        sta $64
        sta $6a
        sta $95
        sta $a3                 ; move counter?
        sta $0510

        lda # $03
        sta $96                 ; player's ship speed?
        sta $a6
        sta $68
        
        lda # $10
        sta $050c
        
        lda #< (_8eff+1)        ;incorrect disassembly?
        sta $b7
        lda #> (_8eff+1)        ;incorrect disassembly?
        sta $b8
        
        lda $045f
        beq _8430
        jsr _b10e
_8430:
        lda $67
        beq _8437
        jsr _a786
_8437:
        jsr _7b1a
        jsr _8ac7
        
        lda #< $ffc0            ;=KERNAL_OPEN?
        sta $04f2
        lda #> $ffc0            ;=KERNAL_OPEN?
        sta $04f3
_8447:
.export _8447

        ; erase $09...$2D:

        ldy # $24
        lda # $00
:       sta ZP_POLYOBJ_XPOS_pt1, y                                                      ;$844B
        dey 
        bpl :-

        lda # $60
        sta ZP_POLYOBJ_M1x1_HI
        sta ZP_POLYOBJ_M2x0_HI
        ora # %10000000
        sta ZP_POLYOBJ_M0x2_HI
        
        rts 

;===============================================================================

_845c:
        ldx # $04
_845e:
        cpx PLAYER_MISSILES
        beq _846c

        ldy # $b7
        jsr _b11f
        dex 
        bne _845e
        rts 

_846c:
        ldy # $57
        jsr _b11f
        dex 
        bne _846c
        rts 

;===============================================================================

_8475:
        lda $a0
        bne _8487
        lda $04e6
        jsr _900d
        lda # $00
        sta $048b
        jmp _84fa

_8487:
        jsr txt_docked_token15
        jmp _84fa

;===============================================================================

_848d:
        jsr _8447
        jsr get_random_number
        sta $06
        and # %10000000
        sta ZP_POLYOBJ_XPOS_pt3
        txa 
        and # %10000000
        sta ZP_POLYOBJ_YPOS_pt3
        lda # $19
        sta ZP_POLYOBJ_XPOS_pt2
        sta ZP_POLYOBJ_YPOS_pt2
        sta ZP_POLYOBJ_ZPOS_pt2
        txa 
        cmp # $f5
        rol 
        ora # %11000000
        sta $29
_84ae:
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

_84c3:
        jsr get_random_number
        lsr 
        sta $29
        sta $26
        rol $28
        and # %00011111
        ora # %00010000
        sta ZP_POLYOBJ_VERTX_LO
        jsr get_random_number
        bmi _84e2
        lda $29
        ora # %11000000
        sta $29
        ldx # $10
        stx $2d
_84e2:
        and # %00000010
        adc # $0b
        cmp # $0f
        beq _84ed
        jsr _7c6b
_84ed:
        jsr _1ec1
        dec $048b
        beq _8475
        bpl _84fa
        inc $048b
_84fa:
        dec $a3                 ; move counter?
        beq _8501
_84fe:
        jmp _8627

_8501:
        lda $0482
        bne _84fe
        jsr get_random_number
        cmp # $23
        bcs _8562
        lda $047f
        cmp # $03
        bcs _8562
        jsr _8447
        lda # $26
        sta ZP_POLYOBJ_ZPOS_pt2
        jsr get_random_number
        sta ZP_POLYOBJ_XPOS_pt1
        stx ZP_POLYOBJ_YPOS_pt1
        and # %10000000
        sta ZP_POLYOBJ_XPOS_pt3
        txa 
        and # %10000000
        sta ZP_POLYOBJ_YPOS_pt3
        rol ZP_POLYOBJ_XPOS_pt2
        rol ZP_POLYOBJ_XPOS_pt2
        jsr get_random_number
        bvs _84c3
        ora # %01101111
        sta $26
        lda $045f
        bne _8562
        txa 
        bcs _8548
        and # %00011111
        ora # %00010000
        sta ZP_POLYOBJ_VERTX_LO
        bcc _854c
_8548:
        ora # %01111111
        sta $27
_854c:
        jsr get_random_number
        cmp # $fc
        bcc _8559
        lda # $0f
        sta $29
        bne _855f
_8559:
        cmp # $0a
        and # %00000001
        adc # $05
_855f:
        jsr _7c6b
_8562:
        lda $045f
        beq _856a
_8567:
        jmp _8627

_856a:
        jsr _8798
        asl 
        ldx $046d
        beq _8576
        ora PLAYER_LEGAL
_8576:
        sta $bb
        jsr _848d
        cmp # $88
        beq _85f8
        cmp $bb
        bcs _8588
        lda # $10
        jsr _7c6b
_8588:
        lda $046d
        bne _8567
        dec $048a
        bpl _8567
        inc $048a
        lda MISSION_FLAGS
        and # %00001100
        cmp # $08
        bne _85a8
        jsr get_random_number
        cmp # $c8
        bcc _85a8
_85a5:
        jsr _739b
_85a8:
        jsr get_random_number
        ldy PSYSTEM_GOVERNMENT
        beq _85bb
        cmp # $5a
        bcs _8567
        and # %00000111
        cmp PSYSTEM_GOVERNMENT
        bcc _8567
_85bb:
        jsr _848d
        cmp # $64
        bcs _860b
        inc $048a
        and # %00000011
        adc # $18
        tay 
        jsr _83b4
        bcc _85e0
        lda # $f9
        sta $29

        lda MISSION_FLAGS
        and # missions::constrictor
        lsr 
        bcc _85e0
        
        ora $047c
        beq _85f0
_85e0:
        lda # $04
        sta $2d
        jsr get_random_number
        cmp # $c8
        rol 
        ora # %11000000
        sta $29
        tya 
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_85f0:
        lda # $1f
_85f2:
        jsr _7c6b
        jmp _8627

_85f8:
        lda POLYOBJ_00 + PolyObject::zpos       ;=$F906
        and # %00111110
        bne _85a5
        lda # $12
        sta ZP_POLYOBJ_VERTX_LO
        lda # $79
        sta $29
        lda # $20
        bne _85f2
_860b:
        and # %00000011
        sta $048a
        sta $a2
_8612:
        jsr get_random_number
        sta $bb
        jsr get_random_number
        and $bb
        and # %00000111
        adc # $11
        jsr _7c6b
        dec $a2
        bpl _8612
_8627:
        ldx # $ff
        txs 
        ldx PLAYER_TEMP_LASER
        beq _8632
        dec PLAYER_TEMP_LASER
_8632:
        ldx $0487
        beq _863e
        dex 
        beq _863b
        dex 
_863b:
        stx $0487
_863e:
        lda $a0
        bne _8645
        jsr _2ff3
_8645:
        lda $a0
        beq _8654
        and _1d08
        lsr 
        bcs _8654
        
        ldy # 2
        jsr wait_frames
_8654:
        ; does the player have more than 256 Trumbles™?
        lda PLAYER_TRUMBLES_HI
       .bze _8670

        jsr get_random_number
        cmp # $dc

        lda PLAYER_TRUMBLES_LO
        adc # $00
        sta PLAYER_TRUMBLES_LO
       .bbw _8670
        
        inc PLAYER_TRUMBLES_HI
        bpl _8670
        dec PLAYER_TRUMBLES_HI
_8670:
        lda PLAYER_TRUMBLES_HI
        beq _86a1
        sta $bb
        lda PLAYER_TEMP_CABIN
        cmp # $e0
        bcs _8680
        asl $bb
_8680:
        jsr get_random_number
        cmp $bb
        bcs _86a1
        jsr get_random_number
        ora # %01000000
        tax 
        lda # $80
        ldy PLAYER_TEMP_CABIN
        cpy # $e0
        bcc _869c
        txa 
        and # %00001111
        tax 
        lda # $f1
_869c:
        ldy # $0e
        jsr _a850
_86a1:
        jsr _81fb
_86a4:
        jsr _86b1
        lda $a7
        beq _86ae
        jmp _8627

_86ae:
        jmp _84ed

_86b1:
        cmp # $25
        bne _86b8
        jmp _2c9b

_86b8:
        cmp # $35
        bne _86bf
        jmp _6c1c

_86bf:
        cmp # $30
        bne _86c6
        jmp _6fdb

_86c6:
        cmp # $2d
        bne _86d0
        jsr _70ab
        jmp _6aa1

_86d0:
        cmp # $20
        bne _86d7
        jmp _6f16

_86d7:
        cmp # $28
        bne _86de
        jmp _72e4

_86de:
        cmp # $3c
        bne _86e5
        jmp _741c

_86e5:
        bit $a7
        bpl _870d
        cmp # $38
        bne _86f0
        jmp _74bb

_86f0:
        cmp # $08
        bne _86f7
        jmp _6d16

_86f7:
        cmp # $12
        bne _8706
        jsr _8ae7
        bcc _8703
        jmp _88ac

_8703:
        jmp _88e7

_8706:
        cmp # $05
        bne _8724
        jmp _6e41

_870d:
        cmp # $3b
        beq _871f
        cmp # $3a
        beq _871c
        cmp # $3d
        bne _8724
        ldx # $03
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_871c:  ldx # $02
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_871f:  ldx # $01

        jmp _a6ba

_8724:
        bit _8d2f
        bpl _872c
        jmp _715c

_872c:
        cmp # $2e
        beq _877e
        cmp # $2b
        bne _8741
        lda $a7
        beq _877d
        lda $a0
        and # %11000000
        beq _877d
        jmp _31c6

_8741:
        sta $06
        lda $a0
        and # %11000000
        beq _875f
        lda $66                 ; hyperspace countdown (outer)?
        bne _875f
        lda $06
        cmp # $1a
        bne _875c
        jsr _6f82
        jsr _3e95
        jmp _6f82

_875c:
        jsr _6f55
_875f:
        lda $66                 ; hyperspace countdown (outer)?
        beq _877d
        dec $65                 ; hyperspace countdown (inner)?
        bne _877d
        ldx $66                 ; hyperspace countdown (outer)?
        dex 
        jsr _7224
        lda # $05
        sta $65                 ; hyperspace countdown (inner)?
        ldx $66                 ; hyperspace countdown (outer)?
        jsr _7224
        dec $66                 ; hyperspace countdown (outer)?
        bne _877d
        jmp _73dd

_877d:
        rts 

_877e:
.export _877e
        lda $a0
        and # %11000000
        beq _877d
        jsr _7695
        sta $34
        jsr _76e9
        lda # $80
        sta $34

        lda # $0c
        jsr print_char
        
        jmp _6a68

;===============================================================================

_8798:
        lda $04b3
        clc 
        adc $04b6
        asl 
        adc $04ba
        rts 

;===============================================================================

_87a4:
.export _87a4
        lda # $e0
_87a6:
.export _87a6
        cmp ZP_POLYOBJ_XPOS_pt2
        bcc _87b0
        cmp ZP_POLYOBJ_YPOS_pt2
        bcc _87b0
        cmp ZP_POLYOBJ_ZPOS_pt2
_87b0:
        rts 

;===============================================================================

_87b1:
.export _87b1
         ora ZP_POLYOBJ_XPOS_pt2
         ora ZP_POLYOBJ_YPOS_pt2
         ora ZP_POLYOBJ_ZPOS_pt2
         rts 

;===============================================================================

_87b8:
        .byte   $00

; BRK routine, set up by `_1e14`
_87b9:
.export _87b9
        dec _87b8
        ldx # $ff
        txs 
        jsr _8c60
        tay 
        lda # $07               ; BEEP?
_87c5:
        jsr paint_char
        iny 
        lda [$fd], y
        bne _87c5
        jmp _8888

;===============================================================================

_87d0:
.export _87d0
        jsr _a813
        jsr _83df
        asl $96                 ; player's ship speed?
        asl $96                 ; player's ship speed?
        ldx # $18
        jsr _7b5e
        jsr _a72f
        jsr _b2a5
        lda # $00
        sta $5f1f
        sta $4118
        jsr _7af7

        lda # 12
        jsr set_cursor_row
        jsr set_cursor_col
        
        lda # $92
        jsr print_canned_message
_87fd:
        jsr _848d
        lsr 
        lsr 
        sta ZP_POLYOBJ_XPOS_pt1
        ldy # $00
        sty $a0
        sty ZP_POLYOBJ_XPOS_pt2
        sty ZP_POLYOBJ_YPOS_pt2
        sty ZP_POLYOBJ_ZPOS_pt2
        sty $29
        dey 
        sty $a3                 ; move counter?
        eor # %00101010
        sta ZP_POLYOBJ_YPOS_pt1
        ora # %01010000
        sta ZP_POLYOBJ_ZPOS_pt1
        txa 
        and # %10001111
        sta $26
        ldy # $40
        sty $0487
        sec 
        ror 
        and # %10000111
        sta $27
        ldx # $05
        lda VIC_SPRITE3_Y
        beq _8835
        bcc _8835
        dex 
_8835:
        jsr _3695
        jsr get_random_number
        and # %10000000
        ldy # $1f
        sta [$59], y
        lda $0456
        beq _87fd
        jsr _8ed5
        sta $96                 ; player's ship speed?
        jsr _1ec1
        jsr disable_sprites
_8851:
        jsr _1ec1
        dec $0487
        bne _8851
        ldx # $1f
        jsr _7b5e
        jmp _8882

;===============================================================================

_8861:
        .byte   $88
_8862:
        .byte   $88

;===============================================================================

; LOADER JUMPS HERE! -- THIS IS THE ENTRY POINT

_8863:
.export _8863

        ; erase $1D12..$1D01

        ldx # $11
        lda # $00
:       sta _1d01, x                                                    ;$8867
        dex 
        bpl :-

        lda VIC_SPRITE1_X       ; this might be HULL_TABLE
        sta _8861
        lda VIC_SPRITE1_Y       ; this might be HULL_TABLE
        sta _8862
        
        jsr _8a0c

        ldx # $ff
        txs 

        jsr _83ca
_8882:
        ldx # $ff
        txs 

        jsr _83df
_8888:
        jsr _8c6d
        
        lda # 3
        jsr set_cursor_col
        
        jsr _91fe
        ldx # $0b
        lda # $06
        ldy # $d2
        jsr _8920
        cmp # $27
        bne _88ac
        jsr _9245
        jsr _88f0
        jsr _8ae7
        jsr _91fe
_88ac:
        jsr _88f0
        jsr _845c
        lda # $07
        ldx # $14
        ldy # $30
        jsr _8920
        jsr _9245
        jsr _3e95
        jsr _70ab
        jsr _7217
        ldx # $05
_88c9:
        lda ZP_SEED, x
        sta $04f4, x
        dex 
        bpl _88c9
        inx 
        stx $048a

        ; set the present system from the target system
        lda TSYSTEM_ECONOMY
        sta PSYSTEM_ECONOMY
        lda TSYSTEM_TECHLEVEL
        sta PSYSTEM_TECHLEVEL
        lda TSYSTEM_GOVERNMENT
        sta PSYSTEM_GOVERNMENT
_88e7:
.export _88e7
        lda # $ff
        sta $a7
        lda # $25
        jmp _86a4

;===============================================================================

_88f0:
        ldx # 84                ; size of new-game data?
:       lda _25aa, x                                                    ;$88F2
        sta $0490, x            ; seed goes in $049C+
        dex 
        bne :-

        stx $a0
_88fd:
        jsr _89eb
        cmp _25ff
        bne _88fd
        eor # %10101001
        tax 
        lda PLAYER_COMPETITION
        cpx _25fd
        beq _8912
        ora # %10000000
_8912:
        ora # %01000000
        sta PLAYER_COMPETITION
        jsr _89f9
        cmp _25fe
        bne _88fd
        rts 

;===============================================================================

_8920:
        sty $06fb
        pha 
        stx $a5
        lda # $ff
        sta _1d13
        jsr _83ca
        lda # $00
        sta _1d13
        jsr _8c6d
        lda # $20
        jsr _6a2e
        lda # $0d
        jsr _a72f
        lda # $00
        sta $a0
        lda # $60
        sta ZP_POLYOBJ_M0x2_HI
        lda # $60
        sta ZP_POLYOBJ_ZPOS_pt2
        ldx # $7f
        stx $26
        stx $27
        inx 
        stx $34
        lda $a5
        jsr _7c6b

        lda # 6
        jsr set_cursor_col
        
.import TXT_ELITE:direct
        lda # TXT_ELITE
        jsr _7773

        lda # $0a
        jsr print_char

        lda # 6
        jsr set_cursor_col
        
        lda _1d08
        beq _8978

        lda # $0d
        jsr print_docked_str
_8978:
        lda _87b8
        beq _8994
        inc _87b8

        lda # 7
        jsr set_cursor_col
        lda # 10
        jsr set_cursor_row
        
        ldy # $00
_898c:
        jsr paint_char
        iny 
        lda [$fd], y
        bne _898c
_8994:
        ldy # $00
        sty $96                 ; player's ship speed?
        sty _1d0c

        lda # 15
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL
        
        pla 
        jsr print_docked_str

        lda # 3
        jsr set_cursor_col
        
        lda # $0c
        jsr print_docked_str
        
        lda # $0c
        sta $ab
        lda # $05
        sta $a3                 ; move counter?
        lda # $ff
        sta _1d0c
_89be:
        lda ZP_POLYOBJ_ZPOS_pt2
        cmp # $01
        beq _89c6
        dec ZP_POLYOBJ_ZPOS_pt2
_89c6:
        jsr _a2a0
        ldx $06fb
        stx ZP_POLYOBJ_ZPOS_pt1
        lda $a3                 ; move counter?
        and # %00000011
        lda # $00
        sta ZP_POLYOBJ_XPOS_pt1
        sta ZP_POLYOBJ_YPOS_pt1
        jsr _9a86
        jsr _8d53
        dec $a3                 ; move counter?
        bit _8d42
        bmi _89ea
        bcc _89be
        inc _1d0c
_89ea:
        rts 

;===============================================================================

; checksum file data?

_89eb:
        ldx # 73
        clc 
        txa 
_89ef:
        adc _25b2, x
        eor _25b3, x
        dex 
        bne _89ef
        rts 

;===============================================================================

_89f9:
        ldx # 73
        clc 
        txa 
_89fd:
        stx $bb
        eor $bb
        ror 
        adc _25b2, x
        eor _25b3, x
        dex 
        bne _89fd
        rts 

;===============================================================================

_8a0c:
        ; copy $2619..$267A to $25AB..$260C

        ldy # $61

:       lda _2619, y                                                    ;$8A0E
        sta _25ab, y            ; seed would be in $25B6?
        dey 
        bpl :-

        ldy # $07
        sty _8bbf

        rts 

;===============================================================================

_8a1d:
        ldx # $07
        lda _8bbe
        sta _8bbf
_8a25:
        lda ZP_POLYOBJ_YPOS_pt3, x
        sta _25ab, x
        dex 
        bpl _8a25
_8a2d:
        ldx # $07
_8a2f:
        lda _25ab, x
        sta ZP_POLYOBJ_YPOS_pt3, x
        dex 
        bpl _8a2f
        rts 

_8a38:
        ldx # $04
_8a3a:
        lda _25a6, x
        sta ZP_POLYOBJ_XPOS_pt1, x
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
        sta $050c

        ldy # 8
        jsr wait_frames

        jsr _28d5
        ldy # $00
_8a6a:
        jsr _8fea
        cmp # $0d
        beq _8a94
        cmp # $1b
        beq _8aa1
        cmp # $7f
        beq _8aa8
        cpy _8ab2
        bcs _8a8d
        cmp _8ab3
        bcc _8a8d
        cmp _8ab4
        bcs _8a8d
        sta $000e, y
        iny 
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit 
_8a8d:  lda # $07               ; BEEP?
_8a8f:
        jsr paint_char
        bcc _8a6a
_8a94:
        sta $000e, y

        lda # $10
        sta $050c
        
        lda # $0c
        jmp paint_char

_8aa1:
        lda # $10
        sta $050c
        sec 
        rts 

;===============================================================================

_8aa8:
        .byte   $98, $f0, $e2, $88, $a9, $7f, $d0, $df
        .byte   $0e, $00
_8ab2:
        .byte   $09
_8ab3:
        .byte   $21
_8ab4:
        .byte   $7b

txt_docked_token1E:                                                     ;$8AB5
        ;=======================================================================
.export txt_docked_token1E

        lda # $03
        clc 
        adc _1d0e
        jmp print_docked_str

txt_docked_token1F:                                                     ;$8ABE
        ;=======================================================================
.export txt_docked_token1F
        
        lda # $02
        sec 
        sbc _1d0e
        jmp print_docked_str

;===============================================================================

; erase $0452...$048C

_8ac7:  
        ldx # $3a
        lda # $00

:       sta $0452, x                                                    ;$8ACB
        dex 
        bpl :-
        rts 
        rts                     ;?

;===============================================================================

;$8AD3  unused code?

        ldx # $0c
        jsr _8ad9
        dex 
_8ad9:
        ldy # $00
        sty $07
        lda # $00
        stx $08
_8ae1:
        sta [$07], y
        iny 
        bne _8ae1
        rts 

;===============================================================================

_8ae7:
        lda # $01
        jsr print_docked_str

        jsr _8fec
        cmp # $31
        beq _8b1c
        cmp # $32
        beq _8b27
        cmp # $33
        beq _8b11
        cmp # $34
        bne _8b0f
        
        lda # $e0
        jsr print_docked_str
        
        jsr _81ee
        bcc _8b0f
        jsr _8a0c
        jmp _88f0

_8b0f:
        ;-----------------------------------------------------------------------
        clc 
        rts 

_8b11:
        ;-----------------------------------------------------------------------
        lda _1d0e
        eor # %11111111
        sta _1d0e
        jmp _8ae7

_8b1c:
        ;-----------------------------------------------------------------------
        jsr _8a38
        jsr _8c0d
        jsr _8a1d
        sec 
        rts 

_8b27:
        ;-----------------------------------------------------------------------
        jsr _8a38
        jsr _8a1d
        lsr $04e2

        lda # $04
        jsr print_docked_str
        
        ldx # $4c
_8b37:
        lda $0499, x            ; $0500+?
        sta _25b3, x
        dex 
        bpl _8b37
        jsr _89f9
        sta _25fe
        jsr _89eb
        sta _25ff
        pha 
        ora # %10000000
        sta $77
        eor PLAYER_COMPETITION
        sta $79
        eor PLAYER_CASH_pt3     ;?
        sta $78
        eor # %01011010
        eor PLAYER_KILLS
        sta $7a
        clc 
        jsr print_large_value
        jsr _6a8e
        jsr _6a8e
        pla 
        eor # %10101001
        sta _25fd
        jsr _8bc0
        lda #< _25b3
        sta $fd
        lda #> _25b3
        sta $fe
        lda # $fd
        ldx # $00
        ldy # $26
        jsr KERNAL_SAVE         ;save after call setlfs,setnam    
        php 
        sei 
        bit $dc0d               ;cia1: cia interrupt control register
        lda # $01
        sta $dc0d               ;cia1: cia interrupt control register
        ldx # $00
        stx _a8d9
        inx 
        stx VIC_INTERRUPT_CONTROL
        lda $d011               ;vic control register 1
        and # %01111111
        sta $d011               ;vic control register 1
        lda # $28
        sta $d012               ;raster position

        lda # MEM_64K
        jsr set_memory_layout
        
        cli 
        jsr _784f
        plp 
        cli 
        bcs _8bbb
        jsr _88f0
        jsr _8fec
        clc 
        rts 

_8bbb:
        jmp _8c61

;===============================================================================

_8bbe:
        .byte   $07
_8bbf:
        .byte   $07

_8bc0:
        jsr _784f
        
        lda # MEM_IO_KERNAL
        sei 
        jsr set_memory_layout
        
        lda # $00
        sta VIC_INTERRUPT_CONTROL
        cli 
        lda # $81
        sta $dc0d               ;cia1: cia interrupt control register
        lda # $c0
        jsr KERNAL_SETMSG       ;enable/disable kernal messages   
        ldx _1d0e
        inx 
        lda _8c0b, x
        tax 
        lda # $01
        ldy # $00
        jsr KERNAL_SETLFS       ;set file parameters              
        lda _8bbe
        ldx # $0e
        ldy # $00
        jmp KERNAL_SETNAM       ;set file name                    
        
        ;bug / unused code? (`jmp` instead of `jsr` above)
        lda # $02
        jsr print_docked_str

        jsr _8fec
        ora # %00010000
        jsr paint_char
        pha 
        jsr print_crlf
        pla 
        cmp # $30
        bcc _8c53
        cmp # $34
        rts 

_8c0b:
        .byte   $08, $01

;===============================================================================

_8c0d:
        jsr _8bc0
        lda # $00
        ldx # $00
        ldy # $cf
        jsr KERNAL_LOAD         ;load after call setlfs,setnam    
        php 
        lda # $01
        sta $dc0d               ;cia1: cia interrupt control register
        sei 
        ldx # $00
        stx _a8d9
        inx 
        stx VIC_INTERRUPT_CONTROL
        lda $d011               ;vic control register 1
        and # %01111111
        sta $d011               ;vic control register 1
        lda # $28
        sta $d012               ;raster position
        
        lda # MEM_64K
        jsr set_memory_layout
        
        cli 
        jsr _784f
        plp 
        cli 
        bcs _8c61
        lda $cf00               ;?
        bmi _8c55
        ldy # $4c
_8c4a:
        lda $cf00, y            ;?
        sta _25b3, y
        dey 
        bpl _8c4a
_8c53:
        sec 
        rts 

_8c55:
        lda # $09
        jsr print_docked_str
        
        jsr _8fec
        jmp _8ae7

;===============================================================================

_8c60:
        rts 

;===============================================================================

_8c61:
        lda # $ff
        jsr print_docked_str

        jsr _8fec
        jmp _8ae7
;$8c6c:
        rts 

_8c6d:
        ldx # $40
        lda # $00
        sta $7d
_8c73:
        sta _8d0c, x
        dex 
        bpl _8c73
        rts 
;$8c7a:
        rts 

;===============================================================================

_8c7b:
.export _8c7b
        ldx # $00
        jsr _7c11
        ldx # $03
        jsr _7c11
        ldx # $06
        jsr _7c11
_8c8a:
.export _8c8a
        lda $35
        ora $38
        ora $3b
        ora # %00000001
        sta $3e
        lda $36
        ora $39
        ora $3c
_8c9a:
        asl $3e
        rol 
        bcs _8cad
        asl $35
        rol $36
        asl $38
        rol $39
        asl $3b
        rol $3c
        bcc _8c9a
_8cad:
.export _8cad
        lda $36
        lsr 
        ora $37
        sta VAR_X
        lda $39
        lsr 
        ora $3a
        sta VAR_Y
        lda $3c
        lsr 
        ora $3d
        sta $6d
_8cc2:
        lda VAR_X
        jsr _3986
        sta $9b
        lda $2e
        sta $9a
        lda VAR_Y
        jsr _3986
        sta $bb
        lda $2e
        adc $9a
        sta $9a
        lda $bb
        adc $9b
        sta $9b
        lda $6d
        jsr _3986
        sta $bb
        lda $2e
        adc $9a
        sta $9a
        lda $bb
        adc $9b
        sta $9b
        jsr _9978
        lda VAR_X
        jsr _918b
        sta VAR_X
        lda VAR_Y
        jsr _918b
        sta VAR_Y
        lda $6d
        jsr _918b
        sta $6d
        rts 

;===============================================================================

; perhaps this is a text-buffer?
; all these labels would just be offsets

_8d0c:
        .byte   $31, $32, $33                   ; '1', '2', '3'?
_8d0f:
.export _8d0f
        .byte   $34                             ; '4'?
_8d10:
.export _8d10
        .byte   $35, $36, $37                   ; '5', '6', '7'?
_8d13:
.export _8d13
        .byte   $38, $39                        ; '8', '9'?
_8d15:
.export _8d15
        .byte   $41, $42, $43                   ; 'A', 'B', 'C'?
_8d18:
        .byte   $44, $45, $46, $30, $31         ; 'D', 'E', 'F', '0', '1'?
_8d1d:
        .byte   $32, $33, $34                   ; '2', '3', '4'?
_8d20:
        .byte   $35, $36, $37                   ; '5', '6', '7'?
_8d23:
.export _8d23
        .byte   $38, $39, $41, $42, $43         ; '8', '9', 'A', 'B', 'C'?
_8d28:
.export _8d28
        .byte   $44, $45                        ; 'D', 'E'?
_8d2a:
.export _8d2a
        .byte   $46, $30, $31, $32              ; 'F', '0', '1', '2'?
_8d2e:
.export _8d2e
        .byte   $33                             ; '3'?
_8d2f:
        .byte   $34, $35, $36, $37, $38, $39    ; '4', '5', '6', '7', '8', '9'?
_8d35:
.export _8d35
        .byte   $41                             ; 'A'?
_8d36:
.export _8d36
        .byte   $42, $43                        ; 'B', 'C'?
_8d38:
.export _8d38
        .byte   $44, $45, $46, $30, $31         ; 'D', 'E', 'F', '0', '1'?
_8d3d:
        .byte   $32                             ; '2'?
_8d3e:
.export _8d3e
        .byte   $33                             ; '3'?
_8d3f:
        .byte   $34, $35, $36                   ; '4', '5', '6'?
_8d42:
.export _8d42
        .byte   $37, $38, $39                   ; '7', '8', '9'?
_8d45:
        .byte   $41, $42, $43, $44, $45         ; 'A', 'B', 'C', 'D', 'E'?
_8d4a:
        .byte   $46                             ; 'F'?
_8d4b:
        .byte   $30, $31, $32, $33              ; '0', '1', '2', '3'?
        .byte   $34, $35, $36, $37              ; '4', '5', '6', '7'?

;===============================================================================

_8d53:
.export _8d53
       .phy                     ; push Y to stack (via A)
        
        lda # MEM_IO_ONLY
        jsr set_memory_layout

        lda VIC_SPRITE_ENABLE
        and # %11111101
        sta VIC_SPRITE_ENABLE
        jsr _8c6d
        ldx _1d0c
        beq _8d73
        lda $dc00               ;cia1: data port register a
        and # %00011111
        eor # %00011111
        bne _8db1
_8d73:
        clc 
        ldx # $00
        sei 
        stx $dc00               ;cia1: data port register a
        ldx $dc01               ;cia1: data port register b
        cli 
        inx 
        beq _8daa
        ldx # $40
        lda # $fe
_8d85:
        sei 
        sta $dc00               ;cia1: data port register a
        pha 
        ldy # $08
_8d8c:
        lda $dc01               ;cia1: data port register b
        cmp $dc01               ;cia1: data port register b
        bne _8d8c
        cli 
_8d95:
        lsr 
        bcs _8d9e
        dec _8d0c, x
        stx $7d
        sec 
_8d9e:
        dex 
        bmi _8da8
        dey 
        bne _8d95
        pla 
        rol 
        bne _8d85
_8da8:
        pla 
        sec 
_8daa:
        lda # $7f
        sta $dc00               ;cia1: data port register a
        bne _8dfd
_8db1:
        lsr 
        bcc _8db7
        stx _8d3f
_8db7:
        lsr 
        bcc _8dbd
        stx _8d35
_8dbd:
        lsr 
        bcc _8dc3
        stx _8d1d
_8dc3:
        lsr 
        bcc _8dc9
        stx _8d20
_8dc9:
        lsr 
        bcc _8dcf
        stx _8d42
_8dcf:
        lda _1d0a
        beq _8de0
        lda _8d35
        ldx _8d3f
        sta _8d3f
        stx _8d35
_8de0:
        lda _1d0b
        beq _8dfd
        lda _8d35
        ldx _8d3f
        sta _8d3f
        stx _8d35
        lda _8d1d
        ldx _8d20
        sta _8d20
        stx _8d1d
_8dfd:
        lda $a0
        beq _8e1e
        lda # $00
        sta _8d0f
        sta _8d13
        sta _8d36
        sta _8d2e
        sta _8d28
        sta _8d3e
        sta _8d2a
        sta _8d38
        sta _8d23
_8e1e:
        lda # MEM_64K
        jsr set_memory_layout

        pla 
        tay 
        lda $7d
        tax 
        rts 

;===============================================================================

_8e29:
.export _8e29
        ldx $047f
        lda $0454, x
        ora $045f
        ora $0482
        bne _8e7c
        ldy POLYOBJ_00 + PolyObject::zpos + 2   ;=$F908
        bmi _8e44
        tay 
        jsr _2c50
        cmp # $02
        bcc _8e7c
_8e44:
        ldy $f92d
        bmi _8e52
        ldy # $25
        jsr _2c4e
        cmp # $02
        bcc _8e7c
_8e52:
        lda # $81
        sta $9c
        sta $9b
        sta $2e
        lda POLYOBJ_00 + PolyObject::zpos + 2   ;=$F908
        jsr _3ad1
        sta POLYOBJ_00 + PolyObject::zpos + 2   ;=$F908
        lda $f92d
        jsr _3ad1
        sta $f92d
        lda # $01
        sta $a0
        sta $a3                 ; move counter?
        lsr 
        sta $048a
        ldx $0486
        jmp _a6ba

_8e7c:
        ldy # $06
        jmp _a858
; $8e81
        rts 

;===============================================================================

; unsued / unreferenced?
;$8e82
        .byte   $e8, $e2, $e6, $e7, $c2, $d1, $c1, $60
        .byte   $70, $23, $35, $65, $22, $45, $52, $37

_8e92:
        ldx # $06
        lda _8d0c, x
        tax 
        rts

;===============================================================================

; ununsed / unreferenced?
; $8e99:
        lda # MEM_IO_ONLY
        jsr set_memory_layout
        
        sei 
        stx $dc00               ;cia1: data port register a
        ldx $dc01               ;cia1: data port register b
        cli 
        inx 
        beq _8eab
        ldx # $ff
_8eab:
        lda # MEM_64K
        jsr set_memory_layout

        txa 
        rts 

;$8eb2:
        rts 

;===============================================================================

;$8eb3: unused / unreferenced?
        lda _9274, x
        eor _1d0b
        rts 

;===============================================================================

_8eba:
        txa 
        cmp _1d14, y
        bne _8ed4
        lda _1d06, y
        eor # %11111111
        sta _1d06, y
        jsr _2fee               ; BEEP?
       .phy                     ; push Y to stack (via A) 
        
        ldy # 20
        jsr wait_frames

        pla 
        tay 
_8ed4:
        rts 

;===============================================================================

_8ed5:
        lda # $00
        ldy # $38
_8ed9:
        sta _8d0c, y
        dey 
        bne _8ed9
        sta $0441
        rts 

;===============================================================================

_8ee3:
        jsr _8d53
        lda $0480
        beq _8f4d
        jsr _8447
        lda # $60
        sta ZP_POLYOBJ_M0x2_HI
        ora # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        sta $a5
        lda $96                 ; player's ship speed?
        sta ZP_POLYOBJ_VERTX_LO
        jsr _34bc
_8eff:
        lda ZP_POLYOBJ_VERTX_LO
_8f01:
        cmp # $16
        bcc _8f07
        lda # $16
_8f07:
        sta $96                 ; player's ship speed?
        lda # $ff
        ldx # $09
        ldy ZP_POLYOBJ_VERTX_HI
        beq _8f18
        bmi _8f15
        ldx # $04
_8f15:
        sta _8d0c, x
_8f18:
        lda # $80
        ldx # $11
        asl $26
        beq _8f35
        bcc _8f24
        ldx # $14
_8f24:
        bit $26
        bpl _8f2f
        lda # $40
        sta $048d
        lda # $00
_8f2f:
        sta _8d0c, x
        lda $048d
_8f35:
        sta $048d
        lda # $80
        ldx # $29
        asl $27
        beq _8f4a
        bcs _8f44
        ldx # $33
_8f44:
        sta _8d0c, x
        lda $048e
_8f4a:
        sta $048e
_8f4d:
        ldx $048d
        lda # $0e
        ldy _8d1d
        beq _8f5a
        jsr _3c6f
_8f5a:
        ldy _8d20
        beq _8f62
        jsr _3c7f
_8f62:
        stx $048d
        ldx $048e
        ldy _8d35
        beq _8f70
        jsr _3c7f
_8f70:
        ldy _8d3f
        beq _8f78
        jsr _3c6f
_8f78:
        stx $048e
        lda _1d0c
        beq _8f9d
        lda $0480
        bne _8f9d
        ldx # $80
        lda _8d1d
        ora _8d20
        bne _8f92
        stx $048d
_8f92:
        lda _8d35
        ora _8d3f
        bne _8f9d
        stx $048e
_8f9d:
        ldx $7d
        stx $0441
        cpx # $40
        bne _8fe9
_8fa6:
        jsr wait_for_frame
        jsr _8d53
        cpx # $02
        bne _8fb3
        stx _1d05
_8fb3:
        ldy # $00
_8fb5:
        jsr _8eba
        iny 
        cpy # $0a
        bne _8fb5
        bit _1d08
        bpl _8fca
_8fc2:
        jsr _8eba
        iny 
        cpy # $0d
        bne _8fc2
_8fca:
        lda _1d0d
        cmp _1d02
        beq _8fd5
        jsr _9231
_8fd5:
        cpx # $33
        bne _8fde
        lda # $00
        sta _1d05
_8fde:
        cpx # $07
        bne _8fe5
        jmp _8882

_8fe5:
        cpx # $0d
        bne _8fa6
_8fe9:
        rts 

;===============================================================================

_8fea:
        sty $9e
_8fec:
        ldy # 2
        jsr wait_frames

        jsr _8d53
        bne _8fec
_8ff6:
        jsr _8d53
        beq _8ff6
        lda _927e, x
        ldy $9e
        tax 
_9001:
        rts 

;===============================================================================

_9002:
        stx $048b
        pha 
        lda $04e6
        jsr _905d
        pla 
_900d:
.export _900d
        pha 
        lda # $10
        ldx $a0
        beq _9019+1
        jsr txt_docked_token15
        lda # $19
_9019:
        bit _3385
        ldx # $00
        stx $34

        lda $b9
        jsr set_cursor_col
        
        pla 
        ldy # $14
        cpx $048b
        bne _9002
        sty $048b
        sta $04e6
        lda # $c0
        sta txt_buffer_flag
        lda $048c
        lsr 
        lda # $00
        bcc _9042
        lda # $0a
_9042:
        sta txt_buffer_index
        
        lda $04e6
        jsr print_flight_token

        lda # $20
        sec 
        sbc txt_buffer_index
        lsr 
        sta $b9
        jsr set_cursor_col
        
        jsr txt_docked_token0F
        lda $04e6
_905d:
        jsr print_flight_token

        lsr $048c
        bcc _9001
        
.import TXT_DESTROYED:direct
        lda # TXT_DESTROYED
        jmp print_flight_token

;===============================================================================

_906a:
        jsr get_random_number
        bmi _9001
        cpx # $16
        bcs _9001
        lda $04b0, x
        beq _9001
        lda $048b
        bne _9001
        ldy # $03
        sty $048c
        sta $04b0, x
        cpx # $11
        bcs _908f
        txa 
        adc # $d0
        jmp _900d

_908f:
        beq _909b
        cpx # $12
        beq _90a0
        txa 
        adc # $5d
        jmp _900d

_909b:
        lda # VAR_Y
        jmp _900d

_90a0:
        lda # $6f
        jmp _900d

;===============================================================================

_90a5:
        .byte   $13
_90a6:
        .byte   $82
_90a7:
        .byte   $06
_90a8:
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
        and ZP_POLYOBJ_ZPOS_pt1, x
        cpy # $07

_90e9:
        tya 
        ldy # $02
        jsr _91b8
        sta ZP_POLYOBJ_M1x2_HI
        jmp _9131

;===============================================================================

_90f4:
        tax 
        lda VAR_Y
        and # %01100000
        beq _90e9
        lda # $02
        jsr _91b8
        sta ZP_POLYOBJ_M1x1_HI
        jmp _9131

;===============================================================================

_9105:
        lda ZP_POLYOBJ_M0x0_HI
        sta VAR_X
        lda ZP_POLYOBJ_M0x1_HI
        sta VAR_Y
        lda ZP_POLYOBJ_M0x2_HI
        sta $6d
        jsr _8cc2
        lda VAR_X
        sta ZP_POLYOBJ_M0x0_HI
        lda VAR_Y
        sta ZP_POLYOBJ_M0x1_HI
        lda $6d
        sta ZP_POLYOBJ_M0x2_HI
        ldy # $04
        lda VAR_X
        and # %01100000
        beq _90f4
        ldx # $02
        lda # $00
        jsr _91b8
        sta ZP_POLYOBJ_M1x0_HI
_9131:
        lda ZP_POLYOBJ_M1x0_HI
        sta VAR_X
        lda ZP_POLYOBJ_M1x1_HI
        sta VAR_Y
        lda ZP_POLYOBJ_M1x2_HI
        sta $6d
        jsr _8cc2
        lda VAR_X
        sta ZP_POLYOBJ_M1x0_HI
        lda VAR_Y
        sta ZP_POLYOBJ_M1x1_HI
        lda $6d
        sta ZP_POLYOBJ_M1x2_HI
        lda ZP_POLYOBJ_M0x1_HI
        sta $9a
        lda ZP_POLYOBJ_M1x2_HI
        jsr _3aa8
        ldx ZP_POLYOBJ_M0x2_HI
        lda ZP_POLYOBJ_M1x1_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x0_HI
        lda ZP_POLYOBJ_M1x0_HI
        jsr _3aa8
        ldx ZP_POLYOBJ_M0x0_HI
        lda ZP_POLYOBJ_M1x2_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x1_HI
        lda ZP_POLYOBJ_M1x1_HI
        jsr _3aa8
        ldx ZP_POLYOBJ_M0x1_HI
        lda ZP_POLYOBJ_M1x0_HI
        jsr _3b0d
        eor # %10000000
        sta ZP_POLYOBJ_M2x2_HI
        lda # $00
        ldx # $0e
_9184:
        sta ZP_POLYOBJ_M0x0_LO, x
        dex 
        dex 
        bpl _9184
        rts 

;===============================================================================

_918b:
        tay 
        and # %01111111
        cmp $9a
        bcs _91b2
        ldx # $fe
        stx $bb
_9196:
        asl 
        cmp $9a
        bcc _919d
        sbc $9a
_919d:
        rol $bb
        bcs _9196
        lda $bb
        lsr 
        lsr 
        sta $bb
        lsr 
        adc $bb
        sta $bb
        tya 
        and # %10000000
        ora $bb
        rts 

_91b2:
        tya 
        and # %10000000
        ora # %01100000
        rts 

;===============================================================================

_91b8:
        sta $30
        lda ZP_POLYOBJ_M0x0_HI, x
        sta $9a
        lda ZP_POLYOBJ_M1x0_HI, x
        jsr _3aa8
        ldx ZP_POLYOBJ_M0x0_HI, y
        stx $9a
        lda $0019, y
        jsr _3ace
        stx $2e
        ldy $30
        ldx ZP_POLYOBJ_M0x0_HI, y
        stx $9a
        eor # %10000000
        sta $2f
        eor $9a
        and # %10000000
        sta $bb
        lda # $00
        ldx # $10
        asl $2e
        rol $2f
        asl $9a
        lsr $9a
_91eb:
        rol 
        cmp $9a
        bcc _91f2
        sbc $9a
_91f2:
        rol $2e
        rol $2f
        dex 
        bne _91eb
        lda $2e
        ora $bb
_91fd:
        rts 

;===============================================================================

_91fe:
        lda # $63
        ldx # $c1
        bne _920d
_9204:
.export _9204
        bit _1d11
        bmi _91fe
        lda # $2c
        ldx # $b7
_920d:
        sta _b4d0
        stx _b4d1
        bit _1d03
        bmi _91fd
        bit _1d10
        bmi _9222
        bit _1d0d
        bmi _91fd
_9222:
        lda # MEM_IO_ONLY
        jsr set_memory_layout

        jsr _b664
        lda # $ff
        sta _1d03
        bne _9266
_9231:
        sta _1d02
        eor # %11111111
        and $0480
        bmi _9222
_923b:
.export _923b
        bit _1d13
        bmi _91fd               ; negative value?
        bit _1d10
        bmi _9204               ; negative value?
_9245:
        bit _1d03
        bpl _91fd               ; positive value? (bit 7 is off)

        jsr _a817

        lda # MEM_IO_ONLY
        jsr set_memory_layout
        
        lda # $00
        sta _1d03
        ldx # $18
        sei 
_925a:
        sta $d400, x            ;voice 1: frequency control - low-byte
        dex 
        bpl _925a
        lda # $0f
        sta $d418               ;select filter mode and volume
        cli 
_9266:
        lda # MEM_64K
        jmp set_memory_layout

;===============================================================================

; unused / unreferenced?
;$926b:
        .byte   $02, $0f, $31, $32, $33, $34, $35, $36
        .byte   $37
_9274:
        .byte   $38, $39, $30, $31, $32, $33, $34, $35
        .byte   $36, $37
_927e:
        .byte   $00, $01, $51, $02 ,$20, $32, $03, $1b                  ;$927e
        .byte   $31, $2f, $5e, $3d ,$05, $06, $3b, $2a                  ;$9286
        .byte   $60, $2c, $40, $3a ,$2e, $2d, $4c, $50                  ;$928e
        .byte   $2b, $4e, $4f, $4b ,$4d, $30, $4a, $49                  ;$9296
        .byte   $39, $56, $55, $48 ,$42, $38, $47, $59                  ;$929e
        .byte   $37, $58, $54, $46 ,$43, $36, $44, $52                  ;$92a6
        .byte   $35, $07, $45, $53 ,$5a, $34, $41, $57                  ;$92ae
        .byte   $33, $08, $09, $0a ,$0b, $0c, $0e, $0d                  ;$92b6
        .byte   $7f, $a9, $05, $20 ,$7f, $82, $a9, $00                  ;$92be
        .byte   $8d, $15, $d0, $a9 ,$04, $78, $8d, $8e                  ;$92c6
        .byte   $82, $a5, $01, $29 ,$f8, $0d, $8e, $82                  ;$92ce
        .byte   $85, $01, $58, $60 ,$04, $a5, $2e, $8d                  ;$92d6
        .byte   $f2, $04, $a5, $2f ,$8d, $f3, $04, $60                  ;$92de
        .byte   $a6, $9d, $20, $f3 ,$82, $a6, $9d, $4c                  ;$92e6
        .byte   $2f, $20, $20, $47 ,$84, $20, $4f, $7b                  ;$92ee
        .byte   $8d, $53, $04, $8d ,$5f, $04, $20, $0e                  ;$92f6
        .byte   $b1, $a9                                                ;$92fe

;===============================================================================

_9300:
.export _9300
        .byte   $06, $00, $20, $32, $40, $4a, $52, $59                  ;$9300
        .byte   $5f, $65, $6a, $6e, $72, $76, $79, $7d                  ;$9308
        .byte   $80, $82, $85, $87, $8a, $8c, $8e, $90                  ;$9310
        .byte   $92, $94, $96, $98, $99, $9b, $9d, $9e                  ;$9318
        .byte   $a0, $a1, $a2, $a4, $a5, $a6, $a7, $a9                  ;$9320
        .byte   $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1                  ;$9328
        .byte   $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9                  ;$9330
        .byte   $b9, $ba, $bb, $bc, $bd, $bd, $be, $bf                  ;$9338
        .byte   $bf, $c0, $c1, $c2, $c2, $c3, $c4, $c4                  ;$9340
        .byte   $c5, $c6, $c6, $c7, $c7, $c8, $c9, $c9                  ;$9348
        .byte   $ca, $ca, $cb, $cc, $cc, $cd, $cd, $ce                  ;$9350
        .byte   $ce, $cf, $cf, $d0, $d0, $d1, $d1, $d2                  ;$9358
        .byte   $d2, $d3, $d3, $d4, $d4, $d5, $d5, $d5                  ;$9360
        .byte   $d6, $d6, $d7, $d7, $d8, $d8, $d9, $d9                  ;$9368
        .byte   $d9, $da, $da, $db, $db, $db, $dc, $dc                  ;$9370
        .byte   $dd, $dd, $dd, $de, $de, $de, $df, $df                  ;$9378
        .byte   $e0, $e0, $e0, $e1, $e1, $e1, $e2, $e2                  ;$9380
        .byte   $e2, $e3, $e3, $e3, $e4, $e4, $e4, $e5                  ;$9388
        .byte   $e5, $e5, $e6, $e6, $e6, $e7, $e7, $e7                  ;$9390
        .byte   $e7, $e8, $e8, $e8, $e9, $e9, $e9, $ea                  ;$9398
        .byte   $ea, $ea, $ea, $eb, $eb, $eb, $ec, $ec                  ;$93a0
        .byte   $ec, $ec, $ed, $ed, $ed, $ed, $ee, $ee                  ;$93a8
        .byte   $ee, $ee, $ef, $ef, $ef, $ef, $f0, $f0                  ;$93b0
        .byte   $f0, $f1, $f1, $f1, $f1, $f1, $f2, $f2                  ;$93b8
        .byte   $f2, $f2, $f3, $f3, $f3, $f3, $f4, $f4                  ;$93c0
        .byte   $f4, $f4, $f5, $f5, $f5, $f5, $f5, $f6                  ;$93c8
        .byte   $f6, $f6, $f6, $f7, $f7, $f7, $f7, $f7                  ;$93d0
        .byte   $f8, $f8, $f8, $f8, $f9, $f9, $f9, $f9                  ;$93d8
        .byte   $f9, $fa, $fa, $fa, $fa, $fa, $fb, $fb                  ;$93e0
        .byte   $fb, $fb, $fb, $fc, $fc, $fc, $fc, $fc                  ;$93e8
        .byte   $fd, $fd, $fd, $fd, $fd, $fd, $fe, $fe                  ;$93f0
        .byte   $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff                  ;$93f8


;===============================================================================

_9400:
.export _9400
        .byte   $ae, $00, $00, $b8, $00, $4d, $b8, $d5                  ;$9400
        .byte   $ff, $70, $4d, $b3, $b8, $6a, $d5, $05                  ;$9408
        .byte   $00, $cc, $70, $ef, $4d, $8d, $b3, $c1                  ;$9410
        .byte   $b8, $9a, $6a, $28, $d5, $74, $05, $88                  ;$9418
        .byte   $00, $6b, $cc, $23, $70, $b3, $ef, $22                  ;$9420
        .byte   $4d, $71, $8d, $a3, $b3, $bd, $c1, $bf                  ;$9428
        .byte   $b8, $ab, $9a, $84, $6a, $4b, $28, $00                  ;$9430
        .byte   $d5, $a7, $74, $3e, $05, $c8, $88, $45                  ;$9438
        .byte   $ff, $b7, $6b, $1d, $cc, $79, $23, $ca                  ;$9440
        .byte   $70, $13, $b3, $52, $ef, $89, $22, $b8                  ;$9448
        .byte   $4d, $e0, $71, $00, $8d, $19, $a3, $2c                  ;$9450
        .byte   $b3, $39, $bd, $3f, $c1, $40, $bf, $3c                  ;$9458
        .byte   $b8, $32, $ab, $23, $9a, $10, $84, $f7                  ;$9460
        .byte   $6a, $db, $4b, $ba, $28, $94, $00, $6b                  ;$9468
        .byte   $d5, $3e, $a7, $0e, $74, $da, $3e, $a2                  ;$9470
        .byte   $05, $67, $c8, $29, $88, $e7, $45, $a3                  ;$9478
        .byte   $00, $5b, $b7, $11, $6b, $c4, $1d, $75                  ;$9480
        .byte   $cc, $23, $79, $ce, $23, $77, $ca, $1d                  ;$9488
        .byte   $70, $c1, $13, $63, $b3, $03, $52, $a1                  ;$9490
        .byte   $ef, $3c, $89, $d6, $22, $6d, $b8, $03                  ;$9498
        .byte   $4d, $96, $e0, $28, $71, $b8, $00, $47                  ;$94a0
        .byte   $8d, $d4, $19, $5f, $a3, $e8, $2c, $70                  ;$94a8
        .byte   $b3, $f6, $39, $7b, $bd, $fe, $3f, $80                  ;$94b0
        .byte   $c1, $01, $40, $80, $bf, $fd, $3c, $7a                  ;$94b8
        .byte   $b8, $f5, $32, $6f, $ab, $e7, $23, $5f                  ;$94c0
        .byte   $9a, $d5, $10, $4a, $84, $be, $f7, $31                  ;$94c8
        .byte   $6a, $a2, $db, $13, $4b, $82, $ba, $f1                  ;$94d0
        .byte   $28, $5e, $94, $cb, $00, $36, $6b, $a0                  ;$94d8
        .byte   $d5, $0a, $3e, $73, $a7, $da, $0e, $41                  ;$94e0
        .byte   $74, $a7, $da, $0c, $3e, $70, $a2, $d3                  ;$94e8
        .byte   $05, $36, $67, $98, $c8, $f8, $29, $59                  ;$94f0
        .byte   $88, $b8, $e7, $16, $45, $74, $a3, $d1                  ;$94f8

;===============================================================================

_9500:
.export _9500
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9500
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9508
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9510
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9518
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9520
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9528
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9530
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9538
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9540
        .byte   $04, $04, $04, $05, $05, $05, $05, $05                  ;$9548
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9550
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9558
        .byte   $08, $08, $08, $08, $08, $08, $09, $09                  ;$9560
        .byte   $09, $09, $09, $0a, $0a, $0a, $0a, $0b                  ;$9568
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0c, $0d                  ;$9570
        .byte   $0d, $0d, $0e, $0e, $0e, $0e, $0f, $0f                  ;$9578
        .byte   $10, $10, $10, $11, $11, $11, $12, $12                  ;$9580
        .byte   $13, $13, $13, $14, $14, $15, $15, $16                  ;$9588
        .byte   $16, $17, $17, $18, $18, $19, $19, $1a                  ;$9590
        .byte   $1a, $1b, $1c, $1c, $1d, $1d, $1e, $1f                  ;$9598
        .byte   $20, $20, $21, $22, $22, $23, $24, $25                  ;$95a0
        .byte   $26, $26, $27, $28, $29, $2a, $2b, $2c                  ;$95a8
        .byte   $2d, $2e, $2f, $30, $31, $32, $33, $34                  ;$95b0
        .byte   $35, $36, $38, $39, $3a, $3b, $3d, $3e                  ;$95b8
        .byte   $40, $41, $42, $44, $45, $47, $48, $4a                  ;$95c0
        .byte   $4c, $4d, $4f, $51, $52, $54, $56, $58                  ;$95c8
        .byte   $5a, $5c, $5e, $60, $62, $64, $67, $69                  ;$95d0
        .byte   $6b, $6d, $70, $72, $75, $77, $7a, $7d                  ;$95d8
        .byte   $80, $82, $85, $88, $8b, $8e, $91, $94                  ;$95e0
        .byte   $98, $9b, $9e, $a2, $a5, $a9, $ad, $b1                  ;$95e8
        .byte   $b5, $b8, $bd, $c1, $c5, $c9, $ce, $d2                  ;$95f0
        .byte   $d7, $db, $e0, $e5, $ea, $ef, $f5, $fa                  ;$95f8

;===============================================================================

_9600:
.export _9600
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9600
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9608
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9610
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9618
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9620
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9628
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9630
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9638
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9640
        .byte   $04, $04, $05, $05, $05, $05, $05, $05                  ;$9648
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9650
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9658
        .byte   $08, $08, $08, $08, $08, $09, $09, $09                  ;$9660
        .byte   $09, $09, $0a, $0a, $0a, $0a, $0a, $0b                  ;$9668
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0d, $0d                  ;$9670
        .byte   $0d, $0d, $0e, $0e, $0e, $0f, $0f, $0f                  ;$9678
        .byte   $10, $10, $10, $11, $11, $12, $12, $12                  ;$9680
        .byte   $13, $13, $14, $14, $14, $15, $15, $16                  ;$9688
        .byte   $16, $17, $17, $18, $18, $19, $1a, $1a                  ;$9690
        .byte   $1b, $1b, $1c, $1d, $1d, $1e, $1e, $1f                  ;$9698
        .byte   $20, $21, $21, $22, $23, $24, $24, $25                  ;$96a0
        .byte   $26, $27, $28, $29, $29, $2a, $2b, $2c                  ;$96a8
        .byte   $2d, $2e, $2f, $30, $31, $32, $34, $35                  ;$96b0
        .byte   $36, $37, $38, $3a, $3b, $3c, $3d, $3f                  ;$96b8
        .byte   $40, $42, $43, $45, $46, $48, $49, $4b                  ;$96c0
        .byte   $4c, $4e, $50, $52, $53, $55, $57, $59                  ;$96c8
        .byte   $5b, $5d, $5f, $61, $63, $65, $68, $6a                  ;$96d0
        .byte   $6c, $6f, $71, $74, $76, $79, $7b, $7e                  ;$96d8
        .byte   $81, $84, $87, $8a, $8d, $90, $93, $96                  ;$96e0
        .byte   $99, $9d, $a0, $a4, $a7, $ab, $af, $b3                  ;$96e8
        .byte   $b6, $ba, $bf, $c3, $c7, $cb, $d0, $d4                  ;$96f0
        .byte   $d9, $de, $e3, $e8, $ed, $f2, $f7, $fd                  ;$96f8


;===============================================================================

; the BBC Micro, unusually for an 8-bit, has programmable display circuitry
; allowing the developer to create custom display modes. On the BBC, Elite uses
; a 256-px wide display for easy math (x-coordinates do not have to be 2 bytes)
; but on the C64 the screen is always 320-px wide and has a non-linear bitmap
; layout (pixels are in order of char-cells, not scanlines)
;
; therefore on the C64, there is some level of translation between a centred
; 256-px (32 char) display and the C64 screen.
;
;        1  4                             36  40
;       +---=------------------------------=---+
;       |   1                             32   |
;       |  ,--------------------------------.  |
;       |  |                                |  |
;       :  :                                :  :
;       '  '                                '  '
;     
; we're going to build a pair of lookup tables that translate a row index
; to a bitmap address for the 1st column of the centred display. each entry
; is repeated 8 times, probably to account for scanlines-per-char(?)

; first, calculate each row address:
_bmprow00 = ELITE_BITMAP_ADDR + .bmppos(  0, 4 ) ;=$4020
_bmprow01 = ELITE_BITMAP_ADDR + .bmppos(  1, 4 ) ;=$4160
_bmprow02 = ELITE_BITMAP_ADDR + .bmppos(  2, 4 ) ;=$42A0
_bmprow03 = ELITE_BITMAP_ADDR + .bmppos(  3, 4 ) ;=$43E0
_bmprow04 = ELITE_BITMAP_ADDR + .bmppos(  4, 4 ) ;=$4520
_bmprow05 = ELITE_BITMAP_ADDR + .bmppos(  5, 4 ) ;=$4660
_bmprow06 = ELITE_BITMAP_ADDR + .bmppos(  6, 4 ) ;=$47A0
_bmprow07 = ELITE_BITMAP_ADDR + .bmppos(  7, 4 ) ;=$48E0
_bmprow08 = ELITE_BITMAP_ADDR + .bmppos(  8, 4 ) ;=$4A20
_bmprow09 = ELITE_BITMAP_ADDR + .bmppos(  9, 4 ) ;=$4B60
_bmprow10 = ELITE_BITMAP_ADDR + .bmppos( 10, 4 ) ;=$4CA0
_bmprow11 = ELITE_BITMAP_ADDR + .bmppos( 11, 4 ) ;=$4DE0
_bmprow12 = ELITE_BITMAP_ADDR + .bmppos( 12, 4 ) ;=$4F20
_bmprow13 = ELITE_BITMAP_ADDR + .bmppos( 13, 4 ) ;=$5060
_bmprow14 = ELITE_BITMAP_ADDR + .bmppos( 14, 4 ) ;=$51A0
_bmprow15 = ELITE_BITMAP_ADDR + .bmppos( 15, 4 ) ;=$52E0
_bmprow16 = ELITE_BITMAP_ADDR + .bmppos( 16, 4 ) ;=$5420
_bmprow17 = ELITE_BITMAP_ADDR + .bmppos( 17, 4 ) ;=$5560
_bmprow18 = ELITE_BITMAP_ADDR + .bmppos( 18, 4 ) ;=$56A0
_bmprow19 = ELITE_BITMAP_ADDR + .bmppos( 19, 4 ) ;=$57E0
_bmprow20 = ELITE_BITMAP_ADDR + .bmppos( 20, 4 ) ;=$5920
_bmprow21 = ELITE_BITMAP_ADDR + .bmppos( 21, 4 ) ;=$5A60
_bmprow22 = ELITE_BITMAP_ADDR + .bmppos( 22, 4 ) ;=$5BA0
_bmprow23 = ELITE_BITMAP_ADDR + .bmppos( 23, 4 ) ;=$5CE0
_bmprow24 = ELITE_BITMAP_ADDR + .bmppos( 24, 4 ) ;=$5E20

; what is this madness!? despite the C64 screen being 25 rows, the data table
; just keeps going! this is purely because the lo/hi tables are indexed and it
; makes it faster to have these aligned a page ($00..$FF)

_bmprow25 = ELITE_BITMAP_ADDR + .bmppos( 25, 4 ) ;=$5F60
_bmprow26 = ELITE_BITMAP_ADDR + .bmppos( 26, 4 ) ;=$60A0
_bmprow27 = ELITE_BITMAP_ADDR + .bmppos( 27, 4 ) ;=$61E0
_bmprow28 = ELITE_BITMAP_ADDR + .bmppos( 28, 4 ) ;=$6320
_bmprow29 = ELITE_BITMAP_ADDR + .bmppos( 29, 4 ) ;=$6460
_bmprow30 = ELITE_BITMAP_ADDR + .bmppos( 30, 4 ) ;=$65A0
_bmprow31 = ELITE_BITMAP_ADDR + .bmppos( 31, 4 ) ;=$66E0

; repeat each row address 8 times:
.define _rowtobmp \
        _bmprow00, _bmprow00, _bmprow00, _bmprow00, \
        _bmprow00, _bmprow00, _bmprow00, _bmprow00, \
        _bmprow01, _bmprow01, _bmprow01, _bmprow01, \
        _bmprow01, _bmprow01, _bmprow01, _bmprow01, \
        _bmprow02, _bmprow02, _bmprow02, _bmprow02, \
        _bmprow02, _bmprow02, _bmprow02, _bmprow02, \
        _bmprow03, _bmprow03, _bmprow03, _bmprow03, \
        _bmprow03, _bmprow03, _bmprow03, _bmprow03, \
        _bmprow04, _bmprow04, _bmprow04, _bmprow04, \
        _bmprow04, _bmprow04, _bmprow04, _bmprow04, \
        _bmprow05, _bmprow05, _bmprow05, _bmprow05, \
        _bmprow05, _bmprow05, _bmprow05, _bmprow05, \
        _bmprow06, _bmprow06, _bmprow06, _bmprow06, \
        _bmprow06, _bmprow06, _bmprow06, _bmprow06, \
        _bmprow07, _bmprow07, _bmprow07, _bmprow07, \
        _bmprow07, _bmprow07, _bmprow07, _bmprow07, \
        _bmprow08, _bmprow08, _bmprow08, _bmprow08, \
        _bmprow08, _bmprow08, _bmprow08, _bmprow08, \
        _bmprow09, _bmprow09, _bmprow09, _bmprow09, \
        _bmprow09, _bmprow09, _bmprow09, _bmprow09, \
        _bmprow10, _bmprow10, _bmprow10, _bmprow10, \
        _bmprow10, _bmprow10, _bmprow10, _bmprow10, \
        _bmprow11, _bmprow11, _bmprow11, _bmprow11, \
        _bmprow11, _bmprow11, _bmprow11, _bmprow11, \
        _bmprow12, _bmprow12, _bmprow12, _bmprow12, \
        _bmprow12, _bmprow12, _bmprow12, _bmprow12, \
        _bmprow13, _bmprow13, _bmprow13, _bmprow13, \
        _bmprow13, _bmprow13, _bmprow13, _bmprow13, \
        _bmprow14, _bmprow14, _bmprow14, _bmprow14, \
        _bmprow14, _bmprow14, _bmprow14, _bmprow14, \
        _bmprow15, _bmprow15, _bmprow15, _bmprow15, \
        _bmprow15, _bmprow15, _bmprow15, _bmprow15, \
        _bmprow16, _bmprow16, _bmprow16, _bmprow16, \
        _bmprow16, _bmprow16, _bmprow16, _bmprow16, \
        _bmprow17, _bmprow17, _bmprow17, _bmprow17, \
        _bmprow17, _bmprow17, _bmprow17, _bmprow17, \
        _bmprow18, _bmprow18, _bmprow18, _bmprow18, \
        _bmprow18, _bmprow18, _bmprow18, _bmprow18, \
        _bmprow19, _bmprow19, _bmprow19, _bmprow19, \
        _bmprow19, _bmprow19, _bmprow19, _bmprow19, \
        _bmprow20, _bmprow20, _bmprow20, _bmprow20, \
        _bmprow20, _bmprow20, _bmprow20, _bmprow20, \
        _bmprow21, _bmprow21, _bmprow21, _bmprow21, \
        _bmprow21, _bmprow21, _bmprow21, _bmprow21, \
        _bmprow22, _bmprow22, _bmprow22, _bmprow22, \
        _bmprow22, _bmprow22, _bmprow22, _bmprow22, \
        _bmprow23, _bmprow23, _bmprow23, _bmprow23, \
        _bmprow23, _bmprow23, _bmprow23, _bmprow23, \
        _bmprow24, _bmprow24, _bmprow24, _bmprow24, \
        _bmprow24, _bmprow24, _bmprow24, _bmprow24, \
        _bmprow25, _bmprow25, _bmprow25, _bmprow25, \
        _bmprow25, _bmprow25, _bmprow25, _bmprow25, \
        _bmprow26, _bmprow26, _bmprow26, _bmprow26, \
        _bmprow26, _bmprow26, _bmprow26, _bmprow26, \
        _bmprow27, _bmprow27, _bmprow27, _bmprow27, \
        _bmprow27, _bmprow27, _bmprow27, _bmprow27, \
        _bmprow28, _bmprow28, _bmprow28, _bmprow28, \
        _bmprow28, _bmprow28, _bmprow28, _bmprow28, \
        _bmprow29, _bmprow29, _bmprow29, _bmprow29, \
        _bmprow29, _bmprow29, _bmprow29, _bmprow29, \
        _bmprow30, _bmprow30, _bmprow30, _bmprow30, \
        _bmprow30, _bmprow30, _bmprow30, _bmprow30, \
        _bmprow31, _bmprow31, _bmprow31, _bmprow31, \
        _bmprow31, _bmprow31, _bmprow31, _bmprow31

; write out separate 256-byte tables for lo-address / hi-address:
; TODO: these must be aligned by the linker

row_to_bitmap_lo:                                                       ;$9700
        .lobytes _rowtobmp

row_to_bitmap_hi:                                                       ;$9800
        .hibytes _rowtobmp

.export row_to_bitmap_lo
.export row_to_bitmap_hi

;===============================================================================

; referenced in the `chrout` routine, these are a pair of hi/lo-byte lookup
; tables that index a row number (0-24) to the place in the menu screen memory
; where that row starts -- note that Elite uses a 32-char (256 px) wide
; 'screen' so this equates the the 4th character in each row

.import ELITE_MENUSCR_COLOR_ADDR
.define menuscr_pos \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  0, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  1, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  2, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  3, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  4, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  5, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  6, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  7, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  8, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos(  9, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 10, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 11, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 12, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 13, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 14, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 15, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 16, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 17, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 18, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 19, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 20, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 21, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 22, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 23, 3 ), \
        ELITE_MENUSCR_COLOR_ADDR + .scrpos( 24, 3 )

menuscr_lo:                                                             ;$9900
        .lobytes menuscr_pos
menuscr_hi:                                                             ;$9919
        .hibytes menuscr_pos

;===============================================================================

_9932:
        jsr _9ad8
        jsr _7d1f
        ora $36
        bne _995d
        lda $43
        cmp # $8e
        bcs _995d
        ldy # $02
        jsr _9964
        ldy # $06
        lda $43
        adc # $01
        jsr _9964
        lda # $08
        ora $28
        sta $28
        lda # $08
        jmp _a174

_995b:
        pla 
        pla 
_995d:
        lda # $f7
        and $28
        sta $28
        rts 

;===============================================================================

_9964:
        sta [$2a], y
        iny 
        iny 
        sta [$2a], y
        lda $35
        dey 
        sta [$2a], y
        adc # $03
        bcs _995b
        dey 
        dey 
        sta [$2a], y
        rts 

;===============================================================================

_9978:
.export _9978
        ldy $9b
        lda $9a
        sta $9c
        ldx # $00
        stx $9a
        lda # $08
        sta $bb
_9986:
        cpx $9a
        bcc _9998
        bne _9990
        cpy # $40
        bcc _9998
_9990:
        tya 
        sbc # $40
        tay 
        txa 
        sbc $9a
        tax 
_9998:
        rol $9a
        asl $9c
        tya 
        rol 
        tay 
        txa 
        rol 
        tax 
        asl $9c
        tya 
        rol 
        tay 
        txa 
        rol 
        tax 
        dec $bb
        bne _9986
        rts 

;===============================================================================

_99af:
.export _99af
        cmp $9a
        bcs _9a07
        sta $b6
        tax 
        beq _99d3
        lda _9400, x
        ldx $9a
        sec 
        sbc _9400, x
        bmi _99d6
        ldx $b6
        lda _9300, x
        ldx $9a
        sbc _9300, x
        bcs _9a07
        tax 
        lda _9500, x
_99d3:
        sta $9b
        rts 

_99d6:
        ldx $b6
        lda _9300, x
        ldx $9a
        sbc _9300, x
        bcs _9a07
        tax 
        lda _9600, x
        sta $9b
        rts 

;===============================================================================

; unused / unreferenced?
;$99e9:
        bcs _9a07
        ldx # $fe
        stx $9b
_99ef:
        asl 
        bcs _99fd
        cmp $9a
        bcc _99f8
        sbc $9a
_99f8:
        rol $9b
        bcs _99ef
        rts 

_99fd:
        sbc $9a
        sec 
        rol $9b
        bcs _99ef
        lda $9b
        rts 

_9a07:
        lda # $ff
        sta $9b
        rts 

;===============================================================================

_9a0c:
        eor $9c
        bmi _9a16
        lda $9a
        clc 
        adc $9b
        rts 

_9a16:
        lda $9b
        sec 
        sbc $9a
        bcc _9a1f
        clc 
        rts 

_9a1f:
        pha 
        lda $9c
        eor # %10000000
        sta $9c
        pla 
        eor # %11111111
        adc # $01
        rts 

;===============================================================================

_9a2c:
.export _9a2c
        ldx # $00
        ldy # $00
_9a30:
        lda VAR_X
        sta $9a
        lda $45, x
        jsr _39ea
        sta $bb
        lda VAR_Y
        eor $46, x
        sta $9c
        lda $6d
        sta $9a
        lda $47, x
        jsr _39ea
        sta $9a
        lda $bb
        sta $9b
        lda $6e
        eor $48, x
        jsr _9a0c
        sta $bb
        lda $6f
        sta $9a
        lda $49, x
        jsr _39ea
        sta $9a
        lda $bb
        sta $9b
        lda $70
        eor $4a, x
        jsr _9a0c
        sta $0071, y
        lda $9c
        sta $0072, y
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

_9a83:
        jmp _7d62

_9a86:
.export _9a86
        lda $a5
        bmi _9a83
        lda # $1f
        sta $ad
        lda $2d
        bmi _9ad8
        lda # $20
        bit $28
        bne _9ac5
        bpl _9ac5
        ora $28
        and # %00111111
        sta $28
        lda # $00
        ldy # $1c
        sta [$59], y
        ldy # $1e
        sta [$59], y
        jsr _9ad8
        ldy # $01
        lda # $12
        sta [$2a], y
        ldy # $07
        lda [$57], y
        ldy # $02
        sta [$2a], y
_9abb:
        iny 
        jsr get_random_number
        sta [$2a], y
        cpy # $06
        bne _9abb
_9ac5:
        lda ZP_POLYOBJ_ZPOS_pt3
        bpl _9ae6
_9ac9:
        lda $28
        and # %00100000
        beq _9ad8
        lda $28
        and # %11110111
        sta $28
        jmp _7866

_9ad8:
        lda # $08
        bit $28
        beq _9ae5
        eor $28
        sta $28
        jmp _a178

_9ae5:
        rts 

_9ae6:
        lda ZP_POLYOBJ_ZPOS_pt2
        cmp # $c0
        bcs _9ac9
        lda ZP_POLYOBJ_XPOS_pt1
        cmp ZP_POLYOBJ_ZPOS_pt1
        lda ZP_POLYOBJ_XPOS_pt2
        sbc ZP_POLYOBJ_ZPOS_pt2
        bcs _9ac9
        lda ZP_POLYOBJ_YPOS_pt1
        cmp ZP_POLYOBJ_ZPOS_pt1
        lda ZP_POLYOBJ_YPOS_pt2
        sbc ZP_POLYOBJ_ZPOS_pt2
        bcs _9ac9
        ldy # $06
        lda [$57], y
        tax 
        lda # $ff
        sta $0100, x
        sta $0101, x
        lda ZP_POLYOBJ_ZPOS_pt1
        sta $bb
        lda ZP_POLYOBJ_ZPOS_pt2
        lsr 
        ror $bb
        lsr 
        ror $bb
        lsr 
        ror $bb
        lsr 
        bne _9b29
        lda $bb
        ror 
        lsr 
        lsr 
        lsr 
        sta $ad
        bpl _9b3a
_9b29:
        ldy # $0d
        lda [$57], y
        cmp ZP_POLYOBJ_ZPOS_pt2
        bcs _9b3a
        lda # $20
        and $28
        bne _9b3a
        jmp _9932

_9b3a:
        ldx # $05
_9b3c:
        lda ZP_POLYOBJ_M2x0_LO, x
        sta $45, x
        lda ZP_POLYOBJ_M1x0_LO, x
        sta $4b, x
        lda ZP_POLYOBJ_M0x0_LO, x
        sta $51, x
        dex 
        bpl _9b3c
        lda # $c5
        sta $9a
        ldy # $10
_9b51:
        lda $0045, y
        asl 
        lda $0046, y
        rol 
        jsr _99af
        ldx $9b
        stx $45, y
        dey 
        dey 
        bpl _9b51
        ldx # $08
_9b66:
        lda ZP_POLYOBJ_XPOS_pt1, x
        sta $85, x
        dex 
        bpl _9b66
        lda # $ff
        sta $44
        ldy # $0c
        lda $28
        and # %00100000
        beq _9b8b
        lda [$57], y
        lsr 
        lsr 
        tax 
        lda # $ff
_9b80:
        sta $35, x
        dex 
        bpl _9b80
        inx 
        stx $ad
_9b88:
        jmp _9cfe

_9b8b:
        lda [$57], y
        beq _9b88
        sta $ae
        ldy # $12
        lda [$57], y
        tax 
        lda $8c
        tay 
        beq _9baa
_9b9b:
        inx 
        lsr $89
        ror $88
        lsr $86
        ror $85
        lsr 
        ror $8b
        tay 
        bne _9b9b
_9baa:
        stx $9f
        lda $8d
        sta $70
        lda $85
        sta VAR_X
        lda $87
        sta VAR_Y
        lda $88
        sta $6d
        lda $8a
        sta $6e
        lda $8b
        sta $6f
        jsr _9a2c
        lda $71
        sta $85
        lda $72
        sta $87
        lda $73
        sta $88
        lda $74
        sta $8a
        lda $75
        sta $8b
        lda $76
        sta $8d
        ldy # $04
        lda [$57], y
        clc 
        adc $57
        sta $5b
        ldy # $11
        lda [$57], y
        adc $58
        sta $5c
        ldy # $00
_9bf2:
        lda [$5b], y
        sta $72
        and # %00011111
        cmp $ad
        bcs _9c0b
        tya 
        lsr 
        lsr 
        tax 
        lda # $ff
        sta $35, x
        tya 
        adc # $04
        tay 
        jmp _9cf7

_9c0b:
        lda $72
        asl 
        sta $74
        asl 
        sta $76
        iny 
        lda [$5b], y
        sta $71
        iny 
        lda [$5b], y
        sta $73
        iny 
        lda [$5b], y
        sta $75
        ldx $9f
        cpx # $04
        bcc _9c4b
        lda $85
        sta VAR_X
        lda $87
        sta VAR_Y
        lda $88
        sta $6d
        lda $8a
        sta $6e
        lda $8b
        sta $6f
        lda $8d
        sta $70
        jmp _9ca9

;===============================================================================

_9c43:
        lsr $85
        lsr $8b
        lsr $88
        ldx # $01
_9c4b:
        lda $71
        sta VAR_X
        lda $73
        sta $6d
        lda $75
        dex 
        bmi _9c60
_9c58:
        lsr VAR_X
        lsr $6d
        lsr 
        dex 
        bpl _9c58
_9c60:
        sta $9b
        lda $76
        sta $9c
        lda $8b
        sta $9a
        lda $8d
        jsr _9a0c
        bcs _9c43
        sta $6f
        lda $9c
        sta $70
        lda VAR_X
        sta $9b
        lda $72
        sta $9c
        lda $85
        sta $9a
        lda $87
        jsr _9a0c
        bcs _9c43
        sta VAR_X
        lda $9c
        sta VAR_Y
        lda $6d
        sta $9b
        lda $74
        sta $9c
        lda $88
        sta $9a
        lda $8a
        jsr _9a0c
        bcs _9c43
        sta $6d
        lda $9c
        sta $6e
_9ca9:
        lda $71
        sta $9a
        lda VAR_X
        jsr _39ea
        sta $bb
        lda $72
        eor VAR_Y
        sta $9c
        lda $73
        sta $9a
        lda $6d
        jsr _39ea
        sta $9a
        lda $bb
        sta $9b
        lda $74
        eor $6e
        jsr _9a0c
        sta $bb
        lda $75
        sta $9a
        lda $6f
        jsr _39ea
        sta $9a
        lda $bb
        sta $9b
        lda $70
        eor $76
        jsr _9a0c
        pha 
        tya 
        lsr 
        lsr 
        tax 
        pla 
        bit $9c
        bmi _9cf4
        lda # $00
_9cf4:
        sta $35, x
        iny 
_9cf7:
        cpy $ae
        bcs _9cfe
        jmp _9bf2

        ;-----------------------------------------------------------------------

_9cfe:
        ldy $47
        ldx $48
        lda $4b
        sta $47
        lda $4c
        sta $48
        sty $4b
        stx $4c
        ldy $49
        ldx $4a
        lda $51
        sta $49
        lda $52
        sta $4a
        sty $51
        stx $52
        ldy $4f
        ldx $50
        lda $53
        sta $4f
        lda $54
        sta $50
        sty $53
        stx $54
        ldy # $08
        lda [$57], y
        sta $ae
        lda $57
        clc 
        adc # $14
        sta $5b
        lda $58
        adc # $00
        sta $5c
        ldy # $00
        sty $aa
_9d45:
        sty $9f
        lda [$5b], y
        sta VAR_X
        iny 
        lda [$5b], y
        sta $6d
        iny 
        lda [$5b], y
        sta $6f
        iny 
        lda [$5b], y
        sta $bb
        and # %00011111
        cmp $ad
        bcc _9d8e
        iny 
        lda [$5b], y
        sta $2e
        and # %00001111
        tax 
        lda $35, x
        bne _9d91
        lda $2e
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda $35, x
        bne _9d91
        iny 
        lda [$5b], y
        sta $2e
        and # %00001111
        tax 
        lda $35, x
        bne _9d91
        lda $2e
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda $35, x
        bne _9d91
_9d8e:
.export _9d8e
        jmp _9f06

        ;-----------------------------------------------------------------------

_9d91:
        lda $bb
        sta VAR_Y
        asl 
        sta $6e
        asl 
        sta $70
        jsr _9a2c
        lda ZP_POLYOBJ_XPOS_pt3
        sta $6d
        eor $72
        bmi _9db6
        clc 
        lda $71
        adc ZP_POLYOBJ_XPOS_pt1
        sta VAR_X
        lda ZP_POLYOBJ_XPOS_pt2
        adc # $00
        sta VAR_Y
_9db3:
.export _9db3
        jmp _9dd9

_9db6:
        lda ZP_POLYOBJ_XPOS_pt1
        sec 
        sbc $71
        sta VAR_X
        lda ZP_POLYOBJ_XPOS_pt2
        sbc # $00
        sta VAR_Y
        bcs _9dd9
        eor # %11111111
        sta VAR_Y
        lda # $01
        sbc VAR_X
        sta VAR_X
        bcc _9dd3
        inc VAR_Y
_9dd3:
        lda $6d
        eor # %10000000
        sta $6d
_9dd9:
        lda ZP_POLYOBJ_YPOS_pt3
        sta $70
        eor $74
        bmi _9df1
        clc 
        lda $73
        adc ZP_POLYOBJ_YPOS_pt1
        sta $6e
        lda ZP_POLYOBJ_YPOS_pt2
        adc # $00
        sta $6f
_9dee:
.export _9dee
        jmp _9e16

        ;-----------------------------------------------------------------------

_9df1:
        lda ZP_POLYOBJ_YPOS_pt1
        sec 
        sbc $73
        sta $6e
        lda ZP_POLYOBJ_YPOS_pt2
        sbc # $00
        sta $6f
        bcs _9e16
        eor # %11111111
        sta $6f
        lda $6e
        eor # %11111111
        adc # $01
        sta $6e
        lda $70
        eor # %10000000
        sta $70
        bcc _9e16
        inc $6f
_9e16:
        lda $76
        bmi _9e64
        lda $75
        clc 
        adc ZP_POLYOBJ_ZPOS_pt1
        sta $bb
        lda ZP_POLYOBJ_ZPOS_pt2
        adc # $00
        sta $99
_9e27:
.export _9e27
        jmp _9e83

;===============================================================================

_9e2a:
        ldx $9a
        beq _9e4a
        ldx # $00
_9e30:
        lsr 
        inx 
        cmp $9a
        bcs _9e30
        stx $9c
        jsr _99af
        ldx $9c
        lda $9b
_9e3f:
        asl 
        rol $99
        bmi _9e4a
        dex 
        bne _9e3f
        sta $9b
        rts 

_9e4a:
        lda # $32
        sta $9b
        sta $99
        rts 

;===============================================================================

_9e51:
        lda # $80
        sec 
        sbc $9b
        sta $0100, x
        inx 
        lda # $00
        sbc $99
        sta $0100, x
        jmp _9ec3

;===============================================================================

_9e64:
        lda ZP_POLYOBJ_ZPOS_pt1
        sec 
        sbc $75
        sta $bb
        lda ZP_POLYOBJ_ZPOS_pt2
        sbc # $00
        sta $99
        bcc _9e7b
        bne _9e83
        lda $bb
        cmp # $04
        bcs _9e83
_9e7b:
        lda # $00
        sta $99
        lda # $04
        sta $bb
_9e83:
        lda $99
        ora VAR_Y
        ora $6f
        beq _9e9a
        lsr VAR_Y
        ror VAR_X
        lsr $6f
        ror $6e
        lsr $99
        ror $bb
        jmp _9e83

_9e9a:
        lda $bb
        sta $9a
        lda VAR_X
        cmp $9a
        bcc _9eaa
        jsr _9e2a
        jmp _9ead

_9eaa:
        jsr _99af
_9ead:
        ldx $aa
        lda $6d
        bmi _9e51
        lda $9b
        clc 
        adc # $80
        sta $0100, x
        inx 
        lda $99
        adc # $00
        sta $0100, x
_9ec3:
       .phx                     ; push X to stack (via A)
        lda # $00
        sta $99
        lda $bb
        sta $9a
        lda $6e
        cmp $9a
        bcc _9eec
        jsr _9e2a
        jmp _9eef

_9ed9:
        lda # $48
        clc 
        adc $9b
        sta $0100, x
        inx 
        lda # $00
        adc $99
        sta $0100, x
        jmp _9f06

_9eec:
        jsr _99af
_9eef:
        pla 
        tax 
        inx 
        lda $70
        bmi _9ed9
        lda # $48
        sec 
        sbc $9b
        sta $0100, x
        inx 
        lda # $00
        sbc $99
        sta $0100, x
_9f06:
        clc 
        lda $aa
        adc # $04
        sta $aa
        lda $9f
        adc # $06
        tay 
        bcs _9f1b
        cmp $ae
        bcs _9f1b
        jmp _9d45

_9f1b:
        lda $28
        and # %00100000
        beq _9f2a
        lda $28
        ora # %00001000
        sta $28
        jmp _7866

_9f2a:
        lda # $08
        bit $28
        beq _9f35
        jsr _a178
        lda # $08
_9f35:
        ora $28
        sta $28
        ldy # $09
        lda [$57], y
        sta $ae
        ldy # $00
        sty $99
        sty $9f
        inc $99
        bit $28
        bvc _9f9f
        lda $28
        and # %10111111
        sta $28
        ldy # $06
        lda [$57], y
        tay 
        ldx $0100, y
        stx VAR_X
        inx 
        beq _9f9f
        ldx $0101, y
        stx VAR_Y
        inx 
        beq _9f9f
        ldx $0102, y
        stx $6d
        ldx $0103, y
        stx $6e
        lda # $00
        sta $6f
        sta $70
        sta $72
        lda ZP_POLYOBJ_ZPOS_pt1
        sta $71
        lda ZP_POLYOBJ_XPOS_pt3
        bpl _9f82
        dec $6f
_9f82:
        jsr _a013
        bcs _9f9f
        ldy $99
        lda VAR_X
        sta [$2a], y
        iny 
        lda VAR_Y
        sta [$2a], y
        iny 
        lda $6d
        sta [$2a], y
        iny 
        lda $6e
        sta [$2a], y
        iny 
        sty $99
_9f9f:
        ldy # $03
        clc 
        lda [$57], y
        adc $57
        sta $5b
        ldy # $10
        lda [$57], y
        adc $58
        sta $5c
        ldy # $05
        lda [$57], y
        sta $06
        ldy $9f
_9fb8:
        lda [$5b], y
        cmp $ad
        bcc _9fd6
        iny 
        lda [$5b], y
        iny 
        sta $2e
        and # %00001111
        tax 
        lda $35, x
        bne _9fd9
        lda $2e
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda $35, x
        bne _9fd9
_9fd6:
        jmp _a15b

_9fd9:
        lda [$5b], y
        tax 
        iny 
        lda [$5b], y
        sta $9a
        lda $0101, x
        sta VAR_Y
        lda $0100, x
        sta VAR_X
        lda $0102, x
        sta $6d
        lda $0103, x
        sta $6e
        ldx $9a
        lda $0100, x
        sta $6f
        lda $0103, x
        sta $72
        lda $0102, x
        sta $71
        lda $0101, x
        sta $70
        jsr _a01a
        bcs _9fd6
        jmp _a13f

;===============================================================================

_a013:
.export _a013
        lda # $00
        sta $06f4
        lda $70
_a01a:
        bit $b7
        bmi _a03c
        ldx # $8f
        ora $72
        bne _a02a
        cpx $71
        bcc _a02a
        ldx # $00
_a02a:
        stx $a2
        lda VAR_Y
        ora $6e
        bne _a04e
        lda # $8f
        cmp $6d
        bcc _a04e
        lda $a2
        bne _a04c
_a03c:
        lda $6d
        sta VAR_Y
        lda $6f
        sta $6d
        lda $71
        sta $6e
        clc 
        rts 

;===============================================================================

_a04a:
        sec 
        rts 

;===============================================================================

_a04c:
        lsr $a2
_a04e:
        lda $a2
        bpl _a081
        lda VAR_Y
        and $70
        bmi _a04a
        lda $6e
        and $72
        bmi _a04a
        ldx VAR_Y
        dex 
        txa 
        ldx $70
        dex 
        stx $73
        ora $73
        bpl _a04a
        lda $6d
        cmp # $90
        lda $6e
        sbc # $00
        sta $73
        lda $71
        cmp # $90
        lda $72
        sbc # $00
        ora $73
        bpl _a04a
_a081:
       .phy                     ; push Y to stack (via A)
        lda $6f
        sec 
        sbc VAR_X
        sta $73
        lda $70
        sbc VAR_Y
        sta $74
        lda $71
        sec 
        sbc $6d
        sta $75
        lda $72
        sbc $6e
        sta $76
        eor $74
        sta $9c
        lda $76
        bpl _a0b2
        lda # $00
        sec 
        sbc $75
        sta $75
        lda # $00
        sbc $76
        sta $76
_a0b2:
        lda $74
        bpl _a0c1
        sec 
        lda # $00
        sbc $73
        sta $73
        lda # $00
        sbc $74
_a0c1:
        tax 
        bne _a0c8
        ldx $76
        beq _a0d2
_a0c8:
        lsr 
        ror $73
        lsr $76
        ror $75
        jmp _a0c1

        ;-----------------------------------------------------------------------

_a0d2:
        stx $bb
        lda $73
        cmp $75
        bcc _a0e4
        sta $9a
        lda $75
        jsr _99af
        jmp _a0ef

_a0e4:
        lda $75
        sta $9a
        lda $73
        jsr _99af
        dec $bb
_a0ef:
        lda $9b
        sta $73
        lda $9c
        sta $74
        lda $a2
        beq _a0fd
        bpl _a110
_a0fd:
        jsr _a19f
        lda $a2
        bpl _a136
        lda VAR_Y
        ora $6e
        bne _a13b
        lda $6d
        cmp # $90
        bcs _a13b
_a110:
        ldx VAR_X
        lda $6f
        sta VAR_X
        stx $6f
        lda $70
        ldx VAR_Y
        stx $70
        sta VAR_Y
        ldx $6d
        lda $71
        sta $6d
        stx $71
        lda $72
        ldx $6e
        stx $72
        sta $6e
        jsr _a19f
        dec $06f4
_a136:
        pla 
        tay 
        jmp _a03c

        ;-----------------------------------------------------------------------

_a13b:
        pla 
        tay 
        sec 
        rts 

;===============================================================================

_a13f:
        ldy $99
        lda VAR_X
        sta [$2a], y
        iny 
        lda VAR_Y
        sta [$2a], y
        iny 
        lda $6d
        sta [$2a], y
        iny 
        lda $6e
        sta [$2a], y
        iny 
        sty $99
        cpy $06
        bcs _a172
_a15b:
        inc $9f
        ldy $9f
        cpy $ae
        bcs _a172
        ldy # $00
        lda $5b
        adc # $04
        sta $5b
        bcc _a16f
        inc $5c
_a16f:
        jmp _9fb8

        ;-----------------------------------------------------------------------

_a172:
        lda $99
_a174:
        ldy # $00
        sta [$2a], y
_a178:
        ldy # $00
        lda [$2a], y
        sta $ae
        cmp # $04
        bcc _a19e
        iny 
_a183:
        lda [$2a], y
        sta VAR_X
        iny 
        lda [$2a], y
        sta VAR_Y
        iny 
        lda [$2a], y
        sta $6d
        iny 
        lda [$2a], y
        sta $6e
        jsr _ab91
        iny 
        cpy $ae
        bcc _a183
_a19e:
        rts 

;===============================================================================

_a19f:
        lda VAR_Y
        bpl _a1ba
        sta $9c
        jsr _a219
        txa 
        clc 
        adc $6d
        sta $6d
        tya 
        adc $6e
        sta $6e
        lda # $00
        sta VAR_X
        sta VAR_Y
        tax 
_a1ba:
        beq _a1d5
        sta $9c
        dec $9c
        jsr _a219
        txa 
        clc 
        adc $6d
        sta $6d
        tya 
        adc $6e
        sta $6e
        ldx # $ff
        stx VAR_X
        inx 
        stx VAR_Y
_a1d5:
        lda $6e
        bpl _a1f3
        sta $9c
        lda $6d
        sta $9b
        jsr _a248
        txa 
        clc 
        adc VAR_X
        sta VAR_X
        tya 
        adc VAR_Y
        sta VAR_Y
        lda # $00
        sta $6d
        sta $6e
_a1f3:
        lda $6d
        sec 
        sbc # $90
        sta $9b
        lda $6e
        sbc # $00
        sta $9c
        bcc _a218
        jsr _a248
        txa 
        clc 
        adc VAR_X
        sta VAR_X
        tya 
        adc VAR_Y
        sta VAR_Y
        lda # $8f
        sta $6d
        lda # $00
        sta $6e
_a218:
        rts 

;===============================================================================

_a219:
        lda VAR_X
        sta $9b
        jsr _a284
        pha 
        ldx $bb
        bne _a250
_a225:
        lda # $00
        tax 
        tay 
        lsr $9c
        ror $9b
        asl $9a
        bcc _a23a
_a231:
        txa 
        clc 
        adc $9b
        tax 
        tya 
        adc $9c
        tay 
_a23a:
        lsr $9c
        ror $9b
        asl $9a
        bcs _a231
        bne _a23a
        pla 
        bpl _a277
        rts 

;===============================================================================

_a248:
        jsr _a284
        pha 
        ldx $bb
        bne _a225
_a250:
        lda # $ff
        tay 
        asl 
        tax 
_a255:
        asl $9b
        rol $9c
        lda $9c
        bcs _a261
        cmp $9a
        bcc _a26c
_a261:
        sbc $9a
        sta $9c
        lda $9b
        sbc # $00
        sta $9b
        sec 
_a26c:
        txa 
        rol 
        tax 
        tya 
        rol 
        tay 
        bcs _a255
        pla 
        bmi _a283
_a277:
        txa 
        eor # %11111111
        adc # $01
        tax 
        tya 
        eor # %11111111
        adc # $00
        tay 
_a283:
        rts 

;===============================================================================

_a284:
        ldx $73
        stx $9a
        lda $9c
        bpl _a29d
        lda # $00
        sec 
        sbc $9b
        sta $9b
        lda $9c
        pha 
        eor # %11111111
        adc # $00
        sta $9c
        pla 
_a29d:
        eor $74
        rts 

;===============================================================================

_a2a0:
.export _a2a0
        lda $28
        and # %10100000
        bne _a2cb
        lda $a3                 ; move counter?
        eor $9d
        and # %00001111
        bne _a2b1
        jsr _9105
_a2b1:
        ldx $a5
        bpl _a2b8
        jmp _a53d

        ;-----------------------------------------------------------------------

_a2b8:
        lda $29
        bpl _a2cb
        cpx # $01
        beq _a2c8
        lda $a3                 ; move counter?
        eor $9d
        and # %00000111
        bne _a2cb
_a2c8:
        jsr _32ad
_a2cb:
        jsr _b410
        lda ZP_POLYOBJ_VERTX_LO
        asl 
        asl 
        sta $9a
        lda ZP_POLYOBJ_M0x0_HI
        and # %01111111
        jsr _39ea
        sta $9b
        lda ZP_POLYOBJ_M0x0_HI
        ldx # $00
        jsr _a44a
        lda ZP_POLYOBJ_M0x1_HI
        and # %01111111
        jsr _39ea
        sta $9b
        lda ZP_POLYOBJ_M0x1_HI
        ldx # $03
        jsr _a44a
        lda ZP_POLYOBJ_M0x2_HI
        and # %01111111
        jsr _39ea
        sta $9b
        lda ZP_POLYOBJ_M0x2_HI
        ldx # $06
        jsr _a44a
        lda ZP_POLYOBJ_VERTX_LO
        clc 
        adc ZP_POLYOBJ_VERTX_HI
        bpl _a30d
        lda # $00
_a30d:
        ldy # $0f
        cmp [$57], y
        bcc _a315
        lda [$57], y
_a315:
        sta ZP_POLYOBJ_VERTX_LO
        lda # $00
        sta ZP_POLYOBJ_VERTX_HI
        ldx $68
        lda ZP_POLYOBJ_XPOS_pt1
        eor # %11111111
        sta $2e
        lda ZP_POLYOBJ_XPOS_pt2
        jsr _3a25
        sta $30
        lda $6a
        eor ZP_POLYOBJ_XPOS_pt3
        ldx # $03
        jsr _a508
        sta $b5
        lda $2f
        sta $b3
        eor # %11111111
        sta $2e
        lda $30
        sta $b4
        ldx $64
        jsr _3a25
        sta $30
        lda $b5
        eor $94
        ldx # $06
        jsr _a508
        sta ZP_POLYOBJ_ZPOS_pt3
        lda $2f
        sta ZP_POLYOBJ_ZPOS_pt1
        eor # %11111111
        sta $2e
        lda $30
        sta ZP_POLYOBJ_ZPOS_pt2
        jsr _3a27
        sta $30
        lda $b5
        sta ZP_POLYOBJ_YPOS_pt3
        eor $94
        eor ZP_POLYOBJ_ZPOS_pt3
        bpl _a37d
        lda $2f
        adc $b3
        sta ZP_POLYOBJ_YPOS_pt1
        lda $30
        adc $b4
        sta ZP_POLYOBJ_YPOS_pt2
        jmp _a39d

_a37d:
        lda $b3
        sbc $2f
        sta ZP_POLYOBJ_YPOS_pt1
        lda $b4
        sbc $30
        sta ZP_POLYOBJ_YPOS_pt2
        bcs _a39d
        lda # $01
        sbc ZP_POLYOBJ_YPOS_pt1
        sta ZP_POLYOBJ_YPOS_pt1
        lda # $00
        sbc ZP_POLYOBJ_YPOS_pt2
        sta ZP_POLYOBJ_YPOS_pt2
        lda ZP_POLYOBJ_YPOS_pt3
        eor # %10000000
        sta ZP_POLYOBJ_YPOS_pt3
_a39d:
        ldx $68
        lda ZP_POLYOBJ_YPOS_pt1
        eor # %11111111
        sta $2e
        lda ZP_POLYOBJ_YPOS_pt2
        jsr _3a25
        sta $30
        lda $69
        eor ZP_POLYOBJ_YPOS_pt3
        ldx # $00
        jsr _a508
        sta ZP_POLYOBJ_XPOS_pt3
        lda $30
        sta ZP_POLYOBJ_XPOS_pt2
        lda $2f
        sta ZP_POLYOBJ_XPOS_pt1
_a3bf:
        lda $96                 ; player's ship speed?
        sta $9b
        lda # $80
        ldx # $06
        jsr _a44c
        lda $a5
        and # %10000001
        cmp # $81
        bne _a3d3
        rts 

        ;-----------------------------------------------------------------------

_a3d3:
        ldy # $09
        jsr _a4a1
        ldy # $0f
        jsr _a4a1
        ldy # $15
        jsr _a4a1
        lda $27
        and # %10000000
        sta $b1
        lda $27
        and # %01111111
        beq _a40b
        cmp # $7f
        sbc # $00
        ora $b1
        sta $27
        ldx # $0f
        ldy # $09
        jsr _2dc5
        ldx # $11
        ldy # $0b
        jsr _2dc5
        ldx # $13
        ldy # $0d
        jsr _2dc5
_a40b:
        lda $26
        and # %10000000
        sta $b1
        lda $26
        and # %01111111
        beq _a434
        cmp # $7f
        sbc # $00
        ora $b1
        sta $26
        ldx # $0f
        ldy # $15
        jsr _2dc5
        ldx # $11
        ldy # $17
        jsr _2dc5
        ldx # $13
        ldy # $19
        jsr _2dc5
_a434:
        lda $28
        and # %10100000
        bne _a443
        lda $28
        ora # %00010000
        sta $28
        jmp _b410

        ;-----------------------------------------------------------------------

_a443:
        lda $28
        and # %11101111
        sta $28
        rts 

;===============================================================================

_a44a:
        and # %10000000
_a44c:
.export _a44c
        asl 
        sta $9c
        lda # $00
        ror 
        sta $bb
        lsr $9c
        eor ZP_POLYOBJ_XPOS_pt3, x
        bmi _a46f
        lda $9b
        adc ZP_POLYOBJ_XPOS_pt1, x
        sta ZP_POLYOBJ_XPOS_pt1, x
        lda $9c
        adc ZP_POLYOBJ_XPOS_pt2, x
        sta ZP_POLYOBJ_XPOS_pt2, x
        lda ZP_POLYOBJ_XPOS_pt3, x
        adc # $00
        ora $bb
        sta ZP_POLYOBJ_XPOS_pt3, x
        rts 

        ;-----------------------------------------------------------------------

_a46f:
        lda ZP_POLYOBJ_XPOS_pt1, x
        sec 
        sbc $9b
        sta ZP_POLYOBJ_XPOS_pt1, x
        lda ZP_POLYOBJ_XPOS_pt2, x
        sbc $9c
        sta ZP_POLYOBJ_XPOS_pt2, x
        lda ZP_POLYOBJ_XPOS_pt3, x
        and # %01111111
        sbc # $00
        ora # %10000000
        eor $bb
        sta ZP_POLYOBJ_XPOS_pt3, x
        bcs _a4a0
        lda # $01
        sbc ZP_POLYOBJ_XPOS_pt1, x
        sta ZP_POLYOBJ_XPOS_pt1, x
        lda # $00
        sbc ZP_POLYOBJ_XPOS_pt2, x
        sta ZP_POLYOBJ_XPOS_pt2, x
        lda # $00
        sbc ZP_POLYOBJ_XPOS_pt3, x
        and # %01111111
        ora $bb
        sta ZP_POLYOBJ_XPOS_pt3, x
_a4a0:
        rts 

;===============================================================================

_a4a1:
        lda $a6
        sta $9a
        ldx ZP_POLYOBJ_XPOS_pt3, y
        stx $9b
        ldx ZP_POLYOBJ_YPOS_pt1, y
        stx $9c
        ldx ZP_POLYOBJ_XPOS_pt1, y
        stx $2e
        lda $000a, y
        eor # %10000000
        jsr _3ace
        sta $000c, y
        stx ZP_POLYOBJ_XPOS_pt3, y
        stx $2e
        ldx ZP_POLYOBJ_XPOS_pt1, y
        stx $9b
        ldx ZP_POLYOBJ_XPOS_pt2, y
        stx $9c
        lda $000c, y
        jsr _3ace
        sta $000a, y
        stx ZP_POLYOBJ_XPOS_pt1, y
        stx $2e
        lda $63
        sta $9a
        ldx ZP_POLYOBJ_XPOS_pt3, y
        stx $9b
        ldx ZP_POLYOBJ_YPOS_pt1, y
        stx $9c
        ldx ZP_POLYOBJ_YPOS_pt2, y
        stx $2e
        lda $000e, y
        eor # %10000000
        jsr _3ace
        sta $000c, y
        stx ZP_POLYOBJ_XPOS_pt3, y
        stx $2e
        ldx ZP_POLYOBJ_YPOS_pt2, y
        stx $9b
        ldx ZP_POLYOBJ_YPOS_pt3, y
        stx $9c
        lda $000c, y
        jsr _3ace
        sta $000e, y
        stx ZP_POLYOBJ_YPOS_pt2, y
        rts 

;===============================================================================

_a508:
        tay 
        eor ZP_POLYOBJ_XPOS_pt3, x
        bmi _a51c
        lda $2f
        clc 
        adc ZP_POLYOBJ_XPOS_pt1, x
        sta $2f
        lda $30
        adc ZP_POLYOBJ_XPOS_pt2, x
        sta $30
        tya 
        rts 
        
        ;-----------------------------------------------------------------------

_a51c:
        lda ZP_POLYOBJ_XPOS_pt1, x
        sec 
        sbc $2f
        sta $2f
        lda ZP_POLYOBJ_XPOS_pt2, x
        sbc $30
        sta $30
        bcc _a52f
        tya 
        eor # %10000000
        rts 

        ;-----------------------------------------------------------------------

_a52f:
        lda # $01
        sbc $2f
        sta $2f
        lda # $00
        sbc $30
        sta $30
        tya 
        rts 

;===============================================================================

_a53d:
        lda $a6
        eor # %10000000
        sta $9a
        lda ZP_POLYOBJ_XPOS_pt1
        sta $2e
        lda ZP_POLYOBJ_XPOS_pt2
        sta $2f
        lda ZP_POLYOBJ_XPOS_pt3
        jsr _38f8
        ldx # $03
        jsr _2d69
        lda $78
        sta $b3
        sta $2e
        lda $79
        sta $b4
        sta $2f
        lda $63
        sta $9a
        lda $7a
        sta $b5
        jsr _38f8
        ldx # $06
        jsr _2d69
        lda $78
        sta $2e
        sta ZP_POLYOBJ_ZPOS_pt1
        lda $79
        sta $2f
        sta ZP_POLYOBJ_ZPOS_pt2
        lda $7a
        sta ZP_POLYOBJ_ZPOS_pt3
        eor # %10000000
        jsr _38f8
        lda $7a
        and # %10000000
        sta $bb
        eor $b5
        bmi _a5a8
        lda $77
        clc 
        adc $b2
        lda $78
        adc $b3
        sta ZP_POLYOBJ_YPOS_pt1
        lda $79
        adc $b4
        sta ZP_POLYOBJ_YPOS_pt2
        lda $7a
        adc $b5
        jmp _a5db

_a5a8:
        lda $77
        sec 
        sbc $b2
        lda $78
        sbc $b3
        sta ZP_POLYOBJ_YPOS_pt1
        lda $79
        sbc $b4
        sta ZP_POLYOBJ_YPOS_pt2
        lda $b5
        and # %01111111
        sta $2e
        lda $7a
        and # %01111111
        sbc $2e
        sta $2e
        bcs _a5db
        lda # $01
        sbc ZP_POLYOBJ_YPOS_pt1
        sta ZP_POLYOBJ_YPOS_pt1
        lda # $00
        sbc ZP_POLYOBJ_YPOS_pt2
        sta ZP_POLYOBJ_YPOS_pt2
        lda # $00
        sbc $2e
        ora # %10000000
_a5db:
        eor $bb
        sta ZP_POLYOBJ_YPOS_pt3
        lda $a6
        sta $9a
        lda ZP_POLYOBJ_YPOS_pt1
        sta $2e
        lda ZP_POLYOBJ_YPOS_pt2
        sta $2f
        lda ZP_POLYOBJ_YPOS_pt3
        jsr _38f8
        ldx # $00
        jsr _2d69
        lda $78
        sta ZP_POLYOBJ_XPOS_pt1
        lda $79
        sta ZP_POLYOBJ_XPOS_pt2
        lda $7a
        sta ZP_POLYOBJ_XPOS_pt3
        jmp _a3bf

;===============================================================================

; what calls in to this, where?

_a604:
        sec 
        ldy # $00
        sty $5b
        ldx # $10
        lda [$07], y
        txa 
_a60e:
        stx $5c
        sty $bb
        adc [$5b], y
        eor $bb
        sbc $5c
        dey 
        bne _a60e
        inx 
        cpx # $a0
        bcc _a60e
        cmp _1d21
        bne _a604
        rts 

;===============================================================================

_a626:
.export _a626
        ldx $0486
        beq _a65e
        dex 
        bne _a65f
        lda ZP_POLYOBJ_XPOS_pt3
        eor # %10000000
        sta ZP_POLYOBJ_XPOS_pt3
        lda ZP_POLYOBJ_ZPOS_pt3
        eor # %10000000
        sta ZP_POLYOBJ_ZPOS_pt3
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
_a65e:
        rts 

        ;-----------------------------------------------------------------------

_a65f:
        lda # $00
        cpx # $02
        ror 
        sta $b1
        eor # %10000000
        sta $b0
        lda ZP_POLYOBJ_XPOS_pt1
        ldx ZP_POLYOBJ_ZPOS_pt1
        sta ZP_POLYOBJ_ZPOS_pt1
        stx ZP_POLYOBJ_XPOS_pt1
        lda ZP_POLYOBJ_XPOS_pt2
        ldx ZP_POLYOBJ_ZPOS_pt2
        sta ZP_POLYOBJ_ZPOS_pt2
        stx ZP_POLYOBJ_XPOS_pt2
        lda ZP_POLYOBJ_XPOS_pt3
        eor $b0
        tax 
        lda ZP_POLYOBJ_ZPOS_pt3
        eor $b1
        sta ZP_POLYOBJ_XPOS_pt3
        stx ZP_POLYOBJ_ZPOS_pt3
        ldy # $09
        jsr _a693
        ldy # $0f
        jsr _a693
        ldy # $15
_a693:
        lda $0009, y
        ldx ZP_POLYOBJ_YPOS_pt2, y
        sta $000d, y
        stx ZP_POLYOBJ_XPOS_pt1, y
        lda $000a, y
        eor $b0
        tax 
        lda $000e, y
        eor $b1
        sta $000a, y
        stx ZP_POLYOBJ_YPOS_pt3, y
_a6ad:
        rts 

;===============================================================================

_a6ae:
        stx $0486
        jsr _a72f
        jsr _a6d4
        jmp _7af3

;===============================================================================

_a6ba:
        lda # $00
        jsr _6a2e

        ldy $a0
        bne _a6ae
        
        cpx $0486
        beq _a6ad
        stx $0486
        
        jsr _a72f
        jsr dust_swap_xy
        jsr _7b1a
_a6d4:
        lda # MEM_IO_ONLY
        jsr set_memory_layout

        ldy $0486
        lda PLAYER_LASERS, y
        beq _a700
        ldy # $a0
        cmp # $0f
        beq _a6f2
        iny 
        cmp # $8f
        beq _a6f2
        iny 
        cmp # $97
        beq _a6f2
        iny 
_a6f2:
        sty $63f8               ;?
        sty $67f8               ;?
        lda _3e08, y            ;!?
        sta $d027               ;sprite 0 color? (or ship model table)
        lda # $01
_a700:
        sta $bb
        lda PLAYER_TRUMBLES_HI
        and # %01111111
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda _a71f, x
        sta $0510
        lda _a727, x
        ora $bb
        sta VIC_SPRITE_ENABLE

        lda # MEM_64K
        jmp set_memory_layout

;===============================================================================

_a71f:
        .byte   $00, $01, $02, $03, $04, $05, $06, $06
_a727:
        .byte   $00, $04, $0c, $1c, $3c, $7c, $fc, $fc

;===============================================================================

_a72f:
.export _a72f
        sta $a0
_a731:
        jsr txt_docked_token02
        lda # $00
        sta $7e
        
        lda # %10000000
        sta $34
        sta txt_lcase_flag

        jsr _7b4f
        lda # $00
        sta $0484
        sta $048b
        sta $048c
        
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        jsr _b21a               ; clear screen -- called only here
        
        ldx $66                 ; hyperspace countdown (outer)?
        beq _a75d
        jsr _7224
_a75d:
        lda # 1
        jsr set_cursor_row
        
        lda $a0
        bne _a77b
        
        lda # 11
        jsr set_cursor_col

        lda $0486
        ora # %01100000
        jsr print_flight_token
        jsr _72c5

.import TXT_VIEW:direct
        lda # TXT_VIEW
        jsr print_flight_token
_a77b:
        ldx # 1
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW

        dex 
        stx $34
        rts 

;===============================================================================

_a785:
        rts 

_a786:
.export _a786
        lda # $00
        sta $67
        sta $0481
        jsr _b0fd
        ldy # $09
        jmp _a822

;===============================================================================

_a795:
.export _a795
        ldx # $01
        jsr _3708
        bcc _a785
        lda # $78
        jsr _900d
        ldy # $04
        jmp _a858

;===============================================================================

_a7a6:
.export _a7a6
        lda $04cb
        clc 
        adc $d062, x
        sta $04cb
        lda $04e0
        adc $d083, x
        sta $04e0
        bcc _a7c3

        inc PLAYER_KILLS
        
        lda # $65                 ; hyperspace countdown (inner)?
        jsr _900d
_a7c3:
        lda ZP_POLYOBJ_ZPOS_pt2
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
_a7db:
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

_a7e9:
.export _a7e9
        lda ZP_POLYOBJ_ZPOS_pt2
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
_a801:
        txa 
        asl 
        asl 
        asl 
        asl 
        ora # %00000011
        ldy # $02
        ldx # $d0
        jmp _a850


_a80f:
;===============================================================================
.export _a80f
        ldy # $05
        bne _a858               ; always branches

_a813:
;===============================================================================
.export _a813
        ldy # $03
        bne _a858               ; always branches

_a817:
;===============================================================================
        ldy # $03
        lda # $01
_a81b:
        sta _aa15, y
        dey 
        bne _a81b
_a821:
        rts 

;===============================================================================

_a822:
        ldx # $03
        iny 
        sty $6d
_a827:
        dex 
        bmi _a821
        lda _aa13, x
        and # %00111111
        cmp $6d
        bne _a827
        lda # $01
        sta _aa16, x
        rts 


_a839:                                                                  ;$A839
;===============================================================================
.export _a839
        ldy # $07
        lda # $f5
        ldx # $f0
        jsr _a850

        ldy # $04
        jsr _a858

        ; wait until the next frame:
        ;SPEED: could just call `wait_for_frame` instead
        ldy # 1
        jsr wait_frames

        ldy # $87
        bne _a858               ; awlays branches

_a850:
        ;-----------------------------------------------------------------------
        bit _a821

        sta VAR_X
        stx VAR_Y
        ; this causes the `clv` below to become a `branch on overflow clear`
        ; to $A811 -- the address is defined by the opcode of `clv` ($B8)
        .byte   $50

_a858:
.export _a858
        clv 
        
        lda _1d05
        bne _a821
        ldx # $02
        iny 
        sty $6d
        dey 
        lda _aa32, y
        lsr 
        bcs _a876
_a86a:
        lda _aa13, x
        and # %00111111
        cmp $6d
        beq _a88b
        dex 
        bpl _a86a
_a876:
        ldx # $00
        lda _aa19
        cmp _aa1a
        bcc _a884
        inx 
        lda _aa1a
_a884:
        cmp _aa1b
        bcc _a88b
        ldx # $02
_a88b:
        tya 
        and # %01111111
        tay 
        lda _aa32, y
        cmp _aa19, x
        bcc _a821
        sei 
        sta _aa19, x
        bvs _a8a0+1
        lda _aa82, y
_a8a0:
       .cmp
        lda VAR_X
        sta _aa29, x
        lda _aa42, y
        sta _aa16, x
        lda _aa92, y
        sta _aa1d, x
        lda _aa62, y
        sta _aa23, x
        bvs _a8bd+1
        lda _aa52, y
_a8bd:
       .cmp
        lda VAR_Y
        sta _aa20, x
        lda _aa72, y
        sta _aa26, x
        lda _aaa2, y
        sta _aa2c, x
        iny 
        tya 
        ora # %10000000
        sta _aa13, x
        cli 
        sec 
        rts 

;===============================================================================

_a8d9:
        .byte   $00
_a8da:
        .byte   $81
_a8db:
        .byte   $81
_a8dc:
        .byte   $01, $00
_a8de:
        .byte   $c2, $33
_a8e0:
.export _a8e0
        .byte   $c0
_a8e1:
        .byte   $c0
_a8e2:
        .byte   $fe, $fc
_a8e4:
        .byte   $02, $00
_a8e6:
.export _a8e6
        .byte   $00, $00

;===============================================================================

_a8e8:
        dey 
        bpl _a958
        pla 
        tay 
_a8ed:
        pla 
        tax 

        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
        sta CPU_CONTROL
        
        pla 
        rti 

        ;-----------------------------------------------------------------------

_a8fa:
        pha 
        
        lda CPU_CONTROL
        and # %11111000
        ora # MEM_IO_ONLY
        sta CPU_CONTROL

        lda VIC_INTERRUPT_STATUS
        ora # %10000000
        sta VIC_INTERRUPT_STATUS
        
       .phx                     ; push X to stack (via A)
        
        ldx _a8d9

        lda _a8da, x
        sta VIC_MEMORY          ;=$d018, VIC-II memory control register

        lda _a8e0, x
        sta $d016               ;vic control register 2

        lda _a8de, x
        sta $d012               ;raster position
        
        lda _a8e2, x
        sta VIC_SPRITE_MULTICOLOR
        
        lda _a8e4, x
        sta $d028               ;sprite 1 color
        
        bit $04c3
        bpl :+
        inc _a8e6
:       lda _a8e6, x                                                    ;$A936
        sta VIC_BACKGROUND

        lda _a8dc, x
        sta _a8d9
        bne _a8ed
       .phy                     ; push Y to stack (via A)
        bit _1d03
        bpl _a956
        jsr _b4d2
        bit _1d12
        bmi _a956
        jmp _aa04

        ;-----------------------------------------------------------------------

_a956:
        ldy # $02
_a958:
        lda _aa13, y
        beq _a8e8
        bmi _a969
        ldx _aa2f, y
        lda _aa1d, y
        beq _a9ae
        bne _a990
_a969:
        lda _aa2f, y
        sta _a973+1             ;low-byte, i.e. $d4xx
        lda # $00
        ldx # $06
_a973:
        sta $d400, x            ;voice 1: frequency control - low-byte
        dex 
        bpl _a973
        ldx _aa2f, y
        lda _aa23, y
        sta $d404, x            ;voice 1: control register
        lda _aa26, y
        sta $d405, x            ;voice 1: attack / decay cycle control
        lda _aa29, y
        sta $d406, x            ;voice 1: sustain / release cycle control
        lda # $00
_a990:
        clc 
        cld 
        adc _aa20, y
        sta _aa20, y
        pha 
        lsr 
        lsr 
        sta $d401, x            ;voice 1: frequency control - high-byte
        pla 
        asl 
        asl 
        asl 
        asl 
        asl 
        asl 
        sta $d400, x            ;voice 1: frequency control - low-byte
        lda _aa1c
        sta $d403, x            ;voice 1: pulse waveform width - high-nybble
_a9ae:
        lda _aa13, y
        bmi _a9f1
        tya 
        tax 
        dec _aa19, x
        bne _a9bd
        inc _aa19, x
_a9bd:
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
        sta $d406, x            ;voice 1: sustain / release cycle control
        jmp _a9f6

_a9dc:
        ldx _aa2f, y
        lda _aa23, y
        and # %11111110
        sta $d404, x            ;voice 1: control register
        lda # $00
        sta _aa13, y
        sta _aa19, y
        beq _a9f6
_a9f1:
        and # %01111111
        sta _aa13, y
_a9f6:
        dey 
        bmi _a9fc
        jmp _a958

_a9fc:
        lda _aa1c
        eor # %00000100
        sta _aa1c
_aa04:
        pla 
        tay 
        pla 
        tax 

        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
        sta CPU_CONTROL

        pla 
        rti 

;===============================================================================

_aa13:
        .byte   $00, $00
_aa15:
        .byte   $00
_aa16:
        .byte   $00, $00, $00
_aa19:
        .byte   $00
_aa1a:
        .byte   $00
_aa1b:
        .byte   $00
_aa1c:
        .byte   $02
_aa1d:
        .byte   $00, $00, $00
_aa20:
        .byte   $00, $00, $00
_aa23:
        .byte   $00, $00, $00
_aa26:
        .byte   $00, $00, $00
_aa29:
        .byte   $00, $00, $00
_aa2c:
        .byte   $00, $00, $00
_aa2f:
        .byte   $00, $07, $0e
_aa32:
        .byte   $72, $70, $74, $77, $73, $68, $60, $f0
        .byte   $30, $fe, $72, $72, $92, $e1, $51, $02
_aa42:
        .byte   $14, $0e, $0c, $50, $3f, $05, $18, $80
        .byte   $30, $ff, $10, $10, $70, $40, $0f, $0e
_aa52:
        .byte   $45, $48, $d0, $51, $40, $f0, $40, $80
        .byte   $10, $50, $34, $33, $60, $55, $80, $40
_aa62:
        .byte   $41, $11, $81, $81, $81, $11, $11, $41
        .byte   $21, $41, $21, $21, $11, $81, $11, $21
_aa72:
        .byte   $01, $09, $20, $08, $0c, $00, $63, $18
        .byte   $44, $11, $00, $00, $44, $11, $18, $09
_aa82:
        .byte   $d1, $f1, $e5, $fb, $dc, $f0, $f3, $d8
        .byte   $00, $e1, $e1, $f1, $f4, $e3, $b0, $a1
_aa92:
        .byte   $fe, $fe, $f3, $ff, $00, $00, $00, $44
        .byte   $00, $55, $fe, $ff, $ef, $77, $7b, $fe
_aaa2:
        .byte   $03, $03, $03, $0f, $0f, $ff, $ff, $1f
        .byte   $ff, $ff, $03, $03, $0f, $ff, $ff, $03


; CALL FROM LOADER; this is the first thing called after initialisation

.export _aab2
.proc   _aab2                                                           ;$AAB2
        ;=======================================================================
        
        ; erase $0400..$0700
        lda #> $0400
        sta $08
        ldx # $03               ; number of pages; 3 x 256 = 768 bytes
        lda #< $0400            ; address must be page aligned for A to be $00 
        sta $07
        tay                     ; =0

:       sta [$07], y                                                    ;$AABD
        iny 
        bne :-

        inc $08                 ; move to the next page
        dex 
        bne :-

        ;-----------------------------------------------------------------------

        ; set non-maskable interrupt location

        lda #< nmi_null
        sta $0318
        lda #> nmi_null
        sta $0319
        
        ; set new KERNAL_CHROUT (print character) routine
        ; -- re-route printing to the bitmap screen

        lda #< chrout
        sta $0326
        lda #> chrout
        sta $0327

        ;-----------------------------------------------------------------------

        ; change the C64's memory layout, turn off the BASIC & KERNAL ROMs
        ; leaving just the I/O registers ($D000...)
        lda # MEM_IO_ONLY
        jsr set_memory_layout

        sei 

        ; enable interrupts (regular and non-interruptable) for system
        ; timers A & B. do not use the TimeOfDay timer
        lda # TIMER_A | TIMER_B
        sta CIA1_INTERRUPT
        sta CIA2_INTERRUPT
        
        lda # $0f
        sta $d418               ;select filter mode and volume
        
        ldx # $00
        stx _a8d9

        ; set the flag for raster interrupts, but note that with CIA1 & 2
        ; interrupts currently enabled, the raster interrupt won't fire
        inx 
        stx VIC_INTERRUPT_CONTROL
        
        lda $d011               ;vic control register 1
        and # %01111111
        sta $d011               ;vic control register 1
        
        ; set the interrupt to occur at line 40 (and 296?)
        lda # 40
        sta $d012               ;raster position
        
        lda CPU_CONTROL
        and # %11111000
        ora # MEM_64K
        sta CPU_CONTROL
        
        ; record this as the game's
        ; current memory-layout state
        lda # MEM_64K
        sta current_memory_layout
        
        ; set up the routines for the interrupts:
        ; NOTE: with the KERNAL ROM off, the hardware vectors at $FFFA...$FFFF
        ;       are now being defined by empty RAM -- we need to set something
        ;       there to prevent crashes when KERNAL ROM is off 

        ; non-maskable interrupt:
        lda #< nmi_null
        sta VECTOR_NMI+0
        lda #> nmi_null
        sta VECTOR_NMI+1

        ; regular interrupt:
        lda #>_a8fa
        sta VECTOR_IRQ+1
        lda #<_a8fa
        sta VECTOR_IRQ+0
        
        cli 
        rts 
.endproc

.proc   nmi_null                                                        ;$AB27
        ;=======================================================================
        ; a Non-Maskable-Interrupt that does nothing; used to disable the
        ; RESTORE key and to prevent crashes when the KERNAL ROM is off

        cli                     ; re-enable interrupts
        rti                     ; "ReTurn from Interrupt"
.endproc

;===============================================================================

; unused / unreferenced?
; $ab29:
        lda # $ff
        sta $32
        rts 

;===============================================================================

; unused / unreferenced?
; $ab2e:
        sta $32
        rts 

;===============================================================================

_ab31:
        .byte   %10000000
        .byte   %01000000
        .byte   %00100000
        .byte   %00010000
        .byte   %00001000
        .byte   %00000100
        .byte   %00000010
        .byte   %00000001

        .byte   %10000000
        .byte   %01000000

        .byte   %11000000
        .byte   %00110000
        .byte   %00001100
        .byte   %00000011
        .byte   %11000000

        .byte   %11000000
        .byte   %01100000
        .byte   %00110000
        .byte   %00011000
        .byte   %00001100
        .byte   %00000110
        .byte   %00000011

_ab47:
        .byte   $c0, $c0
_ab49:
        .byte   $30, $30, $0c, $0c, $03, $03, $c0, $c0
_ab51:
        .byte   $60, $83, $a6, $c9, $ec, $0f, $32, $55
_ab59:
        .byte   $ac, $ac, $ac, $ac, $ac, $ad, $ad, $ad
_ab61:
        .byte   $66, $89, $ac, $cf, $f2, $15, $38, $5b
_ab69:
        .byte   $ac, $ac, $ac, $ac, $ac, $ad, $ad, $ad
_ab71:
        .byte   $e0, $03, $26, $49, $6c, $8f, $b2, $d5
_ab79:
        .byte   $ad, $ae, $ae, $ae, $ae, $ae, $ae, $ae
_ab81:
        .byte   $e6, $09, $2c, $4f, $72, $95, $b8, $db
_ab89:
        .byte   $ad, $ae, $ae, $ae, $ae, $ae, $ae, $ae

;===============================================================================

_ab91:
.export _ab91
        sty $9e
        lda # $80
        sta $bf
        asl 
        sta $06f4
        lda $6d
        sbc VAR_X
        bcs _aba5
        eor # %11111111
        adc # $01
_aba5:
        sta $bc
        sec 
        lda $6e
        sbc VAR_Y
        bcs _abb2
        eor # %11111111
        adc # $01
_abb2:
        sta $bd
        cmp $bc
        bcc _abbb
        jmp _af08

_abbb:
        ldx VAR_X
        cpx $6d
        bcc _abd3
        dec $06f4
        lda $6d
        sta VAR_X
        stx $6d
        tax 
        lda $6e
        ldy VAR_Y
        sta VAR_Y
        sty $6e
_abd3:
        ldx $bd
        beq _abf9
        lda _9400, x
        ldx $bc
        sec 
        sbc _9400, x
        bmi _abfd
        ldx $bd
        lda _9300, x
        ldx $bc
        sbc _9300, x
        bcs _abf5
        tax 
        lda _9500, x
        jmp _ac0d

_abf5:
        lda # $ff
        bne _ac0d
_abf9:
        lda # $00
        beq _ac0d
_abfd:
        ldx $bd
        lda _9300, x
        ldx $bc
        sbc _9300, x
        bcs _abf5
        tax 
        lda _9600, x
_ac0d:
        sta $bd
        clc 
        ldy VAR_Y
        cpy $6e
        bcs _ac19
        jmp _ad8b

        ;-----------------------------------------------------------------------

_ac19:
        lda VAR_X
        and # %11111000
        clc 
        adc row_to_bitmap_lo, y
        sta $07
        lda row_to_bitmap_hi, y
        adc # $00
        sta $08
        tya 
        and # %00000111
        tay 
        lda VAR_X
        and # %00000111
        tax 
        bit $06f4
        bmi _ac49
        lda _ab51, x
        sta _ac46+1
        lda _ab59, x
        sta _ac46+2
        ldx $bc
_ac46:
        jmp _8888               ; is this address ever actually used?

_ac49:
        lda _ab61, x
        sta _ac5a+1
        lda _ab69, x
        sta _ac5a+2
        ldx $bc
        inx 
        beq _ac5d
_ac5a:
        jmp _8888               ; is this address ever actually used?

_ac5d:
        ldy $9e
        rts 

;===============================================================================

_ac60:
        lda # %10000000
        eor [$07], y
        sta [$07], y
        dex 
        beq _ac5d
        lda $bf
        adc $bd
        sta $bf
        bcc _ac83
        dey 
        bpl _ac82
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_ac82:
        clc 
_ac83:
        lda # $40
        eor [$07], y
        sta [$07], y
        dex 
        beq _ac5d
        lda $bf
        adc $bd
        sta $bf
        bcc _aca6
        dey 
        bpl _aca5
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_aca5:
        clc 
_aca6:
        lda # $20
        eor [$07], y
        sta [$07], y
        dex 
        beq _ac5d
        lda $bf
        adc $bd
        sta $bf
        bcc _acc9
        dey 
        bpl _acc8
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_acc8:
        clc 
_acc9:
        lda # $10
        eor [$07], y
        sta [$07], y
        dex 
        beq _ac5d
        lda $bf
        adc $bd
        sta $bf
        bcc _acec
        dey 
        bpl _aceb
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_aceb:
        clc 
_acec:
        lda # $08
        eor [$07], y
        sta [$07], y
        dex 
        beq _ad39
        lda $bf
        adc $bd
        sta $bf
        bcc _ad0f
        dey 
        bpl _ad0e
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_ad0e:
        clc 
_ad0f:
        lda # $04
        eor [$07], y
        sta [$07], y
        dex 
        beq _ad88
        lda $bf
        adc $bd
        sta $bf
        bcc _ad32
        dey 
        bpl _ad31
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_ad31:
        clc 
_ad32:
        lda # $02
        eor [$07], y
        sta [$07], y
        dex 
_ad39:
        beq _ad88
        lda $bf
        adc $bd
        sta $bf
        bcc _ad55
        dey 
        bpl _ad54
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_ad54:
        clc 
_ad55:
        lda # $01
        eor [$07], y
        sta [$07], y
        dex 
        beq _ad88
        lda $bf
        adc $bd
        sta $bf
        bcc _ad78
        dey 
        bpl _ad77
        lda $07
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_ad77:
        clc 
_ad78:
        lda $07
        adc # $08
        sta $07
        bcs _ad83
        jmp _ac60

        ;-----------------------------------------------------------------------

_ad83:
        inc $08
        jmp _ac60

        ;-----------------------------------------------------------------------

_ad88:
        ldy $9e
        rts 

;===============================================================================

_ad8b:
        lda row_to_bitmap_hi, y
        sta $08
        lda VAR_X
        and # %11111000
        adc row_to_bitmap_lo, y
        sta $07
        bcc _ad9e
        inc $08
        clc 
_ad9e:
        sbc # $f7
        sta $07
        bcs _ada6
        dec $08
_ada6:
        tya 
        and # %00000111
        eor # %11111000
        tay 
        lda VAR_X
        and # %00000111
        tax 
        bit $06f4
        bmi _adc9
        lda _ab71, x
        sta _adc6+1
        lda _ab79, x
        sta _adc6+2
        ldx $bc
        beq _ad88
_adc6:
        jmp _8888

        ;-----------------------------------------------------------------------

_adc9:
        lda _ab81, x
        sta _adda+1
        lda _ab89, x
        sta _adda+2
        ldx $bc
        inx 
        beq _ad88
_adda:
        jmp _8888

;===============================================================================

_addd:
        ldy $9e
        rts 

        ;-----------------------------------------------------------------------

_ade0:
        lda # $80
        eor [$07], y
        sta [$07], y
        dex 
        beq _addd
        lda $bf
        adc $bd
        sta $bf
        bcc _ae03
        iny 
        bne _ae02
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_ae02:
        clc 
_ae03:
        lda # $40
        eor [$07], y
        sta [$07], y
        dex 
        beq _addd
        lda $bf
        adc $bd
        sta $bf
        bcc _ae26
        iny 
        bne _ae25
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_ae25:
        clc 
_ae26:
        lda # $20
        eor [$07], y
        sta [$07], y
        dex 
        beq _addd
        lda $bf
        adc $bd
        sta $bf
        bcc _ae49
        iny 
        bne _ae48
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_ae48:
        clc 
_ae49:
        lda # $10
        eor [$07], y
        sta [$07], y
        dex 
        beq _aeb9
        lda $bf
        adc $bd
        sta $bf
        bcc _ae6c
        iny 
        bne _ae6b
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_ae6b:
        clc 
_ae6c:
        lda # $08
        eor [$07], y
        sta [$07], y
        dex 
        beq _aeb9
        lda $bf
        adc $bd
        sta $bf
        bcc _ae8f
        iny 
        bne _ae8e
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_ae8e:
        clc 
_ae8f:
        lda # $04
        eor [$07], y
        sta [$07], y
        dex 
        beq _af05
        lda $bf
        adc $bd
        sta $bf
        bcc _aeb2
        iny 
        bne _aeb1
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_aeb1:
        clc 
_aeb2:
        lda # $02
        eor [$07], y
        sta [$07], y
        dex 
_aeb9:
        beq _af05
        lda $bf
        adc $bd
        sta $bf
        bcc _aed5
        iny 
        bne _aed4
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_aed4:
        clc 
_aed5:
        lda # $01
        eor [$07], y
        sta [$07], y
        dex 
        beq _af05
        lda $bf
        adc $bd
        sta $bf
        bcc _aef8
        iny 
        bne _aef7
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        ldy # $f8
_aef7:
        clc 
_aef8:
        lda $07
        adc # $08
        sta $07
        bcc _af02
        inc $08
_af02:
        jmp _ade0

        ;-----------------------------------------------------------------------

_af05:
        ldy $9e
        rts 

;===============================================================================

_af08:
        ldy VAR_Y
        tya 
        ldx VAR_X
        cpy $6e
        bcs _af22
        dec $06f4
        lda $6d
        sta VAR_X
        stx $6d
        tax 
        lda $6e
        sta VAR_Y
        sty $6e
        tay 
_af22:
        txa 
        and # %11111000
        clc 
        adc row_to_bitmap_lo, y
        sta $07
        lda row_to_bitmap_hi, y
        adc # $00
        sta $08
        tya 
        and # %00000111
        tay 
        txa 
        and # %00000111
        tax 
        lda _ab31, x
        sta $be
        ldx $bc
        beq _af77
        lda _9400, x
        ldx $bd
        sec 
        sbc _9400, x
        bmi _af65
        ldx $bc
        lda _9300, x
        ldx $bd
        sbc _9300, x
        bcs _af61
        tax 
        lda _9500, x
        jmp _af75

_af61:
        lda # $ff
        bne _af75
_af65:
        ldx $bc
        lda _9300, x
        ldx $bd
        sbc _9300, x
        bcs _af61
        tax 
        lda _9600, x
_af75:
        sta $bc
_af77:
        sec 
        ldx $bd
        inx 
        lda $6d
        sbc VAR_X
        bcc _afbe
        clc 
        lda $06f4
        beq _af8e
        dex 
_af88:
        lda $be
        eor [$07], y
        sta [$07], y
_af8e:
        dey 
        bpl _af9f
        lda $07
        sbc # $3f
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_af9f:
        lda $bf
        adc $bc
        sta $bf
        bcc _afb8
        lsr $be
        bcc _afb8
        ror $be
        lda $07
        adc # $08
        sta $07
        bcc _afb8
        inc $08
        clc 
_afb8:
        dex 
        bne _af88
        ldy $9e
        rts 

        ;-----------------------------------------------------------------------

_afbe:
        lda $06f4
        beq _afca
        dex 
_afc4:
        lda $be
        eor [$07], y
        sta [$07], y
_afca:
        dey 
        bpl _afdb
        lda $07
        sbc # $3f
        sta $07
        lda $08
        sbc # $01
        sta $08
        ldy # $07
_afdb:
        lda $bf
        adc $bc
        sta $bf
        bcc _aff4
        asl $be
        bcc _aff4
        rol $be
        lda $07
        sbc # $07
        sta $07
        bcs _aff3
        dec $08
_aff3:
        clc 
_aff4:
        dex 
        bne _afc4
        ldy $9e
_aff9:
        rts 

;===============================================================================

_affa:
.export _affa
        sty $9e
        ldx VAR_X
        cpx $6d
        beq _aff9
        bcc _b00b
        lda $6d
        sta VAR_X
        stx $6d
        tax 
_b00b:
        dec $6d
        lda VAR_Y
        tay 
        and # %00000111
        sta $07
        lda row_to_bitmap_hi, y
        sta $08
        txa 
        and # %11111000
        clc 
        adc row_to_bitmap_lo, y
        tay 
        bcc _b025
        inc $08
_b025:
        txa 
        and # %11111000
        sta $c0
        lda $6d
        and # %11111000
        sec 
        sbc $c0
        beq _b073
        lsr 
        lsr 
        lsr 
        sta $be
        lda VAR_X
        and # %00000111
        tax 
        lda _2907, x
        eor [$07], y
        sta [$07], y
        tya 
        adc # $08
        tay 
        bcc _b04c
        inc $08
_b04c:
        ldx $be
        dex 
        beq _b064
        clc 
_b052:
        lda # $ff
        eor [$07], y
        sta [$07], y
        tya 
        adc # $08
        tay 
        bcc _b061
        inc $08
        clc 
_b061:
        dex 
        bne _b052
_b064:
        lda $6d
        and # %00000111
        tax 
        lda _2900, x
        eor [$07], y
        sta [$07], y
        ldy $9e
        rts 

        ;-----------------------------------------------------------------------

_b073:
        lda VAR_X
        and # %00000111
        tax 
        lda _2907, x
        sta $c0
        lda $6d
        and # %00000111
        tax 
        lda _2900, x
        and $c0
        eor [$07], y
        sta [$07], y
        ldy $9e
        rts 

;===============================================================================

; unused / unreferenced?
;$b08e:
        .byte   %10000000
        .byte   %11000000
        .byte   %11100000
        .byte   %11110000
        .byte   %11111000
        .byte   %11111100
        .byte   %11111110
        .byte   %11111111

        .byte   %01111111
        .byte   %00111111
        .byte   %00011111
        .byte   %00001111
        .byte   %00000111
        .byte   %00000011
        .byte   %00000001

;===============================================================================

_b09d:
        lda $04eb
        sta VAR_Y
        lda $04ea
        sta VAR_X
        lda _1d01
        sta $32
        cmp # $aa
        bne _b0b5
_b0b0:
        jsr _b0b5
        dec VAR_Y
_b0b5:
        ldy VAR_Y
        lda VAR_X
        and # %11111000
        clc 
        adc row_to_bitmap_lo, y
        sta $07
        lda row_to_bitmap_hi, y
        adc # $00
        sta $08
        tya 
        and # %00000111
        tay 
        lda VAR_X
        and # %00000111
        tax 
        lda _ab47, x
        and $32
        eor [$07], y
        sta [$07], y
        lda _ab49, x
        bpl _b0ed
        lda $07
        clc 
        adc # $08
        sta $07
        bcc _b0ea
        inc $08
_b0ea:
        lda _ab49, x
_b0ed:
        and $32
        eor [$07], y
        sta [$07], y
        rts 

;===============================================================================

_b0f4:
.export _b0f4
        lda # $20
        sta $67
        ldy # $09
        jsr _a858
_b0fd:
        lda $67a3               ;?
        eor # %11100000
        sta $67a3               ;?
        lda $67cb
        eor # %11100000
        sta $67cb
        rts 

;===============================================================================

_b10e:
        lda $67b4
        eor # %11100000
        sta $67b4
        lda $67dc
        eor # %11100000
        sta $67dc
        rts 

;===============================================================================

_b11f:
.export _b11f
        dex 
        txa 
        inx 
        eor # %00000011
        sty $07
        tay 
        lda $07
        sta $67c6, y
        ldy # $00
        rts 

;===============================================================================

; unused / unreferenced?
;$b12f:
        jsr $ffff               ;irq
        cmp # $80
        bcc _b13a
_b136:
        lda # $07
        clc 
        rts 
        
        ;-----------------------------------------------------------------------

_b13a:
        cmp # $20
        bcs _b146
        cmp # $0d
        beq _b146
        cmp # $15
        bne _b136
_b146:
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

        ; and then wait for it to return to zero?
        beq :-
:       lda _a8d9                                                       ;$B14E
        bne :-

        pla                     ; restore A 
        rts 


.proc   chrout                                                          ;$B155
        ;=======================================================================
        ; replaces the KERNAL's `CHROUT` routine for printing text to screen
        ; (since Elite uses only the bitmap screen)
        ;
        ; IMPORTANT NOTE: Elite stores its text in ASCII, not PETSCII!
        ; this is due to the data being copied over as-is from the BBC
        ;
        ; A = ASCII code of character to print

        cmp # $7b               ; is code greater than or equal to $7B?
        bcs :+                  ; if yes, skip it
        cmp # $0d               ; is code less than $0D? (RETURN)
        bcc :+                  ; if yes, skip it
        bne paint_char          ; if it's not RETURN, process it

        ; handle the RETURN code
        lda # $0c
        jsr paint_char
        lda # $0d

:       clc                     ; clear carry flag before returning     ;$B166 
        rts 
.endproc

;define the use of some zero-page variables for this routine
.exportzp       ZP_CHROUT_CHARADDR      := $2f  ; $2F/$30
.exportzp       ZP_CHROUT_DRAWADDR      := $07  ; $07/$08
.exportzp       ZP_CHROUT_DRAWADDR_LO   := $07
.exportzp       ZP_CHROUT_DRAWADDR_HI   := $08

_b168:
        jsr _a80f               ; BEEP?
        jmp _b210               ; restore state and exit

        ;-----------------------------------------------------------------------

_b16e:
        jsr _b384
        lda $35
        jmp _b189

        ;-----------------------------------------------------------------------

_b176:  ; this is a trampoline to account for a branch range limitation below
        ; TODO: this could be combined with the one at `_b168` to save 3 bytes
        jmp _b210

        ;-----------------------------------------------------------------------

_b179:  ; NOTE: called only ever by `_2c7d`!
.export _b179
        lda # $0c

paint_char:                                                             ;$B17B
;===============================================================================
; draws a character on the bitmap screen as if it were the text screen
; (automatically advances the cursor)
;
.export paint_char

        ; store current registers
        ; (compatibility with KERNAL_CHROUT?)
        sta $35
        sty $0490
        stx $048f

        ; cancel if text reaches a certain point?
        ; prevent off-screen writing?
        ldy $34
        cpy # $ff
        beq _b176
_b189:
        cmp # $07               ; code $07? (unspecified in PETSCII)
        beq _b168
        cmp # $20               ; is it SPC or above? (i.e. printable)
        bcs _b1a1
        cmp # $0a               ; is it $0A? (unspecified in PETSCII)
        beq _b199
_b195:
        ; start at column 2, i.e. leave a one-char padding from the viewport
        ldx # 1
        stx ZP_CURSOR_COL
_b199:
        cmp # $0d               ; is it RETURN? although note that `chrout`
                                ; replaces $0D codes with $0C
        beq _b176

        inc ZP_CURSOR_ROW
        bne _b176

_b1a1:
        ;-----------------------------------------------------------------------
        ; convert the PETSCII code to an address in the char gfx (font):
        ; note that the font is ASCII so a few characters appear different
        ; and font graphics are only provided for 96 characters, from space
        ; (32 / $20) onwards

        tay                     ; put aside the ASCII code
        
        ; at 8 bytes per character, each page (256 bytes) occupies 32 chars,
        ; so the initial part of this routine is concerned with finding what
        ; the high-address of the character will be

        ; Elite's font defines 96 characters (3 usable pages),
        ; consisting (roughly) of:
        ;
        ; page 0 = codes 0-31   : invalid, no font gfx here
        ; page 1 = codes 32-63  : most punctuation and numbers
        ; page 2 = codes 64-95  : "@", "A" to "Z", "[", "\", "]", "^", "_"
        ; page 3 = codes 96-127 : "£", "a" to "z", "{", "|", "}", "~"

        ; get the location of the font data in RAM
.import __DATA_FONT_RUN__:absolute

        ; default to 0th page since character codes begin from 0,
        ; but in practice we'll only see codes 32-128
        ldx # (>__DATA_FONT_RUN__) - 1
        
        ; if you shift any number twice to the left
        ; then numbers 64 or above will carry (> 255) 
        asl 
        asl 
        bcc :+                  ; no carry (char code was < 64),
                                ; char is in the 0th (unlikely) or 1st page

        ; -- char is in the 2rd or 3rd page
        ldx # (>__DATA_FONT_RUN__) + 1

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
.import ELITE_BITMAP_ADDR
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
        jsr _b3b5
        beq _b210

:       inc ZP_CURSOR_COL                                               ;$B1ED
        ; this is `sta $08` if you jump in after the `bit` instruction,
        ; but it doesn't look like this actually occurs
       .bit
        sta $08

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
        lda $050c               ; colour?
        sta [ZP_CHROUT_DRAWADDR], y

        ; exit and clean-up:
        ;-----------------------------------------------------------------------
_b210:  ; restore registers before returning
        ; (compatibility with KERNAL_CHROUT?)
        ldy $0490
        ldx $048f
        lda $35

        clc 
        rts 

;===============================================================================

; clear screen

_b21a:
        ; set starting position in top-left of the centred
        ; 32-char (256px) screen Elite uses
        lda #< (ELITE_MENUSCR_COLOR_ADDR + .scrpos( 0, 4 ))
        sta $07
        lda #> (ELITE_MENUSCR_COLOR_ADDR + .scrpos( 0, 4 ))
        sta $08

        ldx # 24                ; colour 24 rows

@row:   lda # .color_nybbles( WHITE, BLACK )                            ;$B224
        ldy # 31                ; 32 columns (0-31)

:       sta [$07], y                                                    ;$B228
        dey 
        bpl :-

        ; move to the next row
        lda $07                 ; get the row lo-address
        clc 
        adc # 40                ; add 40 chars (one screen row)
        sta $07
        bcc :+                  ; remains under 255?
        inc $08                 ; if not, increase the hi-address

:       dex                     ; decrement remaining row count         ;$B238
        bne @row

        ;-----------------------------------------------------------------------
        
        ; erase $4000..$5600
        ; (the non-HUD portion of the bitmap)

        ; TODO: this should be calculated based on the size of the HUD data?

        ldx # $40
:       jsr erase_page                                                  ;$B23D
        inx 
        cpx # $56
        bne :-

        ; erase $5600..$567F?
        ldy # $7f
        jsr erase_bytes
        sta [$07], y

        ;-----------------------------------------------------------------------

        ; set cursor position to row/col 2 on Elite's screen
        lda # 1
        sta ZP_CURSOR_COL
        sta ZP_CURSOR_ROW
        
        ;-----------------------------------------------------------------------

        ; mode?
        lda $a0
        beq :+
        cmp # $0d
        bne _b25d
:       jmp _b301                                                       ;$B25A

        ;-----------------------------------------------------------------------

_b25d:
        lda # $81               ; default value
        sta _a8db
        
        lda # $c0               ; default value
        sta _a8e1
_b267:
        jsr erase_page
        inx 
        cpx # $60
        bne _b267
        ldx # $00
        stx _1d01
        stx _1d04
        inx 
        stx ZP_CURSOR_COL
        stx ZP_CURSOR_ROW
        jsr _b359
        jsr _b341
        jsr disable_sprites
        ldy # $1f
        lda # $70
_b289:
        sta $6004, y
        dey 
        bpl _b289
        ldx $a0
        cpx # $02
        beq _b2a5
        cpx # $40
        beq _b2a5
        cpx # $80
        beq _b2a5
        ldy # $1f
_b29f:
        sta $6054, y
        dey 
        bpl _b29f
_b2a5:
        ldx # $c7
        jsr _b2d5
        lda # $ff
        sta $5f1f
        ldx # $19
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit
_b2b2:
        ldx # $12
        stx $c0
        ldy # $18
        sty $07
        ldy # $40
        lda # $03
        jsr _b2e1
        ldy # $20
        sty $07
        ldy # $41
        lda # $c0
        ldx $c0
        jsr _b2e1
        lda # $01
        sta $4118
        ldx # $00
_b2d5:
        stx VAR_Y
        ldx # $00
        stx VAR_X
        dex 
        stx $6d
        jmp _affa

;===============================================================================

_b2e1:
        sta $be
        sty $08
_b2e5:
        ldy # $07
_b2e7:
        lda $be
        eor [$07], y
        sta [$07], y
        dey 
        bpl _b2e7
        lda $07
        clc 
        adc # $40
        sta $07
        lda $08
        adc # $01
        sta $08
        dex 
        bne _b2e5
        rts 

;===============================================================================

_b301:
        jsr _b2b2
        
        lda # $91
        sta _a8db               ; default value is $81
        
        lda # $d0
        sta _a8e1               ; default value is $C0
        
        lda _1d04               ; is HUD visible? (main or menu screen?)
        bne _b335
        
        ; reset the HUD graphics from the copy kept in RAM
.import __DATA_HUD_RUN__

        ldx # $08
        lda #< __DATA_HUD_RUN__
        sta $5b
        lda #> __DATA_HUD_RUN__
        sta $5c
        lda #< $5680            ; start of the HUD on bitmap?
        sta $07
        lda #> $5680
        sta $08
        jsr _b3c3

        ldy # $c0
        ldx # $01
        jsr _b3c5
        jsr _b341
        jsr _2ff3

_b335:  jsr _b359
        jsr disable_sprites

        lda # $ff
        sta _1d04
        
        rts 

;===============================================================================

_b341:
        ldx # $00
_b343:
        lda $0452, x            ; ship slots?
        beq _b358
        bmi _b355

        jsr _3e87               ; get address of ship-slot
        
        ldy # $1f
        lda [$59], y
        and # %11101111
        sta [$59], y
_b355:
        inx 
        bne _b343
_b358:
        rts 

;===============================================================================

_b359:
        ldx # $00
        ldy # $40
        jsr _b364
        ldx #< $4128
        ldy #> $4128
_b364:
        stx $07
        sty $08
        ldx # $12
_b36a:
        ldy # $17
_b36c:
        lda # $ff
        sta [$07], y
        dey 
        bpl _b36c
        lda $07
        clc 
        adc # $40
        sta $07
        lda $08
        adc # $01
        sta $08
        dex 
        bne _b36a
        rts 

;===============================================================================

_b384:
        ldx # $08
        ldy # $00
        clc 
_b389:
        lda row_to_bitmap_lo, x
        sta $07
        lda row_to_bitmap_hi, x
        sta $08
        
        tya 

:       sta [$07], y                                                    ;$B394
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
        sty $07

erase_bytes:                                                            ;$B3AB
        ;-----------------------------------------------------------------------
        ; erase some bytes:
        ;
        ;     $07 = lo-address
        ;       X = hi-address
        ;       Y = offset
        ;
        lda # $00
        stx $08

:       sta [$07], y                                                    ;$B3AF
        dey 
        bne :-

        rts 

_b3b5:
        ;=======================================================================
        lda # $00
:       sta [$07], y                                                    ;$B3B7
        iny 
        bne :-

        rts 

;===============================================================================

; unreferenced / unused?
;$b3bd:
        sta ZP_CURSOR_COL
        rts 

;===============================================================================

_b3c0:
        sta ZP_CURSOR_ROW
        rts 

;===============================================================================

_b3c3:
        ldy # $00
_b3c5:
        lda [$5b], y
        sta [$07], y
        dey 
        bne _b3c5
        inc $5c
        inc $08
        dex 
        bne _b3c5
        rts 

txt_docked_token15:                                                     ;$B3D4
        ;=======================================================================
.export txt_docked_token15
        
        lda # $00
        sta $048b
        sta $048c

        lda # %11111111
        sta txt_lcase_flag
        
        lda #> _8015
        sta $34
        lda #< _8015
        sta ZP_CURSOR_ROW
        lda # 1
        sta ZP_CURSOR_COL
        lda #> $5a60
        sta $08
        lda #< $5a60
        sta $07
        ldx # $03
_b3f7:
        lda # $00
        tay 
_b3fa:
        sta [$07], y
        dey 
        bne _b3fa
        clc 
        lda $07
        adc # $40
        sta $07
        lda $08
        adc # $01
        sta $08
        dex 
        bne _b3f7
_b40f:
        rts 

;===============================================================================

_b410:
.export _b410
        lda $a0
        bne _b40f
        lda $28
        and # %00010000
        beq _b40f
        ldx $a5
        bmi _b40f
        lda _267e, x
        sta $32
        lda ZP_POLYOBJ_XPOS_pt2
        ora ZP_POLYOBJ_YPOS_pt2
        ora ZP_POLYOBJ_ZPOS_pt2
        and # %11000000
        bne _b40f
        lda ZP_POLYOBJ_XPOS_pt2
        clc 
        ldx ZP_POLYOBJ_XPOS_pt3
        bpl _b438
        eor # %11111111
        adc # $01
_b438:
        adc # $7b
        sta VAR_X
        lda ZP_POLYOBJ_ZPOS_pt2
        lsr 
        lsr 
        clc 
        ldx ZP_POLYOBJ_ZPOS_pt3
        bpl _b448
        eor # %11111111
        sec 
_b448:
        adc # $53
        eor # %11111111
        sta $07
        lda ZP_POLYOBJ_YPOS_pt2
        lsr 
        clc 
        ldx ZP_POLYOBJ_YPOS_pt3
        bmi _b459
        eor # %11111111
        sec 
_b459:
        adc $07
        cmp # $92
        bcs _b461
        lda # $92
_b461:
        cmp # $c7
        bcc _b467
        lda # $c6
_b467:
        sta VAR_Y
        sec 
        sbc $07
        php 
        pha 
        jsr _b0b0
        lda _ab49, x
        and $32
        sta VAR_X
        pla 
        plp 
        tax 
        beq _b49a
        bcc _b49b
_b47f:
        dey 
        bpl _b491
        ldy # $07
        lda $07
        sec 
        sbc # $40
        sta $07
        lda $08
        sbc # $01
        sta $08
_b491:
        lda VAR_X
        eor [$07], y
        sta [$07], y
        dex 
        bne _b47f
_b49a:
        rts 

        ;-----------------------------------------------------------------------

_b49b:
        iny 
        cpy # $08
        bne _b4ae
        ldy # $00
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
_b4ae:
        iny 
        cpy # $08
        bne _b4c1
        ldy # $00
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
_b4c1:
        lda VAR_X
        eor [$07], y
        sta [$07], y
        inx 
        bne _b4ae
        rts 

;===============================================================================

_b4cb:
        .byte   $00, $00
_b4cd:
        .byte   $00, $00
_b4cf:
        .byte   $00
_b4d0:
        .byte   $88
_b4d1:
        .byte   $88

;===============================================================================

_b4d2:
        ldy # $00
        cpy $c6
        beq _b4dd
        dec $c6
        jmp _b6e2

        ;-----------------------------------------------------------------------

_b4dd:
        lda $d1
        cmp # $10
        bcs _b4eb
        tax 
        bne _b4ee
        jsr _b60c
        sta $d1
_b4eb:
        and # %00001111
        tax 
_b4ee:
        lda $d1
        lsr 
        lsr 
        lsr 
        lsr 
        sta $d1
        lda _b70e, x
        sta _b502+1
        lda _b71d, x
        sta _b502+2
_b502:
        jmp _b4dd

;===============================================================================

;$b505:
        jsr _b615
        jsr _b5ee
        jmp _b4dd

;===============================================================================

;$b50e:
        jsr _b622
        jsr _b5f8
        jmp _b4dd

;===============================================================================

;$b517:
        jsr _b643
        jsr _b602
        jmp _b4dd

;===============================================================================

;$b520:
        jsr _b615
        jsr _b622
        jsr _b5ee
        jsr _b5f8
        jmp _b4dd

;===============================================================================

;$b52f:
        jsr _b615
        jsr _b622
        jsr _b643
        jsr _b5ee
        jsr _b5f8
        jsr _b602
        jmp _b4dd

;===============================================================================

;$b544:
        inc _b4cb+0
        jmp _b4dd

;===============================================================================

;$b54a:
        lda $d1
        sec 
        rol 
        asl 
        asl 
        asl 
        sta $d1
        lda _b4cf
        sta $c6
        jmp _b4d2

;===============================================================================

;$b55b
        jsr _b60c
        sta $d405               ;voice 1: attack / decay cycle control
        jsr _b60c
        sta $d40c               ;voice 2: attack / decay cycle control
        jsr _b60c
        sta $d413               ;voice 3: attack / decay cycle control
        jsr _b60c
        sta $d406               ;voice 1: sustain / release cycle control
        jsr _b60c
        sta $d40d               ;voice 2: sustain / release cycle control
        jsr _b60c
        sta $d414               ;voice 3: sustain / release cycle control
        
        jmp _b4dd

;===============================================================================

_b582:
        lda # $00
        sta $d1
        lda $c4
        sta $c2
        lda $c5
        sta $c3
        jmp _b4dd

;===============================================================================

;$b591:
        jsr _b60c
        sta $d402               ;voice 1: pulse waveform width - low-byte
        jsr _b60c
        sta $d403               ;voice 1: pulse waveform width - high-nybble
        jsr _b60c
        sta $d409               ;voice 2: pulse waveform width - low-byte
        jsr _b60c
        sta $d40a               ;voice 2: pulse waveform width - high-nybble
        jsr _b60c
        sta $d410               ;voice 3: pulse waveform width - low-byte
        jsr _b60c
        sta $d411               ;voice 3: pulse waveform width - high-nybble

        jmp _b4dd

;===============================================================================

;$b5b8
        jmp _b582

;===============================================================================

;$b5bb:
        jsr _b60c
        sta _b4cf
        jmp _b4dd

;===============================================================================

;$b5c4:
        jsr _b60c
        sta _b4cb+1
        jsr _b60c
        sta _b4cd+0
        jsr _b60c
        sta _b4cd+1
        jmp _b4dd

;===============================================================================

;$b5d9
        jsr _b60c
        sta $d418               ;select filter mode and volume
        jsr _b60c
        sta $d417               ;filter resonance control / voice input control
        jsr _b60c
        sta $d416               ;filter cutoff frequency: high-byte
        jmp _b4dd

;===============================================================================

_b5ee:
        lda _b4cb+1
        sty $d404               ;voice 1: control register
        sta $d404               ;voice 1: control register
        rts 

;===============================================================================

_b5f8:
        lda _b4cd+0
        sty $d40b               ;voice 2: control register
        sta $d40b               ;voice 2: control register
        rts 

;===============================================================================

_b602:
        lda _b4cd+1
        sty $d412               ;voice 3: control register
        sta $d412               ;voice 3: control register
        rts 

;===============================================================================

_b60c:
        inc $c2
        bne _b612
        inc $c3
_b612:
        lda [$c2], y
        rts 

;===============================================================================

_b615:
        jsr _b60c
        sta $d401               ;voice 1: frequency control - high-byte
        jsr _b60c
        sta $d400               ;voice 1: frequency control - low-byte
        rts 

;===============================================================================

_b622:
        jsr _b60c
        sta $d408               ;voice 2: frequency control - high-byte
        sta $c9
        sta $cb
        jsr _b60c
        sta $d407               ;voice 2: frequency control - low-byte
        sta $ca
        sta $cc
        clc 
        cld 
        lda # $20
        adc $cc
        sta $cc
        bcc _b642
        inc $cb
_b642:
        rts 

;===============================================================================

_b643:
        jsr _b60c
        sta $d40f               ;voice 3: frequency control - high-byte
        sta $cd
        sta $cf
        jsr _b60c
        sta $d40e               ;voice 3: frequency control - low-byte
        sta $ce
        sta $d0
        clc 
        cld 
        lda # $25
        adc $d0
        sta $d0
        bcc _b663
        inc $cf
_b663:
        rts 

;===============================================================================

_b664:
        lda # $00
        sta $d1
        sta $c6
        sta $c7
        sta $c8
        ldx # $18
_b670:
        sta $d400, x            ;voice 1: frequency control - low-byte
        dex 
        bne _b670
        lda _b4d0
        sta $c2
        sta $c4
        lda _b4d1
        sta $c3
        sta $c5
        lda # $0f
        sta $d418               ;select filter mode and volume
        rts 

;===============================================================================

;$b68a:
        lda # $00
        sta $c7
        lda # $ae
        sta _b6f0+1
        lda $cb
        sta $d408               ;voice 2: frequency control - high-byte
        lda $cc
        sta $d407               ;voice 2: frequency control - low-byte
        jmp _b6f2

;===============================================================================

_b6a0:
        lda # $00
        sta $c7
        lda # $98
        sta _b6f0+1
        lda $c9
        sta $d408               ;voice 2: frequency control - high-byte
        lda $ca
        sta $d407               ;voice 2: frequency control - low-byte
        jmp _b6f2

        ;-----------------------------------------------------------------------

;$b6b6:
        lda # $00
        sta $c8
        lda # $e2
        sta _b6e8+1
        lda $cf
        sta $d40f               ;voice 3: frequency control - high-byte
        lda $d0
        sta $d40e               ;voice 3: frequency control - low-byte
        jmp _b6f2

        ;-----------------------------------------------------------------------

_b6cc:
        lda # $00
        sta $c8
        lda # $cc
        sta _b6e8+1
        lda $cd
        sta $d40f               ;voice 3: frequency control - high-byte
        lda $ce
        sta $d40e               ;voice 3: frequency control - low-byte
        jmp _b6f2

        ;-----------------------------------------------------------------------
_b6e2:
        inc $c8
        lda # $05
        cmp $c8
_b6e8:
        beq _b6cc
        inc $c7
        lda # $04
        cmp $c7
_b6f0:
        beq _b6a0
_b6f2:
        ldx $c6
        cpx # $00
        bne _b70d
        ldx _b4cb+1
        dex 
        stx $d404               ;voice 1: control register
        ldx _b4cd+0
        dex 
        stx $d40b               ;voice 2: control register
        ldx _b4cd+1
        dex 
        stx $d412               ;voice 3: control register
_b70d:
        rts 

;===============================================================================

.segment        "DATA_B70E"

_b70e:                                                                  ;$b70e
        .byte   $60, $05, $0e, $17, $20, $2f, $44, $5b                  ;$b70e
        .byte   $53, $82, $91, $b8, $bb, $c4, $d9                       ;$b716
        
_b71d:
        .byte   $4a, $b5, $b5, $b5, $b5, $b5, $b5, $b5                  ;$b71d
        .byte   $b5, $b5, $b5, $b5, $b5, $b5, $b5, $b5                  ;$b725
        .byte   $a7, $26, $26, $48, $29, $29, $aa, $00                  ;$b72d
        .byte   $06, $00, $05, $00, $06, $ed, $21, $21                  ;$b735
        .byte   $41, $1f, $f4, $70, $5c, $07, $0e, $ef                  ;$b73d
        .byte   $12, $d1, $1d, $df, $5f, $0e, $ef, $12                  ;$b745
        .byte   $d1, $1d, $df, $38, $1c, $31, $58, $0e                  ;$b74d
        .byte   $ef, $1a, $9c, $1d, $df, $5f, $0e, $ef                  ;$b755
        .byte   $13, $ef, $21, $87, $5f, $0e, $ef, $13                  ;$b75d
        .byte   $ef, $21, $87, $38, $1f, $a5, $58, $0e                  ;$b765
        .byte   $ef, $19, $1e, $21, $87, $5f, $0e, $ef                  ;$b76d
        .byte   $16, $60, $25, $a2, $5f, $0e, $ef, $16                  ;$b775
        .byte   $60, $25, $a2, $38, $21, $87, $58, $0e                  ;$b77d
        .byte   $ef, $1a, $9c, $25, $a2, $5f, $0e, $ef                  ;$b785
        .byte   $19, $1e, $27, $df, $5f, $0e, $ef, $16                  ;$b78d
        .byte   $60, $2c, $31, $5f, $0e, $ef, $13, $ef                  ;$b795
        .byte   $32, $3c, $7f, $08, $06, $29, $2a, $6a                  ;$b79d
        .byte   $b8, $f1, $07, $77, $85, $0e, $ef, $12                  ;$b7a5
        .byte   $d1, $2c, $31, $83, $2a, $3e, $f5, $0e                  ;$b7ad
        .byte   $ef, $12, $d1, $2c, $c1, $f1, $07, $77                  ;$b7b5
        .byte   $85, $0e, $ef, $13, $ef, $32, $3c, $83                  ;$b7bd
        .byte   $2f, $6b, $f5, $0e, $ef, $13, $ef, $32                  ;$b7c5
        .byte   $3c, $f1, $07, $77, $85, $0e, $ef, $15                  ;$b7cd
        .byte   $1f, $32, $3c, $83, $2f, $6b, $f5, $0e                  ;$b7d5
        .byte   $ef, $15, $1f, $32, $3c, $5c, $08, $07                  ;$b7dd
        .byte   $77, $16, $60, $35, $39, $3f, $3b, $be                  ;$b7e5
        .byte   $3f, $43, $0f, $ff, $c8, $09, $7e, $3f                  ;$b7ed
        .byte   $a4, $60, $06, $06, $99, $1a, $1a, $8c                  ;$b7f5
        .byte   $83, $35, $3a, $83, $3b, $be, $83, $43                  ;$b7fd
        .byte   $0f, $83, $1d, $df, $f3, $35, $39, $f4                  ;$b805
        .byte   $07, $77, $12, $d1, $f4, $07, $77, $12                  ;$b80d
        .byte   $d1, $f4, $07, $77, $12, $d1, $3d, $21                  ;$b815
        .byte   $11, $21, $35, $39, $38, $3b, $be, $38                  ;$b81d
        .byte   $43, $0f, $38, $1d, $df, $38, $32, $3c                  ;$b825
        .byte   $4f, $07, $77, $13, $ef, $4f, $07, $77                  ;$b82d
        .byte   $13, $ef, $4f, $07, $77, $13, $ef, $ef                  ;$b835
        .byte   $1f, $a4, $65, $83, $32, $3c, $83, $35                  ;$b83d
        .byte   $39, $83, $3b, $be, $83, $1d, $df, $57                  ;$b845
        .byte   $44, $48, $48, $2f, $8f, $89, $07, $77                  ;$b84d
        .byte   $12, $d1, $2c, $c1, $3f, $1a, $9c, $3f                  ;$b855
        .byte   $1d, $df, $5f, $07, $77, $10, $c3, $27                  ;$b85d
        .byte   $df, $3f, $1a, $9c, $3f, $1d, $df, $5f                  ;$b865
        .byte   $07, $77, $0e, $ef, $25, $a2, $3f, $1a                  ;$b86d
        .byte   $9c, $3f, $1d, $df, $5f, $07, $77, $1a                  ;$b875
        .byte   $9c, $21, $87, $3f, $16, $60, $3f, $1a                  ;$b87d
        .byte   $9c, $5f, $07, $77, $19, $1e, $1d, $df                  ;$b885
        .byte   $3f, $13, $ef, $3f, $19, $1e, $cf, $0b                  ;$b88d
        .byte   $f5, $07, $77, $16, $60, $1a, $9c, $f3                  ;$b895
        .byte   $12, $d1, $f3, $16, $60, $7d, $11, $11                  ;$b89d
        .byte   $11, $27, $27, $27, $1b, $1b, $1b, $f5                  ;$b8a5
        .byte   $07, $77, $07, $7a, $0e, $ef, $ff, $f5                  ;$b8ad
        .byte   $06, $a7, $0d, $4e, $1a, $9c, $ff, $f5                  ;$b8b5
        .byte   $05, $98, $0b, $30, $16, $60, $ff, $78                  ;$b8bd
        .byte   $04, $69, $66, $1b, $ab, $9b, $de, $3f                  ;$b8c5
        .byte   $f2, $60, $21, $11, $11, $21, $09, $f7                  ;$b8cd
        .byte   $13, $ef, $ff, $1f, $0c, $8f, $f2, $19                  ;$b8d5
        .byte   $1e, $ff, $21, $0e, $ef, $1d, $df, $ff                  ;$b8dd
        .byte   $ff, $c7, $44, $46, $08, $2a, $99, $8a                  ;$b8e5
        .byte   $0a, $f5, $04, $fb, $0c, $8f, $1d, $df                  ;$b8ed
        .byte   $f4, $09, $f7, $0c, $8f, $f5, $09, $f7                  ;$b8f5
        .byte   $32, $3c, $3b, $be, $f5, $04, $fb, $32                  ;$b8fd
        .byte   $3c, $3b, $be, $f4, $09, $f7, $0c, $8f                  ;$b905
        .byte   $f5, $09, $f7, $27, $df, $32, $3c, $f5                  ;$b90d
        .byte   $04, $fb, $27, $df, $32, $3c, $f4, $09                  ;$b915
        .byte   $f7, $0c, $8f, $47, $42, $69, $66, $1b                  ;$b91d
        .byte   $ab, $9b, $09, $f7, $13, $ef, $4f, $09                  ;$b925
        .byte   $f7, $13, $ef, $4f, $0c, $8f, $19, $1e                  ;$b92d
        .byte   $4f, $0e, $ef, $1d, $df, $7f, $44, $46                  ;$b935
        .byte   $08, $2a, $99, $8a, $f5, $05, $98, $09                  ;$b93d
        .byte   $68, $1d, $df, $f4, $0d, $4e, $0e, $ef                  ;$b945
        .byte   $f5, $12, $d2, $2c, $c1, $3b, $be, $f5                  ;$b94d
        .byte   $07, $77, $2c, $c1, $3b, $be, $f4, $0e                  ;$b955
        .byte   $ef, $12, $d1, $f5, $12, $d1, $2c, $c1                  ;$b95d
        .byte   $35, $39, $f5, $03, $bb, $2c, $31, $35                  ;$b965
        .byte   $39, $f4, $0d, $4e, $0e, $ef, $47, $42                  ;$b96d
        .byte   $69, $66, $1b, $ab, $9b, $09, $68, $12                  ;$b975
        .byte   $d1, $4f, $09, $68, $12, $d1, $4f, $0b                  ;$b97d
        .byte   $30, $16, $60, $4f, $10, $c0, $21, $87                  ;$b985
        .byte   $7f, $44, $44, $08, $2a, $59, $5a, $f5                  ;$b98d
        .byte   $07, $77, $12, $d1, $21, $87, $f4, $0e                  ;$b995
        .byte   $ef, $12, $d1, $f5, $12, $d1, $35, $39                  ;$b99d
        .byte   $43, $0f, $f5, $03, $bb, $35, $39, $43                  ;$b9a5
        .byte   $0f, $f4, $0e, $ef, $12, $d1, $f5, $12                  ;$b9ad
        .byte   $d1, $2c, $c1, $35, $39, $f5, $07, $77                  ;$b9b5
        .byte   $2c, $c1, $35, $39, $f4, $0d, $4e, $0e                  ;$b9bd
        .byte   $ef, $47, $42, $69, $46, $1b, $ab, $ab                  ;$b9c5
        .byte   $09, $68, $12, $d1, $4f, $09, $68, $12                  ;$b9cd
        .byte   $d1, $4f, $0b, $30, $16, $60, $4f, $10                  ;$b9d5
        .byte   $c3, $21, $87, $7f, $44, $44, $08, $2a                  ;$b9dd
        .byte   $59, $5a, $f5, $04, $fb, $0c, $8f, $21                  ;$b9e5
        .byte   $87, $f4, $0c, $8f, $0e, $ef, $f5, $13                  ;$b9ed
        .byte   $ef, $32, $3c, $43, $0f, $f5, $07, $77                  ;$b9f5
        .byte   $32, $3c, $43, $0f, $f4, $0c, $8f, $0e                  ;$b9fd
        .byte   $ef, $f5, $13, $ef, $27, $df, $32, $3c                  ;$ba05
        .byte   $f5, $04, $fb, $27, $df, $32, $3c, $f4                  ;$ba0d
        .byte   $0c, $8f, $0e, $ef, $dc, $0b, $21, $21                  ;$ba15
        .byte   $21, $e7, $04, $04, $44, $5b, $5b, $5b                  ;$ba1d
        .byte   $6f, $f4, $65, $f4, $09, $f7, $13, $ef                  ;$ba25
        .byte   $f4, $09, $f7, $13, $ef, $f4, $0c, $8f                  ;$ba2d
        .byte   $19, $1e, $f4, $0e, $ef, $1d, $df, $c7                  ;$ba35
        .byte   $44, $44, $48, $39, $49, $aa, $09, $f5                  ;$ba3d
        .byte   $06, $47, $0c, $8f, $27, $df, $84, $09                  ;$ba45
        .byte   $f7, $0c, $8f, $83, $4f, $bf, $f5, $0c                  ;$ba4d
        .byte   $8f, $3b, $be, $4f, $bf, $f5, $06, $47                  ;$ba55
        .byte   $32, $3c, $4f, $bf, $84, $0c, $8f, $0e                  ;$ba5d
        .byte   $ef, $83, $3b, $be, $f5, $13, $ef, $32                  ;$ba65
        .byte   $3c, $3b, $be, $f5, $04, $fb, $32, $3c                  ;$ba6d
        .byte   $3b, $be, $f4, $09, $f7, $0c, $8f, $47                  ;$ba75
        .byte   $06, $46, $46, $7b, $7b, $7b, $09, $f7                  ;$ba7d
        .byte   $13, $ef, $4f, $09, $f7, $13, $ef, $4f                  ;$ba85
        .byte   $0c, $8f, $19, $1e, $4f, $0e, $ef, $1d                  ;$ba8d
        .byte   $df, $7f, $46, $46, $49, $59, $69, $aa                  ;$ba95
        .byte   $f5, $06, $a7, $06, $af, $27, $df, $84                  ;$ba9d
        .byte   $0d, $4e, $10, $c3, $83, $4f, $bf, $f5                  ;$baa5
        .byte   $0d, $4e, $10, $c3, $4f, $bf, $f5, $04                  ;$baad
        .byte   $fb, $43, $0f, $4f, $bf, $84, $0d, $4e                  ;$bab5
        .byte   $10, $c3, $83, $43, $0f, $f5, $06, $a7                  ;$babd
        .byte   $35, $39, $43, $0f, $f5, $03, $53, $27                  ;$bac5
        .byte   $df, $43, $0f, $df, $21, $21, $41, $c7                  ;$bacd
        .byte   $28, $28, $28, $9b, $9b, $9b, $0c, $f4                  ;$bad5
        .byte   $0b, $30, $16, $60, $f4, $0b, $30, $16                  ;$badd
        .byte   $60, $f4, $0d, $4e, $1a, $9c, $f4, $10                  ;$bae5
        .byte   $c3, $21, $87, $c8, $08, $57, $46, $46                  ;$baed
        .byte   $49, $59, $59, $ca, $03, $bb, $03, $bb                  ;$baf5
        .byte   $21, $87, $4f, $0e, $ef, $12, $d1, $4f                  ;$bafd
        .byte   $12, $d1, $16, $60, $1f, $06, $a7, $5f                  ;$bb05
        .byte   $0e, $ef, $12, $d1, $1c, $31, $5f, $12                  ;$bb0d
        .byte   $d1, $16, $60, $1d, $df, $5f, $06, $47                  ;$bb15
        .byte   $06, $4a, $32, $3c, $4f, $0e, $ef, $13                  ;$bb1d
        .byte   $ef, $4f, $13, $ef, $19, $1e, $1f, $04                  ;$bb25
        .byte   $fb, $5f, $0c, $8f, $0e, $ef, $27, $df                  ;$bb2d
        .byte   $5f, $0e, $ef, $13, $ef, $19, $1e, $5f                  ;$bb35
        .byte   $06, $a7, $06, $aa, $19, $1e, $4f, $0d                  ;$bb3d
        .byte   $4e, $10, $c3, $5f, $0d, $4e, $10, $c3                  ;$bb45
        .byte   $16, $60, $5f, $03, $bb, $03, $bd, $21                  ;$bb4d
        .byte   $87, $4f, $0d, $4e, $12, $d1, $5f, $12                  ;$bb55
        .byte   $d1, $16, $60, $1d, $df, $5f, $09, $f7                  ;$bb5d
        .byte   $0c, $8f, $13, $ef, $8f, $57, $08, $08                  ;$bb65
        .byte   $08, $88, $88, $88, $02, $7d, $04, $fc                  ;$bb6d
        .byte   $09, $f9, $58, $02, $7d, $04, $fc, $09                  ;$bb75
        .byte   $f9, $ff, $7d, $11, $11, $11, $28, $24                  ;$bb7d
        .byte   $44, $39, $2b, $7b, $ec, $10, $6f, $a4                  ;$bb85
        .byte   $65, $32, $32, $3c, $4f, $bf, $28, $2c                  ;$bb8d
        .byte   $c1, $83, $4b, $45, $85, $05, $98, $2c                  ;$bb95
        .byte   $c1, $4b, $45, $85, $0b, $30, $27, $df                  ;$bb9d
        .byte   $43, $0f, $85, $0e, $18, $27, $df, $43                  ;$bba5
        .byte   $0f, $81, $05, $98, $85, $0b, $30, $27                  ;$bbad
        .byte   $df, $43, $0f, $85, $0e, $18, $25, $a2                  ;$bbb5
        .byte   $3f, $4b, $85, $05, $98, $25, $a2, $3f                  ;$bbbd
        .byte   $4b, $85, $0b, $30, $27, $df, $43, $0f                  ;$bbc5
        .byte   $85, $0e, $18, $27, $df, $43, $0f, $81                  ;$bbcd
        .byte   $05, $98, $85, $0e, $18, $13, $ef, $16                  ;$bbd5
        .byte   $60, $85, $10, $c3, $13, $ef, $16, $60                  ;$bbdd
        .byte   $85, $07, $77, $12, $d1, $19, $1e, $81                  ;$bbe5
        .byte   $0b, $30, $85, $0e, $ef, $12, $d1, $16                  ;$bbed
        .byte   $60, $81, $05, $98, $85, $0b, $30, $12                  ;$bbf5
        .byte   $d1, $16, $60, $85, $0e, $18, $12, $d1                  ;$bbfd
        .byte   $16, $60, $85, $07, $77, $12, $d1, $21                  ;$bc05
        .byte   $87, $81, $0b, $30, $85, $0e, $ef, $12                  ;$bc0d
        .byte   $d1, $1d, $df, $81, $05, $98, $32, $32                  ;$bc15
        .byte   $3c, $4f, $bf, $28, $2c, $c1, $83, $4b                  ;$bc1d
        .byte   $45, $85, $05, $98, $2c, $c1, $4b, $45                  ;$bc25
        .byte   $85, $0b, $30, $27, $df, $43, $0f, $85                  ;$bc2d
        .byte   $0e, $18, $27, $df, $43, $0f, $81, $05                  ;$bc35
        .byte   $98, $85, $0b, $30, $27, $df, $43, $0f                  ;$bc3d
        .byte   $85, $0d, $4e, $2c, $c1, $4b, $45, $85                  ;$bc45
        .byte   $05, $98, $38, $63, $59, $83, $85, $0b                  ;$bc4d
        .byte   $30, $32, $3c, $4f, $bf, $85, $0e, $18                  ;$bc55
        .byte   $32, $3c, $4f, $bf, $81, $05, $98, $5d                  ;$bc5d
        .byte   $21, $21, $21, $0b, $30, $13, $ef, $1c                  ;$bc65
        .byte   $31, $58, $0b, $da, $13, $ef, $21, $87                  ;$bc6d
        .byte   $58, $0c, $8f, $12, $d1, $21, $87, $5f                  ;$bc75
        .byte   $06, $47, $12, $d1, $1d, $df, $58, $09                  ;$bc7d
        .byte   $f7, $16, $60, $1c, $31, $5f, $04, $fb                  ;$bc85
        .byte   $13, $ef, $19, $1e, $c8, $08, $57, $08                  ;$bc8d
        .byte   $08, $08, $89, $89, $89, $0b, $30, $13                  ;$bc95
        .byte   $ef, $19, $1e, $58, $0b, $30, $13, $ef                  ;$bc9d
        .byte   $19, $1e, $58, $0b, $30, $13, $ef, $19                  ;$bca5
        .byte   $1e, $5f, $05, $98, $0e, $18, $16, $60                  ;$bcad
        .byte   $5f, $03, $bb, $07, $77, $0e, $ef, $ff                  ;$bcb5
        .byte   $7d, $21, $11, $21, $06, $46, $68, $1b                  ;$bcbd
        .byte   $69, $99, $f3, $1d, $df, $85, $03, $bb                  ;$bcc5
        .byte   $0d, $4e, $1a, $9c, $82, $0e, $ef, $84                  ;$bccd
        .byte   $07, $77, $12, $d1, $82, $16, $60, $85                  ;$bcd5
        .byte   $07, $77, $1a, $9c, $1d, $df, $82, $1d                  ;$bcdd
        .byte   $ef, $85, $03, $bb, $0d, $4e, $1a, $9c                  ;$bce5
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$bced
        .byte   $82, $16, $60, $85, $07, $77, $1a, $9c                  ;$bcf5
        .byte   $1d, $df, $82, $1d, $ef, $57, $06, $46                  ;$bcfd
        .byte   $89, $1b, $69, $ac, $03, $bb, $0d, $4e                  ;$bd05
        .byte   $32, $3c, $28, $0e, $ef, $48, $07, $77                  ;$bd0d
        .byte   $12, $d1, $28, $16, $60, $48, $07, $77                  ;$bd15
        .byte   $1a, $9c, $28, $1d, $df, $48, $03, $bb                  ;$bd1d
        .byte   $0d, $4e, $28, $0e, $ef, $58, $07, $77                  ;$bd25
        .byte   $12, $d1, $2c, $c1, $28, $16, $60, $58                  ;$bd2d
        .byte   $07, $77, $1a, $9c, $1d, $df, $28, $1d                  ;$bd35
        .byte   $ef, $78, $06, $46, $68, $1b, $69, $99                  ;$bd3d
        .byte   $85, $04, $fb, $0c, $8f, $19, $1e, $82                  ;$bd45
        .byte   $0e, $ef, $84, $09, $f7, $13, $ef, $82                  ;$bd4d
        .byte   $19, $1e, $85, $09, $f7, $1d, $ef, $1d                  ;$bd55
        .byte   $df, $82, $27, $df, $85, $04, $fb, $0c                  ;$bd5d
        .byte   $8f, $19, $1e, $82, $0e, $ef, $84, $09                  ;$bd65
        .byte   $f7, $13, $ef, $82, $19, $1e, $85, $09                  ;$bd6d
        .byte   $f7, $1d, $ef, $1d, $df, $82, $27, $df                  ;$bd75
        .byte   $57, $06, $46, $89, $1b, $69, $ac, $04                  ;$bd7d
        .byte   $fb, $0c, $8f, $2c, $c1, $28, $0e, $ef                  ;$bd85
        .byte   $48, $09, $f7, $13, $ef, $28, $19, $1e                  ;$bd8d
        .byte   $48, $09, $f7, $1d, $df, $28, $27, $df                  ;$bd95
        .byte   $48, $02, $7d, $0c, $8f, $28, $0e, $ef                  ;$bd9d
        .byte   $58, $09, $f7, $13, $ef, $27, $df, $48                  ;$bda5
        .byte   $09, $f7, $19, $1e, $58, $09, $f7, $1d                  ;$bdad
        .byte   $ef, $1d, $df, $28, $27, $df, $78, $06                  ;$bdb5
        .byte   $46, $68, $1b, $69, $a9, $85, $03, $bb                  ;$bdbd
        .byte   $0d, $4e, $1a, $9c, $82, $0e, $ef, $84                  ;$bdc5
        .byte   $07, $77, $12, $d1, $82, $16, $60, $85                  ;$bdcd
        .byte   $07, $77, $1a, $9c, $1d, $df, $82, $1d                  ;$bdd5
        .byte   $ef, $85, $03, $bb, $0d, $4e, $1a, $9c                  ;$bddd
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$bde5
        .byte   $82, $16, $60, $85, $07, $77, $1a, $9c                  ;$bded
        .byte   $1d, $df, $82, $1d, $ef, $57, $06, $46                  ;$bdf5
        .byte   $89, $1b, $69, $ac, $03, $bb, $0d, $4e                  ;$bdfd
        .byte   $32, $3c, $28, $0e, $ef, $48, $07, $77                  ;$be05
        .byte   $12, $d1, $28, $16, $60, $48, $07, $77                  ;$be0d
        .byte   $1a, $9c, $28, $1d, $df, $48, $03, $bb                  ;$be15
        .byte   $0d, $4e, $28, $0e, $ef, $58, $07, $77                  ;$be1d
        .byte   $12, $d1, $2c, $c1, $28, $16, $60, $58                  ;$be25
        .byte   $07, $77, $1a, $9c, $1d, $df, $28, $1d                  ;$be2d
        .byte   $ef, $d8, $21, $21, $21, $f5, $09, $f7                  ;$be35
        .byte   $19, $1e, $27, $df, $f5, $12, $d1, $1a                  ;$be3d
        .byte   $9c, $2c, $c1, $f5, $11, $c3, $1d, $df                  ;$be45
        .byte   $32, $3c, $f5, $06, $a7, $2a, $3e, $3b                  ;$be4d
        .byte   $be, $f1, $03, $53, $f5, $10, $c3, $2c                  ;$be55
        .byte   $c1, $35, $39, $57, $08, $08, $08, $99                  ;$be5d
        .byte   $99, $c9, $07, $77, $27, $df, $32, $3c                  ;$be65
        .byte   $58, $07, $77, $27, $df, $32, $3c, $58                  ;$be6d
        .byte   $07, $77, $25, $a2, $32, $3c, $5f, $03                  ;$be75
        .byte   $bb, $1a, $9c, $2c, $c1, $5f, $02, $7d                  ;$be7d
        .byte   $19, $1e, $27, $df, $ff, $7c, $11, $27                  ;$be85
        .byte   $27, $48, $19, $19, $ba, $83, $27, $df                  ;$be8d
        .byte   $81, $07, $e9, $84, $0f, $d2, $13, $ef                  ;$be95
        .byte   $84, $0f, $d2, $13, $ef, $81, $07, $e9                  ;$be9d
        .byte   $85, $0f, $d2, $11, $c3, $2a, $3e, $85                  ;$bea5
        .byte   $0f, $d2, $13, $ef, $27, $df, $31, $05                  ;$bead
        .byte   $47, $23, $86, $58, $0a, $8f, $0d, $4e                  ;$beb5
        .byte   $1f, $a5, $58, $0a, $8f, $0e, $ef, $1d                  ;$bebd
        .byte   $df, $58, $0a, $8f, $0f, $d2, $1a, $9c                  ;$bec5
        .byte   $3f, $1a, $9c, $18, $07, $77, $83, $23                  ;$becd
        .byte   $86, $84, $0e, $ef, $11, $c3, $85, $0e                  ;$bed5
        .byte   $ef, $11, $c3, $23, $86, $81, $05, $ed                  ;$bedd
        .byte   $85, $0e, $ef, $15, $1f, $1a, $9c, $85                  ;$bee5
        .byte   $0e, $ef, $15, $1f, $17, $b5, $31, $07                  ;$beed
        .byte   $e9, $17, $b5, $48, $0f, $d2, $13, $ef                  ;$bef5
        .byte   $48, $0f, $d2, $13, $ef, $48, $0b, $da                  ;$befd
        .byte   $15, $1f, $28, $13, $ef, $58, $07, $77                  ;$bf05
        .byte   $11, $c3, $17, $b5, $18, $07, $e9, $83                  ;$bf0d
        .byte   $27, $df, $84, $0f, $d2, $13, $ef, $84                  ;$bf15
        .byte   $0f, $d2, $13, $ef, $81, $07, $e9, $85                  ;$bf1d
        .byte   $0f, $d2, $11, $c3, $2a, $3e, $85, $0f                  ;$bf25
        .byte   $d2, $13, $ef, $27, $df, $31, $05, $47                  ;$bf2d
        .byte   $23, $86, $58, $0a, $8f, $0d, $4e, $1f                  ;$bf35
        .byte   $a5, $58, $0a, $8f, $0e, $ef, $1d, $df                  ;$bf3d
        .byte   $58, $0b, $30, $12, $d1, $1a, $9c, $5f                  ;$bf45
        .byte   $07, $77, $12, $d1, $1a, $9c, $18, $09                  ;$bf4d
        .byte   $f7, $83, $19, $1e, $84, $0e, $ef, $13                  ;$bf55
        .byte   $ef, $85, $0e, $ef, $13, $ef, $19, $1e                  ;$bf5d
        .byte   $81, $09, $f7, $85, $0f, $d2, $12, $d1                  ;$bf65
        .byte   $1a, $9c, $85, $0f, $d2, $12, $d1, $1f                  ;$bf6d
        .byte   $a5, $85, $09, $f7, $19, $1e, $1d, $df                  ;$bf75
        .byte   $84, $07, $77, $0e, $ef, $84, $07, $77                  ;$bf7d
        .byte   $0e, $ef, $84, $07, $77, $0e, $ef, $84                  ;$bf85
        .byte   $07, $77, $0e, $ef, $dc, $08, $21, $11                  ;$bf8d
        .byte   $21, $37, $06, $46, $68, $1b, $69, $99                  ;$bf95
        .byte   $1d, $df, $5f, $03, $bb, $0d, $4e, $1a                  ;$bf9d
        .byte   $9c, $28, $0e, $ef, $48, $07, $77, $12                  ;$bfa5
        .byte   $d1, $28, $16, $60, $58, $07, $77, $1a                  ;$bfad
        .byte   $9c, $1d, $df, $28, $1d, $ef, $58, $03                  ;$bfb5
        .byte   $bb, $0d, $4e, $1a, $9c, $28, $0e, $ef                  ;$bfbd
        .byte   $48, $07, $77, $12, $d1, $28, $16, $60                  ;$bfc5
        .byte   $58, $07, $77, $1a, $9c, $1d, $df, $28                  ;$bfcd
        .byte   $1d, $ef, $78, $06, $46, $89, $1b, $69                  ;$bfd5
        .byte   $ac, $85, $03, $bb, $0d, $4e, $32, $3c                  ;$bfdd
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$bfe5
        .byte   $82, $16, $60, $84, $07, $77, $1a, $9c                  ;$bfed
        .byte   $82, $1d, $df, $84, $03, $bb, $0d, $4e                  ;$bff5
        .byte   $82, $0e, $ef, $85, $07, $77, $12, $d1                  ;$bffd
        .byte   $2c, $c1, $82, $16, $60, $85, $07, $77                  ;$c005
        .byte   $1a, $9c, $1d, $df, $82, $1d, $ef, $57                  ;$c00d
        .byte   $06, $46, $68, $1b, $69, $99, $04, $fb                  ;$c015
        .byte   $0c, $8f, $19, $1e, $28, $0e, $ef, $48                  ;$c01d
        .byte   $09, $f7, $13, $ef, $28, $19, $1e, $58                  ;$c025
        .byte   $09, $f7, $1d, $ef, $1d, $df, $28, $27                  ;$c02d
        .byte   $df, $58, $04, $fb, $0c, $8f, $19, $1e                  ;$c035
        .byte   $28, $0e, $ef, $48, $09, $f7, $13, $ef                  ;$c03d
        .byte   $28, $19, $1e, $58, $09, $f7, $1d, $ef                  ;$c045
        .byte   $1d, $df, $28, $27, $df, $78, $06, $46                  ;$c04d
        .byte   $89, $1b, $69, $ac, $85, $04, $fb, $0c                  ;$c055
        .byte   $8f, $2c, $c1, $82, $0e, $ef, $84, $09                  ;$c05d
        .byte   $f7, $13, $ef, $82, $19, $1e, $84, $09                  ;$c065
        .byte   $f7, $1d, $df, $82, $27, $df, $84, $02                  ;$c06d
        .byte   $7d, $0c, $8f, $82, $0e, $ef, $85, $09                  ;$c075
        .byte   $f7, $13, $ef, $27, $df, $84, $09, $f7                  ;$c07d
        .byte   $19, $1e, $85, $09, $f7, $1d, $ef, $1d                  ;$c085
        .byte   $df, $82, $27, $df, $57, $06, $46, $69                  ;$c08d
        .byte   $1a, $88, $a9, $03, $bb, $0d, $4e, $1a                  ;$c095
        .byte   $9c, $28, $0e, $ef, $48, $07, $77, $12                  ;$c09d
        .byte   $d1, $28, $16, $60, $58, $07, $77, $1a                  ;$c0a5
        .byte   $9c, $1d, $df, $28, $1d, $ef, $58, $03                  ;$c0ad
        .byte   $bb, $0d, $4e, $1a, $9c, $28, $0e, $ef                  ;$c0b5
        .byte   $48, $07, $77, $12, $d1, $28, $16, $60                  ;$c0bd
        .byte   $58, $07, $77, $1a, $9c, $1d, $df, $28                  ;$c0c5
        .byte   $1d, $ef, $78, $06, $46, $89, $1b, $69                  ;$c0cd
        .byte   $ac, $85, $03, $bb, $0d, $4e, $32, $3c                  ;$c0d5
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$c0dd
        .byte   $82, $16, $60, $84, $07, $77, $1a, $9c                  ;$c0e5
        .byte   $82, $1d, $df, $84, $03, $bb, $0d, $4e                  ;$c0ed
        .byte   $82, $0e, $ef, $85, $07, $77, $12, $d1                  ;$c0f5
        .byte   $2c, $c1, $82, $16, $60, $85, $07, $77                  ;$c0fd
        .byte   $1a, $9c, $1d, $df, $82, $1d, $ef, $5d                  ;$c105
        .byte   $21, $21, $21, $09, $f7, $19, $1e, $27                  ;$c10d
        .byte   $df, $5f, $12, $d1, $1a, $9c, $2c, $c1                  ;$c115
        .byte   $5f, $11, $c3, $1d, $df, $32, $3c, $5f                  ;$c11d
        .byte   $06, $a7, $2a, $3e, $3b, $be, $1f, $03                  ;$c125
        .byte   $53, $5f, $10, $c3, $2c, $c1, $35, $39                  ;$c12d
        .byte   $7f, $08, $08, $08, $99, $99, $c9, $85                  ;$c135
        .byte   $07, $77, $27, $df, $32, $3c, $85, $07                  ;$c13d
        .byte   $77, $27, $df, $32, $3c, $f5, $07, $77                  ;$c145
        .byte   $25, $a2, $32, $3c, $f5, $03, $bb, $1a                  ;$c14d
        .byte   $9c, $2c, $c1, $85, $02, $7d, $19, $1e                  ;$c155
        .byte   $27, $df, $8c, $2f, $9c, $08, $ff, $a7                  ;$c15d
        .byte   $05, $05, $0a, $17, $17, $fa, $00, $06                  ;$c165
        .byte   $00, $04, $00, $01, $ec, $05, $7f, $f4                  ;$c16d
        .byte   $50, $4d, $21, $21, $41, $10, $c3, $19                  ;$c175
        .byte   $1e, $4f, $10, $c3, $19, $1e, $4f, $10                  ;$c17d
        .byte   $c3, $19, $1e, $4f, $10, $c3, $19, $1e                  ;$c185
        .byte   $4f, $10, $c3, $19, $1e, $4f, $10, $c3                  ;$c18d
        .byte   $19, $1e, $4f, $10, $c3, $19, $1e, $4f                  ;$c195
        .byte   $10, $c3, $19, $1e, $5f, $10, $c3, $19                  ;$c19d
        .byte   $1e, $02, $f6, $38, $03, $23, $58, $10                  ;$c1a5
        .byte   $c3, $19, $1e, $04, $30, $38, $05, $47                  ;$c1ad
        .byte   $58, $10, $c3, $19, $1e, $07, $0c, $38                  ;$c1b5
        .byte   $06, $47, $58, $10, $c3, $19, $1e, $09                  ;$c1bd
        .byte   $68, $38, $0a, $8f, $58, $10, $c3, $19                  ;$c1c5
        .byte   $1e, $0e, $18, $38, $0c, $8f, $58, $10                  ;$c1cd
        .byte   $c3, $19, $1e, $12, $d1, $38, $15, $1f                  ;$c1d5
        .byte   $58, $10, $c3, $19, $1f, $1c, $31, $38                  ;$c1dd
        .byte   $17, $b5, $58, $10, $c3, $15, $1f, $19                  ;$c1e5
        .byte   $1e, $38, $2a, $3e, $48, $10, $c3, $19                  ;$c1ed
        .byte   $1e, $4f, $10, $c3, $19, $1e, $4f, $10                  ;$c1f5
        .byte   $c3, $19, $1e, $4f, $10, $c3, $19, $1e                  ;$c1fd
        .byte   $7f, $05, $05, $25, $17, $17, $a8, $4e                  ;$c205
        .byte   $3f, $f4, $63, $0e, $18, $16, $60, $5f                  ;$c20d
        .byte   $0e, $18, $16, $60, $19, $1e, $38, $19                  ;$c215
        .byte   $1e, $58, $0e, $18, $16, $60, $21, $87                  ;$c21d
        .byte   $5f, $0e, $18, $16, $60, $2a, $3e, $7f                  ;$c225
        .byte   $04, $04, $29, $17, $17, $ab, $f5, $0c                  ;$c22d
        .byte   $8f, $16, $60, $32, $3c, $f4, $0c, $8f                  ;$c235
        .byte   $16, $60, $f4, $0c, $8f, $16, $60, $f4                  ;$c23d
        .byte   $0c, $8f, $16, $60, $f5, $0c, $8f, $16                  ;$c245
        .byte   $60, $1f, $a5, $f4, $0c, $8f, $16, $60                  ;$c24d
        .byte   $f4, $0c, $8f, $16, $60, $f4, $0c, $8f                  ;$c255
        .byte   $16, $60, $73, $00, $00, $31, $31, $04                  ;$c25d
        .byte   $19, $19, $5b, $ed, $21, $41, $41, $3f                  ;$c265
        .byte   $f4, $70, $4a, $00, $0a, $00, $0a, $00                  ;$c26d
        .byte   $0a, $04, $30, $04, $35, $5f, $10, $c3                  ;$c275
        .byte   $15, $1f, $19, $1e, $38, $19, $1e, $58                  ;$c27d
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $04                  ;$c285
        .byte   $30, $04, $35, $2a, $3e, $5f, $10, $c3                  ;$c28d
        .byte   $15, $1f, $32, $3c, $4f, $10, $c3, $15                  ;$c295
        .byte   $1f, $4f, $04, $30, $04, $35, $4f, $10                  ;$c29d
        .byte   $c3, $15, $1f, $4f, $03, $23, $03, $24                  ;$c2a5
        .byte   $5f, $10, $c3, $16, $60, $25, $a2, $38                  ;$c2ad
        .byte   $25, $a2, $58, $10, $c3, $16, $60, $2c                  ;$c2b5
        .byte   $c1, $5f, $03, $23, $03, $24, $32, $3c                  ;$c2bd
        .byte   $5f, $10, $c3, $16, $60, $38, $63, $5f                  ;$c2c5
        .byte   $10, $c3, $16, $60, $32, $3c, $5f, $03                  ;$c2cd
        .byte   $23, $03, $24, $2a, $3e, $5f, $10, $c3                  ;$c2d5
        .byte   $16, $60, $25, $a2, $5f, $04, $30, $04                  ;$c2dd
        .byte   $35, $2a, $3e, $5f, $10, $c3, $15, $1f                  ;$c2e5
        .byte   $21, $87, $5f, $10, $c3, $15, $1f, $19                  ;$c2ed
        .byte   $1e, $5f, $04, $30, $04, $35, $19, $1e                  ;$c2f5
        .byte   $4f, $10, $c3, $15, $1f, $4f, $10, $c3                  ;$c2fd
        .byte   $15, $1f, $5f, $04, $30, $04, $35, $03                  ;$c305
        .byte   $23, $38, $04, $39, $58, $10, $c3, $15                  ;$c30d
        .byte   $1f, $06, $47, $38, $08, $61, $48, $03                  ;$c315
        .byte   $23, $03, $24, $4f, $10, $c3, $16, $60                  ;$c31d
        .byte   $4f, $10, $c3, $16, $60, $4f, $03, $23                  ;$c325
        .byte   $03, $24, $4f, $10, $c3, $16, $60, $4f                  ;$c32d
        .byte   $10, $c3, $16, $60, $5f, $03, $23, $03                  ;$c335
        .byte   $24, $03, $25, $38, $04, $b4, $58, $10                  ;$c33d
        .byte   $c3, $16, $60, $06, $47, $38, $09, $68                  ;$c345
        .byte   $48, $04, $30, $04, $35, $5f, $10, $c3                  ;$c34d
        .byte   $15, $1f, $19, $1e, $38, $19, $1e, $58                  ;$c355
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $04                  ;$c35d
        .byte   $30, $04, $35, $2a, $3e, $5f, $10, $c3                  ;$c365
        .byte   $15, $1f, $32, $3c, $4f, $10, $c3, $15                  ;$c36d
        .byte   $1f, $4f, $04, $30, $04, $35, $5f, $10                  ;$c375
        .byte   $c3, $15, $1f, $32, $3c, $38, $38, $63                  ;$c37d
        .byte   $58, $05, $98, $05, $9f, $3b, $be, $5f                  ;$c385
        .byte   $0b, $30, $0e, $18, $38, $63, $4f, $0b                  ;$c38d
        .byte   $30, $0e, $18, $5f, $05, $47, $05, $4f                  ;$c395
        .byte   $32, $3c, $4f, $0a, $8f, $0c, $8f, $5f                  ;$c39d
        .byte   $0a, $8f, $0c, $8f, $2a, $3e, $5f, $05                  ;$c3a5
        .byte   $47, $05, $4d, $32, $3c, $5f, $0a, $8f                  ;$c3ad
        .byte   $0c, $8f, $38, $63, $5f, $09, $68, $09                  ;$c3b5
        .byte   $6f, $25, $a2, $4f, $12, $d1, $16, $60                  ;$c3bd
        .byte   $4f, $12, $d1, $16, $60, $5f, $12, $d1                  ;$c3c5
        .byte   $16, $60, $08, $61, $4f, $12, $d1, $16                  ;$c3cd
        .byte   $60, $5f, $12, $d1, $16, $60, $07, $e9                  ;$c3d5
        .byte   $4f, $12, $d1, $16, $60, $5f, $12, $d1                  ;$c3dd
        .byte   $16, $60, $07, $0c, $5f, $0c, $8f, $0f                  ;$c3e5
        .byte   $d2, $06, $47, $4f, $0c, $8f, $0f, $d2                  ;$c3ed
        .byte   $4f, $0c, $8f, $0f, $d2, $5f, $0c, $8f                  ;$c3f5
        .byte   $0f, $d2, $05, $98, $4f, $0c, $8f, $0f                  ;$c3fd
        .byte   $d2, $5f, $0e, $18, $10, $c3, $05, $47                  ;$c405
        .byte   $4f, $0e, $18, $10, $c3, $5f, $0f, $d2                  ;$c40d
        .byte   $12, $d1, $04, $b4, $4f, $04, $30, $04                  ;$c415
        .byte   $35, $5f, $10, $c3, $15, $1f, $19, $1e                  ;$c41d
        .byte   $38, $19, $1e, $58, $10, $c3, $15, $1f                  ;$c425
        .byte   $21, $87, $5f, $04, $30, $04, $35, $2a                  ;$c42d
        .byte   $3e, $5f, $10, $c3, $15, $1f, $32, $3c                  ;$c435
        .byte   $4f, $10, $c3, $15, $1f, $4f, $04, $30                  ;$c43d
        .byte   $04, $35, $4f, $10, $c3, $15, $1f, $4f                  ;$c445
        .byte   $03, $23, $03, $24, $5f, $10, $c3, $16                  ;$c44d
        .byte   $60, $25, $a2, $38, $25, $a2, $58, $10                  ;$c455
        .byte   $c3, $16, $60, $2c, $c1, $5f, $03, $23                  ;$c45d
        .byte   $03, $24, $32, $3c, $5f, $10, $c3, $16                  ;$c465
        .byte   $60, $38, $63, $5f, $10, $c3, $16, $60                  ;$c46d
        .byte   $32, $3c, $5f, $03, $23, $03, $24, $2a                  ;$c475
        .byte   $3e, $5f, $10, $c3, $16, $60, $25, $a2                  ;$c47d
        .byte   $5f, $04, $30, $04, $35, $2a, $3e, $5f                  ;$c485
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $10                  ;$c48d
        .byte   $c3, $15, $1f, $19, $1e, $5f, $04, $30                  ;$c495
        .byte   $04, $35, $38, $63, $4f, $10, $c3, $15                  ;$c49d
        .byte   $1f, $4f, $10, $c3, $15, $1f, $4f, $04                  ;$c4a5
        .byte   $30, $04, $35, $4f, $10, $c3, $15, $1f                  ;$c4ad
        .byte   $5f, $04, $b4, $04, $b8, $25, $a2, $4f                  ;$c4b5
        .byte   $12, $d1, $16, $60, $4f, $12, $d1, $16                  ;$c4bd
        .byte   $60, $4f, $09, $68, $09, $6a, $4f, $12                  ;$c4c5
        .byte   $d1, $16, $60, $4f, $12, $d1, $16, $60                  ;$c4cd
        .byte   $4f, $04, $b4, $04, $b8, $7f, $04, $04                  ;$c4d5
        .byte   $06, $28, $28, $8b, $85, $12, $d1, $16                  ;$c4dd
        .byte   $60, $25, $a2, $83, $2a, $3e, $f5, $06                  ;$c4e5
        .byte   $47, $06, $4f, $2c, $c1, $f5, $10, $c3                  ;$c4ed
        .byte   $16, $60, $2a, $3e, $f4, $10, $c3, $16                  ;$c4f5
        .byte   $60, $f5, $06, $47, $06, $4f, $21, $87                  ;$c4fd
        .byte   $f5, $10, $c3, $1c, $31, $2c, $c1, $f5                  ;$c505
        .byte   $10, $c3, $1c, $c1, $2a, $3e, $f4, $06                  ;$c50d
        .byte   $47, $06, $4f, $f5, $0e, $18, $16, $60                  ;$c515
        .byte   $21, $87, $f5, $0c, $8f, $16, $60, $32                  ;$c51d
        .byte   $3c, $85, $0c, $8f, $16, $60, $32, $3c                  ;$c525
        .byte   $83, $32, $3c, $f5, $0c, $8f, $16, $60                  ;$c52d
        .byte   $32, $3c, $ff, $7f, $06, $06, $48, $48                  ;$c535
        .byte   $48, $8a, $f5, $06, $47, $16, $60, $32                  ;$c53d
        .byte   $3c, $5f, $04, $30, $15, $1f, $43, $0f                  ;$c545
        .byte   $4f, $10, $c3, $15, $1f, $4f, $10, $c3                  ;$c54d
        .byte   $15, $1f, $4f, $04, $30, $04, $35, $4f                  ;$c555
        .byte   $10, $c3, $15, $1f, $4f, $10, $c3, $15                  ;$c55d
        .byte   $1f, $4f, $03, $23, $03, $24, $4f, $10                  ;$c565
        .byte   $c3, $16, $60, $7f, $06, $06, $06, $28                  ;$c56d
        .byte   $28, $28, $f5, $02, $18, $10, $c3, $15                  ;$c575
        .byte   $1f, $f5, $02, $18, $10, $c3, $15, $1f                  ;$c57d
        .byte   $f5, $04, $30, $10, $c3, $15, $1f, $f5                  ;$c585
        .byte   $02, $18, $10, $c3, $15, $1f, $ff, $f3                  ;$c58d
        .byte   $08, $61, $f3, $07, $e9, $7d, $11, $11                  ;$c595
        .byte   $41, $04, $08, $04, $68, $6c, $48, $f3                  ;$c59d
        .byte   $07, $77, $84, $0b, $30, $0e, $ef, $84                  ;$c5a5
        .byte   $0b, $30, $0e, $ef, $f4, $0e, $ef, $12                  ;$c5ad
        .byte   $d1, $f5, $12, $d1, $16, $60, $07, $77                  ;$c5b5
        .byte   $f4, $16, $60, $1d, $df, $f1, $12, $d1                  ;$c5bd
        .byte   $31, $0e, $ef, $09, $68, $1f, $0b, $30                  ;$c5c5
        .byte   $3f, $07, $77, $1f, $09, $68, $18, $0b                  ;$c5cd
        .byte   $30, $18, $0e, $ef, $1f, $12, $d1, $f3                  ;$c5d5
        .byte   $07, $77, $f1, $16, $60, $f1, $12, $d1                  ;$c5dd
        .byte   $f5, $0e, $ef, $1d, $df, $07, $77, $f1                  ;$c5e5
        .byte   $0b, $30, $32, $21, $87, $07, $0c, $1f                  ;$c5ed
        .byte   $0a, $8f, $18, $0e, $18, $18, $10, $c3                  ;$c5f5
        .byte   $5f, $15, $1f, $1c, $31, $07, $0c, $4f                  ;$c5fd
        .byte   $1c, $31, $21, $87, $1f, $15, $1f, $7f                  ;$c605
        .byte   $04, $04, $a0, $88, $09, $0b, $31, $10                  ;$c60d
        .byte   $c3, $05, $47, $1f, $0e, $18, $1f, $0a                  ;$c615
        .byte   $8f, $83, $03, $86, $81, $0e, $18, $81                  ;$c61d
        .byte   $10, $c3, $81, $15, $1f, $31, $1c, $31                  ;$c625
        .byte   $04, $30, $18, $21, $87, $18, $2a, $3e                  ;$c62d
        .byte   $18, $38, $63, $18, $43, $0f, $83, $05                  ;$c635
        .byte   $47, $81, $38, $63, $81, $2a, $3e, $81                  ;$c63d
        .byte   $21, $87, $31, $1c, $31, $07, $0c, $18                  ;$c645
        .byte   $15, $1f, $18, $10, $c3, $18, $0e, $18                  ;$c64d
        .byte   $78, $04, $08, $04, $68, $6c, $48, $f3                  ;$c655
        .byte   $07, $77, $84, $0b, $30, $0e, $ef, $84                  ;$c65d
        .byte   $0b, $30, $0e, $ef, $f4, $0e, $ef, $12                  ;$c665
        .byte   $d1, $f5, $12, $d1, $16, $60, $07, $77                  ;$c66d
        .byte   $f4, $16, $60, $1d, $df, $f1, $12, $d1                  ;$c675
        .byte   $31, $0e, $ef, $09, $68, $1f, $0b, $30                  ;$c67d
        .byte   $3f, $07, $77, $1f, $09, $68, $18, $0b                  ;$c685
        .byte   $30, $18, $0e, $ef, $1f, $12, $d1, $f3                  ;$c68d
        .byte   $07, $77, $f4, $16, $60, $1c, $31, $f1                  ;$c695
        .byte   $12, $d1, $f5, $0e, $ef, $1d, $df, $09                  ;$c69d
        .byte   $68, $f1, $0b, $30, $32, $23, $86, $07                  ;$c6a5
        .byte   $0c, $1f, $0a, $8f, $18, $0e, $18, $18                  ;$c6ad
        .byte   $11, $c3, $1f, $15, $1f, $f3, $08, $e1                  ;$c6b5
        .byte   $f1, $1c, $31, $f1, $15, $1f, $31, $11                  ;$c6bd
        .byte   $c3, $0a, $8f, $1f, $0e, $18, $7f, $06                  ;$c6c5
        .byte   $06, $a0, $88, $6b, $0b, $31, $0a, $8f                  ;$c6cd
        .byte   $03, $86, $18, $0e, $18, $18, $11, $c3                  ;$c6d5
        .byte   $18, $15, $1f, $18, $1c, $31, $83, $04                  ;$c6dd
        .byte   $70, $81, $23, $86, $81, $2a, $3e, $81                  ;$c6e5
        .byte   $38, $63, $31, $47, $0c, $05, $47, $18                  ;$c6ed
        .byte   $38, $63, $18, $2a, $3e, $18, $23, $86                  ;$c6f5
        .byte   $d8, $11, $21, $41, $85, $1c, $31, $23                  ;$c6fd
        .byte   $86, $07, $0c, $81, $15, $1f, $81, $11                  ;$c705
        .byte   $c3, $81, $0e, $18, $27, $06, $06, $06                  ;$c70d
        .byte   $48, $6b, $48, $25, $a2, $f3, $09, $68                  ;$c715
        .byte   $13, $12, $d1, $17, $b5, $3f, $12, $d1                  ;$c71d
        .byte   $f1, $17, $b5, $f3, $09, $68, $f5, $17                  ;$c725
        .byte   $b5, $1c, $31, $12, $d1, $13, $12, $d1                  ;$c72d
        .byte   $17, $b5, $3f, $09, $68, $3f, $12, $d1                  ;$c735
        .byte   $f1, $17, $b5, $13, $09, $68, $17, $b5                  ;$c73d
        .byte   $3f, $12, $d1, $f1, $17, $b5, $13, $12                  ;$c745
        .byte   $d1, $17, $b5, $3f, $09, $68, $f1, $17                  ;$c74d
        .byte   $b5, $13, $12, $d1, $17, $b5, $3f, $12                  ;$c755
        .byte   $d1, $f1, $17, $b5, $f5, $17, $b5, $1c                  ;$c75d
        .byte   $31, $09, $68, $f5, $17, $b5, $25, $a2                  ;$c765
        .byte   $12, $d1, $f5, $17, $b5, $27, $df, $09                  ;$c76d
        .byte   $f7, $13, $13, $ef, $17, $b5, $3f, $13                  ;$c775
        .byte   $ef, $f1, $17, $b5, $f3, $09, $f7, $f5                  ;$c77d
        .byte   $17, $b5, $1d, $df, $13, $ef, $13, $13                  ;$c785
        .byte   $ef, $17, $b5, $3f, $09, $f7, $3f, $13                  ;$c78d
        .byte   $ef, $f1, $17, $b5, $13, $09, $f7, $17                  ;$c795
        .byte   $b5, $3f, $13, $ef, $f1, $17, $b5, $13                  ;$c79d
        .byte   $13, $ef, $17, $b5, $3f, $09, $f7, $f1                  ;$c7a5
        .byte   $17, $b5, $7d, $21, $41, $41, $06, $06                  ;$c7ad
        .byte   $06, $28, $6b, $28, $f5, $17, $b5, $1d                  ;$c7b5
        .byte   $df, $13, $ef, $13, $13, $ef, $17, $b5                  ;$c7bd
        .byte   $5f, $17, $b5, $27, $df, $09, $f7, $3f                  ;$c7c5
        .byte   $17, $b5, $f1, $17, $b5, $32, $2a, $3e                  ;$c7cd
        .byte   $09, $68, $3f, $0e, $18, $f1, $15, $1f                  ;$c7d5
        .byte   $13, $12, $d1, $17, $b5, $3f, $09, $68                  ;$c7dd
        .byte   $5f, $15, $1f, $1f, $a5, $0e, $18, $3f                  ;$c7e5
        .byte   $12, $d1, $f1, $17, $b5, $f3, $09, $68                  ;$c7ed
        .byte   $13, $0e, $18, $15, $1f, $3f, $12, $d1                  ;$c7f5
        .byte   $f1, $17, $b5, $f3, $09, $68, $13, $0e                  ;$c7fd
        .byte   $18, $15, $1f, $3f, $12, $d1, $f1, $17                  ;$c805
        .byte   $b5, $32, $1f, $a5, $09, $68, $3f, $0e                  ;$c80d
        .byte   $18, $81, $15, $1f, $82, $2a, $3e, $13                  ;$c815
        .byte   $12, $d1, $17, $b5, $7f, $06, $06, $06                  ;$c81d
        .byte   $48, $48, $9b, $f5, $17, $b5, $21, $87                  ;$c825
        .byte   $09, $68, $85, $04, $b4, $05, $98, $2c                  ;$c82d
        .byte   $c1, $84, $05, $47, $06, $47, $84, $05                  ;$c835
        .byte   $98, $07, $0c, $84, $06, $47, $07, $e9                  ;$c83d
        .byte   $84, $07, $c0, $08, $61, $84, $07, $e9                  ;$c845
        .byte   $09, $68, $84, $08, $61, $0a, $8f, $84                  ;$c84d
        .byte   $09, $68, $0b, $30, $84, $0a, $8f, $0c                  ;$c855
        .byte   $8f, $84, $0b, $30, $0e, $18, $84, $0c                  ;$c85d
        .byte   $8f, $0f, $d2, $84, $0e, $18, $10, $c3                  ;$c865
        .byte   $85, $0f, $d2, $12, $d1, $2a, $3e, $84                  ;$c86d
        .byte   $10, $c3, $15, $1f, $85, $12, $d1, $16                  ;$c875
        .byte   $60, $2c, $c1, $84, $1c, $31, $21, $87                  ;$c87d
        .byte   $57, $03, $03, $06, $29, $29, $9c, $19                  ;$c885
        .byte   $1e, $1f, $a5, $32, $3c, $48, $12, $d1                  ;$c88d
        .byte   $19, $1e, $48, $0f, $d2, $12, $d1, $48                  ;$c895
        .byte   $0c, $8f, $0f, $d2, $48, $16, $60, $1c                  ;$c89d
        .byte   $31, $48, $10, $c3, $16, $60, $48, $0e                  ;$c8a5
        .byte   $18, $10, $c3, $48, $0b, $30, $0e, $18                  ;$c8ad
        .byte   $58, $15, $1f, $19, $1e, $19, $23, $48                  ;$c8b5
        .byte   $0f, $d2, $15, $1f, $48, $0c, $8f, $0f                  ;$c8bd
        .byte   $d2, $48, $0a, $8f, $0c, $8f, $48, $0f                  ;$c8c5
        .byte   $d2, $16, $60, $48, $0c, $8f, $12, $d1                  ;$c8cd
        .byte   $48, $09, $68, $0f, $d2, $48, $06, $47                  ;$c8d5
        .byte   $09, $68, $78, $30, $30, $06, $39, $39                  ;$c8dd
        .byte   $4b, $f4, $04, $30, $04, $35, $85, $10                  ;$c8e5
        .byte   $c3, $15, $1f, $19, $1e, $83, $19, $1e                  ;$c8ed
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$c8f5
        .byte   $04, $30, $04, $35, $2a, $3e, $f5, $10                  ;$c8fd
        .byte   $c3, $15, $1f, $32, $3c, $f4, $10, $c3                  ;$c905
        .byte   $15, $1f, $f4, $04, $30, $04, $35, $f4                  ;$c90d
        .byte   $10, $c3, $15, $1f, $f4, $03, $23, $03                  ;$c915
        .byte   $24, $85, $10, $c3, $16, $60, $25, $a2                  ;$c91d
        .byte   $83, $25, $a2, $f5, $10, $c3, $16, $60                  ;$c925
        .byte   $2c, $c1, $f5, $03, $23, $03, $24, $32                  ;$c92d
        .byte   $3c, $f5, $10, $c3, $16, $60, $38, $63                  ;$c935
        .byte   $f5, $10, $c3, $16, $60, $32, $3c, $f5                  ;$c93d
        .byte   $03, $23, $03, $24, $2a, $3e, $f5, $10                  ;$c945
        .byte   $c3, $16, $60, $25, $a2, $f5, $04, $30                  ;$c94d
        .byte   $04, $35, $2a, $3e, $f5, $10, $c3, $15                  ;$c955
        .byte   $1f, $21, $87, $f5, $10, $c3, $15, $1f                  ;$c95d
        .byte   $19, $1e, $f5, $04, $30, $04, $35, $19                  ;$c965
        .byte   $1e, $f4, $10, $c3, $15, $1f, $f4, $10                  ;$c96d
        .byte   $c3, $15, $1f, $85, $04, $30, $04, $35                  ;$c975
        .byte   $03, $23, $83, $04, $39, $85, $10, $c3                  ;$c97d
        .byte   $15, $1f, $06, $47, $83, $08, $61, $f4                  ;$c985
        .byte   $03, $23, $03, $24, $f4, $10, $c3, $16                  ;$c98d
        .byte   $60, $f4, $10, $c3, $16, $60, $f4, $03                  ;$c995
        .byte   $23, $03, $24, $f4, $10, $c3, $16, $60                  ;$c99d
        .byte   $f4, $10, $c3, $16, $60, $85, $03, $23                  ;$c9a5
        .byte   $03, $24, $03, $25, $83, $04, $b4, $85                  ;$c9ad
        .byte   $10, $c3, $16, $60, $06, $47, $83, $09                  ;$c9b5
        .byte   $68, $f4, $04, $30, $04, $35, $85, $10                  ;$c9bd
        .byte   $c3, $15, $1f, $19, $1e, $83, $19, $1e                  ;$c9c5
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$c9cd
        .byte   $04, $30, $04, $35, $2a, $3e, $f5, $10                  ;$c9d5
        .byte   $c3, $15, $1f, $32, $3c, $f4, $10, $c3                  ;$c9dd
        .byte   $15, $1f, $f4, $04, $30, $04, $35, $85                  ;$c9e5
        .byte   $10, $c3, $15, $1f, $32, $3c, $83, $38                  ;$c9ed
        .byte   $63, $f5, $05, $98, $05, $9f, $3b, $be                  ;$c9f5
        .byte   $f5, $0b, $30, $0e, $18, $38, $63, $f4                  ;$c9fd
        .byte   $0b, $30, $0e, $18, $f5, $05, $47, $05                  ;$ca05
        .byte   $4f, $32, $3c, $f4, $0a, $8f, $0c, $8f                  ;$ca0d
        .byte   $f5, $0a, $8f, $0c, $8f, $2a, $3e, $f5                  ;$ca15
        .byte   $05, $47, $05, $4d, $32, $3c, $f5, $0a                  ;$ca1d
        .byte   $8f, $0c, $8f, $38, $63, $f5, $09, $68                  ;$ca25
        .byte   $09, $6f, $25, $a2, $f4, $12, $d1, $16                  ;$ca2d
        .byte   $60, $f4, $12, $d1, $16, $60, $f5, $12                  ;$ca35
        .byte   $d1, $16, $60, $08, $61, $f4, $12, $d1                  ;$ca3d
        .byte   $16, $60, $f5, $12, $d1, $16, $60, $07                  ;$ca45
        .byte   $e9, $f4, $12, $d1, $16, $60, $f5, $12                  ;$ca4d
        .byte   $d1, $16, $60, $07, $0c, $f5, $0c, $8f                  ;$ca55
        .byte   $0f, $d2, $06, $47, $f4, $0c, $8f, $0f                  ;$ca5d
        .byte   $d2, $f4, $0c, $8f, $0f, $d2, $f5, $0c                  ;$ca65
        .byte   $8f, $0f, $d2, $05, $98, $f4, $0c, $8f                  ;$ca6d
        .byte   $0f, $d2, $f5, $0e, $18, $10, $c3, $05                  ;$ca75
        .byte   $47, $f4, $0e, $18, $10, $c3, $f5, $02                  ;$ca7d
        .byte   $d2, $12, $d1, $04, $b4, $f4, $04, $30                  ;$ca85
        .byte   $04, $35, $85, $10, $c3, $15, $1f, $19                  ;$ca8d
        .byte   $1e, $83, $19, $1e, $f5, $10, $c3, $15                  ;$ca95
        .byte   $1f, $21, $87, $f5, $04, $30, $04, $35                  ;$ca9d
        .byte   $2a, $3e, $f5, $10, $c3, $15, $1f, $32                  ;$caa5
        .byte   $3c, $f4, $10, $c3, $15, $1f, $f4, $04                  ;$caad
        .byte   $30, $04, $35, $f4, $10, $c3, $15, $1f                  ;$cab5
        .byte   $f4, $03, $23, $03, $24, $85, $10, $c3                  ;$cabd
        .byte   $16, $60, $25, $a2, $83, $25, $a2, $f5                  ;$cac5
        .byte   $10, $c3, $16, $60, $2c, $c1, $f5, $03                  ;$cacd
        .byte   $23, $03, $24, $32, $3c, $f5, $10, $c3                  ;$cad5
        .byte   $16, $60, $38, $63, $f5, $10, $c3, $16                  ;$cadd
        .byte   $60, $32, $3c, $f5, $03, $23, $03, $24                  ;$cae5
        .byte   $2a, $3e, $f5, $10, $c3, $16, $60, $25                  ;$caed
        .byte   $a2, $f5, $04, $30, $04, $35, $2a, $3e                  ;$caf5
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$cafd
        .byte   $10, $c3, $15, $1f, $19, $1e, $f5, $04                  ;$cb05
        .byte   $30, $04, $35, $38, $63, $f4, $10, $c3                  ;$cb0d
        .byte   $15, $1f, $f4, $10, $c3, $15, $1f, $f4                  ;$cb15
        .byte   $04, $30, $04, $35, $f4, $10, $c3, $15                  ;$cb1d
        .byte   $1f, $f5, $04, $b4, $04, $b8, $25, $a2                  ;$cb25
        .byte   $f4, $12, $d1, $16, $60, $f4, $12, $d1                  ;$cb2d
        .byte   $16, $60, $f4, $09, $68, $09, $6a, $f4                  ;$cb35
        .byte   $12, $d1, $16, $60, $f4, $12, $d1, $16                  ;$cb3d
        .byte   $60, $f4, $04, $b4, $04, $b8, $57, $06                  ;$cb45
        .byte   $06, $08, $48, $48, $6b, $12, $d1, $16                  ;$cb4d
        .byte   $60, $25, $a2, $38, $2a, $3e, $58, $06                  ;$cb55
        .byte   $47, $06, $4f, $2c, $c1, $5f, $10, $c3                  ;$cb5d
        .byte   $16, $60, $2a, $3e, $4f, $10, $c3, $16                  ;$cb65
        .byte   $60, $5f, $06, $47, $06, $4f, $21, $87                  ;$cb6d
        .byte   $5f, $10, $c3, $1c, $31, $2c, $c1, $5f                  ;$cb75
        .byte   $10, $c3, $1c, $c1, $2a, $3e, $4f, $06                  ;$cb7d
        .byte   $47, $06, $4f, $5f, $0e, $18, $16, $60                  ;$cb85
        .byte   $21, $87, $df, $11, $11, $11, $f5, $1c                  ;$cb8d
        .byte   $31, $21, $87, $2c, $c1, $f5, $1c, $31                  ;$cb95
        .byte   $21, $87, $2a, $3e, $f4, $19, $1e, $1f                  ;$cb9d
        .byte   $a5, $f5, $19, $1f, $1f, $a5, $21, $87                  ;$cba5
        .byte   $f5, $16, $60, $1c, $31, $2c, $c1, $f5                  ;$cbad
        .byte   $16, $60, $1c, $31, $2a, $3e, $f4, $15                  ;$cbb5
        .byte   $1f, $19, $1e, $f5, $15, $1f, $19, $1e                  ;$cbbd
        .byte   $21, $87, $5d, $21, $41, $41, $06, $47                  ;$cbc5
        .byte   $2c, $c1, $38, $63, $18, $07, $0c, $58                  ;$cbcd
        .byte   $07, $e9, $2a, $3e, $32, $3c, $18, $08                  ;$cbd5
        .byte   $61, $18, $09, $68, $18, $0a, $8f, $58                  ;$cbdd
        .byte   $0b, $30, $21, $87, $2a, $3e, $18, $0c                  ;$cbe5
        .byte   $8f, $58, $0e, $18, $2c, $c1, $38, $63                  ;$cbed
        .byte   $18, $0f, $d2, $58, $10, $c3, $2a, $3e                  ;$cbf5
        .byte   $32, $3c, $18, $12, $d1, $18, $15, $1f                  ;$cbfd
        .byte   $18, $16, $60, $58, $19, $1e, $21, $87                  ;$cc05
        .byte   $2a, $3e, $18, $1c, $31, $58, $1f, $a5                  ;$cc0d
        .byte   $2c, $c1, $32, $3c, $5f, $1f, $a5, $2c                  ;$cc15
        .byte   $c1, $32, $3c, $58, $1f, $a5, $2c, $c1                  ;$cc1d
        .byte   $32, $3c, $58, $1f, $a5, $2c, $c1, $32                  ;$cc25
        .byte   $3c, $ff, $ff, $f5, $06, $47, $2c, $c1                  ;$cc2d
        .byte   $4b, $45, $5f, $04, $30, $2a, $3e, $43                  ;$cc35
        .byte   $0f, $18, $02, $f6, $18, $03, $23, $18                  ;$cc3d
        .byte   $02, $a3, $18, $04, $b4, $18, $04, $30                  ;$cc45
        .byte   $18, $03, $f4, $18, $04, $30, $48, $03                  ;$cc4d
        .byte   $86, $07, $0c, $48, $03, $23, $06, $47                  ;$cc55
        .byte   $48, $02, $a3, $05, $47, $48, $03, $23                  ;$cc5d
        .byte   $06, $47, $48, $04, $b4, $09, $68, $48                  ;$cc65
        .byte   $04, $30, $08, $61, $48, $03, $f4, $07                  ;$cc6d
        .byte   $e9, $48, $04, $30, $08, $61, $48, $07                  ;$cc75
        .byte   $0c, $0e, $18, $48, $05, $ed, $0b, $da                  ;$cc7d
        .byte   $48, $06, $47, $0c, $8f, $48, $08, $61                  ;$cc85
        .byte   $10, $c3, $48, $0a, $8f, $15, $1f, $ff                  ;$cc8d
        .byte   $ff, $85, $06, $47, $0f, $d2, $32, $3c                  ;$cc95
        .byte   $85, $05, $98, $0e, $18, $38, $63, $85                  ;$cc9d
        .byte   $05, $47, $0c, $8f, $3b, $be, $85, $04                  ;$cca5
        .byte   $b4, $0b, $30, $3f, $4b, $f5, $04, $30                  ;$ccad
        .byte   $0a, $8f, $43, $0f, $f5, $04, $30, $0a                  ;$ccb5
        .byte   $8f, $43, $0f, $f5, $04, $30, $0a, $8f                  ;$ccbd
        .byte   $43, $0f, $57, $08, $08, $08, $86, $86                  ;$ccc5
        .byte   $86, $04, $30, $0a, $8f, $43, $0f, $ff                  ;$cccd
        .byte   $9f, $00                                                ;$ccd5

;$CCD7