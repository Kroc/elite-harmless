; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cargo cannister
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_CANNISTER          = hull_index                    ; BBC: OIL      ;=$05

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_CANNISTER_KILL     = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_cannister                                          ;$D008/9

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D046

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_CANNISTER_KILL                                   ;$D067

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_CANNISTER_KILL                                   ;$D088

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_cannister                                                  ;$D353
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 20
        max_edges       = 13
        laser_vertex    = 0
        explosion_count = 3
        bounty          = 0
        lod_distance    = 12
        max_energy      = 17
        max_speed       = 15
        normal_scaling  = 2
        laser_power     = 0
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   24,   16,    0,       0,  1,  5,  5,          31      ; #0
        .vertex   24,    5,   15,       0,  1,  2,  2,          31      ; #1
        .vertex   24,  -13,    9,       0,  2,  3,  3,          31      ; #2
        .vertex   24,  -13,   -9,       0,  3,  4,  4,          31      ; #3
        .vertex   24,    5,  -15,       0,  4,  5,  5,          31      ; #4
        .vertex  -24,   16,    0,       1,  5,  6,  6,          31      ; #5
        .vertex  -24,    5,   15,       1,  2,  6,  6,          31      ; #6
        .vertex  -24,  -13,    9,       2,  3,  6,  6,          31      ; #7
        .vertex  -24,  -13,   -9,       3,  4,  6,  6,          31      ; #8
        .vertex  -24,    5,  -15,       4,  5,  6,  6,          31      ; #9

        .endproc
        
        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        0,  1,           31                      ; #0
        .edge    1,  2,        0,  2,           31                      ; #1
        .edge    2,  3,        0,  3,           31                      ; #2
        .edge    3,  4,        0,  4,           31                      ; #3
        .edge    0,  4,        0,  5,           31                      ; #4
        .edge    0,  5,        1,  5,           31                      ; #5
        .edge    1,  6,        1,  2,           31                      ; #6
        .edge    2,  7,        2,  3,           31                      ; #7
        .edge    3,  8,        3,  4,           31                      ; #8
        .edge    4,  9,        4,  5,           31                      ; #9
        .edge    5,  6,        1,  6,           31                      ; #10
        .edge    6,  7,        2,  6,           31                      ; #11
        .edge    7,  8,        3,  6,           31                      ; #12
        .edge    8,  9,        4,  6,           31                      ; #13
        .edge    9,  5,        5,  6,           31                      ; #14

        .endproc
        
        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face     96,      0,      0,           31                      ; #0
        .face      0,     41,     30,           31                      ; #1
        .face      0,    -18,     48,           31                      ; #2
        .face      0,    -51,      0,           31                      ; #3
        .face      0,    -18,    -48,           31                      ; #4
        .face      0,     41,    -30,           31                      ; #5
        .face    -96,      0,      0,           31                      ; #6

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc