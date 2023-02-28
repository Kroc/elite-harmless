; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; adder
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ADDER              = hull_index                                    ;=$14

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ADDER_KILL         = 90    ;= 0.35

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_adder                                              ;$D026/7

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D055

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ADDER_KILL                                       ;$D076

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ADDER_KILL                                       ;$D097

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2691

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_adder                                                      ;$E1A1
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 50
        max_edges       = 25
        laser_vertex    = 0
        explosion_count = 4
        bounty          = 40
        lod_distance    = 20    ; 23 in BBC Casette version
        max_energy      = 85
        max_speed       = 24
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -18,    0,   40,       1,  0, 12, 11,          31      ; #0
        .vertex   18,    0,   40,       1,  0,  3,  2,          31      ; #1
        .vertex   30,    0,  -24,       3,  2,  5,  4,          31      ; #2
        .vertex   30,    0,  -40,       5,  4,  6,  6,          31      ; #3
        .vertex   18,   -7,  -40,       6,  5, 14,  7,          31      ; #4
        .vertex  -18,   -7,  -40,       8,  7, 14, 10,          31      ; #5
        .vertex  -30,    0,  -40,       9,  8, 10, 10,          31      ; #6
        .vertex  -30,    0,  -24,      10,  9, 12, 11,          31      ; #7
        .vertex  -18,    7,  -40,       8,  7, 13,  9,          31      ; #8
        .vertex   18,    7,  -40,       6,  4, 13,  7,          31      ; #9
        .vertex  -18,    7,   13,       9,  0, 13, 11,          31      ; #10
        .vertex   18,    7,   13,       2,  0, 13,  4,          31      ; #11
        .vertex  -18,   -7,   13,      10,  1, 14, 12,          31      ; #12
        .vertex   18,   -7,   13,       3,  1, 14,  5,          31      ; #13
        .vertex  -11,    3,   29,       0,  0,  0,  0,           5      ; #14
        .vertex   11,    3,   29,       0,  0,  0,  0,           5      ; #15
        .vertex   11,    4,   24,       0,  0,  0,  0,           4      ; #16
        .vertex  -11,    4,   24,       0,  0,  0,  0,           4      ; #17

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        1,  0,           31                      ; #0
        .edge    1,  2,        3,  2,            7                      ; #1
        .edge    2,  3,        5,  4,           31                      ; #2
        .edge    3,  4,        6,  5,           31                      ; #3
        .edge    4,  5,       14,  7,           31                      ; #4
        .edge    5,  6,       10,  8,           31                      ; #5
        .edge    6,  7,       10,  9,           31                      ; #6
        .edge    7,  0,       12, 11,            7                      ; #7
        .edge    3,  9,        6,  4,           31                      ; #8
        .edge    9,  8,       13,  7,           31                      ; #9
        .edge    8,  6,        9,  8,           31                      ; #10
        .edge    0, 10,       11,  0,           31                      ; #11
        .edge    7, 10,       11,  9,           31                      ; #12
        .edge    1, 11,        2,  0,           31                      ; #13
        .edge    2, 11,        4,  2,           31                      ; #14
        .edge    0, 12,       12,  1,           31                      ; #15
        .edge    7, 12,       12, 10,           31                      ; #16
        .edge    1, 13,        3,  1,           31                      ; #17
        .edge    2, 13,        5,  3,           31                      ; #18
        .edge   10, 11,       13,  0,           31                      ; #19
        .edge   12, 13,       14,  1,           31                      ; #20
        .edge    8, 10,       13,  9,           31                      ; #21
        .edge    9, 11,       13,  4,           31                      ; #22
        .edge    5, 12,       14, 10,           31                      ; #23
        .edge    4, 13,       14,  5,           31                      ; #24
        .edge   14, 15,        0,  0,            5                      ; #25
        .edge   15, 16,        0,  0,            3                      ; #26
        .edge   16, 17,        0,  0,            4                      ; #27
        .edge   17, 14,        0,  0,            3                      ; #28

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     39,     10,           31                      ; #0
        .face      0,    -39,     10,           31                      ; #1
        .face     69,     50,     13,           31                      ; #2
        .face     69,    -50,     13,           31                      ; #3
        .face     30,     52,      0,           31                      ; #4
        .face     30,    -52,      0,           31                      ; #5
        .face      0,      0,   -160,           31                      ; #6
        .face      0,      0,   -160,           31                      ; #7
        .face      0,      0,   -160,           31                      ; #8
        .face    -30,     52,      0,           31                      ; #9
        .face    -30,    -52,      0,           31                      ; #10
        .face    -69,     50,     13,           31                      ; #11
        .face    -69,    -50,     13,           31                      ; #12
        .face      0,     28,      0,           31                      ; #13
        .face      0,    -28,      0,           31                      ; #14
        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc