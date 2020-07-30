; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; this file stores the strings typically used when docked (as well as the title
; screen), but also the planet descriptions as those are highly complex and
; there wasn't any room left in the commonly shared 'flight' strings
;
; it's important to note that these strings use an entirely different set of
; scrambled, compressed tokens than the flight strings, but can also include
; flight strings when needed. needless to say, it's complex
;
; this is the 'key' used to scramble / unscramble the docked token symbols
; https://xania.org/201406/elites-crazy-string-format
;
.export TKN_DOCKED_XOR := $57

; tokens in the text database are scrambled in this way:
.define .scramble(value) value ^ TKN_DOCKED_XOR

;-------------------------------------------------------------------------------
; 32 of the docked tokens are functions called when the token is encountered
; in a string. this segment defines a look-up table of which function to call
; for each token (once descrambled)
; 
.segment "TEXT_TOKENS"

; begin with an [unscrambled] token index of 1,
; because token $00 is always invalid
;
_fn_index       .set 1

; in order to build the table, we need a macro because
; each entry in the table must do three things:
;
; 1.    import the symbol for the function -- the functions are not
;       in this file but in "text_docked_fns.asm" instead
;
; 2.    define a local symbol for the token ID as the strings containing the
;       token are defined within this file. these will be in the form "FN_*"
;
; 3.    define a global version of the symbol for when it appears outside
;       of the text database. these will be in the form "TXTFN_*"
;
.macro  .tkn_fn         fn_import, fn_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        ; scramble the function index to produce
        ; the token ID used in docked strings
        .local  _value
        _value  .set .scramble( _fn_index )
        ; define the function token locally,
        ; using the name part given
        .ident( .concat( "FN_", fn_id )) = _value
        ; define an export for the index-number of the function;
        ; this is how the outside world will specify the token ID
.export .ident( .concat( "TKN_DOCKED_FN_", fn_id )) = _fn_index

        ; import the function from "text_docked_fns.asm",
        ; and write its address to the table
.import fn_import
        .addr   fn_import

        ; move to the next index number
        _fn_index .set _fn_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


tkn_docked_functions:                                                   ;$250C
;===============================================================================
; here begins the table of unscrambled token -> function call mappings.
; the columns given are:
; 
; index         the index in the table, basis for the scrambled token
; function      the function to import & call for the token
; symbol        name slug to define the local and global symbol; the local
;               symbol will be prefixed with "FN_" and the global symbol
;               will be prefixed with "TKN_DOCKED_FN_" and exported
; token         the index is scrambled (XOR $57) and this becomes
;               the token ID that is used within the text database
;
.export tkn_docked_functions
;-------------------------------------------------------------------------------
; index         function:                       symbol:                 token:
;-------------------------------------------------------------------------------
; $01           ?
.tkn_fn         tkn_docked_fn01,                "FN01"                  ;=$56
; $02           ?
.tkn_fn         tkn_docked_fn02,                "FN02"                  ;=$55
; $03           print flight-token $03
.tkn_fn         print_flight_token,             "PRINT_FLIGHT_TOKEN"    ;=$54
; $04           print flight-token $04
.tkn_fn         print_flight_token,             "FN04"                  ;=$53
; $05           ?
.tkn_fn         tkn_docked_fn05,                "FN05"                  ;=$52
; $06           ?
.tkn_fn         tkn_docked_fn06,                "FN06"                  ;=$51
; $07           print character $07 -- ?
.tkn_fn         print_char,                     "FN07"                  ;=$50
; $08           ?
.tkn_fn         tkn_docked_fn08,                "FN08"                  ;=$5F
; $09           clear the screen, switch to empty menu page
.tkn_fn         tkn_docked_clearScreen,         "CLEAR_SCREEN"          ;=$5E
; $0A           print character $0A -- ?
.tkn_fn         print_char,                     "FN0A"                  ;=$5D
; $0B           draw a divider across the screen; used for page titles
.tkn_fn         draw_title_divider,             "DIVIDER"               ;=$5C
; $0C           print a newline character -- $0C
.tkn_fn         print_char,                     "NEWLINE"               ;=$5B
; $0D           ?
.tkn_fn         tkn_docked_fn0D,                "FN0D"                  ;=$5A
; $0E           ?
.tkn_fn         tkn_docked_fn0E,                "FN0E"                  ;=$59
; $0F           ?
.tkn_fn         tkn_docked_fn0F,                "FN0F"                  ;=$58
; $10           print "a". truly, truly, a bizzare use of a function token
.tkn_fn         print_a,                        "A"                     ;=$47
; $11           ?
.tkn_fn         tkn_docked_fn11,                "FN11"                  ;=$46
; $12           ?
.tkn_fn         tkn_docked_fn12,                "FN12"                  ;=$45
; $13           ?
.tkn_fn         tkn_docked_capitalizeNext,      "CAPNEXT"               ;=$44
; $14           print character $14 -- ?
.tkn_fn         print_char,                     "FN14"                  ;=$43
; $15           ?
.tkn_fn         tkn_docked_fn15,                "FN15"                  ;=$42      
; $16           ?
.tkn_fn         tkn_docked_fn16,                "FN16"                  ;=$41
; $17           ?
.tkn_fn         tkn_docked_fn17,                "FN17"                  ;=$40
; $18           wait for any key to be pressed
.tkn_fn         tkn_docked_waitForAnyKey,       "WAIT_FOR_KEY"          ;=$4F
; $19           flash "incoming message" on screen
.tkn_fn         tkn_docked_incoming_message,    "INCOMING_MESSAGE"      ;=$4E
; $1A           ?
.tkn_fn         tkn_docked_fn1A,                "FN1A"                  ;=$4D
; $1B           prints an NPC's name (based on the current galaxy number)
.tkn_fn         tkn_docked_theirName,           "THEIR_NAME"            ;=$4C
; $1C           for the prototype mission, changes the end of the sentence
;               based upon the galaxy number, although unused in practice
.tkn_fn         tkn_docked_protoGalaxy,         "PROTO_GALAXY"          ;=$4B
; $1D           ?
.tkn_fn         tkn_docked_fn1D,                "FN1D"                  ;=$4A
; $1E           print currently selected load/save media -- disk / tape
.tkn_fn         tkn_docked_fn_mediaCurrent,     "MEDIA_CURRENT"         ;=$49
; $1F           print the non-selected load/save media -- disk / tape 
.tkn_fn         tkn_docked_fn_mediaOther,       "MEDIA_OTHER"           ;=$48
; $20           print space. unused in practice though as space
;               is already handled in the code before we get here 
.tkn_fn         print_char,                     "SPACE"                 ;=$77

;===============================================================================

.segment        "TEXT_DOCKED"

; import the token numbers for the common charcter pairs used by docked
; strings ("text_pairs.asm"). these come unscrambled; we scramble them
; here, for the on-disk format
;
.import tkn_docked_crlf:direct
CRLF    = .scramble( tkn_docked_crlf )  ;=$80
.import tkn_docked_ab:direct
_AB     = .scramble( tkn_docked_ab )    ;=$8F
.import tkn_docked_ou:direct
_OU     = .scramble( tkn_docked_ou )    ;=$8E
.import tkn_docked_se:direct
_SE     = .scramble( tkn_docked_se )    ;=$8D
.import tkn_docked_it:direct
_IT     = .scramble( tkn_docked_it )    ;=$8C
.import tkn_docked_il:direct
_IL     = .scramble( tkn_docked_il )    ;=$8B
.import tkn_docked_et:direct
_ET     = .scramble( tkn_docked_et )    ;=$8A
.import tkn_docked_st:direct
_ST     = .scramble( tkn_docked_st )    ;=$89
.import tkn_docked_on:direct
_ON     = .scramble( tkn_docked_on )    ;=$88
.import tkn_docked_lo:direct
_LO     = .scramble( tkn_docked_lo )    ;=$B7
.import tkn_docked_nu:direct
_NU     = .scramble( tkn_docked_nu )    ;=$B6
.import tkn_docked_th:direct
_TH     = .scramble( tkn_docked_th )    ;=$B5
.import tkn_docked_no:direct
_NO     = .scramble( tkn_docked_no )    ;=$B4
.import tkn_docked_al:direct
_AL     = .scramble( tkn_docked_al )    ;=$B3
.import tkn_docked_le:direct
_LE     = .scramble( tkn_docked_le )    ;=$B2
.import tkn_docked_xe:direct
_XE     = .scramble( tkn_docked_xe )    ;=$B1
.import tkn_docked_ge:direct
_GE     = .scramble( tkn_docked_ge )    ;=$B0
.import tkn_docked_za:direct
_ZA     = .scramble( tkn_docked_za )    ;=$BF -- unused here
.import tkn_docked_ce:direct
_CE     = .scramble( tkn_docked_ce )    ;=$BE
.import tkn_docked_bi:direct
_BI     = .scramble( tkn_docked_bi )    ;=$BD
.import tkn_docked_so:direct
_SO     = .scramble( tkn_docked_so )    ;=$BC
.import tkn_docked_us:direct
_US     = .scramble( tkn_docked_us )    ;=$BB
.import tkn_docked_es:direct
_ES     = .scramble( tkn_docked_es )    ;=$BA
.import tkn_docked_ar:direct
_AR     = .scramble( tkn_docked_ar )    ;=$B9
.import tkn_docked_ma:direct
_MA     = .scramble( tkn_docked_ma )    ;=$B8
.import tkn_docked_in:direct
_IN     = .scramble( tkn_docked_in )    ;=$A7
.import tkn_docked_di:direct
_DI     = .scramble( tkn_docked_di )    ;=$A6
.import tkn_docked_re:direct
_RE     = .scramble( tkn_docked_re )    ;=$A5
.import tkn_docked_a_:direct
__A     = .scramble( tkn_docked_a_ )    ;=$A4
.import tkn_docked_er:direct
_ER     = .scramble( tkn_docked_er )    ;=$A3
.import tkn_docked_at:direct
_AT     = .scramble( tkn_docked_at )    ;=$A2
.import tkn_docked_en:direct
_EN     = .scramble( tkn_docked_en )    ;=$A1
.import tkn_docked_be:direct
_BE     = .scramble( tkn_docked_be )    ;=$A0
.import tkn_docked_ra:direct
_RA     = .scramble( tkn_docked_ra )    ;=$AF
.import tkn_docked_la:direct
_LA     = .scramble( tkn_docked_la )    ;=$AE
.import tkn_docked_ve:direct
_VE     = .scramble( tkn_docked_ve )    ;=$AD
.import tkn_docked_ti:direct
_TI     = .scramble( tkn_docked_ti )    ;=$AC
.import tkn_docked_ed:direct
_ED     = .scramble( tkn_docked_ed )    ;=$AB
.import tkn_docked_or:direct
_OR     = .scramble( tkn_docked_or )    ;=$AA
.import tkn_docked_qu:direct
_QU     = .scramble( tkn_docked_qu )    ;=$A9
.import tkn_docked_an:direct
_AN     = .scramble( tkn_docked_an )    ;=$A8

; scramble regular ASCII characters:
;-------------------------------------------------------------------------------
__end   = .scramble( $00 )              ;=$57
__      = .scramble( $20 )              ;=$77
_XMARK  = .scramble( $21 )              ;=$76
_APOS   = .scramble( $27 )              ;=$70
_LPAREN = .scramble( $28 )              ;=$7F
_RPAREN = .scramble( $29 )              ;=$7E
_COMMA  = .scramble( $2c )              ;=$7B
_HYPHEN = .scramble( $2d )              ;=$7A
_DOT    = .scramble( $2e )              ;=$79
_SLASH  = .scramble( $2f )              ;=$78
_0      = .scramble( $30 )              ;=$67
_1      = .scramble( $31 )              ;=$66
_2      = .scramble( $32 )              ;=$65
_3      = .scramble( $33 )              ;=$64
_4      = .scramble( $34 )              ;=$63
_5      = .scramble( $35 )              ;=$62
_6      = .scramble( $36 )              ;=$61
_7      = .scramble( $37 )              ;=$60
_8      = .scramble( $38 )              ;=$6F
_9      = .scramble( $39 )              ;=$6E
_COLON  = .scramble( $3a )              ;=$6D
_QMARK  = .scramble( $3f )              ;=$68
_A      = .scramble( $41 )              ;=$16
_B      = .scramble( $42 )              ;=$15
_C      = .scramble( $43 )              ;=$14
_D      = .scramble( $44 )              ;=$13
_E      = .scramble( $45 )              ;=$12
_F      = .scramble( $46 )              ;=$11
_G      = .scramble( $47 )              ;=$10
_H      = .scramble( $48 )              ;=$1F
_I      = .scramble( $49 )              ;=$1E
_J      = .scramble( $4a )              ;=$1D
_K      = .scramble( $4b )              ;=$1C
_L      = .scramble( $4c )              ;=$1B
_M      = .scramble( $4d )              ;=$1A
_N      = .scramble( $4e )              ;=$19
_O      = .scramble( $4f )              ;=$18
_P      = .scramble( $50 )              ;=$07
_Q      = .scramble( $51 )              ;=$06
_R      = .scramble( $52 )              ;=$05
_S      = .scramble( $53 )              ;=$04
_T      = .scramble( $54 )              ;=$03
_U      = .scramble( $55 )              ;=$02
_V      = .scramble( $56 )              ;=$01
_W      = .scramble( $57 )              ;=$00
_X      = .scramble( $58 )              ;=$0F
_Y      = .scramble( $59 )              ;=$0E
_Z      = .scramble( $5a )              ;=$0D

;===============================================================================

_msg_index     .set 0

.macro  .msg_id         msg_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        ; define a reference for the un-scrambled index value,
        ; (should it be needed)
        .ident(.concat("ID", msg_id)) = _msg_index

        .local  _value
        _value  .set 0
        _value  .set .scramble( _msg_index )
        
        ; define the locally scrambled name, e.g. "_A",
        ; used for the text database
        .ident(msg_id) = _value

        ; define an export for the index-number of the message;
        ; this is how the outside world will specify the message to print
        .export .ident(.concat("MSG_DOCKED", msg_id)) = _msg_index

        .if _msg_index >= $81 && _msg_index <= $d6
                ;;.out .sprintf(": $%0.2x: MSG%s", _value, msg_id)
        .endif

        ; move to the next index number:
        ; doing this afterwards ensures that there is an index 0
        _msg_index .set _msg_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.define .msg_skip       _msg_index .set _msg_index + 1

; begin the "docked" text database:
;
_0e00:                                                                  ;$0E00
;===============================================================================
.export _0e00
        ; index (unscrambled)
        ;-----------------------------------------------------------------------
        ; $00:  index 0 is always invalid
        .byte   __end
        .msg_skip

        ; $01:  disk / tape access menu
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_FN01, FN_FN08, __
        ;       "disk" / "tape" "access menu"
        .byte   FN_MEDIA_CURRENT, __, _A, _C, _CE, _S, _S, __, _M, _E, _NU
        .byte   CRLF, FN_FN0A, FN_FN02
        .byte   _1, _DOT, __, _LOAD_NEW_COMMANDER, CRLF
        .byte   _2, _DOT, __, _S, _A, _VE, __, _COMMANDER, __, FN_FN04, CRLF
        .byte   _3, _DOT, __, _C, _H, _AN, _GE, _TO, FN_MEDIA_OTHER, CRLF
        .byte   _4, _DOT, __, _D, _E, _F, _A, _U, _L, _T, __
        .byte   FN_FN01, _J, _A, _M, _E, _S, _O, _N, FN_FN02, CRLF
        .byte   _5, _DOT, __, _E, _X, _IT, CRLF
        .byte   __end
        .msg_id "_DATA_MENU"
        
        ; $02:
        .byte   _DI, _S, _K, __end
        .msg_id     "_DISK"
        
        ; $03:
        ; TODO: remove tape code / references
        .byte   _T, _A, _P, _E, __end
        .msg_id "_TAPE"
        
        ; $04:
        ; TODO: build option to remove competition number
        .byte   _C, _O, _M, _P, _E, _TI, _TI, _ON, __
        .byte   _NU, _M, _B, _ER, _COLON, __end
        .msg_id "_COMPETITION_NUMBER"
        
        ; $05:
        .byte   _B0, .scramble($6d), _IS, .scramble($6e), _B1, __end
        .msg_id "_05"
        
        ; $06:
        .byte   __, __, _LOAD_NEW_COMMANDER, __, FN_FN01
        .byte   _LPAREN, _Y, _SLASH, _N, _RPAREN, _QMARK
        .byte   FN_FN02, FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "_06"

        ; $07:
        .byte   _P, _RE, _S, _S, __, _S, _P, _A, _CE, __, _OR, __, _F, _I, _RE
        .byte   _COMMA, _COMMANDER, _DOT, FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "_07"
        
        ; $08:
        .byte   _COMMANDER, _APOS, _S, _C8, __end
        .msg_id "_08"
        
        ; $09:
        .byte   FN_NEWLINE, FN_FN01, _IL, _LE, _G, _AL, __
        .byte   _E, _L, _I, _T, _E, __, _I, _I, __, _F, _I, _LE, __end
        .msg_id "_ILLEGAL_FILE"
        
        ; $0A:
        .byte   FN_FN17, FN_FN0E, FN_FN02, _G, _RE, _ET, _IN, _G, _S
        .byte   _COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY
        .byte   _AND_, FN_CAPNEXT, _I, __, _BE, _G, _A_, _M, _O, _M, _EN, _T
        .byte   __, _O, _F, __, _YOU, _R, __, _V, _AL, _U, _AB, _LE
        .byte   __, _TI, _M, _E, _NEW_SENTENCE

        .byte   _W, _E, __, _W, _OU, _L, _D, __, _L, _I, _K, _E, __, _YOU, _TO
        .byte   _D, _O, _A_, _L, _IT, _T, _LE, __, _J, _O, _B, __, _F, _OR, __
        .byte   _US, _NEW_SENTENCE

        .byte   _THE_, _SHIP, __, _YOU, __, _SE, _E, __, _H, _E, _RE, _IS, _A
        .byte   _NEW, _M, _O, _D, _E, _L, _COMMA, __, _THE_, FN_CAPNEXT
        .byte   _C, _ON, _ST, _R, _I, _C, _T, _OR, _COMMA, __
        .byte   _E, _QU, _I, _P, _ED_, _W, _I, _TH, _A_, _T, _O, _P, __
        .byte   _SE, _C, _R, _ET, _NEW, _S, _H, _I, _E, _L, _D, __
        .byte   _G, _EN, _ER, _AT, _OR, _NEW_SENTENCE

        .byte   _U, _N, _F, _OR, _T, _U, _N, _AT, _E, _L, _Y, __, _IT
        .byte   _APOS, _S, __, _BE, _EN, __, _ST, _O, _L, _EN
        .byte   _NEW_SENTENCE

        .byte   FN_FN16, _IT, __, _W, _EN, _T, __, _M, _I, _S, _S, _ING_
        .byte   _F, _R, _O, _M, __, _OU, _R, __, _SHIP, __, _Y, _AR, _D, __
        .byte   _ON, __, FN_CAPNEXT, _XE, _ER, __, _F, _I, _VE, __
        .byte   _M, _ON, _TH, _S, __, _A, _G, _O, _AND_
        ;       "is believed to have jumped to this galaxy"
        ;       (see msg index 221)
        .byte   FN_PROTO_GALAXY, _NEW_SENTENCE

        .byte   _YOU, _R, __, _M, _I, _S, _S, _I, _ON, _COMMA, __
        .byte   _S, _H, _OU, _L, _D, __, _YOU, __, _D, _E, _C, _I, _D, _E, _TO
        .byte   _A, _C, _CE, _P, _T, __, _IT, _COMMA, __, _I, _S, _TO
        .byte   _SE, _E, _K, _AND_, _D, _ES, _T, _R, _O, _Y, __, _THIS, _SHIP
        .byte   _NEW_SENTENCE

        .byte   _YOU, __, _A, _RE, __, _C, _A, _U, _TI, _ON, _ED_, _TH, _AT, __
        .byte   _ON, _L, _Y, __, FN_FN06, .scramble($75), FN_FN05, _S, __
        .byte   _W, _IL, _L, __, _P, _EN, _ET, _RA, _T, _E, __, _THE_
        .byte   _N, _E, _W, __, _S, _H, _I, _E, _L, _D, _S, _AND_, _TH, _AT, __
        .byte   _THE_, FN_CAPNEXT, _C, _ON, _ST, _R, _I, _C, _T, _OR, _IS
        .byte   _F, _IT, _T, _ED_, _W, _I, _TH, __, _AN, __, FN_FN06
        .byte   .scramble($6c), FN_FN05, _B1, FN_FN02, FN_FN08
        .byte   _G, _O, _O, _D, __, _L, _U, _C, _K, _COMMA, __, _COMMANDER
        .byte   _D4, FN_FN16, __end
        .msg_id "_0A"
        
        ; $0B:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_FN17, FN_FN0E, FN_FN02, __, __, _AT, _T, _EN, _TI, _ON
        .byte   _COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY, _DOT, __
        .byte   FN_CAPNEXT, _W, _E, __, _H, _A, _VE, __, _N, _E, _ED_, _O, _F
        .byte   __, _YOU, _R, __, _SE, _R, _V, _I, _C, _ES, __, _A, _G, _A, _IN
        .byte   _NEW_SENTENCE

        .byte   _I, _F, __, _YOU, __, _W, _OU, _L, _D, __, _BE, __, _SO, __
        .byte   _G, _O, _O, _D, __, _A, _S, _TO, _G, _O, _TO
        .byte   FN_CAPNEXT, _CE, _ER, _DI, __, _YOU, __, _W, _IL, _L, __
        .byte   _BE, __, _B, _R, _I, _E, _F, _ED, _NEW_SENTENCE

        .byte   _I, _F, __, _S, _U, _C, _CE, _S, _S, _F, _U, _L, _COMMA, __
        .byte   _YOU, __, _W, _IL, _L, __, _BE, __, _W, _E, _L, _L, __
        .byte   _RE, _W, _AR, _D, _ED, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "_0B"

        ;-----------------------------------------------------------------------
        ; $0C:  "(C) D.Braben & I.Bell 1985"
        .byte   _LPAREN, FN_CAPNEXT, _C, _RPAREN, _DBRABEN_AND_IBELL
        .byte   __, _1, _9, _8, _5, __end
        .msg_id "_0C"
        
        ; $0D:  "by D.Braben & I.Bell"
        .byte   _B, _Y, _DBRABEN_AND_IBELL, __end
        .msg_id "_0D"

        ; $0E:
        .byte   FN_FN15, _PLANET, _C8, FN_FN1A, __end
        .msg_id "_0E"

        ; $0F:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_FN17, FN_FN0E
        .byte   FN_FN02, __, __, _C, _ON, _G, _RA, _T, _U, _LA, _TI, _ON, _S, __
        .byte   _COMMANDER, _XMARK, FN_NEWLINE, FN_NEWLINE

        .byte   _TH, _ER, _E, FN_FN0D, __, _W, _IL, _L, __, _AL, _W, _A, _Y, _S
        .byte   __, _BE, _A_, _P, _LA, _CE, __, _F, _OR, __, _YOU, __, _IN
        .byte   _HER_MAJESTYS_SPACE_NAVY, _NEW_SENTENCE

        .byte   _AN, _D, __, _MA, _Y, _BE, __, _SO, _ON, _ER, __, _TH, _AN, __
        .byte   _YOU, __, _TH, _IN, _K, _DOT, _DOT, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "_0F"

        ;-----------------------------------------------------------------------
        ; $10:  "fabled"
        .byte   _F, _AB, _LE, _D, __end
        .msg_id "_FABLED"

        ; $11:  "notable"
        .byte   _NO, _T, _AB, _LE, __end
        .msg_id "_NOTABLE"

        ; $12:  "well known"
        .byte   _W, _E, _L, _L, __, _K, _NO, _W, _N, __end
        .msg_id "_WELL_KNOWN"

        ; $13:  "famous"
        .byte   _F, _A, _M, _O, _US, __end
        .msg_id "_FAMOUS"

        ; $14:  "noted"
        .byte   _NO, _T, _ED, __end
        .msg_id "_NOTED"

        ;-----------------------------------------------------------------------
        ; $15:  "very"
        .byte   _VE, _R, _Y, __end
        .msg_id "_VERY"

        ; $16:  "mildly"
        .byte   _M, _IL, _D, _L, _Y, __end
        .msg_id "_MILDLY"

        ; $17:  "most"
        .byte   _M, _O, _ST, __end
        .msg_id "_MOST"

        ; $18:  "reasonably"
        .byte   _RE, _A, _S, _ON, _AB, _L, _Y, __end
        .msg_id "_REASONABLY"

        ; $19:
        .byte   __end
        .msg_skip
        
        ;-----------------------------------------------------------------------
        ; $1A:
        .byte   _ANCIENT, __end
        .msg_id "_1A"

        ; $1B:
        .byte   .scramble($72), __end
        .msg_id "_1B"

        ; $1C:  "great"
        .byte   _G, _RE, _AT, __end
        .msg_id "_GREAT"
        
        ; $1D:  "vast"
        .byte   _V, _A, _ST, __end
        .msg_id "_VAST"

        ; $1E:  "pink"
        .byte   _P, _IN, _K, __end
        .msg_id "_PINK"
        
        ;-----------------------------------------------------------------------
        ; $1F:
        .byte   FN_FN02, .scramble($77), __, .scramble($76)
        .byte   FN_FN0D, __, _PLANT, _A, _TI, _ON, _S, __end
        .msg_id "_1F"

        ; $20:  "mountains"
        .byte   _MOUNTAIN, _S, __end
        .msg_id "_20"

        ; $21:
        .byte   .scramble($75), __end
        .msg_id "_21"
        
        ; $22:
        .byte   .scramble($80), __, _F, _OR, _ES, _T, _S, __end
        .msg_id "_22"
        
        ; $23:  "oceans"
        .byte   _O, _CE, _AN, _S, __end
        .msg_id "_OCEANS"
        
        ;-----------------------------------------------------------------------
        ; $24:  "shyness"
        .byte   _S, _H, _Y, _N, _ES, _S, __end
        .msg_id "_SHYNESS"
        
        ; $25:  "silliness"
        .byte   _S, _IL, _L, _IN, _ES, _S, __end
        .msg_id "_SILLINESS"
        
        ; $26:  "mating traditions"
        .byte   _MA, _T, _ING_, _T, _RA, _DI, _TI, _ON, _S, __end
        .msg_id "_26"
        
        ; $27:
        .byte   _LO, _AT, _H, _ING_, _O, _F, __, $33, __end
        .msg_id "_27"
        
        ; $28:
        .byte   _LO, _VE, __, _F, _OR, __, $33, __end
        .msg_id "_28"
        
        ; $29:  "food blenders"
        .byte   _F, _O, _O, _D, __, _B, _LE, _N, _D, _ER, _S, __end
        .msg_id "_FOOD_BLENDERS"
        
        ; $2A:  "tourists"
        .byte   _T, _OU, _R, _I, _ST, _S, __end
        .msg_id "_TOURISTS"
        
        ; $2B:  "poetry"
        .byte   _P, _O, _ET, _R, _Y, __end
        .msg_id "_POETRY"
        
        ; $2C:  "discos"
        .byte   _DI, _S, _C, _O, _S, __end
        .msg_id "_DISCOS"
        
        ; $2D:
        .byte   $3b, __end
        .msg_id "_2D"
        
        ;-----------------------------------------------------------------------
        ; $2E:  "walking tree"
        .byte   _W, _AL, _K, _ING_, _TREE, __end
        .msg_id "_WALKING_TREE"
        
        ; $2F:  "crab"
        .byte   _C, _RA, _B, __end
        .msg_id "_CRAB"
        
        ; $30:  "bat"
        .byte   _B, _AT, __end
        .msg_id "_BAT"
        
        ; $31:  "lobst"?
        .byte   _LO, _B, _ST, __end
        .msg_id "_LOBST"
        
        ; $32:
        .byte   FN_FN12, __end
        .msg_id "_32"
        
        ;-----------------------------------------------------------------------
        ; $33:  "beset"
        .byte   _BE, _S, _ET, __end
        .msg_id "_BESET"
        
        ; $34:  "plagued"
        .byte   _P, _LA, _G, _U, _ED, __end
        .msg_id "_PLAGUED"
        
        ; $35:  "ravaged"
        .byte   _RA, _V, _A, _G, _ED, __end
        .msg_id "_RAVAGED"
        
        ; $36:  "cursed"
        .byte   _C, _U, _R, _S, _ED, __end
        .msg_id "_CURSED"
        
        ; $37:  "scourged"
        .byte   _S, _C, _OU, _R, _G, _ED, __end
        .msg_id "_SCOURGED"
        
        ;-----------------------------------------------------------------------
        ; $38:
        .byte   .scramble($71), __, _C, _I, _V, _IL, __, _W, _AR, __end
        .msg_id "_38"
        
        ; $39:
        .byte   $3f, __, $08, __, $37, _S, __end
        .msg_id "_39"
        
        ; $3A:
        .byte   _A, __, $3f, __, _DI, _SE, _A, _SE, __end
        .msg_id "_3A"
        
        ; $3B:
        .byte   $26, __, _E, _AR, _TH, _QU, _A, _K, _ES, __end
        .msg_id "_3B"
        
        ; $3C:
        .byte   $26, __, _SO, _LA, _R, __, _A, _C, _TI, _V, _IT, _Y, __end
        .msg_id "_3C"
        
        ;-----------------------------------------------------------------------
        ; $3D:
        .byte   _ITS, $0a, __, $09, __end
        .msg_id "_3D"
        
        ; $3E:
        .byte   _THE_, FN_FN11, __, $08, __, $37, __end
        .msg_id "_3E"
        
        ; $3F:
        .byte   _ITS, _INHABITANT, _S, _APOS, __, $35, __, $34, __end
        .msg_id "_3F"
        
        ; $40:
        .byte   FN_FN02, $2d, FN_FN0D, __end
        .msg_id "_40"
        
        ; $41:
        .byte   _ITS, $3c, __, $3b, __end
        .msg_id "_41"
        
        ;-----------------------------------------------------------------------
        ; $42:  "juice"
        .byte   _J, _U, _I, _CE, __end
        .msg_id "_JUICE"
        
        ; $43:  "brandy"
        .byte   _B, _RA, _N, _D, _Y, __end
        .msg_id "_BRANDY"
        
        ; $44:  "water"
        .byte   _W, _AT, _ER, __end
        .msg_id "_WATER"
        
        ; $45:  "brew"
        .byte   _B, _RE, _W, __end
        .msg_id "_BREW"
        
        ; $46:  "gargle blasters"
        .byte   _G, _AR, _G, _LE, __, _B, _LA, _ST, _ER, _S, __end
        .msg_id "_GARGLE_BLASTERS"
        
        ;-----------------------------------------------------------------------
        ; $47:
        .byte   FN_FN12, __end
        .msg_id "_47"
        
        ; $48:
        .byte   FN_FN11, __, $37, __end
        .msg_id "_48"
        
        ; $49:
        .byte   FN_FN11, __, FN_FN12, __end
        .msg_id "_49"
        
        ; $4A:
        .byte   FN_FN11, __, $3f, __end
        .msg_id "_4A"
        
        ; $4B:
        .byte   $3f, __, FN_FN12, __end
        .msg_id "_4B"
        
        ;-----------------------------------------------------------------------
        ; $4C:  "fabulous"
        .byte   _F, _AB, _U, _LO, _US, __end
        .msg_id "_FABULOUS"
        
        ; $4D:  "exotic"
        .byte   _E, _X, _O, _TI, _C, __end
        .msg_id "_EXOTIC"
        
        ; $4E:  "hoopy"
        .byte   _H, _O, _O, _P, _Y, __end
        .msg_id "_HOOPY"
        
        ; $4F:  "unusual"
        .byte   _U, _NU, _S, _U, _AL, __end
        ;;.msg_id "_UNUSUAL"
        .msg_skip
        
        ; $50:  "exciting"
        .byte   _E, _X, _C, _IT, _IN, _G, __end
        .msg_id "_EXCITING"
        
        ;-----------------------------------------------------------------------
        ; $51:  "cuisine"
        .byte   _C, _U, _I, _S, _IN, _E, __end
        .msg_id "_CUISINE"
        
        ; $52:  "night life"
        .byte   _N, _I, _G, _H, _T, __, _L, _I, _F, _E, __end
        .msg_id "_NIGHT_LIFE"
        
        ; $53:  "casinos"
        .byte   _C, _A, _S, _I, _NO, _S, __end
        .msg_id "_CASINOS"
        
        ; $54:  "sit coms"
        .byte   _S, _IT, __, _C, _O, _M, _S, __end
        .msg_id "_SIT_COMS"
        
        ; $55:
        .byte   FN_FN02, $2d, FN_FN0D, __end
        .msg_id "_55"
        
        ;-----------------------------------------------------------------------
        ; $56:
        .byte   FN_PRINT_FLIGHT_TOKEN, __end
        .msg_id "_56"
        
        ; $57:
        .byte   _THE_, _PLANET, __, FN_PRINT_FLIGHT_TOKEN, __end
        .msg_id "_57"
        
        ; $58:
        .byte   _THE_, _WORLD, __, FN_PRINT_FLIGHT_TOKEN, __end
        .msg_id "_58"
        
        ; $59:
        .byte   _THIS, _PLANET, __end
        .msg_id "_59"
        
        ; $5A
        .byte   _THIS, _WORLD, __end
        .msg_id "_5A"
        
        ;-----------------------------------------------------------------------
        ; $5B:  "son of a bitch"
        .byte   _S, _ON, __, _O, _F, _A_, _B, _IT, _C, _H, __end
        .msg_id "_SON_OF_A_BITCH"
        
        ; $5C:  "scoundrel"
        .byte   _S, _C, _OU, _N, _D, _RE, _L, __end
        .msg_id "_SCOUNDRELL"
        
        ; $5D:  "blackguard"
        .byte   _B, _LA, _C, _K, _G, _U, _AR, _D, __end
        .msg_id "_BLACKGUARD"
        
        ; $5E:  "rogue"
        .byte   _R, _O, _G, _U, _E, __end
        .msg_id "_ROGUE"
        
        ; $5F:  "whoreson beetle headed flap ear'd knave"
        .byte   _W, _H, _OR, _ES, _ON, __, _BE, _ET, _LE, __
        .byte   _H, _E, _A, _D, _ED_, _F, _LA, _P, __, _E, _AR, _APOS, _D, __
        .byte   _K, _N, _A, _VE, __end
        .msg_id "_5F"
        
        ;-----------------------------------------------------------------------
        ; $60:  "n unremarkable"?
        .byte   _N, __, _U, _N, _RE, _MA, _R, _K, _AB, _LE, __end
        .msg_id "_60"
        
        ; $61:
        .byte   __, _B, _OR, _IN, _G, __end
        .msg_id "_BORING"
        
        ; $62:
        .byte   __, _D, _U, _L, _L, __end
        .msg_id "_DULL"
        
        ; $63:
        .byte   __, _T, _E, _DI, _O, _US, __end
        .msg_id "_TEDIOUS"
        
        ; $64:
        .byte   __, _RE, _V, _O, _L, _T, _IN, _G, __end
        .msg_id "_REVOLTING"
        
        ; $65:
        .byte   _PLANET, __end
        .msg_id "_65"
        
        ; $66:
        .byte   _WORLD, __end
        .msg_id "_66"
        
        ; $67:
        .byte   _P, _LA, _CE, __end
        .msg_id "_PLACE"
        
        ; $68:
        .byte   _L, _IT, _T, _LE, __, _PLANET, __end
        .msg_id "_LITTLE_PLANET"
        
        ; $69:
        .byte   _D, _U, _M, _P, __end
        .msg_id "_DUMP"
        
        ; hints on finding the prototype ship:
        ;-----------------------------------------------------------------------
        ; $6A:
        .byte   _I, __, _H, _E, _AR, _A_, .scramble($72), __
        .byte   _LO, _O, _K, _ING_, _SHIP, __, _A, _P, _P, _E, _AR, _ED_
        .byte   _AT, _ERRIUS, __end
        .msg_id "_6A"
        
        ; $6B:
        .byte   _Y, _E, _A, _H, _COMMA, __
        .byte   _I, __, _H, _E, _AR, _A_, .scramble($72), __
        .byte   _SHIP, __, _LE, _F, _T, _ERRIUS, _A_, __
        .byte   _W, _H, _I, _LE, __, _B, _A, _C
        .byte   _K, __end
        .msg_id "_6B"
        
        ; $6C:
        .byte   _G, _ET, __, _YOU, _R, __, _I, _R, _ON, __, _A, _S, _S, __
        .byte   _O, _V, _ER, __, _T, _O, _ERRIUS, __end
        .msg_id "_6C"
        
        ; $6D:
        .byte   _SO, _M, _E, __, $24, _NEW, _SHIP, __
        .byte   _W, _A, _S, __, _SE, _EN, __, _AT
        .byte   _ERRIUS, __end
        .msg_id "_6D"
        
        ; $6E:
        .byte   _T, _R, _Y, _ERRIUS, __end
        .msg_id "_6E"
        
        ; Trumble™ descriptions?
        ;-----------------------------------------------------------------------
        ; $6F:  " cuddly"
        .byte   __, _C, _U, _D, _D, _L, _Y, __end
        .msg_id "_CUDDLY"
        
        ; $70:  " cute"
        .byte   __, _C, _U, _T, _E, __end
        .msg_id "_CUTE"
        
        ; $71:  " furry"
        .byte   __, _F, _U, _R, _R, _Y, __end
        .msg_id "_FURRY"
        
        ; $72:  " friendly"
        .byte   __, _F, _R, _I, _EN, _D, _L, _Y, __end
        .msg_id "_FRIENDLY"
        
        ;-----------------------------------------------------------------------
        ; $73:
        .byte   _W, _A, _S, _P, __end
        .msg_id "_WASP"
        
        ; $74:
        .byte   _M, _O, _TH, __end
        .msg_id "_MOTH"
        
        ; $75:
        .byte   _G, _R, _U, _B, __end
        .msg_id "_GRUB"
        
        ; $76:
        .byte   _AN, _T, __end
        .msg_id "_ANT"
        
        ; $77:
        .byte   FN_FN12, __end
        .msg_id "_77"
        
        ; $78:
        .byte   _P, _O, _ET, __end
        .msg_id "_POET"
        
        ; $79:
        .byte   _AR, _T, _S, __, _G, _RA, _D, _U, _AT, _E, __end
        .msg_id "_ARTS_GRADUATE"
        
        ; $7A:
        .byte   _Y, _A, _K, __end
        .msg_id "_YAK"
        
        ; $7B:
        .byte   _S, _N, _A, _IL, __end
        .msg_id "_SNAIL"
        
        ; $7C:
        .byte   _S, _L, _U, _G, __end
        .msg_id "_SLUG"
        
        ; $7D:
        .byte   _T, _R, _O, _P, _I, _C, _AL, __end
        .msg_id "_TROPICAL"
        
        ; $7E:
        .byte   _D, _EN, _SE, __end
        .msg_id "_DENSE"
        
        ; $7F:
        .byte   _RA, _IN, __end
        .msg_id "_RAIN"
        
        ; $80:
        .byte   _I, _M, _P, _EN, _ET, _RA, _B, _LE, __end
        .msg_id "_IMPENETRABLE"
        
        ; message indices $81..$D6 are expandable via tokens $81..$D6
        ;=======================================================================
        ; TODO: define a constant for this barrier -- if we add or remove
        ;       messages, then the code needs to update CMP checks
        ; 
        ; $81:  "exuberant"
        .byte   _E, _X, _U, _BE, _RA, _N, _T, __end
        .msg_id "_EXUBERANT"
        
        ; $82:  "funny"
        .byte   _F, _U, _N, _N, _Y, __end
        .msg_id "_FUNNY"
        
        ; $83:  "weird"
        .byte   _W, _E, _I, _R, _D, __end
        .msg_id "_WEIRD"
        
        ; $84:  "unusual"
        .byte   _U, _NU, _S, _U, _AL, __end
        .msg_id "_UNUSUAL"
        
        ; $85:  "strange"
        .byte   _ST, _RA, _N, _GE, __end
        .msg_id "_STRANGE"
        
        ; $86:  "preculiar"
        .byte   _P, _E, _C, _U, _L, _I, _AR, __end
        .msg_id "_PECULIAR"
        
        ; $87:  "frequent"
        .byte   _F, _RE, _QU, _EN, _T, __end
        .msg_id "_FREQUENT"
        
        ; $88:  "occasional"
        .byte   _O, _C, _C, _A, _S, _I, _ON, _AL, __end
        .msg_id "_OCCASIONAL"
        
        ; $89:  "unpredicatble"
        .byte   _U, _N, _P, _RE, _DI, _C, _T, _AB, _LE, __end
        .msg_id "_UNPREDICTABLE"
        
        ; $8A:  "dreadful"
        .byte   _D, _RE, _A, _D, _F, _U, _L, __end
        .msg_id "_DREADFUL"
        
        ; $8B:  "deadly"
        .byte   _DEADLY, __end
        .msg_id "_8B"

        ;-----------------------------------------------------------------------
        ; $8C:
        .byte   $0b, __, $0c, __, _F, _OR, __, $32, __end
        .msg_id "_8C"
        
        ; $8D:
        .byte   _8C, _AND_, $32, __end
        .msg_id "_8D"
        
        ; $8E:
        .byte   $31, __, _B, _Y, __, $30, __end
        .msg_id "_8E"
        
        ; $8F:
        .byte   _8C, __, _B, _U, _T, __, _8E, __end
        .msg_id "_8F"
        
        ; $90:
        .byte   __, _A, .scramble($6f), __, $27, __end
        .msg_id "_90"
        
        ; $91:
        .byte   _P, _L, _AN, _ET, __end
        .msg_id "_PLANET"
        
        ; $92:
        .byte   _W, _OR, _L, _D, __end
        .msg_id "_WORLD"
        
        ; $93:  "the "
        .byte   _TH, _E, __, __end
        .msg_id "_THE_"
        
        ; $94:  "this "
        .byte   _TH, _I, _S, __, __end
        .msg_id "_THIS"
        
        ; $95:  "load new Commander"
        .byte   _LO, _A, _D, _NEW, _COMMANDER, __end
        .msg_id "_LOAD_NEW_COMMANDER"
        
        ; $96:
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_FN01, FN_FN08, __end
        .msg_id "_96"
        
        ; $97:  "drive"
        .byte   _D, _R, _I, _VE, __end
        .msg_id "_DRIVE"
        
        ; $98:  " catalogue"
        .byte   __, _C, _AT, _A, _LO, _G, _U, _E, __end
        .msg_id "_CATALOGUE"
        
        ; $99:  "ian"
        .byte   _I, _AN, __end
        .msg_id "_IAN"
        
        ; $9A:  "Commander"
        .byte   FN_CAPNEXT, _C, _O, _M, _M, _AN, _D, _ER, __end
        .msg_id "_COMMANDER"
        
        ; $9B:
        .byte   $3f, __end
        .msg_id "_9B"
        
        ; $9C:  "mountain"
        .byte   _M, _OU, _N, _T, _A, _IN, __end
        .msg_id "_MOUNTAIN"
        
        ; $9D:  "edible"
        .byte   _ED, _I, _B, _LE, __end
        .msg_id "_EDIBLE"
        
        ; $9E:  "tree"
        .byte   _T, _RE, _E, __end
        .msg_id "_TREE"
        
        ; $9F:  "spotted"
        .byte   _S, _P, _O, _T, _T, _ED, __end
        .msg_id "_SPOTTED"
        
        ; $A0:
        .byte   $2f, __end
        .msg_id "_A0"
        
        ; $A1:
        .byte   $2e, __end
        .msg_id "_A1"
        
        ; $A2:
        .byte   $36, _O, _I, _D, __end
        .msg_id "_A2"
        
        ; $A3:
        .byte   $28, __end
        .msg_id "_A3"
        
        ; $A4:
        .byte   $29, __end
        .msg_id "_A4"
        
        ; $A5:
        .byte   _AN, _C, _I, _EN, _T, __end
        .msg_id "_ANCIENT"
        
        ; $A6:
        .byte   _E, _X, _CE, _P, _TI, _ON, _AL, __end
        .msg_id "_EXCEPTIONAL"
        
        ; $A7:
        .byte   _E, _C, _CE, _N, _T, _R, _I, _C, __end
        .msg_id "_ECCENTRIC"
        
        ; $A8:
        .byte   _IN, _G, _RA, _IN, _ED, __end
        .msg_id "_INGRAINED"
        
        ; $A9:
        .byte   .scramble($72), __end
        .msg_id "_A9"
        
        ;-----------------------------------------------------------------------
        ; $AA:  "killer"
        .byte   _K, _IL, _L, _ER, __end
        .msg_id "_KILLER"
        
        ; $AB:  "deadly"
        .byte   _D, _E, _A, _D, _L, _Y, __end
        .msg_id "_DEADLY"
        
        ; $AC:  "evil"
        .byte   _E, _V, _IL, __end
        .msg_id "_EVIL"
        
        ; $AD:  "lethal"
        .byte   _LE, _TH, _AL, __end
        .msg_id "_LETHAL"
        
        ; $AE:  "vicious"
        .byte   _V, _I, _C, _I, _O, _US, __end
        .msg_id "_VICIOUS"
        
        ;-----------------------------------------------------------------------
        ; $AF:  "its "
        .byte   _IT, _S, __, __end
        .msg_id "_ITS"
        
        ; $B0:
        .byte   FN_FN0D, FN_FN0E, FN_CAPNEXT, __end
        .msg_id "_B0"
        
        ; $B1:
        .byte   _DOT, FN_NEWLINE, FN_FN0F, __end
        .msg_id "_B1"
        
        ; $B2:
        .byte   __, _AN, _D, __, __end
        .msg_id "_AND_"
        
        ; $B3:
        .byte   _Y, _OU, __end
        .msg_id "_YOU"
        
        ;-----------------------------------------------------------------------
        ; $B4:  "parking meters"
        .byte   _P, _AR, _K, _ING_, _M, _ET, _ER, _S, __end
        .msg_id "_PARKING_METERS"
        
        ; $B5:  "dust clouds"
        .byte   _D, _US, _T, __, _C, _LO, _U, _D, _S, __end
        .msg_id "_DUST_CLOUDS"
        
        ; $B6:  "ice bergs"
        .byte   _I, _CE, __, _BE, _R, _G, _S, __end
        .msg_id "_ICE_BERGS"
        
        ; $B7:  "rock formations"
        .byte   _R, _O, _C, _K, __, _F, _OR, _MA, _TI, _ON, _S, __end
        .msg_id "_ROCK_FORMATIONS"
        
        ; $B8:  "volcanoes"
        .byte   _V, _O, _L, _C, _A, _NO, _ES, __end
        .msg_id "_VOLCANOES"
        
        ;-----------------------------------------------------------------------
        ; $B9:  "plant"
        .byte   _P, _L, _AN, _T, __end
        .msg_id "_PLANT"
        
        ; $BA:  "tulip"
        .byte   _T, _U, _L, _I, _P, __end
        .msg_id "_TULIP"
        
        ; $BB:  "banana"
        .byte   _B, _AN, _AN, _A, __end
        .msg_id "_BANANA"
        
        ; $BC:  "corn"
        .byte   _C, _OR, _N, __end
        .msg_id "_CORN"
        
        ; $BD:
        .byte   FN_FN12, _W, _E, _ED, __end
        .msg_id "_WEED"
        
        ; $BE:
        .byte   FN_FN12, __end
        .msg_id "_BE_"
        
        ; $BF:
        .byte   FN_FN11, __, FN_FN12, __end
        .msg_id "_BF"
        
        ; $C0:
        .byte   FN_FN11, __, $3f, __end
        .msg_id "_C0"
        
        ; $C1:
        .byte   _IN, _H, _A, _BI, _T, _AN, _T, __end
        .msg_id "_INHABITANT"
        
        ; $C2:
        .byte   _BF, __end
        .msg_id "_C2"
        
        ; $C3:
        .byte   _IN, _G, __, __end
        .msg_id "_ING_"
        
        ; $C4:
        .byte   _ED, __, __end
        .msg_id "_ED_"
        
        ; $C5:
        .byte   __, _D, _DOT, _B, _RA, _BE, _N, __
        .byte   $71, __, _I, _DOT, _BE, _L, _L, __end
        .msg_id "_DBRABEN_AND_IBELL"
        
        ; $C6:  " little trumble"
        .byte   __, _L, _IT, _T, _LE, __, _T, _R, _U, _M, _B, _LE, __end
        .msg_id "_LITTLE_TRUMBLE"
        
        ; $C7:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_FN1D
        .byte   FN_FN0E, FN_CAPNEXT, _G, _O, _O, _D, FN_FN0D, __, _D, _A, _Y, __
        .byte   _COMMANDER, __, FN_FN04, _COMMA, __, _AL, _LO, _W, __, _M, _E
        .byte   _TO, _IN, _T, _R, _O, _D, _U, _CE, __, _M, _Y, _SE, _L, _F
        .byte   _DOT, __, FN_CAPNEXT, _I, __, _A, _M, FN_FN02, __, _THE_
        .byte   _M, _ER, _C, _H, _AN, _T, __, _P, _R, _IN, _CE, __, _O, _F, __
        .byte   _TH, _R, _U, _N, FN_FN0D, _AND_, FN_CAPNEXT, _I, __, _F, _IN, _D
        .byte   __, _M, _Y, _SE, _L, _F, __, _F, _OR, _CE, _D, _TO, _SE, _L, _L
        .byte   __, _M, _Y, __, _M, _O, _ST, __, _T, _RE, _A, _S, _U, _R, _ED
        .byte   __, _P, _O, _S, _S, _ES, _S, _I, _ON, _NEW_SENTENCE

        .byte   _I, __, _A, _M, __, _O, _F, _F, _ER, _ING_, _Y, _OU, _COMMA, __
        .byte   _F, _OR, __, _THE_, _P, _A, _L, _T, _R, _Y, __, _S, _U, _M, __
        .byte   _O, _F, __, _J, _U, _ST, __, _5, _0, _0, _0
        .byte   FN_CAPNEXT, _C, FN_CAPNEXT, _R, __, _THE_, _RA, _RE, _ST, __
        .byte   _TH, _ING_, __, _IN, __, _THE_, FN_FN02, _K, _NO, _W, _N, __
        .byte   _U, _N, _I, _VE, _R, _SE, _NEW_SENTENCE
        
        .byte   FN_FN0D, _W, _IL, _L, __, _Y, _OU, __, _T, _A, _K, _E, __, _IT
        .byte   FN_FN01, _LPAREN, _Y, _SLASH, _N, _RPAREN, _QMARK, FN_NEWLINE
        .byte   FN_FN0F, FN_FN01, FN_FN08
        .byte   __end
        .msg_id "_TRUMBLES"
        
        ; $C8:  " name?"
        .byte   __, _N, _A, _M, _E, _QMARK, __
        .byte   __end
        .msg_id "_C8"
        
        ; $C9:  " to "
        .byte   __, _T, _O, __, __end
        .msg_id "_TO"
        
        ; $CA:  " is "
        .byte   __, _I, _S, __, __end
        .msg_id "_IS"
        
        ; $CB:  "was last seen at "
        .byte   _W, _A, _S, __, _LA, _ST, __, _SE, _EN, __, _AT, __, FN_CAPNEXT
        .byte   __end
        .msg_id "_WAS_LAST_SEEN_AT_"
        
        ; $CC:  new sentence -- fullstop, new line, captialise next letter
        .byte   _DOT, FN_NEWLINE, __, FN_CAPNEXT
        .byte   __end
        .msg_id "_NEW_SENTENCE"
        
        ; $CD:  "docked"
        .byte   _D, _O, _C, _K, _ED, __end
        .msg_id "_DOCKED"
        
        ; $CE:
        .byte   FN_FN01, _LPAREN, _Y, _SLASH, _N, _RPAREN, _QMARK, __end
        .msg_id "_CE_"
        
        ; $CF:  "ship"
        .byte   _S, _H, _I, _P, __end
        .msg_id "_SHIP"
        
        ; $D0:  " a "
        .byte   __, _A, __, __end
        .msg_id "_A_"
        
        ; $D1:
        .byte   __, _ER, _R, _I, _US, __end
        .msg_id "_ERRIUS"
        
        ; $D2:
        .byte   __, _N, _E, _W, __, __end
        .msg_id "_NEW"
        
        ; $D3:
        .byte   FN_FN02, __, _H, _ER, __, _MA, _J, _ES, _T, _Y, _APOS, _S, __
        .byte   _S, _P, _A, _CE, __, _N, _A, _V, _Y, FN_FN0D
        .byte   __end
        .msg_id "_HER_MAJESTYS_SPACE_NAVY"
        
        ; $D4:
        .byte   _B1, FN_FN08, FN_FN01, __, __
        .byte   _M, _ES, _S, _A, _GE, __, _EN, _D, _S
        .byte   __end
        .msg_id "_D4"
        
        ; $D5:
        .byte   __, _COMMANDER, __, FN_FN04, _COMMA, __, _I, __, FN_FN0D, _A, _M
        .byte   FN_FN02, __, _C, _A, _P, _T, _A, _IN, __, FN_THEIR_NAME, __
        .byte   FN_FN0D, _O, _F, _HER_MAJESTYS_SPACE_NAVY, __end
        .msg_id "_COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY"
        
        ; $D6:
        .byte   __end
        .msg_skip

        ;-----------------------------------------------------------------------
        
        ; $D7:
        .byte   FN_FN0F, __, _U, _N, _K, _NO, _W, _N, __, _PLANET, __end
        .msg_id "_D7"
        
        ; $D8:
        .byte   FN_CLEAR_SCREEN, FN_FN08, FN_FN17, FN_FN01, __, _IN, _C, _O, _M
        .byte   _ING_, _M, _ES, _S, _A, _GE, __end
        .msg_id "_INCOMING_MESSAGE"
        
        ; the names of NPCs; selected by galaxy number
        ;----------------------------------------------------------------------
        ; $D9:  "curruthers"
        .byte   _C, _U, _R, _R, _U, _TH, _ER, _S, __end
        .msg_id "_CURRUTHERS"
        
        ; $DA:  "fosdyke smythe"
        .byte   _F, _O, _S, _D, _Y, _K, _E, __, _S, _M, _Y, _TH, _E, __end
        .msg_id "_FOSDYKE_SMYTHE"
        
        ; $DB:  "fortesque"
        .byte   _F, _OR, _T, _ES, _QU, _E, __end
        .msg_id "_FORTESQUE"
        
        ; $DC:
        .byte   _WAS_LAST_SEEN_AT_, _RE, _ES, _DI, _CE, __end
        .msg_skip
        
        ; $DD:  NOTE: this gets printed by docked token function $1C,
        ;       which adds the galaxy number to index $DC; it was probably
        ;       intended to chase the prototype ship across multiple galaxies,
        ;       but this idea appears to have been scrapped
        .byte   _I, _S, __, _BE, _L, _I, _E, _V, _ED, _TO, _H, _A, _VE, __
        .byte   _J, _U, _M, _P, _ED, _TO, _THIS, _G, _AL, _A, _X, _Y, __end
        .msg_id "_IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY"
        
        ;-----------------------------------------------------------------------
        ; $DE:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_FN1D, FN_FN0E, FN_FN02
        .byte   _G, _O, _O, _D, __, _D, _A, _Y, __, _COMMANDER, __
        .byte   FN_FN04, _NEW_SENTENCE

        .byte   _I, FN_FN0D, __, _A, _M, __, FN_CAPNEXT, _A, _G, _EN, _T, __
        .byte   FN_CAPNEXT, _B, _LA, _K, _E, __, _O, _F, __, FN_CAPNEXT
        .byte   _N, _A, _V, _AL, __, FN_CAPNEXT
        .byte   _IN, _T, _E, _L, _LE, _G, _EN, _CE, _NEW_SENTENCE
        
        .byte   _A, _S, __, _YOU, __, _K, _NO, _W, _COMMA, __, _THE_
        .byte   FN_CAPNEXT, _N, _A, _V, _Y, __, _H, _A, _VE, __, _BE, _EN, __
        .byte   _K, _E, _E, _P, _ING_, _THE_, FN_CAPNEXT
        .byte   _TH, _AR, _G, _O, _I, _D, _S, __, _O, _F, _F, __, _YOU, _R, __
        .byte   _A, _S, _S, __, _OU, _T, __, _IN, __, _D, _E, _E, _P
        .byte   __, _S, _P, _A, _CE, __, _F, _OR, __, _MA, _N, _Y, __
        .byte   _Y, _E, _AR, _S, __, _NO, _W, _DOT, __, FN_CAPNEXT
        .byte   _W, _E, _L, _L, __, _THE_, _S, _IT, _U, _A, _TI, _ON, __
        .byte   _H, _A, _S, __, _C, _H, _AN, _G, _ED, _NEW_SENTENCE

        .byte   _OU, _R, __, _B, _O, _Y, _S, __, _AR, _E, __, _RE, _A, _D, _Y
        .byte   __, _F, _OR, _A_, _P, _U, _S, _H, __, _R, _I, _G, _H, _T, _TO
        .byte   _THE_, _H, _O, _M, _E, __, _S, _Y, _S, _T, _E, _M, __, _O, _F
        .byte   __, _TH, _O, _SE, __, _M, _U, _R, _D, _ER, _ER, _S
        .byte   _NEW_SENTENCE

        .byte   FN_WAIT_FOR_KEY, FN_CLEAR_SCREEN, FN_FN1D
        .byte   _I, FN_FN0D, __, _H, _A, _VE, __, _O, _B, _T, _A, _IN, _ED_
        .byte   _THE_, _D, _E, _F, _EN, _CE, __, _P, _LA, _N, _S, __, _F, _OR
        .byte   __, _TH, _E, _I, _R, __, FN_CAPNEXT, _H, _I, _VE, __
        .byte   FN_CAPNEXT, _W, _OR, _L, _D, _S, _NEW_SENTENCE

        .byte   _THE_, _BE, _ET, _LE, _S, __, _K, _NO, _W, __
        .byte   _W, _E, _APOS, _VE, __, _G, _O, _T, __, _SO, _M, _E, _TH, _ING_
        .byte   _B, _U, _T, __, _NO, _T, __, _W, _H, _AT, _NEW_SENTENCE

        .byte   _I, _F, __, FN_CAPNEXT, _I, __, _T, _RA, _N, _S, _M, _IT, __
        .byte   _THE_, _P, _LA, _N, _S, _TO, _OU, _R, __, _B, _A, _SE, __, _ON
        .byte   __, FN_CAPNEXT, _BI, _RE, _RA, __, _TH, _E, _Y, _APOS, _L, _L
        .byte   __, _IN, _T, _ER, _CE, _P, _T, __, _THE_
        .byte   _T, _R, _AN, _S, _M, _I, _S, _S, _I, _ON, _DOT, __
        .byte   FN_CAPNEXT, _I, __, _N, _E, _ED, _A_, _SHIP, _TO, _MA, _K, _E
        .byte   __, _THE_, _R, _U, _N, _NEW_SENTENCE

        .byte   _YOU, _APOS, _RE, __, _E, _LE, _C, _T, _ED, _NEW_SENTENCE
        
        .byte   _THE_, _P, _LA, _N, _S, __, _A, _RE, __
        .byte   _U, _N, _I, _P, _U, _L, _SE, __, _C, _O, _D, _ED_
        .byte   _W, _I, _TH, _IN, __, _THIS
        .byte   _T, _R, _AN, _S, _M, _I, _S, _S, _I, _ON
        .byte   _NEW_SENTENCE

        .byte   FN_FN08, _YOU, __, _W, _IL, _L, __, _BE, __, _P, _A, _I, _D
        .byte   _NEW_SENTENCE
        
        .byte   __, __, __, __, FN_CAPNEXT, _G, _O, _O, _D
        .byte   __, _L, _U, _C, _K, __, _COMMANDER, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "_DE"
        
        ; $DF:  
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_FN1D, FN_FN08, FN_FN0E, FN_FN0D
        .byte   FN_CAPNEXT, _W, _E, _L, _L, __, _D, _ON
        .byte   _E, __, _COMMANDER, _NEW_SENTENCE, _YOU, __, _H, _A
        .byte   _VE, __, _SE, _R, _V, _ED_, _U, _S
        .byte   __, _W, _E, _L, _L, _AND_, _W, _E
        .byte   __, _S, _H, _AL, _L, __, _RE, _M
        .byte   _E, _M, _B, _ER, _NEW_SENTENCE
        .byte   _W, _E, __, _D, _I, _D, __, _NO, _T, __, _E
        .byte   _X, _P, _E, _C, _T, __, _THE_, FN_CAPNEXT
        .byte   _TH, _AR, _G, _O, _I, _D, _S, _TO
        .byte   _F, _IN, _D, __, _OU, _T, __, _A
        .byte   _B, _OU, _T, __, _YOU, _NEW_SENTENCE
        .byte   _F, _OR, __, _THE_, _M, _O, _M, _EN, _T, __
        .byte   _P, _LE, _A, _SE, __, _A, _C, _CE
        .byte   _P, _T, __, _THIS, FN_CAPNEXT, _N, _A, _V
        .byte   _Y, __, FN_FN06, .scramble($72), FN_FN05, __, _A, _S
        .byte   __, _P, _A, _Y, _M, _EN, _T, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "_DF"
        
        ;-----------------------------------------------------------------------
        ; $E0:  "are you sure?"
        .byte   _A, _RE, __, _YOU, __, _S, _U, _RE, _QMARK, __end
        .msg_id "_ARE_YOU_SURE"
        
        ; $E1:  "shrew"
        .byte   _S, _H, _RE, _W, __end
        .msg_id "_SHREW"
        
        ; $E2:  "beast"
        .byte   _BE, _A, _ST, __end
        .msg_id "_BEAST"
        
        ; $E3:  "bison"
        .byte   _B, _I, _S, _ON, __end
        .msg_id "_BISON"
        
        ; $E4:  "snake"
        .byte   _S, _N, _A, _K, _E, __end
        .msg_id "_SNAKE"
        
        ; $E5:  "wolf"
        .byte   _W, _O, _L, _F, __end
        .msg_id "_WOLF"
        
        ; $E6:  "leopard"
        .byte   _LE, _O, _P, _AR, _D, __end
        .msg_id "_LEOPARD"
        
        ; $E7:  "cat"
        .byte   _C, _AT, __end
        .msg_id "_CAT"
        
        ; $E8:  "monkey"
        .byte   _M, _ON, _K, _E, _Y, __end
        .msg_id "_MONKEY"
        
        ; $E9:  "goat"
        .byte   _G, _O, _AT, __end
        .msg_id "_GOAT"
        
        ; $EA:  "fish"
        .byte   _F, _I, _S, _H, __end
        .msg_id "_FISH"
        
        ; $EB:  
        .byte   $3d, __, $3e, __end
        .msg_id "_EB"
        
        ; $EC:
        .byte   FN_FN11, __, $2f, __, $2c, __end
        .msg_id "_EC"
        
        ; $ED:
        .byte   _ITS, $3c, __, $2e, __, $2c, __end
        .msg_skip
        
        ; $EE:
        .byte   $2b, __, $2a, __end
        .msg_id "_EE"
        
        ; $EF:
        .byte   $3d, __, $3e, __end
        .msg_id "_EF"
        
        ;-----------------------------------------------------------------------
        ; $F0:  "meat"
        .byte   _M, _E, _AT, __end
        .msg_id "_MEAT"
        
        ; $F1:  "cutlet"
        .byte   _C, _U, _T, _L, _ET, __end
        .msg_id "_CUTLET"
        
        ; $F2:  "steak"
        .byte   _ST, _E, _A, _K, __end
        .msg_id "_STEAK"
        
        ; $F3:  "burgers"
        .byte   _B, _U, _R, _G, _ER, _S, __end
        .msg_id "_BURGERS"
        
        ; $F4:  "soup"
        .byte   _SO, _U, _P, __end
        .msg_id "_SOUP"
        
        ; sport prefixes: (e.g. Brockian Ultra Cricket)
        ;-----------------------------------------------------------------------
        ; $F5:  "ice"
        .byte   _I, _CE, __end
        .msg_id "_ICE"
        
        ; $F6:  "mud"
        .byte   _M, _U, _D, __end
        .msg_id "_MUD"
        
        ; $F7:  "zero-G"
        .byte   _Z, _ER, _O, _HYPHEN, FN_CAPNEXT, _G, __end
        .msg_id "_F7"
        
        ; $F8:  "vacuum"
        .byte   _V, _A, _C, _U, _U, _M, __end
        .msg_id "_VACUUM"
        
        ; $F9:
        .byte   FN_FN11, __, _U, _L, _T, _RA, __end
        .msg_id "_F9"
        
        ; sports:
        ;-----------------------------------------------------------------------
        ; $FA:  "hockey"
        .byte   _H, _O, _C, _K, _E, _Y, __end
        .msg_id "_HOCKEY"
        
        ; $FB:  "cricket"
        .byte   _C, _R, _I, _C, _K, _ET, __end
        .msg_id "_CRICKET"
        
        ; $FC:  "karate"
        .byte   _K, _AR, _AT, _E, __end
        .msg_id "_KARATE"
        
        ; $FD:  "polo"
        .byte   _P, _O, _LO, __end
        .msg_id "_POLO"
        
        ; $FE:  "tennis"
        .byte   _T, _EN, _N, _I, _S, __end
        .msg_id "_TENNIS"
        
        ;-----------------------------------------------------------------------
        ; $FF:  disk / tape error
        .byte   FN_NEWLINE, FN_MEDIA_CURRENT, __, _ER, _R, _OR
        .msg_id "_ERROR"

;-------------------------------------------------------------------------------

_1a27:                                                                  ;$1A27
.export _1a27
        .byte   __end
        .byte   $d3, $96, $24, $1c, $fd, $4f, $35, $76
        .byte   $64, $20, $44, $a4, $dc, $6a, $10, $a2
        .byte   $03, $6b, $1a, $c0, $b8, $05, $65, $c1
        .byte   $29
        
_1a41:                                                                  ;$1A41
.export _1a41
        .byte        $01, $80, $00, $00, $00, $01, $01                  
        .byte   $01, $01, $82, $01, $01, $01, $01, $01
        .byte   $01, $01, $01, $01, $01, $01, $01, $01
        .byte   $02, $01, $82, $90
        
;-------------------------------------------------------------------------------

_1a5c:                                                                  ;$1A5C
.export _1a5c
        ; 0.
        .byte   __end
        
        ; 1.
        .byte   _THE_, _C, _O, _LO, _N, _I, _ST, _S, __, _H, _E, _RE, __
        .byte   _H, _A, _VE, __, _V, _I, _O, _L, _AT, _ED, FN_FN02, __
        .byte   _IN, _T, _ER, _G, _AL, _A, _C, _TI, _C, __, _C, _LO, _N, _ING_
        .byte   _P, _R, _O, _T, _O, _C, _O, _L, FN_FN0D, _AND_
        .byte   _S, _H, _OU, _L, _D, __, _BE, __, _A, _V, _O, _I, _D, _ED
        .byte   __end
        
        ; 2.
        ; TODO: "constrictor" should be capitalised
        .byte   _THE_, _C, _ON, _ST, _R, _I, _C, _T, _OR, __, _WAS_LAST_SEEN_AT_
        .byte   _RE, _ES, _DI, _CE, _COMMA, __, _COMMANDER
        .byte   __end

        ; 3.
        .byte   _A, __, .scramble($72), __, _LO, _O, _K, _ING_, _SHIP
        .byte   __, _LE, _F, _T, __, _H, _E, _RE, _A_, _W, _H, _I, _LE, __
        .byte   _B, _A, _C, _K, _DOT, __, _L, _O, _O, _K, _ED_
        ; TODO: "arexe" should be capitalised
        .byte   _B, _OU, _N, _D, __, _F, _OR, __, _AR, _E, _XE, __end
        
        ; 4.
        .byte   _Y, _E
        .byte   _P, _COMMA, _A_, .scramble($72), _NEW, _SHIP, __, _H
        .byte   _A, _D, _A_, _G, _AL, _A, _C, _TI
        .byte   _C, __, _H, _Y, _P, _ER, _D, _R
        .byte   _I, _VE, __, _F, _IT, _T, _ED_, _H
        .byte   _E, _RE, _DOT, __, _US, _ED_, _IT, __
        .byte   _T, _O, _O, __end
        
        ; 5.
        .byte   _THIS, __, .scramble($72), __
        .byte   _SHIP, __, _D, _E, _H, _Y, _P, _ED_
        .byte   _H, _E, _RE, __, _F, _R, _O, _M
        .byte   __, _NO, _W, _H, _E, _RE, _COMMA, __
        .byte   _S, _U, _N, __, _S, _K, _I, _M
        .byte   _M, _ED, _AND_, _J, _U, _M, _P, _ED
        .byte   _DOT, __, _I, __, _H, _E, _AR, __
        .byte   _IT, __, _W, _EN, _T, _TO, _IN, _BI
        .byte   _BE, __end
        
        ; 6.
        .byte   $24, __, _SHIP, __, _W, _EN
        .byte   _T, __, _F, _OR, __, _M, _E, __
        .byte   _AT, __, _A, _US, _AR, _DOT, __, _M
        .byte   _Y, __, _LA, _S, _ER, _S, __, _D
        .byte   _I, _D, _N, _APOS, _T, __, _E, _V
        .byte   _EN, __, _S, _C, _RA, _T, _C, _H
        .byte   __, _THE_, $24, __end
        
        ; 7.
        .byte   _O, _H, __, _D, _E, _AR, __, _M, _E, __, _Y, _ES, _DOT
        .byte   _A_, _F, _R, _I, _G, _H, _T, _F, _U, _L, __
        .byte   _R, _O, _G, _U, _E, __, _W, _I, _TH, __, _W, _H, _AT, __
        .byte   _I, __, _BE, _L, _I, _E, _VE, __, _YOU, __
        .byte   _P, _E, _O, _P, _LE, __, _C, _AL, _L, _A_, _LE, _A, _D, __
        .byte   _P, _O, _ST, _ER, _I, _OR, __, _S, _H, _O, _T, __, _U, _P, __
        .byte   _LO, _T, _S, __, _O, _F, __, _TH, _O, _SE, __
        .byte   _BE, _A, _ST, _L, _Y, __, _P, _I, _RA, _T, _ES, _AND_
        ; TODO: "usleri" should be capitalised
        .byte   _W, _EN, _T, _TO, _US, _LE, _R, _I
        .byte   __end
        
        ; 8.
        .byte   _YOU, __, _C, _AN, __, _T, _A, _C, _K, _LE, __, _THE_
        .byte   $3f, __, $24, __
        .byte   _I, _F, __, _YOU, __, _L, _I, _K, _E, _DOT, __
        ; TODO: "orarra" should be capitalised
        .byte   _H, _E, _APOS, _S, __, _AT, __, _OR, _AR, _RA, __end
        
        ; 9.    still waiting on OP...
        .byte   FN_FN01
        .byte   _C, _O, _M, _ING_, _SO, _ON, _COLON, __
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
        .byte   _B, _O, _Y, __, _A, _RE, __, _YOU, __, _IN, __, _THE_
        .byte   _W, _R, _ON, _G, __, _G, _AL, _A, _X, _Y, _XMARK, __end
        
        ; 24.
        .byte   _TH, _ER, _E, _APOS, _S, _A_, _RE, _AL, __, .scramble($73)
        .byte   __, _P, _I, _RA, _T, _E, __, _OU, _T, __, _TH, _ER, _E, __end
        
        ; 25.
        .byte   _THE_, _INHABITANT, _S, __, _O, _F
        .byte   __, $3a, __, _A, _RE, __, _SO, __
        .byte   _A, _MA, _Z, _IN, _G, _L, _Y, __
        .byte   _P, _R, _I, _M, _I, _TI, _VE, __
        .byte   _TH, _AT, __, _TH, _E, _Y, __, _ST
        .byte   _IL, _L, __, _TH, _IN, _K, __, FN_CAPNEXT
        .byte   $7d, $7d, $7d, $7d, $7d, __, $7d, $7d
        .byte   $7d, $7d, $7d, $7d, _IS, __, $64, _D
        .byte   __end
        
        ; 26.   unused
        .byte   FN_FN01, _W, _E, _L, _C, _O, _M, _E, __, _T, _O, __
        .byte   _T, _H, _E, __, _S, _E, _V, _E, _N, _T, _E, _E, _N, _T, _H, __
        .byte   _G, _A, _L, _A, _X, _Y, _XMARK, __end
        
        ; 27.
        .byte   $3a, FN_THEIR_NAME, FN_CAPNEXT
        .byte   FN_FN16, FN_FN0F, FN_FN0F, $31, $2b, $31, $3a, FN_FN16
        .byte   FN_CAPNEXT, FN_FN14, $23, $30, $3a, FN_FN04, FN_PRINT_FLIGHT_TOKEN
        .byte   FN_FN16,FN_FN0F, FN_FN0F, $31, $35, $2b, $31, $3a, FN_FN1D
        .byte   FN_FN1A, FN_FN07, FN_THEIR_NAME, FN_THEIR_NAME, $35, $33, _Z, $21
        .byte   _HYPHEN, $3d, $2e, FN_THEIR_NAME, FN_THEIR_NAME, $35, $32, $20
        .byte   FN_THEIR_NAME, FN_CAPNEXT, FN_FN16, FN_FN0F, FN_FN0F, $31, $3a, FN_FN04

