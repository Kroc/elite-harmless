; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
; space station (coreolis)
;-------------------------------------------------------------------------------
hull_index              .set hull_index + 1
HULL_COREOLIS           := hull_index                                   ;=$02

; in the BBC version every kill was worth one point but in other ports the
; kill value is fractional and varies by object, where $0100 (256) = 1 point
HULL_COREOLIS_KILL      = 0     ;= 0.00

.segment        "HULL_TABLE"                                            ;$D000..
;===============================================================================
hull_pointer_station:                                                   ;$D002
        ;-----------------------------------------------------------------------
        hull_pointer_station_lo := hull_pointer_station+0
        hull_pointer_station_hi := hull_pointer_station+1

        ; the second entry in the table gets rewritten under two conditions:
        ; 1. on the title screen, for the ship displayed there, and
        ; 2. the current type of space-station (coreolis / dodo)
        ;
        .addr   hull_coreolis                                           ;$D002/3

.segment        "HULL_TYPE"                                             ;$D042..
;===============================================================================
        .byte   $00                                                     ;$D043

.segment        "HULL_KILL_LO"                                          ;$D063..
;===============================================================================
        .byte   < HULL_COREOLIS_KILL                                    ;$D064

.segment        "HULL_KILL_HI"                                          ;$D084..
;===============================================================================
        .byte   > HULL_COREOLIS_KILL                                    ;$D085

.segment        "HULL_DATA"                                             ;$D0A5..
;===============================================================================
.proc   hull_coreolis                                                   ;$D1A3
        ;-----------------------------------------------------------------------
        ; space station (coreolis)

        .proc   header

        .byte   $00             ; "scoop / debris"
        .word   $6400           ; "missile lock area"?
        .byte   < edges_offset  ; "edges data offset lo"
        .byte   < faces_offset  ; "faces data offset lo"
        .byte   $59             ; "4*maxlines+1 for ship lines stack"?
        .byte   $00             ; "gun vertex*4"?
        .byte   $36             ; "explosion count"?
        .byte   vertex_bytes    ; verticies byte count
        .byte   edge_count      ; edge count
        .word   0               ; bounty
        .byte   face_count      ; face count
        .byte   $78             ; LOD distance
        .byte   $f0             ; energy
        .byte   $00             ; speed
        .byte   > edges_offset  ; "edges data offset hi"
        .byte   > faces_offset  ; "faces data offset hi"
        .byte   $00             ; scaling of normals
        .byte   $06             ; laser / missile count?
        
        .endproc

        .proc   verticies
        ;-----------------------------------------------------------------------
        .byte   $a0, $00, $a0, $1f, $10, $62                    ; vertex 1
        .byte   $00, $a0, $a0, $1f, $20, $83                    ; vertex 2
        .byte   $a0, $00, $a0, $9f, $30, $74                    ; vertex 3
        .byte   $00, $a0, $a0, $5f, $10, $54                    ; vertex 4
        .byte   $a0, $a0, $00, $5f, $51, $a6                    ; vertex 5
        .byte   $a0, $a0, $00, $1f, $62, $b8                    ; vertex 6
        .byte   $a0, $a0, $00, $9f, $73, $c8                    ; vertex 7
        .byte   $a0, $a0, $00, $df, $54, $97                    ; vertex 8
        .byte   $a0, $00, $a0, $3f, $a6, $db                    ; vertex 9
        .byte   $00, $a0, $a0, $3f, $b8, $dc                    ; vertex 10
        .byte   $a0, $00, $a0, $bf, $97, $dc                    ; vertex 11
        .byte   $00, $a0, $a0, $7f, $95, $da                    ; vertex 12
        .byte   $0a, $1e, $a0, $5e, $00, $00                    ; vertex 13
        .byte   $0a, $1e, $a0, $1e, $00, $00                    ; vertex 14
        .byte   $0a, $1e, $a0, $9e, $00, $00                    ; vertex 15
        .byte   $0a, $1e, $a0, $de, $00, $00                    ; vertex 16
        
        .endproc

        vertex_bytes = .sizeof( verticies )

        .proc   edges
        ;-----------------------------------------------------------------------
        .byte   $1f, $10, $00, $0c                              ; edge 1
        .byte   $1f, $20, $00, $04                              ; edge 2
        .byte   $1f, $30, $04, $08                              ; edge 3
        .byte   $1f, $40, $08, $0c                              ; edge 4
        .byte   $1f, $51, $0c, $10                              ; edge 5
        .byte   $1f, $61, $00, $10                              ; edge 6
        .byte   $1f, $62, $00, $14                              ; edge 7
        .byte   $1f, $82, $14, $04                              ; edge 8
        .byte   $1f, $83, $04, $18                              ; edge 9
        .byte   $1f, $73, $08, $18                              ; edge 10
        .byte   $1f, $74, $08, $1c                              ; edge 11
        .byte   $1f, $54, $0c, $1c                              ; edge 12
        .byte   $1f, $da, $20, $2c                              ; edge 13
        .byte   $1f, $db, $20, $24                              ; edge 14
        .byte   $1f, $dc, $24, $28                              ; edge 15
        .byte   $1f, $d9, $28, $2c                              ; edge 16
        .byte   $1f, $a5, $10, $2c                              ; edge 17
        .byte   $1f, $a6, $10, $20                              ; edge 18
        .byte   $1f, $b6, $14, $20                              ; edge 19
        .byte   $1f, $b8, $14, $24                              ; edge 20
        .byte   $1f, $c8, $18, $24                              ; edge 21
        .byte   $1f, $c7, $18, $28                              ; edge 22
        .byte   $1f, $97, $1c, $28                              ; edge 23
        .byte   $1f, $95, $1c, $2c                              ; edge 24
        .byte   $1e, $00, $30, $34                              ; edge 25
        .byte   $1e, $00, $34, $38                              ; edge 26
        .byte   $1e, $00, $38, $3c                              ; edge 27
        .byte   $1e, $00, $3c, $30                              ; edge 28
        
        .endproc

        edges_offset = edges - header
        edge_count   = .sizeof( edges ) / 4

        .proc   faces
        ;-----------------------------------------------------------------------
        .byte   $1f, $00, $00, $a0, $5f, $6b, $6b, $6b
        .byte   $1f, $6b, $6b, $6b, $9f, $6b, $6b, $6b
        .byte   $df, $6b, $6b, $6b, $5f, $00, $a0, $00
        .byte   $1f, $a0, $00, $00, $9f, $a0, $00, $00
        .byte   $1f, $00, $a0, $00, $ff, $6b, $6b, $6b
        .byte   $7f, $6b, $6b, $6b, $3f, $6b, $6b, $6b
        .byte   $bf, $6b, $6b, $6b, $3f, $00, $00, $a0
        
        .endproc

        faces_offset = faces - header
        face_count   = .sizeof( faces )

.endproc