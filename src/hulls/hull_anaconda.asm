; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; anaconda
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ANACONDA           = hull_index                                    ;=$0E

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ANACONDA_KILL      = 256   ;= 1.00

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_anaconda                                           ;$D01A/B

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $a1                                                     ;$D04F

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ANACONDA_KILL                                    ;$D070

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ANACONDA_KILL                                    ;$D091

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_anaconda                                                   ;$DC33
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 7
        target_area     = 100
        max_edges       = 23
        laser_vertex    = 12
        explosion_count = 10
        bounty          = 0
        lod_distance    = 36    ; 50 in BBC disk version -- Anaconda is THICC
        max_energy      = 252
        max_speed       = 14
        normal_scaling  = 1
        laser_power     = 7
        missile_count   = 7
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    7,  -58,       1,  0,  5,  5,          30      ; #0
        .vertex  -43,  -13,  -37,       1,  0,  2,  2,          30      ; #1
        .vertex  -26,  -47,   -3,       2,  0,  3,  3,          30      ; #2
        .vertex   26,  -47,   -3,       3,  0,  4,  4,          30      ; #3
        .vertex   43,  -13,  -37,       4,  0,  5,  5,          30      ; #4
        .vertex    0,   48,  -49,       5,  1,  6,  6,          30      ; #5
        .vertex  -69,   15,  -15,       2,  1,  7,  7,          30      ; #6
        .vertex  -43,  -39,   40,       3,  2,  8,  8,          31      ; #7
        .vertex   43,  -39,   40,       4,  3,  9,  9,          31      ; #8
        .vertex   69,   15,  -15,       5,  4, 10, 10,          30      ; #9
        .vertex  -43,   53,  -23,      15, 15, 15, 15,          31      ; #10
        .vertex  -69,   -1,   32,       7,  2,  8,  8,          31      ; #11
        .vertex    0,    0,  254,      15, 15, 15, 15,          31      ; #12
        .vertex   69,   -1,   32,       9,  4, 10, 10,          31      ; #13
        .vertex   43,   53,  -23,      15, 15, 15, 15,          31      ; #14

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        1,  0,           30                      ; #0
        .edge    1,  2,        2,  0,           30                      ; #1
        .edge    2,  3,        3,  0,           30                      ; #2
        .edge    3,  4,        4,  0,           30                      ; #3
        .edge    0,  4,        5,  0,           30                      ; #4
        .edge    0,  5,        5,  1,           29                      ; #5
        .edge    1,  6,        2,  1,           29                      ; #6
        .edge    2,  7,        3,  2,           29                      ; #7
        .edge    3,  8,        4,  3,           29                      ; #8
        .edge    4,  9,        5,  4,           29                      ; #9
        .edge    5, 10,        6,  1,           30                      ; #10
        .edge    6, 10,        7,  1,           30                      ; #11
        .edge    6, 11,        7,  2,           30                      ; #12
        .edge    7, 11,        8,  2,           30                      ; #13
        .edge    7, 12,        8,  3,           31                      ; #14
        .edge    8, 12,        9,  3,           31                      ; #15
        .edge    8, 13,        9,  4,           30                      ; #16
        .edge    9, 13,       10,  4,           30                      ; #17
        .edge    9, 14,       10,  5,           30                      ; #18
        .edge    5, 14,        6,  5,           30                      ; #19
        .edge   10, 14,       11,  6,           30                      ; #20
        .edge   10, 12,       11,  7,           31                      ; #21
        .edge   11, 12,        8,  7,           31                      ; #22
        .edge   12, 13,       10,  9,           31                      ; #23
        .edge   12, 14,       11, 10,           31                      ; #24

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,    -51,    -49,           30                      ; #0
        .face    -51,     18,    -87,           30                      ; #1
        .face    -77,    -57,    -19,           30                      ; #2
        .face      0,    -90,     16,           31                      ; #3
        .face     77,    -57,    -19,           30                      ; #4
        .face     51,     18,    -87,           30                      ; #5
        .face      0,    111,    -20,           30                      ; #6
        .face    -97,     72,     24,           31                      ; #7
        .face   -108,    -68,     34,           31                      ; #8
        .face    108,    -68,     34,           31                      ; #9
        .face     97,     72,     24,           31                      ; #10
        .face      0,     94,     18,           31                      ; #11

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc