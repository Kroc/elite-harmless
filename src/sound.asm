; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.include        "c64/c64.inc"

.export sound_play_addr_lo:absolute
.export sound_play_addr_hi:absolute
.export _b4d2:absolute
.export sound_stop:absolute
.export _b72d:absolute
.export _c164:absolute

ZP_SOUND_ADDR           = $c2
ZP_SOUND_ADDR_LO        = $c2
ZP_SOUND_ADDR_HI        = $c3

ZP_SOUND_START          = $c4
ZP_SOUND_START_LO       = $c4
ZP_SOUND_START_HI       = $c5

;                       = $c6   ;?
;                       = $c7   ;?
;                       = $c8   ;?
;                       = $c9   ;?
;                       = $ca   ;?
;                       = $cb   ;?
;                       = $cc   ;?

ZP_SOUND_TOKEN          = $d1

.segment        "CODE_SOUND"

_b4cb:                                                                  ;$B4CB
        .byte   $00
voice1_ctrl:    .byte   $00                                             ;$B4CC
voice2_ctrl:    .byte   $00                                             ;$B4CD
voice3_ctrl:    .byte   $00                                             ;$B4CE
_b4cf:                                                                  ;$B4CF
        .byte   $00

; address of sound data to play
;
sound_play_addr:
sound_play_addr_lo:                                                     ;$B4D0
        .byte   $88
sound_play_addr_hi:                                                     ;$B4D1
        .byte   $88

_b4d2:                                                                  ;$B4D2
;===============================================================================
        ldy # $00
        cpy $c6                 
       .bze _b4dd
        
        dec $c6                 
        jmp _b6e2               

_b4dd:                                                                  ;$B4DD
        ;-----------------------------------------------------------------------
        ; data bytes can contain 1 or 2 tokens (a nybble each)
        ;
        lda ZP_SOUND_TOKEN      ; current data byte
        cmp # %00010000         ; is there an upper token?
       .bge @lower              ; yes, extract it
        tax                     ; no, take token as is
       .bnz @upper              ; handle any non-zero token

        ; a zero token does nothing,
        ; move on to the next data byte
        ;
        jsr next_byte           ; read byte from the data-stream
        sta ZP_SOUND_TOKEN      ; store unmodified

@lower: and # %00001111         ; take the lower nybble token           ;$B4EB
        tax 

@upper: ; downshift the byte to access the                              ;$B4EE
        ; token in the upper nybble
        ;
        lda ZP_SOUND_TOKEN      ; get back the byte unmodified
        lsr 
        lsr 
        lsr 
        lsr 
        sta ZP_SOUND_TOKEN

        ; get the address of the token's
        ; function and jump to it
        ;
        lda _b70f-1, x          ; load token function address, lo
        sta _b502+1             ; modify the `jmp` below, lo
        lda _b71e-1, x          ; load token function address, hi
        sta _b502+2             ; modify the `jmp` below, hi

_b502:  jmp _b4dd                                                       ;$B502

_b505:                                                                  ;$B505
;===============================================================================
        jsr get_voice1_freq
        jsr set_voice1_ctrl

        jmp _b4dd


_b50e:                                                                  ;$B50E
;===============================================================================
        jsr get_voice2_freq
        jsr set_voice2_ctrl

        jmp _b4dd

_b517:                                                                  ;$B517
;===============================================================================
        jsr get_voice3_freq
        jsr set_voice3_ctrl
        
        jmp _b4dd

;===============================================================================

_b520:                                                                  ;$B520
        jsr get_voice1_freq
        jsr get_voice2_freq
        jsr set_voice1_ctrl
        jsr set_voice2_ctrl
        
        jmp _b4dd

_b52f:                                                                  ;$B52F
;===============================================================================
        jsr get_voice1_freq
        jsr get_voice2_freq
        jsr get_voice3_freq
        jsr set_voice1_ctrl
        jsr set_voice2_ctrl
        jsr set_voice3_ctrl
        
        jmp _b4dd

_b544:                                                                  ;$B544
;===============================================================================
        inc _b4cb
        
        jmp _b4dd

_b54a:                                                                  ;$B54A
;===============================================================================
; shifts the token up into the high nybble and replaces the low nybble with
; token `%1000`. e.g.
;
;       0000_0101 -> 0000_1011 -> 0001_0110 -> 0010_1100 -> 0101_1000
;
        lda ZP_SOUND_TOKEN
        sec                     ; set carry
        rol                     ; insert carry into bit 0
        asl                     ; shift left (inserting 0 into bit 0)
        asl                     ; again
        asl                     ; now with feeling
        sta ZP_SOUND_TOKEN
_b553:                                                                  ;$B653
        ;-----------------------------------------------------------------------
        lda _b4cf
        sta $c6

        jmp _b4d2

token_adsr:                                                             ;$B55B
;===============================================================================
        jsr next_byte
        sta SID_VOICE1_ATKDCY
        jsr next_byte
        sta SID_VOICE2_ATKDCY
        jsr next_byte
        sta SID_VOICE3_ATKDCY
        jsr next_byte
        sta SID_VOICE1_SUSREL
        jsr next_byte
        sta SID_VOICE2_SUSREL
        jsr next_byte
        sta SID_VOICE3_SUSREL
        
        jmp _b4dd

token_loop:                                                             ;$B582
;===============================================================================
        ; clear current token(s);
        ; another will be read automatically
        lda # %00000000
        sta ZP_SOUND_TOKEN

        ; loop the sound
        lda ZP_SOUND_START_LO
        sta ZP_SOUND_ADDR_LO
        lda ZP_SOUND_START_HI
        sta ZP_SOUND_ADDR_HI
        
        jmp _b4dd

token_pulse:                                                            ;$B591
;===============================================================================
        jsr next_byte
        sta SID_VOICE1_PULSE_LO
        jsr next_byte
        sta SID_VOICE1_PULSE_HI
        jsr next_byte
        sta SID_VOICE2_PULSE_LO
        jsr next_byte
        sta SID_VOICE2_PULSE_HI
        jsr next_byte
        sta SID_VOICE3_PULSE_LO
        jsr next_byte
        sta SID_VOICE3_PULSE_HI

        jmp _b4dd

token_lxxp:                                                             ;$B5B8
;===============================================================================
        jmp token_loop

_b5bb:                                                                  ;$B5BB
;===============================================================================
        jsr next_byte
        sta _b4cf
        
        jmp _b4dd

token_control:                                                          ;$B5C4
;===============================================================================
        jsr next_byte
        sta voice1_ctrl
        jsr next_byte
        sta voice2_ctrl
        jsr next_byte
        sta voice3_ctrl

        jmp _b4dd

token_volume_filter:                                                    ;$B5D9
;===============================================================================
        jsr next_byte
        sta SID_VOLUME_CTRL
        jsr next_byte
        sta SID_FILTER_CTRL
        jsr next_byte
        sta SID_FILTER_FREQ_HI

        jmp _b4dd

set_voice1_ctrl:                                                        ;$B5EE
;===============================================================================
        lda voice1_ctrl
        sty SID_VOICE1_CTRL
        sta SID_VOICE1_CTRL
        
        rts 

set_voice2_ctrl:                                                        ;$B5F8
;===============================================================================
        lda voice2_ctrl
        sty SID_VOICE2_CTRL
        sta SID_VOICE2_CTRL
        
        rts 

set_voice3_ctrl:                                                        ;$B602
;===============================================================================
        lda voice3_ctrl
        sty SID_VOICE3_CTRL
        sta SID_VOICE3_CTRL
        
        rts 

next_byte:                                                              ;$B60C
;===============================================================================
        inc ZP_SOUND_ADDR_LO
        bne :+
        inc ZP_SOUND_ADDR_HI
:       lda [ZP_SOUND_ADDR], y                                          ;$B612
        
        rts 

get_voice1_freq:                                                        ;$B615
;===============================================================================
        jsr next_byte
        sta SID_VOICE1_FREQ_HI
        jsr next_byte
        sta SID_VOICE1_FREQ_LO
        
        rts 

get_voice2_freq:                                                        ;$B622
;===============================================================================
        jsr next_byte
        sta SID_VOICE2_FREQ_HI
        sta $c9
        sta $cb
        
        jsr next_byte
        sta SID_VOICE2_FREQ_LO
        sta $ca
        sta $cc
        
        clc 
        cld 
        lda # $20
        adc $cc
        sta $cc
        bcc :+
        inc $cb

:       rts                                                             ;$B642

get_voice3_freq:                                                        ;$B643
;===============================================================================
        jsr next_byte
        sta SID_VOICE3_FREQ_HI
        sta $cd
        sta $cf

        jsr next_byte
        sta SID_VOICE3_FREQ_LO
        sta $ce
        sta $d0
        
        clc 
        cld 
        lda # $25
        adc $d0
        sta $d0
        bcc :+
        inc $cf

:       rts                                                             ;$B663

sound_stop:                                                             ;$B664
;===============================================================================
        ; clear current token(s);
        ; another will be read automatically
        lda # %00000000
        sta ZP_SOUND_TOKEN
        sta $c6
        sta $c7
        sta $c8

        ; clear the SID registers
        ; (working down from $D418 to $D400)
        ldx # (SID_VOLUME_CTRL - SID_REGISTERS)
:       sta SID_REGISTERS, x                                            ;$B670
        dex 
        bne :-
        
        ; reset the starting & looping play addresses:

        lda sound_play_addr_lo
        sta ZP_SOUND_ADDR_LO
        sta ZP_SOUND_START_LO
        
        lda sound_play_addr_hi
        sta ZP_SOUND_ADDR_HI
        sta ZP_SOUND_START_HI
        
        ; set default volume
        lda # 15
        sta SID_VOLUME_CTRL
        
        rts 

;$b68a:
;===============================================================================
        lda # $00
        sta $c7
        
        lda #< _b6ae
        sta _b6f0+1
        
        lda $cb
        sta SID_VOICE2_FREQ_HI
_b698:                                                                  ;$B698
        lda $cc
        sta SID_VOICE2_FREQ_LO
        
        jmp _b6f2

_b6a0:                                                                  ;$B6A0
;===============================================================================
        lda # $00
        sta $c7

        lda #< _b698
        sta _b6f0+1
        
        lda $c9
        sta SID_VOICE2_FREQ_HI
_b6ae:                                                                  ;$B6AE
        lda $ca
        sta SID_VOICE2_FREQ_LO

        jmp _b6f2

        ;-----------------------------------------------------------------------

