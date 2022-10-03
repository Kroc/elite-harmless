; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2022,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "DISK_BUFFER"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; a page is reserved for load/save operations
.res            $0100

.segment        "SAVE_DATA"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; file-name?

_25a6:                                                                  ;$25A6
        .byte   $3a, $30, $2e, $45, $2e                 ;":0.E."

; save data; length might be 97 bytes
;
_25ab:                                                                  ;$25AB
        .byte   $6a, $61, $6d, $65, $73, $6f, $6e       ;"jameson"?
        .byte   $0d

.proc   _25b3                                                           ;$25B3
;-------------------------------------------------------------------------------
        .byte   $00             ; MISSION_FLAGS
        .byte   $00             ; PSYSTEM_POS_X
        .byte   $00             ; PSYSTEM_POS_Y
        .word   $0000           ; SEED_GALAXY_W0
        .word   $0000           ; SEED_GALAXY_W1
        .word   $0000           ; SEED_GALAXY_W2
        .dword  $00000000       ; PLAYER_CASH
        .byte   $00             ; PLAYER_FUEL
        .byte   $00             ; PLAYER_COMPETITION
        .byte   $00             ; PLAYER_GALAXY
        .byte   $00             ; PLAYER_LASER_FRONT
        .byte   $00             ; PLAYER_LASER_REAR
        .byte   $00             ; PLAYER_LASER_LEFT
        .byte   $00             ; PLAYER_LASER_RIGHT
        .byte   $00             ; "PLAYER_LASER_UP" (unused)
        .byte   $00             ; "PLAYER_LASER_DOWN" (unused)
        .byte   $00             ; SHIP_HOLD
        .byte   $00             ; CARGO_FOOD
        .byte   $00             ; CARGO_TEXTILES
        .byte   $00             ; CARGO_RADIOACTIVES
        .byte   $00             ; CARGO_SLAVES
        .byte   $00             ; CARGO_ALCOHOL
        .byte   $00             ; CARGO_LUXURIES
        .byte   $00             ; CARGO_NARCOTICS
        .byte   $00             ; CARGO_COMPUTERS
        .byte   $00             ; CARGO_MACHINERY
        .byte   $00             ; CARGO_ALLOYS
        .byte   $00             ; CARGO_FIREARMS
        .byte   $00             ; CARGO_FURS
        .byte   $00             ; CARGO_MINERALS
        .byte   $00             ; CARGO_GOLD
        .byte   $00             ; CARGO_PLATINUM
        .byte   $00             ; CARGO_GEMS
        .byte   $00             ; CARGO_ALIENS
        .byte   $00             ; PLAYER_ECM
        .byte   $00             ; PLAYER_SCOOP
        .byte   $00             ; PLAYER_EBOMB
        .byte   $00             ; PLAYER_EUNIT
        .byte   $00             ; PLAYER_DOCKCOM
        .byte   $00             ; PLAYER_GDRIVE
        .byte   $00             ; PLAYER_ESCAPEPOD
        .byte   $00             ; (unused)
        .byte   $00             ; (unused)
        .byte   $00             ; (unused)
        .byte   $00             ; PLAYER_KILLS_FRAC
        .byte   $00             ; PLAYER_MISSILES
        .byte   $00             ; PLAYER_LEGAL
        .byte   $10             ; MAKRET_FOOD
        .byte   $0f             ; MARKET_TEXTILES
        .byte   $11             ; MARKET_RADIOACTIVES
        .byte   $00             ; MARKET_SLAVES
        .byte   $03             ; MARKET_ALCOHOL
        .byte   $1c             ; MARKET_LUXURIES
        .byte   $0e             ; MARKET_NARCOTICS
        .byte   $00             ; MARKET_COMPUTERS
        .byte   $00             ; MARKET_MACHINERY
        .byte   $0A             ; MARKET_ALLOYS
        .byte   $00             ; MARKET_FIREAMRS
        .byte   $11             ; MARKET_FURS
        .byte   $3a             ; MARKET_MINERALS
        .byte   $07             ; MARKET_GOLD
        .byte   $09             ; MARKET_PLATINUM
        .byte   $08             ; MARKET_GEMS
        .byte   $00             ; MARKET_ALIENS
        .byte   $00             ; MARKET_RANDOM
        .word   $0000           ; PLAYER_KILLS

        .byte   $80             ; save-count?

; checksum?

_25fd:                                                                  ;$25FD
        .byte   $00             ; block size
_25fe:                                                                  ;$25FE
        .byte   $00             ; CHK2
_25ff:                                                                  ;$25FF
        .byte   $00             ; CHK
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

;===============================================================================
; this is the start of the default save block

        .byte   $3a, $30, $2e, $45, $2e         ;":0.E."

; dummy/default save-data. this gets copied over the 'current'
; save data during game initialisation. length: 97 bytes
;
_2619:                                                                  ;$2619
        ; commander name
        .byte   $4a ,$41, $4d, $45, $53, $4f, $4e       ;"JAMESON"
        .byte   $0d

        .byte   %00000000       ; MISSION_FLAGS
        .byte   20              ; PSYSTEM_POS_X (Lave chart X-pos)
        .byte   173             ; PSYSTEM_POS_Y (Lave chart Y-pos)
        .word   ELITE_SEED      ; SEED_GALAXY -- see "elite.inc"
        .dbyt   0, 1000         ; PLAYER_CASH, "100.00 cr"
        .byte   70              ; PLAYER_FUEL, "7.0"
        .byte   $00             ; PLAYER_COMPETITON
        .byte   $00             ; PLAYER_GALAXY
        .byte   15              ; PLAYER_LASER_FRONT
        .byte   $00             ; PLAYER_LASER_REAR
        .byte   $00             ; PLAYER_LASER_LEFT
        .byte   $00             ; PLAYER_LASER_RIGHT
        .byte   $00             ; "PLAYER_LASER_UP" (unused)
        .byte   $00             ; "PLAYER_LASER_DOWN" (unused)
        .byte   22              ; SHIP_HOLD
        .byte   $00             ; CARGO_FOOD
        .byte   $00             ; CARGO_TEXTILES
        .byte   $00             ; CARGO_RADIOACTIVES
        .byte   $00             ; CARGO_SLAVES
        .byte   $00             ; CARGO_ALCOHOL
        .byte   $00             ; CARGO_LUXURIES
        .byte   $00             ; CARGO_NARCOTICS
        .byte   $00             ; CARGO_COMPUTERS
        .byte   $00             ; CARGO_MACHINERY
        .byte   $00             ; CARGO_ALLOYS
        .byte   $00             ; CARGO_FIREARMS
        .byte   $00             ; CARGO_FURS
        .byte   $00             ; CARGO_MINERALS
        .byte   $00             ; CARGO_GOLD
        .byte   $00             ; CARGO_PLATINUM
        .byte   $00             ; CARGO_GEMS
        .byte   $00             ; CARGO_ALIENS
        .byte   $00             ; PLAYER_ECM
        .byte   $00             ; PLAYER_SCOOP
        .byte   $00             ; PLAYER_EBOMB
        .byte   $00             ; PLAYER_EUNIT
        .byte   $00             ; PLAYER_DOCKCOM
        .byte   $00             ; PLAYER_GDRIVE
        .byte   $00             ; PLAYER_ESCAPEPOD
        .byte   $00             ; (unused)
        .byte   $00             ; (unused)
        .byte   $00             ; (unused)
        .byte   $00             ; PLAYER_KILLS_FRAC
        .byte   3               ; PLAYER_MISSILES
        .byte   $00             ; PLAYER_LEGAL
        .byte   $10             ; MARKET_FOOD
        .byte   $0f             ; MARKET_TEXTILES
        .byte   $11             ; MARKET_RADIOACTIVES
        .byte   $00             ; MARKET_SLAVES
        .byte   $03             ; MARKET_ALCOHOL
        .byte   $1c             ; MARKET_LUXURIES
        .byte   $0e             ; MARKET_NARCOTICS
        .byte   $00             ; MARKET_COMPUTERS
        .byte   $00             ; MARKET_MACHINERY
        .byte   $0a             ; MARKET_ALLOYS
        .byte   $00             ; MARKET_FIREARMS
        .byte   $11             ; MARKET_FURS
        .byte   $3a             ; MARKET_MINERALS
        .byte   $07             ; MARKET_GOLD
        .byte   $09             ; MARKET_PLATINUM
        .byte   $08             ; MARKET_GEMS
        .byte   $00             ; MARKET_ALIENS
        .byte   $00             ; MARKET_RANDOM
        .word   $00             ; PLAYER_KILLS

        .byte   $80             ; save count?
        .byte   $aa             ; CHK2?
        .byte   $27             ; CHK?

        .byte   $03             ;?

        .byte   $00             ; 16 unused bytes, same as BBC
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

        ; colour of ships on scanner?
        ; bitmask for multi-colour pixels?
_267e:                                                                  ;$267E
        .byte   $00, $ff, $ff, $aa, $aa, $aa, $55, $55
        .byte   $55, $aa, $aa, $aa, $aa, $aa, $aa, $55
        .byte   $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
        .byte   $aa, $aa, $aa, $aa, $aa, $5a, $aa, $aa
        .byte   $00, $aa, $00, $00, $00, $00