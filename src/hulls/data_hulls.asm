; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; this file defines the 3D vector models
; of the various ships / objects in the game
;
; this file was produced with the help of nc513 on the lemon64 forums,
; and Andy McFadden's Apple ][ Elite disassembly:
; <https://6502disassembly.com/a2-elite>
;
.linecont+

.struct HullVertex
        vx              .byte
        vy              .byte
        vz              .byte
        signs_vis       .byte
        faces1and2      .byte
        faces3and4      .byte
.endstruct

.macro  .vertex         vx, vy, vz, face1, face2, face3, face4, vis_dist
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        .local  sx, sy, sz
        .local  ax, ay, az
        .if (vx < 0)
                sx .set 1
                ax .set -vx
        .else
                sx .set 0
                ax .set vx
        .endif
        .if (vy < 0)
                sy .set 1
                ay .set -vy
        .else
                sy .set 0
                ay .set vy
        .endif
        .if (vz < 0)
                sz .set 1
                az .set -vz
        .else
                sz .set 0
                az .set vz
        .endif

        ; first three bytes of the vertex
        ; are the X, Y & Z magnitudes
        ;
        .byte   ax              ; X-position, without sign
        .byte   ay              ; Y-position, without sign
        .byte   az              ; Z-position, without sign

        ; bits 0-4: distance 0-31 before this vertex becomes invsible
        ; bits 5-7: X, Y & Z sign-bits
        .byte   vis_dist | sx << 7 | sy << 6 | sz << 5

        .byte   .nybl( face1, face2 )
        .byte   .nybl( face3, face4 )
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.struct HullEdge
        vis_dist        .byte
        face1and2       .byte
        vertex1         .byte
        vertex2         .byte
.endstruct

.macro  .edge           vertex1, vertex2, face1, face2, vis_dist
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        .byte   vis_dist
        .byte   .nybl( face1, face2 )
        .byte   vertex1 << 2, vertex2 << 2
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.struct HullFace
        signs_vis       .byte
        normalx         .byte
        normaly         .byte
        normalz         .byte
.endstruct

.macro  .face           normx, normy, normz, vis_dist
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        .local  sx, sy, sz
        .local  ax, ay, az
        .if (normx < 0)
                sx .set 1
                ax .set -normx
        .else
                sx .set 0
                ax .set normx
        .endif
        .if (normy < 0)
                sy .set 1
                ay .set -normy
        .else
                sy .set 0
                ay .set normy
        .endif
        .if (normz < 0)
                sz .set 1
                az .set -normz
        .else
                sz .set 0
                az .set normz
        .endif

        ; bits 0-4: distance 0-31 before this face becomes invsible
        ; bits 5-7: X, Y & Z sign-bits 
        .byte   vis_dist | sx <<7 | sy <<6 | sz <<5

        .byte   ax, ay, az
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

hull_pointers:                                          ; BBC: XX21     ;$D000
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

.segment        "CODE_276E"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; colour of ships on scanner?
; bitmask for multi-colour pixels?
;
_267e:                                                                  ;$267E
        ;-----------------------------------------------------------------------
        .byte   $00             ; index 0 is unused (no ship)           ;$267E

        ; see includes below
        ; ...


;===============================================================================
; NOTE: THE ORDER OF THESE INCLUDES DETERMINES THEIR INDICES,           ;$D0A5
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

.segment        "CODE_276E"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.ifdef  BUILD_ORIGINAL
;///////////////////////////////////////////////////////////////////////////////
; trailing junk bytes in this segment
;
.byte   $00, $00, $00, $00

;///////////////////////////////////////////////////////////////////////////////
.endif