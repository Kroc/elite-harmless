; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "save_data.asm":
;
; a page is reserved for load/save operations
; TODO: can this be done away with (the disk drive already has a buffer)
;
.segment        "DISK_BUFFER"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.res            $0100

.segment        "SAVE_DATA"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; file-name?

_25a6:                                                                  ;$25A6
        .byte   $3a, $30, $2e,$45                       ;":0.E"?

; 85 bytes here get copied by `_DFAULT` to $0490..$04E4

_25aa:                                                                  ;$25AA
        .byte   $2e                                     ;"."?

; save data; length might be 97 bytes
;
_25ab:                                                                  ;$25AB
        .byte   $6a, $61, $6d, $65, $73, $6f, $6e       ;"jameson"?
_25b2:                                                                  ;$25B2
        .byte   $0d

.proc   _25b3                                                           ;$25B3
;-------------------------------------------------------------------------------
        
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $10, $0f, $11
        .byte   $00, $03, $1c, $0e, $00, $00, $0a, $00
        .byte   $11, $3a, $07, $09, $08, $00, $00, $00
        .byte   $00, $80

; checksum?

_25fd:                                                                  ;$25FD
        .byte   $00
_25fe:                                                                  ;$25FE
        .byte   $00
_25ff:                                                                  ;$25FF
        .byte   $00
.endproc

_25fd   := _25b3::_25fd
_25fe   := _25b3::_25fe
_25ff   := _25b3::_25ff


.segment        "SAVE_DEFAULT"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;$2600: unreferenced / unused data?

        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00
        
        .byte   $3a, $30, $2e  ;":0.E."?
        .byte   $45, $2e

; dummy/default save-data. this gets copied over the 'current'
; save data during game initialisation. length: 97 bytes
;
_2619:                                                                  ;$2619
        ; commander name
        .byte   $4a ,$41, $4d, $45, $53, $4f, $4e, $0d  ;"JAMESON"
        .byte   $00 ,$14, $ad
        
        ; galaxy seed -- see "elite.inc"
        .word   ELITE_SEED
        
        .dbyt   0, 1000         ; cash?
        .byte   $46             ; fuel?
        .byte   $00             ; unused?
        .byte   $00             ; number of current galaxy?
        .byte   $0f             ; front laser type
        .byte   $00             ; rear laser type
        .byte   $00             ; left laser type
        .byte   $00             ; right laser type
        .word   $00             ; additional mission data?
        .byte   $16
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $03             ; number of missiles?
        .byte   $00             ; legal status?
        .byte   $10             ; food available?
        .byte   $0f             ; textiles available?
        .byte   $11             ; radioactives available?
        .byte   $00             ; slaves available?
        .byte   $03             ; liquor available?
        .byte   $1c             ; luxuries available?
        .byte   $0e             ; narcotics available?
        .byte   $00             ; computers available?
        .byte   $00             ; machines available?
        .byte   $0a             ; alloys available?
        .byte   $00             ; firearms available?
        .byte   $11             ; furs available?
        .byte   $3a             ; minerals available?
        .byte   $07             ; gold available?
        .byte   $09             ; platinum available?
        .byte   $08             ; gems available?
        .byte   $00             ; alien goods available?
        .byte   $00             ; price factor?
        .word   $00             ; kills?
        
        .byte   $80
        .byte   $aa
        .byte   $27
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
_267e:                                                                  ;$267E
        .byte   $00, $ff, $ff, $aa, $aa, $aa, $55, $55
        .byte   $55, $aa, $aa, $aa, $aa, $aa, $aa, $55
        .byte   $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
        .byte   $aa, $aa, $aa, $aa, $aa, $5a, $aa, $aa
        .byte   $00, $aa, $00, $00, $00, $00