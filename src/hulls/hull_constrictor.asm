; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; constrictor
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_CONSTRICTOR        = hull_index                                    ;=$1F

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_CONSTRICTOR_KILL   = 1365  ;= 5.33!

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_constrictor                                        ;$D03C/D

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $04                                                     ;$D060

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_CONSTRICTOR_KILL                                 ;$D081

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_CONSTRICTOR_KILL                                 ;$D0A2

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$269C

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_constrictor                                                ;$EC29
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 3
        target_area     = 65
        max_edges       = 20
        laser_vertex    = 0
        explosion_count = 10
        bounty          = 0
        lod_distance    = 45
        max_energy      = 252
        max_speed       = 36
        normal_scaling  = 2
        laser_power     = 6
        missile_count   = 4
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   20,   -7,   80,       2,  0,  9,  9,          31      ; #0
        .vertex  -20,   -7,   80,       1,  0,  9,  9,          31      ; #1
        .vertex  -54,   -7,   40,       4,  1,  9,  9,          31      ; #2
        .vertex  -54,   -7,  -40,       5,  4,  9,  8,          31      ; #3
        .vertex  -20,   13,  -40,       6,  5,  8,  8,          31      ; #4
        .vertex   20,   13,  -40,       7,  6,  8,  8,          31      ; #5
        .vertex   54,   -7,  -40,       7,  3,  9,  8,          31      ; #6
        .vertex   54,   -7,   40,       3,  2,  9,  9,          31      ; #7
        .vertex   20,   13,    5,      15, 15, 15, 15,          31      ; #8
        .vertex  -20,   13,    5,      15, 15, 15, 15,          31      ; #9
        .vertex   20,   -7,   62,       9,  9,  9,  9,          18      ; #10
        .vertex  -20,   -7,   62,       9,  9,  9,  9,          18      ; #11
        .vertex   25,   -7,  -25,       9,  9,  9,  9,          18      ; #12
        .vertex  -25,   -7,  -25,       9,  9,  9,  9,          18      ; #13
        .vertex   15,   -7,  -15,       9,  9,  9,  9,          10      ; #14
        .vertex  -15,   -7,  -15,       9,  9,  9,  9,          10      ; #15
        .vertex    0,   -7,    0,      15,  9,  1,  0,           0      ; #16

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        9,  0,           31                      ; #0
        .edge    1,  2,        9,  1,           31                      ; #1
        .edge    1,  9,        1,  0,           31                      ; #2
        .edge    0,  8,        2,  0,           31                      ; #3
        .edge    0,  7,        9,  2,           31                      ; #4
        .edge    7,  8,        3,  2,           31                      ; #5
        .edge    2,  9,        4,  1,           31                      ; #6
        .edge    2,  3,        9,  4,           31                      ; #7
        .edge    6,  7,        9,  3,           31                      ; #8
        .edge    6,  8,        7,  3,           31                      ; #9
        .edge    5,  8,        7,  6,           31                      ; #10
        .edge    4,  9,        6,  5,           31                      ; #11
        .edge    3,  9,        5,  4,           31                      ; #12
        .edge    3,  4,        8,  5,           31                      ; #13
        .edge    4,  5,        8,  6,           31                      ; #14
        .edge    5,  6,        8,  7,           31                      ; #15
        .edge    3,  6,        9,  8,           31                      ; #16
        .edge    8,  9,        6,  0,           31                      ; #17
        .edge   10, 12,        9,  9,           18                      ; #18
        .edge   12, 14,        9,  9,            5                      ; #19
        .edge   14, 10,        9,  9,           10                      ; #20
        .edge   11, 15,        9,  9,           10                      ; #21
        .edge   13, 15,        9,  9,            5                      ; #22
        .edge   11, 13,        9,  9,           18                      ; #23

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     55,     15,           31                      ; #0
        .face    -24,     75,     20,           31                      ; #1
        .face     24,     75,     20,           31                      ; #2
        .face     44,     75,      0,           31                      ; #3
        .face    -44,     75,      0,           31                      ; #4
        .face    -44,     75,      0,           31                      ; #5
        .face      0,     53,      0,           31                      ; #6
        .face     44,     75,      0,           31                      ; #7
        .face      0,      0,   -160,           31                      ; #8
        .face      0,    -27,      0,           31                      ; #9

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc