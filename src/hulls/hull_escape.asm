; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; escape capsule
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_ESCAPE             = hull_index                                    ;=$03

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_ESCAPE_KILL        = 16    ;= 0.06

.segment        "HULL_TABLE"                                            ;$D000+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_escape                                             ;$D004/5

.segment        "HULL_TYPE"                                             ;$D042+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $01                                                     ;$D044

.segment        "HULL_KILL_LO"                                          ;$D063+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_ESCAPE_KILL                                      ;$D065

.segment        "HULL_KILL_HI"                                          ;$D084+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_ESCAPE_KILL                                      ;$D086

.segment        "CODE_267E"                                             ;$267E+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   %10101010                                               ;$2680

.segment        "HULL_DATA"                                             ;$D0A5+
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_escape                                                     ;$D2BF
        ;-----------------------------------------------------------------------
        .proc   header
 
        scoop           = Cargo::slaves
        debris          = 0
        target_area     = 16
        max_edges       = 7
        laser_vertex    = 0
        explosion_count = 4
        bounty          = 0
        lod_distance    = 8
        max_energy      = 17
        max_speed       = 8
        normal_scaling  = 4
        laser_power     = 0
        missile_count   = 0
 
        .hull
 
        .endproc
 
        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex   -7,    0,   36,       2,  1,  3,  3,          31      ; #0
        .vertex   -7,  -14,  -12,       2,  0,  3,  3,          31      ; #1
        .vertex   -7,   14,  -12,       1,  0,  3,  3,          31      ; #2
        .vertex   21,    0,    0,       1,  0,  2,  2,          31      ; #3
        
        .endproc
 
        vertex_bytes = .sizeof( vertices )
 
        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
        .edge    0,  1,        3,  2,           31                      ; #0
        .edge    1,  2,        3,  0,           31                      ; #1
        .edge    2,  3,        1,  0,           31                      ; #2
        .edge    3,  0,        2,  1,           31                      ; #3
        .edge    0,  2,        3,  1,           31                      ; #4
        .edge    3,  1,        2,  0,           31                      ; #5
        
        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )
 
        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face     52,      0,   -122,           31                      ; #0
        .face     39,    103,     30,           31                      ; #1
        .face     39,   -103,     30,           31                      ; #2
        .face   -112,      0,      0,           31                      ; #3
        
        .endproc
 
        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.endproc