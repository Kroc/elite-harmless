; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "c1541.inc":
;
; definitions for working with the Commodore 1541 disk-drive
;
; the 1541 is a self-contained computer with its own 6502 processor, 2 KB RAM
; and 16 KB ROM. commands can be sent to it over the serial bus but it's also
; possible to execute custom code within the 1541; this is typically used to
; implement fast-loaders and copy-protection schemes
;
; a lot of reference material was used to piece this together;
; including, but not limited to:
;
; "All About Your 1541" by Ninja/The Dreams
; http://unusedino.de/ec64/technical/aay/c1541/
;
;-------------------------------------------------------------------------------

; 5 internal buffers of 256 bytes are set aside
; for data read in from the disk surface:

C1541_BUFF0                     = $0300
C1541_BUFF1                     = $0400
C1541_BUFF2                     = $0500
C1541_BUFF3                     = $0600
C1541_BUFF4                     = $0700

; address to the current buffer to use
C1541_ZP_CURBUFF                = $30
C1541_ZP_CURBUFF_LO             = $30
C1541_ZP_CURBUFF_HI             = $31

; table of track and sectors to use for each buffer
C1541_ZP_BUFF0_TRK              = $06   ; track # for buffer 0
C1541_ZP_BUFF0_SEC              = $07   ; sector # for buffer 0
C1541_ZP_BUFF1_TRK              = $08   ; track # for buffer 1
C1541_ZP_BUFF1_SEC              = $09   ; sector # for buffer 1
C1541_ZP_BUFF2_TRK              = $0a   ; track # for buffer 2
C1541_ZP_BUFF2_SEC              = $0b   ; sector # for buffer 2
C1541_ZP_BUFF3_TRK              = $0c   ; track # for buffer 3
C1541_ZP_BUFF3_SEC              = $0d   ; sector # for buffer 3
C1541_ZP_BUFF4_TRK              = $0e   ; track # for buffer 4
C1541_ZP_BUFF4_SEC              = $0f   ; sector # for buffer 4

; job queue

C1541_ZP_JOB0                   = $00
C1541_ZP_JOB1                   = $01
C1541_ZP_JOB2                   = $02
C1541_ZP_JOB3                   = $03
C1541_ZP_JOB4                   = $04

.enum   C1541_JOB
        READ                    = $80
        WRITE                   = $90
        VERIFY                  = $a0
        SEEK                    = $b0
        BUMP                    = $c0
        JUMP                    = $d0
        EXECUTE                 = $e0
.endenum

; error codes

.enum   C1541_ERR
        ;=======================================================================
        ; "Error #00:   OK"
        ;-----------------------------------------------------------------------
        ; command was executed successfully
        ;
        OK                      = $01   ; no error

        ; "Error #20:   READ ERROR (block header not found),TT,SS"
        ;-----------------------------------------------------------------------
        ; the disk controller is unable to locate the header of the requested
        ; data block. caused by an illegal block number, or the header has
        ; been destroyed
        ;
        READ_ERROR_20           = $02

        ; "Error #21:   READ ERROR (no sync character),TT,SS"
        ;-----------------------------------------------------------------------
        ; the disk controller is unable to detect a sync mark on the desired
        ; track. caused by misalignment of the read/writer head, no diskette
        ; is present, or unformatted or improperly seated diskette.
        ; can also indicate a hardware failure
        ;
        READ_ERROR_21           = $03

        ; "Error #21:   READ ERROR (no sync character),TT,SS"
        ;-----------------------------------------------------------------------
        ; the disk controller is unable to detect a sync mark on the desired
        ; track. caused by misalignment of the read/writer head, no diskette
        ; is present, or unformatted or improperly seated diskette. can also
        ; indicate a hardware failure
        ;
        READ_ERROR_22           = $04

        ; "Error #23:   READ ERROR (checksum error in data block),TT,SS"
        ;-----------------------------------------------------------------------
        ; this error message indicates that there is an error in one or more
        ; of the data bytes. the data has been read into the DOS memory, but
        ; the checksum over the data is in error. This message may also
        ; indicate grounding problems
        ;
        READ_ERROR_23           = $05

        ; "Error #24:   READ ERROR (byte decoding error)"
        ;-----------------------------------------------------------------------
        ; the data or header as been read into the DOS memory, but a hardware
        ; error has been created due to an invalid bit pattern in the data
        ; byte. this message may also indicate grounding problems
        ;
        READ_ERROR_24           = $06   ; doesn't occur in practice
        
        ; "Error #25:   WRITE ERROR (write-verify error),TT,SS"
        ;-----------------------------------------------------------------------
        ; this message is generated if the controller detects a mismatch
        ; between the written data and the data in the DOS memory
        ;
        WRITE_ERROR_25          = $07

        ; "Error #26:   WRITE PROTECT ON,TT,SS"
        ;-----------------------------------------------------------------------
        ; this message is generated when the controller has been requested to
        ; write a data block while the write protect switch is depressed.
        ; typically, this is caused by using a diskette with a write a protect
        ; tab over the notch
        ;
        WRITE_PROTECT_ON        = $08

        ; "Error #27:   READ ERROR (checksum error in header),TT,SS"
        ;-----------------------------------------------------------------------
        ; the controller has detected an error in the header of the requested
        ; data block. the block has not been read into the DOS memory.
        ; this message may also indicate grounding problems
        ;
        READ_ERROR_27           = $09

        ; "Error #28:   WRITE ERROR (long data block)"
        ;-----------------------------------------------------------------------
        ; the controller attempts to detect the sync mark of the next header
        ; after writing a data block. If the sync mark does not appear within
        ; a predetermined time, the error message is generated. the error is
        ; caused by a bad diskette format (the data extends into the next
        ; block), or by hardware failure
        ;
        READ_ERROR_28           = $0a   ; doesn't occur in practice
        
        ; "Error #29:   DISK ID MISMATCH,TT,SS"
        ;-----------------------------------------------------------------------
        ; this message is generated when the controller has been requested to
        ; access a diskette which has not been initialized. the message can
        ; also occur if a diskette has a bad header
        ;
        DISK_ID_MISMATCH        = $0b

        DRIVE_NOT_READY         = $0f
.endenum


; Versatile Interface Adapters (VIA) 6522
;===============================================================================
; the 1541 has two VIA chips that handle input / output. one is wired to the
; drive mechanism and controls the drive motor & read/write head, and the
; other handles the serial bus for communication with the C64. each VIA
; has two "ports" for communication, port A & port B

; VIA1 - serial bus:
;-------------------------------------------------------------------------------
C1541_VIA1_PORTB                = $1800 ; serial bus
C1541_VIA1_PORTA                = $1801

C1541_VIA1_PORTB_DDR            = $1802 ; data-direction-register for port B
C1541_VIA1_PORTA_DDR            = $1803 ; data-direction-register for port A

; VIA2 - drive mechanism:
;-------------------------------------------------------------------------------
C1541_VIA2_PORTB                = $1c00
C1541_VIA2_PORTA                = $1c01 ; data byte last read, or to be written

C1541_VIA2_PORTB_DDR            = $1c02 ; data-direction-register for port B
C1541_VIA2_PORTA_DDR            = $1c03 ; data-direction-register for port A

; 1541 ROM routines:
;-------------------------------------------------------------------------------
C1541_KERNAL_loadBAM            = $d042 ; load the disk's Block Allocation Map

; "Error entry disk controller"
C1541_KERNAL_error              = $f969