; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this is the 'key' used to scramble / unscramble the message token symbols
.export MSG_XOR := $57

.enum   msg_pairs
        AB               =$D8
        OU              ;=$D9
        SE              ;=$DA
        IT              ;=$DB
        IL              ;=$DC
        ET              ;=$DD
        ST              ;=$DE
        ON              ;=$DF
        LO              ;=$E0
        NU              ;=$E1
        TH              ;=$E2
        NO              ;=$E3
.endenum

.AB             = msg_pairs::AB ^ MSG_XOR ;=$8F
.OU             = msg_pairs::OU ^ MSG_XOR ;=$8E
.SE             = msg_pairs::SE ^ MSG_XOR ;=$8D
.IT             = msg_pairs::IT ^ MSG_XOR ;=$8C
.IL             = msg_pairs::IL ^ MSG_XOR ;=$8B
.ET             = msg_pairs::ET ^ MSG_XOR ;=$8A
.ST             = msg_pairs::ST ^ MSG_XOR ;=$89
.ON             = msg_pairs::ON ^ MSG_XOR ;=$88
.LO             = msg_pairs::LO ^ MSG_XOR ;=$B7
.NU             = msg_pairs::NU ^ MSG_XOR ;=$B6
.TH             = msg_pairs::TH ^ MSG_XOR ;=$B5
.NO             = msg_pairs::NO ^ MSG_XOR ;=$B4

__end           = $00 ^ MSG_XOR ;=$57
__              = $20 ^ MSG_XOR ;=$77
_DOT            = $2E ^ MSG_XOR ;=$79
_A              = $41 ^ MSG_XOR ;=$16
_B              = $42 ^ MSG_XOR ;=$15
_C              = $43 ^ MSG_XOR ;=$14
_D              = $44 ^ MSG_XOR ;=$13
_E              = $45 ^ MSG_XOR ;=$12
_F              = $46 ^ MSG_XOR ;=$11
_G              = $47 ^ MSG_XOR ;=$10
_H              = $48 ^ MSG_XOR ;=$1F
_I              = $49 ^ MSG_XOR ;=$1E
_J              = $4a ^ MSG_XOR ;=$1D
_K              = $4b ^ MSG_XOR ;=$1C
_L              = $4c ^ MSG_XOR ;=$1B
_M              = $4d ^ MSG_XOR ;=$1A
_N              = $4e ^ MSG_XOR ;=$19
_O              = $4f ^ MSG_XOR ;=$18
_P              = $50 ^ MSG_XOR ;=$07
_Q              = $51 ^ MSG_XOR ;=$06
_R              = $52 ^ MSG_XOR ;=$05
_S              = $53 ^ MSG_XOR ;=$04
_T              = $54 ^ MSG_XOR ;=$03
_U              = $55 ^ MSG_XOR ;=$02
_V              = $56 ^ MSG_XOR ;=$01
_W              = $57 ^ MSG_XOR ;=$00
_X              = $58 ^ MSG_XOR ;=$0F
_Y              = $59 ^ MSG_XOR ;=$0E
_Z              = $5a ^ MSG_XOR ;=$0D
_HYPHEN         = $2d ^ MSG_XOR ;=$7A
_COLON          = $3a ^ MSG_XOR ;=$6D

; format tokens -- function varies
_F01_           = $01 ^ MSG_XOR ;=$56
_F02_           = $02 ^ MSG_XOR ;=$55
_F03_           = $03 ^ MSG_XOR ;=$54
_F04_           = $04 ^ MSG_XOR ;=$53
_F05_           = $05 ^ MSG_XOR ;=$52
_F06_           = $06 ^ MSG_XOR ;=$51
_F07_           = $07 ^ MSG_XOR ;=$50
_F08_           = $08 ^ MSG_XOR ;=$5F
_F09_           = $09 ^ MSG_XOR ;=$5E
_F0A_           = $0A ^ MSG_XOR ;=$5D
_F0B_           = $0B ^ MSG_XOR ;=$5C
_F0C_           = $0C ^ MSG_XOR ;=$5B
_F0D_           = $0D ^ MSG_XOR ;=$5A
_F0E_           = $0E ^ MSG_XOR ;=$59
_F0F_           = $0F ^ MSG_XOR ;=$58
_F10_           = $10 ^ MSG_XOR ;=$47
_F11_           = $11 ^ MSG_XOR ;=$46
_F12_           = $12 ^ MSG_XOR ;=$45
_F13_           = $13 ^ MSG_XOR ;=$44
_F14_           = $14 ^ MSG_XOR ;=$43
_F15_           = $15 ^ MSG_XOR ;=$42
_F16_           = $16 ^ MSG_XOR ;=$41
_F17_           = $17 ^ MSG_XOR ;=$40
_F18_           = $18 ^ MSG_XOR ;=$4F
_F19_           = $19 ^ MSG_XOR ;=$4E
_F1A_           = $1A ^ MSG_XOR ;=$4D
_F1B_           = $1B ^ MSG_XOR ;=$4C
_F1C_           = $1C ^ MSG_XOR ;=$4B
_F1D_           = $1D ^ MSG_XOR ;=$4A
_F1E_           = $1E ^ MSG_XOR ;=$49
_F1F_           = $1F ^ MSG_XOR ;=$48

;===============================================================================

_msg_index     .set 0

.macro  .define_msg     msg_id
        
        .local  _value
        _value  .set 0

        _value .set _msg_index ^ MSG_XOR
        
        .ident(msg_id) = _value

        ; define an export for the index-number of the message;
        ; this is how the outside world will specify the message to print
        .export .ident(.concat("MSG", msg_id)) = _msg_index

        ;;.out .sprintf(": $%0.2x: MSG%s", _msg_index, msg_id)

        ; move to the next index number:
        ; doing this afterwards ensures that there is an index 0
        _msg_index .set _msg_index + 1
.endmacro

.define .skip_msg       _msg_index .set _msg_index + 1

;===============================================================================

.segment        "TEXT_0E00"

_0e00:
.export _0e00
        ; 0.
        .byte   __end
        .skip_msg

        ; 1.
        .byte   _F09_, _F0B_, _F01_, _F08_, __, _F1E_, __
        .byte   _A, _C, $be, _S, _S, __, _M, _E
        .byte   .NU, $80, _F0A_, _F02_, $66, _DOT, __, $c2
        .byte   $80, $65, _DOT, __, _S, _A, $ad, __
        .byte   $cd, __, _F04_, $80, $64, _DOT, __, _C
        .byte   _H, $a8, $b0, $9e, _F1F_, $80, $63, _DOT
        .byte   __, _D, _E, _F, _A, _U, _L, _T
        .byte   __, _F01_, _J, _A, _M, _E, _S, _O
        .byte   _N, _F02_, $80, $62, _DOT, __, _E, _X
        .byte   .IT, $80, __end
        .define_msg "_01"
        
        ; 2.
        .byte   $a6, _S, _K, __end
        .define_msg "_02"
        
        ; 3.
        .byte   _T, _A, _P, _E, __end
        .define_msg "_03"
        
        ; 4.
        .byte   _C, _O, _M, _P, _E, $ac, $ac, .ON, __, .NU, _M, _B
        .byte   $a3, _COLON, __end
        .define_msg "_04"
        
        ; 5.
        .byte   $e7, $3a, $9d, $39, $e6, __end
        .define_msg "_05"
        
        ; 6.
        .byte   __, __, $c2, __, _F01_, $7f, _Y
        .byte   $78, _N, $7e, $68, _F02_, _F0C_, _F0C_, __end
        .define_msg "_06"

        ; 7.
        .byte   _P, $a5, _S, _S, __, _S, _P, _A
        .byte   $be, __, $aa, __, _F, _I, $a5, $7b
        .byte   $cd, _DOT, _F0C_, _F0C_, __end
        .define_msg "_07"
        
        ; 8.
        .byte   $cd, $70, _S, $9f, __end
        .define_msg "_08"
        
        ; 9.
        .byte   _F0C_, _F01_, .IL, $b2, _G, $b3
        .byte   __, _E, _L, _I, _T, _E, __, _I
        .byte   _I, __, _F, _I, $b2, __end
        .define_msg "_09"
        
        ; 10.
        .byte   _F17_, _F0E_
        .byte   _F02_, _G, $a5, .ET, $a7, _G, _S, $82
        .byte   $e5, _F13_, _I, __, $a0, _G, $87, _M
        .byte   _O, _M, $a1, _T, __, _O, _F, __
        .byte   $e4, _R, __, _V, $b3, _U, .AB, $b2
        .byte   __, $ac, _M, _E, $9b, _W, _E, __
        .byte   _W, .OU, _L, _D, __, _L, _I, _K
        .byte   _E, __, $e4, $9e, _D, _O, $87, _L
        .byte   .IT, _T, $b2, __, _J, _O, _B, __
        .byte   _F, $aa, __, $bb, $9b, $c4, $98, __
        .byte   $e4, __, .SE, _E, __, _H, _E, $a5
        .byte   $9d, _A, $85, _M, _O, _D, _E, _L
        .byte   $7b, __, $c4, _F13_, _C, .ON, .ST, _R
        .byte   _I, _C, _T, $aa, $7b, __, _E, $a9
        .byte   _I, _P, $93, _W, _I, .TH, $87, _T
        .byte   _O, _P, __, .SE, _C, _R, .ET, $85
        .byte   _S, _H, _I, _E, _L, _D, __, _G
        .byte   $a1, $a3, $a2, $aa, $9b, _U, _N, _F
        .byte   $aa, _T, _U, _N, $a2, _E, _L, _Y
        .byte   __, .IT, $70, _S, __, $a0, $a1, __
        .byte   .ST, _O, _L, $a1, $9b, _F16_, .IT, __
        .byte   _W, $a1, _T, __, _M, _I, _S, _S
        .byte   $94, _F, _R, _O, _M, __, .OU, _R
        .byte   __, $98, __, _Y, $b9, _D, __, .ON
        .byte   __, _F13_, $b1, $a3, __, _F, _I, $ad
        .byte   __, _M, .ON, .TH, _S, __, _A, _G
        .byte   _O, $e5, _F1C_, $9b, $e4, _R, __, _M
        .byte   _I, _S, _S, _I, .ON, $7b, __, _S
        .byte   _H, .OU, _L, _D, __, $e4, __, _D
        .byte   _E, _C, _I, _D, _E, $9e, _A, _C
        .byte   $be, _P, _T, __, .IT, $7b, __, _I
        .byte   _S, $9e, .SE, _E, _K, $e5, _D, $ba
        .byte   _T, _R, _O, _Y, __, $c3, $98, $9b
        .byte   $e4, __, _A, $a5, __, _C, _A, _U
        .byte   $ac, .ON, $93, .TH, $a2, __, .ON, _L
        .byte   _Y, __, _F06_, $22, _F05_, _S, __, _W
        .byte   .IL, _L, __, _P, $a1, .ET, $af, _T
        .byte   _E, __, $c4, _N, _E, _W, __, _S
        .byte   _H, _I, _E, _L, _D, _S, $e5, .TH
        .byte   $a2, __, $c4, _F13_, _C, .ON, .ST, _R
        .byte   _I, _C, _T, $aa, $9d, _F, .IT, _T
        .byte   $93, _W, _I, .TH, __, $a8, __, _F06_
        .byte   $3b, _F05_, $e6, _F02_, _F08_, _G, _O, _O
        .byte   _D, __, _L, _U, _C, _K, $7b, __
        .byte   $cd, $83, _F16_, __end
        .define_msg "_0A"
        
        ; 11.
        .byte   _F19_, _F09_, _F17_, _F0E_
        .byte   _F02_, __, __, $a2, _T, $a1, $ac, .ON
        .byte   $82, _DOT, __, _F13_, _W, _E, __, _H
        .byte   _A, $ad, __, _N, _E, $93, _O, _F
        .byte   __, $e4, _R, __, .SE, _R, _V, _I
        .byte   _C, $ba, __, _A, _G, _A, $a7, $9b
        .byte   _I, _F, __, $e4, __, _W, .OU, _L
        .byte   _D, __, $a0, __, $bc, __, _G, _O
        .byte   _O, _D, __, _A, _S, $9e, _G, _O
        .byte   $9e, _F13_, $be, $a3, $a6, __, $e4, __
        .byte   _W, .IL, _L, __, $a0, __, _B, _R
        .byte   _I, _E, _F, $ab, $9b, _I, _F, __
        .byte   _S, _U, _C, $be, _S, _S, _F, _U
        .byte   _L, $7b, __, $e4, __, _W, .IL, _L
        .byte   __, $a0, __, _W, _E, _L, _L, __
        .byte   $a5, _W, $b9, _D, $ab, $83, _F18_, __end
        .define_msg "_0B"

        ; 12.
        .byte   $7f, _F13_, _C, $7e, $92, __, $66, $6e
        .byte   $6f, $62, __end
        .define_msg "_0C"
        
        ; 13.
        .byte   _B, _Y, $92, __end
        .define_msg "_0D"

        ; 14.
        .byte   _F15_, $c6, $9f, _F1A_, __end
        .define_msg "_0E"

        ; 15.
        .byte   _F19_, _F09_, _F17_, _F0E_
        .byte   _F02_, __, __, _C, .ON, _G, $af, _T
        .byte   _U, $ae, $ac, .ON, _S, __, $cd, $76
        .byte   _F0C_, _F0C_, .TH, $a3, _E, _F0D_, __, _W
        .byte   .IL, _L, __, $b3, _W, _A, _Y, _S
        .byte   __, $a0, $87, _P, $ae, $be, __, _F
        .byte   $aa, __, $e4, __, $a7, $84, $9b, $a8
        .byte   _D, __, $b8, _Y, $a0, __, $bc, .ON
        .byte   $a3, __, .TH, $a8, __, $e4, __, .TH
        .byte   $a7, _K, _DOT, _DOT, $83, _F18_, __end
        .define_msg "_0F"

        ; 16.
        .byte   _F, .AB, $b2, _D, __end
        .define_msg "_10"

        ; 17.
        .byte   .NO, _T, .AB, $b2, __end
        .define_msg "_11"

        ; 18.
        .byte   _W, _E, _L, _L, __, _K, .NO, _W, _N, __end
        .define_msg "_12"

        ; 19.
        .byte   _F, _A, _M, _O, $bb, __end
        .define_msg "_13"

        ; 20.
        .byte   .NO, _T, $ab, __end
        .define_msg "_14"

        ; 21.
        .byte   $ad, _R, _Y, __end
        .define_msg "_15"

        ; 22.
        .byte   _M, .IL, _D, _L, _Y, __end
        .define_msg "_16"

        ; 23.
        .byte   _M, _O, .ST, __end
        .define_msg "_17"

        ; 24.
        .byte   $a5, _A, _S, .ON, .AB, _L, _Y, __end
        .define_msg "_18"

        ; 25.
        .byte   __end
        .define_msg "_19"
        
        ; 26.
        .byte   $f2, __end
        .define_msg "_1A"

        ; 27.
        .byte   $25, __end
        .define_msg "_1B"

        ; 28.
        .byte   _G, $a5, $a2, __end
        .define_msg "_1C"
        
        ; 29.
        .byte   _V, _A, .ST, __end
        .define_msg "_1D"

        ; 30.
        .byte   _P, $a7, _K, __end
        .define_msg "_1E"
        
        ; 31.
        .byte   _F02_, $20, __, $21
        .byte   _F0D_, __, $ee, _A, $ac, .ON, _S, __end
        .define_msg "_1F"

        ; 32.
        .byte   $cb, _S, __end
        .define_msg "_20"

        ; 33.
        .byte   $22, __end
        .define_msg "_21"
        
        ; 34.
        .byte   $d7, __, _F, $aa, $ba, _T, _S, __end
        .define_msg "_22"
        
        ; 35.
        .byte   _O, $be, $a8, _S, __end
        .define_msg "_23"
        
        ; 36.
        .byte   _S, _H, _Y, _N, $ba, _S, __end
        .define_msg "_24"
        
        ; 37.
        .byte   _S, .IL, _L, $a7, $ba, _S, __end
        .define_msg "_25"
        
        ; 38.
        .byte   $b8, _T, $94, _T, $af, $a6, $ac, .ON, _S, __end
        .define_msg "_26"
        
        ; 39.
        .byte   .LO, $a2, _H, $94, _O, _F, __, $33, __end
        .define_msg "_27"
        
        ; 40.
        .byte   .LO, $ad, __, _F, $aa, __, $33, __end
        .define_msg "_28"
        
        ; 41.
        .byte   _F, _O, _O, _D, __, _B, $b2, _N, _D, $a3, _S, __end
        .define_msg "_29"
        
        ; 42.
        .byte   _T, .OU, _R, _I, .ST, _S, __end
        .define_msg "_2A"
        
        ; 43.
        .byte   _P, _O, .ET, _R, _Y, __end
        .define_msg "_2B"
        
        ; 44.
        .byte   $a6, _S, _C, _O, _S, __end
        .define_msg "_2C"
        
        ; 45.
        .byte   $3b, __end
        .define_msg "_2D"
        
        ; 46.
        .byte   _W, $b3, _K, $94, $c9, __end
        .define_msg "_2E"
        
        ; 47.
        .byte   _C, $af, _B, __end
        .define_msg "_2F"
        
        ; 48.
        .byte   _B, $a2, __end
        .define_msg "_30"
        
        ; 49.
        .byte   .LO, _B, .ST, __end
        .define_msg "_31"
        
        ; 50.
        .byte   _F12_, __end
        .define_msg "_32"
        
        ; 51.
        .byte   $a0, _S, .ET, __end
        .define_msg "_33"
        
        ; 52.
        .byte   _P, $ae, _G, _U, $ab, __end
        .define_msg "_34"
        
        ; 53.
        .byte   $af, _V, _A, _G, $ab, __end
        .define_msg "_35"
        
        ; 54.
        .byte   _C, _U, _R, _S, $ab, __end
        .define_msg "_36"
        
        ; 55.
        .byte   _S, _C, .OU, _R, _G, $ab, __end
        .define_msg "_37"
        
        ; 56.
        .byte   $26, __, _C, _I, _V, .IL, __, _W, $b9, __end
        .define_msg "_38"
        
        ; 57.
        .byte   $3f, __, $08, __, $37, _S, __end
        .define_msg "_39"
        
        ; 58.
        .byte   _A, __, $3f, __, $a6, .SE, _A, .SE, __end
        .define_msg "_3A"
        
        ; 59.
        .byte   $26, __, _E, $b9, .TH, $a9, _A, _K, $ba, __end
        .define_msg "_3B"
        
        ; 60.
        .byte   $26, __, $bc, $ae, _R, __, _A, _C
        .byte   $ac, _V, .IT, _Y, __end
        .define_msg "_3C"
        
        ; 61.
        .byte   $f8, $0a, __, $09, __end
        .define_msg "_3D"
        
        ; 62.
        .byte   $c4, _F11_, __, $08, __, $37, __end
        .define_msg "_3E"
        
        ; 63.
        .byte   $f8, $96, _S, $70, __, $35, __, $34, __end
        .define_msg "_3F"
        
        ; 64.
        .byte   _F02_, $2d, _F0D_, __end
        .define_msg "_40"
        
        ; 65.
        .byte   $f8, $3c, __, $3b, __end
        .define_msg "_41"
        
        ; 66.
        .byte   _J, _U, _I, $be, __end
        .define_msg "_42"
        
        ; 67.
        .byte   _B, $af, _N, _D, _Y, __end
        .define_msg "_43"
        
        ; 68.
        .byte   _W, $a2, $a3, __end
        .define_msg "_44"
        
        ; 69.
        .byte   _B, $a5, _W, __end
        .define_msg "_45"
        
        ; 70.
        .byte   _G, $b9, _G, $b2, __, _B, $ae, .ST, $a3, _S, __end
        .define_msg "_46"
        
        ; 71.
        .byte   _F12_, __end
        .define_msg "_47"
        
        ; 72.
        .byte   _F11_, __, $37, __end
        .define_msg "_48"
        
        ; 73.
        .byte   _F11_, __, _F12_, __end
        .define_msg "_49"
        
        ; 74.
        .byte   _F11_, __, $3f, __end
        .define_msg "_4A"
        
        ; 75.
        .byte   $3f, __, _F12_, __end
        .define_msg "_4B"
        
        ; 76.
        .byte   _F, .AB, _U, .LO, $bb, __end
        .define_msg "_4C"
        
        ; 77.
        .byte   _E, _X, _O, $ac, _C, __end
        .define_msg "_4D"
        
        ; 78.
        .byte   _H, _O, _O, _P, _Y, __end
        .define_msg "_4E"
        
        ; 79.
        .byte   _U, .NU, _S, _U, $b3, __end
        .define_msg "_4F"
        
        ; 80.
        .byte   _E, _X, _C, .IT, $a7, _G, __end
        .define_msg "_50"
        
        ; 81.
        .byte   _C, _U, _I, _S, $a7, _E, __end
        .define_msg "_51"
        
        ; 82.
        .byte   _N, _I, _G, _H, _T, __, _L, _I, _F, _E, __end
        .define_msg "_52"
        
        ; 83.
        .byte   _C, _A, _S, _I, .NO, _S, __end
        .define_msg "_53"
        
        ; 84.
        .byte   _S, .IT, __, _C, _O, _M, _S, __end
        .define_msg "_54"
        
        ; 85.
        .byte   _F02_, $2d, _F0D_, __end
        .define_msg "_55"
        
        ; 86.
        .byte   _F03_, __end
        .define_msg "_56"
        
        ; 87.
        .byte   $c4, $c6, __, _F03_, __end
        .define_msg "_57"
        
        ; 88.
        .byte   $c4, $c5, __, _F03_, __end
        .define_msg "_58"
        
        ; 89.
        .byte   $c3, $c6, __end
        .define_msg "_59"
        
        ; 90.
        .byte   $c3, $c5, __end
        .define_msg "_5A"
        
        ; 91.
        .byte   _S, .ON, __, _O, _F, $87, _B, .IT, _C, _H, __end
        .define_msg "_5B"
        
        ; 92.
        .byte   _S, _C, .OU, _N, _D, $a5, _L, __end
        .define_msg "_5C"
        
        ; 93.
        .byte   _B, $ae, _C, _K, _G, _U, $b9, _D, __end
        .define_msg "_5D"
        
        ; 94.
        .byte   _R, _O, _G, _U, _E, __end
        .define_msg "_5E"
        
        ; 95.
        .byte   _W, _H, $aa, $ba, .ON
        .byte   __, $a0, .ET, $b2, __, _H, _E, _A
        .byte   _D, $93, _F, $ae, _P, __, _E, $b9
        .byte   $70, _D, __, _K, _N, _A, $ad, __end
        .define_msg "_5F"
        
        ; 96.
        .byte   _N, __, _U, _N, $a5, $b8, _R, _K
        .byte   .AB, $b2, __end
        .define_msg "_60"
        
        ; 97.
        .byte   __, _B, $aa, $a7, _G
        .byte   __end
        .define_msg "_61"
        
        ; 98.
        .byte   __, _D, _U, _L, _L, __end
        .define_msg "_62"
        
        ; 99.
        .byte   __, _T, _E, $a6, _O, $bb, __end
        .define_msg "_63"
        
        ; 100.
        .byte   __, $a5, _V, _O, _L, _T, $a7, _G, __end
        .define_msg "_64"
        
        ; 101.
        .byte   $c6, __end
        .define_msg "_65"
        
        ; 102.
        .byte   $c5, __end
        .define_msg "_66"
        
        ; 103.
        .byte   _P, $ae, $be, __end
        .define_msg "_67"
        
        ; 104.
        .byte   _L, .IT, _T, $b2, __, $c6, __end
        .define_msg "_68"
        
        ; 105.
        .byte   _D, _U, _M, _P, __end
        .define_msg "_69"
        
        ; 106.
        .byte   _I, __, _H, _E, $b9
        .byte   $87, $25, __, .LO, _O, _K, $94, $98
        .byte   __, _A, _P, _P, _E, $b9, $93, $a2
        .byte   $86, __end
        .define_msg "_6A"
        
        ; 107.
        .byte   _Y, _E, _A, _H, $7b, __
        .byte   _I, __, _H, _E, $b9, $87, $25, __
        .byte   $98, __, $b2, _F, _T, $86, $87, __
        .byte   _W, _H, _I, $b2, __, _B, _A, _C
        .byte   _K, __end
        .define_msg "_6B"
        
        ; 108.
        .byte   _G, .ET, __, $e4, _R, __
        .byte   _I, _R, .ON, __, _A, _S, _S, __
        .byte   _O, _V, $a3, __, _T, _O, $86, __end
        .define_msg "_6C"
        
        ; 109.
        .byte   $bc, _M, _E, __, $24, $85, $98, __
        .byte   _W, _A, _S, __, .SE, $a1, __, $a2
        .byte   $86, __end
        .define_msg "_6D"
        
        ; 110.
        .byte   _T, _R, _Y, $86, __end
        .define_msg "_6E"
        
        ; 111.
        .byte   __, _C, _U, _D, _D, _L, _Y, __end
        .define_msg "_6F"
        
        ; 112.
        .byte   __, _C, _U, _T, _E, __end
        .define_msg "_70"
        
        ; 113.
        .byte   __, _F, _U, _R, _R, _Y, __end
        .define_msg "_71"
        
        ; 114.
        .byte   __, _F, _R, _I, $a1, _D, _L, _Y, __end
        .define_msg "_72"
        
        ; 115.
        .byte   _W, _A, _S, _P, __end
        .define_msg "_73"
        
        ; 116.
        .byte   _M, _O, .TH, __end
        .define_msg "_74"
        
        ; 117.
        .byte   _G, _R, _U, _B, __end
        .define_msg "_75"
        
        ; 118.
        .byte   $a8, _T, __end
        .define_msg "_76"
        
        ; 119.
        .byte   _F12_, __end
        .define_msg "_77"
        
        ; 120.
        .byte   _P, _O, .ET, __end
        .define_msg "_78"
        
        ; 121.
        .byte   $b9, _T, _S, __, _G, $af, _D, _U, $a2, _E, __end
        .define_msg "_79"
        
        ; 122.
        .byte   _Y, _A, _K, __end
        .define_msg "_7A"
        
        ; 123.
        .byte   _S, _N, _A, .IL, __end
        .define_msg "_7B"
        
        ; 124.
        .byte   _S, _L, _U, _G, __end
        .define_msg "_7C"
        
        ; 125.
        .byte   _T, _R, _O, _P, _I, _C, $b3, __end
        .define_msg "_7D"
        
        ; 126.
        .byte   _D, $a1, .SE, __end
        .define_msg "_7E"
        
        ; 127.
        .byte   $af, $a7, __end
        .define_msg "_7F"
        
        ; 128.
        .byte   _I, _M, _P, $a1, .ET, $af, _B, $b2, __end
        .define_msg "_80"
        
        ; 129.
        .byte   _E, _X, _U, $a0, $af, _N, _T, __end
        .define_msg "_81"
        
        ; 130.
        .byte   _F, _U, _N, _N, _Y, __end
        .define_msg "_82"
        
        ; 131.
        .byte   _W, _E, _I, _R, _D, __end
        .define_msg "_83"
        
        ; 132.
        .byte   _U, .NU, _S, _U, $b3, __end
        .define_msg "_84"
        
        ; 133.
        .byte   .ST, $af, _N, $b0, __end
        .define_msg "_85"
        
        ; 134.
        .byte   _P, _E, _C, _U, _L, _I, $b9, __end
        .define_msg "_86"
        
        ; 135.
        .byte   _F, $a5, $a9, $a1, _T, __end
        .define_msg "_87"
        
        ; 136.
        .byte   _O, _C, _C, _A, _S, _I, .ON, $b3, __end
        .define_msg "_88"
        
        ; 137.
        .byte   _U, _N, _P, $a5, $a6, _C, _T, .AB, $b2, __end
        .define_msg "_89"
        
        ; 138.
        .byte   _D, $a5, _A, _D, _F, _U, _L, __end
        .define_msg "_8A"
        
        ; 139.
        .byte   $fc, __end
        .define_msg "_8B"

        ; 140.
        .byte   $0b, __, $0c, __, _F, $aa, __, $32, __end
        .define_msg "_8C"
        
        ; 141.
        .byte   $db, $e5, $32, __end
        .define_msg "_8D"
        
        ; 142.
        .byte   $31, __, _B, _Y, __, $30, __end
        .define_msg "_8E"
        
        ; 143.
        .byte   $db, __, _B, _U, _T, __, $d9, __end
        .define_msg "_8F"
        
        ; 144.
        .byte   __, _A, $38, __, $27, __end
        .define_msg "_90"
        
        ; 145.
        .byte   _P, _L, $a8, .ET, __end
        .define_msg "_91"
        
        ; 146.
        .byte   _W, $aa, _L, _D, __end
        .define_msg "_92"
        
        ; 147.
        .byte   .TH, _E, __, __end
        .define_msg "_93"
        
        ; 148.
        .byte   .TH, _I, _S, __, __end
        .define_msg "_94"
        
        ; 149.
        .byte   .LO, _A, _D, $85, $cd, __end
        .define_msg "_95"
        
        ; 150.
        .byte   _F09_, _F0B_, _F01_, _F08_, __end
        .define_msg "_96"
        
        ; 151.
        .byte   _D, _R, _I, $ad, __end
        .define_msg "_97"
        
        ; 152.
        .byte   __, _C, $a2, _A, .LO, _G, _U, _E, __end
        .define_msg "_98"
        
        ; 153.
        .byte   _I, $a8, __end
        .define_msg "_99"
        
        ; 154.
        .byte   _F13_, _C, _O, _M, _M, $a8, _D, $a3, __end
        .define_msg "_9A"
        
        ; 155.
        .byte   $3f, __end
        .define_msg "_9B"
        
        ; 156.
        .byte   _M, .OU, _N, _T, _A, $a7, __end
        .define_msg "_9C"
        
        ; 157.
        .byte   $ab, _I, _B, $b2, __end
        .define_msg "_9D"
        
        ; 158.
        .byte   _T, $a5, _E, __end
        .define_msg "_9E"
        
        ; 159.
        .byte   _S, _P, _O, _T, _T, $ab, __end
        .define_msg "_9F"
        
        ; 160.
        .byte   $2f, __end
        .define_msg "_A0"
        
        ; 161.
        .byte   $2e, __end
        .define_msg "_A1"
        
        ; 162.
        .byte   $36, _O, _I, _D, __end
        .define_msg "_A2"
        
        ; 163.
        .byte   $28, __end
        .define_msg "_A3"
        
        ; 164.
        .byte   $29, __end
        .define_msg "_A4"
        
        ; 165.
        .byte   $a8, _C, _I, $a1, _T, __end
        .define_msg "_A5"
        
        ; 166.
        .byte   _E, _X, $be, _P, $ac, .ON, $b3, __end
        .define_msg "_A6"
        
        ; 167.
        .byte   _E, _C, $be, _N, _T, _R, _I, _C, __end
        .define_msg "_A7"
        
        ; 168.
        .byte   $a7, _G, $af, $a7, $ab, __end
        .define_msg "_A8"
        
        ; 169.
        .byte   $25, __end
        .define_msg "_A9"
        
        ; 170.
        .byte   _K, .IL, _L, $a3, __end
        .define_msg "_AA"
        
        ; 171.
        .byte   _D, _E, _A, _D, _L, _Y, __end
        .define_msg "_AB"
        
        ; 172.
        .byte   _E, _V, .IL, __end
        .define_msg "_AC"
        
        ; 173.
        .byte   $b2, .TH, $b3, __end
        .define_msg "_AD"
        
        ; 174.
        .byte   _V, _I, _C, _I, _O, $bb, __end
        .define_msg "_AE"
        
        ; 175.
        .byte   .IT, _S, __, __end
        .define_msg "_AF"
        
        ; 176.
        .byte   _F0D_, _F0E_, _F13_, __end
        .define_msg "_B0"
        
        ; 177.
        .byte   _DOT, _F0C_, _F0F_, __end
        .define_msg "_B1"
        
        ; 178.
        .byte   __, $a8, _D, __, __end
        .define_msg "_B2"
        
        ; 179.
        .byte   _Y, .OU, __end
        .define_msg "_B3"
        
        ; 180.
        .byte   _P, $b9, _K, $94, _M, .ET, $a3, _S, __end
        .define_msg "_B4"
        
        ; 181.
        .byte   _D, $bb, _T, __, _C, .LO, _U, _D, _S, __end
        .define_msg "_B5"
        
        ; 182.
        .byte   _I, $be, __, $a0, _R, _G, _S, __end
        .define_msg "_B6"
        
        ; 183.
        .byte   _R, _O, _C, _K, __, _F, $aa, $b8
        .byte   $ac, .ON, _S, __end
        .define_msg "_B7"
        
        ; 184.
        .byte   _V, _O, _L, _C, _A, .NO, $ba, __end
        .define_msg "_B8"
        
        ; 185.
        .byte   _P, _L, $a8, _T, __end
        .define_msg "_B9"
        
        ; 186.
        .byte   _T, _U, _L, _I, _P, __end
        .define_msg "_BA"
        
        ; 187.
        .byte   _B, $a8, $a8, _A, __end
        .define_msg "_BB"
        
        ; 188.
        .byte   _C, $aa, _N, __end
        .define_msg "_BC"
        
        ; 189.
        .byte   _F12_, _W, _E, $ab, __end
        .define_msg "_BD"
        
        ; 190.
        .byte   _F12_, __end
        .define_msg "_BE"
        
        ; 191.
        .byte   _F11_, __, _F12_, __end
        .define_msg "_BF"
        
        ; 192.
        .byte   _F11_, __, $3f, __end
        .define_msg "_C0"
        
        ; 193.
        .byte   $a7, _H, _A, $bd, _T, $a8, _T, __end
        .define_msg "_C1"
        
        ; 194.
        .byte   $e8, __end
        .define_msg "_C2"
        
        ; 195.
        .byte   $a7, _G, __, __end
        .define_msg "_C3"
        
        ; 196.
        .byte   $ab, __, __end
        .define_msg "_C4"
        
        ; 197.
        .byte   __, _D, _DOT, _B, $af, $a0, _N, __
        .byte   $71, __, _I, _DOT, $a0, _L, _L, __end
        .define_msg "_C5"
        
        ; 198.
        .byte   __, _L, .IT, _T, $b2, __, _T, _R
        .byte   _U, _M, _B, $b2, __end
        .define_msg "_C6"
        
        ; 199.
        .byte   _F19_, _F09_, _F1D_
        .byte   _F0E_, _F13_, _G, _O, _O, _D, _F0D_, __
        .byte   _D, _A, _Y, __, $cd, __, _F04_, $7b
        .byte   __, $b3, .LO, _W, __, _M, _E, $9e
        .byte   $a7, _T, _R, _O, _D, _U, $be, __
        .byte   _M, _Y, .SE, _L, _F, _DOT, __, _F13_
        .byte   _I, __, _A, _M, _F02_, __, $c4, _M
        .byte   $a3, _C, _H, $a8, _T, __, _P, _R
        .byte   $a7, $be, __, _O, _F, __, .TH, _R
        .byte   _U, _N, _F0D_, $e5, _F13_, _I, __, _F
        .byte   $a7, _D, __, _M, _Y, .SE, _L, _F
        .byte   __, _F, $aa, $be, _D, $9e, .SE, _L
        .byte   _L, __, _M, _Y, __, _M, _O, .ST
        .byte   __, _T, $a5, _A, _S, _U, _R, $ab
        .byte   __, _P, _O, _S, _S, $ba, _S, _I
        .byte   .ON, $9b, _I, __, _A, _M, __, _O
        .byte   _F, _F, $a3, $94, _Y, .OU, $7b, __
        .byte   _F, $aa, __, $c4, _P, _A, _L, _T
        .byte   _R, _Y, __, _S, _U, _M, __, _O
        .byte   _F, __, _J, _U, .ST, __, $62, $67
        .byte   $67, $67, _F13_, _C, _F13_, _R, __, $c4
        .byte   $af, $a5, .ST, __, .TH, $94, __, $a7
        .byte   __, $c4, _F02_, _K, .NO, _W, _N, __
        .byte   _U, _N, _I, $ad, _R, .SE, $9b, _F0D_
        .byte   _W, .IL, _L, __, _Y, .OU, __, _T
        .byte   _A, _K, _E, __, .IT, _F01_, $7f, _Y
        .byte   $78, _N, $7e, $68, _F0C_, _F0F_, _F01_, _F08_
        .byte   __end
        .define_msg "_C7"
        
        ; 200.
        .byte   __, _N, _A, _M, _E, $68, __
        .byte   __end
        .define_msg "_C8"
        
        ; 201.
        .byte   __, _T, _O, __, __end
        .define_msg "_C9"
        
        ; 202.
        .byte   __, _I, _S, __, __end
        .define_msg "_CA"
        
        ; 203.
        .byte   _W, _A, _S, __, $ae
        .byte   .ST, __, .SE, $a1, __, $a2, __, _F13_
        .byte   __end
        .define_msg "_CB"
        
        ; 204.
        .byte   _DOT, _F0C_, __, _F13_, __end
        .define_msg "_CC"
        
        ; 205.
        .byte   _D, _O, _C, _K, $ab, __end
        .define_msg "_CD"
        
        ; 206.
        .byte   _F01_, $7f, _Y, $78, _N, $7e, $68, __end
        .define_msg "_CE"
        
        ; 207.
        .byte   _S, _H, _I, _P, __end
        .define_msg "_CF"
        
        ; 208.
        .byte   __, _A, __, __end
        .define_msg "_D0"
        
        ; 209.
        .byte   __, $a3, _R, _I, $bb, __end
        .define_msg "_D1"
        
        ; 210.
        .byte   __, _N, _E, _W, __, __end
        .define_msg "_D2"
        
        ; 211.
        .byte   _F02_, __, _H, $a3, __, $b8, _J
        .byte   $ba, _T, _Y, $70, _S, __, _S, _P
        .byte   _A, $be, __, _N, _A, _V, _Y, _F0D_
        .byte   __end
        .define_msg "_D3"
        
        ; 212.
        .byte   $e6, _F08_, _F01_, __, __, _M, $ba
        .byte   _S, _A, $b0, __, $a1, _D, _S, __end
        .define_msg "_D4"
        
        ; 213.
        .byte   __, $cd, __, _F04_, $7b, __, _I, __
        .byte   _F0D_, _A, _M, _F02_, __, _C, _A, _P
        .byte   _T, _A, $a7, __, _F1B_, __, _F0D_, _O
        .byte   _F, $84, __end
        .define_msg "_D5"
        
        ; 214.
        .byte   __end
        .define_msg "_D6"
        
        ; 215.
        .byte   _F0F_, __, _U, _N, _K, .NO, _W, _N, __, $c6, __end
        .define_msg "_D7"
        
        ; 216.
        .byte   _F09_, _F08_, _F17_, _F01_, __, $a7, _C, _O, _M
        .byte   $94, _M, $ba, _S, _A, $b0, __end
        .define_msg "_D8"
        
        ; 217.
        .byte   _C, _U, _R, _R, _U, .TH, $a3, _S, __end
        .define_msg "_D9"
        
        ; 218.
        .byte   _F, _O, _S, _D, _Y, _K, _E, __
        .byte   _S, _M, _Y, .TH, _E, __end
        .define_msg "_DA"
        
        ; 219.
        .byte   _F, $aa, _T, $ba, $a9, _E, __end
        .define_msg "_DB"
        
        ; 220.
        .byte   $9c, $a5, $ba, $a6, $be, __end
        .define_msg "_DC"
        
        ; 221.
        .byte   _I, _S, __, $a0, _L
        .byte   _I, _E, _V, $ab, $9e, _H, _A, $ad
        .byte   __, _J, _U, _M, _P, $ab, $9e, $c3
        .byte   _G, $b3, _A, _X, _Y, __end
        .define_msg "_DD"
        
        ; 222.
        .byte   _F19_, _F09_
        .byte   _F1D_, _F0E_, _F02_, _G, _O, _O, _D, __
        .byte   _D, _A, _Y, __, $cd, __, _F04_, $9b
        .byte   _I, _F0D_, __, _A, _M, __, _F13_, _A
        .byte   _G, $a1, _T, __, _F13_, _B, $ae, _K
        .byte   _E, __, _O, _F, __, _F13_, _N, _A
        .byte   _V, $b3, __, _F13_, $a7, _T, _E, _L
        .byte   $b2, _G, $a1, $be, $9b, _A, _S, __
        .byte   $e4, __, _K, .NO, _W, $7b, __, $c4
        .byte   _F13_, _N, _A, _V, _Y, __, _H, _A
        .byte   $ad, __, $a0, $a1, __, _K, _E, _E
        .byte   _P, $94, $c4, _F13_, .TH, $b9, _G, _O
        .byte   _I, _D, _S, __, _O, _F, _F, __
        .byte   $e4, _R, __, _A, _S, _S, __, .OU
        .byte   _T, __, $a7, __, _D, _E, _E, _P
        .byte   __, _S, _P, _A, $be, __, _F, $aa
        .byte   __, $b8, _N, _Y, __, _Y, _E, $b9
        .byte   _S, __, .NO, _W, _DOT, __, _F13_, _W
        .byte   _E, _L, _L, __, $c4, _S, .IT, _U
        .byte   _A, $ac, .ON, __, _H, _A, _S, __
        .byte   _C, _H, $a8, _G, $ab, $9b, .OU, _R
        .byte   __, _B, _O, _Y, _S, __, $b9, _E
        .byte   __, $a5, _A, _D, _Y, __, _F, $aa
        .byte   $87, _P, _U, _S, _H, __, _R, _I
        .byte   _G, _H, _T, $9e, $c4, _H, _O, _M
        .byte   _E, __, _S, _Y, _S, _T, _E, _M
        .byte   __, _O, _F, __, .TH, _O, .SE, __
        .byte   _M, _U, _R, _D, $a3, $a3, _S, $9b
        .byte   _F18_, _F09_, _F1D_, _I, _F0D_, __, _H, _A
        .byte   $ad, __, _O, _B, _T, _A, $a7, $93
        .byte   $c4, _D, _E, _F, $a1, $be, __, _P
        .byte   $ae, _N, _S, __, _F, $aa, __, .TH
        .byte   _E, _I, _R, __, _F13_, _H, _I, $ad
        .byte   __, _F13_, _W, $aa, _L, _D, _S, $9b
        .byte   $c4, $a0, .ET, $b2, _S, __, _K, .NO
        .byte   _W, __, _W, _E, $70, $ad, __, _G
        .byte   _O, _T, __, $bc, _M, _E, .TH, $94
        .byte   _B, _U, _T, __, .NO, _T, __, _W
        .byte   _H, $a2, $9b, _I, _F, __, _F13_, _I
        .byte   __, _T, $af, _N, _S, _M, .IT, __
        .byte   $c4, _P, $ae, _N, _S, $9e, .OU, _R
        .byte   __, _B, _A, .SE, __, .ON, __, _F13_
        .byte   $bd, $a5, $af, __, .TH, _E, _Y, $70
        .byte   _L, _L, __, $a7, _T, $a3, $be, _P
        .byte   _T, __, $c4, _T, _R, $a8, _S, _M
        .byte   _I, _S, _S, _I, .ON, _DOT, __, _F13_
        .byte   _I, __, _N, _E, $ab, $87, $98, $9e
        .byte   $b8, _K, _E, __, $c4, _R, _U, _N
        .byte   $9b, $e4, $70, $a5, __, _E, $b2, _C
        .byte   _T, $ab, $9b, $c4, _P, $ae, _N, _S
        .byte   __, _A, $a5, __, _U, _N, _I, _P
        .byte   _U, _L, .SE, __, _C, _O, _D, $93
        .byte   _W, _I, .TH, $a7, __, $c3, _T, _R
        .byte   $a8, _S, _M, _I, _S, _S, _I, .ON
        .byte   $9b, _F08_, $e4, __, _W, .IL, _L, __
        .byte   $a0, __, _P, _A, _I, _D, $9b, __
        .byte   __, __, __, _F13_, _G, _O, _O, _D
        .byte   __, _L, _U, _C, _K, __, $cd, $83
        .byte   _F18_, __end
        .define_msg "_DE"
        
        ; 223.
        .byte   _F19_, _F09_, _F1D_, _F08_, _F0E_, _F0D_
        .byte   _F13_, _W, _E, _L, _L, __, _D, .ON
        .byte   _E, __, $cd, $9b, $e4, __, _H, _A
        .byte   $ad, __, .SE, _R, _V, $93, _U, _S
        .byte   __, _W, _E, _L, _L, $e5, _W, _E
        .byte   __, _S, _H, $b3, _L, __, $a5, _M
        .byte   _E, _M, _B, $a3, $9b, _W, _E, __
        .byte   _D, _I, _D, __, .NO, _T, __, _E
        .byte   _X, _P, _E, _C, _T, __, $c4, _F13_
        .byte   .TH, $b9, _G, _O, _I, _D, _S, $9e
        .byte   _F, $a7, _D, __, .OU, _T, __, _A
        .byte   _B, .OU, _T, __, $e4, $9b, _F, $aa
        .byte   __, $c4, _M, _O, _M, $a1, _T, __
        .byte   _P, $b2, _A, .SE, __, _A, _C, $be
        .byte   _P, _T, __, $c3, _F13_, _N, _A, _V
        .byte   _Y, __, _F06_, $25, _F05_, __, _A, _S
        .byte   __, _P, _A, _Y, _M, $a1, _T, $83
        .byte   _F18_, __end
        .define_msg "_DF"
        
        ; 224.
        .byte   _A, $a5, __, $e4, __, _S
        .byte   _U, $a5, $68, __end
        .define_msg "_E0"
        
        ; 225.
        .byte   _S, _H, $a5, _W, __end
        .define_msg "_E1"
        
        ; 226.
        .byte   $a0, _A, .ST, __end
        .define_msg "_E2"
        
        ; 227.
        .byte   _B, _I, _S, .ON, __end
        .define_msg "_E3"
        
        ; 228.
        .byte   _S, _N, _A, _K, _E, __end
        .define_msg "_E4"
        
        ; 229.
        .byte   _W, _O, _L, _F, __end
        .define_msg "_E5"
        
        ; 230.
        .byte   $b2, _O, _P, $b9, _D, __end
        .define_msg "_E6"
        
        ; 231.
        .byte   _C, $a2, __end
        .define_msg "_E7"
        
        ; 232.
        .byte   _M, .ON, _K, _E, _Y, __end
        .define_msg "_E8"
        
        ; 233.
        .byte   _G, _O, $a2, __end
        .define_msg "_E9"
        
        ; 234.
        .byte   _F, _I, _S, _H, __end
        .define_msg "_EA"
        
        ; 235.
        .byte   $3d, __, $3e, __end
        .define_msg "_EB"
        
        ; 236.
        .byte   _F11_, __, $2f, __, $2c, __end
        .define_msg "_EC"
        
        ; 237.
        .byte   $f8, $3c, __, $2e, __, $2c, __end
        .define_msg "_ED"
        
        ; 238.
        .byte   $2b, __, $2a, __end
        .define_msg "_EE"
        
        ; 239.
        .byte   $3d, __, $3e, __end
        .define_msg "_EF"
        
        ; 240.
        .byte   _M, _E, $a2, __end
        .define_msg "_F0"
        
        ; 241.
        .byte   _C, _U, _T, _L, .ET, __end
        .define_msg "_F1"
        
        ; 242.
        .byte   .ST, _E, _A, _K, __end
        .define_msg "_F2"
        
        ; 243.
        .byte   _B, _U, _R, _G, $a3, _S, __end
        .define_msg "_F3"
        
        ; 244.
        .byte   $bc, _U, _P, __end
        .define_msg "_F4"
        
        ; 245.
        .byte   _I, $be, __end
        .define_msg "_F5"
        
        ; 246.
        .byte   _M, _U, _D, __end
        .define_msg "_F6"
        
        ; 247.
        .byte   _Z, $a3, _O, _HYPHEN, _F13_, _G, __end
        .define_msg "_F7"
        
        ; 248.
        .byte   _V, _A, _C, _U, _U, _M, __end
        .define_msg "_F8"
        
        ; 249.
        .byte   _F11_, __, _U, _L, _T, $af, __end
        .define_msg "_F9"
        
        ; 250.
        .byte   _H, _O, _C, _K, _E, _Y, __end
        .define_msg "_FA"
        
        ; 251.
        .byte   _C, _R, _I, _C, _K, .ET, __end
        .define_msg "_FB"
        
        ; 252.
        .byte   _K, $b9, $a2, _E, __end
        .define_msg "_FC"
        
        ; 253.
        .byte   _P, _O, .LO, __end
        .define_msg "_FD"
        
        ; 254.
        .byte   _T, $a1, _N, _I, _S, __end
        .define_msg "_FE"
        
        ; 255.
        .byte   _F0C_, _F1E_, __, $a3, _R, $aa
        .define_msg "_FF"

;-------------------------------------------------------------------------------

_1a27:
.export _1a27
        .byte   __end
        .byte   $d3, $96, $24, _K, $fd, _F18_, $35, $76
        .byte   $64, $20, _F13_, $a4, $dc, $6a, _G, $a2
        .byte   _T, $6b, _M, $c0, $b8, _R, $65, $c1
        .byte   $29
        
_1a41:
.export _1a41
        .byte   _V, $80, _W, _W, _W, _V, _V                  
        .byte   _V, _V, $82, _V, _V, _V, _V, _V
        .byte   _V, _V, _V, _V, _V, _V, _V, _V
        .byte   _U, _V, $82, $90
        
;-------------------------------------------------------------------------------

_1a5c:
.export _1a5c
        ; 0.
        .byte   __end
        
        ; 1.
        .byte   $c4, _C, _O
        .byte   .LO, _N, _I, .ST, _S, __, _H, _E
        .byte   $a5, __, _H, _A, $ad, __, _V, _I
        .byte   _O, _L, $a2, $ab, _F02_, __, $a7, _T
        .byte   $a3, _G, $b3, _A, _C, $ac, _C, __
        .byte   _C, .LO, _N, $94, _P, _R, _O, _T
        .byte   _O, _C, _O, _L, _F0D_, $e5, _S, _H
        .byte   .OU, _L, _D, __, $a0, __, _A, _V
        .byte   _O, _I, _D, $ab, __end
        
        ; 2.
        .byte   $c4, _C, .ON
        .byte   .ST, _R, _I, _C, _T, $aa, __, $9c
        .byte   $a5, $ba, $a6, $be, $7b, __, $cd, __end

        ; 3.
        .byte   _A, __, $25, __, .LO, _O, _K, $94
        .byte   $98, __, $b2, _F, _T, __, _H, _E
        .byte   $a5, $87, _W, _H, _I, $b2, __, _B
        .byte   _A, _C, _K, _DOT, __, _L, _O, _O
        .byte   _K, $93, _B, .OU, _N, _D, __, _F
        .byte   $aa, __, $b9, _E, $b1, __end
        
        ; 4.
        .byte   _Y, _E
        .byte   _P, $7b, $87, $25, $85, $98, __, _H
        .byte   _A, _D, $87, _G, $b3, _A, _C, $ac
        .byte   _C, __, _H, _Y, _P, $a3, _D, _R
        .byte   _I, $ad, __, _F, .IT, _T, $93, _H
        .byte   _E, $a5, _DOT, __, $bb, $93, .IT, __
        .byte   _T, _O, _O, __end
        
        ; 5.
        .byte   $c3, __, $25, __
        .byte   $98, __, _D, _E, _H, _Y, _P, $93
        .byte   _H, _E, $a5, __, _F, _R, _O, _M
        .byte   __, .NO, _W, _H, _E, $a5, $7b, __
        .byte   _S, _U, _N, __, _S, _K, _I, _M
        .byte   _M, $ab, $e5, _J, _U, _M, _P, $ab
        .byte   _DOT, __, _I, __, _H, _E, $b9, __
        .byte   .IT, __, _W, $a1, _T, $9e, $a7, $bd
        .byte   $a0, __end
        
        ; 6.
        .byte   $24, __, $98, __, _W, $a1
        .byte   _T, __, _F, $aa, __, _M, _E, __
        .byte   $a2, __, _A, $bb, $b9, _DOT, __, _M
        .byte   _Y, __, $ae, _S, $a3, _S, __, _D
        .byte   _I, _D, _N, $70, _T, __, _E, _V
        .byte   $a1, __, _S, _C, $af, _T, _C, _H
        .byte   __, $c4, $24, __end
        
        ; 7.
        .byte   _O, _H, __, _D
        .byte   _E, $b9, __, _M, _E, __, _Y, $ba
        .byte   _DOT, $87, _F, _R, _I, _G, _H, _T
        .byte   _F, _U, _L, __, _R, _O, _G, _U
        .byte   _E, __, _W, _I, .TH, __, _W, _H
        .byte   $a2, __, _I, __, $a0, _L, _I, _E
        .byte   $ad, __, $e4, __, _P, _E, _O, _P
        .byte   $b2, __, _C, $b3, _L, $87, $b2, _A
        .byte   _D, __, _P, _O, .ST, $a3, _I, $aa
        .byte   __, _S, _H, _O, _T, __, _U, _P
        .byte   __, .LO, _T, _S, __, _O, _F, __
        .byte   .TH, _O, .SE, __, $a0, _A, .ST, _L
        .byte   _Y, __, _P, _I, $af, _T, $ba, $e5
        .byte   _W, $a1, _T, $9e, $bb, $b2, _R, _I
        .byte   __end
        
        ; 8.
        .byte   $e4, __, _C, $a8, __, _T, _A
        .byte   _C, _K, $b2, __, $c4, $3f, __, $24
        .byte   __, _I, _F, __, $e4, __, _L, _I
        .byte   _K, _E, _DOT, __, _H, _E, $70, _S
        .byte   __, $a2, __, $aa, $b9, $af, __end
        
        ; 9.
        .byte   _F01_
        .byte   _C, _O, _M, $94, $bc, .ON, _COLON, __
        .byte   _E, _L, .IT, _E, __, _I, _I, __end
        
        .byte   $23, __end      ; 10.
        .byte   $23, __end      ; 11.
        .byte   $23, __end      ; 12.
        .byte   $23, __end      ; 13.
        .byte   $23, __end      ; 14.
        .byte   $23, __end      ; 15.
        .byte   $23, __end      ; 16.
        .byte   $23, __end      ; 17.
        .byte   $23, __end      ; 18.
        .byte   $23, __end      ; 19.
        .byte   $23, __end      ; 20.
        .byte   $23, __end      ; 21.
        .byte   $23, __end      ; 22.
        
        ; 23.
        .byte   _B, _O, _Y, __, _A, $a5
        .byte   __, $e4, __, $a7, __, $c4, _W, _R
        .byte   .ON, _G, __, _G, $b3, _A, _X, _Y
        .byte   $76, __end
        
        ; 24.
        .byte   .TH, $a3, _E, $70, _S, $87
        .byte   $a5, $b3, __, $24, __, _P, _I, $af
        .byte   _T, _E, __, .OU, _T, __, .TH, $a3
        .byte   _E, __end
        
        ; 25.
        .byte   $c4, $96, _S, __, _O, _F
        .byte   __, $3a, __, _A, $a5, __, $bc, __
        .byte   _A, $b8, _Z, $a7, _G, _L, _Y, __
        .byte   _P, _R, _I, _M, _I, $ac, $ad, __
        .byte   .TH, $a2, __, .TH, _E, _Y, __, .ST
        .byte   .IL, _L, __, .TH, $a7, _K, __, _F13_
        .byte   $7d, $7d, $7d, $7d, $7d, __, $7d, $7d
        .byte   $7d, $7d, $7d, $7d, $9d, __, $64, _D
        .byte   __end
        
        ; 26.
        .byte   _F01_, _W, _E, _L, _C, _O, _M
        .byte   _E, __, _T, _O, __, _T, _H, _E
        .byte   __, _S, _E, _V, _E, _N, _T, _E
        .byte   _E, _N, _T, _H, __, _G, _A, _L
        .byte   _A, _X, _Y, $76, __end
        
        ; 27.
        .byte   $3a, _F1B_, _F13_
        .byte   _F16_, _F0F_, _F0F_, $31, $2b, $31, $3a, _F16_
        .byte   _F13_, _F14_, $23, $30, $3a, _F04_, _F03_, _F16_
        .byte   _F0F_, _F0F_, $31, $35, $2b, $31, $3a, _F1D_
        .byte   _F1A_, _F07_, _F1B_, _F1B_, $35, $33, _Z, $21
        .byte   _HYPHEN, $3d, $2e, _F1B_, _F1B_, $35, $32, $20
        .byte   _F1B_, _F13_, _F16_, _F0F_, _F0F_, $31, $3a, _F04_

;$1D00

;===============================================================================

.segment        "TEXT_PDESC"

; I believe these are a series of expansion-tokens that act as templates
; for planet descriptions

_3eac:
.export _3eac
        .byte   $10             ; msg token $5B
        .byte   $15             ; msg token $5C
        .byte   $1a             ; msg token $5D
        .byte   $1f             ; msg token $5E
        .byte   $9b             ; msg token $5F
        .byte   $a0             ; msg token $60
        .byte   $2e             ; msg token $61
        .byte   $a5             ; msg token $62
        .byte   $24             ; msg token $63
        .byte   $29             ; msg token $64
        .byte   $3d             ; msg token $65
        .byte   $33             ; msg token $66
        .byte   $38             ; msg token $67
        .byte   $aa             ; msg token $68
        .byte   _F15_           ; msg token $69
        .byte   _F10_           ; msg token $6A
        .byte   _F1B_           ; msg token $6B
        .byte   _F06_           ; msg token $6C
        .byte   _F01_           ; msg token $6D
        .byte   $8c             ; msg token $6E
        .byte   $60             ; msg token $6F
        .byte   $65             ; msg token $70
        .byte   $87             ; msg token $71
        .byte   $82             ; msg token $72
        .byte   _F0C_           ; msg token $73
        .byte   $6a             ; msg token $74
        .byte   $b4             ; msg token $75
        .byte   $b9             ; msg token $76
        .byte   $be             ; msg token $77
        .byte   $e1             ; msg token $78
        .byte   $e6             ; msg token $79
        .byte   $eb             ; msg token $7A
        .byte   $f0             ; msg token $7B
        .byte   $f5             ; msg token $7C
        .byte   $fa             ; msg token $7D
        .byte   $73             ; msg token $7E
        .byte   $78             ; msg token $7F
        .byte   $7d             ; msg token $80

;$3ED2