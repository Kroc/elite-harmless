; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "data_hulls.asm":
;
; this file defines the 3D vector models
; of the various ships / objects in the game
;
; this file was produced with the help of nc513 on the lemon64 forums,
; and Andy McFadden's Apple ][ Elite disassembly:
; <https://6502disassembly.com/a2-elite>


.macro  .scoop_debris   scoop, debris
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; the scoop-data in a hull definition provides which cargo type it
        ; gives when scooped, already decremented by 1 to account for the
        ; non-zero check used when scooping. a side-effect of this is that
        ; it's not possible for a hull definition to drop food or textiles(?)
.if     (scoop = 0)
        ; when the scoop type is zero, it really means zero
        .byte   .nybl( $0, debris )
.else
        ; anything else is a type of cargo
        .byte   .nybl( scoop-1, debris )
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro


.segment        "HULL_TABLE"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; we will enumerate hulls as we define them; each needs an index number that
; will be used in the code to refer to them, in the order they are added to
; this table
;
; NOTE: the order of the indices here does not have to
;       match the order of the actual data that follows
;
hull_index      .set    0

hull_pointers:                                                          ;$D000
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

.segment        "HULL_TYPE"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hull_type:                                                              ;$D042
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

.segment        "HULL_KILL_LO"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hull_kill_lo:                                                           ;$D063
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

.segment        "HULL_KILL_HI"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hull_kill_hi:                                                           ;$D084
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

;===============================================================================
; NOTE: THE ORDER OF THESE INCLUDES DETERMINES THEIR INDICES,
;       AND THE ORDER OF THE DATA IN THE TABLES!
;
.include "hulls/hull_missile.asm"               ; $01: missile
.include "hulls/hull_coreolis.asm"              ; $02: station (coreolis)
.include "hulls/hull_escape.asm"                ; $03: escape pod
.include "hulls/hull_plate.asm"                 ; $04: plate / alloy
.include "hulls/hull_cannister.asm"             ; $05: cargo cannister
.include "hulls/hull_boulder.asm"               ; $06: boulder
.include "hulls/hull_asteroid.asm"              ; $07: asteroid
.include "hulls/hull_splinter.asm"              ; $08: splinter
.include "hulls/hull_shuttle.asm"               ; $09: shuttle
.include "hulls/hull_transporter.asm"           ; $0A: transporter
.include "hulls/hull_cobra-mkiii.asm"           ; $0B: cobra mk.III, trader
.include "hulls/hull_python_trader.asm"         ; $0C: python, trader
.include "hulls/hull_boa.asm"                   ; $0D: boa
.include "hulls/hull_anaconda.asm"              ; $0E: anaconda
.include "hulls/hull_hermit.asm"                ; $0F: asteroid, hermit
.include "hulls/hull_viper.asm"                 ; $10: viper
.include "hulls/hull_sidewinder.asm"            ; $11: sidewinder
.include "hulls/hull_mamba.asm"                 ; $12: mamba
.include "hulls/hull_krait.asm"                 ; $13: krait
.include "hulls/hull_adder.asm"                 ; $14: adder
.include "hulls/hull_gecko.asm"                 ; $15: gecko
.include "hulls/hull_cobra-mki.asm"             ; $16: cobra mk.I
.include "hulls/hull_worm.asm"                  ; $17: worm
.include "hulls/hull_cobra-mkiii_pirate.asm"    ; $18: cobra mk.III, pirate
.include "hulls/hull_asp-mkii.asm"              ; $19: asp mk.II
.include "hulls/hull_python_pirate.asm"         ; $1A: python, pirate
.include "hulls/hull_fer-de-lance.asm"          ; $1B: fer-de-lance
.include "hulls/hull_moray.asm"                 ; $1C: moray
.include "hulls/hull_thargoid.asm"              ; $1D: thargoid
.include "hulls/hull_thargon.asm"               ; $1E: thargon
.include "hulls/hull_constrictor.asm"           ; $1F: constrictor
.include "hulls/hull_cougar.asm"                ; $20: cougar (stealth ship)
.include "hulls/hull_dodo.asm"                  ; $21: station (dodo)

                                                                        ;$EF90