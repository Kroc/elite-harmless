; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; it was probably expected, or intended, that cursor movement be more
; advanced on the C64 but in the end these routines just waste cycles

.macro  .cursor_down
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.ifdef  BUILD_ORIGINAL
        jsr cursor_down
.else
        inc ZP_CURSOR_ROW
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .cursor_down_jmp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.ifdef  BUILD_ORIGINAL
        jmp cursor_down
.else
        inc ZP_CURSOR_ROW
        rts
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .set_cursor_col
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.ifdef  BUILD_ORIGINAL
        jsr set_cursor_col
.else
        sta ZP_CURSOR_COL
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .set_cursor_row
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.ifdef  BUILD_ORIGINAL
        jsr set_cursor_row
.else
        sta ZP_CURSOR_ROW
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
.segment    "CODE_6A25"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set_cursor_col:                                                         ;$6A25
;===============================================================================
; set the cursor column (where text printing occurs)
;
; in:   A       column number
;-------------------------------------------------------------------------------
        sta ZP_CURSOR_COL
        rts 

set_cursor_row:                                                         ;$6A28
;===============================================================================
; set the cursor row (where text printing occurs)
;
; in:   A       row number
;-------------------------------------------------------------------------------
        sta ZP_CURSOR_ROW
        rts 

cursor_down:                                                            ;$6A2B
;===============================================================================
; move the cursor down a row (does not change column!)
;
;-------------------------------------------------------------------------------
        inc ZP_CURSOR_ROW
        rts 


_DOVDU19:                                               ; BBC: DOVDU19  ;$6A2E
;===============================================================================
; stubbed-out routine in the original code; this used to be part of
; the BBC Master code to set the multi-colour palette for the viewport:
; <https://www.bbcelite.com/master/main/subroutine/dovdu19.html>
;-------------------------------------------------------------------------------
        rts 

;///////////////////////////////////////////////////////////////////////////////
.endif