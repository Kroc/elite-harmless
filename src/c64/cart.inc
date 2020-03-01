; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================
.linecont+

CART_ROML       = $8000         ; lower region of memory for cart ROM (8K)
CART_ROMH       = $A000         ; upper region of memory for cart ROM (8K)
CART_ULTIMAX    = $E000         ; a mode where the cart ROM replaces KERNAL

.enum   CART_TYPE
        ; type                  ; ID    ; EXROM GAME SIZE     LOAD    BANKS
        NORMAL                  = 0     ; 0     1    4-16K    $8000   -
        ACTION_REPLAY           = 1     ; 0     1    32K      $8000   4 * 8K
        KCS_POWER               = 2     ; 0     0    16K      $A000   2 * 8K
        FINAL_CARTRIDGE_III     = 3     ; 1     1    64K      $8000   4 * 16K
        SIMONS_BASIC            = 4     ; 0     1    16K      $8000   2 * 8K
        OCEAN                   = 5     ; 0     0    32-256K  $8000  32 * 8K
                                        ; 0     1    512K     $8000  64 * 8K
        EXPERT                  = 6     ; 1     0    8K       $8000  -
        FUN_PLAY_POWER_PLAY     = 7     ; 0     1    128K     $8000  16 * 8K
        SUPER_GAMES             = 8     ; 0     0    64K      $8000  4 * 16K
        ATOMIC_POWER            = 9     ;
        EPYX_FASTLOAD           = 10    ;
        WESTERMANN_LEARNING     = 11    ;
        REX_UTILITY             = 12    ;
        FINAL_CARTRIDGE_I       = 13    ;
        MAGIC_FORMEL            = 14    ;
        C64_GAME_SYSTEM         = 15    ;
        WARP_SPEED              = 16    ;
        DINAMIC                 = 17    ;
        ZAXXON                  = 18    ;
        MAGIC_DESK              = 19    ;
        SUPER_SNAPSHOT_V5       = 20    ;
        COMAL_80                = 21    ;
        STRUCTURED_BASIC        = 22    ;
        ROSS                    = 23    ;
.endenum

; inserts a cartridge header. you will have to have already
; set the desired segment as this will not force one on you
; 
.macro  .cart_header    type,   EXROM,  GAME,   name
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.if     .blank(type)
        .fatal  "Cartridge header requires a cartridge type."
.endif
.if     .blank(EXROM)
        .fatal  "EXROM must be specified, even if it is 0."
.endif
.if     .blank(GAME)
        .fatal  "GAME must be specified, even if it is 0."
.endif
.if     .blank(name)
        .fatal  "Cartridge name must be specified."
.endif

.byte   "c64 cartridge   "      ; 16-byte cartridge signature
.byte   $00, $00, $00, $40      ; header-length (4-bytes)
.byte   $01, 00                 ; CRT file-format version "1.0"
.dbyt   type                    ; cartridge type (as given)
.byte   EXROM                   ; EXROM line; 0 = active, 1 = inactive
.byte   GAME                    ; GAME line;  0 = active, 1 = inactive
.res    6, $00                  ; $1A...$1F reserved

.byte   name
.if     .strlen(name) < 32
.res    32 - .strlen(name), $00
.endif

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

; inserts a cartridge "CHIP" header that describes a bank of ROM or RAM
; on the cartridge. one of these is required before each bank in the file
;
.macro  .chip_header    size,   type,   bank,   load
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.if     .blank(size)
        .fatal  "CHIP size is required, it should be $2000 or $4000."
.endif
.if     .blank(type)
        .fatal  .conact( \
                "CHIP type is required, it should be 0 for ROM, ", \
                "1 for RAM and 2 for Flash." \
        )
.endif
.if     .blank(bank)
        .fatal  "CHIP bank number is required. Typically 0 to 63."
.endif
.if     .blank(load)
        .fatal  .concat( \
                "CHIP load-address is required. ", \
                "This should be $8000, $A000 or $E000." \
        )
.endif

.byte   "chip"                  ; CHIP header signature
.dbyt   $0000, size + $10       ; size of packet, including header
.dbyt   type                    ; 0 = ROM, 1 = RAM, 2 = FLASH
.dbyt   bank                    ; bank number
.dbyt   load                    ; intended load address
.dbyt   size                    ; size of data (excluding header)

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro