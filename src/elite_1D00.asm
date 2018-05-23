; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.import _6a00:absolute
.import _6a25:absolute
.import _745a:absolute
.import _7481:absolute
.import _777e:absolute
.import _7c6b:absolute
.import _81ee:absolute
.import _83df:absolute
.import _8447:absolute
.import _88e7:absolute
.import _8d53:absolute
.import _9a86:absolute
.import _a2a0:absolute
.import _a72f:absolute
.import _b148:absolute

;-------------------------------------------------------------------------------

.org    $1d81

.code

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
        and # $03
        bne _1db5
        lda $04e1
        beq _1e00
        lda $04a8
        lsr 
        bne _1e00
        jmp _3ddf

_1db5:                                                                  ;$1db5
        cmp # $03
        bne _1dbc
        jmp _3daf

_1dbc:                                                                  ;$1dbc
        lda $04a8
        cmp # $02
        bne _1e00
        lda $0499
        and # $0f
        cmp # $02
        bne _1dd6
        lda $04e1
        cmp # $05
        bcc _1e00
        jmp _3d7d

_1dd6:                                                                  ;$1dd6
        cmp # $06
        bne _1deb
        lda $049a
        cmp # $d7
        bne _1e00
        lda $049b
        cmp # $54
        bne _1e00
        jmp _3d8d

_1deb:                                                                  ;$1deb
        cmp # $0a
        bne _1e00
        lda $049a
        cmp # $3f
        bne _1e00
        lda $049b
        cmp # $48
        bne _1e00
        jmp _3d9b

_1e00:                                                                  ;$1e00
        lda $04a4
        cmp # $c4
        bcc _1e11
        lda $0499
        and # $10
        bne _1e11
        jmp _3dc0
_1e11:                                                                  ;$1e11
        jmp _88e7

;===============================================================================

_1e14:                                                                  ;$1e14
        lda # $b9
        sei 
        sta $0316
        lda # $87
        sta $0317
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
        and # $07
        cmp $0510
        bcc _1e41
        jmp _1ece

_1e41:
        asl 
        tay 

        lda # MEM_IO_ONLY       ;=5
        jsr _827f
        
        jsr $84af
        cmp # $eb
        bcc _1e6a
        and # $03
        tax 
        lda _1e21, x
        sta $0511, y
        lda _1e25, x
        sta $0521, y
        jsr $84af
        and # $03
        tax 
        lda _1e21, x
        sta $0512, y
_1e6a:
        lda _1e29, y
        and $d010               ;sprites 0-7 msb of x coordinate
        sta $d010               ;sprites 0-7 msb of x coordinate
        lda $d005, y            ;sprite 2 y pos
        clc 
        adc $0512, y
        sta $d005, y            ;sprite 2 y pos
        clc 
        lda $d004, y            ;sprite 2 x pos
        adc $0511, y
        sta $bb
        lda $0531, y
        adc $0521, y
        bpl _1e94
        lda # $48
        sta $bb
        lda # $01
_1e94:
        and # $01
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
        ora $d010               ;sprites 0-7 msb of x coordinate
        sei 
        sta $d010               ;sprites 0-7 msb of x coordinate
_1eb3:
        lda $bb
        sta $d004, y            ;sprite 2 x pos
        cli 

        lda # MEM_64K
        jsr _827f
        
        jmp _1ece

;===============================================================================

_1ec1:
.export _1ec1
        lda $f900
        sta $02
        lda $0510
        beq _1ece
        jmp _1e35

;===============================================================================

_1ece:
        ldx $048d
        jsr _3c58
        jsr _3c58
        txa 
        eor # $80
        tay 
        and # $80
        sta $69
        stx $048d
        eor # $80
        sta $6a
        tya 
        bpl _1eee
        eor # $ff
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
        eor # $80
        tay 
        and # $80
        stx $048e
        sta $95
        eor # $80
        sta $94
        tya 
        bpl _1f15
        eor # $ff
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
        lda $8d10
        beq _1f33
        lda $96
        cmp # $28
        bcs _1f33
        inc $96
_1f33:
        lda $8d15
        beq _1f3e
        dec $96
        bne _1f3e
        inc $96
_1f3e:
        lda $8d2e
        and $04cc
        beq _1f55
        ldy # $57
        jsr $7d0c
        ldy # $06
        jsr $a858
        lda # $00
        sta $0485
_1f55:
        lda $7c
        bpl _1f6b
        lda $8d36
        beq _1f6b
        ldx $04cc
        beq _1f6b
        sta $0485
        ldy # $87
        jsr $b11f
_1f6b:
        lda $8d28
        beq _1f77
        lda $7c
        bmi _1fc2
        jsr _36a6
_1f77:
        lda $8d0f
        beq _1f8b
        asl $04c3
        beq _1f8b
        ldy # $d0
        sty $a8e0
        ldy # $0d
        jsr $a858
_1f8b:
        lda $8d23
        beq _1f98
        lda # $00
        sta $0480
        jsr $923b
_1f98:
        lda $8d13
        and $04c7
        beq _1fa8
        lda $0482
        bne _1fa8
        jmp _316e

        ;-----------------------------------------------------------------------

_1fa8:
        lda $8d2a
        beq _1fb0
        jsr $8e29
_1fb0:
        lda $8d3e
        and $04c1
        beq _1fc2
        lda $67
        bne _1fc2
        dec $0481
        jsr $b0f4
_1fc2:
        lda $8d38
        and $04c5
        beq _1fd5
        eor $8d35
        beq _1fd5
        sta $0480
        jsr $9204
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
        lda $8d42
        beq _202d
        lda $0488
        cmp # $f2
        bcs _202d
        ldx $0486
        lda $04a9, x
        beq _202d
        pha 
        and # $7f
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
        bit $0ba0
_201d:
        jsr $a858
        jsr _3cdb
        pla 
        bpl _2028
        lda # $00
_2028:
        and # $fa
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
        lda ($59), y
        sta $0009, y
        dey 
        bpl _2040
        lda $a5
        bmi _2079
        asl 
        tay 
        lda $cffe, y
        sta $57
        lda $cfff, y
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
        and # $20
        bne _2079
        asl $28
        sec 
        ror $28
        ldx $a5
        jsr $a7a6
_2079:
        jsr _a2a0
        ldy # $24
_207e:
        lda $0009, y
        sta ($59), y
        dey 
        bpl _207e
        lda $28
        and # $a0
        jsr $87b1
        bne _20e0
        lda $09
        ora $0c
        ora $0f
        bmi _20e0
        ldx $a5
        bmi _20e0
        cpx # $02
        beq _20e3
        and # $c0
        bne _20e0
        cpx # $01
        beq _20e0
        lda $04c2
        and $0e
        bpl _2122
        cpx # $05
        beq _20c0
        ldy # $00
        lda ($57), y
        lsr 
        lsr 
        lsr 
        lsr 
        beq _2122
        adc # $01
        bne _20c5
_20c0:
        jsr $84af
        and # $07
_20c5:
        jsr _6a00
        ldy # $4e
        bcs _2110
        ldy $04ef
        adc $04b0, y
        sta $04b0, y
        tya 
        adc # $d0
        jsr $900d
        asl $2d
        sec 
        ror $2d
_20e0:
        jmp _2131

        ;-----------------------------------------------------------------------

_20e3:
        lda $f949
        and # $04
        bne _2107
        lda $17
        cmp # $d6
        bcc _2107
        jsr $8c7b
        lda $6d
        cmp # $59
        bcc _2107
        lda $19
        and # $7f
        cmp # $50
        bcc _2107
_2101:
        jsr $923b
        jmp _1d81

        ;-----------------------------------------------------------------------

_2107:
        lda $96
        cmp # $05
        bcc _211a
        jmp $87d0

        ;-----------------------------------------------------------------------

_2110:
        jsr $a813
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
        jsr $7bd2
        jsr $a813
_2131:
        lda $2d
        bpl _2138
        jsr $b410
_2138:
        lda $a0
        bne _21ab
        jsr $a626
        jsr _363f
        bcc _21a8
        lda $0485
        beq _2153
        jsr $a80f
        ldx $9d
        ldy # $27
        jsr $7d0e
_2153:
        lda $7b
        beq _21a8
        ldx # $0f
        jsr $a7e9
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
        jsr $84af
        ldx # $08
        and # $03
        jsr _2359
_2192:
        ldy # $04
        jsr _234c
        ldy # $05
        jsr _234c
        ldx $a5
        jsr $a7a6
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
        sta ($59), y
        lda $2d
        bmi _21e2
        lda $28
        bpl _21e5
        and # $20
        beq _21e5
        lda $2d
        and # $40
        ora $04cd
        sta $04cd
        lda $048b
        ora $0482
        bne _21e2
        ldy # $0a
        lda ($57), y
        beq _21e2
        tax 
        iny 
        lda ($57), y
        tay 
        jsr $7481
        lda # $00
        jsr $900d
_21e2:
        jmp $829a

        ;-----------------------------------------------------------------------

_21e5:
        lda $a5
        bmi _21ee
        jsr $87a4
        bcc _21e2
_21ee:
        ldy # $1f
        lda $28
        sta ($59), y
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
        and # $07
        bne _227a
        ldx $04e9
        bpl _2224
        ldx $04e8
        jsr $7b61
        stx $04e8
        ldx $04e7
        jsr $7b61
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
        and # $1f
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
        jsr $87a6
        bcc _2277
        jsr $80ff
        jsr $7c24
_2277:
        jmp _231c

        ;-----------------------------------------------------------------------

_227a:
        lda $0482
        bne _2277
        lda $a3
        and # $1f
_2283:
        cmp # $0a
        bne _22b5
        lda # $32
        cmp $04e9
        bcc _2292
        asl 
        jsr $900d
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
        jsr $9978
        lda $9a
        sta $06f3
        bne _231c
_22b2:
        jmp $87d0

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
        eor # $ff
        adc # $1e
        sta $0483
        bcs _22b2
        cmp # $e0
        bcc _231c
        cmp # $f0
        bcc _2303

        lda # MEM_IO_ONLY  ;=5
        jsr _827f
        
        lda VIC_SPRITE_ENABLE
        and # $03
        sta VIC_SPRITE_ENABLE
        
        lda # MEM_64K      ;=4
        jsr _827f
        
        lsr $04ca
        ror $04c9
_2303:
        lda $04c2
        beq _231c
        lda $98
        lsr 
        adc $04a6
        cmp # $46
        bcc _2314
        lda # $46
_2314:
        sta $04a6
        lda # $a0
_2319:
        jsr $900d
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
        jsr $7b64
        beq _2342
_233a:
        lda $67
        beq _2345
        dec a67
        bne _2345
_2342:
        jsr $a786
_2345:
        lda $a0
        bne _2366
        jmp _2a32

;===============================================================================

_234c:
        jsr $84af
        bpl _2366
        tya 
        tax 
        ldy # $00
        and ($57), y
        and # $0f
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

;===============================================================================

_2367:
.export $2367
        lda # $c0
        sta $a8e0
        lda # $00
        sta $a8e6
        rts 

;===============================================================================

_2372:  ; NOTE: this address is used in the table in _250c
        lda # $d9
        bne _2378

_2376:  ; NOTE: this address is used in the table in _250c
        lda # $dc
_2378:
        clc 
        adc $04a8
        bne _2390
_237e:
        pha 
        tax 
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 
        lda # $5c
        sta $5b
        lda # $1a
        bne _23a0
_2390:                                                                  ;$2390
.export _2390
        pha 
        tax 
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 
        lda #< $0e00
        sta $5b
        lda #> $0e00
_23a0:                                                                  ;$23a0
        sta $5c
        ldy # $00
_23a4:                                                                  ;$23a4
        lda ($5b), y
        eor # $57
        bne _23ad
        dex 
        beq _23b4
_23ad:                                                                  ;$23ad
        iny 
        bne _23a4
        inc $5c
        bne _23a4
_23b4:                                                                  ;$23b4
        iny 
        bne _23b9
        inc $5c
_23b9:                                                                  ;$23b9
        lda ($5b), y
        eor # $57
        beq _23c5
        jsr _23cf
        jmp _23b4

_23c5:                                                                  ;$23c5
        pla 
        sta $5c
        pla 
        sta $5b
        pla 
        tay 
        pla 
        rts
_23cf:                                                                  ;$23cf
        cmp # $20
        bcc _241b
        bit _2f1a
        bpl _23e8
        tax 
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 
        txa 
        jsr _777e
        jmp _2438
_23e8:                                                                  ;$23e8
        cmp # $5b
        bcc _2404
        cmp # $81
        bcc _2441
        cmp # $d7
        bcc _2390
        sbc # $d7
        asl 
        pha 
        tax 
        lda _254c, x
        jsr _2404
        pla 
        tax 
        lda _254d, x
_2404:                                                                  ;$2404
        cmp # $41
        bcc _2418
        bit _2f1d
        bmi _2412
        bit _2f19
        bmi _2415
_2412:                                                                  ;$2412
        ora _2f18
_2415:                                                                  ;$2415
        and _2f1e
_2418:                                                                  ;$2418
        jmp _2f24

        ;-----------------------------------------------------------------------

_241b:                                                                  ;$241b
        tax 
        tya 
        pha

        lda $5b
        pha 
        
        lda $5c
        pha 
        
        txa 
        asl 
        tax 

        ; _250c.. must be a lookup table

        lda _250c-2, x          ; X cannot be 0!?
        sta _2435+1
        lda _250c-1, x          ; X cannot be 0!?
        sta _2435+2
        txa 
        lsr
_2435:
        jsr _2f24               ; this address gets overwritten
_2438:
        pla 
        sta $5c
        pla 
        sta $5b
        pla 
        tay 
        rts 

        ;-----------------------------------------------------------------------

_2441:
        sta $07
        tya 
        pha 
        lda $5b
        pha 
        lda $5c
        pha 
        jsr $84af
        tax 
        lda # $00
        cpx # $33
        adc # $00
        cpx # $66
        adc # $00
        cpx # $99
        adc # $00
        cpx # $cc
        ldx $07
        adc _3e51, x
        jsr _2390
        jmp _2438

;===============================================================================

_246a:  ; NOTE: this address is used in the table in _250c
        lda # $00
_246c:
.export _246d := _246c+1
        bit $20a9
        sta _2f18
        lda # $00
        sta _2f1d
        rts

;===============================================================================

_2478:  ; NOTE: this address is used in the table in _250c
        lda # $06
        jsr _6a25
        lda # $ff
        sta _2f19
        rts 

;===============================================================================

_2483:  ; NOTE: this address is used in the table in _250c
        lda # $01
        jsr _6a25
        jmp _a72f

;===============================================================================

_248b:  ; NOTE: this address is used in the table in _250c
        lda # $80
        sta _2f1d
        lda # $20
        sta _2f18
        rts 

;===============================================================================

_2496:  ; NOTE: this address is used in the table in _250c
        lda # $80
        sta $34
        lda # $ff
        bit $00a9

_249d:  ; NOTE: this address is used in the table in _250c
        lda # $00
        sta _2f1a
        rts 

;===============================================================================

_24a3:  ; NOTE: this address is used in the table in _250c
        lda # $80
_24a5:
        ; NOTE: this address is used in the table in _250c
.export _24a6 := _24a5+1
        bit $00a9
        sta _2f1b
        asl 
        sta _2f1c
        rts 

;===============================================================================

_24b0:  ; NOTE: this address is used in the table in _250c
        lda $34
        and # $bf
        sta $34
        lda # $03
        jsr _777e
        ldx _2f1c
        lda $0647, x
        jsr _24f3
        bcc _24c9
        dec _2f1c
_24c9:
        lda # $99
        jmp _2390

;===============================================================================

_24ce:  ; NOTE: this address is used in the table in _250c
        jsr _24ed
        jsr $84af
        and # $03
        tay 
_24d7:
        jsr $84af
        and # $3e
        tax 
        lda _254e+0, x
        jsr _2404
        lda _254e+1, x
        jsr _2404
        dey 
        bpl _24d7
        rts 

;===============================================================================

_24ed:  ; NOTE: this address is used in the table in _250c
        lda # $df
        sta _2f1e
        rts 

;===============================================================================

_24f3:
; $24f3: 09 20       s24f3   ora # $20
; $24f5: c9 61               cmp # $61
; $24f7: f0 11               beq _250a
; $24f9: c9 65               cmp # $65
; $24fb: f0 0d               beq _250a
; $24fd: c9 69               cmp # $69
; $24ff: f0 09               beq _250a
; $2501: c9 6f               cmp # $6f
; $2503: f0 05               beq _250a
; $2505: c9 75               cmp # $75
; $2507: f0 01               beq _250a
; $2509: 18                  clc 
_250a:  ; NOTE: references to _250c, actually begin at _250a!
; $250a: 60          f250a   rts 

_250b:
        rts 

;===============================================================================

_250c:
        .addr   _246a
        .addr   _246d
        .addr   _777e
        .addr   _777e
        .addr   _249d
        .addr   _2496
        .addr   _2f24
        .addr   _2478
        .addr   _2483
        .addr   _2f24
        .addr   _28dc
        .addr   _2f24
        .addr   _248b
        .addr   _24a3
        .addr   _24a6
        .addr   _2f21+1         ; jumps into the middle of a `bit` instruction
        .addr   _24b0
        .addr   _24ce
        .addr   _24ed
        .addr   _2f24
        .addr   $b3d4
        .addr   _3e41
        .addr   _3e57
        .addr   _3e7c
        .addr   _3e37
        .addr   $85ab
        .addr   _2372
        .addr   _2376
        .addr   _3e59+1         ; jumps into the middle of a `bit` instruction
        .addr   $8ab5
        .addr   $8abe
        .addr   _2f24

;===============================================================================

_254c:
        .byte   $0c
_254d:
        .byte   $0a
_254e:
        .byte   $41, $42
; $254e: 41 42       f254e   eor (p42, x)
; $2550: 4f 55 53            sre a5355
; $2553: 45 49               eor a49
; $2555: 54 49               nop f49, x
; $2557: 4c 45 54            jmp e5445

; $255a: 53 54               sre (p54), y
; $255c: 4f 4e 4c            sre a4c4e
; $255f: 4f 4e 55            sre a554e
; $2562: 54 48               nop f48, x
; $2564: 4e 4f 41            lsr a414f
_2566:
.export _2566
_2567:
.export _2567
; $2567: 4c 4c 45            jmp e454c

; $256a: 58                  cli 
; $256b: 45 47               eor a47
; $256d: 45 5a               eor a5a
; $256f: 41 43               eor (p43, x)
; $2571: 45 42               eor a42
; $2573: 49 53               eor # $53
; $2575: 4f 55 53            sre a5355
; $2578: 45 53               eor a53
; $257a: 41 52               eor (p52, x)
; $257c: 4d 41 49            eor a4941
; $257f: 4e 44 49            lsr a4944
; $2582: 52                  jam 
; $2583: 45 41               eor a41
; $2585: 3f 45 52            rla f5245, x
; $2588: 41 54               eor (p54, x)
; $258a: 45 4e               eor a4e
; $258c: 42                  jam 
; $258d: 45 52               eor a52
; $258f: 41 4c               eor (p4c, x)
; $2591: 41 56               eor (p56, x)
; $2593: 45 54               eor a54
; $2595: 49 45               eor # $45
; $2597: 44 4f               nop a4f
; $2599: 52                  jam 
; $259a: 51 55               eor (p55), y
; $259c: 41 4e               eor (p4e, x)
; $259e: 54 45               nop f45, x
; $25a0: 49 53               eor # $53
; $25a2: 52                  jam 
; $25a3: 49 4f               eor # $4f
; $25a5: 4e 3a 30            lsr a303a
_25a6:
.export _25a6
; $25a8: 2e 45 2e            rol a2e45
_25aa:
.export _25aa
_25ab:
.export _25ab
; $25ab: 6a                  ror 
; $25ac: 61 6d               adc (p6d, x)
; $25ae: 65 73               adc a73
; $25b0: 6f 6e 0d            rra a0d6e
_25b2:
.export _25b2
_25b3:
.export _25b3
; $25b3: 00 00               brk # $00
; $25b5: 00 00               brk # $00
; $25b7: 00 00               brk # $00
; $25b9: 00 00               brk # $00
; $25bb: 00 00               brk # $00
; $25bd: 00 00               brk # $00
; $25bf: 00 00               brk # $00
; $25c1: 00 00               brk # $00
; $25c3: 00 00               brk # $00
; $25c5: 00 00               brk # $00
; $25c7: 00 00               brk # $00
; $25c9: 00 00               brk # $00
; $25cb: 00 00               brk # $00
; $25cd: 00 00               brk # $00
; $25cf: 00 00               brk # $00
; $25d1: 00 00               brk # $00
; $25d3: 00 00               brk # $00
; $25d5: 00 00               brk # $00
; $25d7: 00 00               brk # $00
; $25d9: 00 00               brk # $00
; $25db: 00 00               brk # $00
; $25dd: 00 00               brk # $00
; $25df: 00 00               brk # $00
; $25e1: 00 00               brk # $00
; $25e3: 00 00               brk # $00
; $25e5: 00 00               brk # $00
; $25e7: 00 10               brk # $10
; $25e9: 0f 11 00            slo a0011
; $25ec: 03 1c               slo (p1c, x)
; $25ee: 0e 00 00            asl f0000
; $25f1: 0a                  asl 
; $25f2: 00 11               brk # $11
; $25f4: 3a                  nop 
; $25f5: 07 09               slo a09
; $25f7: 08                  php 
; $25f8: 00 00               brk # $00
; $25fa: 00 00               brk # $00
; $25fc: 80 00               nop # $00
_25fd:
.export _25fd
_25fe:
.export _25fe
_25ff:
.export _25ff
; $25fe: 00 00               brk # $00
; $2600: 00 00               brk # $00
; $2602: 00 00               brk # $00
; $2604: 00 00               brk # $00
; $2606: 00 00               brk # $00
; $2608: 00 00               brk # $00
; $260a: 00 00               brk # $00
; $260c: 00 00               brk # $00
; $260e: 00 00               brk # $00
; $2610: 00 00               brk # $00
; $2612: 00 00               brk # $00
; $2614: 3a                  nop 
; $2615: 30 2e               bmi b2645
; $2617: 45 2e               eor a2e
_2619:
.export _2619
; $2619: 4a                  lsr 
; $261a: 41 4d               eor (p4d, x)
; $261c: 45 53               eor a53
; $261e: 4f 4e 0d            sre a0d4e
; $2621: 00 14               brk # $14
; $2623: ad 4a 5a            lda a5a4a
; $2626: 48                  pha 
; $2627: 02                  jam 
; $2628: 53 b7               sre (pb7), y
; $262a: 00 00               brk # $00
; $262c: 03 e8               slo (pe8, x)
; $262e: 46 00               lsr a00
; $2630: 00 0f               brk # $0f
; $2632: 00 00               brk # $00
; $2634: 00 00               brk # $00
; $2636: 00 16               brk # $16
; $2638: 00 00               brk # $00
; $263a: 00 00               brk # $00
; $263c: 00 00               brk # $00
; $263e: 00 00               brk # $00
; $2640: 00 00               brk # $00
; $2642: 00 00               brk # $00
;                    b2645   =*+$01
; $2644: 00 00               brk # $00
; $2646: 00 00               brk # $00
; $2648: 00 00               brk # $00
; $264a: 00 00               brk # $00
; $264c: 00 00               brk # $00
; $264e: 00 00               brk # $00
; $2650: 00 00               brk # $00
; $2652: 00 00               brk # $00
; $2654: 03 00               slo (p00, x)
; $2656: 10 0f               bpl b2667
; $2658: 11 00               ora (p00), y
; $265a: 03 1c               slo (p1c, x)
; $265c: 0e 00 00            asl f0000
; $265f: 0a                  asl 
; $2660: 00 11               brk # $11
; $2662: 3a                  nop 
; $2663: 07 09               slo a09
; $2665: 08                  php 
;                    b2667   =*+$01
; $2666: 00 00               brk # $00
; $2668: 00 00               brk # $00
; $266a: 80 aa               nop # $aa
; $266c: 27 03               rla a03
; $266e: 00 00               brk # $00
; $2670: 00 00               brk # $00
; $2672: 00 00               brk # $00
; $2674: 00 00               brk # $00
; $2676: 00 00               brk # $00
; $2678: 00 00               brk # $00
; $267a: 00 00               brk # $00
; $267c: 00 00               brk # $00

_267e:
.export _267e
; $267e: 00 ff               brk # $ff
; $2680: ff aa aa            isc faaaa, x
; $2683: aa                  tax 
; $2684: 55 55       b2684   eor f55, x
; $2686: 55 aa               eor faa, x
; $2688: aa                  tax 
; $2689: aa                  tax 
; $268a: aa                  tax 
; $268b: aa                  tax 
; $268c: aa                  tax 
; $268d: 55 aa               eor faa, x
; $268f: aa                  tax 
; $2690: aa                  tax 
; $2691: aa                  tax 
; $2692: aa                  tax 
; $2693: aa                  tax 
; $2694: aa                  tax 
; $2695: aa                  tax 
; $2696: aa                  tax 
; $2697: aa                  tax 
; $2698: aa                  tax 
; $2699: aa                  tax 
; $269a: aa                  tax 
; $269b: 5a                  nop 
; $269c: aa                  tax 
; $269d: aa                  tax 
; $269e: 00 aa               brk # $aa
; $26a0: 00 00               brk # $00
; $26a2: 00 00               brk # $00

_26a4:
.export _26a4
; $26a4: 76 85       f26a4   ror f85, x
; $26a6: 9c a5 8b            shy f8ba5, x
; $26a9: 85 9a               sta a9a
; $26ab: a5 8d               lda a8d
; $26ad: 20 0c 9a            jsr e9a0c
; $26b0: b0 d2               bcs b2684
; $26b2: 85 6f               sta a6f
; $26b4: a5 9c               lda a9c
; $26b6: 85 70               sta a70
; $26b8: a5 6b               lda a6b
; $26ba: 85 9b               sta a9b
; $26bc: a5 72               lda a72
; $26be: 85 9c               sta a9c
; $26c0: a5 85               lda a85
; $26c2: 85 9a               sta a9a
; $26c4: a5 87               lda a87
; $26c6: 20 0c 9a            jsr e9a0c
; $26c9: b0 b9               bcs b2684
; $26cb: 85 6b               sta a6b
; $26cd: a5 9c               lda a9c
; $26cf: 85 6c               sta a6c
; $26d1: a5 6d               lda a6d
; $26d3: 85 9b               sta a9b
; $26d5: a5 74               lda a74
; $26d7: 85 9c               sta a9c
; $26d9: a5 88               lda a88
; $26db: 85 9a               sta a9a
; $26dd: a5 8a               lda a8a
; $26df: 20 0c 9a            jsr e9a0c
; $26e2: b0 a0               bcs b2684
; $26e4: 85 6d               sta a6d
; $26e6: a5 9c               lda a9c
; $26e8: 85 6e               sta a6e
; $26ea: a5 71               lda a71
; $26ec: 85 9a               sta a9a
; $26ee: a5 6b               lda a6b
; $26f0: 20 ea 39            jsr s39ea
; $26f3: 85 bb               sta abb
; $26f5: a5 72               lda a72
; $26f7: 45 6c               eor a6c
; $26f9: 85 9c               sta a9c
; $26fb: a5 73               lda a73
; $26fd: 85 9a               sta a9a
; $26ff: a5 6d               lda a6d
; $2701: 20 ea 39            jsr s39ea
; $2704: 85 9a               sta a9a
; $2706: a5 bb               lda abb
; $2708: 85 9b               sta a9b
; $270a: a5 74               lda a74
; $270c: 45 6e               eor a6e
; $270e: 20 0c 9a            jsr e9a0c
; $2711: 85 bb               sta abb
; $2713: a5 75               lda a75
; $2715: 85 9a               sta a9a
; $2717: a5 6f               lda a6f
; $2719: 20 ea 39            jsr s39ea
; $271c: 85 9a               sta a9a
; $271e: a5 bb               lda abb
; $2720: 85 9b               sta a9b
; $2722: a5 70               lda a70
; $2724: 45 76               eor a76
; $2726: 20 0c 9a            jsr e9a0c
; $2729: 48                  pha 
; $272a: 98                  tya 
; $272b: 4a                  lsr 
; $272c: 4a                  lsr 
; $272d: aa                  tax 
; $272e: 68                  pla 
; $272f: 24 9c               bit a9c
; $2731: 30 02               bmi b2735
; $2733: a9 00               lda # $00
; $2735: 95 35       b2735   sta f35, x
; $2737: c8                  iny 
; $2738: c4 ae               cpy aae
; $273a: b0 fe       b273a   bcs b273a
; $273c: 4c f2 9b            jmp e9bf2

; $273f: a4 47               ldy a47
; $2741: a6 48               ldx a48
; $2743: a5 4b               lda a4b
; $2745: 85 47               sta a47
; $2747: a5 4c               lda a4c
; $2749: 85 48               sta a48
; $274b: 84 4b               sty a4b
; $274d: 86 4c               stx a4c
; $274f: a4 49               ldy a49
; $2751: a6 4a               ldx a4a
; $2753: a5 51               lda a51
; $2755: 85 49               sta a49
; $2757: a5 52               lda a52
; $2759: 85 4a               sta a4a
; $275b: 84 51               sty a51
; $275d: 86 52               stx a52
; $275f: a4 4f               ldy a4f
; $2761: a6 50               ldx a50
; $2763: a5 53               lda a53
; $2765: 85 4f               sta a4f
; $2767: a5 54               lda a54
; $2769: 85 50               sta a50
; $276b: 84 53               sty a53
; $276d: 86 54               stx a54
; $276f: a0 08               ldy # $08
; $2771: b1 57               lda (p57), y
; $2773: 85 ae               sta aae
; $2775: a5 57               lda a57
; $2777: 18                  clc 
; $2778: 69 14               adc # $14
; $277a: 85 5b               sta a5b
; $277c: a5 58               lda a58
; $277e: 69 00               adc # $00
; $2780: 85 5c               sta a5c
; $2782: a0 00               ldy # $00
; $2784: 84 aa               sty aaa
; $2786: 84 9f               sty a9f
; $2788: b1 5b               lda (p5b), y
; $278a: 85 6b               sta a6b
; $278c: c8                  iny 
; $278d: b1 5b               lda (p5b), y
; $278f: 85 6d               sta a6d
; $2791: c8                  iny 
; $2792: b1 5b               lda (p5b), y
; $2794: 85 6f               sta a6f
; $2796: c8                  iny 
; $2797: b1 5b               lda (p5b), y
; $2799: 85 bb               sta abb
;                    b279c   =*+$01
; $279b: 29 1f               and # $1f
; $279d: c5 ad               cmp aad
; $279f: 90 fb               bcc b279c
; $27a1: c8                  iny 
;                    f27a3   =*+$01
; $27a2: b1 5b               lda (p5b), y

;===============================================================================

_27a3:
        .byte   $5b
_27a4:
.export _27a4
; $27a4: 85 2e       f27a4   sta a2e
; $27a6: 29 0f               and # $0f
; $27a8: aa                  tax 
; $27a9: b5 35               lda f35, x
; $27ab: d0 fe       b27ab   bne b27ab
; $27ad: a5 2e               lda a2e
; $27af: 4a                  lsr 
; $27b0: 4a                  lsr 
; $27b1: 4a                  lsr 
; $27b2: 4a                  lsr 
; $27b3: aa                  tax 
; $27b4: b5 35               lda f35, x
; $27b6: d0 fe       b27b6   bne b27b6
; $27b8: c8                  iny 
; $27b9: b1 5b               lda (p5b), y
; $27bb: 85 2e               sta a2e
; $27bd: 29 0f               and # $0f
; $27bf: aa                  tax 
; $27c0: b5 35               lda f35, x
; $27c2: d0 fe       b27c2   bne b27c2
; $27c4: a5 2e               lda a2e
; $27c6: 4a                  lsr 
; $27c7: 4a                  lsr 
; $27c8: 4a                  lsr 
; $27c9: 4a                  lsr 
; $27ca: aa                  tax 
; $27cb: b5 35               lda f35, x
; $27cd: d0 fe       b27cd   bne b27cd
; $27cf: 4c 8e 9d            jmp e9d8e

; $27d2: a5 bb               lda abb
; $27d4: 85 6c               sta a6c
; $27d6: 0a                  asl 
; $27d7: 85 6e               sta a6e
; $27d9: 0a                  asl 
; $27da: 85 70               sta a70
; $27dc: 20 2c 9a            jsr e9a2c
; $27df: a5 0b               lda a0b
; $27e1: 85 6d               sta a6d
; $27e3: 45 72               eor a72
; $27e5: 30 fe       b27e5   bmi b27e5
; $27e7: 18                  clc 
; $27e8: a5 71               lda a71
; $27ea: 65 09               adc a09
; $27ec: 85 6b               sta a6b
; $27ee: a5 0a               lda a0a
; $27f0: 69 00               adc # $00
; $27f2: 85 6c               sta a6c
; $27f4: 4c b3 9d            jmp e9db3

; $27f7: a5 09               lda a09
; $27f9: 38                  sec 
; $27fa: e5 71               sbc a71
; $27fc: 85 6b               sta a6b
; $27fe: a5 0a               lda a0a
; $2800: e9 00               sbc # $00
; $2802: 85 6c               sta a6c
; $2804: b0 fe       b2804   bcs b2804
; $2806: 49 ff               eor # $ff
; $2808: 85 6c               sta a6c
; $280a: a9 01               lda # $01
; $280c: e5 6b               sbc a6b
; $280e: 85 6b               sta a6b
; $2810: 90 02               bcc b2814
; $2812: e6 6c               inc a6c
; $2814: a5 6d       b2814   lda a6d
; $2816: 49 80               eor # $80
; $2818: 85 6d               sta a6d
; $281a: a5 0e               lda a0e
; $281c: 85 70               sta a70
; $281e: 45 74               eor a74
; $2820: 30 fe       b2820   bmi b2820
; $2822: 18                  clc 
; $2823: a5 73               lda a73
; $2825: 65 0c               adc a0c
; $2827: 85 6e               sta a6e
; $2829: a5 0d               lda a0d
; $282b: 69 00               adc # $00
; $282d: 85 6f               sta a6f
; $282f: 4c ee 9d            jmp e9dee

; $2832: a5 0c               lda a0c
; $2834: 38                  sec 
; $2835: e5 73               sbc a73
; $2837: 85 6e               sta a6e
; $2839: a5 0d               lda a0d
; $283b: e9 00               sbc # $00
; $283d: 85 6f               sta a6f
; $283f: b0 fe       b283f   bcs b283f
; $2841: 49 ff               eor # $ff
; $2843: 85 6f               sta a6f
; $2845: a5 6e               lda a6e
; $2847: 49 ff               eor # $ff
; $2849: 69 01               adc # $01
; $284b: 85 6e               sta a6e
; $284d: a5 70               lda a70
; $284f: 49 80               eor # $80
; $2851: 85 70               sta a70
; $2853: 90 fe       b2853   bcc b2853
; $2855: e6 6f               inc a6f
; $2857: a5 76               lda a76
; $2859: 30 fe       b2859   bmi b2859
; $285b: a5 75               lda a75
; $285d: 18                  clc 
; $285e: 65 0f               adc a0f
; $2860: 85 bb               sta abb
; $2862: a5 10               lda a10
; $2864: 69 00               adc # $00
; $2866: 85 99               sta a99
; $2868: 4c 27 9e            jmp e9e27

; $286b: a6 9a               ldx a9a
; $286d: f0 fe       b286d   beq b286d
; $286f: a2 00               ldx # $00
; $2871: 4a          b2871   lsr 
; $2872: e8                  inx 
; $2873: c5 9a               cmp a9a
; $2875: b0 fa               bcs b2871
; $2877: 86 9c               stx a9c
; $2879: 20 af 99            jsr $99af
; $287c: a6 9c               ldx a9c
; $287e: a5 9b               lda a9b
; $2880: 0a          b2880   asl 
; $2881: 26 99               rol a99
; $2883: 30 fe       b2883   bmi b2883
; $2885: ca                  dex 
; $2886: d0 f8               bne b2880
; $2888: 85 9b               sta a9b
; $288a: 60                  rts 

; $288b: a9 32               lda # $32
; $288d: 85 9b               sta a9b
; $288f: 85 99               sta a99
; $2891: 60                  rts 

; $2892: a9 80               lda # $80
; $2894: 38                  sec 
; $2895: e5 9b               sbc a9b
; $2897: 9d 00 01            sta f0100, x
; $289a: e8                  inx 
; $289b: a9 00               lda # $00
; $289d: e5 99               sbc a99
; $289f: 9d 00 01            sta f0100, x
;                    f28a4   =*+$02
; $28a2: 4c 61 00            jmp e0061

;===============================================================================

_28a4:
.export _28a4
        .byte   $00
_28a5:
.export _28a5
        .byte   $f9, $25, $f9, $4a, $f9, $6f, $f9, $94
        .byte   $f9, $b9, $f9, $de, $f9, $03, $fa, $28
        .byte   $fa, $4d, $fa, $72, $fa, $80, $40, $20
        .byte   $10, $08, $04, $02, $01, $80, $40

; unused / unreferenced?
;$28c4:
        .byte   %11000000       ;=$C0
        .byte   %00110000       ;=$30
        .byte   %00001100       ;=$0C
        .byte   %00000011       ;=$03

_28c8:  ; pixel pairs, in single step (for drawing stars?)
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

;===============================================================================

_28d9:
.export _28d9:
        jsr _777e

_28dc:  ; NOTE: this address is used in the table in _250c
.export _28dc
        lda # $13
        bne _28e5
_28e0:
.export _28e0
        lda # $17
        jsr $6a2b
_28e5:
.export _28e5
        sta $6c
        sta $6e
        ldx # $00
        stx $6b
        dex 
        stx $6d
        jmp $ab91

;===============================================================================

_28f3:
.export _28f3
        jsr $811e
        sty $6c
        lda # $00
        sta $0580, y
        jmp $affa

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
        eor # $7f
        clc 
        adc # $01
_2921:
        eor # $80
        tax 
        lda $6c
        and # $7f
        cmp # $48
        bcs _2976
        lda $6c
        bpl _2934
        eor # $7f
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
        and # $f8
        clc 
        adc $9700, y
        sta $07
        lda $9800, y
        adc # $00
        sta $08
        tya 
        and # $07
        tay 
        txa 
        and # $07
        tax 
        lda $a1
        cmp # $90
        bcs _296d
        lda _28c8, x
        eor ($07), y
        sta ($07), y
        lda $a1
        cmp # $50
        bcs _2974
        dey 
        bpl _296d
        ldy # $01
_296d:
        lda _28c8, x
        eor ($07), y
        sta ($07), y
_2974:
        ldy a06
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
        sta _27a4, y
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
        jsr $a013
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
        sta _27a4, y
        iny 
_29e6:
        lda $6d
        sta _26a4, y
        lda $6e
        sta _27a4, y
        iny 
        sty $7e
        jsr $ab91
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
        ora # $01
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
        eor # $80
        jsr _290f
        lda $5e
        sta $6b
        sta $06a2, y
        and # $7f
        cmp # $78
        bcs _2b0a
        lda $60
        sta $06bc, y
        sta $6c
        and # $7f
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
        jsr $84af
        ora # $04
        sta $6c
        sta $06bc, y
        jsr $84af
        ora # $08
        sta $6b
        sta $06a2, y
        jsr $84af
        ora # $90
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
        ora # $01
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
        eor # $80
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
        and # $7f
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
        jsr $84af
        and # $7f
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
        jsr $84af
        sta $6c
        sta $06bc, y
        jmp _2bed

        ;-----------------------------------------------------------------------

_2c1a:
        jsr $84af
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
        and # $7f
        rts 

;===============================================================================

_2c4e:
        lda # $00
_2c50:
.export _2c50
        ora $f902, y
        ora $f905, y
        ora $f908, y
        and # $7f
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
        jsr _2390
        jsr $b179
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
        jsr $6a2f
        jsr $70ab
        lda # $07
        jsr _6a25
        lda # $7e
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
        jsr $7773
_2cc7:
        lda # $7d
        jsr $6a9b
        lda # $13
        ldy $04cd
        beq _2cd7
        cpy # $32
        adc # $01
_2cd7:
        jsr $7773
        lda # $10
        jsr $6a9b
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
        jsr $7773
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
        jsr $6a9b
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

_26d1:
        jsr $7773
        lda # $06
        jmp _6a25

;===============================================================================

_2d69:
.export _2d69
        lda $7a
        sta $9c
        and # $80
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
        and # $7f
        ora $bb
        sta $7a
        rts 

        ;-----------------------------------------------------------------------

_2d8d:
        lda $9c
        and # $7f
        sta $9c
        lda $09, x
        sec 
        sbc $78
        sta $78
        lda $0a, x
        sbc $79
        sta $79
        lda $0b, x
        and # $7f
        sbc $9c
        ora # $80
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
        and # $7f
        ora $bb
        sta $7a
_2dc4:
        rts 

;===============================================================================

_2dc5:
.export _2dc5
        lda $0a, x
        and # $7f
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
        and # $80
        sta $bb
        lda $000a, y
        and # $7f
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
        and # $7f
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
        and # $80
        sta $bb
        lda $0a, x
        and # $7f
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        lsr 
        ror $2e
        ora $bb
        eor # $80
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

;===============================================================================

_2e51:
        .byte   $48, $76, $e8, $00

        ;-----------------------------------------------------------------------

_2e55:
.export _2e55
        lda $03
_2e57:
.export _2e57
        ldy $00
_2e59:
.export _2e59
        sta $99
        lda # $00
        sta $77
        sta $78
        sty $79
        stx $7a
_2e65:
.export _2e65
        ldx # $0b
        stx $bb
        php 
        bcc _2e70
        dec $bb
        dec $99
_2e70:
        lda # $0b
        sec 
        sta $9f
        sbc $99
        sta $99
        inc $99
        ldy # $00
        sty $9c
        jmp _2ec1

_2e82:
        asl $7a
        rol $79
        rol $78
        rol $77
        rol $9c
        ldx # $03
_2e8e:
        lda $77, x
        sta $6b, x
        dex 
        bpl _2e8e
        lda $9c
        sta $6f
        asl $7a
        rol $79
        rol $78
        rol $77
        rol $9c
        asl $7a
        rol $79
        rol $78
        rol $77
        rol $9c
        clc 
        ldx # $03
_2eb0:
        lda $77, x
        adc $6b, x
        sta $77, x
        dex 
        bpl _2eb0
        lda $6f
        adc $9c
        sta $9c
        ldy # $00
_2ec1:
        ldx # $03
        sec 
_2ec4:
        lda $77, x
        sbc _2e51, x
        sta $6b, x
        dex 
        bpl _2ec4
        lda $9c
        sbc # $17
        sta $6f
        bcc _2ee7
        ldx # $03
_2ed8:
        lda $6b, x
        sta $77, x
        dex 
        bpl _2ed8
        lda $6f
        sta $9c
        iny 
        jmp _2ec1

_2ee7:
        tya 
        bne _2ef6
        lda $bb
        beq _2ef6
        dec $99
        bpl _2f00
        lda # $20
        bne _2efd
_2ef6:
        ldy # $00
        sty $bb
        clc 
        adc # $30
_2efd:
        jsr _2f24
_2f00:
        dec $bb
        bpl _2f06
        inc $bb
_2f06:
        dec $9f
        bmi _2f17
        bne _2f14
        plp 
        bcc _2f14
        lda # $2e
        jsr _2f24
_2f14:
        jmp _2e82

_2f17:
        rts 

;===============================================================================

_2f18:
        .byte   $20
_2f19:
        .byte   $ff
_2f1a:
        .byte   $00
_2f1b:
.export _2f1b
        .byte   $00
_2f1c:
.export _2f1c
        .byte   $00
_2f1d:
        .byte   $00

;===============================================================================

_2f1e:
        .byte   $ff

_2f1f:
.export _2f1f
        lda # $0c
_2f21:
        bit $41a9

_2f24:  ; NOTE: this address is used in the table in _250c
.export _2f24
        stx a07
        ldx # $ff
        stx _2f1e
        cmp # $2e
        beq _2f40
        cmp # $3a
        beq _2f40
        cmp # $0a
        beq _2f40
        cmp # $0c
        beq _2f40
        cmp # $20
        beq _2f40
        inx 
_2f40:
        stx _2f19
        ldx $07
        bit _2f1b
        bmi _2f4d
        jmp $b17b

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
        jsr $b17b
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
_2fd6
        lda $0648, y
        jsr $b17b
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
_2fee:
.export _2fee
        bit $07a9
        jmp $b17b

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
        eor # $80
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
        and # $03
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
        lda $04a6
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
        jmp $7b6f

;===============================================================================

_30bb:
        ldx # $aa
        lda $a3
        and # $08
        and $1d09
        beq _30c7+1
        txa 
_30c7:
        bit $55a9
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
        sta ($07), y
        iny 
        sta ($07), y
        iny 
        sta ($07), y
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
        eor # $03
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
        and # $aa
        jmp _314d
_3149:
        sta $9a
        lda # $00
_314d:
        sta ($07), y
        iny 
        sta ($07), y
        iny 
        sta ($07), y
        iny 
        sta ($07), y
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
        jsr $b410
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
        jsr $84af
        and # $07
        ora # $01
        sta $04c9
        lda # $00
        sta $04ca
_31be:
        lda # $46
        sta $04a6
        jmp _2101

;===============================================================================

_31c6:
.export _31c6
        lda # $0e
        jsr _2390
        jsr $6f82
        jsr $70a0
        lda # $00
        sta $ae
_31d5:
        jsr _24a3
        jsr $76e9
        ldx _2f1c
        lda $0e, x
        cmp # $0d
        bne _31f1
_31e4:
        dex 
        lda $0e, x
        ora # $20
        cmp $0648, x
        beq _31e4
        txa 
        bmi _3208
_31f1:
        jsr $6a3b
        inc $ae
        bne _31d5
        jsr $70ab
        jsr $6f82
        ldy # $06
        jsr $a858
        lda # $d7
        jmp _2390

        ;-----------------------------------------------------------------------

_3208:
        lda $82
        sta $0509
        lda $80
        sta $050a
        jsr $70ab
        jsr $6f82
        jsr _24a6
        jmp $877e

;===============================================================================

_321e:
        lda $09
        ora $0c
        ora $0f
        bne _322b
        lda # $50
        jsr $7bd2
_322b:
        ldx # $04
        bne _3290
_322f:
        lda # $00
        jsr $87b1
        beq _3239
        jmp _3365

        ;-----------------------------------------------------------------------

_3239:
        jsr _3293
        jsr $a813
        lda # $fa
        jmp $7bd2

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
        and # $7f
        ora $36
        ora $39
        ora $3c
        bne _3299
        lda $29
        cmp # $82
        beq _321e
        ldy # $1f
        lda ($5b), y
        bit _32a0+1             ;!?
        bne _327d
        ora # $80
        sta ($5b), y
_327d:
        lda $09
        ora $0c
        ora $0f
        bne _328a
        lda # $50
        jsr $7bd2
_328a:
        lda $29
        and # $7f
        lsr 
        tax 
_3290:
        jsr $a7a6
_3293:
        asl $28
        sec 
        ror $28
_3298:
        rts 

        ;-----------------------------------------------------------------------

_3299:
        jsr $84af
        cmp # $10
        bcs _32a7
_32a0:
        ldy # $20
        lda ($5b), y
        lsr 
        bcs _32aa
_32a7:
        jmp _336e

_32aa:
        jmp $b0f4

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
        and # $04
        bne _32da
        lda $0467
        bne _3298
        jsr $84af
        cmp # $fd
        bcc _3298
        and # $01
        adc # $08
        tax 
        bne _32ea
_32da:
        jsr $84af
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
        jsr $84af
        cmp # $c8
        bcc _3328
        ldx # $00
        stx $29
        ldx # $24
        stx $2d
        and # $03
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
        cmp ($57), y
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
        jsr $84af
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
        ora # $04
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
        jsr $8c7b
        jmp _34ac

        ;-----------------------------------------------------------------------

_3357:
        lsr 
        bcc _3365
        lda $045f
        beq _3365
        lda $29
        and # $81
        sta $29
_3365:
        ldx # $08
_3367:
        lda $09, x
        sta $35, x
        dex 
        bpl _3367
_336e:
        jsr $8c8a
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
        jsr $84af
        cmp # $c8
        bcc _339a
        jsr $84af
        ldx # $17
        cmp # $64
        bcs _3397
        ldx # $11
_3397:
        jmp _32ea

        ;-----------------------------------------------------------------------

_339a:
        jsr $84af
        cmp # $fa
        bcc _33a8
        jsr $84af
        ora # $68
        sta $26
_33a8:
        ldy # $0e
        lda ($57), y
        lsr 
        cmp $2c
        bcc _33fd
        lsr 
        lsr 
        cmp $2c
        bcc _33d6
        jsr $84af
        cmp # $e6
        bcc _33d6
        ldx $a5
        lda $d041, x
        bpl _33d6
        lda $2d
        and # $f0
        sta $2d
        ldy # $24
        sta ($59), y
        lda # $00
        sta $29
        jmp _3706

        ;-----------------------------------------------------------------------

_33d6:
        lda $28
        and # $07
        beq _33fd
        sta $bb
        jsr $84af
        and # $1f
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
        jmp $a795

        ;-----------------------------------------------------------------------

_33fd:
        lda # $00
        jsr $87b1
        and # $e0
        bne _3434
        ldx $aa
        cpx # $a0
        bcc _3434
        ldy # $13
        lda ($57), y
        and # $f8
        beq _3434
        lda $28
        ora # $40
        sta $28
        cpx # $a3
        bcc _3434
        lda ($57), y
        lsr 
        jsr $7bd2
        dec $25
        lda $67
        bne _3499
        ldy # $01
        jsr $a858
        ldy # $0f
        jmp $a858

        ;-----------------------------------------------------------------------

_3434:
        lda $10
        cmp # $03
        bcs _3442
        lda $0a
        ora $0d
        and # $fe
        beq _3454
_3442:
        jsr $84af
        ora # $80
        cmp $29
        bcs _3454
_344b:
        jsr _35d5
        lda $aa
        eor # $80
_3452:
        sta $aa
_3454:
        ldy # $10
        jsr _3ab2
        tax 
        eor # $80
        and # $80
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
        and # $80
        eor # $80
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
        and # $7f
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
        and # $7f
        bne _34cc
        jsr $8cad
        lda $9a
        sta $77
        jsr $8c8a
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
        jsr $8c8a
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
_b3571:
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
_3581:
        sta $5c
        ldy # $02
        jsr _358f
        ldy # $05
        jsr _358f
        ldy # $08
_358f:
        lda ($5b), y
        eor # $80
        sta $7a
        dey 
        lda ($5b), y
        sta $79
        dey 
        lda ($5b), y
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
        eor # $80
        sta $6b
        lda $6c
        eor # $80
        sta $6c
        lda $6d
        eor # $80
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
        eor # $80
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
        lda f35, x
        eor # $ff
        adc # $01
        sta $35, x
        lda $36, x
        eor # $ff
        adc # $00
        sta $36, x
        lda $37, x
        eor # $80
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
        and # $20
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
        lda ($57), y
        cmp $9c
        bne _367d
        dey 
        lda ($57), y
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
        ora # $80
        sta $29
_3695:
.export _3695
        lda # $60
        sta $17
        ora # $80
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
        jsr $7d0c
        dec $04cc
        ldy # $04
        jmp $a858

;===============================================================================

_36c5:
        cmp # $02
        beq _36f8
        ldy # $24
        lda ($59), y
        and # $20
        beq _36d4
        jsr _36f8
_36d4:
        ldy # $20
        lda ($59), y
        beq _367d
        ora # $80
        sta ($59), y
        ldy # $1c
        lda # $02
        sta ($59), y
        asl 
        ldy # $1e
        sta ($59), y
        lda aa5
        cmp # $0b
        bcc _36f7
        ldy # $24
        lda ($59), y
        ora # $04
        sta ($59), y
_36f7:
        rts 

        ;-----------------------------------------------------------------------

_36f8:
        lda $f949
        ora # $04
        sta $f949
        rts 

_3701:
        lda # $c9
        jmp $900d

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
        lda ($59), y
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
        jsr $84af
        asl 
        sta $27
        txa 
        and # $0f
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
        sta a9b
        lda # $00
        ror 
        jmp $a44c

_3795:
.export _3795
        jsr $a839
        lda # $04
        jsr _37a5
        rts 

;===============================================================================

_379e:
.export _379e
        ldy # $04
        jsr $a858
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
        and # $07
        clc 
        adc # $08
        sta $77
_37d7:
        lda # $01
        sta $7e
        jsr $805e
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
        eor # $80
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
        eor # $80
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
        and # $7f
        eor # $7f
        cmp $ba
        bcc _38be
        beq _38be
        lda $60
        sta $06bc, y
        sta $6c
        and # $7f
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
        eor # $80
        sta $6a
        lda $94
        eor $b0
        sta $94
        eor # $80
        sta $95
        rts 

        ;-----------------------------------------------------------------------

_38be:
        jsr $84af
        sta $6c
        sta $06bc, y
        lda # $73
        ora $b0
        sta $6b
        sta $06a2, y
        bne _38e2
_38d1:
        jsr $84af
        sta $6b
        sta $06a2, y
        lda # $6e
        ora $6a
        sta $6c
        sta $06bc, y
_38e2:
        jsr $84af
        ora # $08
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
        and # $7f
        sta $79
        lda $9a
        and # $7f
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
        and # $80
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
        and # $80
        sta $bb
        txa 
        and # $7f
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
        and # $7f
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
        and # $7f
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
        and # $1f
        tax 
        lda $0ac0, x
        sta $9a
        lda $77
_39ea:
.export _39ea
        stx $2e
        sta $b6
        tax 
        beq _3a1d
        lda $9400, x
        ldx $9a
        beq _3a20
        clc 
        adc $9400, x
        bmi _3a0f
        lda $9300, x
        ldx $b6
        adc $9300, x
        bcc _3a20
        tax 
        lda $9500, x
        ldx $2e
        rts 

        ;-----------------------------------------------------------------------

_3a0f:
        lda $9300, x
        ldx $b6
        adc $9300, x
        bcc _3a20
        tax 
        lda $9600, x
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
        eor # $ff
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
        and # $7f
        lsr 
        sta $2e
        txa 
        eor $9a
        and # $80
        sta $bb
        lda $9a
        and # $7f
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
        and # $80
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
        and # $7f
        sta $99
        lda $2e
        sec 
        sbc $9b
        tax 
        lda $06
        and # $7f
        sbc $99
        bcs _3b0a
        sta $99
        txa 
        eor # $ff
        adc # $01
        tax 
        lda # $00
        sbc $99
        ora # $80
_3b0a:
        eor $bb
        rts 

;===============================================================================

_3b0d:
.export _3b0d
        stx $9a
        eor # $80
        jsr _3ace
        tax 
        and # $80
        sta $bb
        txa 
        and # $7f
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
_3b30:
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
_3b43::
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
        lda $9400, x
        ldx $9a
        sec 
        sbc $9400, x
        bmi _3bae
        ldx $b6
        lda $9300, x
        ldx $9a
        sbc $9300, x
        bcs _3ba9
        tax 
        lda $9500, x
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
        ldx ab6
        lda $9300, x
        ldx $9a
        sbc $9300, x
        bcs _3ba9
        tax 
        lda $9600, x
        sta $9b
        rts 

;===============================================================================

_3bc1:
.export _3bc1
        sta $30
        lda $0f
        ora # $01
        sta $9a
        lda $10
        sta $9b
        lda $11
        sta $9c
        lda $2e
        ora # $01
        sta $2e
        lda $30
        eor $9c
        and # $80
        sta $bb
        ldy # $00
        lda $30
        and # $7f
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
        and # $7f
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
        lda $1d06
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
        lda $1d07
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
        jsr $99af
        lda $9b
        lsr 
        lsr 
        lsr 
        tax 
        lda $0ae0, x
_3cda:
        rts 

;===============================================================================

_3cdb:
        jsr $84af
        and # $07
        adc # $44
        sta a06f1
        jsr $84af
        and # $07
        adc # $7c
        sta $06f0
        lda $0488
        adc # $08
        sta $0488
        jsr $7b64
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
        jsr $ab91
        lda $06f0
        sta $6b
        lda $06f1
        sta $6c
        sty $6d
        lda # $8f
        sta $6e
        jmp $ab91

;===============================================================================

_3d2f:
.export _3d2f
        lda $0507
        ora $0508
        bne _3d6f
        lda aa7
        bpl _3d6f
        ldy # $00
_3d3d:
        lda $1a27, y            ;from $4000..$5600
        cmp $a1
        bne _3d6c
        lda $1a41, y
        and # $7f
        cmp $04a8
        bne _3d6c
        lda $1a41, y
        bmi _3d5e+1
        lda $0499
        lsr 
        bcc _3d6f
        jsr _24a3
        lda # $01
_3d5e:
        bit $b0a9
        jsr _23cf
        tya 
        jsr _237e
        lda # $b1
        bne _3d7a
_3dc6:
        dey 
        bne _3d3d
_3d6f:
        ldx # $03
_3d71:
        lda $81, x
        sta $02, x
        dex 
        bpl _3d71
        lda # $05
_3d7a:
        jmp _2390

;===============================================================================

_3d7d:                                                                  ;$3d7d
        lda $0499
        ora # $04
        sta $0499
        lda # $0b
_3d87:                                                                  ;$3d87
        jsr _2390
_3d8a:                                                                  ;$3d8a
        jmp _88e7

;===============================================================================

_3d8d:                                                                  ;$3d8d
        lda $0499
        and # $f0
        ora # $0a
        sta $0499
        lda # $de
        bne _3d87
_3d9b:                                                                  ;$3d9b
        lda $0499
        ora # $04
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
        ora # $10
        sta $0499
        lda # $c7
        jsr _2390
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
        jsr _3e37
        jsr _8447
        lda # $1f
        sta $a5
        jsr _7c6b
        lda # $01
        jsr _6a25
        sta $10
        jsr _a72f
        lda # $40
        sta $a3
_3e01:                                                                  ;$3e01
        ldx # $7f
        stx $26
        stx $27
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
        inc a10
        lda # $0a
        bne _3dbe
_3e37:  ; NOTE: this address is used in the table in _250c              ;$3e37
        lda # $d8
        jsr _2390
        ldy # $64
        jmp _3ea1

;===============================================================================

_3e41:  ; NOTE: this address is used in the table in _250c              ;$3e41
        jsr _3e65
        bne _3e41
_3e46:                                                                  ;$3e46
        jsr _3e65
        beq _3e46
        lda # $00
        sta $28
        lda # $01
_3e51:                                                                  ;$3e51
        jsr _a72f
        jsr _9a86
_3e57:  ; NOTE: this address is used in the table in _250c
        lda # $0a
_3e59:  ; NOTE: this address is used in the table in _250c
        ; (jumps into the middle of this `bit` instruction)
        bit $06a9
        jsr $6a28
        jsr _250b
        jmp _248b
_3e65:                                                                  ;$3e65
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

;===============================================================================

_3e7c:  ; NOTE: this address is used in the table in _250c              ;$3e7c
        jsr _8d53
        bne _3e7c
        jsr _8d53
        beq _3e7c
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
        lda $049a, x
        sta $0509, x
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
;$3ea8:

        .byte   $07, $07, $0d, $04, $10, $15, $1a, $1f
        .byte   $9b, $a0, $2e, $a5, $24, $29, $3d, $33
        .byte   $38, $aa, $42, $47, $4c, $51, $56, $8c
        .byte   $60, $65, $87, $82, $5b, $6a, $b4, $b9
        .byte   $be, $e1, $e6, $eb, $f0, $f5, $fa, $73
        .byte   $78, $7d, $00, $00

;$3ed4