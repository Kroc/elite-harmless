; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; insert these docked token functions from "code_docked_fns.asm"
;
.tkn_docked_fn_theirName                                                ;$2372
.tkn_docked_fn_protoGalaxy                                              ;$2376

_237e:                                                                  ;$237E
;===============================================================================
; print a message from the message table at `_1a5c`
; rather than the standard one (`txt_docked`)
;-------------------------------------------------------------------------------
        ; push the current state:
        pha 
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; switch base-address of the message pool and jump into the print
        ; routine using this new address. note that in this case, X is the
        ; message-index to print
.import _1a5c
        
        lda # < _1a5c
        sta ZP_TEMP_ADDR3_LO
        lda # > _1a5c
        bne _23a0


print_docked_str:                                                       ;$2390
;===============================================================================
; prints one of the strings from "text_docked.asm"
;
; in:   A       message index of string to print
;
; out:  A, Y    preserves A, Y & ZP_TEMP_ADDR3
;               (due to recursion)
;-------------------------------------------------------------------------------
.import txt_docked

        pha                     ; preserve A (message index)
        tax                     ; move message index to X

        ; when recursing, [ZP_TEMP_ADDR3]+Y represent the
        ; current position in the message data
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; load the message table
        lda #< txt_docked
        sta ZP_TEMP_ADDR3_LO
        lda #> txt_docked
_23a0:                                                                  ;$23A0
        sta ZP_TEMP_ADDR3_HI
        ldy # $00

@skip_str:                                                              ;$23A4
        ;-----------------------------------------------------------------------
        ; skip over the messages until we find the one we want:
        ; -- this is insane!
        ;
.import TKN_DOCKED_XOR:direct

        lda [ZP_TEMP_ADDR3], y
        eor # TKN_DOCKED_XOR    ;=$57 -- descramble token
        bne :+                  ; keep going if not a message terminator ($00)
        dex                     ; message has ended, decrement index
        beq @read_token         ; if we've found our message, exit loop
:       iny                     ; move to next token                    ;$23AD
        bne @skip_str           ; if we haven't crossed the page, keep going
        inc ZP_TEMP_ADDR3_HI    ; move to the next page (256 bytes)
        bne @skip_str           ; and continue

@read_token:                                                            ;$23B4
        ;-----------------------------------------------------------------------
        iny                     ; step over the terminator byte ($00)
        bne :+                  ; did we step over the page boundary?
        inc ZP_TEMP_ADDR3_HI    ; if so, move forward to next page

:       ; read and descramble a token:                                  ;$23B9
        ;
        ; tokens: (descrambled)
        ;     $00 = invalid
        ; $01-$1F = format token, function varies
        ; $20-$40 = print ASCII chars $20-$40 (space, punctuation, numbers)
        ; $41-$5A = print ASCII characters @, A-Z
        ; $5B-$80 = planet description tokens
        ; $81-$D6 = text expansions
        ; $D7-$FF = some pre-defined character pairs ("text_pairs.asm")
        ;
        lda [ZP_TEMP_ADDR3], y  ; read a token
        eor # TKN_DOCKED_XOR    ;=$57 -- descramble token
        beq @rts                ; has message ended? (token $00)

        jsr print_docked_token
        jmp @read_token

@rts:   ; finished printing, clean up and exit                          ;$23C5
        ;-----------------------------------------------------------------------
        pla 
        sta ZP_TEMP_ADDR3_HI
        pla 
        sta ZP_TEMP_ADDR3_LO
       .ply 
        pla 

        rts 


print_docked_token:                                                     ;$23CF
;===============================================================================
        cmp # ' '               ; tokens less than $20 (space)
       .blt _format_code        ; are format codes

        bit txt_flight_flag     ; if flight string mode is off,
        bpl :+                  ; skip the next bit

        ; print a flight token instead of a docked token:
        ;-----------------------------------------------------------------------
        ; save state before we recurse
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 
        txa 

        ; print from the commonly shared 'flight' strings
        jsr print_flight_token

        jmp _2438

        ;-----------------------------------------------------------------------
        ; print docked token:
        ;
:       cmp # 'z'+1             ; letters "A" to "Z"?                   ;$23E8
       .blt print_docked_char   ; print letters, handling auto-casing

        cmp # $81               ; tokens $5B...$80?
       .blt _2441               ; handle planet description tokens

        cmp # $d7               ; tokens $81...$D6 are expansions,
       .blt print_docked_str    ; use the token as a message index

        ; tokens $D7 and above: (character pairs)
        ;-----------------------------------------------------------------------
.import tkn_docked_pair1
.import tkn_docked_pair2

        ; TODO: use a constant
        sbc # $d7               ; re-index as $00...$28
        asl                     ; double, for lookup-table
        pha                     ; (put aside)
        tax                     ; use as index to table
        lda tkn_docked_pair1, x ; read 1st character...
        jsr print_docked_char   ; ...and print it

        pla                     ; get the offset again
        tax                     ; use as index to table
        lda tkn_docked_pair2, x ; read 2nd character...
                                ; ...and print it (fallthrough)
        
print_docked_char:                                                      ;$2404
        ;-----------------------------------------------------------------------
        ; print the punctuation characters ($20...$40)
        ; as is, without changing case
        ;
        cmp # '@'+1
       .blt @print

        ; NOTE: all characters A-Z in the text database are stored
        ;       in upper-case and the game changes case as it goes
        ;
        ; check for the lower-case flag:
        bit txt_lcase_flag      ; check if bit 7 is set
        bmi @lcase              ; if so, skip ahead

        ; check for the upper-case flag:
        bit txt_ucase_flag      ; check if bit 7 is set
        bmi @ucase              ; if so, skip ahead

@lcase: ora txt_lcase_mask      ; lower case (if enabled)               ;$2412

@ucase: and txt_ucase_mask      ; upper case (if enabled)               ;$2415

@print: jmp print_char                                                  ;$2418


_format_code:                                                           ;$241B
        ;=======================================================================
        ; docked tokens $00..$1F are functions, each has a different behaviour:
        ; see "txt_docked.asm" for details

        ; snapshot current state:
        ; -- these format codes can get recursive
        tax 
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; multiply token by two
        ; (lookup into table)
        txa 
        asl 
        tax 

        ; note that the lookup table is indexed two-bytes early, making an
        ; index of zero land in some code -- this is why token $00 is invalid
        ;
        ; we read an address from the table and rewrite a `jsr` instruction
        ; further down, i.e. the token is a lookup to a routine to call
.import tkn_docked_functions

        lda tkn_docked_functions - 2, x
        sta @jsr + 1
        lda tkn_docked_functions - 1, x
        sta @jsr + 2

        ; convert the token back to its original value
        ; (to be used as a parameter for whatever we jump to)
        txa 
        lsr 

        ; NOTE: this address gets overwritten by the code above!!
@jsr:   jsr print_char                                                  ;$2435

_2438:  ; restore state and exit                                        ;$2438
        ;-----------------------------------------------------------------------
        pla 
        sta ZP_TEMP_ADDR3_HI
        pla 
        sta ZP_TEMP_ADDR3_LO
       .ply 
        rts 

_2441:  ; process msg tokens $5B..$80 (planet description tokens)       ;$2441
        ;-----------------------------------------------------------------------
        sta ZP_TEMP_ADDR1_LO    ; put token aside

        ; put aside our current location in the text data
       .phy                     ; push Y to stack (via A)
        lda ZP_TEMP_ADDR3_LO
        pha 
        lda ZP_TEMP_ADDR3_HI
        pha 

        ; choose planet description template 0-4:
        ;
        jsr get_random_number
        tax 
        lda # $00               ; select description template 0
        cpx # $33               ; is random number over $33?
        adc # $00               ; select description template 1
        cpx # $66               ; is random number over $66?
        adc # $00               ; select description template 2
        cpx # $99               ; is random number over $99?
        adc # $00               ; select description template 3
        cpx # $cc               ; is random number over $CC? note that if so,
                                ; carry is set, to be added later

        ; get back the token value and lookup another message index to print
        ; (since these tokens are $5B..$80, we index the table back $5B bytes)
        ;
.import _3eac
        
        ldx ZP_TEMP_ADDR1_LO
        adc _3eac - $5B, x      ; TODO: use a constant for $5B
        jsr print_docked_str    ; print the new message

        jmp _2438               ; clean up and exit


;===============================================================================
; insert these docked token functions from "code_docked_fns.asm"
;
.tkn_docked_caps                                                        ;$246A
.tkn_docked_fn08                                                        ;$2478
.tkn_docked_clearScreen                                                 ;$2483
.tkn_docked_fn0D                                                        ;$248B
.tkn_docked_flightTokens                                                ;$2496
.tkn_docked_textBuffer                                                  ;$24A3
.tkn_docked_provenance                                                  ;$24B0
.print_random_name                                                      ;$24CE
.tkn_docked_capitalizeNext                                              ;$24ED


is_vowel:                                                               ;$24F3
;===============================================================================
        ora # %00100000         ; force upper-case for comparison
        cmp # $61               ; 'A'?
        beq :+
        cmp # $65               ; 'E'?
        beq :+
        cmp # $69               ; 'I'?
        beq :+
        cmp # $6f               ; 'O'?
        beq :+
        cmp # $75               ; 'U'?
        beq :+

        clc 
:       rts                                                             ;$250A

.ifdef  OPTION_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
original_250b:                                                          ;$250B
;===============================================================================
        rts
;///////////////////////////////////////////////////////////////////////////////
.endif
