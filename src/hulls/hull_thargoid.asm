; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; thargoid
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_THARGOID           = hull_index                                    ;=$1D

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_THARGOID_KILL      = 682   ;= 2.66

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_thargoid                                           ;$D038/9

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D05E

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_THARGOID_KILL                                    ;$D07F

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_THARGOID_KILL                                    ;$D0A0

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %01011010                                               ;$278A

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_thargoid                                                   ;$EAA1
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 99
        max_edges       = 26
        laser_vertex    = 15
        explosion_count = 8
        bounty          = 500
        lod_distance    = 55
        max_energy      = 240
        max_speed       = 39
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 6
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   32,  -48,   48,       0,  4,  8,  8,          31      ; #0
        .vertex   32,  -68,    0,       0,  1,  4,  4,          31      ; #1
        .vertex   32,  -48,  -48,       1,  2,  4,  4,          31      ; #2
        .vertex   32,    0,  -68,       2,  3,  4,  4,          31      ; #3
        .vertex   32,   48,  -48,       3,  4,  5,  5,          31      ; #4
        .vertex   32,   68,    0,       4,  5,  6,  6,          31      ; #5
        .vertex   32,   48,   48,       4,  6,  7,  7,          31      ; #6
        .vertex   32,    0,   68,       4,  7,  8,  8,          31      ; #7
        .vertex  -24, -116,  116,       0,  8,  9,  9,          31      ; #8
        .vertex  -24, -164,    0,       0,  1,  9,  9,          31      ; #9
        .vertex  -24, -116, -116,       1,  2,  9,  9,          31      ; #10
        .vertex  -24,    0, -164,       2,  3,  9,  9,          31      ; #11
        .vertex  -24,  116, -116,       3,  5,  9,  9,          31      ; #12
        .vertex  -24,  164,    0,       5,  6,  9,  9,          31      ; #13
        .vertex  -24,  116,  116,       6,  7,  9,  9,          31      ; #14
        .vertex  -24,    0,  164,       7,  8,  9,  9,          31      ; #15
        .vertex  -24,   64,   80,       9,  9,  9,  9,          30      ; #16
        .vertex  -24,   64,  -80,       9,  9,  9,  9,          30      ; #17
        .vertex  -24,  -64,  -80,       9,  9,  9,  9,          30      ; #18
        .vertex  -24,  -64,   80,       9,  9,  9,  9,          30      ; #19

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  7,        4,  8,           31                      ; #0
        .edge    0,  1,        0,  4,           31                      ; #1
        .edge    1,  2,        1,  4,           31                      ; #2
        .edge    2,  3,        2,  4,           31                      ; #3
        .edge    3,  4,        3,  4,           31                      ; #4
        .edge    4,  5,        4,  5,           31                      ; #5
        .edge    5,  6,        4,  6,           31                      ; #6
        .edge    6,  7,        4,  7,           31                      ; #7
        .edge    0,  8,        0,  8,           31                      ; #8
        .edge    1,  9,        0,  1,           31                      ; #9
        .edge    2, 10,        1,  2,           31                      ; #10
        .edge    3, 11,        2,  3,           31                      ; #11
        .edge    4, 12,        3,  5,           31                      ; #12
        .edge    5, 13,        5,  6,           31                      ; #13
        .edge    6, 14,        6,  7,           31                      ; #14
        .edge    7, 15,        7,  8,           31                      ; #15
        .edge    8, 15,        8,  9,           31                      ; #16
        .edge    8,  9,        0,  9,           31                      ; #17
        .edge    9, 10,        1,  9,           31                      ; #18
        .edge   10, 11,        2,  9,           31                      ; #19
        .edge   11, 12,        3,  9,           31                      ; #20
        .edge   12, 13,        5,  9,           31                      ; #21
        .edge   13, 14,        6,  9,           31                      ; #22
        .edge   14, 15,        7,  9,           31                      ; #23
        .edge   16, 17,        9,  9,           30                      ; #24
        .edge   18, 19,        9,  9,           30                      ; #25

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    103,    -60,     25,           31                      ; #0
        .face    103,    -60,    -25,           31                      ; #1
        .face    103,    -25,    -60,           31                      ; #2
        .face    103,     25,    -60,           31                      ; #3
        .face     64,      0,      0,           31                      ; #4
        .face    103,     60,    -25,           31                      ; #5
        .face    103,     60,     25,           31                      ; #6
        .face    103,     25,     60,           31                      ; #7
        .face    103,    -25,     60,           31                      ; #8
        .face    -48,      0,      0,           31                      ; #9

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc