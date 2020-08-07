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
.tkn_fn "CAPS_ON",              tkn_docked_fn01                         ;=$56
; $02   ?
.tkn_fn "CAPS_OFF",             tkn_docked_fn02                         ;=$55
; $03   print the name of the target system. note that this works
;       by printing this token number ($03) as a flight-token
.tkn_fn "TARGET_SYSTEM",        print_flight_token                      ;=$54
; $04   print your commander name. note that this works by printing
;       this token number ($04) as a flight-token
.tkn_fn "YOUR_NAME",            print_flight_token                      ;=$53
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
.tkn_fn "BUFFER_ON",            text_buffer_on                          ;=$59
; $0F   disables the text-buffer
.tkn_fn "BUFFER_OFF",           text_buffer_off                         ;=$58
; $10   print "a". truly, truly, a bizzare use of a function token
.tkn_fn "A",                    print_a                                 ;=$47
; $11   print the name of the target system, with an -"ian" suffix.
;       if the system's last letter is a vowel it is removed, e.g. "Lavian"
.tkn_fn "TARGET_SYSTEM_IAN",    target_system_provenance                ;=$46
; $12   print a randomly generated name
.tkn_fn "RANDOM_NAME",          print_random_name                       ;=$45
; $13   capitalise the next character printed
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
;===============================================================================
.macro  .ascii          tkn_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        .charmap        _tkn_index, .scramble( _tkn_index )
        .tkn_id         tkn_id

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

;       symbol                  ; token scrmbld note
;-------------------------------------------------------------------------------
.ascii  "__"                    ; $20   =$77
.ascii  "XMARK"                 ; $21   =$76    !
.ascii  "SPMARK"                ; $22   =$75    "
.ascii  "HASH"                  ; $23   =$74    #
.ascii  "DOLLAR"                ; $24   =$73    $
.ascii  "PCENT"                 ; $25   =$72    %
.ascii  "AMP"                   ; $26   =$71    &
.ascii  "APOS"                  ; $27   =$70    '
.ascii  "LPAREN"                ; $28   =$7F    (
.ascii  "RPAREN"                ; $29   =$7E    )
.ascii  "STAR"                  ; $2A   =$7D    *
.ascii  "PLUS"                  ; $2B   =$7C    +
.ascii  "COMMA"                 ; $2C   =$7B    ,
.ascii  "HYPHEN"                ; $2D   =$7A    -
.ascii  "DOT"                   ; $2E   =$79    .
.ascii  "FSLASH"                ; $2F   =$78    /
.ascii  "_0"                    ; $30   =$67    0
.ascii  "_1"                    ; $31   =$66    1
.ascii  "_2"                    ; $32   =$65    2
.ascii  "_3"                    ; $33   =$64    3
.ascii  "_4"                    ; $34   =$63    4
.ascii  "_5"                    ; $35   =$62    5
.ascii  "_6"                    ; $36   =$61    6
.ascii  "_7"                    ; $37   =$60    7
.ascii  "_8"                    ; $38   =$6F    8
.ascii  "_9"                    ; $39   =$6E    9
.ascii  "COLON"                 ; $3A   =$6D    :
.ascii  "SEMI"                  ; $3B   =$6C    ;
.ascii  "LT"                    ; $3C   =$6B    <
.ascii  "EQUALS"                ; $3D   =$6A    =
.ascii  "GT"                    ; $3E   =$69    >
.ascii  "QMARK"                 ; $3F   =$68    ?
.ascii  "COMAT"                 ; $40   =$17    @
.ascii  "_A"                    ; $41   =$16    A
.ascii  "_B"                    ; $42   =$15    B
.ascii  "_C"                    ; $43   =$14    C
.ascii  "_D"                    ; $44   =$13    D
.ascii  "_E"                    ; $45   =$12    E
.ascii  "_F"                    ; $46   =$11    F
.ascii  "_G"                    ; $47   =$10    G
.ascii  "_H"                    ; $48   =$1F    H
.ascii  "_I"                    ; $49   =$1E    I
.ascii  "_J"                    ; $4A   =$1D    J
.ascii  "_K"                    ; $4B   =$1C    K
.ascii  "_L"                    ; $4C   =$1B    L
.ascii  "_M"                    ; $4D   =$1A    M
.ascii  "_N"                    ; $4E   =$19    N
.ascii  "_O"                    ; $4F   =$18    O
.ascii  "_P"                    ; $50   =$07    P
.ascii  "_Q"                    ; $51   =$06    Q
.ascii  "_R"                    ; $52   =$05    R
.ascii  "_S"                    ; $53   =$04    S
.ascii  "_T"                    ; $54   =$03    T
.ascii  "_U"                    ; $55   =$02    U
.ascii  "_V"                    ; $56   =$01    V
.ascii  "_W"                    ; $57   =$00    W
.ascii  "_X"                    ; $58   =$0F    X
.ascii  "_Y"                    ; $59   =$0E    Y
.ascii  "_Z"                    ; $5A   =$0D    Z

; NOTE: ASCII codes $5B...$5F are not included!
;;.ascii  "_LSQB"                 ; $5B   =$0C    [
;;.ascii  "_BSLASH"               ; $5C   =$0B    \
;;.ascii  "_RSQB"                 ; $5D   =$0A    ]
;;.ascii  "_ACUTE"                ; $5E   =$09    ^
;;.ascii  "_USCORE"               ; $5F   =$08    _


.segment        "TEXT_PDESC"
;===============================================================================
; docked tokens $5B...$80 (unscrambled) are re-routed through this table:
; $5B is subtracted so that a docked token of $5B will read the first entry
; in this table, and the value is re-used as a new *message* index to print
;
_3eac:                                                                  ;$3EAC
;-------------------------------------------------------------------------------
.export _3eac

; $5B = messages $10...$14:
.tkn_id "FABLED_NOTABLE_WELLKNOWN_FAMOUS_NOTED"                         ;=$0C
        ; $10:  "fabled"
        ; $11:  "notable"
        ; $12:  "well-known"
        ; $13:  "famous"
        ; $14:  "noted"
        .byte   MSG_FABLED

; $5C = messages $15...$19:
.tkn_id "VERY_MILDLY_MOST_REASONABLY"                                   ;=$0B
        ; $15:  "very"
        ; $16:  "mildly"
        ; $17:  "most"
        ; $18:  "reasonably"
        ; $19:  ""
        .byte   MSG_VERY

; $5D = messages $1A...$1E:
.tkn_id "ANCIENT_FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR_GREAT_VAST_PINK"  ;=$0A
        ; $1A:  "ancient"
        ; $1B:  "funny" / "weird" / "unusual" / "strange" / "peculiar"
        ; $1C:  "great"
        ; $1D:  "vast"
        ; $1E:  "pink"
        .byte   MSG_1A

; $5E = messages $1F...$23:
.tkn_id "RANDOM_GEOGRAPHY"                                              ;=$09
        ; $1F:  "<?> plantations"
        ; $20:  "mountains"
        ; $21:  "parking meters" / "dust clouds" / "ice bergs" / 
        ;       "rock formations" / "volcanoes"
        ; $22:  "<?> forests"
        ; $23:  "oceans"
        .byte   MSG_PLANTATIONS

; $5F = tokens $9B...$9F:
.tkn_id "KILLER_ETC_MOUNTAIN_EDIBLE_TREE_SPOTTED"                       ;=$08
        ; $9B:  "killer" / "deadly" / "evil" / "lethal" / "vicious"
        ; $9C:  "mountain"
        ; $9D:  "edible"
        ; $9E:  "tree"
        ; $9F:  "spotted"
        .byte   MSG_KILLER_DEADLY_EVIL_LETHAL_VICIOUS

; $60 = messages $A0...$A4:
.tkn_id "RANDOM_ANIMAL"                                                 ;=$37
        ; $A0:  "shrew" / "beast" / "bison" / "snake" / "wolf"
        ; $A1:  "leopard" / "cat" / "monkey" / "goat" / "fish"
        ; $A2:  "walking treeoid" / "craboid" / "lobstoid" /
        ;        <random-name>-"oid"
        ; $A3:  "poet" / "arts graduate" / "yak" / "snail" / "slug"
        ; $A4:  "wasp" / "moth" / "grub" / "ant" / <random-name>
        .byte   MSG_A0

; $61 = messages $2E...$32:
.tkn_id "WALKINGTREE_CRAB_BAT_LOBST_RANDOMNAME"                         ;=$36
        ; $2E:  "walking tree"
        ; $2F:  "crab"
        ; $30:  "bat"
        ; $31:  "lobst"
        ; $32:  <random-name>
        .byte   MSG_WALKING_TREE

; $62 = messages $A5...$A9:
.tkn_id "ANCIENT_EXCEPTIONAL_ECCENTRIC_INGRAINED_ETC"                   ;=$35
        ; $A5:  "ancient"
        ; $A6:  "exceptional"
        ; $A7:  "eccentric"
        ; $A8:  "ingrained"
        ; $A9:  "funny" / "weird" / "unusual" / "strange" / "peculiar"
        .byte   MSG_ANCIENT

; $63 = messages $24...$28:
.tkn_id "_63"                                                           ;=$34
        .byte   MSG_SHYNESS

; $64 = messages $29...$2D:
.tkn_id "_64"                                                           ;=$33
        ; $29:  "food blenders"
        ; $2A:  "tourists"
        ; $2B:  "poetry"
        ; $2C:  "discos"
        ; $2D:  "cuisine" / "night life" / "casinos" / "sit coms", <?> 
        .byte   MSG_FOOD_BLENDERS

; $65 = messages $3D...$41:
.tkn_id "_65"                                                           ;=$32
        .byte   MSG_3D

; $66 = messages $33...$37:
.tkn_id "BESET_PLAGUED_RAVAGED_CURSED_SCOURGED"                         ;=$31
        ; $33:  "beset"
        ; $34:  "plagued"
        ; $35:  "ravaged"
        ; $36:  "cursed"
        ; $37:  "scourged"
        .byte   MSG_BESET

; $67 = messages $38...$3C:
.tkn_id "_67"                                                           ;=$30
        .byte   MSG_38

; $68 = messages $AA...$AE:
.tkn_id "KILLER_DEADLY_EVIL_LETHAL_VICIOUS"                             ;=$3F
        ; $AA:  "killer"
        ; $AB:  "deadly"
        ; $AC:  "evil"
        ; $AD:  "lethal"
        ; $AE:  "vicious"
        .byte   MSG_KILLER

; $69 = messages $42...$46:
.tkn_id "RANDOM_DRINK"                                                  ;=$3E
        ; $42:  "juice"
        ; $43:  "brandy"
        ; $44:  "water"
        ; $45:  "brew"
        ; $46:  "gargle blasters"
        .byte   MSG_JUICE

; $6A = messages $47...$4B:
.tkn_id "_6A"                                                           ;=$3D
        .byte   MSG_47

; $6B = messages $4C...$50:
.tkn_id "FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING"                        ;=$3C
        ; $4C:  "fabulous"
        ; $4D:  "exotic"
        ; $4E:  "hoopy"
        ; $4F:  "unusual"
        ; $50:  "exciting"
        .byte   MSG_FABULOUS

; $6C = messages $51...$55:
.tkn_id "CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC"                         ;=$3B
        ; $51:  "cuisine"
        ; $52:  "night life"
        ; $53:  "casinos"
        ; $54:  "sit coms"
        ; $55:  TODO: ...?
        .byte   MSG_CUISINE

; $6D = messages $56...$5A:
.tkn_id "_6D"                                                           ;=$3A
        .byte   MSG_56

; $6E = messages $8C...$90:
.tkn_id "_6E"                                                           ;=$39
        .byte   MSG_8C

; $6F = messages $60...$64:
.tkn_id "UNREMARKABLE_BORING_DULL_TEDIOUS_REVOLTING"                    ;=$38
        ; $60:  "unremarkable"
        ; $61:  "boring"
        ; $62:  "dull"
        ; $63:  "tedious"
        ; $64:  "revolting"
        .byte   MSG_UNREMARKABLE

; $70 = messages $65...$69:
.tkn_id "PLANET_WORLD_PLACE_LITTLEPLANET_DUMP"                          ;=$27
        ; $70:  "planet"
        ; $71:  "world"
        ; $72:  "place"
        ; $73:  "little planet"
        ; $74:  "dump"
        .byte   MSG_PLANET_SYNONYMS

; $71 = messages $8F...$93:
.tkn_id "_71"                                                           ;=$26
        ; "<x> but <y>"?
        .byte   MSG_8F

; $72 = messages $82...$86:
.tkn_id "FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR"                          ;=$25
        ; $82:  "funny"
        ; $83:  "weird"
        ; $84:  "unusual"
        ; $85:  "strange"
        ; $86:  "peculiar"
        .byte   MSG_FUNNY

; $73 = messages $5B...$5F:
.tkn_id "RANDOM_INSULT"                                                 ;=$24
        ; $5B:  "son of a bitch"
        ; $5C:  "scoundrel"
        ; $5D:  "blackguard"
        ; $5E:  "rogue"
        ; $5F:  "whoreson beetle headed flap ear'd knave"
        .byte   MSG_INSULTS

; $74 = messages $6A...$6E:
.tkn_id "_74"                                                           ;=$23
        .byte   MSG_PROTO_HINTS

; $75 = messages $B4...$B8:
.tkn_id "PARKINGMETERS_DUSTCLOUDS_ICEBERGS_ROCKFORMATIONS_VOLCANOES"    ;=$22
        ; $B4:  "parking meters"
        ; $B5:  "dust clouds"
        ; $B6:  "ice bergs"
        ; $B7:  "rock formations"
        ; $B8:  "volcanoes"
        .byte   MSG_PARKING_METERS

; $76 = messages $B9...$BD:
.tkn_id "RANDOM_PLANT"                                                  ;=$21
        ; $B9:  "plant"
        ; $BA:  "tulip"
        ; $BB:  "banana"
        ; $BC:  "corn"
        ; $BD:  <random-name> "weed"
        .byte   MSG_PLANT

; $77 = messages $BE...$C2:
.tkn_id "_77"                                                           ;=$20
        .byte   MSG_BE

; $78 = messages $E1...$E5:
.tkn_id "SHREW_BEAST_BISON_SNAKE_WOLF"                                  ;=$2F
        ; $E1:  "shrew"
        ; $E2:  "beast"
        ; $E3:  "bison"
        ; $E4:  "snake"
        ; $E5:  "wolf"
        .byte   MSG_SHREW

; $79 = messages $E6...$EA:
.tkn_id "LEOPARD_CAT_MONKEY_GOAT_FISH"                                  ;=$2E
        ; $E6:  "leopard"
        ; $E7:  "cat"
        ; $E8:  "monkey"
        ; $E9:  "goat"
        ; $EA:  "fish"
        .byte   MSG_LEOPARD

; $7A = messages $EB...$EF:
.tkn_id "_7A"                                                           ;=$2D
        .byte   MSG_EB

; $7B = messages $F0...$F4:
.tkn_id "RANDOM_FOOD"                                                   ;=$2C
        ; $F0:  "meat"
        ; $F1:  "cutlet"
        ; $F2:  "steak"
        ; $F3:  "burgers"
        ; $F4:  "soup"
        .byte   MSG_MEAT

; $7C = messages $F5...$F9:
.tkn_id "RANDOM_ENVIRONMENT"                                            ;=$2B
        ; $F5:  "ice"
        ; $F6:  "mud"
        ; $F7:  "zero-G"
        ; $F8:  "vacuum"
        ; $F9:  <target-system>-"ian ultra"
        .byte   MSG_ICE

; $7D = messages $FA...$FE:
.tkn_id "RANDOM_SPORT"                                                  ;=$2A
        ; $FA:  "hockey"
        ; $FB:  "cricket"
        ; $FC:  "karate"
        ; $FD:  "polo"
        ; $FE:  "tennis"
        .byte   MSG_HOCKEY

; $7E = messages $73...$78:
.tkn_id "RANDOM_PEST"                                                   ;=$29
        ; $73:  "wasp"
        ; $74:  "moth"
        ; $75:  "grub"
        ; $76:  "ant"
        ; $77:  <random-name>
        .byte   MSG_WASP

; $7F = messages $78...$7C:
.tkn_id "POET_ARTSGRADUATE_YAK_SNAIL_SLUG"                              ;=$28
        ; $78:  "poet"
        ; $79:  "arts graduate"
        ; $7A:  "yak"
        ; $7B:  "snail"
        ; $7C:  "slug"
        .byte   MSG_POET

; $80 = messages $7D...$81:
.tkn_id "RANDOM_CLIMATE"                                                ;=$D7
        ; $7D:  "tropical"
        ; $7E:  "dense"
        ; $7F:  "rain"
        ; $80:  "impenetrable"
        ; $81:  "exuberant" 
        .byte   MSG_TROPICAL                                            ;$3ED2


; import the token numbers for the common charcter pairs used by docked
; strings ("text_pairs.asm"). these come unscrambled; we scramble them
; here, for the on-disk format
;
.import tkn_docked_crlf:direct
CRLF    = .scramble( tkn_docked_crlf )                                  ;=$80
.import tkn_docked_ab:direct
AB      = .scramble( tkn_docked_ab )                                    ;=$8F
.import tkn_docked_ou:direct
OU      = .scramble( tkn_docked_ou )                                    ;=$8E
.import tkn_docked_se:direct
SE      = .scramble( tkn_docked_se )                                    ;=$8D
.import tkn_docked_it:direct
IT      = .scramble( tkn_docked_it )                                    ;=$8C
.import tkn_docked_il:direct
IL      = .scramble( tkn_docked_il )                                    ;=$8B
.import tkn_docked_et:direct
ET      = .scramble( tkn_docked_et )                                    ;=$8A
.import tkn_docked_st:direct
ST      = .scramble( tkn_docked_st )                                    ;=$89
.import tkn_docked_on:direct
ON      = .scramble( tkn_docked_on )                                    ;=$88
.import tkn_docked_lo:direct
LO      = .scramble( tkn_docked_lo )                                    ;=$B7
.import tkn_docked_nu:direct
NU      = .scramble( tkn_docked_nu )                                    ;=$B6
.import tkn_docked_th:direct
TH      = .scramble( tkn_docked_th )                                    ;=$B5
.import tkn_docked_no:direct
NO      = .scramble( tkn_docked_no )                                    ;=$B4
.import tkn_docked_al:direct
AL      = .scramble( tkn_docked_al )                                    ;=$B3
.import tkn_docked_le:direct
LE      = .scramble( tkn_docked_le )                                    ;=$B2
.import tkn_docked_xe:direct
XE      = .scramble( tkn_docked_xe )                                    ;=$B1
.import tkn_docked_ge:direct
GE      = .scramble( tkn_docked_ge )                                    ;=$B0
.import tkn_docked_za:direct
ZA      = .scramble( tkn_docked_za )    ; -- unused here                ;=$BF
.import tkn_docked_ce:direct
CE      = .scramble( tkn_docked_ce )                                    ;=$BE
.import tkn_docked_bi:direct
BI      = .scramble( tkn_docked_bi )                                    ;=$BD
.import tkn_docked_so:direct
SO      = .scramble( tkn_docked_so )                                    ;=$BC
.import tkn_docked_us:direct
US      = .scramble( tkn_docked_us )                                    ;=$BB
.import tkn_docked_es:direct
ES      = .scramble( tkn_docked_es )                                    ;=$BA
.import tkn_docked_ar:direct
AR      = .scramble( tkn_docked_ar )                                    ;=$B9
.import tkn_docked_ma:direct
MA      = .scramble( tkn_docked_ma )                                    ;=$B8
.import tkn_docked_in:direct
IN      = .scramble( tkn_docked_in )                                    ;=$A7
.import tkn_docked_di:direct
DI      = .scramble( tkn_docked_di )                                    ;=$A6
.import tkn_docked_re:direct
RE      = .scramble( tkn_docked_re )                                    ;=$A5
.import tkn_docked_a_:direct
A_      = .scramble( tkn_docked_a_ )                                    ;=$A4
.import tkn_docked_er:direct
ER      = .scramble( tkn_docked_er )                                    ;=$A3
.import tkn_docked_at:direct
AT      = .scramble( tkn_docked_at )                                    ;=$A2
.import tkn_docked_en:direct
EN      = .scramble( tkn_docked_en )                                    ;=$A1
.import tkn_docked_be:direct
BE      = .scramble( tkn_docked_be )                                    ;=$A0
.import tkn_docked_ra:direct
RA      = .scramble( tkn_docked_ra )                                    ;=$AF
.import tkn_docked_la:direct
LA      = .scramble( tkn_docked_la )                                    ;=$AE
.import tkn_docked_ve:direct
VE      = .scramble( tkn_docked_ve )                                    ;=$AD
.import tkn_docked_ti:direct
TI      = .scramble( tkn_docked_ti )                                    ;=$AC
.import tkn_docked_ed:direct
ED      = .scramble( tkn_docked_ed )                                    ;=$AB
.import tkn_docked_or:direct
OR      = .scramble( tkn_docked_or )                                    ;=$AA
.import tkn_docked_qu:direct
QU      = .scramble( tkn_docked_qu )                                    ;=$A9
.import tkn_docked_an:direct
AN      = .scramble( tkn_docked_an )                                    ;=$A8


