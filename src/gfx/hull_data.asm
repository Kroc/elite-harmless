; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; this file defines the 3D vector models of the various
; ships / objects in the game
;
; this file was produced with the help of nc513 on the lemon64 forums,
; and Andy McFadden's Apple ][ Elite disassembly:
; <https://6502disassembly.com/a2-elite>


.segment        "HULL_TABLE"
;===============================================================================
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
;===============================================================================
hull_type:                                                              ;$D042
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

.segment        "HULL_KILL_LO"
;===============================================================================
hull_kill_lo:                                                           ;$D063
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

.segment        "HULL_KILL_HI"
;===============================================================================
hull_kill_hi:                                                           ;$D084
        ;-----------------------------------------------------------------------
        ; see includes below...
        ;

;===============================================================================
; NOTE: THE ORDER OF THESE INCLUDES DETERMINES THEIR INDICES,
;       AND THE ORDER OF THE DATA IN THE TABLES!
;
.include "gfx/hulls/hull_missile.asm"           ; $01: missile
.include "gfx/hulls/hull_coreolis.asm"          ; $02: station (coreolis)
.include "gfx/hulls/hull_escape.asm"            ; $03: escape pod
.include "gfx/hulls/hull_plate.asm"             ; $04: plate / alloy
.include "gfx/hulls/hull_cannister.asm"         ; $05: cargo cannister
.include "gfx/hulls/hull_boulder.asm"           ; $06: boulder
.include "gfx/hulls/hull_asteroid.asm"          ; $07: asteroid
.include "gfx/hulls/hull_splinter.asm"          ; $08: splinter
.include "gfx/hulls/hull_shuttle.asm"           ; $09: shuttle
.include "gfx/hulls/hull_transporter.asm"       ; $0A: transporter
.include "gfx/hulls/hull_cobra-mkiii.asm"       ; $0B: cobra mk.III, trader
.include "gfx/hulls/hull_python_trader.asm"     ; $0C: python, trader
.include "gfx/hulls/hull_boa.asm"               ; $0D: boa
.include "gfx/hulls/hull_anaconda.asm"          ; $0E: anaconda
.include "gfx/hulls/hull_hermit.asm"            ; $0F: asteroid, hermit
.include "gfx/hulls/hull_viper.asm"             ; $10: viper
.include "gfx/hulls/hull_sidewinder.asm"        ; $11: sidewinder
.include "gfx/hulls/hull_mamba.asm"             ; $12: mamba
.include "gfx/hulls/hull_krait.asm"             ; $13: krait
.include "gfx/hulls/hull_adder.asm"             ; $14: adder
.include "gfx/hulls/hull_gecko.asm"             ; $15: gecko
.include "gfx/hulls/hull_cobra-mki.asm"         ; $16: cobra mk.I
.include "gfx/hulls/hull_worm.asm"              ; $17: worm
.include "gfx/hulls/hull_cobra-mkiii_pirate.asm"; $18: cobra mk.III, pirate
.include "gfx/hulls/hull_asp-mkii.asm"          ; $19: asp mk.II
.include "gfx/hulls/hull_python_pirate.asm"     ; $1A: python, pirate
.include "gfx/hulls/hull_fer-de-lance.asm"      ; $1B: fer-de-lance
.include "gfx/hulls/hull_moray.asm"             ; $1C: moray
.include "gfx/hulls/hull_thargoid.asm"          ; $1D: thargoid
.include "gfx/hulls/hull_thargon.asm"           ; $1E: thargon
.include "gfx/hulls/hull_constrictor.asm"       ; $1F: constrictor
.include "gfx/hulls/hull_cougar.asm"            ; $20: cougar (stealth ship)
.include "gfx/hulls/hull_dodo.asm"              ; $21: station (dodo)

                                                                        ;$EF90