; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this is the 'key' used to scramble / unscramble the message token symbols
.export MSG_XOR := $57

.enum   msg_pairs
        _AB              =$D8
        _OU             ;=$D9
        _SE             ;=$DA
        _IT             ;=$DB
        _IL             ;=$DC
        _ET             ;=$DD
        _ST             ;=$DE
        _ON             ;=$DF
        _LO             ;=$E0
        _NU             ;=$E1
        _TH             ;=$E2
        _NO             ;=$E3
.endenum

_AB             = msg_pairs::_AB ^ MSG_XOR ;=$8F
_OU             = msg_pairs::_OU ^ MSG_XOR ;=$8E
_SE             = msg_pairs::_SE ^ MSG_XOR ;=$8D
_IT             = msg_pairs::_IT ^ MSG_XOR ;=$8C
_IL             = msg_pairs::_IL ^ MSG_XOR ;=$8B
_ET             = msg_pairs::_ET ^ MSG_XOR ;=$8A
_ST             = msg_pairs::_ST ^ MSG_XOR ;=$89
_ON             = msg_pairs::_ON ^ MSG_XOR ;=$88
_LO             = msg_pairs::_LO ^ MSG_XOR ;=$B7
_NU             = msg_pairs::_NU ^ MSG_XOR ;=$B6
_TH             = msg_pairs::_TH ^ MSG_XOR ;=$B5
_NO             = msg_pairs::_NO ^ MSG_XOR ;=$B4

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

_word_index     .set 0

.macro  .define_word    word_id
        
        .local  _value
        _value  .set 0

        _word_index .set _word_index + 1

        _value .set _word_index ^ MSG_XOR
        
        .out .sprintf(": $%2x: MSG%s", _value, word_id)
        .ident(word_id) = _value

        .export .ident(.concat("MSG", word_id)) = _value ^ MSG_XOR
.endmacro
.define .skip_word      _word_index .set _word_index + 1

;===============================================================================

.segment        "TEXT_0E00"

_0e00:
.export _0e00
        ; 0.
        .byte   __end
        .skip_word

        ; 1.
        .byte   _F09_, _F0B_, _F01_, _F08_, __, _F1E_, __
        .byte   _A, _C, $be, _S, _S, __, _M, _E
        .byte   _NU, $80, _F0A_, _F02_, $66, _DOT, __, $c2
        .byte   $80, $65, _DOT, __, _S, _A, $ad, __
        .byte   $cd, __, _F04_, $80, $64, _DOT, __, _C
        .byte   _H, $a8, $b0, $9e, _F1F_, $80, $63, _DOT
        .byte   __, _D, _E, _F, _A, _U, _L, _T
        .byte   __, _F01_, _J, _A, _M, _E, _S, _O
        .byte   _N, _F02_, $80, $62, _DOT, __, _E, _X
        .byte   _IT, $80, __end
        
        ; 2.
        .byte   $a6, _S, _K, __end
        .skip_word
        
        ; 3.
        .byte   _T, _A, _P, _E, __end
        .skip_word
        
        ; 4.
        .byte   _C, _O, _M, _P, _E, $ac, $ac, _ON, __, _NU, _M, _B
        .byte   $a3, _COLON, __end
        .skip_word
        
        ; 5.
        .byte   $e7, $3a, $9d, $39, $e6, __end
        .skip_word
        
        ; 6.
        .byte   __, __, $c2, __, _F01_, $7f, _Y
        .byte   $78, _N, $7e, $68, _F02_, _F0C_, _F0C_, __end
        .skip_word

        ; 7.
        .byte   _P, $a5, _S, _S, __, _S, _P, _A
        .byte   $be, __, $aa, __, _F, _I, $a5, $7b
        .byte   $cd, _DOT, _F0C_, _F0C_, __end
        .skip_word
        
        ; 8.
        .byte   $cd, $70, _S, $9f, __end
        .skip_word
        
        ; 9.
        .byte   _F0C_, _F01_, _IL, $b2, _G, $b3
        .byte   __, _E, _L, _I, _T, _E, __, _I
        .byte   _I, __, _F, _I, $b2, __end
        .skip_word
        
        ; 10.
        .byte   _F17_, _F0E_
        .byte   _F02_, _G, $a5, _ET, $a7, _G, _S, $82
        .byte   $e5, _F13_, _I, __, $a0, _G, $87, _M
        .byte   _O, _M, $a1, _T, __, _O, _F, __
        .byte   $e4, _R, __, _V, $b3, _U, _AB, $b2
        .byte   __, $ac, _M, _E, $9b, _W, _E, __
        .byte   _W, _OU, _L, _D, __, _L, _I, _K
        .byte   _E, __, $e4, $9e, _D, _O, $87, _L
        .byte   _IT, _T, $b2, __, _J, _O, _B, __
        .byte   _F, $aa, __, $bb, $9b, $c4, $98, __
        .byte   $e4, __, _SE, _E, __, _H, _E, $a5
        .byte   $9d, _A, $85, _M, _O, _D, _E, _L
        .byte   $7b, __, $c4, _F13_, _C, _ON, _ST, _R
        .byte   _I, _C, _T, $aa, $7b, __, _E, $a9
        .byte   _I, _P, $93, _W, _I, _TH, $87, _T
        .byte   _O, _P, __, _SE, _C, _R, _ET, $85
        .byte   _S, _H, _I, _E, _L, _D, __, _G
        .byte   $a1, $a3, $a2, $aa, $9b, _U, _N, _F
        .byte   $aa, _T, _U, _N, $a2, _E, _L, _Y
        .byte   __, _IT, $70, _S, __, $a0, $a1, __
        .byte   _ST, _O, _L, $a1, $9b, _F16_, _IT, __
        .byte   _W, $a1, _T, __, _M, _I, _S, _S
        .byte   $94, _F, _R, _O, _M, __, _OU, _R
        .byte   __, $98, __, _Y, $b9, _D, __, _ON
        .byte   __, _F13_, $b1, $a3, __, _F, _I, $ad
        .byte   __, _M, _ON, _TH, _S, __, _A, _G
        .byte   _O, $e5, _F1C_, $9b, $e4, _R, __, _M
        .byte   _I, _S, _S, _I, _ON, $7b, __, _S
        .byte   _H, _OU, _L, _D, __, $e4, __, _D
        .byte   _E, _C, _I, _D, _E, $9e, _A, _C
        .byte   $be, _P, _T, __, _IT, $7b, __, _I
        .byte   _S, $9e, _SE, _E, _K, $e5, _D, $ba
        .byte   _T, _R, _O, _Y, __, $c3, $98, $9b
        .byte   $e4, __, _A, $a5, __, _C, _A, _U
        .byte   $ac, _ON, $93, _TH, $a2, __, _ON, _L
        .byte   _Y, __, _F06_, $22, _F05_, _S, __, _W
        .byte   _IL, _L, __, _P, $a1, _ET, $af, _T
        .byte   _E, __, $c4, _N, _E, _W, __, _S
        .byte   _H, _I, _E, _L, _D, _S, $e5, _TH
        .byte   $a2, __, $c4, _F13_, _C, _ON, _ST, _R
        .byte   _I, _C, _T, $aa, $9d, _F, _IT, _T
        .byte   $93, _W, _I, _TH, __, $a8, __, _F06_
        .byte   $3b, _F05_, $e6, _F02_, _F08_, _G, _O, _O
        .byte   _D, __, _L, _U, _C, _K, $7b, __
        .byte   $cd, $83, _F16_, __end
        .skip_word
        
        ; 11.
        .byte   _F19_, _F09_, _F17_, _F0E_
        .byte   _F02_, __, __, $a2, _T, $a1, $ac, _ON
        .byte   $82, _DOT, __, _F13_, _W, _E, __, _H
        .byte   _A, $ad, __, _N, _E, $93, _O, _F
        .byte   __, $e4, _R, __, _SE, _R, _V, _I
        .byte   _C, $ba, __, _A, _G, _A, $a7, $9b
        .byte   _I, _F, __, $e4, __, _W, _OU, _L
        .byte   _D, __, $a0, __, $bc, __, _G, _O
        .byte   _O, _D, __, _A, _S, $9e, _G, _O
        .byte   $9e, _F13_, $be, $a3, $a6, __, $e4, __
        .byte   _W, _IL, _L, __, $a0, __, _B, _R
        .byte   _I, _E, _F, $ab, $9b, _I, _F, __
        .byte   _S, _U, _C, $be, _S, _S, _F, _U
        .byte   _L, $7b, __, $e4, __, _W, _IL, _L
        .byte   __, $a0, __, _W, _E, _L, _L, __
        .byte   $a5, _W, $b9, _D, $ab, $83, _F18_, __end
        .skip_word

        ; 12.
        .byte   $7f, _F13_, _C, $7e, $92, __, $66, $6e
        .byte   $6f, $62, __end
        .skip_word
        
        ; 13.
        .byte   _B, _Y, $92, __end
        .skip_word

        ; 14.
        .byte   _F15_, $c6, $9f, _F1A_, __end
        .skip_word

        ; 15.
        .byte   _F19_, _F09_, _F17_, _F0E_
        .byte   _F02_, __, __, _C, _ON, _G, $af, _T
        .byte   _U, $ae, $ac, _ON, _S, __, $cd, $76
        .byte   _F0C_, _F0C_, _TH, $a3, _E, _F0D_, __, _W
        .byte   _IL, _L, __, $b3, _W, _A, _Y, _S
        .byte   __, $a0, $87, _P, $ae, $be, __, _F
        .byte   $aa, __, $e4, __, $a7, $84, $9b, $a8
        .byte   _D, __, $b8, _Y, $a0, __, $bc, _ON
        .byte   $a3, __, _TH, $a8, __, $e4, __, _TH
        .byte   $a7, _K, _DOT, _DOT, $83, _F18_, __end
        .skip_word

        ; 16.
        .byte   _F, _AB, $b2, _D, __end
        .skip_word

        ; 17.
        .byte   _NO, _T, _AB, $b2, __end
        .skip_word

        ; 18.
        .byte   _W, _E, _L, _L, __, _K, _NO, _W, _N, __end
        .skip_word

        ; 19.
        .byte   _F, _A, _M, _O, $bb, __end
        .skip_word

        ; 20.
        .byte   _NO, _T, $ab, __end
        .skip_word

        ; 21.
        .byte   $ad, _R, _Y, __end
        .skip_word

        ; 22.
        .byte   _M, _IL, _D, _L, _Y, __end
        .skip_word

        ; 23.
        .byte   _M, _O, _ST, __end
        .skip_word

        ; 24.
        .byte   $a5, _A, _S, _ON, _AB, _L, _Y, __end
        .skip_word

        ; 25.
        .byte   __end
        .skip_word
        
        ; 26.
        .byte   $f2, __end
        .skip_word

        ; 27.
        .byte   $25, __end
        .skip_word

        ; 28.
        .byte   _G, $a5, $a2, __end
        .skip_word
        
        ; 29.
        .byte   _V, _A, _ST, __end
        .skip_word

        ; 30.
        .byte   _P, $a7, _K, __end
        .skip_word
        
        ; 31.
        .byte   _F02_, $20, __, $21
        .byte   _F0D_, __, $ee, _A, $ac, _ON, _S, __end
        .skip_word

        ; 32.
        .byte   $cb, _S, __end
        .skip_word

        ; 33.
        .byte   $22, __end
        .skip_word
        
        ; 34.
        .byte   $d7, __, _F, $aa, $ba, _T, _S, __end
        .skip_word
        
        ; 35.
        .byte   _O, $be, $a8, _S, __end
        .skip_word
        
        ; 36.
        .byte   _S, _H, _Y, _N, $ba, _S, __end
        .skip_word
        
        ; 37.
        .byte   _S, _IL, _L, $a7, $ba, _S, __end
        .skip_word
        
        ; 38.
        .byte   $b8, _T, $94, _T, $af, $a6, $ac, _ON, _S, __end
        .skip_word
        
        ; 39.
        .byte   _LO, $a2, _H, $94, _O, _F, __, $33, __end
        .skip_word
        
        ; 40.
        .byte   _LO, $ad, __, _F, $aa, __, $33, __end
        .skip_word
        
        ; 41.
        .byte   _F, _O, _O, _D, __, _B, $b2, _N, _D, $a3, _S, __end
        .skip_word
        
        ; 42.
        .byte   _T, _OU, _R, _I, _ST, _S, __end
        .skip_word
        
        ; 43.
        .byte   _P, _O, _ET, _R, _Y, __end
        .skip_word
        
        ; 44.
        .byte   $a6, _S, _C, _O, _S, __end
        .skip_word
        
        ; 45.
        .byte   $3b, __end
        .skip_word
        
        ; 46.
        .byte   _W, $b3, _K, $94, $c9, __end
        .skip_word
        
        ; 47.
        .byte   _C, $af, _B, __end
        .skip_word
        
        ; 48.
        .byte   _B, $a2, __end
        .skip_word
        
        ; 49.
        .byte   _LO, _B, _ST, __end
        .skip_word
        
        ; 50.
        .byte   _F12_, __end
        .skip_word
        
        ; 51.
        .byte   $a0, _S, _ET, __end
        .skip_word
        
        ; 52.
        .byte   _P, $ae, _G, _U, $ab, __end
        .skip_word
        
        ; 53.
        .byte   $af, _V, _A, _G, $ab, __end
        .skip_word
        
        ; 54.
        .byte   _C, _U, _R, _S, $ab, __end
        .skip_word
        
        ; 55.
        .byte   _S, _C, _OU, _R, _G, $ab, __end
        .skip_word
        
        ; 56.
        .byte   $26, __, _C, _I, _V, _IL, __, _W, $b9, __end
        .skip_word
        
        ; 57.
        .byte   $3f, __, $08, __, $37, _S, __end
        .skip_word
        
        ; 58.
        .byte   _A, __, $3f, __, $a6, _SE, _A, _SE, __end
        .skip_word
        
        ; 59.
        .byte   $26, __, _E, $b9, _TH, $a9, _A, _K, $ba, __end
        .skip_word
        
        ; 60.
        .byte   $26, __, $bc, $ae, _R, __, _A, _C
        .byte   $ac, _V, _IT, _Y, __end
        .skip_word
        
        ; 61.
        .byte   $f8, $0a, __, $09, __end
        .skip_word
        
        ; 62.
        .byte   $c4, _F11_, __, $08, __, $37, __end
        .skip_word
        
        ; 63.
        .byte   $f8, $96, _S, $70, __, $35, __, $34, __end
        .skip_word
        
        ; 64.
        .byte   _F02_, $2d, _F0D_, __end
        .skip_word
        
        ; 65.
        .byte   $f8, $3c, __, $3b, __end
        .skip_word
        
        ; 66.
        .byte   _J, _U, _I, $be, __end
        .skip_word
        
        ; 67.
        .byte   _B, $af, _N, _D, _Y, __end
        .skip_word
        
        ; 68.
        .byte   _W, $a2, $a3, __end
        .skip_word
        
        ; 69.
        .byte   _B, $a5, _W, __end
        .skip_word
        
        ; 70.
        .byte   _G, $b9, _G, $b2, __, _B, $ae, _ST, $a3, _S, __end
        .skip_word
        
        ; 71.
        .byte   _F12_, __end
        .skip_word
        
        ; 72.
        .byte   _F11_, __, $37, __end
        .skip_word
        
        ; 73.
        .byte   _F11_, __, _F12_, __end
        .skip_word
        
        ; 74.
        .byte   _F11_, __, $3f, __end
        .skip_word
        
        ; 75.
        .byte   $3f, __, _F12_, __end
        .skip_word
        
        ; 76.
        .byte   _F, _AB, _U, _LO, $bb, __end
        .skip_word
        
        ; 77.
        .byte   _E, _X, _O, $ac, _C, __end
        .skip_word
        
        ; 78.
        .byte   _H, _O, _O, _P, _Y, __end
        .skip_word
        
        ; 79.
        .byte   _U, _NU, _S, _U, $b3, __end
        .skip_word
        
        ; 80.
        .byte   _E, _X, _C, _IT, $a7, _G, __end
        .skip_word
        
        ; 81.
        .byte   _C, _U, _I, _S, $a7, _E, __end
        .skip_word
        
        ; 82.
        .byte   _N, _I, _G, _H, _T, __, _L, _I, _F, _E, __end
        .skip_word
        
        ; 83.
        .byte   _C, _A, _S, _I, _NO, _S, __end
        .skip_word
        
        ; 84.
        .byte   _S, _IT, __, _C, _O, _M, _S, __end
        .skip_word
        
        ; 85.
        .byte   _F02_, $2d, _F0D_, __end
        .skip_word
        
        ; 86.
        .byte   _F03_, __end
        .skip_word
        
        ; 87.
        .byte   $c4, $c6, __, _F03_, __end
        .skip_word
        
        ; 88.
        .byte   $c4, $c5, __, _F03_, __end
        .skip_word
        
        ; 89.
        .byte   $c3, $c6, __end
        .skip_word
        
        ; 90.
        .byte   $c3, $c5, __end
        .skip_word
        
        ; 91.
        .byte   _S, _ON, __, _O, _F, $87, _B, _IT, _C, _H, __end
        .skip_word
        
        ; 92.
        .byte   _S, _C, _OU, _N, _D, $a5, _L, __end
        .skip_word
        
        ; 93.
        .byte   _B, $ae, _C, _K, _G, _U, $b9, _D, __end
        .skip_word
        
        ; 94.
        .byte   _R, _O, _G, _U, _E, __end
        .skip_word
        
        ; 95.
        .byte   _W, _H, $aa, $ba, _ON
        .byte   __, $a0, _ET, $b2, __, _H, _E, _A
        .byte   _D, $93, _F, $ae, _P, __, _E, $b9
        .byte   $70, _D, __, _K, _N, _A, $ad, __end
        .skip_word
        
        ; 96.
        .byte   _N, __, _U, _N, $a5, $b8, _R, _K
        .byte   _AB, $b2, __end
        .skip_word
        
        ; 97.
        .byte   __, _B, $aa, $a7, _G
        .byte   __end
        .skip_word
        
        ; 98.
        .byte   __, _D, _U, _L, _L, __end
        .skip_word
        
        ; 99.
        .byte   __, _T, _E, $a6, _O, $bb, __end
        .skip_word
        
        ; 100.
        .byte   __, $a5, _V, _O, _L, _T, $a7, _G, __end
        .skip_word
        
        ; 101.
        .byte   $c6, __end
        .skip_word
        
        ; 102.
        .byte   $c5, __end
        .skip_word
        
        ; 103.
        .byte   _P, $ae, $be, __end
        .skip_word
        
        ; 104.
        .byte   _L, _IT, _T, $b2, __, $c6, __end
        .skip_word
        
        ; 105.
        .byte   _D, _U, _M, _P, __end
        .skip_word
        
        ; 106.
        .byte   _I, __, _H, _E, $b9
        .byte   $87, $25, __, _LO, _O, _K, $94, $98
        .byte   __, _A, _P, _P, _E, $b9, $93, $a2
        .byte   $86, __end
        .skip_word
        
        ; 107.
        .byte   _Y, _E, _A, _H, $7b, __
        .byte   _I, __, _H, _E, $b9, $87, $25, __
        .byte   $98, __, $b2, _F, _T, $86, $87, __
        .byte   _W, _H, _I, $b2, __, _B, _A, _C
        .byte   _K, __end
        .skip_word
        
        ; 108.
        .byte   _G, _ET, __, $e4, _R, __
        .byte   _I, _R, _ON, __, _A, _S, _S, __
        .byte   _O, _V, $a3, __, _T, _O, $86, __end
        .skip_word
        
        ; 109.
        .byte   $bc, _M, _E, __, $24, $85, $98, __
        .byte   _W, _A, _S, __, _SE, $a1, __, $a2
        .byte   $86, __end
        .skip_word
        
        ; 110.
        .byte   _T, _R, _Y, $86, __end
        .skip_word
        
        ; 111.
        .byte   __, _C, _U, _D, _D, _L, _Y, __end
        .skip_word
        
        ; 112.
        .byte   __, _C, _U, _T, _E, __end
        .skip_word
        
        ; 113.
        .byte   __, _F, _U, _R, _R, _Y, __end
        .skip_word
        
        ; 114.
        .byte   __, _F, _R, _I, $a1, _D, _L, _Y, __end
        .skip_word
        
        ; 115.
        .byte   _W, _A, _S, _P, __end
        .skip_word
        
        ; 116.
        .byte   _M, _O, _TH, __end
        .skip_word
        
        ; 117.
        .byte   _G, _R, _U, _B, __end
        .skip_word
        
        ; 118.
        .byte   $a8, _T, __end
        .skip_word
        
        ; 119.
        .byte   _F12_, __end
        .skip_word
        
        ; 120.
        .byte   _P, _O, _ET, __end
        .skip_word
        
        ; 121.
        .byte   $b9, _T, _S, __, _G, $af, _D, _U, $a2, _E, __end
        .skip_word
        
        ; 122.
        .byte   _Y, _A, _K, __end
        .skip_word
        
        ; 123.
        .byte   _S, _N, _A, _IL, __end
        .skip_word
        
        ; 124.
        .byte   _S, _L, _U, _G, __end
        .skip_word
        
        ; 125.
        .byte   _T, _R, _O, _P, _I, _C, $b3, __end
        .skip_word
        
        ; 126.
        .byte   _D, $a1, _SE, __end
        .skip_word
        
        ; 127.
        .byte   $af, $a7, __end
        .skip_word
        
        ; 128.
        .byte   _I, _M, _P, $a1, _ET, $af, _B, $b2, __end
        .skip_word
        
        ; 129.
        .byte   _E, _X, _U, $a0, $af, _N, _T, __end
        .skip_word
        
        ; 130.
        .byte   _F, _U, _N, _N, _Y, __end
        .skip_word
        
        ; 131.
        .byte   _W, _E, _I, _R, _D, __end
        .skip_word
        
        ; 132.
        .byte   _U, _NU, _S, _U, $b3, __end
        .skip_word
        
        ; 133.
        .byte   _ST, $af, _N, $b0, __end
        .skip_word
        
        ; 134.
        .byte   _P, _E, _C, _U, _L, _I, $b9, __end
        .skip_word
        
        ; 135.
        .byte   _F, $a5, $a9, $a1, _T, __end
        .skip_word
        
        ; 136.
        .byte   _O, _C, _C, _A, _S, _I, _ON, $b3, __end
        .skip_word
        
        ; 137.
        .byte   _U, _N, _P, $a5, $a6, _C, _T, _AB, $b2, __end
        .skip_word
        
        ; 138.
        .byte   _D, $a5, _A, _D, _F, _U, _L, __end
        .skip_word
        
        ; 139.
        .byte   $fc, __end, $0b, __, $0c, __, _F, $aa, __, $32, __end
        .skip_word
        
        ; 140.
        .byte   $db, $e5, $32, __end
        .skip_word
        
        ; 141.
        .byte   $31, __, _B, _Y, __, $30, __end
        .skip_word
        
        ; 142.
        .byte   $db, __, _B, _U, _T, __, $d9, __end
        .skip_word
        
        ; 143.
        .byte   __, _A, $38, __, $27, __end
        .skip_word
        
        ; 144.
        .byte   _P, _L, $a8, _ET, __end
        .skip_word
        
        ; 145.
        .byte   _W, $aa, _L, _D, __end
        .skip_word
        
        ; 146.
        .byte   _TH, _E, __, __end
        .skip_word
        
        ; 147.
        .byte   _TH, _I, _S, __, __end
        .skip_word
        
        ; 148.
        .byte   _LO, _A, _D, $85, $cd, __end
        .skip_word
        
        ; 149.
        .byte   _F09_, _F0B_, _F01_, _F08_, __end
        .skip_word
        
        ; 150.
        .byte   _D, _R, _I, $ad, __end
        .skip_word
        
        ; 151.
        .byte   __, _C, $a2, _A, _LO, _G, _U, _E, __end
        .skip_word
        
        ; 152.
        .byte   _I, $a8, __end
        .skip_word
        
        ; 153.
        .byte   _F13_, _C, _O, _M, _M, $a8, _D, $a3, __end
        .skip_word
        
        ; 154.
        .byte   $3f, __end
        .skip_word
        
        ; 155.
        .byte   _M, _OU, _N, _T, _A, $a7, __end
        .skip_word
        
        ; 156.
        .byte   $ab, _I, _B, $b2, __end
        .skip_word
        
        ; 157.
        .byte   _T, $a5, _E, __end
        .skip_word
        
        ; 158.
        .byte   _S, _P, _O, _T, _T, $ab, __end
        .skip_word
        
        ; 159.
        .byte   $2f, __end
        .skip_word
        
        ; 160.
        .byte   $2e, __end
        .skip_word
        
        ; 161.
        .byte   $36, _O, _I, _D, __end
        .skip_word
        
        ; 162.
        .byte   $28, __end
        .skip_word
        
        ; 163.
        .byte   $29, __end
        .skip_word
        
        ; 164.
        .byte   $a8, _C, _I, $a1, _T, __end
        .skip_word
        
        ; 165.
        .byte   _E, _X, $be, _P, $ac, _ON, $b3, __end
        .skip_word
        
        ; 166.
        .byte   _E, _C, $be, _N, _T, _R, _I, _C, __end
        .skip_word
        
        ; 167.
        .byte   $a7, _G, $af, $a7, $ab, __end
        .skip_word
        
        ; 168.
        .byte   $25, __end
        .skip_word
        
        ; 169.
        .byte   _K, _IL, _L, $a3, __end
        .skip_word
        
        ; 170.
        .byte   _D, _E, _A, _D, _L, _Y, __end
        .skip_word
        
        ; 171.
        .byte   _E, _V, _IL, __end
        .skip_word
        
        ; 172.
        .byte   $b2, _TH, $b3, __end
        .skip_word
        
        ; 173.
        .byte   _V, _I, _C, _I, _O, $bb, __end
        .skip_word
        
        ; 174.
        .byte   _IT, _S, __, __end
        .skip_word
        
        ; 175.
        .byte   _F0D_, _F0E_, _F13_, __end
        .skip_word
        
        ; 176.
        .byte   _DOT, _F0C_, _F0F_, __end
        .skip_word
        
        ; 177.
        .byte   __, $a8, _D, __, __end
        .skip_word
        
        ; 178.
        .byte   _Y, _OU, __end
        .skip_word
        
        ; 179.
        .byte   _P, $b9, _K, $94, _M, _ET, $a3, _S, __end
        .skip_word
        
        ; 180.
        .byte   _D, $bb, _T, __, _C, _LO, _U, _D, _S, __end
        .skip_word
        
        ; 181.
        .byte   _I, $be, __, $a0, _R, _G, _S, __end
        .skip_word
        
        ; 182.
        .byte   _R, _O, _C, _K, __, _F, $aa, $b8
        .byte   $ac, _ON, _S, __end
        .skip_word
        
        ; 183.
        .byte   _V, _O, _L, _C, _A, _NO, $ba, __end
        .skip_word
        
        ; 184.
        .byte   _P, _L, $a8, _T, __end
        .skip_word
        
        ; 185.
        .byte   _T, _U, _L, _I, _P, __end
        .skip_word
        
        ; 186.
        .byte   _B, $a8, $a8, _A, __end
        .skip_word
        
        ; 187.
        .byte   _C, $aa, _N, __end
        .skip_word
        
        ; 188.
        .byte   _F12_, _W, _E, $ab, __end
        .skip_word
        
        ; 189.
        .byte   _F12_, __end
        .skip_word
        
        ; 190.
        .byte   _F11_, __, _F12_, __end
        .skip_word
        
        ; 191.
        .byte   _F11_, __, $3f, __end
        .skip_word
        
        ; 192.
        .byte   $a7, _H, _A, $bd, _T, $a8, _T, __end
        .skip_word
        
        ; 193.
        .byte   $e8, __end
        .skip_word
        
        ; 194.
        .byte   $a7, _G, __, __end
        .skip_word
        
        ; 195.
        .byte   $ab, __, __end
        .skip_word
        
        ; 196.
        .byte   __, _D, _DOT, _B, $af, $a0, _N, __
        .byte   $71, __, _I, _DOT, $a0, _L, _L, __end
        .skip_word
        
        ; 197.
        .byte   __, _L, _IT, _T, $b2, __, _T, _R
        .byte   _U, _M, _B, $b2, __end
        .skip_word
        
        ; 198.
        .byte   _F19_, _F09_, _F1D_
        .byte   _F0E_, _F13_, _G, _O, _O, _D, _F0D_, __
        .byte   _D, _A, _Y, __, $cd, __, _F04_, $7b
        .byte   __, $b3, _LO, _W, __, _M, _E, $9e
        .byte   $a7, _T, _R, _O, _D, _U, $be, __
        .byte   _M, _Y, _SE, _L, _F, _DOT, __, _F13_
        .byte   _I, __, _A, _M, _F02_, __, $c4, _M
        .byte   $a3, _C, _H, $a8, _T, __, _P, _R
        .byte   $a7, $be, __, _O, _F, __, _TH, _R
        .byte   _U, _N, _F0D_, $e5, _F13_, _I, __, _F
        .byte   $a7, _D, __, _M, _Y, _SE, _L, _F
        .byte   __, _F, $aa, $be, _D, $9e, _SE, _L
        .byte   _L, __, _M, _Y, __, _M, _O, _ST
        .byte   __, _T, $a5, _A, _S, _U, _R, $ab
        .byte   __, _P, _O, _S, _S, $ba, _S, _I
        .byte   _ON, $9b, _I, __, _A, _M, __, _O
        .byte   _F, _F, $a3, $94, _Y, _OU, $7b, __
        .byte   _F, $aa, __, $c4, _P, _A, _L, _T
        .byte   _R, _Y, __, _S, _U, _M, __, _O
        .byte   _F, __, _J, _U, _ST, __, $62, $67
        .byte   $67, $67, _F13_, _C, _F13_, _R, __, $c4
        .byte   $af, $a5, _ST, __, _TH, $94, __, $a7
        .byte   __, $c4, _F02_, _K, _NO, _W, _N, __
        .byte   _U, _N, _I, $ad, _R, _SE, $9b, _F0D_
        .byte   _W, _IL, _L, __, _Y, _OU, __, _T
        .byte   _A, _K, _E, __, _IT, _F01_, $7f, _Y
        .byte   $78, _N, $7e, $68, _F0C_, _F0F_, _F01_, _F08_
        .byte   __end
        .skip_word
        
        ; 199.
        .byte   __, _N, _A, _M, _E, $68, __
        .byte   __end
        .skip_word
        
        ; 200.
        .byte   __, _T, _O, __, __end
        .skip_word
        
        ; 201.
        .byte   __, _I, _S, __, __end
        .skip_word
        
        ; 202.
        .byte   _W, _A, _S, __, $ae
        .byte   _ST, __, _SE, $a1, __, $a2, __, _F13_
        .byte   __end
        .skip_word
        
        ; 203.
        .byte   _DOT, _F0C_, __, _F13_, __end
        .skip_word
        
        ; 204.
        .byte   _D, _O, _C, _K, $ab, __end
        .skip_word
        
        ; 205.
        .byte   _F01_, $7f, _Y, $78, _N, $7e, $68, __end
        .skip_word
        
        ; 206.
        .byte   _S, _H, _I, _P, __end
        .skip_word
        
        ; 207.
        .byte   __, _A, __, __end
        .skip_word
        
        ; 208.
        .byte   __, $a3, _R, _I, $bb, __end
        .skip_word
        
        ; 209.
        .byte   __, _N, _E, _W, __, __end
        .skip_word
        
        ; 210.
        .byte   _F02_, __, _H, $a3, __, $b8, _J
        .byte   $ba, _T, _Y, $70, _S, __, _S, _P
        .byte   _A, $be, __, _N, _A, _V, _Y, _F0D_
        .byte   __end
        .skip_word
        
        ; 211.
        .byte   $e6, _F08_, _F01_, __, __, _M, $ba
        .byte   _S, _A, $b0, __, $a1, _D, _S, __end
        .skip_word
        
        ; 212.
        .byte   __, $cd, __, _F04_, $7b, __, _I, __
        .byte   _F0D_, _A, _M, _F02_, __, _C, _A, _P
        .byte   _T, _A, $a7, __, _F1B_, __, _F0D_, _O
        .byte   _F, $84, __end
        .skip_word
        
        ; 213.
        .byte   __end
        .skip_word
        
        ; 214.
        .byte   _F0F_, __, _U, _N, _K, _NO, _W, _N, __, $c6, __end
        .skip_word
        
        ; 215.
        .byte   _F09_, _F08_, _F17_, _F01_, __, $a7, _C, _O, _M
        .byte   $94, _M, $ba, _S, _A, $b0, __end
        .skip_word
        
        ; 216.
        .byte   _C, _U, _R, _R, _U, _TH, $a3, _S, __end
        .skip_word
        
        ; 217.
        .byte   _F, _O, _S, _D, _Y, _K, _E, __
        .byte   _S, _M, _Y, _TH, _E, __end
        .skip_word
        
        ; 218.
        .byte   _F, $aa, _T, $ba, $a9, _E, __end
        .skip_word
        
        ; 219.
        .byte   $9c, $a5, $ba, $a6, $be, __end
        .skip_word
        
        ; 220.
        .byte   _I, _S, __, $a0, _L
        .byte   _I, _E, _V, $ab, $9e, _H, _A, $ad
        .byte   __, _J, _U, _M, _P, $ab, $9e, $c3
        .byte   _G, $b3, _A, _X, _Y, __end
        .skip_word
        
        ; 221.
        .byte   _F19_, _F09_
        .byte   _F1D_, _F0E_, _F02_, _G, _O, _O, _D, __
        .byte   _D, _A, _Y, __, $cd, __, _F04_, $9b
        .byte   _I, _F0D_, __, _A, _M, __, _F13_, _A
        .byte   _G, $a1, _T, __, _F13_, _B, $ae, _K
        .byte   _E, __, _O, _F, __, _F13_, _N, _A
        .byte   _V, $b3, __, _F13_, $a7, _T, _E, _L
        .byte   $b2, _G, $a1, $be, $9b, _A, _S, __
        .byte   $e4, __, _K, _NO, _W, $7b, __, $c4
        .byte   _F13_, _N, _A, _V, _Y, __, _H, _A
        .byte   $ad, __, $a0, $a1, __, _K, _E, _E
        .byte   _P, $94, $c4, _F13_, _TH, $b9, _G, _O
        .byte   _I, _D, _S, __, _O, _F, _F, __
        .byte   $e4, _R, __, _A, _S, _S, __, _OU
        .byte   _T, __, $a7, __, _D, _E, _E, _P
        .byte   __, _S, _P, _A, $be, __, _F, $aa
        .byte   __, $b8, _N, _Y, __, _Y, _E, $b9
        .byte   _S, __, _NO, _W, _DOT, __, _F13_, _W
        .byte   _E, _L, _L, __, $c4, _S, _IT, _U
        .byte   _A, $ac, _ON, __, _H, _A, _S, __
        .byte   _C, _H, $a8, _G, $ab, $9b, _OU, _R
        .byte   __, _B, _O, _Y, _S, __, $b9, _E
        .byte   __, $a5, _A, _D, _Y, __, _F, $aa
        .byte   $87, _P, _U, _S, _H, __, _R, _I
        .byte   _G, _H, _T, $9e, $c4, _H, _O, _M
        .byte   _E, __, _S, _Y, _S, _T, _E, _M
        .byte   __, _O, _F, __, _TH, _O, _SE, __
        .byte   _M, _U, _R, _D, $a3, $a3, _S, $9b
        .byte   _F18_, _F09_, _F1D_, _I, _F0D_, __, _H, _A
        .byte   $ad, __, _O, _B, _T, _A, $a7, $93
        .byte   $c4, _D, _E, _F, $a1, $be, __, _P
        .byte   $ae, _N, _S, __, _F, $aa, __, _TH
        .byte   _E, _I, _R, __, _F13_, _H, _I, $ad
        .byte   __, _F13_, _W, $aa, _L, _D, _S, $9b
        .byte   $c4, $a0, _ET, $b2, _S, __, _K, _NO
        .byte   _W, __, _W, _E, $70, $ad, __, _G
        .byte   _O, _T, __, $bc, _M, _E, _TH, $94
        .byte   _B, _U, _T, __, _NO, _T, __, _W
        .byte   _H, $a2, $9b, _I, _F, __, _F13_, _I
        .byte   __, _T, $af, _N, _S, _M, _IT, __
        .byte   $c4, _P, $ae, _N, _S, $9e, _OU, _R
        .byte   __, _B, _A, _SE, __, _ON, __, _F13_
        .byte   $bd, $a5, $af, __, _TH, _E, _Y, $70
        .byte   _L, _L, __, $a7, _T, $a3, $be, _P
        .byte   _T, __, $c4, _T, _R, $a8, _S, _M
        .byte   _I, _S, _S, _I, _ON, _DOT, __, _F13_
        .byte   _I, __, _N, _E, $ab, $87, $98, $9e
        .byte   $b8, _K, _E, __, $c4, _R, _U, _N
        .byte   $9b, $e4, $70, $a5, __, _E, $b2, _C
        .byte   _T, $ab, $9b, $c4, _P, $ae, _N, _S
        .byte   __, _A, $a5, __, _U, _N, _I, _P
        .byte   _U, _L, _SE, __, _C, _O, _D, $93
        .byte   _W, _I, _TH, $a7, __, $c3, _T, _R
        .byte   $a8, _S, _M, _I, _S, _S, _I, _ON
        .byte   $9b, _F08_, $e4, __, _W, _IL, _L, __
        .byte   $a0, __, _P, _A, _I, _D, $9b, __
        .byte   __, __, __, _F13_, _G, _O, _O, _D
        .byte   __, _L, _U, _C, _K, __, $cd, $83
        .byte   _F18_, __end
        .skip_word
        
        ; 222.
        .byte   _F19_, _F09_, _F1D_, _F08_, _F0E_, _F0D_
        .byte   _F13_, _W, _E, _L, _L, __, _D, _ON
        .byte   _E, __, $cd, $9b, $e4, __, _H, _A
        .byte   $ad, __, _SE, _R, _V, $93, _U, _S
        .byte   __, _W, _E, _L, _L, $e5, _W, _E
        .byte   __, _S, _H, $b3, _L, __, $a5, _M
        .byte   _E, _M, _B, $a3, $9b, _W, _E, __
        .byte   _D, _I, _D, __, _NO, _T, __, _E
        .byte   _X, _P, _E, _C, _T, __, $c4, _F13_
        .byte   _TH, $b9, _G, _O, _I, _D, _S, $9e
        .byte   _F, $a7, _D, __, _OU, _T, __, _A
        .byte   _B, _OU, _T, __, $e4, $9b, _F, $aa
        .byte   __, $c4, _M, _O, _M, $a1, _T, __
        .byte   _P, $b2, _A, _SE, __, _A, _C, $be
        .byte   _P, _T, __, $c3, _F13_, _N, _A, _V
        .byte   _Y, __, _F06_, $25, _F05_, __, _A, _S
        .byte   __, _P, _A, _Y, _M, $a1, _T, $83
        .byte   _F18_, __end
        .skip_word
        
        ; 223.
        .byte   _A, $a5, __, $e4, __, _S
        .byte   _U, $a5, $68, __end
        .skip_word
        
        ; 224.
        .byte   _S, _H, $a5, _W, __end
        .skip_word
        
        ; 225.
        .byte   $a0, _A, _ST, __end
        .skip_word
        
        ; 226.
        .byte   _B, _I, _S, _ON, __end
        .skip_word
        
        ; 227.
        .byte   _S, _N, _A, _K, _E, __end
        .skip_word
        
        ; 228.
        .byte   _W, _O, _L, _F, __end
        .skip_word
        
        ; 229.
        .byte   $b2, _O, _P, $b9, _D, __end
        .skip_word
        
        ; 230.
        .byte   _C, $a2, __end
        .skip_word
        
        ; 231.
        .byte   _M, _ON, _K, _E, _Y, __end
        .skip_word
        
        ; 232.
        .byte   _G, _O, $a2, __end
        .skip_word
        
        ; 233.
        .byte   _F, _I, _S, _H, __end
        .skip_word
        
        ; 234.
        .byte   $3d, __, $3e, __end
        .skip_word
        
        ; 235.
        .byte   _F11_, __, $2f, __, $2c, __end
        .skip_word
        
        ; 236.
        .byte   $f8, $3c, __, $2e, __, $2c, __end
        .skip_word
        
        ; 237.
        .byte   $2b, __, $2a, __end
        .skip_word
        
        ; 238.
        .byte   $3d, __, $3e, __end
        .skip_word
        
        ; 239.
        .byte   _M, _E, $a2, __end
        .skip_word
        
        ; 240.
        .byte   _C, _U, _T, _L, _ET, __end
        .skip_word
        
        ; 241.
        .byte   _ST, _E, _A, _K, __end
        .skip_word
        
        ; 242.
        .byte   _B, _U, _R, _G, $a3, _S, __end
        .skip_word
        
        ; 243.
        .byte   $bc, _U, _P, __end
        .skip_word
        
        ; 244.
        .byte   _I, $be, __end
        .skip_word
        
        ; 245.
        .byte   _M, _U, _D, __end
        .skip_word
        
        ; 246.
        .byte   _Z, $a3, _O, _HYPHEN, _F13_, _G, __end
        .skip_word
        
        ; 247.
        .byte   _V, _A, _C, _U, _U, _M, __end
        .skip_word
        
        ; 248.
        .byte   _F11_, __, _U, _L, _T, $af, __end
        .skip_word
        
        ; 249.
        .byte   _H, _O, _C, _K, _E, _Y, __end
        .skip_word
        
        ; 250.
        .byte   _C, _R, _I, _C, _K, _ET, __end
        .skip_word
        
        ; 251.
        .byte   _K, $b9, $a2, _E, __end
        .skip_word
        
        ; 252.
        .byte   _P, _O, _LO, __end
        .skip_word
        
        ; 253.
        .byte   _T, $a1, _N, _I, _S, __end
        .skip_word
        
        ; 254.
        .byte   _F0C_, _F1E_, __, $a3, _R, $aa
        .skip_word

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
        .byte   _LO, _N, _I, _ST, _S, __, _H, _E
        .byte   $a5, __, _H, _A, $ad, __, _V, _I
        .byte   _O, _L, $a2, $ab, _F02_, __, $a7, _T
        .byte   $a3, _G, $b3, _A, _C, $ac, _C, __
        .byte   _C, _LO, _N, $94, _P, _R, _O, _T
        .byte   _O, _C, _O, _L, _F0D_, $e5, _S, _H
        .byte   _OU, _L, _D, __, $a0, __, _A, _V
        .byte   _O, _I, _D, $ab, __end
        
        ; 2.
        .byte   $c4, _C, _ON
        .byte   _ST, _R, _I, _C, _T, $aa, __, $9c
        .byte   $a5, $ba, $a6, $be, $7b, __, $cd, __end

        ; 3.
        .byte   _A, __, $25, __, _LO, _O, _K, $94
        .byte   $98, __, $b2, _F, _T, __, _H, _E
        .byte   $a5, $87, _W, _H, _I, $b2, __, _B
        .byte   _A, _C, _K, _DOT, __, _L, _O, _O
        .byte   _K, $93, _B, _OU, _N, _D, __, _F
        .byte   $aa, __, $b9, _E, $b1, __end
        
        ; 4.
        .byte   _Y, _E
        .byte   _P, $7b, $87, $25, $85, $98, __, _H
        .byte   _A, _D, $87, _G, $b3, _A, _C, $ac
        .byte   _C, __, _H, _Y, _P, $a3, _D, _R
        .byte   _I, $ad, __, _F, _IT, _T, $93, _H
        .byte   _E, $a5, _DOT, __, $bb, $93, _IT, __
        .byte   _T, _O, _O, __end
        
        ; 5.
        .byte   $c3, __, $25, __
        .byte   $98, __, _D, _E, _H, _Y, _P, $93
        .byte   _H, _E, $a5, __, _F, _R, _O, _M
        .byte   __, _NO, _W, _H, _E, $a5, $7b, __
        .byte   _S, _U, _N, __, _S, _K, _I, _M
        .byte   _M, $ab, $e5, _J, _U, _M, _P, $ab
        .byte   _DOT, __, _I, __, _H, _E, $b9, __
        .byte   _IT, __, _W, $a1, _T, $9e, $a7, $bd
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
        .byte   _E, __, _W, _I, _TH, __, _W, _H
        .byte   $a2, __, _I, __, $a0, _L, _I, _E
        .byte   $ad, __, $e4, __, _P, _E, _O, _P
        .byte   $b2, __, _C, $b3, _L, $87, $b2, _A
        .byte   _D, __, _P, _O, _ST, $a3, _I, $aa
        .byte   __, _S, _H, _O, _T, __, _U, _P
        .byte   __, _LO, _T, _S, __, _O, _F, __
        .byte   _TH, _O, _SE, __, $a0, _A, _ST, _L
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
        .byte   _C, _O, _M, $94, $bc, _ON, _COLON, __
        .byte   _E, _L, _IT, _E, __, _I, _I, __end
        
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
        .byte   _ON, _G, __, _G, $b3, _A, _X, _Y
        .byte   $76, __end
        
        ; 24.
        .byte   _TH, $a3, _E, $70, _S, $87
        .byte   $a5, $b3, __, $24, __, _P, _I, $af
        .byte   _T, _E, __, _OU, _T, __, _TH, $a3
        .byte   _E, __end
        
        ; 25.
        .byte   $c4, $96, _S, __, _O, _F
        .byte   __, $3a, __, _A, $a5, __, $bc, __
        .byte   _A, $b8, _Z, $a7, _G, _L, _Y, __
        .byte   _P, _R, _I, _M, _I, $ac, $ad, __
        .byte   _TH, $a2, __, _TH, _E, _Y, __, _ST
        .byte   _IL, _L, __, _TH, $a7, _K, __, _F13_
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