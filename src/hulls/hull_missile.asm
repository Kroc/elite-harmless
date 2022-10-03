; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; missile
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MISSILE            = hull_index                    ; BBC: MSL      ;=$01

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MISSILE_KILL       = 149   ;= 0.58

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_missile                                            ;$D000/1

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D042

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MISSILE_KILL                                     ;$D063

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MISSILE_KILL                                     ;$D084

.segment        "CODE_276E"                                             ;$276E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %11111111                                               ;$276E

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_missile                                                    ;$D0A5
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 40
        max_edges       = 21
        laser_vertex    = 0
        explosion_count = 1
        bounty          = 0
        lod_distance    = 14
        max_energy      = 2
        max_speed       = 44
        normal_scaling  = 2
        laser_power     = 0
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,   68,       0,  1,  2,  3,          31      ; #0
        .vertex    8,   -8,   36,       1,  2,  4,  5,          31      ; #1
        .vertex    8,    8,   36,       2,  3,  4,  7,          31      ; #2
        .vertex   -8,    8,   36,       0,  3,  6,  7,          31      ; #3
        .vertex   -8,   -8,   36,       0,  1,  5,  6,          31      ; #4
        .vertex    8,    8,  -44,       4,  7,  8,  8,          31      ; #5
        .vertex    8,   -8,  -44,       4,  5,  8,  8,          31      ; #6
        .vertex   -8,   -8,  -44,       5,  6,  8,  8,          31      ; #7
        .vertex   -8,    8,  -44,       6,  7,  8,  8,          31      ; #8
        .vertex   12,   12,  -44,       4,  7,  8,  8,           8      ; #9
        .vertex   12,  -12,  -44,       4,  5,  8,  8,           8      ; #10
        .vertex  -12,  -12,  -44,       5,  6,  8,  8,           8      ; #11
        .vertex  -12,   12,  -44,       6,  7,  8,  8,           8      ; #12
        .vertex   -8,    8,  -12,       6,  7,  7,  7,           8      ; #13
        .vertex   -8,   -8,  -12,       5,  6,  6,  6,           8      ; #14
        .vertex    8,    8,  -12,       4,  7,  7,  7,           8      ; #15
        .vertex    8,   -8,  -12,       4,  5,  5,  5,           8      ; #16

        .endproc
        
        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        1,  2,           31                      ; #0
        .edge    0,  2,        2,  3,           31                      ; #1
        .edge    0,  3,        0,  3,           31                      ; #2
        .edge    0,  4,        0,  1,           31                      ; #3
        .edge    1,  2,        4,  2,           31                      ; #4
        .edge    1,  4,        1,  5,           31                      ; #5
        .edge    3,  4,        0,  6,           31                      ; #6
        .edge    2,  3,        3,  7,           31                      ; #7
        .edge    2,  5,        4,  7,           31                      ; #8
        .edge    1,  6,        4,  5,           31                      ; #9
        .edge    4,  7,        5,  6,           31                      ; #10
        .edge    3,  8,        6,  7,           31                      ; #11
        .edge    7,  8,        6,  8,           31                      ; #12
        .edge    5,  8,        7,  8,           31                      ; #13
        .edge    5,  6,        4,  8,           31                      ; #14
        .edge    6,  7,        5,  8,           31                      ; #15
        .edge    6, 10,        5,  8,            8                      ; #16
        .edge    5,  9,        7,  8,            8                      ; #17
        .edge    8, 12,        7,  8,            8                      ; #18
        .edge    7, 11,        5,  8,            8                      ; #19
        .edge    9, 15,        4,  7,            8                      ; #20
        .edge   10, 16,        4,  5,            8                      ; #21
        .edge   12, 13,        6,  7,            8                      ; #22
        .edge   11, 14,        5,  6,            8                      ; #23

        .endproc
        
        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -64,      0,     16,           31                      ; #0
        .face      0,    -64,     16,           31                      ; #1
        .face     64,      0,     16,           31                      ; #2
        .face      0,     64,     16,           31                      ; #3
        .face     32,      0,      0,           31                      ; #4
        .face      0,    -32,      0,           31                      ; #5
        .face    -32,      0,      0,           31                      ; #6
        .face      0,     32,      0,           31                      ; #7
        .face      0,      0,   -176,           31                      ; #8
        ; these last two faces are different on the BBC disk version
        ; <https://www.bbcelite.com/compare/main/variable/ship_missile.html>
        ; TODO: are these versions of the faces preferable?
;       .face      0,    160,    110,           31                      ; #7
;       .face      0,     64,      4,            0                      ; #8

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc