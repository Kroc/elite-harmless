; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "code_keyboard.inc":
;
; pieces of code relating to reading the hardware keyboard:
; (not key processing, which is handled throughout the code)
;
; the C64 keyboard is an extremely simple piece of hardware; it has no
; "intelligence" to speak of, being literally a long series of PCB traces
; that connect CIA1's two ports together via a loop around the columns and rows
; of the keyboard. a key-press just joins the circuit together, activating the
; combined row/column line between the two ports -- there's no hardware buffer,
; no "keyboard controller", just a simple loop like the first ever light-bulb
; circuit you would have made in school
; 
;                        [$DC01] B < PORTS > A [$DC00]
;                                  +-------+
;             .----( row-0 )---- 0 |       | 0 ----( col-0 )----.
;             ¦----( row-1 )---- 1 | CIA-1 | 1 ----( col-1 )----¦
;             ¦----( row-2 )---- 2 | $DCxx | 2 ----( col-2 )----¦
;             ¦----( row-3 )---- 3 |       | 3 ----( col-3 )----¦
;             ¦----( row-4 )---- 4 |       | 4 ----( col-4 )----¦
;             ¦----( row-5 )---- 5 |       | 5 ----( col-5 )----¦
;             ¦----( row-6 )---- 6 |       | 6 ----( col-6 )----¦
;             ¦----( row-7 )---- 7 |       | 7 ----( col-7 )----¦
;             |                    +-------+                    |
;             |                                                 |
;             '-------------------( 8 lanes )-------------------'
;
; for the full details on the keyboard hardware,
; I'd recommend the following article:
;
; "How the C64 Keyboard Works" by Gregory Nacu
; <http://www.c64os.com/post?p=45>
;
; this extreme simplicity in hardware however does not translate to simplicty
; in software. whilst this comment header will describe everything needed to
; understand Elite's keyboard code, a great more detail about the software
; side can be grokked from the following article:
;
; "Three-Key Rollover for the C-128 and C-64" by Craig Bruce
; <http://www.ffd2.com/fridge/chacking/c=hacking6.txt>
;



; the C64 keyboard is laid out as a matrix of rows & columns. writing to CIA1
; port A ($DC00) sets which row(s) to select where bits 0-7 represent rows 0-7
; and a bit-value of 0 means selected and 1 is ignored. reading from the port
; returns the key-states[*] for the selected row(s).
;
; reads and writes to port B ($DC01) select columns in the same fashion.
;
; [*] note that the read byte uses a bit value of 0 to mean pressed
;     and 1 to represent unpressed (i.e the key grounds a voltage level)
;
; PORT: B  BIT 7 |  BIT 6 |  BIT 5 |  BIT 4 |  BIT 3 |  BIT 2 |  BIT 1 |  BIT 0
;     A +--------¦--------¦--------¦--------¦--------¦--------¦--------¦--------
; BIT 0 | DOWN   | F5     | F3     | F1     | F7     | RIGHT  | RETURN | DELETE
; BIT 1 | LSHIFT | e      | s      | z      | 4      | a      | w      | 3 
; BIT 2 | x      | t      | f      | c      | 6      | d      | r      | 5
; BIT 3 | v      | u      | h      | b      | 8      | g      | y      | 7
; BIT 4 | n      | o      | k      | m      | 0      | j      | i      | 9
; BIT 5 | ,      | @      | :      | .      | -      | l      | p      | +
; BIT 6 | /      | ^      | =      | RSHIFT | HOME   | ;      | *      | £ 
; BIT 7 | STOP   | q      | C=     | SPACE  | 2      | CTRL   | <-     | 1
;
; this chart adapted from:
; <http://codebase64.org/doku.php?id=base:reading_the_keyboard> 
;
.define .key_index( key_addr ) (key_addr - key_states)

.macro  .key_states
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; keyboard keys:
;
; map semantic names to the desired key-state memory locations.
; this lets you very easily remap controls for compile time
;
joy_up                  := key_s
joy_down                := key_x
joy_left                := key_comma
joy_right               := key_dot
joy_fire                := key_a
key_accelerate          := key_spc 
key_decelerate          := key_slash
key_missile_target      := key_t
key_missile_disarm      := key_u
key_missile_fire        := key_m
key_bomb                := key_c64
key_ecm                 := key_e
key_escape_pod          := key_back
key_docking_on          := key_c
key_docking_off         := key_p
key_jump                := key_j        ; quick-jump
key_hyperspace          := key_h        ; hyperspace jump
key_buy_cargo           := key_1        ; buy cargo screen
key_sell_cargo          := key_2        ; sell cargo screen
key_buy_equipment       := key_3        ; buy equipment screen
key_chart_galactic      := key_4        ; galactic chart
key_chart_local         := key_5        ; local (short-range) chart
key_planet              := key_6        ; planetary information
key_market              := key_7        ; market prices screen
key_status              := key_8        ; status screen
key_inventory           := key_9        ; inventory screen
key_view_front          := key_f1
key_view_rear           := key_f3
key_view_left           := key_f5
key_view_right          := key_f7

; an array of key states to indicate which keys are pressed; the byte values
; written out here are meaningless, this array is cleared with $00 when in use
; and an entry is changed to $FF when that key is pressed
;
; the order of keys represented here is determined by the method used to read
; off the keyboard matrix, which is starting at the 64th index in this table
; and working backwards -- for each row 0 to 7, columns are read from 0 to 7.
; this gives a key order of:
;
; addr                  N/A     index   notes                   addr (original)
;-------------------------------------------------------------------------------
key_states:     .byte   '1'     ;=$00 - (unsued)                        ;$8D0C
;-------------------------------------------------------------------------------
; row 7
;
key_stop:       .byte   '2'     ;=$01 - STOP                            ;$8D0D
key_q:          .byte   '3'     ;=$02 - Q                               ;$8D0E
key_c64:        .byte   '4'     ;=$03 - C=    (energy bomb)             ;$8D0F
key_spc:        .byte   '5'     ;=$04 - SPACE (accelerate)              ;$8D10
key_2:          .byte   '6'     ;=$05 - 2                               ;$8D11
key_ctrl:       .byte   '7'     ;=$06 - CTRL                            ;$8D12
key_back:       .byte   '8'     ;=$07 - <-    (escape pod)              ;$8D13
key_1:          .byte   '9'     ;=$08 - 1                               ;$8D14
;-------------------------------------------------------------------------------
; row 6
;
key_slash:      .byte   'a'     ;=$09 - /     (decelerate)              ;$8D15
key_pow:        .byte   'b'     ;=$0A - ^                               ;$8D16
key_equ:        .byte   'c'     ;=$0B - =                               ;$8D17
key_rshft:      .byte   'd'     ;=$0C - RSHIFT                          ;$8D18
key_home:       .byte   'e'     ;=$0D - HOME                            ;$8D19
key_semi:       .byte   'f'     ;=$0E - ;                               ;$8D1A
key_star:       .byte   '0'     ;=$0F - *                               ;$8D1B
key_gbp:        .byte   '1'     ;=$10 - £                               ;$8D1C
;-------------------------------------------------------------------------------
; row 5
;
key_comma:      .byte   '2'     ;=$11 - ,     (roll anti-clockwise)     ;$8D1D
key_at:         .byte   '3'     ;=$12 - @                               ;$8D1E
key_colon:      .byte   '4'     ;=$13 - :                               ;$8D1F
key_dot:        .byte   '5'     ;=$14 - .     (roll clockwise)          ;$8D20
key_dash:       .byte   '6'     ;=$15 - -                               ;$8D21
key_l:          .byte   '7'     ;=$16 - L                               ;$8D22
key_p:          .byte   '8'     ;=$17 - P     (docking computer off)    ;$8D23
key_plus:       .byte   '9'     ;=$18 - +                               ;$8D24
;-------------------------------------------------------------------------------
; row 4
;
key_n:          .byte   'a'     ;=$19 - N                               ;$8D25
key_o:          .byte   'b'     ;=$1A - O                               ;$8D26
key_k:          .byte   'c'     ;=$1B - K                               ;$8D27
key_m:          .byte   'd'     ;=$1C - M     (fire missile)            ;$8D28
key_0:          .byte   'e'     ;=$1D - 0                               ;$8D29
key_j:          .byte   'f'     ;=$1E - J     (quick-jump)              ;$8D2A
key_i:          .byte   '0'     ;=$1F - I                               ;$8D2B
key_9:          .byte   '1'     ;=$20 - 9                               ;$8D2C
;-------------------------------------------------------------------------------
; row 3
;
key_v:          .byte   '2'     ;=$21 - V                               ;$8D2D
key_u:          .byte   '3'     ;=$22 - U     (untarget missile)        ;$8D2E
key_h:          .byte   '4'     ;=$23 - H     (hyperspace)              ;$8D2F
key_b:          .byte   '5'     ;=$24 - B                               ;$8D30
key_8:          .byte   '6'     ;=$25 - 8                               ;$8D31
key_g:          .byte   '7'     ;=$26 - G                               ;$8D32
key_y:          .byte   '8'     ;=$27 - Y                               ;$8D33
key_7:          .byte   '9'     ;=$28 - 7                               ;$8D34
;-------------------------------------------------------------------------------
; row 2
;
key_x:          .byte   'a'     ;=$29 - X     (climb)                   ;$8D35
key_t:          .byte   'b'     ;=$2A - T     (target missile)          ;$8D36
key_f:          .byte   'c'     ;=$2B - F                               ;$8D37
key_c:          .byte   'd'     ;=$2C - C     (docking computer on)     ;$8D38
key_6:          .byte   'e'     ;=$2D - 6                               ;$8D39
key_d:          .byte   'f'     ;=$2E - D                               ;$8D3A
key_r:          .byte   '0'     ;=$2F - R                               ;$8D3B
key_5:          .byte   '1'     ;=$30 - 5                               ;$8D3C
;-------------------------------------------------------------------------------
; row 1
;
key_lshft:      .byte   '2'     ;=$31 - LSHIFT                          ;$8D3D
key_e:          .byte   '3'     ;=$32 - E     (ECM)                     ;$8D3E
key_s:          .byte   '4'     ;=$33 - S     (dive)                    ;$8D3F
key_z:          .byte   '5'     ;=$34 - Z                               ;$8D40
key_4:          .byte   '6'     ;=$35 - 4                               ;$8D41
key_a:          .byte   '7'     ;=$36 - A     (fire)                    ;$8D42
key_w:          .byte   '8'     ;=$37 - W                               ;$8D43
key_3:          .byte   '9'     ;=$38 - 3                               ;$8D44
;------------------------------------------------------------------------------
; row 0
;
key_down:       .byte   'a'     ;=$39 - DOWN                            ;$8D45
key_f5:         .byte   'b'     ;=$3A - F5    (starboard view)          ;$8D46
key_f3:         .byte   'c'     ;=$3B - F3    (aft view)                ;$8D47
key_f1:         .byte   'd'     ;=$3C - F1    (front view)              ;$8D48
key_f7:         .byte   'e'     ;=$3D - F7    (portside view)           ;$8D49
key_right:      .byte   'f'     ;=$3E - RIGHT                           ;$8D4A
key_return:     .byte   '0'     ;=$3F - RETURN                          ;$8D4B
key_del:        .byte   '1'     ;=$40 - DELETE                          ;$8D4C

; the C64 keyboard matrix can only address 64 keys (RESTORE is attached to NMI)
; so these extra bytes may be oversight or extra key states taken from the BBC
;
; TODO: expand keyboard reading for the 128 keyboard?
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
                .byte   '2'                                             ;$8D4D
                .byte   '3'                                             ;$8D4E
                .byte   '4'                                             ;$8D4F
                .byte   '5'                                             ;$8D50
                .byte   '6'                                             ;$8D51
                .byte   '7'                                             ;$8D52
.endif  ;///////////////////////////////////////////////////////////////////////

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .get_input
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
get_input:                                                              ;$8D53
;===============================================================================
; read joystick & keyboard input:
;
; out:  A       index of key pressed
;       X       copy of above
;       Y       (preserved)
;-------------------------------------------------------------------------------
       .phy                     ; preserve Y

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; enable the I/O shield
        lda # C64_MEM::IO_ONLY
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        inc CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

        ; hide sprite 1: why?
        lda VIC_SPRITE_ENABLE
        and # %11111101
        sta VIC_SPRITE_ENABLE

        ; clear the current keyboard state
        ; (sets all key-states to 0)
        jsr clear_keyboard

        ; read joystick?
        ;-----------------------------------------------------------------------
        ldx _1d0c               ; joystick control enabled?
       .bze :+

        lda CIA1_PORTA
        and # %00011111         ; check only first 5 bits (joystick port 2)
        eor # %00011111         ; flip so ON = 1 instead
       .bnz @joy                ; anything pressed?

        ; read keyboard:
        ;-----------------------------------------------------------------------
        ; are ANY keys pressed? by enabling all lines on the keyboard matrix,
        ; any keys pressed will light up at least one of the lines even though
        ; we won't be able to effectively read key presses in this state 
        ;
:       clc                                                             ;$8D73
        ldx # %00000000         ; enable all lines on CIA1's ports
        sei                     ; disable interrupts before writing to CIA1
        stx CIA1_PORTA          ; select all keyboard rows for reading ($00)
        ldx CIA1_PORTB          ; read the keyboard matrix
        cli                     ; enable interrupts
        
        ; if no keys were pressed, X will be $FF (bits are 1 for unpressed!)
        ; and incrementing X will roll it over to 0
        inx 
       .bze @done               ; no keys pressed at all? skip ahead

        ; having determined that at least one key is pressed, we begin looping
        ; through the keyboard matrix row by row to read individual keys
        ;
        ldx # 64                ; number of keys to scan
        lda # %11111110         ; select keyboard row 0 for initial reading

@row:   sei                     ; disable interrupts                    ;$8D85
        sta CIA1_PORTA          ; select keyboard row to read
        pha                     ; store the current row mask for later

        ldy # 8                 ; initialise column counter

        ; wait for the keyboard scan to happen
        ; (this provides the "debounce")
        ;
:       lda CIA1_PORTB          ; read the keyboard column state        ;$8D8C
        cmp CIA1_PORTB          ; has the state changed?
       .bnz :-                  ; no, wait until the state has changed

        ; A will now hold a bitmap of each key in the row,
        ; where 1 = unpressed and 0 = pressed

        cli                     ; enable interrupts again
        
@col:   ; read keys from each column                                    ;$8D95
        ; in the captured row:
        ;
        lsr                     ; check the next key from the column
        bcs :+                  ; no key pressed? skip ahead
                                ; (note that 1 = unpressed, so carry will set)
        
        ; key is pressed:
        ;
        dec key_states, x       ; %0000000 -> %1111111
        stx ZP_7D               ; remember currently pressed key
        sec 

:       dex                     ; move along to the next key-state      ;$8D9E
        bmi :+                  ; if all keys are done, skip ahead
                                ; (X will roll-under to 255, bit 7 is "minus")
        
        dey                     ; next column 
       .bnz @col
        
        pla                     ; retrieve the CIA keyboard row value 
        rol                     ; move to the next row pattern
       .bnz @row                ; if all rows done, fall through

:       pla                     ; level the stack off                   ;$8DA8
        sec                     ;?

@done:  lda # %01111111         ; select keyboard row 7                 ;$8DAA
        sta CIA1_PORTA
        bne @exit               ; always triggers

        ; handle joystick:
        ;-----------------------------------------------------------------------
@joy:   ; joystick up:                                                  ;$8DB1
        lsr                     ; push bit 0 off
        bcc :+                  ; unpressed? skip ahead
        stx joy_up              ; set up-direction pressed flag

:       ; joystick down:                                                ;$8DB7
        lsr                     ; push bit 1 off
        bcc :+                  ; unpressed? skip ahead
        stx joy_down            ; set down-direction pressed flag

:       ; joystick left:                                                ;$8DBD
        lsr                     ; push bit 2 off
        bcc :+                  ; unpressed? skip ahead
        stx joy_left            ; set left-direction pressed flag

:       ; joystick right:                                               ;$8DC3
        lsr                     ; push bit 3 off 
        bcc :+                  ; unpressed? skip ahead
        stx joy_right           ; set right-direction pressed flag

:       ; fire button                                                   ;$8DC9
        lsr                     ; push bit 4 off 
        bcc :+                  ; unpressed? skip ahead
        stx joy_fire            ; set fire-button pressed flag

:       ; flip vertical axis?                                           ;$8DCF
        lda opt_flipvert
       .bze :+

        lda joy_down
        ldx joy_up
        sta joy_up
        stx joy_down

:       ; flip both axises?                                             ;$8DE0
        lda opt_flipaxis
       .bze @exit

        lda joy_down
        ldx joy_up
        sta joy_up
        stx joy_down
        lda joy_left
        ldx joy_right
        sta joy_right
        stx joy_left

        ;-----------------------------------------------------------------------

@exit:  lda ZP_SCREEN           ; which screen page are we looking at?  ;$8DFD
       .bze :+                  ; if cockpit-view, skip 
        
        ; for non cockpit-view pages, do not
        ; allow these key-states to persist?
        lda # $00
        sta key_bomb
        sta key_escape_pod
        sta key_missile_target
        sta key_missile_disarm
        sta key_missile_fire
        sta key_ecm
        sta key_jump
        sta key_docking_on
        sta key_docking_off

:                                                                       ;$8E1E

.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; turn the I/O shield off and
        ; return to 'game' memory layout
        lda # C64_MEM::ALL
        jsr set_memory_layout
.else   ;///////////////////////////////////////////////////////////////////////
        ; optimisation for changing the memory map,
        ; with thanks to: <http://www.c64os.com/post?p=83>
        dec CPU_CONTROL
.endif  ;///////////////////////////////////////////////////////////////////////

       .ply                     ; restore Y
        
        lda ZP_7D               ; return currently-pressed key in A...
        tax                     ; ...and X

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro

.macro  .clear_keyboard
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
clear_keyboard:                                                         ;$8C6D
;===============================================================================
; clear the keyboard state table:
;-------------------------------------------------------------------------------
        ldx # 64                ; number of keys on keyboard to scan
        lda # $00
        sta ZP_7D               ; set currently pressed key to nothing

:       sta key_states, x       ; reset the current key-state           ;$8C73
        dex                     ; move to next key 
        bpl :-                  ; keep going until all 64 are done

        rts 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.endmacro