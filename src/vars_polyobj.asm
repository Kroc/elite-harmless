; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "vars_polyobj.asm" -- run-time storage of 3D polygon-objects in play

.include        "vars_zeropage.asm"

; this is a segement as we need to assign a place in RAM for it
; (based on everything else in RAM), but it's not written to disk;
; this variable space is only used at run-time
;
; see the linker configs ("link/elite-*.cfg") for memory assignment.
; in the original game, this is $F900
;
.segment        "POLYOBJS"

POLYOBJECTS:

; there is a limit of 11 objects at the same time in the game.
; please see "vars_zeropage.asm" for the PolyObject structure
; (unfortunately we can't export `.struct`s whole)
;
; with 11 objects this occupies 407 bytes; this could be expanded
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

.export POLYOBJECTS
.export POLYOBJ_00 
.export POLYOBJ_01
.export POLYOBJ_02
.export POLYOBJ_03
.export POLYOBJ_04
.export POLYOBJ_05
.export POLYOBJ_06
.export POLYOBJ_07
.export POLYOBJ_08
.export POLYOBJ_09
.export POLYOBJ_10