;$1D00

;===============================================================================

.segment        "TEXT_PDESC"

; I believe these are a series of expansion-tokens
; that act as templates for planet descriptions

; docked tokens $5B...$80 (unscrambled) are re-routed through this table:
; $5B is subtracted so that a docked token of $5B will read the first entry
; in this table, and the value is re-used as a new docked token to print.
; ergo, the tokens this table refers to are the *UNSCRAMBLED* indices,
; unlike the codes used in the text-database. this is why this table can't
; use the existing token names
;
_3eac:                                                                  ;$3EAC
;-------------------------------------------------------------------------------
.export _3eac
        ; token $5B = tokens $10...$14:
        ;       "fabled", "notable", "well-known", "famous", "noted"
        .byte   ID_FABLED
        ; token $5C = tokens $15...$19:
        ;       "very", "mildly", "most", "reasonably", "" 
        .byte   ID_VERY
        ; token $5D = tokens $1A...$1E:
        ;       "ancient", "<$72>", "great", "vast", "pink"
        .byte   ID_1A
        ; token $5E = tokens $1F...$23:
        ;       "<?> plantations", "mountains", "<$75>", "<?> forests", "oceans"
        .byte   ID_1F
        ; token $5F = $9B
        .byte   ID_9B
        ; token $60 = $A0
        .byte   ID_A0
        ; token $61 = tokens $2E...$32:
        ;       "walking tree", "crab", "bat", "lobst"(er?), "<fn12>"(?)
        .byte   ID_WALKING_TREE
        ; token $62 = $A5: "ancient", letters
        .byte   ID_ANCIENT
        ; token $63 = $24: "shyness"
        .byte   ID_SHYNESS
        ; token $64 = $29: "food blenders"
        .byte   ID_FOOD_BLENDERS
        ; token $65 = $3D
        .byte   ID_3D
        ; token $66 = tokens $33...$37:
        ;       "beset", "plagued", "ravaged", "cursed", "scourged"
        .byte   ID_BESET
        ; token $67 = $38
        .byte   ID_38
        ; token $68 = tokens $AA...$AE:
        ;       "killer", "deadly", "evil", "lethal", "vicious"
        .byte   ID_KILLER
        ; token $69 = tokens $42...$46:
        ;       "juice", "brandy", "water", "brew", "gargle blasters"
        .byte   ID_JUICE
        ; token $6A = $47
        .byte   ID_47
        ; token $6B = tokens $4C...$50:
        ;       "fabulous", "exotic", "hoopy", "unusual", "exciting"
        .byte   ID_FABULOUS
        ; token $6C = $51: "cuisine"
        .byte   ID_CUISINE
        ; token $6D = $56: print flight-token?
        .byte   ID_56
        ; token $6E = $8C...
        .byte   ID_8C
        ; token $6F = $60? this table!?
        .byte   $60
        ; token $70 = $65
        .byte   $65
        ; token $71 = $8F: "<x> but <y>"?
        .byte   ID_8F
        ; token $72 = $82: "funny"
        .byte   ID_FUNNY
        ; token $73 = $5B
        .byte   $5b
        ; token $74 = $6A
        .byte   $6a
        ; token $75 = tokens $B4...$B8:
        ;       "parking meters", "dust clouds", "ice bergs",
        ;       "rock formations", "volcanoes"
        .byte   ID_PARKING_METERS
        ; token $76 = $B9: "plant"
        .byte   ID_PLANT
        ; token $77 = $BE...
        .byte   ID_BE_
        ; token $78 = $E1
        .byte   $e1
        ; token $79 = $E6
        .byte   $e6
        ; token $7A = $EB
        .byte   $eb
        ; token $7B = tokens $F0..$F4:
        ;       "meat", "cutlet", "steak", "burgers", "soup"
        .byte   ID_MEAT
        ; token $7C = $F5
        .byte   $f5
        ; token $7D = $FA
        .byte   $fa
        ; token $7E = $73
        .byte   $73
        ; token $7F = $78
        .byte   $78
        ; token $80 = $7D
        .byte   $7d

;$3ED2