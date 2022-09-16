; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; missile
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_MISSILE            = hull_index                                    ;=$01

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_MISSILE_KILL       = 149   ;= 0.58

.segment        "HULL_TABLE"                                            ;$D000..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .addr   hull_missile                                            ;$D000/1

.segment        "HULL_TYPE"                                             ;$D042..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   $00                                                     ;$D042

.segment        "HULL_KILL_LO"                                          ;$D063..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   < HULL_MISSILE_KILL                                     ;$D063

.segment        "HULL_KILL_HI"                                          ;$D084..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        .byte   > HULL_MISSILE_KILL                                     ;$D084

.segment        "HULL_DATA"                                             ;$D0A5..
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.proc   hull_missile                                                    ;$D0A5
        ;-----------------------------------------------------------------------
        .proc   header

        ; does not scoop as anything, does not drop any debris:
        .scoop_debris   0, 0

        .word   40 * 40         ; target area
        .byte   < edges_offset  ; "edges data offset lo"
        .byte   < faces_offset  ; "faces data offset lo"
        .byte   $55             ; "4*maxlines+1 for ship lines stack"?
        .byte   $00             ; "gun vertex*4"?
        .byte   $0a             ; "explosion count"?
        .byte   vertex_bytes    ; vertices byte count
        .byte   edge_count      ; edge count
        .word   0               ; bounty
        .byte   face_count      ; face count
        .byte   $0e             ; LOD distance
        .byte   $02             ; energy
        .byte   $2c             ; speed
        .byte   > edges_offset  ; "edges data offset hi"
        .byte   > faces_offset  ; "faces data offset hi"
        .byte   $02             ; scaling of normals
        .byte   $00             ; laser / missile count?
        
        .endproc

        .proc   verticies
        ;-----------------------------------------------------------------------
        .byte   $00, $00, $44, $1f, $10, $32            ; vertex 1
        .byte   $08, $08, $24, $5f, $21, $54            ; vertex 2
        .byte   $08, $08, $24, $1f, $32, $74            ; vertex 3
        .byte   $08, $08, $24, $9f, $30, $76            ; vertex 4
        .byte   $08, $08, $24, $df, $10, $65            ; vertex 5
        .byte   $08, $08, $2c, $3f, $74, $88            ; vertex 6
        .byte   $08, $08, $2c, $7f, $54, $88            ; vertex 7
        .byte   $08, $08, $2c, $ff, $65, $88            ; vertex 8
        .byte   $08, $08, $2c, $bf, $76, $88            ; vertex 9
        .byte   $0c, $0c, $2c, $28, $74, $88            ; vertex 10
        .byte   $0c, $0c, $2c, $68, $54, $88            ; vertex 11
        .byte   $0c, $0c, $2c, $e8, $65, $88            ; vertex 12
        .byte   $0c, $0c, $2c, $a8, $76, $88            ; vertex 13
        .byte   $08, $08, $0c, $a8, $76, $77            ; vertex 14
        .byte   $08, $08, $0c, $e8, $65, $66            ; vertex 15
        .byte   $08, $08, $0c, $28, $74, $77            ; vertex 16
        .byte   $08, $08, $0c, $68, $54, $55            ; vertex 17

        .endproc
        
        vertex_bytes = .sizeof( verticies )

        .proc   edges
        ;-----------------------------------------------------------------------
        .byte   $1f, $21, $00, $04                      ; edge 1
        .byte   $1f, $32, $00, $08                      ; edge 2
        .byte   $1f, $30, $00, $0c                      ; edge 3
        .byte   $1f, $10, $00, $10                      ; edge 4
        .byte   $1f, $24, $04, $08                      ; edge 5
        .byte   $1f, $51, $04, $10                      ; edge 6
        .byte   $1f, $60, $0c, $10                      ; edge 7
        .byte   $1f, $73, $08, $0c                      ; edge 8
        .byte   $1f, $74, $08, $14                      ; edge 9
        .byte   $1f, $54, $04, $18                      ; edge 10
        .byte   $1f, $65, $10, $1c                      ; edge 11
        .byte   $1f, $76, $0c, $20                      ; edge 12
        .byte   $1f, $86, $1c, $20                      ; edge 13
        .byte   $1f, $87, $14, $20                      ; edge 14
        .byte   $1f, $84, $14, $18                      ; edge 15
        .byte   $1f, $85, $18, $1c                      ; edge 16
        .byte   $08, $85, $18, $28                      ; edge 17
        .byte   $08, $87, $14, $24                      ; edge 18
        .byte   $08, $87, $20, $30                      ; edge 19
        .byte   $08, $85, $1c, $2c                      ; edge 20
        .byte   $08, $74, $24, $3c                      ; edge 21
        .byte   $08, $54, $28, $40                      ; edge 22
        .byte   $08, $76, $30, $34                      ; edge 23
        .byte   $08, $65, $2c, $38                      ; edge 24

        .endproc
        
        edges_offset = edges - header
        edge_count   = .sizeof( edges ) / 4

        .proc   faces
        ;-----------------------------------------------------------------------
        .byte   $9f, $40, $00, $10
        .byte   $5f, $00, $40, $10
        .byte   $1f, $40, $00, $10
        .byte   $1f, $00, $40, $10
        .byte   $1f, $20, $00, $00
        .byte   $5f, $00, $20, $00
        .byte   $9f, $20, $00, $00
        .byte   $1f, $00, $20, $00
        .byte   $3f, $00, $00, $b0

        .endproc

        faces_offset = faces - header
        face_count   = .sizeof( faces )

.endproc