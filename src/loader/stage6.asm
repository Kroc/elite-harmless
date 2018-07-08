; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "gma6.prg"

; populate the .PRG header using the address given
; by the linker config (see "link/elite-gma86.cfg")
.segment        "HEAD_STAGE6"
.import         __GMA6_PRG_START__
        .addr   __GMA6_PRG_START__+2

; these bytes are not encrypted!!! (they're the background-fill)
; the linker will exclude these from the binary of the data-to-be-encrypted.
; when the code is re-linked with the encrypted blob, these bytes are appended

.segment        "GMA6_JUNK"

        .byte   $ff, $00, $ff, $00, $ff, $00, $ff, $00                  ;$CCD8
        .byte   $ff                                                     ;$CCE0

;$CCE1