; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; KERNAL routines:
;===============================================================================

; initialize VIC; restore default input/output to keyboard/screen;
; clear screen; set PAL/NTSC switch and interrupt timer
.define KERNAL_SCINIT   $ff81

; initialize CIA's, SID volume; setup memory configuration;
; set and start interrupt timer
.define KERNAL_IOINIT   $ff84

; clear memory addresses $0002-$0101 and $0200-$03FF; run memory test
; and set start and end address of BASIC work area accordingly;
; set screen memory to $0400 and datasette buffer to $033C
.define KERNAL_RAMTAS   $ff87

; fill vector table at memory addresses $0314-$0333 with default values
.define KERNAL_RESTOR   $ff8a

; copy vector table at memory addresses $0314-$0333 from or into user table.
; input:
;       carry : 0 = copy user table into vector table
;               1 = copy vector table into user table
;         X/Y : pointer to user table
;
.define KERNAL_VECTOR   $ff8d

; set system error display switch at memory address $009D
; input:
;       A : switch value
;
.define KERNAL_SETMSG   $ff90

; send `LISTEN` secondary address to serial bus.
; (must call `LISTEN` beforehand)
; input:
;       A : secondary address.
;
.define KERNAL_LSTNSA   $ff93

; send `TALK` secondary address to serial bus.
; (must call `TALK` beforehand)
; input:
;       A : secondary address
;
.define KERNAL_TALKSA   $ff96

; save or restore start address of BASIC work area
; input:
;       carry : 0 = restore from input
;               1 = save to output
;         X/Y : address (if carry = 0)
; output:
;         X/Y : address (if carry = 1)
;
.define KERNAL_MEMBOT   $ff99

; save or restore end address of BASIC work area
; input:
;       carry : 0 = restore from input
;               1 = Save to output
;         X/Y : address (if carry = 0)
; output:
;         X/Y : address (if carry = 1)
;
.define KERNAL_MEMTOP   $ff9c

; query keyboard; put current matrix code into memory address $00CB,
; current status of shift keys into memory address $028D and PETSCII
; code into keyboard buffer
.define KERNAL_SCNKEY   $ff9f

; unknown. (set serial bus timeout)
; input:
;       A : timeout value
;
.define KERNAL_SETTMO   $ffa2

; read byte from serial bus.
; (must call `TALK` and `TALKSA` beforehand)
; output:
;       A : byte read
;
.define KERNAL_IECIN    $ffa5

; write byte to serial bus.
; (must call `LISTEN` and `LSTNSA` beforehand)
; input:
;       A : byte to write
;
.define KERNAL_IECOUT   $ffa8

; send `UNTALK` command to serial bus
.define KERNAL_UNTALK   $ffab

; send `UNLISTEN` command to serial bus
.define KERNAL_UNLSTN   $ffae

; send `LISTEN` command to serial bus
; input:
;       A : device number
;
.define KERNAL_LISTEN   $ffb1

; send `TALK` command to serial bus
; input:
;       A : device number
;
.define KERNAL_TALK     $ffb4

; fetch status of current input/output device, value of `ST` variable
; (for RS232, status is cleared)
; output:
;       A : device status
;
.define KERNAL_READST   $ffb7

; set file parameters
; input:
;       A : logical number
;       X : device number
;       Y : secondary address
;
.define KERNAL_SETLFS   $ffba

; set file name parameters
; input:
;         A : file name length
;       X/Y : pointer to file name
;
.define KERNAL_SETNAM   $ffbd

; open file (must call `SETLFS` and `SETNAM` beforehand)
.define KERNAL_OPEN     $ffc0

; close file
; input:
;       A : logical number
;
.define KERNAL_CLOSE    $ffc3

; define file as default input
; (must call `OPEN` beforehand)
; input:
;       X : logical number
;
.define KERNAL_CHKIN    $ffc6

; define file as default output
; (must call `OPEN` beforehand)
; input:
;       X : logical number
;
.define KERNAL_CHKOUT   $ffc9

; close default input/output files (for serial bus, send `UNTALK` and/or
; `UNLISTEN`); restore default input/output to keyboard/screen
.define KERNAL_CLRCHN   $ffcc


; read byte from default input (for keyboard, read a line from the screen).
; (if not keyboard, must call `OPEN` and `CHKIN` beforehand)
; output:
;       A : byte read
;
.define KERNAL_CHRIN    $ffcf

; write byte to default output
; (if not screen, must call `OPEN` and `CHKOUT` beforehand)
; input:
;       A : byte to write
;
.define KERNAL_CHROUT   $ffd2

; load or verify file. (must call `SETLFS` and `SETNAM` beforehand)
; input:
;           A : 0 = load, 1-255 = verify;
;         X/Y : load address (if secondary address = 0)
; output:
;       carry : 0 = no errors, 1 = error
;           A : KERNAL error code (if carry = 1)
;         X/Y : address of last byte loaded/verified (if carry = 0)
;
.define KERNAL_LOAD     $ffd5

; save file. (must call `SETLFS` and `SETNAM` beforehand)
; input:
;           A : address of zero page register holding
;               start address of memory area to save
;         X/Y : End address of memory area plus 1.
; output:
;       carry : 0 = No errors, 1 = Error
;           A : KERNAL error code (if carry = 1)
;
.define KERNAL_SAVE     $ffd8

; set Time of Day, at memory address $00A0-$00A2
; input:
;       A/X/Y : new TOD value
;
.define KERNAL_SETTIM   $ffdb

; read Time of Day, at memory address $00A0-$00A2
; output:
;       A/X/Y : current TOD value
;
.define KERNAL_RDTIM    $ffde

; query Stop key indicator, at memory address $0091;
; if pressed, call CLRCHN and clear keyboard buffer
; output:
;        zero : 0 = not pressed, 1 = pressed
;       carry : 1 = pressed
;
.define KERNAL_STOP     $ffe1

; read byte from default input
; (if not keyboard, must call `OPEN` and `CHKIN` beforehand)
; output:
;       A : byte read
;
.define KERNAL_GETIN    $ffe4

; clear file table; call `CLRCHN`
.define KERNAL_CLALL    $ffe7

; update Time of Day, at memory address $00A0-$00A2,
; and stop-key indicator, at memory address $0091
.define KERNAL_UDTIM    $ffea

; fetch number of screen rows and columns
; output:
;       X : number of columns (40)
;       Y : number of rows (25)
;
.define KERNAL_SCREEN   $ffed

; save or restore cursor position
; input:
;       carry : 0 = restore from input, 1 = save to output
;           X : cursor column (if carry = 0)
;           Y : cursor row (if carry = 0)
; output:
;           X : cursor column (if carry = 1)
;           Y : cursor row (if carry = 1)
;
.define KERNAL_PLOT     $fff0

; fetch CIA1 base address
; output:
;       X/Y : CIA1 base address ($DC00)
;
.define KERNAL_IOBASE   $fff3
