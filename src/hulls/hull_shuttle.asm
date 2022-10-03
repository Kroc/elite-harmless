; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; shuttle
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_SHUTTLE            = hull_index                                    ;=$09

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_SHUTTLE_KILL       = 16    ;= 0.062

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_shuttle                                            ;$D010/1

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $21                                                     ;$D04A

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_SHUTTLE_KILL                                     ;$D06B

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_SHUTTLE_KILL                                     ;$D08C

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2686

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_shuttle                                                    ;$D5AF
        ;-----------------------------------------------------------------------
        .proc   header
 
        scoop           = 0
        debris          = 15
        target_area     = 50
        max_edges       = 28
        laser_vertex    = 0
        explosion_count = 8
        bounty          = 0
        lod_distance    = 22
        max_energy      = 32
        max_speed       = 8
        normal_scaling  = 2
        laser_power     = 0
        missile_count   = 0
 
        .hull
 
        .endproc
 
        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,  -17,   23,      15, 15, 15, 15,          31      ; #0
        .vertex  -17,    0,   23,      15, 15, 15, 15,          31      ; #1
        .vertex    0,   18,   23,      15, 15, 15, 15,          31      ; #2
        .vertex   18,    0,   23,      15, 15, 15, 15,          31      ; #3
        .vertex  -20,  -20,  -27,       2,  1,  9,  3,          31      ; #4
        .vertex  -20,   20,  -27,       4,  3,  9,  5,          31      ; #5
        .vertex   20,   20,  -27,       6,  5,  9,  7,          31      ; #6
        .vertex   20,  -20,  -27,       7,  1,  9,  8,          31      ; #7
        .vertex    5,    0,  -27,       9,  9,  9,  9,          16      ; #8
        .vertex    0,   -2,  -27,       9,  9,  9,  9,          16      ; #9
        .vertex   -5,    0,  -27,       9,  9,  9,  9,           9      ; #10
        .vertex    0,    3,  -27,       9,  9,  9,  9,           9      ; #11
        .vertex    0,   -9,   35,      10,  0, 12, 11,          16      ; #12
        .vertex    3,   -1,   31,      15, 15,  2,  0,           7      ; #13
        .vertex    4,   11,   25,       1,  0,  4, 15,           8      ; #14
        .vertex   11,    4,   25,       1, 10, 15,  3,           8      ; #15
        .vertex   -3,   -1,   31,      11,  6,  3,  2,           7      ; #16
        .vertex   -3,   11,   25,       8, 15,  0, 12,           8      ; #17
        .vertex  -10,    4,   25,      15,  4,  8,  1,           8      ; #18
        
        .endproc
 
        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        2,  0,           31                      ; #0
        .edge    1,  2,       10,  4,           31                      ; #1
        .edge    2,  3,       11,  6,           31                      ; #2
        .edge    0,  3,       12,  8,           31                      ; #3
        .edge    0,  7,        8,  1,           31                      ; #4
        .edge    0,  4,        2,  1,           24                      ; #5
        .edge    1,  4,        3,  2,           31                      ; #6
        .edge    1,  5,        4,  3,           24                      ; #7
        .edge    2,  5,        5,  4,           31                      ; #8
        .edge    2,  6,        6,  5,           12                      ; #9
        .edge    3,  6,        7,  6,           31                      ; #10
        .edge    3,  7,        8,  7,           24                      ; #11
        .edge    4,  5,        9,  3,           31                      ; #12
        .edge    5,  6,        9,  5,           31                      ; #13
        .edge    6,  7,        9,  7,           31                      ; #14
        .edge    4,  7,        9,  1,           31                      ; #15
        .edge    0, 12,       12,  0,           16                      ; #16
        .edge    1, 12,       10,  0,           16                      ; #17
        .edge    2, 12,       11, 10,           16                      ; #18
        .edge    3, 12,       12, 11,           16                      ; #19
        .edge    8,  9,        9,  9,           16                      ; #20
        .edge    9, 10,        9,  9,            7                      ; #21
        .edge   10, 11,        9,  9,            9                      ; #22
        .edge    8, 11,        9,  9,            7                      ; #23
        .edge   13, 14,       11, 11,            5                      ; #24
        .edge   14, 15,       11, 11,            8                      ; #25
        .edge   13, 15,       11, 11,            7                      ; #26
        .edge   16, 17,       10, 10,            5                      ; #27
        .edge   17, 18,       10, 10,            8                      ; #28
        .edge   16, 18,       10, 10,            7                      ; #29
        
        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -55,    -55,     40,           31                      ; #0
        .face      0,    -74,      4,           31                      ; #1
        .face    -51,    -51,     23,           31                      ; #2
        .face    -74,      0,      4,           31                      ; #3
        .face    -51,     51,     23,           31                      ; #4
        .face      0,     74,      4,           31                      ; #5
        .face     51,     51,     23,           31                      ; #6
        .face     74,      0,      4,           31                      ; #7
        .face     51,    -51,     23,           31                      ; #8
        .face      0,      0,   -107,           31                      ; #9
        .face    -41,     41,     90,           31                      ; #10
        .face     41,     41,     90,           31                      ; #11
        .face     55,    -55,     40,           31                      ; #12
        
        .endproc
 
        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc