; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
.segment        "CODE_A013"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

clip_line:                                              ; BBC: LL145    ;$A013
;===============================================================================
; clip a 16-bit line to the viewport:
;
; given a line with 16-bit co-ordinates X1,Y1 to X2,Y2 this routine finds
; the portion that fits within the viewport and returns the 8-bit co-ords
; otherwise returns carry set if the line is off-screen
;
; in:   ZP_LINE_XX1             X1 (16-bit)
;       ZP_LINE_YY1             Y1 (16-bit)
;       ZP_LINE_XX2             X2 (16-bit)
;       ZP_LINE_YY2             Y2 (16-bit)
;
; out:  carry                   carry clear if line is visible, even partially
;                               carry set if line is wholly outside viewport
;
;       ZP_VAR_XX13             indicates the state of the line:
;                               0   = only end-point is within viewport
;                               71  = only start-point is within viewport
;                               143 = both points are outside the viewport
;
;       LINE_SWAP               indicates if the ends of the line had to be
;                               swapped to face left-to-right; 0=no, $FF=yes
;
;       ZP_LINE_X1              X1 (8-bit)
;       ZP_LINE_Y1              Y1 (8-bit)
;       ZP_LINE_X2              X2 (8-bit)
;       ZP_LINE_Y2              Y2 (8-bit)
;-------------------------------------------------------------------------------
        lda # %00000000         ; clear the flag that indicates
        sta LINE_SWAP           ;  if the line-ends were swapped

        lda ZP_LINE_XX2_HI      ; begin with X2, hi-byte

clip_line_flip:                                         ; BBC: LL147    ;$A01A
        ;-----------------------------------------------------------------------
        ; (this entry point skips resetting of the flip flag)
        ;
        bit ZP_B7               ; check height of the viewport(?)
        bmi @both               ; ?

        ; default return value will be the viewport height, which indicates
        ; start *and* end points being outside the viewport. upon return,
        ; carry clear indicates the line is visible (crosses the viewport)
@end:   ldx # VIEWPORT_HEIGHT-1

        ; is the end point within X|Y 0-255?
        ;
        ora ZP_LINE_YY2_HI      ; combine X2 hi-byte with the Y2 hi-byte
        bne @start              ; skip if end-point is beyond 8-bit range

        ; the end point is at Y 0-255, but could still be outside the viewport
        ; which isn't 256 px high; C64 screen is 200px, and there's the hud
        ;
        cpx ZP_LINE_YY2_LO      ; compare Y2 lo-byte with viewport height
        bcc @start

        ; for now, set the return value as 0;
        ; the end-point is within the screen
        ldx # 0

@start: stx ZP_VAR_XX13         ; set return value momentarily          ;$A02A

        ; is the start point within X|Y 0-255?
        ;
        lda ZP_LINE_XX1_HI      ; combine X1, hi-byte
        ora ZP_LINE_YY1_HI      ;  with Y1, hi-byte
        bne @view               ; skip if start-point is beyond 8-bit range

        ; the start point is at Y 0-255, but could still be outside the viewport
        ; which isn't 256 px high; C64 screen is 200px, and there's the hud
        ;
        lda # VIEWPORT_HEIGHT-1
        cmp ZP_LINE_YY1_LO      ; compare Y1 lo-byte with viewport height
        bcc @view               ; skip onward if end-point is off-screen

        ; the start point is within the viewport;
        ; check against the end-point result
        ;
        lda ZP_VAR_XX13         ; read the previous result for the end-point
        bne @half               ; skip ahead if end-point is outside

        ; we have ascertained that both the start-point and end-point
        ; are within the viewport; ergo the X1,Y1,X2,Y2 co-ords are
        ; already correct for viewport boundaries, we just need to
        ; copy them to the output parameters
        ;
        ; TODO: why not just align the input and output parameters
        ;       so this isn't needed in the first place??
        ;
@both:  lda ZP_LINE_YY1_LO      ; move Y1 lo-byte                       ;$A03C
        sta ZP_LINE_Y1          ;  to XX15+1 (previously X1 hi-byte)
        lda ZP_LINE_XX2_LO      ; move X2 lo-byte
        sta ZP_LINE_X2          ;  to XX15+2 (previously Y1 lo-byte)
        lda ZP_LINE_YY2_LO      ; move Y2 lo-byte
        sta ZP_LINE_Y2          ;  to XX15+3 (previously Y1 hi-byte)

        clc                     ; return carry clear
        rts                     ;  for visible line

        ;-----------------------------------------------------------------------
@novis: sec                     ; return carry set                      ;$A04A
        rts                     ;  for non-visible line

        ;-----------------------------------------------------------------------
        ; when the end-point is outside the viewport but the start point
        ; is inside, we want to return 71 which we can get by dividing
        ; the default return value (143) by 2
        ;
@half:  lsr ZP_VAR_XX13                                                 ;$A04C

        ; fallthrough to clip
        ; the line below
        ;

        ; clip the line to the viewport:                ; BBC: LL145    ;$A04E
        ;=======================================================================
        ; is one of the points inside the viewport? a value of 0 or 71
        ; indicates one or the other points is in-bounds
        ;
@view:  lda ZP_VAR_XX13         ; result from above                     ;$A04E
        bpl @slope              ; <128? skip ahead

        ; both points are off-screen:
        ;-----------------------------------------------------------------------
        ; whilst the start and end of the line are outside the viewport,
        ; the line might still be visible if it *crosses* the viewport
        ;
        ; are both line-points negative?
        ; (outside the screen)
        lda ZP_LINE_XX1_HI      ; combine X1 hi-byte with X2 hi-byte 
        and ZP_LINE_XX2_HI      ;  and if the sign is negative, 
        bmi @novis              ;  return line not visible
        lda ZP_LINE_YY1_HI      ; combine Y1 hi-byte with Y2 hi-byte
        and ZP_LINE_YY2_HI      ;  and if the sign is negative, 
        bmi @novis              ;  return line not visible
 
        ; if both X hi-bytes are positive, then the line cannot
        ; be visible. i.e. if the start and end points are X>255
        ;
        ; when both points are off-screen we need to confirm that one point
        ; is outside one side of the viewport and the other point is outside
        ; the opposite side, therefore crossing the viewport
        ;
        ; lines are limited in size / "closeness" too; any line that extends
        ; more than one additional screen-size outside the viewport is hidden
        ;
        ldx ZP_LINE_XX1_HI      ; X1 hi-byte
        dex                     ; -1 since its guaranteed to be !0
        txa                     ; put aside to compare...
        ldx ZP_LINE_XX2_HI      ; X2 hi-byte
        dex                     ; -1 since its guaranteed to be !0
        stx ZP_VAR_XX12_2       ; put aside to compare...

        ora ZP_VAR_XX12_2       ; combine X1 & X2 signs
        bpl @novis              ; if *both* are positive, line is not visible

        ; if both Y hi-bytes are positive, then the line cannot be visible
        ; i.e. if the start and end points are Y > viewport-height
        ;
        lda ZP_LINE_YY1_LO      ; below the viewport height? (144)
        cmp # VIEWPORT_HEIGHT
        lda ZP_LINE_YY1_HI      ; likewise, subtract 1 (carry)
        sbc # 0                 ;  to normalise above/below screens
        sta ZP_VAR_XX12_2       ; put aside to compare

        lda ZP_LINE_YY2_LO      ; repeat with end-point
        cmp # VIEWPORT_HEIGHT
        lda ZP_LINE_YY2_HI      ; subtract 1 (carry)
        sbc # 0                 ;  to normalise above/below screens
        ora ZP_VAR_XX12_2       ; combine YY1 & YY2 hi-bytes
        bpl @novis              ; if *both* are positive, line is not visible 

        ; at this point, we've determined that the line does indeed cross
        ; the viewport, even if the start+end points lie outside of it
        ;

        ; calculate line gradient:
        ;-----------------------------------------------------------------------
@slope:.phy                     ; preserve Y            ; BBC: LL145    ;$A081

        ; we need to get the slope / gradient of the line:
        ; calculate first X2 - X1 (16-bits)
        ;
        lda ZP_LINE_XX2_LO      ; X2 lo-byte
        sec 
        sbc ZP_LINE_XX1_LO      ; subtact X1 lo-byte
        sta ZP_DELTA_XX_LO      ; store as delta-X, lo-byte
        lda ZP_LINE_XX2_HI      ; repeat for hi-byte
        sbc ZP_LINE_XX1_HI      ; (rippling the borrow)
        sta ZP_DELTA_XX_HI      ; store as delta-X, hi-byte

        ; calculate Y2 - Y1 (16-bits)
        ;
        lda ZP_LINE_YY2_LO      ; Y2 lo-byte
        sec 
        sbc ZP_LINE_YY1_LO      ; subtract Y1 lo-byte
        sta ZP_DELTA_YY_LO      ; store as delta-Y, lo-byte
        lda ZP_LINE_YY2_HI      ; repeat for hi-byte
        sbc ZP_LINE_YY1_HI      ; (rippling the borrow)
        sta ZP_DELTA_YY_HI      ; store as delta-Y, hi-byte

        ; work out the direction of the slope, either downwards (positive),
        ; or upwards (negative) by XORing together the delta-X & delta-Y signs:
        ;
        ;       bit 7 clear = top-left to bottom-right direction
        ;       bit 7 set   = bottom-left to top-right direction
        ;
        eor ZP_DELTA_XX_HI      ; "now kiss"
        sta S                   ; store slope sign for much later

        lda ZP_DELTA_YY_HI      ; check delta-Y sign
        bpl @flipx              ; skip ahead for positive

        ; delta-Y is negative, i.e. the end point is further up the screen
        ; than the start point; convert this to a positive number instead:
        ; calculate 0 - delta-Y to negate the number
        ;
@flipy: lda # $00               
        sec 
        sbc ZP_DELTA_YY_LO
        sta ZP_DELTA_YY_LO

        lda # $00
        sbc ZP_DELTA_YY_HI
        sta ZP_DELTA_YY_HI

@flipx: lda ZP_DELTA_XX_HI                                              ;$A0B2
        bpl @delta

        ; delta-X is negative, i.e. the start and end-points are crossed;
        ; calculate 0 - delta-X to make the number positive
        ;
        sec 
        lda # $00
        sbc ZP_DELTA_XX_LO
        sta ZP_DELTA_XX_LO

        lda # $00
        sbc ZP_DELTA_XX_HI

        ; reduce delta to 8-bit range:
        ;-----------------------------------------------------------------------
@delta: tax                     ; has delta-X hi-byte reached zero?     ;$A0C1
        bne @div2               ; if not, divide both deltas by 2

        ldx ZP_DELTA_YY_HI      ; has delta-Y hi-byte reached zero?
        beq @horv               ; if yes, we can stop

@div2:  lsr                     ; divide delta-X hi-byte                ;$A0C8
        ror ZP_DELTA_X          ;  and ripple to lo-byte
        lsr ZP_DELTA_YY_HI      ; divide delta-Y hi-byte
        ror ZP_DELTA_Y          ;  and ripple to lo-byte
        jmp @delta              ; recheck

        ;-----------------------------------------------------------------------
@horv:  stx T                   ; (set T=0 by nature of process above)  ;$A0D2

        ; is the line more vertical than it is horizontal?
        ;
        lda ZP_DELTA_X          ; compare delta-X
        cmp ZP_DELTA_Y          ;  to delta-Y
        bcc @vert

        sta Q
        lda ZP_DELTA_Y
        jsr math_divide_AQ      ; divide delta-Y by delta-X

        jmp @a0ef

        ;-----------------------------------------------------------------------
@vert:  lda ZP_DELTA_Y          ; use delta-Y                           ;$A0E4
        sta Q                   ;  for later calculation

        lda ZP_DELTA_X
        jsr math_divide_AQ      ; divide delta-X by delta-Y

        dec T                   ; underflow T to $FF

        ; clip start, end, or both points:
        ;-----------------------------------------------------------------------
@a0ef:  lda R                   ; store the resultant slope             ;$A0EF
        sta ZP_LINE_SLOPE       ; (note: alias of ZP_VAR_XX12_2)

        lda S                   ; bit 7 of S is a flag to indicate if
        sta ZP_LINE_DIR         ;  the slope goes downhill (0) or uphill (1)
                                ;  (note: alias of ZP_VAR_XX12_3)

        lda ZP_VAR_XX13         ; check the result of viewport bounds
        beq @left               ; 0: start-point is offscreen
        bpl @right              ; <128, i.e. 71: end-point is off-screen

        ; note that the fallthrough here implies a value of
        ; 143: start-point and end-point are off-screen
        ;
        ; clip start point:
        ;-----------------------------------------------------------------------
@left:  jsr clip_point          ; clip start point into viewport        ;$A0FD

        ; check again viewport bounding result; the start point has already
        ; been clipped so now check if the end-point needs clipping too:
        ;
        lda ZP_VAR_XX13         ; a value of zero indicates the end-point
        bpl @ok                 ;  is already in-bounds so exit early

        lda ZP_LINE_XX1_HI      ; sanity check(?) TODO: is this necessary?
        ora ZP_LINE_YY1_HI      ; if X1,Y1 is still out-of-bounds,
        bne @err                ;  then exit

        ; if the start point is less than 256, then check
        ; that it still fits within the viewport height 
        lda ZP_LINE_YY1_LO
        cmp # VIEWPORT_HEIGHT
        bcs @err

        ; clip end point:
        ;-----------------------------------------------------------------------
        ; swap the start and end points of the line simply beacuse
        ; `clip_point` can only operate on X1 & Y1!
        ;
        ; TODO: create a copy of `clip_point` that can operate
        ;       on X2 / Y2? we've saved enough bytes elsewhere
        ;
@right: ldx ZP_LINE_XX1_LO                                              ;$A110
        lda ZP_LINE_XX2_LO
        sta ZP_LINE_XX1_LO
        stx ZP_LINE_XX2_LO

        lda ZP_LINE_XX2_HI
        ldx ZP_LINE_XX1_HI
        stx ZP_LINE_XX2_HI
        sta ZP_LINE_XX1_HI

        ldx ZP_LINE_YY1_LO
        lda ZP_LINE_YY2_LO
        sta ZP_LINE_YY1_LO
        stx ZP_LINE_YY2_LO

        lda ZP_LINE_YY2_HI
        ldx ZP_LINE_YY1_HI
        stx ZP_LINE_YY2_HI
        sta ZP_LINE_YY1_HI

        jsr clip_point          ; clip end point (now start point) to viewport
        dec LINE_SWAP           ; set flag to indicate line points were swapped

@ok:   .ply                     ; (restore Y)                           ;$A136 
        jmp @both               ; set return parameters and exit

        ;-----------------------------------------------------------------------
@err:  .ply                     ; (restore Y)                           ;$A13B 
        sec                     ; indicate line is not visible
        rts                     ;  and return


.segment        "CODE_A19F"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

clip_point:                                             ; BBC: LL118    ;$A19F
;===============================================================================
; move the point X1,Y1 along a given direction /
; slope until it's within the viewport:
;
; the "slope" of the line can be thought of a ratio of how far to move along
; the line before having to move up/down; the units are arbitrary, and when
; drawing lines we use pixels, where the slope describes how many pixels
; along to draw before having to move up/down a pixel
;
; when a point is outside the viewport, we need to work out where the line
; would intersect the edge of the viewport if we followed it. rather than
; iteratively walk down the line we can just treat the distance from the point
; to the viewport as one "unit" and use the slope's ratio to determine what the
; equivalent "unit" amount down is!
;
; this assumes a "horizontal" (or "shallow") line which is wider than it is
; tall but a line can also be "vertical" (or "steep"), this routine doesn't
; deal with this difference but the routines it calls may flip the axis
; internally to normalise the direction and return the equivalent result
;
; in:   ZP_LINE_XX1             point X-position (16-bit)
;       ZP_LINE_YY1             point Y-position (16-bit)
;       ZP_LINE_SLOPE           slope
;       ZP_LINE_DIR             direction of slope, flag:
;                               $00 = vertical slope, $FF = horitzontal slope
;
; out:  ZP_LINE_X1              new X-position (8-bit)
;       ZP_LINE_Y1              new Y-position (8-bit)
;-------------------------------------------------------------------------------
        ; is the X-postion outside the left or right side of the viewport?
        ;
        lda ZP_LINE_XX1_HI      ; hi-byte of X-position
        bpl @right              ; positive? in or off right-side of viewport

        ;-----------------------------------------------------------------------
        ; X1 is outside the left of the viewport; use the distance from the
        ; point back to 0 to calculate the distance Y1 has to be adjusted
        ; for the two to meet:
        ;
        ; TODO: note that only this routine ever calls `deltax_from_slope` &
        ; `deltay_from_slope` meaning we could just bake the parameters
        ; in directly?
        ;
@left:  sta S                   ; put X1 hi-byte into S for the call
        jsr deltay_from_slope   ; calculate the delta-Y given the delta-X

        txa                     ; add the result to Y1:
        clc                     ;
        adc ZP_LINE_YY1_LO      ; add result lo-byte to Y1 lo-byte
        sta ZP_LINE_YY1_LO      ; write back to Y1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_YY1_HI      ; add result hi-byte to Y1 hi-byte
        sta ZP_LINE_YY1_HI      ; write back to Y1 hi-byte
        
        ; because we've calculated the Y-position where the line intersects
        ; the left-edge of the viewport, X1 can now be moved to the first
        ; pixel in the viewport
        ;
        lda # $00               ; set X1 to zero
        sta ZP_LINE_XX1_LO      ;  lo-byte &
        sta ZP_LINE_XX1_HI      ;  hi-byte
        tax                     ; set X-register to zero too, for later

        ; note that we fall through
        ; with A & X set to zero...
        ;

        ;-----------------------------------------------------------------------
        ; if the X-coordinate is already within
        ; the viewport (0-255), skip ahead
        ;
@right: beq @above                                                      ;$A1BA

        ; X1 is outside the right-edge of the viewport; to calculate the
        ; intersection point we need the distance from the right edge of the
        ; viewport to the point which, given the viewport is 256px wide, is
        ; simply X1 - 256
        ;
        sta S                   ; put X1 hi-byte into S for the call    
        dec S                   ; "subtract" 256 by decrementing hi-byte
        jsr deltay_from_slope   ; calculate the delta-Y given the delta-X

        txa                     ; add the result to Y1:
        clc                     ;
        adc ZP_LINE_YY1_LO      ; add result lo-byte to Y1 lo-byte
        sta ZP_LINE_YY1_LO      ; write back to Y1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_YY1_HI      ; add result hi-byte to Y1 hi-byte
        sta ZP_LINE_YY1_HI      ; write back to Y1 hi-byte

        ; because we've calculated the Y-position where the line intersects
        ; the right-edge of the viewport, X1 can now be moved to the last
        ; pixel in the viewport
        ;
        ldx # VIEWPORT_WIDTH-1  ; set X1 to 255
        stx ZP_LINE_XX1_LO      ;  lo-byte
        inx                     ; overflow to $00
        stx ZP_LINE_XX1_HI      ;  set X1 hi-byte to zero

        ;-----------------------------------------------------------------------
        ; even though X1 is now within the viewport's left<->right boundaries,
        ; the point could still be above the screen!
        ;
@above: lda ZP_LINE_YY1_HI      ; check the point's Y-position          ;$A1D5
        bpl @below              ; skip if positive (0, 1 -- in or below)

        ; Y1 is negative, above the viewport
        ;
        sta S                   ; put Y1 hi-byte into S for the call
        lda ZP_LINE_YY1_LO      ; put Y1 lo-byte
        sta R                   ;  into R for the call
        jsr deltax_from_slope   ; calculate the delta-X given the delta-Y

        txa                     ; add the result to X1:
        clc                     ;
        adc ZP_LINE_XX1_LO      ; add result lo-byte to X1 lo-byte
        sta ZP_LINE_XX1_LO      ; write back to X1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_XX1_HI      ; add result hi-byte to X1 hi-byte
        sta ZP_LINE_XX1_HI      ; write back to X1 hi-byte

        ; because we've calculated the X-position where the line intersects
        ; the top-edge of the viewport, Y1 can now be moved to the first
        ; pixel in the viewport
        ;
        lda # $00               ; set Y1 to zero
        sta ZP_LINE_YY1_LO      ;  lo-byte &
        sta ZP_LINE_YY1_HI      ;  hi-byte

        ;-----------------------------------------------------------------------
        ; moving the point to the bottom of the viewport is trickier
        ; because it's neither a 0 or 255 co-ord
        ;
@below: lda ZP_LINE_YY1_LO      ; we subtract 144 (viewport height)     ;$A1F3
        sec                     ;  from the Y-position to get the
        sbc # VIEWPORT_HEIGHT   ;  distance from the bottom of the
        sta R                   ;  viewport to the point, which will
        lda ZP_LINE_YY1_HI      ;  form the one "unit" (delta-Y)
        sbc # $00               ;  needed to calculate the delta-X
        sta S
        bcc :+                  ; skip if Y-position is within the viewport!

        jsr deltax_from_slope   ; calculate the delta-X given the delta-Y

        txa                     ; add the result to X1:
        clc                     ;
        adc ZP_LINE_XX1_LO      ; add result lo-byte to X1 lo-byte
        sta ZP_LINE_XX1_LO      ; write back to X1 lo-byte
        tya                     ; now handle result hi-byte
        adc ZP_LINE_XX1_HI      ; add result hi-byte to X1 hi-byte
        sta ZP_LINE_XX1_HI      ; write back to X1 hi-byte

        ; because we've calculated the X-position where the line intersects
        ; the bottom-edge of the viewport, Y1 can now be moved to the last
        ; pixel in the viewport
        ;
        lda # VIEWPORT_HEIGHT-1 ; set Y1 to viewport height-1
        sta ZP_LINE_YY1_LO      ; lo-byte is last pixel
        lda # $00               ; hi-byte is zero
        sta ZP_LINE_YY1_HI

:       rts                                                             ;$A218


deltay_from_slope:                                      ; BBC: LL120    ;$A219
;===============================================================================
; in:   T                       flag;
;                               $00 = vertical slope
;                               $FF = horitzontal slope
;-------------------------------------------------------------------------------
        lda ZP_LINE_XX1_LO      ; load R with X-position, lo-byte
        sta R

        jsr _a284
        pha 

        ldx T                   ; "vertical" or "horizontal" line?
        bne _a250               ; skip ahead to handle horizontal line

_a225:                                                                  ;$A225
        lda # $00
        tax 
        tay 
        lsr S
        ror R
        asl Q
        bcc _a23a
_a231:                                                                  ;$A231
        txa 
        clc 
        adc R
        tax 
        tya 
        adc S
        tay 
_a23a:                                                                  ;$A23A
        lsr S
        ror R
        asl Q
        bcs _a231
        bne _a23a
        pla 
        bpl _a277
        rts 


deltax_from_slope:                                      ; BBC: LL123    ;$A248
;===============================================================================
        jsr _a284
        pha 
        ldx T
        bne _a225

_a250:                                                                  ;$A250
        lda # $ff
        tay 
        asl 
        tax 
_a255:                                                                  ;$A255
        asl R
        rol S
        lda S
        bcs _a261
        cmp Q
        bcc _a26c
_a261:                                                                  ;$A261
        sbc Q
        sta S
        lda R
        sbc # $00
        sta R
        sec 
_a26c:                                                                  ;$A26C
        txa 
        rol 
        tax 
        tya 
        rol 
        tay 
        bcs _a255
        pla 
        bmi _a283
_a277:                                                                  ;$A277
        txa 
        eor # %11111111
        adc # $01
        tax 
        tya 
        eor # %11111111
        adc # $00
        tay 

_a283:  rts                                                             ;$A283


_a284:                                                  ; BBC: LL129    ;$A284
;===============================================================================
; in:   ZP_LINE_SLOPE           the line's slope, a single byte value where
;                               $FF = 1.0, $80 = 0.5 and $00 = 0
;       R                       the lo-byte of the point's X or Y position;
;                               that is, `ZP_LINE_XX1_LO` or `ZP_LINE_YY1_LO`
;       S                       the hi-byte of the point's X or Y position;
;                               that is, `ZP_LINE_XX1_HI` or `ZP_LINE_YY1_HI`
;-------------------------------------------------------------------------------
        ldx ZP_LINE_SLOPE       ; transfer slope to Q
        stx Q                   ;  for the calculation

        lda S                   ; check the position hi-byte
        bpl :+                  ; for positive values, skip ahead

        lda # $00
        sec 
        sbc R
        sta R
        lda S
        pha 

        eor # %11111111
        adc # $00
        sta S

        pla 

:       eor ZP_LINE_DIR         ; flip direction flag                   ;$A29D
        rts 
