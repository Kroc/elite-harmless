; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.segment        "INIT_PRG"
.export         __INIT_PRG__:absolute = 1

        .addr   *+2

.segment        "PRG1_PRG"
.export         __PRG1_PRG__:absolute = 1

        .addr   *+2

.segment        "PRG2_PRG"
.export         __PRG2_PRG__:absolute = 1

        .addr   *+2

.segment        "PRG3_PRG"
.export         __PRG3_PRG__:absolute = 1

        .addr   *+2