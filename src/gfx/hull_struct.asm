; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/elite-harmless>
;===============================================================================

; "hull_struct.asm" -- we cannot export structures, so we need to include this
; file when we want to refer to the bytes [easily] within hull data

.struct         Hull
        _00             .byte   ; "scoop / debris"?                     ;+$00
        _0102           .word   ; "missile lock area"?                  ;+$01
        edge_data_lo    .byte   ; edge data offset lo-byte              ;+$03
        face_data_lo    .byte   ; face data offset lo-byte              ;+$04
        _05             .byte   ; max.lines                             ;+$05
        _06             .byte   ; "gun vertex"                          ;+$06
        _07             .byte   ; "explosion count"?                    ;+$07
        _08             .byte   ; verticies byte count                  ;+$08
        edge_count      .byte   ; edge count                            ;+$09
        bounty          .word   ; bounty                                ;+$0A
        face_count      .byte   ; face count                            ;+$0C
        _0d             .byte   ; Level-Of-Detail distance              ;+$0D
        energy          .byte   ; energy                                ;+$0E
        speed           .byte   ; speed                                 ;+$0F
        edge_data_hi    .byte   ; edge data offset hi-byte              ;+$10
        face_data_hi    .byte   ; face data offset hi-byte              ;+$11
        _12             .byte   ; "scaling of normals"?                 ;+$12
        _13             .byte   ; "laser / missile count"?              ;+$13
.endstruct