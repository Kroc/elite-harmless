; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; this table contains the state-switches for the raster-splits, that is, what
; properties of the VIC-II to change at the first split (bitmap line 1), then
; the second split (bitmap line 145), the HUD. for example, the top-border on
; the screen is multi-colour and switches to hires, then multi-colour is
; re-enabled for the HUD
;
interrupt_split:                                                        ;$A8D9
;-------------------------------------------------------------------------------
        .byte   $00

; VIC-II memory layout state for each raster-split:
;-------------------------------------------------------------------------------
interrupt_layout:
interrupt_layout1:                                                      ;$A8DA
        .byte   ELITE_VIC_LAYOUT_MENUSCR
interrupt_layout2:                                                      ;$A8DB
        .byte   ELITE_VIC_LAYOUT_MENUSCR

; this is a toggle for `interrupt_split`
_a8dc:                                                                  ;$A8DC
        .byte   $01, $00

; the location of raster-splits:
;-------------------------------------------------------------------------------
; note that because these are used to set up the *next* raster-split,
; they are effectively in reverse order, starting with the HUD split first
;
interrupt_scanline:                                                     ;$A8DE
interrupt_scanline1:
        ; top of screen, plus height of viewport
        .byte   51 + ELITE_VIEWPORT_HEIGHT-1
interrupt_scanline2:
        ; scanline 51, 2nd pixel row in screen
        ; i.e. changes after the yellow border at the top
        .byte   51

; hires/multi-colour bitmap state for each raster-split:
;-------------------------------------------------------------------------------
; (note that these are `VIC_SCREEN_CTL2` states, see "c64/vic.inc" for details)
interrupt_screenmode:
interrupt_screenmode1:                                                  ;$A8E0
        .byte   vic_screen_ctl2::unused
interrupt_screenmode2:                                                  ;$A8E1
        .byte   vic_screen_ctl2::unused

; sprite multi-colour state for each raster-split:
;-------------------------------------------------------------------------------
; these are used to turn on/off sprite multi-colour at the raster-splits;
; note how the Trumbles™ (bits 7-2) remain multi-colour but the explosion
; sprite, for unknown reasons, is switched from multi-colour to single-colour
;
; (these are `VIC_SPRITE_MULTICOLOR` states, 1 bit for each sprite)
_a8e2:                                                                  ;$A8E2
        .byte   %11111110
        .byte   %11111100

; these are `VIC_SPRITE1_COLOR` states
_a8e4:                                                                  ;$A8E4
        .byte   RED
        .byte   BLACK

_a8e6:                                                                  ;$A8E6
        .byte   $00
        .byte   $00

_a8e8:                                                                  ;$A8E8
;===============================================================================
        dey 
        bpl _a958

       .ply                     ; restore Y (via A)
                                ; (note fall-through to below)

interrupt_end_XA:                                                       ;$A8ED
;===============================================================================
; interrupt finished! restores X & A
;
       .plx                     ; restore X (via A)

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla 
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL         ; restore the memory map

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"


interrupt:                                                              ;$A8FA
;===============================================================================
; this is Elite's main interrupt routine
;
; note that this routine gets called by both raster splits,
; so functionality for both is combined into the one routine
;-------------------------------------------------------------------------------
        pha                     ; preserve A

        ; the current memory map (BASIC, KERNAL, and/or I/O) could be anything
        ; when this interrupt occurs; for the purposes of the interrupt routine
        ; we want to have the ROMs off and I/O on
        ;
        ; in the original Elite code, changing the memory map is handled by
        ; a central routine `set_memory_layout` which keeps a record of the
        ; "current" state. assuming that this routine is *always* used when
        ; changing the memory map, the interrupt routine can restore the
        ; previous state
        ;
        lda CPU_CONTROL         ; read current memory map

.ifndef OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless, we use an optimisation technique described by
        ; Gregory Naçu in his article "The 6510 Processor Port":
        ; <http://www.c64os.com/post?p=83>
        ;
        ; this method removes the need to store extra state, doesn't require
        ; an expensive subroutine and doesn't even use any registers(!) but
        ; it does mean we have to be very, very careful that before we change
        ; it, the memory map is guaranteed to be an expected value every time
        ; (otherwise the machine usually crashes hard)
        ;
        ; the interrupt routine complicates this as we cannot guarantee that
        ; the memory map will be a certain value any time the interrupt occurs.
        ; nested interrupts (when an interrupt interrupts an interrupt) need to
        ; be handled too, so whilst the original code 'knows' what memory map
        ; to return to, elite-harmless pushes the current value to the stack
        ; during the interrupt. whilst this adds 3 cycles to the initialisation
        ; it does greatly reduce the cleanup at the end -- a simple pull and
        ; set (7 cycles) does everything, without needing to `lda, and, ora`
        ; first and then set (12 cycles)
        ;
        pha                     ; push current memory-map value on stack
.endif  ;///////////////////////////////////////////////////////////////////////
        and # %11111000         ; mask out current value in the memory map bits
        ora # C64_MEM::IO_ONLY  ; set I/O on, ROMs off
        sta CPU_CONTROL         ; make it so!

        ; acknowledge the interrupt?
        lda VIC_INTERRUPT_STATUS
        ora # %10000000
        sta VIC_INTERRUPT_STATUS

       .phx                     ; push X to stack (via A)

        ; load the toggle-state; this value flips between 0 & 1 for the two
        ; raster splits and is used as an index for what VIC states to set
        ; at each split
        ldx interrupt_split

        ; change the VIC memory layout for the current split. this is used to
        ; switch between the two text-screens that hold colour data used for
        ; the main flight screen (includes HUD) and menu screens (no HUD)
        lda interrupt_layout, x
        sta VIC_LAYOUT

        ; set screen properties for the split,
        ; i.e. dis/enabling multi-colour bitmap mode
        lda interrupt_screenmode1, x
        sta VIC_SCREEN_CTL2

        ; set the next raster-split line
        lda interrupt_scanline, x
        sta VIC_RASTER

        ; dis/enable sprite multi-colour mode
        lda _a8e2, x
        sta VIC_SPRITE_MULTICOLOR

        ; change the sprite colour
        lda _a8e4, x
        sta VIC_SPRITE1_COLOR

        ; flash screen with e-bomb explosion?
        bit PLAYER_EBOMB
        bpl :+
        inc _a8e6           ; only the viewport-bgcolor is changed
:       lda _a8e6, x                                                    ;$A936
        sta VIC_BACKGROUND

        ; fetch the next interrupt index (currently 0->1->0...)
        ; this toggles the interrupt index in the same frame.
        lda _a8dc, x
        sta interrupt_split

        ; exit when this is not the last interrupt of this frame
        ; (the interrupt directly before the HUD, so the next index is zero)
        ;  everything that follows shall only be done 1x per frame
       .bnz interrupt_end_XA

        ;-----------------------------------------------------------------------
        ; push Y to stack (via A). from this point we must restore Y before
        ; ending the interrupt, so a different exit point is used than the
        ; one above
       .phy

.ifndef OPTION_NOSOUND
        ;///////////////////////////////////////////////////////////////////////
        bit flag_music_playing  ; is music currently playing?
        bpl @play_sfx           ; no, skip ahead to SFX

        jsr _b4d2               ; handle music?

        bit opt_sfx             ; sound effects enabled?
        bmi @play_sfx           ; yes, do SFX
.endif  ;///////////////////////////////////////////////////////////////////////

        ; end the interrupt, but Y & X have been
        ; used so must be restored first
        jmp interrupt_end_YXA

@play_sfx:                                                              ;$A956
        ;=======================================================================
        ldy # 2                 ; begin with `_aa15`?
_a958:                                                                  ;$A958
        lda _aa13, y
       .bze _a8e8               ; if zero... exit?
        bmi :+

        ldx _aa2f, y
        lda _aa1d, y
        beq _a9ae
        bne _a990

:       lda _aa2f, y                                                    ;$A969
        sta @reg+1              ; modify low-byte, i.e. $d4xx

        lda # $00
        ldx # $06
@reg:   sta SID_VOICE1, x                                               ;$A973
        dex
        bpl @reg

        ldx _aa2f, y
        lda _aa23, y
        sta SID_VOICE1_CTRL, x
        lda _aa26, y
        sta SID_VOICE1_ATKDCY, x
        lda _aa29, y
        sta SID_VOICE1_SUSREL, x

        lda # $00
_a990:                                                                  ;$A990
        clc
        cld                     ;??
        adc _aa20, y
        sta _aa20, y
        pha
        lsr
        lsr
        sta SID_VOICE1_FREQ_HI, x
        pla
        asl
        asl
        asl
        asl
        asl
        asl
        sta SID_VOICE1_FREQ_LO, x
        lda _aa1c
        sta SID_VOICE1_PULSE_HI, x
_a9ae:                                                                  ;$A9AE
        lda _aa13, y
        bmi _a9f1
        tya
        tax
        dec _aa19, x
        bne _a9bd
        inc _aa19, x
_a9bd:                                                                  ;$A9BD
        dec _aa16, x
        beq _a9dc
        lda _aa16, x
        and _aa2c, y
        bne _a9f6
        lda _aa29, y
        sec
        sbc # $10
        sta _aa29, y
        ldx _aa2f, y
        sta SID_VOICE1_SUSREL, x
        jmp _a9f6

_a9dc:                                                                  ;$A9DC
        ldx _aa2f, y
        lda _aa23, y
        and # %11111110
        sta SID_VOICE1_CTRL, x
        lda # $00
        sta _aa13, y
        sta _aa19, y
        beq _a9f6
_a9f1:                                                                  ;$A9F1
        and # %01111111
        sta _aa13, y
_a9f6:                                                                  ;$A9F6
        dey
        bmi _a9fc
        jmp _a958

_a9fc:                                                                  ;$A9FC
        lda _aa1c
        eor # %00000100
        sta _aa1c

interrupt_end_YXA:                                                      ;$AA04
        ;-----------------------------------------------------------------------
       .ply                     ; restore Y
       .plx                     ; restore X

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; the original source code uses the last-set memory layout state
        ; recorded by the central routine for restoring the memory layout
        lda CPU_CONTROL
        and # %11111000
        ora current_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; in elite-harmless the previous memory layout state
        ; has been pushed to the stack
        pla 
.endif  ;///////////////////////////////////////////////////////////////////////
        sta CPU_CONTROL         ; restore the memory map

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================

_aa13:                                                                  ;$AA13
        .byte   $00, $00
_aa15:                                                                  ;$AA15
        .byte   $00
_aa16:                                                                  ;$AA16
        .byte   $00, $00, $00
_aa19:                                                                  ;$AA19
        .byte   $00
_aa1a:                                                                  ;$AA1A
        .byte   $00
_aa1b:                                                                  ;$AA1B
        .byte   $00
_aa1c:                                                                  ;$AA1C
        .byte   $02
_aa1d:                                                                  ;$AA1D
        .byte   $00, $00, $00
_aa20:                                                                  ;$AA20
        .byte   $00, $00, $00
_aa23:                                                                  ;$AA23
        .byte   $00, $00, $00
_aa26:                                                                  ;$AA26
        .byte   $00, $00, $00
_aa29:                                                                  ;$AA29
        .byte   $00, $00, $00
_aa2c:                                                                  ;$AA2C
        .byte   $00, $00, $00
_aa2f:                                                                  ;$AA2F
        .byte   $00, $07, $0e

_aa32:  ; table of SFX?                                                 ;$AA32
        .byte   $72, $70, $74, $77, $73, $68, $60, $f0
        .byte   $30, $fe, $72, $72, $92, $e1, $51, $02
_aa42:                                                                  ;$AA42
        .byte   $14, $0e, $0c, $50, $3f, $05, $18, $80
        .byte   $30, $ff, $10, $10, $70, $40, $0f, $0e
_aa52:                                                                  ;$AA52
        .byte   $45, $48, $d0, $51, $40, $f0, $40, $80
        .byte   $10, $50, $34, $33, $60, $55, $80, $40
_aa62:                                                                  ;$AA62
        .byte   $41, $11, $81, $81, $81, $11, $11, $41
        .byte   $21, $41, $21, $21, $11, $81, $11, $21
_aa72:                                                                  ;$AA72
        .byte   $01, $09, $20, $08, $0c, $00, $63, $18
        .byte   $44, $11, $00, $00, $44, $11, $18, $09
_aa82:                                                                  ;$AA82
        .byte   $d1, $f1, $e5, $fb, $dc, $f0, $f3, $d8
        .byte   $00, $e1, $e1, $f1, $f4, $e3, $b0, $a1
_aa92:                                                                  ;$AA92
        .byte   $fe, $fe, $f3, $ff, $00, $00, $00, $44
        .byte   $00, $55, $fe, $ff, $ef, $77, $7b, $fe
_aaa2:                                                                  ;$AAA2
        .byte   $03, $03, $03, $0f, $0f, $ff, $ff, $1f
        .byte   $ff, $ff, $03, $03, $0f, $ff, $ff, $03


init_mem:                                                               ;$AAB2
;===============================================================================
; clear the main variable space and initialise the interrupts:
; CALL FROM LOADER; this is the first thing called after initialisation
;-------------------------------------------------------------------------------
.export init_mem
.import __VARS_MAIN_RUN__       ; runtime location
.import __VARS_MAIN_SIZE__      ; and length

        lda #> __VARS_MAIN_RUN__
        sta ZP_TEMP_ADDR_HI

        ; number of whole pages to copy
        ldx #< .page_count( __VARS_MAIN_SIZE__ )

        lda #< __VARS_MAIN_RUN__
        sta ZP_TEMP_ADDR_LO
        tay                     ;=0

:       sta [ZP_TEMP_ADDR], y                                           ;$AABD
        iny
        bne :-

        inc ZP_TEMP_ADDR_HI     ; move to the next page
        dex
        bne :-

        ;-----------------------------------------------------------------------
        ; set non-maskable interrupt location when the KERNAL is on.
        ; pressing the RESTORE key will fire this routine
        ;
        ; note that when the KERNAL is switched off, the RAM underneath will
        ; define the NMI interrupt address -- this gets rectified further down
        ;
        lda #< nmi_null
        sta KERNAL_VECTOR_NMI+0
        lda #> nmi_null
        sta KERNAL_VECTOR_NMI+1

        ; set new `KERNAL_CHROUT` (print character) routine
        ; -- re-route printing to the bitmap screen
        ;
        lda #< chrout
        sta KERNAL_VECTOR_CHROUT+0
        lda #> chrout
        sta KERNAL_VECTOR_CHROUT+1

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; change the C64's memory layout, turn off the BASIC & KERNAL ROMs
        ; leaving just the I/O registers ($D000...)
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the KERNAL is currently on, so stepping down
        ; once will switch from KERNAL+I/O to I/O only
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        sei                     ; disable interrupts

        ; configure interrupts (regular and non-interruptable)
        ; for system timers A & B -- do not use the TimeOfDay timer
        ;
        lda # CIA::TIMER_A | CIA::TIMER_B
        sta CIA1_INTERRUPT
        sta CIA2_INTERRUPT

        ; configure SID chip
        ;
        lda # 15                ; max volume, filters off
        sta SID_VOLUME_CTRL

        ; begin with the first interrupt split
        ldx # $00
        stx interrupt_split

        ; set the flag for raster interrupts, but note that with CIA1 & 2
        ; interrupts currently enabled, the raster interrupt won't fire
        inx 
        stx VIC_INTERRUPT_CONTROL

        ; the 9th bit (for scanlines 256-312) of the raster line register
        ; is held in the MSB of $D011. in Elite's case our raster-splits
        ; all occur before 256 so this bit just needs to be zero
        lda VIC_SCREEN_CTL1
        and # vic_screen_ctl1::raster_line ^$FF
        sta VIC_SCREEN_CTL1

        ; set the interrupt to occur at line 40.
        ; this is above the top screen border (~50)
        lda # 40
        sta VIC_RASTER

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; switch off the ROMs, leaving 64K of RAM
        lda CPU_CONTROL
        and # %11111000
        ora # C64_MEM::ALL
        sta CPU_CONTROL

        ; record this as the game's
        ; current memory-layout state
        lda # C64_MEM::ALL
        sta current_memory_layout

.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        ;
        ; the I/O shield is currently on so stepping down
        ; once will turn I/O off leaving 64K of RAM
        ;
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; set up the routines for the interrupts:
        ;
        ; NOTE: with the KERNAL ROM off, the hardware vectors at $FFFA...$FFFF
        ;       are now being defined by empty RAM -- we need to set something
        ;       there to prevent crashes when KERNAL ROM is off

        ; non-maskable interrupt:
        lda #< nmi_null
        sta HW_VECTOR_NMI+0
        lda #> nmi_null
        sta HW_VECTOR_NMI+1

        ; regular interrupt:
        lda #> interrupt
        sta HW_VECTOR_IRQ+1
        lda #< interrupt
        sta HW_VECTOR_IRQ+0

        cli                     ; enable interrupts
        rts 

nmi_null:                                                               ;$AB27
;===============================================================================
; a Non-Maskable-Interrupt that does nothing; used to disable the
; RESTORE key and to prevent crashes when the KERNAL ROM is off
;-------------------------------------------------------------------------------
        cli                     ; re-enable interrupts
        rti                     ; "ReTurn from Interrupt"
