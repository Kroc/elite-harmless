; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; rock hermit
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_HERMIT             = hull_index                                    ;=$0F

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_HERMIT_KILL        = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_hermit                                             ;$D01C/D

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a1                                                     ;$D050

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_HERMIT_KILL                                      ;$D071

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_HERMIT_KILL                                      ;$D092

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %01010101                                               ;$268C

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_hermit                                                     ;$DD35
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 7
        target_area     = 80
        max_edges       = 17
        laser_vertex    = 0
        explosion_count = 11
        bounty          = 0
        lod_distance    = 50
        max_energy      = 180
        max_speed       = 30
        normal_scaling  = 1
        laser_power     = 0
        missile_count   = 2
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,   80,    0,      15, 15, 15, 15,          31      ; #0
        .vertex  -80,  -10,    0,      15, 15, 15, 15,          31      ; #1
        .vertex    0,  -80,    0,      15, 15, 15, 15,          31      ; #2
        .vertex   70,  -40,    0,      15, 15, 15, 15,          31      ; #3
        .vertex   60,   50,    0,       5,  6, 12, 13,          31      ; #4
        .vertex   50,    0,   60,      15, 15, 15, 15,          31      ; #5
        .vertex  -40,    0,   70,       0,  1,  2,  3,          31      ; #6
        .vertex    0,   30,  -75,      15, 15, 15, 15,          31      ; #7
        .vertex    0,  -50,  -60,       8,  9, 10, 11,          31      ; #8

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        ; some BBC versions reuse the edge and face data
        ; from the asteroid but the C64 duplicates the data
        ; <www.bbcelite.com/compare/main/variable/ship_rock_hermit.html>
        ;
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        2,  7,           31                      ; #0
        .edge    0,  4,        6, 13,           31                      ; #1
        .edge    3,  4,        5, 12,           31                      ; #2
        .edge    2,  3,        4, 11,           31                      ; #3
        .edge    1,  2,        3, 10,           31                      ; #4
        .edge    1,  6,        2,  3,           31                      ; #5
        .edge    2,  6,        1,  3,           31                      ; #6
        .edge    2,  5,        1,  4,           31                      ; #7
        .edge    5,  6,        0,  1,           31                      ; #8
        .edge    0,  5,        0,  6,           31                      ; #9
        .edge    3,  5,        4,  5,           31                      ; #10
        .edge    0,  6,        0,  2,           31                      ; #11
        .edge    4,  5,        5,  6,           31                      ; #12
        .edge    1,  8,        8, 10,           31                      ; #13
        .edge    1,  7,        7,  8,           31                      ; #14
        .edge    0,  7,        7, 13,           31                      ; #15
        .edge    4,  7,       12, 13,           31                      ; #16
        .edge    3,  7,        9, 12,           31                      ; #17
        .edge    3,  8,        9, 11,           31                      ; #18
        .edge    2,  8,       10, 11,           31                      ; #19
        .edge    7,  8,        8,  9,           31                      ; #20

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      9,     66,     81,           31                      ; #0
        .face      9,    -66,     81,           31                      ; #1
        .face    -72,     64,     31,           31                      ; #2
        .face    -64,    -73,     47,           31                      ; #3
        .face     45,    -79,     65,           31                      ; #4
        .face    135,     15,     35,           31                      ; #5
        .face     38,     76,     70,           31                      ; #6
        .face    -66,     59,    -39,           31                      ; #7
        .face    -67,    -15,    -80,           31                      ; #8
        .face     66,    -14,    -75,           31                      ; #9
        .face    -70,    -80,    -40,           31                      ; #10
        .face     58,   -102,    -51,           31                      ; #11
        .face     81,      9,    -67,           31                      ; #12
        .face     47,     94,    -63,           31                      ; #13

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc