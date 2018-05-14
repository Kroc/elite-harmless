; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================


.org    $1d81

.code

_1d81:                                                                  ;$1d81
        jsr $83df
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
        jmp $88e7

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
; $1e21: 00 01       f1e21   brk #$01
;                    f1e25   =*+$02
; $1e23: ff 00 00            isc f0000,x
; $1e26: 00 ff               brk #$ff
;                    f1e29   =*+$01
; $1e28: 00 fb               brk #$fb
; $1e2a: 04 f7       f1e2a   nop af7
; $1e2c: 08                  php 
; $1e2d: ef 10 df            isc adf10
; $1e30: 20 bf 40            jsr e40bf
;                    j1e35   =*+$02
; $1e33: 7f 80 a5            rra fa580,x
; $1e36: a3 29               lax (p29,x)
; $1e38: 07 cd               slo acd
; $1e3a: 10 05               bpl b1e41
; $1e3c: 90 03               bcc b1e41
; $1e3e: 4c ce 1e            jmp j1ece

; $1e41: 0a          b1e41   asl 
; $1e42: a8                  tay 
; $1e43: a9 05               lda #$05
; $1e45: 20 7f 82            jsr e827f
; $1e48: 20 af 84            jsr e84af
; $1e4b: c9 eb               cmp #$eb
; $1e4d: 90 1b               bcc b1e6a
; $1e4f: 29 03               and #$03
; $1e51: aa                  tax 
; $1e52: bd 21 1e            lda _1e21,x
; $1e55: 99 11 05            sta f0511,y
; $1e58: bd 25 1e            lda f1e25,x
; $1e5b: 99 21 05            sta f0521,y
; $1e5e: 20 af 84            jsr e84af
; $1e61: 29 03               and #$03
; $1e63: aa                  tax 
; $1e64: bd 21 1e            lda _1e21,x
; $1e67: 99 12 05            sta f0512,y
; $1e6a: b9 29 1e    b1e6a   lda f1e29,y
; $1e6d: 2d 10 d0            and $d010    ;sprites 0-7 msb of x coordinate
; $1e70: 8d 10 d0            sta $d010    ;sprites 0-7 msb of x coordinate
; $1e73: b9 05 d0            lda $d005,y  ;sprite 2 y pos
; $1e76: 18                  clc 
; $1e77: 79 12 05            adc f0512,y
; $1e7a: 99 05 d0            sta $d005,y  ;sprite 2 y pos
; $1e7d: 18                  clc 
; $1e7e: b9 04 d0            lda $d004,y  ;sprite 2 x pos
; $1e81: 79 11 05            adc f0511,y
; $1e84: 85 bb               sta abb
; $1e86: b9 31 05            lda f0531,y
; $1e89: 79 21 05            adc f0521,y
; $1e8c: 10 06               bpl b1e94
; $1e8e: a9 48               lda #$48
; $1e90: 85 bb               sta abb
; $1e92: a9 01               lda #$01
; $1e94: 29 01       b1e94   and #$01
; $1e96: f0 0c               beq b1ea4
; $1e98: a5 bb               lda abb
; $1e9a: c9 50               cmp #$50
; $1e9c: a9 01               lda #$01
; $1e9e: 90 04               bcc b1ea4
; $1ea0: a9 00               lda #$00
; $1ea2: 85 bb               sta abb
; $1ea4: 99 31 05    b1ea4   sta f0531,y
; $1ea7: f0 0a               beq b1eb3
; $1ea9: b9 2a 1e            lda f1e2a,y
; $1eac: 0d 10 d0            ora $d010    ;sprites 0-7 msb of x coordinate
; $1eaf: 78                  sei 
; $1eb0: 8d 10 d0            sta $d010    ;sprites 0-7 msb of x coordinate
; $1eb3: a5 bb       b1eb3   lda abb
; $1eb5: 99 04 d0            sta $d004,y  ;sprite 2 x pos
; $1eb8: 58                  cli 
; $1eb9: a9 04               lda #$04
; $1ebb: 20 7f 82            jsr e827f
; $1ebe: 4c ce 1e            jmp j1ece

; $1ec1: ad 00 f9            lda af900
; $1ec4: 85 02               sta a02
; $1ec6: ad 10 05            lda a0510
; $1ec9: f0 03               beq j1ece
; $1ecb: 4c 35 1e            jmp j1e35

; $1ece: ae 8d 04    j1ece   ldx a048d
; $1ed1: 20 58 3c            jsr s3c58
; $1ed4: 20 58 3c            jsr s3c58
; $1ed7: 8a                  txa 
; $1ed8: 49 80               eor #$80
; $1eda: a8                  tay 
; $1edb: 29 80               and #$80
; $1edd: 85 69               sta a69
; $1edf: 8e 8d 04            stx a048d
; $1ee2: 49 80               eor #$80
; $1ee4: 85 6a               sta a6a
; $1ee6: 98                  tya 
; $1ee7: 10 05               bpl b1eee
; $1ee9: 49 ff               eor #$ff
; $1eeb: 18                  clc 
; $1eec: 69 01               adc #$01
; $1eee: 4a          b1eee   lsr 
; $1eef: 4a                  lsr 
; $1ef0: c9 08               cmp #$08
; $1ef2: b0 01               bcs b1ef5
; $1ef4: 4a                  lsr 
; $1ef5: 85 68       b1ef5   sta a68
; $1ef7: 05 69               ora a69
; $1ef9: 85 a6               sta aa6
; $1efb: ae 8e 04            ldx a048e
; $1efe: 20 58 3c            jsr s3c58
; $1f01: 8a                  txa 
; $1f02: 49 80               eor #$80
; $1f04: a8                  tay 
; $1f05: 29 80               and #$80
; $1f07: 8e 8e 04            stx a048e
; $1f0a: 85 95               sta a95
; $1f0c: 49 80               eor #$80
; $1f0e: 85 94               sta a94
; $1f10: 98                  tya 
; $1f11: 10 02               bpl b1f15
; $1f13: 49 ff               eor #$ff
; $1f15: 69 04       b1f15   adc #$04
; $1f17: 4a                  lsr 
; $1f18: 4a                  lsr 
; $1f19: 4a                  lsr 
; $1f1a: 4a                  lsr 
; $1f1b: c9 03               cmp #$03
; $1f1d: b0 01               bcs b1f20
; $1f1f: 4a                  lsr 
; $1f20: 85 64       b1f20   sta a64
; $1f22: 05 94               ora a94
; $1f24: 85 63               sta a63
; $1f26: ad 10 8d            lda a8d10
; $1f29: f0 08               beq b1f33
; $1f2b: a5 96               lda a96
; $1f2d: c9 28               cmp #$28
; $1f2f: b0 02               bcs b1f33
; $1f31: e6 96               inc a96
; $1f33: ad 15 8d    b1f33   lda a8d15
; $1f36: f0 06               beq b1f3e
; $1f38: c6 96               dec a96
; $1f3a: d0 02               bne b1f3e
; $1f3c: e6 96               inc a96
;                    f1f3f   =*+$01
; $1f3e: ad 2e 8d    b1f3e   lda a8d2e
; $1f41: 2d cc 04            and a04cc
; $1f44: f0 0f               beq b1f55
; $1f46: a0 57               ldy #$57
; $1f48: 20 0c 7d            jsr e7d0c
; $1f4b: a0 06               ldy #$06
; $1f4d: 20 58 a8            jsr ea858
; $1f50: a9 00               lda #$00
; $1f52: 8d 85 04            sta a0485
; $1f55: a5 7c       b1f55   lda a7c
; $1f57: 10 12               bpl b1f6b
; $1f59: ad 36 8d            lda a8d36
; $1f5c: f0 0d               beq b1f6b
; $1f5e: ae cc 04            ldx a04cc
; $1f61: f0 08               beq b1f6b
; $1f63: 8d 85 04            sta a0485
; $1f66: a0 87               ldy #$87
; $1f68: 20 1f b1            jsr eb11f
; $1f6b: ad 28 8d    b1f6b   lda a8d28
; $1f6e: f0 07               beq b1f77
; $1f70: a5 7c               lda a7c
; $1f72: 30 4e               bmi b1fc2
; $1f74: 20 a6 36            jsr s36a6
; $1f77: ad 0f 8d    b1f77   lda a8d0f
; $1f7a: f0 0f               beq b1f8b
; $1f7c: 0e c3 04            asl a04c3
; $1f7f: f0 0a               beq b1f8b
; $1f81: a0 d0               ldy #$d0
; $1f83: 8c e0 a8            sty aa8e0
; $1f86: a0 0d               ldy #$0d
; $1f88: 20 58 a8            jsr ea858
; $1f8b: ad 23 8d    b1f8b   lda a8d23
; $1f8e: f0 08               beq b1f98
; $1f90: a9 00               lda #$00
; $1f92: 8d 80 04            sta a0480
; $1f95: 20 3b 92            jsr e923b
; $1f98: ad 13 8d    b1f98   lda a8d13
; $1f9b: 2d c7 04            and a04c7
; $1f9e: f0 08               beq b1fa8
; $1fa0: ad 82 04            lda a0482
; $1fa3: d0 03               bne b1fa8
; $1fa5: 4c 6e 31            jmp j316e

; $1fa8: ad 2a 8d    b1fa8   lda a8d2a
; $1fab: f0 03               beq b1fb0
; $1fad: 20 29 8e            jsr e8e29
; $1fb0: ad 3e 8d    b1fb0   lda a8d3e
; $1fb3: 2d c1 04            and a04c1
; $1fb6: f0 0a               beq b1fc2
; $1fb8: a5 67               lda a67
; $1fba: d0 06               bne b1fc2
; $1fbc: ce 81 04            dec a0481
; $1fbf: 20 f4 b0            jsr eb0f4
; $1fc2: ad 38 8d    b1fc2   lda a8d38
; $1fc5: 2d c5 04            and a04c5
; $1fc8: f0 0b               beq b1fd5
; $1fca: 4d 35 8d            eor a8d35
; $1fcd: f0 06               beq b1fd5
; $1fcf: 8d 80 04            sta a0480
; $1fd2: 20 04 92            jsr e9204
; $1fd5: a9 00       b1fd5   lda #$00
; $1fd7: 85 7b               sta a7b
; $1fd9: 85 97               sta a97
; $1fdb: a5 96               lda a96
; $1fdd: 4a                  lsr 
; $1fde: 66 97               ror a97
; $1fe0: 4a                  lsr 
; $1fe1: 66 97               ror a97
; $1fe3: 85 98               sta a98
; $1fe5: ad 87 04            lda a0487
; $1fe8: d0 43               bne b202d
; $1fea: ad 42 8d            lda a8d42
; $1fed: f0 3e               beq b202d
; $1fef: ad 88 04            lda a0488
; $1ff2: c9 f2               cmp #$f2
; $1ff4: b0 37               bcs b202d
; $1ff6: ae 86 04            ldx a0486
; $1ff9: bd a9 04            lda f04a9,x
; $1ffc: f0 2f               beq b202d
; $1ffe: 48                  pha 
; $1fff: 29 7f               and #$7f
; $2001: 85 7b               sta a7b
; $2003: 8d 84 04            sta a0484
; $2006: a0 00               ldy #$00
; $2008: 68                  pla 
; $2009: 48                  pha 
; $200a: 30 08               bmi b2014
; $200c: c9 32               cmp #$32
; $200e: d0 02               bne b2012
; $2010: a0 0c               ldy #$0c
; $2012: d0 09       b2012   bne b201d
; $2014: c9 97       b2014   cmp #$97
; $2016: f0 03               beq b201b
; $2018: a0 0a               ldy #$0a
;                    b201b   =*+$01
; $201a: 2c a0 0b            bit a0ba0
; $201d: 20 58 a8    b201d   jsr ea858
; $2020: 20 db 3c            jsr s3cdb
; $2023: 68                  pla 
; $2024: 10 02               bpl b2028
; $2026: a9 00               lda #$00
; $2028: 29 fa       b2028   and #$fa
; $202a: 8d 87 04            sta a0487
; $202d: a2 00       b202d   ldx #$00
; $202f: 86 9d       j202f   stx a9d
; $2031: bd 52 04            lda f0452,x
; $2034: d0 03               bne b2039
; $2036: 4c fa 21            jmp j21fa

; $2039: 85 a5       b2039   sta aa5
; $203b: 20 87 3e            jsr _3e87
; $203e: a0 24               ldy #$24
; $2040: b1 59       b2040   lda (p59),y
; $2042: 99 09 00            sta f0009,y
; $2045: 88                  dey 
; $2046: 10 f8               bpl b2040
; $2048: a5 a5               lda aa5
; $204a: 30 2d               bmi b2079
; $204c: 0a                  asl 
; $204d: a8                  tay 
; $204e: b9 fe cf            lda fcffe,y
; $2051: 85 57               sta a57
; $2053: b9 ff cf            lda fcfff,y
; $2056: 85 58               sta a58
; $2058: ad c3 04            lda a04c3
; $205b: 10 1c               bpl b2079
; $205d: c0 04               cpy #$04
; $205f: f0 18               beq b2079
; $2061: c0 3a               cpy #$3a
; $2063: f0 14               beq b2079
; $2065: c0 3e               cpy #$3e
; $2067: b0 10               bcs b2079
; $2069: a5 28               lda a28
; $206b: 29 20               and #$20
; $206d: d0 0a               bne b2079
; $206f: 06 28               asl a28
; $2071: 38                  sec 
; $2072: 66 28               ror a28
; $2074: a6 a5               ldx aa5
; $2076: 20 a6 a7            jsr ea7a6
; $2079: 20 a0 a2    b2079   jsr ea2a0
; $207c: a0 24               ldy #$24
; $207e: b9 09 00    b207e   lda f0009,y
; $2081: 91 59               sta (p59),y
; $2083: 88                  dey 
; $2084: 10 f8               bpl b207e
; $2086: a5 28               lda a28
; $2088: 29 a0               and #$a0
; $208a: 20 b1 87            jsr e87b1
; $208d: d0 51               bne b20e0
; $208f: a5 09               lda a09
; $2091: 05 0c               ora a0c
; $2093: 05 0f               ora a0f
; $2095: 30 49               bmi b20e0
; $2097: a6 a5               ldx aa5
; $2099: 30 45               bmi b20e0
; $209b: e0 02               cpx #$02
; $209d: f0 44               beq b20e3
; $209f: 29 c0               and #$c0
; $20a1: d0 3d               bne b20e0
; $20a3: e0 01               cpx #$01
; $20a5: f0 39               beq b20e0
;                    a20a9   =*+$02
; $20a7: ad c2 04            lda a04c2
; $20aa: 25 0e               and a0e
; $20ac: 10 74               bpl b2122
; $20ae: e0 05               cpx #$05
; $20b0: f0 0e               beq b20c0
; $20b2: a0 00               ldy #$00
; $20b4: b1 57               lda (p57),y
; $20b6: 4a                  lsr 
; $20b7: 4a                  lsr 
; $20b8: 4a                  lsr 
; $20b9: 4a                  lsr 
; $20ba: f0 66               beq b2122
; $20bc: 69 01               adc #$01
; $20be: d0 05               bne b20c5
; $20c0: 20 af 84    b20c0   jsr e84af
; $20c3: 29 07               and #$07
; $20c5: 20 00 6a    b20c5   jsr e6a00
; $20c8: a0 4e               ldy #$4e
; $20ca: b0 44               bcs b2110
; $20cc: ac ef 04            ldy a04ef
; $20cf: 79 b0 04            adc f04b0,y
; $20d2: 99 b0 04            sta f04b0,y
; $20d5: 98                  tya 
; $20d6: 69 d0               adc #$d0
; $20d8: 20 0d 90            jsr e900d
; $20db: 06 2d               asl a2d
; $20dd: 38                  sec 
; $20de: 66 2d               ror a2d
; $20e0: 4c 31 21    b20e0   jmp j2131

; $20e3: ad 49 f9    b20e3   lda af949
; $20e6: 29 04               and #$04
; $20e8: d0 1d               bne b2107
; $20ea: a5 17               lda a17
; $20ec: c9 d6               cmp #$d6
; $20ee: 90 17               bcc b2107
; $20f0: 20 7b 8c            jsr e8c7b
; $20f3: a5 6d               lda a6d
; $20f5: c9 59               cmp #$59
; $20f7: 90 0e               bcc b2107
; $20f9: a5 19               lda a19
; $20fb: 29 7f               and #$7f
; $20fd: c9 50               cmp #$50
; $20ff: 90 06               bcc b2107
; $2101: 20 3b 92    j2101   jsr e923b
; $2104: 4c 81 1d            jmp j1d81

; $2107: a5 96       b2107   lda a96
; $2109: c9 05               cmp #$05
; $210b: 90 0d               bcc b211a
; $210d: 4c d0 87            jmp e87d0

; $2110: 20 13 a8    b2110   jsr ea813
; $2113: 06 28               asl a28
; $2115: 38                  sec 
; $2116: 66 28               ror a28
; $2118: d0 17               bne j2131
; $211a: a9 01       b211a   lda #$01
; $211c: 85 96               sta a96
; $211e: a9 05               lda #$05
; $2120: d0 09               bne b212b
; $2122: 06 28       b2122   asl a28
; $2124: 38                  sec 
; $2125: 66 28               ror a28
; $2127: a5 2c               lda a2c
; $2129: 38                  sec 
; $212a: 6a                  ror 
; $212b: 20 d2 7b    b212b   jsr e7bd2
; $212e: 20 13 a8            jsr ea813
; $2131: a5 2d       j2131   lda a2d
; $2133: 10 03               bpl b2138
; $2135: 20 10 b4            jsr eb410
; $2138: a5 a0       b2138   lda aa0
; $213a: d0 6f               bne b21ab
; $213c: 20 26 a6            jsr ea626
; $213f: 20 3f 36            jsr s363f
; $2142: 90 64               bcc b21a8
; $2144: ad 85 04            lda a0485
; $2147: f0 0a               beq b2153
; $2149: 20 0f a8            jsr ea80f
; $214c: a6 9d               ldx a9d
; $214e: a0 27               ldy #$27
; $2150: 20 0e 7d            jsr e7d0e
; $2153: a5 7b       b2153   lda a7b
; $2155: f0 51               beq b21a8
; $2157: a2 0f               ldx #$0f
; $2159: 20 e9 a7            jsr ea7e9
; $215c: a5 a5               lda aa5
; $215e: c9 02               cmp #$02
; $2160: f0 41               beq b21a3
; $2162: c9 1f               cmp #$1f
; $2164: 90 0a               bcc b2170
; $2166: a5 7b               lda a7b
; $2168: c9 17               cmp #$17
; $216a: d0 37               bne b21a3
; $216c: 46 7b               lsr a7b
; $216e: 46 7b               lsr a7b
; $2170: a5 2c       b2170   lda a2c
; $2172: 38                  sec 
; $2173: e5 7b               sbc a7b
; $2175: b0 2a               bcs b21a1
; $2177: 06 28               asl a28
; $2179: 38                  sec 
; $217a: 66 28               ror a28
; $217c: a5 a5               lda aa5
; $217e: c9 07               cmp #$07
; $2180: d0 10               bne b2192
; $2182: a5 7b               lda a7b
; $2184: c9 32               cmp #$32
; $2186: d0 0a               bne b2192
; $2188: 20 af 84            jsr e84af
; $218b: a2 08               ldx #$08
; $218d: 29 03               and #$03
; $218f: 20 59 23            jsr s2359
; $2192: a0 04       b2192   ldy #$04
; $2194: 20 4c 23            jsr s234c
; $2197: a0 05               ldy #$05
; $2199: 20 4c 23            jsr s234c
; $219c: a6 a5               ldx aa5
; $219e: 20 a6 a7            jsr ea7a6
; $21a1: 85 2c       b21a1   sta a2c
; $21a3: a5 a5       b21a3   lda aa5
; $21a5: 20 c5 36            jsr s36c5
; $21a8: 20 86 9a    b21a8   jsr e9a86
; $21ab: a0 23       b21ab   ldy #$23
; $21ad: a5 2c               lda a2c
; $21af: 91 59               sta (p59),y
; $21b1: a5 2d               lda a2d
; $21b3: 30 2d               bmi b21e2
; $21b5: a5 28               lda a28
; $21b7: 10 2c               bpl b21e5
; $21b9: 29 20               and #$20
; $21bb: f0 28               beq b21e5
; $21bd: a5 2d               lda a2d
; $21bf: 29 40               and #$40
; $21c1: 0d cd 04            ora a04cd
; $21c4: 8d cd 04            sta a04cd
; $21c7: ad 8b 04            lda a048b
; $21ca: 0d 82 04            ora a0482
; $21cd: d0 13               bne b21e2
; $21cf: a0 0a               ldy #$0a
; $21d1: b1 57               lda (p57),y
; $21d3: f0 0d               beq b21e2
; $21d5: aa                  tax 
; $21d6: c8                  iny 
; $21d7: b1 57               lda (p57),y
; $21d9: a8                  tay 
; $21da: 20 81 74            jsr e7481
; $21dd: a9 00               lda #$00
; $21df: 20 0d 90            jsr e900d
; $21e2: 4c 9a 82    b21e2   jmp e829a

; $21e5: a5 a5       b21e5   lda aa5
; $21e7: 30 05               bmi b21ee
; $21e9: 20 a4 87            jsr e87a4
; $21ec: 90 f4               bcc b21e2
; $21ee: a0 1f       b21ee   ldy #$1f
; $21f0: a5 28               lda a28
; $21f2: 91 59               sta (p59),y
; $21f4: a6 9d               ldx a9d
; $21f6: e8                  inx 
; $21f7: 4c 2f 20            jmp j202f

; $21fa: ad c3 04    j21fa   lda a04c3
; $21fd: 10 08               bpl b2207
; $21ff: 0e c3 04            asl a04c3
; $2202: 30 03               bmi b2207
; $2204: 20 67 23            jsr s2367
; $2207: a5 a3       b2207   lda aa3
; $2209: 29 07               and #$07
; $220b: d0 6d               bne b227a
; $220d: ae e9 04            ldx a04e9
; $2210: 10 12               bpl b2224
; $2212: ae e8 04            ldx a04e8
; $2215: 20 61 7b            jsr e7b61
; $2218: 8e e8 04            stx a04e8
; $221b: ae e7 04            ldx a04e7
; $221e: 20 61 7b            jsr e7b61
; $2221: 8e e7 04            stx a04e7
; $2224: 38          b2224   sec 
; $2225: ad c4 04            lda a04c4
; $2228: 6d e9 04            adc a04e9
; $222b: b0 03               bcs b2230
; $222d: 8d e9 04            sta a04e9
; $2230: ad 82 04    b2230   lda a0482
; $2233: d0 42               bne b2277
; $2235: a5 a3               lda aa3
; $2237: 29 1f               and #$1f
; $2239: d0 48               bne b2283
; $223b: ad 5f 04            lda a045f
; $223e: d0 37               bne b2277
; $2240: a8                  tay 
; $2241: 20 50 2c            jsr s2c50
; $2244: d0 31               bne b2277
; $2246: a2 1c               ldx #$1c
; $2248: bd 00 f9    b2248   lda af900,x
; $224b: 95 09               sta f09,x
; $224d: ca                  dex 
; $224e: 10 f8               bpl b2248
; $2250: e8                  inx 
; $2251: a0 09               ldy #$09
; $2253: 20 2d 2c            jsr s2c2d
; $2256: d0 1f               bne b2277
; $2258: a2 03               ldx #$03
; $225a: a0 0b               ldy #$0b
; $225c: 20 2d 2c            jsr s2c2d
; $225f: d0 16               bne b2277
; $2261: a2 06               ldx #$06
; $2263: a0 0d               ldy #$0d
; $2265: 20 2d 2c            jsr s2c2d
; $2268: d0 0d               bne b2277
; $226a: a9 c0               lda #$c0
; $226c: 20 a6 87            jsr e87a6
; $226f: 90 06               bcc b2277
; $2271: 20 ff 80            jsr e80ff
; $2274: 20 24 7c            jsr e7c24
; $2277: 4c 1c 23    b2277   jmp j231c

; $227a: ad 82 04    b227a   lda a0482
; $227d: d0 f8               bne b2277
; $227f: a5 a3               lda aa3
; $2281: 29 1f               and #$1f
; $2283: c9 0a       b2283   cmp #$0a
; $2285: d0 2e               bne b22b5
; $2287: a9 32               lda #$32
; $2289: cd e9 04            cmp a04e9
; $228c: 90 04               bcc b2292
; $228e: 0a                  asl 
; $228f: 20 0d 90            jsr e900d
; $2292: a0 ff       b2292   ldy #$ff
; $2294: 8c f3 06            sty a06f3
; $2297: c8                  iny 
; $2298: 20 4e 2c            jsr s2c4e
; $229b: d0 7f               bne j231c
; $229d: 20 5c 2c            jsr s2c5c
; $22a0: b0 7a               bcs j231c
; $22a2: e9 24               sbc #$24
; $22a4: 90 0c               bcc b22b2
; $22a6: 85 9b               sta a9b
; $22a8: 20 78 99            jsr e9978
; $22ab: a5 9a               lda a9a
; $22ad: 8d f3 06            sta a06f3
; $22b0: d0 6a               bne j231c
; $22b2: 4c d0 87    b22b2   jmp e87d0

; $22b5: c9 0f       b22b5   cmp #$0f
; $22b7: d0 09               bne b22c2
; $22b9: ad 80 04            lda a0480
; $22bc: f0 5e               beq j231c
; $22be: a9 7b               lda #$7b
; $22c0: d0 57               bne b2319
; $22c2: c9 14       b22c2   cmp #$14
; $22c4: d0 56               bne j231c
; $22c6: a9 1e               lda #$1e
; $22c8: 8d 83 04            sta a0483
; $22cb: ad 5f 04            lda a045f
; $22ce: d0 4c               bne j231c
; $22d0: a0 25               ldy #$25
; $22d2: 20 50 2c            jsr s2c50
; $22d5: d0 45               bne j231c
; $22d7: 20 5c 2c            jsr s2c5c
; $22da: 49 ff               eor #$ff
; $22dc: 69 1e               adc #$1e
; $22de: 8d 83 04            sta a0483
; $22e1: b0 cf               bcs b22b2
; $22e3: c9 e0               cmp #$e0
; $22e5: 90 35               bcc j231c
; $22e7: c9 f0               cmp #$f0
; $22e9: 90 18               bcc b2303
; $22eb: a9 05               lda #$05
; $22ed: 20 7f 82            jsr e827f
; $22f0: ad 15 d0            lda $d015    ;sprite display enable
; $22f3: 29 03               and #$03
; $22f5: 8d 15 d0            sta $d015    ;sprite display enable
; $22f8: a9 04               lda #$04
; $22fa: 20 7f 82            jsr e827f
; $22fd: 4e ca 04            lsr a04ca
; $2300: 6e c9 04            ror a04c9
; $2303: ad c2 04    b2303   lda a04c2
; $2306: f0 14               beq j231c
; $2308: a5 98               lda a98
; $230a: 4a                  lsr 
; $230b: 6d a6 04            adc a04a6
; $230e: c9 46               cmp #$46
; $2310: 90 02               bcc b2314
; $2312: a9 46               lda #$46
; $2314: 8d a6 04    b2314   sta a04a6
; $2317: a9 a0               lda #$a0
; $2319: 20 0d 90    b2319   jsr e900d
; $231c: ad 84 04    j231c   lda a0484
; $231f: f0 0f               beq b2330
; $2321: ad 87 04            lda a0487
; $2324: c9 08               cmp #$08
; $2326: b0 08               bcs b2330
; $2328: 20 fa 3c            jsr s3cfa
; $232b: a9 00               lda #$00
; $232d: 8d 84 04            sta a0484
; $2330: ad 81 04    b2330   lda a0481
; $2333: f0 05               beq b233a
; $2335: 20 64 7b            jsr e7b64
; $2338: f0 08               beq b2342
; $233a: a5 67       b233a   lda a67
; $233c: f0 07               beq b2345
; $233e: c6 67               dec a67
; $2340: d0 03               bne b2345
; $2342: 20 86 a7    b2342   jsr ea786
; $2345: a5 a0       b2345   lda aa0
; $2347: d0 1d               bne b2366
; $2349: 4c 32 2a            jmp j2a32

; $234c: 20 af 84    s234c   jsr e84af
; $234f: 10 15               bpl b2366
; $2351: 98                  tya 
; $2352: aa                  tax 
; $2353: a0 00               ldy #$00
; $2355: 31 57               and (p57),y
; $2357: 29 0f               and #$0f
; $2359: 85 aa       s2359   sta aaa
; $235b: f0 09               beq b2366
; $235d: a9 00       b235d   lda #$00
; $235f: 20 0a 37            jsr s370a
; $2362: c6 aa               dec aaa
; $2364: d0 f7               bne b235d
; $2366: 60          b2366   rts 

; $2367: a9 c0       s2367   lda #$c0
; $2369: 8d e0 a8            sta aa8e0
; $236c: a9 00               lda #$00
; $236e: 8d e6 a8            sta aa8e6
; $2371: 60                  rts 

; $2372: a9 d9               lda #$d9
; $2374: d0 02               bne b2378
; $2376: a9 dc               lda #$dc
; $2378: 18          b2378   clc 
; $2379: 6d a8 04            adc a04a8
; $237c: d0 12               bne _2390
; $237e: 48          s237e   pha 
; $237f: aa                  tax 
; $2380: 98                  tya 
; $2381: 48                  pha 
; $2382: a5 5b               lda a5b
; $2384: 48                  pha 
; $2385: a5 5c               lda a5c
; $2387: 48                  pha 
; $2388: a9 5c               lda #$5c
; $238a: 85 5b               sta a5b
; $238c: a9 1a               lda #$1a
; $238e: d0 10               bne _23a0
_2390:                                                                  ;$2390
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
        jsr $777e
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
        lda _254d,x
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
_241b:                                                                  ;$241b
; $241b: aa          b241b   tax 
; $241c: 98                  tya 
; $241d: 48                  pha 
; $241e: a5 5b               lda $5b
; $2420: 48                  pha 
; $2421: a5 5c               lda $5c
; $2423: 48                  pha 
; $2424: 8a                  txa 
; $2425: 0a                  asl 
; $2426: aa                  tax 
;                    f2428   =*+$01
; $2427: bd 0a 25            lda f250a,x
; $242a: 8d 36 24            sta a2436
; $242d: bd 0b 25            lda _250b,x
; $2430: 8d 37 24            sta a2437
; $2433: 8a                  txa 
; $2434: 4a                  lsr 
;                    a2436   =*+$01
;                    a2437   =*+$02
; $2435: 20 24 2f            jsr _2f24
_2438:
; $2438: 68          j2438   pla 
; $2439: 85 5c               sta a5c
; $243b: 68                  pla 
; $243c: 85 5b               sta a5b
; $243e: 68                  pla 
; $243f: a8                  tay 
; $2440: 60                  rts 
_2441:
; $2441: 85 07       b2441   sta a07
; $2443: 98                  tya 
; $2444: 48                  pha 
; $2445: a5 5b               lda a5b
; $2447: 48                  pha 
; $2448: a5 5c               lda a5c
; $244a: 48                  pha 
; $244b: 20 af 84            jsr e84af
; $244e: aa                  tax 
; $244f: a9 00               lda #$00
; $2451: e0 33               cpx #$33
; $2453: 69 00               adc #$00
; $2455: e0 66               cpx #$66
; $2457: 69 00               adc #$00
; $2459: e0 99               cpx #$99
; $245b: 69 00               adc #$00
; $245d: e0 cc               cpx #$cc
; $245f: a6 07               ldx a07
; $2461: 7d 51 3e            adc _3e51,x
; $2464: 20 90 23            jsr _2390
; $2467: 4c 38 24            jmp _2438

; $246a: a9 00               lda #$00
; $246c: 2c a9 20            bit a20a9
; $246f: 8d 18 2f            sta _2f18
; $2472: a9 00               lda #$00
; $2474: 8d 1d 2f            sta _2f1d
; $2477: 60                  rts 

; $2478: a9 06       a2478   lda #$06
; $247a: 20 25 6a            jsr e6a25
; $247d: a9 ff               lda #$ff
; $247f: 8d 19 2f            sta _2f19
; $2482: 60                  rts 

; $2483: a9 01               lda #$01
; $2485: 20 25 6a            jsr e6a25
;                    f248a   =*+$02
; $2488: 4c 2f a7            jmp ea72f

_248b:
; $248b: a9 80       a248b   lda #$80
; $248d: 8d 1d 2f            sta _2f1d
; $2490: a9 20               lda #$20
; $2492: 8d 18 2f            sta _2f18
; $2495: 60                  rts 

; $2496: a9 80               lda #$80
; $2498: 85 34               sta a34
; $249a: a9 ff               lda #$ff
; $249c: 2c a9 00            bit a00a9
; $249f: 8d 1a 2f            sta _2f1a
; $24a2: 60                  rts 

; $24a3: a9 80       s24a3   lda #$80
;                    s24a6   =*+$01
; $24a5: 2c a9 00    a24a5   bit a00a9
; $24a8: 8d 1b 2f            sta a2f1b
; $24ab: 0a                  asl 
; $24ac: 8d 1c 2f            sta a2f1c
; $24af: 60                  rts 

; $24b0: a5 34       a24b0   lda a34
; $24b2: 29 bf               and #$bf
; $24b4: 85 34               sta a34
; $24b6: a9 03               lda #$03
; $24b8: 20 7e 77            jsr e777e
; $24bb: ae 1c 2f            ldx a2f1c
; $24be: bd 47 06            lda f0647,x
; $24c1: 20 f3 24            jsr s24f3
; $24c4: 90 03               bcc b24c9
; $24c6: ce 1c 2f            dec a2f1c
; $24c9: a9 99       b24c9   lda #$99
; $24cb: 4c 90 23            jmp _2390

; $24ce: 20 ed 24            jsr s24ed
; $24d1: 20 af 84            jsr e84af
; $24d4: 29 03               and #$03
; $24d6: a8                  tay 
; $24d7: 20 af 84    b24d7   jsr e84af
; $24da: 29 3e               and #$3e
; $24dc: aa                  tax 
; $24dd: bd 4e 25            lda f254e,x
; $24e0: 20 04 24            jsr _2404
; $24e3: bd 4f 25            lda f254f,x
; $24e6: 20 04 24            jsr _2404
; $24e9: 88                  dey 
; $24ea: 10 eb               bpl b24d7
; $24ec: 60                  rts 

; $24ed: a9 df       s24ed   lda #$df
; $24ef: 8d 1e 2f            sta _2f1e
; $24f2: 60                  rts 

; $24f3: 09 20       s24f3   ora #$20
; $24f5: c9 61               cmp #$61
; $24f7: f0 11               beq f250a
; $24f9: c9 65               cmp #$65
; $24fb: f0 0d               beq f250a
; $24fd: c9 69               cmp #$69
; $24ff: f0 09               beq f250a
; $2501: c9 6f               cmp #$6f
; $2503: f0 05               beq f250a
; $2505: c9 75               cmp #$75
; $2507: f0 01               beq f250a
; $2509: 18                  clc 
; $250a: 60          f250a   rts 

_250b:
        rts 

;===============================================================================

; $250c: 6a                  ror 
; $250d: 24 6d               bit a6d
; $250f: 24 7e               bit a7e
; $2511: 77 7e               rra f7e,x
; $2513: 77 9d               rra f9d,x
; $2515: 24 96               bit a96
; $2517: 24 24               bit a24
; $2519: 2f 78 24            rla a2478
; $251c: 83 24               sax (p24,x)
; $251e: 24 2f               bit a2f
; $2520: dc 28 24            nop f2428,x
; $2523: 2f 8b 24            rla _248b
; $2526: a3 24               lax (p24,x)
; $2528: a6 24               ldx a24
; $252a: 22                  jam 
; $252b: 2f b0 24            rla a24b0
; $252e: ce 24 ed            dec aed24
; $2531: 24 24               bit a24
; $2533: 2f d4 b3            rla ab3d4
; $2536: 41 3e               eor (p3e,x)
; $2538: 57 3e               sre f3e,x
; $253a: 7c 3e 37            nop f373e,x
; $253d: 3e 5b 8a            rol f8a5b,x
; $2540: 72                  jam 
; $2541: 23 76               rla (p76,x)
; $2543: 23 5a               rla (p5a,x)
; $2545: 3e b5 8a            rol f8ab5,x
; $2548: be 8a 24            ldx f248a,y

_254c:
_254d:
;                    f254c   =*+$01
;                    f254d   =*+$02
; $254b: 2f 0c 0a            rla a0a0c
;                    f254f   =*+$01
; $254e: 41 42       f254e   eor (p42,x)
; $2550: 4f 55 53            sre a5355
; $2553: 45 49               eor a49
; $2555: 54 49               nop f49,x
; $2557: 4c 45 54            jmp e5445

; $255a: 53 54               sre (p54),y
; $255c: 4f 4e 4c            sre a4c4e
; $255f: 4f 4e 55            sre a554e
; $2562: 54 48               nop f48,x
; $2564: 4e 4f 41            lsr a414f
; $2567: 4c 4c 45            jmp e454c

; $256a: 58                  cli 
; $256b: 45 47               eor a47
; $256d: 45 5a               eor a5a
; $256f: 41 43               eor (p43,x)
; $2571: 45 42               eor a42
; $2573: 49 53               eor #$53
; $2575: 4f 55 53            sre a5355
; $2578: 45 53               eor a53
; $257a: 41 52               eor (p52,x)
; $257c: 4d 41 49            eor a4941
; $257f: 4e 44 49            lsr a4944
; $2582: 52                  jam 
; $2583: 45 41               eor a41
; $2585: 3f 45 52            rla f5245,x
; $2588: 41 54               eor (p54,x)
; $258a: 45 4e               eor a4e
; $258c: 42                  jam 
; $258d: 45 52               eor a52
; $258f: 41 4c               eor (p4c,x)
; $2591: 41 56               eor (p56,x)
; $2593: 45 54               eor a54
; $2595: 49 45               eor #$45
; $2597: 44 4f               nop a4f
; $2599: 52                  jam 
; $259a: 51 55               eor (p55),y
; $259c: 41 4e               eor (p4e,x)
; $259e: 54 45               nop f45,x
; $25a0: 49 53               eor #$53
; $25a2: 52                  jam 
; $25a3: 49 4f               eor #$4f
; $25a5: 4e 3a 30            lsr a303a
; $25a8: 2e 45 2e            rol a2e45
; $25ab: 6a                  ror 
; $25ac: 61 6d               adc (p6d,x)
; $25ae: 65 73               adc a73
; $25b0: 6f 6e 0d            rra a0d6e
; $25b3: 00 00               brk #$00
; $25b5: 00 00               brk #$00
; $25b7: 00 00               brk #$00
; $25b9: 00 00               brk #$00
; $25bb: 00 00               brk #$00
; $25bd: 00 00               brk #$00
; $25bf: 00 00               brk #$00
; $25c1: 00 00               brk #$00
; $25c3: 00 00               brk #$00
; $25c5: 00 00               brk #$00
; $25c7: 00 00               brk #$00
; $25c9: 00 00               brk #$00
; $25cb: 00 00               brk #$00
; $25cd: 00 00               brk #$00
; $25cf: 00 00               brk #$00
; $25d1: 00 00               brk #$00
; $25d3: 00 00               brk #$00
; $25d5: 00 00               brk #$00
; $25d7: 00 00               brk #$00
; $25d9: 00 00               brk #$00
; $25db: 00 00               brk #$00
; $25dd: 00 00               brk #$00
; $25df: 00 00               brk #$00
; $25e1: 00 00               brk #$00
; $25e3: 00 00               brk #$00
; $25e5: 00 00               brk #$00
; $25e7: 00 10               brk #$10
; $25e9: 0f 11 00            slo a0011
; $25ec: 03 1c               slo (p1c,x)
; $25ee: 0e 00 00            asl f0000
; $25f1: 0a                  asl 
; $25f2: 00 11               brk #$11
; $25f4: 3a                  nop 
; $25f5: 07 09               slo a09
; $25f7: 08                  php 
; $25f8: 00 00               brk #$00
; $25fa: 00 00               brk #$00
; $25fc: 80 00               nop #$00
; $25fe: 00 00               brk #$00
; $2600: 00 00               brk #$00
; $2602: 00 00               brk #$00
; $2604: 00 00               brk #$00
; $2606: 00 00               brk #$00
; $2608: 00 00               brk #$00
; $260a: 00 00               brk #$00
; $260c: 00 00               brk #$00
; $260e: 00 00               brk #$00
; $2610: 00 00               brk #$00
; $2612: 00 00               brk #$00
; $2614: 3a                  nop 
; $2615: 30 2e               bmi b2645
; $2617: 45 2e               eor a2e
; $2619: 4a                  lsr 
; $261a: 41 4d               eor (p4d,x)
; $261c: 45 53               eor a53
; $261e: 4f 4e 0d            sre a0d4e
; $2621: 00 14               brk #$14
; $2623: ad 4a 5a            lda a5a4a
; $2626: 48                  pha 
; $2627: 02                  jam 
; $2628: 53 b7               sre (pb7),y
; $262a: 00 00               brk #$00
; $262c: 03 e8               slo (pe8,x)
; $262e: 46 00               lsr a00
; $2630: 00 0f               brk #$0f
; $2632: 00 00               brk #$00
; $2634: 00 00               brk #$00
; $2636: 00 16               brk #$16
; $2638: 00 00               brk #$00
; $263a: 00 00               brk #$00
; $263c: 00 00               brk #$00
; $263e: 00 00               brk #$00
; $2640: 00 00               brk #$00
; $2642: 00 00               brk #$00
;                    b2645   =*+$01
; $2644: 00 00               brk #$00
; $2646: 00 00               brk #$00
; $2648: 00 00               brk #$00
; $264a: 00 00               brk #$00
; $264c: 00 00               brk #$00
; $264e: 00 00               brk #$00
; $2650: 00 00               brk #$00
; $2652: 00 00               brk #$00
; $2654: 03 00               slo (p00,x)
; $2656: 10 0f               bpl b2667
; $2658: 11 00               ora (p00),y
; $265a: 03 1c               slo (p1c,x)
; $265c: 0e 00 00            asl f0000
; $265f: 0a                  asl 
; $2660: 00 11               brk #$11
; $2662: 3a                  nop 
; $2663: 07 09               slo a09
; $2665: 08                  php 
;                    b2667   =*+$01
; $2666: 00 00               brk #$00
; $2668: 00 00               brk #$00
; $266a: 80 aa               nop #$aa
; $266c: 27 03               rla a03
; $266e: 00 00               brk #$00
; $2670: 00 00               brk #$00
; $2672: 00 00               brk #$00
; $2674: 00 00               brk #$00
; $2676: 00 00               brk #$00
; $2678: 00 00               brk #$00
; $267a: 00 00               brk #$00
; $267c: 00 00               brk #$00
; $267e: 00 ff               brk #$ff
; $2680: ff aa aa            isc faaaa,x
; $2683: aa                  tax 
; $2684: 55 55       b2684   eor f55,x
; $2686: 55 aa               eor faa,x
; $2688: aa                  tax 
; $2689: aa                  tax 
; $268a: aa                  tax 
; $268b: aa                  tax 
; $268c: aa                  tax 
; $268d: 55 aa               eor faa,x
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
; $269e: 00 aa               brk #$aa
; $26a0: 00 00               brk #$00
; $26a2: 00 00               brk #$00
; $26a4: 76 85       f26a4   ror f85,x
; $26a6: 9c a5 8b            shy f8ba5,x
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
; $2733: a9 00               lda #$00
; $2735: 95 35       b2735   sta f35,x
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
; $276f: a0 08               ldy #$08
; $2771: b1 57               lda (p57),y
; $2773: 85 ae               sta aae
; $2775: a5 57               lda a57
; $2777: 18                  clc 
; $2778: 69 14               adc #$14
; $277a: 85 5b               sta a5b
; $277c: a5 58               lda a58
; $277e: 69 00               adc #$00
; $2780: 85 5c               sta a5c
; $2782: a0 00               ldy #$00
; $2784: 84 aa               sty aaa
; $2786: 84 9f               sty a9f
; $2788: b1 5b               lda (p5b),y
; $278a: 85 6b               sta a6b
; $278c: c8                  iny 
; $278d: b1 5b               lda (p5b),y
; $278f: 85 6d               sta a6d
; $2791: c8                  iny 
; $2792: b1 5b               lda (p5b),y
; $2794: 85 6f               sta a6f
; $2796: c8                  iny 
; $2797: b1 5b               lda (p5b),y
; $2799: 85 bb               sta abb
;                    b279c   =*+$01
; $279b: 29 1f               and #$1f
; $279d: c5 ad               cmp aad
; $279f: 90 fb               bcc b279c
; $27a1: c8                  iny 
;                    f27a3   =*+$01
; $27a2: b1 5b               lda (p5b),y
; $27a4: 85 2e       f27a4   sta a2e
; $27a6: 29 0f               and #$0f
; $27a8: aa                  tax 
; $27a9: b5 35               lda f35,x
; $27ab: d0 fe       b27ab   bne b27ab
; $27ad: a5 2e               lda a2e
; $27af: 4a                  lsr 
; $27b0: 4a                  lsr 
; $27b1: 4a                  lsr 
; $27b2: 4a                  lsr 
; $27b3: aa                  tax 
; $27b4: b5 35               lda f35,x
; $27b6: d0 fe       b27b6   bne b27b6
; $27b8: c8                  iny 
; $27b9: b1 5b               lda (p5b),y
; $27bb: 85 2e               sta a2e
; $27bd: 29 0f               and #$0f
; $27bf: aa                  tax 
; $27c0: b5 35               lda f35,x
; $27c2: d0 fe       b27c2   bne b27c2
; $27c4: a5 2e               lda a2e
; $27c6: 4a                  lsr 
; $27c7: 4a                  lsr 
; $27c8: 4a                  lsr 
; $27c9: 4a                  lsr 
; $27ca: aa                  tax 
; $27cb: b5 35               lda f35,x
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
; $27f0: 69 00               adc #$00
; $27f2: 85 6c               sta a6c
; $27f4: 4c b3 9d            jmp e9db3

; $27f7: a5 09               lda a09
; $27f9: 38                  sec 
; $27fa: e5 71               sbc a71
; $27fc: 85 6b               sta a6b
; $27fe: a5 0a               lda a0a
; $2800: e9 00               sbc #$00
; $2802: 85 6c               sta a6c
; $2804: b0 fe       b2804   bcs b2804
; $2806: 49 ff               eor #$ff
; $2808: 85 6c               sta a6c
; $280a: a9 01               lda #$01
; $280c: e5 6b               sbc a6b
; $280e: 85 6b               sta a6b
; $2810: 90 02               bcc b2814
; $2812: e6 6c               inc a6c
; $2814: a5 6d       b2814   lda a6d
; $2816: 49 80               eor #$80
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
; $282b: 69 00               adc #$00
; $282d: 85 6f               sta a6f
; $282f: 4c ee 9d            jmp e9dee

; $2832: a5 0c               lda a0c
; $2834: 38                  sec 
; $2835: e5 73               sbc a73
; $2837: 85 6e               sta a6e
; $2839: a5 0d               lda a0d
; $283b: e9 00               sbc #$00
; $283d: 85 6f               sta a6f
; $283f: b0 fe       b283f   bcs b283f
; $2841: 49 ff               eor #$ff
; $2843: 85 6f               sta a6f
; $2845: a5 6e               lda a6e
; $2847: 49 ff               eor #$ff
; $2849: 69 01               adc #$01
; $284b: 85 6e               sta a6e
; $284d: a5 70               lda a70
; $284f: 49 80               eor #$80
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
; $2864: 69 00               adc #$00
; $2866: 85 99               sta a99
; $2868: 4c 27 9e            jmp e9e27

; $286b: a6 9a               ldx a9a
; $286d: f0 fe       b286d   beq b286d
; $286f: a2 00               ldx #$00
; $2871: 4a          b2871   lsr 
; $2872: e8                  inx 
; $2873: c5 9a               cmp a9a
; $2875: b0 fa               bcs b2871
; $2877: 86 9c               stx a9c
; $2879: 20 af 99            jsr e99af
; $287c: a6 9c               ldx a9c
; $287e: a5 9b               lda a9b
; $2880: 0a          b2880   asl 
; $2881: 26 99               rol a99
; $2883: 30 fe       b2883   bmi b2883
; $2885: ca                  dex 
; $2886: d0 f8               bne b2880
; $2888: 85 9b               sta a9b
; $288a: 60                  rts 

; $288b: a9 32               lda #$32
; $288d: 85 9b               sta a9b
; $288f: 85 99               sta a99
; $2891: 60                  rts 

; $2892: a9 80               lda #$80
; $2894: 38                  sec 
; $2895: e5 9b               sbc a9b
; $2897: 9d 00 01            sta f0100,x
; $289a: e8                  inx 
; $289b: a9 00               lda #$00
; $289d: e5 99               sbc a99
; $289f: 9d 00 01            sta f0100,x
;                    f28a4   =*+$02
; $28a2: 4c 61 00            jmp e0061

_28a4:
_28a5:

; $28a5: f9 25 f9    f28a5   sbc ff925,y
; $28a8: 4a                  lsr 
; $28a9: f9 6f f9            sbc ff96f,y
; $28ac: 94 f9               sty ff9,x
; $28ae: b9 f9 de            lda fdef9,y
; $28b1: f9 03 fa            sbc ffa03,y
; $28b4: 28                  plp 
; $28b5: fa                  nop 
; $28b6: 4d fa 72            eor a72fa
; $28b9: fa                  nop 
; $28ba: 80 40               nop #$40
; $28bc: 20 10 08            jsr e0810
; $28bf: 04 02               nop a02
; $28c1: 01 80               ora (p80,x)
; $28c3: 40                  rti 

; $28c4: c0 30               cpy #$30
;                    f28c8   =*+$02
; $28c6: 0c 03 c0            nop ac003
; $28c9: c0 60               cpy #$60
; $28cb: 30 18               bmi b28e5
; $28cd: 0c 06 03            nop a0306
; $28d0: c0 30       f28d0   cpy #$30
; $28d2: 0c 03 c0            nop ac003
; $28d5: a9 0f               lda #$0f
; $28d7: aa                  tax 
; $28d8: 60                  rts 

; $28d9: 20 7e 77    s28d9   jsr e777e
; $28dc: a9 13               lda #$13
; $28de: d0 05               bne b28e5
; $28e0: a9 17               lda #$17
; $28e2: 20 2b 6a            jsr e6a2b
; $28e5: 85 6c       b28e5   sta a6c
; $28e7: 85 6e               sta a6e
; $28e9: a2 00               ldx #$00
; $28eb: 86 6b               stx a6b
; $28ed: ca                  dex 
; $28ee: 86 6d               stx a6d
; $28f0: 4c 91 ab            jmp eab91

; $28f3: 20 1e 81            jsr e811e
; $28f6: 84 6c               sty a6c
; $28f8: a9 00               lda #$00
; $28fa: 99 80 05            sta f0580,y
; $28fd: 4c fa af            jmp eaffa

; $2900: 80 c0               nop #$c0
; $2902: e0 f0               cpx #$f0
; $2904: f8                  sed 
; $2905: fc fe ff            nop ffffe,x  ;irq
; $2908: 7f 3f 1f            rra f1f3f,x
; $290b: 0f 07 03            slo a0307
;                    s290f   =*+$01
; $290e: 01 20               ora (p20,x)
; $2910: d1 3a               cmp (p3a),y
; $2912: 85 60               sta a60
; $2914: 8a                  txa 
; $2915: 99 c9 06            sta f06c9,y
; $2918: a5 6b       s2918   lda a6b
; $291a: 10 05               bpl b2921
; $291c: 49 7f               eor #$7f
; $291e: 18                  clc 
; $291f: 69 01               adc #$01
; $2921: 49 80       b2921   eor #$80
; $2923: aa                  tax 
; $2924: a5 6c               lda a6c
; $2926: 29 7f               and #$7f
; $2928: c9 48               cmp #$48
; $292a: b0 4a               bcs b2976
; $292c: a5 6c               lda a6c
; $292e: 10 04               bpl b2934
; $2930: 49 7f               eor #$7f
; $2932: 69 01               adc #$01
; $2934: 85 bb       b2934   sta abb
; $2936: a9 49               lda #$49
; $2938: e5 bb               sbc abb
; $293a: 84 06               sty a06
; $293c: a8                  tay 
; $293d: 8a                  txa 
; $293e: 29 f8               and #$f8
; $2940: 18                  clc 
; $2941: 79 00 97            adc f9700,y
; $2944: 85 07               sta a07
; $2946: b9 00 98            lda f9800,y
; $2949: 69 00               adc #$00
; $294b: 85 08               sta a08
; $294d: 98                  tya 
; $294e: 29 07               and #$07
; $2950: a8                  tay 
; $2951: 8a                  txa 
; $2952: 29 07               and #$07
; $2954: aa                  tax 
; $2955: a5 a1               lda aa1
; $2957: c9 90               cmp #$90
; $2959: b0 12               bcs b296d
; $295b: bd c8 28            lda f28c8,x
; $295e: 51 07               eor (p07),y
; $2960: 91 07               sta (p07),y
; $2962: a5 a1               lda aa1
; $2964: c9 50               cmp #$50
; $2966: b0 0c               bcs b2974
; $2968: 88                  dey 
; $2969: 10 02               bpl b296d
; $296b: a0 01               ldy #$01
; $296d: bd c8 28    b296d   lda f28c8,x
; $2970: 51 07               eor (p07),y
; $2972: 91 07               sta (p07),y
; $2974: a4 06       b2974   ldy a06
; $2976: 60          b2976   rts 

; $2977: 8a                  txa 
; $2978: 65 43               adc a43
; $297a: 85 8b               sta a8b
; $297c: a5 44               lda a44
; $297e: 65 bb               adc abb
; $2980: 85 8c               sta a8c
; $2982: a5 a9               lda aa9
; $2984: f0 12               beq b2998
; $2986: e6 a9               inc aa9
; $2988: a4 7e       b2988   ldy a7e
; $298a: a9 ff               lda #$ff
; $298c: d9 a3 27            cmp f27a3,y
; $298f: f0 69               beq b29fa
; $2991: 99 a4 27            sta f27a4,y
; $2994: e6 7e               inc a7e
; $2996: d0 62               bne b29fa
; $2998: a5 85       b2998   lda a85
; $299a: 85 6b               sta a6b
; $299c: a5 86               lda a86
; $299e: 85 6c               sta a6c
; $29a0: a5 87               lda a87
; $29a2: 85 6d               sta a6d
; $29a4: a5 88               lda a88
; $29a6: 85 6e               sta a6e
; $29a8: a5 89               lda a89
; $29aa: 85 6f               sta a6f
; $29ac: a5 8a               lda a8a
; $29ae: 85 70               sta a70
; $29b0: a5 8b               lda a8b
; $29b2: 85 71               sta a71
; $29b4: a5 8c               lda a8c
; $29b6: 85 72               sta a72
; $29b8: 20 13 a0            jsr ea013
; $29bb: b0 cb               bcs b2988
; $29bd: ad f4 06            lda a06f4
; $29c0: f0 10               beq b29d2
; $29c2: a5 6b               lda a6b
; $29c4: a4 6d               ldy a6d
; $29c6: 85 6d               sta a6d
; $29c8: 84 6b               sty a6b
; $29ca: a5 6c               lda a6c
; $29cc: a4 6e               ldy a6e
; $29ce: 85 6e               sta a6e
; $29d0: 84 6c               sty a6c
; $29d2: a4 7e       b29d2   ldy a7e
; $29d4: b9 a3 27            lda f27a3,y
; $29d7: c9 ff               cmp #$ff
; $29d9: d0 0b               bne b29e6
; $29db: a5 6b               lda a6b
; $29dd: 99 a4 26            sta f26a4,y
; $29e0: a5 6c               lda a6c
; $29e2: 99 a4 27            sta f27a4,y
; $29e5: c8                  iny 
; $29e6: a5 6d       b29e6   lda a6d
; $29e8: 99 a4 26            sta f26a4,y
; $29eb: a5 6e               lda a6e
; $29ed: 99 a4 27            sta f27a4,y
; $29f0: c8                  iny 
; $29f1: 84 7e               sty a7e
; $29f3: 20 91 ab            jsr eab91
; $29f6: a5 a2               lda aa2
; $29f8: d0 8e               bne b2988
; $29fa: a5 89       b29fa   lda a89
; $29fc: 85 85               sta a85
; $29fe: a5 8a               lda a8a
; $2a00: 85 86               sta a86
; $2a02: a5 8b               lda a8b
; $2a04: 85 87               sta a87
; $2a06: a5 8c               lda a8c
; $2a08: 85 88               sta a88
; $2a0a: a5 aa               lda aaa
; $2a0c: 18                  clc 
; $2a0d: 65 ac               adc aac
; $2a0f: 85 aa               sta aaa
; $2a11: 60                  rts 

; $2a12: ac 0b 05            ldy a050b
; $2a15: be bc 06    b2a15   ldx f06bc,y
; $2a18: b9 a2 06            lda f06a2,y
; $2a1b: 85 6c               sta a6c
; $2a1d: 99 bc 06            sta f06bc,y
; $2a20: 8a                  txa 
; $2a21: 85 6b               sta a6b
; $2a23: 99 a2 06            sta f06a2,y
; $2a26: b9 d6 06            lda f06d6,y
; $2a29: 85 a1               sta aa1
; $2a2b: 20 18 29            jsr s2918
; $2a2e: 88                  dey 
; $2a2f: d0 e4               bne b2a15
; $2a31: 60                  rts 

; $2a32: ae 86 04    j2a32   ldx a0486
; $2a35: f0 09               beq b2a40
; $2a37: ca                  dex 
; $2a38: d0 03               bne b2a3d
; $2a3a: 4c 2d 2b            jmp j2b2d

; $2a3d: 4c e9 37    b2a3d   jmp j37e9

; $2a40: ac 0b 05    b2a40   ldy a050b
; $2a43: 20 30 3b    j2a43   jsr s3b30
; $2a46: a5 9b               lda a9b
; $2a48: 46 2e               lsr a2e
; $2a4a: 6a                  ror 
; $2a4b: 46 2e               lsr a2e
; $2a4d: 6a                  ror 
; $2a4e: 09 01               ora #$01
; $2a50: 85 9a               sta a9a
; $2a52: b9 e3 06            lda f06e3,y
; $2a55: e5 97               sbc a97
; $2a57: 99 e3 06            sta f06e3,y
; $2a5a: b9 d6 06            lda f06d6,y
; $2a5d: 85 a1               sta aa1
; $2a5f: e5 98               sbc a98
; $2a61: 99 d6 06            sta f06d6,y
; $2a64: 20 92 39            jsr s3992
; $2a67: 85 60               sta a60
; $2a69: a5 2e               lda a2e
; $2a6b: 79 c9 06            adc f06c9,y
; $2a6e: 85 5f               sta a5f
; $2a70: 85 9b               sta a9b
; $2a72: a5 6c               lda a6c
; $2a74: 65 60               adc a60
; $2a76: 85 60               sta a60
; $2a78: 85 9c               sta a9c
; $2a7a: b9 a2 06            lda f06a2,y
; $2a7d: 85 6b               sta a6b
; $2a7f: 20 97 39            jsr s3997
; $2a82: 85 5e               sta a5e
; $2a84: a5 2e               lda a2e
; $2a86: 79 af 06            adc f06af,y
; $2a89: 85 5d               sta a5d
; $2a8b: a5 6b               lda a6b
; $2a8d: 65 5e               adc a5e
; $2a8f: 85 5e               sta a5e
; $2a91: 45 6a               eor a6a
; $2a93: 20 3c 39            jsr s393c
; $2a96: 20 d1 3a            jsr s3ad1
; $2a99: 85 60               sta a60
; $2a9b: 86 5f               stx a5f
; $2a9d: 45 69               eor a69
; $2a9f: 20 34 39            jsr s3934
; $2aa2: 20 d1 3a            jsr s3ad1
; $2aa5: 85 5e               sta a5e
; $2aa7: 86 5d               stx a5d
; $2aa9: a6 64               ldx a64
; $2aab: a5 60               lda a60
; $2aad: 45 95               eor a95
; $2aaf: 20 3e 39            jsr s393e
; $2ab2: 85 9a               sta a9a
; $2ab4: 20 4c 3a            jsr s3a4c
; $2ab7: 06 2e               asl a2e
; $2ab9: 2a                  rol 
; $2aba: 85 bb               sta abb
; $2abc: a9 00               lda #$00
; $2abe: 6a                  ror 
; $2abf: 05 bb               ora abb
; $2ac1: 20 d1 3a            jsr s3ad1
; $2ac4: 85 5e               sta a5e
; $2ac6: 8a                  txa 
; $2ac7: 99 af 06            sta f06af,y
; $2aca: a5 5f               lda a5f
; $2acc: 85 9b               sta a9b
; $2ace: a5 60               lda a60
; $2ad0: 85 9c               sta a9c
; $2ad2: a9 00               lda #$00
; $2ad4: 85 2e               sta a2e
; $2ad6: a5 63               lda a63
; $2ad8: 49 80               eor #$80
; $2ada: 20 0f 29            jsr s290f
; $2add: a5 5e               lda a5e
; $2adf: 85 6b               sta a6b
; $2ae1: 99 a2 06            sta f06a2,y
; $2ae4: 29 7f               and #$7f
; $2ae6: c9 78               cmp #$78
; $2ae8: b0 20               bcs b2b0a
; $2aea: a5 60               lda a60
; $2aec: 99 bc 06            sta f06bc,y
; $2aef: 85 6c               sta a6c
; $2af1: 29 7f               and #$7f
; $2af3: c9 78               cmp #$78
; $2af5: b0 13               bcs b2b0a
; $2af7: b9 d6 06            lda f06d6,y
; $2afa: c9 10               cmp #$10
; $2afc: 90 0c               bcc b2b0a
; $2afe: 85 a1               sta aa1
; $2b00: 20 18 29    j2b00   jsr s2918
; $2b03: 88                  dey 
; $2b04: f0 03               beq b2b09
; $2b06: 4c 43 2a            jmp j2a43

; $2b09: 60          b2b09   rts 

; $2b0a: 20 af 84    b2b0a   jsr e84af
; $2b0d: 09 04               ora #$04
; $2b0f: 85 6c               sta a6c
; $2b11: 99 bc 06            sta f06bc,y
; $2b14: 20 af 84            jsr e84af
; $2b17: 09 08               ora #$08
; $2b19: 85 6b               sta a6b
; $2b1b: 99 a2 06            sta f06a2,y
; $2b1e: 20 af 84            jsr e84af
; $2b21: 09 90               ora #$90
; $2b23: 99 d6 06            sta f06d6,y
; $2b26: 85 a1               sta aa1
; $2b28: a5 6c               lda a6c
; $2b2a: 4c 00 2b            jmp j2b00

; $2b2d: ac 0b 05    j2b2d   ldy a050b
; $2b30: 20 30 3b    j2b30   jsr s3b30
; $2b33: a5 9b               lda a9b
; $2b35: 46 2e               lsr a2e
; $2b37: 6a                  ror 
; $2b38: 46 2e               lsr a2e
; $2b3a: 6a                  ror 
; $2b3b: 09 01               ora #$01
; $2b3d: 85 9a               sta a9a
; $2b3f: b9 a2 06            lda f06a2,y
; $2b42: 85 6b               sta a6b
; $2b44: 20 97 39            jsr s3997
; $2b47: 85 5e               sta a5e
; $2b49: b9 af 06            lda f06af,y
; $2b4c: e5 2e               sbc a2e
; $2b4e: 85 5d               sta a5d
; $2b50: a5 6b               lda a6b
; $2b52: e5 5e               sbc a5e
; $2b54: 85 5e               sta a5e
; $2b56: 20 92 39            jsr s3992
; $2b59: 85 60               sta a60
; $2b5b: b9 c9 06            lda f06c9,y
; $2b5e: e5 2e               sbc a2e
; $2b60: 85 5f               sta a5f
; $2b62: 85 9b               sta a9b
; $2b64: a5 6c               lda a6c
; $2b66: e5 60               sbc a60
; $2b68: 85 60               sta a60
; $2b6a: 85 9c               sta a9c
; $2b6c: b9 e3 06            lda f06e3,y
; $2b6f: 65 97               adc a97
; $2b71: 99 e3 06            sta f06e3,y
; $2b74: b9 d6 06            lda f06d6,y
; $2b77: 85 a1               sta aa1
; $2b79: 65 98               adc a98
; $2b7b: 99 d6 06            sta f06d6,y
; $2b7e: a5 5e               lda a5e
; $2b80: 45 69               eor a69
; $2b82: 20 3c 39            jsr s393c
; $2b85: 20 d1 3a            jsr s3ad1
; $2b88: 85 60               sta a60
; $2b8a: 86 5f               stx a5f
; $2b8c: 45 6a               eor a6a
; $2b8e: 20 34 39            jsr s3934
; $2b91: 20 d1 3a            jsr s3ad1
; $2b94: 85 5e               sta a5e
; $2b96: 86 5d               stx a5d
; $2b98: a5 60               lda a60
; $2b9a: 45 95               eor a95
; $2b9c: a6 64               ldx a64
; $2b9e: 20 3e 39            jsr s393e
; $2ba1: 85 9a               sta a9a
; $2ba3: a5 5e               lda a5e
; $2ba5: 85 9c               sta a9c
; $2ba7: 49 80               eor #$80
; $2ba9: 20 50 3a            jsr s3a50
; $2bac: 06 2e               asl a2e
; $2bae: 2a                  rol 
; $2baf: 85 bb               sta abb
; $2bb1: a9 00               lda #$00
; $2bb3: 6a                  ror 
; $2bb4: 05 bb               ora abb
; $2bb6: 20 d1 3a            jsr s3ad1
; $2bb9: 85 5e               sta a5e
; $2bbb: 8a                  txa 
; $2bbc: 99 af 06            sta f06af,y
; $2bbf: a5 5f               lda a5f
; $2bc1: 85 9b               sta a9b
; $2bc3: a5 60               lda a60
; $2bc5: 85 9c               sta a9c
; $2bc7: a9 00               lda #$00
; $2bc9: 85 2e               sta a2e
; $2bcb: a5 63               lda a63
; $2bcd: 20 0f 29            jsr s290f
; $2bd0: a5 5e               lda a5e
; $2bd2: 85 6b               sta a6b
; $2bd4: 99 a2 06            sta f06a2,y
; $2bd7: a5 60               lda a60
; $2bd9: 99 bc 06            sta f06bc,y
; $2bdc: 85 6c               sta a6c
; $2bde: 29 7f               and #$7f
; $2be0: c9 6e               cmp #$6e
; $2be2: b0 13               bcs b2bf7
; $2be4: b9 d6 06            lda f06d6,y
; $2be7: c9 a0               cmp #$a0
; $2be9: b0 0c               bcs b2bf7
; $2beb: 85 a1               sta aa1
; $2bed: 20 18 29    j2bed   jsr s2918
; $2bf0: 88                  dey 
; $2bf1: f0 03               beq b2bf6
; $2bf3: 4c 30 2b            jmp j2b30

; $2bf6: 60          b2bf6   rts 

; $2bf7: 20 af 84    b2bf7   jsr e84af
; $2bfa: 29 7f               and #$7f
; $2bfc: 69 0a               adc #$0a
; $2bfe: 99 d6 06            sta f06d6,y
; $2c01: 85 a1               sta aa1
; $2c03: 4a                  lsr 
; $2c04: b0 14               bcs b2c1a
; $2c06: 4a                  lsr 
; $2c07: a9 fc               lda #$fc
; $2c09: 6a                  ror 
; $2c0a: 85 6b               sta a6b
; $2c0c: 99 a2 06            sta f06a2,y
; $2c0f: 20 af 84            jsr e84af
; $2c12: 85 6c               sta a6c
; $2c14: 99 bc 06            sta f06bc,y
; $2c17: 4c ed 2b            jmp j2bed

; $2c1a: 20 af 84    b2c1a   jsr e84af
; $2c1d: 85 6b               sta a6b
; $2c1f: 99 a2 06            sta f06a2,y
; $2c22: 4a                  lsr 
; $2c23: a9 e6               lda #$e6
; $2c25: 6a                  ror 
; $2c26: 85 6c               sta a6c
; $2c28: 99 bc 06            sta f06bc,y
; $2c2b: d0 c0               bne j2bed
; $2c2d: b9 09 00    s2c2d   lda f0009,y
; $2c30: 0a                  asl 
; $2c31: 85 78               sta a78
; $2c33: b9 0a 00            lda f000a,y
; $2c36: 2a                  rol 
; $2c37: 85 79               sta a79
; $2c39: a9 00               lda #$00
; $2c3b: 6a                  ror 
; $2c3c: 85 7a               sta a7a
; $2c3e: 20 69 2d            jsr s2d69
; $2c41: 95 0b               sta f0b,x
; $2c43: a4 78               ldy a78
; $2c45: 94 09               sty f09,x
; $2c47: a4 79               ldy a79
; $2c49: 94 0a               sty f0a,x
; $2c4b: 29 7f               and #$7f
; $2c4d: 60                  rts 

; $2c4e: a9 00       s2c4e   lda #$00
; $2c50: 19 02 f9    s2c50   ora ff902,y
; $2c53: 19 05 f9            ora ff905,y
; $2c56: 19 08 f9            ora ff908,y
; $2c59: 29 7f               and #$7f
; $2c5b: 60                  rts 

; $2c5c: b9 01 f9    s2c5c   lda ff901,y
; $2c5f: 20 88 39            jsr s3988
; $2c62: 85 9b               sta a9b
; $2c64: b9 04 f9            lda ff904,y
; $2c67: 20 88 39            jsr s3988
; $2c6a: 65 9b               adc a9b
; $2c6c: b0 0c               bcs b2c7a
; $2c6e: 85 9b               sta a9b
; $2c70: b9 07 f9            lda ff907,y
; $2c73: 20 88 39            jsr s3988
; $2c76: 65 9b               adc a9b
; $2c78: 90 02               bcc b2c7c
; $2c7a: a9 ff       b2c7a   lda #$ff
; $2c7c: 60          b2c7c   rts 

; $2c7d: a9 cd       b2c7d   lda #$cd
; $2c7f: 20 90 23            jsr _2390
; $2c82: 20 79 b1            jsr eb179
; $2c85: 4c c7 2c            jmp j2cc7

; $2c88: a2 09       b2c88   ldx #$09
; $2c8a: c9 19               cmp #$19
; $2c8c: b0 60               bcs b2cee
; $2c8e: ca                  dex 
; $2c8f: c9 0a               cmp #$0a
; $2c91: b0 5b               bcs b2cee
; $2c93: ca                  dex 
; $2c94: c9 02               cmp #$02
; $2c96: b0 56               bcs b2cee
; $2c98: ca                  dex 
; $2c99: d0 53               bne b2cee
; $2c9b: a9 08               lda #$08
; $2c9d: 20 2f 6a            jsr e6a2f
; $2ca0: 20 ab 70            jsr e70ab
; $2ca3: a9 07               lda #$07
; $2ca5: 20 25 6a            jsr e6a25
; $2ca8: a9 7e               lda #$7e
; $2caa: 20 d9 28            jsr s28d9
; $2cad: a9 0f               lda #$0f
; $2caf: a4 a7               ldy aa7
; $2cb1: d0 ca               bne b2c7d
; $2cb3: a9 e6               lda #$e6
; $2cb5: ac 7f 04            ldy a047f
; $2cb8: be 54 04            ldx f0454,y
; $2cbb: f0 07               beq b2cc4
; $2cbd: ac e9 04            ldy a04e9
; $2cc0: c0 80               cpy #$80
; $2cc2: 69 01               adc #$01
; $2cc4: 20 73 77    b2cc4   jsr e7773
; $2cc7: a9 7d       j2cc7   lda #$7d
; $2cc9: 20 9b 6a            jsr e6a9b
; $2ccc: a9 13               lda #$13
; $2cce: ac cd 04            ldy a04cd
; $2cd1: f0 04               beq b2cd7
; $2cd3: c0 32               cpy #$32
; $2cd5: 69 01               adc #$01
; $2cd7: 20 73 77    b2cd7   jsr e7773
; $2cda: a9 10               lda #$10
; $2cdc: 20 9b 6a            jsr e6a9b
; $2cdf: ad e1 04            lda a04e1
; $2ce2: d0 a4               bne b2c88
; $2ce4: aa                  tax 
; $2ce5: ad e0 04            lda a04e0
; $2ce8: 4a                  lsr 
; $2ce9: 4a                  lsr 
; $2cea: e8          b2cea   inx 
; $2ceb: 4a                  lsr 
; $2cec: d0 fc               bne b2cea
; $2cee: 8a          b2cee   txa 
; $2cef: 18                  clc 
; $2cf0: 69 15               adc #$15
; $2cf2: 20 73 77            jsr e7773
; $2cf5: a9 12               lda #$12
; $2cf7: 20 61 2d            jsr s2d61
; $2cfa: ad c7 04            lda a04c7
; $2cfd: f0 05               beq b2d04
; $2cff: a9 70               lda #$70
; $2d01: 20 61 2d            jsr s2d61
; $2d04: ad c2 04    b2d04   lda a04c2
; $2d07: f0 05               beq b2d0e
; $2d09: a9 6f               lda #$6f
; $2d0b: 20 61 2d            jsr s2d61
; $2d0e: ad c1 04    b2d0e   lda a04c1
; $2d11: f0 05               beq b2d18
; $2d13: a9 6c               lda #$6c
; $2d15: 20 61 2d            jsr s2d61
; $2d18: a9 71       b2d18   lda #$71
; $2d1a: 85 ad               sta aad
; $2d1c: a8          b2d1c   tay 
; $2d1d: be 52 04            ldx f0452,y
; $2d20: f0 03               beq b2d25
; $2d22: 20 61 2d            jsr s2d61
; $2d25: e6 ad       b2d25   inc aad
; $2d27: a5 ad               lda aad
; $2d29: c9 75               cmp #$75
; $2d2b: 90 ef               bcc b2d1c
; $2d2d: a2 00               ldx #$00
; $2d2f: 86 aa       b2d2f   stx aaa
; $2d31: bc a9 04            ldy f04a9,x
; $2d34: f0 23               beq b2d59
; $2d36: 8a                  txa 
; $2d37: 18                  clc 
; $2d38: 69 60               adc #$60
; $2d3a: 20 9b 6a            jsr e6a9b
; $2d3d: a9 67               lda #$67
; $2d3f: a6 aa               ldx aaa
; $2d41: bc a9 04            ldy f04a9,x
; $2d44: c0 8f               cpy #$8f
; $2d46: d0 02               bne b2d4a
; $2d48: a9 68               lda #$68
; $2d4a: c0 97       b2d4a   cpy #$97
; $2d4c: d0 02               bne b2d50
; $2d4e: a9 75               lda #$75
; $2d50: c0 32       b2d50   cpy #$32
; $2d52: d0 02               bne b2d56
; $2d54: a9 76               lda #$76
; $2d56: 20 61 2d    b2d56   jsr s2d61
; $2d59: a6 aa       b2d59   ldx aaa
; $2d5b: e8                  inx 
; $2d5c: e0 04               cpx #$04
; $2d5e: 90 cf               bcc b2d2f
; $2d60: 60                  rts 

; $2d61: 20 73 77    s2d61   jsr e7773
; $2d64: a9 06               lda #$06
; $2d66: 4c 25 6a            jmp e6a25

; $2d69: a5 7a       s2d69   lda a7a
; $2d6b: 85 9c               sta a9c
; $2d6d: 29 80               and #$80
; $2d6f: 85 bb               sta abb
; $2d71: 55 0b               eor f0b,x
; $2d73: 30 18               bmi b2d8d
; $2d75: a5 78               lda a78
; $2d77: 18                  clc 
; $2d78: 75 09               adc f09,x
; $2d7a: 85 78               sta a78
; $2d7c: a5 79               lda a79
; $2d7e: 75 0a               adc f0a,x
; $2d80: 85 79               sta a79
; $2d82: a5 7a               lda a7a
; $2d84: 75 0b               adc f0b,x
; $2d86: 29 7f               and #$7f
; $2d88: 05 bb               ora abb
; $2d8a: 85 7a               sta a7a
; $2d8c: 60                  rts 

; $2d8d: a5 9c       b2d8d   lda a9c
; $2d8f: 29 7f               and #$7f
; $2d91: 85 9c               sta a9c
; $2d93: b5 09               lda f09,x
; $2d95: 38                  sec 
; $2d96: e5 78               sbc a78
; $2d98: 85 78               sta a78
; $2d9a: b5 0a               lda f0a,x
; $2d9c: e5 79               sbc a79
; $2d9e: 85 79               sta a79
; $2da0: b5 0b               lda f0b,x
; $2da2: 29 7f               and #$7f
; $2da4: e5 9c               sbc a9c
; $2da6: 09 80               ora #$80
; $2da8: 45 bb               eor abb
; $2daa: 85 7a               sta a7a
; $2dac: b0 16               bcs b2dc4
; $2dae: a9 01               lda #$01
; $2db0: e5 78               sbc a78
; $2db2: 85 78               sta a78
; $2db4: a9 00               lda #$00
; $2db6: e5 79               sbc a79
; $2db8: 85 79               sta a79
; $2dba: a9 00               lda #$00
; $2dbc: e5 7a               sbc a7a
; $2dbe: 29 7f               and #$7f
; $2dc0: 05 bb               ora abb
; $2dc2: 85 7a               sta a7a
; $2dc4: 60          b2dc4   rts 

; $2dc5: b5 0a               lda f0a,x
; $2dc7: 29 7f               and #$7f
; $2dc9: 4a                  lsr 
; $2dca: 85 bb               sta abb
; $2dcc: b5 09               lda f09,x
; $2dce: 38                  sec 
; $2dcf: e5 bb               sbc abb
; $2dd1: 85 9b               sta a9b
; $2dd3: b5 0a               lda f0a,x
; $2dd5: e9 00               sbc #$00
; $2dd7: 85 9c               sta a9c
; $2dd9: b9 09 00            lda f0009,y
; $2ddc: 85 2e               sta a2e
; $2dde: b9 0a 00            lda f000a,y
; $2de1: 29 80               and #$80
; $2de3: 85 bb               sta abb
; $2de5: b9 0a 00            lda f000a,y
; $2de8: 29 7f               and #$7f
; $2dea: 4a                  lsr 
; $2deb: 66 2e               ror a2e
; $2ded: 4a                  lsr 
; $2dee: 66 2e               ror a2e
; $2df0: 4a                  lsr 
; $2df1: 66 2e               ror a2e
; $2df3: 4a                  lsr 
; $2df4: 66 2e               ror a2e
; $2df6: 05 bb               ora abb
; $2df8: 45 b1               eor ab1
; $2dfa: 86 9a               stx a9a
; $2dfc: 20 d1 3a            jsr s3ad1
; $2dff: 85 78               sta a78
; $2e01: 86 77               stx a77
; $2e03: a6 9a               ldx a9a
; $2e05: b9 0a 00            lda f000a,y
; $2e08: 29 7f               and #$7f
; $2e0a: 4a                  lsr 
; $2e0b: 85 bb               sta abb
; $2e0d: b9 09 00            lda f0009,y
; $2e10: 38                  sec 
; $2e11: e5 bb               sbc abb
; $2e13: 85 9b               sta a9b
; $2e15: b9 0a 00            lda f000a,y
; $2e18: e9 00               sbc #$00
; $2e1a: 85 9c               sta a9c
; $2e1c: b5 09               lda f09,x
; $2e1e: 85 2e               sta a2e
; $2e20: b5 0a               lda f0a,x
; $2e22: 29 80               and #$80
; $2e24: 85 bb               sta abb
; $2e26: b5 0a               lda f0a,x
; $2e28: 29 7f               and #$7f
; $2e2a: 4a                  lsr 
; $2e2b: 66 2e               ror a2e
; $2e2d: 4a                  lsr 
; $2e2e: 66 2e               ror a2e
; $2e30: 4a                  lsr 
; $2e31: 66 2e               ror a2e
; $2e33: 4a                  lsr 
; $2e34: 66 2e               ror a2e
; $2e36: 05 bb               ora abb
; $2e38: 49 80               eor #$80
; $2e3a: 45 b1               eor ab1
; $2e3c: 86 9a               stx a9a
; $2e3e: 20 d1 3a            jsr s3ad1
; $2e41: 99 0a 00            sta f000a,y
;                    a2e45   =*+$01
; $2e44: 96 09               stx f09,y
; $2e46: a6 9a               ldx a9a
; $2e48: a5 77               lda a77
; $2e4a: 95 09               sta f09,x
; $2e4c: a5 78               lda a78
; $2e4e: 95 0a               sta f0a,x
; $2e50: 60                  rts 

; $2e51: 48          f2e51   pha 
; $2e52: 76 e8               ror fe8,x
; $2e54: 00 a9               brk #$a9
; $2e56: 03 a0               slo (pa0,x)
; $2e58: 00 85               brk #$85
; $2e5a: 99 a9 00            sta a00a9,y
; $2e5d: 85 77               sta a77
; $2e5f: 85 78               sta a78
; $2e61: 84 79               sty a79
; $2e63: 86 7a               stx a7a
; $2e65: a2 0b               ldx #$0b
; $2e67: 86 bb               stx abb
; $2e69: 08                  php 
; $2e6a: 90 04               bcc b2e70
; $2e6c: c6 bb               dec abb
; $2e6e: c6 99               dec a99
; $2e70: a9 0b       b2e70   lda #$0b
; $2e72: 38                  sec 
; $2e73: 85 9f               sta a9f
; $2e75: e5 99               sbc a99
; $2e77: 85 99               sta a99
; $2e79: e6 99               inc a99
; $2e7b: a0 00               ldy #$00
; $2e7d: 84 9c               sty a9c
; $2e7f: 4c c1 2e            jmp j2ec1

; $2e82: 06 7a       j2e82   asl a7a
; $2e84: 26 79               rol a79
; $2e86: 26 78               rol a78
; $2e88: 26 77               rol a77
; $2e8a: 26 9c               rol a9c
; $2e8c: a2 03               ldx #$03
; $2e8e: b5 77       b2e8e   lda f77,x
; $2e90: 95 6b               sta f6b,x
; $2e92: ca                  dex 
; $2e93: 10 f9               bpl b2e8e
; $2e95: a5 9c               lda a9c
; $2e97: 85 6f               sta a6f
; $2e99: 06 7a               asl a7a
; $2e9b: 26 79               rol a79
; $2e9d: 26 78               rol a78
; $2e9f: 26 77               rol a77
; $2ea1: 26 9c               rol a9c
; $2ea3: 06 7a               asl a7a
; $2ea5: 26 79               rol a79
; $2ea7: 26 78               rol a78
; $2ea9: 26 77               rol a77
; $2eab: 26 9c               rol a9c
; $2ead: 18                  clc 
; $2eae: a2 03               ldx #$03
; $2eb0: b5 77       b2eb0   lda f77,x
; $2eb2: 75 6b               adc f6b,x
; $2eb4: 95 77               sta f77,x
; $2eb6: ca                  dex 
; $2eb7: 10 f7               bpl b2eb0
; $2eb9: a5 6f               lda a6f
; $2ebb: 65 9c               adc a9c
; $2ebd: 85 9c               sta a9c
; $2ebf: a0 00               ldy #$00
; $2ec1: a2 03       j2ec1   ldx #$03
; $2ec3: 38                  sec 
; $2ec4: b5 77       b2ec4   lda f77,x
; $2ec6: fd 51 2e            sbc f2e51,x
; $2ec9: 95 6b               sta f6b,x
; $2ecb: ca                  dex 
; $2ecc: 10 f6               bpl b2ec4
; $2ece: a5 9c               lda a9c
; $2ed0: e9 17               sbc #$17
; $2ed2: 85 6f               sta a6f
; $2ed4: 90 11               bcc b2ee7
; $2ed6: a2 03               ldx #$03
; $2ed8: b5 6b       b2ed8   lda f6b,x
; $2eda: 95 77               sta f77,x
; $2edc: ca                  dex 
; $2edd: 10 f9               bpl b2ed8
; $2edf: a5 6f               lda a6f
; $2ee1: 85 9c               sta a9c
; $2ee3: c8                  iny 
; $2ee4: 4c c1 2e            jmp j2ec1

; $2ee7: 98          b2ee7   tya 
; $2ee8: d0 0c               bne b2ef6
; $2eea: a5 bb               lda abb
; $2eec: f0 08               beq b2ef6
; $2eee: c6 99               dec a99
; $2ef0: 10 0e               bpl b2f00
; $2ef2: a9 20               lda #$20
; $2ef4: d0 07               bne b2efd
; $2ef6: a0 00       b2ef6   ldy #$00
; $2ef8: 84 bb               sty abb
; $2efa: 18                  clc 
; $2efb: 69 30               adc #$30
; $2efd: 20 24 2f    b2efd   jsr _2f24
; $2f00: c6 bb       b2f00   dec abb
; $2f02: 10 02               bpl b2f06
; $2f04: e6 bb               inc abb
; $2f06: c6 9f       b2f06   dec a9f
; $2f08: 30 0d               bmi b2f17
; $2f0a: d0 08               bne b2f14
; $2f0c: 28                  plp 
; $2f0d: 90 05               bcc b2f14
; $2f0f: a9 2e               lda #$2e
; $2f11: 20 24 2f            jsr _2f24
; $2f14: 4c 82 2e    b2f14   jmp j2e82

; $2f17: 60          b2f17   rts 

_2f18:
_2f19:
_2f1a:
;                    a2f19   =*+$01
;                    a2f1a   =*+$02
; $2f18: 20 ff 00    a2f18   jsr e00ff
;                    a2f1c   =*+$01
; $2f1b: 00 00       a2f1b   brk #$00
;                    a2f1e   =*+$01
_2f1d:
_2f1e:
; $2f1d: 00 ff       a2f1d   brk #$ff
; $2f1f: a9 0c               lda #$0c
; $2f21: 2c a9 41            bit a41a9
_2f24:
; $2f24: 86 07       j2f24   stx a07
; $2f26: a2 ff               ldx #$ff
; $2f28: 8e 1e 2f            stx _2f1e
; $2f2b: c9 2e               cmp #$2e
; $2f2d: f0 11               beq b2f40
; $2f2f: c9 3a               cmp #$3a
; $2f31: f0 0d               beq b2f40
; $2f33: c9 0a               cmp #$0a
; $2f35: f0 09               beq b2f40
; $2f37: c9 0c               cmp #$0c
; $2f39: f0 05               beq b2f40
; $2f3b: c9 20               cmp #$20
; $2f3d: f0 01               beq b2f40
; $2f3f: e8                  inx 
; $2f40: 8e 19 2f    b2f40   stx _2f19
; $2f43: a6 07               ldx a07
; $2f45: 2c 1b 2f            bit a2f1b
; $2f48: 30 03               bmi b2f4d
; $2f4a: 4c 7b b1            jmp eb17b

; $2f4d: 2c 1b 2f    b2f4d   bit a2f1b
; $2f50: 70 04               bvs b2f56
; $2f52: c9 0c               cmp #$0c
; $2f54: f0 0d               beq b2f63
; $2f56: ae 1c 2f    b2f56   ldx a2f1c
; $2f59: 9d 48 06            sta f0648,x
; $2f5c: a6 07               ldx a07
; $2f5e: ee 1c 2f            inc a2f1c
; $2f61: 18                  clc 
; $2f62: 60                  rts 

; $2f63: 8a          b2f63   txa 
; $2f64: 48                  pha 
; $2f65: 98                  tya 
; $2f66: 48                  pha 
; $2f67: ae 1c 2f    b2f67   ldx a2f1c
; $2f6a: f0 78               beq b2fe4
; $2f6c: e0 1f               cpx #$1f
; $2f6e: 90 71               bcc b2fe1
; $2f70: 46 08               lsr a08
; $2f72: a5 08       b2f72   lda a08
; $2f74: 30 04               bmi b2f7a
; $2f76: a9 40               lda #$40
; $2f78: 85 08               sta a08
; $2f7a: a0 1d       b2f7a   ldy #$1d
; $2f7c: ad 66 06    b2f7c   lda a0666
; $2f7f: c9 20               cmp #$20
; $2f81: f0 2d               beq b2fb0
; $2f83: 88          b2f83   dey 
; $2f84: 30 ec               bmi b2f72
; $2f86: f0 ea               beq b2f72
; $2f88: b9 48 06            lda f0648,y
; $2f8b: c9 20               cmp #$20
; $2f8d: d0 f4               bne b2f83
; $2f8f: 06 08               asl a08
; $2f91: 30 f0               bmi b2f83
; $2f93: 84 07               sty a07
; $2f95: ac 1c 2f            ldy a2f1c
; $2f98: b9 48 06    b2f98   lda f0648,y
; $2f9b: 99 49 06            sta f0649,y
; $2f9e: 88                  dey 
; $2f9f: c4 07               cpy a07
; $2fa1: b0 f5               bcs b2f98
; $2fa3: ee 1c 2f            inc a2f1c
; $2fa6: d9 48 06    b2fa6   cmp f0648,y
; $2fa9: d0 d1               bne b2f7c
; $2fab: 88                  dey 
; $2fac: 10 f8               bpl b2fa6
; $2fae: 30 c2               bmi b2f72
; $2fb0: a2 1e       b2fb0   ldx #$1e
; $2fb2: 20 d4 2f            jsr s2fd4
; $2fb5: a9 0c               lda #$0c
; $2fb7: 20 7b b1            jsr eb17b
; $2fba: ad 1c 2f            lda a2f1c
; $2fbd: e9 1e               sbc #$1e
; $2fbf: 8d 1c 2f            sta a2f1c
; $2fc2: aa                  tax 
; $2fc3: f0 1f               beq b2fe4
; $2fc5: a0 00               ldy #$00
; $2fc7: e8                  inx 
; $2fc8: b9 67 06    b2fc8   lda f0667,y
; $2fcb: 99 48 06            sta f0648,y
; $2fce: c8                  iny 
; $2fcf: ca                  dex 
; $2fd0: d0 f6               bne b2fc8
; $2fd2: f0 93               beq b2f67
; $2fd4: a0 00       s2fd4   ldy #$00
; $2fd6: b9 48 06    b2fd6   lda f0648,y
; $2fd9: 20 7b b1            jsr eb17b
; $2fdc: c8                  iny 
; $2fdd: ca                  dex 
; $2fde: d0 f6               bne b2fd6
; $2fe0: 60          b2fe0   rts 

; $2fe1: 20 d4 2f    b2fe1   jsr s2fd4
; $2fe4: 8e 1c 2f    b2fe4   stx a2f1c
; $2fe7: 68                  pla 
; $2fe8: a8                  tay 
; $2fe9: 68                  pla 
; $2fea: aa                  tax 
; $2feb: a9 0c               lda #$0c
; $2fed: 2c a9 07            bit a07a9
; $2ff0: 4c 7b b1            jmp eb17b

; $2ff3: a9 70               lda #<p5770
; $2ff5: 85 07               sta a07
; $2ff7: a9 57               lda #>p5770
; $2ff9: 85 08               sta a08
; $2ffb: 20 bb 30            jsr s30bb
; $2ffe: 86 78               stx a78
; $3000: 85 77               sta a77
; $3002: a9 0e               lda #$0e
; $3004: 85 06               sta a06
; $3006: a5 96               lda a96
; $3008: 20 ce 30            jsr s30ce
; $300b: a9 00               lda #$00
; $300d: 85 9b               sta a9b
; $300f: 85 2e               sta a2e
; $3011: a9 08               lda #$08
; $3013: 85 9c               sta a9c
; $3015: a5 68               lda a68
; $3017: 4a                  lsr 
; $3018: 4a                  lsr 
; $3019: 05 69               ora a69
; $301b: 49 80               eor #$80
; $301d: 20 d1 3a            jsr s3ad1
; $3020: 20 30 31            jsr s3130
; $3023: a5 63               lda a63
; $3025: a6 64               ldx a64
; $3027: f0 02               beq b302b
; $3029: e9 01               sbc #$01
; $302b: 20 d1 3a    b302b   jsr s3ad1
; $302e: 20 30 31            jsr s3130
; $3031: a5 a3               lda aa3
; $3033: 29 03               and #$03
; $3035: d0 a9               bne b2fe0
; $3037: a0 00               ldy #$00
;                    a303a   =*+$01
; $3039: 20 bb 30            jsr s30bb
; $303c: 86 77               stx a77
; $303e: 85 78               sta a78
; $3040: a2 03               ldx #$03
; $3042: 86 06               stx a06
; $3044: 94 71       b3044   sty f71,x
; $3046: ca                  dex 
; $3047: 10 fb               bpl b3044
; $3049: a2 03               ldx #$03
; $304b: ad e9 04            lda a04e9
; $304e: 4a                  lsr 
; $304f: 4a                  lsr 
; $3050: 85 9a               sta a9a
; $3052: 38          b3052   sec 
; $3053: e9 10               sbc #$10
; $3055: 90 0d               bcc b3064
; $3057: 85 9a               sta a9a
; $3059: a9 10               lda #$10
; $305b: 95 71               sta f71,x
; $305d: a5 9a               lda a9a
; $305f: ca                  dex 
; $3060: 10 f0               bpl b3052
; $3062: 30 04               bmi b3068
; $3064: a5 9a       b3064   lda a9a
; $3066: 95 71               sta f71,x
; $3068: b9 71 00    b3068   lda f0071,y
; $306b: 84 2e               sty a2e
; $306d: 20 cf 30            jsr s30cf
; $3070: a4 2e               ldy a2e
; $3072: c8                  iny 
; $3073: c0 04               cpy #$04
; $3075: d0 f1               bne b3068
; $3077: a9 b0               lda #<p56b0
; $3079: 85 07               sta a07
; $307b: a9 56               lda #>p56b0
; $307d: 85 08               sta a08
; $307f: a9 aa               lda #$aa
; $3081: 85 77               sta a77
; $3083: 85 78               sta a78
; $3085: ad e7 04            lda a04e7
; $3088: 20 cb 30            jsr s30cb
; $308b: ad e8 04            lda a04e8
; $308e: 20 cb 30            jsr s30cb
; $3091: ad a6 04            lda a04a6
; $3094: 20 cd 30            jsr s30cd
; $3097: 20 bb 30            jsr s30bb
; $309a: 86 78               stx a78
; $309c: 85 77               sta a77
; $309e: a2 0b               ldx #$0b
; $30a0: 86 06               stx a06
; $30a2: ad 83 04            lda a0483
; $30a5: 20 cb 30            jsr s30cb
; $30a8: ad 88 04            lda a0488
; $30ab: 20 cb 30            jsr s30cb
; $30ae: a9 f0               lda #$f0
; $30b0: 85 06               sta a06
; $30b2: ad f3 06            lda a06f3
; $30b5: 20 cb 30            jsr s30cb
; $30b8: 4c 6f 7b            jmp e7b6f

; $30bb: a2 aa       s30bb   ldx #$aa
; $30bd: a5 a3               lda aa3
; $30bf: 29 08               and #$08
; $30c1: 2d 09 1d            and a1d09
; $30c4: f0 02               beq b30c8
; $30c6: 8a                  txa 
;                    b30c8   =*+$01
; $30c7: 2c a9 55            bit a55a9
; $30ca: 60                  rts 

; $30cb: 4a          s30cb   lsr 
; $30cc: 4a                  lsr 
; $30cd: 4a          s30cd   lsr 
; $30ce: 4a          s30ce   lsr 
; $30cf: 85 9a       s30cf   sta a9a
; $30d1: a2 ff               ldx #$ff
; $30d3: 86 9b               stx a9b
; $30d5: c5 06               cmp a06
; $30d7: b0 04               bcs b30dd
; $30d9: a5 78               lda a78
; $30db: d0 02               bne b30df
; $30dd: a5 77       b30dd   lda a77
; $30df: 85 32       b30df   sta a32
; $30e1: a0 02               ldy #$02
; $30e3: a2 03               ldx #$03
; $30e5: a5 9a       b30e5   lda a9a
; $30e7: c9 04               cmp #$04
; $30e9: 90 1e               bcc b3109
; $30eb: e9 04               sbc #$04
; $30ed: 85 9a               sta a9a
; $30ef: a5 9b               lda a9b
; $30f1: 25 32       j30f1   and a32
; $30f3: 91 07               sta (p07),y
; $30f5: c8                  iny 
; $30f6: 91 07               sta (p07),y
; $30f8: c8                  iny 
; $30f9: 91 07               sta (p07),y
; $30fb: 98                  tya 
; $30fc: 18                  clc 
; $30fd: 69 06               adc #$06
; $30ff: 90 02               bcc b3103
; $3101: e6 08               inc a08
; $3103: a8          b3103   tay 
; $3104: ca                  dex 
; $3105: 30 1b               bmi b3122
; $3107: 10 dc               bpl b30e5
; $3109: 49 03       b3109   eor #$03
; $310b: 85 9a               sta a9a
; $310d: a5 9b               lda a9b
; $310f: 0a          b310f   asl 
; $3110: 0a                  asl 
; $3111: c6 9a               dec a9a
; $3113: 10 fa               bpl b310f
; $3115: 48                  pha 
; $3116: a9 00               lda #>p63
; $3118: 85 9b               sta a9b
; $311a: a9 63               lda #<p63
; $311c: 85 9a               sta a9a
; $311e: 68                  pla 
; $311f: 4c f1 30            jmp j30f1

; $3122: a5 07       b3122   lda a07
; $3124: 18                  clc 
; $3125: 69 40               adc #$40
; $3127: 85 07               sta a07
; $3129: a5 08               lda a08
; $312b: 69 01               adc #$01
; $312d: 85 08               sta a08
; $312f: 60                  rts 

; $3130: a0 01       s3130   ldy #$01
; $3132: 85 9a               sta a9a
; $3134: 38          b3134   sec 
; $3135: a5 9a               lda a9a
; $3137: e9 04               sbc #$04
; $3139: b0 0e               bcs b3149
; $313b: a9 ff               lda #$ff
; $313d: a6 9a               ldx a9a
; $313f: 85 9a               sta a9a
; $3141: bd d0 28            lda f28d0,x
; $3144: 29 aa               and #$aa
; $3146: 4c 4d 31            jmp j314d

; $3149: 85 9a       b3149   sta a9a
; $314b: a9 00               lda #$00
; $314d: 91 07       j314d   sta (p07),y
; $314f: c8                  iny 
; $3150: 91 07               sta (p07),y
; $3152: c8                  iny 
; $3153: 91 07               sta (p07),y
; $3155: c8                  iny 
; $3156: 91 07               sta (p07),y
; $3158: 98                  tya 
; $3159: 18                  clc 
; $315a: 69 05               adc #$05
; $315c: a8                  tay 
; $315d: c0 1e               cpy #$1e
; $315f: 90 d3               bcc b3134
; $3161: a5 07               lda a07
; $3163: 69 3f               adc #$3f
; $3165: 85 07               sta a07
; $3167: a5 08               lda a08
; $3169: 69 01               adc #$01
; $316b: 85 08               sta a08
; $316d: 60                  rts 

; $316e: 20 df 83    j316e   jsr e83df
; $3171: a2 0b               ldx #$0b
; $3173: 86 a5               stx aa5
; $3175: 20 80 36            jsr s3680
; $3178: b0 05               bcs b317f
; $317a: a2 18               ldx #$18
; $317c: 20 80 36            jsr s3680
; $317f: a9 08       b317f   lda #$08
; $3181: 85 24               sta a24
; $3183: a9 c2               lda #$c2
; $3185: 85 27               sta a27
; $3187: 4a                  lsr 
; $3188: 85 29               sta a29
; $318a: 20 a0 a2    b318a   jsr ea2a0
; $318d: 20 86 9a            jsr e9a86
; $3190: c6 29               dec a29
; $3192: d0 f6               bne b318a
; $3194: 20 10 b4            jsr eb410
; $3197: a9 00               lda #$00
; $3199: a2 10               ldx #$10
; $319b: 9d b0 04    b319b   sta f04b0,x
; $319e: ca                  dex 
; $319f: 10 fa               bpl b319b
; $31a1: 8d cd 04            sta a04cd
; $31a4: 8d c7 04            sta a04c7
; $31a7: ad c9 04            lda a04c9
; $31aa: 0d ca 04            ora a04ca
; $31ad: f0 0f               beq b31be
; $31af: 20 af 84            jsr e84af
; $31b2: 29 07               and #$07
; $31b4: 09 01               ora #$01
; $31b6: 8d c9 04            sta a04c9
; $31b9: a9 00               lda #$00
; $31bb: 8d ca 04            sta a04ca
; $31be: a9 46       b31be   lda #$46
; $31c0: 8d a6 04            sta a04a6
; $31c3: 4c 01 21            jmp j2101

; $31c6: a9 0e               lda #$0e
; $31c8: 20 90 23            jsr _2390
; $31cb: 20 82 6f            jsr e6f82
; $31ce: 20 a0 70            jsr e70a0
; $31d1: a9 00               lda #$00
; $31d3: 85 ae               sta aae
; $31d5: 20 a3 24    b31d5   jsr s24a3
; $31d8: 20 e9 76            jsr e76e9
; $31db: ae 1c 2f            ldx a2f1c
; $31de: b5 0e               lda f0e,x
; $31e0: c9 0d               cmp #$0d
; $31e2: d0 0d               bne b31f1
; $31e4: ca          b31e4   dex 
; $31e5: b5 0e               lda f0e,x
; $31e7: 09 20               ora #$20
; $31e9: dd 48 06            cmp f0648,x
; $31ec: f0 f6               beq b31e4
; $31ee: 8a                  txa 
; $31ef: 30 17               bmi b3208
; $31f1: 20 3b 6a    b31f1   jsr e6a3b
; $31f4: e6 ae               inc aae
; $31f6: d0 dd               bne b31d5
; $31f8: 20 ab 70            jsr e70ab
; $31fb: 20 82 6f            jsr e6f82
; $31fe: a0 06               ldy #$06
; $3200: 20 58 a8            jsr ea858
; $3203: a9 d7               lda #$d7
; $3205: 4c 90 23            jmp _2390

; $3208: a5 82       b3208   lda a82
; $320a: 8d 09 05            sta a0509
; $320d: a5 80               lda a80
; $320f: 8d 0a 05            sta a050a
; $3212: 20 ab 70            jsr e70ab
; $3215: 20 82 6f            jsr e6f82
; $3218: 20 a6 24            jsr s24a6
; $321b: 4c 7e 87            jmp e877e

; $321e: a5 09       b321e   lda a09
; $3220: 05 0c               ora a0c
; $3222: 05 0f               ora a0f
; $3224: d0 05               bne b322b
; $3226: a9 50               lda #$50
; $3228: 20 d2 7b            jsr e7bd2
; $322b: a2 04       b322b   ldx #$04
; $322d: d0 61               bne b3290
; $322f: a9 00       b322f   lda #$00
; $3231: 20 b1 87            jsr e87b1
; $3234: f0 03               beq b3239
; $3236: 4c 65 33            jmp j3365

; $3239: 20 93 32    b3239   jsr s3293
; $323c: 20 13 a8            jsr ea813
; $323f: a9 fa               lda #$fa
; $3241: 4c d2 7b            jmp e7bd2

; $3244: a5 67       b3244   lda a67
; $3246: d0 d6               bne b321e
; $3248: a5 29               lda a29
; $324a: 0a                  asl 
; $324b: 30 e2               bmi b322f
; $324d: 4a                  lsr 
; $324e: aa                  tax 
; $324f: bd a4 28            lda _28a4,x
; $3252: 85 5b               sta a5b
; $3254: bd a5 28            lda _28a5,x
; $3257: 20 81 35            jsr s3581
; $325a: a5 37               lda a37
; $325c: 05 3a               ora a3a
; $325e: 05 3d               ora a3d
; $3260: 29 7f               and #$7f
; $3262: 05 36               ora a36
; $3264: 05 39               ora a39
; $3266: 05 3c               ora a3c
; $3268: d0 2f               bne b3299
; $326a: a5 29               lda a29
; $326c: c9 82               cmp #$82
; $326e: f0 ae               beq b321e
; $3270: a0 1f               ldy #$1f
; $3272: b1 5b               lda (p5b),y
; $3274: 2c a1 32            bit a32a1
; $3277: d0 04               bne b327d
; $3279: 09 80               ora #$80
; $327b: 91 5b               sta (p5b),y
; $327d: a5 09       b327d   lda a09
; $327f: 05 0c               ora a0c
; $3281: 05 0f               ora a0f
; $3283: d0 05               bne b328a
; $3285: a9 50               lda #$50
; $3287: 20 d2 7b            jsr e7bd2
; $328a: a5 29       b328a   lda a29
; $328c: 29 7f               and #$7f
; $328e: 4a                  lsr 
; $328f: aa                  tax 
; $3290: 20 a6 a7    b3290   jsr ea7a6
; $3293: 06 28       s3293   asl a28
; $3295: 38                  sec 
; $3296: 66 28               ror a28
; $3298: 60          b3298   rts 

; $3299: 20 af 84    b3299   jsr e84af
; $329c: c9 10               cmp #$10
; $329e: b0 07               bcs b32a7
;                    a32a1   =*+$01
; $32a0: a0 20               ldy #$20
; $32a2: b1 5b               lda (p5b),y
; $32a4: 4a                  lsr 
; $32a5: b0 03               bcs b32aa
; $32a7: 4c 6e 33    b32a7   jmp j336e

; $32aa: 4c f4 b0    b32aa   jmp eb0f4

; $32ad: a9 03               lda #<p0403
; $32af: 85 b0               sta ab0
; $32b1: a9 04               lda #>p0403
; $32b3: 85 b1               sta ab1
; $32b5: a9 16               lda #$16
; $32b7: 85 ab               sta aab
; $32b9: e0 01               cpx #$01
; $32bb: f0 87               beq b3244
; $32bd: e0 02               cpx #$02
; $32bf: d0 2e               bne b32ef
; $32c1: a5 2d               lda a2d
; $32c3: 29 04               and #$04
; $32c5: d0 13               bne b32da
; $32c7: ad 67 04            lda a0467
; $32ca: d0 cc               bne b3298
; $32cc: 20 af 84            jsr e84af
; $32cf: c9 fd               cmp #$fd
; $32d1: 90 c5               bcc b3298
; $32d3: 29 01               and #$01
; $32d5: 69 08               adc #$08
; $32d7: aa                  tax 
; $32d8: d0 10               bne b32ea
; $32da: 20 af 84    b32da   jsr e84af
; $32dd: c9 f0               cmp #$f0
; $32df: 90 b7               bcc b3298
; $32e1: ad 6d 04            lda a046d
; $32e4: c9 04               cmp #$04
; $32e6: b0 40               bcs b3328
; $32e8: a2 10               ldx #$10
; $32ea: a9 f1       b32ea   lda #$f1
; $32ec: 4c 0a 37            jmp s370a

; $32ef: e0 0f       b32ef   cpx #$0f
; $32f1: d0 1c               bne b330f
; $32f3: 20 af 84            jsr e84af
; $32f6: c9 c8               cmp #$c8
; $32f8: 90 2e               bcc b3328
; $32fa: a2 00               ldx #$00
; $32fc: 86 29               stx a29
; $32fe: a2 24               ldx #$24
; $3300: 86 2d               stx a2d
; $3302: 29 03               and #$03
; $3304: 69 11               adc #$11
; $3306: aa                  tax 
; $3307: 20 ea 32            jsr b32ea
; $330a: a9 00               lda #$00
; $330c: 85 29               sta a29
; $330e: 60                  rts 

; $330f: a0 0e       b330f   ldy #$0e
; $3311: a5 2c               lda a2c
; $3313: d1 57               cmp (p57),y
; $3315: b0 02               bcs b3319
; $3317: e6 2c               inc a2c
; $3319: e0 1e       b3319   cpx #$1e
; $331b: d0 0c               bne b3329
; $331d: ad 7a 04            lda a047a
; $3320: d0 07               bne b3329
; $3322: 46 29               lsr a29
; $3324: 06 29               asl a29
; $3326: 46 24               lsr a24
; $3328: 60          b3328   rts 

; $3329: 20 af 84    b3329   jsr e84af
; $332c: a5 2d               lda a2d
; $332e: 4a                  lsr 
; $332f: 90 04               bcc b3335
; $3331: e0 32               cpx #$32
; $3333: b0 f3               bcs b3328
; $3335: 4a          b3335   lsr 
; $3336: 90 0f               bcc b3347
; $3338: ae cd 04            ldx a04cd
; $333b: e0 28               cpx #$28
; $333d: 90 08               bcc b3347
; $333f: a5 2d               lda a2d
; $3341: 09 04               ora #$04
; $3343: 85 2d               sta a2d
; $3345: 4a                  lsr 
; $3346: 4a                  lsr 
; $3347: 4a          b3347   lsr 
; $3348: b0 0d               bcs b3357
; $334a: 4a                  lsr 
; $334b: 4a                  lsr 
; $334c: 90 03               bcc b3351
; $334e: 4c bc 34            jmp j34bc

; $3351: 20 7b 8c    b3351   jsr e8c7b
; $3354: 4c ac 34            jmp j34ac

; $3357: 4a          b3357   lsr 
; $3358: 90 0b               bcc j3365
; $335a: ad 5f 04            lda a045f
; $335d: f0 06               beq j3365
; $335f: a5 29               lda a29
; $3361: 29 81               and #$81
; $3363: 85 29               sta a29
; $3365: a2 08       j3365   ldx #$08
; $3367: b5 09       b3367   lda f09,x
; $3369: 95 35               sta f35,x
; $336b: ca                  dex 
; $336c: 10 f9               bpl b3367
; $336e: 20 8a 8c    j336e   jsr e8c8a
; $3371: a0 0a               ldy #$0a
; $3373: 20 b2 3a            jsr s3ab2
; $3376: 85 aa               sta aaa
; $3378: a5 a5               lda aa5
; $337a: c9 01               cmp #$01
; $337c: d0 03               bne b3381
; $337e: 4c 4b 34            jmp j344b

; $3381: c9 0e       b3381   cmp #$0e
; $3383: d0 15               bne b339a
; $3385: 20 af 84            jsr e84af
; $3388: c9 c8               cmp #$c8
; $338a: 90 0e               bcc b339a
; $338c: 20 af 84            jsr e84af
; $338f: a2 17               ldx #$17
; $3391: c9 64               cmp #$64
; $3393: b0 02               bcs b3397
; $3395: a2 11               ldx #$11
; $3397: 4c ea 32    b3397   jmp b32ea

; $339a: 20 af 84    b339a   jsr e84af
; $339d: c9 fa               cmp #$fa
; $339f: 90 07               bcc b33a8
; $33a1: 20 af 84            jsr e84af
; $33a4: 09 68               ora #$68
; $33a6: 85 26               sta a26
; $33a8: a0 0e       b33a8   ldy #$0e
; $33aa: b1 57               lda (p57),y
; $33ac: 4a                  lsr 
; $33ad: c5 2c               cmp a2c
; $33af: 90 4c               bcc b33fd
; $33b1: 4a                  lsr 
; $33b2: 4a                  lsr 
; $33b3: c5 2c               cmp a2c
; $33b5: 90 1f               bcc b33d6
; $33b7: 20 af 84            jsr e84af
; $33ba: c9 e6               cmp #$e6
; $33bc: 90 18               bcc b33d6
; $33be: a6 a5               ldx aa5
; $33c0: bd 41 d0            lda fd041,x
; $33c3: 10 11               bpl b33d6
; $33c5: a5 2d               lda a2d
; $33c7: 29 f0               and #$f0
; $33c9: 85 2d               sta a2d
; $33cb: a0 24               ldy #$24
; $33cd: 91 59               sta (p59),y
; $33cf: a9 00               lda #$00
; $33d1: 85 29               sta a29
; $33d3: 4c 06 37            jmp j3706

; $33d6: a5 28       b33d6   lda a28
; $33d8: 29 07               and #$07
; $33da: f0 21               beq b33fd
; $33dc: 85 bb               sta abb
; $33de: 20 af 84            jsr e84af
; $33e1: 29 1f               and #$1f
; $33e3: c5 bb               cmp abb
; $33e5: b0 16               bcs b33fd
; $33e7: a5 67               lda a67
; $33e9: d0 12               bne b33fd
; $33eb: c6 28               dec a28
; $33ed: a5 a5               lda aa5
; $33ef: c9 1d               cmp #$1d
; $33f1: d0 07               bne b33fa
; $33f3: a2 1e               ldx #$1e
; $33f5: a5 29               lda a29
; $33f7: 4c 0a 37            jmp s370a

; $33fa: 4c 95 a7    b33fa   jmp ea795

; $33fd: a9 00       b33fd   lda #$00
; $33ff: 20 b1 87            jsr e87b1
; $3402: 29 e0               and #$e0
; $3404: d0 2e               bne b3434
; $3406: a6 aa               ldx aaa
; $3408: e0 a0               cpx #$a0
; $340a: 90 28               bcc b3434
; $340c: a0 13               ldy #$13
; $340e: b1 57               lda (p57),y
; $3410: 29 f8               and #$f8
; $3412: f0 20               beq b3434
; $3414: a5 28               lda a28
; $3416: 09 40               ora #$40
; $3418: 85 28               sta a28
; $341a: e0 a3               cpx #$a3
; $341c: 90 16               bcc b3434
; $341e: b1 57               lda (p57),y
; $3420: 4a                  lsr 
; $3421: 20 d2 7b            jsr e7bd2
; $3424: c6 25               dec a25
; $3426: a5 67               lda a67
; $3428: d0 6f               bne b3499
; $342a: a0 01               ldy #$01
; $342c: 20 58 a8            jsr ea858
; $342f: a0 0f               ldy #$0f
; $3431: 4c 58 a8            jmp ea858

; $3434: a5 10       b3434   lda a10
; $3436: c9 03               cmp #$03
; $3438: b0 08               bcs b3442
; $343a: a5 0a               lda a0a
; $343c: 05 0d               ora a0d
; $343e: 29 fe               and #$fe
; $3440: f0 12               beq b3454
; $3442: 20 af 84    b3442   jsr e84af
; $3445: 09 80               ora #$80
; $3447: c5 29               cmp a29
; $3449: b0 09               bcs b3454
; $344b: 20 d5 35    j344b   jsr s35d5
; $344e: a5 aa               lda aaa
; $3450: 49 80               eor #$80
; $3452: 85 aa       j3452   sta aaa
; $3454: a0 10       b3454   ldy #$10
; $3456: 20 b2 3a            jsr s3ab2
; $3459: aa                  tax 
; $345a: 49 80               eor #$80
; $345c: 29 80               and #$80
; $345e: 85 27               sta a27
; $3460: 8a                  txa 
; $3461: 0a                  asl 
; $3462: c5 b1               cmp ab1
; $3464: 90 06               bcc b346c
; $3466: a5 b0               lda ab0
; $3468: 05 27               ora a27
; $346a: 85 27               sta a27
; $346c: a5 26       b346c   lda a26
; $346e: 0a                  asl 
; $346f: c9 20               cmp #$20
; $3471: b0 1a               bcs b348d
; $3473: a0 16               ldy #$16
; $3475: 20 b2 3a            jsr s3ab2
; $3478: aa                  tax 
; $3479: 45 27               eor a27
; $347b: 29 80               and #$80
; $347d: 49 80               eor #$80
; $347f: 85 26               sta a26
; $3481: 8a                  txa 
; $3482: 0a                  asl 
; $3483: c5 b1               cmp ab1
; $3485: 90 06               bcc b348d
; $3487: a5 b0               lda ab0
; $3489: 05 26               ora a26
; $348b: 85 26               sta a26
; $348d: a5 aa       b348d   lda aaa
; $348f: 30 09               bmi b349a
; $3491: c5 ab               cmp aab
; $3493: 90 05               bcc b349a
; $3495: a9 03               lda #$03
; $3497: 85 25               sta a25
; $3499: 60          b3499   rts 

; $349a: 29 7f       b349a   and #$7f
; $349c: c9 12               cmp #$12
; $349e: 90 0b               bcc b34ab
; $34a0: a9 ff               lda #$ff
; $34a2: a6 a5               ldx aa5
; $34a4: e0 01               cpx #$01
; $34a6: d0 01               bne b34a9
; $34a8: 0a                  asl 
; $34a9: 85 25       b34a9   sta a25
; $34ab: 60          b34ab   rts 

; $34ac: a0 0a       j34ac   ldy #$0a
; $34ae: 20 b2 3a            jsr s3ab2
; $34b1: c9 98               cmp #$98
; $34b3: 90 04               bcc b34b9
; $34b5: a2 00               ldx #$00
; $34b7: 86 b1               stx ab1
; $34b9: 4c 52 34    b34b9   jmp j3452

; $34bc: a9 06       j34bc   lda #$06
; $34be: 85 b1               sta ab1
; $34c0: 4a                  lsr 
; $34c1: 85 b0               sta ab0
; $34c3: a9 1d               lda #$1d
; $34c5: 85 ab               sta aab
; $34c7: ad 5f 04            lda a045f
; $34ca: d0 03               bne b34cf
; $34cc: 4c 51 33    b34cc   jmp b3351

; $34cf: 20 7b 35    b34cf   jsr s357b
; $34d2: a5 37               lda a37
; $34d4: 05 3a               ora a3a
; $34d6: 05 3d               ora a3d
; $34d8: 29 7f               and #$7f
; $34da: d0 f0               bne b34cc
; $34dc: 20 ad 8c            jsr e8cad
; $34df: a5 9a               lda a9a
; $34e1: 85 77               sta a77
; $34e3: 20 8a 8c            jsr e8c8a
; $34e6: a0 0a               ldy #$0a
; $34e8: 20 b3 35            jsr s35b3
; $34eb: 30 25               bmi b3512
; $34ed: c9 23               cmp #$23
; $34ef: 90 21               bcc b3512
; $34f1: a0 0a               ldy #$0a
; $34f3: 20 b2 3a            jsr s3ab2
; $34f6: c9 a2               cmp #$a2
; $34f8: b0 32               bcs b352c
; $34fa: a5 77               lda a77
; $34fc: c9 9d               cmp #$9d
; $34fe: 90 04               bcc b3504
; $3500: a5 a5               lda aa5
; $3502: 30 28               bmi b352c
; $3504: 20 d5 35    b3504   jsr s35d5
; $3507: 20 ac 34            jsr j34ac
; $350a: a2 00       b350a   ldx #$00
; $350c: 86 25               stx a25
; $350e: e8                  inx 
; $350f: 86 24               stx a24
; $3511: 60                  rts 

; $3512: 20 7b 35    b3512   jsr s357b
; $3515: 20 e8 35            jsr s35e8
; $3518: 20 e8 35            jsr s35e8
; $351b: 20 8a 8c            jsr e8c8a
; $351e: 20 d5 35            jsr s35d5
; $3521: 4c ac 34            jmp j34ac

; $3524: e6 25       b3524   inc a25
; $3526: a9 7f               lda #$7f
; $3528: 85 26               sta a26
; $352a: d0 45               bne b3571
; $352c: a2 00       b352c   ldx #$00
; $352e: 86 b1               stx ab1
; $3530: 86 27               stx a27
; $3532: a5 a5               lda aa5
; $3534: 10 20               bpl b3556
; $3536: 45 6b               eor a6b
; $3538: 45 6c               eor a6c
; $353a: 0a                  asl 
; $353b: a9 02               lda #$02
; $353d: 6a                  ror 
; $353e: 85 26               sta a26
; $3540: a5 6b               lda a6b
; $3542: 0a                  asl 
; $3543: c9 0c               cmp #$0c
; $3545: b0 c3               bcs b350a
; $3547: a5 6c               lda a6c
; $3549: 0a                  asl 
; $354a: a9 02               lda #$02
; $354c: 6a                  ror 
; $354d: 85 27               sta a27
; $354f: a5 6c               lda a6c
; $3551: 0a                  asl 
; $3552: c9 0c               cmp #$0c
; $3554: b0 b4               bcs b350a
; $3556: 86 26       b3556   stx a26
; $3558: a5 1f               lda a1f
; $355a: 85 6b               sta a6b
; $355c: a5 21               lda a21
; $355e: 85 6c               sta a6c
; $3560: a5 23               lda a23
; $3562: 85 6d               sta a6d
; $3564: a0 10               ldy #$10
; $3566: 20 b3 35            jsr s35b3
; $3569: 0a                  asl 
; $356a: c9 42               cmp #$42
; $356c: b0 b6               bcs b3524
; $356e: 20 0a 35            jsr b350a
; $3571: a5 3f       b3571   lda a3f
; $3573: d0 05               bne b357a
; $3575: 06 2d               asl a2d
; $3577: 38                  sec 
; $3578: 66 2d               ror a2d
; $357a: 60          b357a   rts 

; $357b: a9 25       s357b   lda #<ff925
; $357d: 85 5b               sta a5b
; $357f: a9 f9               lda #>ff925
; $3581: 85 5c       s3581   sta a5c
; $3583: a0 02               ldy #$02
; $3585: 20 8f 35            jsr s358f
; $3588: a0 05               ldy #$05
; $358a: 20 8f 35            jsr s358f
; $358d: a0 08               ldy #$08
; $358f: b1 5b       s358f   lda (p5b),y
; $3591: 49 80               eor #$80
; $3593: 85 7a               sta a7a
; $3595: 88                  dey 
; $3596: b1 5b               lda (p5b),y
; $3598: 85 79               sta a79
; $359a: 88                  dey 
; $359b: b1 5b               lda (p5b),y
; $359d: 85 78               sta a78
; $359f: 84 99               sty a99
; $35a1: a6 99               ldx a99
; $35a3: 20 69 2d            jsr s2d69
; $35a6: a4 99               ldy a99
; $35a8: 95 37               sta f37,x
; $35aa: a5 79               lda a79
; $35ac: 95 36               sta f36,x
; $35ae: a5 78               lda a78
; $35b0: 95 35               sta f35,x
; $35b2: 60                  rts 

; $35b3: be 25 f9    s35b3   ldx ff925,y
; $35b6: 86 9a               stx a9a
; $35b8: a5 6b               lda a6b
; $35ba: 20 a8 3a            jsr s3aa8
; $35bd: be 27 f9            ldx ff927,y
; $35c0: 86 9a               stx a9a
; $35c2: a5 6c               lda a6c
; $35c4: 20 ce 3a            jsr s3ace
; $35c7: 85 9c               sta a9c
; $35c9: 86 9b               stx a9b
; $35cb: be 29 f9            ldx ff929,y
; $35ce: 86 9a               stx a9a
; $35d0: a5 6d               lda a6d
; $35d2: 4c ce 3a            jmp s3ace

; $35d5: a5 6b       s35d5   lda a6b
; $35d7: 49 80               eor #$80
; $35d9: 85 6b               sta a6b
; $35db: a5 6c               lda a6c
; $35dd: 49 80               eor #$80
; $35df: 85 6c               sta a6c
; $35e1: a5 6d               lda a6d
; $35e3: 49 80               eor #$80
; $35e5: 85 6d               sta a6d
; $35e7: 60                  rts 

; $35e8: 20 eb 35    s35e8   jsr s35eb
; $35eb: ad 2f f9    s35eb   lda af92f
; $35ee: a2 00               ldx #$00
; $35f0: 20 00 36            jsr s3600
; $35f3: ad 31 f9            lda af931
; $35f6: a2 03               ldx #$03
; $35f8: 20 00 36            jsr s3600
; $35fb: ad 33 f9            lda af933
; $35fe: a2 06               ldx #$06
; $3600: 0a          s3600   asl 
; $3601: 85 9b               sta a9b
; $3603: a9 00               lda #$00
; $3605: 6a                  ror 
; $3606: 49 80               eor #$80
; $3608: 55 37               eor f37,x
; $360a: 30 0b               bmi b3617
; $360c: a5 9b               lda a9b
; $360e: 75 35               adc f35,x
; $3610: 95 35               sta f35,x
; $3612: 90 02               bcc b3616
; $3614: f6 36               inc f36,x
; $3616: 60          b3616   rts 

; $3617: b5 35       b3617   lda f35,x
; $3619: 38                  sec 
; $361a: e5 9b               sbc a9b
; $361c: 95 35               sta f35,x
; $361e: b5 36               lda f36,x
; $3620: e9 00               sbc #$00
; $3622: 95 36               sta f36,x
; $3624: b0 f0               bcs b3616
; $3626: b5 35               lda f35,x
; $3628: 49 ff               eor #$ff
; $362a: 69 01               adc #$01
; $362c: 95 35               sta f35,x
; $362e: b5 36               lda f36,x
; $3630: 49 ff               eor #$ff
; $3632: 69 00               adc #$00
; $3634: 95 36               sta f36,x
; $3636: b5 37               lda f37,x
; $3638: 49 80               eor #$80
; $363a: 95 37               sta f37,x
; $363c: 4c 16 36            jmp b3616

; $363f: 18          s363f   clc 
; $3640: a5 11               lda a11
; $3642: d0 39               bne b367d
; $3644: a5 a5               lda aa5
; $3646: 30 35               bmi b367d
; $3648: a5 28               lda a28
; $364a: 29 20               and #$20
; $364c: 05 0a               ora a0a
; $364e: 05 0d               ora a0d
; $3650: d0 2b               bne b367d
; $3652: a5 09               lda a09
; $3654: 20 88 39            jsr s3988
; $3657: 85 9c               sta a9c
; $3659: a5 2e               lda a2e
; $365b: 85 9b               sta a9b
; $365d: a5 0c               lda a0c
; $365f: 20 88 39            jsr s3988
; $3662: aa                  tax 
; $3663: a5 2e               lda a2e
; $3665: 65 9b               adc a9b
; $3667: 85 9b               sta a9b
; $3669: 8a                  txa 
; $366a: 65 9c               adc a9c
; $366c: b0 10               bcs b367e
; $366e: 85 9c               sta a9c
; $3670: a0 02               ldy #$02
; $3672: b1 57               lda (p57),y
; $3674: c5 9c               cmp a9c
; $3676: d0 05               bne b367d
; $3678: 88                  dey 
; $3679: b1 57               lda (p57),y
; $367b: c5 9b               cmp a9b
; $367d: 60          b367d   rts 

; $367e: 18          b367e   clc 
; $367f: 60                  rts 

; $3680: 20 47 84    s3680   jsr e8447
; $3683: a9 1c               lda #$1c
; $3685: 85 0c               sta a0c
; $3687: 4a                  lsr 
; $3688: 85 0f               sta a0f
; $368a: a9 80               lda #$80
; $368c: 85 0e               sta a0e
; $368e: a5 7c               lda a7c
; $3690: 0a                  asl 
; $3691: 09 80               ora #$80
; $3693: 85 29               sta a29
; $3695: a9 60               lda #$60
; $3697: 85 17               sta a17
; $3699: 09 80               ora #$80
; $369b: 85 1f               sta a1f
; $369d: a5 96               lda a96
; $369f: 2a                  rol 
; $36a0: 85 24               sta a24
; $36a2: 8a                  txa 
; $36a3: 4c 6b 7c            jmp e7c6b

; $36a6: a2 01       s36a6   ldx #$01
; $36a8: 20 80 36            jsr s3680
; $36ab: 90 54               bcc b3701
; $36ad: a6 7c               ldx a7c
; $36af: 20 87 3e            jsr _3e87
; $36b2: bd 52 04            lda f0452,x
; $36b5: 20 c5 36            jsr s36c5
; $36b8: a0 b7               ldy #$b7
; $36ba: 20 0c 7d            jsr e7d0c
; $36bd: ce cc 04            dec a04cc
; $36c0: a0 04               ldy #$04
; $36c2: 4c 58 a8            jmp ea858

; $36c5: c9 02       s36c5   cmp #$02
; $36c7: f0 2f               beq b36f8
; $36c9: a0 24               ldy #$24
; $36cb: b1 59               lda (p59),y
; $36cd: 29 20               and #$20
; $36cf: f0 03               beq b36d4
; $36d1: 20 f8 36            jsr b36f8
; $36d4: a0 20       b36d4   ldy #$20
; $36d6: b1 59               lda (p59),y
; $36d8: f0 a3               beq b367d
; $36da: 09 80               ora #$80
; $36dc: 91 59               sta (p59),y
; $36de: a0 1c               ldy #$1c
; $36e0: a9 02               lda #$02
; $36e2: 91 59               sta (p59),y
; $36e4: 0a                  asl 
; $36e5: a0 1e               ldy #$1e
; $36e7: 91 59               sta (p59),y
; $36e9: a5 a5               lda aa5
; $36eb: c9 0b               cmp #$0b
; $36ed: 90 08               bcc b36f7
; $36ef: a0 24               ldy #$24
; $36f1: b1 59               lda (p59),y
; $36f3: 09 04               ora #$04
; $36f5: 91 59               sta (p59),y
; $36f7: 60          b36f7   rts 

; $36f8: ad 49 f9    b36f8   lda af949
; $36fb: 09 04               ora #$04
; $36fd: 8d 49 f9            sta af949
; $3700: 60                  rts 

; $3701: a9 c9       b3701   lda #$c9
; $3703: 4c 0d 90            jmp e900d

; $3706: a2 03       j3706   ldx #$03
; $3708: a9 fe               lda #$fe
; $370a: 85 06       s370a   sta a06
; $370c: 8a                  txa 
; $370d: 48                  pha 
; $370e: a5 57               lda a57
; $3710: 48                  pha 
; $3711: a5 58               lda a58
; $3713: 48                  pha 
; $3714: a5 59               lda a59
; $3716: 48                  pha 
; $3717: a5 5a               lda a5a
; $3719: 48                  pha 
; $371a: a0 24               ldy #$24
; $371c: b9 09 00    b371c   lda f0009,y
; $371f: 99 00 01            sta f0100,y
; $3722: b1 59               lda (p59),y
; $3724: 99 09 00            sta f0009,y
; $3727: 88                  dey 
; $3728: 10 f2               bpl b371c
; $372a: a5 a5               lda aa5
; $372c: c9 02               cmp #$02
; $372e: d0 1d               bne b374d
; $3730: 8a                  txa 
; $3731: 48                  pha 
; $3732: a9 20               lda #$20
; $3734: 85 24               sta a24
; $3736: a2 00               ldx #$00
; $3738: a5 13               lda a13
; $373a: 20 8c 37            jsr s378c
;                    f373e   =*+$01
; $373d: a2 03               ldx #$03
; $373f: a5 15               lda a15
; $3741: 20 8c 37            jsr s378c
; $3744: a2 06               ldx #$06
; $3746: a5 17               lda a17
; $3748: 20 8c 37            jsr s378c
; $374b: 68                  pla 
; $374c: aa                  tax 
; $374d: a5 06       b374d   lda a06
; $374f: 85 29               sta a29
; $3751: 46 26               lsr a26
; $3753: 06 26               asl a26
; $3755: 8a                  txa 
; $3756: c9 09               cmp #$09
; $3758: b0 16               bcs b3770
; $375a: c9 04               cmp #$04
; $375c: 90 12               bcc b3770
; $375e: 48                  pha 
; $375f: 20 af 84            jsr e84af
; $3762: 0a                  asl 
; $3763: 85 27               sta a27
; $3765: 8a                  txa 
; $3766: 29 0f               and #$0f
; $3768: 85 24               sta a24
; $376a: a9 ff               lda #$ff
; $376c: 6a                  ror 
; $376d: 85 26               sta a26
; $376f: 68                  pla 
; $3770: 20 6b 7c    b3770   jsr e7c6b
; $3773: 68                  pla 
; $3774: 85 5a               sta a5a
; $3776: 68                  pla 
; $3777: 85 59               sta a59
; $3779: a2 24               ldx #$24
; $377b: bd 00 01    b377b   lda f0100,x
; $377e: 95 09               sta f09,x
; $3780: ca                  dex 
; $3781: 10 f8               bpl b377b
; $3783: 68                  pla 
; $3784: 85 58               sta a58
; $3786: 68                  pla 
; $3787: 85 57               sta a57
; $3789: 68                  pla 
; $378a: aa                  tax 
; $378b: 60                  rts 

; $378c: 0a          s378c   asl 
; $378d: 85 9b               sta a9b
; $378f: a9 00               lda #$00
; $3791: 6a                  ror 
; $3792: 4c 4c a4            jmp ea44c

; $3795: 20 39 a8            jsr ea839
; $3798: a9 04               lda #$04
; $379a: 20 a5 37            jsr s37a5
; $379d: 60                  rts 

;===============================================================================

_379e:
; $379e: a0 04       s379e   ldy #$04
; $37a0: 20 58 a8            jsr ea858
; $37a3: a9 08               lda #$08
; $37a5: 85 ac       s37a5   sta aac
; $37a7: a5 a0               lda aa0
; $37a9: 48                  pha 
; $37aa: a9 00               lda #$00
; $37ac: 20 2f a7            jsr ea72f
; $37af: 68                  pla 
; $37b0: 85 a0               sta aa0
; $37b2: a2 80               ldx #$80
; $37b4: 86 35               stx a35
; $37b6: a2 48               ldx #$48
; $37b8: 86 43               stx a43
; $37ba: a2 00               ldx #$00
; $37bc: 86 ad               stx aad
; $37be: 86 36               stx a36
; $37c0: 86 44               stx a44
; $37c2: 20 ce 37    b37c2   jsr s37ce
; $37c5: e6 ad               inc aad
; $37c7: a6 ad               ldx aad
; $37c9: e0 08               cpx #$08
; $37cb: d0 f5               bne b37c2
; $37cd: 60                  rts 

; $37ce: a5 ad       s37ce   lda aad
; $37d0: 29 07               and #$07
; $37d2: 18                  clc 
; $37d3: 69 08               adc #$08
; $37d5: 85 77               sta a77
; $37d7: a9 01       b37d7   lda #$01
; $37d9: 85 7e               sta a7e
; $37db: 20 5e 80            jsr e805e
; $37de: 06 77               asl a77
; $37e0: b0 06               bcs b37e8
; $37e2: a5 77               lda a77
; $37e4: c9 a0               cmp #$a0
; $37e6: 90 ef               bcc b37d7
; $37e8: 60          b37e8   rts 

; $37e9: a9 00       j37e9   lda #$00
; $37eb: e0 02               cpx #$02
; $37ed: 6a                  ror 
; $37ee: 85 b0               sta ab0
; $37f0: 49 80               eor #$80
; $37f2: 85 b1               sta ab1
; $37f4: 20 a3 38            jsr s38a3
; $37f7: ac 0b 05            ldy a050b
; $37fa: b9 d6 06    j37fa   lda f06d6,y
; $37fd: 85 a1               sta aa1
; $37ff: 4a                  lsr 
; $3800: 4a                  lsr 
; $3801: 4a                  lsr 
; $3802: 20 33 3b            jsr s3b33
; $3805: a5 2e               lda a2e
; $3807: 85 ba               sta aba
; $3809: 45 b1               eor ab1
; $380b: 85 9c               sta a9c
; $380d: b9 af 06            lda f06af,y
; $3810: 85 2e               sta a2e
; $3812: b9 a2 06            lda f06a2,y
; $3815: 85 6b               sta a6b
; $3817: 20 d1 3a            jsr s3ad1
; $381a: 85 9c               sta a9c
; $381c: 86 9b               stx a9b
; $381e: b9 bc 06            lda f06bc,y
; $3821: 85 6c               sta a6c
; $3823: 45 94               eor a94
; $3825: a6 64               ldx a64
; $3827: 20 3e 39            jsr s393e
; $382a: 20 d1 3a            jsr s3ad1
; $382d: 86 5d               stx a5d
; $382f: 85 5e               sta a5e
; $3831: be c9 06            ldx f06c9,y
; $3834: 86 9b               stx a9b
; $3836: a6 6c               ldx a6c
; $3838: 86 9c               stx a9c
; $383a: a6 64               ldx a64
; $383c: 45 95               eor a95
; $383e: 20 3e 39            jsr s393e
; $3841: 20 d1 3a            jsr s3ad1
; $3844: 86 5f               stx a5f
; $3846: 85 60               sta a60
; $3848: a6 68               ldx a68
; $384a: 45 69               eor a69
; $384c: 20 3e 39            jsr s393e
; $384f: 85 9a               sta a9a
; $3851: a5 5d               lda a5d
; $3853: 85 9b               sta a9b
; $3855: a5 5e               lda a5e
; $3857: 85 9c               sta a9c
; $3859: 49 80               eor #$80
; $385b: 20 ce 3a            jsr s3ace
; $385e: 85 5e               sta a5e
; $3860: 8a                  txa 
; $3861: 99 af 06            sta f06af,y
; $3864: a5 5f               lda a5f
; $3866: 85 9b               sta a9b
; $3868: a5 60               lda a60
; $386a: 85 9c               sta a9c
; $386c: 20 ce 3a            jsr s3ace
; $386f: 85 9c               sta a9c
; $3871: 86 9b               stx a9b
; $3873: a9 00               lda #$00
; $3875: 85 2e               sta a2e
; $3877: a5 a6               lda aa6
; $3879: 20 0f 29            jsr s290f
; $387c: a5 5e               lda a5e
; $387e: 99 a2 06            sta f06a2,y
; $3881: 85 6b               sta a6b
; $3883: 29 7f               and #$7f
; $3885: 49 7f               eor #$7f
; $3887: c5 ba               cmp aba
; $3889: 90 33               bcc b38be
; $388b: f0 31               beq b38be
; $388d: a5 60               lda a60
; $388f: 99 bc 06            sta f06bc,y
; $3892: 85 6c               sta a6c
; $3894: 29 7f               and #$7f
; $3896: c9 74               cmp #$74
; $3898: b0 37               bcs b38d1
; $389a: 20 18 29    b389a   jsr s2918
; $389d: 88                  dey 
; $389e: f0 03               beq s38a3
; $38a0: 4c fa 37            jmp j37fa

; $38a3: a5 a6       s38a3   lda aa6
; $38a5: 45 b0               eor ab0
; $38a7: 85 a6               sta aa6
; $38a9: a5 69               lda a69
; $38ab: 45 b0               eor ab0
; $38ad: 85 69               sta a69
; $38af: 49 80               eor #$80
; $38b1: 85 6a               sta a6a
; $38b3: a5 94               lda a94
; $38b5: 45 b0               eor ab0
; $38b7: 85 94               sta a94
; $38b9: 49 80               eor #$80
; $38bb: 85 95               sta a95
; $38bd: 60                  rts 

; $38be: 20 af 84    b38be   jsr e84af
; $38c1: 85 6c               sta a6c
; $38c3: 99 bc 06            sta f06bc,y
; $38c6: a9 73               lda #$73
; $38c8: 05 b0               ora ab0
; $38ca: 85 6b               sta a6b
; $38cc: 99 a2 06            sta f06a2,y
; $38cf: d0 11               bne b38e2
; $38d1: 20 af 84    b38d1   jsr e84af
; $38d4: 85 6b               sta a6b
; $38d6: 99 a2 06            sta f06a2,y
; $38d9: a9 6e               lda #$6e
; $38db: 05 6a               ora a6a
; $38dd: 85 6c               sta a6c
; $38df: 99 bc 06            sta f06bc,y
; $38e2: 20 af 84    b38e2   jsr e84af
; $38e5: 09 08               ora #$08
; $38e7: 85 a1               sta aa1
; $38e9: 99 d6 06            sta f06d6,y
; $38ec: d0 ac               bne b389a
; $38ee: 85 77       b38ee   sta a77
; $38f0: 85 78               sta a78
; $38f2: 85 79               sta a79
; $38f4: 85 7a               sta a7a
; $38f6: 18                  clc 
; $38f7: 60                  rts 

; $38f8: 85 9b               sta a9b
; $38fa: 29 7f               and #$7f
; $38fc: 85 79               sta a79
; $38fe: a5 9a               lda a9a
; $3900: 29 7f               and #$7f
; $3902: f0 ea               beq b38ee
; $3904: 38                  sec 
; $3905: e9 01               sbc #$01
; $3907: 85 bb               sta abb
; $3909: a5 2f               lda a2f
; $390b: 46 79               lsr a79
; $390d: 6a                  ror 
; $390e: 85 78               sta a78
; $3910: a5 2e               lda a2e
; $3912: 6a                  ror 
; $3913: 85 77               sta a77
; $3915: a9 00               lda #$00
; $3917: a2 18               ldx #$18
; $3919: 90 02       b3919   bcc b391d
; $391b: 65 bb               adc abb
; $391d: 6a          b391d   ror 
; $391e: 66 79               ror a79
; $3920: 66 78               ror a78
; $3922: 66 77               ror a77
; $3924: ca                  dex 
; $3925: d0 f2               bne b3919
; $3927: 85 bb               sta abb
; $3929: a5 9b               lda a9b
; $392b: 45 9a               eor a9a
; $392d: 29 80               and #$80
; $392f: 05 bb               ora abb
; $3931: 85 7a               sta a7a
; $3933: 60                  rts 

; $3934: a6 5d       s3934   ldx a5d
; $3936: 86 9b               stx a9b
; $3938: a6 5e               ldx a5e
; $393a: 86 9c               stx a9c
; $393c: a6 68       s393c   ldx a68
; $393e: 86 2e       s393e   stx a2e
; $3940: aa                  tax 
; $3941: 29 80               and #$80
; $3943: 85 bb               sta abb
; $3945: 8a                  txa 
; $3946: 29 7f               and #$7f
; $3948: f0 37               beq b3981
; $394a: aa                  tax 
; $394b: ca                  dex 
; $394c: 86 06               stx a06
; $394e: a9 00               lda #$00
; $3950: 46 2e               lsr a2e
; $3952: 90 02               bcc b3956
; $3954: 65 06               adc a06
; $3956: 6a          b3956   ror 
; $3957: 66 2e               ror a2e
; $3959: 90 02               bcc b395d
; $395b: 65 06               adc a06
; $395d: 6a          b395d   ror 
; $395e: 66 2e               ror a2e
; $3960: 90 02               bcc b3964
; $3962: 65 06               adc a06
; $3964: 6a          b3964   ror 
; $3965: 66 2e               ror a2e
; $3967: 90 02               bcc b396b
; $3969: 65 06               adc a06
; $396b: 6a          b396b   ror 
; $396c: 66 2e               ror a2e
; $396e: 90 02               bcc b3972
; $3970: 65 06               adc a06
; $3972: 6a          b3972   ror 
; $3973: 66 2e               ror a2e
; $3975: 4a                  lsr 
; $3976: 66 2e               ror a2e
; $3978: 4a                  lsr 
; $3979: 66 2e               ror a2e
; $397b: 4a                  lsr 
; $397c: 66 2e               ror a2e
; $397e: 05 bb               ora abb
; $3980: 60                  rts 

; $3981: 85 2f       b3981   sta a2f
; $3983: 85 2e               sta a2e
; $3985: 60                  rts 

; $3986: 29 7f               and #$7f
; $3988: 85 2e       s3988   sta a2e
; $398a: aa                  tax 
; $398b: d0 12               bne b399f
; $398d: 18          b398d   clc 
; $398e: 86 2e               stx a2e
; $3990: 8a                  txa 
; $3991: 60                  rts 

; $3992: b9 bc 06    s3992   lda f06bc,y
; $3995: 85 6c               sta a6c
; $3997: 29 7f       s3997   and #$7f
; $3999: 85 2e               sta a2e
; $399b: a6 9a               ldx a9a
; $399d: f0 ee               beq b398d
; $399f: ca          b399f   dex 
; $39a0: 86 bb               stx abb
; $39a2: a9 00               lda #$00
; $39a4: aa                  tax 
; $39a5: 46 2e               lsr a2e
; $39a7: 90 02               bcc b39ab
; $39a9: 65 bb               adc abb
; $39ab: 6a          b39ab   ror 
; $39ac: 66 2e               ror a2e
; $39ae: 90 02               bcc b39b2
; $39b0: 65 bb               adc abb
; $39b2: 6a          b39b2   ror 
; $39b3: 66 2e               ror a2e
; $39b5: 90 02               bcc b39b9
; $39b7: 65 bb               adc abb
; $39b9: 6a          b39b9   ror 
; $39ba: 66 2e               ror a2e
; $39bc: 90 02               bcc b39c0
; $39be: 65 bb               adc abb
; $39c0: 6a          b39c0   ror 
; $39c1: 66 2e               ror a2e
; $39c3: 90 02               bcc b39c7
; $39c5: 65 bb               adc abb
; $39c7: 6a          b39c7   ror 
; $39c8: 66 2e               ror a2e
; $39ca: 90 02               bcc b39ce
; $39cc: 65 bb               adc abb
; $39ce: 6a          b39ce   ror 
; $39cf: 66 2e               ror a2e
; $39d1: 90 02               bcc b39d5
; $39d3: 65 bb               adc abb
; $39d5: 6a          b39d5   ror 
; $39d6: 66 2e               ror a2e
; $39d8: 90 02               bcc b39dc
; $39da: 65 bb               adc abb
; $39dc: 6a          b39dc   ror 
; $39dd: 66 2e               ror a2e
; $39df: 60                  rts 

; $39e0: 29 1f               and #$1f
; $39e2: aa                  tax 
; $39e3: bd c0 0a            lda f0ac0,x
; $39e6: 85 9a               sta a9a
; $39e8: a5 77               lda a77
; $39ea: 86 2e       s39ea   stx a2e
; $39ec: 85 b6               sta ab6
; $39ee: aa                  tax 
; $39ef: f0 2c               beq b3a1d
; $39f1: bd 00 94            lda f9400,x
; $39f4: a6 9a               ldx a9a
; $39f6: f0 28               beq b3a20
; $39f8: 18                  clc 
; $39f9: 7d 00 94            adc f9400,x
; $39fc: 30 11               bmi b3a0f
; $39fe: bd 00 93            lda f9300,x
; $3a01: a6 b6               ldx ab6
; $3a03: 7d 00 93            adc f9300,x
; $3a06: 90 18               bcc b3a20
; $3a08: aa                  tax 
; $3a09: bd 00 95            lda f9500,x
; $3a0c: a6 2e               ldx a2e
; $3a0e: 60                  rts 

; $3a0f: bd 00 93    b3a0f   lda f9300,x
; $3a12: a6 b6               ldx ab6
; $3a14: 7d 00 93            adc f9300,x
; $3a17: 90 07               bcc b3a20
; $3a19: aa                  tax 
; $3a1a: bd 00 96            lda f9600,x
; $3a1d: a6 2e       b3a1d   ldx a2e
; $3a1f: 60                  rts 

; $3a20: a9 00       b3a20   lda #$00
; $3a22: a6 2e               ldx a2e
; $3a24: 60                  rts 

; $3a25: 86 9a               stx a9a
; $3a27: 49 ff               eor #$ff
; $3a29: 4a                  lsr 
; $3a2a: 85 2f               sta a2f
; $3a2c: a9 00               lda #$00
; $3a2e: a2 10               ldx #$10
; $3a30: 66 2e               ror a2e
; $3a32: b0 0b       b3a32   bcs b3a3f
; $3a34: 65 9a               adc a9a
; $3a36: 6a                  ror 
; $3a37: 66 2f               ror a2f
; $3a39: 66 2e               ror a2e
; $3a3b: ca                  dex 
; $3a3c: d0 f4               bne b3a32
; $3a3e: 60                  rts 

; $3a3f: 4a          b3a3f   lsr 
; $3a40: 66 2f               ror a2f
; $3a42: 66 2e               ror a2e
; $3a44: ca                  dex 
; $3a45: d0 eb               bne b3a32
; $3a47: 60                  rts 

; $3a48: a6 68               ldx a68
; $3a4a: 86 2e               stx a2e
; $3a4c: a6 5e       s3a4c   ldx a5e
; $3a4e: 86 9c               stx a9c
; $3a50: a6 5d       s3a50   ldx a5d
; $3a52: 86 9b               stx a9b
; $3a54: aa          s3a54   tax 
; $3a55: 29 7f               and #$7f
; $3a57: 4a                  lsr 
; $3a58: 85 2e               sta a2e
; $3a5a: 8a                  txa 
; $3a5b: 45 9a               eor a9a
; $3a5d: 29 80               and #$80
; $3a5f: 85 bb               sta abb
; $3a61: a5 9a               lda a9a
; $3a63: 29 7f               and #$7f
; $3a65: f0 3e               beq b3aa5
; $3a67: aa                  tax 
; $3a68: ca                  dex 
; $3a69: 86 06               stx a06
; $3a6b: a9 00               lda #$00
; $3a6d: aa                  tax 
; $3a6e: 90 02               bcc b3a72
; $3a70: 65 06               adc a06
; $3a72: 6a          b3a72   ror 
; $3a73: 66 2e               ror a2e
; $3a75: 90 02               bcc b3a79
; $3a77: 65 06               adc a06
; $3a79: 6a          b3a79   ror 
; $3a7a: 66 2e               ror a2e
; $3a7c: 90 02               bcc b3a80
; $3a7e: 65 06               adc a06
; $3a80: 6a          b3a80   ror 
; $3a81: 66 2e               ror a2e
; $3a83: 90 02               bcc b3a87
; $3a85: 65 06               adc a06
; $3a87: 6a          b3a87   ror 
; $3a88: 66 2e               ror a2e
; $3a8a: 90 02               bcc b3a8e
; $3a8c: 65 06               adc a06
; $3a8e: 6a          b3a8e   ror 
; $3a8f: 66 2e               ror a2e
; $3a91: 90 02               bcc b3a95
; $3a93: 65 06               adc a06
; $3a95: 6a          b3a95   ror 
; $3a96: 66 2e               ror a2e
; $3a98: 90 02               bcc b3a9c
; $3a9a: 65 06               adc a06
; $3a9c: 6a          b3a9c   ror 
; $3a9d: 66 2e               ror a2e
; $3a9f: 4a                  lsr 
; $3aa0: 66 2e               ror a2e
; $3aa2: 05 bb               ora abb
; $3aa4: 60                  rts 

; $3aa5: 85 2e       b3aa5   sta a2e
; $3aa7: 60                  rts 

; $3aa8: 20 54 3a    s3aa8   jsr s3a54
; $3aab: 85 9c               sta a9c
; $3aad: a5 2e               lda a2e
; $3aaf: 85 9b               sta a9b
; $3ab1: 60                  rts 

; $3ab2: b6 09       s3ab2   ldx f09,y
; $3ab4: 86 9a               stx a9a
; $3ab6: a5 6b               lda a6b
; $3ab8: 20 a8 3a            jsr s3aa8
; $3abb: b6 0b               ldx f0b,y
; $3abd: 86 9a               stx a9a
; $3abf: a5 6c               lda a6c
; $3ac1: 20 ce 3a            jsr s3ace
; $3ac4: 85 9c               sta a9c
; $3ac6: 86 9b               stx a9b
; $3ac8: b6 0d               ldx f0d,y
; $3aca: 86 9a               stx a9a
; $3acc: a5 6d               lda a6d
; $3ace: 20 54 3a    s3ace   jsr s3a54
; $3ad1: 85 06       s3ad1   sta a06
; $3ad3: 29 80               and #$80
; $3ad5: 85 bb               sta abb
; $3ad7: 45 9c               eor a9c
; $3ad9: 30 0d               bmi b3ae8
; $3adb: a5 9b               lda a9b
; $3add: 18                  clc 
; $3ade: 65 2e               adc a2e
; $3ae0: aa                  tax 
; $3ae1: a5 9c               lda a9c
; $3ae3: 65 06               adc a06
; $3ae5: 05 bb               ora abb
; $3ae7: 60                  rts 

; $3ae8: a5 9c       b3ae8   lda a9c
; $3aea: 29 7f               and #$7f
; $3aec: 85 99               sta a99
; $3aee: a5 2e               lda a2e
; $3af0: 38                  sec 
; $3af1: e5 9b               sbc a9b
; $3af3: aa                  tax 
; $3af4: a5 06               lda a06
; $3af6: 29 7f               and #$7f
; $3af8: e5 99               sbc a99
; $3afa: b0 0e               bcs b3b0a
; $3afc: 85 99               sta a99
; $3afe: 8a                  txa 
; $3aff: 49 ff               eor #$ff
; $3b01: 69 01               adc #$01
; $3b03: aa                  tax 
; $3b04: a9 00               lda #$00
; $3b06: e5 99               sbc a99
; $3b08: 09 80               ora #$80
; $3b0a: 45 bb       b3b0a   eor abb
; $3b0c: 60                  rts 

; $3b0d: 86 9a               stx a9a
; $3b0f: 49 80               eor #$80
; $3b11: 20 ce 3a            jsr s3ace
; $3b14: aa                  tax 
; $3b15: 29 80               and #$80
; $3b17: 85 bb               sta abb
; $3b19: 8a                  txa 
; $3b1a: 29 7f               and #$7f
; $3b1c: a2 fe               ldx #$fe
; $3b1e: 86 06               stx a06
; $3b20: 0a          b3b20   asl 
; $3b21: c9 60               cmp #$60
; $3b23: 90 02               bcc b3b27
; $3b25: e9 60               sbc #$60
; $3b27: 26 06       b3b27   rol a06
; $3b29: b0 f5               bcs b3b20
; $3b2b: a5 06               lda a06
; $3b2d: 05 bb               ora abb
; $3b2f: 60                  rts 

; $3b30: b9 d6 06    s3b30   lda f06d6,y
; $3b33: 85 9a       s3b33   sta a9a
; $3b35: a5 96               lda a96
; $3b37: 0a                  asl 
; $3b38: 85 2e               sta a2e
; $3b3a: a9 00               lda #$00
; $3b3c: 2a                  rol 
; $3b3d: c5 9a               cmp a9a
; $3b3f: 90 02               bcc b3b43
; $3b41: e5 9a               sbc a9a
; $3b43: 26 2e       b3b43   rol a2e
; $3b45: 2a                  rol 
; $3b46: c5 9a               cmp a9a
; $3b48: 90 02               bcc b3b4c
; $3b4a: e5 9a               sbc a9a
; $3b4c: 26 2e       b3b4c   rol a2e
; $3b4e: 2a                  rol 
; $3b4f: c5 9a               cmp a9a
; $3b51: 90 02               bcc b3b55
; $3b53: e5 9a               sbc a9a
; $3b55: 26 2e       b3b55   rol a2e
; $3b57: 2a                  rol 
; $3b58: c5 9a               cmp a9a
; $3b5a: 90 02               bcc b3b5e
; $3b5c: e5 9a               sbc a9a
; $3b5e: 26 2e       b3b5e   rol a2e
; $3b60: 2a                  rol 
; $3b61: c5 9a               cmp a9a
; $3b63: 90 02               bcc b3b67
; $3b65: e5 9a               sbc a9a
; $3b67: 26 2e       b3b67   rol a2e
; $3b69: 2a                  rol 
; $3b6a: c5 9a               cmp a9a
; $3b6c: 90 02               bcc b3b70
; $3b6e: e5 9a               sbc a9a
; $3b70: 26 2e       b3b70   rol a2e
; $3b72: 2a                  rol 
; $3b73: c5 9a               cmp a9a
; $3b75: 90 02               bcc b3b79
; $3b77: e5 9a               sbc a9a
; $3b79: 26 2e       b3b79   rol a2e
; $3b7b: 2a                  rol 
; $3b7c: c5 9a               cmp a9a
; $3b7e: 90 02               bcc b3b82
; $3b80: e5 9a               sbc a9a
; $3b82: 26 2e       b3b82   rol a2e
; $3b84: a2 00               ldx #$00
; $3b86: 85 b6               sta ab6
; $3b88: aa                  tax 
; $3b89: f0 1b               beq b3ba6
; $3b8b: bd 00 94            lda f9400,x
; $3b8e: a6 9a               ldx a9a
; $3b90: 38                  sec 
; $3b91: fd 00 94            sbc f9400,x
; $3b94: 30 18               bmi b3bae
; $3b96: a6 b6               ldx ab6
; $3b98: bd 00 93            lda f9300,x
; $3b9b: a6 9a               ldx a9a
; $3b9d: fd 00 93            sbc f9300,x
; $3ba0: b0 07               bcs b3ba9
; $3ba2: aa                  tax 
; $3ba3: bd 00 95            lda f9500,x
; $3ba6: 85 9b       b3ba6   sta a9b
; $3ba8: 60                  rts 

; $3ba9: a9 ff       b3ba9   lda #$ff
; $3bab: 85 9b               sta a9b
; $3bad: 60                  rts 

; $3bae: a6 b6       b3bae   ldx ab6
; $3bb0: bd 00 93            lda f9300,x
; $3bb3: a6 9a               ldx a9a
; $3bb5: fd 00 93            sbc f9300,x
; $3bb8: b0 ef               bcs b3ba9
; $3bba: aa                  tax 
; $3bbb: bd 00 96            lda f9600,x
; $3bbe: 85 9b               sta a9b
; $3bc0: 60                  rts 

; $3bc1: 85 30               sta a30
; $3bc3: a5 0f               lda a0f
; $3bc5: 09 01               ora #$01
; $3bc7: 85 9a               sta a9a
; $3bc9: a5 10               lda a10
; $3bcb: 85 9b               sta a9b
; $3bcd: a5 11               lda a11
; $3bcf: 85 9c               sta a9c
; $3bd1: a5 2e               lda a2e
; $3bd3: 09 01               ora #$01
; $3bd5: 85 2e               sta a2e
; $3bd7: a5 30               lda a30
; $3bd9: 45 9c               eor a9c
; $3bdb: 29 80               and #$80
; $3bdd: 85 bb               sta abb
; $3bdf: a0 00               ldy #$00
; $3be1: a5 30               lda a30
; $3be3: 29 7f               and #$7f
; $3be5: c9 40       b3be5   cmp #$40
; $3be7: b0 08               bcs b3bf1
; $3be9: 06 2e               asl a2e
; $3beb: 26 2f               rol a2f
; $3bed: 2a                  rol 
; $3bee: c8                  iny 
; $3bef: d0 f4               bne b3be5
; $3bf1: 85 30       b3bf1   sta a30
; $3bf3: a5 9c               lda a9c
; $3bf5: 29 7f               and #$7f
; $3bf7: 88          b3bf7   dey 
; $3bf8: 06 9a               asl a9a
; $3bfa: 26 9b               rol a9b
; $3bfc: 2a                  rol 
; $3bfd: 10 f8               bpl b3bf7
; $3bff: 85 9a               sta a9a
; $3c01: a9 fe               lda #$fe
; $3c03: 85 9b               sta a9b
; $3c05: a5 30               lda a30
; $3c07: 0a          b3c07   asl 
; $3c08: b0 0d               bcs b3c17
; $3c0a: c5 9a               cmp a9a
; $3c0c: 90 02               bcc b3c10
; $3c0e: e5 9a               sbc a9a
; $3c10: 26 9b       b3c10   rol a9b
; $3c12: b0 f3               bcs b3c07
; $3c14: 4c 20 3c            jmp j3c20

; $3c17: e5 9a       b3c17   sbc a9a
; $3c19: 38                  sec 
; $3c1a: 26 9b               rol a9b
; $3c1c: b0 e9               bcs b3c07
; $3c1e: a5 9b               lda a9b
; $3c20: a9 00       j3c20   lda #$00
; $3c22: 85 78               sta a78
; $3c24: 85 79               sta a79
; $3c26: 85 7a               sta a7a
; $3c28: 98                  tya 
; $3c29: 10 1e               bpl b3c49
; $3c2b: a5 9b               lda a9b
; $3c2d: 0a          b3c2d   asl 
; $3c2e: 26 78               rol a78
; $3c30: 26 79               rol a79
; $3c32: 26 7a               rol a7a
; $3c34: c8                  iny 
; $3c35: d0 f6               bne b3c2d
; $3c37: 85 77               sta a77
; $3c39: a5 7a               lda a7a
; $3c3b: 05 bb               ora abb
; $3c3d: 85 7a               sta a7a
; $3c3f: 60                  rts 

; $3c40: a5 9b       b3c40   lda a9b
; $3c42: 85 77               sta a77
; $3c44: a5 bb               lda abb
; $3c46: 85 7a               sta a7a
; $3c48: 60                  rts 

; $3c49: f0 f5       b3c49   beq b3c40
; $3c4b: a5 9b               lda a9b
; $3c4d: 4a          b3c4d   lsr 
; $3c4e: 88                  dey 
; $3c4f: d0 fc               bne b3c4d
; $3c51: 85 77               sta a77
; $3c53: a5 bb               lda abb
; $3c55: 85 7a               sta a7a
; $3c57: 60                  rts 

; $3c58: ad 80 04    s3c58   lda a0480
; $3c5b: d0 05               bne b3c62
; $3c5d: ad 06 1d            lda a1d06
; $3c60: d0 0c               bne b3c6e
; $3c62: 8a          b3c62   txa 
; $3c63: 10 03               bpl b3c68
; $3c65: ca                  dex 
; $3c66: 30 06               bmi b3c6e
; $3c68: e8          b3c68   inx 
; $3c69: d0 03               bne b3c6e
; $3c6b: ca                  dex 
; $3c6c: f0 fa               beq b3c68
; $3c6e: 60          b3c6e   rts 

; $3c6f: 85 bb               sta abb
; $3c71: 8a                  txa 
; $3c72: 18                  clc 
; $3c73: 65 bb               adc abb
; $3c75: aa                  tax 
; $3c76: 90 02               bcc b3c7a
; $3c78: a2 ff               ldx #$ff
; $3c7a: 10 10       b3c7a   bpl b3c8c
; $3c7c: a5 bb       b3c7c   lda abb
; $3c7e: 60                  rts 

; $3c7f: 85 bb               sta abb
; $3c81: 8a                  txa 
; $3c82: 38                  sec 
; $3c83: e5 bb               sbc abb
; $3c85: aa                  tax 
; $3c86: b0 02               bcs b3c8a
; $3c88: a2 01               ldx #$01
; $3c8a: 10 f0       b3c8a   bpl b3c7c
; $3c8c: ad 07 1d    b3c8c   lda a1d07
; $3c8f: d0 eb               bne b3c7c
; $3c91: a2 80               ldx #$80
; $3c93: 30 e7               bmi b3c7c
; $3c95: a5 2e               lda a2e
; $3c97: 45 9a               eor a9a
; $3c99: 85 06               sta a06
; $3c9b: a5 9a               lda a9a
; $3c9d: f0 25               beq b3cc4
; $3c9f: 0a                  asl 
; $3ca0: 85 9a               sta a9a
; $3ca2: a5 2e               lda a2e
; $3ca4: 0a                  asl 
; $3ca5: c5 9a               cmp a9a
; $3ca7: b0 09               bcs b3cb2
; $3ca9: 20 ce 3c            jsr s3cce
; $3cac: 38                  sec 
; $3cad: a6 06       b3cad   ldx a06
; $3caf: 30 16               bmi b3cc7
; $3cb1: 60                  rts 

; $3cb2: a6 9a       b3cb2   ldx a9a
; $3cb4: 85 9a               sta a9a
; $3cb6: 86 2e               stx a2e
; $3cb8: 8a                  txa 
; $3cb9: 20 ce 3c            jsr s3cce
; $3cbc: 85 bb               sta abb
; $3cbe: a9 40               lda #$40
; $3cc0: e5 bb               sbc abb
; $3cc2: b0 e9               bcs b3cad
; $3cc4: a9 3f       b3cc4   lda #$3f
; $3cc6: 60                  rts 

; $3cc7: 85 bb       b3cc7   sta abb
; $3cc9: a9 80               lda #$80
; $3ccb: e5 bb               sbc abb
; $3ccd: 60                  rts 

; $3cce: 20 af 99    s3cce   jsr e99af
; $3cd1: a5 9b               lda a9b
; $3cd3: 4a                  lsr 
; $3cd4: 4a                  lsr 
; $3cd5: 4a                  lsr 
; $3cd6: aa                  tax 
; $3cd7: bd e0 0a            lda f0ae0,x
; $3cda: 60          b3cda   rts 

; $3cdb: 20 af 84    s3cdb   jsr e84af
; $3cde: 29 07               and #$07
; $3ce0: 69 44               adc #$44
; $3ce2: 8d f1 06            sta a06f1
; $3ce5: 20 af 84            jsr e84af
; $3ce8: 29 07               and #$07
; $3cea: 69 7c               adc #$7c
; $3cec: 8d f0 06            sta a06f0
; $3cef: ad 88 04            lda a0488
; $3cf2: 69 08               adc #$08
; $3cf4: 8d 88 04            sta a0488
; $3cf7: 20 64 7b            jsr e7b64
; $3cfa: a5 a0       s3cfa   lda aa0
; $3cfc: d0 dc               bne b3cda
; $3cfe: a9 20               lda #$20
; $3d00: a0 e0               ldy #$e0
; $3d02: 20 09 3d            jsr s3d09
; $3d05: a9 30               lda #$30
; $3d07: a0 d0               ldy #$d0
; $3d09: 85 6d       s3d09   sta a6d
; $3d0b: ad f0 06            lda a06f0
; $3d0e: 85 6b               sta a6b
; $3d10: ad f1 06            lda a06f1
; $3d13: 85 6c               sta a6c
; $3d15: a9 8f               lda #$8f
; $3d17: 85 6e               sta a6e
; $3d19: 20 91 ab            jsr eab91
; $3d1c: ad f0 06            lda a06f0
; $3d1f: 85 6b               sta a6b
; $3d21: ad f1 06            lda a06f1
; $3d24: 85 6c               sta a6c
; $3d26: 84 6d               sty a6d
; $3d28: a9 8f               lda #$8f
; $3d2a: 85 6e               sta a6e
; $3d2c: 4c 91 ab            jmp eab91

; $3d2f: ad 07 05            lda a0507
; $3d32: 0d 08 05            ora a0508
; $3d35: d0 38               bne b3d6f
; $3d37: a5 a7               lda aa7
; $3d39: 10 34               bpl b3d6f
; $3d3b: a0 00               ldy #$00
; $3d3d: b9 27 1a    b3d3d   lda f1a27,y
; $3d40: c5 a1               cmp aa1
; $3d42: d0 28               bne b3d6c
; $3d44: b9 41 1a            lda f1a41,y
; $3d47: 29 7f               and #$7f
; $3d49: cd a8 04            cmp a04a8
; $3d4c: d0 1e               bne b3d6c
; $3d4e: b9 41 1a            lda f1a41,y
; $3d51: 30 0c               bmi b3d5f
; $3d53: ad 99 04            lda a0499
; $3d56: 4a                  lsr 
; $3d57: 90 16               bcc b3d6f
; $3d59: 20 a3 24            jsr s24a3
; $3d5c: a9 01               lda #$01
;                    b3d5f   =*+$01
; $3d5e: 2c a9 b0            bit ab0a9
; $3d61: 20 cf 23            jsr _23cf
; $3d64: 98                  tya 
; $3d65: 20 7e 23            jsr s237e
; $3d68: a9 b1               lda #$b1
; $3d6a: d0 0e               bne b3d7a
; $3d6c: 88          b3d6c   dey 
; $3d6d: d0 ce               bne b3d3d
; $3d6f: a2 03       b3d6f   ldx #$03
; $3d71: b5 81       b3d71   lda f81,x
; $3d73: 95 02               sta f02,x
; $3d75: ca                  dex 
; $3d76: 10 f9               bpl b3d71
; $3d78: a9 05               lda #$05
; $3d7a: 4c 90 23    b3d7a   jmp _2390

;===============================================================================

_3d7d:                                                                  ;$3d7d
        lda $0499
        ora # $04
        sta $0499
        lda # $0b
_3d87:                                                                  ;$3d87
        jsr _2390
_3d8a:                                                                  ;$3d8a
        jmp $88e7

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
        jsr $7481
        lda # $0f
_3dbe:                                                                  ;$3dbe
        bne _3d87
_3dc0:                                                                  ;$3dc0
        lda $0499
        ora # $10
        sta $0499
        lda # $c7
        jsr _2390
        jsr $81ee
        bcc _3d8a
        ldy # $c3
        ldx # $50
        jsr $745a
        inc $04c9
        jmp $88e7

;===============================================================================

_3dff:                                                                  ;$3dff
        lsr $0499
        sec 
        rol $0499
        jsr _3e37
        jsr $8447
        lda # $1f
        sta $a5
        jsr $7c6b
        lda # $01
        jsr $6a25
        sta $10
        jsr $a72f
        lda # $40
        sta $a3
_3e01:                                                                  ;$3e01
        ldx # $7f
        stx $26
        stx $27
        jsr $9a86
        jsr $a2a0
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
        jsr $9a86
        jsr $a2a0
        dec $a3
        jmp _3e11
_3e31:                                                                  ;$3e31
        inc a10
        lda # $0a
        bne _3dbe
_3e37:                                                                  ;$3e37
        lda # $d8
        jsr _2390
        ldy # $64
        jmp _3ea1

;===============================================================================

_3e41:                                                                  ;$3e41
        jsr _3e65
        bne _3e41
_3e46:                                                                  ;$3e46
        jsr _3e65
        beq _3e46
        lda # $00
        sta $28
        lda # $01
_3e51:                                                                  ;$3e51
        jsr $a72f
        jsr $9a86
        lda # $0a
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
        jsr $9a86
        jsr $a2a0
        jmp $8d53

;===============================================================================

_3e7c:                                                                  ;$3e7c
        jsr $8d53
        bne _3e7c
        jsr $8d53
        beq _3e7c
        rts 

;===============================================================================

_3e87:                                                                  ;$3e87
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
        ldx # $01
_3e97:                                                                  ;$3e97
        lda $049a, x
        sta $0509, x
        dex 
        bpl _3e97
        rts 

;===============================================================================

_3ea1:
        jsr $b148
        dey 
        bne _3ea1
        rts 

;===============================================================================

; $3ea8: 07 07               slo a07
; $3eaa: 0d 04 10            ora a1004
; $3ead: 15 1a               ora f1a,x
; $3eaf: 1f 9b a0            slo fa09b,x
; $3eb2: 2e a5 24            rol a24a5
; $3eb5: 29 3d               and #$3d
; $3eb7: 33 38               rla (p38),y
; $3eb9: aa                  tax 
; $3eba: 42                  jam 
; $3ebb: 47 4c               sre a4c
; $3ebd: 51 56               eor (p56),y
; $3ebf: 8c 60 65            sty a6560
;                    b3ec3   =*+$01
; $3ec2: 87 82               sax a82
; $3ec4: 5b 6a b4            sre fb46a,y
; $3ec7: b9 be e1            lda fe1be,y
; $3eca: e6 eb               inc aeb
; $3ecc: f0 f5               beq b3ec3
; $3ece: fa                  nop 
; $3ecf: 73 78               rra (p78),y
; $3ed1: 7d 00 00            adc f0000,x

;$3ed4