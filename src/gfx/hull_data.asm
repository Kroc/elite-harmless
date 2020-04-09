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
; NOTE: the order of the indicies here does not have to
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
.include        "gfx/hulls/hull_missile.asm"            ; missile
.include        "gfx/hulls/hull_coreolis.asm"           ; station (coreolis)
.include        "gfx/hulls/hull_escape.asm"             ; escape pod
.include        "gfx/hulls/hull_plate.asm"              ; plate / alloy
.include        "gfx/hulls/hull_cargo.asm"              ; cargo cannister
.include        "gfx/hulls/hull_boulder.asm"            ; boulder
.include        "gfx/hulls/hull_asteroid.asm"           ; asteroid
.include        "gfx/hulls/hull_splinter.asm"           ; splinter
.include        "gfx/hulls/hull_shuttle.asm"            ; shuttle
.include        "gfx/hulls/hull_transporter.asm"        ; transporter
.include        "gfx/hulls/hull_cobra-mkiii.asm"        ; cobra mk.III, trader
.include        "gfx/hulls/hull_python_trader.asm"      ; python, trader
.include        "gfx/hulls/hull_boa.asm"                ; boa
.include        "gfx/hulls/hull_anaconda.asm"           ; anaconda
.include        "gfx/hulls/hull_hermit.asm"             ; asteroid, hermit
.include        "gfx/hulls/hull_viper.asm"              ; viper
.include        "gfx/hulls/hull_sidewinder.asm"         ; sidewinder
.include        "gfx/hulls/hull_mamba.asm"              ; mamba
.include        "gfx/hulls/hull_krait.asm"              ; krait
.include        "gfx/hulls/hull_adder.asm"              ; adder
.include        "gfx/hulls/hull_gecko.asm"              ; gecko
.include        "gfx/hulls/hull_cobra-mki.asm"          ; cobra mk.I
.include        "gfx/hulls/hull_worm.asm"               ; worm
.include        "gfx/hulls/hull_cobra-mkiii_pirate.asm" ; cobra mk.III, pirate
.include        "gfx/hulls/hull_asp-mkii.asm"           ; asp mk.II
.include        "gfx/hulls/hull_python_pirate.asm"      ; python, pirate
.include        "gfx/hulls/hull_fer-de-lance.asm"       ; fer-de-lance
.include        "gfx/hulls/hull_moray.asm"              ; moray
.include        "gfx/hulls/hull_thargoid.asm"           ; thargoid
.include        "gfx/hulls/hull_thargon.asm"            ; thargon
.include        "gfx/hulls/hull_constrictor.asm"        ; constrictor
.include        "gfx/hulls/hull_cougar.asm"             ; cougar (stealth ship)
.include        "gfx/hulls/hull_dodo.asm"               ; station (dodo)

                                                                        ;$EF90