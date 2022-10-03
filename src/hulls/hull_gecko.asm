; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; gecko
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_GECKO              = hull_index                                    ;=$15

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_GECKO_KILL         = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_gecko                                              ;$D028/9

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D056

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_GECKO_KILL                                       ;$D077

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_GECKO_KILL                                       ;$D098

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2782

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_gecko                                                      ;$E2D1
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 99
        max_edges       = 17
        laser_vertex    = 0
        explosion_count = 5
        bounty          = 55
        lod_distance    = 18
        max_energy      = 70
        max_speed       = 30
        normal_scaling  = 3
        laser_power     = 2
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -10,   -4,   47,       3,  0,  5,  4,          31      ; #0
        .vertex   10,   -4,   47,       1,  0,  3,  2,          31      ; #1
        .vertex  -16,    8,  -23,       5,  0,  7,  6,          31      ; #2
        .vertex   16,    8,  -23,       1,  0,  8,  7,          31      ; #3
        .vertex  -66,    0,   -3,       5,  4,  6,  6,          31      ; #4
        .vertex   66,    0,   -3,       2,  1,  8,  8,          31      ; #5
        .vertex  -20,  -14,  -23,       4,  3,  7,  6,          31      ; #6
        .vertex   20,  -14,  -23,       3,  2,  8,  7,          31      ; #7
        .vertex   -8,   -6,   33,       3,  3,  3,  3,          16      ; #8
        .vertex    8,   -6,   33,       3,  3,  3,  3,          17      ; #9
        .vertex   -8,  -13,  -16,       3,  3,  3,  3,          16      ; #10
        .vertex    8,  -13,  -16,       3,  3,  3,  3,          17      ; #11

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        3,  0,           31                      ; #0
        .edge    1,  5,        2,  1,           31                      ; #1
        .edge    5,  3,        8,  1,           31                      ; #2
        .edge    3,  2,        7,  0,           31                      ; #3
        .edge    2,  4,        6,  5,           31                      ; #4
        .edge    4,  0,        5,  4,           31                      ; #5
        .edge    5,  7,        8,  2,           31                      ; #6
        .edge    7,  6,        7,  3,           31                      ; #7
        .edge    6,  4,        6,  4,           31                      ; #8
        .edge    0,  2,        5,  0,           29                      ; #9
        .edge    1,  3,        1,  0,           30                      ; #10
        .edge    0,  6,        4,  3,           29                      ; #11
        .edge    1,  7,        3,  2,           30                      ; #12
        .edge    2,  6,        7,  6,           20                      ; #13
        .edge    3,  7,        8,  7,           20                      ; #14
        .edge    8, 10,        3,  3,           16                      ; #15
        .edge    9, 11,        3,  3,           17                      ; #16

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     31,      5,           31                      ; #0
        .face      4,     45,      8,           31                      ; #1
        .face     25,   -108,     19,           31                      ; #2
        .face      0,    -84,     12,           31                      ; #3
        .face    -25,   -108,     19,           31                      ; #4
        .face     -4,     45,      8,           31                      ; #5
        .face    -88,     16,   -214,           31                      ; #6
        .face      0,      0,   -187,           31                      ; #7
        .face     88,     16,   -214,           31                      ; #8

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc