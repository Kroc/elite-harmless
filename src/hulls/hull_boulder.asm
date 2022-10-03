; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; boulder
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_BOULDER            = hull_index                                    ;=$06

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_BOULDER_KILL       = 6     ;= 0.02

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_boulder                                            ;$D00A/B

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D047

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_BOULDER_KILL                                     ;$D068

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_BOULDER_KILL                                     ;$D089

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %01010101                                               ;$2683

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_boulder                                                    ;$D3FB
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 30
        max_edges       = 12
        laser_vertex    = 0
        explosion_count = 2
        bounty          = 1
        lod_distance    = 20
        max_energy      = 20
        max_speed       = 30
        normal_scaling  = 2
        laser_power     = 0
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -18,   37,  -11,       1,  0,  9,  5,          31      ; #0
        .vertex   30,    7,   12,       2,  1,  6,  5,          31      ; #1
        .vertex   28,   -7,  -12,       3,  2,  7,  6,          31      ; #2
        .vertex    2,    0,  -39,       4,  3,  8,  7,          31      ; #3
        .vertex  -28,   34,  -30,       4,  0,  9,  8,          31      ; #4
        .vertex    5,  -10,   13,      15, 15, 15, 15,          31      ; #5
        .vertex   20,   17,  -30,      15, 15, 15, 15,          31      ; #6

        .endproc
        
        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        5,  1,           31                      ; #0
        .edge    1,  2,        6,  2,           31                      ; #1
        .edge    2,  3,        7,  3,           31                      ; #2
        .edge    3,  4,        8,  4,           31                      ; #3
        .edge    4,  0,        9,  0,           31                      ; #4
        .edge    0,  5,        1,  0,           31                      ; #5
        .edge    1,  5,        2,  1,           31                      ; #6
        .edge    2,  5,        3,  2,           31                      ; #7
        .edge    3,  5,        4,  3,           31                      ; #8
        .edge    4,  5,        4,  0,           31                      ; #9
        .edge    0,  6,        9,  5,           31                      ; #10
        .edge    1,  6,        6,  5,           31                      ; #11
        .edge    2,  6,        7,  6,           31                      ; #12
        .edge    3,  6,        8,  7,           31                      ; #13
        .edge    4,  6,        9,  8,           31                      ; #14

        .endproc
        
        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -15,     -3,      8,           31                      ; #0
        .face     -7,     12,     30,           31                      ; #1
        .face     32,    -47,     24,           31                      ; #2
        .face     -3,    -39,     -7,           31                      ; #3
        .face     -5,     -4,     -1,           31                      ; #4
        .face     49,     84,      8,           31                      ; #5
        .face    112,     21,    -21,           31                      ; #6
        .face     76,    -35,    -82,           31                      ; #7
        .face     22,     56,   -137,           31                      ; #8
        .face     40,    110,    -38,           31                      ; #9

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc