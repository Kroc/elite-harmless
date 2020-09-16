; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; "hull_struct.inc" -- we cannot export structures, so we need to include
; this file when we want to refer to the bytes [easily] within hull data

; TODO: use https://6502disassembly.com/a2-elite/meshes.html as a reference

.struct Hull
        ;=======================================================================
        scoop_debris    .byte   ; nybbles; hi = scoop, lo = debris      ;+$00
        _0102           .word   ; "missile lock area"?                  ;+$01
        edge_data_lo    .byte   ; edge data offset, lo-byte             ;+$03
        face_data_lo    .byte   ; face data offset, lo-byte             ;+$04
        _05             .byte   ; max.lines                             ;+$05
        _06             .byte   ; "gun vertex"                          ;+$06
        _07             .byte   ; explosion count; 4*n +6               ;+$07
        _08             .byte   ; verticies byte count                  ;+$08
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