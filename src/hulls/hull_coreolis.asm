; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; space station (coreolis)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COREOLIS           = hull_index                                    ;=$02

; the game changes the pointer to the space station based on the
; local system, so this serves as a generic index for that
HULL_STATION            = hull_index                    ; BBC: SST

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COREOLIS_KILL      = 0     ;= 0.00

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hull_pointer_station:                                                   ;$D002
        ;-----------------------------------------------------------------------
        hull_pointer_station_lo := hull_pointer_station+0
        hull_pointer_station_hi := hull_pointer_station+1

        ; the second entry in the table gets rewritten under two conditions:
        ; 1. on the title screen, for the ship displayed there, and
        ; 2. the current type of space-station (coreolis / dodo)
        ;
        .addr   hull_coreolis                                           ;$D002/3

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D043

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_COREOLIS_KILL                                    ;$D064

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_COREOLIS_KILL                                    ;$D085

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %11111111                                               ;$267F

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_coreolis                                                   ;$D1A3
        ;-----------------------------------------------------------------------
        ; space station (coreolis)
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 160
        max_edges       = 22
        laser_vertex    = 0
        explosion_count = 12
        bounty          = 0
        lod_distance    = 120
        max_energy      = 240
        max_speed       = 0
        normal_scaling  = 0
        laser_power     = 0
        missile_count   = 6

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  160,    0,  160,       0,  1,  2,  6,          31      ; #0
        .vertex    0,  160,  160,       0,  2,  3,  8,          31      ; #1
        .vertex -160,    0,  160,       0,  3,  4,  7,          31      ; #2
        .vertex    0, -160,  160,       0,  1,  4,  5,          31      ; #3
        .vertex  160, -160,    0,       1,  5,  6, 10,          31      ; #4
        .vertex  160,  160,    0,       2,  6,  8, 11,          31      ; #5
        .vertex -160,  160,    0,       3,  7,  8, 12,          31      ; #6
        .vertex -160, -160,    0,       4,  5,  7,  9,          31      ; #7
        .vertex  160,    0, -160,       6, 10, 11, 13,          31      ; #8
        .vertex    0,  160, -160,       8, 11, 12, 13,          31      ; #9
        .vertex -160,    0, -160,       7,  9, 12, 13,          31      ; #10
        .vertex    0, -160, -160,       5,  9, 10, 13,          31      ; #11
        .vertex   10,  -30,  160,       0,  0,  0,  0,          30      ; #12
        .vertex   10,   30,  160,       0,  0,  0,  0,          30      ; #13
        .vertex  -10,   30,  160,       0,  0,  0,  0,          30      ; #14
        .vertex  -10,  -30,  160,       0,  0,  0,  0,          30      ; #15
        
        .endproc

        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  3,        0,  1,           31                      ; #0
        .edge    0,  1,        0,  2,           31                      ; #1
        .edge    1,  2,        0,  3,           31                      ; #2
        .edge    2,  3,        0,  4,           31                      ; #3
        .edge    3,  4,        1,  5,           31                      ; #4
        .edge    0,  4,        1,  6,           31                      ; #5
        .edge    0,  5,        2,  6,           31                      ; #6
        .edge    5,  1,        2,  8,           31                      ; #7
        .edge    1,  6,        3,  8,           31                      ; #8
        .edge    2,  6,        3,  7,           31                      ; #9
        .edge    2,  7,        4,  7,           31                      ; #10
        .edge    3,  7,        4,  5,           31                      ; #11
        .edge    8, 11,       10, 13,           31                      ; #12
        .edge    8,  9,       11, 13,           31                      ; #13
        .edge    9, 10,       12, 13,           31                      ; #14
        .edge   10, 11,        9, 13,           31                      ; #15
        .edge    4, 11,        5, 10,           31                      ; #16
        .edge    4,  8,        6, 10,           31                      ; #17
        .edge    5,  8,        6, 11,           31                      ; #18
        .edge    5,  9,        8, 11,           31                      ; #19
        .edge    6,  9,        8, 12,           31                      ; #20
        .edge    6, 10,        7, 12,           31                      ; #21
        .edge    7, 10,        7,  9,           31                      ; #22
        .edge    7, 11,        5,  9,           31                      ; #23
        .edge   12, 13,        0,  0,           30                      ; #24
        .edge   13, 14,        0,  0,           30                      ; #25
        .edge   14, 15,        0,  0,           30                      ; #26
        .edge   15, 12,        0,  0,           30                      ; #27
        
        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,      0,    160,           31                      ; #0
        .face    107,   -107,    107,           31                      ; #1
        .face    107,    107,    107,           31                      ; #2
        .face   -107,    107,    107,           31                      ; #3
        .face   -107,   -107,    107,           31                      ; #4
        .face      0,   -160,      0,           31                      ; #5
        .face    160,      0,      0,           31                      ; #6
        .face   -160,      0,      0,           31                      ; #7
        .face      0,    160,      0,           31                      ; #8
        .face   -107,   -107,   -107,           31                      ; #9
        .face    107,   -107,   -107,           31                      ; #10
        .face    107,    107,   -107,           31                      ; #11
        .face   -107,    107,   -107,           31                      ; #12
        .face      0,      0,   -160,           31                      ; #13
        
        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc