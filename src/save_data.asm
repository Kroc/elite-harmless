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
;
;             +----------+ >-------------------------------------------.
;       $25A6 | disk-cmd |                                             |
;             +----------+ <----------------------.      saved to <----+
;       $25AB | filename |                        |        disk        |
;             +----------+ >---.                  |                    |
;       $25B3 | SaveData |     |                  |                    |
;             |          |     +---- checksummed  +---- copied from    |
;             |          |     |         |        |       default      |
;             +----------+ >---'         |        |                    |
;       $25FD | checksum | <-------------'        |                    |
;             +----------+ <----------------------' >------------------'
;       $2600 | unused   |
;             +----------+
;
save_data:
;===============================================================================
save_prefix:                                                            ;$25A6
        .byte   $3a, $30, $2e, $45, $2e                 ;":0.E."
save_name:                                                              ;$25AB
        .byte   $6a, $61, $6d, $65, $73, $6f, $6e       ;"jameson"?
        .byte   $0d

; this is the checksummed-region
; that contains the actual game state:
;
.proc   checksum_data                                                   ;$25B3
;-------------------------------------------------------------------------------
        .byte   %00000000       ; MISSION_FLAGS
        .byte   0               ; PSYSTEM_POS_X
        .byte   0               ; PSYSTEM_POS_Y
        .word   $0000           ; SEED_GALAXY_W0
        .word   $0000           ; SEED_GALAXY_W1
        .word   $0000           ; SEED_GALAXY_W2
        .dword  $00000000       ; PLAYER_CASH
        .byte   0               ; PLAYER_FUEL
        .byte   %0000000        ; PLAYER_COMPETITION
        .byte   0               ; PLAYER_GALAXY
        .byte   0               ; PLAYER_LASER_FRONT
        .byte   0               ; PLAYER_LASER_REAR
        .byte   0               ; PLAYER_LASER_LEFT
        .byte   0               ; PLAYER_LASER_RIGHT
        .byte   0               ; "PLAYER_LASER_UP" (unused)
        .byte   0               ; "PLAYER_LASER_DOWN" (unused)
        .byte   0               ; SHIP_HOLD
        .byte   0               ; CARGO_FOOD
        .byte   0               ; CARGO_TEXTILES
        .byte   0               ; CARGO_RADIOACTIVES
        .byte   0               ; CARGO_SLAVES
        .byte   0               ; CARGO_ALCOHOL
        .byte   0               ; CARGO_LUXURIES
        .byte   0               ; CARGO_NARCOTICS
        .byte   0               ; CARGO_COMPUTERS
        .byte   0               ; CARGO_MACHINERY
        .byte   0               ; CARGO_ALLOYS
        .byte   0               ; CARGO_FIREARMS
        .byte   0               ; CARGO_FURS
        .byte   0               ; CARGO_MINERALS
        .byte   0               ; CARGO_GOLD
        .byte   0               ; CARGO_PLATINUM
        .byte   0               ; CARGO_GEMS
        .byte   0               ; CARGO_ALIENS
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
        .byte   0               ; PLAYER_MISSILES
        .byte   %00000000       ; PLAYER_LEGAL
        .byte   16              ; MAKRET_FOOD
        .byte   15              ; MARKET_TEXTILES
        .byte   17              ; MARKET_RADIOACTIVES
        .byte   0               ; MARKET_SLAVES
        .byte   3               ; MARKET_ALCOHOL
        .byte   28              ; MARKET_LUXURIES
        .byte   14              ; MARKET_NARCOTICS
        .byte   0               ; MARKET_COMPUTERS
        .byte   0               ; MARKET_MACHINERY
        .byte   10              ; MARKET_ALLOYS
        .byte   0               ; MARKET_FIREAMRS
        .byte   17              ; MARKET_FURS
        .byte   58              ; MARKET_MINERALS
        .byte   7               ; MARKET_GOLD
        .byte   9               ; MARKET_PLATINUM
        .byte   8               ; MARKET_GEMS
        .byte   0               ; MARKET_ALIENS
        .byte   0               ; MARKET_RANDOM
        .word   0               ; PLAYER_KILLS
.endproc

checksum_data_size = .sizeof( checksum_data )

;-------------------------------------------------------------------------------
        .byte   128             ; save-count?
checksum_bytes:                                                         ;$25FD
        .byte   $00             ; number of bytes checksummed?

; after death, the game state is reset from the last-saved state,
; from the file/player-name, down to just before the checksum bytes
; (these are not needed at runtime)
;
save_reset_size = * - save_name

; save checksum and verification bytes:
;-------------------------------------------------------------------------------
checksum2:                                              ; BBC: CHK2     ;$25FE
        .byte   $00
checksum1:                                              ; BBC: CHK      ;$25FF
        .byte   $00

save_data_size = * - save_data


.segment        "SAVE_DEFAULT"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; TODO: these should be part of SAVE_DATA above,
;       but should not factor into the size calculations
;
        .byte   $00, $00, $00, $00, $00, $00, $00, $00                  ;$2600
        .byte   $00, $00, $00, $00, $00, $00, $00, $00
        .byte   $00, $00, $00, $00

;===============================================================================
; this is the start of the default save block

        .byte   $3a, $30, $2e, $45, $2e         ;":0.E."

; dummy/default save-data. this gets copied over the 'current'
; save data during game initialisation. length: 97 bytes
;
default_name:                                                           ;$2619
;-------------------------------------------------------------------------------
        ; commander name
        .byte   $4a ,$41, $4d, $45, $53, $4f, $4e       ;"JAMESON"
        .byte   $0d

        .byte   %00000000       ; MISSION_FLAGS
        .byte   20              ; PSYSTEM_POS_X (Lave chart X-pos)
        .byte   173             ; PSYSTEM_POS_Y (Lave chart Y-pos)
        .word   ELITE_SEED      ; SEED_GALAXY -- see "elite.inc"
        .dbyt   0, 1000         ; PLAYER_CASH, "100.00 cr"
        .byte   70              ; PLAYER_FUEL, "7.0"
        .byte   %00000000       ; PLAYER_COMPETITON
        .byte   0               ; PLAYER_GALAXY
        .byte   15              ; PLAYER_LASER_FRONT
        .byte   0               ; PLAYER_LASER_REAR
        .byte   0               ; PLAYER_LASER_LEFT
        .byte   0               ; PLAYER_LASER_RIGHT
        .byte   0               ; "PLAYER_LASER_UP" (unused)
        .byte   0               ; "PLAYER_LASER_DOWN" (unused)
        .byte   22              ; SHIP_HOLD
        .byte   0               ; CARGO_FOOD
        .byte   0               ; CARGO_TEXTILES
        .byte   0               ; CARGO_RADIOACTIVES
        .byte   0               ; CARGO_SLAVES
        .byte   0               ; CARGO_ALCOHOL
        .byte   0               ; CARGO_LUXURIES
        .byte   0               ; CARGO_NARCOTICS
        .byte   0               ; CARGO_COMPUTERS
        .byte   0               ; CARGO_MACHINERY
        .byte   0               ; CARGO_ALLOYS
        .byte   0               ; CARGO_FIREARMS
        .byte   0               ; CARGO_FURS
        .byte   0               ; CARGO_MINERALS
        .byte   0               ; CARGO_GOLD
        .byte   0               ; CARGO_PLATINUM
        .byte   0               ; CARGO_GEMS
        .byte   0               ; CARGO_ALIENS
        .byte   0               ; PLAYER_ECM
        .byte   0               ; PLAYER_SCOOP
        .byte   0               ; PLAYER_EBOMB
        .byte   0               ; PLAYER_EUNIT
        .byte   0               ; PLAYER_DOCKCOM
        .byte   0               ; PLAYER_GDRIVE
        .byte   0               ; PLAYER_ESCAPEPOD
        .byte   0               ; (unused)
        .byte   0               ; (unused)
        .byte   0               ; (unused)
        .byte   0               ; PLAYER_KILLS_FRAC
        .byte   3               ; PLAYER_MISSILES
        .byte   %00000000       ; PLAYER_LEGAL
        .byte   16              ; MARKET_FOOD
        .byte   15              ; MARKET_TEXTILES
        .byte   17              ; MARKET_RADIOACTIVES
        .byte   0               ; MARKET_SLAVES
        .byte   3               ; MARKET_ALCOHOL
        .byte   28              ; MARKET_LUXURIES
        .byte   14              ; MARKET_NARCOTICS
        .byte   0               ; MARKET_COMPUTERS
        .byte   0               ; MARKET_MACHINERY
        .byte   10              ; MARKET_ALLOYS
        .byte   0               ; MARKET_FIREARMS
        .byte   17              ; MARKET_FURS
        .byte   58              ; MARKET_MINERALS
        .byte   7               ; MARKET_GOLD
        .byte   9               ; MARKET_PLATINUM
        .byte   8               ; MARKET_GEMS
        .byte   0               ; MARKET_ALIENS
        .byte   0               ; MARKET_RANDOM
        .word   0               ; PLAYER_KILLS

        .byte   128             ; save count?
        .byte   $aa             ; CHK2?
        .byte   $27             ; CHK?

        .byte   3               ;?

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


; NOTE: in the original code, segment "CODE_267E" appears here          ;$267E