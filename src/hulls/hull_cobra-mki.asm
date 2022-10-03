; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cobra mk-I
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COBRAMK1           = hull_index                                    ;=$16

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COBRAMK1_KILL      = 170   ;= 0.66

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_cobramk1                                           ;$D02A/B

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D057

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_COBRAMK1_KILL                                    ;$D078

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_COBRAMK1_KILL                                    ;$D099

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2783

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_cobramk1                                                   ;$E395
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 3
        target_area     = 99
        max_edges       = 18
        laser_vertex    = 10
        explosion_count = 5
        bounty          = 75
        lod_distance    = 19
        max_energy      = 90
        max_speed       = 26
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 2
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -18,   -1,   50,       1,  0,  3,  2,          31      ; #0
        .vertex   18,   -1,   50,       1,  0,  5,  4,          31      ; #1
        .vertex  -66,    0,    7,       3,  2,  8,  8,          31      ; #2
        .vertex   66,    0,    7,       5,  4,  9,  9,          31      ; #3
        .vertex  -32,   12,  -38,       6,  2,  8,  7,          31      ; #4
        .vertex   32,   12,  -38,       6,  4,  9,  7,          31      ; #5
        .vertex  -54,  -12,  -38,       3,  1,  8,  7,          31      ; #6
        .vertex   54,  -12,  -38,       5,  1,  9,  7,          31      ; #7
        .vertex    0,   12,   -6,       2,  0,  6,  4,          20      ; #8
        .vertex    0,   -1,   50,       1,  0,  1,  1,           2      ; #9
        .vertex    0,   -1,   60,       1,  0,  1,  1,          31      ; #10

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    1,  0,        1,  0,           31                      ; #0
        .edge    0,  2,        3,  2,           31                      ; #1
        .edge    2,  6,        8,  3,           31                      ; #2
        .edge    6,  7,        7,  1,           31                      ; #3
        .edge    7,  3,        9,  5,           31                      ; #4
        .edge    3,  1,        5,  4,           31                      ; #5
        .edge    2,  4,        8,  2,           31                      ; #6
        .edge    4,  5,        7,  6,           31                      ; #7
        .edge    5,  3,        9,  4,           31                      ; #8
        .edge    0,  8,        2,  0,           20                      ; #9
        .edge    8,  1,        4,  0,           20                      ; #10
        .edge    4,  8,        6,  2,           16                      ; #11
        .edge    8,  5,        6,  4,           16                      ; #12
        .edge    4,  6,        8,  7,           31                      ; #13
        .edge    5,  7,        9,  7,           31                      ; #14
        .edge    0,  6,        3,  1,           20                      ; #15
        .edge    1,  7,        5,  1,           20                      ; #16
        .edge   10,  9,        1,  0,            2                      ; #17

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     41,     10,           31                      ; #0
        .face      0,    -27,      3,           31                      ; #1
        .face     -8,     46,      8,           31                      ; #2
        .face    -12,    -57,     12,           31                      ; #3
        .face      8,     46,      8,           31                      ; #4
        .face     12,    -57,     12,           31                      ; #5
        .face      0,     49,      0,           31                      ; #6
        .face      0,      0,   -154,           31                      ; #7
        .face   -121,    111,    -62,           31                      ; #8
        .face    121,    111,    -62,           31                      ; #9

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc