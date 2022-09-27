; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; splinter / rock
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_SPLINTER           = hull_index                                    ;=$08

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_SPLINTER_KILL      = 10    ;= 0.039

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_splinter                                           ;$D00E/F

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D049

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_SPLINTER_KILL                                    ;$D06A

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_SPLINTER_KILL                                    ;$D08B

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_splinter                                                   ;$D573
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = Cargo::minerals
        debris          = 0
        target_area     = 16
        max_edges       = 7
        laser_vertex    = 0
        explosion_count = 4
        bounty          = 0
        lod_distance    = 8
        max_energy      = 20
        max_speed       = 10
        normal_scaling  = 5
        laser_power     = 0
        missile_count   = 0

        .hull

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
        .vertex  -24,  -25,   16,       2,  1,  3,  3,          31      ; #0
        .vertex    0,   12,  -10,       2,  0,  3,  3,          31      ; #1
        .vertex   11,   -6,    2,       1,  0,  3,  3,          31      ; #2
        .vertex   12,   42,    7,       1,  0,  2,  2,          31      ; #3

        .endproc

        vertex_bytes = .sizeof( vertices )

        ; the splinter reuses the edges from the escape pod!
        ;
        edges_offset = ::hull_escape::edges - header
        edges_bytes  = .sizeof( ::hull_escape::edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
        .face     35,      0,      4,           31                      ; #0
        .face      3,      4,      8,           31                      ; #1
        .face      1,      8,     12,           31                      ; #2
        .face     18,     12,      0,           31                      ; #3

        .endproc

        ; BUG! in the original code the face-offset is wrong and points into
        ; the shuttle hull's header! thanks goes to Andy McFadden for pointing
        ; this out in his disasembly: <https://6502disassembly.com/a2-elite/>
        ;
.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        faces_offset = $0044
.else   ;///////////////////////////////////////////////////////////////////////
        faces_offset = faces - header
.endif  ;///////////////////////////////////////////////////////////////////////
        face_bytes   = .sizeof( faces )

.endproc