; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>

.segment        "CODE_8AE7"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_SVE:                                                   ; BBC: SVE      ;$8AE7
;===============================================================================
; data menu
;-------------------------------------------------------------------------------
        ; display the data menu on screen
        ;
.import MSG_DOCKED_DATA_MENU:direct
        lda # MSG_DOCKED_DATA_MENU
        jsr print_docked_str

        jsr wait_for_input
        cmp # '1'               ; 1: "Load New Commander"
        beq @load
        cmp # '2'               ; 2: "Save Commander"
        beq @save
        cmp # '3'               ; 3: "Change to Tape|Disk"
        beq @media
        cmp # '4'               ; 4: "Default JAMESON"
        
        bne @exit               ; 5: (any other key) -> exit

        ; reset to default commander:
        ;
.import MSG_DOCKED_ARE_YOU_SURE:direct
        lda # MSG_DOCKED_ARE_YOU_SURE
        jsr print_docked_str

        jsr _GETYN
        bcc @exit

        jsr _8a0c               ; reset save data to default
        jmp _88f0

        ; exit save menu, no change:
        ;=======================================================================
@exit:  clc                                                             ;$8B0F
        rts 

        ; change disk to tape and vice versa:
        ;=======================================================================
@media: lda opt_device          ; current device $FF = disk, $00 = tape ;$8B11
        eor # %11111111         ; flip!
        sta opt_device          ; write back
        jmp _SVE                ; redraw menu

        ; load commander:
        ;=======================================================================
@load:  jsr _8a38                                                       ;$8B1C
        jsr _8c0d
        jsr _8a1d
        sec 
        rts 

        ; save commander:
        ;=======================================================================
@save:  jsr _8a38                                                       ;$8B27
        jsr _8a1d
        lsr VAR_04E2

.import MSG_DOCKED_COMPETITION_NUMBER:direct
        lda # MSG_DOCKED_COMPETITION_NUMBER
        jsr print_docked_str

        ; copy $0499..$04E5 (data to be saved?)
        ldx # $4c
:       lda MISSION_FLAGS, x                                            ;$8B37
        sta checksum_data, x
        dex 
        bpl :-

        jsr calc_checksum2
        sta checksum2
        jsr calc_checksum1
        sta checksum1
        pha 
        ora # %10000000
        sta ZP_VALUE_pt1
        eor PLAYER_COMPETITION
        sta ZP_VALUE_pt3
        eor PLAYER_CASH_pt3     ;?
        sta ZP_VALUE_pt2
        eor # %01011010
        eor PLAYER_KILLS_HI
        sta ZP_VALUE_pt4
        clc 
        jsr print_large_value
        jsr print_newline
        jsr print_newline
        pla 
        eor # %10101001
        sta checksum_bytes
        jsr _8bc0               ; NOTE: enables KERNAL

        lda #< checksum_data
        sta ZP_FD
        lda #> checksum_data
        sta ZP_FE

        ; save to disk:
        ; the linker will define the location and size of the save-data block
.import __SAVE_DATA_RUN__
.import __SAVE_DATA_SIZE__

        ; data is located at the pointer in $FD/$FE
        lda # ZP_FD
        ldx #< (__SAVE_DATA_RUN__ + __SAVE_DATA_SIZE__)
        ldy #> (__SAVE_DATA_RUN__ + __SAVE_DATA_SIZE__)
        jsr KERNAL_SAVE
        php 

        sei 
        bit CIA1_INTERRUPT
        lda # %00000001
        sta CIA1_INTERRUPT

        ldx # $00
        stx interrupt_split
        inx 
        stx VIC_INTERRUPT_CONTROL

        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1

        lda # 40                ; raster line 40
        sta VIC_RASTER

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn KERNAL & I/O area off
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL         ; turn off KERNAL
        dec CPU_CONTROL         ; turn off I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        cli 
        jsr swap_zp_shadow
        plp 
        cli 
        bcs :+
        jsr _88f0               ; rest game to last-saved state?
        jsr wait_for_input

        clc 
        rts 

:       jmp _8c61                                                       ;$8BBB


;===============================================================================
_8bbe:                                                                  ;$8BBE
        .byte   $07             ; file name length?
_8bbf:                                                                  ;$8BBF
        .byte   $07

_8bc0:                                                                  ;$8BC0
        jsr swap_zp_shadow

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        lda # C64_MEM::IO_KERNAL
        sei                     ; disable interrupts
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        sei                     ; disable interrupts
        inc CPU_CONTROL         ; turn on I/O
        inc CPU_CONTROL         ; turn on KERNAL
.endif  ;///////////////////////////////////////////////////////////////////////

        lda # %00000000
        sta VIC_INTERRUPT_CONTROL
        cli 
        lda # %10000001
        sta CIA1_INTERRUPT

        lda # $c0               ;?
        jsr KERNAL_SETMSG

        ; select TAPE or DISK
        ldx opt_device          ; selected load/save device (disk/tape)
        inx                     ; $FF = disk, $00 = tape?
        lda _8c0b, x            ; $00 = disk, $01 = tape
        tax                     ; X = device ID

        lda # $01               ; logical file number
        ldy # $00               ; secondary address
        jsr KERNAL_SETLFS       ; note that X is device ID

        ; TODO: why should the filename be in $0E??
        lda _8bbe               ; filename length
        ldx # $0e               ; $000E?
        ldy # $00               ; X.Y is filename address
        jmp KERNAL_SETNAM

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ;bug / unused code? (`jmp` instead of `jsr` above)
        ;
        ; print "disk"
.import MSG_DOCKED_MEDIAS:direct
        lda # MSG_DOCKED_MEDIAS
        jsr print_docked_str

        jsr wait_for_input
        ora # %00010000
        jsr paint_char
        pha 
        jsr print_crlf
        pla 
        cmp # $30
        bcc _8c53
        cmp # $34

        rts 
.endif  ;///////////////////////////////////////////////////////////////////////

_8c0b:  ; device number table                                           ;$8C0B
        ;-----------------------------------------------------------------------
        ; TODO: remove tape code
        ;
        .byte   DEV_DRV8
        .byte   DEV_TAPE


_8c0d:                                                                  ;$8C0D
;===============================================================================
        jsr _8bc0               ; select drive & filename?
                                ; NOTE: enables KERNAL

        ; load the file into the disk buffer
        lda # $00               ; "LOAD"
        ldx #< ELITE_DISK_BUFFER
        ldy #> ELITE_DISK_BUFFER
        jsr KERNAL_LOAD

        ; push load result to stack
        ; (carry is set if there was an error)
        php 

        lda # %00000001
        sta CIA1_INTERRUPT
        sei 

        ldx # $00
        stx interrupt_split
        inx 
        stx VIC_INTERRUPT_CONTROL

        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1

        lda # 40                ; raster line 40
        sta VIC_RASTER

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn off KERNAL & I/O, go back to 64K RAM
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL         ; turn off KERNAL
        dec CPU_CONTROL         ; turn off I/O
.endif  ;///////////////////////////////////////////////////////////////////////

        cli 
        jsr swap_zp_shadow      ; why is this needed?

        ; check the result of the load
        plp 
        cli 
        bcs _8c61               ; carry set = error
        lda ELITE_DISK_BUFFER
        bmi _illegal

        ; copy the save file from the disk buffer over the current data?
        ; copy $CF00...$CF4C to $25B3...$25FF
        ldy # 76                ; length is $FF-$4C

:       lda ELITE_DISK_BUFFER, y                                        ;$8C4A
        sta checksum_data, y
        dey 
        bpl :-
_8c53:                                                                  ;$8C53
        sec 
        rts 

_illegal:                                                               ;$8C55
        ;-----------------------------------------------------------------------
        ; file is invalid
        ;
.import MSG_DOCKED_ILLEGAL_FILE:direct
        lda # MSG_DOCKED_ILLEGAL_FILE   ; display "illegal Elite II file"
        jsr print_docked_str

        jsr wait_for_input              ; press any key
        jmp _SVE

.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
_8c60:  rts                                                             ;$8C60
;///////////////////////////////////////////////////////////////////////////////
.endif

_8c61:                                                                  ;$8C61
.import MSG_DOCKED_ERROR:direct
        lda # MSG_DOCKED_ERROR
        jsr print_docked_str

        jsr wait_for_input
        jmp _SVE

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        rts                     ; not needed due to `jmp` above
.endif  ;///////////////////////////////////////////////////////////////////////
