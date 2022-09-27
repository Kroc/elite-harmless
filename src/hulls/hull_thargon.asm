; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; thargon
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_THARGON            = hull_index                                    ;=$1E

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_THARGON_KILL       = 33    ;= 0.128

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_thargon                                            ;$D03A/B

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $04                                                     ;$D05F

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_THARGON_KILL                                     ;$D080

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_THARGON_KILL                                     ;$D0A1

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_thargon                                                    ;$EBBD
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = Cargo::aliens
        debris          = 0
        target_area     = 40
        max_edges       = 17
        laser_vertex    = 0
        explosion_count = 3
        bounty          = 50
        lod_distance    = 20
        max_energy      = 20
        max_speed       = 30
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   -9,    0,   40,       1,  0,  5,  5,          31      ; #0
        .vertex   -9,  -38,   12,       1,  0,  2,  2,          31      ; #1
        .vertex   -9,  -24,  -32,       2,  0,  3,  3,          31      ; #2
        .vertex   -9,   24,  -32,       3,  0,  4,  4,          31      ; #3
        .vertex   -9,   38,   12,       4,  0,  5,  5,          31      ; #4
        .vertex    9,    0,   -8,       5,  1,  6,  6,          31      ; #5
        .vertex    9,  -10,  -15,       2,  1,  6,  6,          31      ; #6
        .vertex    9,   -6,  -26,       3,  2,  6,  6,          31      ; #7
        .vertex    9,    6,  -26,       4,  3,  6,  6,          31      ; #8
        .vertex    9,   10,  -15,       5,  4,  6,  6,          31      ; #9

        .endproc

        vertex_bytes = .sizeof( vertices )

        ; the Thargon reuses the edges from the cannister!
        ;
        edges_offset = ::hull_cannister::edges - header
        edges_bytes  = .sizeof( ::hull_cannister::edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -36,      0,      0,           31                      ; #0
        .face     20,     -5,      7,           31                      ; #1
        .face     46,    -42,    -14,           31                      ; #2
        .face     36,      0,   -104,           31                      ; #3
        .face     46,     42,    -14,           31                      ; #4
        .face     20,      5,      7,           31                      ; #5
        .face     36,      0,      0,           31                      ; #6

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc