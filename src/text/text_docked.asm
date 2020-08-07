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

_tkn_index       .set 0

; increment the token index,
; without defining a token ID
;
.macro  .tkn
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; move to the next token index
        _tkn_index .set _tkn_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; define a token number & ID:
;
.macro .tkn_alias       tkn_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; define a constant for the un-scrambled token index
        ;;.ident( .concat("TKN", tkn_id)) = _tkn_index

        ; scramble the token index to produce
        ; the token ID used within docked strings
        .local  _value
        _value  .set .scramble( _tkn_index )
        ; define the token locally, using the name given.
        ; note that this doesn't include a prefix, to make
        ; the text-database below easier on the eyes
        .ident( tkn_id ) = _value
        ; define an export for the index-number of the token;
        ; this is how the outside world will specify the token ID
.export .ident( .concat( "TKN_DOCKED_", tkn_id )) = _tkn_index

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_id         tkn_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        .tkn_alias      tkn_id
        ; move to the next index number
        .tkn

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

;       symbol                  ; token scrmbld note
.tkn_id "__end"                 ; $00   =$57    null terminator


.segment "TEXT_TOKENS"
;===============================================================================
; 32 of the docked tokens are functions called when the token is encountered
; in a string. this segment defines a look-up table of which function to call
; for each token (once descrambled)
;
; in order to build the table, we need a macro because
; each entry in the table must do three things:
;
; 1.    import the symbol for the function -- the functions are not
;       in this file but in "code_docked_fns.asm" instead
;
; 2.    define a local symbol for the token ID as the strings containing the
;       token are defined within this file. these will be in the form "FN_*"
;
; 3.    define a global version of the symbol for when it appears outside
;       of the text database. these will be in the form "TXTFN_*"
;
.macro  .tkn_fn         fn_id, fn_import 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        ; generate the symbols for the token:
        ; note that token function are prefixed with "FN_"
        .tkn_id .concat( "FN_", fn_id )

        ; import the function from "code_docked_fns.asm",
        ; and write its address to the table
.import fn_import
        .addr   fn_import

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


tkn_docked_functions:                                                   ;$250C
;===============================================================================
; here begins the table of unscrambled token -> function call mappings.
; the columns given are:
; 
; token         the index in the table is the unscrambled token ID
; function      the function to import & call for the token
; symbol        name slug to define the local and global symbol; the local
;               symbol will be prefixed with "FN_" and the global symbol
;               will be prefixed with "TKN_DOCKED_FN_" and exported
; scrmbld       the index is scrambled (XOR $57) and this becomes
;               the token ID that is used within the text database
;
.export tkn_docked_functions
;-------------------------------------------------------------------------------
; token symbol:                 function:                               scrmbld:
;-------------------------------------------------------------------------------
; $01   ?
.tkn_fn "01",                   tkn_docked_fn01                         ;=$56
; $02   ?
.tkn_fn "02",                   tkn_docked_fn02                         ;=$55
; $03   print flight-token $03
.tkn_fn "PRINT_FLIGHT_TOKEN",   print_flight_token                      ;=$54
; $04   print flight-token $04
.tkn_fn "04",                   print_flight_token                      ;=$53
; $05   switch from printing flight tokens back to docked tokens
.tkn_fn "FLIGHT_OFF",           use_docked_tokens                       ;=$52
; $06   begin printing docked tokens as flight tokens instead!
.tkn_fn "FLIGHT_ON",            use_flight_tokens                       ;=$51
; $07   print character $07 -- ?
.tkn_fn "07",                   print_char                              ;=$50
; $08   ?
.tkn_fn "08",                   tkn_docked_fn08                         ;=$5F
; $09   clear the screen, switch to empty menu page
.tkn_fn "CLEAR_SCREEN",         tkn_docked_clearScreen                  ;=$5E
; $0A   print character $0A -- ?
.tkn_fn "0A",                   print_char                              ;=$5D
; $0B   draw a divider across the screen; used for page titles
.tkn_fn "DIVIDER",              draw_title_divider                      ;=$5C
; $0C   print a newline character -- $0C
.tkn_fn "NEWLINE",              print_char                              ;=$5B
; $0D   ?
.tkn_fn "0D",                   tkn_docked_fn0D                         ;=$5A
; $0E   enable the text-buffer that will hold text instead of printing
;       immediately. this can be used to full-justify text or inspect
;       the contents of the buffer
.tkn_fn "BUFFER_ON",            tkn_docked_bufferOn                     ;=$59
; $0F   disables the text-buffer
.tkn_fn "BUFFER_OFF",           tkn_docked_bufferOff                    ;=$58
; $10   print "a". truly, truly, a bizzare use of a function token
.tkn_fn "A",                    print_a                                 ;=$47
; $11   ?
.tkn_fn "11",                   tkn_docked_fn11                         ;=$46
; $12   print a randomly chosen name
.tkn_fn "RANDOM_NAME",          tkn_docked_randomName                   ;=$45
; $13   ?
.tkn_fn "CAPNEXT",              tkn_docked_capitalizeNext               ;=$44
; $14   print character $14 -- ?
.tkn_fn "14",                   print_char                              ;=$43
; $15   ?
.tkn_fn "15",                   tkn_docked_fn15                         ;=$42      
; $16   ?
.tkn_fn "16",                   tkn_docked_fn16                         ;=$41
; $17   ?
.tkn_fn "17",                   tkn_docked_fn17                         ;=$40
; $18   wait for any key to be pressed
.tkn_fn "WAIT_FOR_KEY",         tkn_docked_waitForAnyKey                ;=$4F
; $19   flash "incoming message" on screen
.tkn_fn "INCOMING_MESSAGE",     tkn_docked_incoming_message             ;=$4E
; $1A   ?
.tkn_fn "1A",                   tkn_docked_fn1A                         ;=$4D
; $1B   prints an NPC's name (based on the current galaxy number)
.tkn_fn "THEIR_NAME",           tkn_docked_theirName                    ;=$4C
; $1C   for the prototype mission, changes the end of the sentence
;       based upon the galaxy number, although unused in practice
.tkn_fn "PROTO_GALAXY",         tkn_docked_protoGalaxy                  ;=$4B
; $1D   ?
.tkn_fn "1D",                   tkn_docked_fn1D                         ;=$4A
; $1E   print currently selected load/save media -- disk / tape
.tkn_fn "MEDIA_CURRENT",        tkn_docked_fn_mediaCurrent              ;=$49
; $1F   print the non-selected load/save media -- disk / tape 
.tkn_fn "MEDIA_OTHER",          tkn_docked_fn_mediaOther                ;=$48
; $20   space is provided as a function token so that switching to printing
;       flight-tokens (`FN_FLIGHT_ON`) allows spaces to be included easily
;       (all docked function tokens are excluded from flight-token printing)
.tkn_fn "SPACE",                print_char                              ;=$77

_tkn_index      .set $20

; tokenise regular ASCII characters:
;-------------------------------------------------------------------------------
;       symbol                  ; token scrmbld note
.tkn_id "__"                    ; $20   =$77
.tkn_id "XMARK"                 ; $21   =$76    !
.tkn_id "SPMARK"                ; $22   =$75    "
.tkn_id "HASH"                  ; $23   =$74    #
.tkn_id "DOLLAR"                ; $24   =$73    $
.tkn_id "PCENT"                 ; $25   =$72    %
.tkn_id "AMP"                   ; $26   =$71    &
.tkn_id "APOS"                  ; $27   =$70    '
.tkn_id "LPAREN"                ; $28   =$7F    (
.tkn_id "RPAREN"                ; $29   =$7E    )
.tkn_id "STAR"                  ; $2A   =$7D    *
.tkn_id "PLUS"                  ; $2B   =$7C    +
.tkn_id "COMMA"                 ; $2C   =$7B    ,
.tkn_id "HYPHEN"                ; $2D   =$7A    -
.tkn_id "DOT"                   ; $2E   =$79    .
.tkn_id "FSLASH"                ; $2F   =$78    /
.tkn_id "_0"                    ; $30   =$67    0
.tkn_id "_1"                    ; $31   =$66    1
.tkn_id "_2"                    ; $32   =$65    2
.tkn_id "_3"                    ; $33   =$64    3
.tkn_id "_4"                    ; $34   =$63    4
.tkn_id "_5"                    ; $35   =$62    5
.tkn_id "_6"                    ; $36   =$61    6
.tkn_id "_7"                    ; $37   =$60    7
.tkn_id "_8"                    ; $38   =$6F    8
.tkn_id "_9"                    ; $39   =$6E    9
.tkn_id "COLON"                 ; $3A   =$6D    :
.tkn_id "SEMI"                  ; $3B   =$6C    ;
.tkn_id "LT"                    ; $3C   =$6B    <
.tkn_id "EQUALS"                ; $3D   =$6A    =
.tkn_id "GT"                    ; $3E   =$69    >
.tkn_id "QMARK"                 ; $3F   =$68    ?
.tkn_id "COMAT"                 ; $40   =$17    @
.tkn_id "_A"                    ; $41   =$16    A
.tkn_id "_B"                    ; $42   =$15    B
.tkn_id "_C"                    ; $43   =$14    C
.tkn_id "_D"                    ; $44   =$13    D
.tkn_id "_E"                    ; $45   =$12    E
.tkn_id "_F"                    ; $46   =$11    F
.tkn_id "_G"                    ; $47   =$10    G
.tkn_id "_H"                    ; $48   =$1F    H
.tkn_id "_I"                    ; $49   =$1E    I
.tkn_id "_J"                    ; $4A   =$1D    J
.tkn_id "_K"                    ; $4B   =$1C    K
.tkn_id "_L"                    ; $4C   =$1B    L
.tkn_id "_M"                    ; $4D   =$1A    M
.tkn_id "_N"                    ; $4E   =$19    N
.tkn_id "_O"                    ; $4F   =$18    O
.tkn_id "_P"                    ; $50   =$07    P
.tkn_id "_Q"                    ; $51   =$06    Q
.tkn_id "_R"                    ; $52   =$05    R
.tkn_id "_S"                    ; $53   =$04    S
.tkn_id "_T"                    ; $54   =$03    T
.tkn_id "_U"                    ; $55   =$02    U
.tkn_id "_V"                    ; $56   =$01    V
.tkn_id "_W"                    ; $57   =$00    W
.tkn_id "_X"                    ; $58   =$0F    X
.tkn_id "_Y"                    ; $59   =$0E    Y
.tkn_id "_Z"                    ; $5A   =$0D    Z

; NOTE: ASCII codes $5B...$5F are not included!
;;.tkn_id "_LSQB"                 ; $5B   =$0C    [
;;.tkn_id "_BSLASH"               ; $5C   =$0B    \
;;.tkn_id "_RSQB"                 ; $5D   =$0A    ]
;;.tkn_id "_ACUTE"                ; $5E   =$09    ^
;;.tkn_id "_USCORE"               ; $5F   =$08    _

.segment        "TEXT_PDESC"
;===============================================================================
; docked tokens $5B...$80 (unscrambled) are re-routed through this table:
; $5B is subtracted so that a docked token of $5B will read the first entry
; in this table, and the value is re-used as a new *message* index to print
;
_3eac:                                                                  ;$3EAC
;-------------------------------------------------------------------------------
.export _3eac

; $5B = tokens $10...$14:
.tkn_id "FABLED_NOTABLE_WELLKNOWN_FAMOUS_NOTED"                         ;=$0C
        ; "fabled", "notable", "well-known", "famous", "noted"
        .byte   MSG_FABLED

; $5C = tokens $15...$19:
.tkn_id "VERY_MILDLY_MOST_REASONABLY"                                   ;=$0B
        ; "very", "mildly", "most", "reasonably", ""
        .byte   MSG_VERY

; $5D = tokens $1A...$1E:
.tkn_id "ANCIENT_FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR_GREAT_VAST_PINK"  ;=$0A
        ; 1. "ancient"
        ; 2. <"funny", "weird", "unusual", "strange", "peculiar">
        ; 3. "great"
        ; 4. "vast"
        ; 5. "pink"
        .byte   MSG_1A

; $5E = tokens $1F...$23:
.tkn_id "_5E"                                                           ;=$09
        ; "<?> plantations", "mountains", <"parking meters", "dust clouds",
        ; "ice bergs", "rock formations", "volcanoes">, "<?> forests", "oceans"
        .byte   MSG_1F

; $5F = tokens $9B...$9F:
.tkn_id "_5F"                                                           ;=$08
        .byte   MSG_9B

; $60 = $A0
.tkn_id "_60"                                                           ;=$37
        .byte   MSG_A0

; $61 = tokens $2E...$32:
.tkn_id "_61"                                                           ;=$36
        ; "walking tree", "crab", "bat", "lobst"(er?), "<fn12>"(?)
        .byte   MSG_WALKING_TREE

; $62 = tokens $A5...$A9:
        ; 1. "ancient"
        ; 2. "exceptional"
        ; 3. "eccentric"
        ; 4. "ingrained"
        ; 5. <"funny", "weird", "unusual", "strange", "peculiar">
.tkn_id "ANCIENT_EXCEPTIONAL_ECCENTRIC_INGRAINED_ETC"                   ;=$35
        .byte   MSG_ANCIENT

; $63 = $24: "shyness"
.tkn_id "_63"                                                           ;=$34
        .byte   MSG_SHYNESS

; $64 = tokens $29...$2D:
.tkn_id "_64"                                                           ;=$33
        ; 1. "food blenders"
        ; 2. "tourists"
        ; 3. "poetry"
        ; 4. "discos"
        ; 5.1. "cuisine"
        ;   2. "night life"
        ;   3. "casinos"
        ;   4. "sit coms"
        ;   5. <?> 
        .byte   MSG_FOOD_BLENDERS

; $65 = $3D
.tkn_id "_65"                                                           ;=$32
        .byte   MSG_3D

; $66 = tokens $33...$37:
.tkn_id "BESET_PLAGUED_RAVAGED_CURSED_SCOURGED"                         ;=$31
        ; "beset", "plagued", "ravaged", "cursed", "scourged"
        .byte   MSG_BESET

; $67 = $38
.tkn_id "_67"                                                           ;=$30
        .byte   MSG_38

; $68 = tokens $AA...$AE:
.tkn_id "KILLER_DEADLY_EVIL_LETHAL_VICIOUS"                             ;=$3F
        ; "killer", "deadly", "evil", "lethal", "vicious"
        .byte   MSG_KILLER

; $69 = tokens $42...$46:
.tkn_id "RANDOM_DRINK"                                                  ;=$3E
        ; "juice", "brandy", "water", "brew", "gargle blasters"
        .byte   MSG_JUICE

; $6A = $47
.tkn_id "_6A"                                                           ;=$3D
        .byte   MSG_47

; $6B = tokens $4C...$50:
.tkn_id "FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING"                        ;=$3C
        ; "fabulous", "exotic", "hoopy", "unusual", "exciting"
        .byte   MSG_FABULOUS

; $6C = $51: "cuisine"
        ; TODO: this has a fifth entry of some complexity
.tkn_id "CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC"                         ;=$3B
        .byte   MSG_CUISINE

; $6D = $56: print flight-token?
.tkn_id "_6D"                                                           ;=$3A
        .byte   MSG_56

; $6E = $8C...
.tkn_id "_6E"                                                           ;=$39
        .byte   MSG_8C

; $6F = tokens $60...$64:
.tkn_id "UNREMARKABLE_BORING_DULL_TEDIOUS_REVOLTING"                    ;=$38
        ; "unremarkable", "boring", "dull", "tedious", "revolting"
        .byte   MSG_UNREMARKABLE

; $70 = tokens $65...$69:
.tkn_id "PLANET_WORLD_PLACE_LITTLEPLANET_DUMP"                          ;=$27
        ; "planet", "world", "place", "little planet", "dump"
        .byte   MSG_PLANET_SYNONYMS

; $71 = $8F: "<x> but <y>"?
.tkn_id "_71"                                                           ;=$26
        .byte   MSG_8F

; $72 = tokens $82...$86:
.tkn_id "FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR"                          ;=$25
        ; "funny", "weird", "unusual", "strange", "peculiar"
        .byte   MSG_FUNNY

; $73 = tokens $5B...$5F:
.tkn_id "RANDOM_INSULT"                                                 ;=$24
        .byte   MSG_SON_OF_A_BITCH

; $74 = $6A
.tkn_id "_74"                                                           ;=$23
        .byte   MSG_PROTO_HINTS

; $75 = tokens $B4...$B8:
.tkn_id "PARKINGMETERS_DUSTCLOUDS_ICEBERGS_ROCKFORMATIONS_VOLCANOES"    ;=$22
        ; "parking meters", "dust clouds", "ice bergs",
        ; "rock formations", "volcanoes"
        .byte   MSG_PARKING_METERS

; $76 = $B9: "plant"
.tkn_id "_76"                                                           ;=$21
        .byte   MSG_PLANT

; $77 = $BE...
.tkn_id "_77"                                                           ;=$20
        .byte   MSG_BE

; $78 = $E1
.tkn_id "_78"                                                           ;=$2F
        .byte   MSG_SHREW

; $79 = $E6
.tkn_id "_79"                                                           ;=$2E
        .byte   MSG_LEOPARD

; $7A = $EB
.tkn_id "_7A"                                                           ;=$2D
        .byte   MSG_EB

; $7B = tokens $F0...$F4:
.tkn_id "RANDOM_FOOD"                                                   ;=$2C
        ; "meat", "cutlet", "steak", "burgers", "soup"
        .byte  MSG_MEAT

; $7C = tokens $F5...$F9:
.tkn_id "RANDOM_ENVIRONMENT"                                            ;=$2B
        ; "ice", "mud", "zero-G", "vacuum", "<?> ultra"
        .byte   MSG_ICE

; $7D = tokens $FA...$FE:
.tkn_id "RANDOM_SPORT"                                                  ;=$2A
        ; "hockey", "cricket", "karate", "polo", "tennis"
        .byte   MSG_HOCKEY

; $7E = tokens $73...$88:
.tkn_id "RANDOM_PEST"                                                   ;=$29
        ; "wasp", "moth", "grub", "ant", <random-name>
        .byte   MSG_WASP

; $7F = tokens $78...$7C:
.tkn_id "POET_ARTSGRADUATE_YAK_SNAIL_SLUG"                              ;=$28
        ; "poet", "arts graduate", "yak", "snail", "slug"
        .byte   MSG_POET

; $80 = tokens $7D...$81:
.tkn_id "RANDOM_CLIMATE"                                                ;=$D7
        ; "tropical", "dense", "rain", "impenetrable", "exuberant" 
        .byte   MSG_TROPICAL                                            ;$3ED2


; import the token numbers for the common charcter pairs used by docked
; strings ("text_pairs.asm"). these come unscrambled; we scramble them
; here, for the on-disk format
;
.import tkn_docked_crlf:direct
CRLF    = .scramble( tkn_docked_crlf )  ;=$80
.import tkn_docked_ab:direct
AB      = .scramble( tkn_docked_ab )    ;=$8F
.import tkn_docked_ou:direct
OU      = .scramble( tkn_docked_ou )    ;=$8E
.import tkn_docked_se:direct
SE      = .scramble( tkn_docked_se )    ;=$8D
.import tkn_docked_it:direct
IT      = .scramble( tkn_docked_it )    ;=$8C
.import tkn_docked_il:direct
IL      = .scramble( tkn_docked_il )    ;=$8B
.import tkn_docked_et:direct
ET      = .scramble( tkn_docked_et )    ;=$8A
.import tkn_docked_st:direct
ST      = .scramble( tkn_docked_st )    ;=$89
.import tkn_docked_on:direct
ON      = .scramble( tkn_docked_on )    ;=$88
.import tkn_docked_lo:direct
LO      = .scramble( tkn_docked_lo )    ;=$B7
.import tkn_docked_nu:direct
NU      = .scramble( tkn_docked_nu )    ;=$B6
.import tkn_docked_th:direct
TH      = .scramble( tkn_docked_th )    ;=$B5
.import tkn_docked_no:direct
NO      = .scramble( tkn_docked_no )    ;=$B4
.import tkn_docked_al:direct
AL      = .scramble( tkn_docked_al )    ;=$B3
.import tkn_docked_le:direct
LE      = .scramble( tkn_docked_le )    ;=$B2
.import tkn_docked_xe:direct
XE      = .scramble( tkn_docked_xe )    ;=$B1
.import tkn_docked_ge:direct
GE      = .scramble( tkn_docked_ge )    ;=$B0
.import tkn_docked_za:direct
ZA      = .scramble( tkn_docked_za )    ;=$BF -- unused here
.import tkn_docked_ce:direct
CE      = .scramble( tkn_docked_ce )    ;=$BE
.import tkn_docked_bi:direct
BI      = .scramble( tkn_docked_bi )    ;=$BD
.import tkn_docked_so:direct
SO      = .scramble( tkn_docked_so )    ;=$BC
.import tkn_docked_us:direct
US      = .scramble( tkn_docked_us )    ;=$BB
.import tkn_docked_es:direct
ES      = .scramble( tkn_docked_es )    ;=$BA
.import tkn_docked_ar:direct
AR      = .scramble( tkn_docked_ar )    ;=$B9
.import tkn_docked_ma:direct
MA      = .scramble( tkn_docked_ma )    ;=$B8
.import tkn_docked_in:direct
IN      = .scramble( tkn_docked_in )    ;=$A7
.import tkn_docked_di:direct
DI      = .scramble( tkn_docked_di )    ;=$A6
.import tkn_docked_re:direct
RE      = .scramble( tkn_docked_re )    ;=$A5
.import tkn_docked_a_:direct
A_      = .scramble( tkn_docked_a_ )    ;=$A4
.import tkn_docked_er:direct
ER      = .scramble( tkn_docked_er )    ;=$A3
.import tkn_docked_at:direct
AT      = .scramble( tkn_docked_at )    ;=$A2
.import tkn_docked_en:direct
EN      = .scramble( tkn_docked_en )    ;=$A1
.import tkn_docked_be:direct
BE      = .scramble( tkn_docked_be )    ;=$A0
.import tkn_docked_ra:direct
RA      = .scramble( tkn_docked_ra )    ;=$AF
.import tkn_docked_la:direct
LA      = .scramble( tkn_docked_la )    ;=$AE
.import tkn_docked_ve:direct
VE      = .scramble( tkn_docked_ve )    ;=$AD
.import tkn_docked_ti:direct
TI      = .scramble( tkn_docked_ti )    ;=$AC
.import tkn_docked_ed:direct
ED      = .scramble( tkn_docked_ed )    ;=$AB
.import tkn_docked_or:direct
OR      = .scramble( tkn_docked_or )    ;=$AA
.import tkn_docked_qu:direct
QU      = .scramble( tkn_docked_qu )    ;=$A9
.import tkn_docked_an:direct
AN      = .scramble( tkn_docked_an )    ;=$A8


.segment        "TEXT_DOCKED"
;===============================================================================
_msg_index     .set 0

.macro  .msg_alias      msg_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; define a constant for the un-scrambled index value,
        ; (should it be needed)
        .ident( .concat( "MSG_", msg_id )) = _msg_index

        .local  _value
        _value  .set .scramble( _msg_index )

        ; define an export for the index-number of the message;
        ; this is how the outside world will specify the message to print
.export .ident( .concat( "MSG_DOCKED_", msg_id )) = _msg_index

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .msg_id         msg_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        .msg_alias      msg_id

        ; move to the next index number:
        ; doing this afterwards ensures that there is an index 0
        _msg_index .set _msg_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; increment the msg ID, but don't define any symbol
.define .msg            _msg_index .set _msg_index + 1


; begin the "docked" text database:
;
txt_docked:                                                             ;$0E00
;===============================================================================
.export txt_docked
        ;-----------------------------------------------------------------------
        ; msg-id
        ;-----------------------------------------------------------------------
        ; $00:  index 0 is always invalid
        .byte   __end
        .msg

        ; $01:  disk / tape access menu
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_01, FN_08, __
        ;       "disk" / "tape" "access menu"
        .byte   FN_MEDIA_CURRENT, __, _A, _C, CE, _S, _S, __, _M, _E, NU
        .byte   CRLF, FN_0A, FN_02
        .byte   _1, DOT, __, _LOAD_NEW_COMMANDER, CRLF
        .byte   _2, DOT, __, _S, _A, VE, __, _COMMANDER, __, FN_04, CRLF
        .byte   _3, DOT, __, _C, _H, AN, GE, _TO_, FN_MEDIA_OTHER, CRLF
        .byte   _4, DOT, __, _D, _E, _F, _A, _U, _L, _T, __
        .byte             FN_01, _J, _A, _M, _E, _S, _O, _N, FN_02, CRLF
        .byte   _5, DOT, __, _E, _X, IT, CRLF
        .byte   __end
        .msg_id "DATA_MENU"
        
        ; the list of supported save media-types:
        ;-----------------------------------------------------------------------
        .msg_alias "MEDIAS"
        
        ; $02:
        .byte   DI, _S, _K, __end
        .msg

        ; $03:
        ; TODO: remove tape code / references
        .byte   _T, _A, _P, _E, __end
        .msg_id "TAPE"
        
        ;-----------------------------------------------------------------------
        ; $04:
        ; TODO: build option to remove competition number
        .byte   _C, _O, _M, _P, _E, TI, TI, ON, __
        .byte   NU, _M, _B, ER, COLON, __end
        .msg_id "COMPETITION_NUMBER"
        
        ; $05:
        .byte   _B0, _6D, _IS_, _6E, _B1, __end
        .msg
        
        ; $06:
        .byte   __, __, _LOAD_NEW_COMMANDER, __, FN_01
        .byte   LPAREN, _Y, FSLASH, _N, RPAREN, QMARK
        .byte   FN_02, FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "06"

        ; $07:
        .byte   _P, RE, _S, _S, __, _S, _P, _A, CE, __, OR, __, _F, _I, RE
        .byte   COMMA, _COMMANDER, DOT, FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "07"
        
        ; $08:
        .byte   _COMMANDER, APOS, _S, _C8, __end
        .msg
        
        ; $09:
        .byte   FN_NEWLINE, FN_01, IL, LE, _G, AL, __
        .byte   _E, _L, _I, _T, _E, __, _I, _I, __, _F, _I, LE, __end
        .msg_id "ILLEGAL_FILE"
        
        ; $0A:
        .byte   FN_17, FN_BUFFER_ON, FN_02, _G, RE, ET, IN, _G, _S
        .byte   _COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY
        .byte   _AND_, FN_CAPNEXT, _I, __, BE, _G, _A_, _M, _O, _M, EN, _T
        .byte   __, _O, _F, __, _YOU, _R, __, _V, AL, _U, AB, LE
        .byte   __, TI, _M, _E, _NEW_SENTENCE

        .byte   _W, _E, __, _W, OU, _L, _D, __, _L, _I, _K, _E, __, _YOU, _TO_
        .byte   _D, _O, _A_, _L, IT, _T, LE, __, _J, _O, _B, __, _F, OR, __
        .byte   US, _NEW_SENTENCE

        .byte   _THE_, _SHIP, __, _YOU, __, SE, _E, __, _H, _E, RE, _IS_
        .byte   _A, _NEW_, _M, _O, _D, _E, _L, COMMA, __, _THE_, FN_CAPNEXT
        .byte   _C, ON, ST, _R, _I, _C, _T, OR, COMMA, __
        .byte   _E, QU, _I, _P, _ED_, _W, _I, TH, _A_, _T, _O, _P, __
        .byte   SE, _C, _R, ET, _NEW_, _S, _H, _I, _E, _L, _D, __
        .byte   _G, EN, ER, AT, OR, _NEW_SENTENCE

        .byte   _U, _N, _F, OR, _T, _U, _N, AT, _E, _L, _Y, __, IT
        .byte   APOS, _S, __, BE, EN, __, ST, _O, _L, EN
        .byte   _NEW_SENTENCE

        .byte   FN_16, IT, __, _W, EN, _T, __, _M, _I, _S, _S, _ING_
        .byte   _F, _R, _O, _M, __, OU, _R, __, _SHIP, __, _Y, AR, _D, __
        .byte   ON, __, FN_CAPNEXT, XE, ER, __, _F, _I, VE, __
        .byte   _M, ON, TH, _S, __, _A, _G, _O, _AND_
        ;       "is believed to have jumped to this galaxy"
        ;       (see msg index $DD)
        .byte   FN_PROTO_GALAXY, _NEW_SENTENCE

        .byte   _YOU, _R, __, _M, _I, _S, _S, _I, ON, COMMA, __
        .byte   _S, _H, OU, _L, _D, __, _YOU, __, _D, _E, _C, _I, _D, _E, _TO_
        .byte   _A, _C, CE, _P, _T, __, IT, COMMA, __, _I, _S, _TO_
        .byte   SE, _E, _K, _AND_, _D, ES, _T, _R, _O, _Y, __, _THIS, _SHIP
        .byte   _NEW_SENTENCE

        .byte   _YOU, __, _A, RE, __, _C, _A, _U, TI, ON, _ED_, TH, AT, __
        ;       TODO: import correct flight token
        .byte   ON, _L, _Y, __, FN_FLIGHT_ON, $22, FN_FLIGHT_OFF, _S, __
        .byte   _W, IL, _L, __, _P, EN, ET, RA, _T, _E, __, _THE_
        .byte   _N, _E, _W, __, _S, _H, _I, _E, _L, _D, _S, _AND_, TH, AT, __
        .byte   _THE_, FN_CAPNEXT, _C, ON, ST, _R, _I, _C, _T, OR, _IS_
        .byte   _F, IT, _T, _ED_, _W, _I, TH, __, AN, __
        ;       TODO: import correct flight token
        .byte   FN_FLIGHT_ON, $3b, FN_FLIGHT_OFF

        .byte   _B1, FN_02, FN_08
        .byte   _G, _O, _O, _D, __, _L, _U, _C, _K, COMMA, __, _COMMANDER
        .byte   _D4, FN_16, __end
        .msg
        
        ; $0B:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_17, FN_BUFFER_ON, FN_02, __, __, AT, _T, EN, TI, ON
        .byte   _COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY, DOT, __
        .byte   FN_CAPNEXT, _W, _E, __, _H, _A, VE, __, _N, _E, _ED_, _O, _F
        .byte   __, _YOU, _R, __, SE, _R, _V, _I, _C, ES, __, _A, _G, _A, IN
        .byte   _NEW_SENTENCE

        .byte   _I, _F, __, _YOU, __, _W, OU, _L, _D, __, BE, __, SO, __
        .byte   _G, _O, _O, _D, __, _A, _S, _TO_, _G, _O, _TO_
        .byte   FN_CAPNEXT, CE, ER, DI, __, _YOU, __, _W, IL, _L, __
        .byte   BE, __, _B, _R, _I, _E, _F, ED, _NEW_SENTENCE

        .byte   _I, _F, __, _S, _U, _C, CE, _S, _S, _F, _U, _L, COMMA, __
        .byte   _YOU, __, _W, IL, _L, __, BE, __, _W, _E, _L, _L, __
        .byte   RE, _W, AR, _D, ED, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "0B"

        ;-----------------------------------------------------------------------
        ; $0C:  "(C) D.Braben & I.Bell 1985"
        .byte   LPAREN, FN_CAPNEXT, _C, RPAREN, _DBRABEN_AND_IBELL
        .byte   __, _1, _9, _8, _5, __end
        .msg
        
        ; $0D:  "by D.Braben & I.Bell"
        .byte   _B, _Y, _DBRABEN_AND_IBELL, __end
        .msg

        ; $0E:
        .byte   FN_15, _PLANET, _C8, FN_1A, __end
        .msg

        ; $0F:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_17, FN_BUFFER_ON
        .byte   FN_02, __, __, _C, ON, _G, RA, _T, _U, LA, TI, ON, _S, __
        .byte   _COMMANDER, XMARK, FN_NEWLINE, FN_NEWLINE

        .byte   TH, ER, _E, FN_0D, __, _W, IL, _L, __, AL, _W, _A, _Y, _S
        .byte   __, BE, _A_, _P, LA, CE, __, _F, OR, __, _YOU, __, IN
        .byte   _HER_MAJESTYS_SPACE_NAVY, _NEW_SENTENCE

        .byte   AN, _D, __, MA, _Y, BE, __, SO, ON, ER, __, TH, AN, __
        .byte   _YOU, __, TH, IN, _K, DOT, DOT, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg

        ;-----------------------------------------------------------------------
        ; $10:  "fabled"
        .byte   _F, AB, LE, _D, __end
        .msg_id "FABLED"

        ; $11:  "notable"
        .byte   NO, _T, AB, LE, __end
        .msg

        ; $12:  "well known"
        .byte   _W, _E, _L, _L, __, _K, NO, _W, _N, __end
        .msg

        ; $13:  "famous"
        .byte   _F, _A, _M, _O, US, __end
        .msg

        ; $14:  "noted"
        .byte   NO, _T, ED, __end
        .msg

        ;-----------------------------------------------------------------------
        ; $15:  "very"
        .byte   VE, _R, _Y, __end
        .msg_id "VERY"

        ; $16:  "mildly"
        .byte   _M, IL, _D, _L, _Y, __end
        .msg

        ; $17:  "most"
        .byte   _M, _O, ST, __end
        .msg

        ; $18:  "reasonably"
        .byte   RE, _A, _S, ON, AB, _L, _Y, __end
        .msg

        ; $19:
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $1A:
        .byte   _ANCIENT, __end
        .msg_id "1A"

        ; $1B:
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __end
        .msg

        ; $1C:  "great"
        .byte   _G, RE, AT, __end
        .msg
        
        ; $1D:  "vast"
        .byte   _V, _A, ST, __end
        .msg

        ; $1E:  "pink"
        .byte   _P, IN, _K, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $1F:
        .byte   FN_02, _77, __, _76, FN_0D, __, _PLANT, _A, TI, ON, _S, __end
        .msg_id "1F"

        ; $20:  "mountains"
        .byte   _MOUNTAIN, _S, __end
        .msg

        ; $21:
        .byte   PARKINGMETERS_DUSTCLOUDS_ICEBERGS_ROCKFORMATIONS_VOLCANOES
        .byte   __end
        .msg
        
        ; $22:
        .byte   RANDOM_CLIMATE, __, _F, OR, ES, _T, _S, __end
        .msg
        
        ; $23:  "oceans"
        .byte   _O, CE, AN, _S, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $24:  "shyness"
        .byte   _S, _H, _Y, _N, ES, _S, __end
        .msg_id "SHYNESS"
        
        ; $25:  "silliness"
        .byte   _S, IL, _L, IN, ES, _S, __end
        .msg
        
        ; $26:  "mating traditions"
        .byte   MA, _T, _ING_, _T, RA, DI, TI, ON, _S, __end
        .msg
        
        ; $27:  "loathing of ", <"food blenders", "tourists", "poetry",
        ;       "discos", <?>>
        .byte   LO, AT, _H, _ING_, _O, _F, __, _64, __end
        .msg
        
        ; $28:  "love for ", <"food blenders" / "tourists" / "poetry" /
        ;       "discos" / <?>>
        .byte   LO, VE, __, _F, OR, __, _64, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $29:  "food blenders"
        .byte   _F, _O, _O, _D, __, _B, LE, _N, _D, ER, _S, __end
        .msg_id "FOOD_BLENDERS"
        
        ; $2A:  "tourists"
        .byte   _T, OU, _R, _I, ST, _S, __end
        .msg
        
        ; $2B:  "poetry"
        .byte   _P, _O, ET, _R, _Y, __end
        .msg
        
        ; $2C:  "discos"
        .byte   DI, _S, _C, _O, _S, __end
        .msg
        
        ; $2D:
        .byte   CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $2E:  "walking tree"
        .byte   _W, AL, _K, _ING_, _TREE, __end
        .msg_id "WALKING_TREE"
        
        ; $2F:  "crab"
        .byte   _C, RA, _B, __end
        .msg
        
        ; $30:  "bat"
        .byte   _B, AT, __end
        .msg
        
        ; $31:  "lobst"?
        .byte   LO, _B, ST, __end
        .msg
        
        ; $32:
        .byte   FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $33:  "beset"
        .byte   BE, _S, ET, __end
        .msg_id "BESET"
        
        ; $34:  "plagued"
        .byte   _P, LA, _G, _U, ED, __end
        .msg
        
        ; $35:  "ravaged"
        .byte   RA, _V, _A, _G, ED, __end
        .msg
        
        ; $36:  "cursed"
        .byte   _C, _U, _R, _S, ED, __end
        .msg
        
        ; $37:  "scourged"
        .byte   _S, _C, OU, _R, _G, ED, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $38:
        .byte   .scramble($71), __, _C, _I, _V, IL, __, _W, AR, __end
        .msg_id "38"
        
        ; $39:
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __
        .byte   .scramble($5f), __, .scramble($60), _S
        .byte   __end
        .msg
        
        ; $3A:  "a ", <"killer" / "deadly" / "evil" / "lethal" / "vicious">,
        ;       " disease"
        .byte   _A, __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __
        .byte   DI, SE, _A, SE, __end
        .msg
        
        ; $3B:
        .byte   .scramble($71), __, _E, AR, TH, QU, _A, _K, ES, __end
        .msg
        
        ; $3C:
        .byte   .scramble($71), __, SO, LA, _R, __
        .byte   _A, _C, TI, _V, IT, _Y, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $3D:
        .byte   _ITS
        .byte   ANCIENT_FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR_GREAT_VAST_PINK
        .byte   __, .scramble($5e), __end
        .msg_id "3D"
        
        ; $3E:
        .byte   _THE_, FN_11, __, .scramble($5f), __, .scramble($60), __end
        .msg
        
        ; $3F:  "it's inhabitant's ", <"ancient" / "exceptional" / "eccentric" /
        ;       "ingrained" / <"funny" / "weird" / "unusual" / "strange" /
        ;       "peculiar"> ...
        .byte   _ITS, _INHABITANT, _S, APOS, __
        .byte   ANCIENT_EXCEPTIONAL_ECCENTRIC_INGRAINED_ETC, __
        .byte   .scramble($63), __end
        .msg
        
        ; $40:
        .byte   FN_02, .scramble($7a), FN_0D, __end
        .msg
        
        ; $41:
        .byte   _ITS, FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING, __
        .byte   CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $42:  "juice"
        .byte   _J, _U, _I, CE, __end
        .msg_id "JUICE"
        
        ; $43:  "brandy"
        .byte   _B, RA, _N, _D, _Y, __end
        .msg
        
        ; $44:  "water"
        .byte   _W, AT, ER, __end
        .msg
        
        ; $45:  "brew"
        .byte   _B, RE, _W, __end
        .msg
        
        ; $46:  "gargle blasters"
        .byte   _G, AR, _G, LE, __, _B, LA, ST, ER, _S, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $47:
        .byte   FN_RANDOM_NAME, __end
        .msg_id "47"
        
        ; $48:
        .byte   FN_11, __, .scramble($60), __end
        .msg
        
        ; $49:
        .byte   FN_11, __, FN_RANDOM_NAME, __end
        .msg
        
        ; $4A:
        .byte   FN_11, __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __end
        .msg
        
        ; $4B:
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __, FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $4C:  "fabulous"
        .byte   _F, AB, _U, LO, US, __end
        .msg_id "FABULOUS"
        
        ; $4D:  "exotic"
        .byte   _E, _X, _O, TI, _C, __end
        .msg
        
        ; $4E:  "hoopy"
        .byte   _H, _O, _O, _P, _Y, __end
        .msg
        
        ; $4F:  "unusual"
        .byte   _U, NU, _S, _U, AL, __end
        .msg
        
        ; $50:  "exciting"
        .byte   _E, _X, _C, IT, IN, _G, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $51:  "cuisine"
        .byte   _C, _U, _I, _S, IN, _E, __end
        .msg_id "CUISINE"
        
        ; $52:  "night life"
        .byte   _N, _I, _G, _H, _T, __, _L, _I, _F, _E, __end
        .msg
        
        ; $53:  "casinos"
        .byte   _C, _A, _S, _I, NO, _S, __end
        .msg
        
        ; $54:  "sit coms"
        .byte   _S, IT, __, _C, _O, _M, _S, __end
        .msg
        
        ; $55:
        .byte   FN_02, .scramble($7a), FN_0D, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $56:
        .byte   FN_PRINT_FLIGHT_TOKEN, __end
        .msg_id "56"
        
        ; $57:
        .byte   _THE_, _PLANET, __, FN_PRINT_FLIGHT_TOKEN, __end
        .msg
        
        ; $58:
        .byte   _THE_, _WORLD, __, FN_PRINT_FLIGHT_TOKEN, __end
        .msg
        
        ; $59:
        .byte   _THIS, _PLANET, __end
        .msg
        
        ; $5A
        .byte   _THIS, _WORLD, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $5B:  "son of a bitch"
        .byte   _S, ON, __, _O, _F, _A_, _B, IT, _C, _H, __end
        .msg_id "SON_OF_A_BITCH"
        
        ; $5C:  "scoundrel"
        .byte   _S, _C, OU, _N, _D, RE, _L, __end
        .msg

        ; $5D:  "blackguard"
        .byte   _B, LA, _C, _K, _G, _U, AR, _D, __end
        .msg

        ; $5E:  "rogue"
        .byte   _R, _O, _G, _U, _E, __end
        .msg
        
        ; $5F:  "whoreson beetle headed flap ear'd knave"
        .byte   _W, _H, OR, ES, ON, __, BE, ET, LE, __
        .byte   _H, _E, _A, _D, _ED_, _F, LA, _P, __, _E, AR, APOS, _D, __
        .byte   _K, _N, _A, VE, __end
        .msg

        ;-----------------------------------------------------------------------
        ; $60:  "unremarkable"
        ; NOTE: the "n" is included so that "A" becomes "An" for this entry,
        ;       and remains as "A" for the other four
        .byte   _N, __, _U, _N, RE, MA, _R, _K, AB, LE, __end
        .msg_id "UNREMARKABLE"

        ; $61:  " boring"
        .byte   __, _B, OR, IN, _G, __end
        .msg
        
        ; $62:  " dull"
        .byte   __, _D, _U, _L, _L, __end
        .msg
        
        ; $63:  " tedious"
        .byte   __, _T, _E, DI, _O, US, __end
        .msg
        
        ; $64:  " revolting"
        .byte   __, RE, _V, _O, _L, _T, IN, _G, __end
        .msg
        
        ;-----------------------------------------------------------------------
        .msg_id "PLANET_SYNONYMS"

        ; $65:  "planet"
        .byte   _PLANET, __end

        ; $66:  "world"
        .byte   _WORLD, __end
        .msg

        ; $67:  "place"
        .byte   _P, LA, CE, __end
        .msg
        
        ; $68:  "little planet"
        .byte   _L, IT, _T, LE, __, _PLANET, __end
        .msg
        
        ; $69:  "dump"
        .byte   _D, _U, _M, _P, __end
        .msg
        
        ; hints on finding the prototype ship:
        ;-----------------------------------------------------------------------
        ; $6A:
        .byte   _I, __, _H, _E, AR, _A_, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR
        .byte   __, LO, _O, _K, _ING_, _SHIP, __, _A, _P, _P, _E, AR, _ED_
        .byte   AT, _ERRIUS, __end
        .msg_id "PROTO_HINTS"

        ; $6B:
        .byte   _Y, _E, _A, _H, COMMA, __, _I, __, _H, _E, AR, _A_
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __, _SHIP, __
        .byte   LE, _F, _T, _ERRIUS, _A_, __, _W, _H, _I, LE, __
        .byte   _B, _A, _C, _K, __end
        .msg
        
        ; $6C:
        .byte   _G, ET, __, _YOU, _R, __, _I, _R, ON, __, _A, _S, _S, __
        .byte   _O, _V, ER, __, _T, _O, _ERRIUS, __end
        .msg
        
        ; $6D:
        .byte   SO, _M, _E, __, RANDOM_INSULT, _NEW_, _SHIP, __
        .byte   _W, _A, _S, __, SE, EN, __, AT, _ERRIUS, __end
        .msg
        
        ; $6E:
        .byte   _T, _R, _Y, _ERRIUS, __end
        .msg
        
        ; Trumble™ descriptions?
        ;-----------------------------------------------------------------------
        ; $6F:  " cuddly"
        .byte   __, _C, _U, _D, _D, _L, _Y, __end
        .msg_id "CUDDLY"
        
        ; $70:  " cute"
        .byte   __, _C, _U, _T, _E, __end
        .msg
        
        ; $71:  " furry"
        .byte   __, _F, _U, _R, _R, _Y, __end
        .msg
        
        ; $72:  " friendly"
        .byte   __, _F, _R, _I, EN, _D, _L, _Y, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $73:
        .byte   _W, _A, _S, _P, __end
        .msg_id "WASP"
        
        ; $74:
        .byte   _M, _O, TH, __end
        .msg
        
        ; $75:
        .byte   _G, _R, _U, _B, __end
        .msg
        
        ; $76:
        .byte   AN, _T, __end
        .msg
        
        ; $77:
        .byte   FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $78:
        .byte   _P, _O, ET, __end
        .msg_id "POET"
        
        ; $79:
        .byte   AR, _T, _S, __, _G, RA, _D, _U, AT, _E, __end
        .msg
        
        ; $7A:
        .byte   _Y, _A, _K, __end
        .msg
        
        ; $7B:
        .byte   _S, _N, _A, IL, __end
        .msg
        
        ; $7C:
        .byte   _S, _L, _U, _G, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $7D:
        .byte   _T, _R, _O, _P, _I, _C, AL, __end
        .msg_id "TROPICAL"
        
        ; $7E:
        .byte   _D, EN, SE, __end
        .msg
        
        ; $7F:
        .byte   RA, IN, __end
        .msg
        
        ; $80:
        .byte   _I, _M, _P, EN, ET, RA, _B, LE, __end
        .msg
        
        ; message indices $81..$D6 are expandable via tokens $81..$D6
        ;
        ; TODO: define a constant for this barrier -- if we add or remove
        ;       messages, then the code needs to update CMP checks
        ; 
        ; $81:  "exuberant"
        .byte   _E, _X, _U, BE, RA, _N, _T, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $82:  "funny"
        .byte   _F, _U, _N, _N, _Y, __end
        .msg_id "FUNNY"
        .tkn
        
        ; $83:  "weird"
        .byte   _W, _E, _I, _R, _D, __end
        .msg
        .tkn
        
        ; $84:  "unusual"
        .byte   _U, NU, _S, _U, AL, __end
        .msg
        .tkn
        
        ; $85:  "strange"
        .byte   ST, RA, _N, GE, __end
        .msg
        .tkn
        
        ; $86:  "peculiar"
        .byte   _P, _E, _C, _U, _L, _I, AR, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $87:  "frequent"
        .byte   _F, RE, QU, EN, _T, __end
        .msg
        .tkn
        
        ; $88:  "occasional"
        .byte   _O, _C, _C, _A, _S, _I, ON, AL, __end
        .msg
        .tkn
        
        ; $89:  "unpredictable"
        .byte   _U, _N, _P, RE, DI, _C, _T, AB, LE, __end
        .msg
        .tkn
        
        ; $8A:  "dreadful"
        .byte   _D, RE, _A, _D, _F, _U, _L, __end
        .msg
        .tkn
        
        ; $8B:  "deadly"
        .byte   _DEADLY, __end
        .msg
        .tkn

        ;-----------------------------------------------------------------------
        ; $8C:
        .byte   VERY_MILDLY_MOST_REASONABLY, __
        .byte   FABLED_NOTABLE_WELLKNOWN_FAMOUS_NOTED, __
        .byte   _F, OR, __, .scramble($65), __end
        .msg_id "8C"
        .tkn_id "_8C"
        
        ; $8D:
        .byte   _8C, _AND_, .scramble($65), __end
        .msg
        .tkn
        
        ; $8E:
        .byte   BESET_PLAGUED_RAVAGED_CURSED_SCOURGED, __, _B, _Y, __
        .byte   .scramble($67), __end
        .msg
        .tkn_id "_8E"
        
        ; $8F:
        .byte   _8C, __, _B, _U, _T, __, _8E, __end
        .msg_id "8F"
        .tkn
        
        ; $90:
        .byte   __, _A, UNREMARKABLE_BORING_DULL_TEDIOUS_REVOLTING, __
        .byte   PLANET_WORLD_PLACE_LITTLEPLANET_DUMP, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $91:
        .byte   _P, _L, AN, ET, __end
        .msg
        .tkn_id "_PLANET"

        ; $92:
        .byte   _W, OR, _L, _D, __end
        .msg
        .tkn_id "_WORLD"

        ; $93:  "the "
        .byte   TH, _E, __, __end
        .msg
        .tkn_id "_THE_"

        ; $94:  "this "
        .byte   TH, _I, _S, __, __end
        .msg
        .tkn_id "_THIS"

        ; $95:  "load new Commander"
        .byte   LO, _A, _D, _NEW_, _COMMANDER, __end
        .msg
        .tkn_id "_LOAD_NEW_COMMANDER"

        ; $96:
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_01, FN_08, __end
        .msg
        .tkn

        ; $97:  "drive"
        .byte   _D, _R, _I, VE, __end
        .msg
        .tkn

        ; $98:  " catalogue"
        .byte   __, _C, AT, _A, LO, _G, _U, _E, __end
        .msg
        .tkn
        
        ; $99:  -"ian" (suffix)
        .byte   _I, AN, __end
        .msg_id "IAN"
        .tkn

        ; $9A:  "Commander"
        .byte   FN_CAPNEXT, _C, _O, _M, _M, AN, _D, ER, __end
        .msg
        .tkn_id "_COMMANDER"

        ;-----------------------------------------------------------------------
        ; $9B:
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __end
        .msg_id "9B"
        .tkn

        ; $9C:  "mountain"
        .byte   _M, OU, _N, _T, _A, IN, __end
        .msg
        .tkn_id "_MOUNTAIN"

        ; $9D:  "edible"
        .byte   ED, _I, _B, LE, __end
        .msg
        .tkn
        
        ; $9E:  "tree"
        .byte   _T, RE, _E, __end
        .msg
        .tkn_id "_TREE"

        ; $9F:  "spotted"
        .byte   _S, _P, _O, _T, _T, ED, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $A0:
        .byte   .scramble($78), __end
        .msg_id "A0"
        .tkn

        ; $A1:
        .byte   .scramble($79), __end
        .msg
        .tkn
        
        ; $A2:
        .byte   .scramble($61), _O, _I, _D, __end
        .msg
        .tkn
        
        ; $A3:
        .byte   POET_ARTSGRADUATE_YAK_SNAIL_SLUG, __end
        .msg
        .tkn
        
        ; $A4:
        .byte   RANDOM_PEST, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $A5:
        .byte   AN, _C, _I, EN, _T, __end
        .msg_id "ANCIENT"
        .tkn_id "_ANCIENT"
        
        ; $A6:
        .byte   _E, _X, CE, _P, TI, ON, AL, __end
        .msg
        .tkn
        
        ; $A7:
        .byte   _E, _C, CE, _N, _T, _R, _I, _C, __end
        .msg
        .tkn
        
        ; $A8:
        .byte   IN, _G, RA, IN, ED, __end
        .msg
        .tkn
        
        ; $A9:
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $AA:  "killer"
        .byte   _K, IL, _L, ER, __end
        .msg_id "KILLER"
        .tkn

        ; $AB:  "deadly"
        .byte   _D, _E, _A, _D, _L, _Y, __end
        .msg
        .tkn_id "_DEADLY"

        ; $AC:  "evil"
        .byte   _E, _V, IL, __end
        .msg
        .tkn
        
        ; $AD:  "lethal"
        .byte   LE, TH, AL, __end
        .msg
        .tkn
        
        ; $AE:  "vicious"
        .byte   _V, _I, _C, _I, _O, US, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $AF:  "its "
        .byte   IT, _S, __, __end
        .msg
        .tkn_id "_ITS"

        ; $B0:
        .byte   FN_0D, FN_BUFFER_ON, FN_CAPNEXT, __end
        .msg
        .tkn_id "_B0"

        ; $B1:
        .byte   DOT, FN_NEWLINE, FN_BUFFER_OFF, __end
        .msg
        .tkn_id "_B1"

        ; $B2:
        .byte   __, AN, _D, __, __end
        .msg
        .tkn_id "_AND_"

        ; $B3:
        .byte   _Y, OU, __end
        .msg
        .tkn_id "_YOU"

        ;-----------------------------------------------------------------------
        ; $B4:  "parking meters"
        .byte   _P, AR, _K, _ING_, _M, ET, ER, _S, __end
        .msg_id "PARKING_METERS"
        .tkn

        ; $B5:  "dust clouds"
        .byte   _D, US, _T, __, _C, LO, _U, _D, _S, __end
        .msg
        .tkn
        
        ; $B6:  "ice bergs"
        .byte   _I, CE, __, BE, _R, _G, _S, __end
        .msg
        .tkn
        
        ; $B7:  "rock formations"
        .byte   _R, _O, _C, _K, __, _F, OR, MA, TI, ON, _S, __end
        .msg
        .tkn
        
        ; $B8:  "volcanoes"
        .byte   _V, _O, _L, _C, _A, NO, ES, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $B9:  "plant"
        .byte   _P, _L, AN, _T, __end
        .msg_id "PLANT"
        .tkn_id "_PLANT"

        ; $BA:  "tulip"
        .byte   _T, _U, _L, _I, _P, __end
        .msg
        .tkn
        
        ; $BB:  "banana"
        .byte   _B, AN, AN, _A, __end
        .msg
        .tkn
        
        ; $BC:  "corn"
        .byte   _C, OR, _N, __end
        .msg
        .tkn
        
        ; $BD:  <random-name>, "weed"
        .byte   FN_RANDOM_NAME, _W, _E, ED, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $BE:
        .byte   FN_RANDOM_NAME, __end
        .msg_id "BE"
        .tkn

        ; $BF:
        .byte   FN_11, __, FN_RANDOM_NAME, __end
        .msg
        .tkn_id "_BF"
        
        ; $C0:
        .byte   FN_11, __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __end
        .msg
        .tkn
        
        ; $C1:  "inhabitant"
        .byte   IN, _H, _A, BI, _T, AN, _T, __end
        .msg
        .tkn_id "_INHABITANT"
        
        ; $C2:
        .byte   _BF, __end
        .msg
        .tkn
        
        ; $C3:  "ing "
        .byte   IN, _G, __, __end
        .msg
        .tkn_id "_ING_"

        ; $C4:  "ed "
        .byte   ED, __, __end
        .msg
        .tkn_id "_ED_"

        ; $C5:
        .byte   __, _D, DOT, _B, RA, BE, _N, __
        .byte  .scramble($26), __, _I, DOT, BE, _L, _L, __end
        .msg
        .tkn_id "_DBRABEN_AND_IBELL"

        ; $C6:  " little trumble"
        .byte   __, _L, IT, _T, LE, __, _T, _R, _U, _M, _B, LE, __end
        .msg_id "LITTLE_TRUMBLE"
        .tkn

        ; $C7:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_1D
        .byte   FN_BUFFER_ON, FN_CAPNEXT, _G, _O, _O, _D, FN_0D, __, _D, _A, _Y, __
        .byte   _COMMANDER, __, FN_04, COMMA, __, AL, LO, _W, __, _M, _E
        .byte   _TO_, IN, _T, _R, _O, _D, _U, CE, __, _M, _Y, SE, _L, _F
        .byte   DOT, __, FN_CAPNEXT, _I, __, _A, _M, FN_02, __, _THE_
        .byte   _M, ER, _C, _H, AN, _T, __, _P, _R, IN, CE, __, _O, _F, __
        .byte   TH, _R, _U, _N, FN_0D, _AND_, FN_CAPNEXT, _I, __, _F, IN, _D
        .byte   __, _M, _Y, SE, _L, _F, __, _F, OR, CE, _D, _TO_, SE, _L, _L
        .byte   __, _M, _Y, __, _M, _O, ST, __, _T, RE, _A, _S, _U, _R, ED
        .byte   __, _P, _O, _S, _S, ES, _S, _I, ON, _NEW_SENTENCE

        .byte   _I, __, _A, _M, __, _O, _F, _F, ER, _ING_, _Y, OU, COMMA, __
        .byte   _F, OR, __, _THE_, _P, _A, _L, _T, _R, _Y, __, _S, _U, _M, __
        .byte   _O, _F, __, _J, _U, ST, __, _5, _0, _0, _0
        .byte   FN_CAPNEXT, _C, FN_CAPNEXT, _R, __, _THE_, RA, RE, ST, __
        .byte   TH, _ING_, __, IN, __, _THE_, FN_02, _K, NO, _W, _N, __
        .byte   _U, _N, _I, VE, _R, SE, _NEW_SENTENCE
        
        .byte   FN_0D, _W, IL, _L, __, _Y, OU, __, _T, _A, _K, _E, __, IT
        .byte   FN_01, LPAREN, _Y, FSLASH, _N, RPAREN, QMARK, FN_NEWLINE
        .byte   FN_BUFFER_OFF, FN_01, FN_08
        .byte   __end
        .msg_id "MISSION_TRUMBLES"
        .tkn

        ; $C8:  " name?"
        .byte   __, _N, _A, _M, _E, QMARK, __
        .byte   __end
        .msg
        .tkn_id "_C8"

        ; $C9:  " to "
        .byte   __, _T, _O, __, __end
        .msg
        .tkn_id "_TO_"

        ; $CA:  " is "
        .byte   __, _I, _S, __, __end
        .msg
        .tkn_id "_IS_"

        ; $CB:  "was last seen at "
        .byte   _W, _A, _S, __, LA, ST, __, SE, EN, __, AT, __, FN_CAPNEXT
        .byte   __end
        .msg
        .tkn_id "_WAS_LAST_SEEN_AT_"

        ; $CC:  new sentence -- fullstop, new line, captialise next letter
        .byte   DOT, FN_NEWLINE, __, FN_CAPNEXT
        .byte   __end
        .msg
        .tkn_id "_NEW_SENTENCE"

        ; $CD:  "docked"
        .byte   _D, _O, _C, _K, ED, __end
        .msg_id "DOCKED"
        .tkn

        ; $CE:
        .byte   FN_01, LPAREN, _Y, FSLASH, _N, RPAREN, QMARK, __end
        .msg
        .tkn

        ; $CF:  "ship"
        .byte   _S, _H, _I, _P, __end
        .msg
        .tkn_id "_SHIP"

        ; $D0:  " a "
        .byte   __, _A, __, __end
        .msg
        .tkn_id "_A_"

        ; $D1:
        .byte   __, ER, _R, _I, US, __end
        .msg
        .tkn_id "_ERRIUS"

        ; $D2:
        .byte   __, _N, _E, _W, __, __end
        .msg
        .tkn_id "_NEW_"

        ; $D3:
        .byte   FN_02, __, _H, ER, __, MA, _J, ES, _T, _Y, APOS, _S, __
        .byte   _S, _P, _A, CE, __, _N, _A, _V, _Y, FN_0D
        .byte   __end
        .msg
        .tkn_id "_HER_MAJESTYS_SPACE_NAVY"

        ; $D4:
        .byte   _B1, FN_08, FN_01, __, __
        .byte   _M, ES, _S, _A, GE, __, EN, _D, _S
        .byte   __end
        .msg
        .tkn_id "_D4"

        ; $D5:
        .byte   __, _COMMANDER, __, FN_04, COMMA, __, _I, __, FN_0D, _A, _M
        .byte   FN_02, __, _C, _A, _P, _T, _A, IN, __, FN_THEIR_NAME, __
        .byte   FN_0D, _O, _F, _HER_MAJESTYS_SPACE_NAVY, __end
        .msg
        .tkn_id "_COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY"

        ; $D6:
        .byte   __end
        .msg
        .tkn

        ;-----------------------------------------------------------------------
        ; $D7:
        .byte   FN_BUFFER_OFF, __, _U, _N, _K, NO, _W, _N, __, _PLANET, __end
        .msg_id "D7"
        
        ; $D8:
        .byte   FN_CLEAR_SCREEN, FN_08, FN_17, FN_01, __, IN, _C, _O, _M
        .byte   _ING_, _M, ES, _S, _A, GE, __end
        .msg_id "INCOMING_MESSAGE"
        
        ; the names of NPCs; selected by galaxy number
        ;----------------------------------------------------------------------
        ; $D9:  "curruthers"
        .byte   _C, _U, _R, _R, _U, TH, ER, _S, __end
        .msg_id "CURRUTHERS"
        
        ; $DA:  "fosdyke smythe"
        .byte   _F, _O, _S, _D, _Y, _K, _E, __, _S, _M, _Y, TH, _E, __end
        .msg
        
        ; $DB:  "fortesque"
        .byte   _F, OR, _T, ES, QU, _E, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $DC:
        .byte   _WAS_LAST_SEEN_AT_, RE, ES, DI, CE, __end
        .msg
        
        ; $DD:  NOTE: this gets printed by docked token function $1C,
        ;       which adds the galaxy number to index $DC; it was probably
        ;       intended to chase the prototype ship across multiple galaxies,
        ;       but this idea appears to have been scrapped
        .byte   _I, _S, __, BE, _L, _I, _E, _V, ED, _TO_, _H, _A, VE, __
        .byte   _J, _U, _M, _P, ED, _TO_, _THIS, _G, AL, _A, _X, _Y, __end
        .msg_id "IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY"
        
        ;-----------------------------------------------------------------------
        ; $DE:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_1D, FN_BUFFER_ON, FN_02
        .byte   _G, _O, _O, _D, __, _D, _A, _Y, __, _COMMANDER, __
        .byte   FN_04, _NEW_SENTENCE

        .byte   _I, FN_0D, __, _A, _M, __, FN_CAPNEXT, _A, _G, EN, _T, __
        .byte   FN_CAPNEXT, _B, LA, _K, _E, __, _O, _F, __, FN_CAPNEXT
        .byte   _N, _A, _V, AL, __, FN_CAPNEXT
        .byte   IN, _T, _E, _L, LE, _G, EN, CE, _NEW_SENTENCE
        
        .byte   _A, _S, __, _YOU, __, _K, NO, _W, COMMA, __, _THE_
        .byte   FN_CAPNEXT, _N, _A, _V, _Y, __, _H, _A, VE, __, BE, EN, __
        .byte   _K, _E, _E, _P, _ING_, _THE_, FN_CAPNEXT
        .byte   TH, AR, _G, _O, _I, _D, _S, __, _O, _F, _F, __, _YOU, _R, __
        .byte   _A, _S, _S, __, OU, _T, __, IN, __, _D, _E, _E, _P
        .byte   __, _S, _P, _A, CE, __, _F, OR, __, MA, _N, _Y, __
        .byte   _Y, _E, AR, _S, __, NO, _W, DOT, __, FN_CAPNEXT
        .byte   _W, _E, _L, _L, __, _THE_, _S, IT, _U, _A, TI, ON, __
        .byte   _H, _A, _S, __, _C, _H, AN, _G, ED, _NEW_SENTENCE

        .byte   OU, _R, __, _B, _O, _Y, _S, __, AR, _E, __, RE, _A, _D, _Y
        .byte   __, _F, OR, _A_, _P, _U, _S, _H, __, _R, _I, _G, _H, _T, _TO_
        .byte   _THE_, _H, _O, _M, _E, __, _S, _Y, _S, _T, _E, _M, __, _O, _F
        .byte   __, TH, _O, SE, __, _M, _U, _R, _D, ER, ER, _S
        .byte   _NEW_SENTENCE

        .byte   FN_WAIT_FOR_KEY, FN_CLEAR_SCREEN, FN_1D
        .byte   _I, FN_0D, __, _H, _A, VE, __, _O, _B, _T, _A, IN, _ED_
        .byte   _THE_, _D, _E, _F, EN, CE, __, _P, LA, _N, _S, __, _F, OR
        .byte   __, TH, _E, _I, _R, __, FN_CAPNEXT, _H, _I, VE, __
        .byte   FN_CAPNEXT, _W, OR, _L, _D, _S, _NEW_SENTENCE

        .byte   _THE_, BE, ET, LE, _S, __, _K, NO, _W, __
        .byte   _W, _E, APOS, VE, __, _G, _O, _T, __, SO, _M, _E, TH, _ING_
        .byte   _B, _U, _T, __, NO, _T, __, _W, _H, AT, _NEW_SENTENCE

        .byte   _I, _F, __, FN_CAPNEXT, _I, __, _T, RA, _N, _S, _M, IT, __
        .byte   _THE_, _P, LA, _N, _S, _TO_, OU, _R, __, _B, _A, SE, __, ON
        .byte   __, FN_CAPNEXT, BI, RE, RA, __, TH, _E, _Y, APOS, _L, _L
        .byte   __, IN, _T, ER, CE, _P, _T, __, _THE_
        .byte   _T, _R, AN, _S, _M, _I, _S, _S, _I, ON, DOT, __
        .byte   FN_CAPNEXT, _I, __, _N, _E, ED, _A_, _SHIP, _TO_, MA, _K, _E
        .byte   __, _THE_, _R, _U, _N, _NEW_SENTENCE

        .byte   _YOU, APOS, RE, __, _E, LE, _C, _T, ED, _NEW_SENTENCE
        
        .byte   _THE_, _P, LA, _N, _S, __, _A, RE, __
        .byte   _U, _N, _I, _P, _U, _L, SE, __, _C, _O, _D, _ED_
        .byte   _W, _I, TH, IN, __, _THIS
        .byte   _T, _R, AN, _S, _M, _I, _S, _S, _I, ON
        .byte   _NEW_SENTENCE

        .byte   FN_08, _YOU, __, _W, IL, _L, __, BE, __, _P, _A, _I, _D
        .byte   _NEW_SENTENCE
        
        .byte   __, __, __, __, FN_CAPNEXT, _G, _O, _O, _D
        .byte   __, _L, _U, _C, _K, __, _COMMANDER, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg
        
        ; $DF:  
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_1D, FN_08, FN_BUFFER_ON, FN_0D, FN_CAPNEXT
        .byte   _W, _E, _L, _L, __, _D, ON, _E, __, _COMMANDER, _NEW_SENTENCE
        
        .byte   _YOU, __, _H, _A, VE, __, SE, _R, _V, _ED_, _U, _S, __
        .byte   _W, _E, _L, _L, _AND_, _W, _E, __, _S, _H, AL, _L, __
        .byte   RE, _M, _E, _M, _B, ER, _NEW_SENTENCE

        .byte   _W, _E, __, _D, _I, _D, __, NO, _T, __, _E, _X, _P, _E, _C, _T
        .byte   __, _THE_, FN_CAPNEXT, TH, AR, _G, _O, _I, _D, _S, _TO_
        .byte   _F, IN, _D, __, OU, _T, __, _A, _B, OU, _T, __, _YOU
        .byte   _NEW_SENTENCE

        .byte   _F, OR, __, _THE_, _M, _O, _M, EN, _T, __, _P, LE, _A, SE
        .byte   __, _A, _C, CE, _P, _T, __, _THIS, FN_CAPNEXT
        .byte   _N, _A, _V, _Y, __
        ;       TODO: import correct flight token
        .byte   FN_FLIGHT_ON, $25, FN_FLIGHT_OFF, __
        .byte   _A, _S, __, _P, _A, _Y, _M, EN, _T, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $E0:  "are you sure?"
        .byte   _A, RE, __, _YOU, __, _S, _U, RE, QMARK, __end
        .msg_id "ARE_YOU_SURE"
        
        ;-----------------------------------------------------------------------
        ; $E1:  "shrew"
        .byte   _S, _H, RE, _W, __end
        .msg_id "SHREW"
        
        ; $E2:  "beast"
        .byte   BE, _A, ST, __end
        .msg
        
        ; $E3:  "bison"
        .byte   _B, _I, _S, ON, __end
        .msg
        
        ; $E4:  "snake"
        .byte   _S, _N, _A, _K, _E, __end
        .msg
        
        ; $E5:  "wolf"
        .byte   _W, _O, _L, _F, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $E6:  "leopard"
        .byte   LE, _O, _P, AR, _D, __end
        .msg_id "LEOPARD"
        
        ; $E7:  "cat"
        .byte   _C, AT, __end
        .msg
        
        ; $E8:  "monkey"
        .byte   _M, ON, _K, _E, _Y, __end
        .msg
        
        ; $E9:  "goat"
        .byte   _G, _O, AT, __end
        .msg
        
        ; $EA:  "fish"
        .byte   _F, _I, _S, _H, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $EB:  
        .byte   .scramble($6a), __, RANDOM_DRINK
        .byte   __end
        .msg_id "EB"
        
        ; $EC:
        .byte   FN_11, __, .scramble($78), __
        .byte   RANDOM_FOOD, __end
        .msg_id "EC"
        
        ; $ED:
        .byte   _ITS, FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING, __
        .byte   .scramble($79), __, RANDOM_FOOD, __end
        .msg
        
        ; $EE:
        .byte   RANDOM_ENVIRONMENT, __, RANDOM_SPORT, __end
        .msg
        
        ; $EF:
        .byte   .scramble($6a), __, RANDOM_DRINK
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $F0:  "meat"
        .byte   _M, _E, AT, __end
        .msg_id "MEAT"
        
        ; $F1:  "cutlet"
        .byte   _C, _U, _T, _L, ET, __end
        .msg
        
        ; $F2:  "steak"
        .byte   ST, _E, _A, _K, __end
        .msg
        
        ; $F3:  "burgers"
        .byte   _B, _U, _R, _G, ER, _S, __end
        .msg
        
        ; $F4:  "soup"
        .byte   SO, _U, _P, __end
        .msg
        
        ; sport prefixes: (e.g. Brockian Ultra Cricket)
        ;-----------------------------------------------------------------------
        ; $F5:  "ice"
        .byte   _I, CE, __end
        .msg_id "ICE"
        
        ; $F6:  "mud"
        .byte   _M, _U, _D, __end
        .msg
        
        ; $F7:  "zero-G"
        .byte   _Z, ER, _O, HYPHEN, FN_CAPNEXT, _G, __end
        .msg
        
        ; $F8:  "vacuum"
        .byte   _V, _A, _C, _U, _U, _M, __end
        .msg
        
        ; $F9:
        .byte   FN_11, __, _U, _L, _T, RA, __end
        .msg
        
        ; sports:
        ;-----------------------------------------------------------------------
        ; $FA:  "hockey"
        .byte   _H, _O, _C, _K, _E, _Y, __end
        .msg_id "HOCKEY"
        
        ; $FB:  "cricket"
        .byte   _C, _R, _I, _C, _K, ET, __end
        .msg
        
        ; $FC:  "karate"
        .byte   _K, AR, AT, _E, __end
        .msg
        
        ; $FD:  "polo"
        .byte   _P, _O, LO, __end
        .msg
        
        ; $FE:  "tennis"
        .byte   _T, EN, _N, _I, _S, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $FF:  <"disk" / "tape"> " error"
        .byte   FN_NEWLINE, FN_MEDIA_CURRENT, __, ER, _R, OR
        .msg_id "ERROR"

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
        .byte   _THE_, _C, _O, LO, _N, _I, ST, _S, __, _H, _E, RE, __
        .byte   _H, _A, VE, __, _V, _I, _O, _L, AT, ED, FN_02, __
        .byte   IN, _T, ER, _G, AL, _A, _C, TI, _C, __, _C, LO, _N, _ING_
        .byte   _P, _R, _O, _T, _O, _C, _O, _L, FN_0D, _AND_
        .byte   _S, _H, OU, _L, _D, __, BE, __, _A, _V, _O, _I, _D, ED
        .byte   __end
        
        ; 2.
        ; TODO: "constrictor" should be capitalised
        .byte   _THE_, _C, ON, ST, _R, _I, _C, _T, OR, __, _WAS_LAST_SEEN_AT_
        .byte   RE, ES, DI, CE, COMMA, __, _COMMANDER
        .byte   __end

        ; 3.
        .byte   _A, __, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __
        .byte   LO, _O, _K, _ING_, _SHIP, __, LE, _F, _T, __, _H, _E, RE
        .byte   _A_, _W, _H, _I, LE, __, _B, _A, _C, _K, DOT, __
        .byte   _L, _O, _O, _K, _ED_, _B, OU, _N, _D, __, _F, OR, __
        ; TODO: "arexe" should be capitalised
        .byte   AR, _E, XE, __end
        
        ; 4.
        .byte   _Y, _E, _P, COMMA, _A_, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR
        .byte   _NEW_, _SHIP, __, _H, _A, _D, _A_, _G, AL, _A, _C, TI, _C, __
        .byte   _H, _Y, _P, ER, _D, _R, _I, VE, __, _F, IT, _T, _ED_
        .byte   _H, _E, RE, DOT, __, US, _ED_, IT, __, _T, _O, _O, __end
        
        ; 5.
        .byte   _THIS, __, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __, _SHIP, __
        .byte    _D, _E, _H, _Y, _P, _ED_, _H, _E, RE, __, _F, _R, _O, _M, __
        .byte   NO, _W, _H, _E, RE, COMMA, __, _S, _U, _N, __
        .byte   _S, _K, _I, _M, _M, ED, _AND_, _J, _U, _M, _P, ED, DOT, __
        .byte   _I, __, _H, _E, AR, __, IT, __, _W, EN, _T, _TO_
        .byte   IN, BI, BE, __end
        
        ; 6.
        .byte   RANDOM_INSULT, __, _SHIP, __, _W, EN, _T, __, _F, OR, __
        .byte   _M, _E, __, AT, __, _A, US, AR, DOT, __, _M, _Y, __
        .byte   LA, _S, ER, _S, __, _D, _I, _D, _N, APOS, _T, __
        .byte   _E, _V, EN, __, _S, _C, RA, _T, _C, _H, __, _THE_
        .byte   RANDOM_INSULT, __end
        
        ; 7.
        .byte   _O, _H, __, _D, _E, AR, __, _M, _E, __, _Y, ES, DOT
        .byte   _A_, _F, _R, _I, _G, _H, _T, _F, _U, _L, __
        .byte   _R, _O, _G, _U, _E, __, _W, _I, TH, __, _W, _H, AT, __
        .byte   _I, __, BE, _L, _I, _E, VE, __, _YOU, __
        .byte   _P, _E, _O, _P, LE, __, _C, AL, _L, _A_, LE, _A, _D, __
        .byte   _P, _O, ST, ER, _I, OR, __, _S, _H, _O, _T, __, _U, _P, __
        .byte   LO, _T, _S, __, _O, _F, __, TH, _O, SE, __
        .byte   BE, _A, ST, _L, _Y, __, _P, _I, RA, _T, ES, _AND_
        ; TODO: "usleri" should be capitalised
        .byte   _W, EN, _T, _TO_, US, LE, _R, _I
        .byte   __end
        
        ; 8.
        .byte   _YOU, __, _C, AN, __, _T, _A, _C, _K, LE, __, _THE_
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __, RANDOM_INSULT, __
        .byte   _I, _F, __, _YOU, __, _L, _I, _K, _E, DOT, __
        ; TODO: "orarra" should be capitalised
        .byte   _H, _E, APOS, _S, __, AT, __, OR, AR, RA, __end
        
        ; 9.    still waiting on OP...
        .byte   FN_01
        .byte   _C, _O, _M, _ING_, SO, ON, COLON, __
        .byte   _E, _L, IT, _E, __, _I, _I, __end
        
        .byte   .scramble($74), __end      ; 10.
        .byte   .scramble($74), __end      ; 11.
        .byte   .scramble($74), __end      ; 12.
        .byte   .scramble($74), __end      ; 13.
        .byte   .scramble($74), __end      ; 14.
        .byte   .scramble($74), __end      ; 15.
        .byte   .scramble($74), __end      ; 16.
        .byte   .scramble($74), __end      ; 17.
        .byte   .scramble($74), __end      ; 18.
        .byte   .scramble($74), __end      ; 19.
        .byte   .scramble($74), __end      ; 20.
        .byte   .scramble($74), __end      ; 21.
        .byte   .scramble($74), __end      ; 22.
        
        ; 23.
        .byte   _B, _O, _Y, __, _A, RE, __, _YOU, __, IN, __, _THE_
        .byte   _W, _R, ON, _G, __, _G, AL, _A, _X, _Y, XMARK, __end
        
        ; 24.
        .byte   TH, ER, _E, APOS, _S, _A_, RE, AL, __, RANDOM_INSULT
        .byte   __, _P, _I, RA, _T, _E, __, OU, _T, __, TH, ER, _E, __end
        
        ; 25.
        .byte   _THE_, _INHABITANT, _S, __, _O, _F, __
        .byte   .scramble($6d), __, _A, RE, __, SO, __
        .byte   _A, MA, _Z, IN, _G, _L, _Y, __
        .byte   _P, _R, _I, _M, _I, TI, VE, __
        .byte   TH, AT, __, TH, _E, _Y, __, ST
        .byte   IL, _L, __, TH, IN, _K, __, FN_CAPNEXT
        .byte   .scramble($2a),.scramble($2a), .scramble($2a), .scramble($2a)
        .byte   .scramble($2a), __, .scramble($2a), .scramble($2a)
        .byte   .scramble($2a), .scramble($2a), .scramble($2a), .scramble($2a)
        .byte   _IS_, __, .scramble($33), _D
        .byte   __end
        
        ; 26.   unused
        .byte   FN_01, _W, _E, _L, _C, _O, _M, _E, __, _T, _O, __
        .byte   _T, _H, _E, __, _S, _E, _V, _E, _N, _T, _E, _E, _N, _T, _H, __
        .byte   _G, _A, _L, _A, _X, _Y, XMARK, __end
        
        ; 27.   TODO: this does not look like text
        ;       -- some other kind of lookup table?
        .byte   .scramble($6d), FN_THEIR_NAME, FN_CAPNEXT
        .byte   FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, RANDOM_ENVIRONMENT, $31, $3a, FN_16
        .byte   FN_CAPNEXT, FN_14, $23, $30, $3a, FN_04, FN_PRINT_FLIGHT_TOKEN
        .byte   FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, $35, RANDOM_ENVIRONMENT, $31, $3a, FN_1D
        .byte   FN_1A, FN_07, FN_THEIR_NAME, FN_THEIR_NAME, $35, .scramble($64), _Z, $21
        .byte   HYPHEN, .scramble($6a), $2e, FN_THEIR_NAME, FN_THEIR_NAME, $35, $32, $20
        .byte   FN_THEIR_NAME, FN_CAPNEXT, FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, $3a, FN_04

;$1D00