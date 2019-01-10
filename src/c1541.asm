; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "c1541.asm" -- definitions for working with the Commodore 1541 disk-drive

; the 1541 is a self-contained computer with its own 6502 processor, 2 KB RAM
; and 16 KB ROM. commands can be sent to it over the serial bus but it's also
; possible to execute custom code within the 1541; this is typically used to
; implement fast-loaders and copy-protection schemes

;-------------------------------------------------------------------------------

; 5 internal buffers of 256 bytes are set aside for data read in from the
; disk surface:

.define C1541_BUFF0             $0300
.define C1541_BUFF1             $0400
.define C1541_BUFF2             $0500
.define C1541_BUFF3             $0600
.define C1541_BUFF4             $0700


; address to the current buffer to use
.define C1541_ZP_CURBUFF        $30
.define C1541_ZP_CURBUFF_LO     $30
.define C1541_ZP_CURBUFF_HI     $31

; table of track and sectors to use for each buffer
.define C1541_ZP_BUFF0_TRK      $06
.define C1541_ZP_BUFF0_SEC      $07
.define C1541_ZP_BUFF1_TRK      $08
.define C1541_ZP_BUFF1_SEC      $09
.define C1541_ZP_BUFF2_TRK      $0a
.define C1541_ZP_BUFF2_SEC      $0b
.define C1541_ZP_BUFF3_TRK      $0c
.define C1541_ZP_BUFF3_SEC      $0d
.define C1541_ZP_BUFF4_TRK      $0e
.define C1541_ZP_BUFF4_SEC      $0f

; job queue

.define C1541_ZP_JOB0           $00
.define C1541_ZP_JOB1           $01
.define C1541_ZP_JOB2           $02
.define C1541_ZP_JOB3           $03
.define C1541_ZP_JOB4           $04

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
        FORMAT_ERROR            = $00   ; only possible during format
        OK                      = $01   ; no error
        READ_ERROR_20           = $02
        READ_ERROR_21           = $03
        READ_ERROR_22           = $04
        READ_ERROR_23           = $05
        READ_ERROR_24           = $06   ; doesn't occur in practice
        WRITE_ERROR_25          = $07
        WRITE_PROTECT_ON        = $08
        READ_ERROR_27           = $09
        READ_ERROR_28           = $0a   ; doesn't occur in practice
        DISK_ID_MISMATCH        = $0b
        DRIVE_NOT_READY         = $0c
.endenum
