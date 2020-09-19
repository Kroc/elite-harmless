; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "text_flight.asm":
;
; this file stores the more common strings, typically used when in 'flight'
; mode, but this also includes some of the shared menu screens that can be
; accessed either in flight or docked, such as player status. whilst this
; string pool does contain much of the text on the planet status screen,
; it doesn't include the planet description strings, that's a very
; complex system and those are stored in the 'docked' string pool

; this is the 'key' used to scramble / unscramble the flight token symbols
; https://xania.org/201406/elites-crazy-string-format
.export TKN_FLIGHT_XOR = $23

; all flight tokens on disk are scrambled in this way:
.define .scramble(value) value ^ TKN_FLIGHT_XOR

_tkn_index      .set 0

; increment the token index,
; without defining a token ID
;
.macro  .tkn
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; move to the next token index
        _tkn_index .set _tkn_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_id         tkn_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        ; scramble the token index to produce
        ; the token ID used within flight strings
        .local  _value
        _value  .set .scramble( _tkn_index )

        ; TODO: gosh, isn't this just a total mess?
        ;       we may be able to clean this up by using separate
        ;       segments for each of the seprate regions of tokens
        ;
        .if _tkn_index < 96
                _value .set .scramble( $A0 + _tkn_index )

        .elseif _tkn_index < 128
                _value .set .scramble( _tkn_index )
        .else
                _value .set .scramble( _tkn_index - $72 )
        .endif
        ;;.out .sprintf(": $%0.2x: TXT%s", _value, tkn_id)
        
        ; define the token locally, using the name given.
        ; note that this doesn't include a prefix, to make
        ; the text-database below easier on the eyes
        .ident( tkn_id ) = _value
        ; define an export for the index-number of the token;
        ; this is how the outside world will specify the token ID
.export .ident(.concat( "TKN_FLIGHT", tkn_id )) = .scramble( _value )

        ; move to the next token index
        .tkn

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


.macro  .define_letter  id, index
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; define the version as used in the flight
        ; strings database (scrambled)
        ;
        .ident( id ) = .scramble( index )

        ; remap the ASCII character to the scrambled token,
        ; so we can use actual strings in the database
        .charmap        index, .scramble( index )

        ; define the public version used in code,
        ; (unscrambled)
        ;
.export .ident( .concat( "TKN_FLIGHT", id )) = index

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

__end           = $00

; tokenise regular ASCII characters:
;===============================================================================
;       symbol                  ; token scrmbld note
;-------------------------------------------------------------------------------
.define_letter  "__",           $20     ;=$03 (space)
.define_letter  "_XMARK",       $21     ;=$02 "!"
.define_letter  "_LPAREN",      $28     ;=$0B "("
.define_letter  "_RPAREN",      $29     ;=$0A ")"
.define_letter  "_HYPHEN",      $2d     ;=$0E "-"
.define_letter  "_DOT",         $2e     ;=$0D "."
.define_letter  "_SLASH",       $2f     ;=$0C "/"
.define_letter  "_0",           $30     ;=$13 "0"
.define_letter  "_1",           $31     ;=$12 "1"
.define_letter  "_2",           $32     ;=$11 "2"
.define_letter  "_3",           $33     ;=$10 "3"
.define_letter  "_4",           $34     ;=$17 "4"
.define_letter  "_5",           $35     ;=$16 "5"
.define_letter  "_6",           $36     ;=$15 "6"
.define_letter  "_7",           $37     ;=$14 "7"
.define_letter  "_8",           $38     ;=$1B "8"
.define_letter  "_9",           $39     ;=$1A "9"
.define_letter  "_COLON",       $3a     ;=$19 ":"
.define_letter  "_SEMI",        $3b     ;=$18 ";"
.define_letter  "_LANGB",       $3c     ;=$1F "<"
.define_letter  "_EQUALS",      $3d     ;=$1E "="
.define_letter  "_RANGB",       $3e     ;=$1D ">"
.define_letter  "_QMARK",       $3f     ;=$1C "?"
.define_letter  "_ATMARK",      $40     ;=$63 "@"
.define_letter  "_A",           $41     ;=$62
.define_letter  "_B",           $42     ;=$61
.define_letter  "_C",           $43     ;=$60
.define_letter  "_D",           $44     ;=$67
.define_letter  "_E",           $45     ;=$66
.define_letter  "_F",           $46     ;=$65
.define_letter  "_G",           $47     ;=$64
.define_letter  "_H",           $48     ;=$6B
.define_letter  "_I",           $49     ;=$6A
.define_letter  "_J",           $4a     ;=$69
.define_letter  "_K",           $4b     ;=$68
.define_letter  "_L",           $4c     ;=$6F
.define_letter  "_M",           $4d     ;=$6E
.define_letter  "_N",           $4e     ;=$6D
.define_letter  "_O",           $4f     ;=$6C
.define_letter  "_P",           $50     ;=$73
.define_letter  "_Q",           $51     ;=$72
.define_letter  "_R",           $52     ;=$71
.define_letter  "_S",           $53     ;=$70
.define_letter  "_T",           $54     ;=$77
.define_letter  "_U",           $55     ;=$76
.define_letter  "_V",           $56     ;=$75
.define_letter  "_W",           $57     ;=$74
.define_letter  "_X",           $58     ;=$7B
.define_letter  "_Y",           $59     ;=$7A
.define_letter  "_Z",           $5a     ;=$79




.import tkn_flight_al:direct            ;=$80:
_AL     = .scramble( tkn_flight_al )    ;^$23=$A3
.import tkn_flight_le:direct            ;=$81:
_LE     = .scramble( tkn_flight_le )    ;^$23=$A2
.import tkn_flight_xe:direct            ;=$82:
_XE     = .scramble( tkn_flight_xe )    ;^$23=$A1
.import tkn_flight_ge:direct            ;=$83:
_GE     = .scramble( tkn_flight_ge )    ;^$23=$A0
.import tkn_flight_za:direct            ;=$84:
_ZA     = .scramble( tkn_flight_za )    ;^$23=$A7
.import tkn_flight_ce:direct            ;=$85:
_CE     = .scramble( tkn_flight_ce )    ;^$23=$A6
.import tkn_flight_bi:direct            ;=$86:
_BI     = .scramble( tkn_flight_bi )    ;^$23=$A5
.import tkn_flight_so:direct            ;=$87:
_SO     = .scramble( tkn_flight_so )    ;^$23=$A4
.import tkn_flight_us:direct            ;=$88:
_US     = .scramble( tkn_flight_us )    ;^$23=$AB
.import tkn_flight_es:direct            ;=$89:
_ES     = .scramble( tkn_flight_es )    ;^$23=$AA
.import tkn_flight_ar:direct            ;=$8A:
_AR     = .scramble( tkn_flight_ar )    ;^$23=$A9
.import tkn_flight_ma:direct            ;=$8B:
_MA     = .scramble( tkn_flight_ma )    ;^$23=$A8
.import tkn_flight_in:direct            ;=$8C:
_IN     = .scramble( tkn_flight_in )    ;^$23=$AF
.import tkn_flight_di:direct            ;=$8D:
_DI     = .scramble( tkn_flight_di )    ;^$23=$AE
.import tkn_flight_re:direct            ;=$8E:
_RE     = .scramble( tkn_flight_re )    ;^$23=$AD
.import tkn_flight_a_:direct            ;=$8F:
_A_     = .scramble( tkn_flight_a_ )    ;=$23=$AC
.import tkn_flight_er:direct            ;=$90:
_ER     = .scramble( tkn_flight_er )    ;^$23=$B3
.import tkn_flight_at:direct            ;=$91:
_AT     = .scramble( tkn_flight_at )    ;^$23=$B2
.import tkn_flight_en:direct            ;=$92:
_EN     = .scramble( tkn_flight_en )    ;^$23=$B1
.import tkn_flight_be:direct            ;=$93:
_BE     = .scramble( tkn_flight_be )    ;^$23=$B0
.import tkn_flight_ra:direct            ;=$94:
_RA     = .scramble( tkn_flight_ra )    ;^$23=$B7
.import tkn_flight_la:direct            ;=$95:
_LA     = .scramble( tkn_flight_la )    ;^$23=$B6
.import tkn_flight_ve:direct            ;=$96:
_VE     = .scramble( tkn_flight_ve )    ;^$23=$B5
.import tkn_flight_ti:direct            ;=$97:
_TI     = .scramble( tkn_flight_ti )    ;^$23=$B4
.import tkn_flight_ed:direct            ;=$98:
_ED     = .scramble( tkn_flight_ed )    ;^$23=$BB
.import tkn_flight_or:direct            ;=$99:
_OR     = .scramble( tkn_flight_or )    ;^$23=$BA
.import tkn_flight_qu:direct            ;=$9A:
_QU     = .scramble( tkn_flight_qu )    ;^$23=$B9
.import tkn_flight_an:direct            ;=$9B:
_AN     = .scramble( tkn_flight_an )    ;^$23=$B8
.import tkn_flight_te:direct            ;=$9C:
_TE     = .scramble( tkn_flight_te )    ;^$23=$BF
.import tkn_flight_is:direct            ;=$9D:
_IS     = .scramble( tkn_flight_is )    ;^$23=$BE
.import tkn_flight_ri:direct            ;=$9E:
_RI     = .scramble( tkn_flight_ri )    ;^$23=$BD
.import tkn_flight_on:direct            ;=$9F:
_ON     = .scramble( tkn_flight_on )    ;^$23=$BC


.segment        "TEXT_FLIGHT"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
_0700:  ;$A0: 0.                                                        ;$0700
.export _0700
        .byte   _FUEL_SCOOPS, _ON_, $24, __end
        .tkn                                                            ;=$83

_0704:  ;$A1: 1.                                                        ;$0704
        .byte   __, "CH", _AR, "T", __end
        .tkn_id "_CHART"                                                ;=$82

_070A:  ;$A2: 2.                                                        ;$070A
        .byte   "GO", _VE, "RNM", _EN, "T", __end
        .tkn_id "_GOVERNMENT"                                           ;=$81

_0713:  ;$A3: 3.                                                        ;$0713
        .byte   "D", _AT, "A", _ON_, $20, __end
        .tkn_id "_DATA_ON"                                              ;=$80

_0719:  ;$A4: 4.                                                        ;$0719
        .byte   _IN, _VE, "NT", _OR, "Y", $2f, __end
        .tkn_id "_INVENTORY"                                            ;=$87

_0721:  ;$A5: 5.                                                        ;$0721
        .byte   "SYS", _TE, "M", __end
        .tkn_id "_SYSTEM"                                               ;=$86

_0727:  ;$A6: 6.                                                        ;$0727
        .byte   "P", _RI, _CE, __end
        .tkn_id "_PRICE"                                                ;=$85

_072b:  ;$A7: 7.                                                        ;$072B
        .byte   $21, __, _MA, "RKET", __, _PRICE, "S", __end
        .tkn_id "_MARKET_PRICES"                                        ;=$84

_0736:  ;$A8: 8.                                                        ;$0736
        .byte   _IN, "D", _US, "T", _RI, _AL, __end
        .tkn_id "_INDUSTRIAL"                                           ;=$8B

_073d:  ;$A9: 9.                                                        ;$073D
        .byte   "AG", _RI, "CULTU", _RA, "L", __end
        .tkn                                                            ;=$8A

        ; wealth level:
        ;-----------------------------------------------------------------------
_0748:  ;$AA: 10.                                                       ;$0748
        .byte   _RI, "CH", __, __end
        .tkn_id "_WEALTH"                                               ;=$89

_074d:  ;$AB: 11.                                                       ;$074D
        .byte   "A", _VE, _RA, _GE, __, __end
        .tkn_id "_AVERAGE"                                              ;=$88

_0753:  ;$AC: 12.                                                       ;$0753
        .byte   "PO", _OR, __, __end
        .tkn_id "_POOR"                                                 ;=$8F
        ;-----------------------------------------------------------------------
        
_0758:  ;$AD: 13.                                                       ;$0758
        .byte   _MA, _IN, "LY", __, __end
        .tkn_id "_MAINLY"                                               ;=$8E

_075e:  ;$AE: 14.                                                       ;$075E
        .byte   "UNIT", __end
        .tkn_id "_UNIT"                                                 ;=$8D

_0763:  ;$AF: 15.                                                       ;$0763
        .byte  "VIEW", __, __end
        .tkn_id "_VIEW"                                                 ;=$8C

_0769:  ;$B0: 16.                                                       ;$0769
        .byte   _QU, _AN, _TI, "TY", __end
        .tkn_id "_QUANTITY"                                             ;=$93
        
_076f:  ;$B1: 17.                                                       ;$076F
        .byte   _AN, _AR, "CHY", __end
        .tkn_id "_ANARCHY"                                              ;=$92

_0775:  ;$B2: 18.                                                       ;$0775
        .byte   "FEUD", _AL, __end
        .tkn                                                            ;=$91

_077b:  ;$B3: 19.                                                       ;$077B
        .byte   "MUL", _TI, _HYPHEN, _GOVERNMENT, __end
        .tkn                                                            ;=$90
        
_0782:  ;$B4: 20.                                                       ;$0782
        .byte   _DI, "CT", _AT, _OR, _SHIP, __end
        .tkn                                                            ;=$97
        
_0789:  ;$B5: 21.                                                       ;$0789
        .byte   _COM, "MUN", _IS, "T", __end
        .tkn                                                            ;=$96

_0790:  ;$B6: 22.                                                       ;$0790
        .byte   "C", _ON, "F", _ED, _ER, "ACY", __end
        .tkn                                                            ;=$95

_0799:  ;$B7: 23.                                                       ;$0799
        .byte   "DEMOC", _RA, "CY", __end
        .tkn                                                            ;=$94

_07a2:  ;$B8: 24.                                                       ;$07A2
        .byte   "C", _OR, "P", _OR, _AT, "E", __, _ST, _AT, "E", __end
        .tkn                                                            ;=$9B

_07ad:  ;$B9: 25.                                                       ;$07AD
        .byte   "SHIP", __end
        .tkn_id "_SHIP"                                                 ;=$9A

_07b2:  ;$BA: 26.                                                       ;$07B2
        .byte   "P", _RO, "DUCT", __end
        .tkn_id "_PRODUCT"                                              ;=$99

_07b9:  ;$BB: 27.                                                       ;$07B9
        .byte   __, _LA, "S", _ER, __end
        .tkn_id "_LASER"                                                ;=$98

_07be:  ;$BC: 28.                                                       ;$07BE
        .byte   "HUM", _AN, __, "COL", _ON, "I", _AL, __end
        .tkn_id "_HUMAN_COLONIAL"                                       ;=$9F

_07ca:  ;$BD: 29.                                                       ;$07CA
        .byte   "HYP", _ER, "SPA", _CE, __, __end
        .tkn_id "_HYPERSPACE"                                           ;=$9E
        
_07d4:  ;$BE: 30.                                                       ;$07D4
        .byte   "SH", _OR, "T", __, _RANGE, _CHART, __end
        .tkn_id "_SHORT_RANGE_CHART"                                    ;=$9D

_07dc:  ;$BF: 31.                                                       ;$07DC
        .byte   _DI, _ST, _AN, _CE, __end
        .tkn_id "_DISTANCE"                                             ;=$9C

_07e1:  ;$C0: 32.                                                       ;$07E1
        .byte   "POPUL", _AT, "I", _ON, __end
        .tkn_id "_POPULATION"                                           ;=$E3

_07ea:  ;$C1: 33.                                                       ;$07EA
        .byte   _G, _RO, _S, _S, __, _PRODUCT, _I, _V, _I, _T, _Y, __end
        .tkn_id "_GROSS_PRODUCTIVITY"                                   ;=$E2

_07f6:  ;$C2: 34.                                                       ;$07F6
        .byte   "EC", _ON, "OMY", __end
        .tkn_id "_ECONOMY"                                              ;=$E1
        
_07fd:  ;$C3: 35.                                                       ;$07FD
        .byte   __, "LIGHT", __, "YE", _AR, "S", __end
        .tkn_id "_LIGHT_YEARS"                                          ;=$E0

_0809:  ;$C4: 36.                                                       ;$0809
        .byte   _TE, "CH", _DOT, _LE, _VE, "L", __end
        .tkn_id "_TECH_LEVEL"                                           ;=$E7
        
_0811:  ;$C5: 37.                                                       ;$0811
        .byte   "CASH", __end
        .tkn_id "_CASH"                                                 ;=$E6
        
_0816:  ;$C6: 38.                                                       ;$0816
        .byte   __, _BI, _LL, "I", _ON, __end
        .tkn_id "_BILLION"                                              ;=$E5

_081c:  ;$C7: 39.                                                       ;$081C
        .byte   _GALACTIC, _CHART, $22, __end
        .tkn_id "_GALACTIC_CHART"                                       ;=$E4
        
_0820:  ;$C8: 40.                                                       ;$0820
        .byte   "T", _AR, _GE, "T", __, "LO", _ST, __end
        .tkn                                                            ;=$EB
        
_0829:  ;$C9: 41.                                                       ;$0829
        .byte   _MISSILE, __, "JAMM", _ED, __end
        .tkn_id "_MISSILE_JAMMED"                                       ;=$EA
        
_0831:  ;$CA: 42.                                                       ;$0831
        .byte   "R", _AN, _GE, __end
        .tkn_id "_RANGE"                                                ;=$E9
        
_0835:  ;$CB: 43.                                                       ;$0835
        .byte   "ST", __end
        .tkn_id "_ST"                                                   ;=$E8

_0838:  ;$CC: 44.                                                       ;$0838
        .byte   _QUANTITY, __, "OF", __, __end
        .tkn_id "_QUANTITY_OF"                                          ;=$EF

_083e:  ;$CD: 45.                                                       ;$083E
        .byte   "SE", _LL, __end
        .tkn_id "_SELL"                                                 ;=$EE

_0842:  ;$CE: 46.                                                       ;$0842
        .byte   __, "C", _AR, "GO", $25, __end
        .tkn_id "_CARGO"                                                ;=$ED
        
_0849:  ;$CF: 47.                                                       ;$0849
        .byte   "E", _QU, "IP", __end
        .tkn_id "_EQUIP"                                                ;=$EC
        
        ; cargo types:
        ;-----------------------------------------------------------------------
_084e:  ;$D0: 48.                                                       ;$084E
        .byte   "FOOD", __end
        .tkn_id "_CARGO_TYPES"                                          ;=$F3
        
_0853:  ;$D1: 49.                                                       ;$0853
        .byte   _TE, "X", _TI, "L", _ES, __end
        .tkn                                                            ;=$F2
        
_0859:  ;$D2: 50.                                                       ;$0859
        .byte   _RA, _DI, "OAC", _TI, _VE, "S", __end
        .tkn                                                            ;=$F1
        
_0862:  ;$D3: 51.                                                       ;$0862
        .byte   "S", _LA, _VE, "S", __end
        .tkn                                                            ;=$F0
        
_0867:  ;$D4: 52.                                                       ;$0867
        .byte   "LI", _QU, _OR, $0c, "W", _IN, _ES, __end
        .tkn                                                            ;=$F7

_0870:  ;$D5: 53.                                                       ;$0870
        .byte   "LUXU", _RI, _ES, __end
        .tkn                                                            ;=$F6
        
_0877:  ;$D6: 54.                                                       ;$0877
        .byte   "N", _AR, "CO", _TI, "CS", __end
        .tkn                                                            ;=$F5
        
_087f:  ;$D7: 55.                                                       ;$087F
        .byte   _COM, "PUT", _ER, "S", __end
        .tkn_id "_COMPUTERS"                                            ;=$F4
        
_0886:  ;$D8: 56.                                                       ;$0886
        .byte   _MA, "CH", _IN, _ER, "Y", __end
        .tkn                                                            ;=$FB
        
_088dc: ;$D9: 57.                                                       ;$088D
        .byte   "ALLOYS", __end
        .tkn                                                            ;=$FA
        
_0894:  ;$DA: 58.                                                       ;$0894
        .byte   "FI", _RE, _AR, "MS", __end
        .tkn                                                            ;=$F9
        
_089b:  ;$DB: 59.                                                       ;$089B
        .byte   "FURS", __end
        .tkn                                                            ;=$F8
        
_08a0:  ;$DC: 60.                                                       ;$08A0
        .byte   "M", _IN, _ER, _AL, "S", __end
        .tkn                                                            ;=$FF
        
_08a6:  ;$DD: 61.                                                       ;$08A6
        .byte   "GOLD", __end
        .tkn                                                            ;=$FE
        
_08ab:  ;$DE: 62.                                                       ;$08AB
        .byte   "PL", _AT, _IN, "UM", __end
        .tkn                                                            ;=$FD
        
_08b2:  ;$DF: 63.                                                       ;$08B2
        .byte   _GE, "M", _HYPHEN, _ST, _ON, _ES, __end
        .tkn                                                            ;=$FC
        
_08b9:  ;$E0: 64.                                                       ;$08B9
        .byte   _AL, "I", _EN, __, _ITEM, "S", __end
        .tkn                                                            ;=$C3

_08c0:  ;$E1: 65.                                                       ;$08C0
        .byte   $2f, $12, $13, $23, $16, $23, __end
        .tkn                                                            ;=$C2
        
_08c7:  ;$E2: 66.                                                       ;$08C7
        .byte   __, "CR", __end
        .tkn_id "_CR"                                                   ;=$C1
        
_08cb:  ;$E3: 67.                                                       ;$08CB
        .byte   "L", _AR, _GE, __end
        .tkn_id "_LARGE"                                                ;=$C0
        
_08d0:  ;$E4: 68.                                                       ;$08D0
        .byte   "FI", _ER, _CE, __end
        .tkn                                                            ;=$C7

_08d4:  ;$E5: 69.                                                       ;$08D4
        .byte   "S", _MA, _LL, __end
        .tkn                                                            ;=$C6
        
        ; colours:
        ;-----------------------------------------------------------------------
_08d8:  ;$E6: 70.                                                       ;$08D8
        .byte   "G", _RE, _EN, __end
        .tkn_id "_COLORS"                                               ;=$C5
        
_08dc:  ;$E7: 71.                                                       ;$08DC
        .byte   "R", _ED, __end
        .tkn                                                            ;=$C4
        
_08df:  ;$E8: 72.                                                       ;$08DF
        .byte   "YE", _LL, "OW", __end
        .tkn                                                            ;=$CB
        
_08e5:  ;$E9: 73.                                                       ;$08E5
        .byte   "BLUE", __end
        .tkn                                                            ;=$CA
        
_08ea:  ;$EA: 74.                                                       ;$08EA
        .byte   "B", _LA, "CK", __end
        .tkn                                                            ;=$C9

        ; adjectives
        ;-----------------------------------------------------------------------
_08ef:  ;$EB: 75.                                                       ;$08EF
        .byte   _HARMLESS, __end
        .tkn_id "_ADJECTIVES"                                           ;=$C8
        
_08f1:  ;$EC: 76.                                                       ;$08F1
        .byte   "SLIMY", __end
        .tkn                                                            ;=$CF
        
_08f7:  ;$ED: 77.                                                       ;$08F7
        .byte   "BUG", _HYPHEN, "EY", _ED, __end
        .tkn                                                            ;=$CE
        
_08ff:  ;$EE: 78.                                                       ;$08FF
        .byte   "H", _OR, "N", _ED, __end
        .tkn                                                            ;=$CD

_0904:  ;$EF: 79.                                                       ;$0904
        .byte   "B", _ON, "Y", __end
        .tkn                                                            ;$CC

_0908:  ;$F0: 80.                                                       ;$0908
        .byte   "F", _AT, __end
        .tkn                                                            ;$D3
        
_090b:  ;$F1: 81.                                                       ;$090B
        .byte   "FURRY", __end
        .tkn                                                            ;=$D2
        
        ; species:
        ;-----------------------------------------------------------------------
_0911:  ;$F2: 82.                                                       ;$0911
        .byte   _RO, "D", _EN, "T", __end
        .tkn_id "_SPECIES"                                              ;=$D1
        
_0916:  ;$F3: 83.                                                       ;$0916
        .byte   "F", _RO, "G", __end
        .tkn                                                            ;=$D0
        
_091a:  ;$F4: 84.                                                       ;$091A
        .byte   "LI", _ZA, "RD", __end
        .tkn                                                            ;=$D7

_0920:  ;$F5: 85.                                                       ;$0920
        .byte   "LOB", _ST, _ER, __end
        .tkn                                                            ;=$D6
        
_0926:  ;$F6: 86.                                                       ;$0926
        .byte   _BI, "RD", __end
        .tkn                                                            ;=$D5
        
_092a:  ;$F7: 87.                                                       ;$092A
        .byte   "HUM", _AN, "OID", __end
        .tkn                                                            ;=$D4
        
_0932:  ;$F8: 88.                                                       ;$0932
        .byte   "FEL", _IN, "E", __end
        .tkn                                                            ;=$DB

_0938:  ;$F9: 89.                                                       ;$0938
        .byte   _IN, "SECT", __end
        .tkn                                                            ;=$DA
        ;-----------------------------------------------------------------------

_093e:  ;$FA: 90.                                                       ;$093E
        .byte   _AVERAGE, _RA, _DI, _US, __end
        .tkn_id "_AVERAGE_RADIUS"                                       ;=$D9
        
_0943:  ;$FB: 91.                                                       ;$0943
        .byte   "COM", __end
        .tkn_id "_COM"                                                  ;=$D8
        
_0947:  ;$FC: 92.                                                       ;$0947
        .byte   _COM, "M", _AN, "D", _ER, __end
        .tkn_id "_COMMANDER"                                            ;=$DF

_094d:  ;$FD: 93.                                                       ;$094D
        .byte   __, "D", _ES, "T", _RO, "Y", _ED, __end
        .tkn_id "_DESTROYED"                                            ;=$DE
        
_0955:  ;$FE: 94.                                                       ;$0955
        .byte   "RO", __end
        .tkn_id "_RO"                                                   ;=$DD

_0958:  ;$FF: 95.                                                       ;$0958
        .byte   _UNIT, __, __, _QUANTITY, $2f, __
        .byte   _PRODUCT, __, __, __, _UNIT, __
        .byte   _PRICE, __, "F", _OR, __, "SA", _LE, $2f, $29, __end
        .tkn                                                            ;=$DC

;-------------------------------------------------------------------------------
; at this point a different set of token numbers are used
;
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
        ; cockpit view directions:
        ;-----------------------------------------------------------------------
_096f:  ;$60: 96.                                                       ;$096F
        .byte   "FR", _ON, "T", __end
        .tkn_id "_DIRECTIONS"                                           ;=$43
        
_0974:  ;$61: 97.                                                       ;$0974
        .byte   _RE, _AR, __end
        .tkn                                                            ;=$42
        
_0977:  ;$62: 98.                                                       ;$0977
        .byte   _LE, "FT", __end
        .tkn                                                            ;=$41

_097b:  ;$63: 99.                                                       ;$097B
        .byte   _RI, "GHT", __end
        .tkn_id "_RIGHT"                                                ;=$40
        ;-----------------------------------------------------------------------

_0980:  ;$64: 100.                                                      ;$0980
        .byte   _ENERGY, "LOW", $24, __end
        .tkn                                                            ;=$47
        
_0986:  ;$65: 101.                                                      ;$0986
        .byte   _RIGHT, _ON_, _COMMANDER, $02, __end
        .tkn_id "_RIGHT_ON_COMMANDER"                                   ;=$46

_098b:  ;$66: 102.                                                      ;$098B
        .byte   "EXT", _RA, __, __end
        .tkn_id "_EXTRA"                                                ;=$45
        
_0991:  ;$67: 103.                                                      ;$0991
        .byte   "PULSE", _LASER, __end
        .tkn_id "_PULSE_LASER"                                          ;=$44

_0998:  ;$68: 104.                                                      ;$0998
        .byte   _BE, "AM", _LASER, __end
        .tkn_id "_BEAM_LASER"                                           ;=$4B
        
_099d:  ;$69: 105.                                                      ;$099D
        .byte   "FUEL", __end
        .tkn_id "_FUEL"                                                 ;=$4A
        
_09a2:  ;$6A: 106.                                                      ;$09A2
        .byte   "M", _IS, "SI", _LE, __end
        .tkn_id "_MISSILE"                                              ;=$49

_09a8:  ;$6B: 107.                                                      ;$09A8
        .byte   _LARGE, _CARGO, __, "BAY", __end
        .tkn_id "_LARGE_CARGO_BAY"                                      ;=$48
        
_09af:  ;$6C: 108.                                                      ;$09AF
        .byte   "E", _DOT, "C", _DOT, "M", _DOT, _SYSTEM, __end
        .tkn_id "_ECM_SYSTEM"                                           ;=$4F

_09b7:  ;$6D: 109.                                                      ;$09B7
        .byte   _EXTRA, _PULSE_LASER, "S", __end
        .tkn_id "_EXTRA_PULSE_LASERS"                                   ;=$4E

_09bb:  ;$6E: 110.                                                      ;$09BB
        .byte   _EXTRA, _BEAM_LASER, "S", __end
        .tkn                                                            ;=$4D

_09bf:  ;$6F: 111.                                                      ;$09BF
        .byte   _FUEL, __, "SCOOPS", __end
        .tkn_id "_FUEL_SCOOPS"                                          ;=$4C

_09c8:  ;$70: 112.                                                      ;$09C8
        .byte   _ES, "CAPE", __, "POD", __end
        .tkn_id "_ESCAPE_POD"                                           ;=$53
        
_09d2:  ;$71: 113.                                                      ;$09D2
        .byte   _ENERGY, "BOMB", __end
        .tkn                                                            ;=$52

_09d8:  ;$72: 114.                                                      ;$09D8
        .byte   _EXTRA, _ENERGY, _UNIT, __end
        .tkn                                                            ;=$51
        
_09dc:  ;$73: 115.                                                      ;$09dC
        .byte   "DOCK", _IN, "G", __, _COMPUTERS, __end
        .tkn_id "_DOCKING_COMPUTERS"                                    ;=$50

_09e5:  ;$74: 116.                                                      ;$09E5
        .byte   _GALACTIC, __, _HYPERSPACE, __end
        .tkn_id "_GALACTIC_HYPERSPACE"                                  ;=$57
        
_09e9:  ;$75: 117.                                                      ;$09E9
        .byte   "MILIT", _AR, "Y", __, _LASER, __end
        .tkn                                                            ;=$56
        
_09f3:  ;$76: 118.                                                      ;$09F3
        .byte   "M", _IN, _IN, "G", __, _LASER, __end
        .tkn_id "_MINING_LASER"                                         ;=$55
        
_09fa:  ;$77: 119.                                                      ;$09FA
        .byte   _CASH, _COLON, $23, __end
        .tkn_id "_CASH_"                                                ;=$54

_09fe:  ;$78: 120.                                                      ;$09FE
        .byte   _IN, _COM, _IN, "G", __, _MISSILE, __end
        .tkn_id "_INCOMING_MISSILE"                                     ;=$5B

_0a05:  ;$79: 121.                                                      ;$0A05
        .byte   _EN, _ER, "GY", __, __end
        .tkn_id "_ENERGY"                                               ;=$5A
        
_0a0b:  ;$7A: 122.                                                      ;$0A0B
        .byte   "GA", _LA, "C", _TI, "C", __end
        .tkn_id "_GALACTIC"                                             ;=$59

_0a12:  ;$7B: 123.                                                      ;$0A12
        .byte   _DOCKING_COMPUTERS, __, "ON", __end
        .tkn                                                            ;=$58


_0a17:  ;$7C: 124.                                                      ;$0A17
        .byte   "A", _LL, __end
        .tkn                                                            ;=$5F
        
_0a1a:  ;$7D: 125.                                                      ;$0A1A
        .byte   $26, _LE, "G", _AL, __, _ST, _AT, _US, _COLON, __end
        .tkn_id "_LEGAL_STATUS"                                         ;=$5E

_0a24:  ;$7E: 126.                                                      ;$0A24
        .byte   _COMMANDER, __, $27, $2f, $2f, $2f, $25
        .byte   _PRESENT, __, _SYSTEM, $2a, $21, $2f, _HYPERSPACE
        .byte   _SYSTEM, $2a, $20, $2f
        .byte   "C", _ON, _DI, _TI, _ON, $2a, __end
        .tkn_id "_STATUS_TITLE"                                         ;=$5D
        
_0a3d:  ;$7F: 127.                                                      ;$0A3D
        .byte   "I", _TE, "M", __end
        .tkn_id "_ITEM"                                                 ;=$5C
        
;-------------------------------------------------------------------------------
; at this point a different set of token numbers are used
;
;       token (unscrambled): decimal index (of this list).
;-------------------------------------------------------------------------------
_0a41:  ;$0E: 128.                                                      ;$0A41
        ; this has to be skipped because its code is the same as hyphen,
        ; and its de-scrambled value $0E is a meta-command (switch case?)
        .byte   __end
        .tkn                                                            ;=$2D
        
_0a42:  ;$0F: 129.                                                      ;$0A42
        .byte   "LL", __end
        .tkn_id "_LL"                                                   ;=$2C
        
_0a45:  ;$10: 130.                                                      ;$0A45
        .byte   _RA, _TI, "NG", _COLON, __end
        .tkn_id "_RATING"                                               ;=$33
        
_0a4b:  ;$11: 131.                                                      ;$0A4B
        .byte   __, _ON, __, __end
        .tkn_id "_ON_"                                                  ;=$32
        
_0a4f:  ;$12: 132.                                                      ;$0A4F
        .byte   $2f, $2b, _EQUIP, "M", _EN, "T", _COLON, $25, __end
        .tkn_id "_EQUIPMENT"                                            ;=$31

        ; legal status:
        ;-----------------------------------------------------------------------
_0a58:  ;$13: 133.                                                      ;$0A58
        .byte   "C", _LE, _AN, __end
        .tkn_id "_LEGAL_STATE"                                          ;=$30
        
_0a5c:  ;$14: 134.                                                      ;$0A5C
        .byte   "OFF", _EN, "D", _ER, __end
        .tkn                                                            ;=$37
        
_0a63:  ;$15: 135.                                                      ;$0A63
        .byte   "FUGI", _TI, _VE, __end
        .tkn                                                            ;=$36
        ;-----------------------------------------------------------------------

_0a6a:  ;$16: 136.                                                      ;$0A6A
        .byte   "H", _AR, "M", _LE, "SS", __end
        .tkn_id "_HARMLESS"                                             ;=$35
        
_0a71:  ;$17: 137.                                                      ;$0A71
        .byte   "MO", _ST, "LY", __, _HARMLESS, __end
        .tkn                                                            ;=$34
        
_0a79:  ;$18: 138.                                                      ;$0A79
        .byte   _POOR, __end
        .tkn                                                            ;=$3B
        
_0a7b:  ;$19: 139.                                                      ;$0A7B
        .byte   _AVERAGE, __end
        .tkn                                                            ;=$3A
        
_0a7d:  ;$1A: 140.                                                      ;$0A7D
        .byte   "ABO", _VE, __, _AVERAGE, __end
        .tkn                                                            ;=$39
        
_0a84:  ;$1B: 141.                                                      ;$0A84
        .byte   _COM, "PET", _EN, "T", __end
        .tkn                                                            ;=$38
        
_0a8b:  ;$1C: 142.                                                      ;$0A8B
        .byte   "D", _AN, _GE, _RO, _US, __end
        .tkn                                                            ;=$3F
        
_0a91:  ;$1D: 143.                                                      ;$0A91
        .byte   "DEADLY", __end
        .tkn                                                            ;=$3E

_0a98:  ;$1E: 144.                                                      ;$0A98
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN
        .byte   __, "E", __, "L", __, "I", __, "T", __, "E", __
        .byte   _HYPHEN, _HYPHEN, _HYPHEN, _HYPHEN, __end
.else   ;///////////////////////////////////////////////////////////////////////
        .byte   "E", __, "L", __, "I", __, "T", __, "E"
        .byte   __, __, _COLON, __, __, "H", __, "A", __, "R", __, "M", __
        .byte   "L", __, "E", __, "S", __, "S"
        .byte   __end
.endif  ;///////////////////////////////////////////////////////////////////////
        .tkn_id "_ELITE"                                                ;=$3D

_0aac:  ;$1F: 145.                                                      ;$0AAC
        .byte   "P", _RE, "S", _EN, "T", __end
        .tkn_id "_PRESENT"                                              ;=$3C

_0ab2:  ;$20: 146.                                                      ;$0AB2
        .byte   $2b, "GAME", __, "O", _VE, "R", __end
        .tkn                                                            ;=$03
        
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; padding
        .byte   $00, $00, $00, $00                                      ;$0ABC
.endif  ;///////////////////////////////////////////////////////////////////////
