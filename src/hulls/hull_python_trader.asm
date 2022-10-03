; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; python (trader)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_PYTHON_TRADER      = hull_index                                    ;=$0C

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_PYTHON_TRADER_KILL = 170   ;= 0.66

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_python_trader                                      ;$D016/7

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a0                                                     ;$D04D

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_PYTHON_TRADER_KILL                               ;$D06E

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_PYTHON_TRADER_KILL                               ;$D08F

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2689

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_python_trader                                              ;$DA4B
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 5     ; was 3 in BBC casette version
        target_area     = 80    ; was 120 in BBC casette version
        max_edges       = 22
        laser_vertex    = 0
        explosion_count = 9
        bounty          = 0
        lod_distance    = 40
        max_energy      = 250
        max_speed       = 20
        normal_scaling  = 0
        laser_power     = 3
        missile_count   = 3
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,  224,       0,  1,  2,  3,          31      ; #0
        .vertex    0,   48,   48,       0,  1,  4,  5,          31      ; #1!
        .vertex   96,    0,  -16,      15, 15, 15, 15,          31      ; #2
        .vertex  -96,    0,  -16,      15, 15, 15, 15,          31      ; #3
        .vertex    0,   48,  -32,       4,  5,  8,  9,          31      ; #4!
        .vertex    0,   24, -112,       9,  8, 12, 12,          31      ; #5
        .vertex  -48,    0, -112,       8, 11, 12, 12,          31      ; #6
        .vertex   48,    0, -112,       9, 10, 12, 12,          31      ; #7
        .vertex    0,  -48,   48,       2,  3,  6,  7,          31      ; #8!
        .vertex    0,  -48,  -32,       6,  7, 10, 11,          31      ; #9!
        .vertex    0,  -24, -112,      10, 11, 12, 12,          31      ; #10!

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  8,        2,  3,           31                      ; #0!
        .edge    0,  3,        0,  2,           31                      ; #1
        .edge    0,  2,        1,  3,           31                      ; #2
        .edge    0,  1,        0,  1,           31                      ; #3!
        .edge    2,  4,        9,  5,           31                      ; #4!
        .edge    1,  2,        1,  5,           31                      ; #5!
        .edge    2,  8,        7,  3,           31                      ; #6!
        .edge    1,  3,        0,  4,           31                      ; #7!
        .edge    3,  8,        2,  6,           31                      ; #8!
        .edge    2,  9,        7, 10,           31                      ; #9!
        .edge    3,  4,        4,  8,           31                      ; #10!
        .edge    3,  9,        6, 11,           31                      ; #11!
        .edge    3,  5,        8,  8,            7                      ; #12!
        .edge    3, 10,       11, 11,            7                      ; #13!
        .edge    2,  5,        9,  9,            7                      ; #14!
        .edge    2, 10,       10, 10,            7                      ; #15!
        .edge    2,  7,        9, 10,           31                      ; #16
        .edge    3,  6,        8, 11,           31                      ; #17
        .edge    5,  6,        8, 12,           31                      ; #18
        .edge    5,  7,        9, 12,           31                      ; #19
        .edge    7, 10,       12, 10,           31                      ; #20!
        .edge    6, 10,       11, 12,           31                      ; #21!
        .edge    4,  5,        8,  9,           31                      ; #22!
        .edge    9, 10,       10, 11,           31                      ; #23!
        .edge    1,  4,        4,  5,           31                      ; #24!
        .edge    8,  9,        6,  7,           31                      ; #25!

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face    -27,     40,     11,           31                      ; #0!
        .face     27,     40,     11,           31                      ; #1!
        .face    -27,    -40,     11,           31                      ; #2!
        .face     27,    -40,     11,           31                      ; #3!
        .face    -19,     38,      0,           31                      ; #4!
        .face     19,     38,      0,           31                      ; #5!
        .face    -19,    -38,      0,           31                      ; #6!
        .face     19,    -38,      0,           31                      ; #7!
        .face    -25,     37,    -11,           31                      ; #8!
        .face     25,     37,    -11,           31                      ; #9!
        .face     25,    -37,    -11,           31                      ; #10!
        .face    -25,    -37,    -11,           31                      ; #11!
        .face      0,      0,   -112,           31                      ; #12!

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc