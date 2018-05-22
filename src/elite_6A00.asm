; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.include        "c64.asm"

; these will be replaced with imports once I've disassembled $1D00...$3DE4,
; and yes, I am aware that cc65 allows for 'default import of undefined labels'
; but I want to keep track of things explicitly for clarity and helping others

.define _1d01   $1d01
.define _1d02   $1d02
.define _1d03   $1d03
.define _1d04   $1d04
.define _1d05   $1d05
.define _1d06   $1d06
.define _1d08   $1d08
.define _1d0a   $1d0a
.define _1d0b   $1d0b
.define _1d0c   $1d0c
.define _1d0d   $1d0d
.define _1d0e   $1d0e
.define _1d0f   $1d0f
.define _1d10   $1d10
.define _1d11   $1d11
.define _1d12   $1d12
.define _1d13   $1d13
.define _1d14   $1d14
.define _1d21   $1d21

.define _1ec1   $1ec1
.define _202f   $202f
.define _2367   $2367
.define _2390   $2390
.define _246d   $246d
.define _24a6   $24a6
.define _2566   $2566
.define _2567   $2567
.define _25a6   $25a6
.define _25aa   $25aa
.define _25ab   $25ab
.define _25b2   $25b2
.define _25b3   $25b3
.define _25fd   $25fd
.define _25fe   $25fe
.define _25ff   $25ff
.define _2619   $2619
.define _267e   $267e
.define _26a4   $26a4
.define _27a4   $27a4
.define _28a4   $28a4
.define _28a5   $28a5
.define _28d5   $28d5
.define _28d9   $28d9
.define _28dc   $28dc
.define _28e0   $28e0
.define _28e5   $28e5
.define _28f3   $28f3
.define _2900   $2900
.define _2907   $2907
.define _2918   $2918
.define _293a   $293a
.define _2977   $2977
.define _2a12   $2a12
.define _2c4e   $2c4e
.define _2c50   $2c50
.define _2c9b   $2c9b
.define _2d69   $2d69
.define _2dc5   $2dc5
.define _2e55   $2e55
.define _2e57   $2e57
.define _2e59   $2e59
.define _2e65   $2e65
.define _2f19   $2f19
.define _2f1b   $2f1b
.define _2f1c   $2f1c
.define _2f1f   $2f1f
.define _2f24   $2f24
.define _2fee   $2fee
.define _2ff3   $2ff3

.define _31c6   $31c6
.define _32ad   $32ad
.define _3385   $3385
.define _34bc   $34bc
.define _3695   $3695
.define _3708   $3708
.define _3795   $3795
.define _379e   $379e
.define _37b2   $37b2
.define _3895   $3895
.define _38f8   $38f8
.define _3986   $3986
.define _3988   $3988
.define _399b   $399b
.define _39e0   $39e0
.define _39ea   $39ea
.define _3a25   $3a25
.define _3a27   $3a27
.define _3aa8   $3aa8
.define _3ace   $3ace
.define _3ad1   $3ad1
.define _3b0d   $3b0d
.define _3b37   $3b37
.define _3bc1   $3bc1
.define _3c6f   $3c6f
.define _3c7f   $3c7f
.define _3c95   $3c95
.define _3d2f   $3d2f
.define _3e08   $3e08
.define _3e87   $3e87
.define _3e95   $3e95
.define _3ea1   $3ea1

;===============================================================================

_6a00:                                                                  ;$6A00
        sta $04ef
        lda # $01
_6a05:  pha                                                             ;$6a05 
        ldx # $0c
        cpx $04ef
        bcc _6a1b                                                       
_6a0d:  adc $04b0, x                                                    ;$6a0d
        dex 
        bpl _6a0d
        adc $04ca
        cmp $04af
        pla 
        rts

_6a1b:                                                                  ;$6a1b
        ldy $04ef
        adc $04b0, y
        cmp # $c8
        pla 
        rts

;===============================================================================

_6a25:                                                                  ;$6a25
        sta $31
        rts 

;===============================================================================

_6a28:                                                                  ;$6a28
        sta $33
        rts 

;===============================================================================

_6a2b:                                                                  ;$6a2b
        inc $33
        rts 

;===============================================================================

_6a2e:                                                                  ;$62ae
        rts 
_6a2f:                                                                  ;$6a2f
        jsr _a72f
        jsr _28d5
        lda # $30
        jsr _6a2e
        rts 

;===============================================================================

_6a3b:                                                                  ;$6a3b:
        jsr _6a3e
_6a3e:                                                                  ;$6a3e:
        jsr _6a41
_6a41:                                                                  ;$6a41
        lda $7f
        clc 
        adc $81
        tax 
        lda $80
        adc $82
        tay 
        lda $81
        sta $7f
        lda $82
        sta $80
        lda $84
        sta $82
        lda $83
        sta $81
        clc 
        txa 
        adc $81
        sta $83
        tya 
        adc $82
        sta $84
        rts 

;===============================================================================

_6a68:                                                                  ;$6a68
        lda $0507
        ora $0508
        bne _6a73
        jmp _6a2b
_6a73:                                                                  ;$6a73
        lda # $bf
        jsr _7779
        ldx $0507
        ldy $0508
        sec 
        jsr _7235
        lda # $c3
_6a84:                                                                  ;$6a84
        jsr _777e
_6a87:                                                                  ;$6a87
        jsr _6a2b
_6a8a:                                                                  ;$6a8a
        lda # $80
        sta $34
_6a8e:                                                                  ;$6a8e
        lda # $0c
        jmp _777e

;===============================================================================

_6a93:                                                                  ;$6a93
        lda # $ad
        jsr _777e
        jmp _6ad3

;===============================================================================

_6a9b:                                                                  ;$6a9b
        jsr _777e
        jmp _72c5

;===============================================================================

_6aa1:                                                                  ;$6aa1:
        lda # $01
        jsr _6a2f
        lda # $09
        jsr _6a25
        lda # $a3
        jsr _28d9
        jsr _6a87
        jsr _6a68
        lda # $c2
        jsr _7779
        lda $0500
        clc 
        adc # $01
        lsr 
        cmp # $02
        beq _6a93
        lda $0500
        bcc _6ace
        sbc # $05
        clc 
_6ace:                                                                  ;$6ace
        adc # $aa
        jsr _777e
_6ad3:                                                                  ;$6ad3
        lda $0500
        lsr 
        lsr 
        clc 
        adc # $a8
        jsr _6a84
        lda # $a2
        jsr _7779
        lda $0501
        clc 
        adc # $b1
        jsr _6a84
        lda # $c4
        jsr _7779
        ldx $0502
        inx 
        clc 
        jsr _2e55
        jsr _6a87
        lda # $c0
        jsr _7779
        sec 
        ldx $0503
        jsr _2e55
        lda # $c6
        jsr _6a84
        lda # $28
        jsr _777e
        lda $83
        bmi _6b1e
        lda # $bc
        jsr _777e
        jmp _6b5a
_6b1e:                                                                  ;$6b1e
        lda $84
        lsr 
        lsr 
        pha 
        and # $07
        cmp # $03
        bcs _6b2e
        adc # $e3
        jsr _6a9b
_6b2e:                                                                  ;$6b2e
        pla 
        lsr 
        lsr 
        lsr 
        cmp # $06
        bcs _6b3b
        adc # $e6
        jsr _6a9b
_6b3b:                                                                  ;$6b3b
        lda $82
        eor $80
        and # $07
        sta $8e
        cmp # $06
        bcs _6b4c
        adc # $ec
        jsr _6a9b
_6b4c:                                                                  ;$6b4c
        lda $84
        and # $03
        clc 
        adc $8e
        and # $07
        adc # $f2
        jsr _777e
_6b5a:                                                                  ;$6b5a
        lda # $53
        jsr _777e
        lda # $29
        jsr _6a84
        lda # $c1
        jsr _7779
        ldx $0505
        ldy $0506
        jsr _7234
        jsr _72c5
        lda # $00
        sta $34
        lda # $4d
        jsr _777e
        lda # $e2
        jsr _6a84
        lda # $fa
        jsr _7779
        lda $84
        ldx $82
        and # $0f
        clc 
        adc # $0b
        tay 
        jsr _7235
        jsr _72c5
        lda # $6b
        jsr _2f24
        lda # $6d
        jsr _2f24
        jsr _6a87
;6ba5?
        jmp _3d2f

        rts 

;===============================================================================

_6ba9:                                                                  ;$6ba9
        lda $80
        and # $07
        sta $0500
        lda $81
        lsr 
        lsr 
        lsr 
        and # $07
        sta $0501
        lsr 
        bne _6bc5
        lda $0500
        ora # $02
        sta $0500
_6bc5:                                                                  ;$6bc5
        lda $0500
        eor # $07
        clc 
        sta $0502
        lda $82
        and # $03
        adc $0502
        sta $0502
        lda $0501
        lsr 
        adc $0502
        sta $0502
        asl 
        asl 
        adc $0500
        adc $0501
        adc # $01
        sta $0503
        lda $0500
        eor # $07
        adc # $03
        sta $2e
        lda $0501
        adc # $04
        sta $9a
        jsr _399b
        lda $0503
        sta $9a
        jsr _399b
        asl $2e
        rol 
        asl $2e
        rol 
        asl $2e
        rol 
        sta $0506
        lda $2e
        sta $0505
        rts 

;===============================================================================

_6c1c:                                                                  ;$6c1c
        lda # $40
        jsr _a72f
        lda # $10
        jsr _6a2e
        lda # $07
        jsr _6a25
        jsr _70a0
        lda # $c7
        jsr _777e
        jsr _28e0
        lda # $98
        jsr _28e5
        jsr _6cda
        ldx # $00
_6c40:                                                                  ;$6c40
        stx $9d
        ldx $82
        ldy $83
        tya 
        ora # $50
        sta $a1
        lda $80
        lsr 
        clc 
        adc # $18
        sta $6c
        jsr _293a
        jsr _6a3b
        ldx $9d
        inx 
        bne _6c40
        lda $0509
        sta $8e
        lda $050a
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
        sta $6b
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
        sta $6c
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
        sta $6c
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
        sta $6b
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
        lda $04a6
        sta $77
        jmp _6cfe

_6cda:                                                                  ;$6cda
        lda $a0
        bmi _6cc3
        lda $04a6
        lsr 
        lsr 
        sta $77
        lda $049a
        sta $8e
        lda $049b
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
        jsr _b3d4
        lda # $cc
        jsr _777e
        lda $04ef
        clc 
        adc # $d0
        jsr _777e
        lda # $2f
        jsr _777e
        jsr _72b8
        lda # $3f
        jsr _777e
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
        adc # $05
        jsr _6a28
        lda # $00
        jsr _6a25
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
        jsr _2f24
        dec $06
        bne _6dd6
_6e13:                                                                  ;$6e13
        lda # $10
        sta $050c
        lda $9b
        rts 
_6e1b:                                                                  ;$6e1b
        jsr _2f24
        lda $04ed
        sta $9b
        jmp _6e13
_6e26:                                                                  ;$6e26
        jsr _2f24
        lda # $00
        sta $9b
        jmp _6e13
_6e30:                                                                  ;$6e30
        jsr _6a8e
        lda # $b0
        jsr _723c
        jsr _7627
        ldy $04ef
        jmp _6e5d
_6e41:                                                                  ;$6e41
        lda # $04
        jsr _6a2f
        lda # $0a
        jsr _6a25
        lda # $cd
        jsr _777e
        lda # $ce
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
        txa 
        pha 
        jsr _6a8a
        clc 
        lda $04ef
        adc # $d0
        jsr _777e
        lda # $0e
        jsr _6a25
        pla 
        tax 
        sta $04ed
        clc 
        jsr _2e55
        jsr _72b8
        lda $a0
        cmp # $04
        bne _6eca
        lda # $cd
        jsr _777e
        lda # $ce
        jsr _2390
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
        lda $04c9
        ora $04ca
        bne _6eea
_6ee9:                                                                  ;$6ee9
        rts 
_6eea:                                                                  ;$6eea
        clc 
        lda # $00
        ldx $04c9
        ldy $04ca
        jsr _2e59
        jsr _84af
        and # $03
        clc 
        adc # $6f
        jsr _2390
        lda # $c6
        jsr _2390
        lda $04ca
        bne _6f11
        ldx $04c9
        dex 
        beq _6ee9
_6f11:                                                                  ;$6f11
        lda # $73
        jmp _2f24

;===============================================================================

_6f16:                                                                  ;$6f16
        lda # $08
        jsr _6a2f
        lda # $0b
        jsr _6a25
        lda # $a4
        jsr _6a84
        jsr _28dc
        jsr _774a
        lda $04af
        cmp # $1a
        bcc _6f37
        lda # $6b
        jsr _777e
_6f37:                                                                  ;$6f37
        jmp _6e58

;===============================================================================

; dead code?

_6f3a:                                                                  ;$6f3a
        jsr _777e
        lda # $ce
        jsr _2390
        jsr _8fea
        ora # $20
        cmp # $79
        beq _6f50
        lda # $6e
        jmp _2f24
_6f50:                                                                  ;$6f50
        jsr _2f24
        sec 
        rts 

;===============================================================================

_6f55:                                                                  ;$6f55
        txa 
        pha 
        dey 
        tya 
        eor # $ff
        pha 
        jsr _b148
        jsr _6f82
        pla 
        sta $91
        lda $050a
        jsr _6f98
        lda $92
        sta $050a
        sta $8f
        pla 
        sta $91
        lda $0509
        jsr _6f98
        lda $92
        sta $0509
        sta $8e
_6f82:                                                                  ;$6f82
        lda $a0
        bmi _6fa9
        lda $0509
        sta $8e
        lda $050a
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
        lda $0509
        sec 
        sbc $049a
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
        lda $050a
        sec 
        sbc $049b
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
        lda # $07
        jsr _6a25
        lda # $be
        jsr _28d9
        jsr _6cda
        jsr _6f82
        jsr _70a0
        lda # $00
        sta $ae
        ldx # $18
_7004:                                                                  ;$7004
        sta $09, x
        dex 
        bpl _7004
_7009:                                                                  ;$7009
        lda $82
        sec 
        sbc $049a
        bcs _7015
        eor # $ff
        adc # $01
_7015:                                                                  ;$7015
        cmp # $14
        bcs _708d
        lda $80
        sec 
        sbc $049b
        bcs _7025
        eor # $ff
        adc # $01
_7025:                                                                  ;$7025
        cmp # $26
        bcs _708d
        lda $82
        sec 
        sbc $049a
        asl 
        asl 
        adc # $68
        sta $71
        lsr 
        lsr 
        lsr 
        clc 
        adc # $01
        jsr _6a25
        lda $80
        sec 
        sbc $049b
        asl 
        adc # $5a
        sta $43
        lsr 
        lsr 
        lsr 
        tay 
        ldx $09, y
        beq _705c
        iny 
        ldx $09, y
        beq _705c
        dey 
        dey 
        ldx $09, y
        bne _7070
_705c:                                                                  ;$705c
        tya 
        jsr _6a28
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
        lda $84
        and # $01
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

_70a0:                                                                  ;$70a0
        ldx # $05
_70a2:                                                                  ;$70a2
        lda $049c, x
        sta $7f, x
        dex 
        bpl _70a2
        rts 

;===============================================================================

_70ab:                                                                  ;$70ab
        jsr _70a0
        ldy # $7f
        sty $bb
        lda # $00
        sta $99
_70b6:                                                                  ;$70b6
        lda $82
        sec 
        sbc $0509
        bcs _70c2
        eor # $ff
        adc # $01
_70c2:                                                                  ;$70c2
        lsr 
        sta $9c
        lda $80
        sec 
        sbc $050a
        bcs _70d1
        eor # $ff
        adc # $01
_70d1:                                                                  ;$70d1
        lsr 
        clc 
        adc $9c
        cmp $bb
        bcs _70e8
        sta $bb
        ldx # $05
_70dd:                                                                  ;$70dd
        lda $7f, x
        sta $8e, x
        dex 
        bpl _70dd
        lda $99
        sta $a1
_70e8:                                                                  ;$70e8
        jsr _6a3b
        inc $99
        bne _70b6
        ldx # $05
_70f1:                                                                  ;$70f1
        lda $8e, x
        sta $7f, x
        dex 
        bpl _70f1
        lda $80
        sta $050a
        lda $82
        sta $0509
        sec 
        sbc $049a
        bcs _710c
        eor # $ff
        adc # $01
_710c:                                                                  ;$710c
        jsr _3988
        sta $78
        lda $2e
        sta $77
        lda $050a
        sec 
        sbc $049b
        bcs _7122
        eor # $ff
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
        stx $0508
        rol $0508
        asl 
        rol $0508
        sta $0507
        jmp _6ba9

;===============================================================================

_714f:                                                                  ;$714f
        jsr _b3d4
        lda # $0f
        jsr _6a25
        lda # $cd
        jmp _2390

_715c:                                                                  ;$715c
        lda $a7
        bne _714f
        lda $66
        beq _7165
        rts 

_7165:                                                                  ;$7165
        jsr _8e92
        bmi _71ca
        lda $a0
        beq _71c4
        and # $c0
        bne _7173
        rts 

_7173:                                                                  ;$7173
        jsr _7695
_7176:                                                                  ;$7176
        lda $0507
        ora $0508
        bne _717f
        rts 

_717f:                                                                  ;$717f
        ldx # $05
_7181:                                                                  ;$7181
        lda $7f, x
        sta $04fa, x
        dex 
        bpl _7181
        lda # $07
        jsr _6a25
        lda # $17
        ldy $a0
        bne _7196
        lda # $11
_7196:                                                                  ;$7196
        jsr _6a28
        lda # $00
        sta $34
        lda # $bd
        jsr _777e
        lda $0508
        bne _71af
        lda $04a6
        cmp $0507
        bcs _71b2
_71af:                                                                  ;$71af
        jmp _723a

_71b2:                                                                  ;$71b2
        lda # $2d
        jsr _777e
        jsr _76e9
        lda # $0f
_71bc:                                                                  ;$71bc
        sta $66
        sta $65
        tax 
        jmp _7224

_71c4:                                                                  ;$71c4
        jsr _70ab
        jmp _7176

_71ca:                                                                  ;$71ca
        ldx $04c6
        beq _71f2 + 1              ; bug or optimisation?
        inx 
        stx $04c6
        stx $04cd
        lda # $02
        jsr _71bc
        ldx # $05
        inc $04a8
        lda $04a8
        and # $f7
        sta $04a8
_71e8:                                                                  ;$71e8
        lda $049c, x
        asl 
        rol $049c, x
        dex 
        bpl _71e8
_71f2:  ; the $60 also forms an RTS, jumped to from just after _71ca    ;$71f2
        lda # $60

;71f4:
         sta $0509
         sta $050a
         jsr _741c
         jsr _70ab
         ldx # $05
_7202:                                                                  ;$7202
        lda $7f, x
        sta $04fa, x
        dex 
        bpl _7202
        ldx # $00
        stx $0507
        stx $0508
        lda # $74
        jsr _900d
_7217:                                                                  ;$7217
        lda $0509
        sta $049a
        lda $050a
        sta $049b
        rts 

;===============================================================================

_7224:                                                                  ;$7224
        lda # $01
        jsr _6a25
        jsr _6a28
        ldy # $00
        clc 
        lda # $03
        jmp _2e59

;===============================================================================

_7234:                                                                  ;$7234
        clc 
_7235:                                                                  ;$7235
        lda # $05
        jmp _2e59

_723a:                                                                  ;$723a
        lda # $ca
_723c:                                                                  ;$723c
        jsr _777e
        lda # $3f
        jmp _777e

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
        lda # $01
        jsr _6a25
        pla 
        adc # $d0
        jsr _777e
        lda # $0e
        jsr _6a25
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
        jsr _2e57
        jmp _72b8
_72af:                                                                  ;$72af
        lda # $19
        jsr _6a25
        lda # $2d
        bne _72c7
_72b8:                                                                  ;$72b8
        lda $8f
        and # $60
        beq _72ca
        cmp # $20
        beq _72d1
        jsr _72d6
_72c5:                                                                  ;$72c5
        lda # $20
_72c7:                                                                  ;$72c7
        jmp _777e

_72ca:                                                                  ;$72ca
        lda # $74
        jsr _2f24
        bcc _72c5
_72d1:                                                                  ;$72d1
        lda # $6b
        jsr _2f24
_72d6:                                                                  ;$72d6
        lda # $67
        jmp _2f24

;===============================================================================

_72db:                                                                  ;$72db
        lda # $11
        jsr _6a25
        lda # $ff
        bne _72c7
_72e4:                                                                  ;$72e4
        lda # $10
        jsr _6a2f
        lda # $05
        jsr _6a25
        lda # $a7
        jsr _28d9
        lda # $03
        jsr _6a28
        jsr _72db
        lda # $06
        jsr _6a28
        lda # $00
        sta $04ef
_7305:                                                                  ;$7305
        ldx # $80
        stx $34
        jsr _7246
        jsr _6a2b
        inc $04ef
        lda $04ef
        cmp # $11
        bcc _7305
        rts 

;===============================================================================

_731a:                                                                  ;$731a
        lda $8f
        and # $1f
        ldy $04ee
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
        lda $0500
        sta $04ee
        lda $0502
        sta $04f1
        lda $0501
        sta $04f0
        jsr _84af
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
        and # $3f
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
        lsr $04a7
        sec 
        rol $04a7
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
        sta $050b
        ldx # $00
        jsr _a6ba
        lda $049b
        eor # $1f
        sta $049b
        rts 

;===============================================================================

        ; seriously!?
_73dc:                                                                  ;$73dc
        rts 

;===============================================================================

_73dd:                                                                  ;$73dd
        lda $04a6
        sec 
        sbc $0507
        bcs _73e8
        lda # $00
_73e8:                                                                  ;$73e8
        sta $04a6
        lda $a0
        bne _73f5
        jsr _a72f
        jsr _3795
_73f5:                                                                  ;$73f5
        jsr _8e92
        and _1d08
        bmi _73ac
        jsr _84af
        cmp # $fd
        bcs _73b3
        jsr _7337
        jsr _83df
        jsr _7a9f
        lda $a0
        and # $3f
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
        inc $11
        jsr _7a8c
        lda # $80
        sta $11
        inc $10
        jsr _7c24
        lda # $0c
        sta $96
        jsr _8798
        ora $04cd
        sta $04cd
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

;===============================================================================

_745a:                                                                  ;$745a
        stx $06
        lda $04a5
        sec 
        sbc $06
        sta $04a5
        sty $06
        lda $04a4
        sbc $06
        sta $04a4
        lda $04a3
        sbc # $00
        sta $04a3
        lda $04a2
        sbc # $00
        sta $04a2
        bcs _74a1
_7481:                                                                  ;$7481
        txa 
        clc 
        adc $04a5
        sta $04a5
        tya 
        adc $04a4
        sta $04a4
        lda $04a3
        adc # $00
        sta $04a3
        lda $04a2
        adc # $00
        sta $04a2
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

        .byte $52,$2e,$44,$2e,$43,$4f,$44,$45
        .byte $0d

;-------------------------------------------------------------------------------

_74b8:   jmp _88e7                                                      ;$74b8

_74bb:                                                                  ;$74bb
        lda # $20
        jsr _6a2f
        lda # $0c
        jsr _6a25
        lda # $cf
        jsr _6a9b
        lda # $b9
        jsr _28d9
        lda # $80
        sta $34
        jsr _6a2b
        lda $04f1
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
        sbc $04a6
        asl 
        sta _76cd+0
        ldx # $01
_74f5:                                                                  ;$74f5
        stx $a2
        jsr _6a8e
        ldx $a2
        clc 
        jsr _2e55
        jsr _72c5
        lda $a2
        clc 
        adc # $68
        jsr _777e
        lda $a2
        jsr _763f
        sec 
        lda # $19
        jsr _6a25
        lda # $06
        jsr _2e59
        ldx $a2
        inx 
        cpx $9a
        bcc _74f5
        jsr _b3d4
        lda # $7f
        jsr _723c
        jsr _6dc9
        beq _74b8
        bcs _74b8
        sbc # $00
        pha 
        lda # $02
        jsr _6a25
        jsr _6a2b
        pla 
        pha 
        jsr _762f
        pla 
        bne _7549
        ldx # $46
        stx $04a6
_7549:                                                                  ;$7549
        cmp # $01
        bne _755f
        ldx $04cc
        inx 
        ldy # $7c
        cpx # $05
        bcs _75a1
        stx $04cc
        jsr _845c
        lda # $01
_755f:                                                                  ;$755f
        ldy # $6b
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
        lda # $1f
        jsr _777e
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
        ldx $04c4
        bne _75a1
        inc $04c4
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
        ldx $04c6
        bne _75a1
        dec $04c6
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
        ldy # $32
        jmp _3ea1

;===============================================================================

_762f:
        jsr _7642
        jsr _745a
        bcs _764b
        lda # $c5
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
        lda $04f1
        cmp # $08
        bcc _7658
        lda # $20
        jsr _a72f
_7658:
        lda # $10
        tay 
        jsr _6a28
_765e:
        lda # $0c
        jsr _6a25
        tya 
        clc 
        adc # $20
        jsr _6a9b
        lda $33
        clc 
        adc # $50
        jsr _777e
        jsr _6a2b
        ldy $33
        cpy # $14
        bcc _765e
        jsr _b3d4
_767e:
        lda # $af
        jsr _723c
        jsr _8fea
        sec 
        sbc # $30
        cmp # $04
        bcc _7693
        jsr _b3d4
        jmp _767e

_7693:
        tax 
        rts 

;===============================================================================

_7695:
        jsr _6f82
        jsr _70ab
        jsr _6f82
        jmp _b3d4

;===============================================================================

_76a1:
        sta $06
        lda $04a9, x
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
        stx $a1
        tya 
        jsr _7642
        jsr _7481
        ldx $a1
_76c7:
        lda $06
        sta $04a9, x
        rts 

;===============================================================================

_76cd:
        .word   $0001, $012c, $0fa0, $1770, $0fa0
        .word   $2710, $1482, $2710, $2328, $3a98
        .word   $2710, $c350, $ea60, $1f40

;===============================================================================

_76e9:

        ldx # $05
_76eb:
        lda $7f, x
        sta $8e, x
        dex 
        bpl _76eb
        ldy # $03
        bit $7f
        bvs _76f9
        dey 
_76f9:
        sty $bb
_76fb:
        lda $84
        and # $1f
        beq _7706
        ora # $80
        jsr _777e
_7706:
        jsr _6a41
        dec $bb
        bpl _76fb
        ldx # $05
_770f:
        lda $8e, x
        sta $7f, x
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
        jsr _2f24
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
        lda $7f, x
        ldy $04f4, x
        sta $04f4, x
        sty $7f, x
        dex 
        bpl _7734
_7741:
        rts 

;===============================================================================

_7742:
        clc 
        ldx $04a8
        inx 
        jmp _2e55

;===============================================================================

_774a:
        lda # $69
        jsr _7779
        ldx $04a6
        sec 
        jsr _2e55
        lda # $c3
        jsr _7773
        lda # $77
        bne _777e
_775f:
        ldx # $03
_7761:
        lda $04a2, x
        sta $77, x
        dex 
        bpl _7761
        lda # $09
        sta $99
        sec 
        jsr _2e65
        lda # $e2
_7773:
        jsr _777e
        jmp _6a8e

;===============================================================================

_7779:
        jsr _777e
_777c:
        lda # $3a
_777e:
        tax 
        beq _775f
        bmi _77f9
        dex 
        beq _7742
        dex 
        beq _7727
        dex 
        bne _778f
        jmp _76e9
_778f:
        dex 
        beq _7717
        dex 
        beq _774a
        dex 
        bne _779d
        lda # $80
        sta $34
        rts 

_779d:
        dex 
        dex 
        bne _77a4
        stx $34
        rts 

_77a4:
        dex 
        beq _77df
        cmp # $60
        bcs _7813
        cmp # $0e
        bcc _77b3
        cmp # $20
        bcc _77db
_77b3:
        ldx $34
        beq _77f6
        bmi _77ca
        bit $34
        bvs _77ef
_77bd:
        cmp # $41
        bcc _77c7
        cmp # $5b
        bcs _77c7
        adc # $20
_77c7:
        jmp _2f24

_77ca:
        bit $34
        bvs _77e7
        cmp # $41
        bcc _77f6
        pha 
        txa 
        ora # $40
        sta $34
        pla 
        bne _77c7
_77db:
        adc # $72
        bne _7813
_77df:
        lda # $15
        jsr _6a25
        jmp _777c

_77e7:
        cpx # $ff
        beq _784e
        cmp # $41
        bcs _77bd
_77ef:
        pha 
        txa 
        and # $bf
        sta $34
        pla 
_77f6:
        jmp _2f24

_77f9:
        cmp # $a0
        bcs _7811
        and # $7f
        asl 
        tay 
        lda _2566, y
        jsr _777e
        lda _2567, y
        cmp # $3f
        beq _784e
        jmp _777e

_7811:
        sbc # $a0
_7813:
        tax 
        lda #< $0700
        sta $5b
        lda #> $0700
        sta $5c
        ldy # $00
        txa 
        beq _7834
_7821:
        lda ($5b), y
        beq _782c
        iny 
        bne _7821
        inc $5c
        bne _7821
_782c:
        iny 
        bne _7831
        inc $5c
_7831:
        dex 
        bne _7821
_7834:
        tya 
        pha 
        lda $5c
        pha 
        lda ($5b), y
        eor # $23
        jsr _777e
        pla 
        sta $5c
        pla 
        tay 
        iny 
        bne _784a
        inc $5c
_784a:
        lda ($5b), y
        bne _7834
_784e:
        rts 

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
        ora # $a0
        sta $28
        rts 

;===============================================================================

_7866:
        lda $28
        and # $40
        beq _786f
        jsr _78d6
_786f:
        lda $0f
        sta $bb
        lda $10
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
        lda ($2a), y
        sta $050d
        adc # $04
        bcs _785f
        sta ($2a), y
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
        sta ($2a), y
        lda $28
        and # $bf
        sta $28
        and # $08
        beq _784e
        ldy # $02
        lda ($2a), y
        tay 
_78bc:
        lda $00f9, y               ;16-bit reference?
        sta ($2a), y
        dey 
        cpy # $06
        bne _78bc
        lda $28
        ora # $40
        sta $28
        ldy $050d
        cpy # $12
        bne _78d6
        jmp _795a

_78d6:
        ldy # $00
        lda ($2a), y
        sta $9a
        iny 
        lda ($2a), y
        bpl _78e3
        eor # $ff
_78e3:
        lsr 
        lsr 
        lsr 
        lsr 
        ora # $01
        sta $99
        iny 
        lda ($2a), y
        sta $a8
        lda $03
        pha 
        ldy # $06
_78f5:
        ldx # $03
_78f7:
        iny 
        lda ($2a), y
        sta $35, x
        dex 
        bpl _78f7
        sty $aa
        ldy # $02
_7903:
        iny 
        lda ($2a), y
        eor $aa
        sta $ffff, y            ;irq
        cpy # $06
        bne _7903
        ldy $99
_7911:
        clc 
        lda $02
        rol 
        tax 
        adc $04
        sta $02
        stx $04
        lda $03
        tax 
        adc $05
        sta $03
        stx $05
        sta $a1
        lda $36
        sta $9b
        lda $35
        jsr _7974
        bne _795d
        cpx # $8f
        bcs _795d
        stx $6c
        lda $38
        sta $9b
        lda $37
        jsr _7974
        bne _7948
        lda $6c
        jsr _293a
_7948:
        dey 
        bpl _7911
        ldy $aa
        cpy $a8
        bcc _78f5
        pla 
        sta $03
        lda $f906               ;?
        sta $05
        rts 

;===============================================================================

_795a:
        jmp _79a9

;===============================================================================

_795d:
        clc 
        lda $02
        rol 
        tax 
        adc $04
        sta $02
        stx $04
        lda $03
        tax 
        adc $05
        sta $03
        stx $05
        jmp _7948

;===============================================================================

_7974:
        sta $9c
        clc 
        lda $02
        rol 
        tax 
        adc $04
        sta $02
        stx $04
        lda $03
        tax 
        adc $05
        sta $03
        stx $05
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
        lda # MEM_IO_ONLY       ;=5
        jsr _827f

        lda $10
        cmp # $07
        lda # $fd
        ldx # $2c
        ldy # $28
        bcs _79c0
        lda # $ff
        ldx # $20
        ldy # $1e
_79c0:
        sta $d017               ;sprites expand 2x vertical (y)
        sta $d01d               ;sprites expand 2x horizontal (x)
        stx $050e
        sty $050f
        ldy # $00
        lda ($2a), y
        sta $9a
        iny 
        lda ($2a), y
        bpl _79d9
        eor # $ff
_79d9:
        lsr 
        lsr 
        lsr 
        lsr 
        ora # $01
        sta $99
        iny 
        lda ($2a), y
        sta $a8
        lda $03
        pha 
        ldy # $06
_79eb:
        ldx # $03
_79ed:
        iny 
        lda ($2a), y
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
        lda $d010               ;sprites 0-7 msb of x coordinate
        and # $fd
        ora _79a7, x
        sta $d010               ;sprites 0-7 msb of x coordinate
        ldx $07
        sty $d003               ;sprite 1 y pos
        stx $d002               ;sprite 1 x pos
        lda $d015               ;sprite display enable
        ora # $02
        sta $d015               ;sprite display enable
_7a36:
        ldy # $02
_7a38:
        iny 
        lda ($2a), y
        eor $aa
        sta $ffff, y            ;irq
        cpy # $06
        bne _7a38
        ldy $99
_7a46:
        jsr _84ae
        sta $a1
        lda $36
        sta $9b
        lda $35
        jsr _7974
        bne _7a86
        cpx # $8f
        bcs _7a86
        stx $6c
        lda $38
        sta $9b
        lda $37
        jsr _7974
        bne _7a6c
        lda $6c
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
        sta $03
        
        lda # MEM_64K           ; =4
        jsr _827f

        lda $f906
        sta $05
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
        lda $04f1
        and # $02
        ora # $80
        jmp _7c6b

;===============================================================================

_7a9f:
        lda $04c9
        beq _7ac2
        lda # $00
        sta $04b0
        sta $04b6
        jsr _84af
        and # $0f
        adc $04c9
        ora # $04
        rol 
        sta $04c9
        rol $04ca
        bpl _7ac2
        ror $04ca
_7ac2:
        lsr $04cd
        jsr _8447
        lda $80
        and # $03
        adc # $03
        sta $11
        ror 
        sta $0b
        sta $0e
        jsr _7a8c
        lda $82
        and # $07
        ora # $81
        sta $11
        lda $84
        and # $03
        sta $0b
        sta $0a
        lda # $00
        sta $26
        sta $27
        lda # $81
        jsr _7c6b
_7af3:
        lda $a0
        bne _7b1a
_7af7:
        ldy $050b
_7afa:
        jsr _84af
        ora # $08
        sta $06d6, y
        sta $a1
        jsr _84af
        sta $06a2, y
        sta $6b
        jsr _84af
        sta $06bc, y
        sta $6c
        jsr _2918
        dey 
        bne _7afa
_7b1a:
        ldx # $00
_7b1c:
        lda $0452, x
        beq _7b44
        bmi _7b41
        sta $a5
        jsr _3e87
        ldy # $1f
_7b2a:
        lda ($59), y
        sta $0009, y
        dey 
        bpl _7b2a
        stx $9d
        jsr _b410
        ldx $9d
        ldy # $1f
        lda ($59), y
        and # $a7
        sta ($59), y
_7b41:
        inx 
        bne _7b1c
_7b44:
        ldx # $00
        stx $7e
        dex 
        stx _26a4
        stx _27a4
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

;$7b61?
        inx 
        beq _7b5f
        dec $04e9
        php 
        bne _7b6d
        inc $04e9
_7b6d:
        plp 
        rts 

;===============================================================================

;$7b6f?
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
        eor # $ff
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
        lda $6b
        jsr _7b7d
        txa 
        adc # $c3
        sta $04ea
        lda $6c
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

;$7bd2?
        sta $bb
        ldx # $00
        ldy # $08
        lda ($59), y
        bmi _7bee
        lda $04e7
        sbc $bb
        bcc _7be7
        sta $04e7
        rts 

_7be7:
        ldx # $00
        stx $04e7
        bcc _7bfe
_7bee:
        lda $04e8
        sbc $bb
        bcc _7bf9
        sta $04e8
        rts 

_7bf9:
        ldx # $00
        stx $04e8
_7bfe:
        adc $04e9
        sta $04e9
        beq _7c08
        bcs _7c0b
_7c08:
        jmp _87d0

_7c0b:
        jsr _a813
        jmp _906a

;===============================================================================

_7c11:
        lda $f901, x            ;?
        sta $35, x
        lda $f902, x            ;?
        tay 
        and # $7f
        sta $36, x
        tya 
        and # $80
        sta $37, x
        rts 

;===============================================================================

_7c24:
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
        sta $d002               ;sprite 1 x pos
        lda _8862
        sta $d003               ;sprite 1 y pos
        lda $04f1
        cmp # $0a
        bcc _7c61
        lda $d040               ;?
        sta $d002               ;sprite 1 x pos
        lda $d041               ;?
        sta $d003               ;sprite 1 y pos
_7c61:
        lda #< $0580
        sta $2a
        lda #> $0580
        sta $2b
        lda # $02
_7c6b:
        sta $bb
        ldx # $00
_7c6f:
        lda $0452, x
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
        lda $cfff, y            ;?
        beq _7c79
        sta $58
        lda $cffe, y            ;?
        sta $57
        cpy # $04
        beq _7cc4
        ldy # $05
        lda ($57), y
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
        lda ($57), y
        sta $2c
        ldy # $13
        lda ($57), y
        and # $07
        sta $28
        lda $bb
_7cd4:
        sta $0452, x
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
        lda $d041, y            ;?
        and # $6f
        ora $2d
        sta $2d
        ldy # $24
_7cf9:
        lda $0009, y            ;16-bit reference?
        sta ($59), y
        dey 
        bpl _7cf9
        sec 
        rts 

;-------------------------------------------------------------------------------

_7d03:
        lda $09, x
        eor # $80
        sta $09, x
        inx 
        inx 
        rts 

;===============================================================================

_7d0c:
        ldx # $ff
        stx $7c
        ldx $04cc
        jsr _b11f
        sty $0485
        rts 

;===============================================================================

;$7d1a:
        .byte   $04, $00, $00, $00, $00

_7d1f:
        lda $09
        sta $2e
        lda $0a
        sta $2f
        lda $0b
        jsr _81c9
        bcs _7d56
        lda $77
        adc # $80
        sta $35
        txa 
        adc # $00
        sta $36
        lda $0c
        sta $2e
        lda $0d
        sta $2f
        lda $0e
        eor # $80
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
        lda $11
        cmp # $30
        bcs _7d57
        ora $10
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
        lda $17
        eor # $80
        sta $2e
        lda $1d
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
        lda $17
        eor # $80
        sta $2e
        lda $23
        jsr _81aa
        ldx # $15
        jsr _81ba
        jmp _7e54

_7de0:
        lda $1d
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
        lda $09, x
        sta $2e
        lda $0a, x
        and # $7f
        sta $2f
        lda $0a, x
        and # $80
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
        and # $1f
        tax 
        lda $0ac0, x
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
        and # $1f
        tax 
        lda $0ac0, x
        sta $9a
        lda $b3
        jsr _39ea
        sta $79
        lda $b2
        jsr _39ea
        sta $2e
        lda $ab
        adc # $0f
        and # $3f
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
        eor # $ff
        clc 
        adc # $01
        tax 
        lda $bb
        eor # $7f
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
        eor # $80
        sta $bb
        bpl _7efd
        txa 
        eor # $ff
        clc 
        adc # $01
        tax 
        lda $bb
        eor # $7f
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
        and # $3f
        sta $ab
        jmp _7e5f

_7f12:
        rts 

;===============================================================================

_7f13:
        jmp _80ff

_7f16:
        txa 
        eor # $ff
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
        sty $6c
        jsr _9978
        ldy $6c
        jsr _84af
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
        lda $6b
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
        sta $6b
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
        eor # $ff
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
        and # $3f
        cmp # $21
        bcc _80af
        txa 
        eor # $ff
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
        lda _27a4, y
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
        sta $6b
        lda $6e
        sta $6c
        jmp _80c0

_80e6:
        iny 
        lda _26a4, y
        sta $6b
        lda _27a4, y
        sta $6c
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
        sta $6b
        lda $60
        sbc # $00
        bne _8140
        clc 
        rts 

_8140:
        bpl _8148
        lda # $00
        sta $6b
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
        eor # $ff
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
        ldx $17
        bmi _81b5
        eor # $80
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
        and # $7f
        ora $79
        bne _8187
        ldx $78
        cpx # $04
        bcs _81ed
        lda $7a
        bpl _81ed
        lda $77
        eor # $ff
        adc # $01
        sta $77
        txa 
        eor # $ff
        adc # $00
        tax 
_81ec:
        clc 
_81ed:
        rts 

;===============================================================================

_81ee:
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
        eor # $fe
_8268:
        bit _8d4b
        bpl _826f
        asl 
        asl 
_826f:
        tay 
        lda $7d
        rts 


_8273:  ; disable sprites:                                              ;$8273
        ;=======================================================================

        ; ensure the I/O is enabled so we can talk to the VIC-II:

        lda # MEM_IO_ONLY       ; =5; I/O on, no KERNAL present
        jsr _827f

        ; disable all sprites
        lda # %00000000
        sta $d015

        ; switch back to 64K RAM layout
        lda # MEM_64K           ; =4; full 64K RAM. BASIC, I/O & KERNAL OFF!

_827f:                                                                  ;$827f
        ;=======================================================================
        sei                     ; disable interrupts
        sta _828e               ; remember the requested memory layout state
        
        ; update the processor port:

        lda CPU_CONTROL
        and # %11111000         ; clear lower 3-bits whilst keeping upper bits
        ora _828e               ; set the given memory layout
        sta CPU_CONTROL
        
        cli                     ; enable interrupts
        rts 

_828e:                                                                  ;$828e
        .byte   MEM_64K         ; =4; full 64K RAM. BASIC, I/O & KERNAL OFF!

;===============================================================================

_828f:
        lda $2e
        sta $04f2
        lda $2f
        sta $04f3
        rts 

;===============================================================================

_829a:
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
        sta $0e
        lda # $81
        jmp _7c6b

;===============================================================================

_82bc:
        ldx # $ff
_82be:
        inx 
        lda $0452, x
        beq _828f
        cmp # $01
        bne _82be
        txa 
        asl 
        tay 
        lda _28a4, y
        sta $07
        lda _28a5, y
        sta $08
        ldy # $20
        lda ($07), y
        bpl _82be
        and # $7f
        lsr 
        cmp $ad
        bcc _82be
        beq _82ed
        sbc # $01
        asl 
        ora # $80
        sta ($07), y
        bne _82be
_82ed:
        lda # $00
        sta ($07), y
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
        ldx $0452, y
        cpx # $02
        beq _82a4
        cpx # $1f
        bne _831d
        lda $0499
        ora # $02
        sta $0499
        inc $04e1
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
        lda ($57), y
        ldy # $21
        clc 
        adc ($59), y
        sta $2e
        iny 
        lda ($59), y
        adc # $00
        sta $2f
_8343:
        inx 
        lda $0452, x
        sta $0451, x
        bne _834f
        jmp _82bc

_834f:
        asl 
        tay 
        lda $cffe, y            ;?
        sta $07
        lda $cfff, y            ;?
        sta $08
        ldy # $05
        lda ($07), y
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
        lda _28a4, y
        sta $07
        lda _28a5, y
        sta $08
        ldy # $24
        lda ($07), y
        sta ($59), y
        dey 
        lda ($07), y
        sta ($59), y
        dey 
        lda ($07), y
        sta $78
        lda $2f
        sta ($59), y
        dey 
        lda ($07), y
        sta $77
        lda $2e
        sta ($59), y
        dey 
_8399:
        lda ($07), y
        sta ($59), y
        dey 
        bpl _8399
        lda $07
        sta $59
        lda $08
        sta $5a
        ldy $bb
_83aa:
        dey 
        lda ($77), y
        sta ($2e), y
        tya 
        bne _83aa
        beq _8343
_83b4:
        ldx $04a8
        dex 
        bne _83c8
        lda $049a
        cmp # $90
        bne _83c8
        lda $049b
        cmp # $21
        beq _83c9
_83c8:
        clc 
_83c9:
        rts 

;===============================================================================

_83ca:
        jsr _8ac7
        ldx # $06
_83cf:
        sta $63, x
        dex 
        bpl _83cf
        txa 
        sta $a7
        ldx # $02
_83d9:
        sta $04e7, x
        dex 
        bpl _83d9

;===============================================================================

_83df:
        jsr _923b
        lda $04c3
        bpl _83ed
        jsr _2367
        sta $04c3
_83ed:
        lda # $0c
        sta $050b
        ldx # $ff
        stx _26a4
        stx _27a4
        stx $7c
        lda # $80
        sta $048e
        sta $69
        sta $94
        asl 
        sta $63
        sta $64
        sta $6a
        sta $95
        sta $a3
        sta $0510
        lda # $03
        sta $96
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
        lda #< $ffc0
        sta $04f2
        lda #> $ffc0
        sta $04f3
_8447:
        ldy # $24
        lda # $00
_844b:
        sta $0009, y            ;16-bit reference?
        dey 
        bpl _844b
        lda # $60
        sta $1b
        sta $1f
        ora # $80
        sta $17
        rts 

;===============================================================================

_845c:
        ldx # $04
_845e:
        cpx $04cc
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
        jsr _b3d4
        jmp _84fa

;===============================================================================

_848d:
        jsr _8447
        jsr _84af
        sta $06
        and # $80
        sta $0b
        txa 
        and # $80
        sta $0e
        lda # $19
        sta $0a
        sta $0d
        sta $10
        txa 
        cmp # $f5
        rol 
        ora # $c0
        sta $29
_84ae:
        clc 
_84af:
        lda $02
        rol 
        tax 
        adc $04
        sta $02
        stx $04
        lda $03
        tax 
        adc $05
        sta $03
        stx $05
        rts 

;===============================================================================

_84c3:
        jsr _84af
        lsr 
        sta $29
        sta $26
        rol $28
        and # $1f
        ora # $10
        sta $24
        jsr _84af
        bmi _84e2
        lda $29
        ora # $c0
        sta $29
        ldx # $10
        stx $2d
_84e2:
        and # $02
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
        dec $a3
        beq _8501
_84fe:
        jmp _8627

_8501:
        lda $0482
        bne _84fe
        jsr _84af
        cmp # $23
        bcs _8562
        lda $047f
        cmp # $03
        bcs _8562
        jsr _8447
        lda # $26
        sta $10
        jsr _84af
        sta $09
        stx $0c
        and # $80
        sta $0b
        txa 
        and # $80
        sta $0e
        rol $0a
        rol $0a
        jsr _84af
        bvs _84c3
        ora # $6f
        sta $26
        lda $045f
        bne _8562
        txa 
        bcs _8548
        and # $1f
        ora # $10
        sta $24
        bcc _854c
_8548:
        ora # $7f
        sta $27
_854c:
        jsr _84af
        cmp # $fc
        bcc _8559
        lda # $0f
        sta $29
        bne _855f
_8559:
        cmp # $0a
        and # $01
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
        ora $04cd
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
        lda $0499
        and # $0c
        cmp # $08
        bne _85a8
        jsr _84af
        cmp # $c8
        bcc _85a8
_85a5:
        jsr _739b
_85a8:
        jsr _84af
        ldy $04f0
        beq _85bb
        cmp # $5a
        bcs _8567
        and # $07
        cmp $04f0
        bcc _8567
_85bb:
        jsr _848d
        cmp # $64
        bcs _860b
        inc $048a
        and # $03
        adc # $18
        tay 
        jsr _83b4
        bcc _85e0
        lda # $f9
        sta $29
        lda $0499
        and # $03
        lsr 
        bcc _85e0
        ora $047c
        beq _85ef+1             ; bug or optimisation?
_85e0:
        lda # $04
        sta $2d
        jsr _84af
        cmp # $c8
        rol 
        ora # $c0
        sta $29
        tya 
_85ef:      ; NOTE: when accessed as $85F0, this becomes `lda # $1f`
        bit $1fa9
_85f2:
        jsr _7c6b
        jmp _8627

_85f8:
        lda $f906
        and # $3e
        bne _85a5
        lda # $12
        sta $24
        lda # $79
        sta $29
        lda # $20
        bne _85f2
_860b:
        and # $03
        sta $048a
        sta $a2
_8612:
        jsr _84af
        sta $bb
        jsr _84af
        and $bb
        and # $07
        adc # $11
        jsr _7c6b
        dec $a2
        bpl _8612
_8627:
        ldx # $ff
        txs 
        ldx $0488
        beq _8632
        dec $0488
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
        ldy # $02
        jsr _3ea1
_8654:
        lda $04ca
        beq _8670
        jsr _84af
        cmp # $dc
        lda $04c9
        adc # $00
        sta $04c9
        bcc _8670
        inc $04ca
        bpl _8670
        dec $04ca
_8670:
        lda $04ca
        beq _86a1
        sta $bb
        lda $0483
        cmp # $e0
        bcs _8680
        asl $bb
_8680:
        jsr _84af
        cmp $bb
        bcs _86a1
        jsr _84af
        ora # $40
        tax 
        lda # $80
        ldy $0483
        cpy # $e0
        bcc _869c
        txa 
        and # $0f
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
        beq _871e+1             ;bug or optimisation?
        cmp # $3a
        beq _871b+1             ;bug or optimisation?
        cmp # $3d
        bne _8724
        ldx # $03
_871b:  ; NOTE: when called as $871c, this becomes `lda #$02`
        bit $02a2
_871e:  ; NOTE: when called as $871f, this becomes `lda #$01`
        bit $01a2
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
        and # $c0
        beq _877d
        jmp _31c6

_8741:
        sta $06
        lda $a0
        and # $c0
        beq _875f
        lda $66
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
        lda $66
        beq _877d
        dec $65
        bne _877d
        ldx $66
        dex 
        jsr _7224
        lda # $05
        sta $65
        ldx $66
        jsr _7224
        dec $66
        bne _877d
        jmp _73dd

_877d:
        rts 

_877e:
        lda $a0
        and # $c0
        beq _877d
        jsr _7695
        sta $34
        jsr _76e9
        lda # $80
        sta $34
        lda # $0c
        jsr _2f24
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

_874a:
        lda # $e0
        cmp $0a
        bcc _87b0
        cmp $0d
        bcc _87b0
        cmp $10
_87b0:
        rts 

;===============================================================================

_87b1:
         ora $0a
         ora $0d
         ora $10
         rts 

;===============================================================================

_87b8:
        .byte   $00

; unused?
;$87B9
        dec _87b8
        ldx # $ff
        txs 
        jsr _8c60
        tay 
        lda # $07
_87c5:
        jsr _b17b
        iny 
        lda ($fd), y
        bne _87c5
        jmp _8888

;===============================================================================

_87d0:
        jsr _a813
        jsr _83df
        asl $96
        asl $96
        ldx # $18
        jsr _7b5e
        jsr _a72f
        jsr _b2a5
        lda # $00
        sta $5f1f
        sta $4118
        jsr _7af7
        lda # $0c
        jsr _6a28
        jsr _6a25
        lda # $92
        jsr _7813
_87fd:
        jsr _848d
        lsr 
        lsr 
        sta $09
        ldy # $00
        sty $a0
        sty $0a
        sty $0d
        sty $10
        sty $29
        dey 
        sty $a3
        eor # $2a
        sta $0c
        ora # $50
        sta $0f
        txa 
        and # $8f
        sta $26
        ldy # $40
        sty $0487
        sec 
        ror 
        and # $87
        sta $27
        ldx # $05
        lda $d007               ;sprite 3 y pos
        beq _8835
        bcc _8835
        dex 
_8835:
        jsr _3695
        jsr _84af
        and # $80
        ldy # $1f
        sta ($59), y
        lda $0456
        beq _87fd
        jsr _8ed5
        sta $96
        jsr _1ec1
        jsr _8273
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
        ldx # $11
        lda # $00
_8867:
        sta _1d01, x
        dex 
        bpl _8867
        lda $d002    ;sprite 1 x pos
        sta _8861
        lda $d003    ;sprite 1 y pos
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
        lda # $03
        jsr _6a25
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
        lda $7f, x
        sta $04f4, x
        dex 
        bpl _88c9
        inx 
        stx $048a
        lda $0500
        sta $04ee
        lda $0502
        sta $04f1
        lda $0501
        sta $04f0
_88e7:
        lda # $ff
        sta $a7
        lda # $25
        jmp _86a4

;===============================================================================

_88f0:
        ldx # $54
_88f2:
        lda _25aa, x
        sta $0490, x
        dex 
        bne _88f2
        stx $a0
_88fd:
        jsr _89eb
        cmp _25ff
        bne _88fd
        eor # $a9
        tax 
        lda $04a7
        cpx _25fd
        beq _8912
        ora # $80
_8912:
        ora # $40
        sta $04a7
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
        sta $17
        lda # $60
        sta $10
        ldx # $7f
        stx $26
        stx $27
        inx 
        stx $34
        lda $a5
        jsr _7c6b
        lda # $06
        jsr _6a25
        lda # $1e
        jsr _7773
        lda # $0a
        jsr _2f24
        lda # $06
        jsr _6a25
        lda _1d08
        beq _8978
        lda # $0d
        jsr _2390
_8978:
        lda _87b8
        beq _8994
        inc _87b8
        lda # $07
        jsr _6a25
        lda # $0a
        jsr _6a28
        ldy # $00
_898c:
        jsr _b17b
        iny 
        lda ($fd), y
        bne _898c
_8994:
        ldy # $00
        sty $96
        sty _1d0c
        lda # $0f
        sta $33
        lda # $01
        sta $31
        pla 
        jsr _2390
        lda # $03
        jsr _6a25
        lda # $0c
        jsr _2390
        lda # $0c
        sta $ab
        lda # $05
        sta $a3
        lda # $ff
        sta _1d0c
_89be:
        lda $10
        cmp # $01
        beq _89c6
        dec $10
_89c6:
        jsr _a2a0
        ldx $06fb
        stx $0f
        lda $a3
        and # $03
        lda # $00
        sta $09
        sta $0c
        jsr _9a86
        jsr _8d53
        dec $a3
        bit _8d42
        bmi _89ea
        bcc _89be
        inc _1d0c
_89ea:
        rts 

;===============================================================================

_89eb:
        ldx # $49
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
        ldx # $49
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
        ldy # $61
_8a0e:
        lda _2619, y
        sta _25ab, y
        dey 
        bpl _8a0e
        ldy # $07
        sty _8bbf
        rts

;===============================================================================

_8a1d:
        ldx # $07
        lda _8bbe
        sta _8bbf
_8a25:
        lda $0e, x
        sta _25ab, x
        dex 
        bpl _8a25
_8a2d:
        ldx # $07
_8a2f:
        lda _25ab, x
        sta $0e, x
        dex 
        bpl _8a2f
        rts 

_8a38:
        ldx # $04
_8a3a:
        lda _25a6, x
        sta $09, x
        dex 
        bpl _8a3a
        lda # $07
        sta _8ab2
        lda # $08
        jsr _2390
        jsr _8a5b
        lda # $09
        sta _8ab2
        tya 
        beq _8a2d
        sty _8bbe
        rts 

;===============================================================================

_8a5b:
        lda # $40
        sta $050c
        ldy # $08
        jsr _3ea1
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
        bcs _8a8c+1
        cmp _8ab3
        bcc _8a8c+1
        cmp _8ab4
        bcs _8a8c+1
        sta $000e, y
        iny 
_8a8c:  ; NOTE: when accessed as $8A8D, appears as `lda # $07`
        bit $07a9
_8a8f:
        jsr _b17b
        bcc _8a6a
_8a94:
        sta $000e, y
        lda # $10
        sta $050c
        lda # $0c
        jmp _b17b

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

; unused / unreferenced?
;$8ab5:
        lda # $03
        clc 
        adc _1d0e
        jmp _2390

; unused / unreferenced?
;$8abe:
        lda # $02
        sec 
        sbc _1d0e
        jmp _2390

;===============================================================================

_8ac7:
        ldx # $3a
        lda # $00
_8acb:
        sta $0452, x
        dex 
        bpl _8acb
        rts 
        rts        ;?

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
        sta ($07), y
        iny 
        bne _8ae1
        rts 

;===============================================================================

_8ae7:
        lda # $01
        jsr _2390
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
        jsr _2390
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
        eor # $ff
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
        jsr _2390
        ldx # $4c
_8b37:
        lda $0499, x
        sta _25b3, x
        dex 
        bpl _8b37
        jsr _89f9
        sta _25fe
        jsr _89eb
        sta _25ff
        pha 
        ora # $80
        sta $77
        eor $04a7
        sta $79
        eor $04a4
        sta $78
        eor # $5a
        eor $04e1
        sta $7a
        clc 
        jsr _2e65
        jsr _6a8e
        jsr _6a8e
        pla 
        eor # $a9
        sta _25fd
        jsr _8bc0
        lda #< _25b3
        sta $fd
        lda #> _25b3
        sta $fe
        lda # $fd
        ldx # $00
        ldy # $26
        jsr $ffd8               ;$ffd8 - save after call setlfs,setnam    
        php 
        sei 
        bit $dc0d               ;cia1: cia interrupt control register
        lda # $01
        sta $dc0d               ;cia1: cia interrupt control register
        ldx # $00
        stx _a8d9
        inx 
        stx $d01a               ;vic interrupt mask register (imr)
        lda $d011               ;vic control register 1
        and # $7f
        sta $d011               ;vic control register 1
        lda # $28
        sta $d012               ;raster position

        lda # MEM_64K           ;=4
        jsr _827f
        
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
        lda # MEM_IO_KERNAL     ;=6
        sei 
        jsr _827f
        lda # $00
        sta $d01a               ;vic interrupt mask register (imr)
        cli 
        lda # $81
        sta $dc0d               ;cia1: cia interrupt control register
        lda # $c0
        jsr $ff90               ;$ff90 - enable/disable kernal messages   
        ldx _1d0e
        inx 
        lda _8c0b, x
        tax 
        lda # $01
        ldy # $00
        jsr $ffba               ;$ffba - set file parameters              
        lda _8bbe
        ldx # $0e
        ldy # $00
        jmp $ffbd               ;$ffbd - set file name                    
        
        ;bug / unused code? (`jmp` instead of `jsr` above)
        lda # $02
        jsr _2390
        jsr _8fec
        ora # $10
        jsr _b17b
        pha 
        jsr _2f1f
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
        jsr $ffd5               ;$ffd5 - load after call setlfs,setnam    
        php 
        lda # $01
        sta $dc0d               ;cia1: cia interrupt control register
        sei 
        ldx # $00
        stx _a8d9
        inx 
        stx $d01a               ;vic interrupt mask register (imr)
        lda $d011               ;vic control register 1
        and # $7f
        sta $d011               ;vic control register 1
        lda # $28
        sta $d012               ;raster position
        lda # MEM_64K           ;=4
        jsr _827f
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
        jsr _2390
        jsr _8fec
        jmp _8ae7

;===============================================================================

_8c60:
        rts 

;===============================================================================

_8c61:
        lda # $ff
        jsr _2390
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
        ldx # $00
        jsr _7c11
        ldx # $03
        jsr _7c11
        ldx # $06
        jsr _7c11
_8c8a:
        lda $35
        ora $38
        ora $3b
        ora # $01
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
        lda $36
        lsr 
        ora $37
        sta $6b
        lda $39
        lsr 
        ora $3a
        sta $6c
        lda $3c
        lsr 
        ora $3d
        sta $6d
_8cc2:
        lda $6b
        jsr _3986
        sta $9b
        lda $2e
        sta $9a
        lda $6c
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
        lda $6b
        jsr _918b
        sta $6b
        lda $6c
        jsr _918b
        sta $6c
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
        .byte   $34, $35, $36, $37              ; '4', '5', '6', '7'?
_8d13:
        .byte   $38, $39, $41, $42, $43         ; '8', '9', 'A', 'B', 'C'?
_8d18:
        .byte   $44, $45, $46, $30, $31         ; 'D', 'E', 'F', '0', '1'?
_8d1d:
        .byte   $32, $33, $34                   ; '2', '3', '4'?
_8d20:
        .byte   $35, $36, $37                   ; '5', '6', '7'?
_8d23:
        .byte   $38, $39, $41, $42, $43         ; '8', '9', 'A', 'B', 'C'?
_8d28:
        .byte   $44, $45                        ; 'D', 'E'?
_8d2a:
        .byte   $46, $30, $31, $32              ; 'F', '0', '1', '2'?
_8d2e:
        .byte   $33                             ; '3'?
_8d2f:
        .byte   $34, $35, $36, $37, $38, $39    ; '4', '5', '6', '7', '8', '9'?
_8d35:
        .byte   $41                             ; 'A'?
_8d36:
        .byte   $42, $43                        ; 'B', 'C'?
_8d38:
        .byte   $44, $45, $46, $30, $31         ; 'D', 'E', 'F', '0', '1'?
_8d3d:
        .byte   $32                             ; '2'?
_8d3e:
        .byte   $33                             ; '3'?
_8d3f:
        .byte   $34, $35, $36                   ; '4', '5', '6'?
_8d42:
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
        tya 
        pha 
        lda # MEM_IO_ONLY       ;=5
        jsr _827f
        lda $d015               ;sprite display enable
        and # $fd
        sta $d015               ;sprite display enable
        jsr _8c6d
        ldx _1d0c
        beq _8d73
        lda $dc00               ;cia1: data port register a
        and # $1f
        eor # $1f
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
        lda # MEM_64K           ;=4
        jsr _827f
        pla 
        tay 
        lda $7d
        tax 
        rts 

;===============================================================================

_8e29:
        ldx $047f
        lda $0454, x
        ora $045f
        ora $0482
        bne _8e7c
        ldy $f908
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
        lda $f908
        jsr _3ad1
        sta $f908
        lda $f92d
        jsr _3ad1
        sta $f92d
        lda # $01
        sta $a0
        sta $a3
        lsr 
        sta $048a
        ldx $0486
        jmp _a6ba

_8e7c:
        ldy # $06
        jmp _a857+1
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
        lda # MEM_IO_ONLY       ;=5
        jsr _827f
        sei 
        stx $dc00               ;cia1: data port register a
        ldx $dc01               ;cia1: data port register b
        cli 
        inx 
        beq _8eab
        ldx # $ff
_8eab:
        lda # MEM_64K           ;=4
        jsr _827f
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
        eor # $ff
        sta _1d06, y
        jsr _2fee
        tya 
        pha 
        ldy # $14
        jsr _3ea1
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
        sta $17
        ora # $80
        sta $1f
        sta $a5
        lda $96
        sta $24
        jsr _34bc
_8eff:
        lda $24
_8f01:
        cmp # $16
        bcc _8f07
        lda # $16
_8f07:
        sta $96
        lda # $ff
        ldx # $09
        ldy $25
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
        jsr _b148
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
        ldy # $02
        jsr _3ea1
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
        pha 
        lda # $10
        ldx $a0
        beq _9019+1
        jsr _b3d4
        lda # $19
_9019:
        bit _3385
        ldx # $00
        stx $34
        lda $b9
        jsr _6a25
        pla 
        ldy # $14
        cpx $048b
        bne _9002
        sty $048b
        sta $04e6
        lda # $c0
        sta _2f1b
        lda $048c
        lsr 
        lda # $00
        bcc _9042
        lda # $0a
_9042:
        sta _2f1c
        lda $04e6
        jsr _777e
        lda # $20
        sec 
        sbc _2f1c
        lsr 
        sta $b9
        jsr _6a25
        jsr _24a6
        lda $04e6
_905d:
        jsr _777e
        lsr $048c
        bcc _9001
        lda # $fd
        jmp _777e

;===============================================================================

_906a:
        jsr _84af
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
        lda # $6c
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
        and $0f, x
        cpy # $07

_90e9:
        tya 
        ldy # $02
        jsr _91b8
        sta $1d
        jmp _9131

;===============================================================================

_90f4:
        tax 
        lda $6c
        and # $60
        beq _90e9
        lda # $02
        jsr _91b8
        sta $1b
        jmp _9131

;===============================================================================

_9105:
        lda $13
        sta $6b
        lda $15
        sta $6c
        lda $17
        sta $6d
        jsr _8cc2
        lda $6b
        sta $13
        lda $6c
        sta $15
        lda $6d
        sta $17
        ldy # $04
        lda $6b
        and # $60
        beq _90f4
        ldx # $02
        lda # $00
        jsr _91b8
        sta $19
_9131:
        lda $19
        sta $6b
        lda $1b
        sta $6c
        lda $1d
        sta $6d
        jsr _8cc2
        lda $6b
        sta $19
        lda $6c
        sta $1b
        lda $6d
        sta $1d
        lda $15
        sta $9a
        lda $1d
        jsr _3aa8
        ldx $17
        lda $1b
        jsr _3b0d
        eor # $80
        sta $1f
        lda $19
        jsr _3aa8
        ldx $13
        lda $1d
        jsr _3b0d
        eor # $80
        sta $21
        lda $1b
        jsr _3aa8
        ldx $15
        lda $19
        jsr _3b0d
        eor # $80
        sta $23
        lda # $00
        ldx # $0e
_9184:
        sta $12, x
        dex 
        dex 
        bpl _9184
        rts 

;===============================================================================

_918b:
        tay 
        and # $7f
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
        and # $80
        ora $bb
        rts 

_91b2:
        tya 
        and # $80
        ora # $60
        rts 

;===============================================================================

_91b8:
        sta $30
        lda $13, x
        sta $9a
        lda $19, x
        jsr _3aa8
        ldx $13, y
        stx $9a
        lda $0019, y
        jsr _3ace
        stx $2e
        ldy $30
        ldx $13, y
        stx $9a
        eor # $80
        sta $2f
        eor $9a
        and # $80
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
        lda # MEM_IO_ONLY       ;=5
        jsr _827f
        jsr _b664
        lda # $ff
        sta _1d03
        bne _9266
_9231:
        sta _1d02
        eor # $ff
        and $0480
        bmi _9222
_923b:
        bit _1d13
        bmi _91fd
        bit _1d10
        bmi _9204
_9245:
        bit _1d03
        bpl _91fd
        jsr _a817
        lda # MEM_IO_ONLY       ;=5
        jsr _827f
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
        lda # MEM_64K           ;=4
        jmp _827f

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

_9700:
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$9700
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$9708
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$9710
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$9718
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$9720
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$9728
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$9730
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$9738
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$9740
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$9748
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$9750
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$9758
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$9760
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$9768
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$9770
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$9778
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$9780
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$9788
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$9790
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$9798
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$97a0
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$97a8
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$97b0
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$97b8
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$97c0
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$97c8
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$97d0
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$97d8
        .byte   $20, $20, $20, $20, $20, $20, $20, $20                  ;$97e0
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$97e8
        .byte   $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0                  ;$97f0
        .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0                  ;$97f8

;===============================================================================

_9800:
        .byte   $40, $40, $40, $40, $40, $40, $40, $40                  ;$9800
        .byte   $41, $41, $41, $41, $41, $41, $41, $41                  ;$9808
        .byte   $42, $42, $42, $42, $42, $42, $42, $42                  ;$9810
        .byte   $43, $43, $43, $43, $43, $43, $43, $43                  ;$9818
        .byte   $45, $45, $45, $45, $45, $45, $45, $45                  ;$9820
        .byte   $46, $46, $46, $46, $46, $46, $46, $46                  ;$9828
        .byte   $47, $47, $47, $47, $47, $47, $47, $47                  ;$9830
        .byte   $48, $48, $48, $48, $48, $48, $48, $48                  ;$9838
        .byte   $4a, $4a, $4a, $4a, $4a, $4a, $4a, $4a                  ;$9840
        .byte   $4b, $4b, $4b, $4b, $4b, $4b, $4b, $4b                  ;$9848
        .byte   $4c, $4c, $4c, $4c, $4c, $4c, $4c, $4c                  ;$9850
        .byte   $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d                  ;$9858
        .byte   $4f, $4f, $4f, $4f, $4f, $4f, $4f, $4f                  ;$9860
        .byte   $50, $50, $50, $50, $50, $50, $50, $50                  ;$9868
        .byte   $51, $51, $51, $51, $51, $51, $51, $51                  ;$9870
        .byte   $52, $52, $52, $52, $52, $52, $52, $52                  ;$9878
        .byte   $54, $54, $54, $54, $54, $54, $54, $54                  ;$9880
        .byte   $55, $55, $55, $55, $55, $55, $55, $55                  ;$9888
        .byte   $56, $56, $56, $56, $56, $56, $56, $56                  ;$9890
        .byte   $57, $57, $57, $57, $57, $57, $57, $57                  ;$9898
        .byte   $59, $59, $59, $59, $59, $59, $59, $59                  ;$98a0
        .byte   $5a, $5a, $5a, $5a, $5a, $5a, $5a, $5a                  ;$98a8
        .byte   $5b, $5b, $5b, $5b, $5b, $5b, $5b, $5b                  ;$98b0
        .byte   $5c, $5c, $5c, $5c, $5c, $5c, $5c, $5c                  ;$98b8
        .byte   $5e, $5e, $5e, $5e, $5e, $5e, $5e, $5e                  ;$98c0
        .byte   $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f                  ;$98c8
        .byte   $60, $60, $60, $60, $60, $60, $60, $60                  ;$98d0
        .byte   $61, $61, $61, $61, $61, $61, $61, $61                  ;$98d8
        .byte   $63, $63, $63, $63, $63, $63, $63, $63                  ;$98e0
        .byte   $64, $64, $64, $64, $64, $64, $64, $64                  ;$98e8
        .byte   $65, $65, $65, $65, $65, $65, $65, $65                  ;$98f0
        .byte   $66, $66, $66, $66, $66, $66, $66, $66                  ;$98f8

;===============================================================================

_9900:
        .byte   $03, $2b, $53, $7b, $a3, $cb, $f3, $1b                  ;$9900
        .byte   $43, $6b, $93, $bb, $e3, $0b, $33, $5b                  ;$9908
        .byte   $83, $ab, $d3, $fb, $23, $4b, $73, $9b                  ;$9910
        .byte   $c3                                                     ;$9918
_9919:
        .byte   $60, $60, $60, $60, $60, $60, $60, $61                  ;$9919
        .byte   $61, $61, $61, $61, $61, $62, $62, $62                  ;$9921
        .byte   $62, $62, $62, $62, $63, $63, $63, $63                  ;$9929
        .byte   $63                                                     ;$9931

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
        sta ($2a), y
        iny 
        iny 
        sta ($2a), y
        lda $35
        dey 
        sta ($2a), y
        adc # $03
        bcs _995b
        dey 
        dey 
        sta ($2a), y
        rts 

;===============================================================================

_9978:
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
        eor # $80
        sta $9c
        pla 
        eor # $ff
        adc # $01
        rts 

;===============================================================================

_9a2c:
        ldx # $00
        ldy # $00
_9a30:
        lda $6b
        sta $9a
        lda $45, x
        jsr _39ea
        sta $bb
        lda $6c
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
        and # $3f
        sta $28
        lda # $00
        ldy # $1c
        sta ($59), y
        ldy # $1e
        sta ($59), y
        jsr _9ad8
        ldy # $01
        lda # $12
        sta ($2a), y
        ldy # $07
        lda ($57), y
        ldy # $02
        sta ($2a), y
_9abb:
        iny 
        jsr _84af
        sta ($2a), y
        cpy # $06
        bne _9abb
_9ac5:
        lda $11
        bpl _9ae6
_9ac9:
        lda $28
        and # $20
        beq _9ad8
        lda $28
        and # $f7
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
        lda $10
        cmp # $c0
        bcs _9ac9
        lda $09
        cmp $0f
        lda $0a
        sbc $10
        bcs _9ac9
        lda $0c
        cmp $0f
        lda $0d
        sbc $10
        bcs _9ac9
        ldy # $06
        lda ($57), y
        tax 
        lda # $ff
        sta $0100, x
        sta $0101, x
        lda $0f
        sta $bb
        lda $10
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
        lda ($57), y
        cmp $10
        bcs _9b3a
        lda # $20
        and $28
        bne _9b3a
        jmp _9932

_9b3a:
        ldx # $05
_9b3c:
        lda $1e, x
        sta $45, x
        lda $18, x
        sta $4b, x
        lda $12, x
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
        lda $09, x
        sta $85, x
        dex 
        bpl _9b66
        lda # $ff
        sta $44
        ldy # $0c
        lda $28
        and # $20
        beq _9b8b
        lda ($57), y
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
        lda ($57), y
        beq _9b88
        sta $ae
        ldy # $12
        lda ($57), y
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
        sta $6b
        lda $87
        sta $6c
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
        lda ($57), y
        clc 
        adc $57
        sta $5b
        ldy # $11
        lda ($57), y
        adc $58
        sta $5c
        ldy # $00
_9bf2:
        lda ($5b), y
        sta $72
        and # $1f
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
        lda ($5b), y
        sta $71
        iny 
        lda ($5b), y
        sta $73
        iny 
        lda ($5b), y
        sta $75
        ldx $9f
        cpx # $04
        bcc _9c4b
        lda $85
        sta $6b
        lda $87
        sta $6c
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
        sta $6b
        lda $73
        sta $6d
        lda $75
        dex 
        bmi _9c60
_9c58:
        lsr $6b
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
        lda $6b
        sta $9b
        lda $72
        sta $9c
        lda $85
        sta $9a
        lda $87
        jsr _9a0c
        bcs _9c43
        sta $6b
        lda $9c
        sta $6c
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
        lda $6b
        jsr _39ea
        sta $bb
        lda $72
        eor $6c
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
        lda ($57), y
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
        lda ($5b), y
        sta $6b
        iny 
        lda ($5b), y
        sta $6d
        iny 
        lda ($5b), y
        sta $6f
        iny 
        lda ($5b), y
        sta $bb
        and # $1f
        cmp $ad
        bcc _9d8e
        iny 
        lda ($5b), y
        sta $2e
        and # $0f
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
        lda ($5b), y
        sta $2e
        and # $0f
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
        jmp _9f06

        ;-----------------------------------------------------------------------

_9d91:
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
        bmi _9db6
        clc 
        lda $71
        adc $09
        sta $6b
        lda $0a
        adc # $00
        sta $6c
        jmp _9dd9

_9db6:
        lda $09
        sec 
        sbc $71
        sta $6b
        lda $0a
        sbc # $00
        sta $6c
        bcs _9dd9
        eor # $ff
        sta $6c
        lda # $01
        sbc $6b
        sta $6b
        bcc _9dd3
        inc $6c
_9dd3:
        lda $6d
        eor # $80
        sta $6d
_9dd9:
        lda $0e
        sta $70
        eor $74
        bmi _9df1
        clc 
        lda $73
        adc $0c
        sta $6e
        lda $0d
        adc # $00
        sta $6f
        jmp _9e16

        ;-----------------------------------------------------------------------

_9df1:
        lda $0c
        sec 
        sbc $73
        sta $6e
        lda $0d
        sbc # $00
        sta $6f
        bcs _9e16
        eor # $ff
        sta $6f
        lda $6e
        eor # $ff
        adc # $01
        sta $6e
        lda $70
        eor # $80
        sta $70
        bcc _9e16
        inc $6f
_9e16:
        lda $76
        bmi _9e64
        lda $75
        clc 
        adc $0f
        sta $bb
        lda $10
        adc # $00
        sta $99
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
        lda $0f
        sec 
        sbc $75
        sta $bb
        lda $10
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
        ora $6c
        ora $6f
        beq _9e9a
        lsr $6c
        ror $6b
        lsr $6f
        ror $6e
        lsr $99
        ror $bb
        jmp _9e83

_9e9a:
        lda $bb
        sta $9a
        lda $6b
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
        txa 
        pha 
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
        and # $20
        beq _9f2a
        lda $28
        ora # $08
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
        lda ($57), y
        sta $ae
        ldy # $00
        sty $99
        sty $9f
        inc $99
        bit $28
        bvc _9f9f
        lda $28
        and # $bf
        sta $28
        ldy # $06
        lda ($57), y
        tay 
        ldx $0100, y
        stx $6b
        inx 
        beq _9f9f
        ldx $0101, y
        stx $6c
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
        lda $0f
        sta $71
        lda $0b
        bpl _9f82
        dec $6f
_9f82:
        jsr _a013
        bcs _9f9f
        ldy $99
        lda $6b
        sta ($2a), y
        iny 
        lda $6c
        sta ($2a), y
        iny 
        lda $6d
        sta ($2a), y
        iny 
        lda $6e
        sta ($2a), y
        iny 
        sty $99
_9f9f:
        ldy # $03
        clc 
        lda ($57), y
        adc $57
        sta $5b
        ldy # $10
        lda ($57), y
        adc $58
        sta $5c
        ldy # $05
        lda ($57), y
        sta $06
        ldy $9f
_9fb8:
        lda ($5b), y
        cmp $ad
        bcc _9fd6
        iny 
        lda ($5b), y
        iny 
        sta $2e
        and # $0f
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
        lda ($5b), y
        tax 
        iny 
        lda ($5b), y
        sta $9a
        lda $0101, x
        sta $6c
        lda $0100, x
        sta $6b
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
        lda $6c
        ora $6e
        bne _a04e
        lda # $8f
        cmp $6d
        bcc _a04e
        lda $a2
        bne _a04c
_a03c:
        lda $6d
        sta $6c
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
        lda $6c
        and $70
        bmi _a04a
        lda $6e
        and $72
        bmi _a04a
        ldx $6c
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
        tya 
        pha 
        lda $6f
        sec 
        sbc $6b
        sta $73
        lda $70
        sbc $6c
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
        lda $6c
        ora $6e
        bne _a13b
        lda $6d
        cmp # $90
        bcs _a13b
_a110:
        ldx $6b
        lda $6f
        sta $6b
        stx $6f
        lda $70
        ldx $6c
        stx $70
        sta $6c
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
        lda $6b
        sta ($2a), y
        iny 
        lda $6c
        sta ($2a), y
        iny 
        lda $6d
        sta ($2a), y
        iny 
        lda $6e
        sta ($2a), y
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
        sta ($2a), y
_a178:
        ldy # $00
        lda ($2a), y
        sta $ae
        cmp # $04
        bcc _a19e
        iny 
_a183:
        lda ($2a), y
        sta $6b
        iny 
        lda ($2a), y
        sta $6c
        iny 
        lda ($2a), y
        sta $6d
        iny 
        lda ($2a), y
        sta $6e
        jsr _ab91
        iny 
        cpy $ae
        bcc _a183
_a19e:
        rts 

;===============================================================================

_a19f:
        lda $6c
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
        sta $6b
        sta $6c
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
        stx $6b
        inx 
        stx $6c
_a1d5:
        lda $6e
        bpl _a1f3
        sta $9c
        lda $6d
        sta $9b
        jsr _a248
        txa 
        clc 
        adc $6b
        sta $6b
        tya 
        adc $6c
        sta $6c
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
        adc $6b
        sta $6b
        tya 
        adc $6c
        sta $6c
        lda # $8f
        sta $6d
        lda # $00
        sta $6e
_a218:
        rts 

;===============================================================================

_a219:
        lda $6b
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
        eor # $ff
        adc # $01
        tax 
        tya 
        eor # $ff
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
        eor # $ff
        adc # $00
        sta $9c
        pla 
_a29d:
        eor $74
        rts 

;===============================================================================

_a2a0:
        lda $28
        and # $a0
        bne _a2cb
        lda $a3
        eor $9d
        and # $0f
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
        lda $a3
        eor $9d
        and # $07
        bne _a2cb
_a2c8:
        jsr _32ad
_a2cb:
        jsr _b410
        lda $24
        asl 
        asl 
        sta $9a
        lda $13
        and # $7f
        jsr _39ea
        sta $9b
        lda $13
        ldx # $00
        jsr _a44a
        lda $15
        and # $7f
        jsr _39ea
        sta $9b
        lda $15
        ldx # $03
        jsr _a44a
        lda $17
        and # $7f
        jsr _39ea
        sta $9b
        lda $17
        ldx # $06
        jsr _a44a
        lda $24
        clc 
        adc $25
        bpl _a30d
        lda # $00
_a30d:
        ldy # $0f
        cmp ($57), y
        bcc _a315
        lda ($57), y
_a315:
        sta $24
        lda # $00
        sta $25
        ldx $68
        lda $09
        eor # $ff
        sta $2e
        lda $0a
        jsr _3a25
        sta $30
        lda $6a
        eor $0b
        ldx # $03
        jsr _a508
        sta $b5
        lda $2f
        sta $b3
        eor # $ff
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
        sta $11
        lda $2f
        sta $0f
        eor # $ff
        sta $2e
        lda $30
        sta $10
        jsr _3a27
        sta $30
        lda $b5
        sta $0e
        eor $94
        eor $11
        bpl _a37d
        lda $2f
        adc $b3
        sta $0c
        lda $30
        adc $b4
        sta $0d
        jmp _a39d

_a37d:
        lda $b3
        sbc $2f
        sta $0c
        lda $b4
        sbc $30
        sta $0d
        bcs _a39d
        lda # $01
        sbc $0c
        sta $0c
        lda # $00
        sbc $0d
        sta $0d
        lda $0e
        eor # $80
        sta $0e
_a39d:
        ldx $68
        lda $0c
        eor # $ff
        sta $2e
        lda $0d
        jsr _3a25
        sta $30
        lda $69
        eor $0e
        ldx # $00
        jsr _a508
        sta $0b
        lda $30
        sta $0a
        lda $2f
        sta $09
_a3bf:
        lda $96
        sta $9b
        lda # $80
        ldx # $06
        jsr _a44c
        lda $a5
        and # $81
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
        and # $80
        sta $b1
        lda $27
        and # $7f
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
        and # $80
        sta $b1
        lda $26
        and # $7f
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
        and # $a0
        bne _a443
        lda $28
        ora # $10
        sta $28
        jmp _b410

        ;-----------------------------------------------------------------------

_a443:
        lda $28
        and # $ef
        sta $28
        rts 

;===============================================================================

_a44a:
        and # $80
_a44c:
        asl 
        sta $9c
        lda # $00
        ror 
        sta $bb
        lsr $9c
        eor $0b, x
        bmi _a46f
        lda $9b
        adc $09, x
        sta $09, x
        lda $9c
        adc $0a, x
        sta $0a, x
        lda $0b, x
        adc # $00
        ora $bb
        sta $0b, x
        rts 

        ;-----------------------------------------------------------------------

_a46f:
        lda $09, x
        sec 
        sbc $9b
        sta $09, x
        lda $0a, x
        sbc $9c
        sta $0a, x
        lda $0b, x
        and # $7f
        sbc # $00
        ora # $80
        eor $bb
        sta $0b, x
        bcs _a4a0
        lda # $01
        sbc $09, x
        sta $09, x
        lda # $00
        sbc $0a, x
        sta $0a, x
        lda # $00
        sbc $0b, x
        and # $7f
        ora $bb
        sta $0b, x
_a4a0:
        rts 

;===============================================================================

_a4a1:
        lda $a6
        sta $9a
        ldx $0b, y
        stx $9b
        ldx $0c, y
        stx $9c
        ldx $09, y
        stx $2e
        lda $000a, y
        eor # $80
        jsr _3ace
        sta $000c, y
        stx $0b, y
        stx $2e
        ldx $09, y
        stx $9b
        ldx $0a, y
        stx $9c
        lda $000c, y
        jsr _3ace
        sta $000a, y
        stx $09, y
        stx $2e
        lda $63
        sta $9a
        ldx $0b, y
        stx $9b
        ldx $0c, y
        stx $9c
        ldx $0d, y
        stx $2e
        lda $000e, y
        eor # $80
        jsr _3ace
        sta $000c, y
        stx $0b, y
        stx $2e
        ldx $0d, y
        stx $9b
        ldx $0e, y
        stx $9c
        lda $000c, y
        jsr _3ace
        sta $000e, y
        stx $0d, y
        rts 

;===============================================================================

_a508:
        tay 
        eor $0b, x
        bmi _a51c
        lda $2f
        clc 
        adc $09, x
        sta $2f
        lda $30
        adc $0a, x
        sta $30
        tya 
        rts 
        
        ;-----------------------------------------------------------------------

_a51c:
        lda $09, x
        sec 
        sbc $2f
        sta $2f
        lda $0a, x
        sbc $30
        sta $30
        bcc _a52f
        tya 
        eor # $80
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
        eor # $80
        sta $9a
        lda $09
        sta $2e
        lda $0a
        sta $2f
        lda $0b
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
        sta $0f
        lda $79
        sta $2f
        sta $10
        lda $7a
        sta $11
        eor # $80
        jsr _38f8
        lda $7a
        and # $80
        sta $bb
        eor $b5
        bmi _a5a8
        lda $77
        clc 
        adc $b2
        lda $78
        adc $b3
        sta $0c
        lda $79
        adc $b4
        sta $0d
        lda $7a
        adc $b5
        jmp _a5db

_a5a8:
        lda $77
        sec 
        sbc $b2
        lda $78
        sbc $b3
        sta $0c
        lda $79
        sbc $b4
        sta $0d
        lda $b5
        and # $7f
        sta $2e
        lda $7a
        and # $7f
        sbc $2e
        sta $2e
        bcs _a5db
        lda # $01
        sbc $0c
        sta $0c
        lda # $00
        sbc $0d
        sta $0d
        lda # $00
        sbc $2e
        ora # $80
_a5db:
        eor $bb
        sta $0e
        lda $a6
        sta $9a
        lda $0c
        sta $2e
        lda $0d
        sta $2f
        lda $0e
        jsr _38f8
        ldx # $00
        jsr _2d69
        lda $78
        sta $09
        lda $79
        sta $0a
        lda $7a
        sta $0b
        jmp _a3bf

;===============================================================================

; what calls in to this, where?

_a604:
        sec 
        ldy # $00
        sty $5b
        ldx # $10
        lda ($07), y
        txa 
_a60e:
        stx $5c
        sty $bb
        adc ($5b), y
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
        ldx $0486
        beq _a65e
        dex 
        bne _a65f
        lda $0b
        eor # $80
        sta $0b
        lda $11
        eor # $80
        sta $11
        lda $13
        eor # $80
        sta $13
        lda $17
        eor # $80
        sta $17
        lda $19
        eor # $80
        sta $19
        lda $1d
        eor # $80
        sta $1d
        lda $1f
        eor # $80
        sta $1f
        lda $23
        eor # $80
        sta $23
_a65e:
        rts 

        ;-----------------------------------------------------------------------

_a65f:
        lda # $00
        cpx # $02
        ror 
        sta $b1
        eor # $80
        sta $b0
        lda $09
        ldx $0f
        sta $0f
        stx $09
        lda $0a
        ldx $10
        sta $10
        stx $0a
        lda $0b
        eor $b0
        tax 
        lda $11
        eor $b1
        sta $0b
        stx $11
        ldy # $09
        jsr _a693
        ldy # $0f
        jsr _a693
        ldy # $15
_a693:
        lda $0009, y
        ldx $0d, y
        sta $000d, y
        stx $09, y
        lda $000a, y
        eor $b0
        tax 
        lda $000e, y
        eor $b1
        sta $000a, y
        stx $0e, y
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
        jsr _2a12
        jsr _7b1a
_a6d4:
        lda # MEM_IO_ONLY  ;=5
        jsr _827f
        ldy $0486
        lda $04a9, y
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
        sta $d027               ;sprite 0 color
        lda # $01
_a700:
        sta $bb
        lda $04ca
        and # $7f
        lsr 
        lsr 
        lsr 
        lsr 
        tax 
        lda _a71f, x
        sta $0510
        lda _a727, x
        ora $bb
        sta $d015               ;sprite display enable
        lda # MEM_64K           ;=4
        jmp _827f

;===============================================================================

_a71f:
        .byte   $00, $01, $02, $03, $04, $05, $06, $06
_a727:
        .byte   $00, $04, $0c, $1c, $3c, $7c, $fc, $fc

;===============================================================================

_a72f:
        sta $a0
_a731:
        jsr _246d
        lda # $00
        sta $7e
        lda # $80
        sta $34
        sta _2f19
        jsr _7b4f
        lda # $00
        sta $0484
        sta $048b
        sta $048c
        lda # $01
        sta $31
        sta $33
        jsr _b21a
        ldx $66
        beq _a75d
        jsr _7224
_a75d:
        lda # $01
        jsr _6a28
        lda $a0
        bne _a77b
        lda # $0b
        jsr _6a25
        lda $0486
        ora # $60
        jsr _777e
        jsr _72c5
        lda # $af
        jsr _777e
_a77b:
        ldx # $01
        stx $31
        stx $33
        dex 
        stx $34
        rts 

;===============================================================================

_a785:
        rts 

_a786:
        lda # $00
        sta $67
        sta $0481
        jsr _b0fd
        ldy # $09
        jmp _a822

;===============================================================================

_a795:
        ldx # $01
        jsr _3708
        bcc _a785
        lda # $78
        jsr _900d
        ldy # $04
        jmp _a857+1

;===============================================================================

_a7a6:
        lda $04cb
        clc 
        adc $d062, x
        sta $04cb
        lda $04e0
        adc $d083, x
        sta $04e0
        bcc _a7c3
        inc $04e1
        lda # $65
        jsr _900d
_a7c3:
        lda $10
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
        ora # $03
        ldy # $03
        ldx # $51
        jmp _a850

;===============================================================================

_a7e9:
        lda $10
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
        ora # $03
        ldy # $02
        ldx # $d0
        jmp _a850

;===============================================================================

_a80f:
        ldy # $05
        bne _a857+1
_a813:
        ldy # $03
        bne _a857+1
_a817:
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
        and # $3f
        cmp $6d
        bne _a827
        lda # $01
        sta _aa16, x
        rts 

;===============================================================================

_a839:
        ldy # $07
        lda # $f5
        ldx # $f0
        jsr _a850
        ldy # $04
        jsr _a857+1
        ldy # $01
        jsr _3ea1
        ldy # $87
        bne _a857+1
_a850:
        bit _a821
        sta $6b
        stx $6c
_a857:  ; NOTE: when accessed as $A858, this becomes `clv` (clear overlow)
        .byte   $50, $b8        ;=`bvc $a811`
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
        and # $3f
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
        and # $7f
        tay 
        lda _aa32, y
        cmp _aa19, x
        bcc _a821
        sei 
        sta _aa19, x
        bvs _a8a0+1
        lda _aa82, y
_a8a0:  ; NOTE: when accessed as $A8A1, this becomes `lda $6b`
        cmp $6ba5
        sta _aa29, x
        lda _aa42, y
        sta _aa16, x
        lda _aa92, y
        sta _aa1d, x
        lda _aa62, y
        sta _aa23, x
        bvs _a8bd+1
        lda _aa52, y
_a8bd:  ; NOTE: when accessed as $A8BE, this becomes `lda $6c`
        cmp $6ca5
        sta _aa20, x
        lda _aa72, y
        sta _aa26, x
        lda _aaa2, y
        sta _aa2c, x
        iny 
        tya 
        ora # $80
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
        .byte   $c0
_a8e1:
        .byte   $c0
_a8e2:
        .byte   $fe, $fc
_a8e4:
        .byte   $02, $00
_a8e6:
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
        lda CPU_CONTROL         ; [$01]
        and # $f8
        ora _828e
        sta CPU_CONTROL         ; [$01]
        pla 
        rti 

        ;-----------------------------------------------------------------------

_a8fa:
        pha 
        
        lda CPU_CONTROL
        and # $f8
        ora # $05
        sta CPU_CONTROL

        lda $d019               ;vic interrupt request register (irr)
        ora # $80
        sta $d019               ;vic interrupt request register (irr)
        
        txa 
        pha 
        
        ldx _a8d9

        lda _a8da, x
        sta VIC_MEMORY          ;=$d018, VIC-II memory control register

        lda _a8e0, x
        sta $d016               ;vic control register 2

        lda _a8de, x
        sta $d012               ;raster position
        
        lda _a8e2, x
        sta $d01c               ;sprites multi-color mode select
        
        lda _a8e4, x
        sta $d028               ;sprite 1 color
        
        bit $04c3
        bpl :+
        inc _a8e6
:       lda _a8e6, x                                                    ;$A936
        sta $d021               ;background color 0

        lda _a8dc, x
        sta _a8d9
        bne _a8ed
        tya 
        pha 
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
        and # $fe
        sta $d404, x            ;voice 1: control register
        lda # $00
        sta _aa13, y
        sta _aa19, y
        beq _a9f6
_a9f1:
        and # $7f
        sta _aa13, y
_a9f6:
        dey 
        bmi _a9fc
        jmp _a958

_a9fc:
        lda _aa1c
        eor # $04
        sta _aa1c
_aa04:
        pla 
        tay 
        pla 
        tax 

        lda CPU_CONTROL
        and # $f8
        ora _828e
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

;===============================================================================

; CALL FROM LOADER

_aab2:
        ; erase $0400..$0700
        lda #> $0400
        sta $08
        ldx # $03               ; number of pages; 3 x 256 = 768 bytes
        lda #< $0400            ; address must be page aligned for A to be $00 
        sta $07
        tay                     ; =0

:       sta ($07), y                                                    ;$aabd
        iny 
        bne :-

        inc $08                 ; move to the next page
        dex 
        bne :-

        ;-----------------------------------------------------------------------

        ; set non-maskable interrupt location

        lda #< _ab27
        sta $0318               ;nmi
        lda #> _ab27
        sta $0319               ;nmi
        
        ; set new KERNAL_CHROUT (print character) routine

        lda #< _b155
        sta $0326
        lda #> _b155
        sta $0327

        lda # MEM_IO_ONLY       ;=5
        jsr _827f

        sei 
        lda # $03
        sta $dc0d               ;cia1: cia interrupt control register
        sta $dd0d               ;cia2: cia interrupt control register
        lda # $0f
        sta $d418               ;select filter mode and volume
        ldx # $00
        stx _a8d9
        inx 
        stx $d01a               ;vic interrupt mask register (imr)
        lda $d011               ;vic control register 1
        and # $7f
        sta $d011               ;vic control register 1
        lda # $28
        sta $d012               ;raster position
        lda CPU_CONTROL
        and # $f8
        ora # $04
        sta CPU_CONTROL
        lda # $04
        sta _828e
        lda #< _ab27
        sta $fffa               ;nmi
        lda #> _ab27
        sta $fffb               ;nmi
        lda #>_a8fa
        sta $ffff               ;irq
        lda #<_a8fa
        sta $fffe               ;irq
        
        cli 
        rts 

;===============================================================================

_ab27:
        cli 
        rti 

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
        .byte   $80, $40, $20, $10, $08, $04, $02, $01
        .byte   $80, $40, $c0, $30, $0c, $03, $c0, $c0
        .byte   $60, $30, $18, $0c, $06, $03
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
        sty $9e
        lda # $80
        sta $bf
        asl 
        sta $06f4
        lda $6d
        sbc $6b
        bcs _aba5
        eor # $ff
        adc # $01
_aba5:
        sta $bc
        sec 
        lda $6e
        sbc $6c
        bcs _abb2
        eor # $ff
        adc # $01
_abb2:
        sta $bd
        cmp $bc
        bcc _abbb
        jmp _af08

_abbb:
        ldx $6b
        cpx $6d
        bcc _abd3
        dec $06f4
        lda $6d
        sta $6b
        stx $6d
        tax 
        lda $6e
        ldy $6c
        sta $6c
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
        ldy $6c
        cpy $6e
        bcs _ac19
        jmp _ad8b

        ;-----------------------------------------------------------------------

_ac19:
        lda $6b
        and # $f8
        clc 
        adc _9700, y
        sta $07
        lda _9800, y
        adc # $00
        sta $08
        tya 
        and # $07
        tay 
        lda $6b
        and # $07
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
        lda # $80
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        lda _9800, y
        sta $08
        lda $6b
        and # $f8
        adc _9700, y
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
        and # $07
        eor # $f8
        tay 
        lda $6b
        and # $07
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        ldy $6c
        tya 
        ldx $6b
        cpy $6e
        bcs _af22
        dec $06f4
        lda $6d
        sta $6b
        stx $6d
        tax 
        lda $6e
        sta $6c
        sty $6e
        tay 
_af22:
        txa 
        and # $f8
        clc 
        adc _9700, y
        sta $07
        lda _9800, y
        adc # $00
        sta $08
        tya 
        and # $07
        tay 
        txa 
        and # $07
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
        sbc $6b
        bcc _afbe
        clc 
        lda $06f4
        beq _af8e
        dex 
_af88:
        lda $be
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        sty $9e
        ldx $6b
        cpx $6d
        beq _aff9
        bcc _b00b
        lda $6d
        sta $6b
        stx $6d
        tax 
_b00b:
        dec $6d
        lda $6c
        tay 
        and # $07
        sta $07
        lda _9800, y
        sta $08
        txa 
        and # $f8
        clc 
        adc _9700, y
        tay 
        bcc _b025
        inc $08
_b025:
        txa 
        and # $f8
        sta $c0
        lda $6d
        and # $f8
        sec 
        sbc $c0
        beq _b073
        lsr 
        lsr 
        lsr 
        sta $be
        lda $6b
        and # $07
        tax 
        lda _2907, x
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
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
        and # $07
        tax 
        lda _2900, x
        eor ($07), y
        sta ($07), y
        ldy $9e
        rts 

        ;-----------------------------------------------------------------------

_b073:
        lda $6b
        and # $07
        tax 
        lda _2907, x
        sta $c0
        lda $6d
        and # $07
        tax 
        lda _2900, x
        and $c0
        eor ($07), y
        sta ($07), y
        ldy $9e
        rts 

;===============================================================================

; unused / unreferenced?
;$b08e:
        .byte   $80, $c0, $e0, $f0, $f8, $fc, $fe, $ff
        .byte   $7f, $3f, $1f, $0f, $07, $03, $01

;===============================================================================

_b09d:
        lda $04eb
        sta $6c
        lda $04ea
        sta $6b
        lda _1d01
        sta $32
        cmp # $aa
        bne _b0b5
_b0b0:
        jsr _b0b5
        dec $6c
_b0b5:
        ldy $6c
        lda $6b
        and # $f8
        clc 
        adc _9700, y
        sta $07
        lda _9800, y
        adc # $00
        sta $08
        tya 
        and # $07
        tay 
        lda $6b
        and # $07
        tax 
        lda _ab47, x
        and $32
        eor ($07), y
        sta ($07), y
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
        eor ($07), y
        sta ($07), y
        rts 

;===============================================================================

_b0f4:
        lda # $20
        sta $67
        ldy # $09
        jsr _a857+1
_b0fd:
        lda $67a3               ;?
        eor # $e0
        sta $67a3               ;?
        lda $67cb
        eor # $e0
        sta $67cb
        rts 

;===============================================================================

_b10e:
        lda $67b4
        eor # $e0
        sta $67b4
        lda $67dc
        eor # $e0
        sta $67dc
        rts 

;===============================================================================

_b11f:
        dex 
        txa 
        inx 
        eor # $03
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

;===============================================================================

_b148:
        pha 
_b149:
        lda _a8d9
        beq _b149
_b14e:
        lda _a8d9
        bne _b14e
        pla 
        rts 

;===============================================================================

_b155:
        cmp # $7b
        bcs _b166
        cmp # $0d
        bcc _b166
        bne _b17b
        lda # $0c
        jsr _b17b
        lda # $0d
_b166:
        clc 
        rts 

;===============================================================================

_b168:
        jsr _a80f
        jmp _b210

        ;-----------------------------------------------------------------------

_b16e:
        jsr _b384
        lda $35
        jmp _b189

        ;-----------------------------------------------------------------------

_b176:
        jmp _b210

        ;-----------------------------------------------------------------------

_b179:
        lda # $0c
_b17b:
        sta $35
        sty $0490
        stx $048f
        ldy $34
        cpy # $ff
        beq _b176
_b189:
        cmp # $07
        beq _b168
        cmp # $20
        bcs _b1a1
        cmp # $0a
        beq _b199
_b195:
        ldx # $01
        stx $31
_b199:
        cmp # $0d
        beq _b176
        inc $33
        bne _b176
_b1a1:
        tay 
        ldx # $0a
        asl 
        asl 
        bcc _b1aa
        ldx # $0c
_b1aa:
        asl 
        bcc _b1ae
        inx 
_b1ae:
        sta $2f
        stx $30
        lda $31
        cmp # $1f
        bcs _b195
        lda # $80
        sta $07
        lda $33
        cmp # $18
        bcc _b1c5
        jmp _b16e

        ;-----------------------------------------------------------------------

_b1c5:
        lsr 
        ror $07
        lsr 
        ror $07
        adc $33
        adc # $40
        sta $08
        lda $31
        asl 
        asl 
        asl 
        adc $07
        sta $07
        bcc _b1de
        inc $08
_b1de:
        cpy # $7f
        bne _b1ed
        dec $31
        dec $08
        ldy # $f8
        jsr _b3b5
        beq _b210
_b1ed:
        inc $31
        bit $0885
        ldy # $07
_b1f4:
        lda ($2f), y
        eor ($07), y
        sta ($07), y
        dey 
        bpl _b1f4
        ldy $33
        lda _9900, y
        sta $07
        lda _9919, y
        sta $08
        ldy $31
        lda $050c
        sta ($07), y
_b210:
        ldy $0490
        ldx $048f
        lda $35
        clc 
        rts 

;===============================================================================

_b21a:
        lda #< $6004
        sta $07
        lda #> $6004
        sta $08
        ldx # $18
_b224:
        lda # $10
        ldy # $1f
_b228:
        sta ($07), y
        dey 
        bpl _b228
        lda $07
        clc 
        adc # $28
        sta $07
        bcc _b238
        inc $08
_b238:
        dex 
        bne _b224
        ldx # $40
_b23d:
        jsr _b3a7
        inx 
        cpx # $56
        bne _b23d
        ldy # $7f
        jsr _b3ab
        sta ($07), y
        lda # $01
        sta $31
        sta $33
        lda $a0
        beq _b25a
        cmp # $0d
        bne _b25d
_b25a:
        jmp _b301

        ;-----------------------------------------------------------------------

_b25d:
        lda # $81
        sta _a8db
        lda # $c0
        sta _a8e1
_b267:
        jsr _b3a7
        inx 
        cpx # $60
        bne _b267
        ldx # $00
        stx _1d01
        stx _1d04
        inx 
        stx $31
        stx $33
        jsr _b359
        jsr _b341
        jsr _8273
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
_b2b1:
        bit $12a2               ;? -- supposed to jump into +1; "$a2 $12"
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
        stx $6c
        ldx # $00
        stx $6b
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
        eor ($07), y
        sta ($07), y
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
        jsr _b2b1+1
        lda # $91
        sta _a8db
        lda # $d0
        sta _a8e1
        lda _1d04
        bne _b335
        ldx # $08
        lda #< $ef90            ;?
        sta $5b
        lda #> $ef90            ;?
        sta $5c
        lda #< $5680
        sta $07
        lda #> $5680
        sta $08
        jsr _b3c3
        ldy # $c0
        ldx # $01
        jsr _b3c5
        jsr _b341
        jsr _2ff3
_b335:
        jsr _b359
        jsr _8273
        lda # $ff
        sta _1d04
        rts 

;===============================================================================

_b341:
        ldx # $00
_b343:
        lda $0452, x
        beq _b358
        bmi _b355
        jsr _3e87
        ldy # $1f
        lda ($59), y
        and # $ef
        sta ($59), y
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
        sta ($07), y
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
        lda _9700, x
        sta $07
        lda _9800, x
        sta $08
        tya 
_b394:
        sta ($07), y
        dey 
        bne _b394
        txa 
        adc # $08
        tax 
        cmp # $c0
        bcc _b389
        iny 
        sty $31
        sty $33
        rts 

;===============================================================================

_b3a7:
        ldy # $00
        sty $07
_b3ab:
        lda # $00
        stx $08
_b3af:
        sta ($07), y
        dey 
        bne _b3af
        rts

;===============================================================================

_b3b5:
        lda # $00
_b3b7:
        sta ($07), y
        iny 
        bne _b3b7
        rts 

;===============================================================================

; unreferenced / unused?
;$b3bd:
        sta $31
        rts 

;===============================================================================

_b3c0:
        sta $33
        rts 

;===============================================================================

_b3c3:
        ldy # $00
_b3c5:
        lda ($5b), y
        sta ($07), y
        dey 
        bne _b3c5
        inc $5c
        inc $08
        dex 
        bne _b3c5
        rts 

;===============================================================================

_b3d4:
        lda # $00
        sta $048b
        sta $048c
        lda # $ff
        sta _2f19
        lda #> _8015
        sta $34
        lda #< _8015
        sta $33
        lda # $01
        sta $31
        lda #> $5a60
        sta $08
        lda #< $5a60
        sta $07
        ldx # $03
_b3f7:
        lda # $00
        tay 
_b3fa:
        sta ($07), y
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
        lda $a0
        bne _b40f
        lda $28
        and # $10
        beq _b40f
        ldx $a5
        bmi _b40f
        lda _267e, x
        sta $32
        lda $0a
        ora $0d
        ora $10
        and # $c0
        bne _b40f
        lda $0a
        clc 
        ldx $0b
        bpl _b438
        eor # $ff
        adc # $01
_b438:
        adc # $7b
        sta $6b
        lda $10
        lsr 
        lsr 
        clc 
        ldx $11
        bpl _b448
        eor # $ff
        sec 
_b448:
        adc # $53
        eor # $ff
        sta $07
        lda $0d
        lsr 
        clc 
        ldx $0e
        bmi _b459
        eor # $ff
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
        sta $6c
        sec 
        sbc $07
        php 
        pha 
        jsr _b0b0
        lda _ab49, x
        and $32
        sta $6b
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
        lda $6b
        eor ($07), y
        sta ($07), y
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
        lda $6b
        eor ($07), y
        sta ($07), y
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
        and # $0f
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
        lda ($c2), y
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

;===============================================================================

; fill data, not encrypted

        .byte   $ff, $00, $ff, $00, $ff, $00, $ff, $00                  ;$ccd7
        .byte   $ff, $ff                                                ;$ccdf

;$cce1