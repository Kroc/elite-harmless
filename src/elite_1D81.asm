; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.include        "c64.asm"
.include        "elite_consts.asm"

; from "text_flight.asm"
.import _0ac0:absolute
.import _0ae0:absolute

; from "text_docked.asm"
.import _0e00:absolute
.import _1a27:absolute
.import _1a41:absolute

; from "data_1D00.asm"
.import _1d06:absolute
.import _1d07:absolute
.import _1d09:absolute

; from "elite_6A00.asm"
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
.import print_token:absolute
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
.import _87b9:absolute
.import _87d0:absolute
.import _88e7:absolute
.import msgtoken_1A:absolute
.import msgtoken_1E:absolute
.import msgtoken_1F:absolute
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
.import _b148:absolute
.import _b179:absolute
.import paint_char:absolute
.import msgtoken_15:absolute
.import _b410:absolute

; from "data_hulls.asm"
.import _d000:absolute

;-------------------------------------------------------------------------------

.segment        "CODE_1D00"

_1d81:                                                                  ;$1d81
        jsr _83df
        jsr _379e
        lda # $00
        sta $96
        sta $0488
        sta $66
        lda # $ff
        sta $04e7
        sta $04e8
        sta $04e9
        ldy # $2c
        jsr _3ea1
        lda $0499
        and # %00000011
        bne _1db5
        lda $04e1
        beq _1e00
        lda $04a8
        lsr 
        bne _1e00
        jmp _3dff

_1db5:                                                                  ;$1db5
        cmp # $03
        bne _1dbc
        jmp _3daf

_1dbc:                                                                  ;$1dbc
        lda $04a8
        cmp # $02
        bne _1e00
        lda $0499
        and # %00001111
        cmp # $02
        bne _1dd6
        lda $04e1
        cmp # $05
        bcc _1e00
        jmp _3d7d

_1dd6:                                                                  ;$1dd6
        cmp # $06
        bne _1deb
        lda PSYSTEM_POS_X
        cmp # $d7
        bne _1e00
        lda PSYSTEM_POS_Y
        cmp # $54
        bne _1e00
        jmp _3d8d

_1deb:                                                                  ;$1deb
        cmp # $0a
        bne _1e00
        lda PSYSTEM_POS_X
        cmp # $3f
        bne _1e00
        lda PSYSTEM_POS_Y
        cmp # $48
        bne _1e00
        jmp _3d9b

_1e00:                                                                  ;$1e00
        lda PLAYER_CASH_pt3     ;?
        cmp # $c4
        bcc _1e11
        lda $0499
        and # %00010000
        bne _1e11
        jmp _3dc0
_1e11:                                                                  ;$1e11
        jmp _88e7

;===============================================================================

_1e14:                                                                  ;$1e14
        lda #< _87b9
        sei 
        sta $0316               ; vector for BRK routine 
        lda #> _87b9
        sta $0317               ; vector for BRK routine
        cli 
        rts 

;===============================================================================

_1e21:                                                                  ;$1e21
        .byte   $00, $01, $ff, $00
_1e25:                                                                  ;$1e25
        .byte   $00, $00, $ff, $00
_1e29:                                                                  ;$1e29
        .byte   $fb
_1e2a:                                                                  ;$1e2a
        .byte   $04, $f7, $08, $ef, $10, $df, $20, $bf
        .byte   $40, $7f, $80

;===============================================================================

_1e35:
        lda $a3
        and # %00000111
        cmp $0510
        bcc _1e41
        jmp _1ece

_1e41:
        asl 
        tay 

        lda # MEM_IO_ONLY
        jsr set_memory_layout
        
        jsr get_random_number
        cmp # $eb
        bcc _1e6a
        and # %00000011
        tax 
        lda _1e21, x
        sta $0511, y
        lda _1e25, x
        sta $0521, y
        jsr get_random_number
        and # %00000011
        tax 
        lda _1e21, x
        sta $0512, y
_1e6a:
        lda _1e29, y
        and VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        sta VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        lda VIC_SPRITE2_Y, y
        clc 
        adc $0512, y
        sta VIC_SPRITE2_Y, y
        clc 
        lda VIC_SPRITE2_X, y
        adc $0511, y
        sta $bb
        lda $0531, y
        adc $0521, y
        bpl _1e94
        lda # $48
        sta $bb
        lda # $01
_1e94:
        and # %00000001
        beq _1ea4
        lda $bb
        cmp # $50
        lda # $01
        bcc _1ea4
        lda # $00
        sta $bb
_1ea4:
        sta $0531, y
        beq _1eb3
        lda _1e2a, y
        ora VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
        sei 
        sta VIC_SPRITES_X       ;sprites 0-7 msb of x coordinate
_1eb3:
        lda $bb
        sta VIC_SPRITE2_X, y
        cli 

        lda # MEM_64K
        jsr set_memory_layout
        
        jmp _1ece

_1ec1:
;===============================================================================
.export _1ec1
        lda $f900
        sta ZP_GOATSOUP_pt1     ;?

        lda $0510
        beq _1ece
        
        jmp _1e35

        ;-----------------------------------------------------------------------

_1ece:
        ldx $048d
        jsr _3c58
        jsr _3c58
        txa 
        eor # %10000000
        tay 
        and # %10000000
        sta $69
        stx $048d
        eor # %10000000
        sta $6a
        tya 
        bpl _1eee
        eor # %11111111
        clc 
        adc # $01
_1eee:
        lsr 
        lsr 
        cmp # $08
        bcs _1ef5
        lsr 
_1ef5:
        sta $68
        ora $69
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
_1f15:
        adc # $04
        lsr 
        lsr 
        lsr 
        lsr 
        cmp # $03
        bcs _1f20
        lsr 
_1f20:
        sta $64
        ora $94
        sta $63
        lda _8d10
        beq _1f33
        lda $96
        cmp # $28
        bcs _1f33
        inc $96
_1f33:
        lda _8d15
        beq _1f3e
        dec $96
        bne _1f3e
        inc $96
_1f3e:
        lda _8d2e
        and $04cc
        beq _1f55
        ldy # $57
        jsr _7d0c
        ldy # $06
        jsr _a858
        lda # $00
        sta $0485
_1f55:
        lda $7c
        bpl _1f6b
        lda _8d36
        beq _1f6b
        ldx $04cc
        beq _1f6b
        sta $0485
        ldy # $87
        jsr _b11f
_1f6b:
        lda _8d28
        beq _1f77
        lda $7c
        bmi _1fc2
        jsr _36a6
_1f77:
        lda _8d0f
        beq _1f8b
        asl $04c3
        beq _1f8b
        ldy # $d0
        sty _a8e0
        ldy # $0d
        jsr _a858
_1f8b:
        lda _8d23
        beq _1f98
        lda # $00
        sta $0480
        jsr _923b
_1f98:
        lda _8d13
        and $04c7
        beq _1fa8
        lda $0482
        bne _1fa8
        jmp _316e

        ;-----------------------------------------------------------------------

_1fa8:
        lda _8d2a
        beq _1fb0
        jsr _8e29
_1fb0:
        lda _8d3e
        and $04c1
        beq _1fc2
        lda $67
        bne _1fc2
        dec $0481
        jsr _b0f4
_1fc2:
        lda _8d38
        and $04c5
        beq _1fd5
        eor $8d35
        beq _1fd5
        sta $0480
        jsr _9204
_1fd5:
        lda # $00
        sta $7b
        sta $97
        lda $96
        lsr 
        ror $97
        lsr 
        ror $97
        sta $98
        lda $0487
        bne _202d
        lda _8d42
        beq _202d
        lda $0488
        cmp # $f2
        bcs _202d
        ldx $0486
        lda $04a9, x
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
_2012:
        bne _201d
_2014:
        cmp # $97
        beq _201a+1
        ldy # $0a
_201a:
       .bit
        ldy # $0b
_201d:
        jsr _a858
        jsr _3cdb
        pla 
        bpl _2028
        lda # $00
_2028:
        and # %11111010
        sta $0487
_202d:
        ldx # $00
_202f:
.export _202f
        stx $9d
        lda $0452, x
        bne _2039
        jmp _21fa

        ;-----------------------------------------------------------------------

_2039:
        sta $a5
        jsr _3e87
        ldy # $24
_2040:
        lda [$59], y
        sta $0009, y
        dey 
        bpl _2040
        lda $a5
        bmi _2079
        asl 
        tay 
        lda _d000 - 2, y        ; HULL_TABLE?
        sta $57
        lda _d000 - 1, y        ; HULL_TABLE?
        sta $58
        lda $04c3
        bpl _2079
        cpy # $04
        beq _2079
        cpy # $3a
        beq _2079
        cpy # $3e
        bcs _2079
        lda $28
        and # %00100000
        bne _2079
        asl $28
        sec 
        ror $28
        ldx $a5
        jsr _a7a6
_2079:
        jsr _a2a0
        ldy # $24
_207e:
        lda $0009, y
        sta [$59], y
        dey 
        bpl _207e
        lda $28
        and # %10100000
        jsr _87b1
        bne _20e0
        lda $09
        ora $0c
        ora $0f
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
        and $0e
        bpl _2122
        cpx # $05
        beq _20c0
        ldy # $00
        lda [$57], y
        lsr 
        lsr 
        lsr 
        lsr 
        beq _2122
        adc # $01
        bne _20c5
_20c0:
        jsr get_random_number
        and # %00000111
_20c5:
        jsr _6a00
        ldy # $4e
        bcs _2110
        ldy $04ef
        adc $04b0, y
        sta $04b0, y
        tya 
        adc # $d0
        jsr _900d
        asl $2d
        sec 
        ror $2d
_20e0:
        jmp _2131

        ;-----------------------------------------------------------------------

_20e3:
        lda $f949
        and # %00000100
        bne _2107
        lda $17
        cmp # $d6
        bcc _2107
        jsr _8c7b
        lda $6d
        cmp # $59
        bcc _2107
        lda $19
        and # %01111111
        cmp # $50
        bcc _2107
_2101:
        jsr _923b
        jmp _1d81

        ;-----------------------------------------------------------------------

_2107:
        lda $96
        cmp # $05
        bcc _211a
        jmp _87d0

        ;-----------------------------------------------------------------------

_2110:
        jsr _a813
        asl $28
        sec 
        ror $28
        bne _2131
_211a:
        lda # $01
        sta $96
        lda # $05
        bne _212b
_2122:
        asl $28
        sec 
        ror $28
        lda $2c
        sec 
        ror 
_212b:
        jsr _7bd2
        jsr _a813
_2131:
        lda $2d
        bpl _2138
        jsr _b410
_2138:
        lda $a0
        bne _21ab
        jsr _a626
        jsr _363f
        bcc _21a8
        lda $0485
        beq _2153
        jsr _a80f
        ldx $9d
        ldy # $27
        jsr _7d0e
_2153:
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
_2170:
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
_2192:
        ldy # $04
        jsr _234c
        ldy # $05
        jsr _234c
        ldx $a5
        jsr _a7a6
_21a1:
        sta $2c
_21a3:
        lda $a5
        jsr _36c5
_21a8:
        jsr _9a86
_21ab:
        ldy # $23
        lda $2c
        sta [$59], y
        lda $2d
        bmi _21e2
        lda $28
        bpl _21e5
        and # %00100000
        beq _21e5
        lda $2d
        and # %01000000
        ora $04cd
        sta $04cd
        lda $048b
        ora $0482
        bne _21e2
        ldy # $0a
        lda [$57], y
        beq _21e2
        tax 
        iny 
        lda [$57], y
        tay 
        jsr _7481
        lda # $00
        jsr _900d
_21e2:
        jmp _829a

        ;-----------------------------------------------------------------------

_21e5:
        lda $a5
        bmi _21ee
        jsr _87a4
        bcc _21e2
_21ee:
        ldy # $1f
        lda $28
        sta [$59], y
        ldx $9d
        inx 
        jmp _202f

        ;-----------------------------------------------------------------------

_21fa:
        lda $04c3
        bpl _2207
        asl $04c3
        bmi _2207
        jsr _2367
_2207:
        lda $a3
        and # %00000111
        bne _227a
        ldx $04e9
        bpl _2224
        ldx $04e8
        jsr _7b61
        stx $04e8
        ldx $04e7
        jsr _7b61
        stx $04e7
_2224:
        sec 
        lda $04c4
        adc $04e9
        bcs _2230
        sta $04e9
_2230:
        lda $0482
        bne _2277
        lda $a3
        and # %00011111
        bne _2283
        lda $045f
        bne _2277
        tay 
        jsr _2c50
        bne _2277
        ldx # $1c
_2248:
        lda $f900, x
        sta $09, x
        dex 
        bpl _2248
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
_2277:
        jmp _231c

        ;-----------------------------------------------------------------------

_227a:
        lda $0482
        bne _2277
        lda $a3
        and # %00011111
_2283:
        cmp # $0a
        bne _22b5
        lda # $32
        cmp $04e9
        bcc _2292
        asl 
        jsr _900d
_2292:
        ldy # $ff
        sty $06f3
        iny 
        jsr _2c4e
        bne _231c
        jsr _2c5c
        bcs _231c
        sbc # $24
        bcc _22b2
        sta $9b
        jsr _9978
        lda $9a
        sta $06f3
        bne _231c
_22b2:
        jmp _87d0

        ;-----------------------------------------------------------------------

_22b5:
        cmp # $0f
        bne _22c2
        lda $0480
        beq _231c
        lda # $7b
        bne _2319
_22c2:
        cmp # $14
        bne _231c
        lda # $1e
        sta $0483
        lda $045f
        bne _231c
        ldy # $25
        jsr _2c50
        bne _231c
        jsr _2c5c
        eor # %11111111
        adc # $1e
        sta $0483
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
        
        lsr $04ca
        ror $04c9
_2303:
        lda $04c2
        beq _231c
        lda $98
        lsr 
        adc SHIP_FUEL
        cmp # $46
        bcc _2314
        lda # $46
_2314:
        sta SHIP_FUEL
        lda # $a0
_2319:
        jsr _900d
_231c:
        lda $0484
        beq _2330
        lda $0487
        cmp # $08
        bcs _2330
        jsr _3cfa
        lda # $00
        sta $0484
_2330:
        lda $0481
        beq _233a
        jsr _7b64
        beq _2342
_233a:
        lda $67
        beq _2345
        dec $67
        bne _2345
_2342:
        jsr _a786
_2345:
        lda $a0
        bne _2366
        jmp _2a32

;===============================================================================

_234c:
        jsr get_random_number
        bpl _2366
        tya 
        tax 
        ldy # $00
        and [$57], y
        and # %00001111
_2359:
        sta $aa
        beq _2366
_235d:
        lda # $00
        jsr _370a
        dec $aa
        bne _235d
_2366:
        rts 

_2367:
;===============================================================================
.export _2367
        lda # $c0
        sta _a8e0

        lda # $00
        sta _a8e6

        rts 

msgtoken_1B:                                                            ;$2372
        ;=======================================================================
        ; print some message from msg index $D9(217)+?
        ;
        ; "CURRUTHERS" / "FOSDYKE_SMYTHE" / "FORTESQUE"
        ;
        lda # $d9
        bne _2378               ; always branches

msgtoken_1C:                                                            ;$2376
        ;=======================================================================
        ; print some message from msg index $DC(220)+?
        ; 
        lda # $dc
_2378:
        clc 
        adc $04a8
        bne print_msg           ; always branches
        

_237e:                                                                  ;$237E
        ;=======================================================================
        ; print a message from the message table at `_1a5c` rather than the
        ; standard one (`_0e00`)
        ; 
        ; push the current state:
        pha 
        tax 
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 

        ; switch base-address of the message pool and jump into the print
        ; routine using this new address. note that in this case, X is the
        ; message-index to print
.import _1a5c

        lda # < _1a5c
        sta $5b
        lda # > _1a5c
        bne _23a0

print_msg:                                                              ;$2390
;===============================================================================
; prints one of the messages from TEXT_DOCKED, not to be
; confused with the *other* text-printing routine :|
;
;       A = index of message to print, from message table
;
; preserves A, Y & $5B/$5C
; (due to recursion)
;
.export print_msg

        pha                     ; preserve A (message index)
        tax                     ; move message index to X
        
        ; when recursing, $5B/$5C+Y represent the
        ; current position in the message data
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 

        ; load the message table
        lda #< _0e00
        sta $5b
        lda #> _0e00
_23a0:                                                                  ;$23A0
        sta $5c
        ldy # $00

_skip_msg:                                                              ;$23A4
        ;-----------------------------------------------------------------------
        ; skip over the messages until we find the one we want:
        ; -- this is insane!
        ;
.import MSG_XOR:direct

        lda [$5b], y
        eor # MSG_XOR           ;=$57 -- descramble token
        bne :+                  ; keep going if not a message terminator ($00)
        dex                     ; message has ended, decrement index
        beq _read_msgtoken      ; if we've found our message, exit loop
:       iny                     ; move to next token                    ;$23AD
        bne _skip_msg           ; if we haven't crossed the page, keep going
        inc $5c                 ; move to the next page (256 bytes)
        bne _skip_msg           ; and continue

_read_msgtoken:                                                         ;$23B4
        ;-----------------------------------------------------------------------
        iny                     ; step over the terminator byte ($00)
        bne :+                  ; did we step over the page boundary?
        inc $5c                 ; if so, move forward to next page

:       ; read and descramble a token:                                  ;$23B9
        ;
        ; tokens: (descrambled)
        ;     $00 = invalid
        ; $01-$1F = format token, function varies
        ; $20-$40 = print ASCII chars $20-$40 (space, punctuation, numbers)
        ; $41-$5A = print ASCII characters @, A-Z
        ; $5B-$80 = planet description tokens
        ; $81-$D6 = ?
        ; $D7-$FF = some pre-defined character pairs
        ;
        lda [$5b], y            ; read a token
        eor # MSG_XOR           ;=$57 -- descramble token
        beq @rts                ; has message ended? (token $00)

        jsr print_msgtoken
        jmp _read_msgtoken

@rts:   ; finished printing, clean up and exit                          ;$23C5
        ;-----------------------------------------------------------------------
        pla 
        sta $5c
        pla 
        sta $5b
        pla 
        tay 
        pla 
        rts

print_msgtoken:                                                         ;$23CF
        ;=======================================================================
        cmp # ' '               ; tokens less than $20 (space)
       .blt _format_code        ; are format codes
        
        

        bit msg_flight_flag     ; if flight string mode is off,
        bpl :+                  ; skip the next bit
       
       ; save state before we recurse
        tax 
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 
        txa 

        ; print from the commonly shared 'flight' strings
        jsr print_token
        
        jmp _2438

:                                                                       ;$23E8
        ;-----------------------------------------------------------------------
        cmp # 'z'+1             ; letters "A" to "Z"?
       .blt _2404               ; print letters, handling auto-casing

        cmp # $81               ; tokens $5B...$80?
       .blt _2441               ; handle planet description tokens
        
        cmp # $d7               ; tokens $81...$D6 are expansions,
       .blt print_msg           ; use the token as a message index
        
        ; tokens $D7 and above:
        ; (character pairs)
        sbc # $d7               ; re-index as $00...$28
        asl                     ; double, for lookup-table
        pha                     ; (put aside)
        tax                     ; use as index to table
        lda _254c, x            ; read 1st character and print it
        jsr _2404
        pla                     ; get the offset again 
        tax 
        lda _254d, x            ; read 2nd character and print it

_2404:  ; print a character                                             ;$2404
        ;-----------------------------------------------------------------------
        
        ; print the punctuation characters ($20...$40), as is
        
        cmp # '@'+1
       .blt _goto_print_char
        
        ; flag?
        bit _2f1d
        bmi _ucase
        
        ; flag?
        bit _2f19
        bmi _lcase

_ucase:                                                                 ;$2412
        ora msg_ucase           ; upper case (if enabled)
_lcase:                                                                 ;$2415
        and msg_lcase           ; lower-case (if enabled)

_goto_print_char:                                                       ;$2418
        jmp print_char

_format_code:                                                           ;$241B
        ;-----------------------------------------------------------------------
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
        tya 
        pha
        lda $5b
        pha 
        lda $5c
        pha 
        
        ; multiply token by two (lookup into table)
        txa 
        asl 
        tax 

        ; note that the lookup table is indexed two-bytes early, making an
        ; index of zero land in some code -- this is why token $00 is invalid

        ; we read an address from the table and rewrite a `jsr` instruction
        ; further down, i.e. the token is a lookup to a routine to call
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
        sta $5c
        pla 
        sta $5b
        pla 
        tay 
        rts 

_2441:  ; process msg tokens $5B..$80                                   ;$2441
        ;-----------------------------------------------------------------------
        sta $07                 ; put token aside
        
        ; put aside our current location in the text data
        tya 
        pha
        lda $5b
        pha 
        lda $5c
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
        ldx $07
        adc _3eac - $5B, x

        jsr print_msg           ; print the new message

        jmp _2438               ; clean up and exit


msgtoken_01:                                                            ;$246A
        ;=======================================================================
        lda # %00000000
       .bit

msgtoken_02:                                                            ;$246D
        ;=======================================================================
.export msgtoken_02

        lda # %00100000
        sta msg_ucase

        lda # $00
        sta _2f1d
        rts

msgtoken_08:                                                            ;$2478
        ;=======================================================================
        lda # 6
        jsr set_cursor_col

        lda # $ff
        sta _2f19

        rts 

msgtoken_09:                                                            ;$2483
        ;=======================================================================
        lda # 1
        jsr set_cursor_col

        jmp _a72f

msgtoken_0D:                                                            ;$248B
        ;=======================================================================
        ; enable the change-case flag?
        lda # $80
        sta _2f1d
        
        ; enable upper-casing
        lda # %00100000
        sta msg_ucase

        rts 

msgtoken_06:                                                            ;$2496
        ;=======================================================================
        lda # $80
        sta $34
        lda # $ff
       .bit

msgtoken_05:                                                            ;$249D
        ;=======================================================================
        lda # %00000000
        sta msg_flight_flag

        rts 

msgtoken_0E:                                                            ;$24A3
        ;=======================================================================
        lda # $80
       .bit

msgtoken_0F:                                                            ;$24A6
        ;=======================================================================
.export msgtoken_0F
        
        lda # $00
        sta _2f1b
        asl 
        sta _2f1c
        rts 

msgtoken_11:                                                            ;$24B0
        ;=======================================================================
        lda $34
        and # %10111111         ;=$BF
        sta $34

        lda # $03
        jsr print_token
        
        ldx _2f1c
        lda $0647, x
        jsr _24f3
        bcc _24c9
        dec _2f1c
_24c9:
        lda # $99
        jmp print_msg

msgtoken_12:                                                            ;$24CE
        ;=======================================================================
        jsr msgtoken_set_lowercase

        jsr get_random_number
        and # %00000011
        tay 
_24d7:
        jsr get_random_number
        and # %00111110
        tax 

        lda _254e+0, x
        jsr _2404
        
        lda _254e+1, x
        jsr _2404
        
        dey 
        bpl _24d7
        
        rts 

msgtoken_set_lowercase:                                                 ;$24ED
        ;=======================================================================
        ; msg token $13
        ;
        lda # %11011111
        sta msg_lcase

        rts 

;===============================================================================

_24f3:
        ora # %00100000
        cmp # $61
        beq _250a
        cmp # $65
        beq _250a
        cmp # $69
        beq _250a
        cmp # $6f
        beq _250a
        cmp # $75
        beq _250a
        
        clc 
_250a:  rts 
_250b:  rts 

;===============================================================================

_250c:
        .addr   msgtoken_01             ; msg token $01
        .addr   msgtoken_02             ; msg token $02
        .addr   print_token             ; msg token $03
        .addr   print_token             ; msg token $04
        .addr   msgtoken_05             ; msg token $05
        .addr   msgtoken_06             ; msg token $06
        .addr   print_char              ; msg token $07
        .addr   msgtoken_08             ; msg token $08
        .addr   msgtoken_09             ; msg token $09
        .addr   print_char              ; msg token $0A
        .addr   msgtoken_0B             ; msg token $0B
        .addr   print_char              ; msg token $0C
        .addr   msgtoken_0D             ; msg token $0D
        .addr   msgtoken_0E             ; msg token $0E
        .addr   msgtoken_0F             ; msg token $0F
        .addr   msgtoken_10             ; msg token $10
        .addr   msgtoken_11             ; msg token $11
        .addr   msgtoken_12             ; msg token $12
        .addr   msgtoken_set_lowercase  ; msg token $13
        .addr   print_char              ; msg token $14
        .addr   msgtoken_15             ; msg token $15
        .addr   msgtoken_16             ; msg token $16
        .addr   msgtoken_17             ; msg token $17
        .addr   msgtoken_18             ; msg token $18
        .addr   msgtoken_19             ; msg token $19
        .addr   msgtoken_1A             ; msg token $1A
        .addr   msgtoken_1B             ; msg token $1B
        .addr   msgtoken_1C             ; msg token $1C
        .addr   msgtoken_1D             ; msg token $1D
        .addr   msgtoken_1E             ; msg token $1E
        .addr   msgtoken_1F             ; msg token $1F
        
        ; msg token for print space. this table is not
        ; used for this as token $20 is handled already
        .addr   print_char              ; msg token $20


; message compression character pairs:
;-------------------------------------------------------------------------------

_254c:
        .byte   $0c
_254d:
        .byte   $0a
_254e:
        .byte   "ab", "ou", "se", "it"
        .byte   "il", "et", "st", "on"
        .byte   "lo", "nu", "th", "no"


; text compression character pairs:
;-------------------------------------------------------------------------------

char_pairs:                                                             ;$2566
.export char_pairs
.export char_pair1      := char_pairs+0
.export char_pair2      := char_pairs+1

.import TXT_XOR:direct

.enum   pairs
        _AL              =128 ;($80)
        _LE             ;=129  ($81)
        _XE             ;=130  ($82)
        _GE             ;=131  ($83)
        _ZA             ;=132  ($84)
        _CE             ;=133  ($85)
        _BI             ;=134  ($86)
        _SO             ;=135  ($87)
        _US             ;=136  ($88)
        _ES             ;=137  ($89)
        _AR             ;=138  ($8A)
        _MA             ;=139  ($8B)
        _IN             ;=140  ($8C)
        _DI             ;=141  ($8D)
        _RE             ;=142  ($8E)
        _A              ;=143  ($8F) note: second character is ignored
        _ER             ;=144  ($90)
        _AT             ;=145  ($91)
        _EN             ;=146  ($92)
        _BE             ;=147  ($93)
        _RA             ;=148  ($94)
        _LA             ;=149  ($95)
        _VE             ;=150  ($96)
        _TI             ;=151  ($97)
        _ED             ;=152  ($98)
        _OR             ;=153  ($99)
        _QU             ;=154  ($9A)
        _AN             ;=155  ($9B)
        _TE             ;=156  ($9C)
        _IS             ;=157  ($9D)
        _RI             ;=158  ($9E)
        _ON             ;=159  ($9F)
.endenum

.export _AL := pairs::_AL ^ TXT_XOR  ;=$A3
.export _LE := pairs::_LE ^ TXT_XOR  ;=$A2
.export _XE := pairs::_XE ^ TXT_XOR  ;=$A1
.export _GE := pairs::_GE ^ TXT_XOR  ;=$A0
.export _ZA := pairs::_ZA ^ TXT_XOR  ;=$A7
.export _CE := pairs::_CE ^ TXT_XOR  ;=$A6
.export _BI := pairs::_BI ^ TXT_XOR  ;=$A5
.export _SO := pairs::_SO ^ TXT_XOR  ;=$A4
.export _US := pairs::_US ^ TXT_XOR  ;=$AB
.export _ES := pairs::_ES ^ TXT_XOR  ;=$AA
.export _AR := pairs::_AR ^ TXT_XOR  ;=$A9
.export _MA := pairs::_MA ^ TXT_XOR  ;=$A8
.export _IN := pairs::_IN ^ TXT_XOR  ;=$AF
.export _DI := pairs::_DI ^ TXT_XOR  ;=$AE
.export _RE := pairs::_RE ^ TXT_XOR  ;=$AD
.export _A  := pairs::_A  ^ TXT_XOR  ;=$AC
.export _ER := pairs::_ER ^ TXT_XOR  ;=$B3
.export _AT := pairs::_AT ^ TXT_XOR  ;=$B2
.export _EN := pairs::_EN ^ TXT_XOR  ;=$B1
.export _BE := pairs::_BE ^ TXT_XOR  ;=$B0
.export _RA := pairs::_RA ^ TXT_XOR  ;=$B7
.export _LA := pairs::_LA ^ TXT_XOR  ;=$B6
.export _VE := pairs::_VE ^ TXT_XOR  ;=$B5
.export _TI := pairs::_TI ^ TXT_XOR  ;=$B4
.export _ED := pairs::_ED ^ TXT_XOR  ;=$BB
.export _OR := pairs::_OR ^ TXT_XOR  ;=$BA
.export _QU := pairs::_QU ^ TXT_XOR  ;=$B9
.export _AN := pairs::_AN ^ TXT_XOR  ;=$B8
.export _TE := pairs::_TE ^ TXT_XOR  ;=$BF
.export _IS := pairs::_IS ^ TXT_XOR  ;=$BE
.export _RI := pairs::_RI ^ TXT_XOR  ;=$BD
.export _ON := pairs::_ON ^ TXT_XOR  ;=$BC

        .byte   "al", "le", "xe", "ge"
        .byte   "za", "ce", "bi", "so"
        .byte   "us", "es", "ar", "ma"
        .byte   "in", "di", "re", "a?"
        .byte   "er", "at", "en", "be"
        .byte   "ra", "la", "ve", "ti"
        .byte   "ed", "or", "qu", "an"
        .byte   "te", "is", "ri", "on"

;===============================================================================

_25a6:
.export _25a6
        .byte   $3a, $30, $2e,$45                       ;":0.E"?

; 85 bytes here get copied by `_88f0` to $0490..$04E4

_25aa:
.export _25aa
        .byte   $2e                                     ;"."?
_25ab:
.export _25ab
        .byte   $6a, $61, $6d, $65, $73, $6f, $6e       ;"jameson"?
_25b2:
.export _25b2
        .byte   $0d
_25b3:
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

_25fd:
.export _25fd
        .byte   $00
_25fe:
.export _25fe
        .byte   $00

;-------------------------------------------------------------------------------

_25ff:
.export _25ff
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00
        
        .byte   $3a, $30, $2e  ;":0.E."?
        .byte   $45, $2e
_2619:
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
_267e:
.export _267e
        .byte   $00, $ff, $ff, $aa, $aa, $aa, $55, $55
        .byte   $55, $aa, $aa, $aa, $aa, $aa, $aa, $55
        .byte   $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
        .byte   $aa, $aa, $aa, $aa, $aa, $5a, $aa, $aa
        .byte   $00, $aa, $00, $00, $00, $00
_26a4:
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

_27a3:
        .byte   $5b
_27a4:
.export _27a4
        sta $2e
        and # %00001111
        tax 
        lda $35, x
_27ab:  bne _27ab               ; infinite loop, why?
        lda $2e
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda $35, x
_27b6:  bne _27b6               ; infinite loop, why?
        iny 
        lda [$5b], y
        sta $2e
        and # %00001111
        tax 
        lda $35, x
_27c2:  bne _27c2               ; infinite loop, why?
        lda $2e
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda $35, x
_27cd:  bne _27cd               ; infinite loop, why?
        jmp _9d8e               ; SPEED: jump to a jump (`_9f06`)

;===============================================================================

; unreferenced / unused?
;$27D2:
        lda $bb
        sta $6c
        asl 
        sta $6e
        asl 
        sta $70
        jsr _9a2c
        lda $0b
        sta $6d
        eor $72
_27e5:
        bmi _27e5               ; infinite loop, why??
        clc 
        lda $71
        adc $09
        sta $6b
        lda $0a
        adc # $00
        sta $6c
        jmp _9db3               ; SPEED: jump to a jump (`_9dd9`)

;===============================================================================

; unreferenced / unused?
;$27f7:
        lda $09
        sec 
        sbc $71
        sta $6b
        lda $0a
        sbc # $00
        sta $6c
_2804:  bcs _2804               ; infinite loop, why??
        eor # %11111111
        sta $6c
        lda # $01
        sbc $6b
        sta $6b
        bcc _2814
        inc $6c
_2814:
        lda $6d
        eor # %10000000
        sta $6d
        lda $0e
        sta $70
        eor $74
_2820:  bmi _2820               ; infinite loop, why??
        clc 
        lda $73
        adc $0c
        sta $6e
        lda $0d
        adc # $00
        sta $6f
        jmp _9dee               ; SPEED: jump to a jump (`_9e16`)

;===============================================================================

; unreferenced / unused?
;$2832:
        lda $0c
        sec 
        sbc $73
        sta $6e
        lda $0d
        sbc # $00
        sta $6f
_283f:  bcs _283f               ; infinite loop, why??
        eor # %11111111
        sta $6f
        lda $6e
        eor # %11111111
        adc # $01
        sta $6e
        lda $70
        eor # %10000000
        sta $70
_2853:  bcc _2853               ; infinite loop, why??
        inc $6f
        lda $76
_2859:  bmi _2859               ; inifinite loop, why??
        lda $75
        clc 
        adc $0f
        sta $bb
        lda $10
        adc # $00
        sta $99
        jmp _9e27               ; SPEED: jump to a jump (`_9e27`)

;===============================================================================

; unreferenced / unused?
;$286b:
        ldx $9a
_286d:  beq _286d               ; infinite loop, why??
        ldx # $00
_2871:
        lsr 
        inx 
        cmp $9a
        bcs _2871
        stx $9c
        jsr _99af
        ldx $9c
        lda $9b
_2880:
        asl 
        rol $99
_2883:  bmi _2883               ; infinite loop, why??
        dex 
        bne _2880
        sta $9b
        rts 

;===============================================================================

; unreferenced / unused?
;$288b:
        lda # $32
        sta $9b
        sta $99
        rts 

;===============================================================================

; unreferenced / unused?
;$2892:
        lda # $80
        sec 
        sbc $9b
        sta $0100, x
        inx 
        lda # $00
        sbc $99
        sta $0100, x
_28a2:
.export _28a4 := _28a2 + 2
        jmp $0061

;===============================================================================
        
_28a5:
.export _28a5
        .byte   $f9, $25, $f9, $4a, $f9, $6f, $f9, $94
        .byte   $f9, $b9, $f9, $de, $f9, $03, $fa, $28
        .byte   $fa, $4d, $fa, $72, $fa
        
        .byte   $80, $40, $20, $10, $08, $04, $02, $01
        .byte   $80, $40

; unused / unreferenced?
;$28c4:
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03

_28c8:  ; pixel pairs, in single step (for drawing stars?)
        .byte   %11000000       ;=$C0
        .byte   %11000000       ;=$C0
        .byte   %01100000       ;=$60
        .byte   %00110000       ;=$30
        .byte   %00011000       ;=$18
        .byte   %00001100       ;=$0C
        .byte   %00000110       ;=$06
        .byte   %00000011       ;=$03

_28d0:  ; this looks like masks for multi-colour pixels?
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03
        .byte   %11000000       ;=$C0

;===============================================================================

_28d5:
.export _28d5
        lda # $0f
        tax 
        rts 

_28d9:
;===============================================================================
.export _28d9

        jsr print_token

msgtoken_0B:                                                            ;$28DC
;===============================================================================
.export msgtoken_0B

        lda # $13
        bne _28e5

_28e0:
;===============================================================================
.export _28e0

        lda # $17
        jsr cursor_down

_28e5:
;===============================================================================
.export _28e5

        sta $6c
        sta $6e
        ldx # $00
        stx $6b
        dex 
        stx $6d
        jmp _ab91

_28f3:
;===============================================================================
.export _28f3

        jsr _811e
        sty $6c
        lda # $00
        sta $0580, y
        jmp _affa

;===============================================================================

_2900:
.export _2900
        .byte   %10000000       ;=$80
        .byte   %11000000       ;=$C0
        .byte   %11100000       ;=$E0
        .byte   %11110000       ;=$F0
        .byte   %11111000       ;=$F8
        .byte   %11111100       ;=$FC
        .byte   %11111110       ;=$FE
_2907:
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

_290f:
        jsr _3ad1
        sta $60
        txa 
        sta $06c9, y
_2918:
.export _2918
        lda $6b
        bpl _2921
        eor # %01111111
        clc 
        adc # $01
_2921:
        eor # %10000000
        tax 
        lda $6c
        and # %01111111
        cmp # $48
        bcs _2976
        lda $6c
        bpl _2934
        eor # %01111111
        adc # $01
_2934:
        sta $bb
        lda # $49
        sbc $bb
_293a:
.export _293a
        sty $06
        tay 
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
        lda $a1
        cmp # $90
        bcs _296d
        lda _28c8, x
        eor [$07], y
        sta [$07], y
        lda $a1
        cmp # $50
        bcs _2974
        dey 
        bpl _296d
        ldy # $01
_296d:
        lda _28c8, x
        eor [$07], y
        sta [$07], y
_2974:
        ldy $06
_2976:
        rts 

;===============================================================================

_2977:
.export _2977
        txa 
        adc $43
        sta $8b
        lda $44
        adc $bb
        sta $8c
        lda $a9
        beq _2998
        inc $a9
_2988:
        ldy $7e
        lda # $ff
        cmp _27a3, y
        beq _29fa
        sta _27a4, y            ; writing to code??
        inc $7e
        bne _29fa
_2998:
        lda $85
        sta $6b
        lda $86
        sta $6c
        lda $87
        sta $6d
        lda $88
        sta $6e
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
        lda $6b
        ldy $6d
        sta $6d
        sty $6b
        lda $6c
        ldy $6e
        sta $6e
        sty $6c
_29d2:
        ldy $7e
        lda _27a3, y
        cmp # $ff
        bne _29e6
        lda $6b
        sta _26a4, y
        lda $6c
        sta _27a4, y            ; writing to code??
        iny 
_29e6:
        lda $6d
        sta _26a4, y
        lda $6e
        sta _27a4, y            ; writing to code??
        iny 
        sty $7e
        jsr _ab91
        lda $a2
        bne _2988
_29fa:
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

;===============================================================================

_2a12:
.export _2a12
        ldy $050b
_2a15:
        ldx $06bc, y
        lda $06a2, y
        sta $6c
        sta $06bc, y
        txa 
        sta $6b
        sta $06a2, y
        lda $06d6, y
        sta $a1
        jsr _2918
        dey 
        bne _2a15
        rts 

;===============================================================================

_2a32:
        ldx $0486
        beq _2a40
        dex 
        bne _2a3d
        jmp _2b2d

;===============================================================================

_2a3d:
        jmp _37e9

        ;-----------------------------------------------------------------------

_2a40:
        ldy $050b
_2a43:
        jsr _3b30
        lda $9b
        lsr $2e
        ror 
        lsr $2e
        ror 
        ora # %00000001
        sta $9a
        lda $06e3, y
        sbc $97
        sta $06e3, y
        lda $06d6, y
        sta $a1
        sbc $98
        sta $06d6, y
        jsr _3992
        sta $60
        lda $2e
        adc $06c9, y
        sta $5f
        sta $9b
        lda $6c
        adc $60
        sta $60
        sta $9c
        lda $06a2, y
        sta $6b
        jsr _3997
        sta $5e
        lda $2e
        adc $06af, y
        sta $5d
        lda $6b
        adc $5e
        sta $5e
        eor $6a
        jsr _393c
        jsr _3ad1
        sta $60
        stx $5f
        eor $69
        jsr _3934
        jsr _3ad1
        sta $5e
        stx $5d
        ldx $64
        lda $60
        eor $95
        jsr _393e
        sta $9a
        jsr _3a4c
        asl $2e
        rol 
        sta $bb
        lda # $00
        ror 
        ora $bb
        jsr _3ad1
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta $9b
        lda $60
        sta $9c
        lda # $00
        sta $2e
        lda $63
        eor # %10000000
        jsr _290f
        lda $5e
        sta $6b
        sta $06a2, y
        and # %01111111
        cmp # $78
        bcs _2b0a
        lda $60
        sta $06bc, y
        sta $6c
        and # %01111111
        cmp # $78
        bcs _2b0a
        lda $06d6, y
        cmp # $10
        bcc _2b0a
        sta $a1
_2b00:
        jsr _2918
        dey 
        beq _2b09
        jmp _2a43

_2b09:
        rts 

        ;-----------------------------------------------------------------------

_2b0a:
        jsr get_random_number
        ora # %00000100
        sta $6c
        sta $06bc, y
        jsr get_random_number
        ora # %00001000
        sta $6b
        sta $06a2, y
        jsr get_random_number
        ora # %10010000
        sta $06d6, y
        sta $a1
        lda $6c
        jmp _2b00

;===============================================================================

_2b2d:
        ldy $050b
_2b30:
        jsr _3b30
        lda $9b
        lsr $2e
        ror 
        lsr $2e
        ror 
        ora # %00000001
        sta $9a
        lda $06a2, y
        sta $6b
        jsr _3997
        sta $5e
        lda $06af, y
        sbc $2e
        sta $5d
        lda $6b
        sbc $5e
        sta $5e
        jsr _3992
        sta $60
        lda $06c9, y
        sbc $2e
        sta $5f
        sta $9b
        lda $6c
        sbc $60
        sta $60
        sta $9c
        lda $06e3, y
        adc $97
        sta $06e3, y
        lda $06d6, y
        sta $a1
        adc $98
        sta $06d6, y
        lda $5e
        eor $69
        jsr _393c
        jsr _3ad1
        sta $60
        stx $5f
        eor $6a
        jsr _3934
        jsr _3ad1
        sta $5e
        stx $5d
        lda $60
        eor $95
        ldx $64
        jsr _393e
        sta $9a
        lda $5e
        sta $9c
        eor # %10000000
        jsr _3a50
        asl $2e
        rol 
        sta $bb
        lda # $00
        ror 
        ora $bb
        jsr _3ad1
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta $9b
        lda $60
        sta $9c
        lda # $00
        sta $2e
        lda $63
        jsr _290f
        lda $5e
        sta $6b
        sta $06a2, y
        lda $60
        sta $06bc, y
        sta $6c
        and # %01111111
        cmp # $6e
        bcs _2bf7
        lda $06d6, y
        cmp # $a0
        bcs _2bf7
        sta $a1
_2bed:
        jsr _2918
        dey 
        beq _2bf6
        jmp _2b30

_2bf6:
        rts 

        ;-----------------------------------------------------------------------

_2bf7:
        jsr get_random_number
        and # %01111111
        adc # $0a
        sta $06d6, y
        sta $a1
        lsr 
        bcs _2c1a
        lsr 
        lda # $fc
        ror 
        sta $6b
        sta $06a2, y
        jsr get_random_number
        sta $6c
        sta $06bc, y
        jmp _2bed

        ;-----------------------------------------------------------------------

_2c1a:
        jsr get_random_number
        sta $6b
        sta $06a2, y
        lsr 
        lda # $e6
        ror 
        sta $6c
        sta $06bc, y
        bne _2bed
_2c2d:
        lda $0009, y
        asl 
        sta $78
        lda $000a, y
        rol 
        sta $79
        lda # $00
        ror 
        sta $7a
        jsr _2d69
        sta $0b, x
_2c43:
.export _2c43
        ldy $78
        sty $09, x
        ldy $79
        sty $0a, x
        and # %01111111
        rts 

;===============================================================================

_2c4e:
.export _2c4e
        lda # $00
_2c50:
.export _2c50
        ora $f902, y
        ora $f905, y
        ora $f908, y
        and # %01111111
        rts 

;===============================================================================

_2c5c:
        lda $f901, y
        jsr _3988
        sta $9b
        lda $f904, y
        jsr _3988
        adc $9b
        bcs _2c7a
        sta $9b
        lda $f907, y
        jsr _3988
        adc $9b
        bcc _2c7c
_2c7a:
        lda # $ff
_2c7c:
        rts 

;===============================================================================

_2c7d:
        lda # $cd
        jsr print_msg

        jsr _b179
        jmp _2cc7

_2c88:
        ldx # $09
        cmp # $19
        bcs _2cee
        dex 
        cmp # $0a
        bcs _2cee
        dex 
        cmp # $02
        bcs _2cee
        dex 
        bne _2cee
_2c9b:
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
        ldy $04e9
        cpy # $80
        adc # $01
_2cc4:
        jsr _7773
_2cc7:
        lda # $7d
        jsr _6a9b
        lda # $13
        ldy $04cd
        beq _2cd7
        cpy # $32
        adc # $01
_2cd7:
        jsr _7773

        lda # $10
        jsr _6a9b
        lda $04e1
        bne _2c88
        tax 
        lda $04e0
        lsr 
        lsr 
_2cea:
        inx 
        lsr 
        bne _2cea
_2cee:
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
_2d04:
        lda $04c2
        beq _2d0e
        lda # $6f
        jsr _2d61
_2d0e:
        lda $04c1
        beq _2d18
        lda # $6c
        jsr _2d61
_2d18:
        lda # $71
        sta $ad
_2d1c:
        tay 
        ldx $0452, y
        beq _2d25
        jsr _2d61
_2d25:
        inc $ad
        lda $ad
        cmp # $75
        bcc _2d1c
        ldx # $00
_2d2f:
        stx $aa
        ldy $04a9, x
        beq _2d59
        txa 
        clc 
        adc # $60
        jsr _6a9b
        lda # $67
        ldx $aa
        ldy $04a9, x
        cpy # $8f
        bne _2d4a
        lda # $68
