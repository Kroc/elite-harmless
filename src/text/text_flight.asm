; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; this file stores the more common strings, typically used when in 'flight'
; mode, but this also includes some of the shared menu screens that can be
; accessed either in flight or docked, such as player status. whilst this
; string pool does contain much of the text on the planet status screen,
; it doesn't include the planet description strings, that's a very
; complex system and those are stored in the 'docked' string pool


; this is the 'key' used to scramble / unscramble the text token symbols
; https://xania.org/201406/elites-crazy-string-format
.export TXT_FLIGHT_XOR := $23

; all flight tokens on disk are scrambled in this way:
.define .scramble(value) value ^ TXT_FLIGHT_XOR


.import txt_flight_al:direct            ;=$80:
_AL     = .scramble( txt_flight_al )    ;^23=$A3
.import txt_flight_le:direct            ;=$81:
_LE     = .scramble( txt_flight_le )    ;^$23=$A2
.import txt_flight_xe:direct            ;=$82:
_XE     = .scramble( txt_flight_xe )    ;^$23=$A1
.import txt_flight_ge:direct            ;=$83:
_GE     = .scramble( txt_flight_ge )    ;^$23=$A0
.import txt_flight_za:direct            ;=$84:
_ZA     = .scramble( txt_flight_za )    ;^$23=$A7
.import txt_flight_ce:direct            ;=$85:
_CE     = .scramble( txt_flight_ce )    ;^$23=$A6
.import txt_flight_bi:direct            ;=$86:
_BI     = .scramble( txt_flight_bi )    ;^$23=$A5
.import txt_flight_so:direct            ;=$87:
_SO     = .scramble( txt_flight_so )    ;^$23=$A4
.import txt_flight_us:direct            ;=$88:
_US     = .scramble( txt_flight_us )    ;^$23=$AB
.import txt_flight_es:direct            ;=$89:
_ES     = .scramble( txt_flight_es )    ;^$23=$AA
.import txt_flight_ar:direct            ;=$8A:
_AR     = .scramble( txt_flight_ar )    ;^$23=$A9
.import txt_flight_ma:direct            ;=$8B:
_MA     = .scramble( txt_flight_ma )    ;^$23=$A8
.import txt_flight_in:direct            ;=$8C:
_IN     = .scramble( txt_flight_in )    ;^$23=$AF
.import txt_flight_di:direct            ;=$8D:
_DI     = .scramble( txt_flight_di )    ;^$23=$AE
.import txt_flight_re:direct            ;=$8E:
_RE     = .scramble( txt_flight_re )    ;^$23=$AD
.import txt_flight_a_:direct            ;=$8F:
_A_     = .scramble( txt_flight_a_ )    ;=$23=$AC
.import txt_flight_er:direct            ;=$90:
_ER     = .scramble( txt_flight_er )    ;^$23=$B3
.import txt_flight_at:direct            ;=$91:
_AT     = .scramble( txt_flight_at )    ;^$23=$B2
.import txt_flight_en:direct            ;=$92:
_EN     = .scramble( txt_flight_en )    ;^$23=$B1
.import txt_flight_be:direct            ;=$93:
_BE     = .scramble( txt_flight_be )    ;^$23=$B0
.import txt_flight_ra:direct            ;=$94:
_RA     = .scramble( txt_flight_ra )    ;^$23=$B7
.import txt_flight_la:direct            ;=$95:
_LA     = .scramble( txt_flight_la )    ;^$23=$B6
.import txt_flight_ve:direct            ;=$96:
_VE     = .scramble( txt_flight_ve )    ;^$23=$B5
.import txt_flight_ti:direct            ;=$97:
_TI     = .scramble( txt_flight_ti )    ;^$23=$B4
.import txt_flight_ed:direct            ;=$98:
_ED     = .scramble( txt_flight_ed )    ;^$23=$BB
.import txt_flight_or:direct            ;=$99:
_OR     = .scramble( txt_flight_or )    ;^$23=$BA
.import txt_flight_qu:direct            ;=$9A:
_QU     = .scramble( txt_flight_qu )    ;^$23=$B9
.import txt_flight_an:direct            ;=$9B:
_AN     = .scramble( txt_flight_an )    ;^$23=$B8
.import txt_flight_te:direct            ;=$9C:
_TE     = .scramble( txt_flight_te )    ;^$23=$BF
.import txt_flight_is:direct            ;=$9D:
_IS     = .scramble( txt_flight_is )    ;^$23=$BE
.import txt_flight_ri:direct            ;=$9E:
_RI     = .scramble( txt_flight_ri )    ;^$23=$BD
.import txt_flight_on:direct            ;=$9F:
_ON     = .scramble( txt_flight_on )    ;^$23=$BC

.macro  .define_letter  id, index
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; define the version as used in the flight
        ; strings database (scrambled)
        ;
        .ident( id ) = .scramble( index )

        ; define the public version used in code,
        ; (unscrambled)
        ;
.export .ident( .concat( "TXT", id )) = index

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

__end           = $00

.define_letter  "__",           $20     ;^$23=$03 (space)
.define_letter  "_XMARK",       $21     ;^$23=$02 "!"
.define_letter  "_LPAREN",      $28     ;^$23=$0B "("
.define_letter  "_RPAREN",      $29     ;^$23=$0A ")"
.define_letter  "_HYPHEN",      $2d     ;^$23=$0E "-"
.define_letter  "_DOT",         $2e     ;^$23=$0D "."
.define_letter  "_SLASH",       $2f     ;^$23=$0C "/"
.define_letter  "_0",           $30     ;^$23=$13 "0"
.define_letter  "_1",           $31     ;^$23=$12 "1"
.define_letter  "_2",           $32     ;^$23=$11 "2"
.define_letter  "_3",           $33     ;^$23=$10 "3"
.define_letter  "_4",           $34     ;^$23=$17 "4"
.define_letter  "_5",           $35     ;^$23=$16 "5"
.define_letter  "_6",           $36     ;^$23=$15 "6"
.define_letter  "_7",           $37     ;^$23=$14 "7"
.define_letter  "_8",           $38     ;^$23=$1B "8"
.define_letter  "_9",           $39     ;^$23=$1A "9"
.define_letter  "_COLON",       $3a     ;^$23=$19 ":"
.define_letter  "_SEMI",        $3b     ;^$23=$18 ";"
.define_letter  "_LANGB",       $3c     ;^$23=$1F "<"
.define_letter  "_EQUALS",      $3d     ;^$23=$1E "="
.define_letter  "_RANGB",       $3e     ;^$23=$1D ">"
.define_letter  "_QMARK",       $3f     ;^$23=$1C "?"
.define_letter  "_ATMARK",      $40     ;^$23=$63 "@"
.define_letter  "_A",           $41     ;^$23=$62
.define_letter  "_B",           $42     ;^$23=$61
.define_letter  "_C",           $43     ;^$23=$60
.define_letter  "_D",           $44     ;^$23=$67
.define_letter  "_E",           $45     ;^$23=$66
.define_letter  "_F",           $46     ;^$23=$65
.define_letter  "_G",           $47     ;^$23=$64
.define_letter  "_H",           $48     ;^$23=$6B
.define_letter  "_I",           $49     ;^$23=$6A
.define_letter  "_J",           $4a     ;^$23=$69
.define_letter  "_K",           $4b     ;^$23=$68
.define_letter  "_L",           $4c     ;^$23=$6F
.define_letter  "_M",           $4d     ;^$23=$6E
.define_letter  "_N",           $4e     ;^$23=$6D
.define_letter  "_O",           $4f     ;^$23=$6C
.define_letter  "_P",           $50     ;^$23=$73
.define_letter  "_Q",           $51     ;^$23=$72
.define_letter  "_R",           $52     ;^$23=$71
.define_letter  "_S",           $53     ;^$23=$70
.define_letter  "_T",           $54     ;^$23=$77
.define_letter  "_U",           $55     ;^$23=$76
.define_letter  "_V",           $56     ;^$23=$75
.define_letter  "_W",           $57     ;^$23=$74
.define_letter  "_X",           $58     ;^$23=$7B
.define_letter  "_Y",           $59     ;^$23=$7A
.define_letter  "_Z",           $5a     ;^$23=$79


_word_index     .set 0

.macro  .define_word    word_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        .local  _value
        _value  .set 0

        _word_index .set _word_index + 1

        .if _word_index < 96
                _value .set .scramble($A0 + _word_index )

        .elseif _word_index < 128
                _value .set .scramble( _word_index )
        .else
                _value .set .scramble( _word_index - $72 )
        .endif

        ;;.out .sprintf(": $%0.2x: TXT%s", _value, word_id)
        .ident(word_id) = _value

.export .ident(.concat("TXT", word_id)) = .scramble( _value )

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.define .skip_word      _word_index .set _word_index + 1


.segment        "TEXT_FLIGHT"
;===============================================================================
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
_0700:  ;$A0: 0.                                                        ;$0700
.export _0700
        .byte   _FUEL_SCOOPS, _ON_, $24, __end

_0704:  ;$A1: 1.                                                        ;$0704
        .byte   __, _C, _H, _AR, _T, __end
        .define_word \
                "_CHART"        ; $A1^35 = $82

_070A:  ;$A2: 2.                                                        ;$070A
        .byte   _G, _O, _VE, _R, _N, _M, _EN, _T, __end
        .define_word \
                "_GOVERNMENT"   ; $A2^35 = $81

_0713:  ;$A3: 3.                                                        ;$0713
        .byte   _D, _AT, _A, _ON_, $20, __end
        .define_word \
                "_DATA_ON"      ; $A3^35 = $80

_0719:  ;$A4: 4.                                                        ;$0719
        .byte   _IN, _VE, _N, _T, _OR, _Y, $2f, __end
        .define_word \
                "_INVENTORY"    ; $A4^35 = $87

_0721:  ;$A5: 5.                                                        ;$0721
        .byte   _S, _Y, _S, _TE, _M, __end
        .define_word \
                "_SYSTEM"       ; $A5^35 = $86

_0727:  ;$A6: 6.                                                        ;$0727
        .byte   _P, _RI, _CE, __end
        .define_word \
                "_PRICE"        ; $A6^35 = $85

_072b:  ;$A7: 7.                                                        ;$072B
        .byte   $21, __, _MA, _R, _K, _E, _T, __, _PRICE, _S, __end
        .define_word \
                "_MARKET_PRICES"
                                ; $A7^35 = $84

_0736:  ;$A8: 8.                                                        ;$0736
        .byte   _IN, _D, _US, _T, _RI, _AL, __end
        .define_word \
                "_INDUSTRIAL"   ; $A8^35 = $8B

_073d:  ;$A9: 9.                                                        ;$073D
        .byte   _A, _G, _RI, _C, _U, _L, _T, _U, _RA, _L, __end
        .skip_word              ; $A9^35 = $8A

        ; wealth level:
        ;-----------------------------------------------------------------------
_0748:  ;$AA: 10.                                                       ;$0748
        .byte   _RI, _C, _H, __, __end
        .define_word \
                "_WEALTH"       ; $AA^35 = $89

_074d:  ;$AB: 11.                                                       ;$074D
        .byte   _A, _VE, _RA, _GE, __, __end
        .define_word \
                "_AVERAGE"      ; $AB^35 = $88

_0753:  ;$AC: 12.                                                       ;$0753
        .byte   _P, _O, _OR, __, __end
        .define_word \
                "_POOR"         ; $AC^35 = $8F
        ;-----------------------------------------------------------------------
        
_0758:  ;$AD: 13.                                                       ;$0758
        .byte   _MA, _IN, _L, _Y, __, __end
        .define_word \
                "_MAINLY"       ; $AD^35 = $8E

_075e:  ;$AE: 14.                                                       ;$075E
        .byte   _U, _N, _I, _T, __end
        .define_word \
                "_UNIT"         ; $AE^35 = $8D

_0763:  ;$AF: 15.                                                       ;$0763
        .byte   _V, _I, _E, _W, __, __end
        .define_word \
                "_VIEW"         ; $AF^35 = $8C

_0769:  ;$B0: 16.                                                       ;$0769
        .byte   _QU, _AN, _TI, _T, _Y, __end
        .define_word \
                "_QUANTITY"     ; $B0^35 = $93
        
_076f:  ;$B1: 17.                                                       ;$076F
        .byte   _AN, _AR, _C, _H, _Y, __end
        .define_word \
                "_ANARCHY"      ; $B1^35 = $92

_0775:  ;$B2: 18.                                                       ;$0775
        .byte   _F, _E, _U, _D, _AL, __end
        .skip_word              ; $B2^35 = $91

_077b:  ;$B3: 19.                                                       ;$077B
        .byte   _M, _U, _L, _TI, _HYPHEN, _GOVERNMENT, __end
        .skip_word              ; $B3^35 = $90
        
_0782:  ;$B4: 20.                                                       ;$0782
        .byte   _DI, _C, _T, _AT, _OR, _SHIP, __end
        .skip_word              ; $B4^34 = $97
        
_0789:  ;$B5: 21.                                                       ;$0789
        .byte   _COM, _M, _U, _N, _IS, _T, __end
        .skip_word              ; $B5^35 = $96

_0790:  ;$B6: 22.                                                       ;$0790
        .byte   _C, _ON, _F, _ED, _ER, _A, _C, _Y, __end
        .skip_word              ; $B6^35 = $95

_0799:  ;$B7: 23.                                                       ;$0799
        .byte   _D, _E, _M, _O, _C, _RA, _C, _Y, __end
        .skip_word              ; $B7^35 = $94

_07a2:  ;$B8: 24.                                                       ;$07A2
        .byte   _C, _OR, _P, _OR, _AT, _E, __, _ST, _AT, _E, __end
        .skip_word              ; $B8^35 = $9B

_07ad:  ;$B9: 25.                                                       ;$07AD
        .byte   _S, _H, _I, _P, __end
        .define_word \
                "_SHIP"         ; $B9^35 = $9A

_07b2:  ;$BA: 26.                                                       ;$07B2
        .byte   _P, _RO, _D, _U, _C, _T, __end
        .define_word \
                "_PRODUCT"      ; $BA^35 = $99

_07b9:  ;$BB: 27.                                                       ;$07B9
        .byte   __, _LA, _S, _ER, __end
        .define_word \
                "_LASER"        ; $BB^35 = $98

_07be:  ;$BC: 28.                                                       ;$07BE
        .byte   _H, _U, _M, _AN, __, _C, _O, _L, _ON, _I, _AL, __end
        .define_word \
                "_HUMAN_COLONIAL"
                                ; $BC^35 = $9F

