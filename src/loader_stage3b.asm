; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; 75e4 a2 16    ldx #$16
; 75e6 a9 00    lda #$00
; 75e8 85 18    sta $18
; 75ea a9 07    lda #$07
; 75ec 85 19    sta $19
; 75ee a9 00    lda #$00
; 75f0 85 1a    sta $1a
; 75f2 a9 40    lda #$40
; 75f4 20 14 78 jsr $7814
; 75f7 78       sei 
; 75f8 a5 01    lda $01
; 75fa 29 f8    and #$f8
; 75fc 09 04    ora #$04
; 75fe 85 01    sta $01
; 7600 a2 29    ldx #$29
; 7602 a9 00    lda #$00
; 7604 85 18    sta $18
; 7606 a9 d0    lda #$d0
; 7608 85 19    sta $19
; 760a a9 00    lda #$00
; 760c 85 1a    sta $1a
; 760e a9 56    lda #$56
; 7610 20 14 78 jsr $7814
; 7613 a5 01    lda $01
; 7615 29 f8    and #$f8
; 7617 09 05    ora #$05
; 7619 85 01    sta $01
; 761b ad 02 dd lda $dd02
; 761e 09 03    ora #$03
; 7620 8d 02 dd sta $dd02
; 7623 ad 00 dd lda $dd00
; 7626 29 fc    and #$fc
; 7628 09 02    ora #$02
; 762a 8d 00 dd sta $dd00
; 762d a9 03    lda #$03
; 762f 8d 0d dc sta $dc0d
; 7632 8d 0d dd sta $dd0d
; 7635 a9 81    lda #$81
; 7637 8d 18 d0 sta $d018
; 763a a9 00    lda #$00
; 763c 8d 20 d0 sta $d020
; 763f a9 00    lda #$00
; 7641 8d 21 d0 sta $d021
; 7644 a9 3b    lda #$3b
; 7646 8d 11 d0 sta $d011
; 7649 a9 c0    lda #$c0
; 764b 8d 16 d0 sta $d016
; 764e a9 00    lda #$00
; 7650 8d 15 d0 sta $d015
; 7653 a9 09    lda #$09
; 7655 8d 29 d0 sta $d029
; 7658 a9 0c    lda #$0c
; 765a 8d 2a d0 sta $d02a
; 765d a9 06    lda #$06
; 765f 8d 2b d0 sta $d02b
; 7662 a9 01    lda #$01
; 7664 8d 2c d0 sta $d02c
; 7667 a9 05    lda #$05
; 7669 8d 2d d0 sta $d02d
; 766c a9 09    lda #$09
; 766e 8d 2e d0 sta $d02e
; 7671 a9 08    lda #$08
; 7673 8d 25 d0 sta $d025
; 7676 a9 07    lda #$07
; 7678 8d 26 d0 sta $d026
; 767b a9 00    lda #$00
; 767d 8d 1c d0 sta $d01c
; 7680 a9 ff    lda #$ff
; 7682 8d 17 d0 sta $d017
; 7685 8d 1d d0 sta $d01d
; 7688 a9 00    lda #$00
; 768a 8d 10 d0 sta $d010
; 768d a2 a1    ldx #$a1
; 768f a0 65    ldy #$65
; 7691 8e 00 d0 stx $d000
; 7694 8c 01 d0 sty $d001
; 7697 a9 12    lda #$12
; 7699 a0 0c    ldy #$0c
; 769b 8d 02 d0 sta $d002
; 769e 8c 03 d0 sty $d003
; 76a1 0a       asl a
; 76a2 8d 04 d0 sta $d004
; 76a5 8c 05 d0 sty $d005
; 76a8 0a       asl a
; 76a9 8d 06 d0 sta $d006
; 76ac 8c 07 d0 sty $d007
; 76af 0a       asl a
; 76b0 8d 08 d0 sta $d008
; 76b3 8c 09 d0 sty $d009
; 76b6 a9 0e    lda #$0e
; 76b8 8d 0a d0 sta $d00a
; 76bb 8c 0b d0 sty $d00b
; 76be 0a       asl a
; 76bf 8d 0c d0 sta $d00c
; 76c2 8c 0d d0 sty $d00d
; 76c5 0a       asl a
; 76c6 8d 0e d0 sta $d00e
; 76c9 8c 0f d0 sty $d00f
; 76cc a9 02    lda #$02
; 76ce 8d 1b d0 sta $d01b
; 76d1 a9 00    lda #$00
; 76d3 85 18    sta $18
; 76d5 a8       tay 
; 76d6 a2 40    ldx #$40
; 76d8 86 19    stx $19
; 76da 91 18    sta ($18),y
; 76dc c8       iny 
; 76dd d0 fb    bne $76da
; 76df a6 19    ldx $19
; 76e1 e8       inx 
; 76e2 e0 60    cpx #$60
; 76e4 d0 f2    bne $76d8
; 76e6 a9 10    lda #$10
; 76e8 86 19    stx $19
; 76ea 91 18    sta ($18),y
; 76ec c8       iny 
; 76ed d0 fb    bne $76ea
; 76ef a6 19    ldx $19
; 76f1 e8       inx 
; 76f2 e0 68    cpx #$68
; 76f4 d0 f2    bne $76e8
; 76f6 a9 d0    lda #$d0
; 76f8 85 18    sta $18
; 76fa a9 66    lda #$66
; 76fc 85 19    sta $19
; 76fe a9 3a    lda #$3a
; 7700 85 1a    sta $1a
; 7702 a9 78    lda #$78
; 7704 20 27 78 jsr $7827
; 7707 a9 00    lda #$00
; 7709 85 18    sta $18
; 770b a9 60    lda #$60
; 770d 85 19    sta $19
; 770f a2 19    ldx #$19
; 7711 a9 70    lda #$70
; 7713 a0 24    ldy #$24
; 7715 91 18    sta ($18),y
; 7717 a0 03    ldy #$03
; 7719 91 18    sta ($18),y
; 771b 88       dey 
; 771c a9 00    lda #$00
; 771e 91 18    sta ($18),y
; 7720 88       dey 
; 7721 10 fb    bpl $771e
; 7723 a0 25    ldy #$25
; 7725 91 18    sta ($18),y
; 7727 c8       iny 
; 7728 91 18    sta ($18),y
; 772a c8       iny 
; 772b 91 18    sta ($18),y
; 772d a5 18    lda $18
; 772f 18       clc 
; 7730 69 28    adc #$28
; 7732 85 18    sta $18
; 7734 90 02    bcc $7738
; 7736 e6 19    inc $19
; 7738 ca       dex 
; 7739 d0 d6    bne $7711
; 773b a9 00    lda #$00
; 773d 85 18    sta $18
; 773f a9 64    lda #$64
; 7741 85 19    sta $19
; 7743 a2 12    ldx #$12
; 7745 a9 70    lda #$70
; 7747 a0 24    ldy #$24
; 7749 91 18    sta ($18),y
; 774b a0 03    ldy #$03
; 774d 91 18    sta ($18),y
; 774f 88       dey 
; 7750 a9 00    lda #$00
; 7752 91 18    sta ($18),y
; 7754 88       dey 
; 7755 10 fb    bpl $7752
; 7757 a0 25    ldy #$25
; 7759 91 18    sta ($18),y
; 775b c8       iny 
; 775c 91 18    sta ($18),y
; 775e c8       iny 
; 775f 91 18    sta ($18),y
; 7761 a5 18    lda $18
; 7763 18       clc 
; 7764 69 28    adc #$28
; 7766 85 18    sta $18
; 7768 90 02    bcc $776c
; 776a e6 19    inc $19
; 776c ca       dex 
; 776d d0 d6    bne $7745
; 776f a9 70    lda #$70
; 7771 a0 1f    ldy #$1f
; 7773 99 c4 63 sta $63c4,y
; 7776 88       dey 
; 7777 10 fa    bpl $7773
; 7779 a9 00    lda #$00
; 777b 85 18    sta $18
; 777d a8       tay 
; 777e a2 d8    ldx #$d8
; 7780 86 19    stx $19
; 7782 a2 04    ldx #$04
; 7784 91 18    sta ($18),y
; 7786 c8       iny 
; 7787 d0 fb    bne $7784
; 7789 e6 19    inc $19
; 778b ca       dex 
; 778c d0 f6    bne $7784
; 778e a9 d0    lda #$d0
; 7790 85 18    sta $18
; 7792 a9 da    lda #$da
; 7794 85 19    sta $19
; 7796 a9 5a    lda #$5a
; 7798 85 1a    sta $1a
; 779a a9 79    lda #$79
; 779c 20 27 78 jsr $7827
; 779f a0 22    ldy #$22
; 77a1 a9 07    lda #$07
; 77a3 99 02 d8 sta $d802,y
; 77a6 88       dey 
; 77a7 d0 fa    bne $77a3
; 77a9 a9 a0    lda #$a0
; 77ab 8d f8 63 sta $63f8
; 77ae 8d f8 67 sta $67f8
; 77b1 a9 a4    lda #$a4
; 77b3 8d f9 63 sta $63f9
; 77b6 8d f9 67 sta $67f9
; 77b9 a9 a5    lda #$a5
; 77bb 8d fa 63 sta $63fa
; 77be 8d fa 67 sta $67fa
; 77c1 8d fc 63 sta $63fc
; 77c4 8d fc 67 sta $67fc
; 77c7 8d fe 63 sta $63fe
; 77ca 8d fe 67 sta $67fe
; 77cd a9 a6    lda #$a6
; 77cf 8d fb 63 sta $63fb
; 77d2 8d fb 67 sta $67fb
; 77d5 8d fd 63 sta $63fd
; 77d8 8d fd 67 sta $67fd
; 77db 8d ff 63 sta $63ff
; 77de 8d ff 67 sta $67ff
; 77e1 a5 01    lda $01
; 77e3 29 f8    and #$f8
; 77e5 09 06    ora #$06
; 77e7 85 01    sta $01
; 77e9 58       cli 
; 77ea a2 09    ldx #$09
; 77ec a9 90    lda #$90
; 77ee 85 18    sta $18
; 77f0 a9 ef    lda #$ef
; 77f2 85 19    sta $19
; 77f4 a9 7a    lda #$7a
; 77f6 85 1a    sta $1a
; 77f8 a9 7d    lda #$7d
; 77fa 20 14 78 jsr $7814
; 77fd a0 00    ldy #$00
; 77ff b9 7a 7a lda $7a7a,y
; 7802 99 00 68 sta $6800,y
; 7805 88       dey 
; 7806 d0 f7    bne $77ff
; 7808 b9 7a 7b lda $7b7a,y
; 780b 99 00 69 sta $6900,y
; 780e 88       dey 
; 780f d0 f7    bne $7808
; 7811 4c 0e ce jmp $ce0e
; 7814 85 1b    sta $1b
; 7816 a0 00    ldy #$00
; 7818 b1 1a    lda ($1a),y
; 781a 91 18    sta ($18),y
; 781c 88       dey 
; 781d d0 f9    bne $7818
; 781f e6 1b    inc $1b
; 7821 e6 19    inc $19
; 7823 ca       dex 
; 7824 d0 f2    bne $7818
; 7826 60       rts 
; 7827 a2 01    ldx #$01
; 7829 20 14 78 jsr $7814
; 782c a0 17    ldy #$17
; 782e a2 01    ldx #$01
; 7830 b1 1a    lda ($1a),y
; 7832 91 18    sta ($18),y
; 7834 88       dey 
; 7835 10 f9    bpl $7830
; 7837 a2 00    ldx #$00
; 7839 60       rts 
