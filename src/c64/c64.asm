; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

.include        "macros.asm"
.include        "kernal.asm"
.include        "cart.asm"
.include        "vic.asm"
.include        "sid.asm"
.include        "cia.asm"

;===============================================================================
; CPU port: memory layout & Datasette
;===============================================================================

; memory address $00/$01 is hard-wired to the C64's 6510 CPU;
; the "processor port", $01, controls the memory layout of the C64 as well as
; the Datasette. the "data direction" register, $00, controls which bits of the
; processor port can be written to, allowing you to mask out writes to certain
; bits -- e.g. ignore writes to the Datasette when changing memory layout

.define CPU_MASK        $00     ; data direction register
.define CPU_CONTROL     $01     ; processor port (memory layout and Datasette)

; C64 memory layout:
;-------------------------------------------------------------------------------

;                                     BASIC | I/O or CHAR | KERNAL
;                               ;-----------+-------------+---------
.define MEM_CHAR_ONLY   %001    ; 1:  OFF   |     CHAR    |  OFF
.define MEM_CHAR_KERNAL %010    ; 2:  OFF   |     CHAR    |  KERNAL    
.define MEM_IO_OFF      %011    ; 3:  BASIC |     CHAR    |  KERNAL
.define MEM_64K         %100    ; 4:  OFF   |     OFF     |  OFF
.define MEM_IO_ONLY     %101    ; 5:  OFF   |     I/O     |  OFF
.define MEM_IO_KERNAL   %110    ; 6:  OFF   |     I/O     |  KERNAL
.define MEM_DEFAULT     %111    ; 7 : BASIC |     I/O     |  KERNAL
