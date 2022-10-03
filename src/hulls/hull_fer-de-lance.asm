; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; fer-de-lance
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_FERDELANCE         = hull_index                                    ;=$1B

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_FERDELANCE_KILL    = 320   ;= 1.25

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_ferdelance                                         ;$D034/5

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $82                                                     ;$D05C

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_FERDELANCE_KILL                                  ;$D07D

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_FERDELANCE_KILL                                  ;$D09E

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2698

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_ferdelance                                                 ;$E8AF
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 40
        max_edges       = 27
        laser_vertex    = 0
        explosion_count = 5
        bounty          = 0
        lod_distance    = 40
        max_energy      = 160
        max_speed       = 30
        normal_scaling  = 1
        laser_power     = 2
        missile_count   = 2
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,  -14,  108,       1,  0,  9,  5,          31      ; #0
        .vertex  -40,  -14,   -4,       2,  1,  9,  9,          31      ; #1
        .vertex  -12,  -14,  -52,       3,  2,  9,  9,          31      ; #2
        .vertex   12,  -14,  -52,       4,  3,  9,  9,          31      ; #3
        .vertex   40,  -14,   -4,       5,  4,  9,  9,          31      ; #4
        .vertex  -40,   14,   -4,       1,  0,  6,  2,          28      ; #5
        .vertex  -12,    2,  -52,       3,  2,  7,  6,          28      ; #6
        .vertex   12,    2,  -52,       4,  3,  8,  7,          28      ; #7
        .vertex   40,   14,   -4,       4,  0,  8,  5,          28      ; #8
        .vertex    0,   18,  -20,       6,  0,  8,  7,          15      ; #9
        .vertex   -3,  -11,   97,       0,  0,  0,  0,          11      ; #10
        .vertex  -26,    8,   18,       0,  0,  0,  0,           9      ; #11
        .vertex  -16,   14,   -4,       0,  0,  0,  0,          11      ; #12
        .vertex    3,  -11,   97,       0,  0,  0,  0,          11      ; #13
        .vertex   26,    8,   18,       0,  0,  0,  0,           9      ; #14
        .vertex   16,   14,   -4,       0,  0,  0,  0,          11      ; #15
        .vertex    0,  -14,  -20,       9,  9,  9,  9,          12      ; #16
        .vertex  -14,  -14,   44,       9,  9,  9,  9,          12      ; #17
        .vertex   14,  -14,   44,       9,  9,  9,  9,          12      ; #18

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        9,  1,           31                      ; #0
        .edge    1,  2,        9,  2,           31                      ; #1
        .edge    2,  3,        9,  3,           31                      ; #2
        .edge    3,  4,        9,  4,           31                      ; #3
        .edge    0,  4,        9,  5,           31                      ; #4
        .edge    0,  5,        1,  0,           28                      ; #5
        .edge    5,  6,        6,  2,           28                      ; #6
        .edge    6,  7,        7,  3,           28                      ; #7
        .edge    7,  8,        8,  4,           28                      ; #8
        .edge    0,  8,        5,  0,           28                      ; #9
        .edge    5,  9,        6,  0,           15                      ; #10
        .edge    6,  9,        7,  6,           11                      ; #11
        .edge    7,  9,        8,  7,           11                      ; #12
        .edge    8,  9,        8,  0,           15                      ; #13
        .edge    1,  5,        2,  1,           14                      ; #14
        .edge    2,  6,        3,  2,           14                      ; #15
        .edge    3,  7,        4,  3,           14                      ; #16
        .edge    4,  8,        5,  4,           14                      ; #17
        .edge   10, 11,        0,  0,            8                      ; #18
        .edge   11, 12,        0,  0,            9                      ; #19
        .edge   10, 12,        0,  0,           11                      ; #20
        .edge   13, 14,        0,  0,            8                      ; #21
        .edge   14, 15,        0,  0,            9                      ; #22
        .edge   13, 15,        0,  0,           11                      ; #23
        .edge   16, 17,        9,  9,           12                      ; #24
        .edge   16, 18,        9,  9,           12                      ; #25
        .edge   17, 18,        9,  9,            8                      ; #26

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     24,      6,           28                      ; #0
        .face    -68,      0,     24,           31                      ; #1
        .face    -63,      0,    -37,           31                      ; #2
        .face      0,      0,   -104,           31                      ; #3
        .face     63,      0,    -37,           31                      ; #4
        .face     68,      0,     24,           31                      ; #5
        .face    -12,     46,    -19,           28                      ; #6
        .face      0,     45,    -22,           28                      ; #7
        .face     12,     46,    -19,           28                      ; #8
        .face      0,    -28,      0,           31                      ; #9

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc