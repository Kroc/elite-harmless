; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "code_sound.asm":
;
; sound driver
;
.linecont+

ZP_SOUND_ADDR           := $c2
ZP_SOUND_ADDR_LO        := $c2
ZP_SOUND_ADDR_HI        := $c3

ZP_SOUND_START          := $c4
ZP_SOUND_START_LO       := $c4
ZP_SOUND_START_HI       := $c5

ZP_C6                   := $c6  ;?
ZP_C7                   := $c7  ;?
ZP_C8                   := $c8  ;?
ZP_C9                   := $c9  ;?
ZP_CA                   := $ca  ;?
ZP_CB                   := $cb  ;?
ZP_CC                   := $cc  ;?

ZP_SOUND_TOKEN          := $d1

.segment        "CODE_SOUND"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
_b4cb:                                                                  ;$B4CB
        .byte   $00
voice1_ctrl:    .byte   $00                                             ;$B4CC
voice2_ctrl:    .byte   $00                                             ;$B4CD
voice3_ctrl:    .byte   $00                                             ;$B4CE
_b4cf:                                                                  ;$B4CF
        .byte   $00

; address of sound data to play
;-------------------------------------------------------------------------------
sound_play_addr:
sound_play_addr_lo:                                                     ;$B4D0
        .byte   $88
sound_play_addr_hi:                                                     ;$B4D1
        .byte   $88

_b4d2:                                                                  ;$B4D2
;===============================================================================
        ldy # $00
        cpy ZP_C6
       .bze sound_read_token
        
        dec ZP_C6
        jmp _b6e2

sound_read_token:                                                       ;$B4DD
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
        sta @jmp+1              ; modify the `jmp` below, lo
        lda _b71e-1, x          ; load token function address, hi
        sta @jmp+2              ; modify the `jmp` below, hi

@jmp:   jmp sound_read_token                                            ;$B502

_b505:                                                                  ;$B505
;===============================================================================
        jsr get_voice1_freq
        jsr set_voice1_ctrl

        jmp sound_read_token

_b50e:                                                                  ;$B50E
;===============================================================================
        jsr get_voice2_freq
        jsr set_voice2_ctrl

        jmp sound_read_token

_b517:                                                                  ;$B517
;===============================================================================
        jsr get_voice3_freq
        jsr set_voice3_ctrl
        
        jmp sound_read_token

_b520:                                                                  ;$B520
;===============================================================================
        jsr get_voice1_freq
        jsr get_voice2_freq
        jsr set_voice1_ctrl
        jsr set_voice2_ctrl
        
        jmp sound_read_token

_b52f:                                                                  ;$B52F
;===============================================================================
        jsr get_voice1_freq
        jsr get_voice2_freq
        jsr get_voice3_freq
        jsr set_voice1_ctrl
        jsr set_voice2_ctrl
        jsr set_voice3_ctrl
        
        jmp sound_read_token

_b544:                                                                  ;$B544
;===============================================================================
        inc _b4cb
        
        jmp sound_read_token

_b54a:                                                                  ;$B54A
;===============================================================================
; shifts the token up into the high nybble and replaces the low nybble with
; token `%1000`. e.g.
;
;       0000_0101 -> 0000_1011 -> 0001_0110 -> 0010_1100 -> 0101_1000
;-------------------------------------------------------------------------------
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
        sta ZP_C6

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
        
        jmp sound_read_token

token_loop:                                                             ;$B582
;===============================================================================
        lda # %00000000         ; clear current token(s);
        sta ZP_SOUND_TOKEN      ; another will be read automatically

        ; loop the sound
        lda ZP_SOUND_START_LO
        sta ZP_SOUND_ADDR_LO
        lda ZP_SOUND_START_HI
        sta ZP_SOUND_ADDR_HI
        
        jmp sound_read_token

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

        jmp sound_read_token

token_lxxp:                                                             ;$B5B8
;===============================================================================
        jmp token_loop

_b5bb:                                                                  ;$B5BB
;===============================================================================
        jsr next_byte
        sta _b4cf
        
        jmp sound_read_token

token_control:                                                          ;$B5C4
;===============================================================================
        jsr next_byte
        sta voice1_ctrl
        jsr next_byte
        sta voice2_ctrl
        jsr next_byte
        sta voice3_ctrl

        jmp sound_read_token

token_volume_filter:                                                    ;$B5D9
;===============================================================================
        jsr next_byte
        sta SID_VOLUME_CTRL
        jsr next_byte
        sta SID_FILTER_CTRL
        jsr next_byte
        sta SID_FILTER_FREQ_HI

        jmp sound_read_token

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
        sta ZP_C9
        sta ZP_CB
        
        jsr next_byte
        sta SID_VOICE2_FREQ_LO
        sta ZP_CA
        sta ZP_CC
        
        clc 
        cld 
        lda # $20
        adc ZP_CC
        sta ZP_CC
        bcc :+
        inc ZP_CB

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
        sta ZP_C6
        sta ZP_C7
        sta ZP_C8

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
        sta ZP_C7
        
        lda #< _b6ae
        sta _b6f0+1
        
        lda ZP_CB
        sta SID_VOICE2_FREQ_HI
_b698:                                                                  ;$B698
        lda ZP_CC
        sta SID_VOICE2_FREQ_LO
        
        jmp _b6f2

_b6a0:                                                                  ;$B6A0
;===============================================================================
        lda # $00
        sta ZP_C7

        lda #< _b698
        sta _b6f0+1
        
        lda ZP_C9
        sta SID_VOICE2_FREQ_HI
_b6ae:                                                                  ;$B6AE
        lda ZP_CA
        sta SID_VOICE2_FREQ_LO

        jmp _b6f2

        ;-----------------------------------------------------------------------

;$b6b6:
        lda # $00
        sta ZP_C8

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
        sta ZP_C8

        lda #< _b6cc
        sta _b6e8+1
        
        lda $cd
        sta SID_VOICE3_FREQ_HI
        lda $ce
        sta SID_VOICE3_FREQ_LO

        jmp _b6f2

_b6e2:                                                                  ;$B6E2
;===============================================================================
        inc ZP_C8
        lda # 5
        cmp ZP_C8
_b6e8:                                                                  ;$B6E8
        beq _b6cc
        inc ZP_C7
        lda # $04
        cmp ZP_C7
_b6f0:                                                                  ;$B6F0
        beq _b6a0
_b6f2:                                                                  ;$B6F2
        ldx ZP_C6
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

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

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