_2d4a:
        cpy # $97
        bne _2d50
        lda # $75
_2d50:
        cpy # $32
        bne _2d56
        lda # $76
_2d56:
        jsr _2d61
_2d59:
        ldx $aa
        inx 
        cpx # $04
        bcc _2d2f
        rts 

;===============================================================================

_2d61:
        jsr _7773
        lda # 6
        jmp set_cursor_col

;===============================================================================

_2d69:
.export _2d69
        lda $7a
        sta $9c
        and # %10000000
        sta $bb
        eor $0b, x
        bmi _2d8d
        lda $78
        clc 
        adc $09, x
        sta $78
        lda $79
        adc $0a, x
        sta $79
        lda $7a
        adc $0b, x
        and # %01111111
        ora $bb
        sta $7a
        rts 

        ;-----------------------------------------------------------------------

_2d8d:
        lda $9c
        and # %01111111
        sta $9c
        lda $09, x
        sec 
        sbc $78
        sta $78
        lda $0a, x
        sbc $79
        sta $79
        lda $0b, x
        and # %01111111
        sbc $9c
        ora # %10000000
        eor $bb
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
        ora $bb
        sta $7a
_2dc4:
        rts 

;===============================================================================

_2dc5:
.export _2dc5
        lda $0a, x
        and # %01111111
        lsr 
        sta $bb
        lda $09, x
        sec 
        sbc $bb
        sta $9b
        lda $0a, x
        sbc # $00
        sta $9c
        lda $0009, y
        sta $2e
        lda $000a, y
        and # %10000000
        sta $bb
        lda $000a, y
        and # %01111111
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        ora $bb
        eor $b1
        stx $9a
        jsr _3ad1
        sta $78
        stx $77
        ldx $9a
        lda $000a, y
        and # %01111111
        lsr 
        sta $bb
        lda $0009, y
        sec 
        sbc $bb
        sta $9b
        lda $000a, y
        sbc # $00
        sta $9c
        lda $09, x
        sta $2e
        lda $0a, x
        and # %10000000
        sta $bb
        lda $0a, x
        and # %01111111
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        ora $bb
        eor # %10000000
        eor $b1
        stx $9a
        jsr _3ad1
        sta $000a, y
        stx $09, y
        ldx $9a
        lda $77
        sta $09, x
        lda $78
        sta $0a, x
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

msg_ucase:                                                              ;$2F18
        ; a mask for converting a character A-Z to upper-case.
        ; this byte gets changed to 0 to neuter the effect
        .byte   %00100000

_2f19:
.export _2f19
        .byte   $ff

msg_flight_flag:                                                       ;$2F1A
        .byte   %00000000

_2f1b:
.export _2f1b
        .byte   $00
_2f1c:
.export _2f1c
        .byte   $00
_2f1d:
        .byte   $00

msg_lcase:                                                              ;$2F1E
        ; this byte is used to lower-case charcters, it's ANDed with the
        ; character value -- therefore its default value $FF does nothing.
        ; this byte is changed to %11011111 to enable lower-casing, which
        ; removes bit 5 ($20) from characters, e.g. $61 "A" > $41 "a"
        .byte   %11111111

_2f1f:
;===============================================================================
.export _2f1f
        lda # $0c
       .bit

msgtoken_10:                                                            ;$2F22
        ;=======================================================================
        lda # $41

print_char:                                                             ;$2F24
        ;=======================================================================
.export print_char

        stx $07

        ; disable the automatic lower-case transformation
        ldx # %11111111
        stx msg_lcase
        
        cmp # '.'
        beq _2f40
        
        cmp # ':'
        beq _2f40
        
        cmp # $0a               ;?
        beq _2f40
        
        cmp # $0c               ;?
        beq _2f40
        
        cmp # ' '
        beq _2f40

        ; $FF for all characters except ".", ":", $0A, $0C & space,
        ; otherwise $00 -- some kind of flag?
        inx 

_2f40:  stx _2f19
        ldx $07

        bit _2f1b               ; check bit 7
        bmi _2f4d               ; skip if bit 7 set (negative number)

        jmp paint_char

        ;-----------------------------------------------------------------------

_2f4d:
        bit _2f1b
        bvs _2f56

        cmp # $0c
        beq _2f63
_2f56:
        ldx _2f1c
        sta $0648, x
        ldx $07
        inc _2f1c
        clc 
        rts 

        ;-----------------------------------------------------------------------

_2f63:
        txa 
        pha 
        tya 
        pha 
_2f67:
        ldx _2f1c
        beq _2fe4
        cpx # $1f
        bcc _2fe1
        lsr $08
_2f72:
        lda $08
        bmi _2f7a
        lda # $40
        sta $08
_2f7a:
        ldy # $1d
_2f7c:
        lda $0666
        cmp # $20
        beq _2fb0
_2f83:
        dey 
        bmi _2f72
        beq _2f72
        lda $0648, y
        cmp # $20
        bne _2f83
        asl $08
        bmi _2f83
        sty $07
        ldy _2f1c
_2f98:
        lda $0648, y
        sta $0649, y
        dey 
        cpy $07
        bcs _2f98
        inc _2f1c
_2fa6:
        cmp $0648, y
        bne _2f7c
        dey 
        bpl _2fa6
        bmi _2f72
_2fb0:
        ldx # $1e
        jsr _2fd4

        lda # $0c
        jsr paint_char
        
        lda _2f1c
        sbc # $1e
        sta _2f1c
        tax 
        beq _2fe4
        ldy # $00
        inx 
_2fc8:
        lda $0667, y
        sta $0648, y
        iny 
        dex 
        bne _2fc8
        beq _2f67
_2fd4:
        ldy # $00
_2fd6:
        lda $0648, y
        jsr paint_char
        iny 
        dex 
        bne _2fd6
_2fe0:
        rts

        ;-----------------------------------------------------------------------

_2fe1:
        jsr _2fd4
_2fe4:
        stx _2f1c
        pla 
        tay 
        pla 
        tax 
        lda # $0c
       .bit
_2fee:                                                                  ;$2FEE
        ;=======================================================================
.export _2fee
        
        lda # $07
        jmp paint_char

;===============================================================================

_2ff3:
.export _2ff3
        lda #< $5770
        sta $07
        lda #> $5770
        sta $08
        jsr _30bb
        stx $78
        sta $77
        lda # $0e
        sta $06
        lda $96
        jsr _30ce
        lda # $00
        sta $9b
        sta $2e
        lda # $08
        sta $9c
        lda $68
        lsr 
        lsr 
        ora $69
        eor # %10000000
        jsr _3ad1
        jsr _3130
        lda $63
        ldx $64
        beq _302b
        sbc # $01
_302b:
        jsr _3ad1
        jsr _3130
        lda $a3
        and # %00000011
        bne _2fe0
        ldy # $00
        jsr _30bb
        stx $77
        sta $78
        ldx # $03
        stx $06
_3044:
        sty $71, x
        dex 
        bpl _3044
        ldx # $03
        lda $04e9
        lsr 
        lsr 
        sta $9a
_3052:
        sec 
        sbc # $10
        bcc _3064
        sta $9a
        lda # $10
        sta $71, x
        lda $9a
        dex 
        bpl _3052
        bmi _3068
_3064:
        lda $9a
        sta $71, x
_3068:
        lda $0071, y
        sty $2e
        jsr _30cf
        ldy $2e
        iny 
        cpy # $04
        bne _3068
        lda #< $56b0
        sta $07
        lda #> $56b0
        sta $08
        lda # $aa
        sta $77
        sta $78
        lda $04e7
        jsr _30cb
        lda $04e8
        jsr _30cb
        lda SHIP_FUEL
        jsr _30cd
        jsr _30bb
        stx $78
        sta $77
        ldx # $0b
        stx $06
        lda $0483
        jsr _30cb
        lda $0488
        jsr _30cb
        lda # $f0
        sta $06
        lda $06f3
        jsr _30cb
        jmp _7b6f

;===============================================================================

_30bb:
        ldx # $aa
        lda $a3
        and # %00001000
        and _1d09
        beq :+
        txa 
       .bit 
:       lda # $55                                                       ;$30C8
        rts 

;===============================================================================

_30cb:
        lsr 
        lsr 
_30cd:
        lsr 
_30ce:
        lsr 
_30cf:
        sta $9a
        ldx # $ff
        stx $9b
        cmp $06
        bcs _30dd
        lda $78
        bne _30df
_30dd:
        lda $77
_30df:
        sta $32
        ldy # $02
        ldx # $03
_30e5:
        lda $9a
        cmp # $04
        bcc _3109
        sbc # $04
        sta $9a
        lda $9b
_30f1:
        and $32
        sta [$07], y
        iny 
        sta [$07], y
        iny 
        sta [$07], y
        tya 
        clc 
        adc # $06
        bcc _3103
        inc $08
_3103:
        tay 
        dex 
        bmi _3122
        bpl _30e5
_3109:
        eor # %00000011
        sta $9a
        lda $9b
_310f:
        asl 
        asl 
        dec $9a
        bpl _310f
        pha 
        lda #> $63
        sta $9b
        lda #< $63
        sta $9a
        pla 
        jmp _30f1

        ;-----------------------------------------------------------------------

_3122:
        lda $07
        clc 
        adc # $40
        sta $07
        lda $08
        adc # $01
        sta $08
        rts 

;===============================================================================

_3130:
        ldy # $01
        sta $9a
_3134:
        sec 
        lda $9a
        sbc # $04
        bcs _3149
        lda # $ff
        ldx $9a
        sta $9a
        lda _28d0, x
        and # %10101010
        jmp _314d
_3149:
        sta $9a
        lda # $00
_314d:
        sta [$07], y
        iny 
        sta [$07], y
        iny 
        sta [$07], y
        iny 
        sta [$07], y
        tya 
        clc 
        adc # $05
        tay 
        cpy # $1e
        bcc _3134
        lda $07
        adc # $3f
        sta $07
        lda $08
        adc # $01
        sta $08
        rts 

;===============================================================================

_316e:
        jsr _83df
        ldx # $0b
        stx $a5
        jsr _3680
        bcs _317f
        ldx # $18
        jsr _3680
_317f:
        lda # $08
        sta $24
        lda # $c2
        sta $27
        lsr 
        sta $29
_318a:
        jsr _a2a0
        jsr _9a86
        dec $29
        bne _318a
        jsr _b410
        lda # $00
        ldx # $10
_319b:
        sta $04b0, x
        dex 
        bpl _319b
        sta $04cd
        sta $04c7
        lda $04c9
        ora $04ca
        beq _31be
        jsr get_random_number
        and # %00000111
        ora # %00000001
        sta $04c9
        lda # $00
        sta $04ca
_31be:
        lda # $46
        sta SHIP_FUEL
        jmp _2101

;===============================================================================

_31c6:
.export _31c6
        lda # $0e
        jsr print_msg

        jsr _6f82
        jsr _70a0
        lda # $00
        sta $ae
_31d5:
        jsr msgtoken_0E
        jsr _76e9
        ldx _2f1c
        lda $0e, x
        cmp # $0d
        bne _31f1
_31e4:
        dex 
        lda $0e, x
        ora # %00100000
        cmp $0648, x
        beq _31e4
        txa 
        bmi _3208
_31f1:
        jsr _6a3b
        inc $ae
        bne _31d5
        jsr _70ab
        jsr _6f82
        ldy # $06
        jsr _a858

        lda # $d7
        jmp print_msg

        ;-----------------------------------------------------------------------