.segment        "TEXT_DOCKED"
;===============================================================================
_msg_index     .set 0

.macro  .msg_alias      msg_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; define a constant for the un-scrambled index value
        .ident( .concat( "MSG_", msg_id )) = _msg_index
        ; define an export for the index-number of the message;
        ; this is how the outside world will specify the message to print
.export .ident( .concat( "MSG_DOCKED_", msg_id )) = _msg_index

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .msg_id         msg_id
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        ; define the message ID symbols
        .msg_alias      msg_id
        ; move to the next index number:
        ; doing this afterwards ensures that there is an index 0
        _msg_index .set _msg_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .msg
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        ; increment the msg ID, but don't define any symbol
         _msg_index .set _msg_index + 1

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


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
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_CAPS_ON, FN_08, __
        ;       "disk" / "tape" "access menu"
        .byte   FN_MEDIA_CURRENT, " AC", CE, "SS ME", NU
        .byte   CRLF, FN_0A, FN_CAPS_OFF
        .byte   "1. ", LOAD_NEW_COMMANDER, CRLF
        .byte   "2. ", "SA", VE, __, COMMANDER, __, FN_YOUR_NAME, CRLF
        .byte   "3. ", "CH", AN, GE, __TO__, FN_MEDIA_OTHER, CRLF
        .byte   "4. ", "DEFAULT ", FN_CAPS_ON, "JAMESON", FN_CAPS_OFF, CRLF
        .byte   "5. ", "EX", IT, CRLF
        .byte   __end
        .msg_id "DATA_MENU"
        
        ; the list of supported save media-types:
        ;-----------------------------------------------------------------------
        ; $02:
        .byte   DI, "SK", __end
        .msg_id "MEDIAS"

        ; $03:
        ; TODO: remove tape code / references
        .byte   "TAPE", __end
        .msg_id "TAPE"
        
        ;-----------------------------------------------------------------------
        ; $04:
        ; TODO: build option to remove competition number
        .byte   "COMPE", TI, TI, ON, __, NU, "MB", ER, COLON, __end
        .msg_id "COMPETITION_NUMBER"
        
        ; $05:
        .byte   _B0, _6D, __IS__, _6E, _B1, __end
        .msg_id "05"
        
        ; $06:
        .byte   __, __, LOAD_NEW_COMMANDER, __
        .byte   FN_CAPS_ON, "(Y/N)?", FN_CAPS_OFF
        .byte   FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "06"

        ; $07:
        .byte   "P", RE, "SS SPA", CE, __, OR, __, "FI", RE
        .byte   ",", COMMANDER, ".", FN_NEWLINE, FN_NEWLINE, __end
        .msg_id "PRESS_SPACE_OR_FIRE_COMMANDER"
        
        ; $08:
        .byte   COMMANDER, "'S", __NAME_QMARK__, __end
        .msg_id "COMMANDERS_NAME_QMARK"
        
        ; $09:
        .byte   FN_NEWLINE, FN_CAPS_ON
        .byte   IL, LE, "G", AL, " ELITE II FI", LE, __end
        .msg_id "ILLEGAL_FILE"
        
        ; $0A:
        .byte   FN_17, FN_BUFFER_ON, FN_CAPS_OFF, "G", RE, ET, IN, "GS"
        .byte   __COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY
        .byte   __AND__, FN_CAPNEXT, "I", __,  BE, "G", __A__, "MOM", EN, "T"
        .byte   __, "OF", __, YOU, "R", __, "V", AL, "U", AB, LE, __, TI, "ME"
        .byte   NEW_SENTENCE

        .byte   "WE", __, "W", OU, "LD LIKE ", YOU, __TO__, "DO", __A__
        .byte   "L", IT, "T", LE, __, "JOB", __, "F", OR, __, US
        .byte   NEW_SENTENCE

        .byte   THE__, SHIP, __, YOU, __, SE, "E", __, "HE", RE, __IS__
        .byte   "A", __NEW__, "MODEL, ", THE__, FN_CAPNEXT
        .byte   "C", ON, ST, "RICT", OR, ",", __, "E", QU, "IP", ED__
        .byte   "WI", TH, __A__, "TOP", __, SE, "CR", ET, __NEW__, "SHIELD"
        .byte   __, "G", EN, ER, AT, OR, NEW_SENTENCE

        .byte   "UNF", OR, "TUN", AT, "ELY", __, IT, "'S", __, BE, EN, __
        .byte   ST, "OL", EN, NEW_SENTENCE

        .byte   FN_16, IT, __, "W", EN, "T", __, "MISS", ING__, "FROM", __
        .byte   OU, "R", __, SHIP, __, "Y", AR, "D", __, ON, __, FN_CAPNEXT
        .byte   XE, ER, __, "FI", VE, __, "M", ON, TH, "S", __, "AGO", __AND__
        ;       "is believed to have jumped to this galaxy"
        ;       (see msg index $DD)
        .byte   FN_PROTO_GALAXY, NEW_SENTENCE

        .byte   YOU, "R", __, "MISSI", ON, ",", __, "SH", OU, "LD", __, YOU, __
        .byte   "DECIDE", __TO__, "AC", CE, "PT", __, IT, ",", __, "IS", __TO__
        .byte   SE, "EK", __AND__, "D", ES, "TROY", __, THIS__, SHIP
        .byte   NEW_SENTENCE

        .byte   YOU, __, "A", RE, __, "CAU", TI, ON, ED__, TH, AT, __, ON, "LY" 
        ;       TODO: import correct flight token
        .byte   __, FN_FLIGHT_ON, $22, FN_FLIGHT_OFF, "S", __, "W", IL, "L", __
        .byte   "P", EN, ET, RA, "TE", __, THE__, "NEW", __, "SHIELDS", __AND__
        .byte   TH, AT, __, THE__, FN_CAPNEXT, "C", ON, ST, "RICT", OR, __IS__
        .byte   "F", IT, "T", ED__, "WI", TH, __, AN, __
        ;       TODO: import correct flight token
        .byte   FN_FLIGHT_ON, $3b, FN_FLIGHT_OFF

        .byte   _B1, FN_CAPS_OFF, FN_08
        .byte   "GOOD", __, "LUCK,", __, COMMANDER
        .byte   _D4, FN_16, __end
        .msg_id "0A"
        
        ; $0B:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_17, FN_BUFFER_ON, FN_CAPS_OFF, __, __, AT, "T", EN, TI, ON
        .byte   __COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY, ".", __
        .byte   FN_CAPNEXT, "WE", __, "HA", VE, __, "NE", ED__, "OF", __
        .byte   YOU, "R", __, SE, "RVIC", ES, __, "AGA", IN
        .byte   NEW_SENTENCE

        .byte   "IF", __, YOU, __, "W", OU, "LD", __, BE, __, SO, __, "GOOD"
        .byte   __, "AS", __TO__, "GO", __TO__, FN_CAPNEXT, CE, ER, DI, __
        .byte   YOU, __, "W", IL, "L", __, BE, __, "BRIEF", ED, NEW_SENTENCE

        .byte   "IF", __, "SUC", CE, "SSFUL,", __, YOU, __, "W", IL, "L", __
        .byte   BE, __, "WELL", __, RE, "W", AR, "D", ED, _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "0B"

        ;-----------------------------------------------------------------------
        ; $0C:  "(C) D.Braben & I.Bell 1985"
        .byte   "(", FN_CAPNEXT, "C)", __DBRABEN_AND_IBELL, __, "1985", __end
        .msg
        
        ; $0D:  "by D.Braben & I.Bell"
        .byte   "BY", __DBRABEN_AND_IBELL, __end
        .msg_id "BY_DBRABEN_AND_IBELL"

        ; $0E:
        .byte   FN_15, PLANET, __NAME_QMARK__, FN_1A, __end
        .msg_id "PLANET_NAME_QMARK"

        ; $0F:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_17, FN_BUFFER_ON
        .byte   FN_CAPS_OFF, __, __, "C", ON, "G", RA, "TU", LA, TI, ON, "S", __
        .byte   COMMANDER, "!", FN_NEWLINE, FN_NEWLINE

        .byte   TH, ER, "E", FN_0D, __, "W", IL, "L", __, AL, "WAYS", __
        .byte   BE, __A__, "P", LA, CE, __, "F", OR, __, YOU, __, IN
        .byte   HER_MAJESTYS_SPACE_NAVY, NEW_SENTENCE

        .byte   AN, "D", __, MA, "Y", BE, __, SO, ON, ER, __, TH, AN, __
        .byte   YOU, __, TH, IN, "K..", _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "CONGRATULATIONS"

        ;-----------------------------------------------------------------------
        ; $10:  "fabled"
        .byte   "F", AB, LE, "D", __end
        .msg_id "FABLED"

        ; $11:  "notable"
        .byte   NO, "T", AB, LE, __end
        .msg

        ; $12:  "well known"
        .byte   "WELL", __, "K", NO, "WN", __end
        .msg

        ; $13:  "famous"
        .byte   "FAMO", US, __end
        .msg

        ; $14:  "noted"
        .byte   NO, "T", ED, __end
        .msg

        ;-----------------------------------------------------------------------
        ; $15:  "very"
        .byte   VE, "RY", __end
        .msg_id "VERY"

        ; $16:  "mildly"
        .byte   "M", IL, "DLY", __end
        .msg

        ; $17:  "most"
        .byte   "MO", ST, __end
        .msg

        ; $18:  "reasonably"
        .byte   RE, "AS", ON, AB, "LY", __end
        .msg

        ; $19:  ""
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $1A:  "ancient"
        .byte   ANCIENT, __end
        .msg_id "1A"

        ; $1B:  "funny" / "weird" / "unusual" / "peculiar"
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __end
        .msg

        ; $1C:  "great"
        .byte   "G", RE, AT, __end
        .msg
        
        ; $1D:  "vast"
        .byte   "VA", ST, __end
        .msg

        ; $1E:  "pink"
        .byte   "P", IN, "K", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $1F:
        .byte   FN_CAPS_OFF, _77, __, RANDOM_PLANT, FN_0D, __
        .byte   PLANT, "A", TI, ON, "S", __end
        .msg_id "PLANTATIONS"

        ; $20:  "mountains"
        .byte   MOUNTAIN, "S", __end
        .msg

        ; $21:  "parking meters" / "dust clouds" / "ice bergs",
        ;       "rock formations" / "volcanoes"
        .byte   PARKINGMETERS_DUSTCLOUDS_ICEBERGS_ROCKFORMATIONS_VOLCANOES
        .byte   __end
        .msg
        
        ; $22:
        .byte   RANDOM_CLIMATE, __, "F", OR, ES, "TS", __end
        .msg
        
        ; $23:  "oceans"
        .byte   "O", CE, AN, "S", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $24:  "shyness"
        .byte   "SHYN", ES, "S", __end
        .msg_id "SHYNESS"
        
        ; $25:  "silliness"
        .byte   "S", IL, "L", IN, ES, "S", __end
        .msg
        
        ; $26:  "mating traditions"
        .byte   MA, "T", ING__, "T", RA, DI, TI, ON, "S", __end
        .msg
        
        ; $27:  "loathing of ", <"food blenders", "tourists", "poetry",
        ;       "discos", <?>>
        .byte   LO, AT, "H", ING__, "OF", __, _64, __end
        .msg
        
        ; $28:  "love for ", <"food blenders" / "tourists" / "poetry" /
        ;       "discos" / <?>>
        .byte   LO, VE, __, "F", OR, __, _64, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $29:  "food blenders"
        .byte   "FOOD", __, "B", LE, "ND", ER, "S", __end
        .msg_id "FOOD_BLENDERS"
        
        ; $2A:  "tourists"
        .byte   "T", OU, "RI", ST, "S", __end
        .msg
        
        ; $2B:  "poetry"
        .byte   "PO", ET, "RY", __end
        .msg
        
        ; $2C:  "discos"
        .byte   DI, "SCOS", __end
        .msg
        
        ; $2D:  "cuisine" / "night life" / "casinos" / "sit coms" / ...?
        .byte   CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $2E:  "walking tree"
        .byte   "W", AL, "K", ING__, TREE, __end
        .msg_id "WALKING_TREE"
        
        ; $2F:  "crab"
        .byte   "C", RA, "B", __end
        .msg
        
        ; $30:  "bat"
        .byte   "B", AT, __end
        .msg
        
        ; $31:  "lobst"
        .byte   LO, "B", ST, __end
        .msg
        
        ; $32:  <random-name>
        .byte   FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $33:  "beset"
        .byte   BE, "S", ET, __end
        .msg_id "BESET"
        
        ; $34:  "plagued"
        .byte   "P", LA, "GU", ED, __end
        .msg
        
        ; $35:  "ravaged"
        .byte   RA, "VAG", ED, __end
        .msg
        
        ; $36:  "cursed"
        .byte   "CURS", ED, __end
        .msg
        
        ; $37:  "scourged"
        .byte   "SC", OU, "RG", ED, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $38:
        .byte   _71, __, "CIV", IL, __, "W", AR, __end
        .msg_id "38"
        
        ; $39:
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __
        .byte   KILLER_ETC_MOUNTAIN_EDIBLE_TREE_SPOTTED, __
        .byte   RANDOM_ANIMAL, _S
        .byte   __end
        .msg
        
        ; $3A:  "a ", <"killer" / "deadly" / "evil" / "lethal" / "vicious">,
        ;       " disease"
        .byte   "A", __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __
        .byte   DI, SE, "A", SE, __end
        .msg
        
        ; $3B:
        .byte   _71, __, "E", AR, TH, QU, "AK", ES, __end
        .msg
        
        ; $3C:
        .byte   _71, __, SO, LA, "R", __
        .byte   "AC", TI, "V", IT, _Y, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $3D:  "its ", <"ancient" / "funny" / "weird" / "strange" /
        ;       "peculiar" / "great" / "vast" / "pink">, " ", ...
        .byte   ITS__
        .byte   ANCIENT_FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR_GREAT_VAST_PINK
        .byte   __, RANDOM_GEOGRAPHY, __end
        .msg_id "3D"
        
        ; $3E:  "the ", <target-system>-"ian", <"deadly" / "evil" / "lethal" /
        ;       "vicious" / "mountain" / "edible" / "tree" / "spotted">, ... 
        .byte   THE__, FN_TARGET_SYSTEM_IAN, __
        .byte   KILLER_ETC_MOUNTAIN_EDIBLE_TREE_SPOTTED, __
        .byte   RANDOM_ANIMAL, __end
        .msg
        
        ; $3F:  "its inhabitant's ", <"ancient" / "exceptional" / "eccentric" /
        ;       "ingrained" / "funny" / "weird" / "unusual" / "strange" /
        ;       "peculiar">, ...
        .byte   ITS__, INHABITANT, "S'", __
        .byte   ANCIENT_EXCEPTIONAL_ECCENTRIC_INGRAINED_ETC, __
        .byte   _63, __end
        .msg
        
        ; $40:
        .byte   FN_CAPS_OFF, _7A, FN_0D, __end
        .msg
        
        ; $41:
        .byte   ITS__, FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING, __
        .byte   CUISINE_NIGHTLIFE_CASINOS_SITCOMS_ETC
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $42:  "juice"
        .byte   "JUI", CE, __end
        .msg_id "JUICE"
        
        ; $43:  "brandy"
        .byte   "B", RA, "NDY", __end
        .msg
        
        ; $44:  "water"
        .byte   "W", AT, ER, __end
        .msg
        
        ; $45:  "brew"
        .byte   "B", RE, "W", __end
        .msg
        
        ; $46:  "gargle blasters"
        .byte   "G", AR, "G", LE, __, "B", LA, ST, ER, "S", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $47:  <random-name>
        .byte   FN_RANDOM_NAME, __end
        .msg_id "47"
        
        ; $48:  <target-system>-"ian", ...
        .byte   FN_TARGET_SYSTEM_IAN, __, RANDOM_ANIMAL, __end
        .msg
        
        ; $49:  <target-system>-"ian", <random-name>
        .byte   FN_TARGET_SYSTEM_IAN, __, FN_RANDOM_NAME, __end
        .msg
        
        ; $4A:  <target-system>-"ian", <"killer" / "deadly" / "evil" /
        ;       "lethal" / "vicious">
        .byte   FN_TARGET_SYSTEM_IAN, __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS
        .byte   __end
        .msg
        
        ; $4B:  "killer" / "deadly" / "evil" / "lethal" / "vicious",
        ;       <random-name>
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __, FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $4C:  "fabulous"
        .byte   "F", AB, "U", LO, US, __end
        .msg_id "FABULOUS"
        
        ; $4D:  "exotic"
        .byte   "EXO", TI, "C", __end
        .msg
        
        ; $4E:  "hoopy"
        .byte   "HOOPY", __end
        .msg
        
        ; $4F:  "unusual"
        .byte   "U", NU, "SU", AL, __end
        .msg
        
        ; $50:  "exciting"
        .byte   "EXC", IT, IN, "G", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $51:  "cuisine"
        .byte   "CUIS", IN, "E", __end
        .msg_id "CUISINE"
        
        ; $52:  "night life"
        .byte   "NIGHT", __, "LIFE", __end
        .msg
        
        ; $53:  "casinos"
        .byte   "CASI", NO, "S", __end
        .msg
        
        ; $54:  "sit coms"
        .byte   "S", IT, __, "COMS", __end
        .msg
        
        ; $55:
        .byte   FN_CAPS_OFF, _7A, FN_0D, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $56:  <target-system>
        .byte   FN_TARGET_SYSTEM, __end
        .msg_id "56"
        
        ; $57:  "the planet ", <target-system>
        .byte   THE__, PLANET, __, FN_TARGET_SYSTEM, __end
        .msg
        
        ; $58:  "the world", <target-system>
        .byte   THE__, WORLD, __, FN_TARGET_SYSTEM, __end
        .msg
        
        ; $59:  "this planet"
        .byte   THIS__, PLANET, __end
        .msg
        
        ; $5A:  "this world"
        .byte   THIS__, WORLD, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $5B:  "son of a bitch"
        .byte   "S", ON, __, "OF", __A__, "B", IT, "CH", __end
        .msg_id "INSULTS"
        
        ; $5C:  "scoundrel"
        .byte   "SC", OU, "ND", RE, "L", __end
        .msg

        ; $5D:  "blackguard"
        .byte   "B", LA, "CKGU", AR, "D", __end
        .msg

        ; $5E:  "rogue"
        .byte   "ROGUE", __end
        .msg
        
        ; $5F:  "whoreson beetle headed flap ear'd knave"
        .byte   "WH", OR, ES, ON, __, BE, ET, LE, __, "HEAD", ED__
        .byte   "F", LA, "P", __, "E", AR, "'D", __, "KNA", VE, __end
        .msg

        ;-----------------------------------------------------------------------
        ; $60:  "n unremarkable"
        ; NOTE: the "n" is included so that "A" becomes "An" for this entry,
        ;       and remains as "A" for the other four
        .byte   _N, __, "UN", RE, MA, "RK", AB, LE, __end
        .msg_id "UNREMARKABLE"

        ; $61:  " boring"
        .byte   __, "B", OR, IN, "G", __end
        .msg
        
        ; $62:  " dull"
        .byte   __, "DULL", __end
        .msg
        
        ; $63:  " tedious"
        .byte   __, "TE", DI, "O", US, __end
        .msg
        
        ; $64:  " revolting"
        .byte   __, RE, "VOLT", IN, "G", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $65:  "planet"
        .byte   PLANET, __end
        .msg_id "PLANET_SYNONYMS"

        ; $66:  "world"
        .byte   WORLD, __end
        .msg

        ; $67:  "place"
        .byte   "P", LA, CE, __end
        .msg
        
        ; $68:  "little planet"
        .byte   "L", IT, "T", LE, __, PLANET, __end
        .msg
        
        ; $69:  "dump"
        .byte   "DUMP", __end
        .msg
        
        ; hints on finding the prototype ship:
        ;-----------------------------------------------------------------------
        ; $6A:  "i hear a ", <"funny" / "weird" / "unusual" / "strange" /
        ;       "peculiar">, " looking ship appeared at errius"
        .byte   "I", __, "HE", AR, __A__, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR
        ;       TODO: should Errius be capitalised?
        .byte   __, LO, "OK", ING__, SHIP, __, "APPE", AR, ED__, AT, __ERRIUS
        .byte   __end
        .msg_id "PROTO_HINTS"

        ; $6B:  "yeah, i hear a ", <"funny"  / "weird" / "unusual" /
        ;       "strange" / "peculiar">, " ship left errius a while back"
        .byte   "YEAH,", __, "I", __, "HE", AR, __A__
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __, SHIP, __
        .byte   LE, "FT", __ERRIUS, __A__, __, "WHI", LE, __
        .byte   "BACK", __end
        .msg
        
        ; $6C:  "get your iron ass over to errius"
        .byte   "G", ET, __, YOU, _R, __, "IR", ON, __, "ASS", __
        .byte   "OV", ER, __, "TO", __ERRIUS, __end
        .msg
        
        ; $6D:  "some ", <"son of a bitch" / "scoundrel" / "blackguard" /
        ;       "rogue" / "whoreson beetle headed flap ear'd knave">,
        ;       " new ship was seen at errius"
        .byte   SO, "ME", __, RANDOM_INSULT, __NEW__, SHIP, __
        .byte   "WAS", __, SE, EN, __, AT, __ERRIUS, __end
        .msg
        
        ; $6E:  "try errius"
        .byte   "TRY", __ERRIUS, __end
        .msg
        
        ; Trumble™ descriptions?
        ;-----------------------------------------------------------------------
        ; $6F:  " cuddly"
        .byte   __, "CUDDLY", __end
        .msg_id "CUDDLY"
        
        ; $70:  " cute"
        .byte   __, "CUTE", __end
        .msg
        
        ; $71:  " furry"
        .byte   __, "FURRY", __end
        .msg
        
        ; $72:  " friendly"
        .byte   __, "FRI", EN, "DLY", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $73:  "wasp"
        .byte   "WASP", __end
        .msg_id "WASP"
        
        ; $74:  "moth"
        .byte   "MO", TH, __end
        .msg
        
        ; $75:  "grub"
        .byte   "GRUB", __end
        .msg
        
        ; $76:  "ant"
        .byte   AN, "T", __end
        .msg
        
        ; $77:  <random-name>
        .byte   FN_RANDOM_NAME, __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $78:  "poet"
        .byte   "PO", ET, __end
        .msg_id "POET"
        
        ; $79:  "arts graduate"
        .byte   AR, "TS", __, "G", RA, "DU", AT, "E", __end
        .msg
        
        ; $7A:  "yak"
        .byte   "YAK", __end
        .msg
        
        ; $7B:  "snail"
        .byte   "SNA", IL, __end
        .msg
        
        ; $7C:  "slug"
        .byte   "SLUG", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $7D:  "tropical"
        .byte   "TROPIC", AL, __end
        .msg_id "TROPICAL"
        
        ; $7E:  "dense"
        .byte   "D", EN, SE, __end
        .msg
        
        ; $7F:  "rain"
        .byte   RA, IN, __end
        .msg
        
        ; $80:  "impenetrable"
        .byte   "IMP", EN, ET, RA, "B", LE, __end
        .msg
        
        ; message indices $81..$D6 are expandable via tokens $81..$D6
        ;
        ; TODO: define a constant for this barrier -- if we add or remove
        ;       messages, then the code needs to update CMP checks
        ; 
        ; $81:  "exuberant"
        .byte   "EXU", BE, RA, "NT", __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $82:  "funny"
        .byte   "FUNNY", __end
        .msg_id "FUNNY"
        .tkn
        
        ; $83:  "weird"
        .byte   "WEIRD", __end
        .msg
        .tkn
        
        ; $84:  "unusual"
        .byte   "U", NU, "SU", AL, __end
        .msg
        .tkn
        
        ; $85:  "strange"
        .byte   ST, RA, "N", GE, __end
        .msg
        .tkn
        
        ; $86:  "peculiar"
        .byte   "PECULI", AR, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $87:  "frequent"
        .byte   "F", RE, QU, EN, "T", __end
        .msg
        .tkn
        
        ; $88:  "occasional"
        .byte   "OCCASI", ON, AL, __end
        .msg
        .tkn
        
        ; $89:  "unpredictable"
        .byte   "UNP", RE, DI, "CT", AB, LE, __end
        .msg
        .tkn
        
        ; $8A:  "dreadful"
        .byte   "D", RE, "ADFUL", __end
        .msg
        .tkn
        
        ; $8B:  "deadly"
        .byte   DEADLY, __end
        .msg
        .tkn

        ;-----------------------------------------------------------------------
        ; $8C:  <"very" / "mildly" / "most" / "reasonably" / "">, <"fabled" /
        ;       "notable" / "well known" / "famous" / "noted">, " for ", ...
        .byte   VERY_MILDLY_MOST_REASONABLY, __
        .byte   FABLED_NOTABLE_WELLKNOWN_FAMOUS_NOTED, __
        .byte   "F", OR, __, _65, __end
        .msg_id "8C"
        .tkn_id "_8C"
        
        ; $8D:
        .byte   _8C, __AND__, _65, __end
        .msg
        .tkn
        
        ; $8E:  <"beset" / "plagued" / "ravaged" / "cursed" / "scourged">,
        ;       " by ", ...?
        .byte   BESET_PLAGUED_RAVAGED_CURSED_SCOURGED, __, "BY", __
        .byte   _67, __end
        .msg
        .tkn_id "_8E"
        
        ; $8F:
        .byte   _8C, __, "BUT", __, _8E, __end
        .msg_id "8F"
        .tkn
        
        ; $90:  " a ", <"unremarkable" / "boring" / "dull" / "tedious" /
        ;       "revolting">, " ", <"planet" / "world" / "place" /
        ;       "little planet" / "dump">
        .byte   __, "A", UNREMARKABLE_BORING_DULL_TEDIOUS_REVOLTING, __
        .byte   PLANET_WORLD_PLACE_LITTLEPLANET_DUMP, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $91:  "planet"
        .byte   "PL", AN, ET, __end
        .msg
        .tkn_id "PLANET"

        ; $92:  "world"
        .byte   "W", OR, "LD", __end
        .msg
        .tkn_id "WORLD"

        ; $93:  "the "
        .byte   TH, "E", __, __end
        .msg
        .tkn_id "THE__"

        ; $94:  "this "
        .byte   TH, "IS", __, __end
        .msg
        .tkn_id "THIS__"

        ; $95:  "load new Commander"
        .byte   LO, "AD", __NEW__, COMMANDER, __end
        .msg
        .tkn_id "LOAD_NEW_COMMANDER"

        ; $96:
        .byte   FN_CLEAR_SCREEN, FN_DIVIDER, FN_CAPS_ON, FN_08, __end
        .msg
        .tkn

        ; $97:  "drive"
        .byte   "DRI", VE, __end
        .msg
        .tkn

        ; $98:  " catalogue"
        .byte   __, "C", AT, "A", LO, "GUE", __end
        .msg
        .tkn
        
        ; $99:  -"ian" (suffix)
        .byte   "I", AN, __end
        .msg_id "IAN"
        .tkn

        ; $9A:  "Commander"
        .byte   FN_CAPNEXT, "COMM", AN, "D", ER, __end
        .msg
        .tkn_id "COMMANDER"

        ;-----------------------------------------------------------------------
        ; $9B:  "killer" / "deadly" / "evil" / "lethal" / "vicious"
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __end
        .msg_id "KILLER_DEADLY_EVIL_LETHAL_VICIOUS"
        .tkn

        ; $9C:  "mountain"
        .byte   "M", OU, "NTA", IN, __end
        .msg
        .tkn_id "MOUNTAIN"

        ; $9D:  "edible"
        .byte   ED, "IB", LE, __end
        .msg
        .tkn
        
        ; $9E:  "tree"
        .byte   "T", RE, "E", __end
        .msg
        .tkn_id "TREE"

        ; $9F:  "spotted"
        .byte   "SPOTT", ED, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $A0:  "shrew" / "beast" / "bison" / "snake" / "wolf"
        .byte   SHREW_BEAST_BISON_SNAKE_WOLF, __end
        .msg_id "A0"
        .tkn

        ; $A1:  "leopard" / "cat" / "monkey" / "goat" / "fish"
        .byte   LEOPARD_CAT_MONKEY_GOAT_FISH, __end
        .msg
        .tkn
        
        ; $A2:  "walking treeoid" / "craboid" / "lobstoid" /
        ;       <random-name>-"oid"
        .byte   WALKINGTREE_CRAB_BAT_LOBST_RANDOMNAME, "OID", __end
        .msg
        .tkn
        
        ; $A3:  "poet" / "arts graduate" / "yak" / "snail" / "slug"
        .byte   POET_ARTSGRADUATE_YAK_SNAIL_SLUG, __end
        .msg
        .tkn
        
        ; $A4:  "wasp" / "moth" / "grub" / "ant" / <random-name>
        .byte   RANDOM_PEST, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $A5:  "ancient"
        .byte   AN, "CI", EN, "T", __end
        .msg_id "ANCIENT"
        .tkn_id "ANCIENT"
        
        ; $A6:  "exceptional"
        .byte   "EX", CE, "P", TI, ON, AL, __end
        .msg
        .tkn
        
        ; $A7:  "eccentric"
        .byte   "EC", CE, "NTRIC", __end
        .msg
        .tkn
        
        ; $A8:  "ingrained"
        .byte   IN, "G", RA, IN, ED, __end
        .msg
        .tkn
        
        ; $A9:  "funny" / "weird" / "unusual" / "strange" / "peculiar"
        .byte   FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $AA:  "killer"
        .byte   "K", IL, "L", ER, __end
        .msg_id "KILLER"
        .tkn

        ; $AB:  "deadly"
        .byte   "DEADLY", __end
        .msg
        .tkn_id "DEADLY"

        ; $AC:  "evil"
        .byte   "EV", IL, __end
        .msg
        .tkn
        
        ; $AD:  "lethal"
        .byte   LE, TH, AL, __end
        .msg
        .tkn
        
        ; $AE:  "vicious"
        .byte   "VICIO", US, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $AF:  "its "
        .byte   IT, "S", __, __end
        .msg
        .tkn_id "ITS__"

        ; $B0:
        .byte   FN_0D, FN_BUFFER_ON, FN_CAPNEXT, __end
        .msg
        .tkn_id "_B0"

        ; $B1:
        .byte   ".", FN_NEWLINE, FN_BUFFER_OFF, __end
        .msg_id "B1"
        .tkn_id "_B1"

        ; $B2:  " and "
        .byte   __, AN, "D", __, __end
        .msg
        .tkn_id "__AND__"

        ; $B3:  "you"
        .byte   "Y", OU, __end
        .msg
        .tkn_id "YOU"

        ;-----------------------------------------------------------------------
        ; $B4:  "parking meters"
        .byte   "P", AR, "K", ING__, "M", ET, ER, "S", __end
        .msg_id "PARKING_METERS"
        .tkn

        ; $B5:  "dust clouds"
        .byte   "D", US, "T", __, "C", LO, "UDS", __end
        .msg
        .tkn
        
        ; $B6:  "ice bergs"
        .byte   "I", CE, __, BE, "RGS", __end
        .msg
        .tkn
        
        ; $B7:  "rock formations"
        .byte   "ROCK", __, "F", OR, MA, TI, ON, "S", __end
        .msg
        .tkn
        
        ; $B8:  "volcanoes"
        .byte   "VOLCA", NO, ES, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $B9:  "plant"
        .byte   "PL", AN, "T", __end
        .msg_id "PLANT"
        .tkn_id "PLANT"

        ; $BA:  "tulip"
        .byte   "TULIP", __end
        .msg
        .tkn
        
        ; $BB:  "banana"
        .byte   "B", AN, AN, "A", __end
        .msg
        .tkn
        
        ; $BC:  "corn"
        .byte   "C", OR, "N", __end
        .msg
        .tkn
        
        ; $BD:  <random-name>, "weed"
        .byte   FN_RANDOM_NAME, "WE", ED, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $BE:  <random-name>
        .byte   FN_RANDOM_NAME, __end
        .msg_id "BE"
        .tkn

        ; $BF:  <target-system>-"ian", <random-name>
        .byte   FN_TARGET_SYSTEM_IAN, __, FN_RANDOM_NAME, __end
        .msg
        .tkn_id "_BF"
        
        ; $C0:  <target-system>-"ian", <"killer" / "deadly" / "evil" /
        ;       "lethal" / "vicious">
        .byte   FN_TARGET_SYSTEM_IAN, __, KILLER_DEADLY_EVIL_LETHAL_VICIOUS
        .byte   __end
        .msg
        .tkn
        
        ; $C1:  "inhabitant"
        .byte   IN, "HA", BI, "T", AN, "T", __end
        .msg
        .tkn_id "INHABITANT"
        
        ; $C2:
        .byte   _BF, __end
        .msg
        .tkn
        
        ;-----------------------------------------------------------------------
        ; $C3:  "ing "
        .byte   IN, "G", __, __end
        .msg
        .tkn_id "ING__"

        ; $C4:  "ed "
        .byte   ED, __, __end
        .msg
        .tkn_id "ED__"

        ; $C5:  " d.braben & i.bell"
        .byte   __, "D.B", RA, BE, "N", __, "&", __, "I.", BE, "LL", __end
        .msg
        .tkn_id "__DBRABEN_AND_IBELL"

        ; $C6:  " little trumble"
        .byte   __, "L", IT, "T", LE, __, "TRUMB", LE, __end
        .msg_id "LITTLE_TRUMBLE"
        .tkn

        ; $C7:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN, FN_1D
        .byte   FN_BUFFER_ON, FN_CAPNEXT, "GOOD", FN_0D, __, "DAY", __
        .byte   COMMANDER, __, FN_YOUR_NAME, ",", __, AL, LO, "W", __, "ME"
        .byte   __TO__, IN, "TRODU", CE, __, "MY", SE, "LF.", __, FN_CAPNEXT
        .byte   "I", __, "AM", FN_CAPS_OFF, __, THE__, "M", ER, "CH", AN, "T"
        .byte   __, "PR", IN, CE, __, "OF", __, TH, "RUN", FN_0D, __AND__
        .byte   FN_CAPNEXT, "I", __, "F", IN, "D", __, "MY", SE, "LF", __
        .byte   "F", OR, CE, "D", __TO__, SE, "LL", __, "MY", __, "MO", ST, __
        .byte   "T", RE, "ASUR", ED, __, "POSS", ES, "SI", ON, NEW_SENTENCE

        .byte   "I", __, "AM", __, "OFF", ER, ING__, "Y", OU, ",", __, "F", OR
        .byte   __, THE__, "PALTRY", __, "SUM", __, "OF", __, "JU", ST, __
        .byte   "5000", FN_CAPNEXT, "C", FN_CAPNEXT, "R", __, THE__, RA, RE, ST
        .byte   __, TH, ING__, __, IN, __, THE__, FN_CAPS_OFF, "K", NO, "WN", __
        .byte   "UNI", VE, "R", SE, NEW_SENTENCE
        
        .byte   FN_0D, "W", IL, "L", __, "Y", OU, __, "TAKE", __, IT
        .byte   FN_CAPS_ON, "(Y/N)?", FN_NEWLINE, FN_BUFFER_OFF
        .byte   FN_CAPS_ON, FN_08
        .byte   __end
        .msg_id "MISSION_TRUMBLES"
        .tkn

        ; $C8:  " name? "
        .byte   __, "NAME?", __
        .byte   __end
        .msg
        .tkn_id "__NAME_QMARK__"

        ; $C9:  " to "
        .byte   __, "TO", __, __end
        .msg
        .tkn_id "__TO__"

        ; $CA:  " is "
        .byte   __, "IS", __, __end
        .msg
        .tkn_id "__IS__"

        ; $CB:  "was last seen at "
        .byte   "WAS", __, LA, ST, __, SE, EN, __, AT, __
        .byte   FN_CAPNEXT, __end
        .msg
        .tkn_id "WAS_LAST_SEEN_AT__"

        ; $CC:  new sentence -- fullstop, new line, captialise next letter
        .byte   ".", FN_NEWLINE, __, FN_CAPNEXT
        .byte   __end
        .msg
        .tkn_id "NEW_SENTENCE"

        ; $CD:  "docked"
        .byte   "DOCK", ED, __end
        .msg_id "DOCKED"
        .tkn

        ; $CE:  "(Y/N)?"
        .byte   FN_CAPS_ON, "(Y/N)?", __end
        .msg_id "YES_OR_NO"
        .tkn

        ; $CF:  "ship"
        .byte   "SHIP", __end
        .msg
        .tkn_id "SHIP"

        ; $D0:  " a "
        .byte   __, "A", __, __end
        .msg
        .tkn_id "__A__"

        ; $D1:  " errius"
        .byte   __, ER, "RI", US, __end
        .msg
        .tkn_id "__ERRIUS"

        ; $D2:  " new "
        .byte   __, "NEW", __, __end
        .msg
        .tkn_id "__NEW__"

        ; $D3:
        .byte   FN_CAPS_OFF, __, "H", ER, __, MA, "J", ES, "TY'S", __
        .byte   "SPA", CE, __, "NAVY", FN_0D, __end
        .msg
        .tkn_id "HER_MAJESTYS_SPACE_NAVY"

        ; $D4:
        .byte   _B1, FN_08, FN_CAPS_ON, __, __
        .byte   "M", ES, "SA", GE, __, EN, "DS"
        .byte   __end
        .msg
        .tkn_id "_D4"

        ; $D5:
        .byte   __, COMMANDER, __, FN_YOUR_NAME, ",", __, "I", __, FN_0D, "AM"
        .byte   FN_CAPS_OFF, __, "CAPTA", IN, __, FN_THEIR_NAME, __
        .byte   FN_0D, "OF", HER_MAJESTYS_SPACE_NAVY, __end
        .msg
        .tkn_id "__COMMANDER_I_AM_CAPTAIN_OF_HER_MAJESTYS_SPACE_NAVY"

        ; $D6:
        .byte   __end
        .msg
        .tkn

        ;-----------------------------------------------------------------------
        ; $D7:  "unknown planet"
        .byte   FN_BUFFER_OFF, __, "UNK", NO, "WN", __, PLANET, __end
        .msg_id "UNKNOWN_PLANET"
        
        ; $D8:
        .byte   FN_CLEAR_SCREEN, FN_08, FN_17, FN_CAPS_ON, __
        .byte   IN, "COM", ING__, "M", ES, "SA", GE, __end
        .msg_id "INCOMING_MESSAGE"
        
        ; the names of NPCs; selected by galaxy number
        ;----------------------------------------------------------------------
        ; $D9:  "curruthers"
        .byte   "CURRU", TH, ER, "S", __end
        .msg_id "CURRUTHERS"
        
        ; $DA:  "fosdyke smythe"
        .byte   "FOSDYKE", __, "SMY", TH, "E", __end
        .msg
        
        ; $DB:  "fortesque"
        .byte   "F", OR, "T", ES, QU, "E", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $DC:  "was last seen at Reesdice"
        ;       NOTE: "WAS_LAST_SEEN_AT__" ends with `FN_CAPNEXT`
        .byte   WAS_LAST_SEEN_AT__, RE, ES, DI, CE, __end
        .msg
        
        ; $DD:  NOTE: this gets printed by docked token function $1C,
        ;       which adds the galaxy number to index $DC; it was probably
        ;       intended to chase the prototype ship across multiple galaxies,
        ;       but this idea appears to have been scrapped
        .byte   "IS", __, BE, "LIEV", ED, __TO__, "HA", VE, __, "JUMP", ED
        .byte   __TO__, THIS__, "G", AL, "AXY", __end
        .msg_id "IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY"
        
        ;-----------------------------------------------------------------------
        ; $DE:
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_1D, FN_BUFFER_ON, FN_CAPS_OFF
        .byte   "GOOD", __, "DAY", __, COMMANDER, __
        .byte   FN_YOUR_NAME, NEW_SENTENCE

        .byte   "I", FN_0D, __, "AM", __, FN_CAPNEXT, "AG", EN, "T", __
        .byte   FN_CAPNEXT, "B", LA, "KE", __, "OF", __, FN_CAPNEXT
        .byte   "NAV", AL, __, FN_CAPNEXT, IN, "TEL", LE, "G", EN, CE
        .byte   NEW_SENTENCE
        
        .byte   "AS", __, YOU, __, "K", NO, "W,", __, THE__, FN_CAPNEXT
        .byte   "NAVY", __, "HA", VE, __, BE, EN, __, "KEEP", ING__, THE__
        .byte   FN_CAPNEXT, TH, AR, "GOIDS", __, "OFF", __, YOU, "R", __
        .byte   "ASS", __, OU, "T", __, IN, __, "DEEP", __, "SPA", CE, __
        .byte   "F", OR, __, MA, "NY", __, "YE", AR, "S", __, NO, "W.", __
        .byte   FN_CAPNEXT, "WELL", __, THE__, "S", IT, "UA", TI, ON, __
        .byte   "HAS", __, "CH", AN, "G", ED, NEW_SENTENCE

        .byte   OU, "R", __, "BOYS", __, AR, "E", __, RE, "ADY", __, "F", OR
        .byte   __A__, "PUSH", __, "RIGHT", __TO__, THE__, "HOME", __
        .byte   "SYSTEM", __, _O, _F, __, TH, "O", SE, __, "MURD", ER, ER, "S"
        .byte   NEW_SENTENCE

        .byte   FN_WAIT_FOR_KEY, FN_CLEAR_SCREEN, FN_1D
        .byte   "I", FN_0D, __, "HA", VE, __, "OBTA", IN, ED__, THE__
        .byte   "DEF", EN, CE, __, "P", LA, "NS", __, "F", OR, __, TH, "EIR"
        .byte   __, FN_CAPNEXT, "HI", VE, __, FN_CAPNEXT, "W", OR, "LDS"
        .byte   NEW_SENTENCE

        .byte   THE__, BE, ET, LE, "S", __, "K", NO, "W", __, "WE'", VE, __
        .byte   "GOT", __, SO, "ME", TH, ING__, "BUT", __, NO, "T", __
        .byte   "WH", AT, NEW_SENTENCE

        .byte   "IF", __, FN_CAPNEXT, "I", __, "T", RA, "NSM", IT, __, THE__
        .byte   "P", LA, "NS", __TO__, OU, "R", __, "BA", SE, __, ON, __
        .byte   FN_CAPNEXT, BI, RE, RA, __, TH, "EY'LL", __
        .byte   IN, "T", ER, CE, "PT", __, THE__, "TR", AN, "SMISSI", ON, "."
        .byte   __, FN_CAPNEXT, "I", __, "NE", ED, __A__, SHIP, __TO__
        .byte   MA, "KE", __, THE__, "RUN", NEW_SENTENCE

        .byte   YOU, "'", RE, __, "E", LE, "CT", ED, NEW_SENTENCE
        
        .byte   THE__, "P", LA, "NS", __, "A", RE, __, "UNIPUL", SE, __
        .byte   "COD", ED__, "WI", TH, IN, __, THIS__, "TR", AN, "SMISSI", ON
        .byte   NEW_SENTENCE

        .byte   FN_08, YOU, __, "W", IL, "L", __, BE, __, "PAID"
        .byte   NEW_SENTENCE
        
        .byte   __, __, __, __, FN_CAPNEXT, "GOOD", __, "LUCK", __, COMMANDER
        .byte   _D4, FN_WAIT_FOR_KEY, __end
        .msg_id "DE"
        
        ; $DF:  
        .byte   FN_INCOMING_MESSAGE, FN_CLEAR_SCREEN
        .byte   FN_1D, FN_08, FN_BUFFER_ON, FN_0D, FN_CAPNEXT
        .byte   "WELL", __, "D", ON, "E", __, COMMANDER, NEW_SENTENCE
        
        .byte   YOU, __, "HA", VE, __, SE, "RV", ED__, "US", __, "WELL"
        .byte   __AND__, "WE", __, "SH", AL, "L", __, RE, "MEMB", ER
        .byte   NEW_SENTENCE

        .byte   "WE", __, "DID", __, NO, "T", __, "EXPECT", __, THE__
        .byte   FN_CAPNEXT, TH, AR, "GOIDS", __TO__, "F", IN, "D", __
        .byte   OU, "T", __, "AB", OU, "T", __, YOU, NEW_SENTENCE

        .byte   "F", OR, __, THE__, "MOM", EN, "T", __, "P", LE, "A", SE
        .byte   __, "AC", CE, "PT", __, THIS__, FN_CAPNEXT, "NAVY", __
        ;       TODO: import correct flight token
        .byte   FN_FLIGHT_ON, $25, FN_FLIGHT_OFF, __
        .byte   "AS", __, "PAYM", EN, "T", _D4
        .byte   FN_WAIT_FOR_KEY, __end
        .msg_id "DF"
        
        ;-----------------------------------------------------------------------
        ; $E0:  "are you sure?"
        .byte   "A", RE, __, YOU, __, "SU", RE, "?", __end
        .msg_id "ARE_YOU_SURE"
        
        ;-----------------------------------------------------------------------
        ; $E1:  "shrew"
        .byte   "SH", RE, "W", __end
        .msg_id "SHREW"
        
        ; $E2:  "beast"
        .byte   BE, "A", ST, __end
        .msg
        
        ; $E3:  "bison"
        .byte   "BIS", ON, __end
        .msg
        
        ; $E4:  "snake"
        .byte   "SNAKE", __end
        .msg
        
        ; $E5:  "wolf"
        .byte   "WOLF", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $E6:  "leopard"
        .byte   LE, "OP", AR, "D", __end
        .msg_id "LEOPARD"
        
        ; $E7:  "cat"
        .byte   "C", AT, __end
        .msg
        
        ; $E8:  "monkey"
        .byte   "M", ON, "KEY", __end
        .msg
        
        ; $E9:  "goat"
        .byte   "GO", AT, __end
        .msg
        
        ; $EA:  "fish"
        .byte   "FISH", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $EB:  
        .byte   _6A, __, RANDOM_DRINK
        .byte   __end
        .msg_id "EB"
        
        ; $EC:
        .byte   FN_TARGET_SYSTEM_IAN, __, SHREW_BEAST_BISON_SNAKE_WOLF, __
        .byte   RANDOM_FOOD, __end
        .msg_id "EC"
        
        ; $ED:
        .byte   ITS__, FABULOUS_EXOTIC_HOOPY_UNUSUAL_EXCITING, __
        .byte   LEOPARD_CAT_MONKEY_GOAT_FISH, __, RANDOM_FOOD, __end
        .msg
        
        ; $EE:
        .byte   RANDOM_ENVIRONMENT, __, RANDOM_SPORT, __end
        .msg
        
        ; $EF:
        .byte   _6A, __, RANDOM_DRINK
        .byte   __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $F0:  "meat"
        .byte   "ME", AT, __end
        .msg_id "MEAT"
        
        ; $F1:  "cutlet"
        .byte   "CUTL", ET, __end
        .msg
        
        ; $F2:  "steak"
        .byte   ST, "EAK", __end
        .msg
        
        ; $F3:  "burgers"
        .byte   "BURG", ER, "S", __end
        .msg
        
        ; $F4:  "soup"
        .byte   SO, "UP", __end
        .msg
        
        ; sport prefixes: (e.g. Brockian Ultra Cricket)
        ;-----------------------------------------------------------------------
        ; $F5:  "ice"
        .byte   "I", CE, __end
        .msg_id "ICE"
        
        ; $F6:  "mud"
        .byte   "MUD", __end
        .msg
        
        ; $F7:  "zero-G"
        .byte   "Z", ER, "O-", FN_CAPNEXT, "G", __end
        .msg
        
        ; $F8:  "vacuum"
        .byte   "VACUUM", __end
        .msg
        
        ; $F9:  <target-system>-"ian ultra"
        ;       e.g. Brokian ultra cricket
        .byte   FN_TARGET_SYSTEM_IAN, __, "ULT", RA, __end
        .msg
        
        ; sports:
        ;-----------------------------------------------------------------------
        ; $FA:  "hockey"
        .byte   "HOCKEY", __end
        .msg_id "HOCKEY"
        
        ; $FB:  "cricket"
        .byte   "CRICK", ET, __end
        .msg
        
        ; $FC:  "karate"
        .byte   "K", AR, AT, "E", __end
        .msg
        
        ; $FD:  "polo"
        .byte   "PO", LO, __end
        .msg
        
        ; $FE:  "tennis"
        .byte   "T", EN, "NIS", __end
        .msg
        
        ;-----------------------------------------------------------------------
        ; $FF:  "disk" / "tape", " error"
        .byte   FN_NEWLINE, FN_MEDIA_CURRENT, __, ER, "R", OR
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
        .byte   THE__, "CO", LO, "NI", ST, "S", __, "HE", RE, __
        .byte   "HA", VE, __, "VIOL", AT, ED, FN_CAPS_OFF, __
        .byte   IN, "T", ER, "G", AL, "AC", TI, "C", __, "C", LO, "N", ING__
        .byte   "PROTOCOL", FN_0D, __AND__, "SH", OU, "LD", __, BE, __
        .byte   "AVOID", ED, __end
        
        ; 2.
        ; TODO: "Constrictor" should be capitalised
        .byte   THE__, "C", ON, ST, "RICT", OR, __, WAS_LAST_SEEN_AT__
        ;       NOTE: "WAS_LAST_SEEN_AT__" ends with `FN_CAPNEXT`
        .byte   RE, ES, DI, CE, ",", __, COMMANDER
        .byte   __end

        ; 3.
        .byte   "A", __, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __
        .byte   LO, "OK", ING__, SHIP, __, LE, "FT", __, "HE", RE
        .byte   __A__, "WHI", LE, __, "BACK.", __, "LOOK", ED__
        .byte   "B", OU, "ND", __, _F, OR, __
        ; TODO: "Arexe" should be capitalised
        .byte   AR, "E", XE, __end
        
        ; 4.
        .byte   "YEP,", __A__, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __NEW__
        .byte   SHIP, __, "HAD", __A__, "G", AL, "AC", TI, "C", __
        .byte   "HYP", ER, "DRI", VE, __, "F", IT, "T", ED__, "HE", RE, "."
        .byte   __, US, ED__, IT, __, "TOO", __end
        
        ; 5.
        .byte   THIS__, __, FUNNY_WEIRD_UNUSUAL_STRANGE_PECULIAR, __, SHIP, __
        .byte   "DEHYP", ED__, "HE", RE, __, "FROM", __, NO, "WHE", RE, ",", __
        .byte   "SUN", __, "SKIMM", ED, __AND__, "JUMP", ED, ".", __, "I", __
        .byte   "HE", AR, __, IT, __, "W", EN, "T", __TO__, IN, BI, BE, __end
        
        ; 6.
        .byte   RANDOM_INSULT, __, SHIP, __, "W", EN, "T", __, "F", OR, __
        .byte   "ME", __, AT, __, "A", US, AR, ".", __, "MY", __
        .byte   LA, "S", ER, "S", __, "DIDN'T", __, "EV", EN, __
        .byte   "SC", RA, "TCH", __, THE__, RANDOM_INSULT, __end
        
        ; 7.
        .byte   "OH", __, "DE", AR, __, "ME", __, "Y", ES, ".", __A__
        .byte   "FRIGHTFUL", __, "ROGUE", __, "WI", TH, __, "WH", AT, __
        .byte   "I", __, BE, "LIE", VE, __, YOU, __, "PEOP", LE, __
        .byte   "C", AL, "L", __A__, LE, "AD", __, "PO", ST, ER, "I", OR, __
        .byte   "SHOT", __, "UP", __, LO, "TS", __, "OF", __, TH, "O", SE, __
        .byte   BE, "A", ST, "LY", __, "PI", RA, "T", ES, __AND__, "W", EN, "T"
        ; TODO: "Usleri" should be capitalised
        .byte   __TO__, US, LE, "RI", __end
        
        ; 8.
        .byte   YOU, __, "C", AN, __, "TACK", LE, __, THE__
        .byte   KILLER_DEADLY_EVIL_LETHAL_VICIOUS, __, RANDOM_INSULT, __
        .byte   "IF", __, YOU, __, "LIKE.", __, "HE'S", __, AT, __
        ; TODO: "Orarra" should be capitalised
        .byte   OR, AR, RA, __end
        
        ; 9.    still waiting for OP...
        .byte   FN_CAPS_ON
        .byte   "COM", ING__, SO, ON, ":", __, "EL", IT, "E", __, "II", __end
        
        ; prototype mission hints:
        .byte   _74, __end      ; 10.
        .byte   _74, __end      ; 11.
        .byte   _74, __end      ; 12.
        .byte   _74, __end      ; 13.
        .byte   _74, __end      ; 14.
        .byte   _74, __end      ; 15.
        .byte   _74, __end      ; 16.
        .byte   _74, __end      ; 17.
        .byte   _74, __end      ; 18.
        .byte   _74, __end      ; 19.
        .byte   _74, __end      ; 20.
        .byte   _74, __end      ; 21.
        .byte   _74, __end      ; 22.
        
        ; 23.
        .byte   "BOY", __, "A", RE, __, YOU, __, IN, __, THE__
        .byte   "WR", ON, "G", __, "G", AL, "AXY!", __end
        
        ; 24.
        .byte   TH, ER, "E'S", __A__, RE, AL, __, RANDOM_INSULT, __
        .byte   "PI", RA, "TE", __, OU, "T", __, TH, ER, "E", __end
        
        ; 25.
        .byte   THE__, INHABITANT, "S", __, "OF", __, _6D, __
        .byte   "A", RE, __, SO, __, "A", MA, "Z", IN, "GLY", __
        .byte   "PRIMI", TI, VE, __, TH, AT, __, TH, "EY", __, ST, IL, "L", __
        .byte   TH, IN, "K", __, FN_CAPNEXT
        ;       ???
        .byte   "*****", __, "******", __IS__, __, "3D"
        .byte   __end
        
        ; 26.   unused
        .byte   FN_CAPS_ON, "WELCOME", __, "TO", __, "THE", __
        .byte   "SEVENTEENTH", __, "GALAXY!", __end
        
        ; 27.   TODO: this does not look like text
        ;       -- some other kind of lookup table?
        .byte   _6D, FN_THEIR_NAME, FN_CAPNEXT
        .byte   FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, RANDOM_ENVIRONMENT, $31, $3a, FN_16
        .byte   FN_CAPNEXT, FN_14, $23, $30, $3a, FN_YOUR_NAME, FN_TARGET_SYSTEM
        .byte   FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, $35, RANDOM_ENVIRONMENT, $31, $3a, FN_1D
        .byte   FN_1A, FN_07, FN_THEIR_NAME, FN_THEIR_NAME, $35, .scramble($64), _Z, $21
        .byte   HYPHEN, .scramble($6a), $2e, FN_THEIR_NAME, FN_THEIR_NAME, $35, $32, $20
        .byte   FN_THEIR_NAME, FN_CAPNEXT, FN_16, FN_BUFFER_OFF, FN_BUFFER_OFF, $31, $3a, FN_YOUR_NAME

;$1D00