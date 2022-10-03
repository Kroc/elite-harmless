; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; viper
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_VIPER              = hull_index                                    ;=$10

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_VIPER_KILL         = 26    ;= 0.10

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_viper                                              ;$D01E/F

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $c2                                                     ;$D051

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_VIPER_KILL                                       ;$D072

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_VIPER_KILL                                       ;$D093

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$268D

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_viper                                                      ;$DE0B
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 75
        max_edges       = 20
        laser_vertex    = 0
        explosion_count = 9
        bounty          = 0
        lod_distance    = 23
        max_energy      = 140   ; 140 BBC Master, 120 BBC Casette, 100 BBC Disk
        max_speed       = 32
        normal_scaling  = 1
        laser_power     = 2
        missile_count   = 1
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,   72,       1,  2,  3,  4,          31      ; #0
        .vertex    0,   16,   24,       0,  1,  2,  2,          30      ; #1
        .vertex    0,  -16,   24,       3,  4,  5,  5,          30      ; #2
        .vertex   48,    0,  -24,       2,  4,  6,  6,          31      ; #3
        .vertex  -48,    0,  -24,       1,  3,  6,  6,          31      ; #4
        .vertex   24,  -16,  -24,       4,  5,  6,  6,          30      ; #5
        .vertex  -24,  -16,  -24,       5,  3,  6,  6,          30      ; #6
        .vertex   24,   16,  -24,       0,  2,  6,  6,          31      ; #7
        .vertex  -24,   16,  -24,       0,  1,  6,  6,          31      ; #8
        .vertex  -32,    0,  -24,       6,  6,  6,  6,          19      ; #9
        .vertex   32,    0,  -24,       6,  6,  6,  6,          19      ; #10
        .vertex    8,    8,  -24,       6,  6,  6,  6,          19      ; #11
        .vertex   -8,    8,  -24,       6,  6,  6,  6,          19      ; #12
        .vertex   -8,   -8,  -24,       6,  6,  6,  6,          18      ; #13
        .vertex    8,   -8,  -24,       6,  6,  6,  6,          18      ; #14

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  3,        2,  4,           31                      ; #0
        .edge    0,  1,        1,  2,           30                      ; #1
        .edge    0,  2,        3,  4,           30                      ; #2
        .edge    0,  4,        1,  3,           31                      ; #3
        .edge    1,  7,        0,  2,           30                      ; #4
        .edge    1,  8,        0,  1,           30                      ; #5
        .edge    2,  5,        4,  5,           30                      ; #6
        .edge    2,  6,        3,  5,           30                      ; #7
        .edge    7,  8,        0,  6,           31                      ; #8
        .edge    5,  6,        5,  6,           30                      ; #9
        .edge    4,  8,        1,  6,           31                      ; #10
        .edge    4,  6,        3,  6,           30                      ; #11
        .edge    3,  7,        2,  6,           31                      ; #12
        .edge    3,  5,        6,  4,           30                      ; #13
        .edge    9, 12,        6,  6,           19                      ; #14
        .edge    9, 13,        6,  6,           18                      ; #15
        .edge   10, 11,        6,  6,           19                      ; #16
        .edge   10, 14,        6,  6,           18                      ; #17
        .edge   11, 14,        6,  6,           16                      ; #18
        .edge   12, 13,        6,  6,           16                      ; #19

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     32,      0,           31                      ; #0
        .face    -22,     33,     11,           31                      ; #1
        .face     22,     33,     11,           31                      ; #2
        .face    -22,    -33,     11,           31                      ; #3
        .face     22,    -33,     11,           31                      ; #4
        .face      0,    -32,      0,           31                      ; #5
        .face      0,      0,    -48,           31                      ; #6

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc