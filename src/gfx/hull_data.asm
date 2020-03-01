; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "hull_data.asm" -- this file defines the 3D vector models of the various
; ships / objects in the game

; this file was produced with the help of nc513 on the lemon64 forums

.segment        "HULL_TABLE"

hull_pointers:                                                          ;$D000
;===============================================================================
; enumerate hulls as we define them; each needs an index number that will
; be used in the code to refer to them, in the order they appear here.
;
; note that the order of the indicies here do not have to match the order
; of the actual data that follows
;
hull_index      .set    0
        
        ; $01: missile                                                  ;$D000/1
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_missile_index     := hull_index
        
        .addr   hull_missile

        ; $02: space station (coreolis)                                 ;$D002/3
        ;-----------------------------------------------------------------------
        ; the second entry in the table gets rewritten under two conditions:
        ; 1. on the title screen, for the ship displayed there, and
        ; 2. the current type of space-station (coreolis / dodo)
        ;
hull_pointer_current:
        hull_pointer_current_lo := hull_pointer_current+0
        hull_pointer_current_hi := hull_pointer_current+1

        hull_index           .set hull_index + 1
        hull_coreolis_index    := hull_index

        .addr   hull_coreolis

        ; $03: escape capsule                                           ;$D004/5
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_escape_index      := hull_index

        .addr   hull_escape

        ; $04: plate / alloys                                           ;$D006/7
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_plate_index       := hull_index

        .addr   hull_plate

        ; $05: cargo cannister                                          ;$D008/9
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_cargo_index       := hull_index

        .addr   hull_cargo

        ; $06: boulder?                                                 ;$D00A/B
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_d3fb_index        := hull_index

        .addr   _d3fb

        ; $07: asteroid?                                                ;$D00C/D
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_d49d_index        := hull_index

        .addr   _d49d

        ; $08: splinter / rock                                          ;$D00E/F
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_splinter_index    := hull_index

        .addr   hull_splinter

        ; $09: shuttle                                                  ;$D010/1
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_shuttle_index     := hull_index
        
        .addr   hull_shuttle

        ; $0A: transporter                                              ;$D012/3
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_transporter_index := hull_index

        .addr   hull_transporter

        ; $0B: cobra mk-III (trader?)                                   ;$D014/5
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_d8c3_index        := hull_index

        .addr   _d8c3

        ; $0C: python (trader?)                                         ;$D016/7
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_da4b_index        := hull_index

        .addr   _da4b

        ; $0D: boa                                                      ;$D018/9
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_boa_index         := hull_index

        .addr   hull_boa

        ; $0E: anaconda?                                                ;$D01A/B
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_anaconda_index    := hull_index

        .addr   hull_anaconda

        ; $0F: asteroid?                                                ;$D01C/D
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_dd35_index        := hull_index

        .addr   _dd35

        ; $10: viper                                                    ;$D01E/F
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_viper_index       := hull_index

        .addr   hull_viper

        ; $11: sidewinder                                               ;$D020/1
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_sidewinder_index  := hull_index

        .addr   hull_sidewinder

        ; $12: mamba                                                    ;$D022/3
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_mamba_index       := hull_index

        .addr   hull_mamba

        ; $13: krait                                                    ;$D024/5
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_krait_index       := hull_index

        .addr   hull_krait

        ; $14: adder                                                    ;$D026/7
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_adder_index       := hull_index

        .addr   hull_adder

        ; $15: gecko                                                    ;$D028/9
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_gecko_index       := hull_index

        .addr   hull_gecko

        ; $16: cobra mk-I                                               ;$D02A/B
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_cobramk1_index    := hull_index

        .addr   hull_cobramk1

        ; $17: worm                                                     ;$D02C/D
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_worm_index        := hull_index

        .addr   hull_worm
        
        ; $18: combra mk-III (lone wolf?)                               ;$D02E/F
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_e50b_index        := hull_index

        .addr   _e50b

        ; $19: asp mk-II                                                ;$D030/1
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_aspmk2_index      := hull_index

        .addr   hull_aspmk2

        ; $1A: python (lone wolf?)                                      ;$D032/3
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_e7bd_index        := hull_index

        .addr   _e7bd

        ; $1B: fer-de-lance                                             ;$D034/5
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_ferdelance_index  := hull_index

        .addr   hull_ferdelance

        ; $1C: moray                                                    ;$D036/7
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_moray_index       := hull_index

        .addr   hull_moray

        ; $1D: thargoid                                                 ;$D038/9
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_thargoid_index    := hull_index

        .addr   hull_thargoid

        ; $1E: thargon                                                  ;$D03A/B
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_thargon_index     := hull_index

        .addr   hull_thargon

        ; $1F: constrictor                                              ;$D03C/D
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_constrictor_index := hull_index

        .addr   hull_constrictor

        ; $20: cougar                                                   ;$D03E/F
        ;-----------------------------------------------------------------------
        hull_index           .set hull_index + 1
        hull_cougar_index      := hull_index

        .addr   hull_cougar

        ; $21: space station (dodo)                                     ;$D040
        ;-----------------------------------------------------------------------
        hull_pointer_dodo:
        hull_pointer_dodo_lo := hull_pointer_dodo+0
        hull_pointer_dodo_hi := hull_pointer_dodo+1
        
        hull_index           .set hull_index + 1
        hull_dodo_index        := hull_index

        .addr   hull_dodo

;===============================================================================

.segment        "HULL_D042"

; these represent a data byte for each hull defined above

hull_d042:                                                              ;$D042
        ;-----------------------------------------------------------------------
        .byte             $00, $00, $01, $00, $00, $00
        .byte   $00, $00, $21, $61, $a0, $a0, $a0, $a1
        .byte   $a1, $c2, $0c, $8c, $8c, $8c, $0c, $8c                  ;$D050
        .byte   $05, $8c, $8c, $8c, $82, $0c, $0c, $04
        .byte   $04, $20                                                ;$D060

.segment        "HULL_D062"

; these represent a data byte for each hull defined above

hull_d062:
        ;-----------------------------------------------------------------------
        .byte             $00, $95, $00, $10, $0a, $0a
        .byte   $06, $08, $0a, $10, $11, $ea, $aa, $d5
        .byte   $00, $55, $1a, $55, $80, $55, $5a, $55                  ;$D070
        .byte   $aa, $32, $2a, $15, $2a, $40, $c0, $aa
        .byte   $21, $55, $55                                           ;$D080
        

.segment        "HULL_D083"

; these represent a data byte for each hull defined above

hull_d083:
        ;-----------------------------------------------------------------------
        .byte                  $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $01, $00, $00, $00, $00, $00, $00                  ;$D090
        .byte   $00, $00, $00, $01, $01, $01, $01, $00
        .byte   $02, $00, $05, $05, $00                                 ;$D0A0


.segment        "HULL_DATA"

.proc   hull_missile                                                    ;$D0A5
        ;=======================================================================
        .proc   header

        .byte   $00             ; "scoop / debris"
        .word   $0640           ; "missile lock area"?
        .byte   < edges_offset  ; "edges data offset lo"
        .byte   < faces_offset  ; "faces data offset lo"
        .byte   $55             ; "4*maxlines+1 for ship lines stack"?
        .byte   $00             ; "gun vertex*4"?
        .byte   $0a             ; "explosion count"?
        .byte   vertex_bytes    ; verticies byte count
        .byte   edge_count      ; edge count
        .word   $0000           ; bounty
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

        .byte   $00, $00, $44, $1f, $10, $32                    ; vertex 1
        .byte   $08, $08, $24, $5f, $21, $54                    ; vertex 2
        .byte   $08, $08, $24, $1f, $32, $74                    ; vertex 3
        .byte   $08, $08, $24, $9f, $30, $76                    ; vertex 4
        .byte   $08, $08, $24, $df, $10, $65                    ; vertex 5
        .byte   $08, $08, $2c, $3f, $74, $88                    ; vertex 6
        .byte   $08, $08, $2c, $7f, $54, $88                    ; vertex 7
        .byte   $08, $08, $2c, $ff, $65, $88                    ; vertex 8
        .byte   $08, $08, $2c, $bf, $76, $88                    ; vertex 9
        .byte   $0c, $0c, $2c, $28, $74, $88                    ; vertex 10
        .byte   $0c, $0c, $2c, $68, $54, $88                    ; vertex 11
        .byte   $0c, $0c, $2c, $e8, $65, $88                    ; vertex 12
        .byte   $0c, $0c, $2c, $a8, $76, $88                    ; vertex 13
        .byte   $08, $08, $0c, $a8, $76, $77                    ; vertex 14
        .byte   $08, $08, $0c, $e8, $65, $66                    ; vertex 15
        .byte   $08, $08, $0c, $28, $74, $77                    ; vertex 16
        .byte   $08, $08, $0c, $68, $54, $55                    ; vertex 17

        .endproc
        
        vertex_bytes = .sizeof( verticies )

        .proc   edges

        .byte   $1f, $21, $00, $04                              ; edge 1
        .byte   $1f, $32, $00, $08                              ; edge 2
        .byte   $1f, $30, $00, $0c                              ; edge 3
        .byte   $1f, $10, $00, $10                              ; edge 4
        .byte   $1f, $24, $04, $08                              ; edge 5
        .byte   $1f, $51, $04, $10                              ; edge 6
        .byte   $1f, $60, $0c, $10                              ; edge 7
        .byte   $1f, $73, $08, $0c                              ; edge 8
        .byte   $1f, $74, $08, $14                              ; edge 9
        .byte   $1f, $54, $04, $18                              ; edge 10
        .byte   $1f, $65, $10, $1c                              ; edge 11
        .byte   $1f, $76, $0c, $20                              ; edge 12
        .byte   $1f, $86, $1c, $20                              ; edge 13
        .byte   $1f, $87, $14, $20                              ; edge 14
        .byte   $1f, $84, $14, $18                              ; edge 15
        .byte   $1f, $85, $18, $1c                              ; edge 16
        .byte   $08, $85, $18, $28                              ; edge 17
        .byte   $08, $87, $14, $24                              ; edge 18
        .byte   $08, $87, $20, $30                              ; edge 19
        .byte   $08, $85, $1c, $2c                              ; edge 20
        .byte   $08, $74, $24, $3c                              ; edge 21
        .byte   $08, $54, $28, $40                              ; edge 22
        .byte   $08, $76, $30, $34                              ; edge 23
        .byte   $08, $65, $2c, $38                              ; edge 24

        .endproc
        
        edges_offset = edges - header
        edge_count   = .sizeof( edges ) / 4

        .proc   faces

        .byte   $9f, $40, $00, $10, $5f, $00, $40, $10
        .byte   $1f, $40, $00, $10, $1f, $00, $40, $10
        .byte   $1f, $20, $00, $00, $5f, $00, $20, $00
        .byte   $9f, $20, $00, $00, $1f, $00, $20, $00
        .byte   $3f, $00, $00, $b0

        .endproc

        faces_offset = faces - header
        face_count   = .sizeof( faces )

.endproc

.proc   hull_coreolis                                                   ;$D1A3
        ;=======================================================================
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
        .word   $0000           ; bounty
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

;-------------------------------------------------------------------------------

.proc   hull_escape                                                     ;$D2BF
        ; escape capsule

        .byte                                      $20
        .byte   $00, $01, $2c, $44, $1d, $00, $16, $18                  ;$D2C0
        .byte   $06, $00, $00, $10, $08, $11, $08, $00
        .byte   $00, $04, $00, $07, $00, $24, $9f, $12                  ;$D2D0
        .byte   $33, $07, $0e, $0c, $ff, $02, $33, $07
        .byte   $0e, $0c, $bf, $01, $33, $15, $00, $00                  ;$D2E0
        .byte   $1f, $01, $22, $1f, $23, $00, $04, $1f
        .byte   $03, $04, $08, $1f, $01, $08, $0c, $1f                  ;$D2F0
        .byte   $12, $0c, $00, $1f, $13, $00, $08, $1f
        .byte   $02, $0c, $04, $3f, $34, $00, $7a, $1f                  ;$D300
        .byte   $27, $67, $1e, $5f, $27, $67, $1e, $9f
        .byte   $70, $00, $00                                           ;$D310

.endproc

;-------------------------------------------------------------------------------

.proc   hull_plate                                                      ;$D313
        ; plate / alloys

        .byte                  $80, $64, $00, $2c, $3c
        .byte   $15, $00, $0a, $18, $04, $00, $00, $04
        .byte   $05, $10, $10, $00, $00, $03, $00, $0f                  ;$D320
        .byte   $16, $09, $ff, $ff, $ff, $0f, $26, $09
        .byte   $bf, $ff, $ff, $13, $20, $0b, $14, $ff                  ;$D330
        .byte   $ff, $0a, $2e, $06, $54, $ff, $ff, $1f
        .byte   $ff, $00, $04, $10, $ff, $04, $08, $14                  ;$D340
        .byte   $ff, $08, $0c, $10, $ff, $0c, $00, $00
        .byte   $00, $00, $00                                           ;$D350

.endproc

;-------------------------------------------------------------------------------

.proc   hull_cargo                                                      ;$D353
        ; cargo cannister

        .byte                  $00, $90, $01, $50, $8c
        .byte   $35, $00, $12, $3c, $0f, $00, $00, $1c
        .byte   $0c, $11, $0f, $00, $00, $02, $00, $18                  ;$D360
        .byte   $10, $00, $1f, $10, $55, $18, $05, $0f
        .byte   $1f, $10, $22, $18, $0d, $09, $5f, $20                  ;$D370
        .byte   $33, $18, $0d, $09, $7f, $30, $44, $18
        .byte   $05, $0f, $3f, $40, $55, $18, $10, $00                  ;$D380
        .byte   $9f, $51, $66, $18, $05, $0f, $9f, $21
        .byte   $66, $18, $0d, $09, $df, $32, $66, $18                  ;$D390
        .byte   $0d, $09, $ff, $43, $66, $18, $05, $0f
        .byte   $bf, $54, $66, $1f, $10, $00, $04, $1f                  ;$D3A0
        .byte   $20, $04, $08, $1f, $30, $08, $0c, $1f
        .byte   $40, $0c, $10, $1f, $50, $00, $10, $1f                  ;$D3B0
        .byte   $51, $00, $14, $1f, $21, $04, $18, $1f
        .byte   $32, $08, $1c, $1f, $43, $0c, $20, $1f                  ;$D3C0
        .byte   $54, $10, $24, $1f, $61, $14, $18, $1f
        .byte   $62, $18, $1c, $1f, $63, $1c, $20, $1f                  ;$D3D0
        .byte   $64, $20, $24, $1f, $65, $24, $14, $1f
        .byte   $60, $00, $00, $1f, $00, $29, $1e, $5f                  ;$D3E0
        .byte   $00, $12, $30, $5f, $00, $33, $00, $7f
        .byte   $00, $12, $30, $3f, $00, $29, $1e, $9f                  ;$D3F0
        .byte   $60, $00, $00

.endproc

;-------------------------------------------------------------------------------

.proc   _d3fb   ; boulder?                                              ;$D3FB

        .byte                  $00, $84, $03, $3e, $7a
        .byte   $31, $00, $0e, $2a, $0f, $01, $00, $28                  ;$D400
        .byte   $14, $14, $1e, $00, $00, $02, $00, $12
        .byte   $25, $0b, $bf, $01, $59, $1e, $07, $0c                  ;$D410
        .byte   $1f, $12, $56, $1c, $07, $0c, $7f, $23
        .byte   $67, $02, $00, $27, $3f, $34, $78, $1c                  ;$D420
        .byte   $22, $1e, $bf, $04, $89, $05, $0a, $0d
        .byte   $5f, $ff, $ff, $14, $11, $1e, $3f, $ff                  ;$D430
        .byte   $ff, $1f, $15, $00, $04, $1f, $26, $04
        .byte   $08, $1f, $37, $08, $0c, $1f, $48, $0c                  ;$D440
        .byte   $10, $1f, $09, $10, $00, $1f, $01, $00
        .byte   $14, $1f, $12, $04, $14, $1f, $23, $08                  ;$D450
        .byte   $14, $1f, $34, $0c, $14, $1f, $04, $10
        .byte   $14, $1f, $59, $00, $18, $1f, $56, $04                  ;$D460
        .byte   $18, $1f, $67, $08, $18, $1f, $78, $0c
        .byte   $18, $1f, $89, $10, $18, $df, $0f, $03                  ;$D470
        .byte   $08, $9f, $07, $0c, $1e, $5f, $20, $2f
        .byte   $18, $ff, $03, $27, $07, $ff, $05, $04                  ;$D480
        .byte   $01, $1f, $31, $54, $08, $3f, $70, $15
        .byte   $15, $7f, $4c, $23, $52, $3f, $16, $38                  ;$D490
        .byte   $89, $3f, $28, $6e, $26

.endproc

;-------------------------------------------------------------------------------

.proc   _d49d   ; asteroid?                                             ;$D49D

        .byte                            $00, $00, $19
        .byte   $4a, $9e, $45, $00, $22, $36, $15, $05                  ;$D4A0
        .byte   $00, $38, $32, $3c, $1e, $00, $00, $01
        .byte   $00, $00, $50, $00, $1f, $ff, $ff, $50                  ;$D4B0
        .byte   $0a, $00, $df, $ff, $ff, $00, $50, $00
        .byte   $5f, $ff, $ff, $46, $28, $00, $5f, $ff                  ;$D4C0
        .byte   $ff, $3c, $32, $00, $1f, $65, $dc, $32
        .byte   $00, $3c, $1f, $ff, $ff, $28, $00, $46                  ;$D4D0
        .byte   $9f, $10, $32, $00, $1e, $4b, $3f, $ff
        .byte   $ff, $00, $32, $3c, $7f, $98, $ba, $1f                  ;$D4E0
        .byte   $72, $00, $04, $1f, $d6, $00, $10, $1f
        .byte   $c5, $0c, $10, $1f, $b4, $08, $0c, $1f                  ;$D4F0
        .byte   $a3, $04, $08, $1f, $32, $04, $18, $1f
        .byte   $31, $08, $18, $1f, $41, $08, $14, $1f                  ;$D500
        .byte   $10, $14, $18, $1f, $60, $00, $14, $1f
        .byte   $54, $0c, $14, $1f, $20, $00, $18, $1f                  ;$D510
        .byte   $65, $10, $14, $1f, $a8, $04, $20, $1f
        .byte   $87, $04, $1c, $1f, $d7, $00, $1c, $1f                  ;$D520
        .byte   $dc, $10, $1c, $1f, $c9, $0c, $1c, $1f
        .byte   $b9, $0c, $20, $1f, $ba, $08, $20, $1f                  ;$D530
        .byte   $98, $1c, $20, $1f, $09, $42, $51, $5f
        .byte   $09, $42, $51, $9f, $48, $40, $1f, $df                  ;$D540
        .byte   $40, $49, $2f, $5f, $2d, $4f, $41, $1f
        .byte   $87, $0f, $23, $1f, $26, $4c, $46, $bf                  ;$D550
        .byte   $42, $3b, $27, $ff, $43, $0f, $50, $7f
        .byte   $42, $0e, $4b, $ff, $46, $50, $28, $7f                  ;$D560
        .byte   $3a, $66, $33, $3f, $51, $09, $43, $3f
        .byte   $2f, $5e, $3f                                           ;$D570

.endproc

;-------------------------------------------------------------------------------

.proc   hull_splinter                                                   ;$D573
        ; splinter / rock

        .byte                  $b0, $00, $01, $78, $44
        .byte   $1d, $00, $16, $18, $06, $00, $00, $10
        .byte   $08, $14, $0a, $fd, $00, $05, $00, $18                  ;$D580
        .byte   $19, $10, $df, $12, $33, $00, $0c, $0a
        .byte   $3f, $02, $33, $0b, $06, $02, $5f, $01                  ;$D590
        .byte   $33, $0c, $2a, $07, $1f, $01, $22, $1f
        .byte   $23, $00, $04, $1f, $03, $04, $08, $1f                  ;$D5A0
        .byte   $01, $08, $0c, $1f, $12, $0c, $00

.endproc

;-------------------------------------------------------------------------------

.proc   hull_shuttle                                                    ;$D5AF
        ; shuttle

        .byte                                      $0f
        .byte   $c4, $09, $86, $fe, $71, $00, $26, $72                  ;$D5B0
        .byte   $1e, $00, $00, $34, $16, $20, $08, $00
        .byte   $00, $02, $00, $00, $11, $17, $5f, $ff                  ;$D5C0
        .byte   $ff, $11, $00, $17, $9f, $ff, $ff, $00
        .byte   $12, $17, $1f, $ff, $ff, $12, $00, $17                  ;$D5D0
        .byte   $1f, $ff, $ff, $14, $14, $1b, $ff, $12
        .byte   $39, $14, $14, $1b, $bf, $34, $59, $14                  ;$D5E0
        .byte   $14, $1b, $3f, $56, $79, $14, $14, $1b
        .byte   $7f, $17, $89, $05, $00, $1b, $30, $99                  ;$D5F0
        .byte   $99, $00, $02, $1b, $70, $99, $99, $05
        .byte   $00, $1b, $a9, $99, $99, $00, $03, $1b                  ;$D600
        .byte   $29, $99, $99, $00, $09, $23, $50, $0a
        .byte   $bc, $03, $01, $1f, $47, $ff, $02, $04                  ;$D610
        .byte   $0b, $19, $08, $01, $f4, $0b, $04, $19
        .byte   $08, $a1, $3f, $03, $01, $1f, $c7, $6b                  ;$D620
        .byte   $23, $03, $0b, $19, $88, $f8, $c0, $0a
        .byte   $04, $19, $88, $4f, $18, $1f, $02, $00                  ;$D630
        .byte   $04, $1f, $4a, $04, $08, $1f, $6b, $08
        .byte   $0c, $1f, $8c, $00, $0c, $1f, $18, $00                  ;$D640
        .byte   $1c, $18, $12, $00, $10, $1f, $23, $04
        .byte   $10, $18, $34, $04, $14, $1f, $45, $08                  ;$D650
        .byte   $14, $0c, $56, $08, $18, $1f, $67, $0c
        .byte   $18, $18, $78, $0c, $1c, $1f, $39, $10                  ;$D660
        .byte   $14, $1f, $59, $14, $18, $1f, $79, $18
        .byte   $1c, $1f, $19, $10, $1c, $10, $0c, $00                  ;$D670
        .byte   $30, $10, $0a, $04, $30, $10, $ab, $08
        .byte   $30, $10, $bc, $0c, $30, $10, $99, $20                  ;$D680
        .byte   $24, $07, $99, $24, $28, $09, $99, $28
        .byte   $2c, $07, $99, $20, $2c, $05, $bb, $34                  ;$D690
        .byte   $38, $08, $bb, $38, $3c, $07, $bb, $34
        .byte   $3c, $05, $aa, $40, $44, $08, $aa, $44                  ;$D6A0
        .byte   $48, $07, $aa, $40, $48, $df, $37, $37
        .byte   $28, $5f, $00, $4a, $04, $df, $33, $33                  ;$D6B0
        .byte   $17, $9f, $4a, $00, $04, $9f, $33, $33
        .byte   $17, $1f, $00, $4a, $04, $1f, $33, $33                  ;$D6C0
        .byte   $17, $1f, $4a, $00, $04, $5f, $33, $33
        .byte   $17, $3f, $00, $00, $6b, $9f, $29, $29                  ;$D6D0
        .byte   $5a, $1f, $29, $29, $5a, $5f, $37, $37
        .byte   $28                                                     ;$D6E0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_transporter                                                ;$D6E1
        ; transporter
        
        .byte        $00, $c4, $09, $f2, $aa, $95, $30
        .byte   $1a, $de, $2e, $00, $00, $38, $10, $20
        .byte   $0a, $00, $01, $02, $00, $00, $0a, $1a                  ;$D6F0
        .byte   $3f, $06, $77, $19, $04, $1a, $bf, $01
        .byte   $77, $1c, $03, $1a, $ff, $01, $22, $19                  ;$D700
        .byte   $08, $1a, $ff, $02, $33, $1a, $08, $1a
        .byte   $7f, $03, $44, $1d, $03, $1a, $7f, $04                  ;$D710
        .byte   $55, $1a, $04, $1a, $3f, $05, $66, $00
        .byte   $06, $0c, $13, $ff, $ff, $1e, $01, $0c                  ;$D720
        .byte   $df, $17, $89, $21, $08, $0c, $df, $12
        .byte   $39, $21, $08, $0c, $5f, $34, $5a, $1e                  ;$D730
        .byte   $01, $0c, $5f, $56, $ab, $0b, $02, $1e
        .byte   $df, $89, $cd, $0d, $08, $1e, $df, $39                  ;$D740
        .byte   $dd, $0e, $08, $1e, $5f, $3a, $dd, $0b
        .byte   $02, $1e, $5f, $ab, $cd, $05, $06, $02                  ;$D750
        .byte   $87, $77, $77, $12, $03, $02, $87, $77
        .byte   $77, $05, $07, $07, $a7, $77, $77, $12                  ;$D760
        .byte   $04, $07, $a7, $77, $77, $0b, $06, $0e
        .byte   $a7, $77, $77, $0b, $05, $07, $a7, $77                  ;$D770
        .byte   $77, $05, $07, $0e, $27, $66, $66, $12
        .byte   $04, $0e, $27, $66, $66, $0b, $05, $07                  ;$D780
        .byte   $27, $66, $66, $05, $06, $03, $27, $66
        .byte   $66, $12, $03, $03, $27, $66, $66, $0b                  ;$D790
        .byte   $04, $08, $07, $66, $66, $0b, $05, $03
        .byte   $27, $66, $66, $10, $08, $0d, $e6, $33                  ;$D7A0
        .byte   $33, $10, $08, $10, $c6, $33, $33, $11
        .byte   $08, $0d, $66, $33, $33, $11, $08, $10                  ;$D7B0
        .byte   $46, $33, $33, $0d, $03, $1a, $e8, $00
        .byte   $00, $0d, $03, $1a, $68, $00, $00, $09                  ;$D7C0
        .byte   $03, $1a, $25, $00, $00, $08, $03, $1a
        .byte   $a5, $00, $00, $1f, $07, $00, $04, $1f                  ;$D7D0
        .byte   $01, $04, $08, $1f, $02, $08, $0c, $1f
        .byte   $03, $0c, $10, $1f, $04, $10, $14, $1f                  ;$D7E0
        .byte   $05, $14, $18, $1f, $06, $00, $18, $10
        .byte   $67, $00, $1c, $1f, $17, $04, $20, $0b                  ;$D7F0
        .byte   $12, $08, $24, $1f, $23, $0c, $24, $1f
        .byte   $34, $10, $28, $0b, $45, $14, $28, $1f                  ;$D800
        .byte   $56, $18, $2c, $11, $78, $1c, $20, $11
        .byte   $19, $20, $24, $11, $5a, $28, $2c, $11                  ;$D810
        .byte   $6b, $1c, $2c, $13, $bc, $1c, $3c, $13
        .byte   $8c, $1c, $30, $10, $89, $20, $30, $1f                  ;$D820
        .byte   $39, $24, $34, $1f, $3a, $28, $38, $10
        .byte   $ab, $2c, $3c, $1f, $9d, $30, $34, $1f                  ;$D830
        .byte   $3d, $34, $38, $1f, $ad, $38, $3c, $1f
        .byte   $cd, $30, $3c, $07, $77, $40, $44, $07                  ;$D840
        .byte   $77, $48, $4c, $07, $77, $4c, $50, $07
        .byte   $77, $48, $50, $07, $77, $50, $54, $07                  ;$D850
        .byte   $66, $58, $5c, $07, $66, $5c, $60, $07
        .byte   $66, $60, $58, $07, $66, $64, $68, $07                  ;$D860
        .byte   $66, $68, $6c, $07, $66, $64, $6c, $07
        .byte   $66, $6c, $70, $06, $33, $74, $78, $06                  ;$D870
        .byte   $33, $7c, $80, $08, $00, $84, $88, $05
        .byte   $00, $88, $8c, $05, $00, $8c, $90, $05                  ;$D880
        .byte   $00, $90, $84, $3f, $00, $00, $67, $bf
        .byte   $6f, $30, $07, $ff, $69, $3f, $15, $5f                  ;$D890
        .byte   $00, $22, $00, $7f, $69, $3f, $15, $3f
        .byte   $6f, $30, $07, $1f, $08, $20, $03, $9f                  ;$D8A0
        .byte   $08, $20, $03, $93, $08, $22, $0b, $9f
        .byte   $4b, $20, $4f, $1f, $4b, $20, $4f, $13                  ;$D8B0
        .byte   $08, $22, $0b, $1f, $00, $26, $11, $1f
        .byte   $00, $00, $79                                           ;$D8C0

.endproc

;-------------------------------------------------------------------------------

.proc   _d8c3   ; cobra mk-III                                          ;$D8C3

        .byte                  $03, $41, $23, $bc, $54
        .byte   $9d, $54, $2a, $a8, $26, $00, $00, $34
        .byte   $32, $96, $1c, $00, $01, $01, $13, $20                  ;$D8D0
        .byte   $00, $4c, $1f, $ff, $ff, $20, $00, $4c
        .byte   $9f, $ff, $ff, $00, $1a, $18, $1f, $ff                  ;$D8E0
        .byte   $ff, $78, $03, $08, $ff, $73, $aa, $78
        .byte   $03, $08, $7f, $84, $cc, $58, $10, $28                  ;$D8F0
        .byte   $bf, $ff, $ff, $58, $10, $28, $3f, $ff
        .byte   $ff, $80, $08, $28, $7f, $98, $cc, $80                  ;$D900
        .byte   $08, $28, $ff, $97, $aa, $00, $1a, $28
        .byte   $3f, $65, $99, $20, $18, $28, $ff, $a9                  ;$D910
        .byte   $bb, $20, $18, $28, $7f, $b9, $cc, $24
        .byte   $08, $28, $b4, $99, $99, $08, $0c, $28                  ;$D920
        .byte   $b4, $99, $99, $08, $0c, $28, $34, $99
        .byte   $99, $24, $08, $28, $34, $99, $99, $24                  ;$D930
        .byte   $0c, $28, $74, $99, $99, $08, $10, $28
        .byte   $74, $99, $99, $08, $10, $28, $f4, $99                  ;$D940
        .byte   $99, $24, $0c, $28, $f4, $99, $99, $00
        .byte   $00, $4c, $06, $b0, $bb, $00, $00, $5a                  ;$D950
        .byte   $1f, $b0, $bb, $50, $06, $28, $e8, $99
        .byte   $99, $50, $06, $28, $a8, $99, $99, $58                  ;$D960
        .byte   $00, $28, $a6, $99, $99, $50, $06, $28
        .byte   $28, $99, $99, $58, $00, $28, $26, $99                  ;$D970
        .byte   $99, $50, $06, $28, $68, $99, $99, $1f
        .byte   $b0, $00, $04, $1f, $c4, $00, $10, $1f                  ;$D980
        .byte   $a3, $04, $0c, $1f, $a7, $0c, $20, $1f
        .byte   $c8, $10, $1c, $1f, $98, $18, $1c, $1f                  ;$D990
        .byte   $96, $18, $24, $1f, $95, $14, $24, $1f
        .byte   $97, $14, $20, $1f, $51, $08, $14, $1f                  ;$D9A0
        .byte   $62, $08, $18, $1f, $73, $0c, $14, $1f
        .byte   $84, $10, $18, $1f, $10, $04, $08, $1f                  ;$D9B0
        .byte   $20, $00, $08, $1f, $a9, $20, $28, $1f
        .byte   $b9, $28, $2c, $1f, $c9, $1c, $2c, $1f                  ;$D9C0
        .byte   $ba, $04, $28, $1f, $cb, $00, $2c, $1d
        .byte   $31, $04, $14, $1d, $42, $00, $18, $06                  ;$D9D0
        .byte   $b0, $50, $54, $14, $99, $30, $34, $14
        .byte   $99, $48, $4c, $14, $99, $38, $3c, $14                  ;$D9E0
        .byte   $99, $40, $44, $13, $99, $3c, $40, $11
        .byte   $99, $38, $44, $13, $99, $34, $48, $13                  ;$D9F0
        .byte   $99, $30, $4c, $1e, $65, $08, $24, $06
        .byte   $99, $58, $60, $06, $99, $5c, $60, $08                  ;$DA00
        .byte   $99, $58, $5c, $06, $99, $64, $68, $06
        .byte   $99, $68, $6c, $08, $99, $64, $6c, $1f                  ;$DA10
        .byte   $00, $3e, $1f, $9f, $12, $37, $10, $1f
        .byte   $12, $37, $10, $9f, $10, $34, $0e, $1f                  ;$DA20
        .byte   $10, $34, $0e, $9f, $0e, $2f, $00, $1f
        .byte   $0e, $2f, $00, $9f, $3d, $66, $00, $1f                  ;$DA30
        .byte   $3d, $66, $00, $3f, $00, $00, $50, $df
        .byte   $07, $2a, $09, $5f, $00, $1e, $06, $5f                  ;$DA40
        .byte   $07, $2a, $09

.endproc

;-------------------------------------------------------------------------------

.proc   _da4b   ; python (trader?)                                      ;$DA4B

        .byte                  $05, $00, $19, $56, $be
        .byte   $59, $00, $2a, $42, $1a, $00, $00, $34                  ;$DA50
        .byte   $28, $fa, $14, $00, $00, $00, $1b, $00
        .byte   $00, $e0, $1f, $10, $32, $00, $30, $30                  ;$DA60
        .byte   $1f, $10, $54, $60, $00, $10, $3f, $ff
        .byte   $ff, $60, $00, $10, $bf, $ff, $ff, $00                  ;$DA70
        .byte   $30, $20, $3f, $54, $98, $00, $18, $70
        .byte   $3f, $89, $cc, $30, $00, $70, $bf, $b8                  ;$DA80
        .byte   $cc, $30, $00, $70, $3f, $a9, $cc, $00
        .byte   $30, $30, $5f, $32, $76, $00, $30, $20                  ;$DA90
        .byte   $7f, $76, $ba, $00, $18, $70, $7f, $ba
        .byte   $cc, $1f, $32, $00, $20, $1f, $20, $00                  ;$DAA0
        .byte   $0c, $1f, $31, $00, $08, $1f, $10, $00
        .byte   $04, $1f, $59, $08, $10, $1f, $51, $04                  ;$DAB0
        .byte   $08, $1f, $37, $08, $20, $1f, $40, $04
        .byte   $0c, $1f, $62, $0c, $20, $1f, $a7, $08                  ;$DAC0
        .byte   $24, $1f, $84, $0c, $10, $1f, $b6, $0c
        .byte   $24, $07, $88, $0c, $14, $07, $bb, $0c                  ;$DAD0
        .byte   $28, $07, $99, $08, $14, $07, $aa, $08
        .byte   $28, $1f, $a9, $08, $1c, $1f, $b8, $0c                  ;$DAE0
        .byte   $18, $1f, $c8, $14, $18, $1f, $c9, $14
        .byte   $1c, $1f, $ac, $1c, $28, $1f, $cb, $18                  ;$DAF0
        .byte   $28, $1f, $98, $10, $14, $1f, $ba, $24
        .byte   $28, $1f, $54, $04, $10, $1f, $76, $20                  ;$DB00
        .byte   $24, $9f, $1b, $28, $0b, $1f, $1b, $28
        .byte   $0b, $df, $1b, $28, $0b, $5f, $1b, $28                  ;$DB10
        .byte   $0b, $9f, $13, $26, $00, $1f, $13, $26
        .byte   $00, $df, $13, $26, $00, $5f, $13, $26                  ;$DB20
        .byte   $00, $bf, $19, $25, $0b, $3f, $19, $25
        .byte   $0b, $7f, $19, $25, $0b, $ff, $19, $25                  ;$DB30
        .byte   $0b, $3f, $00, $00, $70

.endproc

;-------------------------------------------------------------------------------

.proc   hull_boa                                                        ;$DB3D
        ; boa

        .byte                            $05, $24, $13
        .byte   $62, $c2, $5d, $00, $26, $4e, $18, $00                  ;$DB40
        .byte   $00, $34, $28, $fa, $18, $00, $00, $00
        .byte   $1c, $00, $00, $5d, $1f, $ff, $ff, $00                  ;$DB50
        .byte   $28, $57, $38, $02, $33, $26, $19, $63
        .byte   $78, $01, $44, $26, $19, $63, $f8, $12                  ;$DB60
        .byte   $55, $26, $28, $3b, $bf, $23, $69, $26
        .byte   $28, $3b, $3f, $03, $6b, $3e, $00, $43                  ;$DB70
        .byte   $3f, $04, $8b, $18, $41, $4f, $7f, $14
        .byte   $8a, $18, $41, $4f, $ff, $15, $7a, $3e                  ;$DB80
        .byte   $00, $43, $bf, $25, $79, $00, $07, $6b
        .byte   $36, $02, $aa, $0d, $09, $6b, $76, $01                  ;$DB90
        .byte   $aa, $0d, $09, $6b, $f6, $12, $cc, $1f
        .byte   $6b, $00, $14, $1f, $8a, $00, $1c, $1f                  ;$DBA0
        .byte   $79, $00, $24, $1d, $69, $00, $10, $1d
        .byte   $8b, $00, $18, $1d, $7a, $00, $20, $1f                  ;$DBB0
        .byte   $36, $10, $14, $1f, $0b, $14, $18, $1f
        .byte   $48, $18, $1c, $1f, $1a, $1c, $20, $1f                  ;$DBC0
        .byte   $57, $20, $24, $1f, $29, $10, $24, $18
        .byte   $23, $04, $10, $18, $03, $04, $14, $18                  ;$DBD0
        .byte   $25, $0c, $24, $18, $15, $0c, $20, $18
        .byte   $04, $08, $18, $18, $14, $08, $1c, $16                  ;$DBE0
        .byte   $02, $04, $28, $16, $01, $08, $2c, $16
        .byte   $12, $0c, $30, $0e, $0c, $28, $2c, $0e                  ;$DBF0
        .byte   $1c, $2c, $30, $0e, $2c, $30, $28, $3f
        .byte   $2b, $25, $3c, $7f, $00, $2d, $59, $bf                  ;$DC00
        .byte   $2b, $25, $3c, $1f, $00, $28, $00, $7f
        .byte   $3e, $20, $14, $ff, $3e, $20, $14, $1f                  ;$DC10
        .byte   $00, $17, $06, $df, $17, $0f, $09, $5f
        .byte   $17, $0f, $09, $9f, $1a, $0d, $0a, $5f                  ;$DC20
        .byte   $00, $1f, $0c, $1f, $1a, $0d, $0a, $2e
        .byte   $00, $00, $6b                                           ;$DC30

.endproc

;-------------------------------------------------------------------------------

.proc   hull_anaconda                                                   ;$DC33
        ; anaconda

        .byte                  $07, $10, $27, $6e, $d2
        .byte   $5d, $30, $2e, $5a, $19, $00, $00, $30
        .byte   $24, $fc, $0e, $00, $00, $01, $3f, $00                  ;$DC40
        .byte   $07, $3a, $3e, $01, $55, $2b, $0d, $25
        .byte   $fe, $01, $22, $1a, $2f, $03, $fe, $02                  ;$DC50
        .byte   $33, $1a, $2f, $03, $7e, $03, $44, $2b
        .byte   $0d, $25, $7e, $04, $55, $00, $30, $31                  ;$DC60
        .byte   $3e, $15, $66, $45, $0f, $0f, $be, $12
        .byte   $77, $2b, $27, $28, $df, $23, $88, $2b                  ;$DC70
        .byte   $27, $28, $5f, $34, $99, $45, $0f, $0f
        .byte   $3e, $45, $aa, $2b, $35, $17, $bf, $ff                  ;$DC80
        .byte   $ff, $45, $01, $20, $df, $27, $88, $00
        .byte   $00, $fe, $1f, $ff, $ff, $45, $01, $20                  ;$DC90
        .byte   $5f, $49, $aa, $2b, $35, $17, $3f, $ff
        .byte   $ff, $1e, $01, $00, $04, $1e, $02, $04                  ;$DCA0
        .byte   $08, $1e, $03, $08, $0c, $1e, $04, $0c
        .byte   $10, $1e, $05, $00, $10, $1d, $15, $00                  ;$DCB0
        .byte   $14, $1d, $12, $04, $18, $1d, $23, $08
        .byte   $1c, $1d, $34, $0c, $20, $1d, $45, $10                  ;$DCC0
        .byte   $24, $1e, $16, $14, $28, $1e, $17, $18
        .byte   $28, $1e, $27, $18, $2c, $1e, $28, $1c                  ;$DCD0
        .byte   $2c, $1f, $38, $1c, $30, $1f, $39, $20
        .byte   $30, $1e, $49, $20, $34, $1e, $4a, $24                  ;$DCE0
        .byte   $34, $1e, $5a, $24, $38, $1e, $56, $14
        .byte   $38, $1e, $6b, $28, $38, $1f, $7b, $28                  ;$DCF0
        .byte   $30, $1f, $78, $2c, $30, $1f, $9a, $30
        .byte   $34, $1f, $ab, $30, $38, $7e, $00, $33                  ;$DD00
        .byte   $31, $be, $33, $12, $57, $fe, $4d, $39
        .byte   $13, $5f, $00, $5a, $10, $7e, $4d, $39                  ;$DD10
        .byte   $13, $3e, $33, $12, $57, $3e, $00, $6f
        .byte   $14, $9f, $61, $48, $18, $df, $6c, $44                  ;$DD20
        .byte   $22, $5f, $6c, $44, $22, $1f, $61, $48
        .byte   $18, $1f, $00, $5e, $12                                 ;$DD30

.endproc

;-------------------------------------------------------------------------------

.proc   _dd35   ; asteroid?                                             ;$DD35

        .byte                            $07, $00, $19
        .byte   $4a, $9e, $45, $00, $32, $36, $15, $00
        .byte   $00, $38, $32, $b4, $1e, $00, $00, $01                  ;$DD40
        .byte   $02, $00, $50, $00, $1f, $ff, $ff, $50
        .byte   $0a, $00, $df, $ff, $ff, $00, $50, $00                  ;$DD50
        .byte   $5f, $ff, $ff, $46, $28, $00, $5f, $ff
        .byte   $ff, $3c, $32, $00, $1f, $65, $dc, $32                  ;$DD60
        .byte   $00, $3c, $1f, $ff, $ff, $28, $00, $46
        .byte   $9f, $10, $32, $00, $1e, $4b, $3f, $ff                  ;$DD70
        .byte   $ff, $00, $32, $3c, $7f, $98, $ba, $1f
        .byte   $72, $00, $04, $1f, $d6, $00, $10, $1f                  ;$DD80
        .byte   $c5, $0c, $10, $1f, $b4, $08, $0c, $1f
        .byte   $a3, $04, $08, $1f, $32, $04, $18, $1f                  ;$DD90
        .byte   $31, $08, $18, $1f, $41, $08, $14, $1f
        .byte   $10, $14, $18, $1f, $60, $00, $14, $1f                  ;$DDA0
        .byte   $54, $0c, $14, $1f, $20, $00, $18, $1f
        .byte   $65, $10, $14, $1f, $a8, $04, $20, $1f                  ;$DDB0
        .byte   $87, $04, $1c, $1f, $d7, $00, $1c, $1f
        .byte   $dc, $10, $1c, $1f, $c9, $0c, $1c, $1f                  ;$DDC0
        .byte   $b9, $0c, $20, $1f, $ba, $08, $20, $1f
        .byte   $98, $1c, $20, $1f, $09, $42, $51, $5f                  ;$DDD0
        .byte   $09, $42, $51, $9f, $48, $40, $1f, $df
        .byte   $40, $49, $2f, $5f, $2d, $4f, $41, $1f                  ;$DDE0
        .byte   $87, $0f, $23, $1f, $26, $4c, $46, $bf
        .byte   $42, $3b, $27, $ff, $43, $0f, $50, $7f                  ;$DDF0
        .byte   $42, $0e, $4b, $ff, $46, $50, $28, $7f
        .byte   $3a, $66, $33, $3f, $51, $09, $43, $3f                  ;$DE00
        .byte   $2f, $5e, $3f

.endproc

;-------------------------------------------------------------------------------

.proc   hull_viper                                                      ;$DE0B
        ; viper

        .byte                  $00, $f9, $15, $6e, $be
        .byte   $51, $00, $2a, $5a, $14, $00, $00, $1c                  ;$DE10
        .byte   $17, $8c, $20, $00, $00, $01, $11, $00
        .byte   $00, $48, $1f, $21, $43, $00, $10, $18                  ;$DE20
        .byte   $1e, $10, $22, $00, $10, $18, $5e, $43
        .byte   $55, $30, $00, $18, $3f, $42, $66, $30                  ;$DE30
        .byte   $00, $18, $bf, $31, $66, $18, $10, $18
        .byte   $7e, $54, $66, $18, $10, $18, $fe, $35                  ;$DE40
        .byte   $66, $18, $10, $18, $3f, $20, $66, $18
        .byte   $10, $18, $bf, $10, $66, $20, $00, $18                  ;$DE50
        .byte   $b3, $66, $66, $20, $00, $18, $33, $66
        .byte   $66, $08, $08, $18, $33, $66, $66, $08                  ;$DE60
        .byte   $08, $18, $b3, $66, $66, $08, $08, $18
        .byte   $f2, $66, $66, $08, $08, $18, $72, $66                  ;$DE70
        .byte   $66, $1f, $42, $00, $0c, $1e, $21, $00
        .byte   $04, $1e, $43, $00, $08, $1f, $31, $00                  ;$DE80
        .byte   $10, $1e, $20, $04, $1c, $1e, $10, $04
        .byte   $20, $1e, $54, $08, $14, $1e, $53, $08                  ;$DE90
        .byte   $18, $1f, $60, $1c, $20, $1e, $65, $14
        .byte   $18, $1f, $61, $10, $20, $1e, $63, $10                  ;$DEA0
        .byte   $18, $1f, $62, $0c, $1c, $1e, $46, $0c
        .byte   $14, $13, $66, $24, $30, $12, $66, $24                  ;$DEB0
        .byte   $34, $13, $66, $28, $2c, $12, $66, $28
        .byte   $38, $10, $66, $2c, $38, $10, $66, $30                  ;$DEC0
        .byte   $34, $1f, $00, $20, $00, $9f, $16, $21
        .byte   $0b, $1f, $16, $21, $0b, $df, $16, $21                  ;$DED0
        .byte   $0b, $5f, $16, $21, $0b, $5f, $00, $20
        .byte   $00, $3f, $00, $00, $30                                 ;$DEE0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_sidewinder                                                 ;$DEE5
        ; sidewinder

        .byte                            $00, $81, $10
        .byte   $50, $8c, $41, $00, $1e, $3c, $0f, $32
        .byte   $00, $1c, $14, $46, $25, $00, $00, $02                  ;$DEF0
        .byte   $10, $20, $00, $24, $9f, $10, $54, $20
        .byte   $00, $24, $1f, $20, $65, $40, $00, $1c                  ;$DF00
        .byte   $3f, $32, $66, $40, $00, $1c, $bf, $31
        .byte   $44, $00, $10, $1c, $3f, $10, $32, $00                  ;$DF10
        .byte   $10, $1c, $7f, $43, $65, $0c, $06, $1c
        .byte   $af, $33, $33, $0c, $06, $1c, $2f, $33                  ;$DF20
        .byte   $33, $0c, $06, $1c, $6c, $33, $33, $0c
        .byte   $06, $1c, $ec, $33, $33, $1f, $50, $00                  ;$DF30
        .byte   $04, $1f, $62, $04, $08, $1f, $20, $04
        .byte   $10, $1f, $10, $00, $10, $1f, $41, $00                  ;$DF40
        .byte   $0c, $1f, $31, $0c, $10, $1f, $32, $08
        .byte   $10, $1f, $43, $0c, $14, $1f, $63, $08                  ;$DF50
        .byte   $14, $1f, $65, $04, $14, $1f, $54, $00
        .byte   $14, $0f, $33, $18, $1c, $0c, $33, $1c                  ;$DF60
        .byte   $20, $0c, $33, $18, $24, $0c, $33, $20
        .byte   $24, $1f, $00, $20, $08, $9f, $0c, $2f                  ;$DF70
        .byte   $06, $1f, $0c, $2f, $06, $3f, $00, $00
        .byte   $70, $df, $0c, $2f, $06, $5f, $00, $20                  ;$DF80
        .byte   $08, $5f, $0c, $2f, $06

.endproc

;-------------------------------------------------------------------------------

.proc   hull_mamba                                                      ;$DF8D
        ; mamba

        .byte                            $01, $24, $13
        .byte   $aa, $1a, $61, $00, $22, $96, $1c, $96                  ;$DF90
        .byte   $00, $14, $19, $5a, $1e, $00, $01, $02
        .byte   $12, $00, $00, $40, $1f, $10, $32, $40                  ;$DFA0
        .byte   $08, $20, $ff, $20, $44, $20, $08, $20
        .byte   $be, $21, $44, $20, $08, $20, $3e, $31                  ;$DFB0
        .byte   $44, $40, $08, $20, $7f, $30, $44, $04
        .byte   $04, $10, $8e, $11, $11, $04, $04, $10                  ;$DFC0
        .byte   $0e, $11, $11, $08, $03, $1c, $0d, $11
        .byte   $11, $08, $03, $1c, $8d, $11, $11, $14                  ;$DFD0
        .byte   $04, $10, $d4, $00, $00, $14, $04, $10
        .byte   $54, $00, $00, $18, $07, $14, $f4, $00                  ;$DFE0
        .byte   $00, $10, $07, $14, $f0, $00, $00, $10
        .byte   $07, $14, $70, $00, $00, $18, $07, $14                  ;$DFF0
        .byte   $74, $00, $00, $08, $04, $20, $ad, $44
        .byte   $44, $08, $04, $20, $2d, $44, $44, $08                  ;$E000
        .byte   $04, $20, $6e, $44, $44, $08, $04, $20
        .byte   $ee, $44, $44, $20, $04, $20, $a7, $44                  ;$E010
        .byte   $44, $20, $04, $20, $27, $44, $44, $24
        .byte   $04, $20, $67, $44, $44, $24, $04, $20                  ;$E020
        .byte   $e7, $44, $44, $26, $00, $20, $a5, $44
        .byte   $44, $26, $00, $20, $25, $44, $44, $1f                  ;$E030
        .byte   $20, $00, $04, $1f, $30, $00, $10, $1f
        .byte   $40, $04, $10, $1e, $42, $04, $08, $1e                  ;$E040
        .byte   $41, $08, $0c, $1e, $43, $0c, $10, $0e
        .byte   $11, $14, $18, $0c, $11, $18, $1c, $0d                  ;$E050
        .byte   $11, $1c, $20, $0c, $11, $14, $20, $14
        .byte   $00, $24, $2c, $10, $00, $24, $30, $10                  ;$E060
        .byte   $00, $28, $34, $14, $00, $28, $38, $0e
        .byte   $00, $34, $38, $0e, $00, $2c, $30, $0d                  ;$E070
        .byte   $44, $3c, $40, $0e, $44, $44, $48, $0c
        .byte   $44, $3c, $48, $0c, $44, $40, $44, $07                  ;$E080
        .byte   $44, $50, $54, $05, $44, $50, $60, $05
        .byte   $44, $54, $60, $07, $44, $4c, $58, $05                  ;$E090
        .byte   $44, $4c, $5c, $05, $44, $58, $5c, $1e
        .byte   $21, $00, $08, $1e, $31, $00, $0c, $5e                  ;$E0A0
        .byte   $00, $18, $02, $1e, $00, $18, $02, $9e
        .byte   $20, $40, $10, $1e, $20, $40, $10, $3e                  ;$E0B0
        .byte   $00, $00, $7f

.endproc

;-------------------------------------------------------------------------------

.proc   hull_krait                                                      ;$E0BB
        ; krait

        .byte   $01, $10, $0e, $7a, $ce
        .byte   $59, $00, $12, $66, $15, $64, $00, $18                  ;$E0C0
        .byte   $14, $50, $1e, $00, $00, $01, $10, $00
        .byte   $00, $60, $1f, $01, $23, $00, $12, $30                  ;$E0D0
        .byte   $3f, $03, $45, $00, $12, $30, $7f, $12
        .byte   $45, $5a, $00, $03, $3f, $01, $44, $5a                  ;$E0E0
        .byte   $00, $03, $bf, $23, $55, $5a, $00, $57
        .byte   $1e, $01, $11, $5a, $00, $57, $9e, $23                  ;$E0F0
        .byte   $33, $00, $05, $35, $09, $00, $33, $00
        .byte   $07, $26, $06, $00, $33, $12, $07, $13                  ;$E100
        .byte   $89, $33, $33, $12, $07, $13, $09, $00
        .byte   $00, $12, $0b, $27, $28, $44, $44, $12                  ;$E110
        .byte   $0b, $27, $68, $44, $44, $24, $00, $1e
        .byte   $28, $44, $44, $12, $0b, $27, $a8, $55                  ;$E120
        .byte   $55, $12, $0b, $27, $e8, $55, $55, $24
        .byte   $00, $1e, $a8, $55, $55, $1f, $03, $00                  ;$E130
        .byte   $04, $1f, $12, $00, $08, $1f, $01, $00
        .byte   $0c, $1f, $23, $00, $10, $1f, $35, $04                  ;$E140
        .byte   $10, $1f, $25, $10, $08, $1f, $14, $08
        .byte   $0c, $1f, $04, $0c, $04, $1e, $01, $0c                  ;$E150
        .byte   $14, $1e, $23, $10, $18, $08, $45, $04
        .byte   $08, $09, $00, $1c, $28, $06, $00, $20                  ;$E160
        .byte   $28, $09, $33, $1c, $24, $06, $33, $20
        .byte   $24, $08, $44, $2c, $34, $08, $44, $34                  ;$E170
        .byte   $30, $07, $44, $30, $2c, $07, $55, $38
        .byte   $3c, $08, $55, $3c, $40, $08, $55, $40                  ;$E180
        .byte   $38, $1f, $03, $18, $03, $5f, $03, $18
        .byte   $03, $df, $03, $18, $03, $9f, $03, $18                  ;$E190
        .byte   $03, $3f, $26, $00, $4d, $bf, $26, $00
        .byte   $4d                                                     ;$E1A0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_adder                                                      ;$E1A1
        ; adder

        .byte        $00, $c4, $09, $80, $f4, $65, $00
        .byte   $16, $6c, $1d, $28, $00, $3c, $14, $55
        .byte   $18, $00, $00, $02, $10, $12, $00, $28                  ;$E1B0
        .byte   $9f, $01, $bc, $12, $00, $28, $1f, $01
        .byte   $23, $1e, $00, $18, $3f, $23, $45, $1e                  ;$E1C0
        .byte   $00, $28, $3f, $45, $66, $12, $07, $28
        .byte   $7f, $56, $7e, $12, $07, $28, $ff, $78                  ;$E1D0
        .byte   $ae, $1e, $00, $28, $bf, $89, $aa, $1e
        .byte   $00, $18, $bf, $9a, $bc, $12, $07, $28                  ;$E1E0
        .byte   $bf, $78, $9d, $12, $07, $28, $3f, $46
        .byte   $7d, $12, $07, $0d, $9f, $09, $bd, $12                  ;$E1F0
        .byte   $07, $0d, $1f, $02, $4d, $12, $07, $0d
        .byte   $df, $1a, $ce, $12, $07, $0d, $5f, $13                  ;$E200
        .byte   $5e, $0b, $03, $1d, $85, $00, $00, $0b
        .byte   $03, $1d, $05, $00, $00, $0b, $04, $18                  ;$E210
        .byte   $04, $00, $00, $0b, $04, $18, $84, $00
        .byte   $00, $1f, $01, $00, $04, $07, $23, $04                  ;$E220
        .byte   $08, $1f, $45, $08, $0c, $1f, $56, $0c
        .byte   $10, $1f, $7e, $10, $14, $1f, $8a, $14                  ;$E230
        .byte   $18, $1f, $9a, $18, $1c, $07, $bc, $1c
        .byte   $00, $1f, $46, $0c, $24, $1f, $7d, $24                  ;$E240
        .byte   $20, $1f, $89, $20, $18, $1f, $0b, $00
        .byte   $28, $1f, $9b, $1c, $28, $1f, $02, $04                  ;$E250
        .byte   $2c, $1f, $24, $08, $2c, $1f, $1c, $00
        .byte   $30, $1f, $ac, $1c, $30, $1f, $13, $04                  ;$E260
        .byte   $34, $1f, $35, $08, $34, $1f, $0d, $28
        .byte   $2c, $1f, $1e, $30, $34, $1f, $9d, $20                  ;$E270
        .byte   $28, $1f, $4d, $24, $2c, $1f, $ae, $14
        .byte   $30, $1f, $5e, $10, $34, $05, $00, $38                  ;$E280
        .byte   $3c, $03, $00, $3c, $40, $04, $00, $40
        .byte   $44, $03, $00, $44, $38, $1f, $00, $27                  ;$E290
        .byte   $0a, $5f, $00, $27, $0a, $1f, $45, $32
        .byte   $0d, $5f, $45, $32, $0d, $1f, $1e, $34                  ;$E2A0
        .byte   $00, $5f, $1e, $34, $00, $3f, $00, $00
        .byte   $a0, $3f, $00, $00, $a0, $3f, $00, $00                  ;$E2B0
        .byte   $a0, $9f, $1e, $34, $00, $df, $1e, $34
        .byte   $00, $9f, $45, $32, $0d, $df, $45, $32                  ;$E2C0
        .byte   $0d, $1f, $00, $1c, $00, $5f, $00, $1c
        .byte   $00                                                     ;$E2D0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_gecko                                                      ;$E2D1
        ; gecko

        .byte        $00, $49, $26, $5c, $a0, $45, $00
        .byte   $1a, $48, $11, $37, $00, $24, $12, $46
        .byte   $1e, $00, $00, $03, $10, $0a, $04, $2f                  ;$E2E0
        .byte   $df, $03, $45, $0a, $04, $2f, $5f, $01
        .byte   $23, $10, $08, $17, $bf, $05, $67, $10                  ;$E2F0
        .byte   $08, $17, $3f, $01, $78, $42, $00, $03
        .byte   $bf, $45, $66, $42, $00, $03, $3f, $12                  ;$E300
        .byte   $88, $14, $0e, $17, $ff, $34, $67, $14
        .byte   $0e, $17, $7f, $23, $78, $08, $06, $21                  ;$E310
        .byte   $d0, $33, $33, $08, $06, $21, $51, $33
        .byte   $33, $08, $0d, $10, $f0, $33, $33, $08                  ;$E320
        .byte   $0d, $10, $71, $33, $33, $1f, $03, $00
        .byte   $04, $1f, $12, $04, $14, $1f, $18, $14                  ;$E330
        .byte   $0c, $1f, $07, $0c, $08, $1f, $56, $08
        .byte   $10, $1f, $45, $10, $00, $1f, $28, $14                  ;$E340
        .byte   $1c, $1f, $37, $1c, $18, $1f, $46, $18
        .byte   $10, $1d, $05, $00, $08, $1e, $01, $04                  ;$E350
        .byte   $0c, $1d, $34, $00, $18, $1e, $23, $04
        .byte   $1c, $14, $67, $08, $18, $14, $78, $0c                  ;$E360
        .byte   $1c, $10, $33, $20, $28, $11, $33, $24
        .byte   $2c, $1f, $00, $1f, $05, $1f, $04, $2d                  ;$E370
        .byte   $08, $5f, $19, $6c, $13, $5f, $00, $54
        .byte   $0c, $df, $19, $6c, $13, $9f, $04, $2d                  ;$E380
        .byte   $08, $bf, $58, $10, $d6, $3f, $00, $00
        .byte   $bb, $3f, $58, $10, $d6                                 ;$E390

.endproc

;-------------------------------------------------------------------------------

.proc   hull_cobramk1                                                   ;$E395
        ; cobra mk-I

        .byte                            $03, $49, $26
        .byte   $56, $9e, $49, $28, $1a, $42, $12, $4b
        .byte   $00, $28, $13, $5a, $1a, $00, $00, $02                  ;$E3A0
        .byte   $12, $12, $01, $32, $df, $01, $23, $12
        .byte   $01, $32, $5f, $01, $45, $42, $00, $07                  ;$E3B0
        .byte   $9f, $23, $88, $42, $00, $07, $1f, $45
        .byte   $99, $20, $0c, $26, $bf, $26, $78, $20                  ;$E3C0
        .byte   $0c, $26, $3f, $46, $79, $36, $0c, $26
        .byte   $ff, $13, $78, $36, $0c, $26, $7f, $15                  ;$E3D0
        .byte   $79, $00, $0c, $06, $34, $02, $46, $00
        .byte   $01, $32, $42, $01, $11, $00, $01, $3c                  ;$E3E0
        .byte   $5f, $01, $11, $1f, $01, $04, $00, $1f
        .byte   $23, $00, $08, $1f, $38, $08, $18, $1f                  ;$E3F0
        .byte   $17, $18, $1c, $1f, $59, $1c, $0c, $1f
        .byte   $45, $0c, $04, $1f, $28, $08, $10, $1f                  ;$E400
        .byte   $67, $10, $14, $1f, $49, $14, $0c, $14
        .byte   $02, $00, $20, $14, $04, $20, $04, $10                  ;$E410
        .byte   $26, $10, $20, $10, $46, $20, $14, $1f
        .byte   $78, $10, $18, $1f, $79, $14, $1c, $14                  ;$E420
        .byte   $13, $00, $18, $14, $15, $04, $1c, $02
        .byte   $01, $28, $24, $1f, $00, $29, $0a, $5f                  ;$E430
        .byte   $00, $1b, $03, $9f, $08, $2e, $08, $df
        .byte   $0c, $39, $0c, $1f, $08, $2e, $08, $5f                  ;$E440
        .byte   $0c, $39, $0c, $1f, $00, $31, $00, $3f
        .byte   $00, $00, $9a, $bf, $79, $6f, $3e, $3f                  ;$E450
        .byte   $79, $6f, $3e

.endproc

;-------------------------------------------------------------------------------

.proc   hull_worm                                                       ;$E45B
        ; worm

        .byte                  $00, $49, $26, $50, $90
        .byte   $4d, $00, $12, $3c, $10, $00, $00, $20                  ;$E460
        .byte   $13, $1e, $17, $00, $00, $03, $08, $0a
        .byte   $0a, $23, $5f, $02, $77, $0a, $0a, $23                  ;$E470
        .byte   $df, $03, $77, $05, $06, $0f, $1f, $01
        .byte   $24, $05, $06, $0f, $9f, $01, $35, $0f                  ;$E480
        .byte   $0a, $19, $5f, $24, $77, $0f, $0a, $19
        .byte   $df, $35, $77, $1a, $0a, $19, $7f, $46                  ;$E490
        .byte   $77, $1a, $0a, $19, $ff, $56, $77, $08
        .byte   $0e, $19, $3f, $14, $66, $08, $0e, $19                  ;$E4A0
        .byte   $bf, $15, $66, $1f, $07, $00, $04, $1f
        .byte   $37, $04, $14, $1f, $57, $14, $1c, $1f                  ;$E4B0
        .byte   $67, $1c, $18, $1f, $47, $18, $10, $1f
        .byte   $27, $10, $00, $1f, $02, $00, $08, $1f                  ;$E4C0
        .byte   $03, $04, $0c, $1f, $24, $10, $08, $1f
        .byte   $35, $14, $0c, $1f, $14, $08, $20, $1f                  ;$E4D0
        .byte   $46, $20, $18, $1f, $15, $0c, $24, $1f
        .byte   $56, $24, $1c, $1f, $01, $08, $0c, $1f                  ;$E4E0
        .byte   $16, $20, $24, $1f, $00, $58, $46, $1f
        .byte   $00, $45, $0e, $1f, $46, $42, $23, $9f                  ;$E4F0
        .byte   $46, $42, $23, $1f, $40, $31, $0e, $9f
        .byte   $40, $31, $0e, $3f, $00, $00, $c8, $5f                  ;$E500
        .byte   $00, $50, $00

.endproc

;-------------------------------------------------------------------------------

.proc   _e50b   ; combra mk-III (lone wolf?)                            ;$E50B

        .byte                  $01, $41, $23, $bc, $54
        .byte   $9d, $54, $2a, $a8, $26, $af, $00, $34                  ;$E510
        .byte   $32, $96, $1c, $00, $01, $01, $12, $20
        .byte   $00, $4c, $1f, $ff, $ff, $20, $00, $4c                  ;$E520
        .byte   $9f, $ff, $ff, $00, $1a, $18, $1f, $ff
        .byte   $ff, $78, $03, $08, $ff, $73, $aa, $78                  ;$E530
        .byte   $03, $08, $7f, $84, $cc, $58, $10, $28
        .byte   $bf, $ff, $ff, $58, $10, $28, $3f, $ff                  ;$E540
        .byte   $ff, $80, $08, $28, $7f, $98, $cc, $80
        .byte   $08, $28, $ff, $97, $aa, $00, $1a, $28                  ;$E550
        .byte   $3f, $65, $99, $20, $18, $28, $ff, $a9
        .byte   $bb, $20, $18, $28, $7f, $b9, $cc, $24                  ;$E560
        .byte   $08, $28, $b4, $99, $99, $08, $0c, $28
        .byte   $b4, $99, $99, $08, $0c, $28, $34, $99                  ;$E570
        .byte   $99, $24, $08, $28, $34, $99, $99, $24
        .byte   $0c, $28, $74, $99, $99, $08, $10, $28                  ;$E580
        .byte   $74, $99, $99, $08, $10, $28, $f4, $99
        .byte   $99, $24, $0c, $28, $f4, $99, $99, $00                  ;$E590
        .byte   $00, $4c, $06, $b0, $bb, $00, $00, $5a
        .byte   $1f, $b0, $bb, $50, $06, $28, $e8, $99                  ;$E5A0
        .byte   $99, $50, $06, $28, $a8, $99, $99, $58
        .byte   $00, $28, $a6, $99, $99, $50, $06, $28                  ;$E5B0
        .byte   $28, $99, $99, $58, $00, $28, $26, $99
        .byte   $99, $50, $06, $28, $68, $99, $99, $1f                  ;$E5C0
        .byte   $b0, $00, $04, $1f, $c4, $00, $10, $1f
        .byte   $a3, $04, $0c, $1f, $a7, $0c, $20, $1f                  ;$E5D0
        .byte   $c8, $10, $1c, $1f, $98, $18, $1c, $1f
        .byte   $96, $18, $24, $1f, $95, $14, $24, $1f                  ;$E5E0
        .byte   $97, $14, $20, $1f, $51, $08, $14, $1f
        .byte   $62, $08, $18, $1f, $73, $0c, $14, $1f                  ;$E5F0
        .byte   $84, $10, $18, $1f, $10, $04, $08, $1f
        .byte   $20, $00, $08, $1f, $a9, $20, $28, $1f                  ;$E600
        .byte   $b9, $28, $2c, $1f, $c9, $1c, $2c, $1f
        .byte   $ba, $04, $28, $1f, $cb, $00, $2c, $1d                  ;$E610
        .byte   $31, $04, $14, $1d, $42, $00, $18, $06
        .byte   $b0, $50, $54, $14, $99, $30, $34, $14                  ;$E620
        .byte   $99, $48, $4c, $14, $99, $38, $3c, $14
        .byte   $99, $40, $44, $13, $99, $3c, $40, $11                  ;$E630
        .byte   $99, $38, $44, $13, $99, $34, $48, $13
        .byte   $99, $30, $4c, $1e, $65, $08, $24, $06                  ;$E640
        .byte   $99, $58, $60, $06, $99, $5c, $60, $08
        .byte   $99, $58, $5c, $06, $99, $64, $68, $06                  ;$E650
        .byte   $99, $68, $6c, $08, $99, $64, $6c, $1f
        .byte   $00, $3e, $1f, $9f, $12, $37, $10, $1f                  ;$E660
        .byte   $12, $37, $10, $9f, $10, $34, $0e, $1f
        .byte   $10, $34, $0e, $9f, $0e, $2f, $00, $1f                  ;$E670
        .byte   $0e, $2f, $00, $9f, $3d, $66, $00, $1f
        .byte   $3d, $66, $00, $3f, $00, $00, $50, $df                  ;$E680
        .byte   $07, $2a, $09, $5f, $00, $1e, $06, $5f
        .byte   $07, $2a, $09                                           ;$E690

.endproc

;-------------------------------------------------------------------------------

.proc   hull_aspmk2                                                     ;$E693
        ; asp mk-II
        
        .byte                  $00, $10, $0e, $86, $f6
        .byte   $69, $20, $1a, $72, $1c, $c8, $00, $30
        .byte   $28, $96, $28, $00, $00, $01, $29, $00                  ;$E6A0
        .byte   $12, $00, $56, $01, $22, $00, $09, $2d
        .byte   $7f, $12, $bb, $2b, $00, $2d, $3f, $16                  ;$E6B0
        .byte   $bb, $45, $03, $00, $5f, $16, $79, $2b
        .byte   $0e, $1c, $5f, $01, $77, $2b, $00, $2d                  ;$E6C0
        .byte   $bf, $25, $bb, $45, $03, $00, $df, $25
        .byte   $8a, $2b, $0e, $1c, $df, $02, $88, $1a                  ;$E6D0
        .byte   $07, $49, $5f, $04, $79, $1a, $07, $49
        .byte   $df, $04, $8a, $2b, $0e, $1c, $1f, $34                  ;$E6E0
        .byte   $69, $2b, $0e, $1c, $9f, $34, $5a, $00
        .byte   $09, $2d, $3f, $35, $6b, $11, $00, $2d                  ;$E6F0
        .byte   $aa, $bb, $bb, $11, $00, $2d, $29, $bb
        .byte   $bb, $00, $04, $2d, $6a, $bb, $bb, $00                  ;$E700
        .byte   $04, $2d, $28, $bb, $bb, $00, $07, $49
        .byte   $4a, $04, $04, $00, $07, $53, $4a, $04                  ;$E710
        .byte   $04, $16, $12, $00, $04, $16, $01, $00
        .byte   $10, $16, $02, $00, $1c, $1f, $1b, $04                  ;$E720
        .byte   $08, $1f, $16, $08, $0c, $10, $79, $0c
        .byte   $20, $1f, $04, $20, $24, $10, $8a, $18                  ;$E730
        .byte   $24, $1f, $25, $14, $18, $1f, $2b, $04
        .byte   $14, $1f, $17, $0c, $10, $1f, $07, $10                  ;$E740
        .byte   $20, $1f, $28, $18, $1c, $1f, $08, $1c
        .byte   $24, $1f, $6b, $08, $30, $1f, $5b, $14                  ;$E750
        .byte   $30, $16, $36, $28, $30, $16, $35, $2c
        .byte   $30, $16, $34, $28, $2c, $1f, $5a, $18                  ;$E760
        .byte   $2c, $1f, $4a, $24, $2c, $1f, $69, $0c
        .byte   $28, $1f, $49, $20, $28, $0a, $bb, $34                  ;$E770
        .byte   $3c, $09, $bb, $3c, $38, $08, $bb, $38
        .byte   $40, $08, $bb, $40, $34, $0a, $04, $48                  ;$E780
        .byte   $44, $5f, $00, $23, $05, $7f, $08, $26
        .byte   $07, $ff, $08, $26, $07, $36, $00, $18                  ;$E790
        .byte   $01, $1f, $00, $2b, $13, $bf, $06, $1c
        .byte   $02, $3f, $06, $1c, $02, $5f, $3b, $40                  ;$E7A0
        .byte   $1f, $df, $3b, $40, $1f, $1f, $50, $2e
        .byte   $32, $9f, $50, $2e, $32, $3f, $00, $00                  ;$E7B0
        .byte   $5a, $59, $3a, $43, $4d

.endproc

;-------------------------------------------------------------------------------

.proc   _e7bd   ; python (lone-wolf?)                                   ;$E7BD

        .byte                            $02, $00, $19
        .byte   $56, $be, $59, $00, $2a, $42, $1a, $c8                  ;$E7C0
        .byte   $00, $34, $28, $fa, $14, $00, $00, $00
        .byte   $1b, $00, $00, $e0, $1f, $10, $32, $00                  ;$E7D0
        .byte   $30, $30, $1f, $10, $54, $60, $00, $10
        .byte   $3f, $ff, $ff, $60, $00, $10, $bf, $ff                  ;$E7E0
        .byte   $ff, $00, $30, $20, $3f, $54, $98, $00
        .byte   $18, $70, $3f, $89, $cc, $30, $00, $70                  ;$E7F0
        .byte   $bf, $b8, $cc, $30, $00, $70, $3f, $a9
        .byte   $cc, $00, $30, $30, $5f, $32, $76, $00                  ;$E800
        .byte   $30, $20, $7f, $76, $ba, $00, $18, $70
        .byte   $7f, $ba, $cc, $1f, $32, $00, $20, $1f                  ;$E810
        .byte   $20, $00, $0c, $1f, $31, $00, $08, $1f
        .byte   $10, $00, $04, $1f, $59, $08, $10, $1f                  ;$E820
        .byte   $51, $04, $08, $1f, $37, $08, $20, $1f
        .byte   $40, $04, $0c, $1f, $62, $0c, $20, $1f                  ;$E830
        .byte   $a7, $08, $24, $1f, $84, $0c, $10, $1f
        .byte   $b6, $0c, $24, $07, $88, $0c, $14, $07                  ;$E840
        .byte   $bb, $0c, $28, $07, $99, $08, $14, $07
        .byte   $aa, $08, $28, $1f, $a9, $08, $1c, $1f                  ;$E850
        .byte   $b8, $0c, $18, $1f, $c8, $14, $18, $1f
        .byte   $c9, $14, $1c, $1f, $ac, $1c, $28, $1f                  ;$E860
        .byte   $cb, $18, $28, $1f, $98, $10, $14, $1f
        .byte   $ba, $24, $28, $1f, $54, $04, $10, $1f                  ;$E870
        .byte   $76, $20, $24, $9f, $1b, $28, $0b, $1f
        .byte   $1b, $28, $0b, $df, $1b, $28, $0b, $5f                  ;$E880
        .byte   $1b, $28, $0b, $9f, $13, $26, $00, $1f
        .byte   $13, $26, $00, $df, $13, $26, $00, $5f                  ;$E890
        .byte   $13, $26, $00, $bf, $19, $25, $0b, $3f
        .byte   $19, $25, $0b, $7f, $19, $25, $0b, $ff                  ;$E8A0
        .byte   $19, $25, $0b, $3f, $00, $00, $70

.endproc

;-------------------------------------------------------------------------------

.proc   hull_ferdelance                                                 ;$E8AF
        ; fer-de-lance

        .byte                                      $00
        .byte   $40, $06, $86, $f2, $6d, $00, $1a, $72                  ;$E8B0
        .byte   $1b, $00, $00, $28, $28, $a0, $1e, $00
        .byte   $00, $01, $12, $00, $0e, $6c, $5f, $01                  ;$E8C0
        .byte   $59, $28, $0e, $04, $ff, $12, $99, $0c
        .byte   $0e, $34, $ff, $23, $99, $0c, $0e, $34                  ;$E8D0
        .byte   $7f, $34, $99, $28, $0e, $04, $7f, $45
        .byte   $99, $28, $0e, $04, $bc, $01, $26, $0c                  ;$E8E0
        .byte   $02, $34, $bc, $23, $67, $0c, $02, $34
        .byte   $3c, $34, $78, $28, $0e, $04, $3c, $04                  ;$E8F0
        .byte   $58, $00, $12, $14, $2f, $06, $78, $03
        .byte   $0b, $61, $cb, $00, $00, $1a, $08, $12                  ;$E900
        .byte   $89, $00, $00, $10, $0e, $04, $ab, $00
        .byte   $00, $03, $0b, $61, $4b, $00, $00, $1a                  ;$E910
        .byte   $08, $12, $09, $00, $00, $10, $0e, $04
        .byte   $2b, $00, $00, $00, $0e, $14, $6c, $99                  ;$E920
        .byte   $99, $0e, $0e, $2c, $cc, $99, $99, $0e
        .byte   $0e, $2c, $4c, $99, $99, $1f, $19, $00                  ;$E930
        .byte   $04, $1f, $29, $04, $08, $1f, $39, $08
        .byte   $0c, $1f, $49, $0c, $10, $1f, $59, $00                  ;$E940
        .byte   $10, $1c, $01, $00, $14, $1c, $26, $14
        .byte   $18, $1c, $37, $18, $1c, $1c, $48, $1c                  ;$E950
        .byte   $20, $1c, $05, $00, $20, $0f, $06, $14
        .byte   $24, $0b, $67, $18, $24, $0b, $78, $1c                  ;$E960
        .byte   $24, $0f, $08, $20, $24, $0e, $12, $04
        .byte   $14, $0e, $23, $08, $18, $0e, $34, $0c                  ;$E970
        .byte   $1c, $0e, $45, $10, $20, $08, $00, $28
        .byte   $2c, $09, $00, $2c, $30, $0b, $00, $28                  ;$E980
        .byte   $30, $08, $00, $34, $38, $09, $00, $38
        .byte   $3c, $0b, $00, $34, $3c, $0c, $99, $40                  ;$E990
        .byte   $44, $0c, $99, $40, $48, $08, $99, $44
        .byte   $48, $1c, $00, $18, $06, $9f, $44, $00                  ;$E9A0
        .byte   $18, $bf, $3f, $00, $25, $3f, $00, $00
        .byte   $68, $3f, $3f, $00, $25, $1f, $44, $00                  ;$E9B0
        .byte   $18, $bc, $0c, $2e, $13, $3c, $00, $2d
        .byte   $16, $3c, $0c, $2e, $13, $5f, $00, $1c                  ;$E9C0
        .byte   $00

.endproc

;-------------------------------------------------------------------------------

.proc   hull_moray                                                      ;$E9C9
        ; moray
        
        .byte        $01, $84, $03, $68, $b4, $49, $00
        .byte   $1a, $54, $13, $32, $00, $24, $28, $64                  ;$E9D0
        .byte   $19, $00, $00, $02, $10, $0f, $00, $41
        .byte   $1f, $02, $78, $0f, $00, $41, $9f, $01                  ;$E9E0
        .byte   $67, $00, $12, $28, $31, $ff, $ff, $3c
        .byte   $00, $00, $9f, $13, $66, $3c, $00, $00                  ;$E9F0
        .byte   $1f, $25, $88, $1e, $1b, $0a, $78, $45
        .byte   $78, $1e, $1b, $0a, $f8, $34, $67, $09                  ;$EA00
        .byte   $04, $19, $e7, $44, $44, $09, $04, $19
        .byte   $67, $44, $44, $00, $12, $10, $67, $44                  ;$EA10
        .byte   $44, $0d, $03, $31, $05, $00, $00, $06
        .byte   $00, $41, $05, $00, $00, $0d, $03, $31                  ;$EA20
        .byte   $85, $00, $00, $06, $00, $41, $85, $00
        .byte   $00, $1f, $07, $00, $04, $1f, $16, $04                  ;$EA30
        .byte   $0c, $18, $36, $0c, $18, $18, $47, $14
        .byte   $18, $18, $58, $10, $14, $1f, $28, $00                  ;$EA40
        .byte   $10, $0f, $67, $04, $18, $0f, $78, $00
        .byte   $14, $0f, $02, $00, $08, $0f, $01, $04                  ;$EA50
        .byte   $08, $11, $13, $08, $0c, $11, $25, $08
        .byte   $10, $0d, $45, $08, $14, $0d, $34, $08                  ;$EA60
        .byte   $18, $05, $44, $1c, $20, $07, $44, $1c
        .byte   $24, $07, $44, $20, $24, $05, $00, $28                  ;$EA70
        .byte   $2c, $05, $00, $30, $34, $1f, $00, $2b
        .byte   $07, $9f, $0a, $31, $07, $1f, $0a, $31                  ;$EA80
        .byte   $07, $f8, $3b, $1c, $65, $78, $00, $34
        .byte   $4e, $78, $3b, $1c, $65, $df, $48, $63                  ;$EA90
        .byte   $32, $5f, $00, $53, $1e, $5f, $48, $63
        .byte   $32                                                     ;$EAA0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_thargoid                                                   ;$EAA1
        ; thargoid

        .byte        $00, $49, $26, $8c, $f4, $69, $3c
        .byte   $26, $78, $1a, $f4, $01, $28, $37, $f0
        .byte   $27, $00, $00, $02, $16, $20, $30, $30                  ;$EAB0
        .byte   $5f, $40, $88, $20, $44, $00, $5f, $10
        .byte   $44, $20, $30, $30, $7f, $21, $44, $20                  ;$EAC0
        .byte   $00, $44, $3f, $32, $44, $20, $30, $30
        .byte   $3f, $43, $55, $20, $44, $00, $1f, $54                  ;$EAD0
        .byte   $66, $20, $30, $30, $1f, $64, $77, $20
        .byte   $00, $44, $1f, $74, $88, $18, $74, $74                  ;$EAE0
        .byte   $df, $80, $99, $18, $a4, $00, $df, $10
        .byte   $99, $18, $74, $74, $ff, $21, $99, $18                  ;$EAF0
        .byte   $00, $a4, $bf, $32, $99, $18, $74, $74
        .byte   $bf, $53, $99, $18, $a4, $00, $9f, $65                  ;$EB00
        .byte   $99, $18, $74, $74, $9f, $76, $99, $18
        .byte   $00, $a4, $9f, $87, $99, $18, $40, $50                  ;$EB10
        .byte   $9e, $99, $99, $18, $40, $50, $be, $99
        .byte   $99, $18, $40, $50, $fe, $99, $99, $18                  ;$EB20
        .byte   $40, $50, $de, $99, $99, $1f, $84, $00
        .byte   $1c, $1f, $40, $00, $04, $1f, $41, $04                  ;$EB30
        .byte   $08, $1f, $42, $08, $0c, $1f, $43, $0c
        .byte   $10, $1f, $54, $10, $14, $1f, $64, $14                  ;$EB40
        .byte   $18, $1f, $74, $18, $1c, $1f, $80, $00
        .byte   $20, $1f, $10, $04, $24, $1f, $21, $08                  ;$EB50
        .byte   $28, $1f, $32, $0c, $2c, $1f, $53, $10
        .byte   $30, $1f, $65, $14, $34, $1f, $76, $18                  ;$EB60
        .byte   $38, $1f, $87, $1c, $3c, $1f, $98, $20
        .byte   $3c, $1f, $90, $20, $24, $1f, $91, $24                  ;$EB70
        .byte   $28, $1f, $92, $28, $2c, $1f, $93, $2c
        .byte   $30, $1f, $95, $30, $34, $1f, $96, $34                  ;$EB80
        .byte   $38, $1f, $97, $38, $3c, $1e, $99, $40
        .byte   $44, $1e, $99, $48, $4c, $5f, $67, $3c                  ;$EB90
        .byte   $19, $7f, $67, $3c, $19, $7f, $67, $19
        .byte   $3c, $3f, $67, $19, $3c, $1f, $40, $00                  ;$EBA0
        .byte   $00, $3f, $67, $3c, $19, $1f, $67, $3c
        .byte   $19, $1f, $67, $19, $3c, $5f, $67, $19                  ;$EBB0
        .byte   $3c, $9f, $30, $00, $00

.endproc

;-------------------------------------------------------------------------------

.proc   hull_thargon                                                    ;$EBBD
        ; thargon (the thargoid drone ships)

        .byte                            $f0, $40, $06
        .byte   $e6, $50, $45, $00, $12, $3c, $0f, $32                  ;$EBC0
        .byte   $00, $1c, $14, $14, $1e, $e7, $00, $02
        .byte   $10, $09, $00, $28, $9f, $01, $55, $09                  ;$EBD0
        .byte   $26, $0c, $df, $01, $22, $09, $18, $20
        .byte   $ff, $02, $33, $09, $18, $20, $bf, $03                  ;$EBE0
        .byte   $44, $09, $26, $0c, $9f, $04, $55, $09
        .byte   $00, $08, $3f, $15, $66, $09, $0a, $0f                  ;$EBF0
        .byte   $7f, $12, $66, $09, $06, $1a, $7f, $23
        .byte   $66, $09, $06, $1a, $3f, $34, $66, $09                  ;$EC00
        .byte   $0a, $0f, $3f, $45, $66, $9f, $24, $00
        .byte   $00, $5f, $14, $05, $07, $7f, $2e, $2a                  ;$EC10
        .byte   $0e, $3f, $24, $00, $68, $3f, $2e, $2a
        .byte   $0e, $1f, $14, $05, $07, $1f, $24, $00                  ;$EC20
        .byte   $00

.endproc

;-------------------------------------------------------------------------------

.proc   hull_constrictor                                                ;$EC29
        ; constrictor (mission)

        .byte        $03, $81, $10, $7a, $da, $51, $00
        .byte   $2e, $66, $18, $00, $00, $28, $2d, $fc                  ;$EC30
        .byte   $24, $00, $00, $02, $34, $14, $07, $50
        .byte   $5f, $02, $99, $14, $07, $50, $df, $01                  ;$EC40
        .byte   $99, $36, $07, $28, $df, $14, $99, $36
        .byte   $07, $28, $ff, $45, $89, $14, $0d, $28                  ;$EC50
        .byte   $bf, $56, $88, $14, $0d, $28, $3f, $67
        .byte   $88, $36, $07, $28, $7f, $37, $89, $36                  ;$EC60
        .byte   $07, $28, $5f, $23, $99, $14, $0d, $05
        .byte   $1f, $ff, $ff, $14, $0d, $05, $9f, $ff                  ;$EC70
        .byte   $ff, $14, $07, $3e, $52, $99, $99, $14
        .byte   $07, $3e, $d2, $99, $99, $19, $07, $19                  ;$EC80
        .byte   $72, $99, $99, $19, $07, $19, $f2, $99
        .byte   $99, $0f, $07, $0f, $6a, $99, $99, $0f                  ;$EC90
        .byte   $07, $0f, $ea, $99, $99, $00, $07, $00
        .byte   $40, $9f, $01, $1f, $09, $00, $04, $1f                  ;$ECA0
        .byte   $19, $04, $08, $1f, $01, $04, $24, $1f
        .byte   $02, $00, $20, $1f, $29, $00, $1c, $1f                  ;$ECB0
        .byte   $23, $1c, $20, $1f, $14, $08, $24, $1f
        .byte   $49, $08, $0c, $1f, $39, $18, $1c, $1f                  ;$ECC0
        .byte   $37, $18, $20, $1f, $67, $14, $20, $1f
        .byte   $56, $10, $24, $1f, $45, $0c, $24, $1f                  ;$ECD0
        .byte   $58, $0c, $10, $1f, $68, $10, $14, $1f
        .byte   $78, $14, $18, $1f, $89, $0c, $18, $1f                  ;$ECE0
        .byte   $06, $20, $24, $12, $99, $28, $30, $05
        .byte   $99, $30, $38, $0a, $99, $38, $28, $0a                  ;$ECF0
        .byte   $99, $2c, $3c, $05, $99, $34, $3c, $12
        .byte   $99, $2c, $34, $1f, $00, $37, $0f, $9f                  ;$ED00
        .byte   $18, $4b, $14, $1f, $18, $4b, $14, $1f
        .byte   $2c, $4b, $00, $9f, $2c, $4b, $00, $9f                  ;$ED10
        .byte   $2c, $4b, $00, $1f, $00, $35, $00, $1f
        .byte   $2c, $4b, $00, $3f, $00, $00, $a0, $5f                  ;$ED20
        .byte   $00, $1b, $00

.endproc

;-------------------------------------------------------------------------------

.proc   hull_cougar                                                     ;$ED2B
        ; the secret stealth ship

        .byte                  $03, $24, $13, $86, $ea
        .byte   $69, $00, $2a, $72, $19, $00, $00, $18                  ;$ED30
        .byte   $22, $fc, $28, $00, $00, $02, $34, $00
        .byte   $05, $43, $1f, $02, $44, $14, $00, $28                  ;$ED40
        .byte   $9f, $01, $22, $28, $00, $28, $bf, $01
        .byte   $55, $00, $0e, $28, $3e, $04, $55, $00                  ;$ED50
        .byte   $0e, $28, $7e, $12, $35, $14, $00, $28
        .byte   $1f, $23, $44, $28, $00, $28, $3f, $34                  ;$ED60
        .byte   $55, $24, $00, $38, $9f, $01, $11, $3c
        .byte   $00, $14, $bf, $01, $11, $24, $00, $38                  ;$ED70
        .byte   $1f, $34, $44, $3c, $00, $14, $3f, $34
        .byte   $44, $00, $07, $23, $12, $00, $44, $00                  ;$ED80
        .byte   $08, $19, $14, $00, $44, $0c, $02, $2d
        .byte   $94, $00, $00, $0c, $02, $2d, $14, $44                  ;$ED90
        .byte   $44, $0a, $06, $28, $b4, $55, $55, $0a
        .byte   $06, $28, $f4, $55, $55, $0a, $06, $28                  ;$EDA0
        .byte   $74, $55, $55, $0a, $06, $28, $34, $55
        .byte   $55, $1f, $02, $00, $04, $1f, $01, $04                  ;$EDB0
        .byte   $1c, $1f, $01, $1c, $20, $1f, $01, $20
        .byte   $08, $1e, $05, $08, $0c, $1e, $45, $0c                  ;$EDC0
        .byte   $18, $1e, $15, $08, $10, $1e, $35, $10
        .byte   $18, $1f, $34, $18, $28, $1f, $34, $28                  ;$EDD0
        .byte   $24, $1f, $34, $24, $14, $1f, $24, $14
        .byte   $00, $1b, $04, $00, $0c, $1b, $12, $04                  ;$EDE0
        .byte   $10, $1b, $23, $14, $10, $1a, $01, $04
        .byte   $08, $1a, $34, $14, $18, $14, $00, $30                  ;$EDF0
        .byte   $34, $12, $00, $34, $2c, $12, $44, $2c
        .byte   $38, $14, $44, $38, $30, $12, $55, $3c                  ;$EE00
        .byte   $40, $14, $55, $40, $48, $12, $55, $48
        .byte   $44, $14, $55, $44, $3c, $9f, $10, $2e                  ;$EE10
        .byte   $04, $df, $10, $2e, $04, $5f, $00, $1b
        .byte   $05, $5f, $10, $2e, $04, $1f, $10, $2e                  ;$EE20
        .byte   $04, $3e, $00, $00, $a0

.endproc

;-------------------------------------------------------------------------------

.proc   hull_dodo                                                       ;$EE2D
        ; space station (dodecahedral)

        .byte                            $00, $90, $7e
        .byte   $a4, $2c, $65, $00, $36, $90, $22, $00                  ;$EE30
        .byte   $00, $30, $7d, $f0, $00, $00, $01, $00
        .byte   $00, $00, $96, $c4, $1f, $01, $55, $8f                  ;$EE40
        .byte   $2e, $c4, $1f, $01, $22, $58, $79, $c4
        .byte   $5f, $02, $33, $58, $79, $c4, $df, $03                  ;$EE50
        .byte   $44, $8f, $2e, $c4, $9f, $04, $55, $00
        .byte   $f3, $2e, $1f, $15, $66, $e7, $4b, $2e                  ;$EE60
        .byte   $1f, $12, $77, $8f, $c4, $2e, $5f, $23
        .byte   $88, $8f, $c4, $2e, $df, $34, $99, $e7                  ;$EE70
        .byte   $4b, $2e, $9f, $45, $aa, $8f, $c4, $2e
        .byte   $3f, $16, $77, $e7, $4b, $2e, $7f, $27                  ;$EE80
        .byte   $88, $00, $f3, $2e, $7f, $38, $99, $e7
        .byte   $4b, $2e, $ff, $49, $aa, $8f, $c4, $2e                  ;$EE90
        .byte   $bf, $56, $aa, $58, $79, $c4, $3f, $67
        .byte   $bb, $8f, $2e, $c4, $7f, $78, $bb, $00                  ;$EEA0
        .byte   $96, $c4, $7f, $89, $bb, $8f, $2e, $c4
        .byte   $ff, $9a, $bb, $58, $79, $c4, $bf, $6a                  ;$EEB0
        .byte   $bb, $10, $20, $c4, $9e, $00, $00, $10
        .byte   $20, $c4, $de, $00, $00, $10, $20, $c4                  ;$EEC0
        .byte   $17, $00, $00, $10, $20, $c4, $57, $00
        .byte   $00, $1f, $01, $00, $04, $1f, $02, $04                  ;$EED0
        .byte   $08, $1f, $03, $08, $0c, $1f, $04, $0c
        .byte   $10, $1f, $05, $10, $00, $1f, $16, $14                  ;$EEE0
        .byte   $28, $1f, $17, $28, $18, $1f, $27, $18
        .byte   $2c, $1f, $28, $2c, $1c, $1f, $38, $1c                  ;$EEF0
        .byte   $30, $1f, $39, $30, $20, $1f, $49, $20
        .byte   $34, $1f, $4a, $34, $24, $1f, $5a, $24                  ;$EF00
        .byte   $38, $1f, $56, $38, $14, $1f, $7b, $3c
        .byte   $40, $1f, $8b, $40, $44, $1f, $9b, $44                  ;$EF10
        .byte   $48, $1f, $ab, $48, $4c, $1f, $6b, $4c
        .byte   $3c, $1f, $15, $00, $14, $1f, $12, $04                  ;$EF20
        .byte   $18, $1f, $23, $08, $1c, $1f, $34, $0c
        .byte   $20, $1f, $45, $10, $24, $1f, $67, $28                  ;$EF30
        .byte   $3c, $1f, $78, $2c, $40, $1f, $89, $30
        .byte   $44, $1f, $9a, $34, $48, $1f, $6a, $38                  ;$EF40
        .byte   $4c, $1e, $00, $50, $54, $14, $00, $54
        .byte   $5c, $17, $00, $5c, $58, $14, $00, $58                  ;$EF50
        .byte   $50, $1f, $00, $00, $c4, $1f, $67, $8e
        .byte   $58, $5f, $a9, $37, $59, $5f, $00, $b0                  ;$EF60
        .byte   $58, $df, $a9, $37, $59, $9f, $67, $8e
        .byte   $58, $3f, $00, $b0, $58, $3f, $a9, $37                  ;$EF70
        .byte   $59, $7f, $67, $8e, $58, $ff, $67, $8e
        .byte   $58, $bf, $a9, $37, $59, $3f, $00, $00                  ;$EF80
        .byte   $c4, $4c, $44, $41, $52, $1f, $3f, $58

.endproc

;$EF90