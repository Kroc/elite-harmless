; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; Elite has a number of 'slots' for 3D-objects currently in play;
; e.g. ships, asteroids, space stations and other such polygon-objects.
; this file defines the runtime structure for a poly-object and reserves
; the space in RAM
;
; huge thanks to "DrBeeb" for documenting the data structure on the Elite Wiki
; http://wiki.alioth.net/index.php/Classic_Elite_entity_states
;
.struct PolyObject                                                      ;offset
        
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

        ; a pointer to already processed vertex data
        vertexData      .addr                                           ;+$1B

        roll            .byte                                           ;+$1D
        pitch           .byte                                           ;+$1E
        
        ; visibility state, see enum below
        visibility      .byte                                           ;+$1F
        ; attack state, see enum below
        attack          .byte                                           ;+$20

        speed           .byte                                           ;+$21
        acceleration    .byte                                           ;+$22
        energy          .byte                                           ;+$23

        ; behaviour state, see enum below
        behaviour       .byte                                           ;+$24
.endstruct

; visibilty state and missile count
;-------------------------------------------------------------------------------
.enum   visibility
        exploding       = %10000000     ; is exploding!
        firing          = %01000000     ; is firing at player!
        display         = %00100000     ; display nodes (not distant dot)
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

; this is a segement as we need to assign a place in RAM for it
; (based on everything else in RAM), but it's not written to disk;
; this variable space is only used at run-time
;
; see the linker configs ("link/elite-*.cfg") for memory assignment.
; in the original game, this is $F900
;
.segment        "POLYOBJS"

POLYOBJECTS:                                                            ;$F900

; there is a limit of 11 objects at the same time in the game.
; with 11 objects this occupies 407 bytes. this could be expanded
; to 13 objects (for 481 bytes of 37 bytes each) and remain page-aligned

POLYOBJ_00:      .tag    PolyObject                                     ;$F900
POLYOBJ_01:      .tag    PolyObject                                     ;$F925
POLYOBJ_02:      .tag    PolyObject                                     ;$F94A
POLYOBJ_03:      .tag    PolyObject                                     ;$F96F
POLYOBJ_04:      .tag    PolyObject                                     ;$F994
POLYOBJ_05:      .tag    PolyObject                                     ;$F9B9
POLYOBJ_06:      .tag    PolyObject                                     ;$F9DE
POLYOBJ_07:      .tag    PolyObject                                     ;$FA03
POLYOBJ_08:      .tag    PolyObject                                     ;$FA28
POLYOBJ_09:      .tag    PolyObject                                     ;$FA4D
POLYOBJ_10:      .tag    PolyObject                                     ;$FA72
