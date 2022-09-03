; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "kernal.inc":
;
; these vectors are called by hardware events, independent of the KERNAL.
; when the KERNAL ROM is enabled the ROM provides the values, which are KERNAL
; addresses, to allow normal operation of the C64. if the KERNAL ROM is
; switched off, then the vectors will be defined by the RAM underneath
; -- if the vectors in RAM are not set the system will crash!
; 
CPU_VECTOR_NMI          = $fffa         ; Non-Maskable-Interrupt vector
CPU_VECTOR_RESET        = $fffc         ; cold-reset vector
CPU_VECTOR_IRQ          = $fffe         ; interrupt vector

; device numbers:
;-------------------------------------------------------------------------------
; some KERNAL routines ask for device numbers
;
DEV_KEY                 = 0             ; keyboard
DEV_TAPE                = 1             ; datasette
DEV_RS232               = 2             ; RS232 serial port
DEV_SCR                 = 3             ; the screen
DEV_LPT1                = 4             ; first printer
DEV_LPT2                = 5             ; second printer
DEV_PLOT1               = 6             ; first plotter
DEV_PLOT2               = 7             ; second plotter
DEV_DRV8                = 8             ; disk drive "8"
DEV_DRV9                = 9             ; disk drive "9"
DEV_DRV10               = 10            ; ...
DEV_DRV11               = 11            ; ...
DEV_DRV12               = 12            ; ...
DEV_DRV13               = 13            ; ...
DEV_DRV14               = 14            ; ...
DEV_DRV15               = 15            ; drives above 15 are extremely rare

; KERNAL vectors:
;-------------------------------------------------------------------------------
; the C64 allows hijacking of the ROM routines via a number of vectors in RAM
; that the user can change to their own routines

; vector for the interrupt routine.
; default value is $EA31
KERNAL_VECTOR_INTERRUPT = $0314

; vector for `BRK` instruction interrupt.
; default value is $FE66
KERNAL_VECTOR_BRK       = $0316

; vector for the KERNAL's handling of the Non-Maskable Interrupt; note that
; the hardware vector (below) is executed first, which points into the KERNAL
; by default. this vector only hijacks the NMI when the KERNAL ROM is on.
; if you want to bypass the KERNAL, set the hardware vector directly.
; default value is $FE47
KERNAL_VECTOR_NMI       = $0318

; vector for the KERNAL's `OPEN` routine.
; default value is $F34A
KERNAL_VECTOR_OPEN      = $031a

; vector for the KERNAL's `CLOSE` routine.
; default value is $F291
KERNAL_VECTOR_CLOSE     = $031c

; vector for the KERNAL's `CHKIN` routine.
; default value is $F20E
KERNAL_VECTOR_CHKIN     = $031e

; vector for the KERNAL's `CHKOUT` routine.
; default value is $F250
KERNAL_VECTOR_CHKOUT    = $0320

; vector for the KERNAL's `CLRCHN` routine.
; default value is $F333
KERNAL_VECTOR_CLRCHN    = $0322

; vector for the KERNAL's `CHRIN` routine.
; default value is $F157
KERNAL_VECTOR_CHRIN     = $0324

; vector for the KERNAL's `CHROUT` routine.
; default value is $F1CA
KERNAL_VECTOR_CHROUT    = $0326

; vector for the KERNAL's `STOP` routine.
; default value is $F6ED
KERNAL_VECTOR_STOP      = $0328

; vector for the KERNAL's `GETIN` routine.
; default value is $F13E
KERNAL_VECTOR_GETIN     = $032a

; vector for the KERNAL's `CLALL` routine.
; default value is $F32F
KERNAL_VECTOR_CLALL     = $032c

; an unused vector, default value is $FE66
KERNAL_VECTOR_UNUSED    = $032e

; vector for the KERNAL's `LOAD` routine.
; default value is $F4A5
KERNAL_VECTOR_LOAD      = $0330

; vector for the KERNAL's `SAVE` routine.
; default value is $F5ED
KERNAL_VECTOR_SAVE      = $0332

; KERNAL routines:
;-------------------------------------------------------------------------------

; initialize VIC; restore default input/output to keyboard/screen;
; clear screen; set PAL/NTSC switch and interrupt timer
;
KERNAL_SCINIT           = $ff81
KERNAL_SCINIT_ADDR      = $ff5b

; initialize CIA's, SID volume; setup memory configuration;
; set and start interrupt timer
;
KERNAL_IOINIT           = $ff84
KERNAL_IOINIT_ADDR      = $fda3

; clear memory addresses $0002-$0101 and $0200-$03FF; run memory test
; and set start and end address of BASIC work area accordingly;
; set screen memory to $0400 and datasette buffer to $033C
;
KERNAL_RAMTAS           = $ff87
KERNAL_RAMTAS_ADDR      = $fd50

; fill vector table at memory addresses $0314-$0333 with default values
;
KERNAL_RESTOR           = $ff8a
KERNAL_RESTOR_ADDR      = $fd15

; copy vector table at memory addresses $0314-$0333 from or into user table.
; input:
;       carry : 0 = copy user table into vector table
;               1 = copy vector table into user table
;         X/Y : pointer to user table
;
KERNAL_VECTOR           = $ff8d
KERNAL_VECTOR_ADDR      = $fd1a

; set system error display switch at memory address $009D
; input:
;       A : switch value
;
KERNAL_SETMSG           = $ff90
KERNAL_SETMSG_ADDR      = $fe18

; send `LISTEN` secondary address to serial bus.
; (must call `LISTEN` beforehand)
; input:
;       A : secondary address.
;
KERNAL_LSTNSA           = $ff93
KERNAL_LSTNSA_ADDR      = $edb9

; send `TALK` secondary address to serial bus.
; (must call `TALK` beforehand)
; input:
;       A : secondary address
;
KERNAL_TALKSA           = $ff96
KERANL_TALKSA_ADDR      = $ecd7

; save or restore start address of BASIC work area
; input:
;       carry : 0 = restore from input
;               1 = save to output
;         X/Y : address (if carry = 0)
; output:
;         X/Y : address (if carry = 1)
;
KERNAL_MEMBOT           = $ff99
KERNAL_MEMBOT_ADDR      = $fe25

; save or restore end address of BASIC work area
; input:
;       carry : 0 = restore from input
;               1 = Save to output
;         X/Y : address (if carry = 0)
; output:
;         X/Y : address (if carry = 1)
;
KERNAL_MEMTOP           = $ff9c
KERNAL_MEMTOP_ADDR      = $fe34

; query keyboard; put current matrix code into memory address $00CB,
; current status of shift keys into memory address $028D and PETSCII
; code into keyboard buffer
KERNAL_SCNKEY           = $ff9f
KERNAL_SCNKEY_ADDR      = $ea87

; unknown. (set serial bus timeout)
; input:
;       A : timeout value
;
KERNAL_SETTMO           = $ffa2
KERNAL_SETTMO_ADDR      = $fe21

; read byte from serial bus.
; (must call `TALK` and `TALKSA` beforehand)
; output:
;       A : byte read
;
KERNAL_IECIN            = $ffa5
KERNAL_IECIN_ADDR       = $ee13

; write byte to serial bus.
; (must call `LISTEN` and `LSTNSA` beforehand)
; input:
;       A : byte to write
;
KERNAL_IECOUT           = $ffa8
KERNAL_IECOUT_ADDR      = $eddd

; send `UNTALK` command to serial bus
KERNAL_UNTALK           = $ffab
KERNAL_UNTALK_ADDR      = $edef

; send `UNLISTEN` command to serial bus
KERNAL_UNLSTN           = $ffae
KERNAL_UNLSTN_ADDR      = $edfe

; send `LISTEN` command to serial bus
; input:
;       A : device number
;
KERNAL_LISTEN           = $ffb1
KERNAL_LISTEN_ADDR      = $ed0c

; send `TALK` command to serial bus
; input:
;       A : device number
;
KERNAL_TALK             = $ffb4
KERNAL_TALK_ADDR        = $ed09

; fetch status of current input/output device, value of `ST` variable
; (for RS232, status is cleared)
; output:
;       A : device status
;
KERNAL_READST           = $ffb7
KERNAL_READST_ADDR      = $fe07

; set file parameters
; input:
;       A : logical number
;       X : device number
;       Y : secondary address
;
KERNAL_SETLFS           = $ffba
KERNAL_SETLFS_ADDR      = $fe00

; set file name parameters
; input:
;         A : file name length
;       X/Y : pointer to file name
;
KERNAL_SETNAM           = $ffbd
KERNAL_SETNAM_ADDR      = $fdf9

; open file (must call `SETLFS` and `SETNAM` beforehand)
KERNAL_OPEN             = $ffc0
KERNAL_OPEN_ADDR        = $f34a

; close file
; input:
;       A : logical number
;
KERNAL_CLOSE            = $ffc3
KERNAL_CLOSE_ADDR       = $f291

; define file as default input
; (must call `OPEN` beforehand)
; input:
;       X : logical number
;
KERNAL_CHKIN            = $ffc6
KERNAL_CHKIN_ADDR       = $f20e

; define file as default output
; (must call `OPEN` beforehand)
; input:
;       X : logical number
;
KERNAL_CHKOUT           = $ffc9
KERNAL_CHKOUT_ADDR      = $f250

; close default input/output files (for serial bus, send `UNTALK` and/or
; `UNLISTEN`); restore default input/output to keyboard/screen
KERNAL_CLRCHN           = $ffcc
KERNAL_CLRCHN_ADDR      = $f333

; read byte from default input (for keyboard, read a line from the screen).
; (if not keyboard, must call `OPEN` and `CHKIN` beforehand)
; output:
;       A : byte read
;
KERNAL_CHRIN            = $ffcf
KERNAL_CHRIN_ADDR       = $f157

; write byte to default output
; (if not screen, must call `OPEN` and `CHKOUT` beforehand)
; input:
;       A : byte to write
;
KERNAL_CHROUT           = $ffd2
KERNAL_CHROUT_ADDR      = $f1ca

; load or verify file. (must call `SETLFS` and `SETNAM` beforehand)
; input:
;           A : 0 = load, 1-255 = verify;
;         X/Y : load address (if secondary address = 0)
; output:
;       carry : 0 = no errors, 1 = error
;           A : KERNAL error code (if carry = 1)
;         X/Y : address of last byte loaded/verified (if carry = 0)
;
KERNAL_LOAD             = $ffd5
KERNAL_LOAD_ADDR        = $f49e

; save file. (must call `SETLFS` and `SETNAM` beforehand)
; input:
;           A : address of zero page register holding
;               start address of memory area to save
;         X/Y : End address of memory area plus 1.
; output:
;       carry : 0 = No errors, 1 = Error
;           A : KERNAL error code (if carry = 1)
;
KERNAL_SAVE             = $ffd8
KERNAL_SAVE_ADDR        = $f5dd

; set Time of Day, at memory address $00A0-$00A2
; input:
;       A/X/Y : new TOD value
;
KERNAL_SETTIM           = $ffdb
KERNAL_SETTIM_ADDR      = $f6e4

; read Time of Day, at memory address $00A0-$00A2
; output:
;       A/X/Y : current TOD value
;
KERNAL_RDTIM            = $ffde
KERNAL_RDTIM_ADDR       = $f6dd

; query Stop key indicator, at memory address $0091;
; if pressed, call CLRCHN and clear keyboard buffer
; output:
;        zero : 0 = not pressed, 1 = pressed
;       carry : 1 = pressed
;
KERNAL_STOP             = $ffe1
KERNAL_STOP_ADDR        = $f6ed

; read byte from default input
; (if not keyboard, must call `OPEN` and `CHKIN` beforehand)
; output:
;       A : byte read
;
KERNAL_GETIN            = $ffe4
KERNAL_GETIN_ADDR       = $f13e

; clear file table; call `CLRCHN`
KERNAL_CLALL            = $ffe7
KERNAL_CLALL_ADDR       = $f32f

; update Time of Day, at memory address $00A0-$00A2,
; and stop-key indicator, at memory address $0091
KERNAL_UDTIM            = $ffea
KERNAL_UDTIM_ADDR       = $f69b

; fetch number of screen rows and columns
; output:
;       X : number of columns (40)
;       Y : number of rows (25)
;
KERNAL_SCREEN           = $ffed
KERNAL_SCREEN_ADDR      = $e505

; save or restore cursor position
; input:
;       carry : 0 = restore from input, 1 = save to output
;           X : cursor column (if carry = 0)
;           Y : cursor row (if carry = 0)
; output:
;           X : cursor column (if carry = 1)
;           Y : cursor row (if carry = 1)
;
KERNAL_PLOT             = $fff0
KERNAL_PLOT_ADDR        = $e50a

; fetch CIA1 base address
; output:
;       X/Y : CIA1 base address ($DC00)
;
KERNAL_IOBASE           = $fff3
KERNAL_IOBASE_ADDR      = $e500
