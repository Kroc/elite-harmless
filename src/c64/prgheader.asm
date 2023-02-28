; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "prgheader.asm":
;
; C64 .PRG files, both on PC and on D64 disk, begin with a two-byte header
; that give the load-address of the program in little Endian low-hi order

.segment        "PRGHEADER"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.export         __PRGHEADER__:absolute = 1

        .addr   *+2
