; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.segment        "VIC_BITMAP"

; if we force the 8K alignment required by bitmap screens, the linker will
; issue a warning that this is "suspiciously large"!
;.align          $2000

.res    $2000

.segment        "VIC_SCR_MENU"

.res    $0400

.segment        "VIC_SCR_MAIN"

.res    $0400

.segment        "ZP_SHADOW"

.res    $0100

.segment        "DISK_BUFFER"

.res    $0100
