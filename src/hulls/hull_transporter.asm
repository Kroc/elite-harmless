; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; transporter
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_TRANSPORTER        = hull_index                                    ;=$0A

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_TRANSPORTER_KILL   = 17    ;= 0.066

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_transporter                                        ;$D012/3

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $61                                                     ;$D04B

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_TRANSPORTER_KILL                                 ;$D06C

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_TRANSPORTER_KILL                                 ;$D08D

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2687

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_transporter                                                ;$D6E1
        ;-----------------------------------------------------------------------
        .proc   header
 
        scoop           = 0
        debris          = 0
        target_area     = 50
        max_edges       = 37
        laser_vertex    = 12
        explosion_count = 5
        bounty          = 0
        lod_distance    = 16
        max_energy      = 32
        max_speed       = 10
        normal_scaling  = 2
        laser_power     = 0
        missile_count   = 0
 
        .hull
 
        .endproc
 
        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,   10,  -26,       6,  0,  7,  7,          31      ; #0
        .vertex  -25,    4,  -26,       1,  0,  7,  7,          31      ; #1
        .vertex  -28,   -3,  -26,       1,  0,  2,  2,          31      ; #2
        .vertex  -25,   -8,  -26,       2,  0,  3,  3,          31      ; #3
        .vertex   26,   -8,  -26,       3,  0,  4,  4,          31      ; #4
        .vertex   29,   -3,  -26,       4,  0,  5,  5,          31      ; #5
        .vertex   26,    4,  -26,       5,  0,  6,  6,          31      ; #6
        .vertex    0,    6,   12,      15, 15, 15, 15,          19      ; #7
        .vertex  -30,   -1,   12,       7,  1,  9,  8,          31      ; #8
        .vertex  -33,   -8,   12,       2,  1,  9,  3,          31      ; #9
        .vertex   33,   -8,   12,       4,  3, 10,  5,          31      ; #10
        .vertex   30,   -1,   12,       6,  5, 11, 10,          31      ; #11
        .vertex  -11,   -2,   30,       9,  8, 13, 12,          31      ; #12
        .vertex  -13,   -8,   30,       9,  3, 13, 13,          31      ; #13
        .vertex   14,   -8,   30,      10,  3, 13, 13,          31      ; #14
        .vertex   11,   -2,   30,      11, 10, 13, 12,          31      ; #15
        .vertex   -5,    6,    2,       7,  7,  7,  7,           7      ; #16
        .vertex  -18,    3,    2,       7,  7,  7,  7,           7      ; #17
        .vertex   -5,    7,   -7,       7,  7,  7,  7,           7      ; #18
        .vertex  -18,    4,   -7,       7,  7,  7,  7,           7      ; #19
        .vertex  -11,    6,  -14,       7,  7,  7,  7,           7      ; #20
        .vertex  -11,    5,   -7,       7,  7,  7,  7,           7      ; #21
        .vertex    5,    7,  -14,       6,  6,  6,  6,           7      ; #22
        .vertex   18,    4,  -14,       6,  6,  6,  6,           7      ; #23
        .vertex   11,    5,   -7,       6,  6,  6,  6,           7      ; #24
        .vertex    5,    6,   -3,       6,  6,  6,  6,           7      ; #25
        .vertex   18,    3,   -3,       6,  6,  6,  6,           7      ; #26
        .vertex   11,    4,    8,       6,  6,  6,  6,           7      ; #27
        .vertex   11,    5,   -3,       6,  6,  6,  6,           7      ; #28
        .vertex  -16,   -8,  -13,       3,  3,  3,  3,           6      ; #29
        .vertex  -16,   -8,   16,       3,  3,  3,  3,           6      ; #30
        .vertex   17,   -8,  -13,       3,  3,  3,  3,           6      ; #31
        .vertex   17,   -8,   16,       3,  3,  3,  3,           6      ; #32
        .vertex  -13,   -3,  -26,       0,  0,  0,  0,           8      ; #33
        .vertex   13,   -3,  -26,       0,  0,  0,  0,           8      ; #34
        .vertex    9,    3,  -26,       0,  0,  0,  0,           5      ; #35
        .vertex   -8,    3,  -26,       0,  0,  0,  0,           5      ; #36
        
        .endproc
 
        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        7,  0,           31                      ; #0
        .edge    1,  2,        1,  0,           31                      ; #1
        .edge    2,  3,        2,  0,           31                      ; #2
        .edge    3,  4,        3,  0,           31                      ; #3
        .edge    4,  5,        4,  0,           31                      ; #4
        .edge    5,  6,        5,  0,           31                      ; #5
        .edge    0,  6,        6,  0,           31                      ; #6
        .edge    0,  7,        7,  6,           16                      ; #7
        .edge    1,  8,        7,  1,           31                      ; #8
        .edge    2,  9,        2,  1,           11                      ; #9
        .edge    3,  9,        3,  2,           31                      ; #10
        .edge    4, 10,        4,  3,           31                      ; #11
        .edge    5, 10,        5,  4,           11                      ; #12
        .edge    6, 11,        6,  5,           31                      ; #13
        .edge    7,  8,        8,  7,           17                      ; #14
        .edge    8,  9,        9,  1,           17                      ; #15
        .edge   10, 11,       10,  5,           17                      ; #16
        .edge    7, 11,       11,  6,           17                      ; #17
        .edge    7, 15,       12, 11,           19                      ; #18
        .edge    7, 12,       12,  8,           19                      ; #19
        .edge    8, 12,        9,  8,           16                      ; #20
        .edge    9, 13,        9,  3,           31                      ; #21
        .edge   10, 14,       10,  3,           31                      ; #22
        .edge   11, 15,       11, 10,           16                      ; #23
        .edge   12, 13,       13,  9,           31                      ; #24
        .edge   13, 14,       13,  3,           31                      ; #25
        .edge   14, 15,       13, 10,           31                      ; #26
        .edge   12, 15,       13, 12,           31                      ; #27
        .edge   16, 17,        7,  7,            7                      ; #28
        .edge   18, 19,        7,  7,            7                      ; #29
        .edge   19, 20,        7,  7,            7                      ; #30
        .edge   18, 20,        7,  7,            7                      ; #31
        .edge   20, 21,        7,  7,            7                      ; #32
        .edge   22, 23,        6,  6,            7                      ; #33
        .edge   23, 24,        6,  6,            7                      ; #34
        .edge   24, 22,        6,  6,            7                      ; #35
        .edge   25, 26,        6,  6,            7                      ; #36
        .edge   26, 27,        6,  6,            7                      ; #37
        .edge   25, 27,        6,  6,            7                      ; #38
        .edge   27, 28,        6,  6,            7                      ; #39
        .edge   29, 30,        3,  3,            6                      ; #40
        .edge   31, 32,        3,  3,            6                      ; #41
        .edge   33, 34,        0,  0,            8                      ; #42
        .edge   34, 35,        0,  0,            5                      ; #43
        .edge   35, 36,        0,  0,            5                      ; #44
        .edge   36, 33,        0,  0,            5                      ; #45
        
        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,      0,   -103,           31                      ; #0
        .face   -111,     48,     -7,           31                      ; #1
        .face   -105,    -63,    -21,           31                      ; #2
        .face      0,    -34,      0,           31                      ; #3
        .face    105,    -63,    -21,           31                      ; #4
        .face    111,     48,     -7,           31                      ; #5
        .face      8,     32,      3,           31                      ; #6
        .face     -8,     32,      3,           31                      ; #7
        .face     -8,     34,     11,           19                      ; #8
        .face    -75,     32,     79,           31                      ; #9
        .face     75,     32,     79,           31                      ; #10
        .face      8,     34,     11,           19                      ; #11
        .face      0,     38,     17,           31                      ; #12
        .face      0,      0,    121,           31                      ; #13
        
        .endproc
 
        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc