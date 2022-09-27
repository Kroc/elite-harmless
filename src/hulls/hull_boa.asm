; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; boa
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_BOA                = hull_index                                    ;=$0D

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_BOA_KILL           = 213   ;= 0.83

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_boa                                                ;$D018/9

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a0                                                     ;$D04E

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_BOA_KILL                                         ;$D06F

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_BOA_KILL                                         ;$D090

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_boa                                                        ;$DB3D
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 5
        target_area     = 70
        max_edges       = 23
        laser_vertex    = 0
        explosion_count = 8
        bounty          = 0
        lod_distance    = 40
        max_energy      = 250
        max_speed       = 24
        normal_scaling  = 0
        laser_power     = 3
        missile_count   = 4
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,   93,      15, 15, 15, 15,          31      ; #0
        .vertex    0,   40,  -87,       2,  0,  3,  3,          24      ; #1
        .vertex   38,  -25,  -99,       1,  0,  4,  4,          24      ; #2
        .vertex  -38,  -25,  -99,       2,  1,  5,  5,          24      ; #3
        .vertex  -38,   40,  -59,       3,  2,  9,  6,          31      ; #4
        .vertex   38,   40,  -59,       3,  0, 11,  6,          31      ; #5
        .vertex   62,    0,  -67,       4,  0, 11,  8,          31      ; #6
        .vertex   24,  -65,  -79,       4,  1, 10,  8,          31      ; #7
        .vertex  -24,  -65,  -79,       5,  1, 10,  7,          31      ; #8
        .vertex  -62,    0,  -67,       5,  2,  9,  7,          31      ; #9
        .vertex    0,    7, -107,       2,  0, 10, 10,          22      ; #10
        .vertex   13,   -9, -107,       1,  0, 10, 10,          22      ; #11
        .vertex  -13,   -9, -107,       2,  1, 12, 12,          22      ; #12

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  5,       11,  6,           31                      ; #0
        .edge    0,  7,       10,  8,           31                      ; #1
        .edge    0,  9,        9,  7,           31                      ; #2
        .edge    0,  4,        9,  6,           29                      ; #3
        .edge    0,  6,       11,  8,           29                      ; #4
        .edge    0,  8,       10,  7,           29                      ; #5
        .edge    4,  5,        6,  3,           31                      ; #6
        .edge    5,  6,       11,  0,           31                      ; #7
        .edge    6,  7,        8,  4,           31                      ; #8
        .edge    7,  8,       10,  1,           31                      ; #9
        .edge    8,  9,        7,  5,           31                      ; #10
        .edge    4,  9,        9,  2,           31                      ; #11
        .edge    1,  4,        3,  2,           24                      ; #12
        .edge    1,  5,        3,  0,           24                      ; #13
        .edge    3,  9,        5,  2,           24                      ; #14
        .edge    3,  8,        5,  1,           24                      ; #15
        .edge    2,  6,        4,  0,           24                      ; #16
        .edge    2,  7,        4,  1,           24                      ; #17
        .edge    1, 10,        2,  0,           22                      ; #18
        .edge    2, 11,        1,  0,           22                      ; #19
        .edge    3, 12,        2,  1,           22                      ; #20
        .edge   10, 11,       12,  0,           14                      ; #21
        .edge   11, 12,       12,  1,           14                      ; #22
        .edge   12, 10,       12,  2,           14                      ; #23

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face     43,     37,    -60,           31                      ; #0
        .face      0,    -45,    -89,           31                      ; #1
        .face    -43,     37,    -60,           31                      ; #2
        .face      0,     40,      0,           31                      ; #3
        .face     62,    -32,    -20,           31                      ; #4
        .face    -62,    -32,    -20,           31                      ; #5
        .face      0,     23,      6,           31                      ; #6
        .face    -23,    -15,      9,           31                      ; #7
        .face     23,    -15,      9,           31                      ; #8
        .face    -26,     13,     10,           31                      ; #9
        .face      0,    -31,     12,           31                      ; #10
        .face     26,     13,     10,           31                      ; #11
        .face      0,      0,   -107,           14                      ; #12

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc