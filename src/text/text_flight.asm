; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

; this file stores the more common strings, typically used when in 'flight'
; mode, but this also includes some of the shared menu screens that can be
; accessed either in flight or docked, such as player status. whilst this
; string pool does contain much of the text on the planet status screen,
; it doesn't include the planet description strings, that's a very complex
; system and those are stored in the 'docked' string pool


; this is the 'key' used to scramble / unscramble the text token symbols
; https://xania.org/201406/elites-crazy-string-format
.export TXT_FLIGHT_XOR := $23

; all tokens on disk are scrambled in this way:
.define .encrypt(value) value ^ TXT_FLIGHT_XOR


.import txt_flight_al:direct
_AL     = .encrypt( txt_flight_al )        ;=$A3
.import txt_flight_le:direct
_LE     = .encrypt( txt_flight_le )        ;=$A2
.import txt_flight_xe:direct
_XE     = .encrypt( txt_flight_xe )        ;=$A1
.import txt_flight_ge:direct
_GE     = .encrypt( txt_flight_ge )        ;=$A0
.import txt_flight_za:direct
_ZA     = .encrypt( txt_flight_za )        ;=$A7
.import txt_flight_ce:direct
_CE     = .encrypt( txt_flight_ce )        ;=$A6
.import txt_flight_bi:direct
_BI     = .encrypt( txt_flight_bi )        ;=$A5
.import txt_flight_so:direct
_SO     = .encrypt( txt_flight_so )        ;=$A4
.import txt_flight_us:direct
_US     = .encrypt( txt_flight_us )        ;=$AB
.import txt_flight_es:direct
_ES     = .encrypt( txt_flight_es )        ;=$AA
.import txt_flight_ar:direct
_AR     = .encrypt( txt_flight_ar )        ;=$A9
.import txt_flight_ma:direct
_MA     = .encrypt( txt_flight_ma )        ;=$A8
.import txt_flight_in:direct
_IN     = .encrypt( txt_flight_in )        ;=$AF
.import txt_flight_di:direct
_DI     = .encrypt( txt_flight_di )        ;=$AE
.import txt_flight_re:direct
_RE     = .encrypt( txt_flight_re )        ;=$AD
.import txt_flight_a_:direct
_A      = .encrypt( txt_flight_a_ )        ;=$AC
.import txt_flight_er:direct
_ER     = .encrypt( txt_flight_er )        ;=$B3
.import txt_flight_at:direct
_AT     = .encrypt( txt_flight_at )        ;=$B2
.import txt_flight_en:direct
_EN     = .encrypt( txt_flight_en )        ;=$B1
.import txt_flight_be:direct
_BE     = .encrypt( txt_flight_be )        ;=$B0
.import txt_flight_ra:direct
_RA     = .encrypt( txt_flight_ra )        ;=$B7
.import txt_flight_la:direct
_LA     = .encrypt( txt_flight_la )        ;=$B6
.import txt_flight_ve:direct
_VE     = .encrypt( txt_flight_ve )        ;=$B5
.import txt_flight_ti:direct
_TI     = .encrypt( txt_flight_ti )        ;=$B4
.import txt_flight_ed:direct
_ED     = .encrypt( txt_flight_ed )        ;=$BB
.import txt_flight_or:direct
_OR     = .encrypt( txt_flight_or )        ;=$BA
.import txt_flight_qu:direct
_QU     = .encrypt( txt_flight_qu )        ;=$B9
.import txt_flight_an:direct
_AN     = .encrypt( txt_flight_an )        ;=$B8
.import txt_flight_te:direct
_TE     = .encrypt( txt_flight_te )        ;=$BF
.import txt_flight_is:direct
_IS     = .encrypt( txt_flight_is )        ;=$BE
.import txt_flight_ri:direct
_RI     = .encrypt( txt_flight_ri )        ;=$BD
.import txt_flight_on:direct
_ON     = .encrypt( txt_flight_on )        ;=$BC

__end           = $00
__              = .encrypt ( $20 )              ;=$03
_DOT            = .encrypt ( $2E )              ;=$0D
A_              = .encrypt ( $41 )              ;=$62
B_              = .encrypt ( $42 )              ;=$61
C_              = .encrypt ( $43 )              ;=$60
D_              = .encrypt ( $44 )              ;=$67
E_              = .encrypt ( $45 )              ;=$66
F_              = .encrypt ( $46 )              ;=$65
G_              = .encrypt ( $47 )              ;=$64
H_              = .encrypt ( $48 )              ;=$6b
I_              = .encrypt ( $49 )              ;=$6a
J_              = .encrypt ( $4a )              ;=$69
K_              = .encrypt ( $4b )              ;=$68
L_              = .encrypt ( $4c )              ;=$6f
M_              = .encrypt ( $4d )              ;=$6e
N_              = .encrypt ( $4e )              ;=$6d
O_              = .encrypt ( $4f )              ;=$6c
P_              = .encrypt ( $50 )              ;=$73
Q_              = .encrypt ( $51 )              ;=$72
R_              = .encrypt ( $52 )              ;=$71
S_              = .encrypt ( $53 )              ;=$70
T_              = .encrypt ( $54 )              ;=$77
U_              = .encrypt ( $55 )              ;=$76
V_              = .encrypt ( $56 )              ;=$75
W_              = .encrypt ( $57 )              ;=$74
X_              = .encrypt ( $58 )              ;=$7b
Y_              = .encrypt ( $59 )              ;=$7a
Z_              = .encrypt ( $5a )              ;=$79
_HYPHEN         = .encrypt ( $2d )              ;=$0E
_COLON          = .encrypt ( $3a )              ;=$19

_word_index     .set 0

.macro  .define_word    word_id
;///////////////////////////////////////////////////////////////////////////////
        
        .local  _value
        _value  .set 0

        _word_index .set _word_index + 1

        .if _word_index < 96
                _value .set .encrypt ($A0 + _word_index )

        .elseif _word_index < 128
                _value .set .encrypt( _word_index )
        .else
                _value .set .encrypt( _word_index - $72 )
        .endif

        ;;.out .sprintf(": $%0.2x: TXT%s", _value, word_id)
        .ident(word_id) = _value

        .export .ident(.concat("TXT", word_id)) = .encrypt( _value )

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.define .skip_word      _word_index .set _word_index + 1

;===============================================================================

.segment        "TEXT_FLIGHT"

_0700:  ;0.                                                             ;$0700
.export _0700
        .byte   _FUEL_SCOOPS, _ON_, $24, __end

_0704:  ;1.                                                             ;$0704
        .byte   __, C_, H_, _AR, T_, __end
        .define_word \
                "_CHART"        ; $A1^35 = $82

_070A:  ;2.                                                             ;$070A
        .byte   G_, O_, _VE, R_, N_, M_, _EN, T_, __end
        .define_word \
                "_GOVERNMENT"   ; $A2^35 = $81

_0713:  ;3.                                                             ;$0713
        .byte   D_, _AT, A_, _ON_, $20, __end
        .define_word \
                "_DATA_ON"      ; $A3^35 = $80

_0719:  ;4.                                                             ;$0719
        .byte   _IN, _VE, N_, T_, _OR, Y_, $2f, __end
        .define_word \
                "_INVENTORY"    ; $A4^35 = $87

_0721:  ;5.                                                             ;$0721
        .byte   S_, Y_, S_, _TE, M_, __end
        .define_word \
                "_SYSTEM"       ; $A5^35 = $86

_0727:  ;6.                                                             ;$0727
        .byte   P_, _RI, _CE, __end
        .define_word \
                "_PRICE"        ; $A6^35 = $85

_072b:  ;7.                                                             ;$072B
        .byte   $21, __, _MA, R_, K_, E_, T_, __, _PRICE, S_, __end
        .define_word \
                "_MARKET_PRICES"
                                ; $A7^35 = $84

_0736:  ;8.                                                             ;$0736
        .byte   _IN, D_, _US, T_, _RI, _AL, __end
        .define_word \
                "_INDUSTRIAL"   ; $A8^35 = $8B

_073d:  ;9.                                                             ;$073D
        .byte   A_, G_, _RI, C_, U_, L_, T_, U_, _RA, L_, __end
        .skip_word              ; $A9^35 = $8A

_0748:  ;10.                                                            ;$0748
        .byte   _RI, C_, H_, __, __end
        .define_word \
                "_RICH"         ; $AA^35 = $89

_074d:  ;11.                                                            ;$074D
        .byte   A_, _VE, _RA, _GE, __, __end
        .define_word \
                "_AVERAGE"      ; $AB^35 = $88

_0753:  ;12.                                                            ;$0753
        .byte   P_, O_, _OR, __, __end
        .define_word \
                "_POOR"         ; $AC^35 = $8F
        
_0758:  ;13.                                                            ;$0758
        .byte   _MA, _IN, L_, Y_, __, __end
        .define_word \
                "_MAINLY"       ; $AD^35 = $8E
        
_075e:  ;14.                                                            ;$075E
        .byte   U_, N_, I_, T_, __end
        .define_word \
                "_UNIT"         ; $AE^35 = $8D

_0763:  ;15.                                                            ;$0763
        .byte   V_, I_, E_, W_, __, __end
        .define_word \
                "_VIEW"         ; $AF^35 = $8C

_0769:  ;16.                                                            ;$0769
        .byte   _QU, _AN, _TI, T_, Y_, __end
        .define_word \
                "_QUANTITY"     ; $B0^35 = $93
        
_076f:  ;17.                                                            ;$076F
        .byte   _AN, _AR, C_, H_, Y_, __end
        .define_word \
                "_ANARCHY"      ; $B1^35 = $92

_0775:  ;18.                                                            ;$0775
        .byte   F_, E_, U_, D_, _AL, __end
        .skip_word              ; $B2^35 = $91

_077b:  ;19.                                                            ;$077B
        .byte   M_, U_, L_, _TI, _HYPHEN, _GOVERNMENT, __end
        .skip_word              ; $B3^35 = $90
        
_0782:  ;20.                                                            ;$0782
        .byte   _DI, C_, T_, _AT, _OR, _SHIP, __end
        .skip_word              ; $B4^34 = $97
        
_0789:  ;21.                                                            ;$0789
        .byte   _COM, M_, U_, N_, _IS, T_, __end
        .skip_word              ; $B5^35 = $96

_0790:  ;22.                                                            ;$0790
        .byte   C_, _ON, F_, _ED, _ER, A_, C_, Y_, __end
        .skip_word              ; $B6^35 = $95

_0799:  ;23.                                                            ;$0799
        .byte   D_, E_, M_, O_, C_, _RA, C_, Y_, __end
        .skip_word              ; $B7^35 = $94

_07a2:  ;24.                                                            ;$07A2
        .byte   C_, _OR, P_, _OR, _AT, E_, __, _ST, _AT, E_, __end
        .skip_word              ; $B8^35 = $9B

_07ad:  ;25.                                                            ;$07AD
        .byte   S_, H_, I_, P_, __end
        .define_word \
                "_SHIP"         ; $B9^35 = $9A

_07b2:  ;26.                                                            ;$07B2
        .byte   P_, _RO, D_, U_, C_, T_, __end
        .define_word \
                "_PRODUCT"      ; $BA^35 = $99

_07b9:  ;27.                                                            ;$07B9
        .byte   __, _LA, S_, _ER, __end
        .define_word \
                "_LASER"        ; $BB^35 = $98

_07be:  ;28.                                                            ;$07BE
        .byte   H_, U_, M_, _AN, __, C_, O_, L_, _ON, I_, _AL, __end
        .define_word \
                "_HUMAN_COLONIAL"
                                ; $BC^35 = $9F

_07ca:  ;29.                                                            ;$07CA
        .byte   H_, Y_, P_, _ER, S_, P_, A_, _CE, __, __end
        .define_word \
                "_HYPERSPACE"   ; $BD^35 = $9E
        
_07d4:  ;30.                                                            ;$07D4
        .byte   S_, H_, _OR, T_, __, _RANGE, _CHART, __end
        .define_word \
                "_SHORT_RANGE_CHART"
                                ; $BE^35 = $9D

_07dc:  ;31.                                                            ;$07DC
        .byte   _DI, _ST, _AN, _CE, __end
        .define_word \
                "_DISTANCE"     ; $BF^35 = $9C

_07e1:  ;32.                                                            ;$07E1
        .byte   P_, O_, P_, U_, L_, _AT, I_, _ON, __end
        .define_word \
                "_POPULATION"   ; $C0^35 = $E3

_07ea:  ;33.                                                            ;$07EA
        .byte   G_, _RO, S_, S_, __, _PRODUCT, I_, V_, I_, T_, Y_, __end
        .define_word \
                "_GROSS_PRODUCTIVITY"
                                ; $C1^35 = $E2

_07f6:  ;34.                                                            ;$07F6
        .byte   E_, C_, _ON, O_, M_, Y_, __end
        .define_word \
                "_ECONOMY"      ; $C2^35 = $E1
        
_07fd:  ;35.                                                            ;$07FD
        .byte   __, L_, I_, G_, H_, T_, __, Y_, E_, _AR, S_, __end
        .define_word \
                "_LIGHT_YEARS"  ; $C3^35 = $E0

_0809:  ;36.                                                            ;$0809
        .byte   _TE, C_, H_, _DOT, _LE, _VE, L_, __end
        .define_word \
                "_TECH_LEVEL"   ; $C4^35 = $E7
        
_0811:  ;37.                                                            ;$0811
        .byte   C_, A_, S_, H_, __end
        .define_word \
                "_CASH"         ; $C5^35 = $E6
        
_0816:  ;38.                                                            ;$0816
        .byte   __, _BI, _LL, I_, _ON, __end
        .define_word \
                "_BILLION"      ; $C6^35 = $E5

_081c:  ;39.                                                            ;$081C
        .byte   _GALACTIC, _CHART, $22, __end
        .define_word \
                "_GALACTIC_CHART"
                                ; $C7^35 = $E4
        
_0820:  ;40.                                                            ;$0820
        .byte   T_, _AR, _GE, T_, __, L_, O_, _ST, __end
        .skip_word              ; $C8^35 = $EB
        
_0829:  ;41.                                                            ;$0829
        .byte   _MISSILE, __, J_, A_, M_, M_, _ED, __end
        .skip_word              ; $C9^35 = $EA
        
_0831:   ;42.                                                           ;$0831
        .byte   R_, _AN, _GE, __end
        .define_word \
                "_RANGE"        ; $CA^35 = $E9
        
_0835:  ;43.                                                            ;$0835
        .byte   S_, T_, __end
        .define_word \
                "_ST"           ; $CB^35 = $E8

_0838:  ;44.                                                            ;$0838
        .byte   _QUANTITY, __, O_, F_, __, __end
        .define_word \
                "_QUANTITY_OF"  ; $CC^35 = $EF

_083e:  ;45.                                                            ;$083E
        .byte   S_, E_, _LL, __end
        .define_word \
                "_SELL"         ; $CD^35 = $EE

_0842:  ;46.                                                            ;$0842
        .byte   __, C_, _AR, G_, O_, $25, __end
        .define_word \
                "_CARGO"        ; $CE^35 = $ED
        
_0849:  ;47.                                                            ;$0849
        .byte   E_, _QU, I_, P_, __end
        .define_word \
                "_EQUIP"        ; $CF^35 = $EC
        
_084e:  ;48.                                                            ;$084E
        .byte   F_, O_, O_, D_, __end
        .define_word \
                "_FOOD"         ; $D0^35 = $F3
        
_0853:  ;49.                                                            ;$0853
        .byte   _TE, X_, _TI, L_, _ES, __end
        .skip_word              ; $D1^35 = $F2
        
_0859:  ;50.                                                            ;$0859
        .byte   _RA, _DI, O_, A_, C_, _TI, _VE, S_, __end
        .skip_word              ; $D2^35 = $F1
        
_0862:  ;51.                                                            ;$0862
        .byte   S_, _LA, _VE, S_, __end
        .skip_word              ; $D3^35 = $F0
        
_0867:  ;52.                                                            ;$0867
        .byte   L_, I_, _QU, _OR, $0c, W_, _IN, _ES, __end
        .skip_word              ; $D4^35 = $F7

_0870:  ;53.                                                            ;$0870
        .byte   L_, U_, X_, U_, _RI, _ES, __end
        .skip_word              ; $D5^35 = $F6
        
_0877:  ;54.                                                            ;$0877
        .byte   N_, _AR, C_, O_, _TI, C_, S_, __end
        .skip_word              ; $D6^35 = $F5
        
_087f:  ;55.                                                            ;$087F
        .byte   _COM, P_, U_, T_, _ER, S_, __end
        .define_word \
                "_COMPUTERS"    ; $D7^35 = $F4
        
_0886:  ;56.                                                            ;$0886
        .byte   _MA, C_, H_, _IN, _ER, Y_, __end
        .skip_word              ; $D8^35 = $FB
        
_088dc: ;57.                                                            ;$088D
        .byte   A_, L_, L_, O_, Y_, S_, __end
        .skip_word              ; $D9^35 = $FA
        
_0894:  ;58.                                                            ;$0894
        .byte   F_, I_, _RE, _AR, M_, S_, __end
        .skip_word              ; $DA^35 = $F9
        
_089b:  ;59.                                                            ;$089B
        .byte   F_, U_, R_, S_, __end
        .skip_word              ; $DB^35 = $F8
        
_08a0:  ;60.                                                            ;$08A0
        .byte   M_, _IN, _ER, _AL, S_, __end
        .skip_word              ; $DC^35 = $FF
        
_08a6:  ;61.                                                            ;$08A6
        .byte   G_, O_, L_, D_, __end
        .skip_word              ; $DD^35 = $FE
        
_08ab:  ;62.                                                            ;$08AB
        .byte   P_, L_, _AT, _IN, U_, M_, __end
        .skip_word              ; $DE^35 = $FD
        
_08b2:  ;63.                                                            ;$08B2
        .byte   _GE, M_, _HYPHEN, _ST, _ON, _ES, __end
        .skip_word              ; $DF^35 = $FC
        
_08b9:  ;64.                                                            ;$08B9
        .byte   _AL, I_, _EN, __, _ITEM, S_, __end
        .skip_word              ; $E0^35 = $C3

_08c0:  ;65.                                                            ;$08C0
        .byte   $2f, $12, $13, $23, $16, $23, __end
        .skip_word              ; $E1^35 = $C2
        
_08c7:  ;66.                                                            ;$08C7
        .byte   __, C_, R_, __end
        .define_word \
                "_CR"           ; $E2^35 = $C1
        
_08cb:  ;67.                                                            ;$08CB
        .byte   L_, _AR, _GE, __end
        .define_word \
                "_LARGE"        ; $E3^35 = $C0
        
_08d0:  ;68.                                                            ;$08D0
        .byte   F_, I_, _ER, _CE, __end
        .skip_word              ; $E4^35 = $C7

_08d4:  ;69.                                                            ;$08D4
        .byte   S_, _MA, _LL, __end
        .skip_word              ; $E5^35 = $C6
        
        ; colours:
        ;-----------------------------------------------------------------------

_08d8:  ;70.                                                            ;$08D8
        .byte   G_, _RE, _EN, __end
        .define_word \
                "_COLORS"       ; $E6^35 = $C5
        
_08dc:  ;71.                                                            ;$08DC
        .byte   R_, _ED, __end
        .skip_word              ; $E7^35 = $C4
        
_08df:  ;72.                                                            ;$08DF
        .byte   Y_, E_, _LL, O_, W_, __end
        .skip_word              ; $E8^35 = $CB
        
_08e5:  ;73.                                                            ;$08E5
        .byte   B_, L_, U_, E_, __end
        .skip_word              ; $E9^35 = $CA
        
_08ea:  ;74.                                                            ;$08EA
        .byte   B_, _LA, C_, K_, __end
        .skip_word              ; $EA^35 = $C9

        ; adjectives
        ;-----------------------------------------------------------------------

_08ef:  ;75.                                                            ;$08EF
        .byte   _HARMLESS, __end
        .define_word \
                "_ADJECTIVES"   ; $EB^35 = $C8
        
_08f1:  ;76.                                                            ;$08F1
        .byte   S_, L_, I_, M_, Y_, __end
        .skip_word              ; $EC^35 = $CF
        
_08f7:  ;77.                                                            ;$08F7
        .byte   B_, U_, G_, _HYPHEN, E_, Y_, _ED, __end
        .skip_word              ; $ED^35 = $CE
        
_08ff:  ;78.                                                            ;$08FF
        .byte   H_, _OR, N_, _ED, __end
        .skip_word              ; $EE^35 = $CD

_0904:  ;79.                                                            ;$0904
        .byte   B_, _ON, Y_, __end
        .skip_word              ; $EF^35 = $CC

_0908:  ;80.                                                            ;$0908
        .byte   F_, _AT, __end
        .skip_word              ; $F0^35 = $D3
        
_090b:  ;81.                                                            ;$090B
        .byte   F_, U_, R_, R_, Y_, __end
        .skip_word              ; $F1^35 = $D2
        
        ; species:
        ;-----------------------------------------------------------------------

_0911:  ;82.                                                            ;$0911
        .byte   _RO, D_, _EN, T_, __end
        .define_word \
                "_SPECIES"      ; $F2^35 = $D1
        
_0916:  ;83.                                                            ;$0916
        .byte   F_, _RO, G_, __end
        .skip_word              ; $F3^35 = $D0
        
_091a:  ;84.                                                            ;$091A
        .byte   L_, I_, _ZA, R_, D_, __end
        .skip_word              ; $F4^35 = $D7

_0920:  ;85.                                                            ;$0920
        .byte   L_, O_, B_, _ST, _ER, __end
        .skip_word              ; $F5^35 = $D6
        
_0926:  ;86.                                                            ;$0926
        .byte   _BI, R_, D_, __end
        .skip_word              ; $F6^35 = $D5
        
_092a:  ;87.                                                            ;$092A
        .byte   H_, U_, M_, _AN, O_, I_, D_, __end
        .skip_word              ; $F7^35 = $D4
        
_0932:  ;88.                                                            ;$0932
        .byte   F_, E_, L_, _IN, E_, __end
        .skip_word              ; $F8^35 = $DB

_0938:  ;89.                                                            ;$0938
        .byte   _IN, S_, E_, C_, T_, __end
        .skip_word              ; $F9^35 = $DA
        
        ;-----------------------------------------------------------------------

_093e:  ;90.                                                            ;$093E
        .byte   _AVERAGE, _RA, _DI, _US, __end
        .define_word \
                "_AVERAGE_RADIUS"
                                ; $FA^35 = $D9
        
_0943:  ;91.                                                            ;$0943
        .byte   C_, O_, M_, __end
        .define_word \
                "_COM"          ; $FB^35 = $D8
        
_0947:  ;92.                                                            ;$0947
        .byte   _COM, M_, _AN, D_, _ER, __end
        .define_word \
                "_COMMANDER"    ; $FC^35 = $DF

_094d:  ;93.                                                            ;$094D
        .byte   __, D_, _ES, T_, _RO, Y_, _ED, __end
        .define_word \
                "_DESTROYED"    ; $FD^35 = $DE
        
_0955:  ;94.                                                            ;$0955
        .byte   R_, O_, __end
        .define_word \
                "_RO"           ; $FE^35 = $DD

_0958:  ;95.                                                            ;$0958
        .byte   _UNIT, __, __, _QUANTITY, $2f, __
        .byte   _PRODUCT, __, __, __, _UNIT, __
        .byte   _PRICE, __, F_, _OR, __, S_, A_, _LE, $2f, $29, __end
        .skip_word              ; $FF^35 = $DC

;-------------------------------------------------------------------------------
; at this point a different set of token numbers are used
;
_096f:  ;96.                                                            ;$096F
        .byte   F_, R_, _ON, T_, __end
        .skip_word              ; $60^35 = $43
        
_0974:  ;97.                                                            ;$0974
        .byte   _RE, _AR, __end
        .skip_word              ; $61^35 = $42
        
_0977:  ;98.                                                            ;$0977
        .byte   _LE, F_, T_, __end
        .skip_word              ; $62^35 = $41

_097b:  ;99.                                                            ;$097B
        .byte   _RI, G_, H_, T_, __end
        .define_word \
                "_RIGHT"        ; $63^35 = $40

_0980:  ;100.                                                           ;$0980
        .byte   _ENERGY, L_, O_, W_, $24, __end
        .skip_word              ; $64^35 = $47
        
_0986:  ;101.                                                           ;$0986
        .byte   _RIGHT, _ON_, _COMMANDER, $02, __end
        .skip_word              ; $65^35 = $46

_098b:  ;102.                                                           ;$098B
        .byte   E_, X_, T_, _RA, __, __end
        .define_word \
                "_EXTRA"        ; $66^35 = $45
        
_0991:  ;103.                                                           ;$0991
        .byte   P_, U_, L_, S_, E_, _LASER, __end
        .define_word \
                "_PULSE_LASER"  ; $67^35 = $44

_0998:  ;104.                                                           ;$0998
        .byte   _BE, A_, M_, _LASER, __end
        .define_word \
                "_BEAM_LASER"   ; $68^35 = $4B
        
_099d:  ;105.                                                           ;$099D
        .byte   F_, U_, E_, L_, __end
        .define_word \
                "_FUEL"         ; $69^35 = $4A
        
_09a2:  ;106.                                                           ;$09A2
        .byte   M_, _IS, S_, I_, _LE, __end
        .define_word \
                "_MISSILE"      ; $6A^35 = $49

_09a8:  ;107.                                                           ;$09A8
        .byte   _LARGE, _CARGO, __, B_, A_, Y_, __end
        .define_word \
                "_LARGE_CARGO_BAY"
                                ; $6B^35 = $48
        
_09af:  ;108.                                                           ;$09AF
        .byte   E_, _DOT, C_, _DOT, M_, _DOT, _SYSTEM, __end
        .skip_word              ; $6C^35 = $4F

_09b7:  ;109.                                                           ;$09B7
        .byte   _EXTRA, _PULSE_LASER, S_, __end
        .define_word \
                "_EXTRA_PULSE_LASERS"
                                ; $6D^35 = $4E

_09bb:  ;110.                                                           ;$09BB
        .byte   _EXTRA, _BEAM_LASER, S_, __end
        .skip_word              ; $6E^35 = $4D

_09bf:  ;111.                                                           ;$09BF
        .byte   _FUEL, __, S_, C_, O_, O_, P_, S_, __end
        .define_word \
                "_FUEL_SCOOPS"  ; $6F^35 = $4C

_09c8:  ;112.                                                           ;$09C8
        .byte   _ES, C_, A_, P_, E_, __, P_, O_, D_, __end
        .skip_word              ; $70^35 = $53
        
_09d2:  ;113.                                                           ;$09D2
        .byte   _ENERGY, B_, O_, M_, B_, __end
        .skip_word              ; $71^35 = $52

_09d8:  ;114.                                                           ;$09D8
        .byte   _EXTRA, _ENERGY, _UNIT, __end
        .skip_word              ; $72^35 = $51
        
_09dc:  ;115.                                                           ;$09dC
        .byte   D_, O_, C_, K_, _IN, G_, __, _COMPUTERS, __end
        .define_word \
                "_DOCKING_COMPUTERS"
                                ; $73^35 = $50

_09e5:  ;116.                                                           ;$09E5
        .byte   _GALACTIC, __, _HYPERSPACE, __end
        .skip_word              ; $74^35 = $57
        
_09e9:  ;117.                                                           ;$09E9
        .byte   M_, I_, L_, I_, T_, _AR, Y_, __, _LASER, __end
        .skip_word              ; $75^35 = $56
        
_09f3:  ;118.                                                           ;$09F3
        .byte   M_, _IN, _IN, G_, __, _LASER, __end
        .skip_word              ; $76^35 = $55
        
_09fa:  ;119.                                                           ;$09FA
        .byte   _CASH, _COLON, $23, __end
        .define_word \
                "_CASH_"        ; $77^35 = $54

_09fe:  ;120.                                                           ;$09FE
        .byte   _IN, _COM, _IN, G_, __, _MISSILE, __end
        .skip_word              ; $78^35 = $5B

_0a05:  ;121.                                                           ;$0A05
        .byte   _EN, _ER, G_, Y_, __, __end
        .define_word \
                "_ENERGY"       ; $79^35 = $5A
        
_0a0b:  ;122.                                                           ;$0A0B
        .byte   G_, A_, _LA, C_, _TI, C_, __end
        .define_word \
                "_GALACTIC"     ; $7A^35 = $59

_0a12:  ;123.                                                           ;$0A12
        .byte   _DOCKING_COMPUTERS, __, O_, N_, __end
        .skip_word              ; $7B^35 = $58


_0a17:  ;124.                                                           ;$0A17
        .byte   A_, _LL, __end
        .skip_word              ; $7C^35 = $5F
        
_0a1a:  ;125.                                                           ;$0A1A
        .byte   $26, _LE, G_, _AL, __, _ST, _AT, _US, _COLON, __end
        .skip_word              ; $7D^35 = $5E

_0a24:  ;126.                                                           ;$0A24
        .byte   _COMMANDER, __, $27, $2f, $2f, $2f, $25
        .byte   _PRESENT, __, _SYSTEM, $2a, $21, $2f, _HYPERSPACE
        .byte   _SYSTEM, $2a, $20, $2f
        .byte   C_, _ON, _DI, _TI, _ON, $2a, __end
        .skip_word              ; $7E^35 = $5D
        
_0a3d:  ;127.                                                           ;$0A3D
        .byte   I_, _TE, M_, __end
        .define_word \
                "_ITEM"         ; $7F^35 = $5C
        
;-------------------------------------------------------------------------------

_0a41:  ;128.                                                          ;$0A41
        ; this has to be skipped because its code is the same as hyphen,
        ; and its de-scrambled value $0E is a meta-command (switch case?)
        .byte   __end
        .skip_word              ; $0E^35 = $2D
        
_0a42:  ;129.                                                          ;$0A42
        .byte   L_, L_, __end
        .define_word \
                "_LL"           ; $0F^35 = $2C
        
_0a45:  ;130.                                                           ;$0A45
        .byte   _RA, _TI, N_, G_, _COLON, __end
        .skip_word              ; $10^35 = $33
        
_0a4b:  ;131.                                                           ;$0A4B
        .byte   __, _ON, __, __end
        .define_word \
                "_ON_"          ; $11^35 = $32
        
_0a4f:  ;132.                                                           ;$0A4F
        .byte   $2f, $2b, _EQUIP, M_, _EN, T_, _COLON, $25, __end
        .skip_word              ; $12^35 = $31

_0a58:  ;133.                                                           ;$0A58
        .byte   C_, _LE, _AN, __end
        .skip_word              ; $13^35 = $30
        
_0a5c:  ;134.                                                           ;$0A5C
        .byte   O_, F_, F_, _EN, D_, _ER, __end
        .skip_word              ; $14^35 = $37
        
_0a63:  ;135.                                                           ;$0A63
        .byte   F_, U_, G_, I_, _TI, _VE, __end
        .skip_word              ; $15^35 = $36
        
_0a6a:  ;136.                                                           ;$0A6A
        .byte   H_, _AR, M_, _LE, S_, S_, __end
        .define_word \
                "_HARMLESS"     ; $16^35 = $35
        
_0a71:  ;137.                                                           ;$0A71
        .byte   M_, O_, _ST, L_, Y_, __, _HARMLESS, __end
        .skip_word              ; $17^35 = $34
        
_0a79:  ;138.                                                           ;$0A79
        .byte   _POOR, __end
        .skip_word              ; $18^35 = $3B
        
_0a7b:  ;139.                                                           ;$0A7B
        .byte   _AVERAGE, __end
        .skip_word              ; $19^35 = $3A
        
_0a7d:  ;140.                                                           ;$0A7D
        .byte   A_, B_, O_, _VE, __, _AVERAGE, __end
        .skip_word              ; $1A^35 = $39
        
_0a84:  ;141.                                                           ;$0A84
        .byte   _COM, P_, E_, T_, _EN, T_, __end
        .skip_word              ; $1B^35 = $38
        
_0a8b:  ;142.                                                           ;$0A8B
        .byte   D_, _AN, _GE, _RO, _US, __end
        .skip_word              ; $1C^35 = $3F
        
_0a91:  ;143.                                                           ;$0A91
        .byte   D_, E_, A_, D_, L_, Y_, __end
        .skip_word              ; $1D^35 = $3E

_0a98:  ;144.                                                           ;$0A98
.ifdef  OPTION_ORIGINAL

        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN
        .byte   __, E_, __, L_, __, I_, __, T_, __, E_, __
        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN, __end
.else
        .byte   E_, __, L_, __, I_, __, T_, __, E_
        .byte   __, __, _COLON, __, __
        .byte   H_, __, A_, __, R_, __, M_, __, L_, __, E_, __, S_, __, S_
        .byte   __end
.endif
        .define_word \
                "_ELITE"        ; $1E^35 = $3D

_0aac:  ;145.                                                           ;$0AAC
        .byte   P_, _RE, S_, _EN, T_, __end
        .define_word \
                "_PRESENT"      ; $1F^35 = $3C

_0ab2:  ;146.                                                           ;$0AB2
        .byte   $2b, G_, A_, M_, E_, __, O_, _VE, R_, __end
        .skip_word              ; $20^35 = $03 (same as space?)
        
        ; padding
        .byte   $00, $00, $00, $00                                      ;$0ABC

;===============================================================================

; is this related to text at all?

_0ac0:
.export _0ac0
        .byte   $00, $19, $32, $4a, $62, $79, $8e, $a2                  ;$0AC0
        .byte   $b5, $c6, $d5, $e2, $ed, $f5, $fb, $ff
        .byte   $ff, $ff, $fb, $f5, $ed, $e2, $d5, $c6                  ;$0AD0
        .byte   $b5, $a2, $8e, $79, $62, $4a, $32, $19
_0ae0:
.export _0ae0
        .byte   $00, $01, $03, $04, $05, $06, $08, $09                  ;$0AE0
        .byte   $0a, $0b, $0c, $0d, $0f, $10, $11, $12
        .byte   $13, $14, $15, $16, $17, $18, $19, $19                  ;$0AF0
        .byte   $1a, $1b, $1c, $1d, $1d, $1e, $1f, $1f

;$0B00