;$b6b6:
        lda # $00
        sta $c8

        lda #< _b6e2
        sta _b6e8+1
        
        lda $cf
        sta SID_VOICE3_FREQ_HI
        lda $d0
        sta SID_VOICE3_FREQ_LO
        
        jmp _b6f2

        ;-----------------------------------------------------------------------

_b6cc:                                                                  ;$B6CC
        lda # $00
        sta $c8

        lda #< _b6cc
        sta _b6e8+1
        
        lda $cd
        sta SID_VOICE3_FREQ_HI
        lda $ce
        sta SID_VOICE3_FREQ_LO

        jmp _b6f2

_b6e2:                                                                  ;$B6E2
;===============================================================================
        inc $c8
        lda # 5
        cmp $c8
_b6e8:                                                                  ;$B6E8
        beq _b6cc
        inc $c7
        lda # $04
        cmp $c7
_b6f0:                                                                  ;$B6F0
        beq _b6a0
_b6f2:                                                                  ;$B6F2
        ldx $c6
        cpx # $00
       .bnz :+

        ; fade volume?

        ldx voice1_ctrl
        dex 
        stx SID_VOICE1_CTRL
        
        ldx voice2_ctrl
        dex 
        stx SID_VOICE2_CTRL
        
        ldx voice3_ctrl
        dex 
        stx SID_VOICE3_CTRL

:       rts                                                             ;$B70D

;-------------------------------------------------------------------------------

.ifdef  OPTION_ORIGINAL
        rts 
.endif

.define _addrs  _b505, \
                _b50e, \
                _b517, \
                _b520, \
                _b52f, \
                _b544, \
                token_adsr, \
                _b553, \
                token_loop, \
                token_pulse, \
                token_lxxp, \
                _b5bb, \
                token_control, \
                token_volume_filter, \
                _b54a

B505            = %0001         ;? "voice 1 freq". reads 2 bytes
B50E            = %0010         ;? "voice 2 freq". reads 2 bytes
B517            = %0011         ;? "voice 3 freq". reads 2 bytes
B520            = %0100         ;? "voice 1 & 2 freq". reads 4 bytes
B52F            = %0101         ;? "voice 1, 2 & 3 freq". reads 6 bytes
B544            = %0110         ;?
ADSR            = %0111         ; set ADSR for all voices. reads 6 bytes
B553            = %1000         ;? does not read
LOOP            = %1001         ; return to set loop-point
PLSE            = %1010         ; set pulse modulation for voices. 6 bytes
LXXP            = %1011         ; same as LOOP (removed code?)
B5BB            = %1100         ; sets `_b4cf`. reads 1 byte
CTRL            = %1101         ; control codes for voices, 3 bytes
VOLF            = %1110         ; set volume, filter and filter-freq. 3 bytes
B54A            = %1111         ;? does not read

B553_B517       = B553 | (B517 << 4)    ;=$38
B5BB_B52F       = B5BB | (B52F << 4)    ;=$5C
B54A_B52F       = B54A | (B52F << 4)    ;=$5F
ADSR_PLSE       = ADSR | (PLSE << 4)    ;=$A7
CTRL_VOLF       = CTRL | (VOLF << 4)    ;=$ED

_b70f:  .lobytes _addrs                                                 ;$B70F        
_b71e:  .hibytes _addrs                                                 ;$B71E

;===============================================================================

.segment        "DATA_SOUND"

_b72d:                                                                  ;$B72D
        .byte   ADSR_PLSE
        .byte   $26, $26, $48, $29, $29, $aa
        .byte   $00, $06, $00, $05, $00, $06

        .byte   CTRL_VOLF
        .byte   $21, $21, $41
        .byte   $1f, $f4, $70
        
        .byte   B5BB_B52F
        .byte   $07
        .byte   $0e, $ef, $12, $d1, $1d, $df

        .byte   B54A_B52F
        .byte   $0e, $ef, $12, $d1, $1d, $df
        
        .byte   B553_B517
        .byte   $1c, $31
        
        .byte   $58, $0e                                 ;$B74D
        .byte   $ef, $1a, $9c, $1d, $df, $5f, $0e, $ef                  ;$B755
        .byte   $13, $ef, $21, $87, $5f, $0e, $ef, $13                  ;$B75D
        .byte   $ef, $21, $87, $38, $1f, $a5, $58, $0e                  ;$B765
        .byte   $ef, $19, $1e, $21, $87, $5f, $0e, $ef                  ;$B76D
        .byte   $16, $60, $25, $a2, $5f, $0e, $ef, $16                  ;$B775
        .byte   $60, $25, $a2, $38, $21, $87, $58, $0e                  ;$B77D
        .byte   $ef, $1a, $9c, $25, $a2, $5f, $0e, $ef                  ;$B785
        .byte   $19, $1e, $27, $df, $5f, $0e, $ef, $16                  ;$B78D
        .byte   $60, $2c, $31, $5f, $0e, $ef, $13, $ef                  ;$B795
        .byte   $32, $3c, $7f, $08, $06, $29, $2a, $6a                  ;$B79D
        .byte   $b8, $f1, $07, $77, $85, $0e, $ef, $12                  ;$B7A5
        .byte   $d1, $2c, $31, $83, $2a, $3e, $f5, $0e                  ;$B7AD
        .byte   $ef, $12, $d1, $2c, $c1, $f1, $07, $77                  ;$B7B5
        .byte   $85, $0e, $ef, $13, $ef, $32, $3c, $83                  ;$B7BD
        .byte   $2f, $6b, $f5, $0e, $ef, $13, $ef, $32                  ;$B7C5
        .byte   $3c, $f1, $07, $77, $85, $0e, $ef, $15                  ;$B7CD
        .byte   $1f, $32, $3c, $83, $2f, $6b, $f5, $0e                  ;$B7D5
        .byte   $ef, $15, $1f, $32, $3c, $5c, $08, $07                  ;$B7DD
        .byte   $77, $16, $60, $35, $39, $3f, $3b, $be                  ;$B7E5
        .byte   $3f, $43, $0f, $ff, $c8, $09, $7e, $3f                  ;$B7ED
        .byte   $a4, $60, $06, $06, $99, $1a, $1a, $8c                  ;$B7F5
        .byte   $83, $35, $3a, $83, $3b, $be, $83, $43                  ;$B7FD
        .byte   $0f, $83, $1d, $df, $f3, $35, $39, $f4                  ;$B805
        .byte   $07, $77, $12, $d1, $f4, $07, $77, $12                  ;$B80D
        .byte   $d1, $f4, $07, $77, $12, $d1, $3d, $21                  ;$B815
        .byte   $11, $21, $35, $39, $38, $3b, $be, $38                  ;$B81D
        .byte   $43, $0f, $38, $1d, $df, $38, $32, $3c                  ;$B825
        .byte   $4f, $07, $77, $13, $ef, $4f, $07, $77                  ;$B82D
        .byte   $13, $ef, $4f, $07, $77, $13, $ef, $ef                  ;$B835
        .byte   $1f, $a4, $65, $83, $32, $3c, $83, $35                  ;$B83D
        .byte   $39, $83, $3b, $be, $83, $1d, $df, $57                  ;$B845
        .byte   $44, $48, $48, $2f, $8f, $89, $07, $77                  ;$B84D
        .byte   $12, $d1, $2c, $c1, $3f, $1a, $9c, $3f                  ;$B855
        .byte   $1d, $df, $5f, $07, $77, $10, $c3, $27                  ;$B85D
        .byte   $df, $3f, $1a, $9c, $3f, $1d, $df, $5f                  ;$B865
        .byte   $07, $77, $0e, $ef, $25, $a2, $3f, $1a                  ;$B86D
        .byte   $9c, $3f, $1d, $df, $5f, $07, $77, $1a                  ;$B875
        .byte   $9c, $21, $87, $3f, $16, $60, $3f, $1a                  ;$B87D
        .byte   $9c, $5f, $07, $77, $19, $1e, $1d, $df                  ;$B885
        .byte   $3f, $13, $ef, $3f, $19, $1e, $cf, $0b                  ;$B88D
        .byte   $f5, $07, $77, $16, $60, $1a, $9c, $f3                  ;$B895
        .byte   $12, $d1, $f3, $16, $60, $7d, $11, $11                  ;$B89D
        .byte   $11, $27, $27, $27, $1b, $1b, $1b, $f5                  ;$B8A5
        .byte   $07, $77, $07, $7a, $0e, $ef, $ff, $f5                  ;$B8AD
        .byte   $06, $a7, $0d, $4e, $1a, $9c, $ff, $f5                  ;$B8B5
        .byte   $05, $98, $0b, $30, $16, $60, $ff, $78                  ;$B8BD
        .byte   $04, $69, $66, $1b, $ab, $9b, $de, $3f                  ;$B8C5
        .byte   $f2, $60, $21, $11, $11, $21, $09, $f7                  ;$B8CD
        .byte   $13, $ef, $ff, $1f, $0c, $8f, $f2, $19                  ;$B8D5
        .byte   $1e, $ff, $21, $0e, $ef, $1d, $df, $ff                  ;$B8DD
        .byte   $ff, $c7, $44, $46, $08, $2a, $99, $8a                  ;$B8E5
        .byte   $0a, $f5, $04, $fb, $0c, $8f, $1d, $df                  ;$B8ED
        .byte   $f4, $09, $f7, $0c, $8f, $f5, $09, $f7                  ;$B8F5
        .byte   $32, $3c, $3b, $be, $f5, $04, $fb, $32                  ;$B8FD
        .byte   $3c, $3b, $be, $f4, $09, $f7, $0c, $8f                  ;$B905
        .byte   $f5, $09, $f7, $27, $df, $32, $3c, $f5                  ;$B90D
        .byte   $04, $fb, $27, $df, $32, $3c, $f4, $09                  ;$B915
        .byte   $f7, $0c, $8f, $47, $42, $69, $66, $1b                  ;$B91D
        .byte   $ab, $9b, $09, $f7, $13, $ef, $4f, $09                  ;$B925
        .byte   $f7, $13, $ef, $4f, $0c, $8f, $19, $1e                  ;$B92D
        .byte   $4f, $0e, $ef, $1d, $df, $7f, $44, $46                  ;$B935
        .byte   $08, $2a, $99, $8a, $f5, $05, $98, $09                  ;$B93D
        .byte   $68, $1d, $df, $f4, $0d, $4e, $0e, $ef                  ;$B945
        .byte   $f5, $12, $d2, $2c, $c1, $3b, $be, $f5                  ;$B94D
        .byte   $07, $77, $2c, $c1, $3b, $be, $f4, $0e                  ;$B955
        .byte   $ef, $12, $d1, $f5, $12, $d1, $2c, $c1                  ;$B95D
        .byte   $35, $39, $f5, $03, $bb, $2c, $31, $35                  ;$B965
        .byte   $39, $f4, $0d, $4e, $0e, $ef, $47, $42                  ;$B96D
        .byte   $69, $66, $1b, $ab, $9b, $09, $68, $12                  ;$B975
        .byte   $d1, $4f, $09, $68, $12, $d1, $4f, $0b                  ;$B97D
        .byte   $30, $16, $60, $4f, $10, $c0, $21, $87                  ;$B985
        .byte   $7f, $44, $44, $08, $2a, $59, $5a, $f5                  ;$B98D
        .byte   $07, $77, $12, $d1, $21, $87, $f4, $0e                  ;$B995
        .byte   $ef, $12, $d1, $f5, $12, $d1, $35, $39                  ;$B99D
        .byte   $43, $0f, $f5, $03, $bb, $35, $39, $43                  ;$B9A5
        .byte   $0f, $f4, $0e, $ef, $12, $d1, $f5, $12                  ;$B9AD
        .byte   $d1, $2c, $c1, $35, $39, $f5, $07, $77                  ;$B9B5
        .byte   $2c, $c1, $35, $39, $f4, $0d, $4e, $0e                  ;$B9BD
        .byte   $ef, $47, $42, $69, $46, $1b, $ab, $ab                  ;$B9C5
        .byte   $09, $68, $12, $d1, $4f, $09, $68, $12                  ;$B9CD
        .byte   $d1, $4f, $0b, $30, $16, $60, $4f, $10                  ;$B9D5
        .byte   $c3, $21, $87, $7f, $44, $44, $08, $2a                  ;$B9DD
        .byte   $59, $5a, $f5, $04, $fb, $0c, $8f, $21                  ;$B9E5
        .byte   $87, $f4, $0c, $8f, $0e, $ef, $f5, $13                  ;$B9ED
        .byte   $ef, $32, $3c, $43, $0f, $f5, $07, $77                  ;$B9F5
        .byte   $32, $3c, $43, $0f, $f4, $0c, $8f, $0e                  ;$B9FD
        .byte   $ef, $f5, $13, $ef, $27, $df, $32, $3c                  ;$BA05
        .byte   $f5, $04, $fb, $27, $df, $32, $3c, $f4                  ;$BA0D
        .byte   $0c, $8f, $0e, $ef, $dc, $0b, $21, $21                  ;$BA15
        .byte   $21, $e7, $04, $04, $44, $5b, $5b, $5b                  ;$BA1D
        .byte   $6f, $f4, $65, $f4, $09, $f7, $13, $ef                  ;$BA25
        .byte   $f4, $09, $f7, $13, $ef, $f4, $0c, $8f                  ;$BA2D
        .byte   $19, $1e, $f4, $0e, $ef, $1d, $df, $c7                  ;$BA35
        .byte   $44, $44, $48, $39, $49, $aa, $09, $f5                  ;$BA3D
        .byte   $06, $47, $0c, $8f, $27, $df, $84, $09                  ;$BA45
        .byte   $f7, $0c, $8f, $83, $4f, $bf, $f5, $0c                  ;$BA4D
        .byte   $8f, $3b, $be, $4f, $bf, $f5, $06, $47                  ;$BA55
        .byte   $32, $3c, $4f, $bf, $84, $0c, $8f, $0e                  ;$BA5D
        .byte   $ef, $83, $3b, $be, $f5, $13, $ef, $32                  ;$BA65
        .byte   $3c, $3b, $be, $f5, $04, $fb, $32, $3c                  ;$BA6D
        .byte   $3b, $be, $f4, $09, $f7, $0c, $8f, $47                  ;$BA75
        .byte   $06, $46, $46, $7b, $7b, $7b, $09, $f7                  ;$BA7D
        .byte   $13, $ef, $4f, $09, $f7, $13, $ef, $4f                  ;$BA85
        .byte   $0c, $8f, $19, $1e, $4f, $0e, $ef, $1d                  ;$BA8D
        .byte   $df, $7f, $46, $46, $49, $59, $69, $aa                  ;$BA95
        .byte   $f5, $06, $a7, $06, $af, $27, $df, $84                  ;$BA9D
        .byte   $0d, $4e, $10, $c3, $83, $4f, $bf, $f5                  ;$BAA5
        .byte   $0d, $4e, $10, $c3, $4f, $bf, $f5, $04                  ;$BAAD
        .byte   $fb, $43, $0f, $4f, $bf, $84, $0d, $4e                  ;$BAB5
        .byte   $10, $c3, $83, $43, $0f, $f5, $06, $a7                  ;$BABD
        .byte   $35, $39, $43, $0f, $f5, $03, $53, $27                  ;$BAC5
        .byte   $df, $43, $0f, $df, $21, $21, $41, $c7                  ;$BACD
        .byte   $28, $28, $28, $9b, $9b, $9b, $0c, $f4                  ;$BAD5
        .byte   $0b, $30, $16, $60, $f4, $0b, $30, $16                  ;$BADD
        .byte   $60, $f4, $0d, $4e, $1a, $9c, $f4, $10                  ;$BAE5
        .byte   $c3, $21, $87, $c8, $08, $57, $46, $46                  ;$BAED
        .byte   $49, $59, $59, $ca, $03, $bb, $03, $bb                  ;$BAF5
        .byte   $21, $87, $4f, $0e, $ef, $12, $d1, $4f                  ;$BAFD
        .byte   $12, $d1, $16, $60, $1f, $06, $a7, $5f                  ;$BB05
        .byte   $0e, $ef, $12, $d1, $1c, $31, $5f, $12                  ;$BB0D
        .byte   $d1, $16, $60, $1d, $df, $5f, $06, $47                  ;$BB15
        .byte   $06, $4a, $32, $3c, $4f, $0e, $ef, $13                  ;$BB1D
        .byte   $ef, $4f, $13, $ef, $19, $1e, $1f, $04                  ;$BB25
        .byte   $fb, $5f, $0c, $8f, $0e, $ef, $27, $df                  ;$BB2D
        .byte   $5f, $0e, $ef, $13, $ef, $19, $1e, $5f                  ;$BB35
        .byte   $06, $a7, $06, $aa, $19, $1e, $4f, $0d                  ;$BB3D
        .byte   $4e, $10, $c3, $5f, $0d, $4e, $10, $c3                  ;$BB45
        .byte   $16, $60, $5f, $03, $bb, $03, $bd, $21                  ;$BB4D
        .byte   $87, $4f, $0d, $4e, $12, $d1, $5f, $12                  ;$BB55
        .byte   $d1, $16, $60, $1d, $df, $5f, $09, $f7                  ;$BB5D
        .byte   $0c, $8f, $13, $ef, $8f, $57, $08, $08                  ;$BB65
        .byte   $08, $88, $88, $88, $02, $7d, $04, $fc                  ;$BB6D
        .byte   $09, $f9, $58, $02, $7d, $04, $fc, $09                  ;$BB75
        .byte   $f9, $ff, $7d, $11, $11, $11, $28, $24                  ;$BB7D
        .byte   $44, $39, $2b, $7b, $ec, $10, $6f, $a4                  ;$BB85
        .byte   $65, $32, $32, $3c, $4f, $bf, $28, $2c                  ;$BB8D
        .byte   $c1, $83, $4b, $45, $85, $05, $98, $2c                  ;$BB95
        .byte   $c1, $4b, $45, $85, $0b, $30, $27, $df                  ;$BB9D
        .byte   $43, $0f, $85, $0e, $18, $27, $df, $43                  ;$BBA5
        .byte   $0f, $81, $05, $98, $85, $0b, $30, $27                  ;$BBAD
        .byte   $df, $43, $0f, $85, $0e, $18, $25, $a2                  ;$BBB5
        .byte   $3f, $4b, $85, $05, $98, $25, $a2, $3f                  ;$BBBD
        .byte   $4b, $85, $0b, $30, $27, $df, $43, $0f                  ;$BBC5
        .byte   $85, $0e, $18, $27, $df, $43, $0f, $81                  ;$BBCD
        .byte   $05, $98, $85, $0e, $18, $13, $ef, $16                  ;$BBD5
        .byte   $60, $85, $10, $c3, $13, $ef, $16, $60                  ;$BBDD
        .byte   $85, $07, $77, $12, $d1, $19, $1e, $81                  ;$BBE5
        .byte   $0b, $30, $85, $0e, $ef, $12, $d1, $16                  ;$BBED
        .byte   $60, $81, $05, $98, $85, $0b, $30, $12                  ;$BBF5
        .byte   $d1, $16, $60, $85, $0e, $18, $12, $d1                  ;$BBFD
        .byte   $16, $60, $85, $07, $77, $12, $d1, $21                  ;$BC05
        .byte   $87, $81, $0b, $30, $85, $0e, $ef, $12                  ;$BC0D
        .byte   $d1, $1d, $df, $81, $05, $98, $32, $32                  ;$BC15
        .byte   $3c, $4f, $bf, $28, $2c, $c1, $83, $4b                  ;$BC1D
        .byte   $45, $85, $05, $98, $2c, $c1, $4b, $45                  ;$BC25
        .byte   $85, $0b, $30, $27, $df, $43, $0f, $85                  ;$BC2D
        .byte   $0e, $18, $27, $df, $43, $0f, $81, $05                  ;$BC35
        .byte   $98, $85, $0b, $30, $27, $df, $43, $0f                  ;$BC3D
        .byte   $85, $0d, $4e, $2c, $c1, $4b, $45, $85                  ;$BC45
        .byte   $05, $98, $38, $63, $59, $83, $85, $0b                  ;$BC4D
        .byte   $30, $32, $3c, $4f, $bf, $85, $0e, $18                  ;$BC55
        .byte   $32, $3c, $4f, $bf, $81, $05, $98, $5d                  ;$BC5D
        .byte   $21, $21, $21, $0b, $30, $13, $ef, $1c                  ;$BC65
        .byte   $31, $58, $0b, $da, $13, $ef, $21, $87                  ;$BC6D
        .byte   $58, $0c, $8f, $12, $d1, $21, $87, $5f                  ;$BC75
        .byte   $06, $47, $12, $d1, $1d, $df, $58, $09                  ;$BC7D
        .byte   $f7, $16, $60, $1c, $31, $5f, $04, $fb                  ;$BC85
        .byte   $13, $ef, $19, $1e, $c8, $08, $57, $08                  ;$BC8D
        .byte   $08, $08, $89, $89, $89, $0b, $30, $13                  ;$BC95
        .byte   $ef, $19, $1e, $58, $0b, $30, $13, $ef                  ;$BC9D
        .byte   $19, $1e, $58, $0b, $30, $13, $ef, $19                  ;$BCA5
        .byte   $1e, $5f, $05, $98, $0e, $18, $16, $60                  ;$BCAD
        .byte   $5f, $03, $bb, $07, $77, $0e, $ef, $ff                  ;$BCB5
        .byte   $7d, $21, $11, $21, $06, $46, $68, $1b                  ;$BCBD
        .byte   $69, $99, $f3, $1d, $df, $85, $03, $bb                  ;$BCC5
        .byte   $0d, $4e, $1a, $9c, $82, $0e, $ef, $84                  ;$BCCD
        .byte   $07, $77, $12, $d1, $82, $16, $60, $85                  ;$BCD5
        .byte   $07, $77, $1a, $9c, $1d, $df, $82, $1d                  ;$BCDD
        .byte   $ef, $85, $03, $bb, $0d, $4e, $1a, $9c                  ;$BCE5
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$BCED
        .byte   $82, $16, $60, $85, $07, $77, $1a, $9c                  ;$BCF5
        .byte   $1d, $df, $82, $1d, $ef, $57, $06, $46                  ;$BCFD
        .byte   $89, $1b, $69, $ac, $03, $bb, $0d, $4e                  ;$BD05
        .byte   $32, $3c, $28, $0e, $ef, $48, $07, $77                  ;$BD0D
        .byte   $12, $d1, $28, $16, $60, $48, $07, $77                  ;$BD15
        .byte   $1a, $9c, $28, $1d, $df, $48, $03, $bb                  ;$BD1D
        .byte   $0d, $4e, $28, $0e, $ef, $58, $07, $77                  ;$BD25
        .byte   $12, $d1, $2c, $c1, $28, $16, $60, $58                  ;$BD2D
        .byte   $07, $77, $1a, $9c, $1d, $df, $28, $1d                  ;$BD35
        .byte   $ef, $78, $06, $46, $68, $1b, $69, $99                  ;$BD3D
        .byte   $85, $04, $fb, $0c, $8f, $19, $1e, $82                  ;$BD45
        .byte   $0e, $ef, $84, $09, $f7, $13, $ef, $82                  ;$BD4D
        .byte   $19, $1e, $85, $09, $f7, $1d, $ef, $1d                  ;$BD55
        .byte   $df, $82, $27, $df, $85, $04, $fb, $0c                  ;$BD5D
        .byte   $8f, $19, $1e, $82, $0e, $ef, $84, $09                  ;$BD65
        .byte   $f7, $13, $ef, $82, $19, $1e, $85, $09                  ;$BD6D
        .byte   $f7, $1d, $ef, $1d, $df, $82, $27, $df                  ;$BD75
        .byte   $57, $06, $46, $89, $1b, $69, $ac, $04                  ;$BD7D
        .byte   $fb, $0c, $8f, $2c, $c1, $28, $0e, $ef                  ;$BD85
        .byte   $48, $09, $f7, $13, $ef, $28, $19, $1e                  ;$BD8D
        .byte   $48, $09, $f7, $1d, $df, $28, $27, $df                  ;$BD95
        .byte   $48, $02, $7d, $0c, $8f, $28, $0e, $ef                  ;$BD9D
        .byte   $58, $09, $f7, $13, $ef, $27, $df, $48                  ;$BDA5
        .byte   $09, $f7, $19, $1e, $58, $09, $f7, $1d                  ;$BDAD
        .byte   $ef, $1d, $df, $28, $27, $df, $78, $06                  ;$BDB5
        .byte   $46, $68, $1b, $69, $a9, $85, $03, $bb                  ;$BDBD
        .byte   $0d, $4e, $1a, $9c, $82, $0e, $ef, $84                  ;$BDC5
        .byte   $07, $77, $12, $d1, $82, $16, $60, $85                  ;$BDCD
        .byte   $07, $77, $1a, $9c, $1d, $df, $82, $1d                  ;$BDD5
        .byte   $ef, $85, $03, $bb, $0d, $4e, $1a, $9c                  ;$BDDD
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$BDE5
        .byte   $82, $16, $60, $85, $07, $77, $1a, $9c                  ;$BDED
        .byte   $1d, $df, $82, $1d, $ef, $57, $06, $46                  ;$BDF5
        .byte   $89, $1b, $69, $ac, $03, $bb, $0d, $4e                  ;$BDFD
        .byte   $32, $3c, $28, $0e, $ef, $48, $07, $77                  ;$BE05
        .byte   $12, $d1, $28, $16, $60, $48, $07, $77                  ;$BE0D
        .byte   $1a, $9c, $28, $1d, $df, $48, $03, $bb                  ;$BE15
        .byte   $0d, $4e, $28, $0e, $ef, $58, $07, $77                  ;$BE1D
        .byte   $12, $d1, $2c, $c1, $28, $16, $60, $58                  ;$BE25
        .byte   $07, $77, $1a, $9c, $1d, $df, $28, $1d                  ;$BE2D
        .byte   $ef, $d8, $21, $21, $21, $f5, $09, $f7                  ;$BE35
        .byte   $19, $1e, $27, $df, $f5, $12, $d1, $1a                  ;$BE3D
        .byte   $9c, $2c, $c1, $f5, $11, $c3, $1d, $df                  ;$BE45
        .byte   $32, $3c, $f5, $06, $a7, $2a, $3e, $3b                  ;$BE4D
        .byte   $be, $f1, $03, $53, $f5, $10, $c3, $2c                  ;$BE55
        .byte   $c1, $35, $39, $57, $08, $08, $08, $99                  ;$BE5D
        .byte   $99, $c9, $07, $77, $27, $df, $32, $3c                  ;$BE65
        .byte   $58, $07, $77, $27, $df, $32, $3c, $58                  ;$BE6D
        .byte   $07, $77, $25, $a2, $32, $3c, $5f, $03                  ;$BE75
        .byte   $bb, $1a, $9c, $2c, $c1, $5f, $02, $7d                  ;$BE7D
        .byte   $19, $1e, $27, $df, $ff, $7c, $11, $27                  ;$BE85
        .byte   $27, $48, $19, $19, $ba, $83, $27, $df                  ;$BE8D
        .byte   $81, $07, $e9, $84, $0f, $d2, $13, $ef                  ;$BE95
        .byte   $84, $0f, $d2, $13, $ef, $81, $07, $e9                  ;$BE9D
        .byte   $85, $0f, $d2, $11, $c3, $2a, $3e, $85                  ;$BEA5
        .byte   $0f, $d2, $13, $ef, $27, $df, $31, $05                  ;$BEAD
        .byte   $47, $23, $86, $58, $0a, $8f, $0d, $4e                  ;$BEB5
        .byte   $1f, $a5, $58, $0a, $8f, $0e, $ef, $1d                  ;$BEBD
        .byte   $df, $58, $0a, $8f, $0f, $d2, $1a, $9c                  ;$BEC5
        .byte   $3f, $1a, $9c, $18, $07, $77, $83, $23                  ;$BECD
        .byte   $86, $84, $0e, $ef, $11, $c3, $85, $0e                  ;$BED5
        .byte   $ef, $11, $c3, $23, $86, $81, $05, $ed                  ;$BEDD
        .byte   $85, $0e, $ef, $15, $1f, $1a, $9c, $85                  ;$BEE5
        .byte   $0e, $ef, $15, $1f, $17, $b5, $31, $07                  ;$BEED
        .byte   $e9, $17, $b5, $48, $0f, $d2, $13, $ef                  ;$BEF5
        .byte   $48, $0f, $d2, $13, $ef, $48, $0b, $da                  ;$BEFD
        .byte   $15, $1f, $28, $13, $ef, $58, $07, $77                  ;$BF05
        .byte   $11, $c3, $17, $b5, $18, $07, $e9, $83                  ;$BF0D
        .byte   $27, $df, $84, $0f, $d2, $13, $ef, $84                  ;$BF15
        .byte   $0f, $d2, $13, $ef, $81, $07, $e9, $85                  ;$BF1D
        .byte   $0f, $d2, $11, $c3, $2a, $3e, $85, $0f                  ;$BF25
        .byte   $d2, $13, $ef, $27, $df, $31, $05, $47                  ;$BF2D
        .byte   $23, $86, $58, $0a, $8f, $0d, $4e, $1f                  ;$BF35
        .byte   $a5, $58, $0a, $8f, $0e, $ef, $1d, $df                  ;$BF3D
        .byte   $58, $0b, $30, $12, $d1, $1a, $9c, $5f                  ;$BF45
        .byte   $07, $77, $12, $d1, $1a, $9c, $18, $09                  ;$BF4D
        .byte   $f7, $83, $19, $1e, $84, $0e, $ef, $13                  ;$BF55
        .byte   $ef, $85, $0e, $ef, $13, $ef, $19, $1e                  ;$BF5D
        .byte   $81, $09, $f7, $85, $0f, $d2, $12, $d1                  ;$BF65
        .byte   $1a, $9c, $85, $0f, $d2, $12, $d1, $1f                  ;$BF6D
        .byte   $a5, $85, $09, $f7, $19, $1e, $1d, $df                  ;$BF75
        .byte   $84, $07, $77, $0e, $ef, $84, $07, $77                  ;$BF7D
        .byte   $0e, $ef, $84, $07, $77, $0e, $ef, $84                  ;$BF85
        .byte   $07, $77, $0e, $ef, $dc, $08, $21, $11                  ;$BF8D
        .byte   $21, $37, $06, $46, $68, $1b, $69, $99                  ;$BF95
        .byte   $1d, $df, $5f, $03, $bb, $0d, $4e, $1a                  ;$BF9D
        .byte   $9c, $28, $0e, $ef, $48, $07, $77, $12                  ;$BFA5
        .byte   $d1, $28, $16, $60, $58, $07, $77, $1a                  ;$BFAD
        .byte   $9c, $1d, $df, $28, $1d, $ef, $58, $03                  ;$BFB5
        .byte   $bb, $0d, $4e, $1a, $9c, $28, $0e, $ef                  ;$BFBD
        .byte   $48, $07, $77, $12, $d1, $28, $16, $60                  ;$BFC5
        .byte   $58, $07, $77, $1a, $9c, $1d, $df, $28                  ;$BFCD
        .byte   $1d, $ef, $78, $06, $46, $89, $1b, $69                  ;$BFD5
        .byte   $ac, $85, $03, $bb, $0d, $4e, $32, $3c                  ;$BFDD
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$BFE5
        .byte   $82, $16, $60, $84, $07, $77, $1a, $9c                  ;$BFED
        .byte   $82, $1d, $df, $84, $03, $bb, $0d, $4e                  ;$BFF5
        .byte   $82, $0e, $ef, $85, $07, $77, $12, $d1                  ;$BFFD
        .byte   $2c, $c1, $82, $16, $60, $85, $07, $77                  ;$C005
        .byte   $1a, $9c, $1d, $df, $82, $1d, $ef, $57                  ;$C00D
        .byte   $06, $46, $68, $1b, $69, $99, $04, $fb                  ;$C015
        .byte   $0c, $8f, $19, $1e, $28, $0e, $ef, $48                  ;$C01D
        .byte   $09, $f7, $13, $ef, $28, $19, $1e, $58                  ;$C025
        .byte   $09, $f7, $1d, $ef, $1d, $df, $28, $27                  ;$C02D
        .byte   $df, $58, $04, $fb, $0c, $8f, $19, $1e                  ;$C035
        .byte   $28, $0e, $ef, $48, $09, $f7, $13, $ef                  ;$C03D
        .byte   $28, $19, $1e, $58, $09, $f7, $1d, $ef                  ;$C045
        .byte   $1d, $df, $28, $27, $df, $78, $06, $46                  ;$C04D
        .byte   $89, $1b, $69, $ac, $85, $04, $fb, $0c                  ;$C055
        .byte   $8f, $2c, $c1, $82, $0e, $ef, $84, $09                  ;$C05D
        .byte   $f7, $13, $ef, $82, $19, $1e, $84, $09                  ;$C065
        .byte   $f7, $1d, $df, $82, $27, $df, $84, $02                  ;$C06D
        .byte   $7d, $0c, $8f, $82, $0e, $ef, $85, $09                  ;$C075
        .byte   $f7, $13, $ef, $27, $df, $84, $09, $f7                  ;$C07D
        .byte   $19, $1e, $85, $09, $f7, $1d, $ef, $1d                  ;$C085
        .byte   $df, $82, $27, $df, $57, $06, $46, $69                  ;$C08D
        .byte   $1a, $88, $a9, $03, $bb, $0d, $4e, $1a                  ;$C095
        .byte   $9c, $28, $0e, $ef, $48, $07, $77, $12                  ;$C09D
        .byte   $d1, $28, $16, $60, $58, $07, $77, $1a                  ;$C0A5
        .byte   $9c, $1d, $df, $28, $1d, $ef, $58, $03                  ;$C0AD
        .byte   $bb, $0d, $4e, $1a, $9c, $28, $0e, $ef                  ;$C0B5
        .byte   $48, $07, $77, $12, $d1, $28, $16, $60                  ;$C0BD
        .byte   $58, $07, $77, $1a, $9c, $1d, $df, $28                  ;$C0C5
        .byte   $1d, $ef, $78, $06, $46, $89, $1b, $69                  ;$C0CD
        .byte   $ac, $85, $03, $bb, $0d, $4e, $32, $3c                  ;$C0D5
        .byte   $82, $0e, $ef, $84, $07, $77, $12, $d1                  ;$C0DD
        .byte   $82, $16, $60, $84, $07, $77, $1a, $9c                  ;$C0E5
        .byte   $82, $1d, $df, $84, $03, $bb, $0d, $4e                  ;$C0ED
        .byte   $82, $0e, $ef, $85, $07, $77, $12, $d1                  ;$C0F5
        .byte   $2c, $c1, $82, $16, $60, $85, $07, $77                  ;$C0FD
        .byte   $1a, $9c, $1d, $df, $82, $1d, $ef, $5d                  ;$C105
        .byte   $21, $21, $21, $09, $f7, $19, $1e, $27                  ;$C10D
        .byte   $df, $5f, $12, $d1, $1a, $9c, $2c, $c1                  ;$C115
        .byte   $5f, $11, $c3, $1d, $df, $32, $3c, $5f                  ;$C11D
        .byte   $06, $a7, $2a, $3e, $3b, $be, $1f, $03                  ;$C125
        .byte   $53, $5f, $10, $c3, $2c, $c1, $35, $39                  ;$C12D
        .byte   $7f, $08, $08, $08, $99, $99, $c9, $85                  ;$C135
        .byte   $07, $77, $27, $df, $32, $3c, $85, $07                  ;$C13D
        .byte   $77, $27, $df, $32, $3c, $f5, $07, $77                  ;$C145
        .byte   $25, $a2, $32, $3c, $f5, $03, $bb, $1a                  ;$C14D
        .byte   $9c, $2c, $c1, $85, $02, $7d, $19, $1e                  ;$C155
        .byte   $27, $df, $8c, $2f, $9c, $08, $ff                       ;$C15D
        
_c164:                                                                  ;$C164
        .byte                                      $a7                  ;$C164
        .byte   $05, $05, $0a, $17, $17, $fa, $00, $06                  ;$C165
        .byte   $00, $04, $00, $01, $ec, $05, $7f, $f4                  ;$C16D
        .byte   $50, $4d, $21, $21, $41, $10, $c3, $19                  ;$C175
        .byte   $1e, $4f, $10, $c3, $19, $1e, $4f, $10                  ;$C17D
        .byte   $c3, $19, $1e, $4f, $10, $c3, $19, $1e                  ;$C185
        .byte   $4f, $10, $c3, $19, $1e, $4f, $10, $c3                  ;$C18D
        .byte   $19, $1e, $4f, $10, $c3, $19, $1e, $4f                  ;$C195
        .byte   $10, $c3, $19, $1e, $5f, $10, $c3, $19                  ;$C19D
        .byte   $1e, $02, $f6, $38, $03, $23, $58, $10                  ;$C1A5
        .byte   $c3, $19, $1e, $04, $30, $38, $05, $47                  ;$C1AD
        .byte   $58, $10, $c3, $19, $1e, $07, $0c, $38                  ;$C1B5
        .byte   $06, $47, $58, $10, $c3, $19, $1e, $09                  ;$C1BD
        .byte   $68, $38, $0a, $8f, $58, $10, $c3, $19                  ;$C1C5
        .byte   $1e, $0e, $18, $38, $0c, $8f, $58, $10                  ;$C1CD
        .byte   $c3, $19, $1e, $12, $d1, $38, $15, $1f                  ;$C1D5
        .byte   $58, $10, $c3, $19, $1f, $1c, $31, $38                  ;$C1DD
        .byte   $17, $b5, $58, $10, $c3, $15, $1f, $19                  ;$C1E5
        .byte   $1e, $38, $2a, $3e, $48, $10, $c3, $19                  ;$C1ED
        .byte   $1e, $4f, $10, $c3, $19, $1e, $4f, $10                  ;$C1F5
        .byte   $c3, $19, $1e, $4f, $10, $c3, $19, $1e                  ;$C1FD
        .byte   $7f, $05, $05, $25, $17, $17, $a8, $4e                  ;$C205
        .byte   $3f, $f4, $63, $0e, $18, $16, $60, $5f                  ;$C20D
        .byte   $0e, $18, $16, $60, $19, $1e, $38, $19                  ;$C215
        .byte   $1e, $58, $0e, $18, $16, $60, $21, $87                  ;$C21D
        .byte   $5f, $0e, $18, $16, $60, $2a, $3e, $7f                  ;$C225
        .byte   $04, $04, $29, $17, $17, $ab, $f5, $0c                  ;$C22D
        .byte   $8f, $16, $60, $32, $3c, $f4, $0c, $8f                  ;$C235
        .byte   $16, $60, $f4, $0c, $8f, $16, $60, $f4                  ;$C23D
        .byte   $0c, $8f, $16, $60, $f5, $0c, $8f, $16                  ;$C245
        .byte   $60, $1f, $a5, $f4, $0c, $8f, $16, $60                  ;$C24D
        .byte   $f4, $0c, $8f, $16, $60, $f4, $0c, $8f                  ;$C255
        .byte   $16, $60, $73, $00, $00, $31, $31, $04                  ;$C25D
        .byte   $19, $19, $5b, $ed, $21, $41, $41, $3f                  ;$C265
        .byte   $f4, $70, $4a, $00, $0a, $00, $0a, $00                  ;$C26D
        .byte   $0a, $04, $30, $04, $35, $5f, $10, $c3                  ;$C275
        .byte   $15, $1f, $19, $1e, $38, $19, $1e, $58                  ;$C27D
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $04                  ;$C285
        .byte   $30, $04, $35, $2a, $3e, $5f, $10, $c3                  ;$C28D
        .byte   $15, $1f, $32, $3c, $4f, $10, $c3, $15                  ;$C295
        .byte   $1f, $4f, $04, $30, $04, $35, $4f, $10                  ;$C29D
        .byte   $c3, $15, $1f, $4f, $03, $23, $03, $24                  ;$C2A5
        .byte   $5f, $10, $c3, $16, $60, $25, $a2, $38                  ;$C2AD
        .byte   $25, $a2, $58, $10, $c3, $16, $60, $2c                  ;$C2B5
        .byte   $c1, $5f, $03, $23, $03, $24, $32, $3c                  ;$C2BD
        .byte   $5f, $10, $c3, $16, $60, $38, $63, $5f                  ;$C2C5
        .byte   $10, $c3, $16, $60, $32, $3c, $5f, $03                  ;$C2CD
        .byte   $23, $03, $24, $2a, $3e, $5f, $10, $c3                  ;$C2D5
        .byte   $16, $60, $25, $a2, $5f, $04, $30, $04                  ;$C2DD
        .byte   $35, $2a, $3e, $5f, $10, $c3, $15, $1f                  ;$C2E5
        .byte   $21, $87, $5f, $10, $c3, $15, $1f, $19                  ;$C2ED
        .byte   $1e, $5f, $04, $30, $04, $35, $19, $1e                  ;$C2F5
        .byte   $4f, $10, $c3, $15, $1f, $4f, $10, $c3                  ;$C2FD
        .byte   $15, $1f, $5f, $04, $30, $04, $35, $03                  ;$C305
        .byte   $23, $38, $04, $39, $58, $10, $c3, $15                  ;$C30D
        .byte   $1f, $06, $47, $38, $08, $61, $48, $03                  ;$C315
        .byte   $23, $03, $24, $4f, $10, $c3, $16, $60                  ;$C31D
        .byte   $4f, $10, $c3, $16, $60, $4f, $03, $23                  ;$C325
        .byte   $03, $24, $4f, $10, $c3, $16, $60, $4f                  ;$C32D
        .byte   $10, $c3, $16, $60, $5f, $03, $23, $03                  ;$C335
        .byte   $24, $03, $25, $38, $04, $b4, $58, $10                  ;$C33D
        .byte   $c3, $16, $60, $06, $47, $38, $09, $68                  ;$C345
        .byte   $48, $04, $30, $04, $35, $5f, $10, $c3                  ;$C34D
        .byte   $15, $1f, $19, $1e, $38, $19, $1e, $58                  ;$C355
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $04                  ;$C35D
        .byte   $30, $04, $35, $2a, $3e, $5f, $10, $c3                  ;$C365
        .byte   $15, $1f, $32, $3c, $4f, $10, $c3, $15                  ;$C36D
        .byte   $1f, $4f, $04, $30, $04, $35, $5f, $10                  ;$C375
        .byte   $c3, $15, $1f, $32, $3c, $38, $38, $63                  ;$C37D
        .byte   $58, $05, $98, $05, $9f, $3b, $be, $5f                  ;$C385
        .byte   $0b, $30, $0e, $18, $38, $63, $4f, $0b                  ;$C38D
        .byte   $30, $0e, $18, $5f, $05, $47, $05, $4f                  ;$C395
        .byte   $32, $3c, $4f, $0a, $8f, $0c, $8f, $5f                  ;$C39D
        .byte   $0a, $8f, $0c, $8f, $2a, $3e, $5f, $05                  ;$C3A5
        .byte   $47, $05, $4d, $32, $3c, $5f, $0a, $8f                  ;$C3AD
        .byte   $0c, $8f, $38, $63, $5f, $09, $68, $09                  ;$C3B5
        .byte   $6f, $25, $a2, $4f, $12, $d1, $16, $60                  ;$C3BD
        .byte   $4f, $12, $d1, $16, $60, $5f, $12, $d1                  ;$C3C5
        .byte   $16, $60, $08, $61, $4f, $12, $d1, $16                  ;$C3CD
        .byte   $60, $5f, $12, $d1, $16, $60, $07, $e9                  ;$C3D5
        .byte   $4f, $12, $d1, $16, $60, $5f, $12, $d1                  ;$C3DD
        .byte   $16, $60, $07, $0c, $5f, $0c, $8f, $0f                  ;$C3E5
        .byte   $d2, $06, $47, $4f, $0c, $8f, $0f, $d2                  ;$C3ED
        .byte   $4f, $0c, $8f, $0f, $d2, $5f, $0c, $8f                  ;$C3F5
        .byte   $0f, $d2, $05, $98, $4f, $0c, $8f, $0f                  ;$C3FD
        .byte   $d2, $5f, $0e, $18, $10, $c3, $05, $47                  ;$C405
        .byte   $4f, $0e, $18, $10, $c3, $5f, $0f, $d2                  ;$C40D
        .byte   $12, $d1, $04, $b4, $4f, $04, $30, $04                  ;$C415
        .byte   $35, $5f, $10, $c3, $15, $1f, $19, $1e                  ;$C41D
        .byte   $38, $19, $1e, $58, $10, $c3, $15, $1f                  ;$C425
        .byte   $21, $87, $5f, $04, $30, $04, $35, $2a                  ;$C42D
        .byte   $3e, $5f, $10, $c3, $15, $1f, $32, $3c                  ;$C435
        .byte   $4f, $10, $c3, $15, $1f, $4f, $04, $30                  ;$C43D
        .byte   $04, $35, $4f, $10, $c3, $15, $1f, $4f                  ;$C445
        .byte   $03, $23, $03, $24, $5f, $10, $c3, $16                  ;$C44D
        .byte   $60, $25, $a2, $38, $25, $a2, $58, $10                  ;$C455
        .byte   $c3, $16, $60, $2c, $c1, $5f, $03, $23                  ;$C45D
        .byte   $03, $24, $32, $3c, $5f, $10, $c3, $16                  ;$C465
        .byte   $60, $38, $63, $5f, $10, $c3, $16, $60                  ;$C46D
        .byte   $32, $3c, $5f, $03, $23, $03, $24, $2a                  ;$C475
        .byte   $3e, $5f, $10, $c3, $16, $60, $25, $a2                  ;$C47D
        .byte   $5f, $04, $30, $04, $35, $2a, $3e, $5f                  ;$C485
        .byte   $10, $c3, $15, $1f, $21, $87, $5f, $10                  ;$C48D
        .byte   $c3, $15, $1f, $19, $1e, $5f, $04, $30                  ;$C495
        .byte   $04, $35, $38, $63, $4f, $10, $c3, $15                  ;$C49D
        .byte   $1f, $4f, $10, $c3, $15, $1f, $4f, $04                  ;$C4A5
        .byte   $30, $04, $35, $4f, $10, $c3, $15, $1f                  ;$C4AD
        .byte   $5f, $04, $b4, $04, $b8, $25, $a2, $4f                  ;$C4B5
        .byte   $12, $d1, $16, $60, $4f, $12, $d1, $16                  ;$C4BD
        .byte   $60, $4f, $09, $68, $09, $6a, $4f, $12                  ;$C4C5
        .byte   $d1, $16, $60, $4f, $12, $d1, $16, $60                  ;$C4CD
        .byte   $4f, $04, $b4, $04, $b8, $7f, $04, $04                  ;$C4D5
        .byte   $06, $28, $28, $8b, $85, $12, $d1, $16                  ;$C4DD
        .byte   $60, $25, $a2, $83, $2a, $3e, $f5, $06                  ;$C4E5
        .byte   $47, $06, $4f, $2c, $c1, $f5, $10, $c3                  ;$C4ED
        .byte   $16, $60, $2a, $3e, $f4, $10, $c3, $16                  ;$C4F5
        .byte   $60, $f5, $06, $47, $06, $4f, $21, $87                  ;$C4FD
        .byte   $f5, $10, $c3, $1c, $31, $2c, $c1, $f5                  ;$C505
        .byte   $10, $c3, $1c, $c1, $2a, $3e, $f4, $06                  ;$C50D
        .byte   $47, $06, $4f, $f5, $0e, $18, $16, $60                  ;$C515
        .byte   $21, $87, $f5, $0c, $8f, $16, $60, $32                  ;$C51D
        .byte   $3c, $85, $0c, $8f, $16, $60, $32, $3c                  ;$C525
        .byte   $83, $32, $3c, $f5, $0c, $8f, $16, $60                  ;$C52D
        .byte   $32, $3c, $ff, $7f, $06, $06, $48, $48                  ;$C535
        .byte   $48, $8a, $f5, $06, $47, $16, $60, $32                  ;$C53D
        .byte   $3c, $5f, $04, $30, $15, $1f, $43, $0f                  ;$C545
        .byte   $4f, $10, $c3, $15, $1f, $4f, $10, $c3                  ;$C54D
        .byte   $15, $1f, $4f, $04, $30, $04, $35, $4f                  ;$C555
        .byte   $10, $c3, $15, $1f, $4f, $10, $c3, $15                  ;$C55D
        .byte   $1f, $4f, $03, $23, $03, $24, $4f, $10                  ;$C565
        .byte   $c3, $16, $60, $7f, $06, $06, $06, $28                  ;$C56D
        .byte   $28, $28, $f5, $02, $18, $10, $c3, $15                  ;$C575
        .byte   $1f, $f5, $02, $18, $10, $c3, $15, $1f                  ;$C57D
        .byte   $f5, $04, $30, $10, $c3, $15, $1f, $f5                  ;$C585
        .byte   $02, $18, $10, $c3, $15, $1f, $ff, $f3                  ;$C58D
        .byte   $08, $61, $f3, $07, $e9, $7d, $11, $11                  ;$C595
        .byte   $41, $04, $08, $04, $68, $6c, $48, $f3                  ;$C59D
        .byte   $07, $77, $84, $0b, $30, $0e, $ef, $84                  ;$C5A5
        .byte   $0b, $30, $0e, $ef, $f4, $0e, $ef, $12                  ;$C5AD
        .byte   $d1, $f5, $12, $d1, $16, $60, $07, $77                  ;$C5B5
        .byte   $f4, $16, $60, $1d, $df, $f1, $12, $d1                  ;$C5BD
        .byte   $31, $0e, $ef, $09, $68, $1f, $0b, $30                  ;$C5C5
        .byte   $3f, $07, $77, $1f, $09, $68, $18, $0b                  ;$C5CD
        .byte   $30, $18, $0e, $ef, $1f, $12, $d1, $f3                  ;$C5D5
        .byte   $07, $77, $f1, $16, $60, $f1, $12, $d1                  ;$C5DD
        .byte   $f5, $0e, $ef, $1d, $df, $07, $77, $f1                  ;$C5E5
        .byte   $0b, $30, $32, $21, $87, $07, $0c, $1f                  ;$C5ED
        .byte   $0a, $8f, $18, $0e, $18, $18, $10, $c3                  ;$C5F5
        .byte   $5f, $15, $1f, $1c, $31, $07, $0c, $4f                  ;$C5FD
        .byte   $1c, $31, $21, $87, $1f, $15, $1f, $7f                  ;$C605
        .byte   $04, $04, $a0, $88, $09, $0b, $31, $10                  ;$C60D
        .byte   $c3, $05, $47, $1f, $0e, $18, $1f, $0a                  ;$C615
        .byte   $8f, $83, $03, $86, $81, $0e, $18, $81                  ;$C61D
        .byte   $10, $c3, $81, $15, $1f, $31, $1c, $31                  ;$C625
        .byte   $04, $30, $18, $21, $87, $18, $2a, $3e                  ;$C62D
        .byte   $18, $38, $63, $18, $43, $0f, $83, $05                  ;$C635
        .byte   $47, $81, $38, $63, $81, $2a, $3e, $81                  ;$C63D
        .byte   $21, $87, $31, $1c, $31, $07, $0c, $18                  ;$C645
        .byte   $15, $1f, $18, $10, $c3, $18, $0e, $18                  ;$C64D
        .byte   $78, $04, $08, $04, $68, $6c, $48, $f3                  ;$C655
        .byte   $07, $77, $84, $0b, $30, $0e, $ef, $84                  ;$C65D
        .byte   $0b, $30, $0e, $ef, $f4, $0e, $ef, $12                  ;$C665
        .byte   $d1, $f5, $12, $d1, $16, $60, $07, $77                  ;$C66D
        .byte   $f4, $16, $60, $1d, $df, $f1, $12, $d1                  ;$C675
        .byte   $31, $0e, $ef, $09, $68, $1f, $0b, $30                  ;$C67D
        .byte   $3f, $07, $77, $1f, $09, $68, $18, $0b                  ;$C685
        .byte   $30, $18, $0e, $ef, $1f, $12, $d1, $f3                  ;$C68D
        .byte   $07, $77, $f4, $16, $60, $1c, $31, $f1                  ;$C695
        .byte   $12, $d1, $f5, $0e, $ef, $1d, $df, $09                  ;$C69D
        .byte   $68, $f1, $0b, $30, $32, $23, $86, $07                  ;$C6A5
        .byte   $0c, $1f, $0a, $8f, $18, $0e, $18, $18                  ;$C6AD
        .byte   $11, $c3, $1f, $15, $1f, $f3, $08, $e1                  ;$C6B5
        .byte   $f1, $1c, $31, $f1, $15, $1f, $31, $11                  ;$C6BD
        .byte   $c3, $0a, $8f, $1f, $0e, $18, $7f, $06                  ;$C6C5
        .byte   $06, $a0, $88, $6b, $0b, $31, $0a, $8f                  ;$C6CD
        .byte   $03, $86, $18, $0e, $18, $18, $11, $c3                  ;$C6D5
        .byte   $18, $15, $1f, $18, $1c, $31, $83, $04                  ;$C6DD
        .byte   $70, $81, $23, $86, $81, $2a, $3e, $81                  ;$C6E5
        .byte   $38, $63, $31, $47, $0c, $05, $47, $18                  ;$C6ED
        .byte   $38, $63, $18, $2a, $3e, $18, $23, $86                  ;$C6F5
        .byte   $d8, $11, $21, $41, $85, $1c, $31, $23                  ;$C6FD
        .byte   $86, $07, $0c, $81, $15, $1f, $81, $11                  ;$C705
        .byte   $c3, $81, $0e, $18, $27, $06, $06, $06                  ;$C70D
        .byte   $48, $6b, $48, $25, $a2, $f3, $09, $68                  ;$C715
        .byte   $13, $12, $d1, $17, $b5, $3f, $12, $d1                  ;$C71D
        .byte   $f1, $17, $b5, $f3, $09, $68, $f5, $17                  ;$C725
        .byte   $b5, $1c, $31, $12, $d1, $13, $12, $d1                  ;$C72D
        .byte   $17, $b5, $3f, $09, $68, $3f, $12, $d1                  ;$C735
        .byte   $f1, $17, $b5, $13, $09, $68, $17, $b5                  ;$C73D
        .byte   $3f, $12, $d1, $f1, $17, $b5, $13, $12                  ;$C745
        .byte   $d1, $17, $b5, $3f, $09, $68, $f1, $17                  ;$C74D
        .byte   $b5, $13, $12, $d1, $17, $b5, $3f, $12                  ;$C755
        .byte   $d1, $f1, $17, $b5, $f5, $17, $b5, $1c                  ;$C75D
        .byte   $31, $09, $68, $f5, $17, $b5, $25, $a2                  ;$C765
        .byte   $12, $d1, $f5, $17, $b5, $27, $df, $09                  ;$C76D
        .byte   $f7, $13, $13, $ef, $17, $b5, $3f, $13                  ;$C775
        .byte   $ef, $f1, $17, $b5, $f3, $09, $f7, $f5                  ;$C77D
        .byte   $17, $b5, $1d, $df, $13, $ef, $13, $13                  ;$C785
        .byte   $ef, $17, $b5, $3f, $09, $f7, $3f, $13                  ;$C78D
        .byte   $ef, $f1, $17, $b5, $13, $09, $f7, $17                  ;$C795
        .byte   $b5, $3f, $13, $ef, $f1, $17, $b5, $13                  ;$C79D
        .byte   $13, $ef, $17, $b5, $3f, $09, $f7, $f1                  ;$C7A5
        .byte   $17, $b5, $7d, $21, $41, $41, $06, $06                  ;$C7AD
        .byte   $06, $28, $6b, $28, $f5, $17, $b5, $1d                  ;$C7B5
        .byte   $df, $13, $ef, $13, $13, $ef, $17, $b5                  ;$C7BD
        .byte   $5f, $17, $b5, $27, $df, $09, $f7, $3f                  ;$C7C5
        .byte   $17, $b5, $f1, $17, $b5, $32, $2a, $3e                  ;$C7CD
        .byte   $09, $68, $3f, $0e, $18, $f1, $15, $1f                  ;$C7D5
        .byte   $13, $12, $d1, $17, $b5, $3f, $09, $68                  ;$C7DD
        .byte   $5f, $15, $1f, $1f, $a5, $0e, $18, $3f                  ;$C7E5
        .byte   $12, $d1, $f1, $17, $b5, $f3, $09, $68                  ;$C7ED
        .byte   $13, $0e, $18, $15, $1f, $3f, $12, $d1                  ;$C7F5
        .byte   $f1, $17, $b5, $f3, $09, $68, $13, $0e                  ;$C7FD
        .byte   $18, $15, $1f, $3f, $12, $d1, $f1, $17                  ;$C805
        .byte   $b5, $32, $1f, $a5, $09, $68, $3f, $0e                  ;$C80D
        .byte   $18, $81, $15, $1f, $82, $2a, $3e, $13                  ;$C815
        .byte   $12, $d1, $17, $b5, $7f, $06, $06, $06                  ;$C81D
        .byte   $48, $48, $9b, $f5, $17, $b5, $21, $87                  ;$C825
        .byte   $09, $68, $85, $04, $b4, $05, $98, $2c                  ;$C82D
        .byte   $c1, $84, $05, $47, $06, $47, $84, $05                  ;$C835
        .byte   $98, $07, $0c, $84, $06, $47, $07, $e9                  ;$C83D
        .byte   $84, $07, $c0, $08, $61, $84, $07, $e9                  ;$C845
        .byte   $09, $68, $84, $08, $61, $0a, $8f, $84                  ;$C84D
        .byte   $09, $68, $0b, $30, $84, $0a, $8f, $0c                  ;$C855
        .byte   $8f, $84, $0b, $30, $0e, $18, $84, $0c                  ;$C85D
        .byte   $8f, $0f, $d2, $84, $0e, $18, $10, $c3                  ;$C865
        .byte   $85, $0f, $d2, $12, $d1, $2a, $3e, $84                  ;$C86D
        .byte   $10, $c3, $15, $1f, $85, $12, $d1, $16                  ;$C875
        .byte   $60, $2c, $c1, $84, $1c, $31, $21, $87                  ;$C87D
        .byte   $57, $03, $03, $06, $29, $29, $9c, $19                  ;$C885
        .byte   $1e, $1f, $a5, $32, $3c, $48, $12, $d1                  ;$C88D
        .byte   $19, $1e, $48, $0f, $d2, $12, $d1, $48                  ;$C895
        .byte   $0c, $8f, $0f, $d2, $48, $16, $60, $1c                  ;$C89D
        .byte   $31, $48, $10, $c3, $16, $60, $48, $0e                  ;$C8A5
        .byte   $18, $10, $c3, $48, $0b, $30, $0e, $18                  ;$C8AD
        .byte   $58, $15, $1f, $19, $1e, $19, $23, $48                  ;$C8B5
        .byte   $0f, $d2, $15, $1f, $48, $0c, $8f, $0f                  ;$C8BD
        .byte   $d2, $48, $0a, $8f, $0c, $8f, $48, $0f                  ;$C8C5
        .byte   $d2, $16, $60, $48, $0c, $8f, $12, $d1                  ;$C8CD
        .byte   $48, $09, $68, $0f, $d2, $48, $06, $47                  ;$C8D5
        .byte   $09, $68, $78, $30, $30, $06, $39, $39                  ;$C8DD
        .byte   $4b, $f4, $04, $30, $04, $35, $85, $10                  ;$C8E5
        .byte   $c3, $15, $1f, $19, $1e, $83, $19, $1e                  ;$C8ED
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$C8F5
        .byte   $04, $30, $04, $35, $2a, $3e, $f5, $10                  ;$C8FD
        .byte   $c3, $15, $1f, $32, $3c, $f4, $10, $c3                  ;$C905
        .byte   $15, $1f, $f4, $04, $30, $04, $35, $f4                  ;$C90D
        .byte   $10, $c3, $15, $1f, $f4, $03, $23, $03                  ;$C915
        .byte   $24, $85, $10, $c3, $16, $60, $25, $a2                  ;$C91D
        .byte   $83, $25, $a2, $f5, $10, $c3, $16, $60                  ;$C925
        .byte   $2c, $c1, $f5, $03, $23, $03, $24, $32                  ;$C92D
        .byte   $3c, $f5, $10, $c3, $16, $60, $38, $63                  ;$C935
        .byte   $f5, $10, $c3, $16, $60, $32, $3c, $f5                  ;$C93D
        .byte   $03, $23, $03, $24, $2a, $3e, $f5, $10                  ;$C945
        .byte   $c3, $16, $60, $25, $a2, $f5, $04, $30                  ;$C94D
        .byte   $04, $35, $2a, $3e, $f5, $10, $c3, $15                  ;$C955
        .byte   $1f, $21, $87, $f5, $10, $c3, $15, $1f                  ;$C95D
        .byte   $19, $1e, $f5, $04, $30, $04, $35, $19                  ;$C965
        .byte   $1e, $f4, $10, $c3, $15, $1f, $f4, $10                  ;$C96D
        .byte   $c3, $15, $1f, $85, $04, $30, $04, $35                  ;$C975
        .byte   $03, $23, $83, $04, $39, $85, $10, $c3                  ;$C97D
        .byte   $15, $1f, $06, $47, $83, $08, $61, $f4                  ;$C985
        .byte   $03, $23, $03, $24, $f4, $10, $c3, $16                  ;$C98D
        .byte   $60, $f4, $10, $c3, $16, $60, $f4, $03                  ;$C995
        .byte   $23, $03, $24, $f4, $10, $c3, $16, $60                  ;$C99D
        .byte   $f4, $10, $c3, $16, $60, $85, $03, $23                  ;$C9A5
        .byte   $03, $24, $03, $25, $83, $04, $b4, $85                  ;$C9AD
        .byte   $10, $c3, $16, $60, $06, $47, $83, $09                  ;$C9B5
        .byte   $68, $f4, $04, $30, $04, $35, $85, $10                  ;$C9BD
        .byte   $c3, $15, $1f, $19, $1e, $83, $19, $1e                  ;$C9C5
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$C9CD
        .byte   $04, $30, $04, $35, $2a, $3e, $f5, $10                  ;$C9D5
        .byte   $c3, $15, $1f, $32, $3c, $f4, $10, $c3                  ;$C9DD
        .byte   $15, $1f, $f4, $04, $30, $04, $35, $85                  ;$C9E5
        .byte   $10, $c3, $15, $1f, $32, $3c, $83, $38                  ;$C9ED
        .byte   $63, $f5, $05, $98, $05, $9f, $3b, $be                  ;$C9F5
        .byte   $f5, $0b, $30, $0e, $18, $38, $63, $f4                  ;$C9FD
        .byte   $0b, $30, $0e, $18, $f5, $05, $47, $05                  ;$CA05
        .byte   $4f, $32, $3c, $f4, $0a, $8f, $0c, $8f                  ;$CA0D
        .byte   $f5, $0a, $8f, $0c, $8f, $2a, $3e, $f5                  ;$CA15
        .byte   $05, $47, $05, $4d, $32, $3c, $f5, $0a                  ;$CA1D
        .byte   $8f, $0c, $8f, $38, $63, $f5, $09, $68                  ;$CA25
        .byte   $09, $6f, $25, $a2, $f4, $12, $d1, $16                  ;$CA2D
        .byte   $60, $f4, $12, $d1, $16, $60, $f5, $12                  ;$CA35
        .byte   $d1, $16, $60, $08, $61, $f4, $12, $d1                  ;$CA3D
        .byte   $16, $60, $f5, $12, $d1, $16, $60, $07                  ;$CA45
        .byte   $e9, $f4, $12, $d1, $16, $60, $f5, $12                  ;$CA4D
        .byte   $d1, $16, $60, $07, $0c, $f5, $0c, $8f                  ;$CA55
        .byte   $0f, $d2, $06, $47, $f4, $0c, $8f, $0f                  ;$CA5D
        .byte   $d2, $f4, $0c, $8f, $0f, $d2, $f5, $0c                  ;$CA65
        .byte   $8f, $0f, $d2, $05, $98, $f4, $0c, $8f                  ;$CA6D
        .byte   $0f, $d2, $f5, $0e, $18, $10, $c3, $05                  ;$CA75
        .byte   $47, $f4, $0e, $18, $10, $c3, $f5, $02                  ;$CA7D
        .byte   $d2, $12, $d1, $04, $b4, $f4, $04, $30                  ;$CA85
        .byte   $04, $35, $85, $10, $c3, $15, $1f, $19                  ;$CA8D
        .byte   $1e, $83, $19, $1e, $f5, $10, $c3, $15                  ;$CA95
        .byte   $1f, $21, $87, $f5, $04, $30, $04, $35                  ;$CA9D
        .byte   $2a, $3e, $f5, $10, $c3, $15, $1f, $32                  ;$CAA5
        .byte   $3c, $f4, $10, $c3, $15, $1f, $f4, $04                  ;$CAAD
        .byte   $30, $04, $35, $f4, $10, $c3, $15, $1f                  ;$CAB5
        .byte   $f4, $03, $23, $03, $24, $85, $10, $c3                  ;$CABD
        .byte   $16, $60, $25, $a2, $83, $25, $a2, $f5                  ;$CAC5
        .byte   $10, $c3, $16, $60, $2c, $c1, $f5, $03                  ;$CACD
        .byte   $23, $03, $24, $32, $3c, $f5, $10, $c3                  ;$CAD5
        .byte   $16, $60, $38, $63, $f5, $10, $c3, $16                  ;$CADD
        .byte   $60, $32, $3c, $f5, $03, $23, $03, $24                  ;$CAE5
        .byte   $2a, $3e, $f5, $10, $c3, $16, $60, $25                  ;$CAED
        .byte   $a2, $f5, $04, $30, $04, $35, $2a, $3e                  ;$CAF5
        .byte   $f5, $10, $c3, $15, $1f, $21, $87, $f5                  ;$CAFD
        .byte   $10, $c3, $15, $1f, $19, $1e, $f5, $04                  ;$CB05
        .byte   $30, $04, $35, $38, $63, $f4, $10, $c3                  ;$CB0D
        .byte   $15, $1f, $f4, $10, $c3, $15, $1f, $f4                  ;$CB15
        .byte   $04, $30, $04, $35, $f4, $10, $c3, $15                  ;$CB1D
        .byte   $1f, $f5, $04, $b4, $04, $b8, $25, $a2                  ;$CB25
        .byte   $f4, $12, $d1, $16, $60, $f4, $12, $d1                  ;$CB2D
        .byte   $16, $60, $f4, $09, $68, $09, $6a, $f4                  ;$CB35
        .byte   $12, $d1, $16, $60, $f4, $12, $d1, $16                  ;$CB3D
        .byte   $60, $f4, $04, $b4, $04, $b8, $57, $06                  ;$CB45
        .byte   $06, $08, $48, $48, $6b, $12, $d1, $16                  ;$CB4D
        .byte   $60, $25, $a2, $38, $2a, $3e, $58, $06                  ;$CB55
        .byte   $47, $06, $4f, $2c, $c1, $5f, $10, $c3                  ;$CB5D
        .byte   $16, $60, $2a, $3e, $4f, $10, $c3, $16                  ;$CB65
        .byte   $60, $5f, $06, $47, $06, $4f, $21, $87                  ;$CB6D
        .byte   $5f, $10, $c3, $1c, $31, $2c, $c1, $5f                  ;$CB75
        .byte   $10, $c3, $1c, $c1, $2a, $3e, $4f, $06                  ;$CB7D
        .byte   $47, $06, $4f, $5f, $0e, $18, $16, $60                  ;$CB85
        .byte   $21, $87, $df, $11, $11, $11, $f5, $1c                  ;$CB8D
        .byte   $31, $21, $87, $2c, $c1, $f5, $1c, $31                  ;$CB95
        .byte   $21, $87, $2a, $3e, $f4, $19, $1e, $1f                  ;$CB9D
        .byte   $a5, $f5, $19, $1f, $1f, $a5, $21, $87                  ;$CBA5
        .byte   $f5, $16, $60, $1c, $31, $2c, $c1, $f5                  ;$CBAD
        .byte   $16, $60, $1c, $31, $2a, $3e, $f4, $15                  ;$CBB5
        .byte   $1f, $19, $1e, $f5, $15, $1f, $19, $1e                  ;$CBBD
        .byte   $21, $87, $5d, $21, $41, $41, $06, $47                  ;$CBC5
        .byte   $2c, $c1, $38, $63, $18, $07, $0c, $58                  ;$CBCD
        .byte   $07, $e9, $2a, $3e, $32, $3c, $18, $08                  ;$CBD5
        .byte   $61, $18, $09, $68, $18, $0a, $8f, $58                  ;$CBDD
        .byte   $0b, $30, $21, $87, $2a, $3e, $18, $0c                  ;$CBE5
        .byte   $8f, $58, $0e, $18, $2c, $c1, $38, $63                  ;$CBED
        .byte   $18, $0f, $d2, $58, $10, $c3, $2a, $3e                  ;$CBF5
        .byte   $32, $3c, $18, $12, $d1, $18, $15, $1f                  ;$CBFD
        .byte   $18, $16, $60, $58, $19, $1e, $21, $87                  ;$CC05
        .byte   $2a, $3e, $18, $1c, $31, $58, $1f, $a5                  ;$CC0D
        .byte   $2c, $c1, $32, $3c, $5f, $1f, $a5, $2c                  ;$CC15
        .byte   $c1, $32, $3c, $58, $1f, $a5, $2c, $c1                  ;$CC1D
        .byte   $32, $3c, $58, $1f, $a5, $2c, $c1, $32                  ;$CC25
        .byte   $3c, $ff, $ff, $f5, $06, $47, $2c, $c1                  ;$CC2D
        .byte   $4b, $45, $5f, $04, $30, $2a, $3e, $43                  ;$CC35
        .byte   $0f, $18, $02, $f6, $18, $03, $23, $18                  ;$CC3D
        .byte   $02, $a3, $18, $04, $b4, $18, $04, $30                  ;$CC45
        .byte   $18, $03, $f4, $18, $04, $30, $48, $03                  ;$CC4D
        .byte   $86, $07, $0c, $48, $03, $23, $06, $47                  ;$CC55
        .byte   $48, $02, $a3, $05, $47, $48, $03, $23                  ;$CC5D
        .byte   $06, $47, $48, $04, $b4, $09, $68, $48                  ;$CC65
        .byte   $04, $30, $08, $61, $48, $03, $f4, $07                  ;$CC6D
        .byte   $e9, $48, $04, $30, $08, $61, $48, $07                  ;$CC75
        .byte   $0c, $0e, $18, $48, $05, $ed, $0b, $da                  ;$CC7D
        .byte   $48, $06, $47, $0c, $8f, $48, $08, $61                  ;$CC85
        .byte   $10, $c3, $48, $0a, $8f, $15, $1f, $ff                  ;$CC8D
        .byte   $ff, $85, $06, $47, $0f, $d2, $32, $3c                  ;$CC95
        .byte   $85, $05, $98, $0e, $18, $38, $63, $85                  ;$CC9D
        .byte   $05, $47, $0c, $8f, $3b, $be, $85, $04                  ;$CCA5
        .byte   $b4, $0b, $30, $3f, $4b, $f5, $04, $30                  ;$CCAD
        .byte   $0a, $8f, $43, $0f, $f5, $04, $30, $0a                  ;$CCB5
        .byte   $8f, $43, $0f, $f5, $04, $30, $0a, $8f                  ;$CCBD
        .byte   $43, $0f, $57, $08, $08, $08, $86, $86                  ;$CCC5
        .byte   $86, $04, $30, $0a, $8f, $43, $0f, $ff                  ;$CCCD
        .byte   $9f, $00                                                ;$CCD5

;$CCD7

;$CCD7..$D000 should be free