_07ca:  ;$BD: 29.                                                       ;$07CA
        .byte   _H, _Y, _P, _ER, _S, _P, _A, _CE, __, __end
        .define_word \
                "_HYPERSPACE"   ; $BD^35 = $9E
        
_07d4:  ;$BE: 30.                                                       ;$07D4
        .byte   _S, _H, _OR, _T, __, _RANGE, _CHART, __end
        .define_word \
                "_SHORT_RANGE_CHART"
                                ; $BE^35 = $9D

_07dc:  ;$BF: 31.                                                       ;$07DC
        .byte   _DI, _ST, _AN, _CE, __end
        .define_word \
                "_DISTANCE"     ; $BF^35 = $9C

_07e1:  ;$C0: 32.                                                       ;$07E1
        .byte   _P, _O, _P, _U, _L, _AT, _I, _ON, __end
        .define_word \
                "_POPULATION"   ; $C0^35 = $E3

_07ea:  ;$C1: 33.                                                       ;$07EA
        .byte   _G, _RO, _S, _S, __, _PRODUCT, _I, _V, _I, _T, _Y, __end
        .define_word \
                "_GROSS_PRODUCTIVITY"
                                ; $C1^35 = $E2

_07f6:  ;$C2: 34.                                                       ;$07F6
        .byte   _E, _C, _ON, _O, _M, _Y, __end
        .define_word \
                "_ECONOMY"      ; $C2^35 = $E1
        
_07fd:  ;$C3: 35.                                                       ;$07FD
        .byte   __, _L, _I, _G, _H, _T, __, _Y, _E, _AR, _S, __end
        .define_word \
                "_LIGHT_YEARS"  ; $C3^35 = $E0

_0809:  ;$C4: 36.                                                       ;$0809
        .byte   _TE, _C, _H, _DOT, _LE, _VE, _L, __end
        .define_word \
                "_TECH_LEVEL"   ; $C4^35 = $E7
        
_0811:  ;$C5: 37.                                                       ;$0811
        .byte   _C, _A, _S, _H, __end
        .define_word \
                "_CASH"         ; $C5^35 = $E6
        
_0816:  ;$C6: 38.                                                       ;$0816
        .byte   __, _BI, _LL, _I, _ON, __end
        .define_word \
                "_BILLION"      ; $C6^35 = $E5

_081c:  ;$C7: 39.                                                       ;$081C
        .byte   _GALACTIC, _CHART, $22, __end
        .define_word \
                "_GALACTIC_CHART"
                                ; $C7^35 = $E4
        
_0820:  ;$C8: 40.                                                       ;$0820
        .byte   _T, _AR, _GE, _T, __, _L, _O, _ST, __end
        .skip_word              ; $C8^35 = $EB
        
_0829:  ;$C9: 41.                                                       ;$0829
        .byte   _MISSILE, __, _J, _A, _M, _M, _ED, __end
        .skip_word              ; $C9^35 = $EA
        
_0831:  ;$CA: 42.                                                       ;$0831
        .byte   _R, _AN, _GE, __end
        .define_word \
                "_RANGE"        ; $CA^35 = $E9
        
_0835:  ;$CB: 43.                                                       ;$0835
        .byte   _S, _T, __end
        .define_word \
                "_ST"           ; $CB^35 = $E8

_0838:  ;$CC: 44.                                                       ;$0838
        .byte   _QUANTITY, __, _O, _F, __, __end
        .define_word \
                "_QUANTITY_OF"  ; $CC^35 = $EF

_083e:  ;$CD: 45.                                                       ;$083E
        .byte   _S, _E, _LL, __end
        .define_word \
                "_SELL"         ; $CD^35 = $EE

_0842:  ;$CE: 46.                                                       ;$0842
        .byte   __, _C, _AR, _G, _O, $25, __end
        .define_word \
                "_CARGO"        ; $CE^35 = $ED
        
_0849:  ;$CF: 47.                                                       ;$0849
        .byte   _E, _QU, _I, _P, __end
        .define_word \
                "_EQUIP"        ; $CF^35 = $EC
        
_084e:  ;$D0: 48.                                                       ;$084E
        .byte   _F, _O, _O, _D, __end
        .define_word \
                "_FOOD"         ; $D0^35 = $F3
        
_0853:  ;$D1: 49.                                                       ;$0853
        .byte   _TE, _X, _TI, _L, _ES, __end
        .skip_word              ; $D1^35 = $F2
        
_0859:  ;$D2: 50.                                                       ;$0859
        .byte   _RA, _DI, _O, _A, _C, _TI, _VE, _S, __end
        .skip_word              ; $D2^35 = $F1
        
_0862:  ;$D3: 51.                                                       ;$0862
        .byte   _S, _LA, _VE, _S, __end
        .skip_word              ; $D3^35 = $F0
        
_0867:  ;$D4: 52.                                                       ;$0867
        .byte   _L, _I, _QU, _OR, $0c, _W, _IN, _ES, __end
        .skip_word              ; $D4^35 = $F7

_0870:  ;$D5: 53.                                                       ;$0870
        .byte   _L, _U, _X, _U, _RI, _ES, __end
        .skip_word              ; $D5^35 = $F6
        
_0877:  ;$D6: 54.                                                       ;$0877
        .byte   _N, _AR, _C, _O, _TI, _C, _S, __end
        .skip_word              ; $D6^35 = $F5
        
_087f:  ;$D7: 55.                                                       ;$087F
        .byte   _COM, _P, _U, _T, _ER, _S, __end
        .define_word \
                "_COMPUTERS"    ; $D7^35 = $F4
        
_0886:  ;$D8: 56.                                                       ;$0886
        .byte   _MA, _C, _H, _IN, _ER, _Y, __end
        .skip_word              ; $D8^35 = $FB
        
_088dc: ;$D9: 57.                                                       ;$088D
        .byte   _A, _L, _L, _O, _Y, _S, __end
        .skip_word              ; $D9^35 = $FA
        
_0894:  ;$DA: 58.                                                       ;$0894
        .byte   _F, _I, _RE, _AR, _M, _S, __end
        .skip_word              ; $DA^35 = $F9
        
_089b:  ;$DB: 59.                                                       ;$089B
        .byte   _F, _U, _R, _S, __end
        .skip_word              ; $DB^35 = $F8
        
_08a0:  ;$DC: 60.                                                       ;$08A0
        .byte   _M, _IN, _ER, _AL, _S, __end
        .skip_word              ; $DC^35 = $FF
        
_08a6:  ;$DD: 61.                                                       ;$08A6
        .byte   _G, _O, _L, _D, __end
        .skip_word              ; $DD^35 = $FE
        
_08ab:  ;$DE: 62.                                                       ;$08AB
        .byte   _P, _L, _AT, _IN, _U, _M, __end
        .skip_word              ; $DE^35 = $FD
        
_08b2:  ;$DF: 63.                                                       ;$08B2
        .byte   _GE, _M, _HYPHEN, _ST, _ON, _ES, __end
        .skip_word              ; $DF^35 = $FC
        
_08b9:  ;$E0: 64.                                                       ;$08B9
        .byte   _AL, _I, _EN, __, _ITEM, _S, __end
        .skip_word              ; $E0^35 = $C3

_08c0:  ;$E1: 65.                                                       ;$08C0
        .byte   $2f, $12, $13, $23, $16, $23, __end
        .skip_word              ; $E1^35 = $C2
        
_08c7:  ;$E2: 66.                                                       ;$08C7
        .byte   __, _C, _R, __end
        .define_word \
                "_CR"           ; $E2^35 = $C1
        
_08cb:  ;$E3: 67.                                                       ;$08CB
        .byte   _L, _AR, _GE, __end
        .define_word \
                "_LARGE"        ; $E3^35 = $C0
        
_08d0:  ;$E4: 68.                                                       ;$08D0
        .byte   _F, _I, _ER, _CE, __end
        .skip_word              ; $E4^35 = $C7

_08d4:  ;$E5: 69.                                                       ;$08D4
        .byte   _S, _MA, _LL, __end
        .skip_word              ; $E5^35 = $C6
        
        ; colours:
        ;-----------------------------------------------------------------------
_08d8:  ;$E6: 70.                                                       ;$08D8
        .byte   _G, _RE, _EN, __end
        .define_word \
                "_COLORS"       ; $E6^35 = $C5
        
_08dc:  ;$E7: 71.                                                       ;$08DC
        .byte   _R, _ED, __end
        .skip_word              ; $E7^35 = $C4
        
_08df:  ;$E8: 72.                                                       ;$08DF
        .byte   _Y, _E, _LL, _O, _W, __end
        .skip_word              ; $E8^35 = $CB
        
_08e5:  ;$E9: 73.                                                       ;$08E5
        .byte   _B, _L, _U, _E, __end
        .skip_word              ; $E9^35 = $CA
        
_08ea:  ;$EA: 74.                                                       ;$08EA
        .byte   _B, _LA, _C, _K, __end
        .skip_word              ; $EA^35 = $C9

        ; adjectives
        ;-----------------------------------------------------------------------
_08ef:  ;$EB: 75.                                                       ;$08EF
        .byte   _HARMLESS, __end
        .define_word \
                "_ADJECTIVES"   ; $EB^35 = $C8
        
_08f1:  ;$EC: 76.                                                       ;$08F1
        .byte   _S, _L, _I, _M, _Y, __end
        .skip_word              ; $EC^35 = $CF
        
_08f7:  ;$ED: 77.                                                       ;$08F7
        .byte   _B, _U, _G, _HYPHEN, _E, _Y, _ED, __end
        .skip_word              ; $ED^35 = $CE
        
_08ff:  ;$EE: 78.                                                       ;$08FF
        .byte   _H, _OR, _N, _ED, __end
        .skip_word              ; $EE^35 = $CD

_0904:  ;$EF: 79.                                                       ;$0904
        .byte   _B, _ON, _Y, __end
        .skip_word              ; $EF^35 = $CC

_0908:  ;$F0: 80.                                                       ;$0908
        .byte   _F, _AT, __end
        .skip_word              ; $F0^35 = $D3
        
_090b:  ;$F1: 81.                                                       ;$090B
        .byte   _F, _U, _R, _R, _Y, __end
        .skip_word              ; $F1^35 = $D2
        
        ; species:
        ;-----------------------------------------------------------------------
_0911:  ;$F2: 82.                                                       ;$0911
        .byte   _RO, _D, _EN, _T, __end
        .define_word \
                "_SPECIES"      ; $F2^35 = $D1
        
_0916:  ;$F3: 83.                                                       ;$0916
        .byte   _F, _RO, _G, __end
        .skip_word              ; $F3^35 = $D0
        
_091a:  ;$F4: 84.                                                       ;$091A
        .byte   _L, _I, _ZA, _R, _D, __end
        .skip_word              ; $F4^35 = $D7

_0920:  ;$F5: 85.                                                       ;$0920
        .byte   _L, _O, _B, _ST, _ER, __end
        .skip_word              ; $F5^35 = $D6
        
_0926:  ;$F6: 86.                                                       ;$0926
        .byte   _BI, _R, _D, __end
        .skip_word              ; $F6^35 = $D5
        
_092a:  ;$F7: 87.                                                       ;$092A
        .byte   _H, _U, _M, _AN, _O, _I, _D, __end
        .skip_word              ; $F7^35 = $D4
        
_0932:  ;$F8: 88.                                                       ;$0932
        .byte   _F, _E, _L, _IN, _E, __end
        .skip_word              ; $F8^35 = $DB

_0938:  ;$F9: 89.                                                       ;$0938
        .byte   _IN, _S, _E, _C, _T, __end
        .skip_word              ; $F9^35 = $DA
        ;-----------------------------------------------------------------------

_093e:  ;$FA: 90.                                                       ;$093E
        .byte   _AVERAGE, _RA, _DI, _US, __end
        .define_word \
                "_AVERAGE_RADIUS"
                                ; $FA^35 = $D9
        
_0943:  ;$FB: 91.                                                       ;$0943
        .byte   _C, _O, _M, __end
        .define_word \
                "_COM"          ; $FB^35 = $D8
        
_0947:  ;$FC: 92.                                                       ;$0947
        .byte   _COM, _M, _AN, _D, _ER, __end
        .define_word \
                "_COMMANDER"    ; $FC^35 = $DF

_094d:  ;$FD: 93.                                                       ;$094D
        .byte   __, _D, _ES, _T, _RO, _Y, _ED, __end
        .define_word \
                "_DESTROYED"    ; $FD^35 = $DE
        
_0955:  ;$FE: 94.                                                       ;$0955
        .byte   _R, _O, __end
        .define_word \
                "_RO"           ; $FE^35 = $DD

_0958:  ;$FF: 95.                                                       ;$0958
        .byte   _UNIT, __, __, _QUANTITY, $2f, __
        .byte   _PRODUCT, __, __, __, _UNIT, __
        .byte   _PRICE, __, _F, _OR, __, _S, _A, _LE, $2f, $29, __end
        .skip_word              ; $FF^35 = $DC

;-------------------------------------------------------------------------------
; at this point a different set of token numbers are used
;
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
        ; cockpit view directions:
        ;-----------------------------------------------------------------------
_096f:  ;$60: 96.                                                       ;$096F
        .byte   _F, _R, _ON, _T, __end
        .define_word \
                "_DIRECTIONS"   ; $60^35 = $43
        
_0974:  ;$61: 97.                                                       ;$0974
        .byte   _RE, _AR, __end
        .skip_word              ; $61^35 = $42
        
_0977:  ;$62: 98.                                                       ;$0977
        .byte   _LE, _F, _T, __end
        .skip_word              ; $62^35 = $41

_097b:  ;$63: 99.                                                       ;$097B
        .byte   _RI, _G, _H, _T, __end
        .define_word \
                "_RIGHT"        ; $63^35 = $40
        ;-----------------------------------------------------------------------

_0980:  ;$64: 100.                                                      ;$0980
        .byte   _ENERGY, _L, _O, _W, $24, __end
        .skip_word              ; $64^35 = $47
        
_0986:  ;$65: 101.                                                      ;$0986
        .byte   _RIGHT, _ON_, _COMMANDER, $02, __end
        .skip_word              ; $65^35 = $46

_098b:  ;$66: 102.                                                      ;$098B
        .byte   _E, _X, _T, _RA, __, __end
        .define_word \
                "_EXTRA"        ; $66^35 = $45
        
_0991:  ;$67: 103.                                                      ;$0991
        .byte   _P, _U, _L, _S, _E, _LASER, __end
        .define_word \
                "_PULSE_LASER"  ; $67^35 = $44

_0998:  ;$68: 104.                                                      ;$0998
        .byte   _BE, _A, _M, _LASER, __end
        .define_word \
                "_BEAM_LASER"   ; $68^35 = $4B
        
_099d:  ;$69: 105.                                                      ;$099D
        .byte   _F, _U, _E, _L, __end
        .define_word \
                "_FUEL"         ; $69^35 = $4A
        
_09a2:  ;$6A: 106.                                                      ;$09A2
        .byte   _M, _IS, _S, _I, _LE, __end
        .define_word \
                "_MISSILE"      ; $6A^35 = $49

_09a8:  ;$6B: 107.                                                      ;$09A8
        .byte   _LARGE, _CARGO, __, _B, _A, _Y, __end
        .define_word \
                "_LARGE_CARGO_BAY"
                                ; $6B^35 = $48
        
_09af:  ;$6C: 108.                                                      ;$09AF
        .byte   _E, _DOT, _C, _DOT, _M, _DOT, _SYSTEM, __end
        .define_word \
                "_ECM_SYSTEM"   ; $6C^35 = $4F

_09b7:  ;$6D: 109.                                                      ;$09B7
        .byte   _EXTRA, _PULSE_LASER, _S, __end
        .define_word \
                "_EXTRA_PULSE_LASERS"
                                ; $6D^35 = $4E

_09bb:  ;$6E: 110.                                                      ;$09BB
        .byte   _EXTRA, _BEAM_LASER, _S, __end
        .skip_word              ; $6E^35 = $4D

_09bf:  ;$6F: 111.                                                      ;$09BF
        .byte   _FUEL, __, _S, _C, _O, _O, _P, _S, __end
        .define_word \
                "_FUEL_SCOOPS"  ; $6F^35 = $4C

_09c8:  ;$70: 112.                                                      ;$09C8
        .byte   _ES, _C, _A, _P, _E, __, _P, _O, _D, __end
        .define_word \
                "_ESCAPE_POD"   ; $70^35 = $53
        
_09d2:  ;$71: 113.                                                      ;$09D2
        .byte   _ENERGY, _B, _O, _M, _B, __end
        .skip_word              ; $71^35 = $52

_09d8:  ;$72: 114.                                                      ;$09D8
        .byte   _EXTRA, _ENERGY, _UNIT, __end
        .skip_word              ; $72^35 = $51
        
_09dc:  ;$73: 115.                                                      ;$09dC
        .byte   _D, _O, _C, _K, _IN, _G, __, _COMPUTERS, __end
        .define_word \
                "_DOCKING_COMPUTERS"
                                ; $73^35 = $50

_09e5:  ;$74: 116.                                                      ;$09E5
        .byte   _GALACTIC, __, _HYPERSPACE, __end
        .skip_word              ; $74^35 = $57
        
_09e9:  ;$75: 117.                                                      ;$09E9
        .byte   _M, _I, _L, _I, _T, _AR, _Y, __, _LASER, __end
        .skip_word              ; $75^35 = $56
        
_09f3:  ;$76: 118.                                                      ;$09F3
        .byte   _M, _IN, _IN, _G, __, _LASER, __end
        .define_word \
                "_MINING_LASER" ; $76^35 = $55
        
_09fa:  ;$77: 119.                                                      ;$09FA
        .byte   _CASH, _COLON, $23, __end
        .define_word \
                "_CASH_"        ; $77^35 = $54

_09fe:  ;$78: 120.                                                      ;$09FE
        .byte   _IN, _COM, _IN, _G, __, _MISSILE, __end
        .skip_word              ; $78^35 = $5B

_0a05:  ;$79: 121.                                                      ;$0A05
        .byte   _EN, _ER, _G, _Y, __, __end
        .define_word \
                "_ENERGY"       ; $79^35 = $5A
        
_0a0b:  ;$7A: 122.                                                      ;$0A0B
        .byte   _G, _A, _LA, _C, _TI, _C, __end
        .define_word \
                "_GALACTIC"     ; $7A^35 = $59

_0a12:  ;$7B: 123.                                                      ;$0A12
        .byte   _DOCKING_COMPUTERS, __, _O, _N, __end
        .skip_word              ; $7B^35 = $58


_0a17:  ;$7C: 124.                                                      ;$0A17
        .byte   _A, _LL, __end
        .skip_word              ; $7C^35 = $5F
        
_0a1a:  ;$7D: 125.                                                      ;$0A1A
        .byte   $26, _LE, _G, _AL, __, _ST, _AT, _US, _COLON, __end
        .define_word \
                "_LEGAL_STATUS" ; $7D^35 = $5E

_0a24:  ;$7E: 126.                                                      ;$0A24
        .byte   _COMMANDER, __, $27, $2f, $2f, $2f, $25
        .byte   _PRESENT, __, _SYSTEM, $2a, $21, $2f, _HYPERSPACE
        .byte   _SYSTEM, $2a, $20, $2f
        .byte   _C, _ON, _DI, _TI, _ON, $2a, __end
        .define_word \
                "_STATUS_TITLE" ; $7E^35 = $5D
        
_0a3d:  ;$7F: 127.                                                      ;$0A3D
        .byte   _I, _TE, _M, __end
        .define_word \
                "_ITEM"         ; $7F^35 = $5C
        
;-------------------------------------------------------------------------------
; at this point a different set of token numbers are used
;
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
_0a41:  ;$0E: 128.                                                      ;$0A41
        ; this has to be skipped because its code is the same as hyphen,
        ; and its de-scrambled value $0E is a meta-command (switch case?)
        .byte   __end
        .skip_word              ; $0E^35 = $2D
        
_0a42:  ;$0F: 129.                                                      ;$0A42
        .byte   _L, _L, __end
        .define_word \
                "_LL"           ; $0F^35 = $2C
        
_0a45:  ;$10: 130.                                                      ;$0A45
        .byte   _RA, _TI, _N, _G, _COLON, __end
        .define_word \
                "_RATING"       ; $10^35 = $33
        
_0a4b:  ;$11: 131.                                                      ;$0A4B
        .byte   __, _ON, __, __end
        .define_word \
                "_ON_"          ; $11^35 = $32
        
_0a4f:  ;$12: 132.                                                      ;$0A4F
        .byte   $2f, $2b, _EQUIP, _M, _EN, _T, _COLON, $25, __end
        .define_word \
                "_EQUIPMENT"    ; $12^35 = $31

        ; legal status:
        ;-----------------------------------------------------------------------
_0a58:  ;$13: 133.                                                      ;$0A58
        .byte   _C, _LE, _AN, __end
        .define_word \
                "_LEGAL_STATE"  ; $13^35 = $30
        
_0a5c:  ;$14: 134.                                                      ;$0A5C
        .byte   _O, _F, _F, _EN, _D, _ER, __end
        .skip_word              ; $14^35 = $37
        
_0a63:  ;$15: 135.                                                      ;$0A63
        .byte   _F, _U, _G, _I, _TI, _VE, __end
        .skip_word              ; $15^35 = $36
        ;-----------------------------------------------------------------------

_0a6a:  ;$16: 136.                                                      ;$0A6A
        .byte   _H, _AR, _M, _LE, _S, _S, __end
        .define_word \
                "_HARMLESS"     ; $16^35 = $35
        
_0a71:  ;$17: 137.                                                      ;$0A71
        .byte   _M, _O, _ST, _L, _Y, __, _HARMLESS, __end
        .skip_word              ; $17^35 = $34
        
_0a79:  ;$18: 138.                                                      ;$0A79
        .byte   _POOR, __end
        .skip_word              ; $18^35 = $3B
        
_0a7b:  ;$19: 139.                                                      ;$0A7B
        .byte   _AVERAGE, __end
        .skip_word              ; $19^35 = $3A
        
_0a7d:  ;$1A: 140.                                                      ;$0A7D
        .byte   _A, _B, _O, _VE, __, _AVERAGE, __end
        .skip_word              ; $1A^35 = $39
        
_0a84:  ;$1B: 141.                                                      ;$0A84
        .byte   _COM, _P, _E, _T, _EN, _T, __end
        .skip_word              ; $1B^35 = $38
        
_0a8b:  ;$1C: 142.                                                      ;$0A8B
        .byte   _D, _AN, _GE, _RO, _US, __end
        .skip_word              ; $1C^35 = $3F
        
_0a91:  ;$1D: 143.                                                      ;$0A91
        .byte   _D, _E, _A, _D, _L, _Y, __end
        .skip_word              ; $1D^35 = $3E

_0a98:  ;$1E: 144.                                                      ;$0A98
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN
        .byte   __, _E, __, _L, __, _I, __, _T, __, _E, __
        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN, __end
.else   ;///////////////////////////////////////////////////////////////////////
        .byte   _E, __, _L, __, _I, __, _T, __, _E
        .byte   __, __, _COLON, __, __
        .byte   _H, __, _A, __, _R, __, _M, __, _L, __, _E, __, _S, __, _S
        .byte   __end
.endif  ;///////////////////////////////////////////////////////////////////////
        .define_word \
                "_ELITE"        ; $1E^35 = $3D

_0aac:  ;$1F: 145.                                                      ;$0AAC
        .byte   _P, _RE, _S, _EN, _T, __end
        .define_word \
                "_PRESENT"      ; $1F^35 = $3C

_0ab2:  ;$20: 146.                                                      ;$0AB2
        .byte   $2b, _G, _A, _M, _E, __, _O, _VE, _R, __end
        .skip_word              ; $20^35 = $03 (same as space?)
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; padding
        .byte   $00, $00, $00, $00                                      ;$0ABC
.endif  ;///////////////////////////////////////////////////////////////////////
