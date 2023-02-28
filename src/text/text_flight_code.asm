; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_7717"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

_7717:                                                                  ;$7717
;===============================================================================
; print commander's (your) name
;
;-------------------------------------------------------------------------------
        ldy # $00
:       lda VAR_0491, y                                                 ;$7719
        cmp # $0d
        beq :+
        jsr print_char
        iny 
        bne :-

:       rts                                                             ;$7726 


print_local_planet_name:                                                ;$7727
;===============================================================================
; print the name of the system the player is currently in
;
;-------------------------------------------------------------------------------
        bit IS_WITCHSPACE       ; if the player is in witchspace,
        bmi @rts                ; there is no sun / planet!

        jsr :+                  ; copy the seed for name-expansion
        jsr _76e9

:       ldx # $05                                                       ;$7732

@loop:  lda ZP_SEED, x                                                  ;$7734
        ldy VAR_04F4, x
        sta VAR_04F4, x
        sty ZP_SEED, x
        dex 
        bpl @loop

@rts:   rts                                                             ;$7741


print_galaxy_no:                                                        ;$7742
;===============================================================================
; print galaxy number:
;
;-------------------------------------------------------------------------------
        clc 
        ldx PLAYER_GALAXY       ; current galaxy number
        inx                     ; print as 1-8, not 0-7
        jmp print_tiny_value


print_fuel_and_cash:                                                    ;$774A
;===============================================================================
; print fuel & cash totals:
;
;-------------------------------------------------------------------------------

        ; print "FUEL:"
.import TKN_FLIGHT_FUEL:direct
        lda # TKN_FLIGHT_FUEL
        jsr print_flight_token_with_colon

        ; print the player's fuel quantity
        ldx PLAYER_FUEL
        sec                             ; use decimal point
        jsr print_tiny_value

        ; print "LIGHT YEARS"
.import TKN_FLIGHT_LIGHT_YEARS:direct
        lda # TKN_FLIGHT_LIGHT_YEARS
        jsr print_flight_token_and_newline

        ; TODO: just use `print_flight_token_and_colon`, no?
.import TKN_FLIGHT_CASH_:direct
        lda # TKN_FLIGHT_CASH_  ; "CASH:" (colon in the string)
        bne print_flight_token

        ; print cash value?
_775f:                                                                  ;$775F
        ldx # 3

        ; copy $04A2..$04A5 to $77..$7A?
:       lda PLAYER_CASH, x                                              ;$7761
        sta ZP_VALUE, x
        dex 
        bpl :-

        lda # $09               ; align to 10 digits
        sta U

        sec                     ; set carry flag - use decimal point
        jsr print_large_value   ; convert value to string

        ; print "CR" ("credits") after the cash value
.import TKN_FLIGHT_CR:direct
        lda # TKN_FLIGHT_CR
        ;
        ; fall-through below to print "CR" and new-line
        ;

print_flight_token_and_newline:                                         ;$7773
;===============================================================================
        jsr print_flight_token
        jmp print_newline


print_flight_token_with_colon:                                          ;$7779
;===============================================================================
; prints the flight token in A and appends a colon character:
;
; in:   A       an already *de-scrambled* flight token
;-------------------------------------------------------------------------------
        jsr print_flight_token

        ; fallthrough
        ; ...

print_colon:                                                            ;$777C
;===============================================================================
; prints a colon, nothing else:
;
;-------------------------------------------------------------------------------
        lda # ':'

        ; fallthrough
        ; ...

print_flight_token:                                                     ;$777E
;===============================================================================
; prints an already *de-scrambled* flight token:
;
; this can be a single letter, a variable (like cash or planet name),
; a string-expansion, or a meta-command
;
; in:   A       an already *de-scrambled* string token
;
; brief token breakdown:
;
;      $00 = print "cash:" & cash value
;      $01 = print current galaxy number?
;      $02 = print current system name
;      $03 = print target system name
;      $04 = print commander's name
;      $05 = ?
;      $06 = ?
;      $07 = ?
;      $08 = ?
;      $09 = ?
;      $0A = ?
;      $0B = ?
;      $0C = newline
;      $0D = (also newline)
;  $0E-$20 = canned messages 128-146
;  $21-$5F = ASCII characters $21-$5F -- see "gfx/gfx_font.asm"
;  $60-$7F = canned messages  96-127
;  $80-$9F = flight letter pairs 0-31
;  $A0-$FF = canned messages 0-95
;-------------------------------------------------------------------------------
.export print_flight_token

        tax                     ; put aside token for later test

        ; handle variables / meta-commands:
        ;-----------------------------------------------------------------------
        ; token $00:
        ;
.export TKN_FLIGHT_FN_PLAYER_CASH = $00
       .bze _775f               ; is A 0? -- print "Cash: " and credit count

        ; token $80-$FF:
        ;
        ; any token value 128 or higher (i.e. bit 7 set) is a
        ; canned-message, the index of which is in the remaining bits
        ;
        bmi _print_str          ; is bit 7 set? (i.e. is token)

        ; token $01:
        ;
        dex                     ; decrement token value
       .bze print_galaxy_no     ; if now 0, it was 1 -- print galaxy number

        ; token $02:
        ;
        dex                     ; decrement token value
                                ; if now 0, it was 2 -- print local planet name
       .bze print_local_planet_name

        ; token $03:
        ;
        dex                     ; decrement token value
       .bnz :+                  ; skip ahead if it isn't now zero
        jmp _76e9               ; it was 3 -- print target planet name

        ; token $04:
        ;
:       dex                     ; decrement token value                 ;$778F
       .bze _7717               ; if now 0, it was 4 -- commander's name

        ; token $05:
        ;
        dex                     ; decrement token value
       .bze print_fuel_and_cash ; if now 0, it was 5 -- print fuel & cash

        dex                     ; decrement token value
       .bnz :+                  ; skip ahead if not 0

        ; token $06:
        ;
        lda # %10000000         ; put 128 (bit 7) into A
        sta ZP_PRINT_CASE       ; set case-switch flag
        rts 

        ; NOTE: token $07 will fall through here
        ;       and be handled later!

        ; token $08:
        ;
:       dex                     ; decrement token value twice more      ;$779D
        dex                     ; i.e. if it was 8, it would be 0
       .bnz :+                  ; skip ahead if token was not originally 8
        stx ZP_PRINT_CASE       ; token was 8, store the 0 in the case-switch
        rts                     ;  flag (0 = ALL-CAPS?) and return

        ; token $09:
        ;
:       dex                     ; decrement token again                 ;$77A4
       .bze _indent             ; if token was 9, process a tab

        ; NOTE: A is still the original token number,
        ;       only X has been decremented!

        ; tokens 96...127 are canned messages
        ; (tokens 128...255 have already been checked for above)
        cmp # $60
       .bge print_canned_message

        ; tokens $0A-$0D will be passed through to the character printing
        ; routine where they are special-cased as ASCII codes $09-$0D are
        ; not printable characters!
        ;
        cmp # $0e               ; tokens < $0E that have not already been done
       .blt :+                  ; skip ahead

        cmp # $20               ; tokens < 32?
       .blt _77db               ; treat as token A+114

        ; switch case?
        ;
:       ldx ZP_PRINT_CASE       ; check case-switch flag                ;$77B3
        beq _77f6               ; =0, leave case as-is and print char
        bmi _is_captial         ; or bit 7 set, switch case

        bit ZP_PRINT_CASE       ; check bits 7 & 6 (bit 7 already handled)
        bvs _77ef               ; bit 6 set -- print char and reset bit 6

_77bd:                                                                  ;$77BD
        ;-----------------------------------------------------------------------
        ; print in lower-case:
        ; first though, print any non A-Z character without changing case
        ;
        cmp # 'a'               ; less than 'A'?
        bcc _goto_print_char    ; yes: print as is

        cmp # 'z'+1             ; higher than 'Z'?
        bcs _goto_print_char    ; yes: print as is

        adc # $20               ; otherwise shift letter into lower-case

_goto_print_char:                                                       ;$77C7
        jmp print_char          ; just print char

_is_captial:                                                            ;$77CA
        ;-----------------------------------------------------------------------
        bit ZP_PRINT_CASE       ; bit 6 set?
        bvs _77e7

        cmp # 'a'               ; less than 'A'?
        bcc _77f6               ; yes: print as is

        pha 
        txa 

        ; set bit 6 on the case-switch flag
        ora # %01000000
        sta ZP_PRINT_CASE

        pla 
        bne _goto_print_char    ; print character as-is, but next will be
                                ; lower-cased (bit 6 of case-flag)

_77db:  ; add 114 to the token number and print the canned message:     ;$77DB
        adc # 114
        bne print_canned_message

_indent:                                                                ;$77DF
        ;-----------------------------------------------------------------------
        ; set cursor to column 22
        ;
        lda # 21
       .set_cursor_col
        jmp print_colon

        ;-----------------------------------------------------------------------

_77e7:  ; don't do anything if case-switch flag = %11111111             ;$77E7
        cpx # $ff
        beq rts_784e

        ; if 'A' or above, print in lower-case
        cmp # 'a'
        bcs _77bd

        ; clear bit-6 of case-switch flag
_77ef:  pha                                                             ;$77EF
        txa 
        and # %10111111
        sta ZP_PRINT_CASE
        pla 

_77f6:  jmp print_char                                                  ;$77F6


_print_str:                                                             ;$77F9
        ;-----------------------------------------------------------------------
        ; note that canned message tokens have bit 7 set, so really this is
        ; asking if the message index is > 32 -- the first 32 canned messages
        ; are letter pairs
        ;
        cmp # 160               ; is token >= 160?
       .bge @canned_token       ; if yes, go to canned messages 33+

        ; token is a character pair:
        ;
        and # %01111111         ; clear token flag, leave message index
        asl                     ; double it for a lookup-table offset,
        tay                     ; this would have cleared bit 7 anyway!
        lda TKN_FLIGHT_pair1, y ; read the first character,
        jsr print_flight_token  ; print it
        lda TKN_FLIGHT_pair2, y ; read second character
        cmp # $3f               ; no second character? (print nothing)
        beq rts_784e            ; yes, skip
        jmp print_flight_token  ; print second character (and return)

@canned_token:                                                          ;$7811
        ; token messages 160+; subtract 160 for the message index
        sbc # 160

        ; fallthrough
        ; ...

print_canned_message:                                                   ;$7813
;===============================================================================
; prints a canned message from the messages table:
;
; in:   A                       message index
;-------------------------------------------------------------------------------
        tax                     ; put the message index aside

        ; select the table of canned-messages
        lda #< _0700
        sta ZP_TEMP_ADDR2_LO
        lda #> _0700
        sta ZP_TEMP_ADDR2_HI

        ; initialise loop counter
        ldy # $00

        ; ignore message no.0,
        ; i.e. you can't skip zero messages
        txa                     ; return the original message index
        beq print_flight_token_string

@skip_message:                                                           ;$7821

        lda [ZP_TEMP_ADDR2], y  ; read a code from the compressed text
        beq :+                  ; if zero terminator, end string
        iny                     ; next character
        bne @skip_message       ; loop if not at 256 chars
        inc ZP_TEMP_ADDR2_HI    ; move to the next page,
        bne @skip_message       ; and keep reading

:       iny                     ; move forward over the zero            ;$782C
        bne :+                  ; skip if we haven't overflowed a page
        inc ZP_TEMP_ADDR2_HI    ; next page if the zero happened there
:       dex                     ; decrement message skip counter        ;$7831
        bne @skip_message       ; keep looping if we haven't reached
                                ; the desired message index yet

print_flight_token_string:                                              ;$7834
        ;-----------------------------------------------------------------------
        ; remember the current index
        ; (this routine can call recursively)
       .phy                     ; push Y to stack (via A)
        ; remember the current page
        lda ZP_TEMP_ADDR2_HI
        pha 

        ; get the 'key' used for de-scrambling the text
        ; (see "text_flight.asm")
.import TKN_FLIGHT_XOR:direct

        lda [ZP_TEMP_ADDR2], y  ; read a token
        eor # TKN_FLIGHT_XOR    ; 'descramble' token
        jsr print_flight_token  ; process it

        ; restore the previous page
        pla 
        sta ZP_TEMP_ADDR2_HI
        ; and index
        pla 
        tay 

        iny                     ; next character
        bne :+                  ; overflowed the page?
        inc ZP_TEMP_ADDR2_HI    ; move to the next page

        ; is this the end of the string?
        ; (check for a $00 token)
:       lda [ZP_TEMP_ADDR2], y                                          ;$784A
        bne print_flight_token_string

rts_784e:                                                               ;$784E
        rts