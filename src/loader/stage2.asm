; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "byebyejulie.prg" -- an empty, unused file on the disk,
; probably the remnants of whatever GMA2 was

; populate the .PRG header using the address given
; by the linker config (see "link/elite-gma86.cfg")
.segment        "HEAD_STAGE2"
.import         __GMA2_PRG_START__
        .addr   __GMA2_PRG_START__+2

.segment        "CODE_STAGE2"

.word   $0000