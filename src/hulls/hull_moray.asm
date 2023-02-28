; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; moray
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MORAY              = hull_index                                    ;=$1C

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MORAY_KILL         = 192   ;= 0.75

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_moray                                              ;$D036/7

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D05D

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MORAY_KILL                                       ;$D07E

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MORAY_KILL                                       ;$D09F

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2699

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_moray                                                      ;$E9C9
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 1
        target_area     = 30
        max_edges       = 18
        laser_vertex    = 0
        explosion_count = 5
        bounty          = 50
        lod_distance    = 40
        max_energy      = 100
        max_speed       = 25
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   15,    0,   65,       2,  0,  8,  7,          31      ; #0
        .vertex  -15,    0,   65,       1,  0,  7,  6,          31      ; #1
        .vertex    0,   18,  -40,      15, 15, 15, 15,          17      ; #2
        .vertex  -60,    0,    0,       3,  1,  6,  6,          31      ; #3
        .vertex   60,    0,    0,       5,  2,  8,  8,          31      ; #4
        .vertex   30,  -27,  -10,       5,  4,  8,  7,          24      ; #5
        .vertex  -30,  -27,  -10,       4,  3,  7,  6,          24      ; #6
        .vertex   -9,   -4,  -25,       4,  4,  4,  4,           7      ; #7
        .vertex    9,   -4,  -25,       4,  4,  4,  4,           7      ; #8
        .vertex    0,  -18,  -16,       4,  4,  4,  4,           7      ; #9
        .vertex   13,    3,   49,       0,  0,  0,  0,           5      ; #10
        .vertex    6,    0,   65,       0,  0,  0,  0,           5      ; #11
        .vertex  -13,    3,   49,       0,  0,  0,  0,           5      ; #12
        .vertex   -6,    0,   65,       0,  0,  0,  0,           5      ; #13

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        7,  0,           31                      ; #0
        .edge    1,  3,        6,  1,           31                      ; #1
        .edge    3,  6,        6,  3,           24                      ; #2
        .edge    5,  6,        7,  4,           24                      ; #3
        .edge    4,  5,        8,  5,           24                      ; #4
        .edge    0,  4,        8,  2,           31                      ; #5
        .edge    1,  6,        7,  6,           15                      ; #6
        .edge    0,  5,        8,  7,           15                      ; #7
        .edge    0,  2,        2,  0,           15                      ; #8
        .edge    1,  2,        1,  0,           15                      ; #9
        .edge    2,  3,        3,  1,           17                      ; #10
        .edge    2,  4,        5,  2,           17                      ; #11
        .edge    2,  5,        5,  4,           13                      ; #12
        .edge    2,  6,        4,  3,           13                      ; #13
        .edge    7,  8,        4,  4,            5                      ; #14
        .edge    7,  9,        4,  4,            7                      ; #15
        .edge    8,  9,        4,  4,            7                      ; #16
        .edge   10, 11,        0,  0,            5                      ; #17
        .edge   12, 13,        0,  0,            5                      ; #18

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     43,      7,           31                      ; #0
        .face    -10,     49,      7,           31                      ; #1
        .face     10,     49,      7,           31                      ; #2
        .face    -59,    -28,   -101,           24                      ; #3
        .face      0,    -52,    -78,           24                      ; #4
        .face     59,    -28,   -101,           24                      ; #5
        .face    -72,    -99,     50,           31                      ; #6
        .face      0,    -83,     30,           31                      ; #7
        .face     72,    -99,     50,           31                      ; #8

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc