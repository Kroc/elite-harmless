; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; plate / alloys
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_PLATE              = hull_index                                    ;=$04

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_PLATE_KILL         = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_plate                                              ;$D006/7

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D045

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_PLATE_KILL                                       ;$D066

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_PLATE_KILL                                       ;$D087

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_plate                                                      ;$D313
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = Cargo::alloys
        debris          = 0
        target_area     = 10
        max_edges       = 5
        laser_vertex    = 0
        explosion_count = 1
        bounty          = 0
        lod_distance    = 5
        max_energy      = 16
        max_speed       = 16
        normal_scaling  = 3
        laser_power     = 0
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -15,  -22,   -9,      15, 15, 15, 15,          31      ; #0
        .vertex  -15,   38,   -9,      15, 15, 15, 15,          31      ; #1
        .vertex   19,   32,   11,      15, 15, 15, 15,          20      ; #2
        .vertex   10,  -46,    6,      15, 15, 15, 15,          20      ; #3

        .endproc

        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,       15, 15,           31                      ; #0
        .edge    1,  2,       15, 15,           16                      ; #1
        .edge    2,  3,       15, 15,           20                      ; #2
        .edge    3,  0,       15, 15,           16                      ; #3

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face      0,      0,      0,            0                      ; #0

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc