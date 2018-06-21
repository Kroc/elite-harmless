; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; the text compression in Elite uses, amongst many other things, a table of
; common letter pairs. the tokens representing these are different for the
; 'flight' strings and the 'docked' strings, even if most of the pairs are
; used by both

.segment        "TEXT_PAIRS"

index_docked    .set    $d8     ; pair tokens for docked-text begin at $D8
index_flight    .set    $80     ; pair tokens for flight-text begin at $80

; this first macro helps us define a pair of characters without having to
; write it multiple times. it writes the two charcters into the program,
; but also defines an external name used by "text_flight.asm" to place the
; correct token number (once scrambled) into the text data

.macro  .docked_pair    str
;===============================================================================
        ; export the pair's token name
        .export .ident( .concat( "txt_docked_", str ) ) = index_docked
        ; move to the next token number
        index_docked    .set    index_docked + 1

        ; write the pair of characters to the disk
        .byte   str
.endmacro

txt_docked_pairs:                                                       ;$254C
;-------------------------------------------------------------------------------
; docked text compression character pairs:
;
.export txt_docked_pair1 := txt_docked_pairs+0
.export txt_docked_pair2 := txt_docked_pairs+1

        ; TODO: decode the meaning of these
        .byte   $0c, $0a

_254e:
.export _254e

        .docked_pair    "ab"    ;=$D8 (docked)
        .docked_pair    "ou"    ;=$D9 (docked)
        .docked_pair    "se"    ;=$DA (docked)
        .docked_pair    "it"    ;=$DB (docked)
        .docked_pair    "il"    ;=$DC (docked)
        .docked_pair    "et"    ;=$DD (docked)
        .docked_pair    "st"    ;=$DE (docked)
        .docked_pair    "on"    ;=$DF (docked)
        .docked_pair    "lo"    ;=$E0 (docked)
        .docked_pair    "nu"    ;=$E1 (docked)
        .docked_pair    "th"    ;=$E2 (docked)
        .docked_pair    "no"    ;=$E3 (docked)
        
; after the character pairs unique to the 'docked' string pool come the pairs
; for the 'flight' strings, however the table for docked string pairs overlaps,
; continuing into flight string pairs; since both 'docked' and 'flight' tokens
; use different encryption this means that the *SAME CHARACTER PAIRS HAVE
; DIFFERENT TOKEN NUMBERS BETWEEN DOCKED AND FLIGHT STRINGS*
;
; ergo, this macro will take a pair of characters and define both a docked and
; flight token whilst writing only the two chars to file once

.macro  .shared_pair    str
;===============================================================================
        .local  idstr

        ; it's annoying, but we have to special case "a?", which wouldn't
        ; be a valid ident name, and CA65's macro string handling is hopeless
        .if .xmatch( str, "a?" )
                .define idstr   "a_"
        .else
                .define idstr   str
        .endif

        .export .ident(.concat( "txt_flight_", idstr )) = index_flight
        index_flight    .set    index_flight + 1

        ; the madness continues because the docked tokens run out
        ; a little short of the shared portion of the table
        .if index_docked < $100
                .export .ident(.concat( "txt_docked_", idstr )) = index_docked
                index_docked    .set    index_docked + 1
        .endif
        
        ; write the pair of characters to the disk
        .byte   str
.endmacro

; now continue the table, where the flight pairs
; begin and the docked pairs overlap:

txt_flight_pairs:                                                       ;$2566
;-------------------------------------------------------------------------------
; flight (and docked) text compression character pairs:
;
.export txt_flight_pair1 := txt_flight_pairs+0
.export txt_flight_pair2 := txt_flight_pairs+1

        .shared_pair    "al"    ;=$80 (flight), $E4 (docked)
        .shared_pair    "le"    ;=$81 (flight), $E5 (docked)
        .shared_pair    "xe"    ;=$82 (flight), $E6 (docked)
        .shared_pair    "ge"    ;=$83 (flight), $E7 (docked)
        .shared_pair    "za"    ;=$84 (flight), $E8 (docked)
        .shared_pair    "ce"    ;=$85 (flight), $E9 (docked)
        .shared_pair    "bi"    ;=$86 (flight), $EA (docked)
        .shared_pair    "so"    ;=$87 (flight), $EB (docked)
        .shared_pair    "us"    ;=$88 (flight), $EC (docked)
        .shared_pair    "es"    ;=$89 (flight), $ED (docked)
        .shared_pair    "ar"    ;=$8A (flight), $EE (docked)
        .shared_pair    "ma"    ;=$8B (flight), $EF (docked)
        .shared_pair    "in"    ;=$8C (flight), $F0 (docked)
        .shared_pair    "di"    ;=$8D (flight), $F1 (docked)
        .shared_pair    "re"    ;=$8E (flight), $F2 (docked)
        .shared_pair    "a?"    ;=$8F (flight), $F3 (docked)
        .shared_pair    "er"    ;=$90 (flight), $F4 (docked)
        .shared_pair    "at"    ;=$91 (flight), $F5 (docked)
        .shared_pair    "en"    ;=$92 (flight), $F6 (docked)
        .shared_pair    "be"    ;=$93 (flight), $F7 (docked)
        .shared_pair    "ra"    ;=$94 (flight), $F8 (docked)
        .shared_pair    "la"    ;=$95 (flight), $F9 (docked)
        .shared_pair    "ve"    ;=$96 (flight), $FA (docked)
        .shared_pair    "ti"    ;=$97 (flight), $FB (docked)
        .shared_pair    "ed"    ;=$98 (flight), $FC (docked)
        .shared_pair    "or"    ;=$99 (flight), $FD (docked)
        .shared_pair    "qu"    ;=$9A (flight), $FE (docked)
        .shared_pair    "an"    ;=$9B (flight), $FF (docked)
        .shared_pair    "te"    ;=$9C (flight)
        .shared_pair    "is"    ;=$9D (flight)
        .shared_pair    "ri"    ;=$9E (flight)
        .shared_pair    "on"    ;=$9F (flight)