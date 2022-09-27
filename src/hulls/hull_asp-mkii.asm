; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; asp mk-II
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ASPMK2             = hull_index                                    ;=$19

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ASPMK2_KILL        = 277   ;= 1.08

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_aspmk2                                             ;$D030/1

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D05A

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ASPMK2_KILL                                      ;$D07B

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ASPMK2_KILL                                      ;$D09C

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_aspmk2                                                     ;$E693
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 60
        max_edges       = 26
        laser_vertex    = 8
        explosion_count = 5
        bounty          = 200
        lod_distance    = 40
        max_energy      = 150
        max_speed       = 40
        normal_scaling  = 1
        laser_power     = 5
        missile_count   = 1
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,  -18,    0,       1,  0,  2,  2,          22      ; #0
        .vertex    0,   -9,  -45,       2,  1, 11, 11,          31      ; #1
        .vertex   43,    0,  -45,       6,  1, 11, 11,          31      ; #2
        .vertex   69,   -3,    0,       6,  1,  9,  7,          31      ; #3
        .vertex   43,  -14,   28,       1,  0,  7,  7,          31      ; #4
        .vertex  -43,    0,  -45,       5,  2, 11, 11,          31      ; #5
        .vertex  -69,   -3,    0,       5,  2, 10,  8,          31      ; #6
        .vertex  -43,  -14,   28,       2,  0,  8,  8,          31      ; #7
        .vertex   26,   -7,   73,       4,  0,  9,  7,          31      ; #8
        .vertex  -26,   -7,   73,       4,  0, 10,  8,          31      ; #9
        .vertex   43,   14,   28,       4,  3,  9,  6,          31      ; #10
        .vertex  -43,   14,   28,       4,  3, 10,  5,          31      ; #11
        .vertex    0,    9,  -45,       5,  3, 11,  6,          31      ; #12
        .vertex  -17,    0,  -45,      11, 11, 11, 11,          10      ; #13
        .vertex   17,    0,  -45,      11, 11, 11, 11,           9      ; #14
        .vertex    0,   -4,  -45,      11, 11, 11, 11,          10      ; #15
        .vertex    0,    4,  -45,      11, 11, 11, 11,           8      ; #16
        .vertex    0,   -7,   73,       4,  0,  4,  0,          10      ; #17
        .vertex    0,   -7,   83,       4,  0,  4,  0,          10      ; #18

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        2,  1,           22                      ; #0
        .edge    0,  4,        1,  0,           22                      ; #1
        .edge    0,  7,        2,  0,           22                      ; #2
        .edge    1,  2,       11,  1,           31                      ; #3
        .edge    2,  3,        6,  1,           31                      ; #4
        .edge    3,  8,        9,  7,           16                      ; #5
        .edge    8,  9,        4,  0,           31                      ; #6
        .edge    6,  9,       10,  8,           16                      ; #7
        .edge    5,  6,        5,  2,           31                      ; #8
        .edge    1,  5,       11,  2,           31                      ; #9
        .edge    3,  4,        7,  1,           31                      ; #10
        .edge    4,  8,        7,  0,           31                      ; #11
        .edge    6,  7,        8,  2,           31                      ; #12
        .edge    7,  9,        8,  0,           31                      ; #13
        .edge    2, 12,       11,  6,           31                      ; #14
        .edge    5, 12,       11,  5,           31                      ; #15
        .edge   10, 12,        6,  3,           22                      ; #16
        .edge   11, 12,        5,  3,           22                      ; #17
        .edge   10, 11,        4,  3,           22                      ; #18
        .edge    6, 11,       10,  5,           31                      ; #19
        .edge    9, 11,       10,  4,           31                      ; #20
        .edge    3, 10,        9,  6,           31                      ; #21
        .edge    8, 10,        9,  4,           31                      ; #22
        .edge   13, 15,       11, 11,           10                      ; #23
        .edge   15, 14,       11, 11,            9                      ; #24
        .edge   14, 16,       11, 11,            8                      ; #25
        .edge   16, 13,       11, 11,            8                      ; #26
        .edge   18, 17,        4,  0,           10                      ; #27

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,    -35,      5,           31                      ; #0
        .face      8,    -38,     -7,           31                      ; #1
        .face     -8,    -38,     -7,           31                      ; #2
        .face      0,     24,     -1,           22                      ; #3
        .face      0,     43,     19,           31                      ; #4
        .face     -6,     28,     -2,           31                      ; #5
        .face      6,     28,     -2,           31                      ; #6
        .face     59,    -64,     31,           31                      ; #7
        .face    -59,    -64,     31,           31                      ; #8
        .face     80,     46,     50,           31                      ; #9
        .face    -80,     46,     50,           31                      ; #10
        .face      0,      0,    -90,           31                      ; #11

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; unused junk bytes! these differ from the BBC data-tables
        ; <www.bbcelite.com/master/game_data/variable/ship_asp_mk_2.html>
        .byte   $59, $3a, $43, $4d
.endif  ;///////////////////////////////////////////////////////////////////////

.endproc