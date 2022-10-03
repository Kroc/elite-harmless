; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; worm
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_WORM               = hull_index                                    ;=$17

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_WORM_KILL          = 50    ;= 0.19

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_worm                                               ;$D02C/D

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $05                                                     ;$D058

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_WORM_KILL                                        ;$D079

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_WORM_KILL                                        ;$D09A

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2784

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_worm                                                       ;$E45B
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 99
        max_edges       = 19
        laser_vertex    = 0
        explosion_count = 3
        bounty          = 0
        lod_distance    = 19
        max_energy      = 30
        max_speed       = 23
        normal_scaling  = 3
        laser_power     = 1
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   10,  -10,   35,       2,  0,  7,  7,          31      ; #0
        .vertex  -10,  -10,   35,       3,  0,  7,  7,          31      ; #1
        .vertex    5,    6,   15,       1,  0,  4,  2,          31      ; #2
        .vertex   -5,    6,   15,       1,  0,  5,  3,          31      ; #3
        .vertex   15,  -10,   25,       4,  2,  7,  7,          31      ; #4
        .vertex  -15,  -10,   25,       5,  3,  7,  7,          31      ; #5
        .vertex   26,  -10,  -25,       6,  4,  7,  7,          31      ; #6
        .vertex  -26,  -10,  -25,       6,  5,  7,  7,          31      ; #7
        .vertex    8,   14,  -25,       4,  1,  6,  6,          31      ; #8
        .vertex   -8,   14,  -25,       5,  1,  6,  6,          31      ; #9

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        7,  0,           31                      ; #0
        .edge    1,  5,        7,  3,           31                      ; #1
        .edge    5,  7,        7,  5,           31                      ; #2
        .edge    7,  6,        7,  6,           31                      ; #3
        .edge    6,  4,        7,  4,           31                      ; #4
        .edge    4,  0,        7,  2,           31                      ; #5
        .edge    0,  2,        2,  0,           31                      ; #6
        .edge    1,  3,        3,  0,           31                      ; #7
        .edge    4,  2,        4,  2,           31                      ; #8
        .edge    5,  3,        5,  3,           31                      ; #9
        .edge    2,  8,        4,  1,           31                      ; #10
        .edge    8,  6,        6,  4,           31                      ; #11
        .edge    3,  9,        5,  1,           31                      ; #12
        .edge    9,  7,        6,  5,           31                      ; #13
        .edge    2,  3,        1,  0,           31                      ; #14
        .edge    8,  9,        6,  1,           31                      ; #15

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     88,     70,           31                      ; #0
        .face      0,     69,     14,           31                      ; #1
        .face     70,     66,     35,           31                      ; #2
        .face    -70,     66,     35,           31                      ; #3
        .face     64,     49,     14,           31                      ; #4
        .face    -64,     49,     14,           31                      ; #5
        .face      0,      0,   -200,           31                      ; #6
        .face      0,    -80,      0,           31                      ; #7

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc