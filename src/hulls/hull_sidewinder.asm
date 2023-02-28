; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; sidewinder
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_SIDEWINDER         = hull_index                                    ;=$11

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_SIDEWINDER_KILL    = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_sidewinder                                         ;$D020/1

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $0c                                                     ;$D052

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_SIDEWINDER_KILL                                  ;$D073

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_SIDEWINDER_KILL                                  ;$D094

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$268E

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_sidewinder                                                 ;$DEE5
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 65
        max_edges       = 16
        laser_vertex    = 0
        explosion_count = 6
        bounty          = 50
        lod_distance    = 20
        max_energy      = 70
        max_speed       = 37
        normal_scaling  = 2
        laser_power     = 2
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -32,    0,   36,       0,  1,  4,  5,          31      ; #0
        .vertex   32,    0,   36,       0,  2,  5,  6,          31      ; #1
        .vertex   64,    0,  -28,       2,  3,  6,  6,          31      ; #2
        .vertex  -64,    0,  -28,       1,  3,  4,  4,          31      ; #3
        .vertex    0,   16,  -28,       0,  1,  2,  3,          31      ; #4
        .vertex    0,  -16,  -28,       3,  4,  5,  6,          31      ; #5
        .vertex  -12,    6,  -28,       3,  3,  3,  3,          15      ; #6
        .vertex   12,    6,  -28,       3,  3,  3,  3,          15      ; #7
        .vertex   12,   -6,  -28,       3,  3,  3,  3,          12      ; #8
        .vertex  -12,   -6,  -28,       3,  3,  3,  3,          12      ; #9

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        0,  5,           31                      ; #0
        .edge    1,  2,        2,  6,           31                      ; #1
        .edge    1,  4,        0,  2,           31                      ; #2
        .edge    0,  4,        0,  1,           31                      ; #3
        .edge    0,  3,        1,  4,           31                      ; #4
        .edge    3,  4,        1,  3,           31                      ; #5
        .edge    2,  4,        2,  3,           31                      ; #6
        .edge    3,  5,        3,  4,           31                      ; #7
        .edge    2,  5,        3,  6,           31                      ; #8
        .edge    1,  5,        5,  6,           31                      ; #9
        .edge    0,  5,        4,  5,           31                      ; #10
        .edge    6,  7,        3,  3,           15                      ; #11
        .edge    7,  8,        3,  3,           12                      ; #12
        .edge    6,  9,        3,  3,           12                      ; #13
        .edge    8,  9,        3,  3,           12                      ; #14

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,     32,      8,           31                      ; #0
        .face    -12,     47,      6,           31                      ; #1
        .face     12,     47,      6,           31                      ; #2
        .face      0,      0,   -112,           31                      ; #3
        .face    -12,    -47,      6,           31                      ; #4
        .face      0,    -32,      8,           31                      ; #5
        .face     12,    -47,      6,           31                      ; #6

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc