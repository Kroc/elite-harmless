; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;
; "math_data.asm":
; 
; lookup tables for math routines. these are segments, therefore create output
; and cannot be included multiple times by other files, which is why the math
; routines are in separate files

.segment        "TABLE_SIN"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; table: sin(x/32*pi)*256
;
table_sin:                                                              ;$0AC0

        .byte   $00, $19, $32, $4a, $62, $79, $8e, $a2                  ;$0AC0
        .byte   $b5, $c6, $d5, $e2, $ed, $f5, $fb, $ff
        .byte   $ff, $ff, $fb, $f5, $ed, $e2, $d5, $c6                  ;$0AD0
        .byte   $b5, $a2, $8e, $79, $62, $4a, $32, $19
_0ae0:                                                                  ;$0AE0

        .byte   $00, $01, $03, $04, $05, $06, $08, $09                  ;$0AE0
        .byte   $0a, $0b, $0c, $0d, $0f, $10, $11, $12
        .byte   $13, $14, $15, $16, $17, $18, $19, $19                  ;$0AF0
        .byte   $1a, $1b, $1c, $1d, $1d, $1e, $1f, $1f


.ifdef  FEATURE_MATHTABLES
;///////////////////////////////////////////////////////////////////////////////
.segment        "TABLE_SQR"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.align          $0100

; Table generation: I:0..511
;       square1_lo = <((I*I)/4)
;       square1_hi = >((I*I)/4)
;       square2_lo = <(((I-255)*(I-255))/4)
;       square2_hi = >(((I-255)*(I-255))/4)

square1_lo:
;-------------------------------------------------------------------------------
.ifdef  FEATURE_MATHTABLES_ROM
        ;///////////////////////////////////////////////////////////////////////
        .repeat 512, i
                .byte <((i * i) / 4)
        .endrepeat
.else   ;///////////////////////////////////////////////////////////////////////
        .res    512
.endif  ;///////////////////////////////////////////////////////////////////////

square1_hi:
;-------------------------------------------------------------------------------
.ifdef  FEATURE_MATHTABLES_ROM
        ;///////////////////////////////////////////////////////////////////////
        .repeat 512, i
                .byte >((i * i) / 4)
        .endrepeat
.else   ;///////////////////////////////////////////////////////////////////////
        .res    512
.endif  ;///////////////////////////////////////////////////////////////////////

square2_lo:
;-------------------------------------------------------------------------------
.ifdef  FEATURE_MATHTABLES_ROM
        ;///////////////////////////////////////////////////////////////////////
        .repeat 512, i
                .byte <(((i-255) * (i-255)) / 4)
        .endrepeat
.else   ;///////////////////////////////////////////////////////////////////////
        .res    512
.endif  ;///////////////////////////////////////////////////////////////////////

square2_hi:
;-------------------------------------------------------------------------------
.ifdef  FEATURE_MATHTABLES_ROM
        ;///////////////////////////////////////////////////////////////////////
        .repeat 512, i
                .byte >(((i-255) * (i-255)) / 4)
        .endrepeat
.else   ;///////////////////////////////////////////////////////////////////////
        .res    512
.endif  ;///////////////////////////////////////////////////////////////////////

; http://codebase64.org/doku.php?id=base:table_generator_routine_for_fast_8_bit_mul_table
;
.segment        "CODE_INIT"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
populate_multiply_tables:
        ;-----------------------------------------------------------------------
        ldx # $00
        txa 
        .byte   $c9             ; skip TYA and clear carry flag
@lb1:   tya 
        adc # $00
@ml1:   sta square1_hi, x
        tay 
        cmp # $40
        txa 
        ror 
@ml9:   adc # $00
        sta @ml9+1
        inx 
@ml0:   sta square1_lo, x
        bne @lb1
        inc @ml0+2
        inc @ml1+2
        clc 
        iny 
        bne @lb1

        ;-----------------------------------------------------------------------
        ldx # $00
        ldy # $ff
