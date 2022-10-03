; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; cougar
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COUGAR             = hull_index                                    ;=$20

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COUGAR_KILL        = 1365  ;= 5.33!

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_cougar                                             ;$D03E/F

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $20                                                     ;$D061

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_COUGAR_KILL                                      ;$D082

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_COUGAR_KILL                                      ;$D0A3

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %00000000       ; does not show on radar!               ;$269D

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_cougar                                                     ;$ED2B
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 3
        target_area     = 70
        max_edges       = 26
        laser_vertex    = 0
        explosion_count = 9
        bounty          = 0
        lod_distance    = 34
        max_energy      = 252
        max_speed       = 40
        normal_scaling  = 2
        laser_power     = 6
        missile_count   = 4
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    5,   67,       2,  0,  4,  4,          31      ; #0
        .vertex  -20,    0,   40,       1,  0,  2,  2,          31      ; #1
        .vertex  -40,    0,  -40,       1,  0,  5,  5,          31      ; #2
        .vertex    0,   14,  -40,       4,  0,  5,  5,          30      ; #3
        .vertex    0,  -14,  -40,       2,  1,  5,  3,          30      ; #4
        .vertex   20,    0,   40,       3,  2,  4,  4,          31      ; #5
        .vertex   40,    0,  -40,       4,  3,  5,  5,          31      ; #6
        .vertex  -36,    0,   56,       1,  0,  1,  1,          31      ; #7
        .vertex  -60,    0,  -20,       1,  0,  1,  1,          31      ; #8
        .vertex   36,    0,   56,       4,  3,  4,  4,          31      ; #9
        .vertex   60,    0,  -20,       4,  3,  4,  4,          31      ; #10
        .vertex    0,    7,   35,       0,  0,  4,  4,          18      ; #11
        .vertex    0,    8,   25,       0,  0,  4,  4,          20      ; #12
        .vertex  -12,    2,   45,       0,  0,  0,  0,          20      ; #13
        .vertex   12,    2,   45,       4,  4,  4,  4,          20      ; #14
        .vertex  -10,    6,  -40,       5,  5,  5,  5,          20      ; #15
        .vertex  -10,   -6,  -40,       5,  5,  5,  5,          20      ; #16
        .vertex   10,   -6,  -40,       5,  5,  5,  5,          20      ; #17
        .vertex   10,    6,  -40,       5,  5,  5,  5,          20      ; #18

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        2,  0,           31                      ; #0
        .edge    1,  7,        1,  0,           31                      ; #1
        .edge    7,  8,        1,  0,           31                      ; #2
        .edge    8,  2,        1,  0,           31                      ; #3
        .edge    2,  3,        5,  0,           30                      ; #4
        .edge    3,  6,        5,  4,           30                      ; #5
        .edge    2,  4,        5,  1,           30                      ; #6
        .edge    4,  6,        5,  3,           30                      ; #7
        .edge    6, 10,        4,  3,           31                      ; #8
        .edge   10,  9,        4,  3,           31                      ; #9
        .edge    9,  5,        4,  3,           31                      ; #10
        .edge    5,  0,        4,  2,           31                      ; #11
        .edge    0,  3,        4,  0,           27                      ; #12
        .edge    1,  4,        2,  1,           27                      ; #13
        .edge    5,  4,        3,  2,           27                      ; #14
        .edge    1,  2,        1,  0,           26                      ; #15
        .edge    5,  6,        4,  3,           26                      ; #16
        .edge   12, 13,        0,  0,           20                      ; #17
        .edge   13, 11,        0,  0,           18                      ; #18
        .edge   11, 14,        4,  4,           18                      ; #19
        .edge   14, 12,        4,  4,           20                      ; #20
        .edge   15, 16,        5,  5,           18                      ; #21
        .edge   16, 18,        5,  5,           20                      ; #22
        .edge   18, 17,        5,  5,           18                      ; #23
        .edge   17, 15,        5,  5,           20                      ; #24

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -16,     46,      4,           31                      ; #0
        .face    -16,    -46,      4,           31                      ; #1
        .face      0,    -27,      5,           31                      ; #2
        .face     16,    -46,      4,           31                      ; #3
        .face     16,     46,      4,           31                      ; #4
        .face      0,      0,   -160,           30                      ; #5

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc