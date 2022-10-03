; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; mamba
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MAMBA              = hull_index                                    ;=$12

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MAMBA_KILL         = 128   ;= 0.50

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_mamba                                              ;$D022/3

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D053

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MAMBA_KILL                                       ;$D074

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MAMBA_KILL                                       ;$D095

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$277F

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_mamba                                                      ;$DF8D
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 1
        target_area     = 70
        max_edges       = 24
        laser_vertex    = 0
        explosion_count = 7
        bounty          = 150
        lod_distance    = 25
        max_energy      = 90
        max_speed       = 30
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 2
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,   64,       0,  1,  2,  3,          31      ; #0
        .vertex  -64,   -8,  -32,       0,  2,  4,  4,          31      ; #1
        .vertex  -32,    8,  -32,       1,  2,  4,  4,          30      ; #2
        .vertex   32,    8,  -32,       1,  3,  4,  4,          30      ; #3
        .vertex   64,   -8,  -32,       0,  3,  4,  4,          31      ; #4
        .vertex   -4,    4,   16,       1,  1,  1,  1,          14      ; #5
        .vertex    4,    4,   16,       1,  1,  1,  1,          14      ; #6
        .vertex    8,    3,   28,       1,  1,  1,  1,          13      ; #7
        .vertex   -8,    3,   28,       1,  1,  1,  1,          13      ; #8
        .vertex  -20,   -4,   16,       0,  0,  0,  0,          20      ; #9
        .vertex   20,   -4,   16,       0,  0,  0,  0,          20      ; #10
        .vertex  -24,   -7,  -20,       0,  0,  0,  0,          20      ; #11
        .vertex  -16,   -7,  -20,       0,  0,  0,  0,          16      ; #12
        .vertex   16,   -7,  -20,       0,  0,  0,  0,          16      ; #13
        .vertex   24,   -7,  -20,       0,  0,  0,  0,          20      ; #14
        .vertex   -8,    4,  -32,       4,  4,  4,  4,          13      ; #15
        .vertex    8,    4,  -32,       4,  4,  4,  4,          13      ; #16
        .vertex    8,   -4,  -32,       4,  4,  4,  4,          14      ; #17
        .vertex   -8,   -4,  -32,       4,  4,  4,  4,          14      ; #18
        .vertex  -32,    4,  -32,       4,  4,  4,  4,           7      ; #19
        .vertex   32,    4,  -32,       4,  4,  4,  4,           7      ; #20
        .vertex   36,   -4,  -32,       4,  4,  4,  4,           7      ; #21
        .vertex  -36,   -4,  -32,       4,  4,  4,  4,           7      ; #22
        .vertex  -38,    0,  -32,       4,  4,  4,  4,           5      ; #23
        .vertex   38,    0,  -32,       4,  4,  4,  4,           5      ; #24

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        0,  2,           31                      ; #0
        .edge    0,  4,        0,  3,           31                      ; #1
        .edge    1,  4,        0,  4,           31                      ; #2
        .edge    1,  2,        2,  4,           30                      ; #3
        .edge    2,  3,        1,  4,           30                      ; #4
        .edge    3,  4,        3,  4,           30                      ; #5
        .edge    5,  6,        1,  1,           14                      ; #6
        .edge    6,  7,        1,  1,           12                      ; #7
        .edge    7,  8,        1,  1,           13                      ; #8
        .edge    5,  8,        1,  1,           12                      ; #9
        .edge    9, 11,        0,  0,           20                      ; #10
        .edge    9, 12,        0,  0,           16                      ; #11
        .edge   10, 13,        0,  0,           16                      ; #12
        .edge   10, 14,        0,  0,           20                      ; #13
        .edge   13, 14,        0,  0,           14                      ; #14
        .edge   11, 12,        0,  0,           14                      ; #15
        .edge   15, 16,        4,  4,           13                      ; #16
        .edge   17, 18,        4,  4,           14                      ; #17
        .edge   15, 18,        4,  4,           12                      ; #18
        .edge   16, 17,        4,  4,           12                      ; #19
        .edge   20, 21,        4,  4,            7                      ; #20
        .edge   20, 24,        4,  4,            5                      ; #21
        .edge   21, 24,        4,  4,            5                      ; #22
        .edge   19, 22,        4,  4,            7                      ; #23
        .edge   19, 23,        4,  4,            5                      ; #24
        .edge   22, 23,        4,  4,            5                      ; #25
        .edge    0,  2,        1,  2,           30                      ; #26
        .edge    0,  3,        1,  3,           30                      ; #27

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,    -24,      2,           30                      ; #0
        .face      0,     24,      2,           30                      ; #1
        .face    -32,     64,     16,           30                      ; #2
        .face     32,     64,     16,           30                      ; #3
        .face      0,      0,   -127,           30                      ; #4

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc