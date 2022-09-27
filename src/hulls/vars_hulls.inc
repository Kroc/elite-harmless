; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
;
; we cannot export structures, so we need to include this file
; when we want to refer to the bytes [easily] within hull data
;
; TODO: use https://6502disassembly.com/a2-elite/meshes.html as a reference
;
.struct Hull
        ;=======================================================================
        scoop_debris    .byte   ; nybbles; hi = scoop, lo = debris      ;+$00
        _0102           .word   ; "missile lock area"?                  ;+$01
        edge_data_lo    .byte   ; edge data offset, lo-byte             ;+$03
        face_data_lo    .byte   ; face data offset, lo-byte             ;+$04
        _05             .byte   ; max.lines                             ;+$05
        laser_vertex    .byte   ; which vertex the lasers come from     ;+$06
        _07             .byte   ; explosion count; 4*n +6               ;+$07
        vertex_count    .byte   ; vertices byte count                   ;+$08
        edge_count      .byte   ; edge count                            ;+$09
        bounty          .word   ; bounty (in 0.1 Cr units)              ;+$0A
        face_count      .byte   ; face count                            ;+$0C
        lod_distance    .byte   ; Level-Of-Detail distance              ;+$0D
        energy          .byte   ; hull-strength; energy                 ;+$0E
        speed           .byte   ; speed                                 ;+$0F
        edge_data_hi    .byte   ; edge data offset, hi-byte             ;+$10
        face_data_hi    .byte   ; face data offset, hi-byte             ;+$11
        _12             .byte   ; "scaling of normals"?                 ;+$12
        laser_missiles  .byte   ; laser-power & missile-count           ;+$13
.endstruct

;===============================================================================
.macro  .hull
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; note that the following local symbols must be defined:
;
;       scoop                   ; type of item when scooped, or 0=random
;       debris                  ; number of cannisters dropped on death
;       target_area             ; target area (squared), i.e. "40" = 40 * 40
;       edges_offset            ; 16-bit offset to the edge-list
;       faces_offset            ; 16-bit offset to the face-list
;       max_edges               ; max number of edges visible at once
;       laser_vertex            ; vertex number for the laser emitter
;       explosion_count 
;       vertex_bytes 
;       edge_count              ; number of edges
;       bounty
;       face_count             
;       lod_distance
;       max_energy
;       max_speed
;       normal_scaling
;       laser_power
;       missile_count
;
        .scoop_debris \
                scoop, debris
        .word   target_area * target_area
        .byte   < edges_offset
        .byte   < faces_offset
        .byte   .max_edges( max_edges )
        .byte   .laser_vertex( laser_vertex )
        .byte   .explosion_count( explosion_count )
        .byte   vertex_bytes
        .byte   .edge_count( edges_bytes )
        .word   bounty
        .byte   face_bytes
        .byte   lod_distance
        .byte   max_energy
        .byte   max_speed
        .byte   > edges_offset
        .byte   > faces_offset
        .byte   normal_scaling
        .byte   .laser_missiles( laser_power, missile_count )
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .scoop_debris   scoop, debris
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ; the scoop-data in a hull definition provides which cargo type it
        ; gives when scooped, already decremented by 1 to account for the
        ; non-zero check used when scooping. a side-effect of this is that
        ; it's not possible for a hull definition to drop food or textiles(?)
.if     (scoop = 0)
        ; when the scoop type is zero, it really means zero
        .byte   .nybl( debris, $0 )
.else
        ; anything else is a type of cargo
        .byte   .nybl( debris, scoop-1 )
.endif
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; given a number of edges, calculate the heap size needed for the lines
.define .max_edges(c)           ((c * .sizeof( HullEdge )) + 1)
; given the number of bytes for edge data, return the edge count
.define .edge_count(b)          (b / .sizeof( HullEdge ))
; given the number of bytes for face data, return the face count
.define .face_count(b)          (b / .sizeof( HullFace ))
; given a particle count, return the number of bytes of storage
.define .explosion_count(c)     ((c * 4) + 6)
; given a laser power and missile-count, return the 1-byte representation
.define .laser_missiles(l,m)    (l<<3 | m)
; given a vertex index from the hull, return the offset used during runtime;
; whilst vertices in the hull blueprint are 6 bytes, the transformed vertices
; during runtime are 4 bytes each
.define .laser_vertex(i)        (i * 4)