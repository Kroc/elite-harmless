; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; krait
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_KRAIT              = hull_index                                    ;=$13

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_KRAIT_KILL         = 85    ;= 0.33

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
        .addr   hull_krait                                              ;$D024/5

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $8c                                                     ;$D054

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_KRAIT_KILL                                       ;$D075

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_KRAIT_KILL                                       ;$D096

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_krait                                                      ;$E0BB
        ;-----------------------------------------------------------------------
        .proc   header

        ; "The ship hangar in the disc version displays the Krait with normals
        ; scaled with a factor of 4, which are more accurate than in the ship
        ; hangars of the other enhanced versions, which store them with a scale
        ; factor of 2." -- TODO: should we switch to the better scaled version?
        ; <https://www.bbcelite.com/compare/main/variable/ship_krait.html>
        ;
        scoop           = 0
        debris          = 1
        target_area     = 60
        max_edges       = 22
        laser_vertex    = 0
        explosion_count = 3
        bounty          = 100
        lod_distance    = 20    ; 25 in BBC Disk flight-mode
        max_energy      = 80
        max_speed       = 30
        normal_scaling  = 1     ; 2 in BBC Disk docked
        laser_power     = 2
        missile_count   = 0
 
        .hull
 
        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex    0,    0,   96,       1,  0,  3,  2,          31      ; #0
        .vertex    0,   18,  -48,       3,  0,  5,  4,          31      ; #1
        .vertex    0,  -18,  -48,       2,  1,  5,  4,          31      ; #2
        .vertex   90,    0,   -3,       1,  0,  4,  4,          31      ; #3
        .vertex  -90,    0,   -3,       3,  2,  5,  5,          31      ; #4
        .vertex   90,    0,   87,       1,  0,  1,  1,          30      ; #5!
        .vertex  -90,    0,   87,       3,  2,  3,  3,          30      ; #6!
        .vertex    0,    5,   53,       0,  0,  3,  3,           9      ; #7
        .vertex    0,    7,   38,       0,  0,  3,  3,           6      ; #8
        .vertex  -18,    7,   19,       3,  3,  3,  3,           9      ; #9
        .vertex   18,    7,   19,       0,  0,  0,  0,           9      ; #10
        .vertex   18,   11,  -39,       4,  4,  4,  4,           8      ; #11
        .vertex   18,  -11,  -39,       4,  4,  4,  4,           8      ; #12
        .vertex   36,    0,  -30,       4,  4,  4,  4,           8      ; #13
        .vertex  -18,   11,  -39,       5,  5,  5,  5,           8      ; #14
        .vertex  -18,  -11,  -39,       5,  5,  5,  5,           8      ; #15
        .vertex  -36,    0,  -30,       5,  5,  5,  5,           8      ; #16

        .endproc

        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        3,  0,           31                      ; #0
        .edge    0,  2,        2,  1,           31                      ; #1
        .edge    0,  3,        1,  0,           31                      ; #2
        .edge    0,  4,        3,  2,           31                      ; #3
        .edge    1,  4,        5,  3,           31                      ; #4
        .edge    4,  2,        5,  2,           31                      ; #5
        .edge    2,  3,        4,  1,           31                      ; #6
        .edge    3,  1,        4,  0,           31                      ; #7
        .edge    3,  5,        1,  0,           30                      ; #8
        .edge    4,  6,        3,  2,           30                      ; #9!
        .edge    1,  2,        5,  4,            8                      ; #10!
        .edge    7, 10,        0,  0,            9                      ; #11
        .edge    8, 10,        0,  0,            6                      ; #12
        .edge    7,  9,        3,  3,            9                      ; #13
        .edge    8,  9,        3,  3,            6                      ; #14
        .edge   11, 13,        4,  4,            8                      ; #15
        .edge   13, 12,        4,  4,            8                      ; #16
        .edge   12, 11,        4,  4,            7                      ; #17
        .edge   14, 15,        5,  5,            7                      ; #18
        .edge   15, 16,        5,  5,            8                      ; #19
        .edge   16, 14,        5,  5,            8                      ; #20

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      3,     24,      3,           31                      ; #0!
        .face      3,    -24,      3,           31                      ; #1!
        .face     -3,    -24,      3,           31                      ; #2!
        .face     -3,     24,      3,           31                      ; #3!
        .face     38,      0,    -77,           31                      ; #4!
        .face    -38,      0,    -77,           31                      ; #5!

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc