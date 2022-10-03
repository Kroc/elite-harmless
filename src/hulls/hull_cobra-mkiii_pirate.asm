; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; combra mk-III (pirate)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MK3_PIRATE         = hull_index                                    ;=$18

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MK3_PIRATE_KILL    = 298   ;= 1.16

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_mk3_pirate                                         ;$D02E/F

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $8c                                                     ;$D059

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MK3_PIRATE_KILL                                  ;$D07A

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MK3_PIRATE_KILL                                  ;$D09B

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2785

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_mk3_pirate                                                 ;$E50B
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 1
        target_area     = 95
        max_edges       = 39
        laser_vertex    = 21
        explosion_count = 9
        bounty          = 175
        lod_distance    = 50
        max_energy      = 150
        max_speed       = 28
        normal_scaling  = 1
        laser_power     = 2
        missile_count   = 2
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   32,    0,   76,      15, 15, 15, 15,          31      ; #0
        .vertex  -32,    0,   76,      15, 15, 15, 15,          31      ; #1
        .vertex    0,   26,   24,      15, 15, 15, 15,          31      ; #2
        .vertex -120,   -3,   -8,       3,  7, 10, 10,          31      ; #3
        .vertex  120,   -3,   -8,       4,  8, 12, 12,          31      ; #4
        .vertex  -88,   16,  -40,      15, 15, 15, 15,          31      ; #5
        .vertex   88,   16,  -40,      15, 15, 15, 15,          31      ; #6
        .vertex  128,   -8,  -40,       8,  9, 12, 12,          31      ; #7
        .vertex -128,   -8,  -40,       7,  9, 10, 10,          31      ; #8
        .vertex    0,   26,  -40,       5,  6,  9,  9,          31      ; #9
        .vertex  -32,  -24,  -40,       9, 10, 11, 11,          31      ; #10
        .vertex   32,  -24,  -40,       9, 11, 12, 12,          31      ; #11
        .vertex  -36,    8,  -40,       9,  9,  9,  9,          20      ; #12
        .vertex   -8,   12,  -40,       9,  9,  9,  9,          20      ; #13
        .vertex    8,   12,  -40,       9,  9,  9,  9,          20      ; #14
        .vertex   36,    8,  -40,       9,  9,  9,  9,          20      ; #15
        .vertex   36,  -12,  -40,       9,  9,  9,  9,          20      ; #16
        .vertex    8,  -16,  -40,       9,  9,  9,  9,          20      ; #17
        .vertex   -8,  -16,  -40,       9,  9,  9,  9,          20      ; #18
        .vertex  -36,  -12,  -40,       9,  9,  9,  9,          20      ; #19
        .vertex    0,    0,   76,       0, 11, 11, 11,           6      ; #20
        .vertex    0,    0,   90,       0, 11, 11, 11,          31      ; #21
        .vertex  -80,   -6,  -40,       9,  9,  9,  9,           8      ; #22
        .vertex  -80,    6,  -40,       9,  9,  9,  9,           8      ; #23
        .vertex  -88,    0,  -40,       9,  9,  9,  9,           6      ; #24
        .vertex   80,    6,  -40,       9,  9,  9,  9,           8      ; #25
        .vertex   88,    0,  -40,       9,  9,  9,  9,           6      ; #26
        .vertex   80,   -6,  -40,       9,  9,  9,  9,           8      ; #27

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        ; some BBC versions reuse the edge and face data from the
        ; non-pirate Cobra Mk.III but the C64 duplicates the data
        ; <www.bbcelite.com/compare/main/variable/ship_cobra_mk_3_p.html>
        ;
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        0, 11,           31                      ; #0
        .edge    0,  4,        4, 12,           31                      ; #1
        .edge    1,  3,        3, 10,           31                      ; #2
        .edge    3,  8,        7, 10,           31                      ; #3
        .edge    4,  7,        8, 12,           31                      ; #4
        .edge    6,  7,        8,  9,           31                      ; #5
        .edge    6,  9,        6,  9,           31                      ; #6
        .edge    5,  9,        5,  9,           31                      ; #7
        .edge    5,  8,        7,  9,           31                      ; #8
        .edge    2,  5,        1,  5,           31                      ; #9
        .edge    2,  6,        2,  6,           31                      ; #10
        .edge    3,  5,        3,  7,           31                      ; #11
        .edge    4,  6,        4,  8,           31                      ; #12
        .edge    1,  2,        0,  1,           31                      ; #13
        .edge    0,  2,        0,  2,           31                      ; #14
        .edge    8, 10,        9, 10,           31                      ; #15
        .edge   10, 11,        9, 11,           31                      ; #16
        .edge    7, 11,        9, 12,           31                      ; #17
        .edge    1, 10,       10, 11,           31                      ; #18
        .edge    0, 11,       11, 12,           31                      ; #19
        .edge    1,  5,        1,  3,           29                      ; #20
        .edge    0,  6,        2,  4,           29                      ; #21
        .edge   20, 21,        0, 11,            6                      ; #22
        .edge   12, 13,        9,  9,           20                      ; #23
        .edge   18, 19,        9,  9,           20                      ; #24
        .edge   14, 15,        9,  9,           20                      ; #25
        .edge   16, 17,        9,  9,           20                      ; #26
        .edge   15, 16,        9,  9,           19                      ; #27
        .edge   14, 17,        9,  9,           17                      ; #28
        .edge   13, 18,        9,  9,           19                      ; #29
        .edge   12, 19,        9,  9,           19                      ; #30
        .edge    2,  9,        5,  6,           30                      ; #31
        .edge   22, 24,        9,  9,            6                      ; #32
        .edge   23, 24,        9,  9,            6                      ; #33
        .edge   22, 23,        9,  9,            8                      ; #34
        .edge   25, 26,        9,  9,            6                      ; #35
        .edge   26, 27,        9,  9,            6                      ; #36
        .edge   25, 27,        9,  9,            8                      ; #37

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     62,     31,           31                      ; #0
        .face    -18,     55,     16,           31                      ; #1
        .face     18,     55,     16,           31                      ; #2
        .face    -16,     52,     14,           31                      ; #3
        .face     16,     52,     14,           31                      ; #4
        .face    -14,     47,      0,           31                      ; #5
        .face     14,     47,      0,           31                      ; #6
        .face    -61,    102,      0,           31                      ; #7
        .face     61,    102,      0,           31                      ; #8
        .face      0,      0,    -80,           31                      ; #9
        .face     -7,    -42,      9,           31                      ; #10
        .face      0,    -30,      6,           31                      ; #11
        .face      7,    -42,      9,           31                      ; #12

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc