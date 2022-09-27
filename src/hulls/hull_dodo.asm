; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; space station (dodo)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_DODO               = hull_index                                    ;=$21

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_DODO_KILL          = 0     ;= 0.00

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
hull_pointer_dodo:
        ;-----------------------------------------------------------------------
        hull_pointer_dodo_lo := hull_pointer_dodo+0
        hull_pointer_dodo_hi := hull_pointer_dodo+1
        
        .addr   hull_dodo                                               ;$D040

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D062

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_DODO_KILL                                        ;$D083

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_DODO_KILL                                        ;$D0A4

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_dodo                                                       ;$EE2D
        ;-----------------------------------------------------------------------
        .proc   header

        scoop           = 0
        debris          = 0
        target_area     = 180
        max_edges       = 25
        laser_vertex    = 0
        explosion_count = 12
        bounty          = 0
        lod_distance    = 125
        max_energy      = 240
        max_speed       = 0
        normal_scaling  = 0
        laser_power     = 0
        missile_count   = 0

        .hull

;;        ; does not scoop as anything, does not drop any debris:
;;        .scoop_debris   0, 0                                            ;$EE2D
;;        
;;        .word   180 * 180       ; target range
;;        .byte   $a4             ; edges lo
;;        .byte   $2c             ; faces lo
;;        .byte   .max_edges( 25 )
;;        .byte   0               ; laser vertex
;;        .byte   .explosion_count( 12 )
;;        .byte   vertex_bytes    ; vertex bytes
;;        .byte   $22             ; edge count
;;        .word   0               ; bounty
;;        .byte   $30             ; number of faces
;;        .byte   125             ; lod
;;        .byte   240             ; energy
;;        .byte   0               ; speed
;;        .byte   $00             ; edges hi
;;        .byte   $01             ; faces hi
;;        .byte   0               ; normals
;;        .byte   .laser_missiles( 0, 0 )

        .endproc

        .proc   vertices
        ;-----------------------------------------------------------------------
        ;          X     Y     Z  face: 1   2   3   4          vis       num
;;        .vertex    0,  150,  196,       1,  0,  5,  5,          31      ; #0
;;        .vertex  143,   46,  196,       1,  0,  2,  2,          31      ; #1
;;        .vertex   88, -121,  196,       2,  0,  3,  3,          31      ; #2
;;        .vertex  -88, -121,  196,       3,  0,  4,  4,          31      ; #3
;;        .vertex -143,   46,  196,       4,  0,  5,  5,          31      ; #4
;;        .vertex    0,  243,   46,       5,  1,  6,  6,          31      ; #5
;;        .vertex  231,   75,   46,       2,  1,  7,  7,          31      ; #6
;;        .vertex  143, -196,   46,       3,  2,  8,  8,          31      ; #7
;;        .vertex -143, -196,   46,       4,  3,  9,  9,          31      ; #8
;;        .vertex -231,   75,   46,       5,  4, 10, 10,          31      ; #9
;;        .vertex  143,  196,  -46,       6,  1,  7,  7,          31      ; #10
;;        .vertex  231,  -75,  -46,       7,  2,  8,  8,          31      ; #11
;;        .vertex    0, -243,  -46,       8,  3,  9,  9,          31      ; #12
;;        .vertex -231,  -75,  -46,       9,  4, 10, 10,          31      ; #13
;;        .vertex -143,  196,  -46,       6,  5, 10, 10,          31      ; #14
;;        .vertex   88,  121, -196,       7,  6, 11, 11,          31      ; #15
;;        .vertex  143,  -46, -196,       8,  7, 11, 11,          31      ; #16
;;        .vertex    0, -150, -196,       9,  8, 11, 11,          31      ; #17
;;        .vertex -143,  -46, -196,      10,  9, 11, 11,          31      ; #18
;;        .vertex  -88,  121, -196,      10,  6, 11, 11,          31      ; #19
;;        .vertex  -16,   32,  196,       0,  0,  0,  0,          30      ; #20
;;        .vertex  -16,  -32,  196,       0,  0,  0,  0,          30      ; #21
;;        .vertex   16,   32,  196,       0,  0,  0,  0,          23      ; #22
;;        .vertex   16,  -32,  196,       0,  0,  0,  0,          23      ; #23

        .byte   $00, $96, $c4, $1f, $01, $55                            ; #0
        .byte   $8f, $2e, $c4, $1f, $01, $22                            ; #1
        .byte   $58, $79, $c4, $5f, $02, $33                            ; #2
        .byte   $58, $79, $c4, $df, $03, $44                            ; #3
        .byte   $8f, $2e, $c4, $9f, $04, $55                            ; #4
        .byte   $00, $f3, $2e, $1f, $15, $66                            ; #5
        .byte   $e7, $4b, $2e, $1f, $12, $77                            ; #6
        .byte   $8f, $c4, $2e, $5f, $23, $88                            ; #7
        .byte   $8f, $c4, $2e, $df, $34, $99                            ; #8
        .byte   $e7, $4b, $2e, $9f, $45, $aa                            ; #9
        .byte   $8f, $c4, $2e, $3f, $16, $77                            ; #10
        .byte   $e7, $4b, $2e, $7f, $27, $88                            ; #11
        .byte   $00, $f3, $2e, $7f, $38, $99                            ; #12
        .byte   $e7, $4b, $2e, $ff, $49, $aa                            ; #13
        .byte   $8f, $c4, $2e, $bf, $56, $aa                            ; #14
        .byte   $58, $79, $c4, $3f, $67, $bb                            ; #15
        .byte   $8f, $2e, $c4, $7f, $78, $bb                            ; #16
        .byte   $00, $96, $c4, $7f, $89, $bb                            ; #17
        .byte   $8f, $2e, $c4, $ff, $9a, $bb                            ; #18
        .byte   $58, $79, $c4, $bf, $6a, $bb                            ; #19
        .byte   $10, $20, $c4, $9e, $00, $00                            ; #20
        .byte   $10, $20, $c4, $de, $00, $00                            ; #21
        .byte   $10, $20, $c4, $17, $00, $00                            ; #22
        .byte   $10, $20, $c4, $57, $00, $00                            ; #23

        .endproc

        vertex_bytes = .sizeof( vertices )

        .proc   edges
        ;-----------------------------------------------------------------------
        ; vertex 1   2    face 1   2           vis                       num
;;        .edge    0,  1,        1,  0,           31                      ; #0
;;        .edge    1,  2,        2,  0,           31                      ; #1
;;        .edge    2,  3,        3,  0,           31                      ; #2
;;        .edge    3,  4,        4,  0,           31                      ; #3
;;        .edge    4,  0,        5,  0,           31                      ; #4
;;        .edge    5, 10,        6,  1,           31                      ; #5
;;        .edge   10,  6,        7,  1,           31                      ; #6
;;        .edge    6, 11,        7,  2,           31                      ; #7
;;        .edge   11,  7,        8,  2,           31                      ; #8
;;        .edge    7, 12,        8,  3,           31                      ; #9
;;        .edge   12,  8,        9,  3,           31                      ; #10
;;        .edge    8, 13,        9,  4,           31                      ; #11
;;        .edge   13,  9,       10,  4,           31                      ; #12
;;        .edge    9, 14,       10,  5,           31                      ; #13
;;        .edge   14,  5,        6,  5,           31                      ; #14
;;        .edge   15, 16,       11,  7,           31                      ; #15
;;        .edge   16, 17,       11,  8,           31                      ; #16
;;        .edge   17, 18,       11,  9,           31                      ; #17
;;        .edge   18, 19,       11, 10,           31                      ; #18
;;        .edge   19, 15,       11,  6,           31                      ; #19
;;        .edge    0,  5,        5,  1,           31                      ; #20
;;        .edge    1,  6,        2,  1,           31                      ; #21
;;        .edge    2,  7,        3,  2,           31                      ; #22
;;        .edge    3,  8,        4,  3,           31                      ; #23
;;        .edge    4,  9,        5,  4,           31                      ; #24
;;        .edge   10, 15,        7,  6,           31                      ; #25
;;        .edge   11, 16,        8,  7,           31                      ; #26
;;        .edge   12, 17,        9,  8,           31                      ; #27
;;        .edge   13, 18,       10,  9,           31                      ; #28
;;        .edge   14, 19,       10,  6,           31                      ; #29
;;        .edge   20, 21,        0,  0,           30                      ; #30
;;        .edge   21, 23,        0,  0,           20                      ; #31
;;        .edge   23, 22,        0,  0,           23                      ; #32
;;        .edge   22, 20,        0,  0,           20                      ; #33

        .byte   $1f, $01, $00, $04                                      ; #0
        .byte   $1f, $02, $04, $08                                      ; #1
        .byte   $1f, $03, $08, $0c                                      ; #2
        .byte   $1f, $04, $0c, $10                                      ; #3
        .byte   $1f, $05, $10, $00                                      ; #4
        .byte   $1f, $16, $14, $28                                      ; #5
        .byte   $1f, $17, $28, $18                                      ; #6
        .byte   $1f, $27, $18, $2c                                      ; #7
        .byte   $1f, $28, $2c, $1c                                      ; #8
        .byte   $1f, $38, $1c, $30                                      ; #9
        .byte   $1f, $39, $30, $20                                      ; #10
        .byte   $1f, $49, $20, $34                                      ; #11
        .byte   $1f, $4a, $34, $24                                      ; #12
        .byte   $1f, $5a, $24, $38                                      ; #13
        .byte   $1f, $56, $38, $14                                      ; #14
        .byte   $1f, $7b, $3c, $40                                      ; #15
        .byte   $1f, $8b, $40, $44                                      ; #16
        .byte   $1f, $9b, $44, $48                                      ; #17
        .byte   $1f, $ab, $48, $4c                                      ; #18
        .byte   $1f, $6b, $4c, $3c                                      ; #19
        .byte   $1f, $15, $00, $14                                      ; #20
        .byte   $1f, $12, $04, $18                                      ; #21
        .byte   $1f, $23, $08, $1c                                      ; #22
        .byte   $1f, $34, $0c, $20                                      ; #23
        .byte   $1f, $45, $10, $24                                      ; #24
        .byte   $1f, $67, $28, $3c                                      ; #25
        .byte   $1f, $78, $2c, $40                                      ; #26
        .byte   $1f, $89, $30, $44                                      ; #27
        .byte   $1f, $9a, $34, $48                                      ; #28
        .byte   $1f, $6a, $38, $4c                                      ; #29
        .byte   $1e, $00, $50, $54                                      ; #30
        .byte   $14, $00, $54, $5c                                      ; #31
        .byte   $17, $00, $5c, $58                                      ; #32
        .byte   $14, $00, $58, $50                                      ; #33

        .endproc

        edges_offset = edges - header
        edges_bytes  = .sizeof( edges )

        .proc   faces
        ;-----------------------------------------------------------------------
        ;    normalx normaly normalz           vis                       num
;;        .face      0,      0,    196,           31                      ; #0
;;        .face    103,    142,     88,           31                      ; #1
;;        .face    169,    -55,     89,           31                      ; #2
;;        .face      0,   -176,     88,           31                      ; #3
;;        .face   -169,    -55,     89,           31                      ; #4
;;        .face   -103,    142,     88,           31                      ; #5
;;        .face      0,    176,    -88,           31                      ; #6
;;        .face    169,     55,    -89,           31                      ; #7
;;        .face    103,   -142,    -88,           31                      ; #8
;;        .face   -103,   -142,    -88,           31                      ; #9
;;        .face   -169,     55,    -89,           31                      ; #10
;;        .face      0,      0,   -196,           31                      ; #11

        .byte   $1f, $00, $00, $c4                                      ; #0
        .byte   $1f, $67, $8e, $58                                      ; #1
        .byte   $5f, $a9, $37, $59                                      ; #2
        .byte   $5f, $00, $b0, $58                                      ; #3
        .byte   $df, $a9, $37, $59                                      ; #4
        .byte   $9f, $67, $8e, $58                                      ; #5
        .byte   $3f, $00, $b0, $58                                      ; #6
        .byte   $3f, $a9, $37, $59                                      ; #7
        .byte   $7f, $67, $8e, $58                                      ; #8
        .byte   $ff, $67, $8e, $58                                      ; #9
        .byte   $bf, $a9, $37, $59                                      ; #10
        .byte   $3f, $00, $00, $c4                                      ; #11        

        .endproc

        faces_offset = faces - header
        face_bytes   = .sizeof( faces )

.ifdef  BUILD_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; unused junk bytes! these don't appear in the BBC data-tables!
        .byte   $4c, $44, $41, $52, $1f, $3f, $58
.endif  ;///////////////////////////////////////////////////////////////////////

.endproc