; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "vars_polyobj.asm":
;
; Elite has a number of 'slots' for 3D-objects currently in play;
; e.g. ships, asteroids, space stations and other such polygon-objects.
; this file defines the runtime structure for a poly-object and reserves
; the space in RAM
;
; huge thanks to "DrBeeb" for documenting the data structure on the Elite Wiki
; http://wiki.alioth.net/index.php/Classic_Elite_entity_states
;
.struct PolyObject                                                      ;offset
        ;=======================================================================
        ; NOTE: these are not addresses, but they are 24-bit
        xpos            .faraddr                                        ;+$00
        ypos            .faraddr                                        ;+$03
        zpos            .faraddr                                        ;+$06

        ; a 3x3 rotation matrix?
        ; TODO: I don't know how best to name these yet
        ; 
        ; [ X ]    [ X, Y, Z ] ?
        ; [ Y ] -> [ X, Y, Z ]
        ; [ Z ]    [ X, Y, Z ]
        ;
        m0x0            .word                                           ;+$09
        m0x1            .word                                           ;+$0B
        m0x2            .word                                           ;+$0D
        m1x0            .word                                           ;+$0F
        m1x1            .word                                           ;+$11
        m1x2            .word                                           ;+$13
        m2x0            .word                                           ;+$15
        m2x1            .word                                           ;+$17
        m2x2            .word                                           ;+$19

        speed           .byte                                           ;+$1B
        acceleration    .byte                                           ;+$1C

        roll            .byte                                           ;+$1D
        pitch           .byte                                           ;+$1E
        
        ; misc. state & missile count, see enum below
        state           .byte                                           ;+$1F
        ; attack state, see enum below
        attack          .byte                                           ;+$20

        ; a pointer to already processed vertex data
        vertexData      .addr                                           ;+$21
        
        energy          .byte                                           ;+$23

        ; behaviour state, see enum below
        behaviour       .byte                                           ;+$24
.endstruct

; ship state and missile count
;-------------------------------------------------------------------------------
.enum   state
        exploding       = %10000000     ; is exploding!
        firing          = %01000000     ; is firing at player!
        debris          = %00100000     ; display debris(?)
        scanner         = %00010000     ; visible on scanner
        redraw          = %00001000     ; needs a redraw
        missiles        = %00000111     ; no. of missiles (or thargons)
.endenum

; A.I. attack state
;-------------------------------------------------------------------------------
.enum   attack
        active          = %10000000     ; use tactics; missiles updated often
        target          = %01000000     ; is targeting player
        aggression      = %00111110     ; aggression level / missile target ID
        aggr1           = %00000010     ; - aggression lvl.1
        aggr2           = %00000100     ; - aggression lvl.2
        aggr3           = %00001000     ; - aggression lvl.3
        aggr4           = %00010000     ; - aggression lvl.4
        aggr5           = %00100000     ; - agrression lvl.5
        ecm             = %00000001     ; has E.C.M.
.endenum

; A.I. behaviour state
;-------------------------------------------------------------------------------
.enum   behaviour
        remove          = %10000000     ; remove -- too far away
        police          = %01000000     ; is police vessel
        protected       = %00100000     ; protected by space-station
        docking         = %00010000     ; is docking
        pirate          = %00001000     ; is pirate
        angry           = %00000100     ; is angry with the player
        hunter          = %00000010     ; is a bounty-hunter
        trader          = %00000001     ; is a peaceful trader
.endenum

; this is a segment as we need to assign a place in RAM for it
; (based on everything else in RAM), but it's not written to disk;
; this variable space is only used at run-time
;
; see the linker configs ("link/elite-*.cfg") for memory assignment.
; in the original game, this is $F900
;
.segment        "POLYOBJS"

polyobjects:                                                            ;$F900
;===============================================================================
polyobj_00:      .tag    PolyObject                                     ;$F900
polyobj_01:      .tag    PolyObject                                     ;$F925
polyobj_02:      .tag    PolyObject                                     ;$F94A
polyobj_03:      .tag    PolyObject                                     ;$F96F
polyobj_04:      .tag    PolyObject                                     ;$F994
polyobj_05:      .tag    PolyObject                                     ;$F9B9
polyobj_06:      .tag    PolyObject                                     ;$F9DE
polyobj_07:      .tag    PolyObject                                     ;$FA03
polyobj_08:      .tag    PolyObject                                     ;$FA28
polyobj_09:      .tag    PolyObject                                     ;$FA4D
polyobj_10:      .tag    PolyObject                                     ;$FA72

POLYOBJ_COUNT   = 11


.macro  .polybj_to_zp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; copy the given PolyObject to
        ; the working space in zero page
        ;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is the original copy routine
        ;                                       ; bytes/tally   cycles/tally
        ;---------------------------------------;-------------------------------
        ldy # .sizeof( PolyObject )-1           ; +2    2       +2      2
:       lda [ZP_POLYOBJ_ADDR], y                ; +2    .       +5      .      
        sta ZP_POLYOBJ, y                       ; +2    .       +5      .      
        dey                                     ; +1    .       +2      .      
        bpl :-                                  ; +2    7       +3     (15)
        ;                                 loop: ;               -1  *37=555
        ;---------------------------------------;-------------------------------
        ;                                total: ;       9               556
        .exitmacro
.endif  ;///////////////////////////////////////////////////////////////////////

        ; currently, we don't have a constant (at assemble-time) to know
        ; if we're running in a high-RAM configuration as our loop-unroll
        ; here is too large for the low-RAM layout. let's assume that if
        ; the math tables are missing, we don't have room for this unroll...
        ;
.ifndef FEATURE_MATHTABLES
        ;///////////////////////////////////////////////////////////////////////
        ; a slightly optimised version that takes fewer cycles
        ;
        .local  @copy
        ;                                       ; bytes/tally   cycles/tally
        ;---------------------------------------;-------------------------------
        lda ZP_POLYOBJ_ADDR_LO                  ; +2    .       +3      .
        sta @copy+1                             ; +3    .       +4      .
        lda ZP_POLYOBJ_ADDR_HI                  ; +2    .       +3      .
        sta @copy+2                             ; +3    .       +4      .
        ldx # .sizeof( PolyObject )-1           ; +2    12      +2      16
        ;---------------------------------------;-------------------------------
@copy:  lda $8888, x                            ; +3    .       +4      .
        sta ZP_POLYOBJ, x                       ; +2    .       +4      .
        dex                                     ; +1    .       +2      .
        bpl @copy                               ; +2    8       +3     (13)
        ;                                 loop: ;               -1  *37=481
        ;---------------------------------------;-------------------------------
        ;                                total: ;       20              496
.else   ;///////////////////////////////////////////////////////////////////////
        ; the amount of time spent copying the ship instances back and forth
        ; between zero-page is quite significant. we can unroll the copy loop
        ; to speed it up drastically, but it will take up a lot more RAM!
        ;
        ;                                       ; bytes/tally   cycles/tally
        ;-----------------------------------------------------------------------
        ldy # 0                                 ; +2    2       +2      2
        .repeat .sizeof( PolyObject )-2, I
                lda [ZP_POLYOBJ_ADDR], y        ; +2    .       +5      .
                sta ZP_POLYOBJ + I              ; +2    .       +3      .
                iny                             ; +1   (5)      +2     (10)
        .endrep                         ; loop: ;   *36=180         *36=360
        ;
        ; the last iteration does not need to
        ; include the INY so is split out here
        lda [ZP_POLYOBJ_ADDR], y                ; +2    .       +5      .
        sta ZP_POLYOBJ+.sizeof( PolyObject )-1  ; +2    4       +3      8
        ;---------------------------------------;-------------------------------
        ;                                total: ;       186             370
.endif  ;///////////////////////////////////////////////////////////////////////
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


.macro  .zp_to_polyobj
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; copy the working poly-object in zero-page
        ; back to its storage space
        ;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is the original copy routine
        ;                                       ; bytes/tally   cycles/tally
        ;---------------------------------------;-------------------------------
        ldy # .sizeof( PolyObject )-1           ; +2    2       +2      2
:       lda ZP_POLYOBJ, y                       ; +3    .       +4      .
        sta [ZP_POLYOBJ_ADDR], y                ; +2    .       +6      .
        dey                                     ; +1    .       +2      .      
        bpl :-                                  ; +2    7       +3     (15)
        ;                                 loop: ;               -1  *37=555
        ;---------------------------------------;-------------------------------
        ;                                total: ;       9               556
        .exitmacro
.endif  ;///////////////////////////////////////////////////////////////////////

        ; currently, we don't have a constant (at assemble-time) to know
        ; if we're running in a high-RAM configuration as our loop-unroll
        ; here is too large for the low-RAM layout. let's assume that if
        ; the math tables are missing, we don't have room for this unroll...
        ;
.ifndef FEATURE_MATHTABLES
        ;///////////////////////////////////////////////////////////////////////
        ; a slightly optimised version that takes fewer cycles
        ;
        .local  @copy
        .local  @addr
        ;                                       ; bytes/tally   cycles/tally
        ;---------------------------------------;-------------------------------
        lda ZP_POLYOBJ_ADDR_LO                  ; +2    .       +3      .
        sta @addr+1                             ; +3    .       +4      .
        lda ZP_POLYOBJ_ADDR_HI                  ; +2    .       +3      .
        sta @addr+2                             ; +3    .       +4      .
        ldx # .sizeof( PolyObject )-1           ; +2    12      +2      16
        ;---------------------------------------;-------------------------------
@copy:  lda ZP_POLYOBJ, x                       ; +2    .       +4      .
@addr:  sta $8888, x                            ; +3    .       +5      .
        dex                                     ; +1    .       +2      .
        bpl @copy                               ; +2    8       +3     (14)
        ;                                 loop: ;               -1  *37=518
        ;---------------------------------------;-------------------------------
        ;                                total: ;       20              534
.else   ;///////////////////////////////////////////////////////////////////////
        ; the amount of time spent copying the ship instances back and forth
        ; between zero-page is quite significant. we can unroll the copy loop
        ; to speed it up drastically, but it will take up a lot more RAM!
        ;
        ;                                       ; bytes/tally   cycles/tally
        ;-----------------------------------------------------------------------
        ldy # 0                                 ; +2    2       +2      2
        .repeat .sizeof( PolyObject )-2, I
                lda ZP_POLYOBJ + I              ; +2    .       +3      .
                sta [ZP_POLYOBJ_ADDR], y        ; +2    .       +6      .
                iny                             ; +1   (5)      +2     (11)
        .endrep                         ; loop: ;   *36=180         *36=396
        ;
        ; the last iteration does not need to
        ; include the INY so is split out here
        lda ZP_POLYOBJ+.sizeof( PolyObject )-1  ; +2    .       +3      .
        sta [ZP_POLYOBJ_ADDR], y                ; +2    4       +6      9
        ;---------------------------------------;-------------------------------
        ;                                total: ;       186             407
.endif  ;///////////////////////////////////////////////////////////////////////
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro