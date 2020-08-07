; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "code_docked_fns.inc" -- a series of in-string functions, assigned to the
; first 32 "docked" string tokens. these are stored as macros in this file
; because their physical location in the original code is all over the place

.macro  .tkn_docked_fn01_02
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_fn01:                                                        ;$246A
;===============================================================================
.export tkn_docked_fn01

        lda # %00000000
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

tkn_docked_fn02:                                                        ;$246D
;===============================================================================
.export tkn_docked_fn02

        lda # %00100000
        sta txt_lcase_mask

        lda # %00000000
        sta txt_lcase_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_flightTokens
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
use_flight_tokens:                                                      ;$2496
;===============================================================================
; begin printing flight-tokens in docked strings!
;
;-------------------------------------------------------------------------------
.export use_flight_tokens
        
        ; reset capitalisation?
        lda # %10000000
        sta ZP_34

        ; enable the flag that causes docked tokens to be
        ; interpretted as flight tokens instead
        lda # %11111111
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

use_docked_tokens:                                                      ;$249D
;===============================================================================
; stop flight-token printing in docked strings:
;
;-------------------------------------------------------------------------------
.export use_docked_tokens

        ; disable the flag that causes docked tokens to be
        ; interpretted as flight tokens instead
        lda # %00000000
        sta txt_flight_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn08
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_fn08:                                                        ;$2478
;===============================================================================
.export tkn_docked_fn08

        lda # 6
        jsr set_cursor_col

        lda # %11111111
        sta txt_ucase_flag

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_clearScreen
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_clearScreen:                                                 ;$2483
;===============================================================================
; move the cursor to the left and switch to an empty menu page:
; the game uses this for various interstitial screens such as
; "INCOMING MESSAGE"
;
;-------------------------------------------------------------------------------
.export tkn_docked_clearScreen

        lda # 1                 ;=page::empty
        jsr set_cursor_col
        jmp set_page

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn0D
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_fn0D:                                                        ;$248B
;===============================================================================
.export tkn_docked_fn0D
        
        ; enable the change-case flag?
        lda # %10000000
        sta txt_lcase_flag
        
        ; enable lower-casing
        lda # %00100000
        sta txt_lcase_mask

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_textBuffer
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
text_buffer_on:                                                         ;$24A3
;===============================================================================
; enable the text-buffer:
;
; this stops printing directly to the screen and holds new text in a buffer
; until it is released. this can be used to full-justify the text or inspect
; the characters in the buffer before they go to screen
;-------------------------------------------------------------------------------
.export text_buffer_on

        ; use a high-bit for the 'on' value
        lda # %10000000
        ; (this causes the next instruction to become a meaningless `bit`
        ;  instruction, a very handy way of skipping without branching)
       .bit

text_buffer_off:                                                        ;$24A6
;===============================================================================
; disable the text-buffer:
;
;-------------------------------------------------------------------------------
.export text_buffer_off
        
        lda # %00000000         ; 'off' value
        sta txt_buffer_flag     ; set the text-buffer flag

        ; reset the text-buffer's length / current index
        asl                     ; A=0 (shift the flag off, if present)
        sta txt_buffer_index    ; set the index to 0

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn_theirName
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_theirName:                                                   ;$2372
;===============================================================================
.export tkn_docked_theirName

        ; print a name from the docked token list:
        ; ("CURRUTHERS" / "FOSDYKE_SMYTHE" / "FORTESQUE")
.import MSG_DOCKED_CURRUTHERS:direct
        lda # MSG_DOCKED_CURRUTHERS
        bne _2378               ; (always branches)

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn_protoGalaxy
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_protoGalaxy:                                                 ;$2376
;===============================================================================
.export tkn_docked_protoGalaxy

        ; when receiving the mission for tracking down the prototype ship,
        ; the last part of the sentence "it went missing from our ship yard
        ; on Xeer five months ago and..." is appended with a message based
        ; upon the current galaxy number; it was probably intended to chase
        ; the prototype ship across multiple galaxies, but this idea appears
        ; to have been scrapped
        ;
.import MSG_DOCKED_IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY:direct
        lda # MSG_DOCKED_IS_BELIEVED_TO_HAVE_JUMPED_TO_THIS_GALAXY-1

_2378:  clc                                                             ;$2378
        adc PLAYER_GALAXY       ; add galaxy number to message index
        bne print_docked_str    ; (always branches)

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_provenance
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
target_system_provenance:                                                       ;$24B0
;===============================================================================
; print the name of the target system, with the -"ian" suffix:
; if the system's last letter is a vowel it is removed, e.g. "Lavian"
;
;-------------------------------------------------------------------------------
.export target_system_provenance

        ; remove any current capitalisation?
        lda ZP_34
        and # %10111111
        sta ZP_34

        ; print the target system name, e.g. "Lave"
        ; TODO: import this flight-token
        lda # $03
        jsr print_flight_token
        
        ldx txt_buffer_index    ; read the last character...
        lda TXT_BUFFER-1, x     ; ...in the text-buffer
        jsr is_vowel            ; is it a vowel?
        bcc :+                  ; if no, add the -"ian" suffix
        dec txt_buffer_index    ; if yes, remove the vowel!

        ; import the token for the -"ian" suffix (not Ian Bell!)
.import MSG_DOCKED_IAN:direct
:       lda # MSG_DOCKED_IAN                                            ;$24C9
        jmp print_docked_str

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .print_random_name
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
print_random_name:                                                      ;$24CE
;===============================================================================
; prints a randomised name:
;
;-------------------------------------------------------------------------------
.export print_random_name

        ; automatically capitalise the next letter, whatever it is
        jsr tkn_docked_capitalizeNext

        ; choose the length of the name:
        ; (this is in character pairs)
        ;
        jsr get_random_number   ; choose a random number,
        and # %00000011         ; between 0-7 (=2 to 16 characters)
        tay                     ; put length random number in Y

        ; choose a character pair:
        ;
@loop:  jsr get_random_number   ; choose a random number                ;$24D7
        and # %00111110         ; between 0 & 31, multiplied by 2
        tax                     ; put index aside in X

.import txt_pairs

        lda txt_pairs+0, x      ; read the first character of the pair
        jsr print_docked_char   ; print this...
        
        lda txt_pairs+1, x      ; read the second character of the pair
        jsr print_docked_char   ; print this...
        
        dey                     ; one less character pair to print
        bpl @loop               ; any remaining? keep printing...
        
        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_capitalizeNext
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_capitalizeNext:                                              ;$24ED
;===============================================================================
.export tkn_docked_capitalizeNext
        
        ; set ASCII upper-case
        lda # %11011111
        sta txt_ucase_mask

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn16_17_1D
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
tkn_docked_fn16:                                                        ;$3E41
;===============================================================================
.export tkn_docked_fn16
        
        jsr _3e65
        bne tkn_docked_fn16
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
        jsr set_cursor_row

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        jsr original_250b       ; dead code, just an RTS
.endif  ;///////////////////////////////////////////////////////////////////////
        
        jmp tkn_docked_fn0D

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_waitForAnyKey
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_incoming_message
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .tkn_docked_fn_media
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro