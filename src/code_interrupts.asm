; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

; this table contains the state-switches for the raster-splits, that is, what
; properties of the VIC to change at the first split (bitmap line 1), then the
; second split (bitmap line 145), the HUD. for example, the top-border on the
; screen is multi-colour and switches to hires afterwards, then multi-colour
; is reenabled for the HUD
;
_a8d9:                                                                  ;$A8D9
        .byte   $00

; these are `VIC_LAYOUT` states
;-------------------------------------------------------------------------------
_a8da:                                                                  ;$A8DA
        .byte   ELITE_VIC_LAYOUT_MENUSCR
_a8db:                                                                  ;$A8DB
        .byte   ELITE_VIC_LAYOUT_MENUSCR

; this is a toggle for `_a8d9`
_a8dc:                                                                  ;$A8DC
        .byte   $01, $00

; the location of raster-splits:
;-------------------------------------------------------------------------------
_a8de:                                                                  ;$A8DE
        ; top of screen, plus height of viewport
        .byte   51 + ELITE_VIEWPORT_HEIGHT-1
        ; scanline 51, 2nd pixel row in screen
        ; i.e. changes after the yellow border at the top
        .byte   51

; these are `VIC_SCREEN_CTL2` states
_a8e0:                                                                  ;$A8E0
        .byte   %11000000
_a8e1:                                                                  ;$A8E1
        .byte   %11000000

; these are `VIC_SPRITE_MULTICOLOR` states
_a8e2:                                                                  ;$A8E2
        .byte   %11111110, %11111100

; these are `VIC_SPRITE1_COLOR` states
_a8e4:                                                                  ;$A8E4
        .byte   RED, BLACK
_a8e6:                                                                  ;$A8E6
        .byte   $00, $00

; e-bomb explosion?
;
_a8e8:                                                                  ;$A8E8
        ;-----------------------------------------------------------------------
        dey
        bpl _a958
        pla
        tay

interrupt_end_XA:                                                       ;$A8ED
        ;=======================================================================
        ; interrupt finished! restores X & A.
        ;
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
        sta CPU_CONTROL

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"

;===============================================================================
; this is Elite's main interrupt routine
;
interrupt:                                                              ;$A8FA

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

        ldx _a8d9

        ; flicker the VIC memory map!?
        ; the two values are the same, so this does nothing in practice
        ;
        lda _a8da, x
        sta VIC_LAYOUT

        lda _a8e0, x
        sta VIC_SCREEN_CTL2

        lda _a8de, x
        sta VIC_RASTER

        lda _a8e2, x
        sta VIC_SPRITE_MULTICOLOR

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
        sta _a8d9

        ; exit when this is not the last interrupt of this frame
        ; (the interrupt directly before the HUD, so the next index is zero)
        ; everything that follows shall only be don 1x per frame
       .bnz interrupt_end_XA

        ; push Y to stack (via A).
        ; from this point we must restore Y before ending the interrupt,
        ; so a different exit point is used than the one above
       .phy

        bit _1d03               ; if this option,
        bpl _a956               ; is off, skip ahead

.ifndef OPTION_NOSOUND
        ;///////////////////////////////////////////////////////////////////////
        jsr _b4d2               ; handle music?
.endif  ;///////////////////////////////////////////////////////////////////////

        bit _1d12               ; sound effects enabled?
        bmi _a956               ; yes, do SFX

        jmp interrupt_end_YXA

_a956:                                                                  ;$A956
        ldy # $02
_a958:                                                                  ;$A958
        lda _aa13, y
        beq _a8e8
        bmi _a969

        ldx _aa2f, y
        lda _aa1d, y
        beq _a9ae
        bne _a990
_a969:                                                                  ;$A969
        lda _aa2f, y
        sta _a973+1             ;low-byte, i.e. $d4xx
        lda # $00
        ldx # $06
_a973:                                                                  ;$A973
        sta SID_VOICE1, x
        dex
        bpl _a973
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
        cld
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
        sta CPU_CONTROL

        pla                     ; restore A
        rti                     ; "ReTurn from Interrupt"