_3208:
        lda ZP_SEED_pt4
        sta TSYSTEM_POS_X
        lda ZP_SEED_pt2
        sta TSYSTEM_POS_Y
        jsr _70ab
        jsr _6f82
        jsr msgtoken_0F
        jmp _877e

;===============================================================================

_321e:
        lda $09
        ora $0c
        ora $0f
        bne _322b
        lda # $50
        jsr _7bd2
_322b:
        ldx # $04
        bne _3290
_322f:
        lda # $00
        jsr _87b1
        beq _3239
        jmp _3365

        ;-----------------------------------------------------------------------

_3239:
        jsr _3293
        jsr _a813
        lda # $fa
        jmp _7bd2

        ;-----------------------------------------------------------------------

_3244:
        lda $67
        bne _321e
        lda $29
        asl 
        bmi _322f
        lsr 
        tax 
        lda _28a4, x
        sta $5b
        lda _28a5, x
        jsr _3581
        lda $37
        ora $3a
        ora $3d
        and # %01111111
        ora $36
        ora $39
        ora $3c
        bne _3299
        lda $29
        cmp # $82
        beq _321e
        ldy # $1f
        lda [$5b], y
        ; this might be a `ldy # $32`, but I don't see any jump into it
        bit _32a0+1             ;!?
        bne _327d
        ora # %10000000
        sta [$5b], y
_327d:
        lda $09
        ora $0c
        ora $0f
        bne _328a
        lda # $50
        jsr _7bd2
_328a:
        lda $29
        and # %01111111
        lsr 
        tax 
_3290:
        jsr _a7a6
_3293:
        asl $28
        sec 
        ror $28
_3298:
        rts 

        ;-----------------------------------------------------------------------

_3299:
        jsr get_random_number
        cmp # $10
        bcs _32a7
_32a0:
        ldy # $20
        lda [$5b], y
        lsr 
        bcs _32aa
_32a7:
        jmp _336e

_32aa:
        jmp _b0f4

;===============================================================================

_32ad:
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
_32da:
        jsr get_random_number
        cmp # $f0
        bcc _3298
        lda $046d
        cmp # $04
        bcs _3328
        ldx # $10
_32ea:
        lda # $f1
        jmp _370a

        ;-----------------------------------------------------------------------

_32ef:
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

_330f:
        ldy # $0e
        lda $2c
        cmp [$57], y
        bcs _3319
        inc $2c
_3319:
        cpx # $1e
        bne _3329
        lda $047a
        bne _3329
        lsr $29
        asl $29
        lsr $24
_3328:
        rts 

        ;-----------------------------------------------------------------------

_3329:
        jsr get_random_number
        lda $2d
        lsr 
        bcc _3335
        cpx # $32
        bcs _3328
_3335:
        lsr 
        bcc _3347
        ldx $04cd
        cpx # $28
        bcc _3347
        lda $2d
        ora # %00000100
        sta $2d
        lsr 
        lsr 
_3347:
        lsr 
        bcs _3357
        lsr 
        lsr 
        bcc _3351
        jmp _34bc

        ;-----------------------------------------------------------------------

_3351:
        jsr _8c7b
        jmp _34ac

        ;-----------------------------------------------------------------------

_3357:
        lsr 
        bcc _3365
        lda $045f
        beq _3365
        lda $29
        and # %10000001
        sta $29
_3365:
        ldx # $08
_3367:
        lda $09, x
        sta $35, x
        dex 
        bpl _3367
_336e:
        jsr _8c8a
        ldy # $0a
        jsr _3ab2
        sta $aa
        lda $a5
        cmp # $01
        bne _3381
        jmp _344b

        ;-----------------------------------------------------------------------

_3381:
        cmp # $0e
        bne _339a
_3385:
.export _3385
        jsr get_random_number
        cmp # $c8
        bcc _339a
        jsr get_random_number
        ldx # $17
        cmp # $64
        bcs _3397
        ldx # $11
_3397:
        jmp _32ea

        ;-----------------------------------------------------------------------

_339a:
        jsr get_random_number
        cmp # $fa
        bcc _33a8
        jsr get_random_number
        ora # %01101000
        sta $26
_33a8:
        ldy # $0e
        lda [$57], y
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
        lda $d041, x            ;TODO: HULL_DATA?
        bpl _33d6
        lda $2d
        and # %11110000
        sta $2d
        ldy # $24
        sta [$59], y
        lda # $00
        sta $29
        jmp _3706

        ;-----------------------------------------------------------------------

_33d6:
        lda $28
        and # %00000111
        beq _33fd
        sta $bb
        jsr get_random_number
        and # %00011111
        cmp $bb
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

_33fa:
        jmp _a795

        ;-----------------------------------------------------------------------

_33fd:
        lda # $00
        jsr _87b1
        and # %11100000
        bne _3434
        ldx $aa
        cpx # $a0
        bcc _3434
        ldy # $13
        lda [$57], y
        and # %11111000
        beq _3434
        lda $28
        ora # %01000000
        sta $28
        cpx # $a3
        bcc _3434
        lda [$57], y
        lsr 
        jsr _7bd2
        dec $25
        lda $67
        bne _3499
        ldy # $01
        jsr _a858
        ldy # $0f
        jmp _a858

        ;-----------------------------------------------------------------------

_3434:
        lda $10
        cmp # $03
        bcs _3442
        lda $0a
        ora $0d
        and # %11111110
        beq _3454
_3442:
        jsr get_random_number
        ora # %10000000
        cmp $29
        bcs _3454
_344b:
        jsr _35d5
        lda $aa
        eor # %10000000
_3452:
        sta $aa
_3454:
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
_346c:
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
_348d:
        lda $aa
        bmi _349a
        cmp $ab
        bcc _349a
        lda # $03
        sta $25
_3499:
        rts 

        ;-----------------------------------------------------------------------

_349a:
        and # %01111111
        cmp # $12
        bcc _34ab
        lda # $ff
        ldx $a5
        cpx # $01
        bne _34a9
        asl 
_34a9:
        sta $25
_34ab:
        rts 

        ;-----------------------------------------------------------------------

_34ac:
        ldy # $0a
        jsr _3ab2
        cmp # $98
        bcc _34b9
        ldx # $00
        stx $b1
_34b9:
        jmp _3452

;===============================================================================

_34bc:
.export _34bc
        lda # $06
        sta $b1
        lsr 
        sta $b0
        lda # $1d
        sta $ab
        lda $045f
        bne _34cf
_34cc:
        jmp _3351

        ;-----------------------------------------------------------------------

_34cf:
        jsr _357b
        lda $37
        ora $3a
        ora $3d
        and # %01111111
        bne _34cc
        jsr _8cad
        lda $9a
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
_3504:
        jsr _35d5
        jsr _34ac
_350a:
        ldx # $00
        stx $25
        inx 
        stx $24
        rts 

        ;-----------------------------------------------------------------------

_3512:
        jsr _357b
        jsr _35e8
        jsr _35e8
        jsr _8c8a
        jsr _35d5
        jmp _34ac

        ;-----------------------------------------------------------------------

_3524:
        inc $25
        lda # $7f
        sta $26
        bne _3571
_352c:
        ldx # $00
        stx $b1
        stx $27
        lda $a5
        bpl _3556
        eor $6b
        eor $6c
        asl 
        lda # $02
        ror 
        sta $26
        lda $6b
        asl 
        cmp # $0c
        bcs _350a
        lda $6c
        asl 
        lda # $02
        ror 
        sta $27
        lda $6c
        asl 
        cmp # $0c
        bcs _350a
_3556:
        stx $26
        lda $1f
        sta $6b
        lda $21
        sta $6c
        lda $23
        sta $6d
        ldy # $10
        jsr _35b3
        asl 
        cmp # $42
        bcs _3524
        jsr _350a
_3571:
        lda $3f
        bne _357a
        asl $2d
        sec 
        ror $2d
_357a:
        rts 

;===============================================================================

_357b:
        lda #< $f925
        sta $5b
        lda #> $f925
_3581:  sta $5c
        ldy # $02
        jsr _358f

        ldy # $05
        jsr _358f
        
        ldy # $08
_358f:
        lda [$5b], y
        eor # %10000000
        sta $7a

        dey 
        lda [$5b], y
        sta $79
        
        dey 
        lda [$5b], y
        sta $78
        
        sty $99
        ldx $99
        jsr _2d69
        
        ldy $99
        sta $37, x
        lda $79
        sta $36, x
        lda $78
        sta $35, x
        rts 

;===============================================================================

_35b3:
        ldx $f925, y
        stx $9a
        lda $6b
        jsr _3aa8
        ldx $f927, y
        stx $9a
        lda $6c
        jsr _3ace
        sta $9c
        stx $9b
        ldx $f929, y
        stx $9a
        lda $6d
        jmp _3ace

;===============================================================================

_35d5:
        lda $6b
        eor # %10000000
        sta $6b
        lda $6c
        eor # %10000000
        sta $6c
        lda $6d
        eor # %10000000
        sta $6d
        rts 

;===============================================================================

_35e8:
        jsr _35eb
_35eb:
        lda $f92f
        ldx # $00
        jsr _3600
        lda $f931
        ldx # $03
        jsr _3600
        lda $f933
        ldx # $06
_3600:
        asl 
        sta $9b
        lda # $00
        ror 
        eor # %10000000
        eor $37, x
        bmi _3617
        lda $9b
        adc $35, x
        sta $35, x
        bcc _3616
        inc $36, x
_3616:
        rts 

        ;-----------------------------------------------------------------------

_3617:
        lda $35, x
        sec 
        sbc $9b
        sta $35, x
        lda $36, x
        sbc # $00
        sta $36, x
        bcs _3616
        lda $35, x
        eor # %11111111
        adc # $01
        sta $35, x
        lda $36, x
        eor # %11111111
        adc # $00
        sta $36, x
        lda $37, x
        eor # %10000000
        sta $37, x
        jmp _3616

;===============================================================================

_363f:
        clc 
        lda $11
        bne _367d
        lda $a5
        bmi _367d
        lda $28
        and # %00100000
        ora $0a
        ora $0d
        bne _367d
        lda $09
        jsr _3988
        sta $9c
        lda $2e
        sta $9b
        lda $0c
        jsr _3988
        tax 
        lda $2e
        adc $9b
        sta $9b
        txa 
        adc $9c
        bcs _367e
        sta $9c
        ldy # $02
        lda [$57], y
        cmp $9c
        bne _367d
        dey 
        lda [$57], y
        cmp $9b
_367d:
        rts 

        ;-----------------------------------------------------------------------

_367e:
        clc 
        rts 

;===============================================================================

_3680:
        jsr _8447
        lda # $1c
        sta $0c
        lsr 
        sta $0f
        lda # $80
        sta $0e
        lda $7c
        asl 
        ora # %10000000
        sta $29
_3695:
.export _3695
        lda # $60
        sta $17
        ora # %10000000
        sta $1f
        lda $96
        rol 
        sta $24
        txa 
        jmp _7c6b

;===============================================================================

_36a6:
        ldx # $01
        jsr _3680
        bcc _3701
        ldx $7c
        jsr _3e87
        lda $0452, x
        jsr _36c5
        ldy # $b7
        jsr _7d0c
        dec $04cc
        ldy # $04
        jmp _a858

;===============================================================================

_36c5:
        cmp # $02
        beq _36f8
        ldy # $24
        lda [$59], y
        and # %00100000
        beq _36d4
        jsr _36f8
_36d4:
        ldy # $20
        lda [$59], y
        beq _367d
        ora # %10000000
        sta [$59], y
        ldy # $1c
        lda # $02
        sta [$59], y
        asl 
        ldy # $1e
        sta [$59], y
        lda $a5
        cmp # $0b
        bcc _36f7
        ldy # $24
        lda [$59], y
        ora # %00000100
        sta [$59], y
_36f7:
        rts 

        ;-----------------------------------------------------------------------

_36f8:
        lda $f949
        ora # %00000100
        sta $f949
        rts 

_3701:
        lda # $c9
        jmp _900d

;===============================================================================

_3706:
        ldx # $03
_3708:
.export _3708
        lda # $fe
_370a:
        sta $06
        txa 
        pha 
        lda $57
        pha 
        lda $58
        pha 
        lda $59
        pha 
        lda $5a
        pha 
        ldy # $24
_371c:
        lda $0009, y
        sta $0100, y
        lda [$59], y
        sta $0009, y
        dey 
        bpl _371c
        lda $a5
        cmp # $02
        bne _374d
        txa 
        pha 
        lda # $20
        sta $24
        ldx # $00
        lda $13
        jsr _378c
        ldx # $03
        lda $15
        jsr _378c
        ldx # $06
        lda $17
        jsr _378c
        pla 
        tax 
_374d:
        lda $06
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
        sta $24
        lda # $ff
        ror 
        sta $26
        pla 
_3770:
        jsr _7c6b
        pla 
        sta $5a
        pla 
        sta $59
        ldx # $24
_377b:
        lda $0100, x
        sta $09, x
        dex 
        bpl _377b
        pla 
        sta $58
        pla 
        sta $57
        pla 
        tax 
        rts 

;===============================================================================

_378c:
        asl 
        sta $9b
        lda # $00
        ror 
        jmp _a44c

_3795:
.export _3795
        jsr _a839
        lda # $04
        jsr _37a5
        rts 

;===============================================================================

_379e:
.export _379e
        ldy # $04
        jsr _a858
        lda # $08
_37a5:
        sta $ac
        lda $a0
        pha 
        lda # $00
        jsr _a72f
        pla 
        sta $a0
_37b2:
.export _37b2
        ldx # $80
        stx $35
        ldx # $48
        stx $43
        ldx # $00
        stx $ad
        stx $36
        stx $44
_37c2:
        jsr _37ce
        inc $ad
        ldx $ad
        cpx # $08
        bne _37c2
        rts 

;===============================================================================

_37ce:
        lda $ad
        and # %00000111
        clc 
        adc # $08
        sta $77
_37d7:
        lda # $01
        sta $7e
        jsr _805e
        asl $77
        bcs _37e8
        lda $77
        cmp # $a0
        bcc _37d7
_37e8:
        rts 

;===============================================================================

_37e9:
        lda # $00
        cpx # $02
        ror 
        sta $b0
        eor # %10000000
        sta $b1
        jsr _38a3
        ldy $050b
_37fa:
        lda $06d6, y
        sta $a1
        lsr 
        lsr 
        lsr 
        jsr _3b33
        lda $2e
        sta $ba
        eor $b1
        sta $9c
        lda $06af, y
        sta $2e
        lda $06a2, y
        sta $6b
        jsr _3ad1
        sta $9c
        stx $9b
        lda $06bc, y
        sta $6c
        eor $94
        ldx $64
        jsr _393e
        jsr _3ad1
        stx $5d
        sta $5e
        ldx $06c9, y
        stx $9b
        ldx $6c
        stx $9c
        ldx $64
        eor $95
        jsr _393e
        jsr _3ad1
        stx $5f
        sta $60
        ldx $68
        eor $69
        jsr _393e
        sta $9a
        lda $5d
        sta $9b
        lda $5e
        sta $9c
        eor # %10000000
        jsr _3ace
        sta $5e
        txa 
        sta $06af, y
        lda $5f
        sta $9b
        lda $60
        sta $9c
        jsr _3ace
        sta $9c
        stx $9b
        lda # $00
        sta $2e
        lda $a6
        jsr _290f
        lda $5e
        sta $06a2, y
        sta $6b
        and # %01111111
        eor # %01111111
        cmp $ba
        bcc _38be
        beq _38be
        lda $60
        sta $06bc, y
        sta $6c
        and # %01111111
_3895:
.export _3895
        cmp # $74
        bcs _38d1
_389a:
        jsr _2918
        dey 
        beq _38a3
        jmp _37fa

        ;-----------------------------------------------------------------------

_38a3:
        lda $a6
        eor $b0
        sta $a6
        lda $69
        eor $b0
        sta $69
        eor # %10000000
        sta $6a
        lda $94
        eor $b0
        sta $94
        eor # %10000000
        sta $95
        rts 

        ;-----------------------------------------------------------------------

_38be:
        jsr get_random_number
        sta $6c
        sta $06bc, y
        lda # $73
        ora $b0
        sta $6b
        sta $06a2, y
        bne _38e2
_38d1:
        jsr get_random_number
        sta $6b
        sta $06a2, y
        lda # $6e
        ora $6a
        sta $6c
        sta $06bc, y
_38e2:
        jsr get_random_number
        ora # %00001000
        sta $a1
        sta $06d6, y
        bne _389a
_38ee:
        sta $77
        sta $78
        sta $79
        sta $7a
        clc 
        rts 

        ;-----------------------------------------------------------------------

_38f8:
.export _38f8
        sta $9b
        and # %01111111
        sta $79
        lda $9a
        and # %01111111
        beq _38ee
        sec 
        sbc # $01
        sta $bb
        lda $2f
        lsr $79
        ror 
        sta $78
        lda $2e
        ror 
        sta $77
        lda # $00
        ldx # $18
_3919:
        bcc _391d
        adc $bb
_391d:
        ror 
        ror $79
        ror $78
        ror $77
        dex 
        bne _3919
        sta $bb
        lda $9b
        eor $9a
        and # %10000000
        ora $bb
        sta $7a
        rts 

;===============================================================================

_3934:
        ldx $5d
        stx $9b
        ldx $5e
        stx $9c
_393c:
        ldx $68
_393e:
        stx $2e
        tax 
        and # %10000000
        sta $bb
        txa 
        and # %01111111
        beq _3981
        tax 
        dex 
        stx $06
        lda # $00
        lsr $2e
        bcc _3956
        adc $06
_3956:
        ror 
        ror $2e
        bcc _395d
        adc $06
_395d:
        ror 
        ror $2e
        bcc _3964
        adc $06
_3964:
        ror 
        ror $2e
        bcc _396b
        adc $06
_396b:
        ror 
        ror $2e
        bcc _3972
        adc $06
_3972:
        ror 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        ora $bb
        rts 

        ;-----------------------------------------------------------------------

_3981:
        sta $2f
        sta $2e
        rts 

;===============================================================================

_3986:
.export _3986
        and # %01111111
_3988:
.export _3988
        sta $2e
        tax 
        bne _399f
_398d:
        clc 
        stx $2e
        txa 
        rts 

        ;-----------------------------------------------------------------------

_3992:
        lda $06bc, y
        sta $6c
_3997:
        and # %01111111
        sta $2e
_399b:
.export _399b
        ldx $9a
        beq _398d
_399f:
        dex 
        stx $bb
        lda # $00
        tax 
        lsr $2e
        bcc _39ab
        adc $bb
_39ab:
        ror 
        ror $2e
        bcc _39b2
        adc $bb
_39b2:
        ror 
        ror $2e
        bcc _39b9
        adc $bb
_39b9:
        ror 
        ror $2e
        bcc _39c0
        adc $bb
_39c0:
        ror 
        ror $2e
        bcc _39c7
        adc $bb
_39c7:
        ror 
        ror $2e
        bcc _39ce
        adc $bb
_39ce:
        ror 
        ror $2e
        bcc _39d5
        adc $bb
_39d5:
        ror 
        ror $2e
        bcc _39dc
        adc $bb
_39dc:
        ror 
        ror $2e
        rts 

;===============================================================================

_39e0:
.export _39e0
        and # %00011111
        tax 
        lda _0ac0, x
        sta $9a
        lda $77
_39ea:
.export _39ea
        stx $2e
        sta $b6
        tax 
        beq _3a1d
        lda _9400, x
        ldx $9a
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
        ldx $2e
        rts 

        ;-----------------------------------------------------------------------

_3a0f:
        lda _9300, x
        ldx $b6
        adc _9300, x
        bcc _3a20
        tax 
        lda _9600, x
_3a1d:
        ldx $2e
        rts 

        ;-----------------------------------------------------------------------

_3a20:
        lda # $00
        ldx $2e
        rts 

;===============================================================================

_3a25:
.export _3a25
        stx $9a
_3a27:
.export _3a27
        eor # %11111111
        lsr 
        sta $2f
        lda # $00
        ldx # $10
        ror $2e
_3a32:
        bcs _3a3f
        adc $9a
        ror 
        ror $2f
        ror $2e
        dex 
        bne _3a32
        rts 

        ;-----------------------------------------------------------------------

_3a3f:
        lsr 
        ror $2f
        ror $2e
        dex 
        bne _3a32
        rts 

;===============================================================================

; unused / unreferenced?
;$3a48
        ldx $68
        stx $2e
_3a4c:
        ldx $5e
        stx $9c
_3a50:
        ldx $5d
        stx $9b
_3a54:
        tax 
        and # %01111111
        lsr 
        sta $2e
        txa 
        eor $9a
        and # %10000000
        sta $bb
        lda $9a
        and # %01111111
        beq _3aa5
        tax 
        dex 
        stx $06
        lda # $00
        tax 
        bcc _3a72
        adc $06
_3a72:
        ror 
        ror $2e
        bcc _3a79
        adc $06
_3a79:
        ror 
        ror $2e
        bcc _3a80
        adc $06
_3a80:
        ror 
        ror $2e
        bcc _3a87
        adc $06
_3a87:
        ror 
        ror $2e
        bcc _3a8e
        adc $06
_3a8e:
        ror 
        ror $2e
        bcc _3a95
        adc $06
_3a95:
        ror 
        ror $2e
        bcc _3a9c
        adc $06
_3a9c:
        ror 
        ror $2e
        lsr 
        ror $2e
        ora $bb
        rts 

_3aa5:
        sta $2e
        rts 

;===============================================================================

_3aa8:
.export _3aa8
        jsr _3a54
        sta $9c
        lda $2e
        sta $9b
        rts 

;===============================================================================

_3ab2:
        ldx $09, y
        stx $9a
        lda $6b
        jsr _3aa8
        ldx $0b, y
        stx $9a
        lda $6c
        jsr _3ace
        sta $9c
        stx $9b
        ldx $0d, y
        stx $9a
        lda $6d
_3ace:
.export _3ace
        jsr _3a54
_3ad1:
.export _3ad1
        sta $06
        and # %10000000
        sta $bb
        eor $9c
        bmi _3ae8
        lda $9b
        clc 
        adc $2e
        tax 
        lda $9c
        adc $06
        ora $bb
        rts 

        ;-----------------------------------------------------------------------

_3ae8:
        lda $9c
        and # %01111111
        sta $99
        lda $2e
        sec 
        sbc $9b
        tax 
        lda $06
        and # %01111111
        sbc $99
        bcs _3b0a
        sta $99
        txa 
        eor # %11111111
        adc # $01
        tax 
        lda # $00
        sbc $99
        ora # %10000000
_3b0a:
        eor $bb
        rts 

;===============================================================================

_3b0d:
.export _3b0d
        stx $9a
        eor # %10000000
        jsr _3ace
        tax 
        and # %10000000
        sta $bb
        txa 
        and # %01111111
        ldx # $fe
        stx $06
_3b20:
        asl 
        cmp # $60
        bcc _3b27
        sbc # $60
_3b27:
        rol $06
        bcs _3b20
        lda $06
        ora $bb
        rts 

;===============================================================================

_3b30:
        lda $06d6, y
_3b33:
        sta $9a
        lda $96
_3b37:
.export _3b37
        asl 
        sta $2e
        lda # $00
        rol 
        cmp $9a
        bcc _3b43
        sbc $9a
_3b43:
        rol $2e
        rol 
        cmp $9a
        bcc _3b4c
        sbc $9a
_3b4c:
        rol $2e
        rol 
        cmp $9a
        bcc _3b55
        sbc $9a
_3b55:
        rol $2e
        rol 
        cmp $9a
        bcc _3b5e
        sbc $9a
_3b5e:
        rol $2e
        rol 
        cmp $9a
        bcc _3b67
        sbc $9a
_3b67:
        rol $2e
        rol 
        cmp $9a
        bcc _3b70
        sbc $9a
_3b70:
        rol $2e
        rol 
        cmp $9a
        bcc _3b79
        sbc $9a
_3b79:
        rol $2e
        rol 
        cmp $9a
        bcc _3b82
        sbc $9a
_3b82:
        rol $2e
        ldx # $00
        sta $b6
        tax 
        beq _3ba6
        lda _9400, x
        ldx $9a
        sec 
        sbc _9400, x
        bmi _3bae
        ldx $b6
        lda _9300, x
        ldx $9a
        sbc _9300, x
        bcs _3ba9
        tax 
        lda _9500, x
_3ba6:
        sta $9b
        rts 
        
        ;-----------------------------------------------------------------------

_3ba9:
        lda # $ff
        sta $9b
        rts 

        ;-----------------------------------------------------------------------

_3bae:
        ldx $b6
        lda _9300, x
        ldx $9a
        sbc _9300, x
        bcs _3ba9
        tax 
        lda _9600, x
        sta $9b
        rts 

;===============================================================================

_3bc1:
.export _3bc1
        sta $30
        lda $0f
        ora # %00000001
        sta $9a
        lda $10
        sta $9b
        lda $11
        sta $9c
        lda $2e
        ora # %00000001
        sta $2e
        lda $30
        eor $9c
        and # %10000000
        sta $bb
        ldy # $00
        lda $30
        and # %01111111
_3be5:
        cmp # $40
        bcs _3bf1
        asl $2e
        rol $2f
        rol 
        iny 
        bne _3be5
_3bf1:
        sta $30
        lda $9c
        and # %01111111
_3bf7:
        dey 
        asl $9a
        rol $9b
        rol 
        bpl _3bf7
        sta $9a
        lda # $fe
        sta $9b
        lda $30
_3c07:
        asl 
        bcs _3c17
        cmp $9a
        bcc _3c10
        sbc $9a
_3c10:
        rol $9b
        bcs _3c07
        jmp _3c20

_3c17:
        sbc $9a
        sec 
        rol $9b
        bcs _3c07
        lda $9b
_3c20:
        lda # $00
        sta $78
        sta $79
        sta $7a
        tya 
        bpl _3c49
        lda $9b
_3c2d:
        asl 
        rol $78
        rol $79
        rol $7a
        iny 
        bne _3c2d
        sta $77
        lda $7a
        ora $bb
        sta $7a
        rts 

;===============================================================================

_3c40:
        lda $9b
        sta $77
        lda $bb
        sta $7a
        rts 

        ;-----------------------------------------------------------------------

_3c49:
        beq _3c40
        lda $9b
_3c4d:
        lsr 
        dey 
        bne _3c4d
        sta $77
        lda $bb
        sta $7a
        rts 

;===============================================================================

_3c58:
        lda $0480
        bne _3c62
        lda _1d06
        bne _3c6e
_3c62:
        txa 
        bpl _3c68
        dex 
        bmi _3c6e
_3c68:
        inx 
        bne _3c6e
        dex 
        beq _3c68
_3c6e:
        rts 

;===============================================================================

_3c6f:
.export _3c6f
        sta $bb
        txa 
        clc 
        adc $bb
        tax 
        bcc _3c7a
        ldx # $ff
_3c7a:
        bpl _3c8c
_3c7c:
        lda $bb
        rts 

        ;-----------------------------------------------------------------------

_3c7f:
.export _3c7f
        sta $bb
        txa 
        sec 
        sbc $bb
        tax 
        bcs _3c8a
        ldx # $01
_3c8a:
        bpl _3c7c
_3c8c:
        lda _1d07
        bne _3c7c
        ldx # $80
        bmi _3c7c
_3c95:
.export _3c95
        lda $2e
        eor $9a
        sta $06
        lda $9a
        beq _3cc4
        asl 
        sta $9a
        lda $2e
        asl 
        cmp $9a
        bcs _3cb2
        jsr _3cce
        sec 
_3cad:
        ldx $06
        bmi _3cc7
        rts 

        ;-----------------------------------------------------------------------

_3cb2:
        ldx $9a
        sta $9a
        stx $2e
        txa 
        jsr _3cce
        sta $bb
        lda # $40
        sbc $bb
        bcs _3cad
_3cc4:
        lda # $3f
        rts 

        ;-----------------------------------------------------------------------

_3cc7:
        sta $bb
        lda # $80
        sbc $bb
        rts 

        ;-----------------------------------------------------------------------

_3cce:
        jsr _99af
        lda $9b
        lsr 
        lsr 
        lsr 
        tax 
        lda _0ae0, x
_3cda:
        rts 

;===============================================================================

_3cdb:
        jsr get_random_number
        and # %00000111
        adc # $44
        sta $06f1
        jsr get_random_number
        and # %00000111
        adc # $7c
        sta $06f0
        lda $0488
        adc # $08
        sta $0488
        jsr _7b64
_3cfa:
        lda $a0
        bne _3cda
        lda # $20
        ldy # $e0
        jsr _3d09
        lda # $30
        ldy # $d0
_3d09:
        sta $6d
        lda $06f0
        sta $6b
        lda $06f1
        sta $6c
        lda # $8f
        sta $6e
        jsr _ab91
        lda $06f0
        sta $6b
        lda $06f1
        sta $6c
        sty $6d
        lda # $8f
        sta $6e
        jmp _ab91

;===============================================================================

_3d2f:
.export _3d2f
        lda TSYSTEM_DISTANCE_LO
        ora TSYSTEM_DISTANCE_HI
        bne _3d6f
        lda $a7
        bpl _3d6f
        ldy # $00
_3d3d:
        lda _1a27, y
        cmp $a1
        bne _3d6c
        lda _1a41, y
        and # %01111111
        cmp $04a8
        bne _3d6c
        lda _1a41, y
        bmi :+
        lda $0499
        lsr 
        bcc _3d6f
        jsr msgtoken_0E
        lda # $01
       .bit
:       lda # $b0                                                       ;$3D5F
        jsr print_msgtoken
        tya 
        jsr _237e

        lda # $b1
        bne _3d7a
_3d6c:
        dey 
        bne _3d3d
_3d6f:
        ; copy the last four bytes of the main seed to the "goat soup" seed,
        ; used for generating the planet descriptions
        ldx # $03
:       lda ZP_SEED_pt3, x                                              ;3D71
        sta ZP_GOATSOUP, x
        dex 
        bpl :-

        lda # $05
_3d7a:  jmp print_msg

;===============================================================================

_3d7d:                                                                  ;$3d7d
        lda $0499
        ora # %00000100
        sta $0499
        lda # $0b
_3d87:                                                                  ;$3d87
        jsr print_msg
_3d8a:                                                                  ;$3d8a
        jmp _88e7

;===============================================================================

_3d8d:                                                                  ;$3d8d
        lda $0499
        and # %11110000
        ora # %00001010
        sta $0499
        lda # $de
        bne _3d87
_3d9b:                                                                  ;$3d9b
        lda $0499
        ora # %00000100
        sta $0499
        lda # $02
        sta $04c4
        inc $04e1
        lda # $df
        bne _3d87
_3daf:                                                                  ;$3daf
        lsr $0499
        asl $0499
        ldx # $50
        ldy # $c3
        jsr _7481
        lda # $0f
_3dbe:                                                                  ;$3dbe
        bne _3d87
_3dc0:                                                                  ;$3dc0
        lda $0499
        ora # %00010000
        sta $0499

        lda # $c7
        jsr print_msg
        
        jsr _81ee
        bcc _3d8a
        ldy # $c3
        ldx # $50
        jsr _745a
        inc $04c9
        jmp _88e7

;===============================================================================

_3dff:                                                                  ;$3dff
        lsr $0499
        sec 
        rol $0499
        jsr msgtoken_19
        jsr _8447
        lda # $1f
        sta $a5
        jsr _7c6b

        lda # 1
        jsr set_cursor_col
        
        sta $10
        jsr _a72f
        lda # $40
        sta $a3
_3e01:                                                                  ;$3e01
        ldx # $7f
        stx $26
        stx $27
_3e07:
.export _3e08 := _3e07+1
        jsr _9a86
        jsr _a2a0
        dec $a3
        bne _3e01
_3e11:                                                                  ;$3e11
        lsr $09
        inc $0f
        beq _3e31
        inc $0f
        beq _3e31
        ldx $0c
        inx 
        cpx # $50
        bcc _3e24
        ldx # $50
_3e24:                                                                  ;$3e24
        stx $0c
        jsr _9a86
        jsr _a2a0
        dec $a3
        jmp _3e11
_3e31:                                                                  ;$3e31
        inc $10
        lda # $0a
        bne _3dbe
        
msgtoken_19:                                                            ;$3E37
        ;=======================================================================
        lda # $d8
        jsr print_msg

        ldy # $64
        jmp _3ea1

msgtoken_16:                                                            ;$3E41
        ;=======================================================================
        jsr _3e65
        bne msgtoken_16
_3e46:                                                                  ;$3e46
        jsr _3e65
        beq _3e46
        lda # $00
        sta $28
        lda # $01
        jsr _a72f
        jsr _9a86

msgtoken_17:                                                            ;$3E57  
        ;=======================================================================
        lda # $0a
       .bit

msgtoken_1D:                                                            ;$3E5A
        ;=======================================================================
        lda # $06
        jsr set_cursor_row

        jsr _250b
        
        jmp msgtoken_0D

_3e65:                                                                  ;$3E65
        ;-----------------------------------------------------------------------
        lda # $50
        sta $0c
        lda # $00
        sta $09
        sta $0f
        lda # $02
        sta $10
        jsr _9a86
        jsr _a2a0
        jmp _8d53


msgtoken_18:                                                            ;$3E7C
        ;=======================================================================
        jsr _8d53
        bne msgtoken_18

        jsr _8d53
        beq msgtoken_18
        
        rts 

;===============================================================================

_3e87:                                                                  ;$3e87
.export _3e87
        txa 
        asl 
        tay 
        lda _28a4, y
        sta $59
        lda _28a5, y
        sta $5a
        rts 

;===============================================================================

_3e95:                                                                  ;$3e95
.export _3e95
        ldx # $01
_3e97:                                                                  ;$3e97
        lda PSYSTEM_POS, x
        sta TSYSTEM_POS, x
        dex 
        bpl _3e97
        rts 

;===============================================================================

_3ea1:                                                                  ;$3ea1
.export _3ea1
        jsr _b148
        dey 
        bne _3ea1
        rts 

;===============================================================================

; unused / unreferenced?

; note that these could be a part of the planet description templates
; in the "TEXT_PDESC" segement in "text_docked.asm"

;$3EA8:

        .byte   $07, $07, $0d, $04                                      ;$3EA8

;$3EAC
