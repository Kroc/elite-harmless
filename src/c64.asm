; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================
.linecont+

.macro .phx             ; "Push X"
        txa 
        pha 
.endmacro

.macro .phy             ; "Push Y"
        tya 
        pha 
.endmacro

; the 6502 CPU has very difficult to grasp semantics when it comes to
; comparisons and branching when compared to the Z80. this can make it
; very non-obvious whether a branch is `>`, `>=`, `<` or `<=`
;
; see this page for details on comparisons and branching:
; http://www.6502.org/tutorials/compare_instructions.html
;
; the set of macros below provide more visibly recognisable names.
; these macros are already defined in generic.mac, but this is pretty
; non-obvious, even to a CC65 user and I'd prefer to place them somewhere
; visible. (in these, a leading dot is included in the names, to make it
; obvious that they are macros, and not original instructions)

.macro .bge     Arg     ; branch on greater-than or equal
        bcs     Arg
.endmacro

.macro .blt     Arg     ; branch on less-than
        bcc     Arg
.endmacro

.macro .bgt     Arg     ; branch on greater-than
        .local  L
        beq     L
        bcs     Arg
L:
.endmacro

.macro .ble     Arg     ; branch on less-than or equal
        beq     Arg
        bcc     Arg
.endmacro

.macro .bnz     Arg     ; branch on not zero
        bne     Arg
.endmacro

.macro .bze     Arg     ; branch on zero
        beq     Arg
.endmacro

.macro .seb             ; set borrow
        clc 
.endmacro

.macro .clb             ; clear borrow
        sec 
.endmacro

.macro .bbw     Arg     ; branch on borrow
        bcc     Arg
.endmacro

.macro .bnb     Arg     ; branch on no-borrow
        bcs     Arg
.endmacro

; an optimisation, to avoid extra branching, is to jump into the middle of an
; instruction which is then interpretted as some other instruction. a common
; example of this is using the `bit` instruction as a 'do nothing' instruction
; with the option to jump over the `bit` opcode and treat the 2-byte parameter
; as different instruction:
;
;     bit $00a9 ;<-- this is `lda # $00` if you skip the `bit` opcode
;
; this macro simply outputs the opcode for the `bit` instruction, causing the
; next 2-byte instruction to be 'ignored'. for example:
;
;     do_one_thing:
;         lda # $ff
;        .bit           ; skip the next `lda` by making it a `bit` instruction
;
;     do_a_different_thing:
;         lda # $00
;
.macro .bit
        .byte   $2c
.endmacro

; colours
;===============================================================================

.define BLACK   $00
.define WHITE   $01
.define RED     $02
.define CYAN    $03
.define PURPLE  $04
.define GREEN   $05
.define BLUE    $06
.define YELLOW  $07
.define ORANGE  $08
.define BROWN   $09
.define LTRED   $0a
.define DKGREY  $0b
.define GREY    $0c
.define LTGREEN $0d
.define LTBLUE  $0e
.define LTGREY  $0f

.define .color_nybbles(fore, back) \
        (fore & 15) << 4 | (back & 15)

.define .scrpos(ypos, xpos) \
        ((ypos * 40) + xpos)

; given a screen row + column, return a bitmap offset in bytes
; where 1 char = 8 bytes, therefore one row is 320 bytes
.define .bmppos(ypos, xpos) \
        ((ypos * 320) + (xpos * 8))

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


;===============================================================================
; CIA
;===============================================================================
.define CIA1_INTERRUPT          $dc0d
.define CIA2_INTERRUPT          $dd0d

.define TIMER_A                 %001
.define TIMER_B                 %010
.define TIMER_TOD               %100

.define VECTOR_NMI              $fffa
.define VECTOR_RESET            $fffc
.define VECTOR_IRQ              $fffe


;===============================================================================
; VIC-II registers:
;===============================================================================

.define VIC_SPRITE0_X           $d000
.define VIC_SPRITE0_Y           $d001
.define VIC_SPRITE1_X           $d002
.define VIC_SPRITE1_Y           $d003
.define VIC_SPRITE2_X           $d004
.define VIC_SPRITE2_Y           $d005
.define VIC_SPRITE3_X           $d006
.define VIC_SPRITE3_Y           $d007
.define VIC_SPRITE4_X           $d008
.define VIC_SPRITE4_Y           $d009
.define VIC_SPRITE5_X           $d00a
.define VIC_SPRITE5_Y           $d00b
.define VIC_SPRITE6_X           $d00c
.define VIC_SPRITE6_Y           $d00d
.define VIC_SPRITE7_X           $d00e
.define VIC_SPRITE7_Y           $d00f

.define VIC_SPRITES_X           $d010

.define VIC_SCREEN_VERT         $d011
.define VIC_SCREEN_HORZ         $d016

.define VIC_RASTER              $d012

.define VIC_LIGHT_X             $d013
.define VIC_LIGHT_Y             $d014

.define VIC_SPRITE_ENABLE       $d015

.define VIC_SPRITE_DBLHEIGHT    $d017
.define VIC_SPRITE_DBLWIDTH     $d01d

.define VIC_MEMORY              $d018

.define VIC_INTERRUPT_STATUS    $d019
.define VIC_INTERRUPT_CONTROL   $d01a

.define INTERRUPT_RASTER        %0001
.define INTERRUPT_BGCOLLISION   %0010
.define INTERRUPT_SPCOLLISION   %0100
.define INTERRUPT_LIGHTPEN      %1000

.define VIC_SPRITE_PRIORITY     $d01b

.define VIC_SPRITE_MULTICOLOR   $d01c

.define VIC_SPRITE_SPCOLLISION  $d01e
.define VIC_SPRITE_BGCOLLISION  $d01f

.define VIC_BORDER              $d020
.define VIC_BACKGROUND          $d021


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

; send LISTEN secondary address to serial bus.
; (must call LISTEN beforehand)
; input:
;       A : secondary address.
;
.define KERNAL_LSTNSA   $ff93

; send TALK secondary address to serial bus.
; (must call TALK beforehand)
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
; (must call TALK and TALKSA beforehand)
; output:
;       A : byte read
;
.define KERNAL_IECIN    $ffa5

; write byte to serial bus.
; (must call LISTEN and LSTNSA beforehand)
; input:
;       A : byte to write
;
.define KERNAL_IECOUT   $ffa8

; send UNTALK command to serial bus
.define KERNAL_UNTALK   $ffab

; send UNLISTEN command to serial bus
.define KERNAL_UNLSTN   $ffae

; send LISTEN command to serial bus
; input:
;       A : device number
;
.define KERNAL_LISTEN   $ffb1

; send TALK command to serial bus
; input:
;       A : device number
;
.define KERNAL_TALK     $ffb4

; fetch status of current input/output device, value of ST variable
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

; open file (must call SETLFS and SETNAM beforehand)
.define KERNAL_OPEN     $ffc0

; close file
; input:
;       A : logical number
;
.define KERNAL_CLOSE    $ffc3

; define file as default input
; (must call OPEN beforehand)
; input:
;       X : logical number
;
.define KERNAL_CHKIN    $ffc6

; define file as default output
; (must call OPEN beforehand)
; input:
;       X : logical number
;
.define KERNAL_CHKOUT   $ffc9

; close default input/output files (for serial bus, send UNTALK and/or
; UNLISTEN); restore default input/output to keyboard/screen
.define KERNAL_CLRCHN   $ffcc


; read byte from default input (for keyboard, read a line from the screen).
; (if not keyboard, must call OPEN and CHKIN beforehand)
; output:
;       A : byte read
;
.define KERNAL_CHRIN    $ffcf

; write byte to default output
; (if not screen, must call OPEN and CHKOUT beforehand)
; input:
;       A : byte to write
;
.define KERNAL_CHROUT   $ffd2

; load or verify file. (must call SETLFS and SETNAM beforehand)
; input:
;           A : 0 = load, 1-255 = verify;
;         X/Y : load address (if secondary address = 0)
; output:
;       carry : 0 = no errors, 1 = error
;           A : KERNAL error code (if carry = 1)
;         X/Y : address of last byte loaded/verified (if carry = 0)
;
.define KERNAL_LOAD     $ffd5

; save file. (must call SETLFS and SETNAM beforehand)
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
; (if not keyboard, must call OPEN and CHKIN beforehand)
; output:
;       A : byte read
;
.define KERNAL_GETIN    $ffe4

; clear file table; call CLRCHN
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
