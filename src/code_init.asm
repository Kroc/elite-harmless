; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; once-off intialisation code for elite-harmless; original Elite uses
; "orig_init.asm". this code is loaded into the variable space the game
; uses, so once executed it is erased!

.zeropage

ZP_COPY_TO      := $18
ZP_COPY_TO_LO   := $18
ZP_COPY_TO_HI   := $19
ZP_COPY_FROM    := $1a
ZP_COPY_FROM_LO := $1a
ZP_COPY_FROM_HI := $1b

.segment        "CODE_INIT"

init:
        ; change the address of STOP key routine from $F6ED, to $FFED,
        ; the SCREEN routine which returns row/col count, i.e. does
        ; nothing of use -- this effectively disables the STOP key
        lda #> KERNAL_SCREEN
        sta KERNAL_VECTOR_STOP + 1

        ; disable interrupts:
        ; (we'll be configuring screen & sprites)
        sei 
        
        ; black screen:
        lda # BLACK
        sta VIC_BORDER          ; set border colour black
        sta VIC_BACKGROUND      ; set background colour black

        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; it is assumed that the memory map is default, i.e. BASIC & KERNAL
        ; are currently switched on, so stepping down twice will switch from
        ; BASIC+KERNAL+I/O to KERNAL+I/O, and then to I/O only
        ;
        dec CPU_CONTROL         ; turn off BASIC ROM
        dec CPU_CONTROL         ; turn off KERNAL ROM, leaving I/O

        lda CIA2_PORTA_DDR      ; read Port A ($DD00) data-direction register
        ora # %00000011         ; set bits 0/1 to R+W, all others read-only
        sta CIA2_PORTA_DDR

        ; set the VIC-II bank:
        ;
        ; the VIC-II video chip itself can only reference 16 KB of RAM and not
        ; the full 64 KB of the C64 at once. you must select the 16 KB slice
        ; (known as a "bank") for the VIC-II to use
        ;
        ;       $FFFF +--------+--------+ <-- hardware vectors: $FFFA-$FFFF
        ;             |        | KERNAL |
        ;             | BANK 3 ¦--------+
        ;             |        |   I/O  |
        ;       $C000 +--------+--------+
        ;             |        |  BASIC |
        ;             | BANK 2 ¦--------+
        ;             |        |
        ;       $8000 +--------+
        ;             |        |
        ;             | BANK 1 |
        ;             |        |
        ;       $4000 +--------+
        ;             |        |
        ;             | BANK 0 |
        ;             |        | <-- stack: $0100-$01FF
        ;       $0000 +--------+ <-- zero page: $00-$FF
        ;
        ; the lower two-bits of register $DD00 selects the VIC-II bank.
        ; (the binary value is inverted compared to the canonical bank
        ;  numbers and you should retain the top 6 bits)
        ;
        lda CIA2_PORTA          ; read the serial bus / VIC-II bank state
        and # %11111100         ; keep current value except bits 0-1 (VIC bank)

        ; set the bits according to the bank defined by the linker script,
        ; e.g. "link/elite-harmless-d64.cfg", and imported by "elite.inc"
        ora # .vic_bank_bits( ELITE_VIC_BANK )
        sta CIA2_PORTA

        ; enable interrupts and non-maskable interrupts generated by the A/B
        ; system timers. the bottom two bits control CIA timers A & B, and
        ; writes to $DC0D control normal interrupts, and writes to $DD0D
        ; control non-maskable interrupts
        lda # CIA::TIMER_A | CIA::TIMER_B        ;=%00000011
        sta CIA1_INTERRUPT      ; interrupt control / status register
        sta CIA2_INTERRUPT      ; non-maskable interrupt register

        ; set up VIC-II memory:
        ;
        ; the VIC-II register $D018 (here, `VIC_MEMORY`) controls the relative
        ; locations of the screen, character map and bitmap screen within the
        ; selected VIC-II bank. "elite.inc" takes the memory addresses defined
        ; by the linker script ("link/elite-*.cfg") and puts together a $D018
        ; value that selects the chosen screen & bitmap locations
        ;
        lda # ELITE_VIC_MEMORY_MENUSCR
        sta VIC_MEMORY

        ; clear the screen
        ;=======================================================================
        ; NOTE: if VIC bank #3 is being used, the screens will be under the I/O
        ; shield! make sure to turn off I/O before trying to write to $D000+
        ;
        dec CPU_CONTROL         ; disable I/O
       
        ; set the screen-colours for the menu-screen:
        ; (high-resolution section only, no HUD)
        ;-----------------------------------------------------------------------
        lda #< ELITE_MENUSCR_ADDR
        sta ZP_COPY_TO_LO
        lda #> ELITE_MENUSCR_ADDR
        sta ZP_COPY_TO_HI

        ldx # 25                ; 25-rows

        ; colour the borders yellow down the sides of the view-port:
@menu:  lda # .color_nybble( YELLOW, BLACK )
        ldy # 36                ; set the colour on column 37
        sta [ZP_COPY_TO], y
        ldy # 3                 ; set the colour on column 4
        sta [ZP_COPY_TO], y
        dey

        ; colour the area outside the viewport black
        lda # .color_nybble( BLACK, BLACK )
:       sta [ZP_COPY_TO], y     ; set columns 2, 1 & 0 to black
        dey 
        bpl :-

        ldy # 37                ; begin at column 38
        sta [ZP_COPY_TO], y     ; set column 38 black
        iny 
        sta [ZP_COPY_TO], y     ; and column 39
        iny 
        sta [ZP_COPY_TO], y     ; and column 40

        ; move to the next row
        ; (add 40 columns)
        lda ZP_COPY_TO_LO
        clc 
        adc # 40
        sta ZP_COPY_TO_LO
        bcc :+
        inc ZP_COPY_TO_HI
:       dex                     ; repeat for 25 rows
        bne @menu

        ; set yellow colour across the bottom row of the menu-screen
        lda # .color_nybble( YELLOW, BLACK )
        ldy # ELITE_VIEWPORT_COLS - 1
:       sta ELITE_MENUSCR_ADDR + .scrpos( 24, 4 ), y
        dey 
        bpl :-

        ; re-enable the I/O shield
        ; to manage colour-RAM & sprites
        inc CPU_CONTROL
        
        ; upload the colour RAM from the initialisation data:
        ;-----------------------------------------------------------------------
        ; number of pages to copy; even though colour RAM is 1'000 bytes,
        ; we'll copy 1'024 to make this loop easier to write (whole pages)
        ldx # .page_count( 1000 )
        ldy # $00
        ; copy one-byte of colour RAM over
@from:  lda gfx_colorram_init, y
@to:    sta $D800, y
        dey 
        bne @from               ; keep copying page?

        ; page has been copied, move to the next page
        inc @from+2
        inc @to  +2
        ; all pages copied?
        dex 
        bne @from

        ; sprites:
        ;=======================================================================
        ; disable all sprites
        lda # %00000000
        sta VIC_SPRITE_ENABLE

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; set sprite 3 colour to medium-grey
        lda # GREY
        sta VIC_SPRITE3_COLOR
        ; set sprite 4 colour to blue
        lda # BLUE
        sta VIC_SPRITE4_COLOR
        ; set sprite 5 colour to white
        lda # WHITE
        sta VIC_SPRITE5_COLOR
        ; set sprite 6 colour to green
        lda # GREEN
        sta VIC_SPRITE6_COLOR
        ; set sprite 7 colour to brown
        lda # BROWN
        sta VIC_SPRITE7_COLOR
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set sprite 2 colour to brown
        ; (this is the explosion sprite)
        lda # BROWN
        sta VIC_SPRITE2_COLOR
        ; extra colours for the explosion sprite:
        ; set sprite multi-colour 1 to orange
        lda # ORANGE
        sta VIC_SPRITE_EXTRA1
        ; set sprite multi-colour 2 to yellow
        lda # YELLOW
        sta VIC_SPRITE_EXTRA2

        ; set all sprites to single-colour
        ; (the Trumbles™ are actually multi-colour,
        ;  so this must be changed at some point)
        lda # %00000000
        sta VIC_SPRITE_MULTICOLOR

        ; set all sprites to double-width, double-height
        lda # %11111111
        sta VIC_SPRITE_DBLHEIGHT
        sta VIC_SPRITE_DBLWIDTH

        ; set sprites' X 8th bit to 0;
        ; i.e all X-positions are < 256
        lda # $00
        sta VIC_SPRITES_X

        ; roughly centre sprite 0 (crosshair) on screen
        ; TODO: base these values on ELITE_VIEWPORT_*
        ldx # 161
        ldy # 101
        stx VIC_SPRITE0_X
        sty VIC_SPRITE0_Y
        
        ; setup (but don't display) the Trumbles™
        lda # 18
        ldy # 12
        sta VIC_SPRITE1_X
        sty VIC_SPRITE1_Y

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        asl                     ; double x-position (=36)
        sta VIC_SPRITE2_X
        sty VIC_SPRITE2_Y
        asl                     ; double x-position (=72)
        sta VIC_SPRITE3_X
        sty VIC_SPRITE3_Y
        asl                     ; double x-position (=144)
        sta VIC_SPRITE4_X
        sty VIC_SPRITE4_Y
        lda # 14
        sta VIC_SPRITE5_X
        sty VIC_SPRITE5_Y
        asl                     ; double x-position (=28)
        sta VIC_SPRITE6_X
        sty VIC_SPRITE6_Y
        asl                     ; double x-position (=56)
        sta VIC_SPRITE7_X
        sty VIC_SPRITE7_Y
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set sprite priority:
        ; only sprite 1 (explosion) is behind screen
        lda # %0000010
        sta VIC_SPRITE_PRIORITY

        ; sprite indicies:
        ; (crosshair)
        lda # ELITE_SPRITES_INDEX + 0
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE0_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE0_PTR
        ; (explosion)
        lda # ELITE_SPRITES_INDEX + 4
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE1_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE1_PTR

.ifndef OPTION_NOTRUMBLES
        ;///////////////////////////////////////////////////////////////////////
        ; each of the Trumbles™ alternate patterns
        lda # ELITE_SPRITES_INDEX + 5
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE2_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE2_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE4_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE4_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE6_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE6_PTR
        lda # ELITE_SPRITES_INDEX + 6
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE3_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE3_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE5_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE5_PTR
        sta ELITE_MENUSCR_ADDR + VIC_SPRITE7_PTR
        sta ELITE_MAINSCR_ADDR + VIC_SPRITE7_PTR
.endif  ;///////////////////////////////////////////////////////////////////////

.ifdef  OPTION_MATHTABLES
        ;///////////////////////////////////////////////////////////////////////
        ; if we're including the math lookup tables for faster multiplication,
        ; then -- for the disk versions of the game -- we will populate the
        ; table data at runtime rather than including the tables on the disk
        ; so as to decrease the disk-file size and therefore load-times
        ;
        ; "math_data.asm" defines the segments for the lookup tables, but also
        ; appends a routine to the end of our current segement which we can
        ; call to populate the 2 KB of lookup tables
        ; 
        jsr populate_multiply_tables

.endif  ;///////////////////////////////////////////////////////////////////////

        ; turn the screen on:
        ;-----------------------------------------------------------------------
        ; - bit 0-2: horizontal scroll (0)
        ; - bit   3: 38 columns (borders inset)
        ; - bit   4: multi-color mode off
        ;
        lda # %11000000         ; undocumented bits? default?
        sta VIC_SCREEN_CTL2
        
        ; set up the bitmap screen:
        ;
        ; - bit 0-2: vertical scroll offset (set to 3, why?)
        ; - bit   3: 1 = 25 rows
        ; - bit   4: 1 = screen on
        ; - bit   5: 1 = bitmap mode on
        ; - bit 6-7: 0 = extended mode off / raster interrupt off
        ;
        lda # 3 | vic_screen_ctl1::rows \
                | vic_screen_ctl1::display \
                | vic_screen_ctl1::bitmap
        sta VIC_SCREEN_CTL1

        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the KERNAL is currently off, so stepping up
        ; once will switch from I/O only to KERNAL+I/O
        ;
        inc CPU_CONTROL

        ;-----------------------------------------------------------------------        
        ; NOTE: calling `init_mem` clears variable storage from $0400..$0700
        ; *THIS VERY CODE IS WITHIN THAT REGION* -- ergo, we cannot return
        ; from a subroutine here but we will still need to send execution to
        ; `_8863` after clearing variable storage. we do this by pushing the
        ; address we want to jump to (`_8863`) on to the stack and then jump
        ; (*NOT* `jsr`) to the subroutine. when it hits `rts`, execution will
        ; move to the address we inserted into the stack!
        ;
        lda #> (_8863 - 1)
        pha 
        lda #< (_8863 - 1)
        pha 

        cli                     ; enable interrupts
        jmp init_mem
