; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; a series of in-string functions, assigned to the first 32 "docked" string
; tokens. these are separated into segments in this file because their
; physical location in the original code is all over the place
;
.segment        "CODE_3E41"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

tkn_docked_fn16:                                                        ;$3E41
;===============================================================================
.export tkn_docked_fn16
        
        jsr _3e65
        bne tkn_docked_fn16
_3e46:                                                                  ;$3E46
        jsr _3e65
        beq _3e46
        
        ; this might be a temporary variable and not the ship state
        lda # %00000000
        sta ZP_SHIP_STATE
        
        lda # page::empty
        jsr set_page

        jsr draw_ship           ; TODO: unusual here?

tkn_docked_fn17:                                                        ;$3E57  
;===============================================================================
.export tkn_docked_fn17

        lda # 10
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

tkn_docked_fn1D:                                                        ;$3E5A
;===============================================================================
.export tkn_docked_fn1D

        lda # 6
       .set_cursor_row

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr original_250b       ; dead code, just an RTS
.endif  ;///////////////////////////////////////////////////////////////////////
        
        jmp tkn_docked_fn0D


.segment        "CODE_3E7C"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

tkn_docked_waitForAnyKey:                                               ;$3E7C
;===============================================================================
; press any key!
;
;-------------------------------------------------------------------------------
.export tkn_docked_waitForAnyKey
        
        ; check for key down...
        jsr get_input
        ; keep checking until non-zero value
        bne tkn_docked_waitForAnyKey

        ; check for key up...
        jsr get_input
        ; keep checking until zero (no key pressed)
        beq tkn_docked_waitForAnyKey
        
        rts 


.segment        "CODE_3E37"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

tkn_docked_incoming_message:                                            ;$3E37
;===============================================================================
; print "INCOMING MESSAGE" on screen and wait a bit
;
;-------------------------------------------------------------------------------
.export tkn_docked_incoming_message

        ; print "INCOMING MESSAGE"
        ;
.import MSG_DOCKED_INCOMING_MESSAGE:direct
        lda # MSG_DOCKED_INCOMING_MESSAGE
        jsr print_docked_str

        ; wait 100 frames
        ;
        ldy # 100
        jmp wait_frames


.segment        "CODE_8AB5"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

tkn_docked_fn_mediaCurrent:                                             ;$8AB5
;===============================================================================
; print the currently selected load/save media: "disk" or "tape"
;
;-------------------------------------------------------------------------------
.export tkn_docked_fn_mediaCurrent
.import MSG_DOCKED_TAPE:direct

        lda # MSG_DOCKED_TAPE   ; $02 = "DISK", $03 = "TAPE"
        clc                     ; add the following:
        adc opt_device          ; $FF = disk,   $00 = tape
        jmp print_docked_str    ; $02 = "DISK", $03 = "TAPE"


tkn_docked_fn_mediaOther:                                               ;$8ABE
;===============================================================================
; print the opposite of the currently selected load/save media,
; "disk" or "tape"
;
;-------------------------------------------------------------------------------
.export tkn_docked_fn_mediaOther
.import MSG_DOCKED_MEDIAS:direct

        lda # MSG_DOCKED_MEDIAS ; $02 = "DISK", $03 = "TAPE"
        sec                     ; subtract the following:
        sbc opt_device          ; $FF = disk,   $00 = tape
        jmp print_docked_str    ; $02 = "DISK", $03 = "TAPE"