:       lda square1_hi+1, x
        sta square2_hi+$100, x
        lda square1_hi, x
        sta square2_hi, y
        lda square1_lo+1, x
        sta square2_lo+$100, x
        lda square1_lo, x
        sta square2_lo, y
        dey 
        inx 
        bne :-

        rts 

.endif
;///////////////////////////////////////////////////////////////////////////////

.segment        "MATH_LOGS"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.align          $0100
;
; hello and welcome to "I don't understand logarithims 101"
;
; in disassembling Elite, and having no background in math, I have discovered
; how awful math tutorials are. it is only by the grace of lemon64 forum
; member nc513 that I can tell you anything about these lookup tables
;
; what is a log? it's the opposite of exponention -- "to the power of" -- which
; I hope you are familiar with as even if you've never come across logs before,
; exponention is extremely common in any low-level computing such as assembly.
; you'll already be very familiar with the sequence of powers of 2:
; 1, 2, 4, 8, 16, 32, 64, 128 & 256
;
; since we're using an 8-bit computer and powers of 2 are easy for us to use,
; we'll also be using base 2 logs. note that logs can be in any base, but from
; this point onwards any reference to log is going to assume a base of 2
;
; (NOTE: the caret "^" symbol will be used here as the symbol for exponention
;  as it is more commonly known this way, even though the caret is XOR in CA65)
;
; if 2^8 (=256) can be seen as:
;
;       2^8 = 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 = 256
;
; then log answers the question "given a number, what power do we need to raise
; our base [2] to get that number?". i.e.
;
;       log2(256) = 2^? = 8
;
; logs are useful because they can simulate a multiplication using lookup
; tables and addition. a multiplication of X & Y can be reduced to adding
; two logs together and then using exponention to restore the number base
;
; likewise, a division can be done by subtracting the logarithms of two
; numbers end exponentiating the result.
;
; however, given that the input number is not always going to be a square
; number the answer is, more often than not, going to be a fraction, e.g.
;
;       log2(240) = 2^? = 7.906890595608519
;
; if this were a spreadsheet then we'd be using full 4 or 5-byte floating-point
; numbers, but that would be too slow for a game! in DOOM a "16.16" fixed-point
; floating number is used but even this is too much for our lowly 8-bit micro!
; Elite does away with all precision and uses 8-bit integers without fractions
; for its log numbers -- given that the viewport is only 256px wide, this is
; sufficient but it menas that the log tables here have two major drawbacks:
;
; 1. compound use increases the error drastically; that is, the more
;    times a value goes through the log tables the more severe the
;    loss of precision becomes
;
; 2. it's not possible to use these log-tables for typical multiplication.
;    Elite has its own multiplication tables (see "math_data.asm")
;    required to produce correct results
;
; =============================================
; ==  USE OF THE LOGARITHM TABLES IN ELITE:  ==
; =============================================
; _9500 and _9600 together build an exp table for 2^((x*2)/32),
; where _9500 contains all the even entries (thus being a 2^(x/32) table)
; and _9600 contains all the odd entries (thus being a 2^((x+0.5)/32) table)
; table_logdiv is used to determine which of the two exp-tables to use
; to get the most accurate result for a log-table multiplication or division.
; This gives an extra bit of accuracy in log-space, which is direly needed.
;
; whenever a log-addition (A*X) or a log-subtraction (A/X) is done, the same
; operation with the table_logdiv yields a negative value if the _9600-table
; should be used.
;
; ==  OVERFLOW AND UNDERFLOW:  ==
;
; Elite uses log and exp-tables that scale the value internally by a factor
; of 32. this just gives a little extra precision, and  since both the
; log and exp-tables use this factor, they normally cancel each other out:
; exp((log(A)*32 + log(B)*32)/32) = exp((log(A)+log(B)) = A*B
; exp((log(A)*32 - log(B)*32)/32) = exp((log(A)-log(B)) = A/B
; 
; but when an overflow occurs, the 256 overflow difference conviniently turns
; into an 8 bit shift:
; exp((log(A)*32 + log(B)*32 - 256)/32) = exp(log(A)+log(B)-8) = (A*B)/256
; exp((log(A)*32 - log(B)*32 + 256)/32) = exp(log(A)-log(B)+8) = (A/B)*256
;
; so when multiplying two big values (overflow occurs when adding the logs),
; the result of the exp() is the hi-byte of the multiplication.
; and when dividing the lesser of two values by the greater, the subtraction
; of the two logs underflows, and the result is the fraction in 8-bit fixed
; point.
;

table_log:                                                              ;$9300
;===============================================================================
; nc513 says:
; - $9300..$93FF is a lookup table for the function
;   TRUNC(LOG(X;2)*32), except for X=0, X=8, X=64
;
        .byte   $06, $00, $20, $32, $40, $4a, $52, $59                  ;$9300
        .byte   $5f, $65, $6a, $6e, $72, $76, $79, $7d                  ;$9308
        .byte   $80, $82, $85, $87, $8a, $8c, $8e, $90                  ;$9310
        .byte   $92, $94, $96, $98, $99, $9b, $9d, $9e                  ;$9318
        .byte   $a0, $a1, $a2, $a4, $a5, $a6, $a7, $a9                  ;$9320
        .byte   $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1                  ;$9328
        .byte   $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9                  ;$9330
        .byte   $b9, $ba, $bb, $bc, $bd, $bd, $be, $bf                  ;$9338
        .byte   $bf, $c0, $c1, $c2, $c2, $c3, $c4, $c4                  ;$9340
        .byte   $c5, $c6, $c6, $c7, $c7, $c8, $c9, $c9                  ;$9348
        .byte   $ca, $ca, $cb, $cc, $cc, $cd, $cd, $ce                  ;$9350
        .byte   $ce, $cf, $cf, $d0, $d0, $d1, $d1, $d2                  ;$9358
        .byte   $d2, $d3, $d3, $d4, $d4, $d5, $d5, $d5                  ;$9360
        .byte   $d6, $d6, $d7, $d7, $d8, $d8, $d9, $d9                  ;$9368
        .byte   $d9, $da, $da, $db, $db, $db, $dc, $dc                  ;$9370
        .byte   $dd, $dd, $dd, $de, $de, $de, $df, $df                  ;$9378
        .byte   $e0, $e0, $e0, $e1, $e1, $e1, $e2, $e2                  ;$9380
        .byte   $e2, $e3, $e3, $e3, $e4, $e4, $e4, $e5                  ;$9388
        .byte   $e5, $e5, $e6, $e6, $e6, $e7, $e7, $e7                  ;$9390
        .byte   $e7, $e8, $e8, $e8, $e9, $e9, $e9, $ea                  ;$9398
        .byte   $ea, $ea, $ea, $eb, $eb, $eb, $ec, $ec                  ;$93A0
        .byte   $ec, $ec, $ed, $ed, $ed, $ed, $ee, $ee                  ;$93A8
        .byte   $ee, $ee, $ef, $ef, $ef, $ef, $f0, $f0                  ;$93B0
        .byte   $f0, $f1, $f1, $f1, $f1, $f1, $f2, $f2                  ;$93B8
        .byte   $f2, $f2, $f3, $f3, $f3, $f3, $f4, $f4                  ;$93C0
        .byte   $f4, $f4, $f5, $f5, $f5, $f5, $f5, $f6                  ;$93C8
        .byte   $f6, $f6, $f6, $f7, $f7, $f7, $f7, $f7                  ;$93D0
        .byte   $f8, $f8, $f8, $f8, $f9, $f9, $f9, $f9                  ;$93D8
        .byte   $f9, $fa, $fa, $fa, $fa, $fa, $fb, $fb                  ;$93E0
        .byte   $fb, $fb, $fb, $fc, $fc, $fc, $fc, $fc                  ;$93E8
        .byte   $fd, $fd, $fd, $fd, $fd, $fd, $fe, $fe                  ;$93F0
        .byte   $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff                  ;$93F8

table_logdiv:                                                           ;$9400
;===============================================================================
; nc513 says:
; - $9400..94FF is a lookup table for the function
;   TRUNC(256*(LOG(X;2)*32-TRUNC(LOG(X;2)*32))),
;   except for X=0, X=8, X=64
;
        .byte   $ae, $00, $00, $b8, $00, $4d, $b8, $d5                  ;$9400
        .byte   $ff, $70, $4d, $b3, $b8, $6a, $d5, $05                  ;$9408
        .byte   $00, $cc, $70, $ef, $4d, $8d, $b3, $c1                  ;$9410
        .byte   $b8, $9a, $6a, $28, $d5, $74, $05, $88                  ;$9418
        .byte   $00, $6b, $cc, $23, $70, $b3, $ef, $22                  ;$9420
        .byte   $4d, $71, $8d, $a3, $b3, $bd, $c1, $bf                  ;$9428
        .byte   $b8, $ab, $9a, $84, $6a, $4b, $28, $00                  ;$9430
        .byte   $d5, $a7, $74, $3e, $05, $c8, $88, $45                  ;$9438
        .byte   $ff, $b7, $6b, $1d, $cc, $79, $23, $ca                  ;$9440
        .byte   $70, $13, $b3, $52, $ef, $89, $22, $b8                  ;$9448
        .byte   $4d, $e0, $71, $00, $8d, $19, $a3, $2c                  ;$9450
        .byte   $b3, $39, $bd, $3f, $c1, $40, $bf, $3c                  ;$9458
        .byte   $b8, $32, $ab, $23, $9a, $10, $84, $f7                  ;$9460
        .byte   $6a, $db, $4b, $ba, $28, $94, $00, $6b                  ;$9468
        .byte   $d5, $3e, $a7, $0e, $74, $da, $3e, $a2                  ;$9470
        .byte   $05, $67, $c8, $29, $88, $e7, $45, $a3                  ;$9478
        .byte   $00, $5b, $b7, $11, $6b, $c4, $1d, $75                  ;$9480
        .byte   $cc, $23, $79, $ce, $23, $77, $ca, $1d                  ;$9488
        .byte   $70, $c1, $13, $63, $b3, $03, $52, $a1                  ;$9490
        .byte   $ef, $3c, $89, $d6, $22, $6d, $b8, $03                  ;$9498
        .byte   $4d, $96, $e0, $28, $71, $b8, $00, $47                  ;$94A0
        .byte   $8d, $d4, $19, $5f, $a3, $e8, $2c, $70                  ;$94A8
        .byte   $b3, $f6, $39, $7b, $bd, $fe, $3f, $80                  ;$94B0
        .byte   $c1, $01, $40, $80, $bf, $fd, $3c, $7a                  ;$94B8
        .byte   $b8, $f5, $32, $6f, $ab, $e7, $23, $5f                  ;$94C0
        .byte   $9a, $d5, $10, $4a, $84, $be, $f7, $31                  ;$94C8
        .byte   $6a, $a2, $db, $13, $4b, $82, $ba, $f1                  ;$94D0
        .byte   $28, $5e, $94, $cb, $00, $36, $6b, $a0                  ;$94D8
        .byte   $d5, $0a, $3e, $73, $a7, $da, $0e, $41                  ;$94E0
        .byte   $74, $a7, $da, $0c, $3e, $70, $a2, $d3                  ;$94E8
        .byte   $05, $36, $67, $98, $c8, $f8, $29, $59                  ;$94F0
        .byte   $88, $b8, $e7, $16, $45, $74, $a3, $d1                  ;$94F8

_9500:                                                                  ;$9500
;===============================================================================
; nc513 says:
; - $9500..$95FF is a lookup table for the function TRUNC(2^(X/32))
;
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9500
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9508
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9510
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9518
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9520
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9528
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9530
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9538
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9540
        .byte   $04, $04, $04, $05, $05, $05, $05, $05                  ;$9548
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9550
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9558
        .byte   $08, $08, $08, $08, $08, $08, $09, $09                  ;$9560
        .byte   $09, $09, $09, $0a, $0a, $0a, $0a, $0b                  ;$9568
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0c, $0d                  ;$9570
        .byte   $0d, $0d, $0e, $0e, $0e, $0e, $0f, $0f                  ;$9578
        .byte   $10, $10, $10, $11, $11, $11, $12, $12                  ;$9580
        .byte   $13, $13, $13, $14, $14, $15, $15, $16                  ;$9588
        .byte   $16, $17, $17, $18, $18, $19, $19, $1a                  ;$9590
        .byte   $1a, $1b, $1c, $1c, $1d, $1d, $1e, $1f                  ;$9598
        .byte   $20, $20, $21, $22, $22, $23, $24, $25                  ;$95A0
        .byte   $26, $26, $27, $28, $29, $2a, $2b, $2c                  ;$95A8
        .byte   $2d, $2e, $2f, $30, $31, $32, $33, $34                  ;$95B0
        .byte   $35, $36, $38, $39, $3a, $3b, $3d, $3e                  ;$95B8
        .byte   $40, $41, $42, $44, $45, $47, $48, $4a                  ;$95C0
        .byte   $4c, $4d, $4f, $51, $52, $54, $56, $58                  ;$95C8
        .byte   $5a, $5c, $5e, $60, $62, $64, $67, $69                  ;$95D0
        .byte   $6b, $6d, $70, $72, $75, $77, $7a, $7d                  ;$95D8
        .byte   $80, $82, $85, $88, $8b, $8e, $91, $94                  ;$95E0
        .byte   $98, $9b, $9e, $a2, $a5, $a9, $ad, $b1                  ;$95E8
        .byte   $b5, $b8, $bd, $c1, $c5, $c9, $ce, $d2                  ;$95F0
        .byte   $d7, $db, $e0, $e5, $ea, $ef, $f5, $fa                  ;$95F8

_9600:                                                                  ;$9600
;===============================================================================
; nc513 says:
; - $9600..96FF seems to follow the pattern of
;   TRUNC(2^((X/32)+(1/64))) just perfectly
;
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9600
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9608
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9610
        .byte   $01, $01, $01, $01, $01, $01, $01, $01                  ;$9618
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9620
        .byte   $02, $02, $02, $02, $02, $02, $02, $02                  ;$9628
        .byte   $02, $02, $02, $03, $03, $03, $03, $03                  ;$9630
        .byte   $03, $03, $03, $03, $03, $03, $03, $03                  ;$9638
        .byte   $04, $04, $04, $04, $04, $04, $04, $04                  ;$9640
        .byte   $04, $04, $05, $05, $05, $05, $05, $05                  ;$9648
        .byte   $05, $05, $05, $06, $06, $06, $06, $06                  ;$9650
        .byte   $06, $06, $07, $07, $07, $07, $07, $07                  ;$9658
        .byte   $08, $08, $08, $08, $08, $09, $09, $09                  ;$9660
        .byte   $09, $09, $0a, $0a, $0a, $0a, $0a, $0b                  ;$9668
        .byte   $0b, $0b, $0b, $0c, $0c, $0c, $0d, $0d                  ;$9670
        .byte   $0d, $0d, $0e, $0e, $0e, $0f, $0f, $0f                  ;$9678
        .byte   $10, $10, $10, $11, $11, $12, $12, $12                  ;$9680
        .byte   $13, $13, $14, $14, $14, $15, $15, $16                  ;$9688
        .byte   $16, $17, $17, $18, $18, $19, $1a, $1a                  ;$9690
        .byte   $1b, $1b, $1c, $1d, $1d, $1e, $1e, $1f                  ;$9698
        .byte   $20, $21, $21, $22, $23, $24, $24, $25                  ;$96A0
        .byte   $26, $27, $28, $29, $29, $2a, $2b, $2c                  ;$96A8
        .byte   $2d, $2e, $2f, $30, $31, $32, $34, $35                  ;$96B0
        .byte   $36, $37, $38, $3a, $3b, $3c, $3d, $3f                  ;$96B8
        .byte   $40, $42, $43, $45, $46, $48, $49, $4b                  ;$96C0
        .byte   $4c, $4e, $50, $52, $53, $55, $57, $59                  ;$96C8
        .byte   $5b, $5d, $5f, $61, $63, $65, $68, $6a                  ;$96D0
        .byte   $6c, $6f, $71, $74, $76, $79, $7b, $7e                  ;$96D8
        .byte   $81, $84, $87, $8a, $8d, $90, $93, $96                  ;$96E0
        .byte   $99, $9d, $a0, $a4, $a7, $ab, $af, $b3                  ;$96E8
        .byte   $b6, $ba, $bf, $c3, $c7, $cb, $d0, $d4                  ;$96F0
        .byte   $d9, $de, $e3, $e8, $ed, $f2, $f7, $fd                  ;$96F8


.segment        "LINE_DATA"
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; a buffer of line-points is built up so line-drawing can be done continuously.
; in the original game, these two buffers (one for X-coords, one for Y-coords)
; are filled with junk data (stuff left over in the C64 RAM when the game was
; assembled) and occupy space in the disk-file. for elite-harmless we make
; these buffers blocks of reserved RAM that do not exist in the disk-file
;
; TODO: this understanding is incorrect!
;       something else is happening here
;
line_points_x:                                                          ;$26A4
;-------------------------------------------------------------------------------
; RAM used for X-coords for line-drawing
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is junk code/data left in memory
        ; in this unitialised table
        ;
        .byte   $76, $85, $9c, $a5, $8b, $85, $9a, $a5
        .byte   $8d, $20, $0c, $9a, $b0, $d2, $85, $6f
        .byte   $a5, $9c, $85, $70, $a5, $6b, $85, $9b
        .byte   $a5, $72, $85, $9c, $a5, $85, $85, $9a
        .byte   $a5, $87, $20, $0c, $9a, $b0, $b9, $85
        .byte   $6b, $a5, $9c, $85, $6c, $a5, $6d, $85
        .byte   $9b, $a5, $74, $85, $9c, $a5, $88, $85
        .byte   $9a, $a5, $8a, $20, $0c, $9a, $b0, $a0
        .byte   $85, $6d, $a5, $9c, $85, $6e, $a5, $71
        .byte   $85, $9a, $a5, $6b, $20, $ea, $39, $85
        .byte   $bb, $a5, $72, $45, $6c, $85, $9c, $a5
        .byte   $73, $85, $9a, $a5, $6d, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $74
        .byte   $45, $6e, $20, $0c, $9a, $85, $bb, $a5
        .byte   $75, $85, $9a, $a5, $6f, $20, $ea, $39
        .byte   $85, $9a, $a5, $bb, $85, $9b, $a5, $70
        .byte   $45, $76, $20, $0c, $9a, $48, $98, $4a
        .byte   $4a, $aa, $68, $24, $9c, $30, $02, $a9
        .byte   $00, $95, $35, $c8, $c4, $ae, $b0, $fe
        .byte   $4c, $f2, $9b, $a4, $47, $a6, $48, $a5
        .byte   $4b, $85, $47, $a5, $4c, $85, $48, $84
        .byte   $4b, $86, $4c, $a4, $49, $a6, $4a, $a5
        .byte   $51, $85, $49, $a5, $52, $85, $4a, $84
        .byte   $51, $86, $52, $a4, $4f, $a6, $50, $a5
        .byte   $53, $85, $4f, $a5, $54, $85, $50, $84
        .byte   $53, $86, $54, $a0, $08, $b1, $57, $85
        .byte   $ae, $a5, $57, $18, $69, $14, $85, $5b
        .byte   $a5, $58, $69, $00, $85, $5c, $a0, $00
        .byte   $84, $aa, $84, $9f, $b1, $5b, $85, $6b
        .byte   $c8, $b1, $5b, $85, $6d, $c8, $b1, $5b
        .byte   $85, $6f, $c8, $b1, $5b, $85, $bb, $29
        .byte   $1f, $c5, $ad, $90, $fb, $c8, $b1, $5b
.else   ;///////////////////////////////////////////////////////////////////////
        .res    256
.endif  ;///////////////////////////////////////////////////////////////////////


line_points_y:                                                          ;$27A4
;-------------------------------------------------------------------------------
; RAM used for X-coords for line-drawing
;
.ifdef  OPTION_ORIGINAL
        ;///////////////////////////////////////////////////////////////////////
        ; this is junk code/data left in memory
        ; in this unitialised table
        ;
        .byte   $85, $2e, $29, $0f, $aa, $b5, $35, $d0
        .byte   $fe, $a5, $2e, $4a, $4a, $4a, $4a, $aa
        .byte   $b5, $35, $d0, $fe, $c8, $b1, $5b, $85
        .byte   $2e, $29, $0f, $aa, $b5, $35, $d0, $fe
        .byte   $a5, $2e, $4a, $4a, $4a, $4a, $aa, $b5
        .byte   $35, $d0, $fe, $4c, $8e, $9d, $a5, $bb
        .byte   $85, $6c, $0a, $85, $6e, $0a, $85, $70
        .byte   $20, $2c, $9a, $a5, $0b, $85, $6d, $45
        .byte   $72, $30, $fe, $18, $a5, $71, $65, $09
        .byte   $85, $6b, $a5, $0a, $69, $00, $85, $6c
        .byte   $4c, $b3, $9d, $a5, $09, $38, $e5, $71
        .byte   $85, $6b, $a5, $0a, $e9, $00, $85, $6c
        .byte   $b0, $fe, $49, $ff, $85, $6c, $a9, $01
        .byte   $e5, $6b, $85, $6b, $90, $02, $e6, $6c
        .byte   $a5, $6d, $49, $80, $85, $6d, $a5, $0e
        .byte   $85, $70, $45, $74, $30, $fe, $18, $a5
        .byte   $73, $65, $0c, $85, $6e, $a5, $0d, $69
        .byte   $00, $85, $6f, $4c, $ee, $9d, $a5, $0c
        .byte   $38, $e5, $73, $85, $6e, $a5, $0d, $e9
        .byte   $00, $85, $6f, $b0, $fe, $49, $ff, $85
        .byte   $6f, $a5, $6e, $49, $ff, $69, $01, $85
        .byte   $6e, $a5, $70, $49, $80, $85, $70, $90
        .byte   $fe, $e6, $6f, $a5, $76, $30, $fe, $a5
        .byte   $75, $18, $65, $0f, $85, $bb, $a5, $10
        .byte   $69, $00, $85, $99, $4c, $27, $9e, $a6
        .byte   $9a, $f0, $fe, $a2, $00, $4a, $e8, $c5
        .byte   $9a, $b0, $fa, $86, $9c, $20, $af, $99
        .byte   $a6, $9c, $a5, $9b, $0a, $26, $99, $30
        .byte   $fe, $ca, $d0, $f8, $85, $9b, $60, $a9
        .byte   $32, $85, $9b, $85, $99, $60, $a9, $80
        .byte   $38, $e5, $9b, $9d, $00, $01, $e8, $a9
        .byte   $00, $e5, $99, $9d, $00, $01, $4c, $61
.else   ;///////////////////////////////////////////////////////////////////////
        .res    256
.endif  ;///////////////////////////////////////////////////////////////////////
