; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

.segment        "TEXT_PAIRS"

; message compression character pairs:
;-------------------------------------------------------------------------------

_254c:
.export _254c

        .byte   $0c
_254d:
.export _254d

        .byte   $0a
_254e:
.export _254e

        .byte   "ab", "ou", "se", "it"
        .byte   "il", "et", "st", "on"
        .byte   "lo", "nu", "th", "no"


; text compression character pairs:
;-------------------------------------------------------------------------------

char_pairs:                                                             ;$2566
.export char_pairs
.export char_pair1      := char_pairs+0
.export char_pair2      := char_pairs+1

        .byte   "al", "le", "xe", "ge"
        .byte   "za", "ce", "bi", "so"
        .byte   "us", "es", "ar", "ma"
        .byte   "in", "di", "re", "a?"
        .byte   "er", "at", "en", "be"
        .byte   "ra", "la", "ve", "ti"
        .byte   "ed", "or", "qu", "an"
        .byte   "te", "is", "ri", "on"