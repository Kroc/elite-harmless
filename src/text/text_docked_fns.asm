; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.macro  .txt_docked_token01_02
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token01:                                                     ;$246A
        ;=======================================================================
.export txt_docked_token01

        lda # %00000000

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token02:                                                     ;$246D
        ;=======================================================================
.export txt_docked_token02

        lda # %00100000
        sta txt_ucase_mask

        lda # %00000000
        sta txt_ucase_flag

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token06_05
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token06:                                                     ;$2496
        ;=======================================================================
.export txt_docked_token06
        
        lda # %10000000
        sta ZP_34
        lda # %11111111

        ; this causes the next instruction to become a meaningless `bit`
        ; instruction, a very handy way of skipping without branching
       .bit

txt_docked_token05:                                                     ;$249D
        ;=======================================================================
.export txt_docked_token05

        lda # %00000000
        sta txt_flight_flag

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token08
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token08:                                                     ;$2478
        ;=======================================================================
.export txt_docked_token08

        lda # 6
        jsr set_cursor_col

        lda # %11111111
        sta txt_lcase_flag

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token09
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token09:                                                     ;$2483
        ;=======================================================================
        ; switch to view "1"(?)
        ;
.export txt_docked_token09

        lda # 1
        jsr set_cursor_col

        jmp set_page

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token0D
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token0D:                                                     ;$248B
        ;=======================================================================
.export txt_docked_token0D
        
        ; enable the change-case flag?
        lda # %10000000
        sta txt_ucase_flag
        
        ; enable upper-casing
        lda # %00100000
        sta txt_ucase_mask

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token0E_0F
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token0E:                                                     ;$24A3
        ;=======================================================================
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

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token1B
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token1B:                                                     ;$2372
        ;=======================================================================
.export txt_docked_token1B

        ; print some message from msg index $D9(217)+?
        ; ("CURRUTHERS" / "FOSDYKE_SMYTHE" / "FORTESQUE")
        lda # $d9
        bne _2378               ; always branches

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token1C
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token1C:                                                     ;$2376
        ;=======================================================================
.export txt_docked_token1C

        ; print some message from msg index $DC(220)+?
        lda # $dc
_2378:                                                                  ;$2378
        clc 
        adc PLAYER_GALAXY
        bne print_docked_str    ; always branches

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token11
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token11:                                                     ;$24B0
        ;=======================================================================
.export txt_docked_token11

        lda ZP_34
        and # %10111111         ;=$BF
        sta ZP_34

        lda # $03
        jsr print_flight_token
        
        ldx txt_buffer_index
        lda $0647, x
        jsr is_vowel
        bcc _24c9
        dec txt_buffer_index
_24c9:                                                                  ;$24C9
        lda # $99
        jmp print_docked_str

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token12
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token12:                                                     ;$24CE
        ;=======================================================================
.export txt_docked_token12

        jsr txt_docked_token_set_lowercase

        jsr get_random_number
        and # %00000011
        tay 
_24d7:                                                                  ;$24D7
        jsr get_random_number
        and # %00111110
        tax 

.import _254e

        lda _254e+0, x
        jsr _2404
        
        lda _254e+1, x
        jsr _2404
        
        dey 
        bpl _24d7
        
        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro

.macro  .txt_docked_token_set_lowercase ;(docked token $13)
;///////////////////////////////////////////////////////////////////////////////

txt_docked_token_set_lowercase:                                         ;$24ED
        ;=======================================================================
.export txt_docked_token_set_lowercase
        
        ; msg token $13
        ;
        lda # %11011111
        sta txt_lcase_mask

        rts 

;///////////////////////////////////////////////////////////////////////////////
.endmacro