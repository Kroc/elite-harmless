; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "text_docked_fns.inc" -- a series of in-string functions, assigned to the
; first 32 "docked" string tokens. these are stored as macros in this file
; because their physical location in the original code is all over the place

.macro  .txt_docked_token01_02
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token01:                                                     ;$246A
;-------------------------------------------------------------------------------
.export txt_docked_token01

        lda # %00000000

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token02:                                                     ;$246D
;-------------------------------------------------------------------------------
.export txt_docked_token02

        lda # %00100000
        sta txt_ucase_mask

        lda # %00000000
        sta txt_ucase_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token06_05
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token06:                                                     ;$2496
;-------------------------------------------------------------------------------
.export txt_docked_token06
        
        lda # %10000000
        sta ZP_34
        lda # %11111111

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token05:                                                     ;$249D
;-------------------------------------------------------------------------------
.export txt_docked_token05

        lda # %00000000
        sta txt_flight_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token08
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token08:                                                     ;$2478
;-------------------------------------------------------------------------------
.export txt_docked_token08

        lda # 6
        jsr set_cursor_col

        lda # %11111111
        sta txt_lcase_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_clearScreen
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_clearScreen:                                                 ;$2483
;-------------------------------------------------------------------------------
; move the cursor to the left and switch to an empty menu page:
; the game uses this for various interstitial screens such as
; "INCOMING MESSAGE"
;
.export txt_docked_clearScreen

        lda # 1                 ;=page::empty
        jsr set_cursor_col
        jmp set_page

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token0D
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token0D:                                                     ;$248B
;-------------------------------------------------------------------------------
.export txt_docked_token0D
        
        ; enable the change-case flag?
        lda # %10000000
        sta txt_ucase_flag
        
        ; enable upper-casing?
        lda # %00100000
        sta txt_ucase_mask

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token0E_0F
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token0E:                                                     ;$24A3
;-------------------------------------------------------------------------------
.export txt_docked_token0E

        lda # %10000000

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token0F:                                                     ;$24A6
        ;=======================================================================
.export txt_docked_token0F
        
        lda # %00000000
        sta txt_buffer_flag
        asl 
        sta txt_buffer_index
        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_tokens_theirName_protoGalaxy
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_theirName:                                                   ;$2372
;-------------------------------------------------------------------------------
.export txt_docked_theirName

        ; print a name from the docked token list:
        ; ("CURRUTHERS" / "FOSDYKE_SMYTHE" / "FORTESQUE")
.import TXT_DOCKED_CURRUTHERS:direct
        lda # TXT_DOCKED_CURRUTHERS
        bne _2378               ; (always branches)

txt_docked_protoGalaxy:                                                 ;$2376
;-------------------------------------------------------------------------------
.export txt_docked_protoGalaxy

        ; when receiving the mission for tracking down the prototype ship,
        ; the last part of the sentence "it went missing from our ship yard
        ; on Xeer five months ago and..." is appended with a message based
        ; upon the current galaxy number; it was probably intended to chase
        ; the prototype ship across multiple galaxies, but this idea appears
        ; to have been scrapped
        ;
.import TXT_DOCKED_IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY:direct
        lda # TXT_DOCKED_IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY-1

_2378:  clc                                                             ;$2378
        adc PLAYER_GALAXY       ; add galaxy number to message index
        bne print_docked_str    ; (always branches)

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token11
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token11:                                                     ;$24B0
;-------------------------------------------------------------------------------
.export txt_docked_token11

        lda ZP_34
        and # %10111111         ;=$BF
        sta ZP_34

        lda # $03               ;?
        jsr print_flight_token
        
        ldx txt_buffer_index
        lda VAR_0647, x
        jsr is_vowel
        bcc _24c9
        dec txt_buffer_index
_24c9:                                                                  ;$24C9
        lda # $99
        jmp print_docked_str

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token12
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token12:                                                     ;$24CE
;-------------------------------------------------------------------------------
.export txt_docked_token12

        jsr txt_docked_capitalizeNext

        jsr get_random_number
        and # %00000011
        tay 
_24d7:                                                                  ;$24D7
        jsr get_random_number
        and # %00111110
        tax 

.import _254e

        lda _254e+0, x
        jsr print_docked_char
        
        lda _254e+1, x
        jsr print_docked_char
        
        dey 
        bpl _24d7
        
        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_capitalizeNext ;(docked token $13)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_capitalizeNext:                                              ;$24ED
;-------------------------------------------------------------------------------
.export txt_docked_capitalizeNext
        
        ; set ASCII upper-case (for next character)
        lda # %11011111
        sta txt_lcase_mask

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token16_17_1D
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

txt_docked_token16:                                                     ;$3E41
;-------------------------------------------------------------------------------
.export txt_docked_token16
        
        jsr _3e65
        bne txt_docked_token16
_3e46:                                                                  ;$3E46
        jsr _3e65
        beq _3e46
        
        ; this might be a temporary variable and not the visibility state
        lda # %00000000
        sta ZP_POLYOBJ_VISIBILITY
        
        ; switch to page "1"(?)
        lda # $01
        jsr set_page

        jsr _9a86

txt_docked_token17:                                                     ;$3E57  
;-------------------------------------------------------------------------------
.export txt_docked_token17

        lda # 10
        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token1D:                                                     ;$3E5A
;-------------------------------------------------------------------------------
.export txt_docked_token1D

        lda # 6
        jsr set_cursor_row

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr original_250b       ; dead code, just an RTS
.endif  ;///////////////////////////////////////////////////////////////////////
        
        jmp txt_docked_token0D

_3e65:                                                                  ;$3E65
        ;-----------------------------------------------------------------------
        lda # $50
        sta ZP_POLYOBJ_YPOS_LO

        lda # $00
        sta ZP_POLYOBJ_XPOS_LO
        sta ZP_POLYOBJ_ZPOS_LO
        
        lda # $02
        sta ZP_POLYOBJ_ZPOS_MI
        
        jsr _9a86
        jsr _a2a0
        
        jmp get_input

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_waitForAnyKey
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; press any key!
;
txt_docked_waitForAnyKey:                                               ;$3E7C
;-------------------------------------------------------------------------------
.export txt_docked_waitForAnyKey
        
        ; check for key down...
        jsr get_input
        ; keep checking until non-zero value
        bne txt_docked_waitForAnyKey

        ; check for key up...
        jsr get_input
        ; keep checking until zero (no key pressed)
        beq txt_docked_waitForAnyKey
        
        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_incoming_message
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print "INCOMING MESSAGE" on screen and wait a bit
;
txt_docked_incoming_message:                                            ;$3E37
;-------------------------------------------------------------------------------
.export txt_docked_incoming_message

        ; print "INCOMING MESSAGE"
        ;
.import TXT_DOCKED_INCOMING_MESSAGE:direct
        lda # TXT_DOCKED_INCOMING_MESSAGE
        jsr print_docked_str

        ; wait 100 frames
        ;
        ldy # 100
        jmp wait_frames

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token_mediaCurrent
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print the currently selected load/save media: "disk" or "tape"
;
txt_docked_token_mediaCurrent:                                          ;$8AB5
;-------------------------------------------------------------------------------
.export txt_docked_token_mediaCurrent

.import TXT_DOCKED_TAPE:direct
        lda # TXT_DOCKED_TAPE   ; $02 = "DISK", $03 = "TAPE"
        clc                     ; add the following:
        adc opt_device          ; $FF = disk,   $00 = tape
        jmp print_docked_str    ; $02 = "DISK", $03 = "TAPE"

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .txt_docked_token_mediaOther
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; print the opposite of the currently selected load/save media,
; "disk" or "tape"
;
txt_docked_token_mediaOther:                                            ;$8ABE
;-------------------------------------------------------------------------------
.export txt_docked_token_mediaOther
.import TXT_DOCKED_DISK:direct

        lda # TXT_DOCKED_DISK   ; $02 = "DISK", $03 = "TAPE"
        sec                     ; subtract the following:
        sbc opt_device          ; $FF = disk,   $00 = tape
        jmp print_docked_str    ; $02 = "DISK", $03 = "TAPE"

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro